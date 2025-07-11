unit uStaticModule;

interface

uses
  Windows, SysUtils, Classes, rtcDataSrv, rtcInfo, rtcConn, uCommon, Math;

type
  TStaticModule = class(TDataModule, IHTTPModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    StaticProvider: TRtcDataProvider;
    procedure StaticProviderCheckRequest(Sender: TRtcConnection);
    procedure StaticProviderDataReceived(Sender: TRtcConnection);
    procedure StaticProviderDataSent(Sender: TRtcConnection);
  protected
    //IHTTPModule
    procedure SetHTTPServer(Server: TRtcDataServer);
    procedure InitModule;
  public
    { Public declarations }
  end;

var
  StaticModule: TStaticModule;

implementation

{$R *.dfm}

procedure TStaticModule.DataModuleCreate(Sender: TObject);
begin
  StaticProvider := TRtcDataProvider.Create(Self);
  StaticProvider.OnCheckRequest := StaticProviderCheckRequest;
  StaticProvider.OnDataReceived := StaticProviderDataReceived;
  StaticProvider.OnDataSent := StaticProviderDataSent;
  HTTPManager.RegisterModule(Self);
end;

procedure TStaticModule.InitModule;
begin

end;

procedure TStaticModule.SetHTTPServer(Server: TRtcDataServer);
begin
  StaticProvider.Server := Server;
end;

procedure TStaticModule.StaticProviderCheckRequest(Sender: TRtcConnection);
var
  AFileName: String;
begin
  with TRtcDataServer(Sender) do
  begin
    if Request.Complete then
    begin
      if not SameText(HTTPManager.ResourcesList, TRtcDataServer(Sender).Request.FileName) and
         not SameText(HTTPManager.ResourcesFile, TRtcDataServer(Sender).Request.FileName) and
         not SameText(HTTPManager.PingUrl, TRtcDataServer(Sender).Request.FileName) then
      begin
        AFileName := HTTPManager.WWWRoot + StringReplace(TRtcDataServer(Sender).Request.FileName, '/', '\', [rfReplaceAll]);
        if FileExists(AFileName) then
        begin
          Accept;
          Response.ContentLength := File_Size(AFileName);
          Response.ContentType := GetContentType(Request.FileName);
          WriteHeader;
        end
        else
        begin
          Response.Status(403, 'Forbidden');
          Write('Status 403: Forbidden');
        end;
      end;
    end;
  end;
end;

procedure TStaticModule.StaticProviderDataReceived(Sender: TRtcConnection);
begin
//
end;

procedure TStaticModule.StaticProviderDataSent(Sender: TRtcConnection);
var
  AFileName: String;
  AByteArray: RtcByteArray;
  ASendLen: Integer;
begin
  with TRtcDataServer(Sender) do
  begin
    if Request.Complete then
    begin
      if Response.ContentLength > Response.ContentOut then
      begin
        AFileName := HTTPManager.WWWRoot + StringReplace(Request.FileName, '/', '\', [rfReplaceAll]);
        ASendLen := Min(BufferSize, Response.ContentLength - Response.ContentOut);
        AByteArray := Read_FileEx(AFileName, Response.ContentOut, ASendLen);
        WriteEx(AByteArray);
      end;
    end;
  end;
end;

end.
