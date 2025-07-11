unit uURLModule;

interface

uses
  Windows, SysUtils, Classes, rtcDataSrv, rtcInfo, rtcConn, uHTTPTypes, uCommon;

type
  TUrlMonModule = class(TDataModule, IHTTPModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    ResProvider: TRtcDataProvider;
    FURLManager: TURLManager;
    procedure ResProviderCheckRequest(Sender: TRtcConnection);
    procedure ResProviderDataReceived(Sender: TRtcConnection);
  protected
    //IHTTPModule
    procedure SetHTTPServer(Server: TRtcDataServer);
    procedure InitModule;
  public
    { Public declarations }
  end;

var
  UrlMonModule: TUrlMonModule;

implementation

{$R *.dfm}

{ TUrlMonModule }

procedure TUrlMonModule.DataModuleCreate(Sender: TObject);
begin
  FURLManager := TURLManager.Create;
  ResProvider := TRtcDataProvider.Create(Self);
  ResProvider.OnCheckRequest := ResProviderCheckRequest;
  ResProvider.OnDataReceived := ResProviderDataReceived;
  HTTPManager.RegisterModule(Self);
end;

procedure TUrlMonModule.InitModule;
begin

end;

procedure TUrlMonModule.ResProviderCheckRequest(Sender: TRtcConnection);
var
  AClass: TURLResponderClass;
begin
  if not SameText(HTTPManager.ResourcesList, TRtcDataServer(Sender).Request.FileName) and not SameText(HTTPManager.ResourcesFile, TRtcDataServer(Sender).Request.FileName) then
    if TURLManager.TryGetResponder(TRtcDataServer(Sender).Request.FileName, AClass) then
      TRtcDataServer(Sender).Accept;
end;

procedure TUrlMonModule.ResProviderDataReceived(Sender: TRtcConnection);
var
  AClass: TURLResponderClass;
  AResponder: TURLResponder;
begin
  if TURLManager.TryGetResponder(TRtcDataServer(Sender).Request.FileName, AClass) then
  begin
    AResponder := AClass.Create;
    try
      AResponder.Request(TRtcDataServer(Sender));
    finally
      AResponder.Free;
    end;
  end;
end;

procedure TUrlMonModule.SetHTTPServer(Server: TRtcDataServer);
begin
  ResProvider.Server := Server;
end;

type
  TURLIndexResponder = class(TURLResponder)
  public
    procedure Request(Sender: TRtcDataServer); override;
  end;


{ TURLIndexResponder }

procedure TURLIndexResponder.Request(Sender: TRtcDataServer);
begin
  Sender.Write('Welcome!!!!!!!!');
end;

initialization
  TURLManager.Register('/', TURLIndexResponder);
  TURLManager.Register('/index.html', TURLIndexResponder);
  TURLManager.Register('/index.htm', TURLIndexResponder);

end.
