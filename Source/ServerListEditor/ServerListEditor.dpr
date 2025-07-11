program ServerListEditor;

uses
  Forms,
  Main in 'Main.pas' {FrmServerList};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmServerList, FrmServerList);
  Application.Run;
end.
