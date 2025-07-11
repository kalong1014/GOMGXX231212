unit uServerList;

interface
  uses Classes, SysUtils, NativeXmlObjectStorage, ZLib, ComCtrls, uMD5, uTypes, uEDCode,
  StrUtils;

type
  TServerItem = class(TuCollectionItem)
  private
    FPort: Integer;
    FHost: String;
    FServerName: String;
    FGroupName: String;
    FKey: AnsiString;
    FDisplayName: String;
    FImageIndex: Integer;
    FActive: Boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TCollection); override;
    property Active: Boolean read FActive write FActive;
  published
    property GroupName: String read FGroupName write FGroupName;
    property ServerName: String read FServerName write FServerName;
    property DisplayName: String read FDisplayName write FDisplayName;
    property Host: String read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property Key: AnsiString read FKey write FKey;
    property ImageIndex: Integer read FImageIndex write FImageIndex;
    property Enable;
  end;

  TServerList = class(TuCollection)
  private
    function GetItem(index: Integer): TServerItem;
  public
    function Add: TServerItem;
    property Items[index: Integer]: TServerItem read GetItem;
  end;

  TupDownKind = (dkHttp, dkBAIDUNetDisk, dt360NetDisk, dkFtp, dkAlbum);
  TutDownType = (dtSystem, dtBackground, dtDownIfNeed);

  TUpdateItem = class(TuCollectionItem)
  private
    FUrl: String;
    FCode: String;
    FZip: Boolean;
    FFileName: String;
    FPath: String;
    FUPKind: TupDownKind;
    FDownType: TutDownType;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  published
    property Url: String read FUrl write FUrl;
    property Code: String read FCode write FCode;
    property Zip: Boolean read FZip write FZip;
    property Path: String read FPath write FPath;
    property FileName: String read FFileName write FFileName;
    property DownKind: TupDownKind read FUPKind write FUPKind;
    property DownType: TutDownType read FDownType write FDownType;
    property Enable;
  end;

  TUpdateItems  = class(TuCollection)
  private
    function GetItem(index: Integer): TUpdateItem;
  public
    function Add: TUpdateItem;
    property Items[index: Integer]: TUpdateItem read GetItem; default;
  end;

  TSecurityFile = class(TuCollectionItem)
  private
    FFileName: String;
    FPassword: String;
  published
    property FileName: String read FFileName write FFileName;
    property Password: String read FPassword write FPassword;
  end;

  TSecurityFiles = class(TuCollection)
  private
    function GetItem(index: Integer): TSecurityFile;
  public
    function Add: TSecurityFile;
    property Items[index: Integer]: TSecurityFile read GetItem; default;
    procedure LoadFromStream(Stream:TStream);
    procedure SaveToStream(Stream:TStream);
    procedure SaveToFile(const FileName:String);
    procedure LoadFromFile(Const FileName:String);
  end;

  TDisplaySize = (dsNormal, ds1024, ds800);
  TServerInfo = class(TPersistent)
  private
    FUpdateItems: TUpdateItems;
    FLoginURL: String;
    FPayURL: String;
    FHomeURL: String;
    FContactURL: String;
    FNode: TTreeNode;
    FServerList: TServerList;
    FResFolder: String;
    FMiniURL: String;
    FClassicsUI: Boolean;
    FFullScreen: Boolean;
    FVBlank: Boolean;
    FDo3D: Boolean;
    FDisplaySize: TDisplaySize;
    FMiniPwd: String;
    FEnabledMini: Boolean;
    FLoginVerZip: Boolean;
    FLoginVerMD5: String;
    FLoginVerKind: TupDownKind;
    FLoginVerURL: String;
    FLoginVerFile: String;
    FClientType: Byte;
    FAutoClientType: Boolean;
    FMaxClient: Byte;
    FAssistantKind: Byte;
    FSecurityFiles: TSecurityFiles;
    FCreateShortCut: Boolean;
    FClientFileName: String;
    FIDLetterNum: Boolean;
    FIDFirstLetter: Boolean;
    FIDShowName: Boolean;
    FIDNameReq: Boolean;
    FIDShowBirth: Boolean;
    FIDBirthReq: Boolean;
    FIDQSReq: Boolean;
    FIDShowQS: Boolean;
    FIDQQReq: Boolean;
    FIDMailReq: Boolean;
    FIDShowMobile: Boolean;
    FIDMobileReq: Boolean;
    FIDShowID: Boolean;
    FIDShowQQ: Boolean;
    FIDIDReq: Boolean;
    FIDShowMail: Boolean;
    FUseLisence: Boolean;    //授权开启
    FDataTimeLisence: String;   //授权时间
    function GetFileCount: Integer;
    function GetSysFileCount: Integer;
    function GetBgFileCount: Integer;
    function GetDownIfNeedFileCount: Integer;
    procedure GetResFolder(const Value: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromFile(const AFileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const AFileName: String);
    procedure SaveToSteam(Stream: TStream);
    function SaveToString: String;
    procedure LoadFromString(const Source: String);
    property Node: TTreeNode read FNode write FNode;
    property FileCount: Integer read GetFileCount;
    property SysFileCount: Integer read GetSysFileCount;
    property BgFileCount: Integer read GetBgFileCount;
    property DownIfNeedFileCount: Integer read GetDownIfNeedFileCount;
  published
    property LoginURL: String read FLoginURL write FLoginURL;
    property PayURL: String read FPayURL write FPayURL;
    property HomeURL: String read FHomeURL write FHomeURL;
    property ContactURL: String read FContactURL write FContactURL;
    property EnabledMini: Boolean read FEnabledMini write FEnabledMini;
    property MiniURL: String read FMiniURL write FMiniURL;
    property MiniPwd: String read FMiniPwd write FMiniPwd;
    property ResFolder: String read FResFolder write GetResFolder;
    property ServerList: TServerList read FServerList write FServerList;
    property UpdateItems: TUpdateItems read FUpdateItems write FUpdateItems;
    property SecurityFiles: TSecurityFiles read FSecurityFiles write FSecurityFiles;
    property DisplaySize: TDisplaySize read FDisplaySize write FDisplaySize;
    property Do3D: Boolean read FDo3D write FDo3D;
    property VBlank: Boolean read FVBlank write FVBlank;
    property CreateShortCut: Boolean read FCreateShortCut write FCreateShortCut default True;
    property FullScreen: Boolean read FFullScreen write FFullScreen;
    property ClassicsUI: Boolean read FClassicsUI write FClassicsUI;
    property LoginVerURL: String read FLoginVerURL write FLoginVerURL;
    property LoginVerFile: String read FLoginVerFile write FLoginVerFile;
    property LoginVerMD5: String read FLoginVerMD5 write FLoginVerMD5;
    property LoginVerKind: TupDownKind read FLoginVerKind write FLoginVerKind;
    property LoginVerZip: Boolean read FLoginVerZip write FLoginVerZip;
    property AutoClientType: Boolean read FAutoClientType write FAutoClientType;
    property ClientType: Byte read FClientType write FClientType;
    property MaxClient: Byte read FMaxClient write FMaxClient;
    property AssistantKind: Byte read FAssistantKind write FAssistantKind;
    property ClientFileName: String read FClientFileName write FClientFileName;
    property IDLetterNum: Boolean read FIDLetterNum write FIDLetterNum default False;
    property IDFirstLetter: Boolean read FIDFirstLetter write FIDFirstLetter default False;
    property IDShowName: Boolean read FIDShowName write FIDShowName default True;
    property IDNameReq: Boolean read FIDNameReq write FIDNameReq default False;
    property IDShowBirth: Boolean read FIDShowBirth write FIDShowBirth default True;
    property IDBirthReq: Boolean read FIDBirthReq write FIDBirthReq default False;
    property IDShowQS: Boolean read FIDShowQS write FIDShowQS default True;
    property IDQSReq: Boolean read FIDQSReq write FIDQSReq default False;
    property IDShowMail: Boolean read FIDShowMail write FIDShowMail default True;
    property IDMailReq: Boolean read FIDMailReq write FIDMailReq default False;
    property IDShowQQ: Boolean read FIDShowQQ write FIDShowQQ default True;
    property IDQQReq: Boolean read FIDQQReq write FIDQQReq default False;
    property IDShowID: Boolean read FIDShowID write FIDShowID default True;
    property IDIDReq: Boolean read FIDIDReq write FIDIDReq default False;
    property IDShowMobile: Boolean read FIDShowMobile write FIDShowMobile default True;
    property IDMobileReq: Boolean read FIDMobileReq write FIDMobileReq default False;
    property UseLisence: Boolean read FUseLisence write FUseLisence;
    property DataTimeLisence: String read FDataTimeLisence write FDataTimeLisence;
  end;

implementation
  USES RegularExpressions, uTPLb_StreamUtils;

type
  TWorkStreamZlib = class
  private
    class function CompressionStream(Stream: TStream): TStream;
    class function DecompressionStream(Stream: TStream): TStream;
  end;


{ TStreamZlib }

class function TWorkStreamZlib.CompressionStream(
  Stream: TStream): TStream;
var
  Deststream:TMemoryStream;
  SourceStream:TCompressionStream;
  Count:Longint;
begin
  Result  :=  TMemoryStream.Create;
  Count:=Stream.Size;
  DestStream  :=  TMemoryStream.Create;
  SourceStream  :=  TCompressionStream.Create(clDefault, DestStream);
  TMemoryStream(Stream).SaveToStream(SourceStream);
  SourceStream.Free;

  Result.WriteBuffer(Count, Sizeof(Count));
  Result.CopyFrom(DestStream, 0);
  DestStream.Free;
end;

class function TWorkStreamZlib.DecompressionStream(
  Stream: TStream): TStream;
Var
  SourceStream:TDecompressionStream;
  count:Integer;
  buffer:pointer;
begin
  Stream.Position := 0;
  Stream.ReadBuffer(Count, Sizeof(Count));
  GetMem(Buffer,Count);
  Result  :=  TMemoryStream.Create;
  SourceStream := TDecompressionStream.Create(Stream);
  Try
    SourceStream.ReadBuffer(Buffer^,Count);
    Result.WriteBuffer(Buffer^,Count);
    Result.Position := 0;
  Finally
    FreeMem(Buffer);
    SourceStream.Destroy;
  End;
end;

{ TServerList }

function TServerList.Add: TServerItem;
begin
  Result  :=  TServerItem(inherited Add);
end;

function TServerList.GetItem(index: Integer): TServerItem;
begin
  Result  :=  TServerItem(inherited Items[index]);
end;

{ TUpdateItems }

function TUpdateItems.Add: TUpdateItem;
begin
  Result  :=  TUpdateItem(inherited Add);
end;

function TUpdateItems.GetItem(index: Integer): TUpdateItem;
begin
  Result  :=  TUpdateItem(inherited Items[index]);
end;

{TSecurityFiles}

function TSecurityFiles.GetItem(index: Integer): TSecurityFile;
begin
  Result  :=  TSecurityFile(inherited Items[index]);
end;

procedure TSecurityFiles.LoadFromFile(const FileName: String);
var
  Stream: TStream;
begin
  Stream  :=  TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TSecurityFiles.LoadFromStream(Stream: TStream);
var
  Temp, ACompStream: TStream;
begin
  Temp  :=  TMemoryStream.Create;
  ACompStream  :=  TMemoryStream.Create;
  try
    Stream.Seek(0, soBeginning);
    uEDCode.DecodeStream(Stream, ACompStream, uEDCode.DecodeSource('3JgWcMygyIQyvEiyr1uzMpHfkeGEYQVsp286NMbdfSz3fvEAeynXO7XqLn46zfuNVrmztOMPgorGktbfsqraHkuT1Z'+
                                                                    'rFc4PupqOov9qlKK0hXgOgRMS/yaTQOHg6Tll1HIElYH0/db28zgtgvAk6Rcu5oncVXxWyUIzVSUhmx1nsymgUsBc'+
                                                                    'MqLJ6bPAZHUBTtsPyBBfjhwuNyQtfEqm2KwXyHONCTDfL+J4V+nt7jjqIibRS1SQv2Lc2fseJddOIoTYVCFD5qwDrqnTt'));
    ACompStream.Seek(0, soBeginning);
    ZLib.ZDecompressStream(ACompStream, Temp);
    Temp.Seek(0, soBeginning);
    Clear;
    NativeXmlObjectStorage.ObjectLoadFromXmlStream(Self, Temp);
  finally
    Temp.Free;
    ACompStream.Free;
  end;
end;

procedure TSecurityFiles.SaveToFile(const FileName: String);
var
  Stream: TMemoryStream;
begin
  Stream  :=  TMemoryStream.Create;
  try
    SaveToStream(Stream);
    Stream.SaveToFile(FileName);
  finally
    Stream.Free;
  end;
end;

procedure TSecurityFiles.SaveToStream(Stream: TStream);
var
  ATemp, ACompStream: TStream;
begin
  ATemp :=  TMemoryStream.Create;
  ACompStream :=  TMemoryStream.Create;
  try
    NativeXmlObjectStorage.ObjectSaveToXmlStream(Self, ATemp);
    ATemp.Seek(0, soBeginning);
    ZLib.ZCompressStream(ATemp, ACompStream);
    uEDCode.EncodeStream(ACompStream, Stream, uEDCode.DecodeSource('o9dzKyaj4XPJ+BjaQ7q9+GhoRu6N62O5gbQhikWzxtTgCd7PD5HaOSH9H1fpiZvvvvgVV/94jwbI7Rbk3T2qLPzfxo'+
                                                                   'WWfXemzvSLw878iJ0JXRaHrCFsBzAdFRnGGI2lXXL+TJWvll3JjgshIdIyOOBJ+AR+tYn7ghhWEx/fAF7pNBd/xjhd'+
                                                                   'BM4Qf/W9RGlyNrJBbOBCPAhyafvLRTd1KvY8h0QzaUTobWC4IKLTHLk95EXwthdOa09p061W3HH8ibI5eMtkA4CUB/I4'));
  finally
    ATemp.Free;
    ACompStream.Free;
  end;
end;

function TSecurityFiles.Add: TSecurityFile;
begin
  Result  :=  TSecurityFile(inherited Add);
end;

{ TServerInfo }

procedure TServerInfo.Clear;
begin
  FUpdateItems.Clear;
  FServerList.Clear;
  FLoginURL   :=  '';
  FPayURL     :=  '';
  FHomeURL    :=  '';
  FContactURL :=  '';
  FClassicsUI :=  True;
  FFullScreen :=  False;
  FVBlank     :=  True;
  FDo3D       :=  True;
  FDisplaySize:=  ds1024;
  FMiniPwd      :=  '';
  FEnabledMini  :=  False;
  FMiniURL      :=  '';
  AssistantKind := 0;
end;

constructor TServerInfo.Create;
begin
  FUpdateItems  :=  TUpdateItems.Create(Self, TUpdateItem);
  FServerList   :=  TServerList.Create(Self, TServerItem);
  FSecurityFiles:=  TSecurityFiles.Create(Self, TSecurityFile);
  FClassicsUI   :=  True;
  FFullScreen   :=  False;
  FVBlank       :=  True;
  FDo3D         :=  True;
  FDisplaySize  :=  ds1024;
  FMiniPwd      :=  '';
  FEnabledMini  :=  False;
  FMiniURL      :=  '';
  FLoginVerZip  :=  False;
  FLoginVerMD5  :=  '';
  FLoginVerKind :=  dkHttp;
  FLoginVerURL  :=  '';
  FClientFileName := 'Client.dat';
  FAutoClientType := True;
  FCreateShortCut := True;
  FClientType := 0;
  FMaxClient := 3;
  AssistantKind := 0;
  FIDLetterNum := False;
  FIDFirstLetter := False;
  FIDShowName := True;
  FIDNameReq := False;
  FIDShowBirth := True;
  FIDBirthReq := False;
  FIDQSReq := False;
  FIDShowQS := True;
  FIDQQReq := False;
  FIDMailReq := False;
  FIDShowMobile := True;
  FIDMobileReq := False;
  FIDShowID := True;
  FIDShowQQ := True;
  FIDIDReq := False;
  FIDShowMail := True;
  FUseLisence   :=  False;
  FDataTimeLisence :=  EncodeLisence(DateToStr(Now));
end;

destructor TServerInfo.Destroy;
begin
  FreeAndNil(FUpdateItems);
  FreeAndNil(FServerList);
  FreeAndNil(FSecurityFiles);
  inherited;
end;

procedure TServerInfo.LoadFromFile(const AFileName: String);
var
  Stream: TStream;
begin
  Stream  :=  TFileStream.Create(AFileName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TServerInfo.LoadFromStream(Stream: TStream);
var
  Temp, ACompStream: TStream;
begin
  Temp  :=  TMemoryStream.Create;
  ACompStream  :=  TMemoryStream.Create;
  try
    Stream.Seek(0, soBeginning);
    uEDCode.DecodeStream(Stream, ACompStream, uEDCode.DecodeSource('3JgWcMygyIQyvEiyr1uzMpHfkeGEYQVsp286NMbdfSz3fvEAeynXO7XqLn46zfuNVrmztOMPgorGktbfsqraHkuT1Z'+
                                                                    'rFc4PupqOov9qlKK0hXgOgRMS/yaTQOHg6Tll1HIElYH0/db28zgtgvAk6Rcu5oncVXxWyUIzVSUhmx1nsymgUsBc'+
                                                                    'MqLJ6bPAZHUBTtsPyBBfjhwuNyQtfEqm2KwXyHONCTDfL+J4V+nt7jjqIibRS1SQv2Lc2fseJddOIoTYVCFD5qwDrqnTt'));
    ACompStream.Seek(0, soBeginning);
    ZLib.ZDecompressStream(ACompStream, Temp);
    Temp.Seek(0, soBeginning);
    Clear;
    NativeXmlObjectStorage.ObjectLoadFromXmlStream(Self, Temp);
  finally
    Temp.Free;
    ACompStream.Free;
  end;
end;

procedure TServerInfo.SaveToFile(const AFileName: String);
var
  Stream: TMemoryStream;
begin
  Stream  :=  TMemoryStream.Create;
  try
    SaveToSteam(Stream);
    Stream.SaveToFile(AFileName);
  finally
    Stream.Free;
  end;
end;

procedure TServerInfo.SaveToSteam(Stream: TStream);
var
  ATemp, ACompStream: TStream;
begin
  ATemp :=  TMemoryStream.Create;
  ACompStream :=  TMemoryStream.Create;
  try
    NativeXmlObjectStorage.ObjectSaveToXmlStream(Self, ATemp);
    ATemp.Seek(0, soBeginning);
    ZLib.ZCompressStream(ATemp, ACompStream);
    uEDCode.EncodeStream(ACompStream, Stream, uEDCode.DecodeSource('o9dzKyaj4XPJ+BjaQ7q9+GhoRu6N62O5gbQhikWzxtTgCd7PD5HaOSH9H1fpiZvvvvgVV/94jwbI7Rbk3T2qLPzfxo'+
                                                                   'WWfXemzvSLw878iJ0JXRaHrCFsBzAdFRnGGI2lXXL+TJWvll3JjgshIdIyOOBJ+AR+tYn7ghhWEx/fAF7pNBd/xjhd'+
                                                                   'BM4Qf/W9RGlyNrJBbOBCPAhyafvLRTd1KvY8h0QzaUTobWC4IKLTHLk95EXwthdOa09p061W3HH8ibI5eMtkA4CUB/I4'));
  finally
    ATemp.Free;
    ACompStream.Free;
  end;
end;

function TServerInfo.SaveToString: String;
var
  AStream: TStream;
begin
  AStream :=  TMemoryStream.Create;
  try
    SaveToSteam(AStream);
    AStream.Seek(0, soBeginning);
    Result  :=  uTPLb_StreamUtils.Stream_to_Base64(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TServerInfo.LoadFromString(const Source: String);
const
  REG_STR = '#ServerInfo#(.*)#ServerInfo#';
var
  AObjString: String;
  AStream: TStream;
begin
  with TRegEx.Match(Source, REG_STR) do
    if Success then
    begin
      AObjString  :=  Trim(Groups[1].Value);
      AObjString  :=  ReplaceStr(AObjString, ' ', '');
      AObjString  :=  ReplaceStr(AObjString, #$D#$A, '');
    end
    else
      AObjString  :=  Trim(Source);
  if AObjString <> '' then
  begin
    AStream :=  TMemoryStream.Create;
    try
      base64_to_stream(AObjString, AStream);
      AStream.Seek(0, soBeginning);
      LoadFromStream(AStream);
    finally
      AStream.Free;
    end;
  end;
end;

function TServerInfo.GetFileCount: Integer;
begin
  Result  :=  FUpdateItems.Count;
end;

procedure TServerInfo.GetResFolder(const Value: String);
begin
  FResFolder := Value;
  if FResFolder = '' then
    FResFolder := 'Resource\';
end;

function TServerInfo.GetSysFileCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FUpdateItems.Count - 1 do
    if FUpdateItems[I].DownType = dtSystem then
      Inc(Result);
end;

function TServerInfo.GetBgFileCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FUpdateItems.Count - 1 do
    if FUpdateItems[I].DownType = dtBackground then
      Inc(Result);
end;

function TServerInfo.GetDownIfNeedFileCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FUpdateItems.Count - 1 do
    if FUpdateItems[I].DownType = dtDownIfNeed then
      Inc(Result);
end;

{ TServerItem }

procedure TServerItem.AssignTo(Dest: TPersistent);
begin
  inherited;
  if not (Dest is TServerItem) then Exit;

  TServerItem(Dest).FPort       :=  FPort;
  TServerItem(Dest).FHost       :=  FHost;
  TServerItem(Dest).FServerName :=  FServerName;
  TServerItem(Dest).FGroupName  :=  FGroupName;
  TServerItem(Dest).FKey        :=  FKey;
  TServerItem(Dest).FDisplayName:=  FDisplayName;
  TServerItem(Dest).FImageIndex :=  FImageIndex;
end;

constructor TServerItem.Create(ACollection: TCollection);
begin
  inherited;
  FImageIndex :=  -1;
  FActive :=  True;
end;

{ TUpdateItem }

procedure TUpdateItem.AssignTo(Dest: TPersistent);
begin
  inherited;
  if not (Dest is TUpdateItem) then Exit;

  TUpdateItem(Dest).FUrl  :=  FUrl;
  TUpdateItem(Dest).FCode  :=  FCode;
  TUpdateItem(Dest).FZip  :=  FZip;
  TUpdateItem(Dest).FFileName  :=  FFileName;
  TUpdateItem(Dest).FPath  :=  FPath;
  TUpdateItem(Dest).FUPKind  :=  FUPKind;
  TUpdateItem(Dest).FDownType  :=  FDownType;
end;

end.
