unit MShare;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Imm, AbstractCanvas,
  AsphyreRenderTargets, AbstractTextures, Vectors2px, AsphyreFactory,
  AsphyreTypes, AbstractDevices, cliUtil, Actor, Grobal2, WIL, HashList,
  uGameEngine, uCommon, pngimage, HUtil32, CnHashTable, IniFiles, SoundUtil;

const
  LOGINBAGIMGINDEX = 22;
  DEFSCREENWIDTH = 800;
  DEFSCREENHEIGHT = 600;

  FontBorderColor = $00080808;
  WTiles_IMAGEFILE = 'Data\Tiles.wil';
  WObjects1_IMAGEFILE = 'Data\Objects.wil';
  WSmTiles_IMAGEFILE = 'Data\SmTiles.wil';
  WHumImg_IMAGEFILE = 'Data\Hum.wil';
  WTranImg_IMAGEFILE = 'Data\Transform.Data';
  NewUI_IMAGEFILE = 'Data\NewUI.Data';
  WProgUse_IMAGEFILE = 'Data\Prguse.data';
  WMonImg_IMAGEFILE = 'Data\Mon1.wil';
  WHairImg_IMAGEFILE = 'Data\Hair.wil';
  WBagItem_IMAGEFILE = 'Data\Items.wil';
  WWeapon_IMAGEFILE = 'Data\Weapon.wil';
  WStateItem_IMAGEFILE = 'Data\StateItem.wil';
  WDnItem_IMAGEFILE = 'Data\DnItems.wil';
  WMagic_IMAGEFILE = 'Data\Magic.wil';
  WNpcImg_IMAGEFILE = 'Data\Npc.wil';
  WMagIcon_IMAGEFILE = 'Data\MagIcon.wil';
  WChrSel_IMAGEFILE = 'Data\ChrSel.wil';
  WMon2Img_IMAGEFILE = 'Data\Mon2.wil';
  WMon3Img_IMAGEFILE = 'Data\Mon3.wil';
  WMMap_IMAGEFILE = 'Data\mmap.wil';
  WMMapNew_IMAGEFILE = 'Data\mmapNew.wil';
  WMon4Img_IMAGEFILE = 'Data\Mon4.wil';
  WMon5Img_IMAGEFILE = 'Data\Mon5.wil';
  WMon6Img_IMAGEFILE = 'Data\Mon6.wil';
  WEffectImg_IMAGEFILE = 'Data\Effect.wil';
  WObjects2_IMAGEFILE = 'Data\Objects2.wil';
  WObjects3_IMAGEFILE = 'Data\Objects3.wil';
  WObjects4_IMAGEFILE = 'Data\Objects4.wil';
  WObjects5_IMAGEFILE = 'Data\Objects5.wil';
  WObjects6_IMAGEFILE = 'Data\Objects6.wil';
  WObjects7_IMAGEFILE = 'Data\Objects7.wil';
  WMon7Img_IMAGEFILE = 'Data\Mon7.wil';
  WMon8Img_IMAGEFILE = 'Data\Mon8.wil';
  WMon9Img_IMAGEFILE = 'Data\Mon9.wil';
  WMon10Img_IMAGEFILE = 'Data\Mon10.wil';
  WMon11Img_IMAGEFILE = 'Data\Mon11.wil';
  WMon12Img_IMAGEFILE = 'Data\Mon12.wil';
  WMon13Img_IMAGEFILE = 'Data\Mon13.wil';
  WMon14Img_IMAGEFILE = 'Data\Mon14.wil';
  WMon15Img_IMAGEFILE = 'Data\Mon15.wil';
  WMon16Img_IMAGEFILE = 'Data\Mon16.wil';
  WMon17Img_IMAGEFILE = 'Data\Mon17.wil';
  WMon18Img_IMAGEFILE = 'Data\Mon18.wil';
  WMagic2_IMAGEFILE = 'Data\Magic2.wil';
  WMagic3_IMAGEFILE = 'Data\Magic3.wil';
  WMagic4_IMAGEFILE = 'Data\Magic4.wzl';
  WProgUse2_IMAGEFILE = 'Data\Prguse2.data';
  WMon19Img_IMAGEFILE = 'Data\Mon19.wil';
  WMon20Img_IMAGEFILE = 'Data\Mon20.wil';
  WMon21Img_IMAGEFILE = 'Data\Mon21.wil';
  WObjects8_IMAGEFILE = 'Data\Objects8.wil';
  WObjects9_IMAGEFILE = 'Data\Objects9.wil';
  WMon22Img_IMAGEFILE = 'Data\Mon22.wil';
  WHumWing_IMAGEFILE = 'Data\HumEffect.wil';
  WDragonImg_IMAGEFILE = 'Data\Dragon.wil';
  WObjects10_IMAGEFILE = 'Data\Objects10.wil';
  WMon23Img_IMAGEFILE = 'Data\Mon23.wil';
  WDecoImg_IMAGEFILE = 'Data\Deco.wil';
  WMon24Img_IMAGEFILE = 'Data\Mon24.wil';
  WMon25Img_IMAGEFILE = 'Data\Mon25.wil';
  WMon26Img_IMAGEFILE = 'Data\Mon26.wil';
  WMon27Img_IMAGEFILE = 'Data\Mon27.wil';
  WObjects11_IMAGEFILE = 'Data\Objects11.wil';//1~7  记得改1
   WObjects12_IMAGEFILE = 'Data\Objects12.wil';//1~7  记得改1
   WObjects13_IMAGEFILE = 'Data\Objects13.wil';//1~7  记得改1
   WObjects14_IMAGEFILE = 'Data\Objects14.wil';//1~7  记得改1
   WObjects15_IMAGEFILE = 'Data\Objects15.wil';//1~7  记得改1
   WObjects16_IMAGEFILE = 'Data\Objects16.wil';//1~7  记得改1
   WObjects17_IMAGEFILE = 'Data\Objects17.wil';//1~7  记得改1
   WObjects18_IMAGEFILE = 'Data\Objects18.wil';//1~7  记得改1
   WObjects19_IMAGEFILE = 'Data\Objects19.wil';//1~7  记得改1
   WObjects20_IMAGEFILE = 'Data\Objects20.wil';//1~7  记得改1
   WObjects21_IMAGEFILE = 'Data\Objects21.wil';//1~7  记得改1
   WObjects22_IMAGEFILE = 'Data\Objects22.wil';//1~7  记得改1
   WObjects23_IMAGEFILE = 'Data\Objects23.wil';//1~7  记得改1
