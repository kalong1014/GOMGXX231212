unit StreamUtils;
//---------------------------------------------------------------------------
// StreamUtils.pas                                      Modified: 14-Sep-2012
// Utility routines for handling simple data types in streams.   Version 1.05
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
// The Original Code is StreamUtils.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< Utility routines for saving and loading different data type in streams. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
uses
 Classes, AsphyreDef, Vectors2px;

//---------------------------------------------------------------------------
{ Saves 8-bit unsigned integer to the stream. If the value is outside of
  [0..255] range, it will be clamped. }
procedure StreamPutByte(Stream: TStream; Value: Cardinal);

{ Loads 8-bit unsigned integer from the stream. }
function StreamGetByte(Stream: TStream): Cardinal;

//---------------------------------------------------------------------------
{ Saves 16-bit unsigned integer to the stream. If the value is outside of
  [0..65535] range, it will be clamped. }
procedure StreamPutWord(Stream: TStream; Value: Cardinal);

{ Loads 16-bit unsigned integer value from the stream. }
function StreamGetWord(Stream: TStream): Cardinal;

//---------------------------------------------------------------------------
{ Saves 32-bit unsigned integer to the stream. }
procedure StreamPutLongWord(Stream: TStream; Value: Cardinal);

{ Loads 32-bit unsigned integer from the stream. }
function StreamGetLongWord(Stream: TStream): Cardinal;

//---------------------------------------------------------------------------
{ Saves 8-bit signed integer to the stream. If the value is outside of
  [-128..127] range, it will be clamped. }
procedure StreamPutShortInt(Stream: TStream; Value: Integer);

{ Loads 8-bit signed integer from the stream. }
function StreamGetShortInt(Stream: TStream): Integer;

//---------------------------------------------------------------------------
{ Saves 16-bit signed integer to the stream. If the value is outside of
  [-32768..32767] range, it will be clamped. }
procedure StreamPutSmallInt(Stream: TStream; Value: Integer);

{ Loads 16-bit signed integer from the stream. }
function StreamGetSmallInt(Stream: TStream): Integer;

//---------------------------------------------------------------------------
{ Saves 32-bit signed integer to the stream. }
procedure StreamPutLongInt(Stream: TStream; Value: Integer);

{ Loads 32-bit signed integer from the stream. }
function StreamGetLongInt(Stream: TStream): Integer;

//---------------------------------------------------------------------------
{ Saves 64-bit signed integer to the stream. }
procedure StreamPutInt64(Stream: TStream; const Value: Int64);

{ Loads 64-bit signed integer from the stream. }
function StreamGetInt64(Stream: TStream): Int64;

//---------------------------------------------------------------------------
{ Saves 64-bit unsigned integer to the stream. }
procedure StreamPutUInt64(Stream: TStream; const Value: UInt64);

{ Loads 64-bit unsigned integer from the stream. }
function StreamGetUInt64(Stream: TStream): UInt64;

//---------------------------------------------------------------------------
{ Saves @bold(Boolean) value to the stream as 8-bit unsigned integer. A value
  of @False is saved as 255, while @True is saved as 0. }
procedure StreamPutBool(Stream: TStream; Value: Boolean);

{ Loads @bold(Boolean) value from the stream previously saved by
  @link(StreamPutBool). The resulting value is treated as 8-bit unsigned
  integer with values of [0..127] considered as @True and values of
  [128..255] considered as @False. }
function StreamGetBool(Stream: TStream): Boolean;

//---------------------------------------------------------------------------
{ Saves 8-bit unsigned index to the stream. A value of -1 (and other
  negative values) is stored as 255. Positive numbers that are outside of
  [0..254] range will be clamped. }
procedure StreamPutByteIndex(Stream: TStream; Value: Integer);

{ Loads 8-bit unsigned index from the stream. The range of returned values is
  [0..254], the value of 255 is returned as -1. }
function StreamGetByteIndex(Stream: TStream): Integer;

//---------------------------------------------------------------------------
{ Saves 16-bit unsigned index to the stream. A value of -1 (and other
  negative values) is stored as 65535. Positive numbers that are outside of
  [0..65534] range will be clamped. }
