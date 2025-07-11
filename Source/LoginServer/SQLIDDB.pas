unit SQLIDDB;

interface

uses
  SysUtils, Classes, Forms, Grobal2, ADODB;

type
  TDBType = (tMaster, tAccount, tManage);

  TUserInfo = record
    UInfo: TUserEntryInfo;
    UAdd: TUserEntryAddInfo;
  end;

  FIdRcd = record
    Deleted: Boolean; {delete mark}
    MakeRcdDateTime: TDateTime;
    UpdateDateTime: TDateTime; //TDouble;
    UserInfo: TUserInfo;
  end;
  PFIdRcd = ^FIdRcd;

  TSQLIDDB = class
  private
    FADOConnection: TADOConnection;
    FADOQuery: TADOQuery;
    FConnInfo: string;
    FServer: string;
    FUserID: string;
    FPassword: string;
    FDB_Account: string;
    FDB_Manage: string;
    FLastConnTime: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;
    property SqlDB: TADOQuery read FADOQuery;
    property SqlCon: TADOConnection read FADOConnection;
    function Connect(server, id, password: string): Boolean;
    function ReConnect: Boolean;
    procedure Close;
    function Open: Boolean;
    function UseDB(dbdata: TDBType): Boolean;
    function OpenQuery(sqlstr: string): TADOQuery;
    function OpenConn(sqlstr: string): _Recordset;
    function ExeCuteSQL(sqlstr: string): Integer;
    function ReadRecord(uname: string; var rcd: FIdRcd): Boolean;
    function WriteRecord(rcd: FIdRcd; asnew: Boolean): Boolean;
    function DeleteRecord(uname: string): Boolean;
    function Find(uname: string; var rcd: FIdRcd): integer;
    function FindLike(uname: string; flist: TStrings): integer;
  end;

implementation

uses
  LoginSvrWnd, LSShare;

constructor TSQLIDDB.Create;
begin
  FADOConnection := TADOConnection.Create(nil);
  FADOQuery := TADOQuery.Create(nil);
  FADOConnection.ConnectOptions := coAsyncConnect;
  FADOConnection.ConnectionTimeout := 5;

  FConnInfo := '';
  FDB_Account := 'Account';   //多区需要改的
  FDB_Manage := 'Manage';  //多区需要改的
  FLastConnTime := 0;
end;

destructor TSQLIDDB.Destroy;
begin
  Close;

  FADOConnection.Free;
  FADOQuery.Free;
  inherited;
end;

function TSQLIDDB.Connect(server, id, password: string): Boolean;
begin
  Result := false;

  FServer := server;
  FUserID := id;
  FPassword := password;

  FConnInfo := 'Provider=SQLOLEDB.1;Password='         + password +
               ';Persist Security Info=True;User ID='  + id +
               ';Initial Catalog='                     + 'master' +
               ';Data Source='                         + server ;

  //-------------------------------------------
  try
    if FConnInfo <> '' then begin
      // Try Connect...
      FADOConnection.Connected := FALSE;
      FADOConnection.ConnectionString := FConnInfo;
      FADOConnection.LoginPrompt := false;
      FADOConnection.Connected := true;
      Result := FADOConnection.Connected;

      if Result = true then begin
        // ADO_Query setting...
        FADOQuery.Active := false;
        FADOQuery.Connection := FADOConnection;
        FLastConnTime := Now;
        MainOutMessage(0, 'SUCCESS DBSQL CONNECTION');
      end;
    end
    else begin
      //Setlog(0, ServerName+' : DBSQL CONNECTION INFO IS NULL!');
    end;
  except
    MainOutMessage(CERR, '[DB Error] ' + Exception(ExceptObject).Message);
  end;
end;

function TSQLIDDB.Open: Boolean;
begin
  if not UseDB(tMaster) then
    ReConnect;

  Result := FADOConnection.Connected;
end;

procedure TSQLIDDB.Close;
begin
  FAdoQuery.Active := false;
  FADOConnection.Connected := false;
end;

function TSQLIDDB.ReConnect: Boolean;
begin
  Result := false;
  // 15 檬俊 茄锅究 促矫 府目池记 秦夯促.
  //if (FlastConnMSec + 15 * 1000) < GetTickCount then begin

  Close;

//   MainOutMessage('[TestCode]Try to reconnect with DBSQL');
  Result := Connect(FServer, FUserID, FPassword);

  MainOutMessage(0, 'CAUTION! DBSQL RECONNECTION');
  //end;
end;

function TSQLIDDB.UseDB(dbdata: TDBType): Boolean;
var
  sdb: string;
begin
  try
    case dbdata of
      tMaster:
        sdb := 'master';
      tAccount:
        sdb := FDB_Account;
      tManage:
        sdb := FDB_Manage;
    end;
    FADOConnection.Execute('use ' + sdb);
    Result := TRUE;
  except
    Result := FALSE;
    MainOutMessage(CERR, '[DB Error] ' + Exception(ExceptObject).Message);
  end;
