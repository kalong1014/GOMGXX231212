unit NetGameServer;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, syncobjs, Grobal2, HUtil32,
  EdCode, mudutil, MfdbDef, ExtCtrls, Inifiles, ScktComp, FDBSQL, ADODB, DBShare;

type
  TCGameServer = class
    procedure SocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent:
      TErrorEvent; var ErrorCode: Integer);
    procedure SocketRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    procedure SendSocket (usock: TCustomWinSocket; str: string);
    function  MakeDefaultMsg(msg: word; soul: integer; wparam, atag, nseries: word): TDefaultMessage;
    procedure DecodeMessagePacket (data: AnsiString; datalen: integer; usock: TCustomWinSocket);
    procedure EmergencyServerClosed (usock: TCustomWinSocket);
    procedure DecodeSocData (pu: PTDBUserInfo);
  public
    ServerSocket: TServerSocket;
    constructor Create;
    destructor Destroy; override;
    procedure ClearList;
    procedure GetLoadHumanRcd (body: string; usock: TCustomWinSocket);
    procedure GetSaveHumanRcd (certify: integer; body: string; usock: TCustomWinSocket);
    procedure GetSaveAndChange (certify: integer; body: string; usock: TCustomWinSocket);

    procedure GetFriendList(body: string; usock: TCustomWinSocket);
    procedure GetFriendAdd(body: string; usock: TCustomWinSocket);
    procedure GetFriendDelete(body: string; usock: TCustomWinSocket);
    procedure GetFriendEdit(body: string; usock: TCustomWinSocket);
    procedure GetFriendOwnList (body: string; usock: TCustomWinSocket);

    procedure GetTagAdd(body: string; usock: TCustomWinSocket);
    procedure GetTagDelete (body: string; usock: TCustomWinSocket);
    procedure GetTagDeleteAll (body: string; usock: TCustomWinSocket);
    procedure GetTagList(body: string; usock: TCustomWinSocket);
    procedure GetTagSetInfo(body: string; usock: TCustomWinSocket);

    procedure GetTagRejectAdd(body: string; usock: TCustomWinSocket);
    procedure GetTagRejectDelete(body: string; usock: TCustomWinSocket);
    procedure GetTagRejectList(body: string; usock: TCustomWinSocket);
    procedure GetTagNotReadCount(body: string; usock: TCustomWinSocket);

    procedure GetLMList(body: string; usock: TCustomWinSocket);
    procedure GetLMAdd(body: string; usock: TCustomWinSocket);
    procedure GetLMDelete(body: string; usock: TCustomWinSocket);
    procedure GetLMEdit(body: string; usock: TCustomWinSocket);
    procedure GetLMEdit2(body: string; usock: TCustomWinSocket);
  end;

var
  CGameServer: TCGameServer;

implementation

uses
  DBSMain;

constructor TCGameServer.Create;
begin
  ServerSocket:= TServerSocket.Create(nil);
  ServerSocket.OnClientConnect := SocketConnect;
  ServerSocket.OnClientDisconnect := SocketDisconnect;
  ServerSocket.OnClientError := SocketError;
  ServerSocket.OnClientRead := SocketRead;

  m_listGameServer := TList.Create;
  UserIDList := TList.Create;

  ReceiveCount := 0;
  DecodeCount := 0;
  SendCount := 0;
  ErrorCount := 0;
  FailCount := 0;
  transcount := 0;
end;

destructor TCGameServer.Destroy;
begin
  ClearList;
  ServerSocket.Free;
  m_listGameServer.Free;
  UserIdList.Free;
  inherited;
end;

procedure TCGameServer.ClearList;
var
  i: integer;
begin
  for i := m_listGameServer.Count - 1 downto 0 do
    Dispose(m_listGameServer[i]);
  m_listGameServer.Clear;

  for i := UserIdList.Count - 1 downto 0 do
    Dispose(UserIdList[i]);
  UserIdList.Clear;
end;

procedure TCGameServer.SocketConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  uinfo: PTDBUserInfo;
  szLogMsg: string;
begin
  if not SQLLoading then begin
    New(uinfo);
    uinfo.Connected := TRUE;
    uinfo.Shandle := Socket.SocketHandle;
    uinfo.SocData := '';
    uinfo.USocket := Socket;
    m_listGameServer.Add(uinfo);
    szLogMsg := Format('[%s:%d] GameServer connected.', [Socket.RemoteAddress, Socket.RemotePort]);
    MainOutMessage(0, szLogMsg);
    AddLog(szLogMsg);
  end
  else begin
    Socket.Close;
  end;
end;

procedure TCGameServer.SocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i: integer;
  szLogMsg: string;
begin
  for i := 0 to m_listGameServer.Count - 1 do begin
    if PTDBUserInfo(m_listGameServer[i]).SHandle = Socket.SocketHandle then begin
      szLogMsg := Format('[%s:%d] GameServer disconnected.', [Socket.RemoteAddress, Socket.RemotePort]);
      MainOutMessage(CERR, szLogMsg);
      AddLog(szLogMsg);
      Dispose(PTDBUserInfo(m_listGameServer[i]));
      m_listGameServer.Delete(i);
      EmergencyServerClosed(Socket);
      break;
    end;
  end;
end;

procedure TCGameServer.SocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent:
  TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  SocketDisconnect(self, Socket);
  Socket.Close;
end;

procedure TCGameServer.SocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i: integer;
  str, data: string;
  pu: PTDBUserInfo;
begin
  for i := 0 to m_listGameServer.Count - 1 do begin
    pu := PTDBUserInfo(m_listGameServer[i]);
    if pu.SHandle = Socket.SocketHandle then begin
      str := Socket.ReceiveText;
      Inc(ReceiveCount);
      if str <> '' then begin
        pu.SocData := pu.SocData + str;
        if pos ('!', str) >= 1 then begin
          DecodeSocData(pu);
          Inc(DecodeCount);
          Inc(transcount);
        end else begin
          if Length(pu.SocData) > 81920 then begin
            pu.SocData := '';
            Inc(HackCountHeavyPacket);
          end;
        end;
      end;
      break;
    end;
  end;
