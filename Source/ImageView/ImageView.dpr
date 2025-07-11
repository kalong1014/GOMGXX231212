program ImageView;



uses
  Forms,
  M2ImageView in 'M2ImageView.pas' {uImageViewer},
  M2DelImages in 'M2DelImages.pas' {uFrmDelImages},
  M2CreateData in 'M2CreateData.pas' {uFrmCreateData},
  M2OutPutDlgMain in 'M2OutPutDlgMain.pas' {uFrmExport},
  M2InPutManyDlgMain in 'M2InPutManyDlgMain.pas' {uFrmInputMany},
  Convert in 'Convert.pas' {frmConvertDlg},
  M2ImageInput in 'M2ImageInput.pas' {uFrmImgInput},
  DIB in 'DIB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TuImageViewer, uImageViewer);
  Application.CreateForm(TfrmConvertDlg, frmConvertDlg);
  Application.Run;
end.
