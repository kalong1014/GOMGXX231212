unit DrawScrn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IntroScn, Actor, cliUtil, clFunc, Grobal2, AbstractDevices, AbstractCanvas,
  AbstractTextures, AsphyreTextureFonts, uGameEngine, uCommon, HUtil32;

const
  MAXSYSLINE = 8;
  BOTTOMBOARD = 1;
  VIEWCHATLINE = 9;
  AREASTATEICONBASE = 150;
  AREASTATEICOSAFE = 151;
//  HEALTHBAR_BLACK = 0;
//  HEALTHBAR_RED = 1;
//  HEALTHBAR_BLUE = 10;

type
  TDrawScreen = class
  private
    MoveTextTime: longword;
    frametime, framecount, drawframecount: longword;
    SysMsg: TStringList;
  public
    CurrentScene: TScene;
    ChatStrs: TStringList;
    HornStrs:TStringList;
    ChatBks: TList;
    ChatBoardTop: integer;
    HintList: TStringList;
    HintX, HintY, HintWidth, HintHeight: integer;
    HintUp: Boolean;
    HintColor: TColor;
    FMagicHint: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure KeyPress(var Key: Char);
    procedure KeyDown(var Key: Word; Shift: TShiftState);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Initialize;
    procedure Finalize;
    procedure ChangeScene(scenetype: TSceneType);
    procedure BeginDrawScreen(Device: TAsphyreDevice; MSurface: TAsphyreCanvas);
    procedure DrawScreen(MSurface: TAsphyreCanvas);
    procedure DrawScreenTop(MSurface: TAsphyreCanvas);
    procedure ScrollingText (MSurface: TAsphyreCanvas; str: string);
    procedure AddSysMsg(msg: string);
    procedure AddChatBoardString(str: string; fcolor, bcolor: integer);
    procedure AddHorn(str: string; fc, bc, fixde: byte);
    procedure ClearChatBoard;
    procedure ShowHint(x, y: integer; str: string; color: TColor; drawup: Boolean; MagicHint: Boolean = False; drawleft: Boolean = False);
    procedure ClearHint(boClear: Boolean);
    procedure DrawHint(MSurface: TAsphyreCanvas);
  end;

implementation

uses
  ClMain, MShare, NgShare;

constructor TDrawScreen.Create;
var
  i: integer;
begin
  CurrentScene := nil;
  frametime := GetTickCount;
  framecount := 0;
  SysMsg := TStringList.Create;
  ChatStrs := TStringList.Create;
  HornStrs:=TStringList.Create;
  ChatBks := TList.Create;
  ChatBoardTop := 0;
  FMagicHint := False;
  HintList := TStringList.Create;

end;

destructor TDrawScreen.Destroy;
begin
  SysMsg.Free;
  ChatStrs.Free;
  HornStrs.Free;
  ChatBks.Free;
  HintList.Free;
  inherited Destroy;
end;

procedure TDrawScreen.Initialize;
begin
end;

procedure TDrawScreen.Finalize;
begin
end;

procedure TDrawScreen.KeyPress(var Key: Char);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyPress(Key);
end;

procedure TDrawScreen.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyDown(Key, Shift);
end;

procedure TDrawScreen.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseMove(Shift, X, Y);
end;

procedure TDrawScreen.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseDown(Button, Shift, X, Y);
end;

procedure TDrawScreen.ChangeScene(scenetype: TSceneType);
begin
  if CurrentScene <> nil then
    CurrentScene.CloseScene;
  case scenetype of
    stIntro:
      CurrentScene := IntroScene;
    stLogin:
      CurrentScene := LoginScene;
    stSelectCountry:
      ;
    stSelectChr:
      CurrentScene := SelectChrScene;
    stNewChr:
      ;
    stLoading:
      ;
    stLoginNotice:
      CurrentScene := LoginNoticeScene;
    stPlayGame:
      CurrentScene := PlayScene;
  end;
  if CurrentScene <> nil then
    CurrentScene.OpenScene;
end;
//添加系统信息

procedure TDrawScreen.AddHorn(str: string; fc, bc, fixde: byte);
var
  i, len, aline, BOXWIDTH: integer;
  dline, temp: string;
  phc: pTHornColor;