end;

procedure TCGameServer.DecodeSocData(pu: PTDBUserInfo);
var
  cc: AnsiString;
  w1, w2: word;
  len, v: integer;
  str, data, certify: AnsiString;
  flag: Boolean;
begin
  if SQLLoading then exit;
  try
    flag := FALSE;
    str := AnsiString(pu.SocData);
    pu.SocData := '';
    data := '';
    while True do begin
      str := AnsiArrestStringEx(str, '#', '!', data);
      if data <> '' then begin
        data := AnsiGetValidStr3(data, certify, ['/']);
{$IFDEF DEBUG}
  MainOutMessage(CRECV, Format('[GS/%d]', [Length(data)]));
{$ENDIF}
        len := Length(data);
        if (len >= DEFBLOCKSIZE) and (certify <> '') then begin
          w1 := Str_ToInt(certify, 0) xor $aa;
          w2 := word(len);
          v := MakeLong(w1, w2);
          cc := EncodeBuffer(@v, sizeof(integer));
          CurCertify := certify;
          if AnsiCompareBackLStr(data, cc, Length(cc)) then begin
            DecodeMessagePacket(data, len, pu.USocket);
            flag := TRUE;
          end;
        end;
      end;
      if Pos('!', str) <= 0 then Break;
    end;
    if str <> '' then begin
      Inc(ErrorCount);
      FrmDBSrv.LabelErrorCount.Caption := 'Error ' + IntToStr(ErrorCount);
      MainOutMessage(CRECV, Format('[DecodeSocData Error]=%s', [str]));
    end;
    if not flag then begin
      Def := MakeDefaultMsg(DBR_FAIL, 0, 0, 0, 0);  {Fail}
      SendSocket(pu.USocket, EncodeMessage(Def));
      Inc(ErrorCount);
      FrmDBSrv.LabelErrorCount.Caption := 'Error ' + IntToStr(ErrorCount);
    end;
  except
  end;
end;

procedure TCGameServer.EmergencyServerClosed(usock: TCustomWinSocket);
var
  i: integer;
  pid: PTUserIDInfo;
begin
  i := 0;
  while TRUE do begin
    if i >= UserIdList.Count then break;
    pid := PTUserIDInfo(UserIdList[i]);
    if pid.ServerSocket = usock then begin
      Dispose(pid);
      UserIdList.Delete(i);
    end else
      Inc(i);
  end;
end;

function TCGameServer.MakeDefaultMsg(msg: word; soul: integer; wparam, atag, nseries: word): TDefaultMessage;
begin
  with Result do begin
    Ident := msg;
    Recog := soul;
    param := wparam;
    Tag := atag;
    Series := nseries;
  end;
end;

procedure TCGameServer.SendSocket(usock: TCustomWinSocket; str: string);
var
  cert: integer;
  len: word;
  cc: string;
begin
  Inc(SendCount);
  len := Length(str) + 6;
  cert := MakeLong(Str_ToInt(CurCertify, 0) xor $aa, len);
  cc := EncodeBuffer(@cert, sizeof(integer));
  usock.SendText('#' + CurCertify + '/' + str + cc + '!');
end;

procedure TCGameServer.DecodeMessagePacket(data: AnsiString; datalen: integer;
  usock: TCustomWinSocket);
var
  msg: TDefaultMessage;
  head, body: string;
begin
  if datalen = DEFBLOCKSIZE then begin
    head := data;
    body := '';
  end
  else begin
    head := Copy(data, 1, DEFBLOCKSIZE);
    body := Copy(data, DEFBLOCKSIZE + 1, Length(data) - DEFBLOCKSIZE - 6);
  end;
  msg := DecodeMessage(head);

  case msg.Ident of
    DB_LOADHUMANRCD:
      begin
        GetLoadHumanRcd(body, usock);
      end;

    DB_SAVEHUMANRCD:
      begin
        GetSaveHumanRcd(msg.Recog, body, usock);
      end;

    DB_SAVEANDCHANGE:
      begin
        GetSaveAndChange(msg.Recog, body, usock);
      end;
    //-------------------------------------------------------
    DB_FRIEND_LIST:
      begin
        GetFriendList(body, usock);
      end;
    DB_FRIEND_ADD:
      begin
        GetFriendAdd(body, usock);
      end;
    DB_FRIEND_DELETE:
      begin
        GetFriendDelete(body, usock);
      end;
    DB_FRIEND_OWNLIST:
      begin
        GetFriendOwnList(body, usock);
      end;
    DB_FRIEND_EDIT:
      begin
        GetFriendEdit(body, usock);
      end;
    //-------------------------------------------------------
    DB_TAG_ADD:
      begin
        GetTagAdd(body, usock);
      end;
    DB_TAG_DELETE:
      begin
        GetTagDelete(body, usock);
      end;
    DB_TAG_DELETEALL:
      begin
        GetTagDeleteAll(body, usock);
      end;
    DB_TAG_LIST:
      begin
        GetTagList(body, usock);
      end;
    DB_TAG_SETINFO:
      begin
        GetTagSetInfo(body, usock);
      end;
    DB_TAG_REJECT_ADD:
      begin
        GetTagRejectAdd(body, usock);
      end;
    DB_TAG_REJECT_DELETE:
      begin
        GetTagRejectDelete(body, usock);
      end;
    DB_TAG_REJECT_LIST:
      begin
        GetTagRejectList(body, usock);
      end;
    DB_TAG_NOTREADCOUNT:
      begin
        GetTagNotReadCount(body, usock);
      end;
    //-------------------------------------------------------
    DB_LM_LIST:
      begin
        GetLMList(body, usock);
      end;
    DB_LM_ADD:
      begin
        GetLMAdd(body, usock);
      end;
    DB_LM_EDIT:
      begin
        GetLMEdit(body, usock);
      end;
    DB_LM_EDIT2:
      begin
        GetLMEdit2(body, usock);
      end;
    DB_LM_DELETE:
      begin
        GetLMDelete(body, usock);
      end;
  else
    begin
      Def := MakeDefaultMsg(DBR_FAIL, 0, 0, 0, 0);  {Fail}
      SendSocket(usock, EncodeMessage(Def));
      Inc(FailCount);
      MainOutMessage(CERR, 'Fail ' + IntToStr(FailCount));
    end;
  end;