procedure StreamPutWordIndex(Stream: TStream; Value: Integer);

{ Loads 16-bit unsigned index from the stream. The range of returned values is
  [0..65534], the value of 65535 is returned as -1. }
function StreamGetWordIndex(Stream: TStream): Integer;

//---------------------------------------------------------------------------
{ Saves 2D integer point to the stream. Each coordinate is saved as 32-bit
  signed integer. }
procedure StreamPutLongPoint2px(Stream: TStream; const Vec: TPoint2px);

{ Loads 2D integer point from the stream. Each coordinate is loaded as 32-bit
  signed integer.}
function StreamGetLongPoint2px(Stream: TStream): TPoint2px;

//---------------------------------------------------------------------------
{ Saves 2D integer point to the stream. Each coordinate is saved as 16-bit
  unsigned integer with values outside of [0..65534] range clamped. Each
  coordinate values equalling to those of @link(InfPoint2px) will be saved
  as 65535. }
procedure StreamPutWordPoint2px(Stream: TStream; const Vec: TPoint2px);

{ Loads 2D integer point from the stream. Each coordinate is loaded as 16-bit
  unsigned integer with values in range of [0..65534]. The loaded values of
  65535 are returned equalling to those from @link(InfPoint2px). }
function StreamGetWordPoint2px(Stream: TStream): TPoint2px;

//---------------------------------------------------------------------------
{ Saves 2D integer point to the stream. Each coordinate is saved as 8-bit
  unsigned integer with values outside of [0..254] range clamped. Each
  coordinate values equalling to those of @link(InfPoint2px) will be saved
  as 255. }
procedure StreamPutBytePoint2px(Stream: TStream; const Vec: TPoint2px);

{ Loads 2D integer point from the stream. Each coordinate is loaded as 8-bit
  unsigned integer with values in range of [0..254]. The loaded values of
  255 are returned equalling to those from @link(InfPoint2px). }
function StreamGetBytePoint2px(Stream: TStream): TPoint2px;

//---------------------------------------------------------------------------
{ Saves 32-bit floating-point value (single-precision) to the stream. }
procedure StreamPutSingle(Stream: TStream; Value: Single);

{ Loads 32-bit floating-point value (single-precision) from the stream. }
function StreamGetSingle(Stream: TStream): Single;

//---------------------------------------------------------------------------
{ Saves 64-bit floating-point value (double-precision) to the stream. }
procedure StreamPutDouble(Stream: TStream; Value: Double);

{ Loads 64-bit floating-point value (double-precision) from the stream. }
function StreamGetDouble(Stream: TStream): Double;

//---------------------------------------------------------------------------
{ Saves floating-point value as 8-bit signed byte to the stream using 1:3:4
  fixed-point format with values outside of [-8..7.9375] range will be
  clamped.  }
procedure StreamPutFloat34(Stream: TStream; Value: Single);

{ Loads floating-point value as 8-bit signed byte from the stream using 1:3:4
  fixed-point format. The possible values are in [-8..7.9375] range.  }
function StreamGetFloat34(Stream: TStream): Single;

//---------------------------------------------------------------------------
{ Saves floating-point value as 8-bit signed byte to the stream using 1:4:3
  fixed-point format with values outside of [-16..15.875] range will be
  clamped.  }
procedure StreamPutFloat43(Stream: TStream; Value: Single);

{ Loads floating-point value as 8-bit signed byte from the stream using 1:4:3
  fixed-point format. The possible values are in [-16..15.875] range.  }
function StreamGetFloat43(Stream: TStream): Single;

//---------------------------------------------------------------------------
{ Saves two floating-point values as a single 8-bit unsigned byte to the
  stream with each value having 4-bits. Values outside of [-8..7] range will be
  clamped. }
procedure StreamPutFloats44(Stream: TStream; Value1, Value2: Single);

{ Loads two floating-point values as a single 8-bit unsigned byte from the
  stream with each value having 4-bits. The possible values are in [-8..7]
  range. }