begin
  if g_FScreenWidth = 1024 then
    BOXWIDTH := 374 + 224
  else
    BOXWIDTH := 374;
  if HornStrs.Count >= 5 then  //传音筒固顶消息条数
  begin
    for I := 0 to HornStrs.Count - 1 do
    begin
      phc := pTHornColor(DScreen.HornStrs.Objects[i]);
      if phc.fixde <> 1 then
      begin
        Dispose(pTHornColor(DScreen.HornStrs.Objects[I]));
        HornStrs.Delete(I);
        Break;
      end;
    end;
  end;
  len := Length(str);
  temp := '';
  i := 1;
  New(phc);
  phc.FColor := fc;
  phc.BColor := bc;
  phc.STime := gettickcount;
  phc.fixde := fixde;
  while TRUE do
  begin
    if i > len then
      break;
    if byte(str[i]) >= 128 then
    begin
      temp := temp + str[i];
      Inc(i);
      if i <= len then
        temp := temp + str[i]
      else
        break;
    end
    else
      temp := temp + str[i];

    aline := FrmMain.Canvas.TextWidth(temp);
    if aline > BOXWIDTH then
    begin
//      HornStrs.AddObject(temp, TObject(gettickcount));
      HornStrs.AddObject(temp, TObject(phc));
      str := '';
      temp := '';
      break;
    end;
    Inc(i);
  end;
  if temp <> '' then
  begin
//    HornStrs.AddObject(temp, TObject(gettickcount));
    HornStrs.AddObject(temp, TObject(phc));
    str := '';
  end;
 if str <> '' then
//    HornStrs.AddObject(temp, TObject(gettickcount));
    HornStrs.AddObject(temp, TObject(phc));
end;

procedure TDrawScreen.AddSysMsg(msg: string);
begin
  if SysMsg.Count >= 10 then
    SysMsg.Delete(0);
  SysMsg.AddObject(msg, TObject(GetTickCount));
end;
//添加信息聊天板

procedure TDrawScreen.AddChatBoardString(str: string; fcolor, bcolor: integer);
var
  i, len, aline, BOXWIDTH: integer;
  dline, temp: string;
begin
  if g_FScreenWidth = 1024 then BOXWIDTH := 374 + 224
  else BOXWIDTH := 374;
  len := Length(str);
  temp := '';
  i := 1;
  while TRUE do
  begin
    if i > len then
      break;
    if byte(str[i]) >= 128 then
    begin
      temp := temp + str[i];
      Inc(i);
      if i <= len then
        temp := temp + str[i]
      else
        break;
    end
    else
      temp := temp + str[i];

    aline := FontManager.Default.TextWidth(temp);
    if aline > BOXWIDTH then
    begin
      ChatStrs.AddObject(temp, TObject(fcolor));
      ChatBks.Add(Pointer(bcolor));
      str := Copy(str, i + 1, len - i);
      temp := '';
      break;
    end;
    Inc(i);
  end;

  if temp <> '' then
  begin
    ChatStrs.AddObject(temp, TObject(fcolor));
    ChatBks.Add(Pointer(bcolor));
    str := '';
  end;
  if ChatStrs.Count > 200 then
  begin
    ChatStrs.Delete(0);
    ChatBks.Delete(0);
    if ChatStrs.Count - ChatBoardTop < VIEWCHATLINE then
      Dec(ChatBoardTop);
  end
  else if (ChatStrs.Count - ChatBoardTop) > VIEWCHATLINE then
  begin
    Inc(ChatBoardTop);
  end;

  if str <> '' then
    AddChatBoardString(' ' + str, fcolor, bcolor);

end;
//鼠标放在某个物品上显示的信息

procedure TDrawScreen.ShowHint(x, y: integer; str: string; color: TColor; drawup: Boolean; MagicHint: Boolean; drawleft: Boolean);
var
  data, data2, data3, Tempname: string;
  w, h, TempL: integer;
  nColor: Byte;