end;

procedure TCGameServer.GetLoadHumanRcd (body: string; usock: TCustomWinSocket);
var
  i, rr, nCnt, nBagItem, nSaveItem, nSECONDS: Integer;
  lhuman: TLoadHuman;
  rcd: FDBRecord;
  pRec: TADOQuery;
  szQuery: AnsiString;
  CharFields: TCharacterFields;
//  AbilFields: TAbilityFields;
  MagicFields: TMagicFields;
  ItemFields: TItemFields;
begin
	rr := 0;
  DecodeBuffer (body, @lhuman, sizeof(TLoadHuman));
  ZeroMemory(@rcd, sizeof(rcd));

	if ( g_FDBSQL.Connected ) then begin

    if (g_FDBSQL.MakeSqlParam (szQuery, SQLTYPE_SELECTWHERE, @__CHARACTERTABLE, [StrPas(lhuman.ChrName), StrPas(lhuman.UsrId)])) then
    begin
      // To PDS
//       SetLog(0, Format('OnLoadQuery: %s', [szQuery]));
      g_FDBSQL.UseDB (tGame);
      pRec := g_FDBSQL.OpenQuery (szQuery);
      if ( pRec <> nil ) and ( pRec.RecordCount > 0 ) then begin
        g_FDBSQL._GetFields(pRec, @__CHARACTERTABLE, @CharFields);
        g_FDBSQL._SetRecordTHuman(@CharFields, @rcd.Block.DBHuman);
        pRec.Close;

        // TO PDS: DELETE ABIL RECORD
        (*
        makesqlparam(szQuery, SQLTYPE_SELECTWHERE, @__ABILITYTABLE, [StrPas(lhuman.szName)]);

        pRec := g_FDBSQL.OpenQuery (szQuery);
        if ( pRec.RecordCount > 0 ) then begin
          _getfields(pRec, @__ABILITYTABLE, @AbilFields);
          _FieldsToStrucAbil(@tAbilFields, @rcd.Block.DBHuman.Abil);
        end;
        pRec.Close;
        *)

        g_FDBSQL.MakeSqlParam(szQuery, SQLTYPE_SELECTWHERE, @__MAGICTABLE, [StrPas(lhuman.ChrName)]);
        szQuery := szQuery + ' ORDER BY FLD_POS';
//        SetLog(0, szQuery );
        pRec := g_FDBSQL.OpenQuery (szQuery);
        if ( pRec <> nil ) and ( pRec.RecordCount > 0 )  then begin
          nCnt := 0;
          pRec.First;
          while ( not pRec.EOF ) do begin
            g_FDBSQL._GetFields(pRec, @__MAGICTABLE, @MagicFields);
            g_FDBSQL._FieldsToStrucUseMagic(@MagicFields, @rcd.Block.DBUseMagic.Magics[nCnt]);
            Inc(nCnt);
            pRec.Next;
          end;
          pRec.Close;
        end;
        pRec.Close;

        g_FDBSQL.LoadQuest(@rcd.Block.DBHuman, lhuman.ChrName);	// Fetch Quest Info.

        if (g_FDBSQL.MakeSqlParam(szQuery, SQLTYPE_SELECTWHERENOT, @__ITEMTABLE, [StrPas(lhuman.ChrName), U_SAVE])) then
        begin
          szQuery := szQuery + ' ORDER BY FLD_POS';
//          SetLog(0, szQuery );
          pRec:= g_FDBSQL.OpenQuery(szQuery);
          if ( pRec <> nil ) and ( pRec.RecordCount > 0 ) then begin
            nBagItem := 0;
            pRec.First;
            while ( not pRec.EOF ) do begin
              g_FDBSQL._GetFields(pRec, @__ITEMTABLE, @ItemFields);
              g_FDBSQL._SetRecordTBagItem(@ItemFields, @rcd.Block.DBBagItem, @nBagItem);
              pRec.Next;
            end;
            pRec.Close;
          end;
        end;
        pRec.Close;

      // TO PDS
      // if (_makesqlparam(szQuery, SQLTYPE_SELECTWHERE, &__SAVEDITEMTABLE, lhuman.szName ))
        if (g_FDBSQL.MakeSqlParam(szQuery, SQLTYPE_SELECTWHERE, @__ITEMTABLE, [StrPas(lhuman.ChrName), U_SAVE])) then
        begin
          szQuery := szQuery + ' ORDER BY FLD_POS';
          pRec := g_FDBSQL.OpenQuery (szQuery);
          if ( pRec <> nil ) and ( pRec.RecordCount > 0) then begin
            nSaveItem := 0;
            pRec.First;
            while ( not pRec.EOF ) do begin
              /// TO PDS
              //_getfields(pRec, @__SAVEDITEMTABLE, @ItemFields);
              g_FDBSQL._GetFields(pRec, @__ITEMTABLE, @ItemFields);

              rcd.Block.DBSaveItem.Items[nSaveItem].MakeIndex	:= ItemFields.fld_makeindex;
              rcd.Block.DBSaveItem.Items[nSaveItem].Index		:= ItemFields.fld_index;
              rcd.Block.DBSaveItem.Items[nSaveItem].Dura		:= ItemFields.fld_dura;
              rcd.Block.DBSaveItem.Items[nSaveItem].DuraMax	:= ItemFields.fld_duramax;

              for  i := 0 to 13  do
                rcd.Block.DBSaveItem.Items[nSaveItem].Desc[i]	:= BYTE(ItemFields.fld_desc[i]);

              rcd.Block.DBSaveItem.Items[nSaveItem].ColorR		:= ItemFields.fld_colorr;
              rcd.Block.DBSaveItem.Items[nSaveItem].ColorG		:= ItemFields.fld_colorg;
              rcd.Block.DBSaveItem.Items[nSaveItem].ColorB		:= ItemFields.fld_colorb;

              if strlen(ItemFields.Prefix) > 0 then begin
                MainOutMessage( 0, Format('SavedItem[LOAD] : %c %c %c', [ItemFields.Prefix[0], ItemFields.Prefix[1], ItemFields.Prefix[2]]));
                ZeroMemory(@rcd.Block.DBSaveItem.Items[nSaveItem].Prefix, sizeof(rcd.Block.DBSaveItem.Items[nSaveItem].Prefix));
