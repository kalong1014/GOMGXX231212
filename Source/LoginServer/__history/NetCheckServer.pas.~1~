unit NetCheckServer;

interface

uses
  Windows, SysUtils, ExtCtrls, ScktComp;

type
  TCCheckServer = class
    procedure CheckServerTimerTimer(Sender: TObject);
    procedure Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Disconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  private
  public
    CheckServerSocket: TServerSocket;
    CheckServerTimer: TTimer;
    constructor Create;
    destructor Destroy; override;
  end;

var
  CCheckServer: TCCheckServer;

implementation

uses
   NetGameServer, LoginSvrWnd, LSShare;

constructor TCCheckServer.Create;
begin
  CheckServerSocket:= TServerSocket.Create(nil);
  CheckServerSocket.OnClientConnect := Connect;
  CheckServerSocket.OnClientDisconnect := Disconnect;
  CheckServerSocket.OnClientError := Error;
  CheckServerTimer := TTimer.Create(nil);
  CheckServerTimer.Interval := 5000;
  CheckServerTimer.OnTimer := CheckServerTimerTimer;
end;

destructor TCCheckServer.Destroy;
begin
  CheckServerSocket.Free;
  CheckServerTimer.Free;
  inherited;
end;

procedure TCCheckServer.CheckServerTimerTimer(Sender: TObject);
var
  i, ccount, nTransferred: integer;
  svname, sstate: string;
begin
  m_listGameServer.Lock;
  try
    ccount := m_listGameServer.Count;
    for i:=0 to m_listGameServer.Count-1 do begin
      svname := PTGameServer(m_listGameServer[i]).ServerName;
      if svname <> '' then begin
        sstate := sstate + svname + '/' +
                  IntToStr (PTGameServer(m_listGameServer[i]).ServerIndex) + '/' +
                  IntToStr (PTGameServer(m_listGameServer[i]).CurUserCount) + '/';
        if GetTickCount - PTGameServer(m_listGameServer[i]).CheckTime < 30 * 1000 then begin
           sstate := sstate + 'Good;';
        end else sstate := sstate + 'Timeout;';
      end else begin
        sstate := sstate + '-/-/-/-;';
      end;
    end;
    with CheckServerSocket do begin
      for i:=0 to Socket.ActiveConnections-1 do begin
        if Socket.Connections[i].Connected then begin
          nTransferred := Socket.Connections[i].SendText (IntToStr(ccount) + ';' + sstate);
{$IFDEF DEBUG}
          MainOutMessage(CSEND, Format('[CheckServer/%d]', [nTransferred]));
{$ENDIF}
        end;
      end;
    end;
  finally
    m_listGameServer.UnLock;
  end;
end;

procedure TCCheckServer.Connect(Sender: TObject; Socket: TCustomWinSocket);
begin
  MainOutMessage(0, Format('[CheckServer/Connect] CheckServer connected. (%s):(%d))',
                [Socket.RemoteAddress, Socket.RemotePort]));
end;

procedure TCCheckServer.Disconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  MainOutMessage(CERR, Format('CheckServer disconnected. [%s:%d]',
                [Socket.RemoteAddress, Socket.RemotePort]));
end;

procedure TCCheckServer.Error(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

end.
