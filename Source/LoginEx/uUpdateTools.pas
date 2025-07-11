unit uUpdateTools;

interface
  uses Windows, SysUtils, Classes, OverbyteIcsWndControl, OverbyteIcsHttpProt, OverbyteIcsFtpCli,
  RegularExpressions, Graphics, uServerList, IOUtils, uMD5, RAR, RAR_DLL, Forms;

type
  TUpdateManager  = class;

  TUpdateEvent  = procedure(UpdateItem: TUpdateItem) of Object;
  TPrintEvent  = procedure(UpdateItem: TUpdateItem; const Value: String) of Object;
  TProgressEvent = procedure(UpdateItem: TUpdateItem; AllSize, APosition: Integer) of Object;
  TUpdateItemEvent = procedure(UpdateItem: TUpdateItem; AllSize: Integer) of Object;
  TCheckNeedUpdateEvent = procedure(UpdateItem: TUpdateItem; var Need: Boolean) of Object;

  TUpdateTool = class
  private
    FPostion: Integer;
    FUpdateItem: TUpdateItem;
    FExtractPath,
    FTempFileName: String;
    FFileList: TStrings;
    FFileISOk: Boolean;
    FOnEnd: TUpdateEvent;
    FOnBegin: TUpdateEvent;
    FOnPrint: TPrintEvent;
    FOnProgress: TProgressEvent;
    FHomePath: String;
    FRARDLLFile: AnsiString;
    FCheckUpdateEvent: TCheckNeedUpdateEvent;
    FDeleteTempFile: Boolean;
    FResourcePath: String;
    procedure DoRARListFile(Sender: TObject; const FileInformation: TRARFileItem);
    procedure BeginDownload;
    procedure EndDownload;
    procedure Progress(ACount, APosition: Integer);
    procedure Print(const Value: String);
    function GetFullName: String;
    function GetFullPath: String;
  protected
    function GetAllSize: Integer; virtual; abstract;
  public
    constructor Create(AUpdateItem: TUpdateItem); virtual;
    destructor Destroy; override;
    class function CreateTool(AUpdateItem: TUpdateItem): TUpdateTool;

    function CheckNeedUpdate: Boolean;
    procedure Prepare; virtual;
    function DoDownload: Boolean; virtual; abstract;
    procedure Setup;
    procedure ExtractFiles(List: TStrings);
    procedure DeleteFile;

    procedure Download;
    property HomePath: String read FHomePath write FHomePath;
    property ResourcePath: String read FResourcePath write FResourcePath;
    property FullPath: String read GetFullPath;
    property FullName: String read GetFullName;
    property RARDLLFile: AnsiString read FRARDLLFile write FRARDLLFile;
    property Size: Integer read GetAllSize;
    property Postion: Integer read FPostion;
    property DeleteTempFile: Boolean read FDeleteTempFile write FDeleteTempFile;
    property TempFileName: String read FTempFileName;
    property ExtractPath: String read FExtractPath;
    property OnBegin: TUpdateEvent read FOnBegin write FOnBegin;
    property OnEnd: TUpdateEvent read FOnEnd write FOnEnd;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnPrint: TPrintEvent read FOnPrint write FOnPrint;
    property OnCheckNeedUpdateEvent: TCheckNeedUpdateEvent read FCheckUpdateEvent write FCheckUpdateEvent;
  end;

  TUpdateManager  = class
  private
    FServerInfo: TServerInfo;
    FActiveItem: TUpdateTool;
    FOnPrint: TPrintEvent;
    FOnProgress: TProgressEvent;
    FOnBeginUpdateItem,
    FOnEndUpdateItem: TUpdateItemEvent;
    FOnFileBegin,
    FOnFileEnd: TNotifyEvent;
    FRARDLLFile: AnsiString;
    FHomePath: String;
    function CreateUpdateTool(AUpdateItem: TUpdateItem): TUpdateTool;
    procedure DoProgress(AUpdateItem: TUpdateItem; AllSize, APosition: Integer);
    procedure DoBegin(AUpdateItem: TUpdateItem);
    procedure DoEnd(AUpdateItem: TUpdateItem);
    procedure DoPrint(AUpdateItem: TUpdateItem; const Value: String);
    procedure DoFileBegin;
    procedure DoFileEnd;
  public
    constructor Create(AServerInfo: TServerInfo);
    destructor Destroy; override;
    procedure Download;
    procedure DownloadBy(ADownType: TutDownType);

    property RARDLLFile: AnsiString read FRARDLLFile write FRARDLLFile;
    property HomePath: String read FHomePath write FHomePath;
    property OnFileBegin: TNotifyEvent read FOnFileBegin write FOnFileBegin;
    property OnFileEnd: TNotifyEvent read FOnFileEnd write FOnFileEnd;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnPrint: TPrintEvent read FOnPrint write FOnPrint;
    property OnBeginUpdateItem: TUpdateItemEvent read FOnBeginUpdateItem write FOnBeginUpdateItem;
    property OnEndUpdateItem: TUpdateItemEvent read FOnEndUpdateItem write FOnEndUpdateItem;
  end;

