unit cliUtil;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, WIL,
  AbstractCanvas, AbstractTextures, AsphyreTypes, StdCtrls, DIB, HUtil32,
  uGameEngine, uCommon;

const
  ALPHAVALUE = 150;

type
  TColorEffect = (ceNone, ceGrayScale, ceBright, ceBlack, ceWhite, ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia, ceSky);

procedure MakeDark (ssuf: TAsphyreCanvas; darklevel: integer); inline;
procedure DrawEffect(X, Y: Integer; ACanavas: TAsphyreCanvas; ATexture: TAsphyreLockableTexture; AColorEff: TColorEffect; ATransparent: Boolean); inline;

var
  DarkLevel: integer;

implementation

procedure MakeDark (ssuf: TAsphyreCanvas; darklevel: integer);
begin
  if not darklevel in [1..30] then exit;
   ssuf.FillRectAlpha (ssuf.ClipRect, 0, round((30-darklevel)*255/30));
end;

procedure DrawEffect(X, Y: Integer; ACanavas: TAsphyreCanvas; ATexture: TAsphyreLockableTexture; AColorEff: TColorEffect; ATransparent: Boolean);
begin
  if ATexture = nil then Exit;

  if not ATransparent then
  begin
    case AColorEff of
      ceNone: ACanavas.Draw(X, Y, ATexture, True);
      ceGrayScale: ACanavas.Draw(X, Y, ATexture, beGrayscale);
      //ceBright: ACanavas.Draw(X, Y, ATexture);
      ceBright: ACanavas.Draw(X, Y, ATexture.ClientRect, ATexture, cColor4(cRGB1(255, 255, 255, 255)), fxBlend);
      ceBlack: ACanavas.DrawColor(X, Y, ATexture, clBlack, True);
      ceRed: ACanavas.DrawColor(X, Y, ATexture, clRed, True);
      ceGreen: ACanavas.DrawColor(X, Y, ATexture, GetRGB(222), True);
      ceBlue: ACanavas.DrawColor(X, Y, ATexture, clBlue, True);
      ceYellow: ACanavas.DrawColor(X, Y, ATexture, clYellow, True);
      ceFuchsia: ACanavas.DrawColor(X, Y, ATexture, clFuchsia, True);
      ceWhite: ACanavas.DrawColor(X, Y, ATexture, clWhite, True);
    end;
  end
  else
  begin
    case AColorEff of
      ceNone: ACanavas.DrawAlpha(X, Y, ATexture, 128);
      ceGrayScale: ACanavas.DrawAlpha(X, Y, ATexture.ClientRect, ATexture, ALPHAVALUE, beGrayscale);
      //ceBright: ACanavas.Draw(X, Y, ATexture.ClientRect, ATexture, cColor4(cRGB1(128, 128, 128, 255)), beBlend); //这个不对 ，图层
      ceBright: ACanavas.Draw(X, Y, ATexture.ClientRect, ATexture, cColor4(cRGB1(ALPHAVALUE, ALPHAVALUE, ALPHAVALUE, 128{255})), beBright);  //用这个 隐身后透明度特别高。
      ceBlack: ACanavas.DrawColorAlpha(X, Y, ATexture, clBlack, True, ALPHAVALUE);
      ceRed: ACanavas.DrawColorAlpha(X, Y, ATexture, clRed, True, ALPHAVALUE);
      ceGreen: ACanavas.DrawColorAlpha(X, Y, ATexture, GetRGB(222), True, ALPHAVALUE);
      ceBlue: ACanavas.DrawColorAlpha(X, Y, ATexture, clBlue, True, ALPHAVALUE);
      ceYellow: ACanavas.DrawColorAlpha(X, Y, ATexture, clYellow, True, ALPHAVALUE);
      ceFuchsia: ACanavas.DrawColorAlpha(X, Y, ATexture, clFuchsia, True, ALPHAVALUE);
      ceWhite: ACanavas.DrawColorAlpha(X, Y, ATexture, clWhite, True, ALPHAVALUE);
    end;
  end;
end;

end.
