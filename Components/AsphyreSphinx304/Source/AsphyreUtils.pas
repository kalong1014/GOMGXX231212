unit AsphyreUtils;
//---------------------------------------------------------------------------
// AsphyreUtils.pas                                     Modified: 14-Sep-2012
// Asphyre helper functions.                                     Version 1.07
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
//
// If you require any clarifications about the license, feel free to contact
// us or post your question on our forums at: http://www.afterwarp.net
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
// The Original Code is AsphyreUtils.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< A collection of useful functions and utilities working with numbers and
   rectangles that are used throughout the entire framework. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
uses
 Types, AsphyreDef, Vectors2px, Vectors2;

//---------------------------------------------------------------------------
{ Returns @True if the given point is within the specified rectangle or
  @False otherwise. }
function PointInRect(const Point: TPoint2px;
 const Rect: TRect): Boolean; overload;

//---------------------------------------------------------------------------
{ Returns @True if the given point is within the specified rectangle or
  @False otherwise. This function works with floating-point vector by rounding
  it down. }
{$ifndef Vec2ToPxImplicit}
function PointInRect(const Point: TPoint2;
 const Rect: TRect): Boolean; overload;
{$endif}

//---------------------------------------------------------------------------
{ Returns @True if the given rectangle is within the specified rectangle or
  @False otherwise. }
function RectInRect(const Rect1, Rect2: TRect): Boolean;

//---------------------------------------------------------------------------
{ Returns @True if the two specified rectangles overlap or @False otherwise. }
function OverlapRect(const Rect1, Rect2: TRect): Boolean;

//---------------------------------------------------------------------------
{ Returns @True if the specified point is inside the triangle specified by
  the given three vertices or @False otherwise. }
function PointInTriangle(const Pos, v1, v2, v3: TPoint2px): Boolean;

//---------------------------------------------------------------------------
{ Displaces the specified rectangle by the given offset and returns the
  new resulting rectangle. }
function MoveRect(const Rect: TRect; const Point: TPoint2px): TRect;

//---------------------------------------------------------------------------
{ Calculates the smaller rectangle resulting from the intersection of the
  given two rectangles. }
function ShortRect(const Rect1, Rect2: TRect): TRect;

//---------------------------------------------------------------------------
{ Reduces the size of the specified rectangle by the given offsets on all
  edges. }
function ShrinkRect(const Rect: TRect; hIn, vIn: Integer): TRect;

//---------------------------------------------------------------------------
{ Calculates the resulting interpolated value from the given two depending on
  the @italic(Theta) parameter, which must be specified in [0..1] range. }
function Lerp(x0, x1, Theta: Single): Single;

//---------------------------------------------------------------------------
{ Calculates the resulting interpolated value from the given four vertices and
  the @italic(Theta) parameter, which must be specified in [0..1] range. The
  interpolation uses Catmull-Rom spline. }
function CatmullRom(x0, x1, x2, x3, Theta: Single): Single;

//---------------------------------------------------------------------------
{ Clamps the given value so that it always lies within the specified range. }
function MinMax2(Value, Min, Max: Integer): Integer;

//---------------------------------------------------------------------------
{ Returns the value that is smallest among the two. }
function Min2(a, b: Integer): Integer;

//---------------------------------------------------------------------------
{ Returns the value that is biggest among the two. }
function Max2(a, b: Integer): Integer;

//---------------------------------------------------------------------------
{ Returns the value that is smallest among the three. }
function Min3(a, b, c: Integer): Integer;

//---------------------------------------------------------------------------
{ Returns the value that is biggest among the three. }
function Max3(a, b, c: Integer): Integer;

//---------------------------------------------------------------------------
{ Returns @True if the specified value is a power of two or @False otherwise. }
function IsPowerOfTwo(Value: Integer): Boolean;

//---------------------------------------------------------------------------
{ Returns the least power of two greater or equal to the specified value. }
function CeilPowerOfTwo(Value: Integer): Integer;

//---------------------------------------------------------------------------
{ Returns the greatest power of two lesser or equal to the specified value. }
function FloorPowerOfTwo(Value: Integer): Integer;

//---------------------------------------------------------------------------
implementation

//-----------------------------------------------------------------------------
uses
 SysUtils, Math;

//-----------------------------------------------------------------------------
function PointInRect(const Point: TPoint2px;
 const Rect: TRect): Boolean; overload;
begin
 Result:= (Point.x >= Rect.Left)and(Point.x <= Rect.Right)and
  (Point.y >= Rect.Top)and(Point.y <= Rect.Bottom);
end;

//---------------------------------------------------------------------------
{$ifndef Vec2ToPxImplicit}
function PointInRect(const Point: TPoint2;
 const Rect: TRect): Boolean; overload;
begin
 Result:= PointInRect(Vec2ToPx(Point), Rect);
end;
{$endif}

//---------------------------------------------------------------------------
function RectInRect(const Rect1, Rect2: TRect): Boolean;
begin
 Result:= (Rect1.Left >= Rect2.Left)and(Rect1.Right <= Rect2.Right)and
  (Rect1.Top >= Rect2.Top)and(Rect1.Bottom <= Rect2.Bottom);
end;

//---------------------------------------------------------------------------
function OverlapRect(const Rect1, Rect2: TRect): Boolean;
begin
 Result:= (Rect1.Left < Rect2.Right)and(Rect1.Right > Rect2.Left)and
  (Rect1.Top < Rect2.Bottom)and(Rect1.Bottom > Rect2.Top);
