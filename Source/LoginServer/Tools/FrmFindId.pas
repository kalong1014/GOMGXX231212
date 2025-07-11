unit FrmFindId;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls, Grids, Grobal2,
  SQLIDDB;

type
  TFrmFindUserId = class(TForm)
    IdGrid: TStringGrid;
    Panel1: TPanel;
    EdFindId: TEdit;
    Label1: TLabel;
    BtnFindAll: TButton;
    BtnEdit: TButton;
    Button2: TButton;
    procedure EdFindIdKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure BtnFindAllClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    function MakeHumStr(nrow: integer; rcd: FIdRcd): string;
  public
    procedure Open();
  end;

var
  FrmFindUserId: TFrmFindUserId;

implementation

{$R *.DFM}

uses
  LoginSvrWnd, EditUserInfo, LSShare;

procedure TFrmFindUserId.Open();
begin
  EdFindId.Text := '';
  ShowModal;
end;

procedure TFrmFindUserId.FormCreate(Sender: TObject);
var
  i: integer;
begin
  IdGrid.RowCount := 2;
  with IdGrid do begin
    Cells[0, 0] := '帐号';
    Cells[1, 0] := '密码';
    Cells[2, 0] := '用户名称';
    Cells[3, 0] := '身份证号';
    Cells[4, 0] := '生日';
    Cells[5, 0] := '问题一';
    Cells[6, 0] := '答案一';
    Cells[7, 0] := '问题二';
    Cells[8, 0] := '答案二';
    Cells[9, 0] := '电话';
    Cells[10, 0] := '移动电话';
    Cells[11, 0] := '备注一';
    Cells[12, 0] := '备注二';
    Cells[13, 0] := '创建时间';
    Cells[14, 0] := '最后登录时间';
    Cells[15, 0] := '电子邮箱';
  end;
end;

function TFrmFindUserId.MakeHumStr(nrow: integer; rcd: FIdRcd): string;
var
  n: integer;
begin
  if nrow <= 0 then begin
    IdGrid.RowCount := IdGrid.RowCount + 1;
    IdGrid.FixedRows := 1;
    n := IdGrid.RowCount - 1;
  end else
    n := nrow;

  with IdGrid do begin
    Cells[0, n] := rcd.UserInfo.UInfo.LoginId;
    Cells[1, n] := rcd.UserInfo.UInfo.Password;
    Cells[2, n] := rcd.UserInfo.UInfo.UserName;
    Cells[3, n] := rcd.UserInfo.UInfo.SSNo;
    Cells[4, n] := rcd.UserInfo.UAdd.BirthDay;
    Cells[5, n] := rcd.UserInfo.UInfo.Quiz;
    Cells[6, n] := rcd.UserInfo.UInfo.Answer;
    Cells[7, n] := rcd.UserInfo.UAdd.Quiz2;
    Cells[8, n] := rcd.UserInfo.UAdd.Answer2;
    Cells[9, n] := rcd.UserInfo.UInfo.Phone;
    Cells[10, n] := rcd.UserInfo.UAdd.MobilePhone;
    Cells[11, n] := rcd.UserInfo.UAdd.Memo1;
    Cells[12, n] := rcd.UserInfo.UAdd.Memo2;
    Cells[13, n] := DateTimeToStr(rcd.MakeRcdDateTime);
    Cells[14, n] := DateTimeToStr(rcd.UpdateDateTime);
    Cells[15, n] := rcd.UserInfo.UInfo.EMail;
  end;
end;

procedure TFrmFindUserId.EdFindIdKeyPress(Sender: TObject; var Key: Char);
var
  idx: integer;
  uid: string;
  ircd: FIdRcd;
begin
  if Key = #13 then begin
    Key := #0;
    IdGrid.RowCount := 1;
    uid := Trim(EdFindId.Text);
    if uid = '' then
      exit;
    with FSQLIDDB do begin
      try
        if Open then begin
          idx := Find(uid, ircd);
          if idx > 0 then begin
            MakeHumStr(-1, ircd);
          end;
        end;
      finally
        Close;
      end;
    end;
  end;
end;

procedure TFrmFindUserId.BtnFindAllClick(Sender: TObject);
var
  i: integer;
  uid: string;
  flist: TStringList;
  ircd: PFIdRcd;
begin
  IdGrid.RowCount := 1;
  uid := Trim(EdFindId.Text);
  if uid = '' then
    exit;
  flist := TStringList.Create;
  with FSQLIDDB do begin
    try
      if Open then begin
        FindLike(uid, flist);
        for i := 0 to flist.Count - 1 do begin
          ircd := PFIdRcd(flist.Objects[i]);
          MakeHumStr(-1, ircd^);
          Dispose(ircd);
        end;
      end;
    finally
      Close;
    end;
  end;
  flist.Free;
end;

procedure TFrmFindUserId.BtnEditClick(Sender: TObject);
var
  i, n, idx: integer;
  ircd, tmprcd: FIdRcd;
  uid: string;
  flag, bosuccess: Boolean;
  ue: TUserEntryInfo;
  ua: TUserEntryAddInfo;
begin
  FrmUserInfoEdit := TFrmUserInfoEdit.Create(nil);
  FrmUserInfoEdit.Top := Self.Top + 28;
  FrmUserInfoEdit.Left := Self.Left;
  n := IdGrid.Row;
  if n <= 0 then exit;
  uid := IdGrid.Cells[0, n];
  if uid = '' then exit;

  bosuccess := FALSE;
  with FSQLIDDB do begin
    flag := FALSE;
    try
      if Open then begin
        idx := Find(uid, ircd);
        if idx > 0 then begin
          flag := TRUE;
        end;
      end;
    finally
      Close;
    end;

    if FrmUserInfoEdit.Execute(ircd) then begin
      try
        if Open then begin
          idx := Find(uid, tmprcd);
          if idx > 0 then begin
            if WriteRecord(ircd, False) then begin
              ue := ircd.UserInfo.UInfo;
              ua := ircd.UserInfo.UAdd;
              MakeHumStr(n, ircd);
              bosuccess := TRUE;
            end;
          end;
        end;
      finally
        Close;
      end;
    end;
  end;
  FrmUserInfoEdit.Free;
   //if bosuccess then
   //   FrmMain.WriteLog ('ch2', ue, ua);
end;

procedure TFrmFindUserId.Button2Click(Sender: TObject);
var
  i, n, idx: integer;
  ircd, tmprcd: FIdRcd;
  uid: string;
  flag, bosuccess: Boolean;
  ue: TUserEntryInfo;
  ua: TUserEntryAddInfo;
begin
  FrmUserInfoEdit := TFrmUserInfoEdit.Create(nil);
  FrmUserInfoEdit.Top := Self.Top + 28;
  FrmUserInfoEdit.Left := Self.Left;
  FillChar(ircd, sizeof(FIdRcd), #0);
  bosuccess := FALSE;
  if FrmUserInfoEdit.ExecuteEdit(TRUE, ircd) then begin
    if ircd.UserInfo.UInfo.LoginId <> '' then begin
      uid := ircd.UserInfo.UInfo.LoginId;
      with FSQLIDDB do begin
        try
          if Open then begin
            idx := Find(uid, tmprcd);
            if idx <= 0 then begin
              if WriteRecord(ircd, TRUE) then
                bosuccess := TRUE;
            end;
          end;
        finally
          Close;
        end;
      end;
    end;
  end;
  if bosuccess then begin
    MainOutMessage(0, 'Making id success : ' + uid);
      //FrmMain.WriteLog ('ch2', ue, ua);
  end;
  FrmUserInfoEdit.Free;
end;

end.