type
  TMirStartupInfo = record
    sDisplayName: String[30];
    sServerName: String[30];
    sServeraddr: String[30];
    nServerPort: Integer;
    sServerKey: String[100];
    sResourceDir: String[50];
    boFullScreen: Boolean;
    boWaitVBlank: Boolean;
    bo3D: Boolean;
    boMini: Boolean;
    nLocalMiniPort: Integer;
    nScreenWidth: Integer;
    nScreenHegiht: Integer;
    sLogo: String[255];
    sWebSite: String[50];
    sPaySite: String[50];
    PassWordFileName:string[127];
  end;

  TMiniResRequest = packed record
    _Type: Byte; //0:图片 1:单文件
    Important: Boolean; //是否重要，无需队列等待，立即下载
    FileName: String[200];
    Index: Integer;
    FailCount:Word; //失败次数
    Data:Pointer; //用以挂接其他数据
  end;
  PTMiniResRequest = ^TMiniResRequest;

  TMiniResResponse = packed record
    Ident: Integer;
    FileName: String[200];
    Index: Integer;
    Position: Integer;
  end;
  PTMiniResResponse = ^TMiniResResponse;

  IApplication = interface
    ['{501687F1-F936-4A5F-A235-34643269AF55}']
    procedure AddToChatBoardString(const Message: String; FColor, BColor: TColor);
    procedure LoadImage(const FileName: String; Index, Position: Integer);
//    procedure AddMessageDialog(const Text: String; Buttons: TMsgDlgButtons; Handler: TMessageHandler = nil; Size: Integer = 1);
    procedure Terminate;
    procedure DisConnect;
    function _CurPos: TPoint;
  end;

var
  g_boRightItemRingEmpty        :Boolean=False; //人物戒指哪头是空
  g_boRightItemArmRingEmpty     :Boolean=False; //人物手镯哪头是空

  WTiles: TWMImages;
  WObjects1: TWMImages;
  WObjects2: TWMImages;
  WObjects3: TWMImages;
  WObjects4: TWMImages;
  WObjects5: TWMImages;
  WObjects6: TWMImages;
  WObjects7: TWMImages;
  WObjects8: TWMImages;
  WObjects9: TWMImages;
  WObjects10: TWMImages;
  WObjects11: TWMImages;
   WObjects12: TWMImages;
   WObjects13: TWMImages;
   WObjects14: TWMImages;
   WObjects15: TWMImages;
   WObjects16: TWMImages;
   WObjects17: TWMImages;
   WObjects18: TWMImages;
   WObjects19: TWMImages;
   WObjects20: TWMImages;
   WObjects21: TWMImages;
   WObjects22: TWMImages;
   WObjects23: TWMImages;

  WSmTiles: TWMImages;
  WHumImg: TWMImages;
  WTranImg: TWMImages;
  NewUI: TWMImages;
  WHumWing: TWMImages;
  WHairImg: TWMImages;
  WWeapon: TWMImages;
  WMagic: TWMImages;
  WMagic2: TWMImages;
  WMagic3: TWMImages;
  WMagic4: TWMImages;
  WMagIcon: TWMImages;
  WMonImg: TWMImages;
  WMon2Img: TWMImages;
  WMon3Img: TWMImages;
  WMon4Img: TWMImages;
  WMon5Img: TWMImages;
  WMon6Img: TWMImages;
  WMon7Img: TWMImages;
  WMon8Img: TWMImages;
  WMon9Img: TWMImages;
  WMon10Img: TWMImages;
  WMon11Img: TWMImages;
  WMon12Img: TWMImages;
  WMon13Img: TWMImages;
  WMon14Img: TWMImages;
  WMon15Img: TWMImages;
  WMon16Img: TWMImages;
  WMon17Img: TWMImages;
  WMon18Img: TWMImages;
  WMon19Img: TWMImages;
  WMon20Img: TWMImages;
  WMon21Img: TWMImages;
  WMon22Img: TWMImages;
  WMon23Img: TWMImages;
  WMon24Img: TWMImages;
  WMon25Img: TWMImages;
  WMon26Img: TWMImages;
  WMon27Img: TWMImages;
  WDragonImg: TWMImages;
  WDecoImg: TWMImages;
  WNpcImg: TWMImages;
  WEffectImg: TWMImages;
  WProgUse: TWMImages;
  WProgUse2: TWMImages;
  WChrSel: TWMImages;
  WMMap: TWMImages;
  WMMapNew: TWMImages;
  WBagItem: TWMImages;
  WStateItem: TWMImages;
  WDnItem: TWMImages;

  g_Application: IApplication = nil;
  //客户端ASP相关函数
  g_GameDevice: TAsphyreDevice;
  g_GameCanvas: TAsphyreCanvas;
  g_DisplaySize: TPoint2px;
  g_LogoHide: Boolean = False;
  g_ProcOnIdleTick: LongWord;
  g_ProcOnDrawTick: LongWord;
  g_MirStartupInfo: TMirStartupInfo;
  ClientParamStr : string;
  ResourceDir: String = 'Resource\';
  UserCfgDir: String = 'Resource\Users\';
  g_boForceMapDraw: Boolean = False;
  g_boForceMapFileLoad: Boolean = False;

  m_Point: TPoint;
  LightImages: array[0..5] of TAsphyreLockableTexture;

