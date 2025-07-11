unit NetLoginServer;

interface

uses
  SysUtils, Classes, Controls, Forms, EdCode, ExtCtrls, IniFiles, HUtil32,
  Grobal2, ScktComp;

type
  TCLoginServer = class
    procedure SocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure SocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ConnLoginServerTimerTimer(Sender: TObject);
    procedure KeepAliveTimerTimer(Sender: TObject);
  private
    listAdmission: TList;
  public
    IDSocket: TClientSocket;
    ConnLoginServerTimer: TTimer;
    KeepAliveTimer: TTimer;
    IDSocStr: string;
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    procedure DecodeSocStr;
    procedure InsertAdmission (uid, ipaddr: string; certify, paymode: integer);
    procedure RemoveAdmission (uid: string; certify: integer);
    procedure GetPasswdSuccess (body: string);
    procedure GetTotalUserCount (body: string);
    procedure GetCancelAdmission (body: string);
    procedure GetRecvPublicKey (body: string);
    function  GetAdmission (uid, uaddr: string; cert: integer): Boolean;
    procedure ClearSelectedAdmission (cert: integer);
    procedure CheckSelectedAdmission (cert: integer);
    function  IsSelectedAdmision (cert: integer): Boolean;
    procedure SendIDSMsg (msg: word; body: string);
    procedure SendUserCount;
    procedure ClearList;
  end;

var
  CLoginServer: TCLoginServer;

implementation

uses
  DBSMain, DBShare;

constructor TCLoginServer.Create;
begin
  IDSocket:= TClientSocket.Create(nil);
  IDSocket.OnConnect := SocketConnect;
  IDSocket.OnDisconnect := SocketDisconnect;
  IDSocket.OnError := SocketError;
  IDSocket.OnRead := SocketRead;
  IDSocket.Address := '';

  ConnLoginServerTimer := TTimer.Create(nil);
  ConnLoginServerTimer.Interval := 10000;
  ConnLoginServerTimer.OnTimer := ConnLoginServerTimerTimer;

  KeepAliveTimer := TTimer.Create(nil);
  KeepAliveTimer.Interval := 10000;
  KeepAliveTimer.OnTimer := KeepAliveTimerTimer;

  listAdmission := TList.Create;
  IDSocStr := '';
end;

destructor TCLoginServer.Destroy;
begin
  ClearList;
  IDSocket.Free;
  ConnLoginServerTimer.Free;
  KeepAliveTimer.Free;
  listAdmission.Free;
  inherited;
end;

procedure TCLoginServer.ClearList;
var
  i: integer;
begin
  for i := listAdmission.Count - 1 downto 0 do
    Dispose(PTAdmission(listAdmission[i]));
  listAdmission.Clear;
end;

procedure TCLoginServer.InsertAdmission(uid, ipaddr: string; certify, paymode: integer);
var
  pa: PTAdmission;
begin
  new(pa);
  pa.usrid := uid;
  pa.ipaddr := ipaddr;
  pa.Certification := certify;
  pa.PayMode := paymode;
  pa.Selected := FALSE;
  listAdmission.Add(pa);
end;

procedure TCLoginServer.RemoveAdmission(uid: string; certify: integer);
var
  i: integer;
begin
  for i := listAdmission.Count - 1 downto 0 do begin
    if (PTAdmission(listAdmission[i]).Certification = certify) or
      (PTAdmission(listAdmission[i]).UsrId = uid) then begin
      Dispose(PTAdmission(listAdmission[i]));
      listAdmission.Delete(i);
    end;
  end;
end;

procedure TCLoginServer.ClearSelectedAdmission(cert: integer);
var
  i: integer;
begin
  for i := 0 to listAdmission.Count - 1 do begin
    if PTAdmission(listAdmission[i]).Certification = cert then begin
      PTAdmission(listAdmission[i]).Selected := FALSE;
      break;
    end;
  end;
end;

procedure TCLoginServer.CheckSelectedAdmission(cert: integer);
var
  i: integer;
begin
  for i := 0 to listAdmission.Count - 1 do begin
    if PTAdmission(listAdmission[i]).Certification = cert then begin
      PTAdmission(listAdmission[i]).Selected := TRUE;
      break;
    end;
  end;
end;

function TCLoginServer.IsSelectedAdmision(cert: integer): Boolean;
var
  i: integer;
begin
  Result := FALSE;
  for i := 0 to listAdmission.Count - 1 do begin
    if PTAdmission(listAdmission[i]).Certification = cert then begin
      Result := PTAdmission(listAdmission[i]).Selected;
      break;
    end;
  end;
end;

function TCLoginServer.GetAdmission(uid, uaddr: string; cert: integer): Boolean;
var
  i: integer;
begin
  Result := FALSE;
  for i := 0 to listAdmission.Count - 1 do begin
    if (PTAdmission(listAdmission[i]).usrid = uid) and //(PTAdmission(AdmissionList[i]).ipaddr = uaddr) and
      (PTAdmission(listAdmission[i]).Certification = cert) then begin
      Result := TRUE;
      break;
    end;
  end;
end;

procedure TCLoginServer.SocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  MainOutMessage(0, 'Connected to LoginServer.');
  AddLog('Connected to LoginServer.');
  ConnLoginServerTimer.Enabled := FALSE;
  KeepAliveTimer.Enabled := TRUE;
  AddLog('KillTimer : TIMER_CONNLOGINSERVER, StartTimer : TIMER_KEEPALIVE');
