unit FontLetterGroups;
//---------------------------------------------------------------------------
// FontLetterGroups.pas                                 Modified: 14-Sep-2012
// 2-letter displacement combination holder.                     Version 1.02
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
// The Original Code is FontLetterGroups.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< Classes that facilitate the specification of individual letter spacing
   for Asphyre fonts for pixel-perfect text rendering. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
uses
 SysUtils, AsphyreDef, Vectors2px, HelperSets;

//---------------------------------------------------------------------------
type
{ The hashed list of individual letter spacings used in Asphyre fonts for
  pixel-perfect text rendering. The list stores values between ANSI letters
  quickly using hash table; for Unicode characters a linear list is used. }
 TFontLetterGroups = class
 private
  HashArray: packed array[0..255, 0..255] of Shortint;
  ExtArray : TPointList;

  function GetShift(Code1, Code2: Integer): Integer;
 public
  { Returns the spacing between two given character codes. If there is no
    registry for the given combination of characters, zero is returned. }
  property Shift[Code1, Code2: Integer]: Integer read GetShift; default;

  { Modifies the spacing value for the given pair of character codes. If the
    registry for this combination of characters does not exist, it will be
    created; it if does exist, it will be replaced by the spacing value. }
  procedure Spec(Code1, Code2, AShift: Integer); overload;

  { Modifies the spacing value for the given pair of ANSI character codes. If
    the registry for this combination of characters does not exist, it will be
    created; it if does exist, it will be replaced by the spacing value. }
  procedure Spec(Code1, Code2: AnsiChar; AShift: Integer); overload;

  { Copies the spacing information from the given list of 2D integer points,
    where @code(X) and @code(Y) are considered character codes and @code(Data)
    field as integer representation of spacing between the given characters.
    The existing registry entries in the current list are not deleted, but
    replaced when needed. }
  procedure CopyFrom(Source: TPointList);

  {@exclude}constructor Create();
  {@exclude}destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreUtils;

//---------------------------------------------------------------------------
constructor TFontLetterGroups.Create();
begin
 inherited;

 ExtArray:= TPointList.Create();

 FillChar(HashArray, SizeOf(HashArray), 0);
end;

//---------------------------------------------------------------------------
destructor TFontLetterGroups.Destroy();
begin
 FreeAndNil(ExtArray);

 inherited;
end;

//---------------------------------------------------------------------------
procedure TFontLetterGroups.Spec(Code1, Code2, AShift: Integer);
var
 Pos: TPoint2px;
 Index: Integer;
begin
 if (Code1 < 0)or(Code2 < 0) then Exit;

 AShift:= MinMax2(AShift, -128, 127);

 if (Code1 <= 255)and(Code2 <= 255) then
  begin
   HashArray[Code1, Code2]:= AShift;
   Exit;
  end;

 Pos.x:= Code1;
 Pos.y:= Code2;

 Index:= ExtArray.IndexOf(Pos);
 if (Index = -1) then Index:= ExtArray.Insert(Pos);

 ExtArray[Index].Data:= Pointer(AShift);
end;

//---------------------------------------------------------------------------
function TFontLetterGroups.GetShift(Code1, Code2: Integer): Integer;
var
 Index: Integer;
begin
 Result:= 0;
 if (Code1 < 0)or(Code2 < 0) then Exit;

 if (Code1 <= 255)and(Code2 <= 255) then
  begin
   Result:= HashArray[Code1, Code2];
   Exit;
  end;

 Index:= ExtArray.IndexOf(Point2px(Code1, Code2));

 if (Index <> -1) then
  Result:= PtrInt(ExtArray[Index].Data);
end;

//---------------------------------------------------------------------------
procedure TFontLetterGroups.Spec(Code1, Code2: AnsiChar; AShift: Integer);
begin
 Spec(Integer(Code1), Integer(Code2), AShift);
end;

//---------------------------------------------------------------------------
procedure TFontLetterGroups.CopyFrom(Source: TPointList);
var
 i: Integer;
 Holder: PPointHolder;
begin
 for i:= 0 to Source.Count - 1 do
  begin
   Holder:= Source.Item[i];
   if (not Assigned(Holder)) then Continue;

   Spec(Holder.Point.x, Holder.Point.y, PtrInt(Holder.Data));
  end;
end;

//---------------------------------------------------------------------------
end.
