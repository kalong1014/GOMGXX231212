(* 微端资源下载器 *)
// 一路随云 2016，1，2

unit uMiniResDownloader;

interface
{.$DEFINE USENAMEPIPE}
uses
  Classes, SysUtils, ListEx, SyncObjs, IdComponent, uSocket, uCommon,
  OverbyteIcsWSocketS, uLog, uEDCode, Share, rtcConn, rtcDataCli,
  OverbyteIcsHttpProt, Math, WzlMerge, uGameEngine, Generics.Collections,
  uMiniResFileInfo, HUtil32, EDcode, Windows, uSyncObj,
{$IFDEF USENAMEPIPE}
PipeServer,
{$ENDIF}
uTypes,ScktCompSY,IOUtils,
{$IFDEF MINI_INDY}
IdException,IdHTTP;
{$ELSE}
rtcHttpCli;
{$ENDIF}

{$DEFINE DEBUGDOWNLOADER}

const
  PART_CHK_CODE = $CCFFEEDD; //分割部分的验证码
  CL_CLIENTOPEN  = 10000;
  CL_CLIENTCLOSE = 10001;
  CL_RES_REQUST = 10002;
  CL_RES_NEWFILE = 10003;
  CL_RES_IMGDOWNLOADED = 10004;
  CL_RES_FILEDOWNLOADED = 10005;
  CL_RES_UPDATEFILE = 10006;//通知所有客户端有图片文件需要更新。

type
   //客户端文件锁定的结构体
   PTLockFileState = ^TLockFileState;
   TLockFileState = record
     FileName:string[200]; //锁定的文件
     ClientState:Integer;//解锁客户端的状态。
     LockTime:Cardinal;
   end;

   //下载成功或者失败的事件
   TDownloadEventType = (deSucess,deFail);

   //等待合并的事件
   TWaitMergeEvent = record
     Stream:TMemoryStream;
     FileName:string[200];
   end;
   pTWaitMergeEvent = ^TWaitMergeEvent;

   TClientSession = class
     SocektData:AnsiString;
     ClientNumber:Integer;
   constructor Create();
   destructor Destroy; override;

   end;

   TDownLoader = class;
   TDownLoaderManager = class(TThread)
   private
     m_sResSite :string; //资源地址
     m_WorkerList : TList ; //工作的线程对象表
     m_RecentDownloing : TDictionary<String,Cardinal>; //最近下载的文件
     m_WaitingForDownLoad : TDoubleList; //等待下载的列表
     m_LockFileList:TGList;// <PTLockFileState>//禁止更新的文件列表。 等待客户端返回后删除 。
     m_WaitMergerFileList:TDoubleList; // 等待合并的文件列表。 当文件被禁止更新后 。临时文件将会被保存下来等待合并。
//     m_RecvMsgList : TDoubleList; //收到的消息
     {$IFDEF USENAMEPIPE}
     m_LocalServer : TNamedPipeServer;
     {$ELSE}
     m_LocalServer: TuServerSocket;
     {$ENDIF}
     //成功下载完成的列表 主要用于 Debug 是否会将成功的下载的再次下载
     //正式发行版本 不会对这个列表加入记录
     {$IFDEF DEBUGDOWNLOADER}
     m_DownLoadDoneList : TStringList;
     {$ENDIF}
     m_ResVerPack: TMiniResFilePackage;
     m_Password : String;
     m_ClientFlag : Integer;
     m_boWorking:Boolean; //是否在工作
     m_boSocketWork:Boolean;//是否Socket在工作
     m_LastProcessRecentTime:Cardinal;
     m_LoopTimeMax:Cardinal;
     m_MaxProcessMsgTime,
     m_MaxProcessDownloadListTime,
     m_MaxProcessUnlockListTime,
     m_MaxProcessRecentListTime:Cardinal;
     m_MergeFileThread:TThread; //合并文件线程
     m_SocketBuffer:AnsiString;
     m_TempSocketBuffer:AnsiString;
     m_EncodeRequestSize:Integer;
     m_ClientList : TGList;
     m_LastProcessUnLockTime:Cardinal; //上次执行解锁文件的 时间
     m_SocketSendLock : TFixedCriticalSection;
     function  FindIdleWork(boImportant:Boolean):TDownLoader; //找到一个空闲的下载线程
     function GetClientCount():Integer;
     function GetLocalServerPort:Word;
     function IsLocked(const FileName:String):Boolean; //检查文件是否被锁定。加了锁
     function FileIsLockeStatic(const FileName:String):Boolean; //检查文件是否被锁定 没有加锁
     procedure Merge(const FileName:String;Stream:TStream;Part:Integer);
   protected
     procedure Execute();override;
     procedure ProcessRecvMsg(); //处理收到的消息
     procedure ProcessDownLoadList();//处理待下载的列表

     procedure ProcessUnLockList(); //处理等待解锁的文件列表。
     procedure ProcessRecentList(); //处理最近下载过的文件超过30秒就清掉

     //这条是文件操作线程 单独的 和其他事件的线程不一样
     procedure ProcessWaitMergeList(); //处理等待合并文件的列表。

     function GetWorker(n:Integer):TDownLoader;
     function GetWorkCount : Integer;
     procedure OnClientDataAvailable(Sender: TObject;Socket: TCustomWinSocket);
     procedure OnClientConnected(Sender: TObject;Socket: TCustomWinSocket);
     procedure OnClientDisConnected(Sender: TObject;Socket: TCustomWinSocket);
      procedure OnRequestDownLoadSoundFile(PRequest:PTMiniResRequest); //请求下载声音文件。
     procedure OnRequestDownLoadImageFile(PRequest:PTMiniResRequest); //请求下载图片文件
     procedure OnRequestClientUpdataSuecess(Client: TCustomWinSocket; PRequest:PTMiniResRequest); //客户端通知解锁文件完毕。可以进行解锁了
     procedure OnClientSocketError(Sender: TObject; Socket: TCustomWinSocket;ErrorEvent: TErrorEvent; var ErrorCode: Integer);
     procedure OnFileDownLoadEvent(Event:TDownloadEventType;PRequest: PTMiniResRequest ; Stream :TMemoryStream); //所有下载完成事件都通过这里来调用
   public
     m_RecvMsgList : TDoubleList; //收到的消息
     constructor Create();
     destructor Destroy();override;

     //初始化下载器 资源地址,开启下载器的线程数量
     procedure StartWork(ThreadCount : Integer ; ImportantThreadCount:Integer);

     procedure StartSocekt();

     procedure BoardCastIdent(IDent:Integer);overload;
     procedure BoardCastIdent(IDent:Integer ; FileName:String);overload;
     procedure StopAllWorker;
     procedure LoadResVerPackFromFile(const FileName:String);
     procedure LoadResVerPackFromStream(Stream:TStream); //读取微端客户端文件的描述

     function IsResVerFileRead():Boolean; //微端配置文件是否读取了。
     property Worker[n:Integer] : TDownLoader read GetWorker;
     property WorkerCount : Integer read GetWorkCount;
     property Port:Word  read GetLocalServerPort;
     property ClientCount :Integer read GetClientCount;
     property PassWord:String read m_Password write m_Password;
     property ResURL:String read m_sResSite write m_sResSite;
     property SocketStart:Boolean read m_boSocketWork;
   end;


   TDownLoader = class(TThread)
   private
     {$IFDEF MINI_INDY}
     m_IDHttp : TIdHTTP;
     {$ELSE}
     m_HttpCli: THttpCli;
     {$ENDIF}
     m_Owner  : TDownLoaderManager;
     m_DownLoadInfo:PTMiniResRequest;
     m_nFileSize : Integer;//总文件大小
     m_nProgress :Integer; //进度 万分比
     m_sFileName : ShortString;
     m_boImportant:Boolean; //是否重要 重要线程优先给重要的 不是重要的不处理。
   protected
     procedure execute();override;
     procedure ProcessDownLoad(PRequest:PTMiniResRequest );

     {$IF CompilerVersion >= 20.0}
       procedure OnWork(ASender: TObject; AWorkMode: TWorkMode;
                AWorkCount: Int64);
     {$ELSE}
       procedure OnWork(ASender: TObject; AWorkMode: TWorkMode;
                AWorkCount: Integer);
     {$IFEND}

     {$IF CompilerVersion >= 20.0}
     procedure OnWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
                AWorkCountMax: Int64);
     {$ELSE}
     procedure OnWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
                AWorkCountMax: Integer);
     {$IFEND}
     function GetProgress:Integer; //获取下载进度 万分比;
   public
     constructor Create(Owner:TDownLoaderManager);
     destructor Destroy;override;
     procedure SetDownLoad(PRequest:PTMiniResRequest);
     function IsIdle : Boolean;
     procedure StopWork;
     property Progress : Integer  read  GetProgress;
     property FileName : ShortString read m_sFileName;
     property Important : Boolean read m_boImportant write m_boImportant;
   end;