implementation
  uses StrUtils, uFilePICConverter;//, uLogin;

type
  TAlbumItem  = class
  private
    FFileName: String;
    FileStream: TFileStream;
    Url: String;
    procedure CreateFile;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TAlbumUpdateTool  = class(TUpdateTool)
  private
    FHttp: THttpCli;
    FPosition: Integer;
    FItems: TList;
    function GetItems(index: Integer): TAlbumItem;
    function GetResponseStream(const AUrl: String; AStream: TStream): Integer;
    function GetAlbumUrls(const AUrl: String; List: TStrings): Boolean;
  protected
    function GetAllSize: Integer; override;
    procedure Prepare; override;
  public
    constructor Create(AUpdateItem: TUpdateItem); override;
    destructor Destroy; override;
    function DoDownload: Boolean; override;

    property Items[index: Integer]: TAlbumItem read GetItems;
    property Size: Integer read GetAllSize;
    property Position: Integer read FPosition;
  end;

  THttpUpdateTool = class(TUpdateTool)
  private
    FHttp: THttpCli;
    FAllSize,
    FPosition: Integer;
    FDocEnded: Boolean;

    procedure BeginDocData(Sender: TObject);
    procedure DocDataRead(Sender: TObject; Buffer: Pointer; Len: Integer);
    procedure EndDocData(Sender: TObject);
  protected
    function GetAllSize: Integer; override;
  public
    constructor Create(AUpdateItem: TUpdateItem); override;
    destructor Destroy; override;
    function DoDownload: Boolean; override;
  end;

  TFtpUpdateTool = class(TUpdateTool)
  private
    FFtp: TFtpClient;
  protected
    function GetAllSize: Integer; override;
  public
    constructor Create(AUpdateItem: TUpdateItem); override;
    destructor Destroy; override;
    function DoDownload: Boolean; override;
  end;

  TBAIDUStoreUpdateTool = class(THttpUpdateTool)
  private
    FURLChecked: Boolean;
  protected
    procedure Prepare; override;
    function DoDownload: Boolean; override;
  public
    constructor Create(AUpdateItem: TUpdateItem); override;
  end;

  T360StoreUpdateTool = class(THttpUpdateTool)
  private
    FURLChecked: Boolean;
  protected
    procedure Prepare; override;
  public
    constructor Create(AUpdateItem: TUpdateItem); override;
    function DoDownload: Boolean; override;
  end;

function ParseURL(const Url: String): String;
begin
  Result  :=  StrUtils.ReplaceStr(Url, '&amp;', '&');
end;

function GetResponse(const AUrl: String; var DataString: String): Boolean;
var
  AHttp: THttpCli;
begin
  Result := False;
  try
    AHttp     :=  THttpCli.Create(nil);
    AHttp.Agent :=  'Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20100101 Firefox/8.0';
    AHttp.URL         :=  AUrl;
    AHttp.RcvdStream  :=  TStringStream.Create;
    try
      AHttp.Get;
      DataString  :=  TStringStream(AHttp.RcvdStream).DataString;
      Result      :=  AHttp.StatusCode = 200;
    except
    end;
  finally
    AHttp.RcvdStream.Free;
    AHttp.Free;
  end;
end;

{ TAlbumUpdateTool }

function TAlbumUpdateTool.GetResponseStream(const AUrl: String; AStream: TStream): Integer;
begin
  FHttp.URL         :=  AUrl;
  FHttp.RcvdStream  :=  AStream;
  FHttp.Get;
  Result      :=  FHttp.StatusCode;
