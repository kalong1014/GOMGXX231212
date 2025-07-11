unit uCommon;

interface
  uses Classes, SysUtils, NativeXmlObjectStorage, rtcDataSrv, uTypes, uEDCode,
  Generics.Collections, RAR, RAR_DLL, uWil;

type
  ILogger = interface
  ['{B2DB7805-FA44-4F97-9084-F9FFA7B05479}']
    procedure WriteLog(const Value: String);
  end;

  IHTTPModule = interface
  ['{578D914B-EC3D-4B8F-8826-57226A86D77B}']
    procedure SetHTTPServer(Server: TRtcDataServer);
    procedure InitModule;
  end;

  TMiniFile = class(TCollectionItem)
  private
    FFileName: String;
    FPassword: String;
  published
    property FileName: String read FFileName write FFileName;
    property Password: String read FPassword write FPassword;
  end;

  TMiniFiles = class(TCollection)
  private
    function Get(Index: Integer): TMiniFile;
  public
    function Add: TMiniFile;
    function Exists(const AFileName: String): Boolean;
    property Items[Index: Integer]: TMiniFile read Get;
  end;

  TMiniConfigure = class(TuSerialObject)
  private
    FPort: Integer;
    FPassWord: String;
    FAddr: String;
    FFiles: TMiniFiles;
    FRealPassWord: String;
    FEnabledBlackList: Boolean;
    FBlackList: TStrings;
    FAutoCompress: Boolean;
    FBufferSize: Integer;
    FClientPath: String;
    FRarPath:String;
    procedure SetPassWord(const Value: String);
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure AddBlackIP(const IP: String);
    procedure RemoveBlackIP(const IP: String);
    function InBlackList(const IP: String): Boolean;

    property RealPassWord: String read FRealPassWord;
  published
    property Addr: String read FAddr write FAddr;
    property Port: Integer read FPort write FPort;
    property PassWord: String read FPassWord write SetPassWord;
    property EnabledBlackList: Boolean read FEnabledBlackList write FEnabledBlackList;
    property AutoCompress: Boolean read FAutoCompress write FAutoCompress;
    property BufferSize: Integer read FBufferSize write FBufferSize;
    property Files: TMiniFiles read FFiles write FFiles;
    property ClientPath: String read FClientPath write FClientPath;
    property RarPath:string read FRarPath write FRarPath;
  end;

  THTTPManager = class
  private
    FModules: TList;
    FServer: TRtcDataServer;
    FWWWRoot: String;
    procedure SetServer(const Value: TRtcDataServer);
  public
    const ResourcesList = '/Resources/List';
    const ResourcesFile = '/Resources/File';
    const PingUrl = '/Resources/Ping';
  public
    constructor Create;
    destructor Destroy; override;

    procedure InitModules;
    procedure RegisterModule(AModule: IHTTPModule);

    property Server: TRtcDataServer read FServer write SetServer;
    property WWWRoot: String read FWWWRoot write FWWWRoot;
  end;

  TRarFileItem = class
    FileName: String;
    RarName: String;
    Name: String;
  end;

  TFileManager = class
  private
    FFiles: TObjectDictionary<String, TRarFileItem>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddFile(const AName: String; ARarItem: TRarFileItem);
    function Contain(const AName: String): Boolean;
    function TryGet(const AName: String; out ARarItem: TRarFileItem): Boolean;
    procedure WriteHeaders(Stream: TStream);
  end;

procedure KickSession(Conn: TRtcDataServer);
function GetContentType(const FileName: String): String;
function ISResourceFileName(const AFileName: String): Boolean;

var
  HTTPManager: THTTPManager;
  FileManager: TFileManager;
  MiniConfigure: TMiniConfigure;
  BufferSize: Integer = 8192;
  Logger: ILogger;

implementation

procedure KickSession(Conn: TRtcDataServer);
begin
  Conn.Response.Status(400, 'Bad Request');
  Conn.Write('Status 400: Bad Request');
  Conn.Disconnect;
end;

function GetContentType(const FileName: String): String;
var
  AExt: String;
begin
  AExt := LowerCase(ExtractFileExt(FileName));
  if AExt = '.html' then
    Result := 'text/html'
  else if AExt = '.htm' then
    Result := 'text/html'
  else if AExt = '.js' then
    Result := 'text/js'
  else if AExt = '.css' then
    Result := 'text/css'
  else if AExt = '.txt' then
    Result := 'text/plain'
  else if AExt = '.rar' then
    Result := 'application/octet-stream'
  else if AExt = '.zip' then
    Result := 'application/octet-stream'
  else
    Result := 'application/octet-stream';
end;

function ISResourceFileName(const AFileName: String): Boolean;
var
  AExt: String;
begin
  Result := False;
  AExt := UpperCase(ExtractFileExt(AFileName));
  Result := (AExt = '.WZL') or (AExt = '.WIL') or (AExt = '.DATA') or (AExt = '.7RES');
