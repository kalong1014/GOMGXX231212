unit MaketSystem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs, Grobal2,
  HUtil32, EdCode;

const
  MAKET_ITEMCOUNT_PER_PAGE = 10;
  MAKET_MAX_PAGE = 12;
  MAKET_MAX_ITEM_COUNT = MAKET_ITEMCOUNT_PER_PAGE * MAKET_MAX_PAGE;
  MAKET_STATE_EMPTY = 0;
  MAKET_STATE_LOADING = 1;
  MAKET_STATE_LOADED = 2;

{
    TMaketItem = record
      Item   	: TClientItem;	// 변경된 능력치는 여기에 적용됨.
      SellIndex	: integer;	    // 판매번호
      SellPrice	: integer;	    // 판매 가격
      SellWho	: string[20];	// 판매자
      Selldate	: string[10] 	// 판매날짜(0312311210 = 2003-12-31 12:10 )
      SellState : word          // 1 = 판매중 , 2 = 판매완료
   end;
}

type
  TMarketItemManager = class(TObject)
  private
    FState: integer;

    FMaxPage: integer;
    FCurrPage: integer;
    FLoadedpage: integer;

    FItems: TList;
    FSelectedIndex: integer;

    FUserMode: integer;
    FItemType: integer;
    bFirst: integer;
  public
    RecvCurPage: integer;
    RecvMaxPage: integer;
  private
    procedure RemoveAll;
    procedure InitFirst;
    function CheckIndex(index_: integer): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load;
    procedure ReLoad;
    procedure Add(pInfo_: PTMarketItem);
    procedure Delete(Index_: integer);
    procedure Clear;
    function GetItem(Index_: integer; var rSelected: Boolean): PTMarketItem; overload;
    function GetItem(Index_: integer): PTMarketItem; overload;
    function Select(Index_: integer): Boolean;
    function IsEmpty: Boolean;
    function Count: integer;
    function GetFirst: integer;
    function PageCount: integer;
    function GetUserMode: integer;
    function GetItemType: integer;
    procedure OnMsgReadData(msg: TDefaultMessage; body: string);
    procedure OnMsgWriteData(msg: TDefaultMessage; body: string);
  end;

var
  g_Market: TMarketItemManager;

implementation

uses
  ClMain;

constructor TMarketItemManager.Create;
begin
  InitFirst;
end;

destructor TMarketItemManager.Destroy;
begin
  RemoveAll;

  inherited;
end;

procedure TMarketItemManager.RemoveAll;
var
  i: integer;
  pinfo: PTMarketItem;
begin

  for i := FItems.count - 1 downto 0 do
  begin
    pinfo := FItems.Items[i];

    if pinfo <> nil then
      dispose(pinfo);

    FItems.delete(i);
  end;
  FItems.Clear;
  FState := MAKET_STATE_EMPTY;
end;

function TMarketItemManager.CheckIndex(Index_: integer): Boolean;
begin
  if (Index_ >= 0) and (Index_ < FItems.count) then
    result := true
  else
    result := false;
end;

procedure TMarketItemManager.InitFirst;
begin
  FItems := TList.Create;
  FSelectedIndex := -1;
  FState := MAKET_STATE_EMPTY;

  RecvCurPage := 0;
  RecvMaxPage := 0;
end;

procedure TMarketItemManager.Load;
begin
  if IsEmpty and (FState = MAKET_STATE_EMPTY) then
  begin
//        OnMsgReadData;
  end;
end;

procedure TMarketItemManager.ReLoad;
begin
  if not IsEmpty then
    RemoveAll;
  Load;
end;

procedure TMarketItemManager.Add(pInfo_: PTMarketItem);
begin
  if (FItems <> nil) and (pInfo_ <> nil) then
  begin
    FItems.Add(pInfo_);
  end;
end;

procedure TMarketItemManager.Delete(Index_: integer);
begin

end;

procedure TMarketItemManager.Clear;
begin
  RemoveAll;
  InitFirst;
end;

function TMarketItemManager.Select(Index_: integer): Boolean;
begin
  Result := false;

  if CheckIndex(Index_) then
  begin
    FSelectedIndex := Index_;
    Result := true;
  end;
end;

function TMarketItemManager.IsEmpty: Boolean;
begin
  if FItems.Count > 0 then
    Result := false
  else
    Result := true;

end;

function TMarketItemManager.Count: integer;
begin
  Result := FItems.Count;
end;

function TMarketItemManager.GetFirst: integer;
begin
  Result := bFirst;
end;

function TMarketItemManager.PageCount: integer;
begin
  if FItems.Count = 0 then
    Result := 0
  else
    Result := FItems.Count div MAKET_ITEMCOUNT_PER_PAGE + 1;
end;

function TMarketItemManager.GetUserMode: integer;
begin
  Result := FUserMode;
end;

function TMarketItemManager.GetItemType: integer;
begin
  Result := FitemType;
end;

function TMarketItemManager.GetItem(Index_: integer; var rSelected: Boolean): PTMarketItem;
begin
  Result := GetItem(Index_);

  if Result <> nil then
  begin
    if Index_ = FSelectedIndex then
      rSelected := true
    else
      rSelected := false;
  end;

end;

function TMarketItemManager.GetItem(Index_: integer): PTMarketItem;
begin
  Result := nil;

  if checkIndex(Index_) then
  begin
    result := PTMarketItem(FItems.Items[Index_]);

  end;
end;

procedure TMarketItemManager.OnMsgReadData(msg: TDefaultMessage; body: string);
begin

end;

procedure TMarketItemManager.OnMsgWriteData(msg: TDefaultMessage; body: string);
var
//    itemtype    : integer;
//    bFirst      : integer;
  nCount: integer;
  i: integer;
  pInfo: PTMarketItem;
  buffer1: string;
  buffer2: string;
begin
//    DScreen.AddSysMsg ('GET MARKET MSG');

  case msg.Ident of
    SM_MARKET_LIST:
      begin
        FUserMode := msg.Recog;
        FItemType := msg.Param;
        bFirst := msg.Tag;

        buffer1 := DecodeString(body);

        if bFirst > 0 then
          Clear;

        buffer1 := GetValidStr3(buffer1, buffer2, ['/']);
        nCount := Str_ToInt(buffer2, 0);

        buffer1 := GetValidStr3(buffer1, buffer2, ['/']);
        RecvCurPage := Str_ToInt(buffer2, 0);

        buffer1 := GetValidStr3(buffer1, buffer2, ['/']);
        RecvMaxPage := Str_ToInt(buffer2, 0);

        for i := 0 to nCount - 1 do
        begin

          buffer1 := GetValidStr3(buffer1, buffer2, ['/']);
          new(pInfo);
          DecodeBuffer(buffer2, pointer(pInfo), sizeof(TMarketItem));

          Add(pInfo);
        end;
      end;
  end;
end;

end.

