unit GrobalSession;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls;

type
  TfrmGrobalSession = class(TForm)
    ButtonRefGrid: TButton;
    PanelStatus: TPanel;
    GridSession: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure ButtonRefGridClick(Sender: TObject);
  private
    procedure RefGridSession();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmGrobalSession          : TfrmGrobalSession;

implementation

uses LSShare, Grobal2, LoginSvrWnd, HUtil32;

{$R *.dfm}

{ TfrmGrobalSession }

procedure TfrmGrobalSession.FormCreate(Sender: TObject);
begin
  GridSession.Cells[0, 0] := '序号';
  GridSession.Cells[1, 0] := '登录帐号';
  GridSession.Cells[2, 0] := '登录地址';
  GridSession.Cells[3, 0] := '服务器名';
  GridSession.Cells[4, 0] := '会话ID';
  GridSession.Cells[5, 0] := '是否充值';
end;

procedure TfrmGrobalSession.Open;
begin
  RefGridSession();
  ShowModal;
end;

procedure TfrmGrobalSession.RefGridSession;
  function StrAvailableType(nAt: Byte): string;
  begin
    Result := '';
    case nAt of
      1: Result := '用户月卡';
      2: Result := '用户秒卡';
      3: Result := '网吧月卡';
      4: Result := '网吧秒卡';
      5: Result := '未充值';
    end;
  end;
var
  I: Integer;
  CertUser: pTCertUser;
begin
  PanelStatus.Caption := '正在取得数据...';
  GridSession.Visible := False;
  GridSession.Cells[0, 1] := '';
  GridSession.Cells[1, 1] := '';
  GridSession.Cells[2, 1] := '';
  GridSession.Cells[3, 1] := '';
  GridSession.Cells[4, 1] := '';
  GridSession.Cells[5, 1] := '';
  m_csListCert.Lock;
  try
    if m_csListCert.Count <= 0 then begin
      GridSession.RowCount := 2;
      GridSession.FixedRows := 1;
    end else
      GridSession.RowCount := m_csListCert.Count + 1;
    for I := 0 to m_csListCert.Count - 1 do begin
      CertUser := m_csListCert.Items[I];
      GridSession.Cells[0, I + 1] := IntToStr(I);
      GridSession.Cells[1, I + 1] := CertUser.szLoginID;
      GridSession.Cells[2, I + 1] := CertUser.szAddr;
      GridSession.Cells[3, I + 1] := CertUser.szServerName;
      GridSession.Cells[4, I + 1] := IntToStr(CertUser.nCertification);
      GridSession.Cells[5, I + 1] := StrAvailableType(CertUser.nAvailableType);
    end;
  finally
    m_csListCert.UnLock;
  end;
  GridSession.Visible := true;
end;

procedure TfrmGrobalSession.ButtonRefGridClick(Sender: TObject);
begin
  RefGridSession();
end;

end.