end;

procedure TCLoginServer.SocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  szLogMsg: string;
begin
  szLogMsg := Format('[%s:%d] LoginServer disconnected.', [IDSocket.Address, IDSocket.Port]);
  MainOutMessage(CERR, szLogMsg);
  AddLog(szLogMsg);
  ConnLoginServerTimer.Enabled := TRUE;
  AddLog('StartTimer : TIMER_CONNLOGINSERVER');
end;

procedure TCLoginServer.SocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
  MainOutMessage(CERR, 'Unable to connect to LoginServer.');
  ConnLoginServerTimer.Enabled := TRUE;
end;

procedure TCLoginServer.SocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  IdSocStr := IdSocStr + Socket.ReceiveText;
  if Pos(')', IdSocStr) > 0 then
    DecodeSocStr;
end;

procedure TCLoginServer.ConnLoginServerTimerTimer(Sender: TObject);
begin
  if IDSocket.Address <> '' then
    if not IDSocket.Active then begin
      MainOutMessage(0, 'Retry to connect to LoginServer.');
      IDSocket.Active := TRUE;
    end;
end;

procedure TCLoginServer.Initialize;
begin
end;

procedure TCLoginServer.DecodeSocStr;
var
  BufStr, str, head, body: string;
  ident: integer;
begin
{$IFDEF DEBUG}
//   SetLog( CRECV, Format('[ISM/%d] %s', [Length(IDSocStr), StringReplace (IDSocStr, char($a), '/', [rfReplaceAll])]) );
{$ENDIF}
  BufStr := IDSocStr;
  IDSocStr := '';
  while Pos(')', BufStr) > 0 do begin
    BufStr := ArrestStringEx(BufStr, '(', ')', str);
    if str <> '' then begin
      body := GetValidStr3(str, head, ['/']);
      ident := Str_ToInt(head, 0);
      case ident of
        ISM_PASSWDSUCCESS:
          begin
            GetPasswdSuccess(body);
          end;
        ISM_CANCELADMISSION:
          begin
            GetCancelAdmission(body);
          end;
        ISM_TOTALUSERCOUNT:
          begin
            GetTotalUserCount(body);
          end;
        ISM_USERCLOSED:
          begin
          end;
        ISM_SEND_PUBLICKEY:
          begin
            GetRecvPublicKey(body);
          end;
        ISM_UPDATALOGINTIME:
          begin
            //GetRecvPublicKey(body);
            //Messagebox(0,'','',0);
          end;
      end;
    end else
      break;
  end;
  IdSocStr := BufStr + IdSocStr;
end;

procedure TCLoginServer.GetPasswdSuccess(body: string);
var
  uid, certstr, paystr, ipaddr: string;
begin
  // '/' -> '0x0a'
  body := GetValidStr3(body, uid, [char($a)]);
  body := GetValidStr3(body, certstr, [char($a)]);
  body := GetValidStr3(body, paystr, [char($a)]);
  //GetValidStr3 (body, ipaddr, ['/']);
  InsertAdmission(uid, ipaddr, Str_ToInt(certstr, 0), Str_ToInt(paystr, 0));
end;

procedure TCLoginServer.GetTotalUserCount(body: string);
begin
  //
	// 하는 일 없음
	//
end;

procedure TCLoginServer.GetRecvPublicKey(body: string);
var
  pubkeystr: string;
  pubkey: integer;
begin
  try
    GetValidStr3(body, pubkeystr, ['/']);
    pubkey := Str_ToInt(pubkeystr, 0);
    SetPublicKey(WORD(pubkey));
//    MainOutMessage ('GetRecvPublicKey : ' + IntToStr(GetPublicKey));
  except
//    MainOutMessage ('[Exception] FrmIdSoc.GetRecvPublicKey');
  end;
end;

procedure TCLoginServer.GetCancelAdmission(body: string);
var
  cert: integer;
  uid: string;
begin
  body := GetValidStr3(body, uid, ['/']);
  cert := Str_ToInt(body, 0);
  RemoveAdmission(uid, cert);
end;

procedure TCLoginServer.SendIDSMsg(msg: word; body: string);
var
  str: string;
begin
  str := '(' + IntToStr(msg) + '/' + body + ')';
  if IDSocket.Socket.Connected then
    IDSocket.Socket.SendText(str);
end;

procedure TCLoginServer.SendUserCount;
begin
  if IDSocket.Socket.Connected then
    IDSocket.Socket.SendText('(' + IntToStr(ISM_USERCOUNT) + '/' + g_Config.ServerName + '/99/' + IntToStr(Round(GetFreeDiskSpace('D:'))) + ')');
end;

procedure TCLoginServer.KeepAliveTimerTimer(Sender: TObject);
begin
   SendUserCount;
//   SetLog(0, Format('## Load/Save Human Data (%s:%d) => Load:%d/%d, Save:%d/%d',
//      [IDSocket.Socket.RemoteAddress, IDSocket.Socket.RemotePort, m_nLoadCount, m_nLoadFailCount,
//							m_nSaveCount, m_nSaveFailCount]) );
//  m_nLoadCount := 0;
//	m_nLoadFailCount := 0;
//	m_nSaveCount := 0;
//	m_nSaveFailCount := 0;
end;

end.
