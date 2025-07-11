unit NgShare;

interface

uses
  windows, Classes, Graphics, SysUtils, IniFiles, Grobal2, DWinCtl;

const
  g_sRenewBooks: array[0..3] of string = (
    '随机传送卷', //shape = 2
    '地牢逃脱卷', //shape = 1
    '回城卷', //shape = 3
    '行会回城卷'
    );

type
  TMapDescList = record
    sMapName: string[50];
    MaxList: TList;
    MinList: TList;
  end;
  pTMapDescList = ^TMapDescList;

  TMapDesc = record
    sName: string[50];
    nX, nY: Word;
    nColor: TColor;
  end;
  pTMapDesc = ^TMapDesc;

  TItemFiltrate = packed record
    boItemHiht: Boolean;
    boPickUp: Boolean;
    boShowName: Boolean;
  end;

  pTItemFiltrate = ^TItemFiltrate;

  NgConfigInfo = record
//----------------------------基本----------------------------------------
    boShowName: boolean;//显示人名
    boNotDeath: Boolean;//隐藏尸体
    boDuraWarning: boolean;//持久警告
    boNotNeedShift: boolean;//免shift
    boExpShow: boolean;//经验过滤
    nExpShow: Integer;//经验过滤
    boBrightShowHp: boolean;//高亮显血
    boShowMap: boolean;//显示地图标识
//--------------------------物品-----------------------------------------------
    boPickUpItemAll: Boolean;
//--------------------------保护-----------------------------------------------
    boSpecialHP: Boolean;
    nSpecialHP: Integer;
    nwSpecialHP: LongWord;

    boRanHP: Boolean;
    nRanHP: Integer;
    nwRanHP: LongWord;
    sRanItemName: string;
//--------------------------药品-----------------------------------------------
    boHpPtEat: Boolean;
    nHpPtEat: Integer;
    nwHpPtEat: LongWord;
    boMpPtEat: Boolean;
    nMpPtEat: Integer;
    nwMpPtEat: LongWord;
//--------------------------技能-----------------------------------------------
    boAutoFireHit: Boolean;
    boAutoShield: Boolean;
    boAutoHide: Boolean;
    boAutoHld: Boolean;
    boAutoJld: Boolean;
    boAutoLongHit: Boolean;
    boAutoMagic: Boolean;
    nwAutoMagic: LongWord;
    nAutoMagicID: Integer;
  end;

