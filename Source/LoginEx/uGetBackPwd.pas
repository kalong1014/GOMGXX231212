unit uGetBackPwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, dxGDIPlusClasses,uLogin;

type
  TfrmGetBackPwd = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    edtID: TEdit;
    Label2: TLabel;
    edBtd: TEdit;
    Label3: TLabel;
    edQ1: TEdit;
    Label4: TLabel;
    edA1: TEdit;
    Label5: TLabel;
    edQ2: TEdit;
    Label6: TLabel;
    edA2: TEdit;
    Bevel1: TBevel;
    btnOK: TBitBtn;
    BitBtn2: TBitBtn;
    Label7: TLabel;
    edPwd: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function CheckInPut():Boolean;
  public
    { Public declarations }
    procedure Initializa;
  end;

var
  frmGetBackPwd: TfrmGetBackPwd;

implementation

{$R *.dfm}

procedure TfrmGetBackPwd.BitBtn2Click(Sender: TObject);
begin
  Close();
end;

procedure TfrmGetBackPwd.btnOKClick(Sender: TObject);
begin
  if CheckInPut() then
  begin
    btnOK.Enabled :=  False;
    uClientApp.SendGetBackPassWord(edtID.Text, edPwd.Text, edQ1.Text , edA1.Text , edQ2.Text ,EdA2.Text , edbtd.Text);
  end;
end;

function TfrmGetBackPwd.CheckInPut: Boolean;
begin
  if Trim(edtID.Text) = ''  then
  begin
    Application.MessageBox('帐号不能为空', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;

  if Trim(edBtd.Text) = ''  then
  begin
    Application.MessageBox('生日不能为空', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;

  if Trim(edQ1.Text) = ''  then
  begin
    Application.MessageBox('问题1不能为空', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;

  if Trim(edQ2.Text) = ''  then
  begin
    Application.MessageBox('问题2不能为空', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;

  if Trim(edA1.Text) = ''  then
  begin
    Application.MessageBox('答案1不能为空', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;

  if Trim(edA2.Text) = ''  then
  begin
    Application.MessageBox('答案2不能为空', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;

  if Trim(edPwd.Text) = ''  then
  begin
    Application.MessageBox('新密码不能为空', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;

  Result := True;
end;

procedure TfrmGetBackPwd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edtID.Text    :=  '';
  edBtd.Text   :=  '';
  edQ1.Text   :=  '';
  edQ2.Text  :=  '';
  edA1.Text   :=  '';
  edA2.Text  :=  '';
  edPwd.Text   :=  '';

  btnOK.Enabled := True;
  BitBtn2.Enabled := True;
end;

procedure TfrmGetBackPwd.Initializa;
begin

end;

end.
