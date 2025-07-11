unit MasterSystem;

interface

uses
  Classes, SysUtils, grobal2, Windows, Relationship, HUtil32;

const
  MAX_APPRENTICECOUNT = 5;                    // 最多徒弟数
  STR_MASTERTITLE = '师    父     : ';
  STR_APPRENTICETL = '徒    弟%d    : ';
  UNBINDMASTERGOLD = 50000;                // 花钱解除师徒关系
  UNBINDMASTERGOLD2 = 100000;                // 花钱解除师徒关系
type
  TMasterMgr = class
  private
    FOwner: string;    // 我是谁
    FMasterName: string;    // 师父的名字
    FItems: TList;     // 徒弟列表
    FEnableBeMaster: Boolean;   // 允许收徒
    FSonCount: Integer;   // 徒弟数量
    FSonNumber: Integer;   // 自己是师父的第几个徒弟
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

        // 注册状态：角色的名字.等级.性别...../
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
      sChn := '大';
    2:
      sChn := '二';
    3:
      sChn := '三';
    4:
      sChn := '四';
    5:
      sChn := '五';
  else
    sChn := '';
  end;
  if MasterName <> '' then
    if FSonNumber > 0 then
      Result := '[' + MasterName + ' 的' + sChn + '徒弟]'
    else
      Result := '[' + MasterName + ' 的徒弟]';
end;

end.
