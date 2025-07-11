unit M2DownloadTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Menus, StdCtrls, cxButtons, cxProgressBar, uUpdateTools,
  uServerList, dxSkinsCore, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light;

type
  TDownloadTestForm = class(TForm)
    ProgressBar: TcxProgressBar;
    BtnClose: TcxButton;
    LabInfo: TLabel;
    BtnDownload: TcxButton;
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnDownloadClick(Sender: TObject);
  private
    { Private declarations }
    FUpdateItem: TUpdateItem;
    procedure Download;
    procedure PrintEx(AUpdateItem: TUpdateItem; const Message: String);
    procedure DoProgress(UpdateItem: TUpdateItem; AllSize, APosition: Integer);
    procedure DoCheckNeedUpdate(UpdateItem: TUpdateItem; var Need: Boolean);
  public
    { Public declarations }
  end;

  procedure TestDownload(AUpdateItem: TUpdateItem);

implementation

{$R *.dfm}

procedure TestDownload(AUpdateItem: TUpdateItem);
begin
  with TDownloadTestForm.Create(nil) do
    try
      FUpdateItem := AUpdateItem;
      ShowModal;
    finally
      Free;
    end;
end;

procedure TDownloadTestForm.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDownloadTestForm.BtnDownloadClick(Sender: TObject);
begin
  BtnClose.Enabled := False;
  BtnDownload.Enabled := False;
  try
    Download;
  finally
    BtnClose.Enabled := True;
    BtnDownload.Enabled := True;
  end;
end;

procedure TDownloadTestForm.DoCheckNeedUpdate(UpdateItem: TUpdateItem;
  var Need: Boolean);
begin
  Need := True;
end;

procedure TDownloadTestForm.DoProgress(UpdateItem: TUpdateItem; AllSize,
  APosition: Integer);
begin
  ProgressBar.Properties.Max := AllSize;
  ProgressBar.Position := APosition;
  ProgressBar.Update;
  Application.ProcessMessages;
end;

procedure TDownloadTestForm.Download;
var
  ATool: TUpdateTool;
begin
  ATool := TUpdateTool.CreateTool(FUpdateItem);
  if ATool <> nil then
  begin
    try
      LabInfo.Caption := '开始测试下载...';
      ATool.OnProgress := DoProgress;
      ATool.OnPrint := PrintEx;
      ATool.OnCheckNeedUpdateEvent := DoCheckNeedUpdate;
      ATool.DeleteTempFile := False;
      if ATool.CheckNeedUpdate then
      begin
        try
          LabInfo.Caption := '开始解析...';
          ATool.Prepare;
          LabInfo.Caption := '开始下载...';
          ATool.DoDownload;
          LabInfo.Caption := '下载完成...';
        except
          on E: Exception do
            LabInfo.Caption := '下载出错：' + E.Message;
        end;
      end;
    finally
      ATool.Free;
    end;
  end;
end;

procedure TDownloadTestForm.PrintEx(AUpdateItem: TUpdateItem;
  const Message: String);
begin
  LabInfo.Caption := Message;
end;

end.
