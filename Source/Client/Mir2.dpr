program Mir2;

{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

{$IFDEF CONSOLE}
{$APPTYPE CONSOLE}
{$ENDIF}

{$R *.dres}

uses
  Forms,
  Dialogs,
  IniFiles,
  Windows,
  SysUtils,
  classes,
  ClMain in 'ClMain.pas' {FrmMain},
  DrawScrn in 'DrawScrn.pas',
  IntroScn in 'IntroScn.pas',
  PlayScn in 'PlayScn.pas',
  MapUnit in 'MapUnit.pas',
  FState in 'FState.pas' {FrmDlg},
  ClFunc in 'ClFunc.pas',
  magiceff in 'magiceff.pas',
  SoundUtil in 'SoundUtil.pas',
  Actor in 'Actor.pas',
  HerbActor in 'HerbActor.pas',
  clEvent in 'clEvent.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  ConfirmDlg in 'ConfirmDlg.pas',
  SingleInstance in 'SingleInstance.pas',
  MaketSystem in 'MaketSystem.pas',
  RelationShip in 'RelationShip.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  EDCode in '..\Common\EDCode.pas',
  MShare in 'MShare.pas',
  AxeMon in 'AxeMon.pas',
  StallSystem in '..\Common\StallSystem.pas',
  UHelpStr in 'UHelpStr.pas',
  NgShare in 'NgShare.pas',
  DlgConfig in 'DlgConfig.pas' {frmDlgConfig},
  MagicShar in 'MagicShar.pas',
  FWeb in 'FWeb.pas' {FrmWeb},
  DWinCtl in '..\SceneUI\DWinCtl.pas',
  WIL in '..\SceneUI\WIL.pas',
  cliUtil in 'cliUtil.pas',
  uFirewall in '..\Common\uFirewall.pas',
  uEDCode in '..\Common\uEDCode.pas',
  uLocalMessageer in 'uLocalMessageer.pas',
  frmWebBroser in 'frmWebBroser.pas' {frmWebBrowser};

{$R *.RES}
{$R ResData.RES}

begin
  Application.Title := 'legend of mir2';
  Application.Initialize;
  Application.MainFormOnTaskBar := True;       // 启动时任务栏所显示的程序名称

  if ParamStr(1) = '' then begin
    ClientParamStr :=
    'nhjcdW1/gL9NR2ymIVYJjI8pqXsagck/c/ta5z1t/vqB4iJLrJIGsRgryJjp0qRcpeB6TcgkmOKW' +
    'UYhIYLRQrIMsxbyXqEI6u+kQrayuruFdJjGZ0PaeGQP3oaZAOT0bemR+5InGcyCkgTJA3hAH45oj' +
    'rsoGPF4Z8SZ6HYSnhAUVtiUvtxT/mnV2f3tnoJC3pLaAOqfkMMDmZN77OUwM1kjbYDA6SdyIpDWU' +
    'CKn4Zix0X4ogyu/MVzFRkmpwtyaIy1veRlJSPhXEZIMCb453bNZZZid46GQzw0x0hPKUhyGrVw9D' +
    'M6aXMN+3bJSnLBrJ0ZOS/wJxIM0w9C46EOZBYWtkMyf+qSKcMyjM4qm1+HqIVuT2UBbFqH5wkgUB' +
    'yoJw859fZVtanwZXeqgh0fOvJUAGG8+KvcI+y8uwb//XepPjdsSN4sKSz/2jb8ed6xj6meCeqYqY' +
    'tqrZ7L7BL/Ejd5sW0neNj2IzBdeu6cZBrE4JBzP06h+F4GATIXJtz0azdqCwDYKZueBR7JY4OnyW' +
    'zFLZU+vK27KPsg16xWrnbMqPT2dnIY3HObNWOXSX+Z4JbohA2hFJQVa3NKHIRGBAHFrNxWIHki7p' +
    'AUYOv0SjRgj5KhTidpY+CK2SoezNL8mxPRBqZuqjqXI7A55MJcqdq5RE2ttBNLWQJGROiSRc2TGP' +
    '1fJl4+yljRt9xWQmC1oW9SHsfYPB8NLM82cK22D7PgalBq4537OJ90jJ+hSjw+TMBpNAytrooCO5' +
    '+Thy1c9i37gwJ9fh3uMJFJNtT1I3fvYOXo/cDuxsUI6EtnEEwLJVhVdHaXq+5JwbOWyrfm004mwc' +
    'Z5ZlLxHDakxE4svyWp3MXBPumJxcuHuR34Ff5AZx70VILAWNFhfer3EvHWGlHvKlMj1MAXadezM0' +
    'GD5VXAZPoCZEiCGA8dgbhe4gboyVRSTjVf/bwslzQy24y1ZbUt4ZioI8MPCLCy9Qjv38CIw2jeNd' +
    'yGXkF7T0XKuYVPI8yQa2w5U+GV4dlC4=';
  end
  else begin
    ClientParamStr := ParamStr(1);
  end;
  if ClientParamStr <> '' then
  begin
    FillChar(g_MirStartupInfo, SizeOf(TMirStartupInfo), #0);
    try
      uEDCode.DecodeSourceData(ClientParamStr, g_MirStartupInfo, SizeOf(TMirStartupInfo));
    except

    end;
  end;

//  AddApplicationToFirewall('MirClient', Application.ExeName);

  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmDlg, FrmDlg);
  Application.CreateForm(TfrmDlgConfig, frmDlgConfig);
  Application.CreateForm(TfrmWebBrowser, frmWebBrowser);
  Application.Run;
end.
