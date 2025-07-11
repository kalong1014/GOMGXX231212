unit GeneralConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TfrmGeneralConfig = class(TForm)
    GroupBoxNet: TGroupBox;
    lblGateIPad: TLabel;
    LabelServerIPaddr: TLabel;
    EditDataSource: TEdit;
    EditDataID: TEdit;
    GroupBoxInfo: TGroupBox;
    ButtonOK: TButton;
    CheckBoxMinimize: TCheckBox;
    EditDataPass: TEdit;
    Label1: TLabel;
    EditDataPass2: TEdit;
    EditDataSource2: TEdit;
    EditDataID2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditLoginServerPort: TEdit;
    EditGameServerPort: TEdit;
    EditSelChrGatePort: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ButtonCel: TButton;
    EditLoginServerAddr: TEdit;
    EditMapInfoFilePath: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    EditServerName: TEdit;
    procedure ButtonOKClick(Sender: TObject);
    procedure CheckBoxMinimizeClick(Sender: TObject);
    procedure ButtonCelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open();
  end;

var
  frmGeneralConfig: TfrmGeneralConfig;

implementation

uses
  HUtil32, DBShare, IniFiles;

{$R *.dfm}

procedure TfrmGeneralConfig.ButtonCelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGeneralConfig.ButtonOKClick(Sender: TObject);
var
  sDataSource, sDataID, sDataPass: string;
  sDataSource2, sDataID2, sDataPass2: string;
  sServerName, sLoginSvrAddr, sMapInfoFilePath: string;
  nLoginServerPort, nGameServerPort, nSelChrGatePort: Integer;
  Conf: TIniFile;