procedure ResDownLoadLog(S:String;B:Byte = 1);
function GetResDownLoader : TDownLoaderManager;
implementation
uses ZLib  , Messages,MMSystem;

function GetRandPort: Integer;
var
  nPort: Integer;
begin
  Result := 9999;
  repeat
    Inc(Result);
  until not PortInUse(Result);
end;


procedure UnCompressionStream(var ASrcStream: TMemoryStream); //解压缩
var
  nTmpStream: TDecompressionStream;
  nDestStream: TMemoryStream;
  nBuf: array[1..512] of Byte;
  nSrcCount: integer;
begin
  ASrcStream.Position := 0;
  nDestStream := TMemoryStream.Create;
  nTmpStream := TDecompressionStream.Create(ASrcStream);
  try
    repeat
      //读入实际大小
      nSrcCount := nTmpStream.Read(nBuf, SizeOf(nBuf));
      if nSrcCount > 0 then
        nDestStream.Write(nBuf, nSrcCount);
    until (nSrcCount = 0);
    ASrcStream.Clear;
    ASrcStream.LoadFromStream(nDestStream);
    ASrcStream.Position := 0;
  finally
    nDestStream.Clear;
    nDestStream.Free;
    nTmpStream.Free;
  end;
end;

var
    g_ResDownLoader : TDownLoaderManager;
function GetResDownLoader : TDownLoaderManager;
begin
  if g_ResDownLoader = nil then
    g_ResDownLoader := TDownLoaderManager.Create();

  Result := g_ResDownLoader;
end;

var
  LogLock : TFixedCriticalSection;
procedure ResDownLoadLog(S:String;B:Byte = 1); //如果B  > 3说明调试信息是明显的要注意
var
  flname: string;
  fhandle: TextFile;
begin
  Exit;
  {$IFDEF DEBUG}

  {$ELSE}
    if B > 3 then
    Exit;
  {$ENDIF}
  if LogLock = nil then
    LogLock := TFixedCriticalSection.Create;
  LogLock.Enter;
  Try
    flname := '.\MiniClientLog.txt';
    if FileExists(flname) then
    begin
      AssignFile(fhandle, flname);
      Append(fhandle);
    end else begin
      AssignFile(fhandle, flname);
      Rewrite(fhandle);
    end;
    Writeln(fhandle,Format('[%s] %s' , [DateTimeToStr(Now),S]));
    CloseFile(fhandle);
  Finally
    LogLock.Leave;
  End;
end;
{ TResDownLoader }

procedure TDownLoaderManager.BoardCastIdent(IDent: Integer);
begin
  BoardCastIdent(IDent,'');
end;

procedure TDownLoaderManager.BoardCastIdent(IDent: Integer; FileName: String);
var
  AResponse: TMiniResResponse;
  SockData:AnsiString;
  I:Integer;
begin
  if m_LocalServer <> nil then
  begin
    m_SocketSendLock.Enter;
    Try
      AResponse.Ident := Ident;
      AResponse.FileName := FileName;
      SockData :=  '#' + EncodeBuffer(PAnsiChar(@AResponse),SizeOf(AResponse)) + '!';

      for I := 0 to m_LocalServer.ClientCount - 1 do
      m_LocalServer.Client[I].SendText(SockData);
    Finally
      m_SocketSendLock.Leave;
    End;
  end;
