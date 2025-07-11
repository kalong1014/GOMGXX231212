(* ΢����Դ������ *)
// һ·���� 2016��1��2

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
  PART_CHK_CODE = $CCFFEEDD; //�ָ�ֵ���֤��
  CL_CLIENTOPEN  = 10000;
  CL_CLIENTCLOSE = 10001;
  CL_RES_REQUST = 10002;
  CL_RES_NEWFILE = 10003;
  CL_RES_IMGDOWNLOADED = 10004;
  CL_RES_FILEDOWNLOADED = 10005;
  CL_RES_UPDATEFILE = 10006;//֪ͨ���пͻ�����ͼƬ�ļ���Ҫ���¡�

type
   //�ͻ����ļ������Ľṹ��
   PTLockFileState = ^TLockFileState;
   TLockFileState = record
     FileName:string[200]; //�������ļ�
     ClientState:Integer;//�����ͻ��˵�״̬��
     LockTime:Cardinal;
   end;

   //���سɹ�����ʧ�ܵ��¼�
   TDownloadEventType = (deSucess,deFail);

   //�ȴ��ϲ����¼�
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
     m_sResSite :string; //��Դ��ַ
     m_WorkerList : TList ; //�������̶߳����
     m_RecentDownloing : TDictionary<String,Cardinal>; //������ص��ļ�
     m_WaitingForDownLoad : TDoubleList; //�ȴ����ص��б�
     m_LockFileList:TGList;// <PTLockFileState>//��ֹ���µ��ļ��б� �ȴ��ͻ��˷��غ�ɾ�� ��
     m_WaitMergerFileList:TDoubleList; // �ȴ��ϲ����ļ��б� ���ļ�����ֹ���º� ����ʱ�ļ����ᱻ���������ȴ��ϲ���
//     m_RecvMsgList : TDoubleList; //�յ�����Ϣ
     {$IFDEF USENAMEPIPE}
     m_LocalServer : TNamedPipeServer;
     {$ELSE}
     m_LocalServer: TuServerSocket;
     {$ENDIF}
     //�ɹ�������ɵ��б� ��Ҫ���� Debug �Ƿ�Ὣ�ɹ������ص��ٴ�����
     //��ʽ���а汾 ���������б�����¼
     {$IFDEF DEBUGDOWNLOADER}
     m_DownLoadDoneList : TStringList;
     {$ENDIF}
     m_ResVerPack: TMiniResFilePackage;
     m_Password : String;
     m_ClientFlag : Integer;
     m_boWorking:Boolean; //�Ƿ��ڹ���
     m_boSocketWork:Boolean;//�Ƿ�Socket�ڹ���
     m_LastProcessRecentTime:Cardinal;
     m_LoopTimeMax:Cardinal;
     m_MaxProcessMsgTime,
     m_MaxProcessDownloadListTime,
     m_MaxProcessUnlockListTime,
     m_MaxProcessRecentListTime:Cardinal;
     m_MergeFileThread:TThread; //�ϲ��ļ��߳�
     m_SocketBuffer:AnsiString;
     m_TempSocketBuffer:AnsiString;
     m_EncodeRequestSize:Integer;
     m_ClientList : TGList;
     m_LastProcessUnLockTime:Cardinal; //�ϴ�ִ�н����ļ��� ʱ��
     m_SocketSendLock : TFixedCriticalSection;
     function  FindIdleWork(boImportant:Boolean):TDownLoader; //�ҵ�һ�����е������߳�
     function GetClientCount():Integer;
     function GetLocalServerPort:Word;
     function IsLocked(const FileName:String):Boolean; //����ļ��Ƿ�������������
     function FileIsLockeStatic(const FileName:String):Boolean; //����ļ��Ƿ����� û�м���
     procedure Merge(const FileName:String;Stream:TStream;Part:Integer);
   protected
     procedure Execute();override;
     procedure ProcessRecvMsg(); //�����յ�����Ϣ
     procedure ProcessDownLoadList();//��������ص��б�

     procedure ProcessUnLockList(); //����ȴ��������ļ��б�
     procedure ProcessRecentList(); //����������ع����ļ�����30������

     //�������ļ������߳� ������ �������¼����̲߳�һ��
     procedure ProcessWaitMergeList(); //����ȴ��ϲ��ļ����б�

     function GetWorker(n:Integer):TDownLoader;
     function GetWorkCount : Integer;
     procedure OnClientDataAvailable(Sender: TObject;Socket: TCustomWinSocket);
     procedure OnClientConnected(Sender: TObject;Socket: TCustomWinSocket);
     procedure OnClientDisConnected(Sender: TObject;Socket: TCustomWinSocket);
      procedure OnRequestDownLoadSoundFile(PRequest:PTMiniResRequest); //�������������ļ���
     procedure OnRequestDownLoadImageFile(PRequest:PTMiniResRequest); //��������ͼƬ�ļ�
     procedure OnRequestClientUpdataSuecess(Client: TCustomWinSocket; PRequest:PTMiniResRequest); //�ͻ���֪ͨ�����ļ���ϡ����Խ��н�����
     procedure OnClientSocketError(Sender: TObject; Socket: TCustomWinSocket;ErrorEvent: TErrorEvent; var ErrorCode: Integer);
     procedure OnFileDownLoadEvent(Event:TDownloadEventType;PRequest: PTMiniResRequest ; Stream :TMemoryStream); //������������¼���ͨ������������
   public
     m_RecvMsgList : TDoubleList; //�յ�����Ϣ
     constructor Create();
     destructor Destroy();override;

     //��ʼ�������� ��Դ��ַ,�������������߳�����
     procedure StartWork(ThreadCount : Integer ; ImportantThreadCount:Integer);

     procedure StartSocekt();

     procedure BoardCastIdent(IDent:Integer);overload;
     procedure BoardCastIdent(IDent:Integer ; FileName:String);overload;
     procedure StopAllWorker;
     procedure LoadResVerPackFromFile(const FileName:String);
     procedure LoadResVerPackFromStream(Stream:TStream); //��ȡ΢�˿ͻ����ļ�������

     function IsResVerFileRead():Boolean; //΢�������ļ��Ƿ��ȡ�ˡ�
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
     m_nFileSize : Integer;//���ļ���С
     m_nProgress :Integer; //���� ��ֱ�
     m_sFileName : ShortString;
     m_boImportant:Boolean; //�Ƿ���Ҫ ��Ҫ�߳����ȸ���Ҫ�� ������Ҫ�Ĳ�����
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
     function GetProgress:Integer; //��ȡ���ؽ��� ��ֱ�;
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


