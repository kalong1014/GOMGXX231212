unit M2DelImages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, Buttons, ComCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Menus, cxButtons,
  cxGroupBox, cxRadioGroup, cxTextEdit, M2Wil, dxSkinsCore,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light;

type
  TuFrmDelImages = class(TForm)
    ProgressBar: TProgressBar;
    cxGroupBox1: TcxGroupBox;
    EditX: TcxTextEdit;
    EditY: TcxTextEdit;
    RadioGroup: TcxRadioGroup;
    RzLabel1: TLabel;
    RzLabel2: TLabel;
    BitBtnOK: TcxButton;
    BitBtnClose: TcxButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BitBtnCloseClick(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FWorking: Boolean;
    FImageFile: TWMImages;
  public
  end;

procedure DeleteImages(AImageFile: TWMImages; StartIndex, EndIndex: Integer);

implementation

{$R *.dfm}

procedure DeleteImages(AImageFile: TWMImages; StartIndex, EndIndex: Integer);
begin
  with TuFrmDelImages.Create(nil) do
    try
      FImageFile  :=  AImageFile;
      ProgressBar.Position := 0;
      ProgressBar.Max := 100;
      EditX.Text := IntToStr(StartIndex);
      EditY.Text := IntToStr(EndIndex);
      ShowModal;
    finally
      Free;
    end;
end;

procedure TuFrmDelImages.BitBtnOKClick(Sender: TObject);
var
  nBIndex, nEIndex: Integer;
begin
  if not Assigned(FImageFile) then Exit;
  if FWorking then
    Exit;
  FWorking := True;
  BitBtnOK.Enabled := False;
  BitBtnClose.Enabled := False;
  try
    nBIndex := StrToIntDef(EditX.Text, 0);
    nEIndex := StrToIntDef(EditY.Text, 0);

    if nBIndex < 0 then
      nBIndex := 0;
    if nEIndex > FImageFile.ImageCount - 1 then
      nEIndex := FImageFile.ImageCount - 1;
    if nBIndex > FImageFile.ImageCount - 1 then
      nBIndex := FImageFile.ImageCount - 1;
    if nBIndex > nEIndex then
      nBIndex := nEIndex;

    if RadioGroup.ItemIndex = 0 then
    begin
      if (nEIndex >= nBIndex) and (nBIndex >= 0) and (nEIndex < FImageFile.ImageCount) then
      begin
        FImageFile.BeginUpdate;
        if FImageFile.Delete(nBIndex, nEIndex) then
        begin
          FImageFile.EndUpdate;
          Application.MessageBox('图片删除成功 ！！！', '提示信息', MB_ICONQUESTION);
        end
        else
          Application.MessageBox('图片删除失败 ！！！', '提示信息', MB_ICONQUESTION);
      end;
    end
    else
    begin
      if (nEIndex >= nBIndex) and (nBIndex >= 0) and (nEIndex < FImageFile.ImageCount) then
      begin
        FImageFile.BeginUpdate;
        if FImageFile.Fill(nBIndex, nEIndex) then
        begin
          FImageFile.EndUpdate;
          Application.MessageBox('图片删除成功 ！！！', '提示信息', MB_ICONQUESTION);
        end
        else
          Application.MessageBox('图片删除失败 ！！！', '提示信息', MB_ICONQUESTION);
      end;
    end;
  finally
    BitBtnOK.Enabled := True;
    BitBtnClose.Enabled := True;
    FWorking := False;
  end;
  Close;
end;

procedure TuFrmDelImages.BitBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TuFrmDelImages.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FWorking;
end;

end.
