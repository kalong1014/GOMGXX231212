program MiniClientResMaker;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  WzlSpliter in 'WzlSpliter.pas',
  WzlMerge in 'WzlMerge.pas',
  MergeFile in 'MergeFile.pas' {frmMerge},
  WIL in '..\SceneUI\WIL.pas',
  uMiniResFileInfo in '..\LoginEx\uMiniResFileInfo.pas',
  MiniResBuilderConfig in 'MiniResBuilderConfig.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmMerge, frmMerge);
  Application.Run;
end.
