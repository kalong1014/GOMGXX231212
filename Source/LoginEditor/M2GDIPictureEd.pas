unit M2GDIPictureEd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ExtDlgs, Buttons, StdCtrls, Menus, cxLookAndFeelPainters,
  cxControls, cxContainer, cxEdit, cxImage, cxButtons, cxLookAndFeels,
  ComCtrls, cxGraphics, dxSkinsCore, AdvGDIPicture, GDIPicture,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light;

type
  TcxGDIPictureEditor = class(TForm)
    btnLoad: TcxButton;
    btnSave: TcxButton;
    btnClear: TcxButton;
    btnCancel: TcxButton;
    btnOk: TcxButton;
    Bevel1: TBevel;
    Panel: TPanel;
    Image: TAdvGDIPPicture;
    procedure btnLoadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FSizeGripBounds: TRect;
    FChained: Boolean;
    FNextWindow: HWND;
    procedure ForwardMessage(var Message: TMessage);
    procedure WMChangeCBChain(var Message: TWMChangeCBChain); message WM_CHANGECBCHAIN;
    procedure WMDrawClipboard(var Message: TMessage); message WM_DRAWCLIPBOARD;
    procedure WMNCDestroy(var Message: TWMNCDestroy); message WM_NCDESTROY;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWindowHandle; override;
    function HasPicture: Boolean;
    procedure UpdateButtons;
  end;

  PcxGDIPictureEditorDlgData = ^TcxGDIPictureEditorDlgData;
  TcxGDIPictureEditorDlgData = record
    Caption: string;
    LookAndFeel: TcxLookAndFeel;
    Picture: TGDIPPicture;
  end;

function cxShowGDIPictureEditor(const AData: PcxGDIPictureEditorDlgData): Boolean;

implementation

{$R *.DFM}

uses
  ClipBrd, cxClasses, cxVGridConsts, cxEditConsts, dxThemeConsts,
  dxThemeManager, dxUxTheme,dxCore;

function cxShowGDIPictureEditor(const AData: PcxGDIPictureEditorDlgData): Boolean;
var
  Form: TcxGDIPictureEditor;
  I: Integer;
begin
  Form := TcxGDIPictureEditor.Create(nil);
  with Form do
  try
    for I := 0 to ComponentCount - 1 do
      if Components[I] is TcxButton then
        TcxButton(Components[I]).LookAndFeel.MasterLookAndFeel := AData.LookAndFeel;
    btnClear.Caption := cxGetResourceString(@cxSMenuItemCaptionDelete);
    btnLoad.Caption := cxGetResourceString(@cxSMenuItemCaptionLoad);
    btnSave.Caption := cxGetResourceString(@cxSMenuItemCaptionSave);
    btnOK.Caption := cxGetResourceString(@cxSvgOKCaption);
    btnCancel.Caption := cxGetResourceString(@cxSvgCancelCaption);
    Panel.Caption := cxGetResourceString(@cxSvgRTTIInspectorEmptyGlyph);
    Image.Picture := AData^.Picture;
    Caption := AData^.Caption;
    UpdateButtons;
    Result := ShowModal = mrOK;
    if Result then
      AData^.Picture.Assign(Image.Picture);
  finally
    Free;
  end;
end;

procedure TcxGDIPictureEditor.CreateWnd;
begin
  inherited CreateWnd;
  if Handle <> 0 then
  begin
    FNextWindow := SetClipboardViewer(Handle);
    FChained := True;
  end;
  SendMessage(Self.Handle, WM_SETICON, 1, 0);
end;

procedure TcxGDIPictureEditor.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
end;

procedure TcxGDIPictureEditor.DestroyWindowHandle;
begin
  if FChained then
  begin
    ChangeClipboardChain(Handle, FNextWindow);
    FChained := False;
  end;
  FNextWindow := 0;
  inherited DestroyWindowHandle;
end;

procedure TcxGDIPictureEditor.FormPaint(Sender: TObject);
var
  ATheme: TdxTheme;
  R: TRect;
begin
  R := ClientRect;
  R.Left := R.Right - GetSystemMetrics(SM_CXVSCROLL);
  R.Top := R.Bottom - GetSystemMetrics(SM_CYHSCROLL);
  if btnOk.LookAndFeel.NativeStyle and AreVisualStylesAvailable([totScrollBar]) then
  begin
    ATheme := OpenTheme(totScrollBar);
    DrawThemeBackground(ATheme, Canvas.Handle, SBP_SIZEBOX, SZB_RIGHTALIGN, @R);
  end
  else
    DrawFrameControl(Canvas.Handle, R, DFC_SCROLL, DFCS_SCROLLSIZEGRIP);
end;

procedure TcxGDIPictureEditor.FormResize(Sender: TObject);
begin
  FSizeGripBounds := cxGetWindowRect(Self);
  FSizeGripBounds.Left := FSizeGripBounds.Right - GetSystemMetrics(SM_CXVSCROLL);
  FSizeGripBounds.Top := FSizeGripBounds.Bottom - GetSystemMetrics(SM_CYHSCROLL);
  Invalidate;
end;

procedure TcxGDIPictureEditor.ForwardMessage(var Message: TMessage);
begin
  if FNextWindow <> 0 then
    with Message do
      SendMessage(FNextWindow, Msg, WParam, LParam);
end;

procedure TcxGDIPictureEditor.WMChangeCBChain(var Message: TWMChangeCBChain);
begin
  if Message.Remove = FNextWindow then
    FNextWindow := Message.Next
  else ForwardMessage(TMessage(Message));
  inherited;
end;

procedure TcxGDIPictureEditor.WMDrawClipboard(var Message: TMessage);
begin
  UpdateButtons;
  ForwardMessage(Message);
  inherited;
end;

procedure TcxGDIPictureEditor.WMNCDestroy(var Message: TWMNCDestroy);
begin
  if FChained then
  begin
    ChangeClipboardChain(Handle, FNextWindow);
    FChained := False;
    FNextWindow := 0;
  end;
  inherited;
end;

procedure TcxGDIPictureEditor.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    if Message.Result in [HTCLIENT, HTRIGHT, HTBOTTOM]  then
      if PtInRect(FSizeGripBounds, GetMouseCursorPos) then
        Message.Result := HTBOTTOMRIGHT;
  end;
end;

function TcxGDIPictureEditor.HasPicture: Boolean;
begin
  Result := not Image.Picture.Empty;
end;

procedure TcxGDIPictureEditor.UpdateButtons;
begin
  btnSave.Enabled := HasPicture;
  btnClear.Enabled := HasPicture;
  if HasPicture then
    Panel.Caption := ''
  else
    Panel.Caption := cxGetResourceString(@cxSvgRTTIInspectorEmptyGlyph);
end;

procedure TcxGDIPictureEditor.btnLoadClick(Sender: TObject);
begin
  with TOpenPictureDialog.Create(nil) do
  begin
    Filter := 'All (*.jpg;*.jpeg;*.gif;*.bmp;*.png)|*.jpg;*.jpeg;*.gif;*.bmp;*.png|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|GIF files (*.gif)|*.gif|Bitmaps (*.bmp)|*.bmp|PNG files (*.png)|*.png';
    try
      if Execute then
      begin
        Image.Picture.LoadFromFile(FileName);
        UpdateButtons;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TcxGDIPictureEditor.btnSaveClick(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
  begin
    try
      if Execute then
      begin
        Image.Picture.SaveToFile(FileName);
        UpdateButtons;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TcxGDIPictureEditor.btnClearClick(Sender: TObject);
begin
  Image.Picture := nil;
  UpdateButtons;
end;

end.