procedure StreamGetFloats44(Stream: TStream; out Value1,
 Value2: Single);

//---------------------------------------------------------------------------
{ Saves two floating-point values as a single 8-bit unsigned byte to the
  stream with each value stored in fixed-point 1:2:1 format. Values outside of
  [-4..3.5] range will be clamped. }
procedure StreamPutFloats3311(Stream: TStream; Value1, Value2: Single);

{ Loads two floating-point values as a single 8-bit unsigned byte from the
  stream with each value stored in fixed-point 1:2:1 format. The possible
  values are in [-4..3.5] range. }
procedure StreamGetFloats3311(Stream: TStream; out Value1, Value2: Single);

//---------------------------------------------------------------------------
{ Saves @bold(ShortString) to the stream. If @italic(MaxCount) is not zero,
  the string will be limited to a certain number of characters. }
procedure StreamPutShortString(Stream: TStream; const Text: ShortString;
 MaxCount: Integer = 0);

{ Loads @bold(ShortString) from the stream. }
function StreamGetShortString(Stream: TStream): ShortString;

 //---------------------------------------------------------------------------
{ Saves @bold(AnsiString) (non-unicode, ansi) to the stream. No restrictions
  are applied to the string, so up to 2 Gb of data can be saved this way.
  This is most useful when the string contains binary data or very long
  text. For a more restricted and limited approach, use
  @link(StreamPutAnsiString). }
procedure StreamPutAnsi4String(Stream: TStream; const Value: AnsiString);

{ Loads @bold(AnsiString) (non-unicode, ansi) from the stream previously saved
  by @link(StreamPutAnsi4String). }
function StreamGetAnsi4String(Stream: TStream): AnsiString;

//---------------------------------------------------------------------------
{ Saves @bold(AnsiString) (non-unicode, ansi) to the stream. The string is
  limited to a maximum of 65535 characters. If @italic(MaxCount) is not zero,
  the string will be limited to the given number of characters. }
procedure StreamPutAnsiString(Stream: TStream; const Text: AnsiString;
 MaxCount: Integer = 0);

{ Loads @bold(AnsiString) (non-unicode, ansi) from the stream previously saved
  by @link(StreamPutAnsiString). The returned string can contain up to 65535
  characters. }
function StreamGetAnsiString(Stream: TStream): AnsiString;

//---------------------------------------------------------------------------
{ Saves @bold(UniString) (Unicode) to the stream in UTF-8 encoding. The
  resulting UTF-8 string is limited to a maximum of 65535 characters;
  therefore, for certain charsets the actual string is limited to either
  32767 or even 21845 characters in worst case. If @italic(MaxCount) is not
  zero, the input string will be limited to the given number of characters. }
procedure StreamPutUtf8String(Stream: TStream; const Text: UniString;
 MaxCount: Integer = 0);

{ Loads @bold(UniString) (Unicode) from the stream in UTF-8 encoding
  previously saved by @link(StreamPutUtf8String). }
function StreamGetUtf8String(Stream: TStream): UniString;

//---------------------------------------------------------------------------
{ Saves @bold(UniString) (Unicode) to the stream in UTF-8 encoding. The
  resulting UTF-8 string is limited to a maximum of 255 characters;
  therefore, for certain charsets the actual string is limited to either
  127 or even 85 characters in worst case. If @italic(MaxCount) is not
  zero, the input string will be limited to the given number of characters. }
procedure StreamPutShortUtf8String(Stream: TStream; const Text: UniString;
 MaxCount: Integer = 0);

{ Loads @bold(UniString) (Unicode) from the stream in UTF-8 encoding
  previously saved by @link(StreamPutShortUtf8String). }
function StreamGetShortUtf8String(Stream: TStream): UniString;

//----------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreUtils;

//---------------------------------------------------------------------------
procedure StreamPutByte(Stream: TStream; Value: Cardinal);
var
 ByteValue: Byte;
begin
 ByteValue:= Min2(Value, 255);
 Stream.WriteBuffer(ByteValue, SizeOf(Byte));
end;

//---------------------------------------------------------------------------
function StreamGetByte(Stream: TStream): Cardinal;
var
 ByteValue: Byte;