end;

constructor TDownLoaderManager.Create();
var
  S:AnsiString;
  ARequest:TMiniResRequest;
begin
  inherited Create(True);
  m_WorkerList := TList.Create;
  m_WaitingForDownLoad := TDoubleList.Create;
  m_DownLoadDoneList := TStringList.Create;
  m_LockFileList := TGlist.Create;
  m_ResVerPack := TMiniResFilePackage.Create;
  m_WaitMergerFileList := TDoubleList.Create;
  m_RecentDownloing := TDictionary<String,Cardinal>.Create;
  S := EncodeBuffer(PAnsiChar(@ARequest),SizeOf(ARequest));
  m_EncodeRequestSize := Length(S);
  S := '';
  m_ClientList := TGList.Create;
  m_RecvMsgList := TDoubleList.Create;
  m_SocketSendLock := TFixedCriticalSection.Create;

end;

destructor TDownLoaderManager.Destroy;
var
 i : Integer;
 PRequest : PTMiniResRequest;
 PLockState:PTLockFileState;
begin
  Terminate;
  Start;
  WaitFor;

  //释放工作线程
  for I := 0 to m_WorkerList.Count - 1 do
  begin
    TDownLoader(m_WorkerList[i]).Free;
  end;
  m_WorkerList.Free;

  //释放等待下载信息
  m_WaitingForDownLoad.Flush;
  Try
    for I := 0 to m_WaitingForDownLoad.Count - 1 do
    begin
      PRequest :=  PTMiniResRequest(m_WaitingForDownLoad[i]);
      Dispose(PRequest);
    end;
  Finally
    m_WaitingForDownLoad.Free;
  End;

  m_LockFileList.Lock;
  Try
    for i := 0 to m_LockFileList.Count - 1 do
    begin
      PLockState := m_LockFileList[i];
      Dispose(PLockState);
    end;
  Finally
     m_LockFileList.UnLock;
  End;


  m_ClientList.Lock;
  try
    for I := 0 to m_ClientList.Count - 1 do
    begin
      TClientSession(m_ClientList[i]).Free;
    end;
  finally
    m_ClientList.UnLock;
  end;
  m_ClientList.Free;

  m_RecvMsgList.Flush;
  Try
    for I := 0 to m_RecvMsgList.Count - 1 do
    begin
      PRequest :=  PTMiniResRequest(m_RecvMsgList[i]);
      Dispose(PRequest);
    end;
  Finally
    m_RecvMsgList.Free;
  End;
  m_SocketSendLock.Free;
  m_LockFileList.Free;
  m_DownLoadDoneList.Free;
  m_RecentDownloing.Free;
  m_WaitMergerFileList.Free;
  m_ResVerPack.Free;
  m_LocalServer.Free;
  ResDownLoadLog('=====微端下载器工作结束===== OneLoopMaxTime:' + IntToStr(m_LoopTimeMax),1);

 ResDownLoadLog( Format('m_MaxProcessMsgTime:%d , m_MaxProcessDownloadListTime:%d , m_MaxProcessUnlockListTime : %d , m_MaxProcessRecentListTime : %d',
  [
        m_MaxProcessMsgTime,
        m_MaxProcessDownloadListTime,
        m_MaxProcessUnlockListTime,
        m_MaxProcessRecentListTime]),1);



  inherited;
end;

procedure TDownLoaderManager.Execute;
var
  StartTick:Cardinal;
  ProcessMsgTime,ProcessDownloadListTime,ProcessUnlockListTime,ProcessRecentListTime:Cardinal;
  ProcessMsgTick,ProcessDownloadListTick,ProcessUnlockListTick : Cardinal;
begin
  inherited;
  while not Terminated  do
  begin
    StartTick := TimeGetTime;
    try
      //处理收到的消息
      ProcessRecvMsg;
      ProcessMsgTick := TimeGetTime;
      ProcessMsgTime := ProcessMsgTick - StartTick;

      //处理将要下载的列表
      ProcessDownLoadList;
      ProcessDownloadListTick := TimeGetTime;
      ProcessDownloadListTime := ProcessDownloadListTick - ProcessMsgTick;

      //处理等待解锁的列表
      ProcessUnLockList;
      ProcessUnlockListTick := TimeGetTime;
      ProcessUnlockListTime := ProcessUnlockListTick - ProcessDownloadListTick;

      //处理解锁
      ProcessRecentList;
      ProcessRecentListTime := TimeGetTime - ProcessUnlockListTick;
      StartTick := TimeGetTime - StartTick;

      if StartTick > m_LoopTimeMax then
      begin
        m_LoopTimeMax := StartTick;
        m_MaxProcessMsgTime := ProcessMsgTime;
        m_MaxProcessDownloadListTime := ProcessDownloadListTime;
        m_MaxProcessUnlockListTime := ProcessUnlockListTime;
        m_MaxProcessRecentListTime:= ProcessRecentListTime;
      end;
    except

    end;
    Sleep(1);
  end;
end;

function TDownLoaderManager.FindIdleWork(boImportant:Boolean):TDownLoader;
var
  i : Integer;
begin
  Result := nil;
  if boImportant then
  begin
    //重要事情 优先使用重要的 下载器 如果重要的下载器 不够 可以用普通的下载器。
    for i := m_WorkerList.Count - 1 downto 0 do
    begin
      if (TDownLoader(m_WorkerList[i]).IsIdle) then
      begin
        Result :=  TDownLoader(m_WorkerList[i]);
        Break;
      end;
    end;
  end else
  begin
    //普通的事情只能用跟普通的工作者
    for i := 0 to m_WorkerList.Count - 1 do
    begin
      if (TDownLoader(m_WorkerList[i]).Important = boImportant) then
      begin
        if (TDownLoader(m_WorkerList[i]).IsIdle) then
        begin
          Result :=  TDownLoader(m_WorkerList[i]);
          Break;
        end;
      end else
        break;
    end;
  end;

end;

function TDownLoaderManager.GetClientCount: Integer;
begin
  Result := 0;
  if m_LocalServer <> nil then
    Result := m_LocalServer.ClientCount;