end;

function TSQLIDDB.OpenQuery(sqlstr: string): TADOQuery;
begin
  try
    FADOQuery.Close;
    FADOQuery.SQL.Text := sqlstr;
    FADOQuery.Open;
    Result := FADOQuery;
  except
    Result := nil;
    MainOutMessage(CERR, '[DB Error] ' + Exception(ExceptObject).Message);
  end;
end;

function TSQLIDDB.OpenConn(sqlstr: string): _Recordset;
begin
  try
    Result := FADOConnection.Execute(sqlstr);
  except
    Result := nil;
    MainOutMessage(CERR, '[DB Error] ' + Exception(ExceptObject).Message);
  end;
end;

function TSQLIDDB.ExeCuteSQL(sqlstr: string): Integer;
begin
  try
    FADOQuery.Close;
    FADOQuery.SQL.Text := sqlstr;
    Result := FADOQuery.ExecSQL;
  except
    Result := 0;
    MainOutMessage(CERR, '[DB Error] ' + Exception(ExceptObject).Message);
  end;
end;

function TSQLIDDB.DeleteRecord(uname: string): Boolean;
var
  oldpos: integer;
  nowtime: TDateTime;
  szQuery: string;
begin
  Result := FALSE; //Error;
  szQuery := Format('DELETE FROM TBL_ACCOUNT WHERE FLD_LOGINID = N''%s''', [uname]);
  UseDB(tAccount);
  if ExeCuteSQL(szQuery) > 0 then
    Result := TRUE;
end;

function TSQLIDDB.ReadRecord(uname: string; var rcd: FIdRcd): Boolean;
begin
  //未使用到
end;

function TSQLIDDB.WriteRecord(rcd: FIdRcd; asnew: Boolean): Boolean;
var
  ue: TUserEntryInfo;
  ua: TUserEntryAddInfo;
  szQuery: string;
begin
  Result := FALSE;
  ue := rcd.UserInfo.UInfo;
  ua := rcd.UserInfo.UAdd;
  if asnew then begin
    szQuery := Format( 'INSERT INTO TBL_ACCOUNT(FLD_LOGINID, FLD_PASSWORD, FLD_MAKETIME)' +
                             ' VALUES(''%s'', ''%s'', GetDate())',
                       [ue.LoginId, ue.Password] );

    UseDB (tAccount);
    if ExeCuteSQL (szQuery) <= 0 then exit;

    szQuery := Format( 'INSERT INTO TBL_ACCOUNTADD(FLD_LOGINID, FLD_USERNAME' +
                        ', FLD_SSNO, FLD_BIRTHDAY, FLD_EMAIL, FLD_PHONE' +
                        ', FLD_MOBILEPHONE, FLD_QUIZ1, FLD_ANSWER1, FLD_QUIZ2, FLD_ANSWER2)' +
                        ' VALUES(''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'' )',
                        [ue.LoginId, ue.UserName, ue.SSNo, ua.Birthday,
                         ue.EMail, ue.Phone, ua.MobilePhone, ue.Quiz,
                         ue.Answer, ua.Quiz2, ua.Answer2] );

    if ExeCuteSQL (szQuery) <= 0 then exit;
  end else begin
    szQuery :=  Format('UPDATE TBL_ACCOUNT SET FLD_PASSWORD = ''%s''' +
                         ' WHERE FLD_LOGINID=N''%s''',
                         [ue.Password, ue.LoginId] );

    UseDB (tAccount);
    if ExeCuteSQL (szQuery) <= 0 then exit;

    szQuery := Format('UPDATE TBL_ACCOUNTADD SET ' +
                         ' FLD_USERNAME = ''%s'', FLD_SSNO = ''%s'', FLD_BIRTHDAY = ''%s'',' +
                         ' FLD_EMAIL = ''%s'', FLD_PHONE = ''%s'', FLD_MOBILEPHONE = ''%s'',' +
                         ' FLD_QUIZ1 = ''%s'', FLD_ANSWER1 = ''%s'', FLD_QUIZ2 = ''%s'',' +
                         ' FLD_ANSWER2 = ''%s''' +
                         ' WHERE FLD_LOGINID=N''%s''',
                         [ue.UserName, ue.SSNo, ua.Birthday, ue.EMail,
                          ue.Phone, ua.MobilePhone, ue.Quiz, ue.Answer,
                          ua.Quiz2, ua.Answer2, ue.LoginId] );

    if ExeCuteSQL (szQuery) <= 0 then exit;
  end;
  Result := TRUE;
end;

function TSQLIDDB.Find(uname: string; var rcd: FIdRcd): integer;
var
  szQuery: string;
  pRec: TADOQuery;