begin
  ClearHint(True);
  HintX := x;
  HintY := y;
  HintWidth := 0;
  HintHeight := 0;
  HintUp := drawup;
  HintColor := color;
  nColor := 0;
  FMagicHint := MagicHint;
  while TRUE do
  begin
    if str = '' then
      break;
    if MagicHint then
    begin
      Inc(nColor);
    end;
    str := GetValidStr3(str, data, ['\']);
    if Pos('$', data) > 0 then
    begin
      TempL := 0;
      data2 := data;
      data2 := GetValidStr3(data2, data3, ['$']);
      data3 := GetValidStr3(data3, Tempname, ['|']);
      nColor := StrToIntDef(data3, 0);
      TempL := FrmMain.Canvas.TextWidth(Tempname);
      w := TempL;
      data2 := GetValidStr3(data2, Tempname, ['|']);
      nColor := StrToIntDef(data2, 0);
      TempL := FrmMain.Canvas.TextWidth(Tempname);
      w := w + TempL;
    end
    else if Pos('|', data) > 0 then
    begin
      data2 := data;
      data2 := GetValidStr3(data2, Tempname, ['|']);
      nColor := StrToIntDef(data2, 0);
      w := FrmMain.Canvas.TextWidth(Tempname);
    end else
    w := FrmMain.Canvas.TextWidth(data) + 4{空白}  * 2;
    if w > HintWidth then
      HintWidth := w;
    if data <> '' then
      if MagicHint then
      begin
        case nColor of
          1: HintList.AddObject(data, TObject(RGB(0, 255, 0)));
          2: HintList.AddObject(data, TObject(RGB(255, 255, 0)));
          3: HintList.AddObject(data, TObject(RGB(255, 255, 255)));
        end;
      end
      else
        HintList.AddObject(data, TObject(HintColor));
  end;
  HintHeight := (FrmMain.Canvas.TextHeight('A') + 1) * HintList.Count + 3{空白}  * 2;
  if HintUp then
    HintY := HintY - HintHeight;
  if drawleft then
    HintX := HintX - HintWidth;
end;
//清除鼠标放在某个物品上显示的信息

procedure TDrawScreen.ClearHint(boClear: Boolean);
begin
  if boClear then
  begin
    HintList.Clear;
  end;
end;

procedure TDrawScreen.ClearChatBoard;
var
  I: Integer;
  phc: pTHornColor;
begin
  SysMsg.Clear;
  ChatStrs.Clear;
  ChatBks.Clear;
  ChatBoardTop := 0;

  for I := HornStrs.Count - 1 downto 0 do
  begin
    Dispose(pTHornColor(DScreen.HornStrs.Objects[I]));
    HornStrs.Delete(I);
  end;
  HornStrs.Clear;
end;

procedure TDrawScreen.BeginDrawScreen(Device: TAsphyreDevice; MSurface: TAsphyreCanvas);
begin
  if CurrentScene <> nil then
    CurrentScene.BeginScene(Device, MSurface);
end;

procedure TDrawScreen.DrawScreen(MSurface: TAsphyreCanvas);

(*
  procedure NameTextOut(surface: TAsphyreCanvas; x, y, fcolor, bcolor: integer; namestr: string);
  var
    i, row: integer;
    nstr: string;
  begin
    row := 0;
    for i := 0 to 10 do
    begin
      if namestr = '' then
        break;
      namestr := GetValidStr3(namestr, nstr, ['\']);
//         BoldTextOut (surface,
//                      x - surface.Canvas.TextWidth(nstr) div 2,
//                      y + row * 12,
//                      fcolor, bcolor, nstr);

      surface.BoldTextOut(x - FontManager.Default.TextWidth(nstr) div 2, y + row * 12, fcolor, bcolor, nstr);
      Inc(row);
    end;
  end;
*)

var
  i, k, line, sx, sy, fcolor, bcolor {,TempNameColor}: integer;
  actor: TActor;
  str{, uname}: string;
  dsurface: TAsphyreLockableTexture;
  d: TAsphyreLockableTexture;
//  rc: TRect;
//  infoMsg: string;
//  HpColor, Right: Integer;
begin
  // MSurface.Fill(0);
  if CurrentScene <> nil then
    CurrentScene.PlayScene(MSurface);

  if GetTickCount - frametime > 1000 then
  begin
    frametime := GetTickCount;
    drawframecount := framecount;
    framecount := 0;
  end;
  Inc(framecount);


   //SetBkMode (MSurface.Canvas.Handle, TRANSPARENT);
   //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'c1 ' + IntToStr(DebugColor1));
   //BoldTextOut (MSurface, 0, 20, clWhite, clBlack, 'c2 ' + IntToStr(DebugColor2));
   //BoldTextOut (MSurface, 0, 40, clWhite, clBlack, 'c3 ' + IntToStr(DebugColor3));
   //BoldTextOut (MSurface, 0, 60, clWhite, clBlack, 'c4 ' + IntToStr(DebugColor4));
   //MSurface.Canvas.Release;


  if Myself = nil then
    exit;

  if CurrentScene = PlayScene then
  begin
    with MSurface do
    begin
         //头上显示血条相关
      with PlayScene do
      begin
        (*
        for k := 0 to ActorList.Count - 1 do
        begin
          actor := ActorList[k];

          if g_boMirShowHp then begin
            if not actor.Death then begin
              if actor.BoInstanceOpenHealth then
                if GetTickCount - actor.OpenHealthStart > actor.OpenHealthTime then
                  actor.BoInstanceOpenHealth := FALSE;

          //数字显血

              if g_boMirShowNumber then begin
                if ( actor = MySelf ) or (g_bo绝对泰山) then begin
                  if ((actor.Abil.MaxHP > 1)) and not actor.Death then begin
                    infoMsg := IntToStr(actor.Abil.HP) + '/' + IntToStr(actor.Abil.MaxHP);
                    BoldTextOut(actor.SayX - {15}FontManager.Default.TextWidth(infoMsg)
                      div 2, actor.SayY - 23, clWhite, clBlack, infoMsg);
                  end;
                end
                else begin
                  if (actor.BoOpenHealth or actor.BoInstanceOpenHealth) and not actor.Death then
                    if ((actor.Abil.MaxHP > 1)) and not actor.Death then begin
                      infoMsg := IntToStr(actor.Abil.HP) + '/' + IntToStr(actor.Abil.MaxHP);
                      BoldTextOut(actor.SayX - {15}FontManager.Default.TextWidth(infoMsg)
                        div 2, actor.SayY - 23, clWhite, clBlack, infoMsg);
                    end;
                end;
              end
              else begin
                if (actor.BoOpenHealth and (actor.Abil.MaxHP > 1)) and not actor.Death
                  then begin
                  infoMsg := IntToStr(actor.Abil.HP) + '/' + IntToStr(actor.Abil.MaxHP);
                  BoldTextOut(actor.SayX - {15}FontManager.Default.TextWidth(infoMsg)
                    div 2, actor.SayY - 23, clWhite, clBlack, infoMsg);
                end;
              end;

              if actor.Race = 0 then begin
                d := WProgUse2.Images[HEALTHBAR_BLUE]; //组队蓝条
                HpColor := $FF0000;
              end
              else begin
                d := WProgUse2.Images[HEALTHBAR_RED];
                HpColor := $0000FF;
              end;

              if actor.Race in [12, 24, 50] then begin//大刀，带刀，NPC
                d := WProgUse2.Images[10];      //NPC头顶血条图片
                HpColor := $CE9C4A;
              end else
              begin
                if actor <> MySelf then begin
                  d := WProgUse2.Images[HEALTHBAR_RED];
                  HpColor := $0000FF;
                end else if g_NgConfigInfo.boBrightShowHp then begin
                  d := WProgUse2.Images[12];
                  HpColor := $00DE00;
                end else begin
                  d := WProgUse2.Images[HEALTHBAR_RED];
                  HpColor := $0000FF;
                end;
              end;


              if d <> nil then begin
                rc := d.ClientRect;
                if actor.Abil.MaxHP > 0 then
                  rc.Right := _MIN(Round((rc.Right - rc.Left) / actor.Abil.MaxHP * actor.Abil.HP), d.Width);
//                MSurface.Draw(actor.SayX - d.Width div 2, actor.SayY - 10, rc, d, TRUE);

                if actor.Abil.MaxHP > 0 then begin
                  Right := _MIN(31, Round(31 / actor.Abil.MaxHP * actor.Abil.HP));
                end
                else begin
                  Right := 31;
                end;
                FillRect(Rect(actor.SayX - 31 div 2,Actor.SayY - 9,actor.SayX - 31 div 2 + Right - 1,actor.SayY - 10 + 3), HpColor);
              end;
              d := WProgUse2.Images[HEALTHBAR_BLACK];
              if d <> nil then
                MSurface.Draw(actor.SayX - d.Width div 2, actor.SayY - 10, d.ClientRect, d, TRUE);
            end;
          end
          else begin
            if (actor.BoOpenHealth or actor.BoInstanceOpenHealth) and not actor.Death then begin
              if actor.BoInstanceOpenHealth then
                if GetTickCount - actor.OpenHealthStart > actor.OpenHealthTime then

                  actor.BoInstanceOpenHealth := FALSE;

              d := WProgUse2.Images[HEALTHBAR_BLACK];
              if d <> nil then
                MSurface.Draw(actor.SayX - d.Width div 2, actor.SayY - 10, d.ClientRect,
                  d, TRUE);
              if actor.Race = 0 then
                d := WProgUse2.Images[HEALTHBAR_BLUE] //组队蓝条
              else
                d := WProgUse2.Images[HEALTHBAR_RED];

              if actor.Race in [12, 24, 50] then //大刀，带刀，NPC
                d := WProgUse2.Images[10]      //NPC头顶血条图片
              else begin
                if actor <> MySelf then
                  d := WProgUse2.Images[HEALTHBAR_RED]
                else if g_NgConfigInfo.boBrightShowHp then
                  d := WProgUse2.Images[12]
                else
                  d := WProgUse2.Images[HEALTHBAR_RED];
              end;

              if d <> nil then begin
                rc := d.ClientRect;
                if actor.Abil.MaxHP > 0 then
                  rc.Right := _MIN(Round((rc.Right - rc.Left) / actor.Abil.MaxHP * actor.Abil.HP), d.Width);
                MSurface.Draw(actor.SayX - d.Width div 2, actor.SayY - 10, rc, d, TRUE);
              end;
            end;
            if g_boMirShowNumber then begin
              //数字显血
              if (actor = MySelf ) or (g_bo绝对泰山) then begin
                if ((actor.Abil.MaxHP > 1)) and not actor.Death then begin
                  infoMsg := IntToStr(actor.Abil.HP) + '/' + IntToStr(actor.Abil.MaxHP);
                  BoldTextOut(actor.SayX - {15}FontManager.Default.TextWidth(infoMsg)
                    div 2, actor.SayY - 23, clWhite, clBlack, infoMsg);
                end;
              end
              else begin
                if (actor.BoOpenStruckHealth) and not actor.Death then begin
                  if actor.BoOpenStruckHealth then
                    if GetTickCount - actor.OpenStruckStart > actor.OpenStruckTime then
                      actor.BoOpenStruckHealth := FALSE;

                  if ((actor.Abil.MaxHP > 1)) and not actor.Death then begin
                    infoMsg := IntToStr(actor.Abil.HP) + '/' + IntToStr(actor.Abil.MaxHP);
                    BoldTextOut(actor.SayX - {15}FontManager.Default.TextWidth(infoMsg)
                      div 2, actor.SayY - 23, clWhite, clBlack, infoMsg);
                  end;
                end;
              end;
            end;
          end;
        end;
*)
      end;

{
      if g_NgConfigInfo.boShowName then begin

        with PlayScene do begin
          for k := 0 to ActorList.Count - 1 do begin
            Actor := ActorList[k];


            if (Actor <> nil) and //
              (not Actor.Death) and //
              (Actor.SayX <> 0) and //
              (Actor.SayY <> 0) and //
              ((actor.Race = 0) or //
              (actor.Race = 1) or //
              (actor.Race = 12) or //
              (actor.Race = 50)) then
            begin
              if (Actor <> FocusCret) then
              begin
                if (actor = MySelf) and boSelectMyself then
                  Continue;
                uname := Actor.UserName;
                case actor.Race of
                  12, 50:
                    if g_boMirNg then
                      TempNameColor := clLime
                    else
                      //TempNameColor := Actor.NameColor;
                      TempNameColor := clLime;  //NPC不开内挂颜色
                else
                  TempNameColor := Actor.NameColor;
                end;

                NameTextOut(MSurface, Actor.SayX, // - Canvas.TextWidth(uname) div 2,
                  Actor.SayY + 30, TempNameColor, ClBlack, uname);
              end;
            end;
          end;

        end;
      end;
}

(*
         //画当前选择的物品/人物的名字
      if (FocusCret <> nil) and PlayScene.IsValidActor(FocusCret) then
      begin        if FocusCret.Race = 95 then
        begin
          if FocusCret.Death then
            FocusCret.UserName := '酒滚瘤'
          else
            FocusCret.UserName := '禁扁唱规';
        end
        else if FocusCret.Race = 96 then
          FocusCret.UserName := '';

        uname := FocusCret.DescUserName + '\' + FocusCret.UserName;
        if (FocusCret.Race = 50) and (FocusCret.Appearance = 57) then
          uname := '';
        case FocusCret.Race of
          12, 50:
            begin
              if g_boMirNg then
                TempNameColor := clLime
              else
                TempNameColor := clLime;   //NPC不开内挂颜色
            end
        else
         TempNameColor := FocusCret.NameColor;
        end;
        if FocusCret.Death then
        begin
          if not g_NgConfigInfo.boNotDeath then
            NameTextOut(MSurface, FocusCret.SayX, // - Canvas.TextWidth(uname) div 2,
              FocusCret.SayY + 30, TempNameColor, clBlack, uname);
        end
        else
        NameTextOut(MSurface, FocusCret.SayX, // - Canvas.TextWidth(uname) div 2,
          FocusCret.SayY + 30, TempNameColor, clBlack, uname);
      end;
      if BoSelectMyself then
      begin
        uname := Myself.DescUserName + '\' + Myself.UserName;  //你原来都有的  你都给改没了
         NameTextOut(MSurface, Myself.SayX, // - Canvas.TextWidth(uname) div 2,
          Myself.SayY + 30, Myself.NameColor, clBlack, uname);
      end;
*)
//         Canvas.Font.Color := clWhite;

{
         //显示角色说话文字
      with PlayScene do
      begin
        for k := 0 to ActorList.Count - 1 do
        begin
          actor := ActorList[k];
          if actor is THumActor then
            if THumActor(actor).m_StallMgr.OnSale then begin
              NameTextOut(MSurface, THumActor(actor).SayX, THumActor(actor).SayY
                - 36, GetRGB(94), clBlack, THumActor(actor).m_StallMgr.mBlock.StallName);
            end;
          if actor.Saying[0] <> '' then
          begin
            if GetTickCount - actor.SayTime < 4 * 1000 then
            begin
              for i := 0 to actor.SayLineCount - 1 do
                if actor.Death then
                           //控制玩家说话的颜色（头顶上的字体颜色）
                  BoldTextOut(actor.SayX - (actor.SayWidths[i] div 2), actor.SayY - (actor.SayLineCount * 16) + i * 14, clGray, clBlack, actor.Saying[i])
                else
                           //控制人物死亡后说话的颜色（头顶上的字体颜色
                  BoldTextOut(actor.SayX - (actor.SayWidths[i] div 2), actor.SayY - (actor.SayLineCount * 16) + i * 14, clWhite, clBlack, actor.Saying[i]);
            end
            else
              actor.Saying[0] := ''; //说的话显示4秒
          end;
        end;
      end;
}

         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(SendCount) + ' : ' + IntToStr(ReceiveCount));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'HITSPEED=' + IntToStr(Myself.HitSpeed));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, 'DupSel=' + IntToStr(DupSelection));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(LastHookKey));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack,
         //             IntToStr(
         //                int64(GetTickCount - LatestSpellTime) - int64(700 + MagicDelayTime)
         //                ));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack, IntToStr(PlayScene.EffectList.Count));
         //BoldTextOut (MSurface, 0, 0, clWhite, clBlack,
         //                  IntToStr(Myself.XX) + ',' + IntToStr(Myself.YY) + '  ' +
         //                  IntToStr(Myself.ShiftX) + ',' + IntToStr(Myself.ShiftY));

         //System Message
         //攻城区域(临时)