begin
 Stream.ReadBuffer(ByteValue, SizeOf(Byte));
 Result:= ByteValue;
end;

//---------------------------------------------------------------------------
procedure StreamPutWord(Stream: TStream; Value: Cardinal);
var
 WordValue: Word;
begin
 WordValue:= Min2(Value, 65535);
 Stream.WriteBuffer(WordValue, SizeOf(Word));
end;

//---------------------------------------------------------------------------
function StreamGetWord(Stream: TStream): Cardinal;
var
 WordValue: Word;
begin
 Stream.ReadBuffer(WordValue, SizeOf(Word));
 Result:= WordValue;
end;

//---------------------------------------------------------------------------
procedure StreamPutLongWord(Stream: TStream; Value: Cardinal);
var
 LongValue: LongWord;
begin
 LongValue:= Value;
 Stream.WriteBuffer(LongValue, SizeOf(LongWord));
end;

//---------------------------------------------------------------------------
function StreamGetLongWord(Stream: TStream): Cardinal;
var
 LongValue: LongWord;
begin
 Stream.ReadBuffer(LongValue, SizeOf(LongWord));
 Result:= LongValue;
end;

//---------------------------------------------------------------------------
procedure StreamPutShortInt(Stream: TStream; Value: Integer);
var
 IntValue: ShortInt;
begin
 IntValue:= MinMax2(Value, -128, 127);
 Stream.WriteBuffer(IntValue, SizeOf(ShortInt));
end;

//---------------------------------------------------------------------------
function StreamGetShortInt(Stream: TStream): Integer;
var
 IntValue: ShortInt;
begin
 Stream.ReadBuffer(IntValue, SizeOf(ShortInt));
 Result:= IntValue;
end;

//---------------------------------------------------------------------------
procedure StreamPutSmallInt(Stream: TStream; Value: Integer);
var
 IntValue: SmallInt;
begin
 IntValue:= MinMax2(Value, -32768, 32767);
 Stream.WriteBuffer(IntValue, SizeOf(SmallInt));
end;

//---------------------------------------------------------------------------
function StreamGetSmallInt(Stream: TStream): Integer;
var
 IntValue: SmallInt;
begin
 Stream.ReadBuffer(IntValue, SizeOf(SmallInt));
 Result:= IntValue;
end;

//---------------------------------------------------------------------------
procedure StreamPutLongInt(Stream: TStream; Value: Integer);
var
 LongValue: LongInt;
begin
 LongValue:= Value;
 Stream.WriteBuffer(LongValue, SizeOf(LongInt));
end;

//---------------------------------------------------------------------------
function StreamGetLongInt(Stream: TStream): Integer;
var
 LongValue: LongInt;
begin
 Stream.ReadBuffer(LongValue, SizeOf(LongInt));
 Result:= LongValue;
end;

//---------------------------------------------------------------------------
procedure StreamPutInt64(Stream: TStream; const Value: Int64);
begin
 Stream.WriteBuffer(Value, SizeOf(Int64));
end;

//---------------------------------------------------------------------------
function StreamGetInt64(Stream: TStream): Int64;
begin
 Stream.ReadBuffer(Result, SizeOf(Int64));
end;

//---------------------------------------------------------------------------
procedure StreamPutUInt64(Stream: TStream; const Value: UInt64);
begin
 Stream.WriteBuffer(Value, SizeOf(UInt64));
end;

//---------------------------------------------------------------------------
function StreamGetUInt64(Stream: TStream): UInt64;
begin
 Stream.ReadBuffer(Result, SizeOf(UInt64));
end;

//---------------------------------------------------------------------------
procedure StreamPutBool(Stream: TStream; Value: Boolean);
var
 ByteValue: Byte;
begin
 ByteValue:= 255;
 if (Value) then ByteValue:= 0;

 Stream.WriteBuffer(ByteValue, SizeOf(Byte));
end;

//---------------------------------------------------------------------------
function StreamGetBool(Stream: TStream): Boolean;
var
 ByteValue: Byte;
