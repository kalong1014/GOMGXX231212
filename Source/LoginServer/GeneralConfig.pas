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
    EditPCDataPass: TEdit;
    EditPCDataSource: TEdit;
    EditPCDataID: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditCheckServerPort: TEdit;
    EditDBServerPort: TEdit;
    EditLoginGatePort: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ButtonCel: TButton;
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
  HUtil32, LSShare, IniFiles;

{$R *.dfm}

procedure TfrmGeneralConfig.ButtonCelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGeneralConfig.ButtonOKClick(Sender: TObject);
var
  sDataSource, sDataID, sDataPass: string;
  sPCDataSource, sPCDataID, sPCDataPass: string;
  nCheckServerPort, nDBServerPort, nLoginGatePort: Integer;
  Conf: TIniFile;
begin
  sDataSource := Trim(EditDataSource.Text);
  sDataID := Trim(EditDataID.Text);
  sDataPass := Trim(EditDataPass.Text);
  sPCDataSource := Trim(EditPCDataSource.Text);
  sPCDataID := Trim(EditPCDataID.Text);
  sPCDataPass := Trim(EditPCDataPass.Text);

  nCheckServerPort := Str_ToInt(Trim(EditCheckServerPort.Text), -1);
  nDBServerPort := Str_ToInt(Trim(EditDBServerPort.Text), -1);
  nLoginGatePort := Str_ToInt(Trim(EditLoginGatePort.Text), -1);

  if (nCheckServerPort < 0) or (nCheckServerPort > 65535) then begin
    Application.MessageBox('Invalid Check Server port entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditCheckServerPort.SetFocus;
    Exit;
  end;

  if (nDBServerPort < 0) or (nDBServerPort > 65535) then begin
    Application.MessageBox('Invalid DB Server port entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditDBServerPort.SetFocus;
    Exit;
  end;

  if (nLoginGatePort < 0) or (nLoginGatePort > 65535) then begin
    Application.MessageBox('Invalid Login Gate port entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditLoginGatePort.SetFocus;
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

  if sPCDataSource = '' then begin
    Application.MessageBox('Invalid Data Source entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditPCDataSource.SetFocus;
    Exit;
  end;

  if sPCDataID = '' then begin
    Application.MessageBox('Invalid Data ID entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditPCDataID.SetFocus;
    Exit;
  end;

  if sPCDataPass = '' then begin
    Application.MessageBox('Invalid Data Password entered!!!', 'Error Message', MB_OK + MB_ICONERROR);
    EditPCDataPass.SetFocus;
    Exit;
  end;

  g_Config.ODBC_DSN := sDataSource;
  g_Config.ODBC_ID := sDataID;
  g_Config.ODBC_PW := sDataPass;
  g_Config.ODBC_DSN_PC := sPCDataSource;
  g_Config.ODBC_ID_PC := sPCDataID;
  g_Config.ODBC_PW_PC := sPCDataPass;

  g_Config.CS_BPORT := nCheckServerPort;
  g_Config.GS_BPORT := nDBServerPort;
  g_Config.LG_BPORT := nLoginGatePort;

  Conf := TIniFile.Create('.\Config.ini');
  Conf.WriteString(GateClass, 'ODBC_DSN', g_Config.ODBC_DSN);
  Conf.WriteString(GateClass, 'ODBC_ID', g_Config.ODBC_ID);
  Conf.WriteString(GateClass, 'ODBC_PW', g_Config.ODBC_PW);
  Conf.WriteString(GateClass, 'ODBC_DSN_PC', g_Config.ODBC_DSN_PC);
  Conf.WriteString(GateClass, 'ODBC_ID_PC', g_Config.ODBC_ID_PC);
  Conf.WriteString(GateClass, 'ODBC_PW_PC', g_Config.ODBC_PW_PC);

  Conf.WriteInteger(GateClass, 'CS_BPORT', g_Config.CS_BPORT);
  Conf.WriteInteger(GateClass, 'GS_BPORT', g_Config.GS_BPORT);
  Conf.WriteInteger(GateClass, 'LG_BPORT', g_Config.LG_BPORT);

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
  EditDataSource.Text := g_Config.ODBC_DSN;
  EditDataID.Text := g_Config.ODBC_ID;
  EditDataPass.Text := g_Config.ODBC_PW;
  EditPCDataSource.Text := g_Config.ODBC_DSN_PC;
  EditPCDataID.Text := g_Config.ODBC_ID_PC;
  EditPCDataPass.Text := g_Config.ODBC_PW_PC;

  EditCheckServerPort.Text := IntToStr(g_Config.CS_BPORT);
  EditDBServerPort.Text := IntToStr(g_Config.GS_BPORT);
  EditLoginGatePort.Text := IntToStr(g_Config.LG_BPORT);
  CheckBoxMinimize.Checked := g_Config.boMinimize;
  ShowModal;
end;

end.