//      if (AreaStateValue and $04) <> 0 then
//      begin
//        g_boShowName := true;            // 进入攻城区域人物显名打开
//        MSurface.BoldTextOut(0, 0, clWhite, clBlack, '攻城区域');
//      end else begin
//        g_boShowName := false;          // 离开攻城区域人物显名关闭
//      end;
         if (AreaStateValue and $04) <> 0 then begin
            MSurface.BoldTextOut(0, 0, clWhite, clBlack, '攻城区域');
         end;
(*
              if g_boShowName then begin
          with PlayScene do begin
            for k := 0 to ActorList.Count - 1 do begin
              Actor := ActorList[k];
              if (Actor <> nil)  and (not Actor.Death) and
              //                (Actor.SayX <> 0) and (Actor.SayY <> 0) and ((actor.Race = 0) or (actor.Race = 1) or (actor.Race = 50)) then begin
//                (Actor.SayX <> 0) and (Actor.SayY <> 0) and (actor.Race = 50) then begin
                (Actor.SayX <> 0) and (Actor.SayY <> 0) and ((actor.Race = 12) or (actor.Race = 50)) then begin
                  if (Actor <> FocusCret) then begin

                    if (actor = MySelf) and boSelectMyself then Continue;
                        uname := Actor.UserName;

                      NameTextOut(MSurface,
                        Actor.SayX, // - Canvas.TextWidth(uname) div 2,
                        Actor.SayY + 30,
                        ClLime, ClBlack,   //Actor.NameColor, ClBlack,  //NPC名字颜色
                        uname);


                  end;



                end;
               // if (Actor <> nil) { and (not Actor.Death)}  and (Actor.SayX <> 0) and (Actor.SayY <> 0) and ((actor.Race = 0) or (actor.Race = 1)) then begin
                if (Actor <> nil)  and (not Actor.Death) and
                  (Actor.SayX <> 0) and (Actor.SayY <> 0) and ((actor.Race = 0) or (actor.Race = 1)) then begin
                  if (Actor <> FocusCret) then begin

                    if (actor = MySelf) and boSelectMyself then Continue;
                        uname := Actor.UserName;

                      NameTextOut(MSurface,
                        Actor.SayX, // - Canvas.TextWidth(uname) div 2,
                        Actor.SayY + 30,
                        Actor.NameColor, ClBlack,   //人物名字颜色
                        uname);


                  end;




                end;



            end;
          end;
        end; //with
*)
      //  Canvas.Relea

