unit StallSystem;

interface

uses
  Windows, Grobal2;

const
  MAX_STALL_ITEM_COUNT      = 10;

type
 //卖家客户端传来基础数据
  TClientStall = packed record  //9
    MakeIndex: LongWord; //物品IdX
    Price: Integer;                //售价
    GoldType: Byte;                        //贩卖类型 4 5   金币  元宝
  end;
  TClientStallItems = packed record //118
    Name: string[28]; //店名
    Items: array[0..MAX_STALL_ITEM_COUNT - 1] of TClientStall;//十个售卖物品信息
  end;


//卖家所有物品    非真实  买家观看用。
  TClientStallInfo = packed record //32 +1300  //出售物品真实信息
    ItemCount: Integer; //实际数量？
    StallName: string[28]; //店名
    Items: array[0..MAX_STALL_ITEM_COUNT - 1] of TClientItem; //物品信息？？？？有问题？
  end;   //买入观看

  //卖家 基本信息  所有用户接受
  TStallInfo = packed record
    Open: Boolean; //摊位打开否                     //
    Looks: Word;//摊位类型                        //̯λ΢ڛ
    Name: string[28];  //摊位名字
  end; //摊位基础信息

  TStallMgr = class                     //2568
    StallType: Word; //方向
    OnSale: Boolean;//       服务端判断是否摆摊变量
    mBlock: TClientStallInfo; //本人卖

    DoShop: Boolean;//       客户端断是否摆摊变量
    uSelIdx: Integer;//选中
    uBlock: TClientStallInfo;//其他人卖    暂定？

    CurActor: Integer;  //客户端调用         卖家人物指针
  private
  protected
  public
    constructor Create();
  end;

  //var
    //StallMgr                  : TStallMgr;

implementation

constructor TStallMgr.Create();
begin
  StallType:= 0;
  CurActor := 0;
  OnSale := False;
  DoShop := False;
  uSelIdx := -1;
  FillChar(mBlock, SizeOf(mBlock), 0);
  FillChar(uBlock, SizeOf(uBlock), 0);

end;

end.


