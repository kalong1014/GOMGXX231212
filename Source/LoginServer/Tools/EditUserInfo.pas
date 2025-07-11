unit EditUserInfo;

interface

uses
  Classes, Controls, Forms, StdCtrls, SysUtils, SQLIDDB;

type
  TFrmUserInfoEdit = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    CkFullEdit: TCheckBox;
    EdAnswer: TEdit;
    EdAnswer2: TEdit;
    EdBirthDay: TEdit;
    EdEMail: TEdit;
    EdId: TEdit;
    EdMemo1: TEdit;
    EdMemo2: TEdit;
    EdMobilePhone: TEdit;
    EdPasswd: TEdit;
    EdPhone: TEdit;
    EdQuiz: TEdit;
    EdQuiz2: TEdit;
    EdSSNo: TEdit;
    EdUserName: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure CkFullEditClick(Sender: TObject);
  private
  public
    function  Execute (var ircd: FIdRcd): Boolean;
    function  ExecuteEdit (bonew: Boolean; var ircd: FIdRcd): Boolean;
  end;

var
  FrmUserInfoEdit: TFrmUserInfoEdit;

implementation

{$R *.DFM}

function TFrmUserInfoEdit.Execute(var ircd: FIdRcd): Boolean;
begin
  Result := ExecuteEdit(FALSE, ircd);
end;

function TFrmUserInfoEdit.ExecuteEdit(bonew: Boolean; var ircd: FIdRcd): Boolean;
begin
  Result := FALSE;
  if not bonew then begin
    CkFullEdit.Enabled := TRUE;
    CkFullEdit.Checked := FALSE;
    CkFullEditClick(self);
    EdId.Enabled := FALSE;
  end
  else begin
    CkFullEdit.Enabled := FALSE;
    CkFullEdit.Checked := TRUE;
    CkFullEditClick(self);
    EdId.Enabled := TRUE;
  end;

  EdId.Text := Trim(ircd.UserInfo.UInfo.LoginId);
  EdPasswd.Text := Trim(ircd.UserInfo.UInfo.Password);
  EdUserName.Text := Trim(ircd.UserInfo.UInfo.UserName);
  EdSSNo.Text := Trim(ircd.UserInfo.UInfo.SSNo);
  EdBirthDay.Text := Trim(ircd.UserInfo.UAdd.Birthday);
  EdQuiz.Text := Trim(ircd.UserInfo.UInfo.Quiz);
  EdAnswer.Text := Trim(ircd.UserInfo.UInfo.Answer);
  EdQuiz2.Text := Trim(ircd.UserInfo.UAdd.Quiz2);
  EdAnswer2.Text := Trim(ircd.UserInfo.UAdd.Answer2);
  EdPhone.Text := Trim(ircd.UserInfo.UInfo.Phone);
  EdMobilePhone.Text := Trim(ircd.UserInfo.UAdd.MobilePhone);
  EdMemo1.Text := Trim(ircd.UserInfo.UAdd.Memo1);
  EdMemo2.Text := Trim(ircd.UserInfo.UAdd.Memo2);
  EdEMail.Text := Trim(ircd.UserInfo.UInfo.EMail);

  if ShowModal = mrOk then begin
    if bonew then begin
      ircd.UserInfo.UInfo.LoginId := EdId.Text;
    end;
    ircd.UserInfo.UInfo.Password := EdPasswd.Text;
    ircd.UserInfo.UInfo.UserName := EdUserName.Text;
    ircd.UserInfo.UInfo.SSNo := EdSSNo.Text;
    ircd.UserInfo.UAdd.Birthday := EdBirthday.Text;
    ircd.UserInfo.UInfo.Quiz := EdQuiz.Text;
    ircd.UserInfo.UInfo.Answer := EdAnswer.Text;
    ircd.UserInfo.UAdd.Quiz2 := EdQuiz2.Text;
    ircd.UserInfo.UAdd.Answer2 := EdAnswer2.Text;
    ircd.UserInfo.UInfo.Phone := EdPhone.Text;
    ircd.UserInfo.UAdd.MobilePhone := EdMobilePhone.Text;
    ircd.UserInfo.UAdd.Memo1 := EdMemo1.Text;
    ircd.UserInfo.UAdd.Memo2 := EdMemo2.Text;
    ircd.UserInfo.UInfo.EMail := EdEMail.Text;
    Result := TRUE;
  end;
end;

procedure TFrmUserInfoEdit.CkFullEditClick(Sender: TObject);
var
  flag: Boolean;
begin
  flag := CkFullEdit.Checked;
  EdUserName.Enabled := flag;
  EdSSNo.Enabled := flag;
  EdBirthDay.Enabled := flag;
  EdQuiz.Enabled := flag;
  EdAnswer.Enabled := flag;
  EdQuiz2.Enabled := flag;
  EdAnswer2.Enabled := flag;
  EdPhone.Enabled := flag;
  EdMobilePhone.Enabled := flag;
  EdMemo1.Enabled := FALSE;
  EdMemo2.Enabled := FALSE;
  EdEMail.Enabled := flag;
end;

end.