//         Canvas.Release;
      if (GroupMembers.Count > 0) and    g_bozuduihp  then
        PlayScene.DrawGroupHealthBar(MSurface);

         //显示地图状态
      k := 0;
      for i := 0 to 15 do
      begin
        if AreaStateValue and ($01 shr i) <> 0 then
        begin
          d := WProgUse.Images[AREASTATEICONBASE + i];
          if d <> nil then
          begin
            k := k + d.Width;
            MSurface.Draw(g_FScreenWidth - k, 0, d.ClientRect, d, TRUE);
          end;
        end;
      end;
      k := 0;
      for i := 0 to 15 do
      begin
        if AreaStateValue and ($02 shr i) <> 0 then
        begin
          d := WProgUse.Images[AREASTATEICOSAFE + i];
          if d <> nil then
          begin
            k := k + d.Width;
            MSurface.Draw(g_FScreenWidth - k, 0, d.ClientRect, d, TRUE);
          end;
        end;
      end;

    end;
  end;
  PlayScene.RenderMiniMap(MSurface);
end;
//显示左上角信息文字

procedure TDrawScreen.DrawScreenTop(MSurface: TAsphyreCanvas);
var
  i, sx, sy: integer;
  TempMsg: string;
begin
  if Myself = nil then
    exit;

  if CurrentScene = PlayScene then
  begin
    with MSurface do
    begin
       //  SetBkMode (Canvas.Handle, TRANSPARENT);
      if SysMsg.Count > 0 then
      begin
        sx := 30;
        sy := 40;
        for i := 0 to SysMsg.Count - 1 do
        begin
          if Copy(SysMsg[i], 1, 8) = 'clYellow' then
          begin
            TempMsg := Copy(SysMsg[i], 9, Length(SysMsg[i]) - 8);
            BoldTextOut (sx, sy, clYellow, clBlack, TempMsg);

          end
          else
            BoldTextOut (sx, sy, clGreen, clBlack, SysMsg[i]);
          inc(sy, 16);
        end;
        if GetTickCount - longword(SysMsg.Objects[0]) >= 3000 then
          SysMsg.Delete(0);
      end;
        // Canvas.Release;
    end;
      //绘制走马灯公告
    if BoShowScrollingBar then
    begin
      ScrollingText(MSurface, ScrollingBarText);
    end;
  end;
