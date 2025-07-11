unit uGameEngine;

interface

uses
  Windows, Classes, SysUtils, AbstractTextures, Graphics, AbstractCanvas, StrUtils,
  AsphyreTypes, AsphyreConv, Vectors2px, AsphyreUtils, PngImage, Math, DIB, ZLib;

const
  TransparentBlendingEff: array [Boolean] of TBlendingEffect = (beNone, beNormal);
  DefaultFontName = '宋体';
  DefaultFontSize = 9;
  DefaultFontStyle = [];
  FontBorderColor = $00080808;

type
  PBGR = ^TBGR;
  TBGR = packed record
    B, G, R: Byte;
  end;
  TRGBA = packed record
    R: Byte;
    G: Byte;
    B: Byte;
    A: Byte;
  end;
  
  TARGB = packed record
    A: Byte;
    R: Byte;
    G: Byte;
    B: Byte;
  end;

  TReversalKind = (rkNone, rkHor, rkVer);
  TAsphyreCanvasHelper = class helper for TAsphyreCanvas
  public
    procedure Draw(SrcRect, DstRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor4; Effect: TBlendingEffect = beNormal; ReversalKind: TReversalKind = rkNone); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor4; Effect: TBlendingEffect = beNormal; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure Draw(X, Y: Integer; Texture: TAsphyreCustomTexture; Color: TColor4; Effect: TBlendingEffect = beNormal; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure Draw(X, Y: Integer; Texture: TAsphyreCustomTexture; Effect: TBlendingEffect; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure Draw(X, Y: Integer; Texture: TAsphyreCustomTexture; Transparent: Boolean = True; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure Draw(X, Y: Integer; SourceRect: TRect; Texture: TAsphyreCustomTexture; Transparent: Boolean = True; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure DrawColor(X, Y: Integer; Texture: TAsphyreCustomTexture; Color: TColor; Transparent: Boolean = True; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure DrawColor(X, Y: Integer; SrcRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor; Transparent: Boolean = True; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure DrawBlend(X, Y: Integer; Texture: TAsphyreCustomTexture;ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure DrawBlend(X, Y: Integer; Texture: TAsphyreCustomTexture; Blendmode: Integer; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure DrawBlend(X, Y: Integer; SrcRect: TRect;Texture: TAsphyreCustomTexture; Blendmode: Integer; ReversalKind: TReversalKind = rkNone); overload; inline;



    procedure DrawBlendEffect(X, Y: Integer; Texture: TAsphyreCustomTexture; Blendmode: Integer; ReversalKind: TReversalKind = rkNone); inline;
    procedure DrawBlendAdd(X, Y: Integer; Texture: TAsphyreCustomTexture; Blendmode, tNum: Integer; ReversalKind: TReversalKind = rkNone); inline;
    procedure DrawAlpha(X, Y: Integer; Texture: TAsphyreCustomTexture; Alpha: Byte; Effect: TBlendingEffect = beNormal; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure DrawAlpha(X, Y: Integer; SrcRect: TRect; Texture: TAsphyreCustomTexture; Alpha: Byte; Effect: TBlendingEffect = beNormal; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure FillRectAlpha(const DestRect: TRect; Color: TColor; Alpha: Integer); inline;
    procedure DrawColorAlpha(const X, Y: Integer; Texture: TAsphyreCustomTexture; Color: TColor; Transparent: Boolean; Alpha: Integer; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure DrawColorAlpha(const X, Y: Integer; SrcRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor; Transparent: Boolean; Alpha: Integer; ReversalKind: TReversalKind = rkNone); overload; inline;
    procedure DrawInRect(const X, Y: Integer; DstRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor4; Effect: TBlendingEffect = beNormal; ReversalKind: TReversalKind = rkNone); overload;
    procedure HorFillDraw(const X1, X2, Y: Integer; Source: TAsphyreCustomTexture; const Transparent: Boolean = True);
    procedure VerFillDraw(const X, Y1, Y2: Integer; Source: TAsphyreCustomTexture; const Transparent: Boolean = True);



     procedure StretchDraw(const DestRect, SrcRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor4;Transparent: Boolean = True); overload;
     procedure StretchDraw(const DestRect: TRect; Texture: TAsphyreCustomTexture;Transparent: Boolean = True; Alpha: Integer = 255); overload;

    procedure RectText(X, Y: Integer; const Text: String; FColor, BColor: TColor; DstRect: TRect; FontStyles: TFontStyles; FontSize: Integer; Transparent: Boolean = True);

    procedure BoldText(X, Y: Integer; const Text: String; FontColor, BgColor: TColor); overload;
    procedure BoldText(const Text: String; FontColor, BgColor: TColor; FontStyles: TFontStyles; X, Y: Integer); overload;
    procedure BoldText(const Text: String; FontColor, BgColor: TColor; X, Y: Integer); overload;
    procedure BoldTextOut(X, Y: Integer; const Text: String; FontColor, BgColor: TColor); overload;
    procedure BoldTextOut(X, Y: Integer;  FontColor, BgColor: TColor;Text: String); overload;
    procedure BoldTextOut(const Text: String; FontColor, BgColor: TColor; FontStyles: TFontStyles; X, Y: Integer); overload;
    procedure BoldTextOut(const Text: String; FontColor, BgColor: TColor; X, Y: Integer); overload;
    procedure BoldTextOut(X, Y: Integer;const Text: String; FontColor, BgColor: TColor; FontStyles: TFontStyles;FontSize: Integer); overload;
    procedure BoldTextOut(X, Y: Integer;const Text: String; FontColor, BgColor: TColor; FontStyles: TFontStyles;FontSize: Integer;FontName: String); overload;
    procedure BoldTextOutZ( X, Y, Z, fcolor, bcolor: Integer; Str: string);

    procedure TextOut(X, Y: Integer; const Text: String; FontColor: TColor=clWhite; Effect: TBlendingEffect = beNormal); overload;
    procedure TextOut(X, Y: Integer; const FontColor: TColor;Text: String; Effect: TBlendingEffect = beNormal); overload;
    procedure TextOut(const Text: String; FontColor: TColor; X, Y: Integer; Effect: TBlendingEffect = beNormal); overload;
    procedure DrawBoldText(X, Y: Integer; Text: TAsphyreCustomTexture; FontColor, BgColor: TColor; Transparent: Boolean = True); overload; inline;
    procedure DrawOutLineTextInRect(X, Y: Integer; DstRect:TRect; Text: TAsphyreCustomTexture; FontColor, BgColor: TColor; OutLinePixel : Integer = 1;  Transparent: Boolean = true);{$IFNDEF DEBUG}inline; {$ENDIF}
    procedure DrawOutLineText(X, Y: Integer; Text: TAsphyreCustomTexture; FontColor, BgColor: TColor; OutLinePixel : Integer = 1; Transparent: Boolean = True); {$IFNDEF DEBUG}inline; {$ENDIF}
    procedure DrawBoldTextInRect(X, Y: Integer; DstRect: TRect; Text: TAsphyreCustomTexture; FontColor, BgColor: TColor; Effect: TBlendingEffect = beNormal); inline;
    procedure DrawText(X, Y: Integer; Text: TAsphyreCustomTexture; FontColor: TColor; Transparent: Boolean = True); inline;
    procedure DrawTextInRect(X, Y: Integer; DstRect: TRect; Text: TAsphyreCustomTexture; FontColor: TColor; Effect: TBlendingEffect = beNormal); inline;
    procedure PixelsOut(X, Y: Integer; Color: TColor; Size: Integer);
    procedure FrameRect(ARect: TRect; Color: TColor); overload;
    procedure FillRect(ARect: TRect; Color: TColor); overload;
    procedure Line(X1, Y1, X2, Y2: Integer; LineColor: TColor); overload;
    procedure TextRect(BRect: TRect;  nX, nY: Integer;Text: WideString; FColor: Cardinal;BColor: Cardinal; TextFormat: TTextFormat = []);
  end;

  TAsphyreCustomTextureHelper = class helper for TAsphyreCustomTexture
  public
    function ClientRect: TRect; inline;
    procedure SetSize(W, H: Integer; AutoInitialize: Boolean = False); inline;
  end;

  TAsphyreLockableTextureHelper = class helper for TAsphyreLockableTexture
  public
    function ClientRect: TRect; inline;
    procedure SetSize(W, H: Integer; AutoInitialize: Boolean = False); inline;
    function LoadFromFontData(AData: Pointer; ADataSize: LongWord; AWidth, AHeight: Integer): Boolean;
    function LoadFromDataEx(ABuffer: Pointer; ADataSize: LongWord; ABitCount: Byte; AWidth, AHeight: Integer; MirrorX, MirrorY: Boolean): Boolean;
    function LoadAlphaFromDataEx(ABuffer: Pointer; ADataSize: LongWord; AWidth, AHeight: Integer): Boolean;
    function LoadFromPng32Data(ABuffer: Pointer; ADataSize: LongWord; ABitCount: Byte; AWidth, AHeight: Integer): Boolean;
    function LoadFromPng(PNG:TPngImage):Boolean;
    procedure ResetAlpha;
    procedure Fill(Color: TColor);
    procedure FillRect(ARect: TRect; Color: TColor);
    procedure Draw(X, Y: Integer; Source: TAsphyreLockableTexture; Transparent: Boolean = True); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TAsphyreLockableTexture; Transparent: Boolean = True); overload;
    procedure Draw(SrcRect, DstRect: TRect; Source: TAsphyreLockableTexture; Transparent: Boolean = True); overload;
    procedure HorFillDraw(const X1, X2, Y: Integer; Source: TAsphyreLockableTexture; const Transparent: Boolean = True);
    procedure VerFillDraw(const X, Y1, Y2: Integer; Source: TAsphyreLockableTexture; const Transparent: Boolean = True);
    procedure CopyFrom(Source : TAsphyreLockableTexture);
  end;

function dxColorToAlphaColor(AColor: TColor; Alpha: Byte): Cardinal;
function NotColor(Source: TColor): TColor; inline;
function cColor1(Color: TColor): Cardinal; inline;
procedure WidthBytes(AWidth, ABitCount: Integer; var APicth: Integer); inline;
function DisplaceRB(Color: Cardinal): Cardinal;
function GetRGB(c256: BYTE): Integer;
function MakeNewGUID38: String;
function MakeNewGUID36: String;
function MakeNewGUID32: String;
function MakeNewGUID16: String;
procedure FreeAndNilEx(var Obj);
procedure FreeAndNilSafe( var Obj);
procedure CompressBufZ(const InBuf: PAnsiChar; InBytes: Integer;  out OutBuf: PAnsiChar; out OutBytes: Integer);
procedure DecompressBufZ(const inBuffer: PAnsiChar; inSize: Integer; outEstimate: Integer; out outBuffer: PAnsiChar; out outSize: Integer);

var
  Bit8MainPalette: TRGBQuads;
  ColorTable_565: array[0..255] of Word;
  ColorTable_R5G6B5_32: array[0..65535] of Cardinal;
  ColorTable_A1R5G5B5: array[0..65535] of Word;
  ColorPalette: array[0..255] of Cardinal;

implementation

uses
  AsphyreTextureFonts;


function NotColor(Source: TColor): TColor;
begin
  Result := $FFFFFF - ColorToRGB(Source);
end;

function DisplaceRB(Color: Cardinal): Cardinal;
asm
  mov ecx, eax
  mov edx, eax
  and eax, 0FF00FF00h
  and edx, 0000000FFh
  shl edx, 16
  or eax, edx
  mov edx, ecx
  shr edx, 16
  and edx, 0000000FFh
  or eax, edx
end;

function dxColorToAlphaColor(AColor: TColor; Alpha: Byte): Cardinal;

  function _ColorToRGBQuad(AColor: TColor; AReserved: Byte): TRGBQuad;
  var
    ATemp: TRGBA;
  begin
    DWORD(ATemp) := ColorToRGB(AColor);
    Result.rgbBlue := ATemp.B;
    Result.rgbRed := ATemp.R;
    Result.rgbGreen := ATemp.G;
    Result.rgbReserved := AReserved;
  end;

begin
  if AColor = Graphics.clNone then
    Result := $00000000
  else
    if AColor = Graphics.clDefault then
      Result := $00010203
    else
      Result := Cardinal(_ColorToRGBQuad(AColor, Alpha));
end;

function cColor1(Color: TColor): Cardinal;
begin
  Result := dxColorToAlphaColor(Color, 255);
  //Result := DisplaceRB(Color) or $FF000000;
end;

procedure WidthBytes(AWidth, ABitCount: Integer; var APicth: Integer);
begin
  APicth := (((AWidth * ABitCount) + 31) and not 31) div 8;
end;

{ TAsphyreCanvasHelper }

procedure TAsphyreCanvasHelper.FrameRect(ARect: TRect;Color: TColor);
begin
  FrameRect(ARect, cColor4(cColor1(Color)));
end;

procedure TAsphyreCanvasHelper.FillRect(ARect: TRect; Color: TColor);
begin
  FillRect(ARect, cColor1(Color));
end;

procedure TAsphyreCanvasHelper.FillRectAlpha(const DestRect: TRect; Color: TColor; Alpha: Integer);
begin
  FillQuad(pRect4(DestRect), cColorAlpha4(cColor1(Color), Alpha), beNormal);
end;

procedure TAsphyreCanvasHelper.Draw(X, Y: Integer; Texture: TAsphyreCustomTexture; Transparent: Boolean; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, Texture.ClientRect, Texture, clWhite4, TransparentBlendingEff[Transparent], ReversalKind);
end;

function ClipRect2(var DestRect, SrcRect: TRect; const DestRect2, SrcRect2: TRect): Boolean;
begin
  if DestRect.Left < DestRect2.Left then
  begin
    SrcRect.Left := SrcRect.Left + (DestRect2.Left - DestRect.Left);
    DestRect.Left := DestRect2.Left;
  end;

  if DestRect.Top < DestRect2.Top then
  begin
    SrcRect.Top := SrcRect.Top + (DestRect2.Top - DestRect.Top);
    DestRect.Top := DestRect2.Top;
  end;

  if SrcRect.Left < SrcRect2.Left then
  begin
    DestRect.Left := DestRect.Left + (SrcRect2.Left - SrcRect.Left);
    SrcRect.Left := SrcRect2.Left;
  end;

  if SrcRect.Top < SrcRect2.Top then
  begin
    DestRect.Top := DestRect.Top + (SrcRect2.Top - SrcRect.Top);
    SrcRect.Top := SrcRect2.Top;
  end;

  if DestRect.Right > DestRect2.Right then
  begin
    SrcRect.Right := SrcRect.Right - (DestRect.Right - DestRect2.Right);
    DestRect.Right := DestRect2.Right;
  end;

  if DestRect.Bottom > DestRect2.Bottom then
  begin
    SrcRect.Bottom := SrcRect.Bottom - (DestRect.Bottom - DestRect2.Bottom);
    DestRect.Bottom := DestRect2.Bottom;
  end;

  if SrcRect.Right > SrcRect2.Right then
  begin
    DestRect.Right := DestRect.Right - (SrcRect.Right - SrcRect2.Right);
    SrcRect.Right := SrcRect2.Right;
  end;

  if SrcRect.Bottom > SrcRect2.Bottom then
  begin
    DestRect.Bottom := DestRect.Bottom - (SrcRect.Bottom - SrcRect2.Bottom);
    SrcRect.Bottom := SrcRect2.Bottom;
  end;

  Result := (DestRect.Left < DestRect.Right) and (DestRect.Top < DestRect.Bottom) and (SrcRect.Left < SrcRect.Right) and (SrcRect.Top < SrcRect.Bottom);
end;

procedure TAsphyreCanvasHelper.Draw(X, Y: Integer; SourceRect: TRect; Texture: TAsphyreCustomTexture; Transparent: Boolean; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, SourceRect, Texture, clWhite4, TransparentBlendingEff[Transparent], ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawAlpha(X, Y: Integer; Texture: TAsphyreCustomTexture; Alpha: Byte; Effect: TBlendingEffect; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, Texture.ClientRect, Texture, cAlpha4(Alpha), Effect, ReversalKind);
end;

procedure TAsphyreCanvasHelper.Draw(X, Y: Integer; Texture: TAsphyreCustomTexture; Effect: TBlendingEffect; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, Texture.ClientRect, Texture, clWhite4, Effect, ReversalKind);
end;

procedure TAsphyreCanvasHelper.Draw(X, Y: Integer; Texture: TAsphyreCustomTexture; Color: TColor4; Effect: TBlendingEffect; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, Texture.ClientRect, Texture, Color, Effect, ReversalKind);
end;

procedure TAsphyreCanvasHelper.Draw(X, Y: Integer; SrcRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor4; Effect: TBlendingEffect; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(SrcRect, Bounds(X, Y, SrcRect.Right - SrcRect.Left, SrcRect.Bottom - SrcRect.Top), Texture, Color, Effect, ReversalKind);
end;

procedure TAsphyreCanvasHelper.Draw(SrcRect, DstRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor4; Effect: TBlendingEffect; ReversalKind: TReversalKind);
var
  Mapping: TPoint4;
  Dest: TPoint2px;
  VisibleSize: TPoint2px;
  ViewPos, ViewSize: TPoint2px;
begin
  if Texture = nil then Exit;
  if (DstRect.Left > ClipRect.Right) or (DstRect.Top > ClipRect.Bottom) then Exit;

  if ClipRect2(DstRect, SrcRect, ClipRect, Texture.ClientRect) then
  begin
    ViewSize.X := SrcRect.Right - SrcRect.Left;
    ViewSize.Y := SrcRect.Bottom - SrcRect.Top;

    ViewPos.X := SrcRect.Left;
    ViewPos.Y := SrcRect.Top;

    VisibleSize.X := Texture.Width;
    VisibleSize.Y := Texture.Height;

    Dest.X := ViewPos.X + Min2(ViewSize.X, VisibleSize.X);
    Dest.Y := ViewPos.Y + Min2(ViewSize.Y, VisibleSize.Y);

    case ReversalKind of
      rkNone:
      begin
        Mapping[0].X := ViewPos.X / Texture.Width;
        Mapping[0].Y := ViewPos.Y / Texture.Height;

        Mapping[1].X := Dest.X / Texture.Width;
        Mapping[1].Y := Mapping[0].Y;

        Mapping[2].X := Mapping[1].X;
        Mapping[2].Y := Dest.Y / Texture.Height;

        Mapping[3].X := Mapping[0].X;
        Mapping[3].Y := Mapping[2].Y;
      end;
      rkHor:
      begin
        Mapping[1].X := ViewPos.X / Texture.Width;
        Mapping[1].Y := ViewPos.Y / Texture.Height;

        Mapping[0].X := Dest.X / Texture.Width;
        Mapping[0].Y := Mapping[1].Y;

        Mapping[3].X := Mapping[0].X;
        Mapping[3].Y := Dest.Y / Texture.Height;

        Mapping[2].X := Mapping[1].X;
        Mapping[2].Y := Mapping[3].Y;
      end;
      rkVer:
      begin
        Mapping[2].X := ViewPos.X / Texture.Width;
        Mapping[2].Y := ViewPos.Y / Texture.Height;

        Mapping[3].X := Dest.X / Texture.Width;
        Mapping[3].Y := Mapping[2].Y;

        Mapping[0].X := Mapping[3].X;
        Mapping[0].Y := Dest.Y / Texture.Height;

        Mapping[1].X := Mapping[2].X;
        Mapping[1].Y := Mapping[0].Y;
      end;
    end;
    if Texture.ISPNGTexture and (Effect = TBlendingEffect.beBlend)  then
      Effect := TBlendingEffect.beNormal;


    UseTexture(Texture, Mapping);
    TexMap(pRect4(DstRect), Color, Effect);
  end;
end;

procedure TAsphyreCanvasHelper.DrawAlpha(X, Y: Integer; SrcRect: TRect; Texture: TAsphyreCustomTexture; Alpha: Byte; Effect: TBlendingEffect; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, SrcRect, Texture, cAlpha4(Alpha), Effect, ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawBlend(X, Y: Integer; Texture: TAsphyreCustomTexture;ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, Texture.ClientRect, Texture, cColor4(cRGB1(128, 128, 128, 255)), TBlendingEffect.beBlend, ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawBlend(X, Y: Integer; Texture: TAsphyreCustomTexture; Blendmode: Integer; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, Texture.ClientRect, Texture, clWhite4, TBlendingEffect.beBlend, ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawBlend(X, Y: Integer;  SrcRect: TRect;Texture: TAsphyreCustomTexture; Blendmode: Integer; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, SrcRect, Texture, clWhite4, TBlendingEffect.beBlend, ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawBlendAdd(X, Y: Integer; Texture: TAsphyreCustomTexture; Blendmode, tNum: Integer; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, Texture.ClientRect, Texture, clWhite4, beSrcColorAdd, ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawBlendEffect(X, Y: Integer;
  Texture: TAsphyreCustomTexture; Blendmode: Integer;
  ReversalKind: TReversalKind);
var
 E : TBlendingEffect;
begin
  if Texture = nil then Exit;
  if Blendmode in [Ord(TBlendingEffect.beNone) .. Ord(TBlendingEffect.beBright)] then
    E:= TBlendingEffect(Blendmode)
  else
    E:= TBlendingEffect.beBlend;

  Draw(X, Y, Texture.ClientRect, Texture, clWhite4, E, ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawColor(X, Y: Integer; Texture: TAsphyreCustomTexture; Color: TColor; Transparent: Boolean; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, Texture.ClientRect, Texture, cColor4(cColor1(Color)), TransparentBlendingEff[Transparent], ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawColor(X, Y: Integer; SrcRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor; Transparent: Boolean; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, SrcRect, Texture, cColor4(cColor1(Color)), TransparentBlendingEff[Transparent], ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawColorAlpha(const X, Y: Integer; Texture: TAsphyreCustomTexture; Color: TColor; Transparent: Boolean; Alpha: Integer; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, Texture.ClientRect, Texture, cColorAlpha4(cColor1(Color), Alpha), TransparentBlendingEff[Transparent], ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawColorAlpha(const X, Y: Integer; SrcRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor; Transparent: Boolean; Alpha: Integer; ReversalKind: TReversalKind);
begin
  if Texture = nil then Exit;
  Draw(X, Y, SrcRect, Texture, cColorAlpha4(cColor1(Color), Alpha), TransparentBlendingEff[Transparent], ReversalKind);
end;

procedure TAsphyreCanvasHelper.DrawInRect(const X, Y: Integer; DstRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor4; Effect: TBlendingEffect; ReversalKind: TReversalKind);
var
  SrcRect: TRect;
begin
  SrcRect := Bounds(X, Y, Texture.Width, Texture.Height);
  DstRect := ShortRect(SrcRect, DstRect);
  SrcRect := Bounds(DstRect.Left - X, DstRect.Top - Y, DstRect.Right - DstRect.Left, DstRect.Bottom - DstRect.Top);
  Draw(SrcRect, DstRect, Texture, Color, Effect, ReversalKind);
end;

procedure TAsphyreCanvasHelper.HorFillDraw(const X1, X2, Y: Integer; Source: TAsphyreCustomTexture; const Transparent: Boolean);
var
  W, I: Integer;
begin
  if Source = nil then Exit;

  if (ABS(X2-X1) < Source.Width) then
  begin
    Draw(Source.ClientRect, Rect(X1, Y, X2, Y), Source, clWhite4);
    Exit;
  end;

  W := Source.Width;
  I := 0;
  while True do
  begin
    Draw(X1 + I * W, Y, Source, Transparent);
    Inc(I);
    if X1 + I * W + W> X2 then
    begin
      if X1 < X2 then
        Draw(X2 - W, Y, Source, Transparent);;
      Break;
    end;
  end;
end;

procedure TAsphyreCanvasHelper.Line(X1, Y1, X2, Y2: Integer; LineColor: TColor);
begin
  Line(X1, Y1, X2, Y2, cColor1(LineColor));
end;

procedure TAsphyreCanvasHelper.TextRect(BRect: TRect; nX, nY: Integer;
  Text: WideString; FColor, BColor: Cardinal; TextFormat: TTextFormat);
var
  Texture: TAsphyreCustomTexture;
  AsciiRect: TRect;
  nWidth, nHeight, FontWidth: Integer;
  x, y, w, h: Integer;
begin
  x := 0;
  y := 0;
  w := 0;
  h := 0;
  if Text = '' then exit;
  FontWidth := 0;
  nWidth := BRect.Right - BRect.Left;
  nHeight := BRect.Bottom - BRect.Top;
  if (nWidth <= 0) or (nHeight <= 0) then exit;
//  nY := (nHeight - FontManager.Default.TextHeight('中')) div 2;
  if nY < 0 then nY := 0;
  if tfRight in TextFormat then begin
//    nX := BRect.Right;
    Texture := FontManager.Default.TextOut(Text);
    if Texture <> nil then   begin
      AsciiRect := Texture.ClientRect;
      if (AsciiRect.Right > 4) then begin
        x := AsciiRect.Left;
        y := AsciiRect.Top;
        w := AsciiRect.Right - AsciiRect.Left;
        h := AsciiRect.Bottom - AsciiRect.Top;
        if (nY + h) > nHeight then begin
          h := nHeight - nY;
          if h <= 0 then h := h;
        end;
        if (FontWidth + w) > nWidth then begin
          x := x + (w) - (nWidth - FontWidth);
          w := nWidth - FontWidth;
        end;
      end;
      if Text <> '' then
//      FillRect(nX - FontWidth - w, nY + BRect.Top, w,h, (cColor1(BColor)));
      DrawInRect(nX - FontWidth - w, nY + BRect.Top, Rect( x, y, w + x, y + h) , Texture , cColor4(cColor1(FColor)), TBlendingEffect.beNormal);
    end;
  end
  else if tfCenter in TextFormat then begin
//     nX := BRect.Right;
    Texture := FontManager.Default.TextOut(Text);
    if Texture <> nil then   begin
      AsciiRect := Texture.ClientRect;
      if (AsciiRect.Right > 4) then begin
        x := AsciiRect.Left;
        y := AsciiRect.Top;
        w := AsciiRect.Right - AsciiRect.Left;
        h := AsciiRect.Bottom - AsciiRect.Top;
        if (nY + h) > nHeight then begin
          h := nHeight - nY;
          if h <= 0 then h := h;
        end;
        if (FontWidth + w) > nWidth then begin
          x := x + (w) - (nWidth - FontWidth);
          w := nWidth - FontWidth;
        end;
      end;
      Draw(nX - FontWidth - w, nY + BRect.Top, Rect( x, y, w + x, y + h) , Texture , cColor4(cColor1(FColor)), TBlendingEffect.beNormal);
    end;
  end
  else begin
//    nX := BRect.Left;
    Texture := FontManager.Default.TextOut(Text);
    if Texture <> nil then   begin
      AsciiRect := Texture.ClientRect;
      if (AsciiRect.Right > 4) then begin
        x := AsciiRect.Left;
        y := AsciiRect.Top;
        w := AsciiRect.Right - AsciiRect.Left;
        h := AsciiRect.Bottom - AsciiRect.Top;
        if (nY + h) > nHeight then begin
          h := nHeight - nY;
          if h <= 0 then h := h;
        end;
        if (FontWidth + w) > nWidth then begin
          w := nWidth - FontWidth;
        end;
      end;
      if Text <> '' then
//      FillRect(nX + FontWidth, nY + BRect.Top, w,h, (cColor1(BColor)));
      Draw(nX + FontWidth, nY + BRect.Top, Rect(x, y, w + x, y + h) , Texture , cColor4(cColor1(FColor)), TBlendingEffect.beNormal);
    end;
  end;
end;
procedure TAsphyreCanvasHelper.PixelsOut(X, Y: Integer; Color: TColor;
  Size: Integer);
begin
  FillRect(Bounds(X, Y, Size, Size), cColor4(cColor1(Color)));
end;

procedure TAsphyreCanvasHelper.StretchDraw(const DestRect, SrcRect: TRect; Texture: TAsphyreCustomTexture; Color: TColor4;
  Transparent: Boolean);
var
  Mapping: TPoint4;
  Source: TPoint2px;
  Dest: TPoint2px;
  VisibleSize: TPoint2px;
  ViewPos, ViewSize: TPoint2px;
  Effect: TBlendingEffect;
begin
  if Transparent then
    Effect := beNormal
  else
    Effect := beUnknown;

  ViewSize.x := DestRect.Right - DestRect.Left;
  ViewSize.y := DestRect.Bottom - DestRect.Top;
  ViewPos.x := SrcRect.Left;
  ViewPos.y := SrcRect.Top;

  VisibleSize.x := Texture.Width;
  VisibleSize.y := Texture.Height;

  Source.x := ViewPos.x;
  Source.y := ViewPos.y;
  Dest.x := Source.x + VisibleSize.x;
  Dest.y := Source.y + VisibleSize.y;

  Mapping[0].x := Source.x / Texture.Width;
  Mapping[0].y := Source.y / Texture.Height;

  Mapping[1].x := Dest.x / Texture.Width;
  Mapping[1].y := Mapping[0].y;

  Mapping[2].x := Mapping[1].x;
  Mapping[2].y := Dest.y / Texture.Height;

  Mapping[3].x := Mapping[0].x;
  Mapping[3].y := Mapping[2].y;

  UseTexture(Texture, Mapping);
  TexMap(pBounds4(DestRect.Left, DestRect.Top, ViewSize.x, ViewSize.y), Color, Effect);
  //end;
end;

procedure TAsphyreCanvasHelper.StretchDraw(const DestRect: TRect; Texture: TAsphyreCustomTexture;
  Transparent: Boolean; Alpha :Integer);
begin
  StretchDraw(DestRect, Texture.ClientRect, Texture, cAlpha4(Alpha), Transparent);
end;

procedure TAsphyreCanvasHelper.RectText(X, Y: Integer; const Text: String; FColor, BColor: TColor; DstRect: TRect; FontStyles: TFontStyles; FontSize: Integer; Transparent: Boolean = True);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.GetFont(DefaultFontName, FontSize, FontStyles).TextOut(Text);
  if AText <> nil then begin
    DrawColor(X - 1, Y, DstRect, AText, BColor, Transparent);
    DrawColor(X + 1, Y, DstRect, AText, BColor, Transparent);
    DrawColor(X, Y - 1, DstRect, AText, BColor, Transparent);
    DrawColor(X, Y + 1, DstRect, AText, BColor, Transparent);
    DrawColor(X, Y, DstRect, AText, FColor, Transparent);
  end;
end;

procedure TAsphyreCanvasHelper.VerFillDraw(const X, Y1, Y2: Integer; Source: TAsphyreCustomTexture; const Transparent: Boolean);
var
  H, I: Integer;
begin
  if Source = nil then Exit;

  if (ABS(Y2 - Y1) < Source.Height) then
  begin
    Draw(Source.ClientRect, Rect(X, Y1, X, Y2), Source, clWhite4);
    Exit;
  end;

  H := Source.Height;
  I := 0;
  while True do
  begin
    Draw(X, Y1 + I * H, Source, Transparent);
    Inc(I);
    if Y1 + I * H + H > Y2 then
    begin
      if Y1 < Y2 then
        Draw(X, Y2 - H, Source, Transparent);
      Break;
    end;
  end;
end;

procedure TAsphyreCanvasHelper.TextOut(X, Y: Integer; const Text: String; FontColor: TColor; Effect: TBlendingEffect);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.Default.TextOut(Text);
  if AText <> nil then
    Draw(X, Y, AText.ClientRect, AText, cColor4(cColor1(FontColor)), Effect);
end;
procedure TAsphyreCanvasHelper.TextOut(X, Y: Integer; const FontColor: TColor; Text: String; Effect: TBlendingEffect);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.Default.TextOut(Text);
  if AText <> nil then
    Draw(X, Y, AText.ClientRect, AText, cColor4(cColor1(FontColor)), Effect);
end;
procedure TAsphyreCanvasHelper.TextOut(const Text: String; FontColor: TColor; X, Y: Integer; Effect: TBlendingEffect);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.Default.TextOut(Text);
  if AText <> nil then
    Draw(X, Y, AText.ClientRect, AText, cColor4(cColor1(FontColor)), Effect);
end;



procedure TAsphyreCanvasHelper.BoldText(X, Y: Integer; const Text: String; FontColor, BgColor: TColor);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.Default.TextOut(Text);
  if AText <> nil then
    DrawBoldText(X, Y, AText, FontColor, BgColor);
end;

procedure TAsphyreCanvasHelper.BoldText(const Text: String; FontColor, BgColor: TColor; FontStyles: TFontStyles; X, Y: Integer);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.GetFont(DefaultFontName, DefaultFontSize, FontStyles).TextOut(Text);
  if AText <> nil then
    DrawBoldText(X, Y, AText, FontColor, BgColor);
end;

procedure TAsphyreCanvasHelper.BoldText(const Text: String; FontColor, BgColor: TColor; X, Y: Integer);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.Default.TextOut(Text);
  if AText <> nil then
    DrawBoldText(X, Y, AText, FontColor, BgColor);
end;

procedure TAsphyreCanvasHelper.BoldTextOut(X, Y: Integer; const Text: String;
  FontColor, BgColor: TColor);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.Default.TextOut(Text);
  if AText <> nil then
    DrawBoldText(X, Y, AText, FontColor, BgColor);
end;

procedure TAsphyreCanvasHelper.BoldTextOut(X, Y: Integer;  FontColor, BgColor: TColor;Text: String);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.Default.TextOut(Text);
  if AText <> nil then
    DrawBoldText(X, Y, AText, FontColor, BgColor);
end;

procedure TAsphyreCanvasHelper.BoldTextOut(const Text: String; FontColor,
  BgColor: TColor; FontStyles: TFontStyles; X, Y: Integer);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.GetFont(DefaultFontName, DefaultFontSize, FontStyles).TextOut(Text);
  if AText <> nil then
    DrawBoldText(X, Y, AText, FontColor, BgColor);
end;
procedure TAsphyreCanvasHelper.BoldTextOut(X, Y: Integer;const Text: String; FontColor, BgColor: TColor; FontStyles: TFontStyles;FontSize: Integer);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.GetFont(DefaultFontName, FontSize, FontStyles).TextOut(Text);
  if AText <> nil then
    DrawBoldText(X, Y, AText, FontColor, BgColor);
end;
procedure TAsphyreCanvasHelper.BoldTextOut(X, Y: Integer;const Text: String; FontColor, BgColor: TColor; FontStyles: TFontStyles;FontSize: Integer;FontName: String);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.GetFont(FontName, FontSize, FontStyles).TextOut(Text);
  if AText <> nil then
    DrawBoldText(X, Y, AText, FontColor, BgColor);
end;

//增加鉴宝文字绘制
procedure TAsphyreCanvasHelper.BoldTextOutZ(X, Y, Z, fcolor, bcolor: Integer;Str: string);
var
  tStr, temp        : string;
  i, Len, n, aline  : Integer;
label
  Loop1;
begin
  tStr := Str;
  n := 0;
  if tStr <> '' then begin
    Loop1:
    Len := Length(tStr);
    temp := '';
    i := 1;
    while True do begin
      if i > Len then Break;

      if Byte(tStr[i]) >= 128 then begin
        temp := temp + tStr[i];
        Inc(i);
        if i <= Len then
          temp := temp + tStr[i]
        else
          Break;
      end else
        temp := temp + tStr[i];
      //clGray

      if (temp <> '') and (tStr[i] = #$0D) and ((i + 1 <= Len) and (tStr[i + 1] = #$0A)) then begin
        BoldTextOut( X, Y + n * 14, fcolor, bcolor, temp);
        tStr := Copy(tStr, i + 1 + 1, Len - i - 1);
        if tStr <> '' then Inc(n);
        temp := '';
        Break;
      end;

      aline := FontManager.Default.TextWidth(temp);
      if (aline > Z) and (temp <> '') then begin
        BoldTextOut( X, Y + n * 14, fcolor,bcolor,  temp);
        tStr := Copy(tStr, i + 1, Len - i);
        if tStr <> '' then Inc(n);
        temp := '';
        Break;
      end;
      Inc(i);
    end;
    if temp <> '' then begin
      BoldTextOut( X, Y + n * 14, fcolor,bcolor, temp);
      tStr := '';
    end;
    if tStr <> '' then
      goto Loop1;
  end;
end;

procedure TAsphyreCanvasHelper.BoldTextOut(const Text: String; FontColor,
  BgColor: TColor; X, Y: Integer);
var
  AText: TAsphyreCustomTexture;
begin
  AText := FontManager.Default.TextOut(Text);
  if AText <> nil then
    DrawBoldText(X, Y, AText, FontColor, BgColor);
end;

procedure TAsphyreCanvasHelper.DrawBoldText(X, Y: Integer; Text: TAsphyreCustomTexture; FontColor, BgColor: TColor; Transparent: Boolean);
begin
  DrawColor(X - 1, Y, Text, BgColor, Transparent);
  DrawColor(X + 1, Y, Text, BgColor, Transparent);
  DrawColor(X, Y - 1, Text, BgColor, Transparent);
  DrawColor(X, Y + 1, Text, BgColor, Transparent);
  DrawColor(X, Y, Text, FontColor, Transparent);
end;

procedure TAsphyreCanvasHelper.DrawOutLineText(X, Y: Integer; Text: TAsphyreCustomTexture; FontColor, BgColor: TColor; OutLinePixel : Integer;  Transparent: Boolean);
var
  I : Integer;
begin

  for i := 1 to OutLinePixel do
  begin
    DrawColor(X - i, Y, Text, BgColor, Transparent);
    DrawColor(X + i, Y, Text, BgColor, Transparent);
    DrawColor(X, Y - i, Text, BgColor, Transparent);
    DrawColor(X, Y + i, Text, BgColor, Transparent);
  end;

  DrawColor(X, Y, Text, FontColor, Transparent);
end;

procedure TAsphyreCanvasHelper.DrawOutLineTextInRect(X, Y: Integer; DstRect:TRect; Text: TAsphyreCustomTexture; FontColor, BgColor: TColor; OutLinePixel : Integer;  Transparent: Boolean);
var
  I : Integer;
begin

  for i := 1 to OutLinePixel do
  begin
    DrawInRect(X - i, Y, DstRect , Text , cColor4(cColor1(BgColor)), TBlendingEffect.beNormal);
    DrawInRect(X + i, Y, DstRect , Text , cColor4(cColor1(BgColor)), TBlendingEffect.beNormal);
    DrawInRect(X, Y - i, DstRect , Text , cColor4(cColor1(BgColor)), TBlendingEffect.beNormal);
    DrawInRect(X, Y + i, DstRect , Text , cColor4(cColor1(BgColor)), TBlendingEffect.beNormal);
  end;

  DrawInRect(X, Y , DstRect , Text , cColor4(cColor1(FontColor)), TBlendingEffect.beNormal);
end;

procedure TAsphyreCanvasHelper.DrawBoldTextInRect(X, Y: Integer; DstRect: TRect; Text: TAsphyreCustomTexture; FontColor, BgColor: TColor; Effect: TBlendingEffect);
begin
//  DrawInRect(X - 1, Y - 1, DstRect, Text, cColor4(cColor1(BgColor)), Effect);
//  DrawInRect(X - 1, Y + 1, DstRect, Text, cColor4(cColor1(BgColor)), Effect);
//  DrawInRect(X + 1, Y - 1, DstRect, Text, cColor4(cColor1(BgColor)), Effect);
//  DrawInRect(X + 1, Y + 1, DstRect, Text, cColor4(cColor1(BgColor)), Effect);
  DrawInRect(X - 1, Y, DstRect, Text, cColor4(cColor1(BgColor)), Effect);
  DrawInRect(X + 1, Y, DstRect, Text, cColor4(cColor1(BgColor)), Effect);
  DrawInRect(X, Y - 1, DstRect, Text, cColor4(cColor1(BgColor)), Effect);
  DrawInRect(X, Y + 1, DstRect, Text, cColor4(cColor1(BgColor)), Effect);
  DrawInRect(X, Y, DstRect, Text, cColor4(cColor1(FontColor)), Effect);
end;

procedure TAsphyreCanvasHelper.DrawText(X, Y: Integer; Text: TAsphyreCustomTexture; FontColor: TColor; Transparent: Boolean);
begin
  DrawColor(X, Y, Text, FontColor, Transparent);
end;

procedure TAsphyreCanvasHelper.DrawTextInRect(X, Y: Integer; DstRect: TRect; Text: TAsphyreCustomTexture; FontColor: TColor; Effect: TBlendingEffect);
begin
  DrawInRect(X, Y, DstRect, Text, cColor4(cColor1(FontColor)), Effect);
end;

{ TAsphyreLockableTextureHelper }

function TAsphyreLockableTextureHelper.ClientRect: TRect;
begin
  Result := Bounds(0, 0, Width, Height);
end;

procedure TAsphyreLockableTextureHelper.Draw(X, Y: Integer; Source: TAsphyreLockableTexture; Transparent: Boolean);
begin
  Draw(Source.ClientRect, Bounds(X, Y, Width - X, Height - Y), Source, Transparent);
end;

procedure TAsphyreLockableTextureHelper.Draw(X, Y: Integer; SrcRect: TRect; Source: TAsphyreLockableTexture; Transparent: Boolean);
begin
  Draw(SrcRect, Bounds(X, Y, Width, Height), Source, Transparent);
end;

procedure TAsphyreLockableTextureHelper.CopyFrom(
  Source: TAsphyreLockableTexture);
var
  P, P2 :Pointer;
  Pitch : Integer;
begin
  Self.Mipmapping := Source.Mipmapping;
  Self.Format := Source.Format;
  Self.Width := Source.Width;
  Self.Height := Source.Height;

  Source.Lock(Rect(0,0,Source.Width,Source.Height),P,Pitch);
  Try
    if Initialize then
    begin
      try
        Lock(Rect(0,0,Width,Height),P2,Pitch);
        Move(P^,P2^,Pitch * Height);
      finally
        Unlock;
      end;
    end;
  Finally
    Source.Unlock;
  End;

end;

procedure TAsphyreLockableTextureHelper.Draw(SrcRect, DstRect: TRect; Source: TAsphyreLockableTexture; Transparent: Boolean);
var
  ASData, ADData, ASLine, ADLine: Pointer;
  ASPitch, ADPitch: Integer;
  I, J, W, H: Integer;
begin
  if Source.Format = Format then
  begin
    Source.Lock(Source.ClientRect, ASData, ASPitch);
    Lock(ClientRect, ADData, ADPitch);
    try
      W := Min(SrcRect.Right - SrcRect.Left, DstRect.Right - DstRect.Left);
      H := Min(SrcRect.Bottom - SrcRect.Top, DstRect.Right - DstRect.Left);
      Inc(Cardinal(ADData), DstRect.Top * ADPitch + DstRect.Left * BytesPerPixel);
      Inc(Cardinal(ASData), SrcRect.Top * ASPitch + SrcRect.Left * Source.BytesPerPixel);
      if Transparent then
      begin
        for I := 0 to H - 1 do
        begin
          ADLine := ADData;
          ASLine := ASData;
          for J := 0 to W - 1 do
          begin
            if PCardinal(ASLine)^ > 0 then
              PCardinal(ADLine)^ := PCardinal(ASLine)^;
            Inc(PCardinal(ASLine));
            Inc(PCardinal(ADLine));
          end;
          Inc(Cardinal(ASData), ASPitch);
          Inc(Cardinal(ADData), ADPitch);
        end;
      end
      else
      begin
        for I := 0 to H - 1 do
        begin
          Move(ASData^, ADData^, W * BytesPerPixel);
          Inc(Cardinal(ASData), ASPitch);
          Inc(Cardinal(ADData), ADPitch);
        end;
      end;
    finally
      Source.Unlock;
      Unlock;
    end;
  end;
end;

procedure TAsphyreLockableTextureHelper.Fill(Color: TColor);
var
  AData: Pointer;
  APitch: Integer;
  ACColor: Cardinal;
  X: Integer;
begin
  ACColor := cColor1(Color);
  Lock(ClientRect, AData, APitch);
  try
    for X := 0 to Height - 1 do
    begin
      FillChar(AData^, APitch, ACColor);
      AData := Pointer(Cardinal(AData) + APitch);
    end;
  finally
    Unlock;
  end;
end;

procedure TAsphyreLockableTextureHelper.FillRect(ARect: TRect; Color: TColor);
var
  AData: Pointer;
  APitch: Integer;
  ACColor: Cardinal;
  I: Integer;
begin
  ACColor := cColor1(Color);
  Lock(ClientRect, AData, APitch);
  try
    Inc(Cardinal(AData), APitch * ARect.Top + ARect.Left * BytesPerPixel);
    for I := ARect.Top to ARect.Bottom do
    begin
      FillChar(AData^, (ARect.Right - ARect.Left) * BytesPerPixel, ACColor);
      Inc(Cardinal(AData), APitch);
    end;
  finally
    Unlock;
  end;
end;

procedure TAsphyreLockableTextureHelper.HorFillDraw(const X1, X2, Y: Integer; Source: TAsphyreLockableTexture; const Transparent: Boolean);
var
  W, I: Integer;
begin
  W := Source.Width;
  I := 0;
  while True do
  begin
    Self.Draw(X1 + I * W, Y, Source, Transparent);
    Inc(I);
    if X1 + I * W > X2 then
    begin
      if X1 < X2 then
        Draw(X2 - W, Y, Source, Transparent);;
      Break;
    end;
  end;
end;

function TAsphyreLockableTextureHelper.LoadFromFontData(AData: Pointer; ADataSize: LongWord; AWidth, AHeight: Integer): Boolean;
var
  ATextureData, ADLine: Pointer;
  ASourceLine: PWord;
  AWord: Word;
  APitch, APitch1, X, Y: Integer;
begin
  Result := False;
  try
    if Initialize then
    begin
      WidthBytes(AWidth, 16, APitch1);
      Lock(Bounds(0, 0, Width, Height), ATextureData, APitch);
      try
        for Y := 0 to Height - 1 do
        begin
          ADLine := Pointer(Cardinal(ATextureData) + APitch * Y); //图片
          ASourceLine := PWord(Cardinal(AData) + APitch1 * Y);
          for X := 0 to Width - 1 do
          begin
            AWord := 0;
            if PWord(ASourceLine)^ > 0 then
              AWord := ColorTable_A1R5G5B5[$FFFF];
            PWord(ADLine)^ := AWord;
            ADLine := Pointer(Cardinal(ADLine) + 2{BytesPerPixel});
            Inc(ASourceLine);
          end;
        end;
        Result := True;
      finally
        Unlock;
      end;
    end;
  except
  end;
end;

var LogicThreadID :Cardinal =  0;
function TAsphyreLockableTextureHelper.LoadFromDataEx(ABuffer: Pointer; ADataSize: LongWord; ABitCount: Byte; AWidth, AHeight: Integer; MirrorX, MirrorY: Boolean): Boolean;
var
  ATextureData, ADLine, ASourceLine: Pointer;
  AWord: Word;
  V: Cardinal;
  APitch,X, Y: Integer;
begin
  Result := False;
  Format := TAsphyrePixelFormat.apf_A8R8G8B8;
  Width := AWidth;
  Height := AHeight;
  if LogicThreadID = 0 then
  begin
    LogicThreadID := GetCurrentThreadId();
  end;

  if LogicThreadID  <> GetCurrentThreadId then
  begin
    DebugBreak;
  end;

  if Initialize then
  begin
    Lock(Bounds(0, 0, Width, Height), ATextureData, APitch);
    try
      for Y := 0 to AHeight - 1 do
      begin
        if MirrorY then
          ADLine := Pointer(Cardinal(ATextureData) + APitch * (Height - Y - 1))
        else
          ADLine := Pointer(Cardinal(ATextureData) + APitch * Y);
        if MirrorX then
          ADLine := Pointer(Cardinal(ADLine) + APitch - BytesPerPixel);
        ASourceLine := Pointer(Cardinal(ABuffer) + (ADataSize div AHeight) * Y);
        case ABitCount of
          8:
          begin
            for X := 0 to AWidth - 1 do
            begin
              if PByte(ASourceLine)^ = 0 then
                V := $00000000
              else
                V :=  ColorPalette[PByte(ASourceLine)^];
              PCardinal(ADLine)^ := V;
              if MirrorX then
                Dec(PCardinal(ADLine))
              else
                Inc(PCardinal(ADLine));
              Inc(PByte(ASourceLine));
            end;
          end;
          16:
          begin
            for X := 0 to AWidth - 1 do
            begin
              if PWord(ASourceLine)^ = 0 then
                V := $00000000
              else
                V := ColorTable_R5G6B5_32[PWord(ASourceLine)^];
              PCardinal(ADLine)^ := V;
              if MirrorX then
                Dec(PCardinal(ADLine))
              else
                Inc(PCardinal(ADLine));
              Inc(PWord(ASourceLine));
            end;
          end;
          24:
          begin
            for X := 0 to AWidth - 1 do
            begin
              V := 0;
              Move(ASourceLine^, V, 3);
              if V <> 0 then
                V := V or $FF000000;
              PCardinal(ADLine)^ := V;
              if MirrorX then
                Dec(PCardinal(ADLine))
              else
                Inc(PCardinal(ADLine));
              Inc(PBGR(ASourceLine));
            end;
          end;
          32:
          begin
            for X := 0 to AWidth - 1 do
            begin
              if PLongWord(ASourceLine)^ > 0 then
                V := PLongWord(ASourceLine)^ or $FF000000
              else
                V := 0;
              PCardinal(ADLine)^ := V;
              if MirrorX then
                ADLine := Pointer(Cardinal(ADLine) - BytesPerPixel)
              else
                ADLine := Pointer(Cardinal(ADLine) + BytesPerPixel);
              Inc(PLongWord(ASourceLine));
            end;
          end;
        end;
      end;
    finally
      Unlock;
    end;
    Result := True;
  end else begin
    {$IFDEF CONSOLE}
       Writeln('[异常] 纹理初始化失败');
    {$ENDIF}
  end;
end;

function TAsphyreLockableTextureHelper.LoadFromPng(PNG: TPngImage): Boolean;
var
  P: pRGBLine;
  PAlpha : pByteArray;
  RGB:TRGBTriple;
  I,J : Integer;
  A : Byte; //透明值
  ATextureData: Pointer;
  ADLine : pCardinal;
  APitch: Integer;
  DIB:TBitmap;
begin
  Format := TAsphyrePixelFormat.apf_A8R8G8B8;
  SetSize(PNG.Width,PNG.Height);
  ISPNGTexture := True;
  if Initialize then
  begin
    Lock(Bounds(0, 0, Width, Height), ATextureData, APitch);
    Try
      if (PNG.Header.ColorType = COLOR_RGBALPHA) then
      begin
        for I := 0  to PNG.Height - 1 do
        begin
          P := pRGBLine(png.Scanline[I]);
          PAlpha := PNG.AlphaScanline[i];
          ADLine := pCardinal(Cardinal(ATextureData) + APitch * I);
          for J := 0 to PNG.Width - 1 do
          begin
            RGB := P^[J];
            A := PAlpha^[J];
            ADLine^ := (A shl 24) or (RGB.rgbtRed shl 16) or (RGB.rgbtGreen shl 8) or (RGB.rgbtBlue);
            Inc(ADLine);
          end;
        end;
      end else
      begin
        DIB := TBitmap.Create;
        Try
          DIB.PixelFormat := pf24bit;
          DIB.SetSize(PNG.Width,PNG.Height);
          DIB.Canvas.Draw(0,0,PNG);
          for I := 0  to PNG.Height - 1 do
          begin
            P := pRGBLine(DIB.Scanline[I]);
            ADLine := pCardinal(Cardinal(ATextureData) + APitch * I);
            for J := 0 to PNG.Width - 1 do
            begin
              RGB := P^[J];
              ADLine^ := ($FF000000) or (RGB.rgbtRed shl 16) or (RGB.rgbtGreen shl 8) or (RGB.rgbtBlue);
              Inc(ADLine);
            end;
          end;
        Finally
          DIB.Free;
        End;
      end;
    Finally
      Unlock;
    End;
  end;
end;

function TAsphyreLockableTextureHelper.LoadFromPng32Data(ABuffer: Pointer; ADataSize: LongWord; ABitCount: Byte; AWidth, AHeight: Integer): Boolean;
var
  ATextureData, ADLine, ASourceLine: Pointer;
  APitch,APitch2,Y: Integer;
begin
  Result := False;
  Format := TAsphyrePixelFormat.apf_A8R8G8B8;
  Width := AWidth;
  Height := AHeight;
  if Initialize then
  begin
    WidthBytes(AWidth,32,APitch2);
    Lock(Bounds(0, 0, Width, Height), ATextureData, APitch);
    try
      for Y := 0 to AHeight - 1 do
      begin
        ADLine := Pointer(Cardinal(ATextureData) + APitch * Y);
        ASourceLine := Pointer(Cardinal(ABuffer) + APitch2 * Y);
        Move(ASourceLine^, ADLine^, APitch2);
      end;
      Result := True;
    finally
      Unlock;
    end;
  end;
end;

function TAsphyreLockableTextureHelper.LoadAlphaFromDataEx(ABuffer: Pointer; ADataSize: LongWord; AWidth, AHeight: Integer): Boolean;
  function LoByteToByte(Value:Byte):Byte;inline;
  begin
    Result := (Value and $F) * 16;
  end;

  function HiByteToByte(Value:Byte):Byte;inline;
  begin
     Result := ((Value and $F0) shr 4 ) * 16;
  end;
var
  ATextureData, AAlphaData: Pointer;
  ASLine: PWord;
  ADLine: PCardinal;
  AALine: PByte;
  X, Y, APitch, AAPitch: Integer;
  V32: Cardinal;
  ARGBQuad: TRGBQuad absolute V32;
  Lo:boolean;
begin
  Result := False;
  Width := AWidth;
  Height := AHeight;
  Format := TAsphyrePixelFormat.apf_A8R8G8B8;
  if Initialize then
  begin
    Lock(Bounds(0, 0, Width, Height), ATextureData, APitch);
    try
      AAlphaData := Pointer(Cardinal(ABuffer) + (APitch DIV 2) * Height);
      AAPitch := Width div 2;

      for Y := 0 to Height - 1 do
      begin
        ASLine := PWord(Cardinal(ABuffer) + (APitch DIV 2) * Y);
        ADLine := PCardinal(Cardinal(ATextureData) + APitch * (Height - 1 - Y));
        AALine := PByte(Cardinal(AAlphaData) + AAPitch * (Height - 1 - Y));
        Lo := True;
        for X := 0 to Width - 1 do
        begin
          V32 := ColorTable_R5G6B5_32[ASLine^];

          if Lo then
          begin
            ARGBQuad.rgbReserved := LoByteToByte( AALine^);
          end
          else
          begin
            ARGBQuad.rgbReserved := HiByteToByte( AALine^);
          end;


          ADLine^ := V32;
          Inc(ASLine);
          Inc(ADLine);

          if Lo then
          begin
            Inc(AALine);
            Lo := False;
          end else
          begin
            Lo := not Lo;
          end;
        end;
      end;
      Result := True;
    finally
      Unlock;
    end;
  end;
end;

procedure TAsphyreLockableTextureHelper.ResetAlpha;
var
  SrcPx: PLongWord;
  I, APitch: Integer;
begin
  Lock(ClientRect, Pointer(SrcPx), APitch);
  try
    for i:= 0 to (Width * Height) - 1 do
    begin
      SrcPx^ := SrcPx^ or $FF000000;
      Inc(SrcPx);
    end;
  finally
    UnLock;
  end;
end;

procedure TAsphyreLockableTextureHelper.SetSize(W, H: Integer; AutoInitialize: Boolean);
begin
  Width := W;
  Height := H;
  if AutoInitialize then
    Initialize;
end;

procedure TAsphyreLockableTextureHelper.VerFillDraw(const X, Y1, Y2: Integer; Source: TAsphyreLockableTexture; const Transparent: Boolean);
var
  H, I: Integer;
begin
  H := Source.Height;
  I := 0;
  while True do
  begin
    Draw(X, Y1 + I * H, Source, Transparent);
    Inc(I);
    if Y1 + I * H > Y2 then
    begin
      if Y1 < Y2 then
        Draw(X, Y2 - H, Source, Transparent);;
      Break;
    end;
  end;
end;

{ TAsphyreCustomTextureHelper }

function TAsphyreCustomTextureHelper.ClientRect: TRect;
begin
  Result := Bounds(0, 0, Width, Height);
end;

procedure TAsphyreCustomTextureHelper.SetSize(W, H: Integer; AutoInitialize: Boolean);
begin
  Width := W;
  Height := H;
  if AutoInitialize then
    Initialize;
end;

const
  ColorArray: array[0..1023] of Byte = (
    $00, $00, $00, $00, $00, $00, $80, $00, $00, $80, $00, $00, $00, $80, $80, $00,
    $80, $00, $00, $00, $80, $00, $80, $00, $80, $80, $00, $00, $C0, $C0, $C0, $00,
    $97, $80, $55, $00, $C8, $B9, $9D, $00, $73, $73, $7B, $00, $29, $29, $2D, $00,
    $52, $52, $5A, $00, $5A, $5A, $63, $00, $39, $39, $42, $00, $18, $18, $1D, $00,
    $10, $10, $18, $00, $18, $18, $29, $00, $08, $08, $10, $00, $71, $79, $F2, $00,
    $5F, $67, $E1, $00, $5A, $5A, $FF, $00, $31, $31, $FF, $00, $52, $5A, $D6, $00,
    $00, $10, $94, $00, $18, $29, $94, $00, $00, $08, $39, $00, $00, $10, $73, $00,
    $00, $18, $B5, $00, $52, $63, $BD, $00, $10, $18, $42, $00, $99, $AA, $FF, $00,
    $00, $10, $5A, $00, $29, $39, $73, $00, $31, $4A, $A5, $00, $73, $7B, $94, $00,
    $31, $52, $BD, $00, $10, $21, $52, $00, $18, $31, $7B, $00, $10, $18, $2D, $00,
    $31, $4A, $8C, $00, $00, $29, $94, $00, $00, $31, $BD, $00, $52, $73, $C6, $00,
    $18, $31, $6B, $00, $42, $6B, $C6, $00, $00, $4A, $CE, $00, $39, $63, $A5, $00,
    $18, $31, $5A, $00, $00, $10, $2A, $00, $00, $08, $15, $00, $00, $18, $3A, $00,
    $00, $00, $08, $00, $00, $00, $29, $00, $00, $00, $4A, $00, $00, $00, $9D, $00,
    $00, $00, $DC, $00, $00, $00, $DE, $00, $00, $00, $FB, $00, $52, $73, $9C, $00,
    $4A, $6B, $94, $00, $29, $4A, $73, $00, $18, $31, $52, $00, $18, $4A, $8C, $00,
    $11, $44, $88, $00, $00, $21, $4A, $00, $10, $18, $21, $00, $5A, $94, $D6, $00,
    $21, $6B, $C6, $00, $00, $6B, $EF, $00, $00, $77, $FF, $00, $84, $94, $A5, $00,
    $21, $31, $42, $00, $08, $10, $18, $00, $08, $18, $29, $00, $00, $10, $21, $00,
    $18, $29, $39, $00, $39, $63, $8C, $00, $10, $29, $42, $00, $18, $42, $6B, $00,
    $18, $4A, $7B, $00, $00, $4A, $94, $00, $7B, $84, $8C, $00, $5A, $63, $6B, $00,
    $39, $42, $4A, $00, $18, $21, $29, $00, $29, $39, $46, $00, $94, $A5, $B5, $00,
    $5A, $6B, $7B, $00, $94, $B1, $CE, $00, $73, $8C, $A5, $00, $5A, $73, $8C, $00,
    $73, $94, $B5, $00, $73, $A5, $D6, $00, $4A, $A5, $EF, $00, $8C, $C6, $EF, $00,
    $42, $63, $7B, $00, $39, $56, $6B, $00, $5A, $94, $BD, $00, $00, $39, $63, $00,
    $AD, $C6, $D6, $00, $29, $42, $52, $00, $18, $63, $94, $00, $AD, $D6, $EF, $00,
    $63, $8C, $A5, $00, $4A, $5A, $63, $00, $7B, $A5, $BD, $00, $18, $42, $5A, $00,
    $31, $8C, $BD, $00, $29, $31, $35, $00, $63, $84, $94, $00, $4A, $6B, $7B, $00,
    $5A, $8C, $A5, $00, $29, $4A, $5A, $00, $39, $7B, $9C, $00, $10, $31, $42, $00,
    $21, $AD, $EF, $00, $00, $10, $18, $00, $00, $21, $29, $00, $00, $6B, $9C, $00,
    $5A, $84, $94, $00, $18, $42, $52, $00, $29, $5A, $6B, $00, $21, $63, $7B, $00,
    $21, $7B, $9C, $00, $00, $A5, $DE, $00, $39, $52, $5A, $00, $10, $29, $31, $00,
    $7B, $BD, $CE, $00, $39, $5A, $63, $00, $4A, $84, $94, $00, $29, $A5, $C6, $00,
    $18, $9C, $10, $00, $4A, $8C, $42, $00, $42, $8C, $31, $00, $29, $94, $10, $00,
    $10, $18, $08, $00, $18, $18, $08, $00, $10, $29, $08, $00, $29, $42, $18, $00,
    $AD, $B5, $A5, $00, $73, $73, $6B, $00, $29, $29, $18, $00, $4A, $42, $18, $00,
    $4A, $42, $31, $00, $DE, $C6, $63, $00, $FF, $DD, $44, $00, $EF, $D6, $8C, $00,
    $39, $6B, $73, $00, $39, $DE, $F7, $00, $8C, $EF, $F7, $00, $00, $E7, $F7, $00,
    $5A, $6B, $6B, $00, $A5, $8C, $5A, $00, $EF, $B5, $39, $00, $CE, $9C, $4A, $00,
    $B5, $84, $31, $00, $6B, $52, $31, $00, $D6, $DE, $DE, $00, $B5, $BD, $BD, $00,
    $84, $8C, $8C, $00, $DE, $F7, $F7, $00, $18, $08, $00, $00, $39, $18, $08, $00,
    $29, $10, $08, $00, $00, $18, $08, $00, $00, $29, $08, $00, $A5, $52, $00, $00,
    $DE, $7B, $00, $00, $4A, $29, $10, $00, $6B, $39, $10, $00, $8C, $52, $10, $00,
    $A5, $5A, $21, $00, $5A, $31, $10, $00, $84, $42, $10, $00, $84, $52, $31, $00,
    $31, $21, $18, $00, $7B, $5A, $4A, $00, $A5, $6B, $52, $00, $63, $39, $29, $00,
    $DE, $4A, $10, $00, $21, $29, $29, $00, $39, $4A, $4A, $00, $18, $29, $29, $00,
    $29, $4A, $4A, $00, $42, $7B, $7B, $00, $4A, $9C, $9C, $00, $29, $5A, $5A, $00,
    $14, $42, $42, $00, $00, $39, $39, $00, $00, $59, $59, $00, $2C, $35, $CA, $00,
    $21, $73, $6B, $00, $00, $31, $29, $00, $10, $39, $31, $00, $18, $39, $31, $00,
    $00, $4A, $42, $00, $18, $63, $52, $00, $29, $73, $5A, $00, $18, $4A, $31, $00,
    $00, $21, $18, $00, $00, $31, $18, $00, $10, $39, $18, $00, $4A, $84, $63, $00,
    $4A, $BD, $6B, $00, $4A, $B5, $63, $00, $4A, $BD, $63, $00, $4A, $9C, $5A, $00,
    $39, $8C, $4A, $00, $4A, $C6, $63, $00, $4A, $D6, $63, $00, $4A, $84, $52, $00,
    $29, $73, $31, $00, $5A, $C6, $63, $00, $4A, $BD, $52, $00, $00, $FF, $10, $00,
    $18, $29, $18, $00, $4A, $88, $4A, $00, $4A, $E7, $4A, $00, $00, $5A, $00, $00,
    $00, $88, $00, $00, $00, $94, $00, $00, $00, $DE, $00, $00, $00, $EE, $00, $00,
    $00, $FB, $00, $00, $94, $5A, $4A, $00, $B5, $73, $63, $00, $D6, $8C, $7B, $00,
    $D6, $7B, $6B, $00, $FF, $88, $77, $00, $CE, $C6, $C6, $00, $9C, $94, $94, $00,
    $C6, $94, $9C, $00, $39, $31, $31, $00, $84, $18, $29, $00, $84, $00, $18, $00,
    $52, $42, $4A, $00, $7B, $42, $52, $00, $73, $5A, $63, $00, $F7, $B5, $CE, $00,
    $9C, $7B, $8C, $00, $CC, $22, $77, $00, $FF, $AA, $DD, $00, $2A, $B4, $F0, $00,
    $9F, $00, $DF, $00, $B3, $17, $E3, $00, $F0, $FB, $FF, $00, $A4, $A0, $A0, $00,
    $80, $80, $80, $00, $00, $00, $FF, $00, $00, $FF, $00, $00, $00, $FF, $FF, $00,
    $FF, $00, $00, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $00, $FF, $FF, $FF, $00
  );

//function GetRGB(c256: Byte): TColor;
//begin
//  Result := RGB(Bit8MainPalette[c256].rgbBlue, Bit8MainPalette[c256].rgbGreen, Bit8MainPalette[c256].rgbRed);
//end;
function GetRGB(c256: BYTE): Integer;
begin
  Result := RGB(Bit8MainPalette[c256].rgbRed, Bit8MainPalette[c256].rgbGreen, Bit8MainPalette[c256].rgbBlue);
end;

function MakeNewGUID38: String;
var
  AGuid: TGUID;
begin
  CreateGUID(AGuid);
  Result := GuidToString(AGuid);
end;

function MakeNewGUID36: String;
begin
  Result := Copy(MakeNewGUID38, 2, 36);
end;

function MakeNewGUID32: String;
begin
  Result := StrUtils.ReplaceStr(MakeNewGUID36, '-', '');
end;

function MakeNewGUID16: String;
var
  Tmp: String;
  I: Integer;
begin
  Tmp := MakeNewGUID32;
  for I := 1 to Length(Tmp) do
  begin
    if I mod 2 = 0 then
      Result  :=  Result + Tmp[I];
  end;
end;

{$IF RTLVersion>= 29.0}//xe8+
{$LEGACYIFEND ON}
{$IFEND}

{$IF RTLVersion>= 29.0}//xe8+
function ZLibPtr(Ptr:PAnsiChar):PByte;
begin
  Result := PByte(Ptr);
end;

{$ELSE}
function ZLibPtr(Ptr:PAnsiChar):PAnsiChar;
begin
  Result := Ptr;
end;

{$IFEND}


procedure CompressBufZ(const InBuf: PAnsiChar; InBytes: Integer; out OutBuf: PAnsiChar; out OutBytes: Integer);
const
  delta = 256;
var
  zstream: TZStreamRec;
begin
  FillChar(zstream, SizeOf(TZStreamRec), 0);

  OutBytes := ((InBytes + (InBytes div 10) + 12) + 255) and not 255;
  GetMem(OutBuf, OutBytes);

  try
    zstream.next_in := ZLibPtr(InBuf);
    zstream.avail_in := InBytes;
    zstream.next_out := ZLibPtr(OutBuf);
    zstream.avail_out := OutBytes;

    DeflateInit_(zstream, Z_BEST_COMPRESSION, ZLIB_VERSION, SizeOf(TZStreamRec));
    try
      while deflate(zstream, Z_FINISH) <> Z_STREAM_END do
      begin
        Inc(OutBytes, delta);
        ReallocMem(OutBuf, OutBytes);
        zstream.next_out := ZLibPtr(PAnsiChar(Integer(OutBuf) + zstream.total_out));
        zstream.avail_out := delta;
      end;
    finally
      deflateEnd(zstream);
    end;

    ReallocMem(OutBuf, zstream.total_out);
    OutBytes := zstream.total_out;
  except
    FreeMem(OutBuf);
    raise;
  end;
end;


procedure DecompressBufZ(const inBuffer: PAnsiChar; inSize: Integer; outEstimate: Integer;
  out outBuffer: PAnsiChar; out outSize: Integer);
var
  zstream: TZStreamRec;
  delta: Integer;
begin
  FillChar(zstream, SizeOf(TZStreamRec), 0);
  delta := (inSize + 255) and not 255;
  if outEstimate = 0 then
    outSize := delta
  else
    outSize := outEstimate;

  GetMem(outBuffer, outSize);
  zstream.next_in := ZLibPtr(inBuffer);
  zstream.avail_in := inSize;
  zstream.next_out := ZLibPtr(outBuffer);
  zstream.avail_out := outSize;
  inflateInit_(zstream, zlib_version, sizeof(zstream));
  try
    while inflate(zstream, Z_NO_FLUSH) <> Z_STREAM_END do
    begin
      Inc(outSize, delta);
      ReallocMem(outBuffer, outSize);

      zstream.next_out := ZLibPtr(PAnsiChar(Cardinal(outBuffer) + zstream.total_out));
      zstream.avail_out := delta;
    end;
  finally
    inflateEnd(zstream);
  end;

  ReallocMem(outBuffer, zstream.total_out);
  outSize := zstream.total_out;
end;

procedure FreeAndNilEx(var Obj);
var
  Temp: TObject;
begin
  try
    Temp := TObject(Obj);
    Pointer(Obj) := nil;
    Temp.Free;
  except
  end;
end;

procedure FreeAndNilSafe( var Obj);
var
  Temp: TObject;
begin
  try
    Temp := TObject(Obj);
    if Temp  <> nil then
    begin
      Pointer(Obj) := nil;
      Temp.Free;
    end;
  except
  end;
end;

procedure Pixel565To32(Value: Word; var AResult: Cardinal);
 var
  R, G, B, A: Byte;
begin
  if Value <> 0 then
  begin
    R := Value and $F800 shr 8;
    G := Value and $07E0 shr 3;
    B := Value and $001F shl 3;
    A := $FF;
    AResult := B or (G shl 8) or (R shl 16) or (A shl 24);
  end else
  begin
    AResult := 0;
  end;
end;

procedure Pixel32To1555(Source: Cardinal; var Value: Word);
var
  AValue: Cardinal;
begin
  Value := 0;
  if Source > 0 then
  begin
    AValue := ((Source and $FF) * 31) div 255;
    AValue := AValue or ((((Source shr 8) and $FF) * 31) div 255) shl 5;
    AValue := AValue or ((((Source shr 16) and $FF) * 31) div 255) shl 10;
    AValue := AValue or (((Source shr 24) and $FF) div 255) shl 15;
  end;
  Value := AValue;
end;

function RGBToASPColor(RGB:TRGBQuad):Cardinal;
begin
  Result := RGB.rgbBlue or (RGB.rgbGreen shl 8) or (RGB.rgbRed shl 16) or ($FF000000);
end;

procedure BuildColorTable;
var
  I: Integer;
  ACardinal: Cardinal;
begin
  Move(ColorArray[0], Bit8MainPalette[0], SizeOf(ColorArray));
  for I := 0 to Length(ColorTable_565) - 1 do
  begin
    if Integer(Bit8MainPalette[I]) = 0 then
      ColorTable_565[I] := 0
    else
      ColorTable_565[I] := Word((Max(Bit8MainPalette[I].rgbRed and $F8, 8) shl 8)
      or (Max(Bit8MainPalette[I].rgbGreen and $FC, 8) shl 3)
      or (Max(Bit8MainPalette[I].rgbBlue and $F8, 8) shr 3));
  end;

  for I := Low(Word) to High(Word) do
    Pixel565To32(I, ColorTable_R5G6B5_32[I]);
  for I := Low(Word) to High(Word) do
    Pixel32To1555(ColorTable_R5G6B5_32[I], ColorTable_A1R5G5B5[I]);

  for i := 0 to High(ColorPalette) do
  begin
    ColorPalette[i] := RGBToASPColor(Bit8MainPalette[i]);
  end;

end;

procedure UnBuildColorTable;
begin
  Finalize(Bit8MainPalette);
  Finalize(ColorTable_565);
  Finalize(ColorTable_R5G6B5_32);
  Finalize(ColorTable_A1R5G5B5);
end;

initialization
  BuildColorTable;

finalization
  UnBuildColorTable;

end.