end;

constructor TAlbumUpdateTool.Create(AUpdateItem: TUpdateItem);
var
  AMatch: TMatch;
begin
  inherited;
  FHttp := THttpCli.Create(nil);
  FHttp.Agent :=  'Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20100101 Firefox/8.0';
  FItems    :=  TList.Create;
end;

destructor TAlbumUpdateTool.Destroy;
var
  I: Integer;
begin
  FreeAndNil(FHttp);
  for I :=  0 to FItems.Count - 1 do
    Items[I].Free;
  FreeAndNil(FItems);
  inherited;
end;

function TAlbumUpdateTool.DoDownload: Boolean;
var
  I: Integer;
  AStream,
  FFileStream: TFileStream;
begin
  Result := False;
  BeginDownload;
  FPosition  :=  0;
  for I := 0 to FItems.Count - 1 do
  begin
    Items[I].CreateFile;
    GetResponseStream(Items[I].Url, Items[I].FileStream);
    Inc(FPosition);
    Progress(FItems.Count, FPosition);
  end;
  EndDownload;

  FFileStream :=  TFileStream.Create(FTempFileName, fmCreate);
  try
    for I := 0 to FItems.Count - 1 do
    begin
      Items[I].FileStream.Position := 0;
      WriteBitmapStreamToStream(Items[I].FileStream, FFileStream);
    end;
    FFileISOk := FFileStream.Size > 0;
  finally
    FreeAndNil(FFileStream);
  end;
  Result := True;
end;

function TAlbumUpdateTool.GetAllSize: Integer;
begin
  Result  :=  FItems.Count;
end;

function TAlbumUpdateTool.GetItems(index: Integer): TAlbumItem;
begin
  Result  :=  TAlbumItem(FItems.Items[index]);
end;

function FindValueFromResponse(const AResponse, AStartStr, AEndStr: String; var Value: String; var LastPos: Integer): Boolean;
var
  nLenStart, nPos, nEndPos: Integer;
begin
  Result := False;
  nPos := PosEx(AStartStr, AResponse, LastPos);
  if nPos > 0 then
  begin
    nLenStart := Length(AStartStr);
    nEndPos := PosEx(AEndStr, AResponse, nPos + nLenStart);
    if nEndPos > 0 then
    begin
      LastPos := nEndPos + Length(AEndStr);
      Value := Copy(AResponse, nPos + nLenStart, nEndPos - nPos - nLenStart);
      Result := True;
    end;
  end;
end;

function TAlbumUpdateTool.GetAlbumUrls(const AUrl: String; List: TStrings): Boolean;
var
  AResponse: String;
  ACode, APicUrl, APicName: String;
  AOffset: Integer;
  AUrls, ANames, ASortNames: TStringList;
  I: Integer;
