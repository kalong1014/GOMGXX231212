unit UniStringUtils;
//---------------------------------------------------------------------------
// UniStringUtils.pas                                   Modified: 14-Sep-2012
// Cross-platform and cross-compiler unicode string utilities.    Version 1.0
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
// The Original Code is UniStringUtils.pas.
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
 SysUtils, AsphyreDef;

//---------------------------------------------------------------------------
{ Determines whether both strings have the same text ignoring the case. }
function UniSameText(const Text1, Text2: UniString): Boolean;

//---------------------------------------------------------------------------
{ Compares the specified two strings and returns a positive number if the
  first string should be placed after the second string, negative number if
  the first string should be placed before the second string, and zero if
  both strings are exactly the same. The case is ignored. }
function UniCompareText(const Text1, Text2: UniString): Integer;

//---------------------------------------------------------------------------
// UniFormat[...]()
//
// Calls the corresponding Format() or WideFormat() function depending on
// Delphi and/or FreePascal version. Since there is no way to make a portable
// prototype of Format/WideFormat that will work fluently both in Delphi and
// FreePascal, these specific data variants are provided instead.
//---------------------------------------------------------------------------
function UniFormatInt(const Text: UniString; Value: Integer): UniString;
function UniFormatFloat(const Text: UniString; Value: Single): UniString;
function UniFormatText(const Text, Value: UniString): UniString;

//...........................................................................
function UniFormatInt2(const Text: UniString; Value1,
 Value2: Integer): UniString;
function UniFormatFloat2(const Text: UniString; Value1,
 Value2: Single): UniString;
function UniFormatText2(const Text, Value1, Value2: UniString): UniString;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
function UniSameText(const Text1, Text2: UniString): Boolean;
begin
 {$ifdef Delphi2009Up}
 Result:= SameText(Text1, Text2);
 {$else}
 Result:= WideSameText(Text1, Text2);
 {$endif}
end;

//---------------------------------------------------------------------------
function UniCompareText(const Text1, Text2: UniString): Integer;
begin
 {$ifdef Delphi2009Up}
 Result:= CompareText(Text1, Text2);
 {$else}
 Result:= WideCompareText(Text1, Text2);
 {$endif}
end;

//---------------------------------------------------------------------------
function UniFormatInt(const Text: UniString; Value: Integer): UniString;
begin
 {$ifdef Delphi2009Up}
 Result:= Format(Text, [Value]);
 {$else}
 Result:= WideFormat(Text, [Value]);
 {$endif}
end;

//---------------------------------------------------------------------------
function UniFormatFloat(const Text: UniString; Value: Single): UniString;
begin
 {$ifdef Delphi2009Up}
 Result:= Format(Text, [Value]);
 {$else}
 Result:= WideFormat(Text, [Value]);
 {$endif}
end;

//---------------------------------------------------------------------------
function UniFormatText(const Text, Value: UniString): UniString;
begin
 {$ifdef Delphi2009Up}
 Result:= Format(Text, [Value]);
 {$else}
 Result:= WideFormat(Text, [Value]);
 {$endif}
end;

//---------------------------------------------------------------------------
function UniFormatInt2(const Text: UniString; Value1,
 Value2: Integer): UniString;
begin
 {$ifdef Delphi2009Up}
 Result:= Format(Text, [Value1, Value2]);
 {$else}
 Result:= WideFormat(Text, [Value1, Value2]);
 {$endif}
end;

//---------------------------------------------------------------------------
function UniFormatFloat2(const Text: UniString; Value1,
 Value2: Single): UniString;
begin
 {$ifdef Delphi2009Up}
 Result:= Format(Text, [Value1, Value2]);
 {$else}
 Result:= WideFormat(Text, [Value1, Value2]);
 {$endif}
end;

//---------------------------------------------------------------------------
function UniFormatText2(const Text, Value1, Value2: UniString): UniString;
begin
 {$ifdef Delphi2009Up}
 Result:= Format(Text, [Value1, Value2]);
 {$else}
 Result:= WideFormat(Text, [Value1, Value2]);
 {$endif}
end;

//---------------------------------------------------------------------------
end.