//  boWhisperAuto :Boolean = False;
//  g_sAutoAns : string = '';
  boWhisperLen :Boolean = False;

  CLIENTUPDATETIME: string = '2016.02.09';
  g_sCurFontName: string = '宋体';
  g_boFullScreen: Boolean = False;
  g_boLockFullScreen: Boolean = False;

  g_boInitialize: Boolean;
  g_boDrawTileMap: Boolean = True;
  g_boCanDraw: Boolean = True;
  g_boCanSound: Boolean = True;

  g_boSound: Boolean = True;
  g_boBGSound: Boolean = True;
  g_btMP3Volume: Byte = 70;
  g_btSoundVolume: Byte = 70;
  g_FScreenMode: Byte = 0;      //分辨率，1是1024*768，0是800*600
  g_FScreenWidth: Integer = DEFSCREENWIDTH;
  g_FScreenHeight: Integer = DEFSCREENHEIGHT;
  g_FrmMainWinHandle: THandle;
  g_ColorTable: TRGBQuads;
  g_HIMC: HIMC; //输入法关闭调用变量

  g_boOwnerMsg: Boolean;            //是否拒绝公聊
  g_RefuseCRY: Boolean = True;      //拒绝喊话
  g_Refuseguild: Boolean = True;    //拒绝行会聊天信息
  g_RefuseWHISPER: Boolean = True;  //拒绝私聊信息

  g_boAutoTalk: Boolean = False;    //自动喊话
  g_sAutoTalkStr: string;           //喊话内容
  g_nAutoTalkTimer: LongWord = 8;   //自动喊话

  g_dwSendGetPinTick: LongWord = 0;  //心跳包间隔时间
  g_dwReceiveGetPinTick: LongWord = 0;  //心跳包间隔时间
  g_nPing : Integer = 0;  //网络延时值 毫秒

  //自动毒药标识
  g_nDuWhich: byte = 0;
  g_UnbindItemList: TList = nil;     // 解包列表
  g_nLastUnbindTime : LongWord = 0;  // 时间

  g_nMiniMapMaxX: Integer = -1;
  g_nMiniMapMaxY: Integer = -1;
  g_nMiniMapMoseX: Integer = -1;
  g_nMiniMapMoseY: Integer = -1;
  g_nMiniMapMaxMosX: Integer;
  g_nMiniMapMaxMosY: Integer;

  g_boOpenStallSystem: Boolean = True;

  SafeZoneFromM2: array of TSafeZone; //2019-02-019
  TempMapTitle: string; //2019-02-19


  g_ItemsFilter_All: TCnHashTableSmall;
  g_ItemsFilter_All_Def: TCnHashTableSmall;
  g_ItemsFilter_All_Str: TStringList;
  g_ItemsFilter_Dress: TStringList;
  g_ItemsFilter_Weapon: TStringList;
  g_ItemsFilter_Headgear: TStringList;
  g_ItemsFilter_Drug: TStringList;
  g_ItemsFilter_Other: TStringList;
  g_ItemsFilter_Find_Str:TStringList;

  g_TileMapOffSetX: Integer = 9;
  g_TileMapOffSetY: Integer = 9;
  AAX: Integer = 26 + 14;

  g_SendSayList: TStringList;
  g_SendSayListIdx: Integer = 0;

  g_ShopListArr: array[0..5] of TList;
  g_btSellType: Byte = 0;
  g_ClickShopItem: TShopItem;

procedure LoadWMImagesLib();
procedure InitWMImagesLib;
procedure UnLoadWMImagesLib();

procedure PomiTextOut(dsurface: TAsphyreCanvas; x, y: integer; str: string);
function GetObjs(wunit, idx: integer): TAsphyreLockableTexture;
function GetObjsEx(wunit, idx: integer; var px, py: integer): TAsphyreLockableTexture;
function BagItemCount: Integer;

