unit uMainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, uEDCode, uCliTypes, uServerList, uLogin;

type
  TMainForm = class(TuForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function LoadSkinStram: TStream;
    procedure TreeChangingNode(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure OnAdvancedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMNCHITTEST(var Msg: TWMNCHITTEST); message WM_NCHITTEST;
  public
    { Public declarations }
    SkinLoaded: Boolean;
    procedure LoadFromSkinData;
  end;

var
  MainForm: TMainForm;
implementation
  uses uSplashFrm;

{$R *.dfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadFromSkinData;
  uClientApp.MainForm := Self;
  uClientApp.Open;
end;

function TMainForm.LoadSkinStram: TStream;
var
  AFile: TFileStream;
  AExecutableStructure: TuExecutableStructure;
begin
  Result  :=  TMemoryStream.Create;
  {$IFDEF DEBUG}
  TMemoryStream(Result).LoadFromFile('.\Default.m2skin');
  Result.Seek(0, soFromBeginning);
  {$ELSE}
  AExecutableStructure  :=  LoadExecutableStructure;
  AFile :=  TFileStream.Create(Application.ExeName, fmOpenRead or fmShareDenyNone);
  try
    AFile.Position  :=  AExecutableStructure.Offset;// AFile.Size - 276 - AExecutableStructure.SkinDataLen;
    Result.CopyFrom(AFile, AExecutableStructure.SkinDataLen);
    Result.Seek(0, soFromBeginning);
  finally
    AFile.Free;
  end;
  {$ENDIF}
end;

procedure TMainForm.OnAdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);
begin
  if Node.Level = 0 then
    Sender.Canvas.Font.Color  :=  clYellow
  else if (Node.Data <> nil) and (TObject(Node.Data) is TServerItem) then
  begin
    if TServerItem(Node.Data).Active then
      Sender.Canvas.Font.Color  :=  clLime
    else
      Sender.Canvas.Font.Color  :=  clRed;
  end;
end;

procedure TMainForm.TreeChangingNode(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  AllowChange :=  not uClientApp.CheckVer;
end;

procedure TMainForm.WMNCHITTEST(var Msg: TWMNCHITTEST);
begin
  inherited;
  if Msg.Result = HTCLIENT then     //½ûÖ¹´°¿ÚÍÏ¶¯
    Msg.Result := 0
end;

procedure TMainForm.WMSysCommand(var Message: TWMSysCommand);
begin
  inherited;
  if Message.CmdType = $F012 then
  begin
    SplashForm_Login_77M2.Left := Left;
    SplashForm_Login_77M2.Top := Top;
    SplashForm_Login_77M2.Width := Width;
    SplashForm_Login_77M2.Height := Height;
    SplashForm_Login_77M2.UpdateForm;
  end;

end;

procedure TMainForm.LoadFromSkinData;
var
  I: Integer;
  Comp: TComponent;
  ASkinStram: TStream;
begin
  uAlphaForm := GetDisplayBitsoixel = 32;
  ASkinStram  :=  LoadSkinStram;
  Windows.LockWindowUpdate(Handle);
  try
    Try
      Position := poScreenCenter;
      BorderStyle  :=  bsNone;
      LoadFromStream(ASkinStram);
      Position :=  poScreenCenter;
    Finally
      ASkinStram.Free;
    End;
  except
   // Application.Terminate;
  end;
  for I := 0 to ComponentCount - 1 do
  begin
    Comp  :=  Components[I];
    if Comp.ClassType = TuURLButton then
    begin
      if TuURLButton(Comp).URL='' then
        TuURLButton(Comp).Enabled :=  False;
    end
    else if Comp.ClassType = TuStartBtton then
      TuStartBtton(Comp).Enabled :=  False
    else if Comp.ClassType = TuRegisterButton then
      TuRegisterButton(Comp).Enabled :=  False
    else if Comp.ClassType = TuGetBackPassButton then
      TuGetBackPassButton(Comp).Enabled :=  False
    else if Comp.ClassType = TuChangePassButton then
      TuChangePassButton(Comp).Enabled :=  False
    else if Comp.ClassType = TuCurProgressBar then
    begin
      TuCurProgressBar(Comp).Position :=  0;
      TuCurProgressBar(Comp).Min :=  0;
      TuCurProgressBar(Comp).Max :=  0;
    end
    else if Comp.ClassType = TuAllProgressBar then
    begin
      TuAllProgressBar(Comp).Position :=  0;
      TuAllProgressBar(Comp).Min :=  0;
      TuAllProgressBar(Comp).Max :=  0;
    end
    else if Comp.ClassType = TuInfLable then
    begin
      TuInfLable(Comp).Caption :=  '';
    end
    else if Comp.ClassType = TuTreeView then
    begin
      TuTreeView(Comp).Items.Clear;
      TuTreeView(Comp).OnChanging :=  TreeChangingNode;
      TuTreeView(Comp).OnChange   :=  uClientApp.TreeChangeNode;
      TuTreeView(Comp).OnMouseDown := uClientApp.TreeMouseDown;
      uClientApp.TreeView := TuTreeView(Comp);
      TuTreeView(Comp).OnAdvancedCustomDrawItem :=  OnAdvancedCustomDrawItem;
    end
    else if Comp.ClassType = TuServerCombobox then
    begin
      TuServerCombobox(Comp).Items.Clear;
      TuServerCombobox(Comp).OnChange := uClientApp.ServerComboboxChange;
    end
    else if Comp.ClassType = TuImage then
    begin
      if uAlphaForm and TransparentColor and TuImage(Comp).Visible then
      begin
        TuImage(Comp).Visible := False;
        TuImage(Comp).Tag := 9999;
      end;
    end;
  end;

  SplashForm_Login_77M2.Left := Left;
  SplashForm_Login_77M2.Top := Top;
  SplashForm_Login_77M2.Width := Width;
  SplashForm_Login_77M2.Height := Height;
  SplashForm_Login_77M2.AlginMainForm;
  SplashForm_Login_77M2.UpdateForm;
  Windows.LockWindowUpdate(0);
  SkinLoaded := True;
  Show;
end;

end.