var
  g_MapDescList: TList; //地图备注信息
  g_MapDesc: pTMapDescList = nil;
  g_boShiftOff: Boolean = False;
  g_boShiftUp: Boolean = False;
  g_boMirDark: Boolean = True;


  g_DefaultNgConfigInfo: NgConfigInfo = (//
//----------------------------基本----------------------------------------
    boShowName: true; //
    boNotDeath: false;
    boDuraWarning: false; //
    boNotNeedShift: false; //
    boExpShow: false; //
    nExpShow: 2000;//经验过滤
    boBrightShowHp: false; //
    boShowMap: false; //
//--------------------------物品-----------------------------------------------
    boPickUpItemAll: True;
//--------------------------保护-----------------------------------------------
    boSpecialHP: False;
    nSpecialHP: 10;
    nwSpecialHP: 4;

    boRanHP: False;
    nRanHP: 10;
    nwRanHP: 4;
    sRanItemName: '';
//--------------------------药品-----------------------------------------------
    boHpPtEat : False;
    nHpPtEat : 10;
    nwHpPtEat : 4;
    boMpPtEat : False;
    nMpPtEat : 10;
    nwMpPtEat : 4;
//--------------------------技能-----------------------------------------------
    boAutoFireHit: False;
    boAutoShield: False;
    boAutoHide: False;
    boAutoHld: False;
    boAutoJld: False;
    boAutoLongHit: False;
    boAutoMagic: False;
    nwAutoMagic: 4;
    nAutoMagicID: -1;
  );
  g_NgConfigInfo: NgConfigInfo;
  g_DwItemDuraTick: LongWord = 0;
  g_DwEatHpTick: LongWord = 0;
  g_DwEatMpTick: LongWord = 0;
  g_DwAutoFireTick: LongWord = 0;
  g_DwAutoShieldTick: LongWord = 0;
  g_DwAutoHideTick: LongWord = 0;
  g_DwAutoMagicTick: LongWord = 0;
  g_DwSpecialHPTick: LongWord = 0;
  g_DwAutoRanHPTick: LongWord = 0;
  g_DwAutoPickUpItemTick: LongWord = 0;
  g_boMirNg: Boolean = True;
  g_boMirShowHp: Boolean = True;
  g_boMirShowNumber: Boolean = True;
  g_MemoList: TStringList;
  g_Memobyte: Byte = 0;
  bo摆摊: boolean = false;
  boHelp: boolean = false;

  g_TopDWindow: TDWindow = nil;

  g_boHostpot: boolean = false;
  g_boQuestions: boolean = false;
  g_boChinese: boolean = false;
  g_boWhisperWin: boolean = false;
  g_boRelationWin: boolean = false;
  g_boMirShop: boolean = false;
  g_bofuguHP: Boolean = False;
  g_bozuduihp: Boolean = False;
  g_boHostpotWeb : string = '';
  g_bopaobusudu  : Integer = 110;
  g_MAGICSPEED  : Integer = 500;
  g_ATTACKSPEED  : Integer = 1400;
  g_boQuestionsWeb  : string = '';
  g_bo免助跑: boolean = false;
  g_bo技能备注: boolean = false;
  g_bo物品窗口: boolean = false;
  g_bo主界面: boolean = false;
    g_bo锁定人物: boolean= false;
    g_bo锁定怪物: boolean= false;
  g_boRefreshBagItem: boolean = false;
  g_dw刷新背包间隔: LongWord = 0;

  g_bo极品蓝字: boolean = false;
 g_bo自动换符: boolean = true;
  g_bo自动换毒: boolean = true;
  g_bo地图雷达: boolean = true;
  g_bo悬浮信息: boolean = true;
  g_bo人物四格: boolean = true;
  g_bo大地图开关: boolean = true;
  g_bo小地图迷宫入口显示: boolean = true;
  g_bo稳如泰山: boolean = false;
  g_bosjcd: boolean = false;
  g_bozdfy: boolean = false;
  g_Deatheject: boolean = false;
  g_bo绝对泰山: boolean = false;
  g_bo刀刀刺杀: boolean = false;
  g_bo战斗退出: boolean = false;
  g_bochksigedu: boolean = false;
procedure LoadMapDescList(const FileName: string);

function GetMapDescList(sMapName: string): pTMapDescList;

procedure ClearMapDescList();

procedure LoadNgInfo();

procedure SaveNgInfo();

procedure CloseNgInfo();

procedure LoadMemoList;

implementation

uses
  HUtil32, ClMain, MShare, FState;

procedure LoadMemoList;
var
  TempFile: string;
  I: Integer;
begin
  TempFile := 'Config\' + FrmMain.CharName + '\Memo.txt';
  case g_Memobyte of
    0:
      begin
        g_Memobyte := 1;
        if FileExists(TempFile) then
        begin
          g_MemoList.LoadFromFile(TempFile);
          for I := 0 to g_MemoList.Count - 1 do
            FrmDlg.DSdoMemo.Lines.Add(g_MemoList.Strings[i]);
        end;
      end;
  else
    begin
      if g_MemoList.Count > 1 then
      begin
        FrmDlg.DSdoMemo.Lines.Clear;
        for I := 0 to g_MemoList.Count - 1 do
          FrmDlg.DSdoMemo.Lines.Add(g_MemoList.Strings[i]);
      end;
    end;
  end;
end;

procedure CloseNgInfo();
begin
  g_NgConfigInfo.boShowName := False;
  g_NgConfigInfo.boNotDeath := False;
  g_NgConfigInfo.boDuraWarning := False;
  g_NgConfigInfo.boNotNeedShift := False;
  g_NgConfigInfo.boExpShow := False;
  g_NgConfigInfo.boBrightShowHp := False;
  g_NgConfigInfo.boShowMap := False;
  g_NgConfigInfo.boPickUpItemAll := False;
  g_NgConfigInfo.boSpecialHP := False;
  g_NgConfigInfo.boRanHP := False;
  g_NgConfigInfo.boHpPtEat := False;
  g_NgConfigInfo.boMpPtEat := False;
  g_NgConfigInfo.boAutoFireHit := False;
  g_NgConfigInfo.boAutoShield := False;
  g_NgConfigInfo.boAutoHide := False;
  g_NgConfigInfo.boAutoHld := False;
  g_NgConfigInfo.boAutoJld := False;
  g_NgConfigInfo.boAutoLongHit := False;
  g_NgConfigInfo.boAutoMagic := False;
