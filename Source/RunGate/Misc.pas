unit Misc;

interface

{$DEFINE SIGN3D}

uses
  Windows, Messages, SysUtils, WinSock2, ClientSession;

procedure CloseIPConnect(const nRemoteIP: Integer);
function KickUser(const nRemoteIP: Integer): Boolean; overload;
procedure KickUser(const UserObj: TSessionObj); overload;

function ReverseIP(dwIP: DWORD): DWORD;

implementation

uses
  AcceptExWorkedThread, SHSocket, AppMain, Protocol, ConfigManager, Filter, Grobal2;

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

function ReverseIP(dwIP: DWORD): DWORD;
begin
  Result := (LOBYTE(LOWORD(dwIP)) shl 24) or
    (HIBYTE(LOWORD(dwIP)) shl 16) or
    (LOBYTE(HIWORD(dwIP)) shl 8) or
    (HIBYTE(HIWORD(dwIP)));
end;

end.

