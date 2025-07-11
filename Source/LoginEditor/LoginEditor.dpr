program LoginEditor;





{$R *.dres}

uses
  Forms,
  M2LoginEditor in 'M2LoginEditor.pas' {FRMLgoinEditor},
  M2LoginServerList in 'M2LoginServerList.pas' {frmLoginSrvList};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFRMLgoinEditor, FRMLgoinEditor);
  Application.CreateForm(TfrmLoginSrvList, frmLoginSrvList);
  Application.Run;
end.