begin
 Stream.ReadBuffer(ByteValue, SizeOf(Byte));
 Result:= ByteValue < 128;
end;

//---------------------------------------------------------------------------
procedure StreamPutByteIndex(Stream: TStream; Value: Integer);
var
 ByteValue: Byte;
begin
 if (Value >= 0) then ByteValue:= Min2(Value, 254)
  else ByteValue:= 255;

 Stream.WriteBuffer(ByteValue, SizeOf(Byte));
end;

//---------------------------------------------------------------------------
function StreamGetByteIndex(Stream: TStream): Integer;
var
 ByteValue: Byte;
begin
 Stream.ReadBuffer(ByteValue, SizeOf(Byte));

 if (ByteValue <> 255) then Result:= ByteValue
  else Result:= -1;
end;

//---------------------------------------------------------------------------
procedure StreamPutWordIndex(Stream: TStream; Value: Integer);
var
 WordValue: Word;
begin
 if (Value >= 0) then WordValue:= Min2(Value, 65534)
  else WordValue:= 65535;

 Stream.WriteBuffer(WordValue, SizeOf(Word));
end;

//---------------------------------------------------------------------------
function StreamGetWordIndex(Stream: TStream): Integer;
var
 WordValue: Word;
begin
 Stream.ReadBuffer(WordValue, SizeOf(Word));

 if (WordValue <> 65535) then Result:= WordValue
  else Result:= -1;
end;

//---------------------------------------------------------------------------
procedure StreamPutLongPoint2px(Stream: TStream; const Vec: TPoint2px);
begin
 Stream.WriteBuffer(Vec.x, SizeOf(Longint));
 Stream.WriteBuffer(Vec.y, SizeOf(Longint));
end;

//---------------------------------------------------------------------------
function StreamGetLongPoint2px(Stream: TStream): TPoint2px;
begin
 Stream.ReadBuffer(Result.x, SizeOf(Longint));
 Stream.ReadBuffer(Result.y, SizeOf(Longint));
end;

//---------------------------------------------------------------------------
procedure StreamPutWordPoint2px(Stream: TStream; const Vec: TPoint2px);
var
 WordValue: Word;
begin
 if (Vec.x <> Low(LongInt)) then WordValue:= MinMax2(Vec.x, 0, 65534)
  else WordValue:= 65535;

 Stream.WriteBuffer(WordValue, SizeOf(Word));

 if (Vec.y <> Low(LongInt)) then WordValue:= MinMax2(Vec.y, 0, 65534)
  else WordValue:= 65535;

 Stream.WriteBuffer(WordValue, SizeOf(Word));
end;

//---------------------------------------------------------------------------
function StreamGetWordPoint2px(Stream: TStream): TPoint2px;
var
 WordValue: Word;
begin
 Stream.ReadBuffer(WordValue, SizeOf(Word));

 if (WordValue <> 65535) then Result.x:= WordValue
  else Result.x:= Low(Integer);

 Stream.ReadBuffer(WordValue, SizeOf(Word));

 if (WordValue <> 65535) then Result.y:= WordValue
  else Result.y:= Low(Integer);
end;

//---------------------------------------------------------------------------
procedure StreamPutBytePoint2px(Stream: TStream; const Vec: TPoint2px);
var
 ByteValue: Byte;
begin
 if (Vec.x <> Low(LongInt)) then ByteValue:= MinMax2(Vec.x, 0, 254)
  else ByteValue:= 255;

 Stream.WriteBuffer(ByteValue, SizeOf(Byte));

 if (Vec.y <> Low(LongInt)) then ByteValue:= MinMax2(Vec.y, 0, 254)
  else ByteValue:= 255;

 Stream.WriteBuffer(ByteValue, SizeOf(Byte));
end;

//---------------------------------------------------------------------------
function StreamGetBytePoint2px(Stream: TStream): TPoint2px;
var
 ByteValue: Byte;
begin
 Stream.ReadBuffer(ByteValue, SizeOf(Byte));

 if (ByteValue <> 255) then Result.x:= ByteValue
  else Result.x:= Low(Integer);

 Stream.ReadBuffer(ByteValue, SizeOf(Byte));

 if (ByteValue <> 255) then Result.y:= ByteValue
  else Result.y:= Low(Integer);
