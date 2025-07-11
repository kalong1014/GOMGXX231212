program DBServer;

{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

uses
{$IFDEF DEBUG}
  FastMM4,
{$ENDIF}
  Forms,
  DBSMain in 'DBSMain.pas' {FrmDBSrv},
  FDBSQL in 'FDBSQL.pas',
  DBShare in 'DBShare.pas',
  NetSelChrGate in 'NetSelChrGate.pas',
  NetLoginServer in 'NetLoginServer.pas',
  NetGameServer in 'NetGameServer.pas',
  GeneralConfig in 'GeneralConfig.pas' {frmGeneralConfig};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmDBSrv, FrmDBSrv);
  Application.Run;
end.