end;

function TDownLoaderManager.GetLocalServerPort: Word;
begin
  Result := m_LocalServer.Port;
end;

function TDownLoaderManager.GetWorkCount: Integer;
begin
  Result := m_WorkerList.Count - 1;
end;

function TDownLoaderManager.GetWorker(n: Integer): TDownLoader;
begin
  Result := nil;
  if (n>= 0) and (n < m_WorkerList.Count ) then
  begin
    Result := m_WorkerList.Items[n];
  end;
end;

procedure TDownLoaderManager.StartSocekt;
begin
  m_LocalServer := TuServerSocket.Create(nil);
  m_LocalServer.OnClientRead := OnClientDataAvailable;
  m_LocalServer.OnClientDisconnect := OnClientDisConnected;
  m_LocalServer.OnClientConnect := OnClientConnected;
  m_LocalServer.OnClientError := OnClientSocketError;
  m_LocalServer.Address := '127.0.0.128';
  {$IFDEF DEBUG}
  m_LocalServer.Port := 10555;
  {$ELSE}
  m_LocalServer.Port := GetRandPort;
  {$ENDIF}
  try
    m_LocalServer.Active := True;;
    m_boSocketWork := True;
  except
    on E: Exception do
    begin
      uLog.TLogger.AddLog(uEDCode.DecodeSource('Y1CTZ79B1G1v/6KJ4AV3A+yJTJyqwRkVQ8pAlxvtYevTZyDaTM5luk0D') + E.Message);  //开启本地TCP服务失败,错误信息:
      m_LocalServer.Free;
    end;
  end;
end;

procedure TDownLoaderManager.StartWork(ThreadCount : Integer ; ImportantThreadCount:Integer);
var
  Worker : TDownLoader;
  i : Integer;
begin
  for i := 0 to ThreadCount - 1 do
  begin
    Worker := TDownLoader.Create(Self);
    Worker.Important := False;
    m_WorkerList.Add(Worker);
  end;

  for i := 0 to ImportantThreadCount - 1 do
  begin
    Worker := TDownLoader.Create(Self);
    Worker.Important := True;
    m_WorkerList.Add(Worker);
  end;




  m_MergeFileThread := TThread.CreateAnonymousThread( procedure ()
  begin
   while not Terminated do
   begin
     Try
       ProcessWaitMergeList();
       Sleep(1);
     Except
       on E:Exception do
       begin
         ResDownLoadLog('ProcessWaitMergeList Error .' + E.Message);
       end;
     End;
   end;
  end  );

  m_MergeFileThread.Start;
  ResDownLoadLog(Format('==微端开始工作, 线程ID: %d  线程数量:%d==',[ Self.ThreadID,ThreadCount]));
  ResDownLoadLog('====微端下载地址:' + m_sResSite + '========',5);
  Start;
  m_boWorking := True;
end;

function TDownLoaderManager.IsLocked(const FileName: String): Boolean;
var
  I : Integer;
  PLockState: PTLockFileState;
begin
  m_LockFileList.Lock;
  Try
    Result := FileIsLockeStatic(FileName)
  Finally
    m_LockFileList.Unlock;
  End;
end;

function TDownLoaderManager.FileIsLockeStatic(const FileName: String): Boolean;
var
  I : Integer;
  PLockState: PTLockFileState;
begin
  Result := False;
  for i := 0 to m_LockFileList.Count - 1 do
  begin
    PLockState := m_LockFileList[i];
    if PLockState.FileName = FileName then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TDownLoaderManager.IsResVerFileRead: Boolean;
begin
  Result := m_ResVerPack.Inited;
end;

procedure TDownLoaderManager.LoadResVerPackFromFile(const FileName: String);
begin
  m_ResVerPack.LoadPackageFromFile(FileName,m_Password);
end;

procedure TDownLoaderManager.LoadResVerPackFromStream(Stream: TStream);
begin
  m_ResVerPack.LoadPackageFromStream(Stream,m_Password);
  if not m_ResVerPack.Inited then
    ResDownLoadLog('无法解压微端描述文件。可能是密码错误？',1);
end;

procedure TDownLoaderManager.Merge(const FileName:String;Stream:TStream;Part:Integer);
var
  Ext:String;
  HashFile:String;
  PartInfo:TImageFilePartInfo;
  DataHeaderStream: TMemoryStream;
  nStartIndex,nEndIndex:Integer;
  PlockState : PTLockFileState;
begin
   ResDownLoadLog(Format('开始合并文件 : %s ,Part : %d ',[FileName,Part]),4);
   DataHeaderStream := nil;

   if Part <> -1 then
   begin
     HashFile := UpperCase(ChangeFileExt(FileName,''));  //TODO
     if m_ResVerPack.TryGetImagePartInfo(HashFile,PartInfo) then
     begin
       if PartInfo.Format = wDATA then
       begin
         DataHeaderStream := TMemoryStream.Create;
         PartInfo.writeDataHeader(DataHeaderStream);
       end;

       if PartInfo.GetPartIndex(Part,nStartIndex,nEndIndex) then
       begin
         if DoMerge(FileName,nStartIndex,nEndIndex,PartInfo.ImageCount,PartInfo.Format,Stream,DataHeaderStream) then
         begin
           //加入等待解锁列表
           New(PlockState);
           PlockState.ClientState := 0;
           PlockState.LockTime := GetTickCount();
           PlockState.FileName := FileName;
           //因为合并的操作外部已经对m_LockFileList 加锁了 所以没必要再枷锁
           m_LockFileList.Add(PlockState);
           if DataHeaderStream <> nil then
             DataHeaderStream.Free;

           ResDownLoadLog('合并文件完成 : ' + FileName);
         end;
         PartInfo.PartState[Part] := PsOk;
         //合并完后通知客户端进行更新
         BoardCastIdent(CL_RES_UPDATEFILE,FileName);
       end;
     end else
     begin
       ResDownLoadLog('合并文件失败 : ' + FileName + ', 微端版本信息不存在此文件信息');
     end;
   end;
end;