end;

//---------------------------------------------------------------------------
function PointInTriangle(const Pos, v1, v2, v3: TPoint2px): Boolean;
var
 Aux: Integer;
begin
 Aux:= (Pos.y - v2.y) * (v3.x - v2.x) - (Pos.x - v2.x) * (v3.y - v2.y);

 Result:= (Aux * ((Pos.y - v1.y) * (v2.x - v1.x) - (Pos.x - v1.x) *
  (v2.y - v1.y)) > 0)and(Aux * ((Pos.y - v3.y) * (v1.x - v3.x) - (Pos.x -
  v3.x) * (v1.y - v3.y)) > 0);
end;

//---------------------------------------------------------------------------
function Lerp(x0, x1, Theta: Single): Single;
begin
 Result:= x0 + (x1 - x0) * Theta;
end;

//---------------------------------------------------------------------------
function CatmullRom(x0, x1, x2, x3, Theta: Single): Single;
begin
 Result:= 0.5 * ((2.0 * x1) + Theta * (-x0 + x2 + Theta * (2.0 * x0 - 5.0 *
  x1 + 4.0 * x2 - x3 + Theta * (-x0 + 3.0 * x1 - 3.0 * x2 + x3))));
end;

//---------------------------------------------------------------------------
function MoveRect(const Rect: TRect; const Point: TPoint2px): TRect;
begin
 Result.Left  := Rect.Left   + Point.x;
 Result.Top   := Rect.Top    + Point.y;
 Result.Right := Rect.Right  + Point.x;
 Result.Bottom:= Rect.Bottom + Point.y;
end;

//---------------------------------------------------------------------------
function ShortRect(const Rect1, Rect2: TRect): TRect;
begin
 Result.Left  := Max2(Rect1.Left, Rect2.Left);
 Result.Top   := Max2(Rect1.Top, Rect2.Top);
 Result.Right := Min2(Rect1.Right, Rect2.Right);
 Result.Bottom:= Min2(Rect1.Bottom, Rect2.Bottom);
end;

//---------------------------------------------------------------------------
function ShrinkRect(const Rect: TRect; hIn, vIn: Integer): TRect;
begin
 Result.Left:= Rect.Left + hIn;
 Result.Top:= Rect.Top + vIn;
 Result.Right:= Rect.Right - hIn;
 Result.Bottom:= Rect.Bottom - vIn;
end;

//---------------------------------------------------------------------------
function MinMax2(Value, Min, Max: Integer): Integer;
{$ifdef AsmIntelX86}
{$ifdef fpc} assembler;{$endif}
asm // 32-bit assembly
 cmp eax, edx
 cmovl eax, edx
 cmp eax, ecx
 cmovg eax, ecx
end;
{$else !AsmIntelX86}
begin // native pascal code
 Result:= Value;
 if (Result < Min) then Result:= Min;
 if (Result > Max) then Result:= Max;
end;
{$endif AsmIntelX86}

//---------------------------------------------------------------------------
function Min2(a, b: Integer): Integer;
{$ifdef AsmIntelX86}
{$ifdef fpc} assembler;{$endif}
asm // 32-bit assembly
 cmp edx, eax
 cmovl eax, edx
end;
{$else !AsmIntelX86}
begin // native pascal code
 Result:= a;
 if (b < Result) then Result:= b;
end;
{$endif AsmIntelX86}

//---------------------------------------------------------------------------
function Max2(a, b: Integer): Integer;
{$ifdef AsmIntelX86}
{$ifdef fpc} assembler;{$endif}
asm // 32-bit assembly
 cmp edx, eax
 cmovg eax, edx
end;
{$else !AsmIntelX86}
begin // native pascal code
 Result:= a;
 if (b > Result) then Result:= b;
end;
{$endif AsmIntelX86}

//---------------------------------------------------------------------------
function Min3(a, b, c: Integer): Integer;
{$ifdef AsmIntelX86}
{$ifdef fpc} assembler;{$endif}
asm // 32-bit assembly
 cmp edx, eax
 cmovl eax, edx
 cmp ecx, eax
 cmovl eax, ecx
end;
{$else !AsmIntelX86}
begin // native pascal code
 Result:= a;
 if (b < Result) then Result:= b;
 if (c < Result) then Result:= c;
end;
{$endif AsmIntelX86}

//---------------------------------------------------------------------------
function Max3(a, b, c: Integer): Integer;
{$ifdef AsmIntelX86}
{$ifdef fpc} assembler;{$endif}
asm // 32-bit assembly
 cmp   edx, eax
 cmovg eax, edx
 cmp   ecx, eax
 cmovg eax, ecx
end;
{$else !AsmIntelX86}
begin // native pascal code
 Result:= a;
 if (b > Result) then Result:= b;
 if (c > Result) then Result:= c;
end;
{$endif AsmIntelX86}

//---------------------------------------------------------------------------
function IsPowerOfTwo(Value: Integer): Boolean;
begin
 Result:= (Value >= 1)and((Value and (Value - 1)) = 0);
end;

//---------------------------------------------------------------------------
function CeilPowerOfTwo(Value: Integer): Integer;
begin
 Result:= Round(Power(2.0, Ceil(Log2(Value))))
end;

//---------------------------------------------------------------------------
function FloorPowerOfTwo(Value: Integer): Integer;
begin
 Result:= Round(Power(2.0, Floor(Log2(Value))))
end;

//---------------------------------------------------------------------------
end.
