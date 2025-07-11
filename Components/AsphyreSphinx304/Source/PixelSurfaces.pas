unit PixelSurfaces;
//---------------------------------------------------------------------------
// PixelSurfaces.pas                                    Modified: 14-Sep-2012
// Flexible image processing class.                               Version 1.0
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
// The Original Code is PixelSurfaces.pas.
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
 SysUtils, AsphyreDef, AsphyreTypes;

//---------------------------------------------------------------------------
type
 TPixelSurfaces = class;

//---------------------------------------------------------------------------
 TPixelSurface = class
 private
  FMipMaps: TPixelSurfaces;

  FName  : StdString;
  FBits  : Pointer;
  FPitch : Integer;
  FWidth : Integer;
  FHeight: Integer;
  FPixelFormat: TAsphyrePixelFormat;
  FBytesPerPixel: Integer;

  function GetScanline(Index: Integer): Pointer;
  function GetPixel(x, y: Integer): Cardinal;
  procedure SetPixel(x, y: Integer; const Value: Cardinal);
 public
  property Name: StdString read FName;

  property Bits : Pointer read FBits;
  property Pitch: Integer read FPitch;

  property Width : Integer read FWidth;
  property Height: Integer read FHeight;

  property PixelFormat: TAsphyrePixelFormat read FPixelFormat;

  property Scanline[Index: Integer]: Pointer read GetScanline;
  property Pixels[x, y: Integer]: Cardinal read GetPixel write SetPixel;

  property BytesPerPixel: Integer read FBytesPerPixel;

  property MipMaps: TPixelSurfaces read FMipMaps;

  function GetPixelPtr(x, y: Integer): Pointer;

  procedure SetSize(AWidth, AHeight: Integer;
   APixelFormat: TAsphyrePixelFormat = apf_Unknown;
   ABytesPerPixel: Integer = 0);

  function ConvertPixelFormat(NewFormat: TAsphyrePixelFormat): Boolean;

  procedure CopyFrom(Source: TPixelSurface);

  procedure Clear(Color: Cardinal);
  procedure ResetAlpha();

  function HasAlphaChannel(): Boolean;
  function Shrink2xFrom(Source: TPixelSurface): Boolean;

  procedure GenerateMipMaps();
  procedure RemoveMipMaps();

  constructor Create(const AName: StdString = '');
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 TPixelSurfaces = class
 private
  Data: array of TPixelSurface;

  function GetCount(): Integer;
  function GetItem(Index: Integer): TPixelSurface;
 public
  property Count: Integer read GetCount;
  property Items[Index: Integer]: TPixelSurface read GetItem; default;

  function Add(const AName: StdString = ''): Integer;
  procedure Remove(Index: Integer);
  procedure RemoveAll();

  function IndexOf(const AName: StdString): Integer;

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreUtils, AsphyreConv, PixelUtils;

//---------------------------------------------------------------------------
constructor TPixelSurface.Create(const AName: StdString = '');
begin
 inherited Create();

 FMipMaps:= TPixelSurfaces.Create();
 FName:= AName;

 FBits  := nil;
 FPitch := 0;
 FWidth := 0;
 FHeight:= 0;

 FPixelFormat:= apf_Unknown;
 FBytesPerPixel:= 0;
end;

//---------------------------------------------------------------------------
destructor TPixelSurface.Destroy();
begin
 if (Assigned(FBits)) then FreeNullMem(FBits);
 FreeAndNil(FMipMaps);

 inherited;
end;

//---------------------------------------------------------------------------
function TPixelSurface.GetScanline(Index: Integer): Pointer;
begin
 if (Index >= 0)and(Index < FHeight) then
  Result:= Pointer(PtrInt(FBits) + (PtrInt(FPitch) * Index)) else Result:= nil;
end;

//---------------------------------------------------------------------------
function TPixelSurface.GetPixel(x, y: Integer): Cardinal;
var
 SrcPtr: Pointer;
begin
 if (x < 0)or(y < 0)or(x >= FWidth)or(y >= FHeight)or
  (FPixelFormat = apf_Unknown) then
  begin
   Result:= 0;
   Exit;
  end;

 SrcPtr:= Pointer(PtrInt(FBits) + (PtrInt(FPitch) * y) + ((PtrInt(x) *
  AsphyrePixelFormatBits[FPixelFormat]) div 8));

 Result:= PixelXto32(SrcPtr, FPixelFormat);
end;

//---------------------------------------------------------------------------
procedure TPixelSurface.SetPixel(x, y: Integer; const Value: Cardinal);
var
 DestPtr: Pointer;
begin
 if (x < 0)or(y < 0)or(x >= FWidth)or(y >= FHeight)or
  (FPixelFormat = apf_Unknown) then Exit;

 DestPtr:= Pointer(PtrInt(FBits) + (PtrInt(FPitch) * y) + ((PtrInt(x) *
  AsphyrePixelFormatBits[FPixelFormat]) div 8));

 Pixel32toX(Value, DestPtr, FPixelFormat);
end;