//									strcopy(rcd.Block.DBSaveItem.Items[nSaveItem].Prefix, ItemFields.Prefix);
              end
              else
                ZeroMemory(@rcd.Block.DBSaveItem.Items[nSaveItem].Prefix, sizeof(rcd.Block.DBSaveItem.Items[nSaveItem].Prefix));

              Inc(nSaveItem);
              pRec.Next;
            end;
            pRec.Close;
          end;
        end;

        pRec.Close;

        rr := 1;
      end else // if ( pRec.RecordCount > 0 ) then
        pRec.Close;
    end else
      pRec.Close;

    g_FDBSQL.UseDB(tAccount);
    szQuery := Format('SELECT * FROM TBL_ACCOUNT WHERE FLD_LOGINID=''%s''', [rcd.Block.DBHuman.UserId]);
    pRec := g_FDBSQL.OpenQuery(szQuery);
    if pRec <> nil then
    begin
      if pRec.RecordCount > 0 then
      begin
        pRec.First;
        while (not pRec.EOF) do
        begin
          nSECONDS := pRec.FieldByName('FLD_MIAOKA').AsInteger;
          rcd.Block.DBHuman.Seconds := nSECONDS;
          pRec.Next;
        end;
        pRec.Close;
      end;
    end;
	end;

	if (rr = 1) then begin
		// total
		//size = sizeof( rcd ) ;
		//size = sizeof ( rcd.Block );
		//size = sizeof ( rcd.Block.DBHuman   );
		//size = sizeof ( rcd.Block.DBBagItem );
		//size = sizeof ( rcd.Block.DBSaveItem);
		//size = sizeof ( rcd.Block.DBUseMagic);

    Def := MakeDefaultMsg (DBR_LOADHUMANRCD, 1, 0, 0, 1);
    SendSocket (usock, EncodeMessage (Def) +
               EncodeString(lhuman.ChrName) + '/' +
               EncodeBuffer(@rcd, sizeof(FDBRecord)));
//		Inc(m_nLoadCount);
	end
	else
	begin
    Def := MakeDefaultMsg (DBR_LOADHUMANRCD, rr, 0, 0, 0);
    SendSocket (usock, EncodeMessage (Def));
//		Inc(m_nLoadFailCount);
	end;
end;

procedure TCGameServer.GetSaveHumanRcd (certify: integer; body: string; usock: TCustomWinSocket);
var
  fFail, fCommit: Boolean;
  rcd: FDBRecord;
  str, szID, szName, szLogMsg, szQuery: string;
  pRec: TADOQuery;
  CharFields: TCharacterFields;
//  AbilFields: TAbilityFields;
  nSECONDS: Integer;
begin
	fFail := false;
	fCommit := false;

	if body = '' then exit;
	// To PDS
	// AddLog ( body );

	str := GetValidStr3 (body, szID, ['/']);
  str := GetValidStr3 (str, szName, ['/']);

	szID := DecodeString (szID);
  szName := DecodeString (szName);

	ZeroMemory(@rcd, sizeof(FDBRecord));

//	if (strlen(str) - 6 = UpInt(sizeof(FDBRecord)*4/3))
// SIZEOFFDB(4937) *4/3 = 6583
	if Length(str) = UpInt(sizeof(FDBRecord)*4/3) then	// 6583 , 6582	 // 6647  // Encode FDBRecord size
		DecodeBuffer (str, @rcd, sizeof(FDBRecord))
	else
	begin
{$IFDEF DEBUG}
		szLogMsg := Format('Packet Size:%d, Struct Size:%d', [Length(str), UpInt(sizeof(FDBRecord)*4/3)]);
		MainOutMessage( 0, szLogMsg );
{$ENDIF}
		fFail := true;
	end;
	if szName = '' then fFail := TRUE;

	if not fFail then begin
		if g_FDBSQL.Connected then begin
      g_FDBSQL.UseDB (tGame);
      g_FDBSQL.SqlCon.BeginTrans;
      g_FDBSQL._SetRecordCharFields(@CharFields, @rcd.Block.DBHuman);
      // To PDS
      //_StrucToFieldsAbil(@AbilFields, @rcd.Block.DBHuman.Abil, szName);