procedure LoadItemFilter(D: Byte = 0);
procedure LoadItemFilter2();
procedure SaveItemFilter();
procedure ClearItemFilter(d: Byte);
procedure ItemFilterFind(ASrcList,ADestList:Tstringlist;const AFindStr:string);
function GetFiltrateItem(sItemName: string): pTCItemRule;
procedure ScreenChanged();
function ShiftYOffset(): Integer;
procedure LoadLightImages();
procedure UnLoadLightImages();

VAR
  g_bo拒绝拜师: boolean = false;

implementation

uses
  ClMain;

procedure LoadItemFilter(D: Byte);
var
  i, n: Integer;
  s, s0, s1, s2, s3, s4, fn: string;
  ls: TStringList;
  p, p2: pTCItemRule;
  ItemFilterRes: TResourceStream;
begin
  ItemFilterRes := TResourceStream.Create(HInstance, 'DefaultItemFilter', 'DefaultItemFilterFile');
  try
    if ItemFilterRes <> nil then
    begin
      //fn := '.\Data\DefaultItemFilter.dat';
      ls := TStringList.Create;
      //ls.LoadFromFile(fn);
      ls.LoadFromStream(ItemFilterRes);
      ClearItemFilter(d);
      for i := 0 to ls.Count - 1 do
      begin
        s := ls[i];
        if s = '' then
          Continue;

        s := GetValidStr3(s, s0, [',']);
        s := GetValidStr3(s, s1, [',']);
        s := GetValidStr3(s, s2, [',']);
        s := GetValidStr3(s, s3, [',']);
        s := GetValidStr3(s, s4, [',']);
        New(p);
        p.Name := s0;
        p.rare := s2 = '1';
        p.pick := s3 = '1';
        p.show := s4 = '1';
        g_ItemsFilter_All.put(s0, TObject(p));
        g_ItemsFilter_All_Str.AddObject(s0, TObject(p));

        New(p2);
        p2^ := p^;
        g_ItemsFilter_All_Def.Put(s0, TObject(p2));

          //  n := StrToInt(s1);
        if s1 = '服装类' then
        begin
          g_ItemsFilter_Dress.AddObject(s0, TObject(p));
        end
        else if s1 = '武器类' then
        begin
          g_ItemsFilter_Weapon.AddObject(s0, TObject(p));
        end
        else if s1 = '药品类' then
        begin
          g_ItemsFilter_Drug.AddObject(s0, TObject(p))
        end
        else if s1 = '其他类' then
        begin
          g_ItemsFilter_Other.AddObject(s0, TObject(p))
        end
        else
        begin
          g_ItemsFilter_Headgear.AddObject(s0, TObject(p));
        end;
      end;
      ls.Free;
    end;
  finally
    ItemFilterRes.Free;
  end;
end;

procedure ItemFilterFind(ASrcList, ADestList: Tstringlist; const AFindStr: string);
var
  i: integer;
begin
  ADestList.Clear;
  for i := 0 to ASrcList.Count - 1 do
  begin
    if pos(AFindStr, ASrcList.Strings[i]) > 0 then
    begin
      ADestList.AddObject(ASrcList.Strings[i], ASrcList.Objects[i]);
    end;
  end;
end;

function GetFiltrateItem(sItemName: string): pTCItemRule;
begin
  Result := pTCItemRule(g_ItemsFilter_All.GetValues(sItemName));
end;

procedure LoadItemFilter2();
var
  i, n: Integer;
  s, s0, s1, s2, s3, s4, fn: string;
  ls: TStringList;
  p, p2: pTCItemRule;
  b2, b3, b4: Boolean;
begin
  fn := '.\Config\' + frmMain.CharName + '\ItemFilter.txt';
  //DScreen.AddChatBoardString(fn, clWhite, clBlue);
  if FileExists(fn) then begin
    //DScreen.AddChatBoardString('1', clWhite, clBlue);
    ls := TStringList.Create;
    ls.LoadFromFile(fn);
    for i := 0 to ls.Count - 1 do begin
      s := ls[i];
      if s = '' then Continue;

      s := GetValidStr3(s, s0, [',']);
      s := GetValidStr3(s, s2, [',']);
      s := GetValidStr3(s, s3, [',']);
      s := GetValidStr3(s, s4, [',']);

      p := pTCItemRule(g_ItemsFilter_All_Def.GetValues(s0));
      if p <> nil then begin
        //DScreen.AddChatBoardString('2', clWhite, clBlue);
        b2 := s2 = '1';
        b3 := s3 = '1';
        b4 := s4 = '1';
        if (b2 <> p.rare) or (b3 <> p.pick) or (b4 <> p.show) then begin
          //DScreen.AddChatBoardString('3', clWhite, clBlue);
          p2 := pTCItemRule(g_ItemsFilter_All.GetValues(s0));
          if p2 <> nil then begin
            //DScreen.AddChatBoardString('4', clWhite, clBlue);
            p2.rare := b2;
            p2.pick := b3;
            p2.show := b4;
          end;
        end;
      end;
    end;
    ls.Free;
  end else LoadItemFilter;
end;

procedure SaveItemFilter(); //退出增量保存
var
  i, n: Integer;
  s, s0, s1, s2, s3, s4, fn: string;
  ls: TStringList;
  p, p2: pTCItemRule;