end;

//绘制走马灯公告
procedure TDrawScreen.ScrollingText(MSurface: TAsphyreCanvas; str: string);
var
  AText: TAsphyreLockableTexture;
  rc: TRect;
  w, nx, ntime, texttop, nFontSize: integer;
begin
  texttop := 6;
  AText := FontManager.GetFont(DefaultFontName, 11, [fsBold]).TextOut(str);
  nFontSize := 11;
  MSurface.FillRect(0, 0, g_FScreenWidth, 28, $96000000 or GetRGB(152));

  w := g_FScreenWidth;
  nx := 0;
  with MSurface do begin
    if ScrollingTextLeft > w then begin  //从右移到左边
      rc.Left := ScrollingTextLeft - w;
      if rc.Left > AText.Width then begin  //滚动完一圈

        ScrollingTextLeft := 0;
        rc.Left := 0;
        Inc(ScrollingBarTimes);
      end;
    end
    else begin
      rc.Left := 0;
      nx := w - ScrollingTextLeft;
    end;
    rc.Top := 0;
    rc.Right := ScrollingTextLeft;
    rc.Bottom := 18;

    if rc.Right > AText.Width then
      rc.Right := AText.Width + 5;
    if AText <> nil then
      RectText(nx, texttop, str, ScrollingFColor, ScrollingBColor, rc, [fsBold], nFontSize);
    ntime := 10;
  end;

  if GetTickCount - MoveTextTime > ntime then begin
    MoveTextTime := GetTickCount;
    Inc(ScrollingTextLeft, 1);
    if ntime > 1000 then Inc(ScrollingBarTimes);
  end;

  FrmMain.Canvas.Font.Size := 9;
  FrmMain.Canvas.Font.Style := [];

   //滚动次数限制
   if ScrollingBarTimes >= 1 then begin    //滚动公告的圈数
      BoShowScrollingBar := FALSE;
      ScrollingTextLeft := 0;
   end;