procedure TDownLoaderManager.OnFileDownLoadEvent(Event:TDownloadEventType;PRequest: PTMiniResRequest ; Stream :TMemoryStream);
var
  sFileName  : string;
  CompressMem : TMemoryStream;
  PartInfo:TImageFilePartInfo;
  nPart:Integer;
  FilePath:String;
  PMegerEvent:pTWaitMergeEvent;
begin
  if Event = deSucess then
  begin
     ResDownLoadLog('下载完毕:' + PRequest.FileName );
    {$IFDEF DEBUGDOWNLOADER}
     m_DownLoadDoneList.Add(PRequest.FileName);
    {$ENDIF}

    if PRequest._Type = 0 then
    begin
      sFileName := GetImageFileHashKeyName(PRequest.FileName);
      if  m_ResVerPack.TryGetImagePartInfo(sFileName,PartInfo) then
      begin
        New(PMegerEvent);
        PMegerEvent.FileName := PRequest.FileName;
        PMegerEvent.Stream := Stream;
        m_WaitMergerFileList.Append(PMegerEvent);
        ResDownLoadLog('加入等待合并列表:' + PRequest.FileName );

        nPart := PartInfo.GetIndexPart(PRequest.Index);
        if nPart >= 0 then
          PartInfo.PartState[nPart] := PsMerge;
      end;
      Dispose(PRequest);
    end else
    begin
      //非图片数据保存到文件即可。
      CompressMem := TMemoryStream.Create;
      try
        Stream.Position := 36; // 4 CheckCode | 32字节MD5 | 压缩的原始数据
        CompressMem.CopyFrom(Stream,Stream.Size - 36);
        UnCompressionStream(CompressMem);
        sFileName := PRequest.FileName;
        Delete(sFileName,Length(sFileName) - 1,2);
        if FileExists(sFileName) then
        begin
          ResDownLoadLog(Format('文件已存在:%s ,可能发生了重复下载!',[sFileName]));
        end;

        CompressMem.SaveToFile(sFileName);
      finally
        CompressMem.Free;
        Stream.Free;
      end;
      //通知客户端文件下载成功
      BoardCastIdent(CL_RES_FILEDOWNLOADED,sFileName);
      ResDownLoadLog('文件下载完成 : ' + PRequest.FileName);
      Dispose(PRequest);
    end;
  end else
  begin
    PRequest.FailCount := PRequest.FailCount + 1;
    m_WaitingForDownLoad.Append(PRequest);  //添加到下载队列
    ResDownLoadLog(format('【下载失败】: %s , 重试次数: %d', [PRequest.FileName,PRequest.FailCount]));
  end;
end;

procedure TDownLoaderManager.OnRequestClientUpdataSuecess(Client: TCustomWinSocket; PRequest:PTMiniResRequest);
var
  I :Integer;
  PLockState:PTLockFileState;
  Session:TClientSession;
begin
  Session := Client.Data;
  ResDownLoadLog(Format('客户端: %d 更新文件成功 : %s ,ServerFlag : %d' , [Session.ClientNumber,PRequest.FileName,m_ClientFlag]));
  m_LockFileList.Lock;
  Try
    for i := 0 to m_LockFileList.Count - 1 do
    begin
      PLockState := m_LockFileList[i];
      if SameText(PLockState.FileName , PRequest.FileName) then
      begin
        PLockState.ClientState := PLockState.ClientState or Session.ClientNumber;
        Break;
      end;
    end;
  Finally
    m_LockFileList.UnLock;
  End;
  Dispose(PRequest);
end;

procedure TDownLoaderManager.OnRequestDownLoadImageFile(
  PRequest: PTMiniResRequest);
var
  FileName:string;
  Format:TWZLDATAFormat;
  PartInfo : TImageFilePartInfo;
  Ext , CompareExt:String;
  nPart:Integer;
  PartState: TPartState;
  RequestOk:Boolean;
begin
  RequestOk := False;
  if m_ResVerPack.TryGetImagePartInfo(PRequest.FileName,PartInfo) then
  begin
    nPart := PartInfo.GetIndexPart(PRequest.Index);
    PartState := PartInfo.PartState[nPart];
    case PartState of
      psEmpty,psDowing:
      begin
        if (PartState = psEmpty) or ((PartState = psDowing) and (GetTickCount - PartInfo.PartRequestTime[nPart] > 20 * 1000)) then
        begin
          Ext := UpperCase(ExtractFileExt(PRequest.FileName));
          if PartInfo.Format = wWZL then
            CompareExt := '.WZL'
          else
            CompareExt := '.DATA';

          if Ext = CompareExt then
          begin
            if nPart >= 0 then
            begin
              PRequest.FileName :=  PRequest.FileName + IntToStr(nPart);
              PartInfo.PartState[nPart] := psDowing;
              PartInfo.PartRequestTime[nPart] := GetTickCount;
              if PRequest.Important then
                m_WaitingForDownLoad.Insert(0,PRequest)
              else
                m_WaitingForDownLoad.Append(PRequest);  //添加到下载队列

              RequestOk := True;
            end
            else
            begin
              ResDownLoadLog(SysUtils.Format('无法获取图片文件分割部分 : %s , 序号: %d',[PRequest.FileName,PRequest.Index]));
            end;
          end else
          begin
            ResDownLoadLog('请求文件格式不匹配放弃下载 :' + PRequest.FileName);
          end;
        end else if PartState = psDowing then
        begin
          ResDownLoadLog(SysUtils.format('文件下载中请求放弃 : %s , Part %d ' ,[PRequest.FileName,nPart]));
        end;
      end;
      PsOk:
      begin
        ResDownLoadLog(SysUtils.format('文件已整合,通知刷新并放弃请求 : %s , Part %d ' ,[PRequest.FileName,nPart]));
        //通知客户端刷新文件即可
        //合并完后通知客户端进行更新
        BoardCastIdent(CL_RES_UPDATEFILE,FileName);
      end;
      PsMerge:
      begin
        ResDownLoadLog(SysUtils.format('文件等待合并中请求放弃 : %s , Part %d ' ,[PRequest.FileName,nPart]));
      end;

    end;

  end else
  begin
    ResDownLoadLog('没有找到对应的微端版本信息放弃下载 :' + PRequest.FileName);
  end;

  if not RequestOk then
    Dispose(PRequest);