begin
  Result := -1;
  FillChar (rcd, SizeOf(FIdRcd), #0);
  szQuery := Format('SELECT A.FLD_LOGINID, FLD_PASSWORD, FLD_MAKETIME'+
                    ',FLD_USERNAME, FLD_SSNO, FLD_BIRTHDAY'+
                    ',FLD_PHONE, FLD_EMAIL, FLD_MOBILEPHONE'+
                    ',FLD_QUIZ1, FLD_ANSWER1, FLD_QUIZ2, FLD_ANSWER2'+
                    ' FROM TBL_ACCOUNT A,TBL_ACCOUNTADD B WHERE A.FLD_LOGINID'+
                    ' = N''%s'' AND A.FLD_LOGINID = B.FLD_LOGINID',
                    [uname]);
  UseDB(tAccount);
  pRec := OpenQuery(szQuery);

  if (pRec <> nil) and (pRec.RecordCount > 0) then begin
    pRec.First;
    rcd.MakeRcdDateTime := pRec.FieldByName('FLD_MAKETIME').AsDateTime;
    rcd.UpdateDateTime := Now;
    with rcd.UserInfo do begin
      UInfo.LoginId := pRec.FieldByName('FLD_LOGINID').AsString;
      UInfo.Password := pRec.FieldByName('FLD_PASSWORD').AsString;
      UInfo.UserName := pRec.FieldByName('FLD_USERNAME').AsString;
      UInfo.SSNo := pRec.FieldByName('FLD_SSNO').AsString;
      UInfo.Phone := pRec.FieldByName('FLD_PHONE').AsString;
      UInfo.Quiz := pRec.FieldByName('FLD_QUIZ1').AsString;
      UInfo.Answer := pRec.FieldByName('FLD_ANSWER1').AsString;
      UInfo.EMail := pRec.FieldByName('FLD_EMAIL').AsString;
      UAdd.Birthday := pRec.FieldByName('FLD_BIRTHDAY').AsString;
      UAdd.MobilePhone := pRec.FieldByName('FLD_MOBILEPHONE').AsString;
      UAdd.Quiz2 := pRec.FieldByName('FLD_QUIZ2').AsString;
      UAdd.Answer2 := pRec.FieldByName('FLD_ANSWER2').AsString;
      UAdd.Memo1 := '';
      UAdd.Memo2 := '';
    end;
    Result := pRec.RecordCount;
  end;
  pRec.Close;
end;

function TSQLIDDB.FindLike(uname: string; flist: TStrings): integer; {found count}
var
  i: integer;
  rcd: PFIdRcd;
  szQuery: string;
  pRec: TADOQuery;
begin
  Result := -1;

  szQuery := Format('SELECT A.FLD_LOGINID, FLD_PASSWORD, FLD_MAKETIME'+
                    ',FLD_USERNAME, FLD_SSNO, FLD_BIRTHDAY'+
                    ',FLD_PHONE, FLD_EMAIL, FLD_MOBILEPHONE'+
                    ',FLD_QUIZ1, FLD_ANSWER1, FLD_QUIZ2, FLD_ANSWER2'+
                    ' FROM TBL_ACCOUNT A,TBL_ACCOUNTADD B WHERE A.FLD_LOGINID'+
                    ' LIKE N''%s%%'' AND A.FLD_LOGINID = B.FLD_LOGINID',
                    [uname]);
  UseDB(tAccount);
  pRec := OpenQuery(szQuery);
  if (pRec <> nil) and (pRec.RecordCount > 0) then begin
    pRec.First;
    while not pRec.EOF do begin
      New(rcd);
      FillChar(rcd^, SizeOf(FIdRcd), #0);
      rcd.MakeRcdDateTime := pRec.FieldByName('FLD_MAKETIME').AsDateTime;
      rcd.UpdateDateTime := Now;
      with rcd.UserInfo do begin
        UInfo.LoginId := pRec.FieldByName('FLD_LOGINID').AsString;
        UInfo.Password := pRec.FieldByName('FLD_PASSWORD').AsString;
        UInfo.UserName := pRec.FieldByName('FLD_USERNAME').AsString;
        UInfo.SSNo := pRec.FieldByName('FLD_SSNO').AsString;
        UInfo.Phone := pRec.FieldByName('FLD_PHONE').AsString;
        UInfo.Quiz := pRec.FieldByName('FLD_QUIZ1').AsString;
        UInfo.Answer := pRec.FieldByName('FLD_ANSWER1').AsString;
        UInfo.EMail := pRec.FieldByName('FLD_EMAIL').AsString;
        UAdd.Birthday := pRec.FieldByName('FLD_BIRTHDAY').AsString;
        UAdd.MobilePhone := pRec.FieldByName('FLD_MOBILEPHONE').AsString;
        UAdd.Quiz2 := pRec.FieldByName('FLD_QUIZ2').AsString;
        UAdd.Answer2 := pRec.FieldByName('FLD_ANSWER2').AsString;
        UAdd.Memo1 := '';
        UAdd.Memo2 := '';
      end;
      flist.AddObject(rcd.UserInfo.UInfo.LoginId, TObject(rcd));
      pRec.Next;
    end;
    pRec.Close;
  end;
//  pRec := nil;
  Result := flist.Count;
end;

end.