begin
  fn := '.\Config\' + frmMain.CharName + '\ItemFilter.txt';
  ls := TStringList.Create;
  for i := 0 to g_ItemsFilter_All.Count - 1 do begin
    p := pTCItemRule(g_ItemsFilter_All.GetValues(g_ItemsFilter_All.Keys[i]));
    p2 := pTCItemRule(g_ItemsFilter_All_Def.GetValues(g_ItemsFilter_All_Def.Keys[i]));
    if p.Name = p2.Name then begin
      if (p.rare <> p2.rare) or
        (p.pick <> p2.pick) or
        (p.show <> p2.show) then begin
        ls.Add(Format('%s,%d,%d,%d', [
          p.Name,
            Byte(p.rare),
            Byte(p.pick),
            Byte(p.show)
            ]));
      end;
    end;
  end;
  if ls.Count > 0 then
    ls.SaveToFile(fn);
  ls.Free;
end;

procedure LoadWMImagesLib();
begin
  WTiles := CreateImages(WTiles_IMAGEFILE);
  WObjects1 := CreateImages(WObjects1_IMAGEFILE);
  WSmTiles := CreateImages(WSmTiles_IMAGEFILE);
  WHumImg := CreateImages(WHumImg_IMAGEFILE);
  WTranImg := CreateImages(WTranImg_IMAGEFILE);
  NewUI := CreateImages(NewUI_IMAGEFILE);
  WProgUse := CreateImages(WProgUse_IMAGEFILE);
  WMonImg := CreateImages(WMonImg_IMAGEFILE);
  WHairImg := CreateImages(WHairImg_IMAGEFILE);
  WBagItem := CreateImages(WBagItem_IMAGEFILE);
  WWeapon := CreateImages(WWeapon_IMAGEFILE);
  WStateItem := CreateImages(WStateItem_IMAGEFILE);
  WDnItem := CreateImages(WDnItem_IMAGEFILE);
  WMagic := CreateImages(WMagic_IMAGEFILE);
  WNpcImg := CreateImages(WNpcImg_IMAGEFILE);
  WMagIcon := CreateImages(WMagIcon_IMAGEFILE);
  WChrSel := CreateImages(WChrSel_IMAGEFILE);
  WMon2Img := CreateImages(WMon2Img_IMAGEFILE);
  WMon3Img := CreateImages(WMon3Img_IMAGEFILE);
  WMMap := CreateImages(WMMap_IMAGEFILE);
  WMMapNew := CreateImages(WMMapNew_IMAGEFILE);
  WMon4Img := CreateImages(WMon4Img_IMAGEFILE);
  WMon5Img := CreateImages(WMon5Img_IMAGEFILE);
  WMon6Img := CreateImages(WMon6Img_IMAGEFILE);
  WEffectImg := CreateImages(WEffectImg_IMAGEFILE);
  WObjects2 := CreateImages(WObjects2_IMAGEFILE);
  WObjects3 := CreateImages(WObjects3_IMAGEFILE);
  WObjects4 := CreateImages(WObjects4_IMAGEFILE);
  WObjects5 := CreateImages(WObjects5_IMAGEFILE);
  WObjects6 := CreateImages(WObjects6_IMAGEFILE);
  WObjects7 := CreateImages(WObjects7_IMAGEFILE);
  WMon7Img := CreateImages(WMon7Img_IMAGEFILE);
  WMon8Img := CreateImages(WMon8Img_IMAGEFILE);
  WMon9Img := CreateImages(WMon9Img_IMAGEFILE);
  WMon10Img := CreateImages(WMon10Img_IMAGEFILE);
  WMon11Img := CreateImages(WMon11Img_IMAGEFILE);
  WMon12Img := CreateImages(WMon12Img_IMAGEFILE);
  WMon13Img := CreateImages(WMon13Img_IMAGEFILE);
  WMon14Img := CreateImages(WMon14Img_IMAGEFILE);
  WMon15Img := CreateImages(WMon15Img_IMAGEFILE);
  WMon16Img := CreateImages(WMon16Img_IMAGEFILE);
  WMon17Img := CreateImages(WMon17Img_IMAGEFILE);
  WMon18Img := CreateImages(WMon18Img_IMAGEFILE);
  WMagic2 := CreateImages(WMagic2_IMAGEFILE);
  WMagic3 := CreateImages(WMagic3_IMAGEFILE);
  WMagic4 := CreateImages(WMagic4_IMAGEFILE);
  WProgUse2 := CreateImages(WProgUse2_IMAGEFILE);
  WMon19Img := CreateImages(WMon19Img_IMAGEFILE);
  WMon20Img := CreateImages(WMon20Img_IMAGEFILE);
  WMon21Img := CreateImages(WMon21Img_IMAGEFILE);
  WObjects8 := CreateImages(WObjects8_IMAGEFILE);
  WObjects9 := CreateImages(WObjects9_IMAGEFILE);
  WMon22Img := CreateImages(WMon22Img_IMAGEFILE);
  WHumWing := CreateImages(WHumWing_IMAGEFILE);
  WDragonImg := CreateImages(WDragonImg_IMAGEFILE);
  WObjects10 := CreateImages(WObjects10_IMAGEFILE);
  WMon23Img := CreateImages(WMon23Img_IMAGEFILE);
  WDecoImg := CreateImages(WDecoImg_IMAGEFILE);
  WMon24Img := CreateImages(WMon24Img_IMAGEFILE);
  WMon25Img := CreateImages(WMon25Img_IMAGEFILE);
  WMon26Img := CreateImages(WMon26Img_IMAGEFILE);
  WMon27Img := CreateImages(WMon27Img_IMAGEFILE);
  WObjects11 := CreateImages(WObjects11_IMAGEFILE);
  WObjects12 := CreateImages(WObjects12_IMAGEFILE);
  WObjects13 := CreateImages(WObjects13_IMAGEFILE);
  WObjects14 := CreateImages(WObjects14_IMAGEFILE);
  WObjects15 := CreateImages(WObjects15_IMAGEFILE);
  WObjects16 := CreateImages(WObjects16_IMAGEFILE);
  WObjects17 := CreateImages(WObjects17_IMAGEFILE);
  WObjects18 := CreateImages(WObjects18_IMAGEFILE);
  WObjects19 := CreateImages(WObjects19_IMAGEFILE);
  WObjects20 := CreateImages(WObjects20_IMAGEFILE);
  WObjects21 := CreateImages(WObjects21_IMAGEFILE);
  WObjects22 := CreateImages(WObjects22_IMAGEFILE);
  WObjects23 := CreateImages(WObjects23_IMAGEFILE);