procedure UnCompressionStream(var ASrcStream: TMemoryStream); //��ѹ��
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
      //����ʵ�ʴ�С
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
procedure ResDownLoadLog(S:String;B:Byte = 1); //���B  > 3˵��������Ϣ�����Ե�Ҫע��
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

  //�ͷŹ����߳�
  for I := 0 to m_WorkerList.Count - 1 do
  begin
    TDownLoader(m_WorkerList[i]).Free;
  end;
  m_WorkerList.Free;

  //�ͷŵȴ�������Ϣ
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
  ResDownLoadLog('=====΢����������������===== OneLoopMaxTime:' + IntToStr(m_LoopTimeMax),1);

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
      //�����յ�����Ϣ
      ProcessRecvMsg;
      ProcessMsgTick := TimeGetTime;
      ProcessMsgTime := ProcessMsgTick - StartTick;

      //����Ҫ���ص��б�
      ProcessDownLoadList;
      ProcessDownloadListTick := TimeGetTime;
      ProcessDownloadListTime := ProcessDownloadListTick - ProcessMsgTick;

      //����ȴ��������б�
      ProcessUnLockList;
      ProcessUnlockListTick := TimeGetTime;
      ProcessUnlockListTime := ProcessUnlockListTick - ProcessDownloadListTick;

      //�������
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
    //��Ҫ���� ����ʹ����Ҫ�� ������ �����Ҫ�������� ���� ��������ͨ����������
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
    //��ͨ������ֻ���ø���ͨ�Ĺ�����
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
      uLog.TLogger.AddLog(uEDCode.DecodeSource('Y1CTZ79B1G1v/6KJ4AV3A+yJTJyqwRkVQ8pAlxvtYevTZyDaTM5luk0D') + E.Message);  //��������TCP����ʧ��,������Ϣ:
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
  ResDownLoadLog(Format('==΢�˿�ʼ����, �߳�ID: %d  �߳�����:%d==',[ Self.ThreadID,ThreadCount]));
  ResDownLoadLog('====΢�����ص�ַ:' + m_sResSite + '========',5);
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
    ResDownLoadLog('�޷���ѹ΢�������ļ����������������',1);
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
   ResDownLoadLog(Format('��ʼ�ϲ��ļ� : %s ,Part : %d ',[FileName,Part]),4);
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
           //����ȴ������б�
           New(PlockState);
           PlockState.ClientState := 0;
           PlockState.LockTime := GetTickCount();
           PlockState.FileName := FileName;
           //��Ϊ�ϲ��Ĳ����ⲿ�Ѿ���m_LockFileList ������ ����û��Ҫ�ټ���
           m_LockFileList.Add(PlockState);
           if DataHeaderStream <> nil then
             DataHeaderStream.Free;

           ResDownLoadLog('�ϲ��ļ���� : ' + FileName);
         end;
         PartInfo.PartState[Part] := PsOk;
         //�ϲ����֪ͨ�ͻ��˽��и���
         BoardCastIdent(CL_RES_UPDATEFILE,FileName);
       end;
     end else
     begin
       ResDownLoadLog('�ϲ��ļ�ʧ�� : ' + FileName + ', ΢�˰汾��Ϣ�����ڴ��ļ���Ϣ');
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
     ResDownLoadLog('�������:' + PRequest.FileName );
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
        ResDownLoadLog('����ȴ��ϲ��б�:' + PRequest.FileName );

        nPart := PartInfo.GetIndexPart(PRequest.Index);
        if nPart >= 0 then
          PartInfo.PartState[nPart] := PsMerge;
      end;
      Dispose(PRequest);
    end else
    begin
      //��ͼƬ���ݱ��浽�ļ����ɡ�
      CompressMem := TMemoryStream.Create;
      try
        Stream.Position := 36; // 4 CheckCode | 32�ֽ�MD5 | ѹ����ԭʼ����
        CompressMem.CopyFrom(Stream,Stream.Size - 36);
        UnCompressionStream(CompressMem);
        sFileName := PRequest.FileName;
        Delete(sFileName,Length(sFileName) - 1,2);
        if FileExists(sFileName) then
        begin
          ResDownLoadLog(Format('�ļ��Ѵ���:%s ,���ܷ������ظ�����!',[sFileName]));
        end;

        CompressMem.SaveToFile(sFileName);
      finally
        CompressMem.Free;
        Stream.Free;
      end;
      //֪ͨ�ͻ����ļ����سɹ�
      BoardCastIdent(CL_RES_FILEDOWNLOADED,sFileName);
      ResDownLoadLog('�ļ�������� : ' + PRequest.FileName);
      Dispose(PRequest);
    end;
  end else
  begin
    PRequest.FailCount := PRequest.FailCount + 1;
    m_WaitingForDownLoad.Append(PRequest);  //��ӵ����ض���
    ResDownLoadLog(format('������ʧ�ܡ�: %s , ���Դ���: %d', [PRequest.FileName,PRequest.FailCount]));
  end;
