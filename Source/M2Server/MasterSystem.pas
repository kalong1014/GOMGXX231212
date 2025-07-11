unit MasterSystem;

interface

uses
  Classes, SysUtils, grobal2, Windows, Relationship, HUtil32;

const
  MAX_APPRENTICECOUNT = 5;                    // ���ͽ����
  STR_MASTERTITLE = 'ʦ    ��     : ';
  STR_APPRENTICETL = 'ͽ    ��%d    : ';
  UNBINDMASTERGOLD = 50000;                // ��Ǯ���ʦͽ��ϵ
  UNBINDMASTERGOLD2 = 100000;                // ��Ǯ���ʦͽ��ϵ
type
  TMasterMgr = class
  private
    FOwner: string;    // ����˭
    FMasterName: string;    // ʦ��������
    FItems: TList;     // ͽ���б�
    FEnableBeMaster: Boolean;   // ������ͽ
    FSonCount: Integer;   // ͽ������
    FSonNumber: Integer;   // �Լ���ʦ���ĵڼ���ͽ��
    FReqSequence: Integer;
    FCancelTime: LongWord;
    procedure RemoveAll;
  public
    constructor Create;
    destructor Destroy; override;
    function GetListMsg(ReqType: integer; var ListCount: integer): string;
    function AddChild(sName: string; nSonNumber: Integer = -1): Boolean;
    function DelChild(sName: string; nSonNumber: Integer = -1): Boolean;
    function DelChildByNo(nno: Integer): Boolean;
    function GetInfo(Name_: string; var Info_: TRelationShipInfo): Boolean;
    function GetChildNameByNo(nno: Integer): string;
    function GetTitle: string;
    property MasterName: string read FMasterName write FMasterName;
    property EnableBeMaster: Boolean read FEnableBeMaster write FEnableBeMaster;
    property SonCount: Integer read FSonCount write FSonCOunt;
    property SonNumber: integer read FSonNumber write FSonNumber;
    property Items: TList read FItems write FItems;
  end;

implementation

{ TMasterMgr }

constructor TMasterMgr.Create;
begin
  inherited;
  //TO DO Initialize
  FItems := TList.Create;
  FEnableBeMaster := False;
  FReqSequence := rsReq_None;
  FCancelTime := 0;
  FSonCount := 0;
end;

destructor TMasterMgr.Destroy;
begin
  RemoveAll;
  FItems.Free;
  inherited;
end;

function TMasterMgr.GetListMsg(ReqType: integer; var ListCount: integer): string;
var
  i: integer;
  Info: TRelationShipInfo;
  msg: string;
begin
  ListCount := 0;
  msg := '';
  for i := 0 to FItems.Count - 1 do begin
    Info := Fitems[i];

        // ע��״̬����ɫ������.�ȼ�.�Ա�...../
    msg := msg + IntToStr(Info.State) + ':' + Info.Name + ':' + IntToStr(Info.Level)
      + ':' + IntToStr(Info.Sex) + ':' + Info.Date + ':' + Info.ServerDate + ':'
      + Info.MapInfo + '/';
    Inc(ListCount);

  end;
  Result := msg;
end;

function TMasterMgr.AddChild(sName: string; nSonNumber: Integer): Boolean;
var
  i: integer;
  Info: TRelationShipInfo;
  msg: string;
begin
  Result := false;

  if GetInfo(sName, Info) then begin
    Result := true;
    exit;
  end;
  Info := TRelationShipInfo.Create;
  Info.Name := sName;
  Info.SonNumber := nSonNumber;
  FItems.Add(Info);
  if FMasterName = '' then
  begin
    Inc(FSonCount);
    Info.SonNumber := FSonCount;
  end;

  Result := true;
end;

function TMasterMgr.DelChild(sName: string; nSonNumber: Integer): Boolean;
var
  i: integer;
  Info: TRelationShipInfo;
  msg: string;
begin
  Result := false;
  Info := nil;

  for i := 0 to FItems.Count - 1 do begin
    Info := FItems[i];
    if (Info <> nil) and (Info.Name = sName) then begin
      FItems.Delete(i);
      Dec(FSonCount);
      Result := true;
      Break;
    end
  end;
  if nSonNumber <> -1 then
  begin
    for i := 0 to FItems.Count - 1 do
    begin
      Info := FItems[i];
      if (Info <> nil) and (nSonNumber < Info.SonNumber) then
      begin
        Info.SonNumber := Info.SonNumber - 1
      end;
    end;
  end;
end;

function TMasterMgr.DelChildByNo(nno: integer): Boolean;
var
  i: integer;
  Info: TRelationShipInfo;
  msg: string;
begin
  Result := false;

  FItems.Delete(nno - 1);
  Dec(FSonCount);
  Result := true;

end;

function TMasterMgr.GetInfo(Name_: string; var Info_: TRelationShipInfo): Boolean;
var
  i: integer;
  Info: TrelationShipInfo;
begin
  result := False;
  Info_ := nil;

  for i := 0 to FItems.Count - 1 do begin
    Info := FItems[i];
    if (Info <> nil) and (Info.Name = Name_) then begin
      Info_ := Info;
      Result := true;
      Exit;
    end;
  end;
end;

procedure TMasterMgr.RemoveAll;
var
  Info: TObject;
  i: integer;
begin
  for i := 0 to FItems.count - 1 do begin
    Info := FItems[i];

    if (Info <> nil) then begin
      Info.Free;
      Info := nil;
    end;
  end;

  FItems.Clear;
end;


function TMasterMgr.GetChildNameByNo(nno: Integer): string;
var
  i: integer;
  Info: TrelationShipInfo;
begin
  result := '';
  if nno <= FItems.Count then begin
    Info := FItems[nno - 1];
    if (Info <> nil) then
      Result := Info.Name;
  end;
end;

function TMasterMgr.GetTitle: string;
var
  sChn: string;
begin
  Result := '';
  case FSonNumber of
    1:
      sChn := '��';
    2:
      sChn := '��';
    3:
      sChn := '��';
    4:
      sChn := '��';
    5:
      sChn := '��';
  else
    sChn := '';
  end;
  if MasterName <> '' then
    if FSonNumber > 0 then
      Result := '[' + MasterName + ' ��' + sChn + 'ͽ��]'
    else
      Result := '[' + MasterName + ' ��ͽ��]';
end;

end.