end;

procedure InitWMImagesLib;
begin
  WChrSel.Initialize;
  WProgUse.Initialize;
  WProgUse2.Initialize;
  WTiles.Initialize;
  WObjects1.Initialize;
  WSmTiles.Initialize;
  WHumImg.Initialize;
  WTranImg.Initialize;
  NewUI.Initialize;
  WMonImg.Initialize;
  WHairImg.Initialize;
  WBagItem.Initialize;
  WWeapon.Initialize;
  WStateItem.Initialize;
  WDnItem.Initialize;
  WMagic.Initialize;
  WNpcImg.Initialize;
  WMagIcon.Initialize;
  WMon2Img.Initialize;
  WMon3Img.Initialize;
  WMMap.Initialize;
  WMMapNew.Initialize;
  WMon4Img.Initialize;
  WMon5Img.Initialize;
  WMon6Img.Initialize;
  WEffectImg.Initialize;
  WObjects2.Initialize;
  WObjects3.Initialize;
  WObjects4.Initialize;
  WObjects5.Initialize;
  WObjects6.Initialize;
  WObjects7.Initialize;
  WMon7Img.Initialize;
  WMon8Img.Initialize;
  WMon9Img.Initialize;
  WMon10Img.Initialize;
  WMon11Img.Initialize;
  WMon12Img.Initialize;
  WMon13Img.Initialize;
  WMon14Img.Initialize;
  WMon15Img.Initialize;
  WMon16Img.Initialize;
  WMon17Img.Initialize;
  WMon18Img.Initialize;
  WMagic2.Initialize;
  WMagic3.Initialize;
  WMagic4.Initialize;
  WMon19Img.Initialize;
  WMon20Img.Initialize;
  WMon21Img.Initialize;
  WMon22Img.Initialize;
  WObjects8.Initialize;
  WObjects9.Initialize;
  WObjects10.Initialize;
  WHumWing.Initialize;
  WDragonImg.Initialize;
  WDecoImg.Initialize;
  WMon23Img.Initialize;
  WMon24Img.Initialize;
  WMon25Img.Initialize;
  WMon26Img.Initialize;
  WMon27Img.Initialize;
  WObjects11.Initialize;
  WObjects12.Initialize;
  WObjects13.Initialize;
  WObjects14.Initialize;
  WObjects15.Initialize;
  WObjects16.Initialize;
  WObjects17.Initialize;
  WObjects18.Initialize;
  WObjects19.Initialize;
  WObjects20.Initialize;
  WObjects21.Initialize;
  WObjects22.Initialize;
  WObjects23.Initialize;
end;