end;

procedure LoadNgInfo();
var
  ini: TIniFile;
begin
  ini := TIniFile.Create('Config\' + FrmMain.CharName + '\NgConfig.ini');
  if ini <> nil then
  begin
    g_NgConfigInfo.boShowName := ini.ReadBool('Setup', 'ShowName', g_NgConfigInfo.boShowName);
    g_NgConfigInfo.boNotDeath := ini.ReadBool('Setup', 'NotDeath', g_NgConfigInfo.boNotDeath);
    g_NgConfigInfo.boDuraWarning := ini.ReadBool('Setup', 'DuraWarning', g_NgConfigInfo.boDuraWarning);
    g_NgConfigInfo.boNotNeedShift := ini.ReadBool('Setup', 'NotNeedShift', g_NgConfigInfo.boNotNeedShift);
    g_NgConfigInfo.boExpShow := ini.ReadBool('Setup', 'ExpShow', g_NgConfigInfo.boExpShow);
    g_NgConfigInfo.nExpShow := ini.ReadInteger('Setup', 'nExpShow', g_NgConfigInfo.nExpShow);
    g_NgConfigInfo.boBrightShowHp := ini.ReadBool('Setup', 'BrightShowHp', g_NgConfigInfo.boBrightShowHp);
    g_NgConfigInfo.boShowMap := ini.ReadBool('Setup', 'ShowMap', g_NgConfigInfo.boShowMap);
    g_NgConfigInfo.boPickUpItemAll := ini.ReadBool('Setup', 'PickUpItemAll', g_NgConfigInfo.boPickUpItemAll);
    g_NgConfigInfo.boSpecialHP := ini.ReadBool('Setup', 'SpecialHP', g_NgConfigInfo.boSpecialHP);
    g_NgConfigInfo.nSpecialHP := ini.ReadInteger('Setup', 'nSpecialHP', g_NgConfigInfo.nSpecialHP);
    g_NgConfigInfo.nwSpecialHP := ini.ReadInteger('Setup', 'wSpecialHP', g_NgConfigInfo.nwSpecialHP);
    g_NgConfigInfo.boRanHP := ini.ReadBool('Setup', 'RanHP', g_NgConfigInfo.boRanHP);
    g_NgConfigInfo.nRanHP := ini.ReadInteger('Setup', 'nRanHP', g_NgConfigInfo.nRanHP);
    g_NgConfigInfo.nwRanHP := ini.ReadInteger('Setup', 'wRanHP', g_NgConfigInfo.nwRanHP);
    g_NgConfigInfo.sRanItemName := ini.ReadString('Setup', 'RanItemName', g_NgConfigInfo.sRanItemName);
    g_NgConfigInfo.boHpPtEat := ini.ReadBool('Setup', 'HpPtEat', g_NgConfigInfo.boHpPtEat);
    g_NgConfigInfo.nHpPtEat := ini.ReadInteger('Setup', 'nHpPtEat', g_NgConfigInfo.nHpPtEat);
    g_NgConfigInfo.nwHpPtEat := ini.ReadInteger('Setup', 'wHpPtEat', g_NgConfigInfo.nwHpPtEat);
    g_NgConfigInfo.boMpPtEat := ini.ReadBool('Setup', 'MpPtEat', g_NgConfigInfo.boMpPtEat);
    g_NgConfigInfo.nMpPtEat := ini.ReadInteger('Setup', 'nMpPtEat', g_NgConfigInfo.nMpPtEat);
    g_NgConfigInfo.nwMpPtEat := ini.ReadInteger('Setup', 'wMpPtEat', g_NgConfigInfo.nwMpPtEat);
    g_NgConfigInfo.boAutoFireHit := ini.ReadBool('Setup', 'AutoFireHit', g_NgConfigInfo.boAutoFireHit);
    g_NgConfigInfo.boAutoShield := ini.ReadBool('Setup', 'AutoShield', g_NgConfigInfo.boAutoShield);
    g_NgConfigInfo.boAutoHide := ini.ReadBool('Setup', 'AutoHide', g_NgConfigInfo.boAutoHide);
    g_NgConfigInfo.boAutoHld := ini.ReadBool('Setup', 'AutoHld', g_NgConfigInfo.boAutoHld);
    g_NgConfigInfo.boAutoJld := ini.ReadBool('Setup', 'AutoJld', g_NgConfigInfo.boAutoJld);
    g_NgConfigInfo.boAutoLongHit := ini.ReadBool('Setup', 'AutoLongHit', g_NgConfigInfo.boAutoLongHit);
    g_NgConfigInfo.boAutoMagic := ini.ReadBool('Setup', 'AutoMagic', g_NgConfigInfo.boAutoMagic);
    g_NgConfigInfo.nwAutoMagic := ini.ReadInteger('Setup', 'wAutoMagic', g_NgConfigInfo.nwAutoMagic);
    g_NgConfigInfo.nAutoMagicID := ini.ReadInteger('Setup', 'AutoMagicID', g_NgConfigInfo.nAutoMagicID);
  end
  else
    g_NgConfigInfo := g_DefaultNgConfigInfo;
  ini.Free;
end;

procedure SaveNgInfo();
var
  ini: TIniFile;
begin
  if not DirectoryExists('.\Config\' + FrmMain.CharName) then
    ForceDirectories('.\Config\' + FrmMain.CharName);
  ini := TIniFile.Create('Config\' + FrmMain.CharName + '\NgConfig.ini');
  if ini <> nil then
  begin
    ini.WriteBool('Setup', 'ShowName', g_NgConfigInfo.boShowName);
    ini.WriteBool('Setup', 'NotDeath', g_NgConfigInfo.boNotDeath);
    ini.WriteBool('Setup', 'DuraWarning', g_NgConfigInfo.boDuraWarning);
    ini.WriteBool('Setup', 'NotNeedShift', g_NgConfigInfo.boNotNeedShift);
    ini.WriteBool('Setup', 'ExpShow', g_NgConfigInfo.boExpShow);
    ini.WriteInteger('Setup', 'nExpShow', g_NgConfigInfo.nExpShow);
    ini.WriteBool('Setup', 'BrightShowHp', g_NgConfigInfo.boBrightShowHp);
    ini.WriteBool('Setup', 'ShowMap', g_NgConfigInfo.boShowMap);
    ini.WriteBool('Setup', 'PickUpItemAll', g_NgConfigInfo.boPickUpItemAll);
    ini.WriteBool('Setup', 'SpecialHP', g_NgConfigInfo.boSpecialHP);
    ini.WriteInteger('Setup', 'nSpecialHP', g_NgConfigInfo.nSpecialHP);
    ini.WriteInteger('Setup', 'wSpecialHP', g_NgConfigInfo.nwSpecialHP);
    ini.WriteBool('Setup', 'RanHP', g_NgConfigInfo.boRanHP);
    ini.WriteInteger('Setup', 'nRanHP', g_NgConfigInfo.nRanHP);
    ini.WriteInteger('Setup', 'wRanHP', g_NgConfigInfo.nwRanHP);
    ini.ReadString('Setup', 'RanItemName', g_NgConfigInfo.sRanItemName);
    ini.WriteBool('Setup', 'HpPtEat', g_NgConfigInfo.boHpPtEat);
    ini.WriteInteger('Setup', 'nHpPtEat', g_NgConfigInfo.nHpPtEat);
    ini.WriteInteger('Setup', 'wHpPtEat', g_NgConfigInfo.nwHpPtEat);
    ini.WriteBool('Setup', 'MpPtEat', g_NgConfigInfo.boMpPtEat);
    ini.WriteInteger('Setup', 'nMpPtEat', g_NgConfigInfo.nMpPtEat);
    ini.WriteInteger('Setup', 'wMpPtEat', g_NgConfigInfo.nwMpPtEat);
    ini.WriteBool('Setup', 'AutoFireHit', g_NgConfigInfo.boAutoFireHit);
    ini.WriteBool('Setup', 'AutoShield', g_NgConfigInfo.boAutoShield);
    ini.WriteBool('Setup', 'AutoHide', g_NgConfigInfo.boAutoHide);
    ini.WriteBool('Setup', 'AutoHld', g_NgConfigInfo.boAutoHld);
    ini.WriteBool('Setup', 'AutoJld', g_NgConfigInfo.boAutoJld);
    ini.WriteBool('Setup', 'AutoLongHit', g_NgConfigInfo.boAutoLongHit);
    ini.WriteBool('Setup', 'AutoMagic', g_NgConfigInfo.boAutoMagic);
    ini.WriteInteger('Setup', 'wAutoMagic', g_NgConfigInfo.nwAutoMagic);
    ini.WriteInteger('Setup', 'AutoMagicID', g_NgConfigInfo.nAutoMagicID);
  end;
  ini.Free;
  SaveItemFilter;
  g_MemoList.SaveToFile('Config\' + FrmMain.CharName + '\Memo.txt');
end;

procedure LoadMapDescList(const FileName: string);
  procedure AddMapDescToList(sMapName: string; MapDesc: pTMapDesc; boMax: Boolean);
  var
    i: integer;
    MapDescList: pTMapDescList;
  begin
    for I := g_MapDescList.Count - 1 downto 0 do begin
      MapDescList := g_MapDescList[i];
      if MapDescList.sMapName = sMapName then begin
        if boMax then
          MapDescList.MaxList.Add(MapDesc)
        else
          MapDescList.MinList.Add(MapDesc);
        exit;
      end;
    end;
    New(MapDescList);
    MapDescList.sMapName := sMapName;
    MapDescList.MaxList := TList.Create;
    MapDescList.MinList := TList.Create;
    if boMax then
      MapDescList.MaxList.Add(MapDesc)
    else
      MapDescList.MinList.Add(MapDesc);
    g_MapDescList.Add(MapDescList);
  end;
var
  i: integer;
  str: string;
  MapDesc: pTMapDesc;
  sMapName, sx, sy, sName, sColor, sMax: string;
  LoadList: TStringList;
  MapDescRes: TResourceStream;
begin
  ClearMapDescList();
  LoadList := TStringList.Create;
  MapDescRes := TResourceStream.Create(HInstance, 'MapDesc', 'MapDescFile');
  if MapDescRes <> nil then begin
    try
      LoadList.LoadFromStream(MapDescRes);
    except
      LoadList.Clear;
    end;
  end;
  for I := 0 to LoadList.Count - 1 do begin
    str := LoadList[i];
    if (str <> '') and (str[1] <> ';') then begin
      str := GetValidStr3(str, sMapName, [' ', #9, ',']);
      str := GetValidStr3(str, sx, [' ', #9, ',']);
      str := GetValidStr3(str, sy, [' ', #9, ',']);
      str := GetValidStr3(str, sName, [' ', #9, ',']);
      str := GetValidStr3(str, sColor, [' ', #9, ',']);
      str := GetValidStr3(str, sMax, [' ', #9, ',']);
      if (sMax <> '') then begin
        New(MapDesc);
        MapDesc.sName := sName;
        MapDesc.nX := StrToIntDef(sX, -1);
        MapDesc.nY := StrToIntDef(sY, -1);
        MapDesc.nColor := StrToIntDef(sColor, 0);
        AddMapDescToList(sMapName, MapDesc, (sMax = '0'));
      end;
    end;
  end;
  LoadList.Free;
end;

function GetMapDescList(sMapName: string): pTMapDescList;
var
  i: integer;
  MapDescList: pTMapDescList;
begin
  Result := nil;
  for i := 0 to g_MapDescList.Count - 1 do begin
    MapDescList := g_MapDescList[i];
    if MapDescList.sMapName = sMapname then begin
      Result := MapDescList;
      break;
    end;
  end;
end;

procedure ClearMapDescList();
var
  i, ii: integer;
  MapDescList: pTMapDescList;
begin
  for i := 0 to g_MapDescList.Count - 1 do begin
    MapDescList := g_MapDescList[i];
    for ii := 0 to MapDescList.MaxList.Count - 1 do
      Dispose(pTMapDesc(MapDescList.MaxList[ii]));
    for ii := 0 to MapDescList.MinList.Count - 1 do
      Dispose(pTMapDesc(MapDescList.MinList[ii]));
    MapDescList.MaxList.Free;
    MapDescList.MinList.Free;
    Dispose(MapDescList);
  end;
  g_MapDescList.Clear;
end;

initialization
begin
  g_NgConfigInfo := g_DefaultNgConfigInfo;
  if not DirectoryExists('.\Config\') then
    ForceDirectories('.\Config\');
  g_MapDescList := TList.create;
  g_MemoList := TStringList.Create;
end

finalization
begin
  g_MapDescList.Free;
  g_MemoList.Free;
end;

end.