//---------------------------------------------------------------------------
function TPixelSurface.GetPixelPtr(x, y: Integer): Pointer;
begin
 if (x < 0)or(y < 0)or(x >= FWidth)or(y >= FHeight) then
  begin
   Result:= nil;
   Exit;
  end;

 if (FPixelFormat <> apf_Unknown) then
  begin
   Result:= Pointer(PtrInt(FBits) + (PtrInt(FPitch) * y) + ((PtrInt(x) *
    AsphyrePixelFormatBits[FPixelFormat]) div 8));
  end else
  begin
   Result:= Pointer(PtrInt(FBits) + (PtrInt(FPitch) * y) + (PtrInt(x) *
    FBytesPerPixel));
  end;
end;

//---------------------------------------------------------------------------
procedure TPixelSurface.SetSize(AWidth, AHeight: Integer;
 APixelFormat: TAsphyrePixelFormat = apf_Unknown;
 ABytesPerPixel: Integer = 0);
var
 NewSize: Integer;
begin
 FPixelFormat  := APixelFormat;
 FBytesPerPixel:= Max2(ABytesPerPixel, 0);

 if (FPixelFormat = apf_Unknown)and(FBytesPerPixel < 1) then
  FPixelFormat:= apf_A8R8G8B8;

 FWidth := Max2(AWidth, 0);
 FHeight:= Max2(AHeight, 0);

 if (FPixelFormat <> apf_Unknown) then
  begin
   FPitch := (FWidth * AsphyrePixelFormatBits[FPixelFormat]) div 8;
   NewSize:= (FWidth * FHeight * AsphyrePixelFormatBits[FPixelFormat]) div 8;

   FBytesPerPixel:= AsphyrePixelFormatBits[FPixelFormat] div 8;
  end else
  begin
   FPitch := FWidth * FBytesPerPixel;
   NewSize:= FWidth * FHeight * FBytesPerPixel;
  end;

 ReallocMem(FBits, NewSize);
 FillChar(FBits^, NewSize, 0);
end;

//---------------------------------------------------------------------------
function TPixelSurface.ConvertPixelFormat(
 NewFormat: TAsphyrePixelFormat): Boolean;
var
 NewBits, TempBits: Pointer;
 NewSize: Integer;
begin
 Result:= (FPixelFormat <> apf_Unknown)and(NewFormat <> apf_Unknown);
 if (not Result) then Exit;

 FBytesPerPixel:= AsphyrePixelFormatBits[NewFormat] div 8;

 if (FWidth < 1)or(FHeight < 1)or(not Assigned(FBits)) then
  begin
   FPixelFormat:= NewFormat;
   Exit;
  end;

 NewSize:= (FWidth * FHeight * AsphyrePixelFormatBits[NewFormat]) div 8;
 NewBits:= AllocMem(NewSize);

 if (FPixelFormat = apf_A8R8G8B8) then
  begin // Source is 32-bit ARGB.
   Pixel32toXArray(FBits, NewBits, NewFormat, FWidth * FHeight);
  end else
 if (NewFormat = apf_A8R8G8B8) then
  begin // Destination is 32-bit ARGB.
   PixelXto32Array(FBits, NewBits, FPixelFormat, FWidth * FHeight);
  end else
  begin // Source and Destination are NOT 32-bit ARGB.
   TempBits:= AllocMem(FWidth * FHeight * 4);

   PixelXto32Array(FBits, TempBits, FPixelFormat, FWidth * FHeight);
   Pixel32toXArray(TempBits, NewBits, NewFormat, FWidth * FHeight);

   FreeNullMem(TempBits);
  end;

 FreeNullMem(FBits);

 FPixelFormat:= NewFormat;

 FBits := NewBits;
 FPitch:= (FWidth * AsphyrePixelFormatBits[FPixelFormat]) div 8;
end;

//---------------------------------------------------------------------------
procedure TPixelSurface.CopyFrom(Source: TPixelSurface);
begin
 if (FPixelFormat <> Source.PixelFormat)or(FWidth <> Source.Width)or
  (FHeight <> Source.Height)or(FBytesPerPixel <> Source.BytesPerPixel) then
  SetSize(Source.Width, Source.Height, Source.PixelFormat,
   Source.BytesPerPixel);

 Move(Source.Bits^, FBits^, FHeight * FPitch);
end;

//---------------------------------------------------------------------------
procedure TPixelSurface.Clear(Color: Cardinal);
var
 i: Integer;
 DestPtr: Pointer;
begin
 if (FWidth < 1)or(FHeight < 1)or(not Assigned(FBits)) then Exit;

 if (FPixelFormat = apf_Unknown) then
  begin
   FillChar(FBits^, FHeight * FPitch, Color and $FF);
   Exit;
  end;

 for i:= 0 to (FWidth * FHeight) - 1 do
  begin
   DestPtr:= Pointer(PtrInt(FBits) + ((PtrInt(i) *
    AsphyrePixelFormatBits[FPixelFormat]) div 8));

   Pixel32toX(Color, DestPtr, FPixelFormat);
  end;