procedure UnLoadWMImagesLib();
begin
  WTiles.Finalize;
  WTiles.Free;
  WObjects1.Finalize;
  WObjects1.Free;
  WObjects2.Finalize;
  WObjects2.Free;
  WObjects3.Finalize;
  WObjects3.Free;
  WObjects4.Finalize;
  WObjects4.Free;
  WObjects5.Finalize;
  WObjects5.Free;
  WObjects6.Finalize;
  WObjects6.Free;
  WObjects7.Finalize;
  WObjects7.Free;
  WObjects8.Finalize;
  WObjects8.Free;
  WObjects9.Finalize;
  WObjects9.Free;
  WObjects10.Finalize;
  WObjects10.Free;
  WObjects11.Finalize;
  WObjects11.Free;
  WObjects12.Finalize;
  WObjects12.Free;
  WObjects13.Finalize;
  WObjects13.Free;
  WObjects14.Finalize;
   WObjects14.Free;
   WObjects15.Finalize;
   WObjects15.Free;
   WObjects16.Finalize;
   WObjects16.Free;
   WObjects17.Finalize;
   WObjects17.Free;
   WObjects18.Finalize;
   WObjects18.Free;
   WObjects19.Finalize;
   WObjects19.Free;
   WObjects20.Finalize;
   WObjects20.Free;
   WObjects21.Finalize;
   WObjects21.Free;
   WObjects22.Finalize;
   WObjects22.Free;
   WObjects23.Finalize;
   WObjects23.Free;
  WSmTiles.Finalize;
  WSmTiles.Free;
  WHumImg.Finalize;
  WHumImg.Free;
  WTranImg.Finalize;
  WTranImg.Free;
  NewUI.Finalize;
  NewUI.Free;
  WHairImg.Finalize;
  WHairImg.Free;
  WWeapon.Finalize;
  WWeapon.Free;
  WMagic.Finalize;
  WMagic.Free;
  WMagic2.Finalize;
  WMagic2.Free;
  WMagic3.Finalize;
  WMagic3.Free;
  WMagic4.Finalize;
  WMagic4.Free;
  WMagIcon.Finalize;
  WMagIcon.Free;
  WMonImg.Finalize;
  WMonImg.Free;
  WMon2Img.Finalize;
  WMon2Img.Free;
  WMon3Img.Finalize;
  WMon3Img.Free;
  WMon4Img.Finalize;
  WMon4Img.Free;
  WMon5Img.Finalize;
  WMon5Img.Free;
  WMon6Img.Finalize;
  WMon6Img.Free;
  WMon7Img.Finalize;
  WMon7Img.Free;
  WMon8Img.Finalize;
  WMon8Img.Free;
  WMon9Img.Finalize;
  WMon9Img.Free;
  WMon10Img.Finalize;
  WMon10Img.Free;
  WMon11Img.Finalize;
  WMon11Img.Free;
  WMon12Img.Finalize;
  WMon12Img.Free;
  WMon13Img.Finalize;
  WMon13Img.Free;
  WMon14Img.Finalize;
  WMon14Img.Free;
  WMon15Img.Finalize;
  WMon15Img.Free;
  WMon16Img.Finalize;
  WMon16Img.Free;
  WMon17Img.Finalize;
  WMon17Img.Free;
  WMon18Img.Finalize;
  WMon18Img.Free;
  WMon19Img.Finalize;
  WMon19Img.Free;
  WMon20Img.Finalize;
  WMon20Img.Free;
  WMon21Img.Finalize;
  WMon21Img.Free;
  WMon22Img.Finalize;
  WMon22Img.Free;
  WMon23Img.Finalize;
  WMon23Img.Free;
  WMon24Img.Finalize;
  WMon24Img.Free;
  WMon25Img.Finalize;
  WMon25Img.Free;
  WMon26Img.Finalize;
  WMon26Img.Free;
  WMon27Img.Finalize;
  WMon27Img.Free;
  WNpcImg.Finalize;
  WNpcImg.Free;
  WEffectImg.Finalize;
  WEffectImg.Free;
  WProgUse.Finalize;
  WProgUse.Free;
  WProgUse2.Finalize;
  WProgUse2.Free;
  WChrSel.Finalize;
  WChrSel.Free;
  WMMap.Finalize;
  WMMap.Free;
  WMMapNew.Finalize;
  WMMapNew.Free;
  WBagItem.Finalize;
  WBagItem.Free;
  WStateItem.Finalize;
  WStateItem.Free;
  WDnItem.Finalize;
  WDnItem.Free;
  WHumWing.Finalize;
  WHumWing.Free;
  WDecoimg.Finalize;
  WDecoimg.Free;
  WDragonImg.Finalize;
  WDragonImg.Free;
end;

procedure PomiTextOut(dsurface: TAsphyreCanvas; x, y: integer; str: string);
var
  i, n: integer;
  d: TAsphyreLockableTexture;
begin
  for i := 1 to Length(str) do
  begin
    n := byte(str[i]) - byte('0');
    if n in [0..9] then
    begin
      d := WProgUse.Images[30 + n];
      if d <> nil then
        dsurface.Draw(x + i * 8, y, d.ClientRect, d, TRUE);
    end
    else
    begin
      if str[i] = '-' then
      begin
        d := WProgUse.Images[40];
        if d <> nil then
          dsurface.Draw(x + i * 8, y, d.ClientRect, d, TRUE);
      end;
    end;
  end;
end;

function GetObjs(wunit, idx: integer): TAsphyreLockableTexture;
begin
  case wunit of
    0:    Result := WObjects1.Images[idx];
      1:    Result := WObjects2.Images[idx];
      2:    Result := WObjects3.Images[idx];
      3:    Result := WObjects4.Images[idx];
      4:    Result := WObjects5.Images[idx];
      5:    Result := WObjects6.Images[idx];
      6:    Result := WObjects7.Images[idx];
      7:    Result := WObjects8.Images[idx];
      8:    Result := WObjects9.Images[idx];
      9:    Result := WObjects10.Images[idx];
      10:    Result := WObjects11.Images[idx];
      11:    Result := WObjects12.Images[idx];
      12:    Result := WObjects13.Images[idx];
      13:    Result := WObjects14.Images[idx];
      14:    Result := WObjects15.Images[idx];
      15:    Result := WObjects16.Images[idx];
      16:    Result := WObjects17.Images[idx];
      17:    Result := WObjects18.Images[idx];
      18:    Result := WObjects19.Images[idx];
      19:    Result := WObjects20.Images[idx];
      20:    Result := WObjects21.Images[idx];
      21:    Result := WObjects22.Images[idx];
      22:    Result := WObjects23.Images[idx];
  else
    Result := WObjects1.Images[idx];
  end;
