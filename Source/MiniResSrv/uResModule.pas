unit uResModule;

interface

uses
  Windows, SysUtils, Classes, rtcDataSrv, rtcInfo, rtcConn, uWil, uEDCode, uCommon,
  Math;

const
  MAX_ACCEPT_BODY_SIZE: int64 = 1024;

type
  TMiniResRequest = packed record
    _Type: Byte; //0:图片 1:单文件
    Important: Boolean; //是否重要，无需队列等待，立即下载
    FileName: String[200];
    Index: Integer;
    FailCount:Word; //失败次数
    Data:Pointer; //用以挂接其他数据
  end;
  PTMiniResRequest = ^TMiniResRequest;

  TResoureModule = class(TDataModule, IHTTPModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    ResProvider: TRtcDataProvider;
    FListBuffer: PAnsiChar;
    FListDataSize: Integer;
    procedure ResProviderCheckRequest(Sender: TRtcConnection);
    procedure ResProviderDataSent(Sender: TRtcConnection);
    procedure WriteList(Sender: TRtcDataServer; APosition, ASendLen: Integer);
    procedure WriteResource(Sender: TRtcDataServer; APosition, ASendLen: Integer);
  protected
    //IHTTPModule
    procedure SetHTTPServer(Server: TRtcDataServer);
    procedure InitModule;
  public
    { Public declarations }
  end;

var
  ResoureModule: TResoureModule;

implementation

{$R *.dfm}

procedure TResoureModule.DataModuleCreate(Sender: TObject);
begin
  FListBuffer := nil;
  FListDataSize := 0;
  ResProvider := TRtcDataProvider.Create(Self);
  ResProvider.OnCheckRequest := ResProviderCheckRequest;
  ResProvider.OnDataSent := ResProviderDataSent;
  HTTPManager.RegisterModule(Self);
end;

procedure TResoureModule.DataModuleDestroy(Sender: TObject);
begin
  if FListBuffer <> nil then
    FreeMem(FListBuffer);
end;

procedure TResoureModule.ResProviderCheckRequest(Sender: TRtcConnection);
var
  AServer: TRtcDataServer;
  APass: String;
  ARequest: TMiniResRequest;
  AImages: TWMImages;
  ARarItem: TRarFileItem;
  ADataSize: Integer;
begin
  AServer := TRtcDataServer(Sender);
  with AServer do
  begin
    if Request.DataSize > MAX_ACCEPT_BODY_SIZE then
    begin
      KickSession(AServer);
      Logger.WriteLog(Format('请求头部不在允许的范围内(IP:%s, Size:%d URLPath:%s)', [Sender.PeerAddr, Request.DataSize, Request.FileName]));
    end;
    if (Request.Method='GET') then
    begin
      if SameText(HTTPManager.ResourcesList, Request.FileName) then
      begin
        APass := uEDCode.DecodeSource(rtcInfo.URL_Decode(Request.Query.asString['Params']));
        if APass = MiniConfigure.RealPassWord then
        begin
          Accept;
          Response.ContentLength := FListDataSize;
          Response.ContentType := 'application/octet-stream';
          WriteHeader;
        end
        else
        begin
          Logger.WriteLog(Format('微端请求安全校验失败(IP:%s)', [Sender.PeerAddr]));
          if MiniConfigure.EnabledBlackList then
          begin
            MiniConfigure.AddBlackIP(Sender.PeerAddr);
            Logger.WriteLog(Format('加入黑名单(IP:%s)', [Sender.PeerAddr]));
          end;
          KickSession(AServer);
        end;
      end
      else if SameText(HTTPManager.ResourcesFile, Request.FileName) then
      begin
        try
          Accept;
          uEDCode.DecodeData(rtcInfo.URL_Decode(Request.Query.asString['Params']), ARequest, SizeOf(TMiniResRequest), MiniConfigure.RealPassWord);
          Response.ContentType := 'application/octet-stream';
          Request.Info.asString['File'] := UpperCase(ARequest.FileName);
          Request.Info.asString['Type'] := IntToStr(ARequest._Type);
          case ARequest._Type of
            0:
            begin
              if ImagesManager.TryGet(UpperCase(ARequest.FileName), AImages) then
              begin
                try
                  AImages.Extract(ARequest.Index, ADataSize);
                  Request.Info.asString['Index'] := IntToStr(ARequest.Index);
                  Response.ContentLength := ADataSize;
                except
                end;
              end;
            end;
            1:
            begin
              if FileManager.TryGet(UpperCase(ARequest.FileName), ARarItem) then
                Response.ContentLength := Max(0, rtcInfo.File_Size(ARarItem.RarName));
            end
            else
            begin
              KickSession(AServer);
              Logger.WriteLog(Format('请求超过允许的范围内(IP:%s)', [PeerAddr]));
            end;
          end;
          WriteHeader;
        except
          on E: Exception do
          begin
            Logger.WriteLog(Format('微端请求失败(IP:%s,URLPath:%s)', [PeerAddr, Request.FileName]));
            if MiniConfigure.EnabledBlackList then
            begin
              Logger.WriteLog(Format('加入黑名单(IP:%s)', [Sender.PeerAddr]));
              MiniConfigure.AddBlackIP(Sender.PeerAddr);
            end;
            KickSession(AServer);
          end;
        end;
      end
      else if SameText(HTTPManager.PingUrl, Request.FileName) then
      begin
        Accept;
        Response.Status(200, 'OK');
        Write('Status 200: OK');
      end;
    end
    else
    begin
      KickSession(AServer);
      Logger.WriteLog(Format('没授权的请求(IP:%s, Size:%d URLPath:%s)', [Sender.PeerAddr, Request.DataSize, Request.FileName]));
    end;
  end;
end;

procedure TResoureModule.WriteList(Sender: TRtcDataServer; APosition, ASendLen: Integer);
var
  AByteArray: RtcByteArray;
begin
  SetLength(AByteArray, ASendLen);
  Move(FListBuffer[APosition], AByteArray[0], ASendLen);
  Sender.WriteEx(AByteArray);
end;

procedure TResoureModule.WriteResource(Sender: TRtcDataServer; APosition, ASendLen: Integer);
var
  AFileName: String;
  AImages: TWMImages;
  ARarItem: TRarFileItem;
  AImageIndex: Integer;
  AByteArray: RtcByteArray;
begin
  AFileName := Sender.Request.Info.asString['File'];
  if Sender.Request.Info.asString['Type'] = '0' then
  begin
    if ImagesManager.TryGet(AFileName, AImages) then
    begin
      AImageIndex := StrToIntDef(Sender.Request.Info.asString['Index'], 0);
      AImages.ReadBuffer(AImageIndex, AByteArray, APosition, ASendLen);
      Sender.WriteEx(AByteArray);
    end;
  end
  else
  begin
    if FileManager.TryGet(AFileName, ARarItem) then
    begin
      AByteArray := Read_FileEx(ARarItem.RarName, APosition, ASendLen);
      Sender.WriteEx(AByteArray);
    end;
  end;
end;

procedure TResoureModule.ResProviderDataSent(Sender: TRtcConnection);
var
  ASendLen: Integer;
begin
  with TRtcDataServer(Sender) do
  begin
    if Request.Complete then
    begin
      if Response.ContentLength > Response.ContentOut then
      begin
        ASendLen := Min(BufferSize, Response.ContentLength - Response.ContentOut);
        if SameText(HTTPManager.ResourcesList, Request.FileName) then
          WriteList(TRtcDataServer(Sender), Response.ContentOut, ASendLen)
        else if SameText(HTTPManager.ResourcesFile, Request.FileName) then
          WriteResource(TRtcDataServer(Sender), Response.ContentOut, ASendLen);
      end;
    end;
  end;
end;

procedure TResoureModule.SetHTTPServer(Server: TRtcDataServer);
begin
  ResProvider.Server := Server;
end;

procedure TResoureModule.InitModule;
var
  AStream: TMemoryStream;
begin
  Logger.WriteLog('初始化微端管理模块...');
  AStream := TMemoryStream.Create;
  try
    ImagesManager.WriteHeaders(AStream);
    FileManager.WriteHeaders(AStream);
    CompressBufZ(PAnsiChar(AStream.Memory), AStream.Size, FListBuffer, FListDataSize);
    Logger.WriteLog('初始化微端管理模块完成...');
  except
    on E: Exception do
    begin
      Logger.WriteLog('错误: 初始化微端管理模块失败...');
      FreeMem(FListBuffer, FListDataSize);
      FListBuffer := nil;
    end;
  end;
  AStream.Free;
end;

end.