end;

//---------------------------------------------------------------------------
procedure StreamPutSingle(Stream: TStream; Value: Single);
begin
 Stream.WriteBuffer(Value, SizeOf(Single));
end;

//---------------------------------------------------------------------------
function StreamGetSingle(Stream: TStream): Single;
begin
 Stream.ReadBuffer(Result, SizeOf(Single));
end;

//---------------------------------------------------------------------------
procedure StreamPutDouble(Stream: TStream; Value: Double);
begin
 Stream.WriteBuffer(Value, SizeOf(Double));
end;

//---------------------------------------------------------------------------
function StreamGetDouble(Stream: TStream): Double;
begin
 Stream.ReadBuffer(Result, SizeOf(Double));
end;

//----------------------------------------------------------------------------
procedure StreamPutFloat34(Stream: TStream; Value: Single);
var
 Aux: Integer;
begin
 Aux:= MinMax2(Round(Value * 16.0), -128, 127);
 StreamPutShortInt(Stream, Aux);
end;

//----------------------------------------------------------------------------
function StreamGetFloat34(Stream: TStream): Single;
begin
 Result:= StreamGetShortInt(Stream) / 16.0;
end;

//----------------------------------------------------------------------------
procedure StreamPutFloat43(Stream: TStream; Value: Single);
var
 Aux: Integer;
begin
 Aux:= MinMax2(Round(Value * 8.0), -128, 127);
 StreamPutShortInt(Stream, Aux);
end;

//----------------------------------------------------------------------------
function StreamGetFloat43(Stream: TStream): Single;
begin
 Result:= StreamGetShortInt(Stream) / 8.0;
end;

//---------------------------------------------------------------------------
procedure StreamPutFloats44(Stream: TStream; Value1, Value2: Single);
var
 Aux1, Aux2: Integer;
begin
 Aux1:= MinMax2(Round(Value1), -8, 7) + 8;
 Aux2:= MinMax2(Round(Value2), -8, 7) + 8;

 StreamPutByte(Stream, Aux1 or (Aux2 shl 4));
end;

//---------------------------------------------------------------------------
procedure StreamGetFloats44(Stream: TStream; out Value1, Value2: Single);
var
 Aux: Integer;
begin
 Aux:= StreamGetByte(Stream);

 Value1:= ((Aux and $0F) - 8);
 Value2:= ((Aux shr 4) - 8);
end;

//---------------------------------------------------------------------------
procedure StreamPutFloats3311(Stream: TStream; Value1, Value2: Single);
var
 Aux1, Aux2: Integer;
begin
 Aux1:= MinMax2(Round(Value1 * 2.0), -8, 7) + 8;
 Aux2:= MinMax2(Round(Value2 * 2.0), -8, 7) + 8;

 StreamPutByte(Stream, Aux1 or (Aux2 shl 4));
end;

//---------------------------------------------------------------------------
procedure StreamGetFloats3311(Stream: TStream; out Value1,
 Value2: Single);
var
 Aux: Integer;
begin
 Aux:= StreamGetByte(Stream);

 Value1:= ((Aux and $0F) - 8) / 2.0;
 Value2:= ((Aux shr 4) - 8) / 2.0;
end;

//---------------------------------------------------------------------------
procedure StreamPutShortString(Stream: TStream; const Text: ShortString;
 MaxCount: Integer = 0);
var
 i, Count: Integer;
begin
 Count:= Length(Text);
 if (MaxCount > 0)and(MaxCount < 255) then Count:= Min2(Count, MaxCount);

 StreamPutByte(Stream, Count);

 for i:= 0 to Count - 1 do
  StreamPutByte(Stream, Byte(Text[i + 1]));
end;

//---------------------------------------------------------------------------
function StreamGetShortString(Stream: TStream): ShortString;
var
 Count, i: Integer;
begin
 Count:= StreamGetByte(Stream);
 SetLength(Result, Count);

 for i:= 0 to Count - 1 do
  Result[i + 1]:= AnsiChar(StreamGetByte(Stream));
