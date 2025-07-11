unit AsphyreDef;
//---------------------------------------------------------------------------
// AsphyreDef.pas                                       Modified: 14-Sep-2012
// Basic type definitions for Asphyre framework.                 Version 1.02
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
// The Original Code is AsphyreDef.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< General integer and floating-point types optimized for each platform that
   are used throughout the entire framework. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
type
{ This type is used to pass @link(SizeFloat) by reference. }
 PSizeFloat = ^SizeFloat;

//---------------------------------------------------------------------------
{ General floating-point type. On 64-bit platform it is an equivalent of 
  @italic(Double) for better real-time performance, while on 32-bit systems 
  it is an equivalent of @italic(Single). }
 SizeFloat = {$ifdef cpux64}Double{$else}Single{$endif};

//---------------------------------------------------------------------------
{ This type is used to pass @link(PreciseFloat) by reference. }
 PPreciseFloat = ^PreciseFloat;

//---------------------------------------------------------------------------
{ High-precision floating-point type. It is typically equivalent of Double,
  unless target platform does not support 64-bit floats, in which case it is
  considered as Single. }
 PreciseFloat = {$ifdef AllowPreciseFloat}Double{$else}Single{$endif};

//---------------------------------------------------------------------------
{ This type is used to pass @link(UniString) by reference. }
 PUniString = ^UniString;

{ General-purpose Unicode string type. }
 UniString = {$ifdef Delphi2009Up}UnicodeString{$else}WideString{$endif};

//---------------------------------------------------------------------------
{ This type is used to pass @link(StdString) by reference. }
 PStdString = ^StdString;

{ Standard string type that is compatible with most Delphi and/or FreePascal
  functions that is version dependant. In latest Delphi versions it is
  considered Unicode, while older versions and FreePascal consider it
  AnsiString. }
 StdString = {$ifdef fpc}AnsiString{$else}string{$endif};

//---------------------------------------------------------------------------
// The following types in certain circumstances can lead to better 
// performance because they fit completely into CPU registers on each 
// specific platform.
//---------------------------------------------------------------------------
{ This type is used to pass @link(SizeInt) by reference. }
 PSizeInt = ^SizeInt;

{ This type is used to pass @link(SizeInt) by reference. }
 PSizeUInt = ^SizeUInt;

{$ifdef fpc}
 SizeInt  = PtrInt;
 SizeUInt = PtrUInt;
{$else}

{$ifdef DelphiXE2Up}
{ General-purpose signed integer type. }
 SizeInt = NativeInt;

{ General-purpose unsigned integer type. }
 SizeUInt = NativeUInt;
{$else} // Other Delphi versions.
 SizeInt  = Integer;
 SizeUInt = Cardinal;
{$endif}

{$endif}

//---------------------------------------------------------------------------
{$ifndef fpc}
{ Special signed integer type that can be used for pointer arithmetic. }
 PtrInt  = SizeInt;

{ Special unsigned integer type that can be used for pointer arithmetic. }
 PtrUInt = SizeUInt;
{$endif}

//---------------------------------------------------------------------------
{ Calls FreeMem for the given value and then sets the value to @nil. }
procedure FreeNullMem(var Value);

//---------------------------------------------------------------------------
implementation

procedure FreeNullMem(var Value);
var
 Aux: Pointer;
begin
 Aux:= Pointer(Value);

 Pointer(Value):= nil;
 FreeMem(Aux);
end;


//---------------------------------------------------------------------------
end.