begin
  Result := True;
  if GetResponse(AUrl, AResponse) then
  begin
    AOffset := 1;
    if FindValueFromResponse(AResponse, 'picSign: ''', '''', ACode, AOffset) then
    begin
      if GetResponse('http://xiangce.baidu.com/picture/detail/' + ACode, AResponse) then
      begin
        AOffset := 1;
        ANames := TStringList.Create;
        ASortNames := TStringList.Create;
        AUrls := TStringList.Create;
        try
          repeat
            if FindValueFromResponse(AResponse, '"picture_name":"', '"', APicName, AOffset) then
            begin
              ANames.Add(APicName);
            end
            else
              Break;

            if FindValueFromResponse(AResponse, '"img_src_ac":"', '"', APicUrl, AOffset) then
            begin
              APicUrl := StringReplace(APicUrl, '\', '', [rfReplaceAll]);
              AUrls.Add(APicUrl);
            end
            else
              Break;
          until False;
          Result := ANames.Count = AUrls.Count;
          if Result then
          begin
            ASortNames.Assign(ANames);
            ASortNames.Sort;
            for I := 0 to ANames.Count - 1 do
              List.Add(AUrls[ANames.IndexOf(ASortNames[I])]);
          end;
        finally
          ANames.Free;
          ASortNames.Free;
          AUrls.Free;
        end;
      end;
    end;
  end;
end;

procedure TAlbumUpdateTool.Prepare;
var
  AAlbumItem: TAlbumItem;
  List: TStrings;
  I: Integer;
begin
  List := TStringList.Create;
  try
    if GetAlbumUrls(FUpdateItem.Url, List) then
    begin
      for I := 0 to List.Count - 1 do
      begin
        AAlbumItem := TAlbumItem.Create;
        AAlbumItem.Url := StringReplace(List[I], '\', '', [rfReplaceAll]);
        FItems.Add(AAlbumItem);
      end;
    end;
  finally
    List.Free;
  end;
end;

{ TAlbumItem }

constructor TAlbumItem.Create;
begin
  FileStream  :=  nil;
end;

procedure TAlbumItem.CreateFile;
begin
  FFileName   :=  IOUtils.TPath.GetTempFileName;
  FileStream  :=  TFileStream.Create(FFileName, fmCreate);
end;

destructor TAlbumItem.Destroy;
begin
  if Assigned(FileStream) then
    FreeAndNil(FileStream);
  if FFileName<>'' then
    DeleteFile(FFileName);
  inherited;
end;

{ THttpUpdateTool }

procedure THttpUpdateTool.BeginDocData(Sender: TObject);
begin
  FAllSize  :=  FHttp.ContentLength;
end;

constructor THttpUpdateTool.Create(AUpdateItem: TUpdateItem);
begin
  inherited Create(AUpdateItem);
  FHttp :=  THttpCli.Create(nil);
  FHttp.Agent :=  'Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20100101 Firefox/8.0';
  FHttp.URL :=  AUpdateItem.Url;

  FHttp.OnDocBegin  :=  BeginDocData;
  FHttp.OnDocData   :=  DocDataRead;
  FHttp.OnDocEnd    :=  EndDocData;
end;

destructor THttpUpdateTool.Destroy;
begin
  FreeAndNil(FHttp);
  inherited;
end;

procedure THttpUpdateTool.DocDataRead(Sender: TObject; Buffer: Pointer;
  Len: Integer);
begin
  Inc(FPosition, Len);
  Progress(FAllSize, FPosition);
end;

function THttpUpdateTool.DoDownload: Boolean;
begin
  Result := False;
  FPosition :=  0;
  FHttp.RcvdStream  :=  TFileStream.Create(FTempFileName, fmCreate);
  try
    FDocEnded := False;
    try
      FHttp.Get;
      FFileISOk := FHttp.RcvdStream.Size > 0;
      Result := FFileISOk;
    except
    end;
  finally
    FHttp.RcvdStream.Free;
    FHttp.RcvdStream  :=  nil;
  end;
end;

procedure THttpUpdateTool.EndDocData(Sender: TObject);
begin
  FDocEnded := True;
end;

function THttpUpdateTool.GetAllSize: Integer;
begin
  Result  :=  FAllSize;
end;

{ TUpdateTool }

function TUpdateTool.CheckNeedUpdate: Boolean;
begin
  Result  :=  False;
  if Assigned(FCheckUpdateEvent) then
    FCheckUpdateEvent(Self.FUpdateItem, Result)
  else
  begin
    Print('正在检查：'+FUpdateItem.FileName);
    if not IOUtils.TFile.Exists(FullName) then
    begin
      Result  :=  True;
      Exit;
    end;

    if FUpdateItem.Code = '' then
    begin
      Result  :=  False;
      Exit;
    end;

    if not SameText(uMD5.MD5File(FullName), FUpdateItem.Code) then
      Result  :=  True;
  end;
end;

constructor TUpdateTool.Create(AUpdateItem: TUpdateItem);
begin
  FFileList :=  TStringList.Create;
  FTempFileName :=  IOUtils.TPath.GetTempFileName;
  FUpdateItem  :=  AUpdateItem;
  FFileISOk := False;
  FDeleteTempFile := True;
end;

class function TUpdateTool.CreateTool(AUpdateItem: TUpdateItem): TUpdateTool;
begin
  Result := nil;
  case AUpdateItem.DownKind of
    TupDownKind.dkHttp: Result  :=  THttpUpdateTool.Create(AUpdateItem);
    TupDownKind.dkFtp: Result  :=  TFtpUpdateTool.Create(AUpdateItem);
    TupDownKind.dkAlbum: Result  :=  TAlbumUpdateTool.Create(AUpdateItem);
    TupDownKind.dkBAIDUNetDisk: Result  :=  TBAIDUStoreUpdateTool.Create(AUpdateItem);
    TupDownKind.dt360NetDisk: Result := T360StoreUpdateTool.Create(AUpdateItem);
  end;
end;

procedure TUpdateTool.DeleteFile;
begin
  if (FTempFileName<>'') and IOUtils.TFile.Exists(FTempFileName) then
    IOUtils.TFile.Delete(FTempFileName);
end;

destructor TUpdateTool.Destroy;
begin
  if FDeleteTempFile then
    DeleteFile;
  FreeAndNil(FFileList);
  inherited;
end;

procedure TUpdateTool.DoRARListFile(Sender: TObject;
  const FileInformation: TRARFileItem);
begin
  FFileList.Add(FileInformation.FileNameW);
end;

procedure TUpdateTool.BeginDownload;
begin
  if Assigned(FOnBegin) then
    FOnBegin(Self.FUpdateItem);
end;

procedure TUpdateTool.EndDownload;
begin
  if Assigned(FOnEnd) then
    FOnEnd(Self.FUpdateItem);
end;

procedure TUpdateTool.Progress(ACount, APosition: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self.FUpdateItem, ACount, APosition);
end;

procedure TUpdateTool.Print(const Value: String);
begin
  if Assigned(FOnPrint) then
    FOnPrint(Self.FUpdateItem, Value);
end;

procedure TUpdateTool.Download;
begin
  if CheckNeedUpdate then
  begin
    Print('正在更新：'+FUpdateItem.FileName);
    Prepare;
    if DoDownload then
    begin
      Print('更新完成：'+FUpdateItem.FileName);
      Setup;
    end
    else
      Print('更新失败：'+FUpdateItem.FileName);
  end;
end;

procedure TUpdateTool.Prepare;
begin
end;

procedure TUpdateTool.Setup;
var
  ARar: TRar;
  I: Integer;
  APath: String;
begin
  if not FFileISOk then Exit;

  if not ((FTempFileName<>'') and IOUtils.TFile.Exists(FTempFileName)) then Exit;

  APath := FullPath;
  if not IOUtils.TDirectory.Exists(APath) then
    IOUtils.TDirectory.CreateDirectory(APath);

  if not FUpdateItem.Zip then
  begin
    if IOUtils.TFile.Exists(APath + FUpdateItem.FileName) then
      IOUtils.TFile.Delete(APath + FUpdateItem.FileName);
    IOUtils.TFile.Copy(FTempFileName, APath + FUpdateItem.FileName);
    Exit;
  end;

  ARar  :=  TRar.Create(nil);
  ARar.DllName    :=  FRARDLLFile;
  ARar.OnListFile :=  DoRARListFile;
  try
    if ARar.OpenFile(FTempFileName) then
    begin
      FExtractPath  :=  IncludeTrailingPathDelimiter(IOUtils.TPath.GetTempPath) + IOUtils.TPath.GetGUIDFileName + '\';
      ARar.Extract(FExtractPath, True, nil);
      for I :=  0 to FFileList.Count - 1 do
      begin
        if IOUtils.TFile.Exists(APath + FFileList.Strings[I]) then
          IOUtils.TFile.Delete(APath + FFileList.Strings[I]);
        IOUtils.TFile.Copy(
          FExtractPath + FFileList.Strings[I],
          APath + FFileList.Strings[I]
        );
        IOUtils.TFile.Delete(FExtractPath + FFileList.Strings[I]);
      end;
      IOUtils.TDirectory.Delete(FExtractPath, True);
    end;
  finally
    FreeAndNil(ARar);
  end;
end;

procedure TUpdateTool.ExtractFiles(List: TStrings);
var
  ARar: TRar;
  I: Integer;
begin
  if not FUpdateItem.Zip then
  begin
    FExtractPath := IncludeTrailingPathDelimiter(ExtractFilePath(FTempFileName));
    List.Add(FTempFileName);
  end
  else
  begin
    ARar := TRar.Create(nil);
    ARar.DllName    :=  FRARDLLFile;
    ARar.OnListFile :=  DoRARListFile;
    try
      if ARar.OpenFile(AnsiString(FTempFileName)) then
      begin
        FExtractPath := IncludeTrailingPathDelimiter(IOUtils.TPath.GetTempPath) + IOUtils.TPath.GetGUIDFileName + '\';
        ARar.Extract(FExtractPath, True, nil);
        for I :=  0 to FFileList.Count - 1 do
          List.Add(FExtractPath + FFileList.Strings[I]);
      end;
    finally
      FreeAndNil(ARar);
    end;
  end;
end;

function TUpdateTool.GetFullName: String;
begin
  Result := GetFullPath + FUpdateItem.FileName;
end;

function TUpdateTool.GetFullPath: String;
var
  APath: String;
begin
  APath := IncludeTrailingPathDelimiter(FUpdateItem.Path);
  if (APath <> '') and (APath[1] = '$') then
  begin
    Delete(APath, 1, 1);
    APath := IncludeTrailingPathDelimiter(FResourcePath) + APath;
  end
  else if (Length(APath) >= 2) and (APath[1] = '.') and (APath[2] = '\') then
  begin
    Delete(APath, 1, 2);
  end;
  Result := IncludeTrailingPathDelimiter(FHomePath) + APath;
  Result := StringReplace(Result, '\\', '\', [rfReplaceAll]);
end;

{ TFtpUpdateTool }

constructor TFtpUpdateTool.Create(AUpdateItem: TUpdateItem);
begin
  inherited;
  FFtp  :=  TFtpClient.Create(nil);
end;

destructor TFtpUpdateTool.Destroy;
begin
  FreeAndNil(FFtp);
  inherited;
end;

function TFtpUpdateTool.DoDownload: Boolean;
begin
  Result := False;
end;

function TFtpUpdateTool.GetAllSize: Integer;
begin

end;

{ TUpdateManager }

constructor TUpdateManager.Create(AServerInfo: TServerInfo);
begin
  FServerInfo   :=  AServerInfo;
end;

function TUpdateManager.CreateUpdateTool(AUpdateItem: TUpdateItem): TUpdateTool;
begin
  case AUpdateItem.DownKind of
    TupDownKind.dkHttp: Result  :=  THttpUpdateTool.Create(AUpdateItem);
    TupDownKind.dkFtp: Result  :=  TFtpUpdateTool.Create(AUpdateItem);
    TupDownKind.dkAlbum: Result  :=  TAlbumUpdateTool.Create(AUpdateItem);
    TupDownKind.dkBAIDUNetDisk: Result  :=  TBAIDUStoreUpdateTool.Create(AUpdateItem);
    TupDownKind.dt360NetDisk: Result := T360StoreUpdateTool.Create(AUpdateItem);
  end;
  if Result <> nil then
  begin
    Result.FHomePath := IncludeTrailingPathDelimiter(FHomePath);
    Result.FResourcePath := IncludeTrailingPathDelimiter(FServerInfo.ResFolder);
    Result.RARDLLFile := Self.FRARDLLFile;
    Result.OnBegin := DoBegin;
    Result.OnEnd := DoEnd;
    Result.OnProgress := DoProgress;
    Result.OnPrint := DoPrint;
  end;
end;

destructor TUpdateManager.Destroy;
begin
  inherited;
end;

procedure TUpdateManager.DoBegin(AUpdateItem: TUpdateItem);
begin
  if Assigned(FOnBeginUpdateItem) then
    FOnBeginUpdateItem(AUpdateItem, FActiveItem.Size);
end;

procedure TUpdateManager.DoEnd(AUpdateItem: TUpdateItem);
begin
  if Assigned(FOnEndUpdateItem) then
    FOnEndUpdateItem(AUpdateItem, FActiveItem.Size);
end;

procedure TUpdateManager.DoPrint(AUpdateItem: TUpdateItem; const Value: String);
begin
  if Assigned(FOnPrint) then
    FOnPrint(AUpdateItem, Value);
end;

procedure TUpdateManager.DoFileBegin;
begin
  if Assigned(FOnFileBegin) then
    FOnFileBegin(Self);
end;

procedure TUpdateManager.DoFileEnd;
begin
  if Assigned(FOnFileEnd) then
    FOnFileEnd(Self);
end;

procedure TUpdateManager.DoProgress(AUpdateItem: TUpdateItem; AllSize, APosition: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(FActiveItem.FUpdateItem, AllSize, APosition);
end;

procedure TUpdateManager.Download;
var
  I: Integer;
begin

  for I :=  0 to FServerInfo.UpdateItems.Count - 1 do
  begin
    if FServerInfo.UpdateItems.Items[I].Enable then
    begin
      DoFileBegin;
      FActiveItem :=  CreateUpdateTool(FServerInfo.UpdateItems.Items[I]);
      try
        try
          FActiveItem.Download;
        except
        end;
      finally
        FreeAndNil(FActiveItem);
      end;
      DoFileEnd;
    end;
  end;
end;

procedure TUpdateManager.DownloadBy(ADownType: TutDownType);
var
  I: Integer;
begin
  for I :=  0 to FServerInfo.UpdateItems.Count - 1 do
  begin
    if FServerInfo.UpdateItems.Items[I].Enable then
    begin
      if FServerInfo.UpdateItems[I].DownType = ADownType then
      begin
        DoFileBegin;
        FActiveItem :=  CreateUpdateTool(FServerInfo.UpdateItems.Items[I]);
        try
          try
            FActiveItem.Download;
          except
          end;
        finally
          FreeAndNil(FActiveItem);
        end;
        DoFileEnd;
      end;
    end;
  end;
end;

{ TBAIDUStoreUpdateTool }

constructor TBAIDUStoreUpdateTool.Create(AUpdateItem: TUpdateItem);
begin
  inherited;
  FURLChecked :=  False;
end;

function TBAIDUStoreUpdateTool.DoDownload: Boolean;
begin
  Result := False;
  if FURLChecked then
    Result := inherited
  else
    Print(FUpdateItem.FileName + '下载失败');
end;

procedure TBAIDUStoreUpdateTool.Prepare;
var
  AResponse: String;
  APos, ALen: Integer;
  AUrl: String;
  C: Char;
begin
  if GetResponse(FUpdateItem.Url, AResponse) then
  begin
    APos := Pos('\"dlink\":\"', AResponse);
    if APos > 0 then
    begin
      APos := APos + Length('\"dlink\":\"');
      ALen := Length(AResponse);
      AUrl := '';
      while APos < ALen do
      begin
        C := AResponse[APos];
        if C <> '"' then
          AUrl := AUrl + C
        else
          Break;
        Inc(APos);
      end;
      FUpdateItem.Url := StringReplace(AUrl, '\\', '', [rfReplaceAll]);
      FHttp.URL := FUpdateItem.Url;
      FURLChecked := True;
    end;
  end;
end;

{ T360StoreUpdateTool }

constructor T360StoreUpdateTool.Create(AUpdateItem: TUpdateItem);
begin
  inherited;
  FURLChecked :=  False;
end;

function T360StoreUpdateTool.DoDownload: Boolean;
begin
  Result := False;
  if FURLChecked then
    Result := inherited
  else
    Print(FUpdateItem.FileName + '下载失败');
end;

procedure T360StoreUpdateTool.Prepare;

  function GtJSField(const Html: String; const StartStr, EndStr: String): String;
  var
    nPos, nEnd: Integer;
    C: Char;
  begin
    Result := '';
    nPos := PosEx(StartStr, Html);
    if nPos > 0 then
    begin
      nEnd := PosEx(EndStr, Html, nPos + Length(StartStr));
      if nEnd > 0 then
        Result := Copy(Html, nPos + Length(StartStr), nEnd - nPos - Length(StartStr));
    end;
  end;

var
  AResponse: String;
  SUrl, SCode: String;
begin
  if GetResponse(FUpdateItem.Url, AResponse) then
  begin
    SUrl := GtJSField(AResponse, 'surl : ''', ''',');
    SCode := GtJSField(AResponse, 'nid : ''', ''',');
    if (SUrl <> '') and (SCode <> '') then
    begin
      if GetResponse('http://aj2dw893ji.l29.yunpan.cn/share/downloadfile?nid='+SCode+'&shorturl='+SUrl, AResponse) then
      begin
        SUrl := GtJSField(AResponse, 'downloadurl":"', '"');
        if SUrl <> '' then
        begin
          SUrl := StringReplace(SUrl, '\', '', [rfReplaceAll]);
          FHttp.URL := SUrl;
          FURLChecked := True;
        end;
      end;
    end;
  end;
end;

end.