end;

{ TMiniFiles }

function TMiniFiles.Add: TMiniFile;
begin
  Result := TMiniFile(inherited Add);
end;

function TMiniFiles.Exists(const AFileName: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    if SameText(AFileName, Items[I].FFileName) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TMiniFiles.Get(Index: Integer): TMiniFile;
begin
  Result := TMiniFile(inherited Items[Index]);
end;

{ TMiniConfigure }

constructor TMiniConfigure.Create;
begin
  inherited;
  FBlackList := TStringList.Create;
  FPort := 80;
  FAddr := '0.0.0.0';
  FRealPassWord := '';
  FBufferSize := 8192;
  FFiles := TMiniFiles.Create(TMiniFile);
end;

destructor TMiniConfigure.Destroy;
begin
  FreeAndNil(FFiles);
  FBlackList.Free;
  inherited;
end;

function TMiniConfigure.InBlackList(const IP: String): Boolean;
begin
  Result := FBlackList.IndexOf(IP) > -1;
end;

procedure TMiniConfigure.AddBlackIP(const IP: String);
var
  Idx: Integer;
begin
  Idx := FBlackList.IndexOf(IP);
  if Idx = -1 then
    FBlackList.Add(IP);
end;

procedure TMiniConfigure.RemoveBlackIP(const IP: String);
var
  Idx: Integer;
begin
  Idx := FBlackList.IndexOf(IP);
  if Idx <> -1 then
    FBlackList.Delete(Idx);
end;

procedure TMiniConfigure.SetPassWord(const Value: String);
begin
  FPassWord := Value;
  FRealPassWord := uEDCode.DecodeSource(FPassWord);
end;

{ THTTPManager }

type
  TModuleRecord = record
    Module: IHTTPModule;
  end;
  PModuleRecord = ^TModuleRecord;

constructor THTTPManager.Create;
begin
  FServer := nil;
  FModules  :=  TList.Create;
end;

destructor THTTPManager.Destroy;
var
  I: Integer;
begin
  for I := 0 to FModules.Count - 1 do
    Dispose(FModules[I]);
  FreeAndNil(FModules);
  inherited;
end;

procedure THTTPManager.InitModules;
var
  I: Integer;
begin
  for I := 0 to FModules.Count - 1 do
    PModuleRecord(FModules[I]).Module.InitModule;
end;

procedure THTTPManager.RegisterModule(AModule: IHTTPModule);
var
  ARecord: PModuleRecord;
begin
  if (FServer <> nil) and (AModule <> nil) then
    AModule.SetHTTPServer(FServer);
  New(ARecord);
  ARecord.Module := AModule;
  FModules.Add(ARecord);
end;

procedure THTTPManager.SetServer(const Value: TRtcDataServer);
var
  I: Integer;
begin
  FServer := Value;
  for I := 0 to FModules.Count - 1 do
    PModuleRecord(FModules[I]).Module.SetHTTPServer(FServer);
end;

{ TFileManager }

function TFileManager.Contain(const AName: String): Boolean;
begin
  Result := FFiles.ContainsKey(AName);
end;

constructor TFileManager.Create;
begin
  FFiles := TObjectDictionary<String, TRarFileItem>.Create([doOwnsValues]);
end;

destructor TFileManager.Destroy;
begin
  FreeAndNil(FFiles);
  inherited;
end;

function TFileManager.TryGet(const AName: String;
  out ARarItem: TRarFileItem): Boolean;
begin
  Result := FFiles.TryGetValue(AName, ARarItem);
end;

procedure TFileManager.WriteHeaders(Stream: TStream);
var
  AEnumerator: TObjectDictionary<String, TRarFileItem>.TPairEnumerator;
  AFileName: String;
  ANameBytes: TBytes;
  ANameLen: Integer;
  btValue: Byte;
begin
  btValue := TYPE_ANY_FILE;
  AEnumerator := FFiles.GetEnumerator;
  if AEnumerator <> nil then
  begin
    while AEnumerator.MoveNext do
    begin
      ANameBytes := TEncoding.UTF8.GetBytes(AEnumerator.Current.Value.Name);
      ANameLen := Length(ANameBytes);
      Stream.WriteBuffer(btValue, 1);
      Stream.WriteBuffer(ANameLen, SizeOf(Integer));
      Stream.WriteBuffer(ANameBytes[0], ANameLen);
    end;
  end;
end;

procedure TFileManager.AddFile(const AName: String; ARarItem: TRarFileItem);
begin
  FFiles.AddOrSetValue(AName, ARarItem);
end;

initialization
  HTTPManager := THTTPManager.Create;
  FileManager := TFileManager.Create;
  MiniConfigure := TMiniConfigure.Create;

finalization
  FreeAndNil(HTTPManager);
  FreeAndNil(FileManager);
  FreeAndNil(MiniConfigure);

end.
