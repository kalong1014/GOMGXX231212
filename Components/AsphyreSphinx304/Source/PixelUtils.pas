unit PixelUtils;
//---------------------------------------------------------------------------
// PixelUtils.pas                                       Modified: 14-Sep-2012
// Utility routines for processing pixels and colors.            Version 1.01
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
// The Original Code is PixelUtils.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< Utility routines for processing, mixing and blending pixels (or colors). }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
{ Switches red and blue channels in 32-bit RGBA color value. }
function DisplaceRB(Color: Cardinal): Cardinal;

//---------------------------------------------------------------------------
{ Computes alpha-blending for a pair of 32-bit RGBA colors values.
  @italic(Alpha) can be in [0..255] range. }
function BlendPixels(Color1, Color2: Cardinal; Alpha: Integer): Cardinal;

//---------------------------------------------------------------------------
{ Computes alpha-blending for a pair of 32-bit RGBA colors values using
  floating-point approach. @italic(Alpha) can be in [0..1] range. For a
  faster alternative, use @link(BlendPixels). }
function LerpPixels(Color1, Color2: Cardinal; Alpha: Single): Cardinal;

//---------------------------------------------------------------------------
{ Computes the average of two given 32-bit RGBA color values. }
function AvgPixels(Color1, Color2: Cardinal): Cardinal;

//---------------------------------------------------------------------------
{ Computes the average of four given 32-bit RGBA color values. }
function AvgFourPixels(Color1, Color2, Color3, Color4: Cardinal): Cardinal;

//---------------------------------------------------------------------------
{ Computes the average of six given 32-bit RGBA color values. }
function AvgSixPixels(Color1, Color2, Color3, Color4, Color5,
 Color6: Cardinal): Cardinal;

//---------------------------------------------------------------------------
{ Adds two 32-bit RGBA color values together clamping the resulting values
  if necessary. }
function AddPixels(Color1, Color2: Cardinal): Cardinal;

//---------------------------------------------------------------------------
{ Multiplies two 32-bit RGBA color values together. }
function MulPixels(Color1, Color2: Cardinal): Cardinal;

//---------------------------------------------------------------------------
{ Multiplies alpha-channel of the given 32-bit RGBA color value by the
  given coefficient and divides the result by 255. }
function MulPixelAlpha(Color: Cardinal; Alpha: Integer): Cardinal; overload;

{ Multiplies alpha-channel of the given 32-bit RGBA color value by the
  given coefficient using floating-point approach. }
function MulPixelAlpha(Color: Cardinal; Alpha: Single): Cardinal; overload;

//---------------------------------------------------------------------------
{ Returns grayscale value in range of [0..255] from the given 32-bit RGBA
  color value. The alpha-channel is ignored. }
function PixelToGray(Pixel: Cardinal): Integer;

//---------------------------------------------------------------------------
{ Returns grayscale value in range of [0..1] from the given 32-bit RGBA
  color value. The resulting value can be considered the color's @italic(luma).
  The alpha-channel is ignored. }
function PixelToGrayEx(Pixel: Cardinal): Single;

//---------------------------------------------------------------------------
{ Extracts alpha-channel from two grayscale samples. The sample must be
  rendered with the same color on two different backgrounds, preferably on
  black and white; the resulting colors are provided in @italic(Src1) and
  @italic(Src2), with original backgrounds in @italic(Bk1) and @italic(Bk2).
  The resulting alpha-channel and original color are computed and returned.
  This method is particularly useful for calculating alpha-channel when
  rendering GDI fonts or in tools that generate resulting images without
  providing alpha-channel (therefore rendering the same image on two
  backgrounds is sufficient to calculate its alpha-channel). }
procedure ExtractAlpha(Src1, Src2, Bk1, Bk2: Single; out Alpha,
 Px: Single);

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreUtils;

//----------------------------------------------------------------------------
function DisplaceRB(Color: Cardinal): Cardinal;
begin
 Result:= ((Color and $FF) shl 16) or (Color and $FF00FF00) or
  ((Color shr 16) and $FF);
end;