begin
  sServerName := Trim(EditServerName.Text);
  sDataSource := Trim(EditDataSource.Text);
  sDataID := Trim(EditDataID.Text);
  sDataPass := Trim(EditDataPass.Text);
  sDataSource2 := Trim(EditDataSource2.Text);
  sDataID2 := Trim(EditDataID2.Text);
  sDataPass2 := Trim(EditDataPass2.Text);

  sLoginSvrAddr := Trim(EditLoginServerAddr.Text);
  nLoginServerPort := Str_ToInt(Trim(EditLoginServerPort.Text), -1);
  nGameServerPort := Str_ToInt(Trim(EditGameServerPort.Text), -1);
  nSelChrGatePort := Str_ToInt(Trim(EditSelChrGatePort.Text), -1);
  sMapInfoFilePath := Trim(EditMapInfoFilePath.Text);

  if (nLoginServerPort < 0) or (nLoginServerPort > 65535) then begin
    Application.MessageBox('Invalid Check Server port entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditLoginServerPort.SetFocus;
    Exit;
  end;

  if (nGameServerPort < 0) or (nGameServerPort > 65535) then begin
    Application.MessageBox('Invalid Game Server port entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditGameServerPort.SetFocus;
    Exit;
  end;

  if (nSelChrGatePort < 0) or (nSelChrGatePort > 65535) then begin
    Application.MessageBox('Invalid SelChr Gate port entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditSelChrGatePort.SetFocus;
    Exit;
  end;

  if sServerName = '' then begin
    Application.MessageBox('Invalid Server Name entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditServerName.SetFocus;
    Exit;
  end;

  if sDataSource = '' then begin
    Application.MessageBox('Invalid Data Source entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditDataSource.SetFocus;
    Exit;
  end;

  if sDataID = '' then begin
    Application.MessageBox('Invalid Data ID entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditDataID.SetFocus;
    Exit;
  end;

  if sDataPass = '' then begin
    Application.MessageBox('Invalid Data Password entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditDataPass.SetFocus;
    Exit;
  end;

  if sDataSource2 = '' then begin
    Application.MessageBox('Invalid Data Source entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditDataSource2.SetFocus;
    Exit;
  end;

  if sDataID2 = '' then begin
    Application.MessageBox('Invalid Data ID entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditDataID2.SetFocus;
    Exit;
  end;

  if sDataPass2 = '' then begin
    Application.MessageBox('Invalid Data Password entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditDataPass2.SetFocus;
    Exit;
  end;

  if sLoginSvrAddr = '' then begin
    Application.MessageBox('Invalid LoginSvr Address entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditLoginServerAddr.SetFocus;
    Exit;
  end;

  if sMapInfoFilePath = '' then begin
    Application.MessageBox('Invalid MapInfo File Path entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditMapInfoFilePath.SetFocus;
    Exit;
  end;

  g_Config.SERVERNAME := sServerName;
  g_Config.ODBC_DSN := sDataSource;
  g_Config.ODBC_ID := sDataID;
  g_Config.ODBC_PW := sDataPass;
  g_Config.ODBC_DSN2 := sDataSource2;
  g_Config.ODBC_ID2 := sDataID2;
  g_Config.ODBC_PW2 := sDataPass2;
  g_Config.LS_ADDR := sLoginSvrAddr;

  g_Config.LS_CPORT := nLoginServerPort;
  g_Config.GS_BPORT := nGameServerPort;
  g_Config.RG_BPORT := nSelChrGatePort;
  g_Config.MF_FILEPATH := sMapInfoFilePath;
  Conf := TIniFile.Create('.\Config.ini');

  Conf.WriteString(GateClass, 'NAME', g_Config.SERVERNAME);
  Conf.WriteString(GateClass, 'ODBC_DSN', g_Config.ODBC_DSN);
  Conf.WriteString(GateClass, 'ODBC_ID', g_Config.ODBC_ID);
  Conf.WriteString(GateClass, 'ODBC_PW', g_Config.ODBC_PW);
  Conf.WriteString(GateClass, 'ODBC_DSN2', g_Config.ODBC_DSN2);
  Conf.WriteString(GateClass, 'ODBC_ID2', g_Config.ODBC_ID2);
  Conf.WriteString(GateClass, 'ODBC_PW2', g_Config.ODBC_PW2);
  Conf.WriteString(GateClass, 'LS_ADDR', g_Config.LS_ADDR);

  Conf.WriteInteger(GateClass, 'LS_CPORT', g_Config.LS_CPORT);
  Conf.WriteInteger(GateClass, 'GS_BPORT', g_Config.GS_BPORT);
  Conf.WriteInteger(GateClass, 'RG_BPORT', g_Config.RG_BPORT);
  Conf.WriteString(GateClass, 'MF_FILEPATH', g_Config.MF_FILEPATH);

  Conf.WriteBool(GateClass, 'Minimize', g_Config.boMinimize);
  Conf.Free;
  Close;
end;

procedure TfrmGeneralConfig.CheckBoxMinimizeClick(Sender: TObject);
begin
  g_Config.boMinimize := CheckBoxMinimize.Checked;
end;

procedure TfrmGeneralConfig.Open();
begin
  EditServerName.Text := g_Config.SERVERNAME;
  EditDataSource.Text := g_Config.ODBC_DSN;
  EditDataID.Text := g_Config.ODBC_ID;
  EditDataPass.Text := g_Config.ODBC_PW;
  EditDataSource2.Text := g_Config.ODBC_DSN2;
  EditDataID2.Text := g_Config.ODBC_ID2;
  EditDataPass2.Text := g_Config.ODBC_PW2;
  EditLoginServerAddr.Text := g_Config.LS_ADDR;
  EditMapInfoFilePath.Text := g_Config.MF_FILEPATH;

  EditLoginServerPort.Text := IntToStr(g_Config.LS_CPORT);
  EditGameServerPort.Text := IntToStr(g_Config.GS_BPORT);
  EditSelChrGatePort.Text := IntToStr(g_Config.RG_BPORT);
  CheckBoxMinimize.Checked := g_Config.boMinimize;
  ShowModal;
end;

end.
