unit uSplashFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GDIPUTIL, GDIPAPI, GDIPOBJ, uLogin, uCliTypes, ExtCtrls;

type
  TSplashForm_Login_77M2 = class(TForm)
    Timer: TTimer;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMMouseActivate(var Message: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure DoAppActivate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetZOrder(TopMost: Boolean); override;
  public
    { Public declarations }
    procedure AlginMainForm;
    procedure UpdateForm;
  end;

var
  SplashForm_Login_77M2: TSplashForm_Login_77M2;

implementation
  uses uChangPwd, uNewAccount, uMainFrm, uGameSetting, uGetBackPwd;

{$R *.dfm}

procedure TSplashForm_Login_77M2.AlginMainForm;
begin
  if (MainForm <> nil) and (not (csDestroying in ComponentState)) and MainForm.SkinLoaded then
  begin
    MainForm.Left := Left;
    MainForm.Top := Top;
    MainForm.BringToFront;
  end;
end;

procedure TSplashForm_Login_77M2.CMShowingChanged(var Message: TMessage);
begin
  if not Visible then
    inherited
  else
    ShowWindow(Handle, SW_SHOWNOACTIVATE);
  AlginMainForm;
end;

procedure TSplashForm_Login_77M2.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    //WndParent := MainForm.Handle;
  end;
end;

procedure TSplashForm_Login_77M2.DoAppActivate(Sender: TObject);
begin
  AlginMainForm;
  if (MainForm <> nil) and MainForm.Visible then
    MainForm.BringToFront;
  if (frmGetBackPwd <> nil) and frmGetBackPwd.Visible then
    frmGetBackPwd.BringToFront;
  if (FRMChangePWD <> nil) and FRMChangePWD.Visible then
    FRMChangePWD.BringToFront;
  if (FrmNewAccount <> nil) and FrmNewAccount.Visible then
    FrmNewAccount.BringToFront;
  if (FrmSetting <> nil) and FrmSetting.Visible then
    FrmSetting.BringToFront;
end;

procedure TSplashForm_Login_77M2.FormCreate(Sender: TObject);
begin
  Application.OnActivate := DoAppActivate;
  Caption := uClientApp.Title;
end;

procedure TSplashForm_Login_77M2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Handle, WM_NCLBUTTONDOWN, HTCaption, 0);
end;

procedure TSplashForm_Login_77M2.FormShow(Sender: TObject);
begin
  MainForm.Show;
end;

procedure TSplashForm_Login_77M2.SetZOrder(TopMost: Boolean);
begin
end;

procedure TSplashForm_Login_77M2.TimerTimer(Sender: TObject);
var
  AHandle: INT64;
  I: Integer;
  dwExitCode: DWORD;
begin
  for I := uHandles.Count - 1 downto 0 do
  begin
    AHandle := StrToInt64Def(uHandles[I], 0);
    GetExitCodeProcess(AHandle, dwExitCode);
    if dwExitCode <> STILL_ACTIVE then
    begin
      try
        CloseHandle(AHandle);
      except
      end;
      uHandles.Delete(I);
      if uHandles.Count < uClientApp.MaxClient then
        Application.MainForm.Show;
    end;
  end;
end;

procedure TSplashForm_Login_77M2.UpdateForm;
var
  ASize: TSize;
  APoint: TPoint;
  ABlendFun: TBlendFunction;
  ATopLeft: TPoint;
  AWindowRect: TRect;
  AGPGraph: TGPGraphics;
  AHDCMemory: HDC;
  AHDCScreen: HDC;
  AHBMP: HBITMAP;
  AImgAttributes: TGPImageAttributes;
  I: Integer;
  AStream: TStream;
  AStreamAdapter: TStreamAdapter;
  AGPBmp: TGPBitmap;
begin
  if uAlphaForm then
  begin
    AHDCScreen := GetDC(0);
    AHDCMemory := CreateCompatibleDC(AHDCScreen);
    AHBMP := CreateCompatibleBitmap(AHDCScreen, Width, Height);
    SelectObject(AHDCMemory, AHBMP);
    AGPGraph := TGPGraphics.Create(AHDCMemory);
    AImgAttributes := TGPImageAttributes.Create;
    try
      AImgAttributes.SetColorKey(ColorRefToARGB(MainForm.TransparentColorValue), ColorRefToARGB(MainForm.TransparentColorValue));
      //»­±³¾°Í¼
      for I := 0 to MainForm.ControlCount - 1 do
      begin
        if (MainForm.Controls[I] is TuImage) and (MainForm.Controls[I].Tag = 9999) and (TuImage(MainForm.Controls[I]).Picture.Graphic <> nil) then
        begin
          AStream := TMemoryStream.Create;
          AStreamAdapter := TStreamAdapter.Create(AStream, soOwned);
          try
            TuImage(MainForm.Controls[I]).Picture.Graphic.SaveToStream(AStream);
            AGPBmp := TGPBitmap.Create(AStreamAdapter);
            AGPGraph.DrawImage(AGPBmp, MainForm.Controls[I].Left, MainForm.Controls[I].Top, AGPBmp.GetWidth(), AGPBmp.GetHeight());
          finally
            AGPBmp.Free;
            AStreamAdapter := nil;
          end;
        end;
      end;
      ASize.cx := Width;
      ASize.cy := Height;
      APoint := Point(0, 0);
      with ABlendFun do
      begin
        BlendOp := AC_SRC_OVER;
        BlendFlags := 0;
        SourceConstantAlpha := 255;
        AlphaFormat := AC_SRC_ALPHA;
      end;
      GetWindowRect(Handle, AWindowRect);
      ATopLeft := AWindowRect.TopLeft;
      SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
      UpdateLayeredWindow(Handle, 0, @ATopLeft, @ASize, AGPGraph.GetHDC, @APoint, 0, @ABlendFun, 2);
    finally
      AGPGraph.ReleaseHDC(AHDCMemory);
      ReleaseDC(0, AHDCScreen);
      DeleteObject(AHBMP);
      DeleteDC(AHDCMemory);
      AGPGraph.Free;
      AImgAttributes.Free;
    end;
  end;
end;

procedure TSplashForm_Login_77M2.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TSplashForm_Login_77M2.WMMouseActivate(var Message: TWMMouseActivate);
begin
  Message.Result := MA_NOACTIVATE;
end;

procedure TSplashForm_Login_77M2.WMMove(var Message: TWMMove);
begin
  inherited;
  AlginMainForm;
end;

end.
