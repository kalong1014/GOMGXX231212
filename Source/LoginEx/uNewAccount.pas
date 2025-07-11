unit uNewAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grobal2, uLogin, Buttons, uServerList;

type
  TFrmNewAccount = class(TForm)
    sbOK: TBitBtn;
    BtnCancel: TBitBtn;
    GroupBox: TGroupBox;
    LabelID: TLabel;
    LabelPwd: TLabel;
    LabelPwd1: TLabel;
    LabelName: TLabel;
    LabelBtd: TLabel;
    LabelQ1: TLabel;
    LabelA1: TLabel;
    LabelQ2: TLabel;
    LabelA2: TLabel;
    LabelEMail: TLabel;
    LabelPID: TLabel;
    edID: TEdit;
    edPwd: TEdit;
    edPwd1: TEdit;
    edName: TEdit;
    edBtd: TEdit;
    edQ1: TEdit;
    edA1: TEdit;
    edQ2: TEdit;
    edA2: TEdit;
    edEMail: TEdit;
    edPID: TEdit;
    edQQ: TEdit;
    LabelQQ: TLabel;
    LabelMobile: TLabel;
    edMobile: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCancelClick(Sender: TObject);
    procedure sbOKClick(Sender: TObject);
  private
    { Private declarations }
    FServerInfo: TServerInfo;
    function CheckInput: Boolean;
  public
    { Public declarations }
    procedure Initializa(AServerInfo: TServerInfo);
  end;

var
  FrmNewAccount: TFrmNewAccount;

implementation

{$R *.dfm}

procedure TFrmNewAccount.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edID.Text :=  '';
  edPwd.Text  :=  '';
  edPwd1.Text :=  '';
  edName.Text :=  '';
  edBtd.Text :=  '2000-12-30';
  edQ1.Text :=  '';
  edA1.Text :=  '';
  edQ2.Text :=  '';
  edA2.Text :=  '';
  edEMail.Text  :=  '';
  edPID.Text    :=  '';
  edQQ.Text :='';
  edMobile.Text := '';
  sbOK.Enabled := True;
  BtnCancel.Enabled := True;
end;

procedure TFrmNewAccount.Initializa(AServerInfo: TServerInfo);

  procedure ShowControl(ALabel: TLabel; AEdit: TWinControl; AVisible: Boolean; var ATop: Integer);
  begin
    ALabel.Visible := AVisible;
    AEdit.Visible := AVisible;
    if AVisible then
    begin
      AEdit.Left := 86;
      AEdit.Top := ATop;
      ALabel.Left := 16;
      ALabel.Top := ATop + (AEdit.Height - ALabel.Height) div 2;
      ALabel.FocusControl := AEdit;

      ATop := ATop + AEdit.Height + 6;
    end;
  end;

var
  ATop: Integer;
begin
  FServerInfo := AServerInfo;
  ATop := 16;
  ShowControl(LabelID, edID, True, ATop);
  ShowControl(LabelPwd, edPwd, True, ATop);
  ShowControl(LabelPwd1, edPwd1, True, ATop);
  ShowControl(LabelName, edName, FServerInfo.IDShowName, ATop);
  ShowControl(LabelBtd, edBtd, FServerInfo.IDShowBirth, ATop);
  ShowControl(LabelQ1, edQ1, FServerInfo.IDShowQS, ATop);
  ShowControl(LabelA1, edA1, FServerInfo.IDShowQS, ATop);
  ShowControl(LabelQ2, edQ2, FServerInfo.IDShowQS, ATop);
  ShowControl(LabelA2, edA2, FServerInfo.IDShowQS, ATop);
  ShowControl(LabelEMail, edEMail, FServerInfo.IDShowMail, ATop);
  ShowControl(LabelQQ, edQQ, FServerInfo.IDShowQQ, ATop);
  ShowControl(LabelPID, edPID, FServerInfo.IDShowID, ATop);
  ShowControl(LabelMobile, edMobile, FServerInfo.IDShowMobile, ATop);

  GroupBox.Height := ATop + 6;
  sbOK.Top := ATop + 22;
  BtnCancel.Top := ATop + 22;
  ClientHeight := sbOK.Top + sbOK.Height + 8;

  sbOK.Enabled := True;
  BtnCancel.Enabled := True;
end;

procedure TFrmNewAccount.sbOKClick(Sender: TObject);
var
  AUEntry: TUserEntryInfo;
  AUEntryAdd: TUserEntryAddInfo;
begin
  if CheckInput then
  begin
    AUEntry.LoginId  :=  edID.Text;
    AUEntry.Password :=  edPwd.Text;
    AUEntry.UserName :=  edName.Text;
    AUEntry.SSNo     :=  edPID.Text;
    if AUEntry.SSNo = '' then AUEntry.SSNo := '650101-1455111';
    AUEntry.Phone    :=  '';
    AUEntry.Quiz     :=  edQ1.Text;
    AUEntry.Answer   :=  edA1.Text;
    AUEntry.EMail    :=  edEMail.Text;
    AUEntryAdd.Quiz2 :=  edQ2.Text;
    AUEntryAdd.Answer2 :=  edA2.Text;
    AUEntryAdd.BirthDay:=  edBtd.Text;
    AUEntryAdd.MobilePhone := edMobile.Text;
    AUEntryAdd.Memo1  :=  edQQ.Text;
    AUEntryAdd.Memo2  :=  '';
    sbOK.Enabled  :=  False;
    uLogin.uClientApp.SendNewAccount(AUEntry, AUEntryAdd);
  end;
end;

procedure TFrmNewAccount.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

function TFrmNewAccount.CheckInput: Boolean;
begin
  Result  :=  False;
  if Trim(edID.Text) = '' then
  begin
    edID.SetFocus;
    Application.MessageBox('账号必须输入！', '提示信息', MB_OK);
    Exit;
  end;
  if Length(Trim(edID.Text)) < 4 then
  begin
    edID.SetFocus;
    Application.MessageBox('账号长度必须大于4位！', '提示信息', MB_OK);
    Exit;
  end;
  if Trim(edPwd.Text) = '' then
  begin
    edPwd.SetFocus;
    Application.MessageBox('密码不可为空！', '提示信息', MB_OK);
    Exit;
  end;
  if Length(Trim(edPwd.Text)) < 4 then
  begin
    edPwd.SetFocus;
    Application.MessageBox('密码长度必须大于4位！', '提示信息', MB_OK);
    Exit;
  end;
  if edPwd.Text <> edPwd1.Text then
  begin
    edPwd.SetFocus;
    Application.MessageBox('两次密码输入不一致！', '提示信息', MB_OK);
    Exit;
  end;

  Result  :=  True;
end;

end.