end;

function GetObjsEx(wunit, idx: integer; var px, py: integer): TAsphyreLockableTexture;
begin
  case wunit of
    0:
      Result := WObjects1.GetCachedImage(idx, px, py);
    1:
      Result := WObjects2.GetCachedImage(idx, px, py);
    2:
      Result := WObjects3.GetCachedImage(idx, px, py);
    3:
      Result := WObjects4.GetCachedImage(idx, px, py);
    4:
      Result := WObjects5.GetCachedImage(idx, px, py);
    5:
      Result := WObjects6.GetCachedImage(idx, px, py);
    6:
      Result := WObjects7.GetCachedImage(idx, px, py);
      7:
      Result := WObjects8.GetCachedImage(idx, px, py);
      8:
      Result := WObjects9.GetCachedImage(idx, px, py);
      9:
      Result := WObjects10.GetCachedImage(idx, px, py);
      10:
      Result := WObjects11.GetCachedImage(idx, px, py);
      11:
      Result := WObjects12.GetCachedImage(idx, px, py);
      12:
      Result := WObjects13.GetCachedImage(idx, px, py);
      13:
      Result := WObjects14.GetCachedImage(idx, px, py);
      14:
      Result := WObjects15.GetCachedImage(idx, px, py);
      15:
      Result := WObjects16.GetCachedImage(idx, px, py);
      16:
      Result := WObjects17.GetCachedImage(idx, px, py);
      17:
      Result := WObjects18.GetCachedImage(idx, px, py);
      18:
      Result := WObjects19.GetCachedImage(idx, px, py);
      19:
      Result := WObjects20.GetCachedImage(idx, px, py);
      20:
      Result := WObjects21.GetCachedImage(idx, px, py);
      21:
      Result := WObjects22.GetCachedImage(idx, px, py);
      22:
      Result := WObjects23.GetCachedImage(idx, px, py);
  else
    Result := WObjects1.GetCachedImage(idx, px, py);
  end;
end;

function BagItemCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(ItemArr) to High(ItemArr) do begin
    if ItemArr[I].s.Name <> '' then Inc(Result);
  end;
end;

procedure ClearItemFilter(d: Byte);
var
  StringList: TStringList;
  fn: string;
begin
  case d of
    1:
      begin
        StringList := TStringList.Create;
        fn := '.\Config\' + frmMain.CharName + '\ItemFilter.txt';
        StringList.SaveToFile(fn);
        StringList.free;
      end;
  end;
  g_ItemsFilter_All_Str.Clear;
  g_ItemsFilter_Dress.Clear;
  g_ItemsFilter_Weapon.Clear;
  g_ItemsFilter_Headgear.Clear;
  g_ItemsFilter_Drug.Clear;
  g_ItemsFilter_Other.Clear;
  g_ItemsFilter_Find_Str.Clear;
end;

procedure ScreenChanged();
begin
  g_TileMapOffSetX := Round(g_FScreenWidth div 2 / UNITX) + 1;
  g_TileMapOffSetY := Round(g_FScreenHeight div 2 / UNITY);
  AAX := (g_FScreenWidth - UNITX) div 2 mod UNITX;
end;

function ShiftYOffset(): Integer;
begin
  Result := Round((g_FScreenHeight - 150) / UNITY / 2) * UNITY - HALFY;
end;

procedure LoadLightImages();
var
  I: integer;
  Png: TPngImage;
  AResource: TResourceStream;
begin
  for I := 0 to 5 do begin
    AResource := TResourceStream.Create(HInstance, 'PngImage'+IntToStr(I), RT_RCDATA);
    LightImages[I] := Factory.CreateLockableTexture;

    Png := TPngImage.Create;
    try
      Png.LoadFromStream(AResource);
      LightImages[I].LoadFromPng(Png);
    finally
      Png.Free;
      AResource.Free;
    end;
  end;
end;

procedure UnLoadLightImages();
var
  I: integer;
begin
  for I := 0 to 5 do begin
    if LightImages[I] <> nil then begin
      try
        LightImages[I].Free;
      finally
        LightImages[I] := nil;
      end;
    end;
  end;
end;

initialization
begin
  g_UnbindItemList := tlist.Create;
  g_ItemsFilter_All := TCnHashTableSmall.Create;
  g_ItemsFilter_All_Def := TCnHashTableSmall.Create;
  g_ItemsFilter_All_Str := TStringList.Create;
  g_ItemsFilter_Dress := TStringList.Create;
  g_ItemsFilter_Weapon := TStringList.Create;
  g_ItemsFilter_Headgear := TStringList.Create;
  g_ItemsFilter_Drug := TStringList.Create;
  g_ItemsFilter_Other := TStringList.Create;
  g_ItemsFilter_Find_Str := TStringList.Create;
end;

finalization
begin
  Freeandnil(g_UnbindItemList);
  g_ItemsFilter_All.Free;
  g_ItemsFilter_All_Def.Free;
  g_ItemsFilter_All_Str.Free;
  g_ItemsFilter_Dress.Free;
  g_ItemsFilter_Weapon.Free;
  g_ItemsFilter_Headgear.Free;
  g_ItemsFilter_Drug.Free;
  g_ItemsFilter_Other.Free;
  g_ItemsFilter_Find_Str.Free;
end;

end.

