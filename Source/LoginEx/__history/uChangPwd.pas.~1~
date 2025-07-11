unit uChangPwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, uLogin, Buttons, dxGDIPlusClasses;

type
  TFRMChangePWD = class(TForm)
    edtID: TEdit;
    edtOld: TEdit;
    edtNew: TEdit;
    edtNew1: TEdit;
    btnOK: TBitBtn;
    BitBtn2: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    function CheckInput: Boolean;
  public
    { Public declarations }
    procedure Initializa;
  end;

var
  FRMChangePWD: TFRMChangePWD;

implementation

{$R *.dfm}

function TFRMChangePWD.CheckInput: Boolean;
begin
  if Trim(edtId.Text) = '' then
  begin
    Application.MessageBox('帐号必须输入', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;
  if Trim(edtOld.Text) = '' then
  begin
    Application.MessageBox('旧密码必须输入', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;
  if (Trim(edtNew.Text) = '') or (edtNew.Text<>edtNew1.Text) then
  begin
    Application.MessageBox('两次新密码必须输入且必须保持一致', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;
  if Trim(edtOld.Text)=Trim(edtNew.Text) then
  begin
    Application.MessageBox('密码修改时新旧密码不能完全一致', '提示', MB_OK);
    Result  :=  False;
    Exit;
  end;
  Result  :=  True;
end;

procedure TFRMChangePWD.btnOKClick(Sender: TObject);
begin
  if CheckInput then
  begin
    btnOK.Enabled :=  False;
    uClientApp.SendChangePassWord(edtID.Text, edtOld.Text, edtNew.Text);
  end;
end;

procedure TFRMChangePWD.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TFRMChangePWD.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  edtID.Text    :=  '';
  edtOld.Text   :=  '';
  edtNew.Text   :=  '';
  edtNew1.Text  :=  '';
  btnOK.Enabled := True;
  BitBtn2.Enabled := True;
end;

procedure TFRMChangePWD.Initializa;
begin

end;

end.
