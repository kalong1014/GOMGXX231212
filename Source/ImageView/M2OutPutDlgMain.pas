unit M2OutPutDlgMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, FileCtrl, Buttons, ComCtrls, M2Wil,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Menus, cxButtons, cxTextEdit, cxGroupBox, cxMaskEdit, cxButtonEdit,
  pngimage, dxSkinsCore, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light;

type
  TuFrmExport = class(TForm)
    RzLabel: TLabel;
    ProgressBar: TProgressBar;
    EditFileDir: TcxButtonEdit;
    cxGroupBox1: TcxGroupBox;
    RzLabel1: TLabel;
    RzLabel2: TLabel;
    EditX: TcxTextEdit;
    EditY: TcxTextEdit;
    BitBtnOK: TcxButton;
    BitBtnClose: TcxButton;
    procedure BitBtnOKClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cxButton2Click(Sender: TObject);
    procedure EditFileDirPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    FWorking: Boolean;
    FImageFile: TWMImages;
  end;

procedure ExportResource(AImageFile: TWMImages; StartIndex, EndIndex: Integer);

implementation

uses DIB;

{$R *.dfm}

procedure DeleteDirectory(const Name: string);
var
  F: TSearchRec;
begin
  if FindFirst(Name + '\*', faAnyFile, F) = 0 then begin
    try
      repeat
        if (F.Attr and faDirectory <> 0) then begin
          if (F.Name <> '.') and (F.Name <> '..') then begin
            DeleteDirectory(Name + '\' + F.Name);
          end;
        end else begin
          DeleteFile(Name + '\' + F.Name);
        end;
      until FindNext(F) <> 0;
    finally
      FindClose(F);
    end;
    RemoveDir(Name);
  end;
end;


procedure ExportResource(AImageFile: TWMImages; StartIndex, EndIndex: Integer);
begin
  with TuFrmExport.Create(nil) do
    try
      FImageFile  :=  AImageFile;
      EditX.Text  := IntToStr(StartIndex);
      EditY.Text  := IntToStr(EndIndex);
      ProgressBar.Position := 0;
      ProgressBar.Max := 100;
      ShowModal;
    finally
      Free;
    end;
end;

procedure SetPoint(FileName: string; Point: TPoint; AGraphicType: TGraphicType);
var
  sFileName: string;
  SaveList: TStringList;
begin
  sFileName := ExtractFilePath(FileName) + 'Placements\';
  if not DirectoryExists(sFileName) then
  begin
    CreateDir(sFileName);
  end;
  sFileName := sFileName + ExtractFileName(FileName) + '.txt';
  SaveList := TStringList.Create;
  SaveList.Add(IntToStr(Point.X));
  SaveList.Add(IntToStr(Point.Y));
  SaveList.Add(IntToStr(Ord(AGraphicType)));
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
end;

procedure TuFrmExport.BitBtnOKClick(Sender: TObject);
var
  nStart, nStop: Integer;
  nW, nH, nIndex, nCount: Integer;
  AGraphicType: TGraphicType;
  sFileName: string;
  sPath: string;
  Pt: TPoint;
  Bitmap: TGraphic;
begin
  if not Assigned(FImageFile) then Exit;
  if FWorking then Exit;
  BitBtnOK.Enabled := False;
  BitBtnClose.Enabled := False;
  FWorking := True;
  try
    nStart := StrToIntDef(EditX.Text, 0);
    nStop := StrToIntDef(EditY.Text, 0);

    sPath := Trim(EditFileDir.Text);
    DeleteDirectory(sPath);
    ForceDirectories(PChar(sPath));
    if (sPath[Length(sPath)] <> '\') then
      sPath := sPath + '\';

    if (nStop >= nStart) and (nStart >= 0) and (nStop < FImageFile.ImageCount) then
    begin
      ProgressBar.Position := 0;
      ProgressBar.Max := nStop - nStart + 1;

      for nIndex := nStart to nStop do
      begin
        Bitmap := FImageFile.Graphics[nIndex];
        Application.ProcessMessages;
        ProgressBar.Position := ProgressBar.Position + 1;

        FImageFile.GetImgSize(nIndex, nW, nH, Pt.X, Pt.Y, AGraphicType);

        if Bitmap <> nil then
        begin
          if Bitmap is TDIB then
          begin
            Try
              sFileName := sPath + Format('%.5d', [nIndex]) + '.BMP';
              SetPoint(sFileName, Pt, AGraphicType);
              Bitmap.SaveToFile(sFileName);
            except

            End;
          end else if Bitmap is TPngImage then
          begin
            Try
              sFileName := sPath + Format('%.5d', [nIndex]) + '.PNG';
              SetPoint(sFileName, Pt, AGraphicType);
              Bitmap.SaveToFile(sFileName);
            except

            End;
          end;


        end
        else
        begin
          Bitmap := TDIB.Create;
          Bitmap.Width := 1;
          Bitmap.Height := 1;
          sFileName := sPath + Format('%.5d', [nIndex]) + '.BMP';
          Bitmap.SaveToFile(sFileName);
          Bitmap.Free;
        end;
      end;
      Application.MessageBox('图片导出成功 ！！！', '提示信息', MB_ICONQUESTION);
      Close;
    end;
  finally
    FWorking := False;
    BitBtnOK.Enabled := True;
    BitBtnClose.Enabled := True;
  end;
end;

procedure TuFrmExport.cxButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TuFrmExport.EditFileDirPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var
  Directory: string;
begin
  if SelectDirectory('浏览文件夹', '', Directory) then
  begin
    EditFileDir.Text := Directory;
  end;
end;

procedure TuFrmExport.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FWorking;
end;

end.