end;

procedure TDownLoaderManager.OnRequestDownLoadSoundFile(
  PRequest: PTMiniResRequest);
var
  SoundFormat:TSoundFormat;
begin
  SoundFormat := m_ResVerPack.IncludeSoundFile(PRequest.FileName);
  case SoundFormat of
    sfNone:
    begin
      Dispose(PRequest);
      Exit;
    end;
    sfWav: PRequest.FileName := ChangeFileExt(PRequest.FileName,'.wav');
    sfMp3: PRequest.FileName := ChangeFileExt(PRequest.FileName,'.mp3');
    sfOgg: PRequest.FileName := ChangeFileExt(PRequest.FileName,'.ogg');
  end;

  if not m_RecentDownloing.ContainsKey(PRequest.FileName) then
  begin
    m_RecentDownloing.Add(PRequest.FileName,GetTickCount);
    PRequest.FileName := PRequest.FileName + '.z';
    if PRequest.Important then
      m_WaitingForDownLoad.Insert(0,PRequest)
    else
      m_WaitingForDownLoad.Append(PRequest);  //添加到下载队列
  end else
  begin
    Dispose(PRequest);
    ResDownLoadLog('文件正在下载中放弃本次下载 :' + PRequest.FileName);
  end;


end;


procedure TDownLoaderManager.OnClientConnected(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I:Integer;
  Number: Integer;
  BoFound:Boolean;
  LoopCount : Integer;
  PLockState : PTLockFileState;
  Session:TClientSession;
begin
  Number := 1;
  LoopCount := 0;
  while LoopCount < 32  do
  begin
    BoFound := False;
    for i := 0 to m_LocalServer.ClientCount - 1 do
    begin
      if Socket <> m_LocalServer.Client[i] then
      begin
        if Integer(Socket.Data) = Number then
        begin
          BoFound := True;
          Number := Number shl 1;
          Break;
        end;
      end;
    end;

    Inc(LoopCount);
    if not BoFound then
    begin
      Break;
    end;
  end;

  Session := TClientSession.Create;
  Session.ClientNumber := Number;

  Socket.Data := Session;

  m_ClientFlag := m_ClientFlag or Number;

  m_ClientList.Lock;
  Try
    m_ClientList.Add(Session);
  Finally
    m_ClientList.UnLock;
  End;

  //给所有的上锁文件增加此客户端已经下载完毕
  m_LockFileList.Lock;
  Try
    for I := 0 to m_LockFileList.Count - 1 do
    begin
      PLockState := m_LockFileList[i];
      PLockState.ClientState := PLockState.ClientState or Number;
    end;
  Finally
    m_LockFileList.UnLock;
  End;

  ResDownLoadLog('通讯建立:' + IntToStr(Number));
end;

procedure TDownLoaderManager.OnClientDataAvailable(Sender: TObject;Socket: TCustomWinSocket);
var
  ARequest: PTMiniResRequest;
  Session:TClientSession;
  SocketMsg:AnsiString;
begin
  try
    Session := Socket.Data;
    Session.SocektData := Session.SocektData + Socket.ReceiveText;

    while True do
    begin
      if Pos('!',Session.SocektData) > 0 then
      begin
        Session.SocektData := AnsiArrestStringEx(Session.SocektData,'#','!',SocketMsg);
        if (SocketMsg <> '') and (Length(SocketMsg) = m_EncodeRequestSize) then
        begin
          New(ARequest);
          DecodeBuffer(SocketMsg,PAnsiChar(ARequest),SizeOf(TMiniResRequest));
          ARequest.Data := Socket;
          m_RecvMsgList.Append(ARequest);
        end else
        begin
          Break;
        end;
      end else
      begin
        Break;
      end;
    end;

  except
    on E: Exception do
      uLog.TLogger.AddLog(uEDCode.DecodeSource('SZBJaaE580cJBYBMGvLosmYwtIo5Bp7t+airAJDhCSXxjGmeWnLo2ZV4') + E.Message);  //客户端与登录器通讯报错,错误信息:
  end;
end;

procedure TDownLoaderManager.OnClientDisConnected(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Number : Integer;
  I:Integer;
  PLockState : PTLockFileState;
  Session:TClientSession;
begin
  //更新客户端Flag 去掉其中的一个Flag
  Session := Socket.Data;

  Number := not Session.ClientNumber;
  m_ClientFlag := m_ClientFlag and Number;
  //遍历所有上锁的文件 也将其中的Flag去掉
  m_LockFileList.Lock;
  try
    for I := 0 to m_LockFileList.Count - 1 do
    begin
      PLockState := m_LockFileList[i];
      PLockState.ClientState := PLockState.ClientState and Number;
    end;
  finally
    m_LockFileList.UnLock;
  end;

  m_ClientList.Lock;
  try
    m_ClientList.Remove(Session);
  finally
    m_ClientList.UnLock;
  end;

  Session.Free;
end;

procedure TDownLoaderManager.OnClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
   ErrorCode := 0;
   Socket.Close;
end;

procedure TDownLoaderManager.ProcessDownLoadList;
var
  i ,nCount :Integer;
  Worker : TDownLoader;
  DownInfo:PTMiniResRequest;
begin
  m_WaitingForDownLoad.Flush;

  while m_WaitingForDownLoad.Count > 0 do
  begin
        //获取下载信息
    DownInfo := PTMiniResRequest(m_WaitingForDownLoad[0]);

    //如果当前没有空闲的下载进程 则跳出
    Worker := FindIdleWork(DownInfo.Important);
    if Worker = nil then
    begin
     // ResDownLoadLog('下载线程不足。当前等待下载队列:' + IntToStr(m_WaitingForDownLoad.Count));
      Break;
    end;

    //给对应的下载器 设置任务
    Worker.SetDownLoad(DownInfo);
    Worker.Resume;

    m_WaitingForDownLoad.Delete(0);
  end;

end;

procedure TDownLoaderManager.ProcessRecentList;
var
  Enumerator : TEnumerator<TPair<String,Cardinal>>;
  Pair : TPair<String,Cardinal>;
  NowTick:Cardinal;
begin
  NowTick := GetTickCount;
  //两次处理间隔10秒以上
  if NowTick - m_LastProcessRecentTime > 10*1000 then
  begin
    m_LastProcessRecentTime := NowTick;
    Enumerator :=  m_RecentDownloing.GetEnumerator;
    Try
      while Enumerator.MoveNext do
      begin
        Pair:= Enumerator.Current;
        if Now - Pair.Value > 30 * 1000 then
        begin
          m_RecentDownloing.Remove(Pair.Key);
        end;
      end;
    Finally
      Enumerator.Free;
    End;

  end;
end;

procedure TDownLoaderManager.ProcessRecvMsg;
var
  ARequest : PTMiniResRequest;
  SocketMsg: AnsiString;
  I:Integer;
begin

  m_RecvMsgList.Flush;

  for i := 0 to m_RecvMsgList.Count - 1 do
  begin
    Try
      ARequest := m_RecvMsgList.Items[i];
      case ARequest._Type of
        0: OnRequestDownLoadImageFile(ARequest);  //请求下载图片
        1: begin  //请求下载普通文件
          if m_ResVerPack.IncludeFile(ARequest.FileName) then
          begin
            if not m_RecentDownloing.ContainsKey(ARequest.FileName) then
            begin
              m_RecentDownloing.Add(ARequest.FileName,GetTickCount);
              ARequest.FileName := ARequest.FileName + '.z';
              if ARequest.Important then
              begin
                m_WaitingForDownLoad.Insert(0,ARequest);
              end else
              begin
                m_WaitingForDownLoad.Add(ARequest);  //添加到下载队列
              end;
            end else
            begin
              ResDownLoadLog('文件正在下载中放弃本次下载 :' + ARequest.FileName);
              Dispose(ARequest);
            end;
          end;
        end;
        2: OnRequestDownLoadSoundFile(ARequest);  //请求下载声音文件。
        3: OnRequestClientUpdataSuecess(ARequest.Data,ARequest); //客户端通知解锁文件完毕。可以进行解锁了
      end;
    Finally
      m_RecvMsgList.Items[i] := nil;
    End;
  end;

  for i := m_RecvMsgList.Count - 1 downto 0 do
  begin
    if m_RecvMsgList.Items[i] = nil then
      m_RecvMsgList.Delete(i);
  end;
end;

procedure TDownLoaderManager.ProcessUnLockList;
var
  i:Integer;
  PLockState: PTLockFileState;
  TickCount :Integer;
begin
  TickCount := GetTickCount;
  //如果和上次 处理的时间超过了 半秒钟 那么必须进行解锁处理。
  if TickCount - m_LastProcessUnLockTime > 500 then
  begin
    m_LockFileList.Lock;
  end else
  begin
    if not m_LockFileList.TryLock then
      Exit;
  end;


  Try

    m_LastProcessUnLockTime := TickCount;
    for i := m_LockFileList.Count - 1 downto 0 do
    begin
      PLockState := m_LockFileList[i];
      if (PLockState.ClientState = m_ClientFlag) then
      begin
        m_LockFileList.Delete(i);
        ResDownLoadLog(Format('文件:%s 所有客户端刷新完毕 进行解锁。',[PLockState.FileName]));
        Dispose(PLockState);
        Continue;
      end;

      //超过10秒强制解锁
      if (TickCount - PLockState.LockTime > 10 * 1000) then
      begin
        m_LockFileList.Delete(i);
        ResDownLoadLog(Format('文件:%s 客户端刷新超时强制进行解锁。',[PLockState.FileName]));
        Dispose(PLockState);
        Continue;
      end;
    end;
  Finally
    m_LockFileList.UnLock;
  End;
end;

procedure TDownLoaderManager.ProcessWaitMergeList;
var
  MainFileName,PartFileName:string;
  I , nPart:Integer;
  FileStream : TStream;
  Ext , sPart,FilePath:String;
  pMergeEvent:pTWaitMergeEvent;
begin
  MainFileName := '';
  nPart := -1;
  m_WaitMergerFileList.Flush;
  //遍历所有需要合并的文件列表。 如果文件锁上了那么保存文件到硬盘。
  //释放内存。 如果没有直接执行合并
  for i := m_WaitMergerFileList.Count - 1 downto 0 do
  begin
     pMergeEvent := m_WaitMergerFileList[i];
     PartFileName := pMergeEvent.FileName;
     Ext := UpperCase(ExtractFileExt(PartFileName));
     if Length(Ext) > 1 then
     begin
       if Ext[2] = 'D' then
       begin
         sPart := Copy(Ext,6,20);
         nPart := StrToIntDef(sPart,-1);
         MainFileName := ChangeFileExt(PartFileName,'.data');
       end
       else
       begin
         sPart := Copy(Ext,5,20);
         nPart := StrToIntDef(sPart,-1);
         MainFileName := ChangeFileExt(PartFileName,'.wzl');
       end;
     end;

    m_LockFileList.Lock;
    Try
      if not FileIsLockeStatic(MainFileName) then
      begin
        if MainFileName <> '' then
        begin
          //确定文件夹进行文件夹确认
          FilePath := ExtractFilePath(MainFileName);
          if not DirectoryExists(FilePath) then
            ForceDirectories(FilePath);

          //如果合并的内存文件还在那么从内存合并。 否则尝试加载硬盘文件
          if pMergeEvent.Stream = nil then
          begin
            if FileExists(PartFileName) then
            begin
              FileStream := TFileStream.Create(PartFileName,fmOpenRead);
            end else
            begin
              ResDownLoadLog(format('[异常]: 等待合并的文件不存在:%s',[PartFileName]));
              //m_WaitMergerFileList.SaveToFile('DropWaitingMeger.txt');
            End;
          end else
          begin
            FileStream := pMergeEvent.Stream;
          end;

          Try
            Merge(MainFileName,FileStream,nPart);
          Finally
            FileStream.Free;
            if pMergeEvent.Stream = nil then
            begin
              IOUtils.TFile.Delete(PartFileName);
              ResDownLoadLog('删除临时文件:' + PartFileName);
            end;

            pMergeEvent.Stream := nil;
            m_WaitMergerFileList.Delete(i);
            Dispose(pMergeEvent);
          End;

        end;

      end else
      begin
        //如果是内存流  那么 保存到硬盘 等待文件解锁后在进行合并。
        if pMergeEvent.Stream <> nil then
        begin
          pMergeEvent.Stream.SaveToFile(pMergeEvent.FileName);
          pMergeEvent.Stream.Free;
          pMergeEvent.Stream := nil;
        end;
      end;
    Finally
      m_LockFileList.UnLock;
    End;
  end;
end;

procedure TDownLoaderManager.StopAllWorker;
var
  i : Integer;
begin
  Terminate; //进行工作调度
  for i := 0 to m_WorkerList.Count - 1 do
  begin
    TDownLoader(m_WorkerList[i]).StopWork;
  end;
end;

{ TDownLoader }

constructor TDownLoader.Create(Owner:TDownLoaderManager);
begin
  inherited Create(True);
  m_Owner := Owner;
  {$IFDEF MINI_INDY}
  m_IDHttp := TIdHTTP.Create(nil);
  m_IDHttp.OnWork := OnWork;
  m_IDHttp.OnWorkBegin := OnWorkBegin;
  {$ELSE}
  m_HttpCli := THttpCli.Create(nil);
  m_HttpCli.Agent := 'Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20100101 Firefox/8.0';
  {$ENDIF}
end;

destructor TDownLoader.Destroy;
begin
  Terminate;
 {$IFDEF MINI_INDY}
  m_IDHttp.Free;
 {$ELSE}
  m_HttpCli.Free;
 {$ENDIF}
  if m_DownLoadInfo <> nil then
  begin
    Dispose(m_DownLoadInfo);
    m_DownLoadInfo := nil;
  end;
  inherited;
end;

procedure TDownLoader.execute;
begin
  inherited;
  while (not Terminated) do
  begin
    Try
      if m_DownLoadInfo <> nil then
      begin
        ProcessDownLoad(m_DownLoadInfo);
        m_DownLoadInfo := nil;
      end;
    finally

    End ;
    Sleep(10);
  end;

end;

function TDownLoader.GetProgress: Integer;
begin
  Result := m_nProgress;
end;

function TDownLoader.IsIdle: Boolean;
begin
  Result := m_DownLoadInfo = nil;
end;

 {$IF CompilerVersion >= 20.0}
   procedure TDownLoader.OnWork(ASender: TObject; AWorkMode: TWorkMode;
            AWorkCount: Int64);
 {$ELSE}
   procedure TDownLoader.OnWork(ASender: TObject; AWorkMode: TWorkMode;
            AWorkCount: Integer);
{$IFEND}
begin
  if m_nFileSize <> 0 then
  begin
    m_nProgress := (AWorkCount * 10000) div m_nFileSize;
  end;
end;

 {$IF CompilerVersion >= 20.0}
 procedure TDownLoader.OnWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
            AWorkCountMax: Int64);
 {$ELSE}
 procedure TDownLoader.OnWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
            AWorkCountMax: Integer);
{$IFEND}
begin
  m_nFileSize := AWorkCountMax;