//				szLogMsg := Format( 'Update transaction -> User [%s/%s].', [szID, szName] );
//				m_TransLog.Log ( szLogMsg, true );

      if (g_FDBSQL.UpdateRecord(@__CHARACTERTABLE, @CharFields, false)) then
      begin
        // TO PDS: if (true)
        // if (UpdateRecord(m_AdoCon, @__ABILITYTABLE, @tAbilFields, false))
        if ( true ) then begin
      //		pConn->DestroyRecordset( pRec );

          if (g_FDBSQL.SaveUseMagic(@rcd.Block.DBUseMagic, szName)) then
          begin
            if (g_FDBSQL.SaveBagItem(@rcd.Block.DBBagItem, szName)) then
            begin
              if (g_FDBSQL.SaveSaveItem(@rcd.Block.DBSaveItem, szName)) then
              begin
                if (g_FDBSQL.SaveQuest(@rcd.Block.DBHuman, szName)) then
                  fCommit := true
                else
                  fCommit := false;
              end else
                fCommit := false;
            end else
              fCommit := false;
          end else
            //pConn->DestroyRecordset( pRec );
            fCommit := false;
        end else
        begin
          //pConn->DestroyRecordset( pRec );
          fCommit := false;
        end;
      end
      else
      begin
        fCommit := false;
      end;

			g_FDBSQL.SqlCon.CommitTrans;

//			if (fCommit) then
//				szLogMsg := Format('Update transaction [commit] -> User [%s/%s].', [szID, szName] )
//			else
//				szLogMsg := Format('Update transaction [rollback] -> User [%s/%s].', [szID, szName] );

//			SetLog ( CDBG, szLogMsg );
//			m_TransLog.Log ( szLogMsg, true );


      szQuery := Format('UPDATE TBL_ACCOUNT SET ' + ' FLD_MIAOKA = ''%d''' + ' WHERE FLD_LOGINID=N''%s''', [rcd.Block.DBHuman.Seconds, rcd.Block.DBHuman.UserId]);
      g_FDBSQL.UseDB(tAccount);
      with g_FDBSQL.SqlDB do
      begin
        Close;
        SQL.Text := szQuery;
        try
          ExecSQL;
        except
          exit;
        end;
      end;

		end;
	end;

	if not fFail then begin
(*		  for i:=0 to UserIdList.Count-1 do begin
			 puser := PTUserIdInfo (UserIdList[i]);
			 if (puser.ChrName = uname) and (puser.Certification = certify) then begin
				puser.OpenTime := GetCurrentTime; //Timeout ����
			 end;
		  end; *)
		Def := MakeDefaultMsg (DBR_SAVEHUMANRCD, 1, 0, 0, 0); {SUCCESS}
    SendSocket (usock, EncodeMessage (Def));
//		Inc(m_nSaveCount);
	end
	else
	begin
		Def := MakeDefaultMsg (DBR_SAVEHUMANRCD, 0, 0, 0, 0); {ABORT}
    SendSocket (usock, EncodeMessage (Def));
//		Inc(m_nSaveFailCount);
	end;
end;

procedure TCGameServer.GetSaveAndChange (certify: integer; body: string; usock: TCustomWinSocket);
var
   i: integer;
   str, uid, uname: string;
   puid: PTUserIdInfo;
begin
   str := GetValidStr3 (body, uid, ['/']);
   str := GetValidStr3 (str, uname, ['/']);
   uname := DecodeString (uname);
   uid := DecodeString (uid);
   for i:=0 to UserIdList.Count-1 do begin
      puid := PTUserIdInfo (UserIdList[i]);
      if (puid.UsrId = uid) and (puid.Certification = certify) then begin
         puid.RunConnect := FALSE;
         puid.ServerSocket := usock;
         puid.Connecting := TRUE;
         puid.OpenTime := GetCurrentTime;
         break;
      end;
   end;
   GetSaveHumanRcd (certify, body, usock);
end;

procedure TCGameServer.GetFriendList (body: string; usock: TCustomWinSocket);
var
  szUserName, szQuery: string;
  szFldFriend, szFldDesc: string;
  szFldState, nCnt: Integer;
  szTemp1, szTemp2: string;
  pRec: TADOQuery;
begin
  GetValidStr3(body, szUserName, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!1] %s', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_FRIEND_LIST ''%s''', [szUserName]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.OpenQuery (szQuery);

    if pRec <> nil then begin
      if pRec.RecordCount > 0 then begin
        nCnt := 0;
        pRec.First;
        while ( not pRec.EOF ) do begin
          szFldFriend := Trim(pRec.FieldByName('FLD_FRIEND').AsString);
          szFldState := pRec.FieldByName('FLD_STATE').AsInteger;
          szFldDesc := Trim(pRec.FieldByName('FLD_DESC').AsString);
          if szFldDesc <> '' then
            szTemp2 := Format('%d:%s:%s/',[szFldState , szFldFriend , szFldDesc])
          else
            szTemp2 := Format('%d:%s:/',[szFldState , szFldFriend]);

          szTemp1 := szTemp1 + szTemp2;
          Inc(nCnt);
          pRec.Next;
        end;
        pRec.Close;

        szTemp2 := Format('%s/%d/%d/%s',[szUserName, DB_FRIEND_LIST, nCnt, szTemp1]);

        Def := MakeDefaultMsg (DBR_FRIEND_LIST, 1, 0, 0, 0);
        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(AnsiString(szTemp2)));
      end;
    end;
  end;
end;

procedure TCGameServer.GetFriendAdd (body: string; usock: TCustomWinSocket);
var
  szUserName, szData, szQuery, szState, szFriend, szDesc, szFldReturn, szTemp: string;
  fld_return: Integer;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szData, ['/']);

  szData := GetValidStr3(szData, szState, [':']);
  szDesc := GetValidStr3(szData, szFriend, [':']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!2] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_FRIEND_ADD ''%s'',''%s'',''%s'',''%s''', [szUserName, szState, szFriend, szDesc]);
    g_FDBSQL.UseDB (tGame);
    pRec := g_FDBSQL.Execute(szQuery);

//    if pRec <> nil then begin
//      if pRec.RecordCount > 0 then begin
//        pRec.First;
//        while ( not pRec.EOF ) do begin
//          szFldReturn := Trim(pRec.FieldByName('FLD_RETURN').AsString);
//          fld_return := StrToInt(szFldReturn);
//          pRec.Next;
//        end;
//        pRec.Close;
//
//        szTemp := PAnsiChar(Format('%s/%d',[szUserName, DB_FRIEND_ADD]));
//        Def := MakeDefaultMsg (DBR_FRIEND_RESULT, fld_return, 0, 0, 0);
//        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(szTemp));
//      end;
//    end;
    pRec.Close;
  end;
end;

procedure TCGameServer.GetFriendDelete (body: string; usock: TCustomWinSocket);
var
  szUserName, szFriend, szQuery: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szFriend, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!3] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_FRIEND_DELETE ''%s'',''%s''', [szUserName, szFriend]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
