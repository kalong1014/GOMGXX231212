unit WinKeyb;
//---------------------------------------------------------------------------
// WinKeyb.pas                                          Modified: 14-Sep-2012
// Keyboard key handler for Asphyre.                             Version 1.03
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
// The Original Code is WinKeyb.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< Asynchronous keyboard input implementation using Windows API. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, SysUtils, AsphyreDef;

//---------------------------------------------------------------------------
const
{@exclude}
 WinKeybLocale = '00000409'; // U.S. English

//---------------------------------------------------------------------------
type
{ Keyboard input class that uses Windows API for retrieving the state of
  keyboard buttons asynchronously. }
 TWinKeyb = class
 private
  Locale: HKL;

  function GetKey(vKey: Integer): Boolean;
  function GetKeyName(vKey: Integer): StdString;
  function GetKeyPressed(vKey: Integer): Boolean;
 public
  { Returns the status of a single keyboard key. @code(VCode) is the virtual
    key code usually defined by VK_[KeyName] constants. }
  property Key[vKey: Integer]: Boolean read GetKey;

  { Returns the name of the given key as it is described by underlying OS.
    @code(VCode) is the virtual key code. }
  property KeyName[vKey: Integer]: StdString read GetKeyName;

  { Indicates whether the key has been pressed since the last time it was
    checked. However, due to multitasking, a query from another application
    or even query to @link(Key) can reset this state so it should not be
    relied upon. @code(VCode) is the virtual key code. }
  property KeyPressed[vKey: Integer]: Boolean read GetKeyPressed;

  { Given the specified character, this function returns its virtual key
    code. }
  function CharKey(Ch: Char): Integer;

  {@exclude}constructor Create();
  {@exclude}destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
var
{ Instance of @link(TWinKeyb) that is ready to use in applications for
  querying keyboard state  so they do not need to create other instances
  of that class manually. }
 Keyb: TWinKeyb{$ifndef PasDoc} = nil{$endif};

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TWinKeyb.Create();
begin
 inherited;

 Locale:= LoadKeyboardLayout(PChar(WinKeybLocale), 0);
end;

//---------------------------------------------------------------------------
destructor TWinKeyb.Destroy();
begin
 UnloadKeyboardLayout(Locale);

 inherited;
end;

//---------------------------------------------------------------------------
function TWinKeyb.GetKey(vKey: Integer): Boolean;
var
 State: SmallInt;
begin
 State:= GetAsyncKeyState(vKey);
 Result:= State and $8000 <> 0;
end;

//---------------------------------------------------------------------------
function TWinKeyb.GetKeyName(vKey: Integer): StdString;
var
 KeyText : array[0..254] of Char;
 ScanCode: Longword;
begin
 ScanCode:= MapVirtualKey(vKey, 0);

 if (ScanCode <> 0) then
  begin
   GetKeyNameText(ScanCode or $800000, @KeyText, 255);
   Result:= StdString(KeyText);
  end else Result:= '';
end;

//---------------------------------------------------------------------------
function TWinKeyb.GetKeyPressed(vKey: Integer): Boolean;
var
 State: SmallInt;
begin
 State:= GetAsyncKeyState(vKey);
 Result:= State and $1 <> 0;
end;

//---------------------------------------------------------------------------
function TWinKeyb.CharKey(Ch: Char): Integer;
begin
 Result:= VkKeyScanEx(Ch, Locale) and $FF;
end;

//---------------------------------------------------------------------------
initialization
 Keyb:= TWinKeyb.Create();

//---------------------------------------------------------------------------
finalization
 FreeAndNil(Keyb);

//---------------------------------------------------------------------------
end.