end;

procedure TDownLoader.ProcessDownLoad(PRequest: PTMiniResRequest);
var
  M : TMemoryStream;
  boFreeMemory : Boolean;
  sUrl : string;
  FileName:String;
begin
  Try
    if PRequest._Type = 0 then
    begin
      FileName := ExtractFileNameOnly(PRequest.FileName);
      FileName := ExtractFilePath(PRequest.FileName) +  FileName + '/'+  FileName + ExtractFileExt(PRequest.FileName);
    end else
    begin
      FileName := PRequest.FileName;
    end;

    sUrl := m_Owner.m_sResSite + StringReplace(FileName,'\','/',[rfReplaceAll]);
    boFreeMemory := False;

    {$IFDEF MINI_INDY}
    M := TMemoryStream.Create;
    Try
      ResDownLoadLog(Format('[开始下载]: %s',[sUrl]));
      m_sFileName := ExtractFileName(sUrl);
      m_IDHttp.Get(sUrl,M);
    except
      on E:EIdException do
      begin
        boFreeMemory := True;
        ResDownLoadLog('[Exception]:TDownLoader.ProcessDownLoad Indy' + E.Message);
      end;
    End;
    {$ELSE}
    M := TMemoryStream.Create;
    m_HttpCli.RcvdStream := M;
    m_HttpCli.Url := sUrl;
    m_HttpCli.NoCache := True;
    try
      m_HttpCli.Get;
    except
      on E:Exception do
      begin
        boFreeMemory := True;
        ResDownLoadLog('[Exception]: TDownLoader.ProcessDownLoad ICS:' + E.Message);
      end;
    end;
    {$ENDIF}


    //出现异常的时候释放资源
    if boFreeMemory then
    begin
      M.Free;
      m_Owner.OnFileDownLoadEvent(deFail,PRequest,nil);
    end else
    begin
      m_Owner.OnFileDownLoadEvent(deSucess,PRequest,M);
      m_DownLoadInfo := nil;
    end;

  except
    ResDownLoadLog('[Exception]:' + 'TDownLoader.ProcessDownLoad(PRequest: PTMiniResRequest)');
  End;
end;

procedure TDownLoader.SetDownLoad(PRequest: PTMiniResRequest);
begin
  m_DownLoadInfo := PRequest;
end;

procedure TDownLoader.StopWork;
begin

  // 停止下载
  {$IFDEF MINI_INDY}
  m_IDHttp.EndWork(wmRead);
  m_IDHttp.EndWork(wmWrite);
  {$ELSE}
  m_HttpCli.Close;
  {$ENDIF}
end;

{ TClientData }

constructor TClientSession.Create;
begin
  inherited;
end;

destructor TClientSession.Destroy;
begin
  inherited;
end;

initialization

finalization
  if LogLock <> nil then
    LogLock.Free;

end.

