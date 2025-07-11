unit M2InPutManyDlgMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, FileCtrl, Buttons, ComCtrls, DIB, uTypes,
  HUtil32, M2WIL, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxGroupBox,
  cxMaskEdit, cxButtonEdit, cxRadioGroup, Menus, cxButtons, Math, cxSpinEdit,
  dxSkinsCore, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light;

type
  TLoadBitmapType = (t_BMP, t_BM, t_PT, t_SM);
  TAddBitmapType = (t_Add, t_Insert, t_Replace);

  TuFrmInputMany = class(TForm)
    RzLabel: TLabel;
    ProgressBar: TProgressBar;
    RadioGroup1: TcxRadioGroup;
    EditFileDir: TcxButtonEdit;
    GroupBox2: TcxGroupBox;
    RzLabel1: TLabel;
    RzLabel2: TLabel;
    EditX: TcxTextEdit;
    EditY: TcxTextEdit;
    RadioGroup3: TcxRadioGroup;
    GroupBox4: TcxGroupBox;
    RadioButton1: TcxRadioButton;
    RadioButton2: TcxRadioButton;
    EditXY: TcxTextEdit;
    BitBtnOK: TcxButton;
    BitBtnClose: TcxButton;
    GroupBoxAtt: TGroupBox;
    CheckBoxEmpty1X1: TCheckBox;
    CheckBoxInputEmpty: TCheckBox;
    EditSkipNum: TcxSpinEdit;
    EditAddNum: TcxSpinEdit;
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EditFileDirPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure BitBtnCloseClick(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
    procedure RadioGroup1PropertiesChange(Sender: TObject);
    procedure RadioGroup3PropertiesChange(Sender: TObject);
  private
    FImageFile: TWMImages;
    FWorking: Boolean;
    procedure LoadBitmap(LoadType: TLoadBitmapType; const FileName: string; var Source: TGraphic; var nX, nY: Integer; var AGraphicType: TGraphicType);
    procedure AddBitmap(nIndex, nX, nY: Integer; Source: TDIB; AddType: TAddBitmapType; AGraphicType: TGraphicType);
  end;

procedure ImportResource(AImageFile: TWMImages; StartIndex: Integer);

implementation

var
  StringList: TSortStringList;

procedure ImportResource(AImageFile: TWMImages; StartIndex: Integer);
begin
  with TuFrmInputMany.Create(nil) do
    try
      FImageFile := AImageFile;
      ProgressBar.Position := 0;
      ProgressBar.Max := 100;
      EditX.Text := IntToStr(StartIndex);
      EditY.Text := IntToStr(FImageFile.ImageCount - 1);
      ShowModal;
    finally
      Free;
    end;
end;

{$R *.dfm}

function WidthBytes(w: Integer): Integer;
begin
  Result := (((w * 8) + 31) div 32) * 4;
end;

procedure GetPoint(FileName: string; var APoint: TPoint; var AGraphicType: TGraphicType);
var
  AFileName: string;
  AList: TStringList;
  AX, AY: Integer;
begin
  APoint := Point(0, 0);
  AFileName := ExtractFilePath(FileName) + 'Placements\' + ExtractFileName(FileName) + '.txt';
  if not FileExists(AFileName) then
  begin
    AFileName := ExtractFilePath(FileName) + 'Placements\' + ExtractFileName(FileName);
    AFileName := SysUtils.ChangeFileExt(AFileName, '.txt');
  end;
  if FileExists(AFileName) then
  begin
    AList := TStringList.Create;
    try
      AList.LoadFromFile(AFileName);
      AX := 0;
      AY := 0;
      if AList.Count > 0 then
        AX := StrToIntDef(AList.Strings[0], 0);
      if AList.Count > 1 then
        AY := StrToIntDef(AList.Strings[1], 0);
      APoint := Point(AX, AY);
      if AGraphicType <> gtRealPng then
      begin
        if AList.Count > 2 then
          AGraphicType := TGraphicType(StrToIntDef(AList.Strings[2], 0));
      end;
    finally
      AList.Free;
    end;
  end;
end;

function DoSearchFile(const Path: string; Files: TStrings): Boolean;
var
  Info: TSearchRec;
  s01: string;

  function IsDir: Boolean;
  begin
    with Info do
      Result := (Name <> '.') and (Name <> '..') and ((Attr and faDirectory) = faDirectory);
  end;

  function IsFile: Boolean;
  begin
    Result := (not((Info.Attr and faDirectory) = faDirectory)) and ((CompareText(ExtractFileExt(Info.Name), '.bmp') = 0) or (CompareText(ExtractFileExt(Info.Name), '.png')=0));
  end;

begin
  try
    Result := False;
    if FindFirst(Path + '*.*', faAnyFile, Info) = 0 then
    begin
      while True do
      begin
        if IsFile then
        begin
          s01 := Path + Info.Name;
          Files.Add(s01);
        end;
        Application.ProcessMessages;
        if FindNext(Info) <> 0 then
          Break;
      end;
    end;
    Result := True;
  finally
    FindClose(Info);
  end;
end;

procedure TuFrmInputMany.LoadBitmap(LoadType: TLoadBitmapType; const FileName: string; var Source: TGraphic; var nX, nY: Integer; var AGraphicType: TGraphicType);
var
  Pt: TPoint;
begin
  Source := nil;
  case LoadType of
    t_BMP:
    begin
      Source := LoadDIBFromFile(FileName, AGraphicType);
      if RadioButton1.Checked then
      begin
        GetPoint(FileName, Pt, AGraphicType);
        nX := Pt.X;
        nY := Pt.Y;
      end;
    end;
    t_BM:
    begin
      Source := LoadDIBFromFile(FileName, AGraphicType);
    end;
    t_PT:
    begin
      AGraphicType := TGraphicType.gtDIB;
      if RadioButton1.Checked then
      begin
        GetPoint(FileName, Pt, AGraphicType);
        nX := Pt.X;
        nY := Pt.Y;
      end;
    end;
    t_SM:
    begin
    end;
  end;
end;

procedure TuFrmInputMany.AddBitmap(nIndex, nX, nY: Integer; Source: TDIB; AddType: TAddBitmapType; AGraphicType: TGraphicType);
begin
  case AddType of
    t_Add:
      FImageFile.Add(Source, nX, nY, AGraphicType);
    t_Insert:
      FImageFile.Insert(nIndex, Source, nX, nY, AGraphicType);
    t_Replace:
      FImageFile.Replace(nIndex, Source, nX, nY, AGraphicType);
  end;
end;


function QuickFileNameSort(List: TStringList; Index1, Index2: Integer): Integer;
var
  AIndex1Name, AIndex2Name: String;
begin
  AIndex1Name := List[Index1];
  AIndex2Name := List[Index2];
  AIndex1Name := ExtractFileName(AIndex1Name);
  AIndex1Name := SysUtils.ChangeFileExt(AIndex1Name, '');
  AIndex2Name := ExtractFileName(AIndex2Name);
  AIndex2Name := SysUtils.ChangeFileExt(AIndex2Name, '');
  Result := StrToIntDef(AIndex1Name, 0) - StrToIntDef(AIndex2Name, 0);
end;

procedure TuFrmInputMany.BitBtnOKClick(Sender: TObject);
var
  I: Integer;
  sPath: string;
  nDefX, nDefY, nX, nY: Integer;
  sXY: string;
  sX: string;
  sY: string;
  nBIndex: Integer;
  nEIndex: Integer;
  nCount: Integer;
  Source: TGraphic;
  AddBitmapType: TAddBitmapType;
  ALoadBitmapType: TLoadBitmapType;
  AGraphicType: TGraphicType;
  nSkip, nAddNum, J: Integer;
begin
  if FWorking or (FImageFile = nil) then
    Exit;

  FWorking := True;
  BitBtnOK.Enabled := False;
  BitBtnClose.Enabled := False;
  try
    AddBitmapType := TAddBitmapType(RadioGroup3.ItemIndex);
    ALoadBitmapType := TLoadBitmapType(RadioGroup1.ItemIndex);
    nBIndex := StrToIntDef(EditX.Text, 0);
    nEIndex := StrToIntDef(EditY.Text, 0);
    nBIndex := Min(nBIndex, FImageFile.ImageCount - 1);
    nBIndex := Min(nBIndex, nEIndex);
    if RadioButton2.Checked then
    begin
      sXY := Trim(EditXY.Text);
      sXY := GetValidStr3(sXY, sX, [',']);
      sXY := GetValidStr3(sXY, sY, [',']);
      nDefX := Str_ToInt(sX, 0);
      nDefY := Str_ToInt(sY, 0);
    end
    else
    begin
      nDefX := 0;
      nDefY := 0;
    end;

    if ALoadBitmapType = t_SM then
    begin
      if AddBitmapType = t_Replace then
      begin
        nEIndex := Min(nEIndex, FImageFile.ImageCount - 1);
        nBIndex := Min(nBIndex, nEIndex);
      end;
      ProgressBar.Max := nEIndex - nBIndex;
      FImageFile.BeginUpdate;
      try
        for I := nBIndex to nEIndex do
        begin
          ProgressBar.Position := ProgressBar.Position + 1;
          nX := nDefX;
          nY := nDefY;
          case AddBitmapType of
            t_Add: FImageFile.Add(nil, nX, nY, gtDIB);
            t_Insert: FImageFile.Insert(I, nil, nX, nY, gtDIB);
            t_Replace: FImageFile.Replace(I, nil, nX, nY, gtDIB);
          end;
        end;
      finally
        FImageFile.EndUpdate;
      end;
    end
    else
    begin
      sPath := EditFileDir.Text;
      if sPath <> '' then
        sPath := sPath + '\';
      if (sPath[Length(sPath)] <> '\') then
        sPath := sPath + '\';

      StringList.Clear;
      DoSearchFile(sPath, StringList);
      StringList.CustomSort(QuickFileNameSort);

      nCount := StringList.Count;
      if AddBitmapType = t_Replace then
      begin
        nEIndex := _MIN(nBIndex + (StringList.Count - 1), FImageFile.ImageCount - 1);
        nCount := _MIN(nEIndex - nBIndex + 1, StringList.Count);
        nCount := _MIN(nCount, FImageFile.ImageCount);
        if nBIndex > nEIndex then
        begin
          nBIndex := nEIndex;
          nCount := 1;
        end;
      end;

      ProgressBar.Position := 0;
      ProgressBar.Max := nCount;

      if StringList.Count > 0 then
      begin
        nSkip := EditSkipNum.Value;
        nAddNum := EditAddNum.Value;
        FImageFile.BeginUpdate;
        for I := 0 to nCount - 1 do
        begin
          Application.ProcessMessages;
          ProgressBar.Position := ProgressBar.Position + 1;
          nX := nDefX;
          nY := nDefY;
          LoadBitmap(ALoadBitmapType, StringList.Strings[I], Source, nX, nY, AGraphicType);
          if CheckBoxEmpty1X1.Checked then
          begin
            if (Source <> nil) and (Source.Width = 1) and (Source.Height = 1) {and (Source.Pixels[0, 0] = 0)} then
            begin
              FreeAndNil(Source);
            end;
          end;
          if (Source <> nil) and (Source is TDIB) then
            TDIB(Source).Mirror(False, True);
          case AddBitmapType of
            t_Add:
              FImageFile.Add(Source, nX, nY, AGraphicType);
            t_Insert:
              begin
                FImageFile.Insert(nBIndex, Source, nX, nY, AGraphicType);
                Inc(nBIndex);
              end;
            t_Replace:
              begin
                FImageFile.Replace(nBIndex, Source, nX, nY, AGraphicType);
                Inc(nBIndex);
              end;
          end;
          if Source <> nil then
            Source.Free;
          if CheckBoxInputEmpty.Checked and (AddBitmapType = t_Add) and (nSkip > 0) and (nAddNum > 0) then
          begin
            if (I + 1) mod nSkip = 0 then
            begin
              for J := 1 to nAddNum do
              begin
                FImageFile.Add(nil, 0, 0, gtDIB);
              end;
            end;
          end;
        end;
        FImageFile.EndUpdate;
      end;
    end;
  finally
    BitBtnOK.Enabled := True;
    BitBtnClose.Enabled := True;
    FWorking := False;
  end;
  Application.MessageBox('图片导入成功 ！！！', '提示信息', MB_ICONQUESTION);
  Close;
end;

procedure TuFrmInputMany.BitBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TuFrmInputMany.EditFileDirPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  Directory: string;
begin
  if SelectDirectory('浏览文件夹', '', Directory) then
  begin
    EditFileDir.Text := Directory;
  end;
end;

procedure TuFrmInputMany.RadioGroup1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    0:
      begin
        EditFileDir.Enabled := True;
        RadioGroup3.Enabled := True;
        GroupBox4.Enabled := True;
        RzLabel.Caption := '图片位置:';
      end;
    1:
      begin
        EditFileDir.Enabled := True;
        RadioGroup3.Enabled := True;
        GroupBox4.Enabled := False;
        RzLabel.Caption := '图片位置:';
      end;
    2:
      begin
        EditFileDir.Enabled := True;
        GroupBox4.Enabled := True;
        RadioGroup3.ItemIndex := 2;
        RadioGroup3.Enabled := False;
        RzLabel.Caption := '坐标位置:';
      end;
    3:
      begin
        EditFileDir.Enabled := False;
        RadioGroup3.Enabled := True;
        GroupBox4.Enabled := False;
        RzLabel.Caption := '图片位置:';
      end;
  end;
end;

procedure TuFrmInputMany.RadioGroup1PropertiesChange(Sender: TObject);
begin
  RadioButton1.Enabled := True;
  RadioButton2.Enabled := True;
  RadioButton1.Checked := True;
  EditFileDir.Enabled := True;
  CheckBoxInputEmpty.Enabled := False;
  EditSkipNum.Enabled := False;
  EditAddNum.Enabled := False;
  case TLoadBitmapType(RadioGroup1.ItemIndex) of
    t_SM:
    begin
      EditFileDir.Enabled := False;
      RadioButton1.Enabled := False;
      RadioButton2.Checked := True;
    end;
  end;
  case TAddBitmapType(RadioGroup3.ItemIndex) of
    t_Add:
    begin
      CheckBoxInputEmpty.Enabled := True;
      EditSkipNum.Enabled := True;
      EditAddNum.Enabled := True;
    end;
    else
    begin
      CheckBoxInputEmpty.Enabled := False;
      EditSkipNum.Enabled := False;
      EditAddNum.Enabled := False;
    end;
  end;
end;

procedure TuFrmInputMany.RadioGroup3Click(Sender: TObject);
begin
  case RadioGroup3.ItemIndex of
    0:
      begin
        GroupBox2.Enabled := False;
        { EditX.Enabled := True;
          EditY.Enabled := True; }
      end;
    1:
      begin
        GroupBox2.Enabled := True;
        EditX.Enabled := True;
        EditY.Enabled := False;
      end;
    2:
      begin
        GroupBox2.Enabled := True;
        EditX.Enabled := True;
        EditY.Enabled := True;
      end;
  end;
end;

procedure TuFrmInputMany.RadioGroup3PropertiesChange(Sender: TObject);
begin
  case TAddBitmapType(RadioGroup3.ItemIndex) of
    t_Add:
    begin
      CheckBoxInputEmpty.Enabled := True;
      EditSkipNum.Enabled := True;
      EditAddNum.Enabled := True;
    end;
    else
    begin
      CheckBoxInputEmpty.Enabled := False;
      EditSkipNum.Enabled := False;
      EditAddNum.Enabled := False;
    end;
  end;
end;

procedure TuFrmInputMany.FormCreate(Sender: TObject);
begin
  RadioGroup1.ItemIndex := 0;
  RadioGroup3.ItemIndex := 0;
  StringList := TSortStringList.Create;
end;

procedure TuFrmInputMany.FormDestroy(Sender: TObject);
begin
  StringList.Free;
end;

procedure TuFrmInputMany.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FWorking;
end;

end.
