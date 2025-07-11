unit YiqColorUtils;
//---------------------------------------------------------------------------
// YiqColorUtils.pas                                    Modified: 14-Sep-2012
// YIQ color space utilities for Asphyre.                        Version 1.01
//---------------------------------------------------------------------------
// Important Notice:
//
// If you modify/use this code or one of its parts either in original or
// modified form, you must comply with Mozilla Public License Version 2.0,
// including section 3, "Responsibilities". Failure to do so will result in
// the license breach, which will be resolved in the court. Remember that
// violating author's rights either accidentally or intentionally is
// considered a serious crime in many countries. Thank you!
//
// !! Please *read* Mozilla Public License 2.0 document located at:
//  http://www.mozilla.org/MPL/
//---------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 2.0 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is YiqColorUtils.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
uses
 Math;

//---------------------------------------------------------------------------
type
 TYIQColor = record
  y, i, q, a: Single;
 end;

//---------------------------------------------------------------------------
 TYCHiqColor = record
  y, C, h, a: Single;
 end;

//---------------------------------------------------------------------------
function YIQColor(y, i, q: Single): TYIQColor;
function YCHiqColor(y, C, h: Single): TYCHiqColor;

//---------------------------------------------------------------------------
function RGBtoYIQ(Color: Cardinal): TYIQColor;
function YIQtoRGB(const Color: TYIQColor): Cardinal;

//---------------------------------------------------------------------------
function YIQtoYCHiq(const Color: TYIQColor): TYCHiqColor;
function YCHiqToYIQ(const Color: TYCHiqColor): TYIQColor;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreUtils;

//---------------------------------------------------------------------------
function YIQColor(y, i, q: Single): TYIQColor;
begin
 Result.y:= y;
 Result.i:= i;
 Result.q:= q;
 Result.a:= 1.0;
end;

//---------------------------------------------------------------------------
function YCHiqColor(y, C, h: Single): TYCHiqColor;
begin
 Result.y:= y;
 Result.C:= C;
 Result.h:= h;
 Result.a:= 1.0;
end;

//---------------------------------------------------------------------------
function RGBtoYIQ(Color: Cardinal): TYIQColor;
var
 r, g, b: Single;
begin
 b:= (Color and $FF) / 255.0;
 g:= ((Color shr 8) and $FF) / 255.0;
 r:= ((Color shr 16) and $FF) / 255.0;

 Result.y:= 0.29889531 * r +  0.58662247 * g +  0.11448223 * b;
 Result.i:= 0.59597799 * r + -0.27417610 * g + -0.32180189 * b;
 Result.q:= 0.21147017 * r + -0.52261711 * g +  0.31114694 * b;
 Result.a:= ((Color shr 24) and $FF) / 255.0;
end;

//---------------------------------------------------------------------------
function YIQtoRGB(const Color: TYIQColor): Cardinal;
var
 Red, Green, Blue: Integer;
begin
 Red:= MinMax2(Round((Color.y + 0.95608445 * Color.i + 0.62088850 * Color.q) *
  255.0), 0, 255);

 Green:= MinMax2(Round((Color.y - 0.27137664 * Color.i - 0.64860590 * Color.q) *
  255.0), 0, 255);

 Blue:= MinMax2(Round((Color.y - 1.10561724 * Color.i + 1.70250126 * Color.q) *
  255.0), 0, 255);

 Result:= Cardinal(Blue) or (Cardinal(Green) shl 8) or
  (Cardinal(Red) shl 16) or (Cardinal(Round(Color.a * 255.0)) shl 24);
end;

//---------------------------------------------------------------------------
function YIQtoYCHiq(const Color: TYIQColor): TYCHiqColor;
begin
 Result.y:= Color.y;
 Result.C:= Sqrt(Sqr(Color.i) + Sqr(Color.q));
 Result.h:= ArcTan2(Color.q, Color.i);
 Result.a:= Color.a;
end;

//---------------------------------------------------------------------------
function YCHiqToYIQ(const Color: TYCHiqColor): TYIQColor;
begin
 Result.y:= Color.y;
 Result.i:= Color.C * Cos(Color.h);
 Result.q:= Color.C * Sin(Color.h);
 Result.a:= Color.a;
end;

//---------------------------------------------------------------------------
end.