end;

//---------------------------------------------------------------------------
procedure StreamPutAnsi4String(Stream: TStream; const Value: AnsiString);
var
 i: Integer;
begin
 StreamPutLongInt(Stream, Length(Value));

 for i:= 0 to Length(Value) - 1 do
  StreamPutByte(Stream, Byte(Value[i + 1]));
end;

//---------------------------------------------------------------------------
function StreamGetAnsi4String(Stream: TStream): AnsiString;
var
 Count, i: Integer;
begin
 Count:= StreamGetLongInt(Stream);
 SetLength(Result, Count);

 for i:= 0 to Count - 1 do
  Result[i + 1]:= AnsiChar(StreamGetByte(Stream));
end;

//----------------------------------------------------------------------------
procedure StreamPutAnsiString(Stream: TStream; const Text: AnsiString;
 MaxCount: Integer = 0);
var
 i, Count: Integer;
begin
 Count:= Min2(Length(Text), 65535);
 if (MaxCount > 0)and(MaxCount < 65535) then Count:= Min2(Count, MaxCount);

 StreamPutWord(Stream, Count);

 for i:= 0 to Count - 1 do
  StreamPutByte(Stream, Byte(Text[i + 1]));
end;

//----------------------------------------------------------------------------
function StreamGetAnsiString(Stream: TStream): AnsiString;
var
 Count, i: Integer;
begin
 Count:= StreamGetWord(Stream);
 SetLength(Result, Count);

 for i:= 0 to Count - 1 do
  Result[i + 1]:= AnsiChar(StreamGetByte(Stream));
end;

//----------------------------------------------------------------------------
procedure StreamPutUtf8String(Stream: TStream; const Text: UniString;
 MaxCount: Integer = 0);
var
 i, Count: Integer;
 ShText: AnsiString;
begin
 ShText:= UTF8Encode(Text);

 Count:= Min2(Length(ShText), 65535);
 if (MaxCount > 0)and(MaxCount < 65535) then Count:= Min2(Count, MaxCount);

 StreamPutWord(Stream, Count);

 for i:= 0 to Count - 1 do
  StreamPutByte(Stream, Byte(ShText[i + 1]));
end;

//----------------------------------------------------------------------------
function StreamGetUtf8String(Stream: TStream): UniString;
var
 Count, i: Integer;
 ShText: AnsiString;
begin
 Count:= StreamGetWord(Stream);

 SetLength(ShText, Count);

 for i:= 0 to Count - 1 do
  ShText[i + 1]:= AnsiChar(StreamGetByte(Stream));

 {$if (defined(fpc))or(defined(DelphiLegacy))}
 Result:= UTF8Decode(ShText);
 {$else}
 Result:= UTF8ToWideString(ShText);
 {$ifend}
end;

//----------------------------------------------------------------------------
procedure StreamPutShortUtf8String(Stream: TStream; const Text: UniString;
 MaxCount: Integer = 0);
var
 i, Count: Integer;
 ShText: AnsiString;
begin
 ShText:= UTF8Encode(Text);

 Count:= Min2(Length(ShText), 255);
 if (MaxCount > 0)and(MaxCount < 255) then Count:= Min2(Count, MaxCount);

 StreamPutByte(Stream, Count);

 for i:= 0 to Count - 1 do
  StreamPutByte(Stream, Byte(ShText[i + 1]));
end;

//----------------------------------------------------------------------------
function StreamGetShortUtf8String(Stream: TStream): UniString;
var
 Count, i: Integer;
 ShText: AnsiString;
begin
 Count:= StreamGetByte(Stream);

 SetLength(ShText, Count);

 for i:= 0 to Count - 1 do
  ShText[i + 1]:= AnsiChar(StreamGetByte(Stream));

 {$if (defined(fpc))or(defined(DelphiLegacy))}
 Result:= UTF8Decode(ShText);
 {$else}
 Result:= UTF8ToWideString(ShText);
 {$ifend}
end;

//----------------------------------------------------------------------------
end.