//    if pRec <> nil then begin
//      if pRec.RecordCount > 0 then begin
//        pRec.First;
//        while ( not pRec.EOF ) do begin
//          szFldReturn := Trim(pRec.FieldByName('FLD_RETURN').AsString);
//          fld_return := StrToInt(szFldReturn);
//          pRec.Next;
//        end;
//        pRec.Close;
//
//        szTemp := PAnsiChar(Format('%s/%d',[szUserName, DB_FRIEND_DELETE]));
//        Def := MakeDefaultMsg (DBR_FRIEND_RESULT, fld_return, 0, 0, 0);
//        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(szTemp));
//      end;
//    end;
    pRec.Close;
  end;
end;

procedure TCGameServer.GetFriendEdit (body: string; usock: TCustomWinSocket);
var
  szUserName, szData, szQuery, szFriend, szDesc: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szData, ['/']);

  szDesc := GetValidStr3(szData, szFriend, [':']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!4] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_FRIEND_SETDESC ''%s'',''%s'',''%s''', [szUserName, szFriend, szDesc]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
//    if pRec <> nil then begin
//      if pRec.RecordCount > 0 then begin
//        pRec.First;
//        while ( not pRec.EOF ) do begin
//          szFldReturn := Trim(pRec.FieldByName('FLD_RETURN').AsString);
//          fld_return := StrToInt(szFldReturn);
//          pRec.Next;
//        end;
//        pRec.Close;
//
//        szTemp := PAnsiChar(Format('%s/%d',[szUserName, DB_FRIEND_EDIT]));
//        Def := MakeDefaultMsg (DBR_FRIEND_RESULT, fld_return, 0, 0, 0);
//        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(szTemp));
//      end;
//    end;
    pRec.Close;
  end;
end;

procedure TCGameServer.GetFriendOwnList (body: string; usock: TCustomWinSocket);
var
  szUserName, szFldFriend, szQuery: string;
  nCnt: Integer;
  szTemp1, szTemp2: string;
  pRec: TADOQuery;
begin
  GetValidStr3(body, szUserName, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!5] %s', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_FRIEND_LINKEDLIST ''%s''', [szUserName]);
    g_FDBSQL.UseDB (tGame);
    pRec := g_FDBSQL.OpenQuery (szQuery);

    if pRec <> nil then begin
      if pRec.RecordCount > 0 then begin
        nCnt := 0;
        pRec.First;
        while ( not pRec.EOF ) do begin
          szFldFriend := Trim(pRec.FieldByName('FLD_CHARACTER').AsString);
          szTemp2 := Format('%s/',[szFldFriend]);

          szTemp1 := szTemp1 + szTemp2;
          Inc(nCnt);
          pRec.Next;
        end;
        pRec.Close;

        szTemp2 := Format('%s/%d/%d/%s',[szUserName, DB_FRIEND_OWNLIST, nCnt, szTemp1]);

        Def := MakeDefaultMsg (DBR_FRIEND_WONLIST, 1, 0, 0, 0);
        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(AnsiString(szTemp2)));
      end;
    end;
  end;
end;

procedure TCGameServer.GetTagAdd (body: string; usock: TCustomWinSocket);
var
  szUserName, szData, szQuery, szState, szDate, szReciever, szDesc: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szData, ['/']);

  szData := GetValidStr3(szData, szState, [':']);
  szData := GetValidStr3(szData, szDate, [':']);
  szDesc := GetValidStr3(szData, szReciever, [':']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!6] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_TAG_ADD ''%s'',''%s'',''%s'',''%s'',''%s''', [szReciever, szDate, szState, szUserName, szDesc]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
//    if pRec <> nil then begin
//      if pRec.RecordCount > 0 then begin
//        pRec.First;
//        while ( not pRec.EOF ) do begin
//          szFldReturn := Trim(pRec.FieldByName('FLD_RETURN').AsString);
//          fld_return := StrToInt(szFldReturn);
//          pRec.Next;
//        end;
//        pRec.Close;
//
//        szTemp := PAnsiChar(Format('%s/%d',[szUserName, DB_TAG_ADD]));
//        Def := MakeDefaultMsg (DBR_TAG_RESULT, fld_return, 0, 0, 0);
//        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(szTemp));
//      end;
//    end;
    pRec.Close;
  end;
end;

procedure TCGameServer.GetTagDelete (body: string; usock: TCustomWinSocket);
var
  szUserName, szSendDate, szQuery: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szSendDate, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!7] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_TAG_DELETE ''%s'',''%s''', [szUserName, szSendDate]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
//    if pRec <> nil then begin
//      if pRec.RecordCount > 0 then begin
//        pRec.First;
//        while ( not pRec.EOF ) do begin
//          szFldReturn := Trim(pRec.FieldByName('FLD_RETURN').AsString);
//          fld_return := StrToInt(szFldReturn);
//          pRec.Next;
//        end;
//        pRec.Close;
//
//        szTemp := PAnsiChar(Format('%s/%d',[szUserName, DB_TAG_DELETE]));
//        Def := MakeDefaultMsg (DBR_TAG_RESULT, fld_return, 0, 0, 0);
//        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(szTemp));
//      end;
//    end;
    pRec.Close;
  end;
end;

