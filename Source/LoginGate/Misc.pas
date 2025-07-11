unit Misc;

interface

{$DEFINE SIGN3D}

uses
  Windows, Messages, SysUtils, WinSock2, ClientSession;

function CheckStr(const str: string): Boolean;
function CheckBlank(const str: string): Boolean;

procedure ConnSqlServer();
procedure CheckSqlServerConn();
procedure CloseSqlServer();

procedure CloseIPConnect(const nRemoteIP: Integer);
function KickUser(const nRemoteIP: Integer): Boolean; overload;
procedure KickUser(const UserObj: TSessionObj); overload;
procedure BlockUser(const UserObj: TSessionObj);

function ReverseIP(dwIP: DWORD): DWORD;
function AnsiStrToVal(const nPtr: PAnsiChar; var nPos: Integer): Integer;

//procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);

function CheckAccountName(sName: string): Boolean;

implementation

uses
  AcceptExWorkedThread, SHSocket, AppMain, Protocol,
  ConfigManager, IPAddrFilter, Grobal2, ComObj, Variants, LogManager;


function CheckStr(const str: string): Boolean;
var
  i                 : Integer;
begin
  for i := 1 to Length(str) do
  begin
    if str[i] in ['"', ',', '`', '=', '<', '>', '\', '(', ')', Chr(34), Chr(39)] then
    begin
      Result := True;
      exit;
    end;
  end;
  Result := False;
end;

function CheckBlank(const str: string): Boolean;
var
  i                 : Integer;
begin
  for i := 1 to Length(str) do
  begin
    if str[i] <= ' ' then
    begin
      Result := True;
      exit;
    end;
  end;
  Result := False;
end;

procedure ConnSqlServer();
begin
  if g_pConfig.m_fEnableIDService then begin
    g_Conn := CreateOleObject('ADODB.Connection');
    try
      if g_pLogMgr.CheckLevel(1) then
        g_pLogMgr.Add('正在连接SQL帐号数据库...');
      //连接数据库
      g_Conn.ConnectionString := 'Provider=SQLOLEDB.1;Password=' + g_pConfig.m_szSqlPassword +
        ';Persist Security Info=True;User ID=' + g_pConfig.m_szSqlAccount + ';Initial Catalog=' +
        g_pConfig.m_szSqlDatabase + ';Data Source=' + g_pConfig.m_szSqlServer + ';';
      g_Conn.Open();
      //连接成功返回true
      g_Rs := CreateOleObject('adodb.recordset');
      g_fSQLReady := True;

      if g_pLogMgr.CheckLevel(1) then
        g_pLogMgr.Add('连接SQL帐号数据库成功...');
    except
      on E: Exception do begin
        //连接失败返回False
        g_Rs := UNASSIGNED;
        g_Conn := UNASSIGNED;
        g_fSQLReady := False;
        if g_pLogMgr.CheckLevel(4) then
        g_pLogMgr.Add(Format('SQL帐号数据库连接失败' + #13#10 + '%s',[E.Message]));
      end;
    end;
  end
  else begin
    if g_pLogMgr.CheckLevel(1) then
        g_pLogMgr.Add('帐号服务系统设置为禁止使用...');
    g_fSQLReady := False;
  end;
end;

procedure CheckSqlServerConn();
begin
  try
    g_Rs.Open('Select FLD_LOGINID From [TBL_ACCOUNT] Where FLD_LOGINID=''''', g_Conn, 1,
      1);
    g_Rs.Close;
  except
    try
      g_Conn := UNASSIGNED;
      g_Conn := CreateOleObject('ADODB.Connection');
      g_Conn.ConnectionString := 'Provider=SQLOLEDB.1;Password=' + g_pConfig.m_szSqlPassword +
                              ';Persist Security Info=True;User ID=' + g_pConfig.m_szSqlAccount +
                              ';Initial Catalog=' + g_pConfig.m_szSqlDatabase +
                              ';Data Source=' + g_pConfig.m_szSqlServer + ';';
      g_Conn.Open();

      if g_pLogMgr.CheckLevel(1) then
        g_pLogMgr.Add(Format('重新连接%s数据库...',[g_pConfig.m_szSqlDatabase]));
    except
      on E: Exception do begin
        if g_pLogMgr.CheckLevel(4) then
        g_pLogMgr.Add(Format('重新连接%s数据库...' + #13#10 + '%s',[g_pConfig.m_szSqlDatabase,E.Message]));
      end;
    end;
  end;
end;

procedure CloseSqlServer();
begin
  try
    if g_fSQLReady then
      g_Conn.Close;
  finally
    if g_fSQLReady then
      if g_pLogMgr.CheckLevel(1) then
         g_pLogMgr.Add('帐号数据库已经关闭...');

    g_fSQLReady := False;
    g_Rs := UNASSIGNED;
    g_Conn := UNASSIGNED;
  end;
end;

procedure CloseIPConnect(const nRemoteIP: Integer);
var
  i, n                      : Integer;
  UserObj                   : TSessionObj;
begin
  if not g_fServiceStarted then
    Exit;
  for n := 0 to USER_ARRAY_COUNT - 1 do begin
    UserObj := g_UserList[n];
    if (UserObj <> nil) and
      (UserObj.m_tLastGameSvr <> nil) and
      (UserObj.m_tLastGameSvr.Active) and
      (UserObj.m_pUserOBJ.nIPAddr = nRemoteIP) then begin
      if UserObj.m_fHandleLogin >= 2 then begin
        UserObj.SendDefMessage(SM_OUTOFCONNECTION, UserObj.m_nSvrObject, 0, 0, 0, '');
        UserObj.m_fKickFlag := True;
      end else
        SHSocket.FreeSocket(UserObj.m_pUserOBJ._SendObj.Socket);
    end;
  end;
end;

function KickUser(const nRemoteIP: Integer): Boolean;
begin
  Result := True;
  if g_pConfig.m_fKickOverPacketSize then begin
    case g_pConfig.m_tBlockIPMethod of
      mDisconnect: begin
          Result := False;
        end;
      mBlock: begin
          AddToTempBlockIPList(nRemoteIP);
          CloseIPConnect(nRemoteIP);
          Result := False;
        end;
      mBlockList: begin
          AddToBlockIPList(nRemoteIP);
          CloseIPConnect(nRemoteIP);
          Result := False;
        end;
    end;
  end;
end;

procedure KickUser(const UserObj: TSessionObj);
begin
  if g_pConfig.m_fKickOverPacketSize then begin
    SHSocket.FreeSocket(UserObj.m_pUserOBJ._SendObj.Socket);
    UserObj.m_fKickFlag := True;
    case g_pConfig.m_tBlockIPMethod of
      mBlock: begin
          AddToTempBlockIPList(UserObj.m_pUserOBJ.nIPAddr);
        end;
      mBlockList: begin
          AddToBlockIPList(UserObj.m_pUserOBJ.nIPAddr);
        end;
    end;
  end;
end;

procedure BlockUser(const UserObj: TSessionObj);
begin
  if g_pConfig.m_fKickOverPacketSize then begin
    UserObj.m_fKickFlag := True;
    case g_pConfig.m_tBlockIPMethod of
      mBlock: begin
          AddToTempBlockIPList(UserObj.m_pUserOBJ.nIPAddr);
        end;
      mBlockList: begin
          AddToBlockIPList(UserObj.m_pUserOBJ.nIPAddr);
        end;
    end;
  end;
end;

function ReverseIP(dwIP: DWORD): DWORD;
begin
  Result := (LOBYTE(LOWORD(dwIP)) shl 24) or
    (HIBYTE(LOWORD(dwIP)) shl 16) or
    (LOBYTE(HIWORD(dwIP)) shl 8) or
    (HIBYTE(HIWORD(dwIP)));
end;

function AnsiStrToVal(const nPtr: PAnsiChar; var nPos: Integer): Integer;
var
  c                         : AnsiChar;
  tPtr                      : PAnsiChar;
  total                     : Integer;
begin
  nPos := 0;
  Result := 0;
  if nPtr = nil then Exit;
  tPtr := nPtr;
  c := tPtr^;
  total := 0;
  while ((c >= '0') and (c <= '9')) do begin
    total := 10 * total + (Byte(c) - Byte('0'));
    inc(tPtr);
    inc(nPos);
    c := tPtr^;
  end;
  Result := total;
end;

//procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
//var
//  SendData                  : TCopyDataStruct;
//  nParam                    : Integer;
//begin
//  nParam := MakeLong(Word(tLoginGate), wIdent);
//  SendData.cbData := Length(AnsiString(sSendMsg)) + 1;
//  GetMem(SendData.lpData, SendData.cbData);
//  Move(PAnsiChar(AnsiString(sSendMsg))^, PAnsiChar(AnsiString(SendData.lpData))^, Length(AnsiString(sSendMsg)) + 1);
//  SendMessage(g_hGameCenterHandle, WM_COPYDATA, nParam, Cardinal(@SendData));
//  FreeMem(SendData.lpData);
//end;

function CheckAccountName(sName: string): Boolean;
var
  I                         : Integer;
  nLen                      : Integer;
begin
  Result := False;
  if sName = '' then
    Exit;
  Result := true;
  nLen := Length(sName);
  I := 1;
  while (true) do begin
    if I > nLen then Break;
    if (sName[I] < '0') or (sName[I] > 'z') then begin
      Result := False;
      if (sName[I] >= #$B0) and (sName[I] <= #$C8) then begin
        Inc(I);
        if I <= nLen then
          if (sName[I] >= #$A1) and (sName[I] <= #$FE) then
            Result := true;
      end;
      if not Result then
        Break;
    end;
    Inc(I);
  end;
end;

end.