end;

procedure TDownLoaderManager.OnRequestClientUpdataSuecess(Client: TCustomWinSocket; PRequest:PTMiniResRequest);
var
  I :Integer;
  PLockState:PTLockFileState;
  Session:TClientSession;
begin
  Session := Client.Data;
  ResDownLoadLog(Format('�ͻ���: %d �����ļ��ɹ� : %s ,ServerFlag : %d' , [Session.ClientNumber,PRequest.FileName,m_ClientFlag]));
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
                m_WaitingForDownLoad.Append(PRequest);  //��ӵ����ض���

              RequestOk := True;
            end
            else
            begin
              ResDownLoadLog(SysUtils.Format('�޷���ȡͼƬ�ļ��ָ�� : %s , ���: %d',[PRequest.FileName,PRequest.Index]));
            end;
          end else
          begin
            ResDownLoadLog('�����ļ���ʽ��ƥ��������� :' + PRequest.FileName);
          end;
        end else if PartState = psDowing then
        begin
          ResDownLoadLog(SysUtils.format('�ļ�������������� : %s , Part %d ' ,[PRequest.FileName,nPart]));
        end;
      end;
      PsOk:
      begin
        ResDownLoadLog(SysUtils.format('�ļ�������,֪ͨˢ�²��������� : %s , Part %d ' ,[PRequest.FileName,nPart]));
        //֪ͨ�ͻ���ˢ���ļ�����
        //�ϲ����֪ͨ�ͻ��˽��и���
        BoardCastIdent(CL_RES_UPDATEFILE,FileName);
      end;
      PsMerge:
      begin
        ResDownLoadLog(SysUtils.format('�ļ��ȴ��ϲ���������� : %s , Part %d ' ,[PRequest.FileName,nPart]));
      end;

    end;

  end else
  begin
    ResDownLoadLog('û���ҵ���Ӧ��΢�˰汾��Ϣ�������� :' + PRequest.FileName);
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
      m_WaitingForDownLoad.Append(PRequest);  //��ӵ����ض���
  end else
  begin
    Dispose(PRequest);
    ResDownLoadLog('�ļ����������з����������� :' + PRequest.FileName);
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

  //�����е������ļ����Ӵ˿ͻ����Ѿ��������
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

  ResDownLoadLog('ͨѶ����:' + IntToStr(Number));
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
      uLog.TLogger.AddLog(uEDCode.DecodeSource('SZBJaaE580cJBYBMGvLosmYwtIo5Bp7t+airAJDhCSXxjGmeWnLo2ZV4') + E.Message);  //�ͻ������¼��ͨѶ����,������Ϣ:
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
  //���¿ͻ���Flag ȥ�����е�һ��Flag
  Session := Socket.Data;

  Number := not Session.ClientNumber;
  m_ClientFlag := m_ClientFlag and Number;
  //���������������ļ� Ҳ�����е�Flagȥ��
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
        //��ȡ������Ϣ
    DownInfo := PTMiniResRequest(m_WaitingForDownLoad[0]);

    //�����ǰû�п��е����ؽ��� ������
    Worker := FindIdleWork(DownInfo.Important);
    if Worker = nil then
    begin
     // ResDownLoadLog('�����̲߳��㡣��ǰ�ȴ����ض���:' + IntToStr(m_WaitingForDownLoad.Count));
      Break;
    end;

    //����Ӧ�������� ��������
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
  //���δ�����10������
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
        0: OnRequestDownLoadImageFile(ARequest);  //��������ͼƬ
        1: begin  //����������ͨ�ļ�
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
                m_WaitingForDownLoad.Add(ARequest);  //��ӵ����ض���
              end;
            end else
            begin
              ResDownLoadLog('�ļ����������з����������� :' + ARequest.FileName);
              Dispose(ARequest);
            end;
          end;
        end;
        2: OnRequestDownLoadSoundFile(ARequest);  //�������������ļ���
        3: OnRequestClientUpdataSuecess(ARequest.Data,ARequest); //�ͻ���֪ͨ�����ļ���ϡ����Խ��н�����
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
  //������ϴ� �����ʱ�䳬���� ������ ��ô������н�������
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
        ResDownLoadLog(Format('�ļ�:%s ���пͻ���ˢ����� ���н�����',[PLockState.FileName]));
        Dispose(PLockState);
        Continue;
      end;

      //����10��ǿ�ƽ���
      if (TickCount - PLockState.LockTime > 10 * 1000) then
      begin
        m_LockFileList.Delete(i);
        ResDownLoadLog(Format('�ļ�:%s �ͻ���ˢ�³�ʱǿ�ƽ��н�����',[PLockState.FileName]));
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
  //����������Ҫ�ϲ����ļ��б� ����ļ���������ô�����ļ���Ӳ�̡�
  //�ͷ��ڴ档 ���û��ֱ��ִ�кϲ�
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
          //ȷ���ļ��н����ļ���ȷ��
          FilePath := ExtractFilePath(MainFileName);
          if not DirectoryExists(FilePath) then
            ForceDirectories(FilePath);

          //����ϲ����ڴ��ļ�������ô���ڴ�ϲ��� �����Լ���Ӳ���ļ�
          if pMergeEvent.Stream = nil then
          begin
            if FileExists(PartFileName) then
            begin
              FileStream := TFileStream.Create(PartFileName,fmOpenRead);
            end else
            begin
              ResDownLoadLog(format('[�쳣]: �ȴ��ϲ����ļ�������:%s',[PartFileName]));
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
              ResDownLoadLog('ɾ����ʱ�ļ�:' + PartFileName);
            end;

            pMergeEvent.Stream := nil;
            m_WaitMergerFileList.Delete(i);
            Dispose(pMergeEvent);
          End;

        end;

      end else
      begin
        //������ڴ���  ��ô ���浽Ӳ�� �ȴ��ļ��������ڽ��кϲ���
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
  Terminate; //���й�������
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
      ResDownLoadLog(Format('[��ʼ����]: %s',[sUrl]));
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


    //�����쳣��ʱ���ͷ���Դ
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

  // ֹͣ����
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

