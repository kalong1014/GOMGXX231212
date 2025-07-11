unit uGameSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TFrmSetting = class(TForm)
    LabelDisplaySize: TLabel;
    chkWindow: TCheckBox;
    cbbScreenSize: TComboBox;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    LabHomePath: TLabel;
    chkVBlank: TCheckBox;
    chk3D: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure LabHomePathMouseEnter(Sender: TObject);
    procedure LabHomePathMouseLeave(Sender: TObject);
    procedure LabHomePathClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetDisplaySize(AWidth, AHeight: Integer);
    procedure LoadConfig;
  end;
  procedure EnumDisplayMode(LS: TStrings);

var
  FrmSetting: TFrmSetting;

implementation
  uses uLogin, uHomeSearch;

{$R *.dfm}
type
  TDisplay = record
    X,
    Y: Integer;
  end;
  pTDisplay = ^TDisplay;

function _DoSort(Item1, Item2: Pointer): Integer;
begin
  Result  :=  pTDisplay(Item1).X - pTDisplay(Item2).X;
  if Result = 0 then
    Result  :=  pTDisplay(Item1).Y - pTDisplay(Item2).Y;
end;

procedure EnumDisplayMode(LS: TStrings);
var
  DevModeCount: Integer;             // 显示模式的数目
  DevModeInfo: TDevMode;            //指向显示模式信息的指针
  Line: String;
  L: TList;
  ADisplay: pTDisplay;
  I, AMin: Integer;
begin
  L :=  TList.Create;
  try
    DevModeCount := 0;
    //GetMem(DevModeInfo, SizeOf(TDevMode));
    while EnumDisplaySettings(nil, DevModeCount, DevModeInfo) do
    begin
      Inc(DevModeCount);
      Line  :=  IntToStr(DevModeInfo.dmPelsWidth) + 'x' + IntToStr(DevModeInfo.dmPelsHeight);
      if (DevModeInfo.dmPelsWidth>640) and (ls.IndexOf(Line)=-1) then
      begin
        New(ADisplay);
        ADisplay^.X :=  DevModeInfo.dmPelsWidth;
        ADisplay^.Y :=  DevModeInfo.dmPelsHeight;
        L.Add(ADisplay);
        LS.Add(Line);
      end;
     // GetMem(DevModeInfo, SizeOf(TDevMode));
    end;
  //  FreeMem(DevModeInfo, SizeOf(TDevMode));

    L.Sort(_DoSort);
    LS.Clear;
    for I :=  0 to L.Count - 1 do
    begin
      LS.Add(Format('%dx%d', [pTDisplay(L[I]).X, pTDisplay(L[I]).Y]));
      Dispose(pTDisplay(L[I]));
    end;
  finally
    L.Free;
  end;
end;

procedure TFrmSetting.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  ls: TStrings;
begin
  if ModalResult = mrOK then
  begin
    uFullScreen := not chkWindow.Checked;
    uWaitVBlank := chkVBlank.Checked;
    u3D := chk3D.Checked;
    ls  :=  TStringList.Create;
    try
      ExtractStrings(['x'], [], PChar(cbbScreenSize.Text), ls);
      uSCREENWIDTH  :=  StrToInt(ls.Strings[0]);
      uSCREENHEIGHT :=  StrToInt(ls.Strings[1]);
    finally
      ls.Free;
    end;
  end;
end;

procedure TFrmSetting.FormCreate(Sender: TObject);
//var
//  ls: TStringList;
begin
//  ls  :=  TStringList.Create;
//  try
//    EnumDisplayMode(ls);
//    cbbScreenSize.Items.Assign(ls);
//  finally
//    ls.Free;
//  end;
  if cbbScreenSize.Items.Count = 0 then
  begin
    cbbScreenSize.Items.Add('800x600');
    cbbScreenSize.Items.Add('1024x768');
  end;
end;

procedure TFrmSetting.LabHomePathClick(Sender: TObject);
begin
  SetHomePath;
end;

procedure TFrmSetting.LabHomePathMouseEnter(Sender: TObject);
begin
  LabHomePath.Font.Color := clBlue;
end;

procedure TFrmSetting.LabHomePathMouseLeave(Sender: TObject);
begin
  LabHomePath.Font.Color := clBlack;
end;

procedure TFrmSetting.LoadConfig;
begin
  chkWindow.Checked := not uFullScreen;
  chkVBlank.Checked := uWaitVBlank;
  chk3D.Checked := u3D;
  cbbScreenSize.ItemIndex :=  cbbScreenSize.Items.IndexOf(Format('%dx%d', [uScreenWidth, uScreenHeight]));
  if (cbbScreenSize.ItemIndex = -1) and (cbbScreenSize.Items.Count>0) then
  begin
    cbbScreenSize.ItemIndex :=  cbbScreenSize.Items.IndexOf('1024x768');
    if (cbbScreenSize.ItemIndex = -1) and (cbbScreenSize.Items.Count>0) then
      cbbScreenSize.ItemIndex :=  0;
  end;
end;

procedure TFrmSetting.SetDisplaySize(AWidth, AHeight: Integer);
begin

end;

end.