procedure TCGameServer.GetTagDeleteAll(body: string; usock: TCustomWinSocket);
var
  szUserName, szQuery: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!8] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_TAG_DELETEALL ''%s''', [szUserName]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
//    if pRec <> nil then begin
//      if pRec.RecordCount > 0 then begin
//        pRec.First;
//        while ( not pRec.EOF ) do begin
//          szFldReturn := Trim(pRec.FieldByName('FLD_RETURN').AsString);
//          fld_return := StrToInt(szFldReturn);
//          pRec.Next;
//        end;
//        pRec.Close;
//
//        szTemp := PAnsiChar(Format('%s/%d',[szUserName, DB_TAG_DELETEALL]));
//        Def := MakeDefaultMsg (DBR_TAG_RESULT, fld_return, 0, 0, 0);
//        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(szTemp));
//      end;
//    end;
    pRec.Close;
  end;
end;

procedure TCGameServer.GetTagList (body: string; usock: TCustomWinSocket);
var
  szUserName, szFldDate, szFldSender, szFldDesc, szQuery: string;
  szFldState, nCnt: Integer;
  szTemp1, szTemp2: string;
  pRec: TADOQuery;
begin
  GetValidStr3(body, szUserName, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!9] %s', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_TAG_LIST ''%s''', [szUserName]);
    g_FDBSQL.UseDB (tGame);
    pRec := g_FDBSQL.OpenQuery (szQuery);

    if pRec <> nil then begin
      if pRec.RecordCount > 0 then begin
        nCnt := 0;
        pRec.First;
        while ( not pRec.EOF ) do begin
          szFldState	:= pRec.FieldByName('FLD_STATE').AsInteger;
          szFldDate   := Trim(pRec.FieldByName('FLD_DATE').AsString);
          szFldSender := Trim(pRec.FieldByName('FLD_SENDER').AsString);
          szFldDesc   := Trim(pRec.FieldByName('FLD_DESC').AsString);

          szTemp2 := Format('%d:%s:%s:%s/',[szFldState , szFldDate , szFldSender, szFldDesc]);
          szTemp1 := szTemp1 + szTemp2;
          Inc(nCnt);
          pRec.Next;
        end;
        pRec.Close;

        szTemp2 := Format('%s/%d/%d/%s',[szUserName, DB_TAG_LIST, nCnt, szTemp1]);

        Def := MakeDefaultMsg (DBR_TAG_LIST, 1, 0, 0, 0);
        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(AnsiString(szTemp2)));
      end;
    end;
  end;
end;

procedure TCGameServer.GetTagSetInfo(body: string; usock: TCustomWinSocket);
var
  szUserName, szTemp, szQuery, szState, szDate: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szTemp, ['/']);

  szDate := GetValidStr3(szTemp, szState, [':']);
//  szTemp := GetValidStr3(szTemp, szDate, [':']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!10] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_TAG_SETINFO ''%s'',''%s'',''%s''', [szUserName, szDate, szState]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
//    if pRec <> nil then begin
//      if pRec.RecordCount > 0 then begin
//        pRec.First;
//        while ( not pRec.EOF ) do begin
//          szFldReturn := Trim(pRec.FieldByName('FLD_RETURN').AsString);
//          fld_return := StrToInt(szFldReturn);
//          pRec.Next;
//        end;
//        pRec.Close;
//
//        szTemp := PAnsiChar(Format('%s/%d',[szUserName, DB_TAG_SETINFO]));
//        Def := MakeDefaultMsg (DBR_TAG_RESULT, fld_return, 0, 0, 0);
//        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(szTemp));
//      end;
//    end;
    pRec.Close;
  end;
end;

procedure TCGameServer.GetTagRejectAdd(body: string; usock: TCustomWinSocket);
var
  szUserName, szRejecter, szQuery: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szRejecter, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!11] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_TAG_REJECTADD ''%s'',''%s''', [szUserName, szRejecter]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
//    if pRec <> nil then begin
//      if pRec.RecordCount > 0 then begin
//        pRec.First;
//        while ( not pRec.EOF ) do begin
//          szFldReturn := Trim(pRec.FieldByName('FLD_RETURN').AsString);
//          fld_return := StrToInt(szFldReturn);
//          pRec.Next;
//        end;
//        pRec.Close;
//
//        szTemp := PAnsiChar(Format('%s/%d',[szUserName, DB_TAG_REJECT_ADD]));
//        Def := MakeDefaultMsg (DBR_TAG_RESULT, fld_return, 0, 0, 0);
//        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(szTemp));
//      end;
//    end;
    pRec.Close;
  end;
end;

procedure TCGameServer.GetTagRejectDelete(body: string; usock: TCustomWinSocket);
var
  szUserName, szRejecter, szQuery: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szRejecter, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!12] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_TAG_REJECTDELETE ''%s'',''%s''', [szUserName, szRejecter]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
//    if pRec <> nil then begin
//      if pRec.RecordCount > 0 then begin
//        pRec.First;
//        while ( not pRec.EOF ) do begin
//          szFldReturn := Trim(pRec.FieldByName('FLD_RETURN').AsString);
//          fld_return := StrToInt(szFldReturn);
//          pRec.Next;
//        end;
//        pRec.Close;
//
//        szTemp := PAnsiChar(Format('%s/%d',[szUserName, DB_TAG_REJECT_DELETE]));
//        Def := MakeDefaultMsg (DBR_TAG_RESULT, fld_return, 0, 0, 0);
//        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(szTemp));
//      end;
//    end;
    pRec.Close;
  end;
end;

procedure TCGameServer.GetTagRejectList (body: string; usock: TCustomWinSocket);
var
  szUserName, szFldRejecter, szQuery: string;
  nCnt: Integer;
  szTemp1, szTemp2: AnsiString;
  pRec: TADOQuery;