//---------------------------------------------------------------------------
function BlendPixels(Color1, Color2: Cardinal; Alpha: Integer): Cardinal;
begin
 Result:=
  // Blue Component
  Cardinal(Integer(Color1 and $FF) + (((Integer(Color2 and $FF) -
  Integer(Color1 and $FF)) * Alpha) div 255)) or

  // Green Component
  (Cardinal(Integer((Color1 shr 8) and $FF) +
  (((Integer((Color2 shr 8) and $FF) - Integer((Color1 shr 8) and $FF)) *
  Alpha) div 255)) shl 8) or

  // Red Component
  (Cardinal(Integer((Color1 shr 16) and $FF) +
  (((Integer((Color2 shr 16) and $FF) - Integer((Color1 shr 16) and $FF)) *
  Alpha) div 255)) shl 16) or

  // Alpha Component
  (Cardinal(Integer((Color1 shr 24) and $FF) +
  (((Integer((Color2 shr 24) and $FF) - Integer((Color1 shr 24) and $FF)) *
  Alpha) div 255)) shl 24);
end;

//---------------------------------------------------------------------------
function LerpPixels(Color1, Color2: Cardinal; Alpha: Single): Cardinal;
begin
 Result:=
  // Blue component
  Cardinal(Integer(Color1 and $FF) + Round((Integer(Color2 and $FF) -
  Integer(Color1 and $FF)) * Alpha)) or

  // Green component
  (Cardinal(Integer((Color1 shr 8) and $FF) +
  Round((Integer((Color2 shr 8) and $FF) - Integer((Color1 shr 8) and $FF)) *
  Alpha)) shl 8) or

  // Red component
  (Cardinal(Integer((Color1 shr 16) and $FF) +
  Round((Integer((Color2 shr 16) and $FF) - Integer((Color1 shr 16) and $FF)) *
  Alpha)) shl 16) or

  // Alpha component
  (Cardinal(Integer((Color1 shr 24) and $FF) +
  Round((Integer((Color2 shr 24) and $FF) - Integer((Color1 shr 24) and $FF)) *
  Alpha)) shl 24);
end;

//---------------------------------------------------------------------------
function AvgPixels(Color1, Color2: Cardinal): Cardinal;
begin
 Result:=
  // Blue component
  (((Color1 and $FF) + (Color2 and $FF)) div 2) or

  // Green component
  (((((Color1 shr 8) and $FF) + ((Color2 shr 8) and $FF)) div 2) shl 8) or

  // Red component
  (((((Color1 shr 16) and $FF) + ((Color2 shr 16) and $FF)) div 2) shl 16) or

  // Alpha component
  (((((Color1 shr 24) and $FF) + ((Color2 shr 24) and $FF)) div 2) shl 24);
end;

//---------------------------------------------------------------------------
function AvgFourPixels(Color1, Color2, Color3, Color4: Cardinal): Cardinal;
begin
 Result:=
  // Blue component
  (((Color1 and $FF) + (Color2 and $FF) + (Color3 and $FF) +
  (Color4 and $FF)) div 4) or

  // Green component
  (((((Color1 shr 8) and $FF) + ((Color2 shr 8) and $FF) +
  ((Color3 shr 8) and $FF) + ((Color4 shr 8) and $FF)) div 4) shl 8) or

  // Red component
  (((((Color1 shr 16) and $FF) + ((Color2 shr 16) and $FF) +
  ((Color3 shr 16) and $FF) + ((Color4 shr 16) and $FF)) div 4) shl 16) or

  // Alpha component
  (((((Color1 shr 24) and $FF) + ((Color2 shr 24) and $FF) +
  ((Color3 shr 24) and $FF) + ((Color4 shr 24) and $FF)) div 4) shl 24);
end;

//---------------------------------------------------------------------------
function AvgSixPixels(Color1, Color2, Color3, Color4, Color5,
 Color6: Cardinal): Cardinal;