end;

//显示提示信息

procedure TDrawScreen.DrawHint(MSurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  i, hx, hy, old, TempL: integer;
  str, data, data2, Tempname: string;
  HITNTTRect: TRect;
  nColor: TColor;
begin
  if HintList.Count > 0 then
  begin
    d := WProgUse.Images[394];
    if d <> nil then
    begin
      if HintWidth > d.Width then
        HintWidth := d.Width;
      if HintHeight > d.Height then
        HintHeight := d.Height;
      if HintX + HintWidth > g_FScreenWidth then
        hx := g_FScreenWidth - HintWidth
      else
        hx := HintX;
      if HintY < 0 then
        hy := 0
      else
        hy := HintY;
      if hx < 0 then
        hx := 0;

      HITNTTRect.Left := 0;
      HITNTTRect.Top := 0;
      HITNTTRect.Right := HintWidth + 4; //到这里  86 + 4=90 
      HITNTTRect.Bottom := HintHeight;
      MSurface.DrawAlpha(hx, hy, HITNTTRect, d, 120);
    end;
  end;
  with MSurface do
  begin
    if HintList.Count > 0 then
    begin
      for i := 0 to HintList.Count - 1 do
      begin
        if FMagicHint then
        begin
          nColor := TColor(HintList.Objects[i]);
          case i of
            0: TextOut(hx + 4, hy + 3 + (FontManager.Default.TextHeight('A') + 2) * i, {HintColor}nColor, HintList[i]);
            else TextOut(hx + 4, hy + 3 + (FontManager.Default.TextHeight('A') + 2) * i, HintList[i], {HintColor}nColor);
          end;

        end else
        begin
          if Pos('$', HintList[i]) > 0 then
          begin
            TempL := 0;
            data := HintList[i];
            data := GetValidStr3(data, data2, ['$']);
            data2 := GetValidStr3(data2, Tempname, ['|']);
            nColor := StrToIntDef(data2, 0);
            TempL := FontManager.Default.TextWidth(Tempname);
            TextOut(hx + 4, hy + 3 + (FontManager.Default.TextHeight('A') + 2) * i, Tempname, nColor);
            data := GetValidStr3(data, Tempname, ['|']);
            nColor := StrToIntDef(data, 0);
            TextOut(hx + 4 + TempL, hy + 3 + (FontManager.Default.TextHeight('A') + 2) * i, Tempname, nColor);
          end
          else if Pos('|', HintList[i]) > 0 then
          begin
            data := HintList[i];
            data := GetValidStr3(data, Tempname, ['|']);
            nColor := StrToIntDef(data, 0);
            TextOut(hx + 4, hy + 3 + (FontManager.Default.TextHeight('A') + 2) * i, Tempname, nColor);
          end
          else
            TextOut(hx + 4, hy + 3 + (FontManager.Default.TextHeight('A') + 2) * i, HintList[i], HintColor); //这个东西是整体的   所有那种提示都是这一条输出   你改动这里所有的都会跟随这变动
        end;
      end;
    end;

    if Myself <> nil then
    begin
      TextOut(10, 0, clWhite, str);
    end;
  end;
end;

end.