begin
  GetValidStr3(body, szUserName, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!13] %s', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_TAG_REJECTLIST ''%s''', [szUserName]);
    g_FDBSQL.UseDB (tGame);
    pRec := g_FDBSQL.OpenQuery (szQuery);

    if pRec <> nil then begin
      if pRec.RecordCount > 0 then begin
        nCnt := 0;
        pRec.First;
        while ( not pRec.EOF ) do begin
          szFldRejecter := Trim(pRec.FieldByName('FLD_REJECTER').AsString);
          szTemp2 := Format('%s/',[szFldRejecter]);

          szTemp1 := szTemp1 + szTemp2;
          Inc(nCnt);
          pRec.Next;
        end;
        pRec.Close;

        szTemp2 := Format('%s/%d/%d/%s',[szUserName, DB_TAG_REJECT_LIST, nCnt, szTemp1]);

        Def := MakeDefaultMsg (DBR_TAG_REJECT_LIST, 1, 0, 0, 0);
        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(AnsiString(szTemp2)));
      end;
    end;
  end;
end;

procedure TCGameServer.GetTagNotReadCount(body: string; usock: TCustomWinSocket);
var
  szUserName, szFldCount, szQuery, szTemp2: string;
  nCnt: Integer;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!14] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_TAG_NOTREADCOUNT ''%s''', [szUserName]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.OpenQuery (szQuery);

    if pRec <> nil then begin
      if pRec.RecordCount > 0 then begin
        nCnt := 0;
        szFldCount := Trim(pRec.FieldByName('FLD_COUNT').AsString);
        pRec.Close;

        szTemp2 := Format('%s/%d/%d/%s',[szUserName, DB_TAG_NOTREADCOUNT, nCnt, szFldCount]);

        Def := MakeDefaultMsg (DBR_TAG_NOTREADCOUNT, 1, 0, 0, 0);
        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(AnsiString(szTemp2)));
      end;
    end;
  end;
end;

procedure TCGameServer.GetLMList (body: string; usock: TCustomWinSocket);
var
  szUserName, szQuery: string;
  szFldOther, szFldDate: string;
  szFldState, szFldMsg, szFldLevel, szFldSex, nCnt: Integer;
  szTemp1, szTemp2: AnsiString;
  pRec: TADOQuery;
begin
  GetValidStr3(body, szUserName, ['/']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!15] %s', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_LM_LIST ''%s''', [szUserName]);
    g_FDBSQL.UseDB (tGame);
    pRec := g_FDBSQL.OpenQuery (szQuery);

    if pRec <> nil then begin
      if pRec.RecordCount > 0 then begin
        nCnt := 0;
        pRec.First;
        while ( not pRec.EOF ) do begin

          szFldOther := Trim(pRec.FieldByName('FLD_OTHER').AsString);
          szFldState := pRec.FieldByName('FLD_STATE').AsInteger;
          szFldMsg   := pRec.FieldByName('FLD_MSG').AsInteger;
          szFldDate  := Trim(pRec.FieldByName('FLD_DATE').AsString);
          szFldLevel := pRec.FieldByName('FLD_LEVEL').AsInteger;
          szFldSex   := pRec.FieldByName('FLD_SEX').AsInteger;

          szTemp2 := Format('%s:%d:%d:%s:%d:%d/', [szFldOther, szFldState,szFldMsg,szFldDate,szFldLevel,szFldSex]);
          szTemp1 := szTemp1 + szTemp2;
          Inc(nCnt);
          pRec.Next;
        end;
        pRec.Close;

        szTemp2 := Format('%s/%d/%d/%s',[szUserName, DB_LM_LIST, nCnt, szTemp1]);

        Def := MakeDefaultMsg (DBR_LM_LIST, 1, 0, 0, 0);
        SendSocket (usock, EncodeMessage (Def) + '/' + EncodeString(AnsiString(szTemp2)));
      end;
    end;
  end;
end;

procedure TCGameServer.GetLMAdd(body: string; usock: TCustomWinSocket);
var
  szUserName, szData, szOther, szState, szDate, szQuery: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szData, ['/']);

  szData := GetValidStr3(szData, szOther, [':']);
  szDate := GetValidStr3(szData, szState, [':']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!16] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_LM_ADD ''%s'',''%s'',''%s'',''%s''', [szUserName, szOther, szState, szDate]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
    pRec.Close;
  end;
end;

procedure TCGameServer.GetLMDelete(body: string; usock: TCustomWinSocket);
var
  szUserName, szOther, szState, szQuery: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szOther, ['/']);
  szState := GetValidStr3(szOther, szOther, [':']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!17] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_LM_DELETE ''%s'',''%s'', ''%s''', [szUserName, szOther, szState]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
    pRec.Close;
  end;
end;

procedure TCGameServer.GetLMEdit(body: string; usock: TCustomWinSocket);
var
  szUserName, szData, szOther, szQuery, szState, szMsg: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szData, ['/']);

  szData := GetValidStr3(szData, szOther, [':']);
  szMsg := GetValidStr3(szData, szState, [':']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!18] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_TAG_SETINFO ''%s'',''%s'',''%s'',''%s''', [szUserName, szOther, szState, szMsg]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
    pRec.Close;
  end;
end;

procedure TCGameServer.GetLMEdit2(body: string; usock: TCustomWinSocket);
var
  szUserName, szOther, szState, szQuery: string;
  pRec: TADOQuery;
begin
  body := GetValidStr3(body, szUserName, ['/']);
  body := GetValidStr3(body, szOther, ['/']);
  szState := GetValidStr3(szOther, szOther, [':']);

	if Length(szUserName) > 20 then begin
		MainOutMessage( CERR, Format('[LONG-QUERY MESSAGE!!!17] %s,', [szUserName]));
	end;

  if (g_FDBSQL.Connected) then begin
    szQuery := Format('EXEC SP_LM_DELETE ''%s'',''%s'', ''%s''', [szOther, szUserName, szState]);
    g_FDBSQL.UseDB (tGame);

    pRec := g_FDBSQL.Execute(szQuery);
    pRec.Close;
  end;
end;

end.