begin
 Result:=
  // Blue component
  (((Color1 and $FF) + (Color2 and $FF) + (Color3 and $FF) +
  (Color4 and $FF) + (Color5 and $FF) + (Color6 and $FF)) div 6) or

  // Green component
  (((((Color1 shr 8) and $FF) + ((Color2 shr 8) and $FF) +
  ((Color3 shr 8) and $FF) + ((Color4 shr 8) and $FF) +
  ((Color5 shr 8) and $FF) + ((Color6 shr 8) and $FF)) div 6) shl 8) or

  // Red component
  (((((Color1 shr 16) and $FF) + ((Color2 shr 16) and $FF) +
  ((Color3 shr 16) and $FF) + ((Color4 shr 16) and $FF) +
  ((Color5 shr 16) and $FF) + ((Color6 shr 16) and $FF)) div 6) shl 16) or

  // Alpha component
  (((((Color1 shr 24) and $FF) + ((Color2 shr 24) and $FF) +
  ((Color3 shr 24) and $FF) + ((Color4 shr 24) and $FF) +
  ((Color5 shr 24) and $FF) + ((Color6 shr 24) and $FF)) div 6) shl 24);
end;

//---------------------------------------------------------------------------
function AddPixels(Color1, Color2: Cardinal): Cardinal;
begin
 Result:=
  // Blue Component
  Cardinal(Min2(Integer(Color1 and $FF) + Integer(Color2 and $FF), 255)) or

  // Green Component
  (Cardinal(Min2(Integer((Color1 shr 8) and $FF) +
   Integer((Color2 shr 8) and $FF), 255)) shl 8) or

  // Blue Component
  (Cardinal(Min2(Integer((Color1 shr 16) and $FF) +
   Integer((Color2 shr 16) and $FF), 255)) shl 16) or

  // Alpha Component
  (Cardinal(Min2(Integer((Color1 shr 24) and $FF) +
   Integer((Color2 shr 24) and $FF), 255)) shl 24);
end;

//---------------------------------------------------------------------------
function MulPixels(Color1, Color2: Cardinal): Cardinal;
begin
 Result:=
  // Blue Component
  Cardinal((Integer(Color1 and $FF) * Integer(Color2 and $FF)) div 255) or

  // Green Component
  (Cardinal((Integer((Color1 shr 8) and $FF) *
   Integer((Color2 shr 8) and $FF)) div 255) shl 8) or

  // Blue Component
  (Cardinal((Integer((Color1 shr 16) and $FF) *
   Integer((Color2 shr 16) and $FF)) div 255) shl 16) or

  // Alpha Component
  (Cardinal((Integer((Color1 shr 24) and $FF) *
   Integer((Color2 shr 24) and $FF)) div 255) shl 24);
end;

//---------------------------------------------------------------------------
function MulPixelAlpha(Color: Cardinal; Alpha: Integer): Cardinal; overload;
begin
 Result:= (Color and $00FFFFFF) or
  Cardinal((Integer(Color shr 24) * Alpha) div 255) shl 24;
end;

//---------------------------------------------------------------------------
function MulPixelAlpha(Color: Cardinal; Alpha: Single): Cardinal; overload;
begin
 Result:= (Color and $00FFFFFF) or
  Cardinal(Round(Integer(Color shr 24) * Alpha)) shl 24;
end;

//---------------------------------------------------------------------------
function PixelToGray(Pixel: Cardinal): Integer;
begin
 Result:=
  ((Integer(Pixel and $FF) * 5) +
  (Integer((Pixel shr 8) and $FF) * 8) +
  (Integer((Pixel shr 16) and $FF) * 3)) div 16;
end;

//---------------------------------------------------------------------------
function PixelToGrayEx(Pixel: Cardinal): Single;
begin
 Result:= ((Pixel and $FF) * 0.3 + ((Pixel shr 8) and $FF) * 0.59 +
  ((Pixel shr 16) and $FF) * 0.11) / 255.0;
end;

//---------------------------------------------------------------------------
procedure ExtractAlpha(Src1, Src2, Bk1, Bk2: Single; out Alpha,
 Px: Single);
begin
 Alpha:= (1.0 - (Src2 - Src1)) / (Bk2 - Bk1);

 Px:= Src1;

 if (Alpha > 0.0) then
  Px:= (Src1 - (1.0 - Alpha) * Bk1) / Alpha;
end;

//---------------------------------------------------------------------------
end.
