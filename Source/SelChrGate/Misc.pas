unit Misc;

interface

{$DEFINE SIGN3D}

uses
  Windows, Messages, SysUtils, WinSock2, ClientSession;

procedure CloseIPConnect(const nRemoteIP: Integer);
function KickUser(const nRemoteIP: Integer): Boolean; overload;
procedure KickUser(const UserObj: TSessionObj); overload;
procedure BlockUser(const UserObj: TSessionObj);

function ReverseIP(dwIP: DWORD): DWORD;
function AnsiStrToVal(const nPtr: PAnsiChar; var nPos: Integer): Integer;

function CheckAccountName(sName: string): Boolean;

implementation

uses
  AcceptExWorkedThread, SHSocket, AppMain, Protocol,
  ConfigManager, IPAddrFilter, Grobal2;


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