end;

//---------------------------------------------------------------------------
procedure TPixelSurface.ResetAlpha();
var
 i, j  : Integer;
 PixPtr: Pointer;
 Value : Cardinal;
begin
 if (FWidth < 1)or(FHeight < 1)or(not Assigned(FBits))or
  (FPixelFormat = apf_Unknown) then Exit;

 for j:= 0 to FHeight - 1 do
  for i:= 0 to FWidth - 1 do
   begin
    PixPtr:= Pointer(PtrInt(FBits) + FPitch * j + ((i *
     AsphyrePixelFormatBits[FPixelFormat]) div 8));

    Value:= PixelXto32(PixPtr, FPixelFormat);
    Pixel32toX(Value or $FF000000, PixPtr, FPixelFormat);
   end;
end;

//---------------------------------------------------------------------------
function TPixelSurface.HasAlphaChannel(): Boolean;
var
 i, j  : Integer;
 SrcPtr: Pointer;
 Value : Cardinal;
begin
 if (FWidth < 1)or(FHeight < 1)or(not Assigned(FBits))or
  (FPixelFormat = apf_Unknown) then
  begin
   Result:= False;
   Exit;
  end;

 for j:= 0 to FHeight - 1 do
  for i:= 0 to FWidth - 1 do
   begin
    SrcPtr:= Pointer(PtrInt(FBits) + FPitch * j + ((i *
     AsphyrePixelFormatBits[FPixelFormat]) div 8));

    Value:= PixelXto32(SrcPtr, FPixelFormat);
    if (Value and $FF000000 > 0) then
     begin
      Result:= True;
      Exit;
     end;
   end;

 Result:= False;
end;

//---------------------------------------------------------------------------
function TPixelSurface.Shrink2xFrom(Source: TPixelSurface): Boolean;
var
 i, j: Integer;
begin
 Result:= (Source.PixelFormat <> apf_Unknown)and(Source.Width > 1)and
  (Source.Height > 1);
 if (not Result) then Exit;

 if (FWidth <> Source.Width div 2)or(FHeight <> Source.Height div 2)or
  (FPixelFormat <> Source.PixelFormat) then
  SetSize(Source.Width div 2, Source.Height div 2, Source.PixelFormat);

 for j:= 0 to FHeight - 1 do
  for i:= 0 to FWidth - 1 do
   begin
    SetPixel(i, j, AvgFourPixels(Source.GetPixel(i * 2, j * 2),
     Source.GetPixel((i * 2) + 1, j * 2), Source.GetPixel(i * 2, (j * 2) + 1),
     Source.GetPixel((i * 2) + 1, (j * 2) + 1)));
   end;
end;

//---------------------------------------------------------------------------
procedure TPixelSurface.GenerateMipMaps();
var
 Source, Dest: TPixelSurface;
 NewIndex: Integer;
begin
 FMipMaps.RemoveAll();

 Source:= Self;
 while (Source.Width > 1)and(Source.Height > 1)and
  (Source.PixelFormat <> apf_Unknown) do
  begin
   NewIndex:= FMipMaps.Add();

   Dest:= FMipMaps[NewIndex];
   if (not Assigned(Dest)) then Break;

   Dest.Shrink2xFrom(Source);
   Source:= Dest;
  end;
end;

//---------------------------------------------------------------------------
procedure TPixelSurface.RemoveMipMaps();
begin
 FMipMaps.RemoveAll();
end;

//---------------------------------------------------------------------------
constructor TPixelSurfaces.Create();
begin
 inherited;

end;

//---------------------------------------------------------------------------
destructor TPixelSurfaces.Destroy();
begin
 RemoveAll();

 inherited;
end;

//---------------------------------------------------------------------------
function TPixelSurfaces.GetCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TPixelSurfaces.GetItem(Index: Integer): TPixelSurface;
begin
 if (Index >= 0)and(Index < Length(Data)) then
  Result:= Data[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TPixelSurfaces.Add(const AName: StdString = ''): Integer;
begin
 Result:= Length(Data);
 SetLength(Data, Result + 1);

 Data[Result]:= TPixelSurface.Create(AName);
end;

//---------------------------------------------------------------------------
procedure TPixelSurfaces.Remove(Index: Integer);
var
 i: Integer;
begin
 if (Index < 0)or(Index >= Length(Data)) then Exit;

 FreeAndNil(Data[Index]);

 for i:= Index to Length(Data) - 2 do
  Data[i]:= Data[i + 1];

 SetLength(Data, Length(Data) - 1);
end;

//---------------------------------------------------------------------------
procedure TPixelSurfaces.RemoveAll();
var
 i: Integer;
begin
 for i:= Length(Data) - 1 downto 0 do
  FreeAndNil(Data[i]);

 SetLength(Data, 0);
end;

//---------------------------------------------------------------------------
function TPixelSurfaces.IndexOf(const AName: StdString): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to Length(Data) - 1 do
  if (SameText(AName, Data[i].Name)) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
end.
