unit AsphyreKeyboard;
//---------------------------------------------------------------------------
// AsphyreKeyboard.pas                                  Modified: 14-Sep-2012
// DirectInput Keyboard wrapper for Asphyre.                     Version 1.05
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
// The Original Code is AsphyreKeyboard.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< Asynchronous keyboard input implementation using DirectInput 8. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, DirectInput, AsphyreDef;

//---------------------------------------------------------------------------
type
{@exclude}
 TDIKeyBuf = array[0..255] of Byte;

//---------------------------------------------------------------------------
{ Keyboard input class that uses DirectInput 8 for retrieving the state of
  keyboard buttons asynchronously. }
 TAsphyreKeyboard = class
 private
  FInputDevice: IDirectInputDevice8;
  FBackground : Boolean;
  FInitialized: Boolean;

  FWindowHandle: THandle;

  KeyBuffer : TDIKeyBuf;
  PrevBuffer: TDIKeyBuf;

  function CreateDirectInput(): Boolean;

  function GetKey(KeyNum: Integer): Boolean;
  function GetKeyName(KeyNum: Integer): StdString;

  function GetKeyPressed(KeyNum: Integer): Boolean;
  function GetKeyReleased(KeyNum: Integer): Boolean;

  function ConvertVKey(VCode: Cardinal): Integer;

  function GetVKey(VCode: Cardinal): Boolean;
  function GetVKeyName(VCode: Cardinal): StdString;
  function GetVKeyPressed(VCode: Cardinal): Boolean;
  function GetVKeyReleased(VCode: Cardinal): Boolean;
 public
  {@exclude}
  property InputDevice: IDirectInputDevice8 read FInputDevice;

  { Indicates whether the component has been properly initialized and is
    ready to be used. }
  property Initialized: Boolean read FInitialized;

  { Determines whether the input should still be available when application is
    minimized or not focused. }
  property Background: Boolean read FBackground write FBackground;

  { The handle of the application's main window. This should be properly set
    before initializing the component as it will not work otherwise. }
  property WindowHandle: THandle read FWindowHandle write FWindowHandle;

  { Returns the status of a single keyboard key. @code(KeyNum) is the internal
    key number as defined in DirectInput. These constants are usually named as
    @code(DIK_[KeyName]). Search for Microsoft article called "Keyboard Device
    Enumeration" for more information. }
  property Key[KeyNum: Integer]: Boolean read GetKey;

  { Returns the name of the given key as it is described by underlying OS.
    @code(KeyNum) is the internal key number as with @link(Key) property. }
  property KeyName[KeyNum: Integer]: StdString read GetKeyName;

  { Indicates whether the key has been pressed after two consequent calls
    to @link(Update). @code(KeyNum) is the internal key number as with
    @link(Key) property. }
  property KeyPressed[KeyNum: Integer]: Boolean read GetKeyPressed;

  { Indicates whether the key has been released after two consequent calls
    to @link(Update). @code(KeyNum) is the internal key number as with
    @link(Key) property. }
  property KeyReleased[KeyNum: Integer]: Boolean read GetKeyReleased;

  { Returns the status of a single keyboard key. @code(VCode) is the virtual
    key code usually defined by VK_[KeyName] constants. }
  property VKey[VCode: Cardinal]: Boolean read GetVKey;

  { Returns the name of the given key as it is described by underlying OS.
    @code(VCode) is the virtual key code. }
  property VKeyName[VCode: Cardinal]: StdString read GetVKeyName;

  { Indicates whether the key has been pressed after two consequent calls
    to @link(Update). @code(VCode) is the virtual key code. }
  property VKeyPressed[VCode: Cardinal]: Boolean read GetVKeyPressed;

  { Indicates whether the key has been released after two consequent calls
    to @link(Update). @code(VCode) is the virtual key code. }
  property VKeyReleased[VCode: Cardinal]: Boolean read GetVKeyReleased;

  { Updates the state of keyboard keys. The returned value is @True if the
    method succeeds and @False otherwise. }
  function Update(): Boolean;

  { Initializes the component and prepares DirectInput interface. If the
    method succeeds, the returned value is @True and @False otherwise.
    @link(WindowHandle) must be properly set before for this call to
    succeed. }
  function Initialize(): Boolean;

  { Finalizes the component releasing DirectInput interface. }
  procedure Finalize();

  {@exclude}constructor Create();
  {@exclude}destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 DX8Types;

//---------------------------------------------------------------------------
constructor TAsphyreKeyboard.Create();
begin
 inherited;

 FBackground := True;
 FInitialized:= False;

 FWindowHandle:= 0;
end;

//---------------------------------------------------------------------------
destructor TAsphyreKeyboard.Destroy();
begin
 if (FInitialized) then Finalize();

 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.CreateDirectInput(): Boolean;
begin
 if (DInput8 <> nil) then
  begin
   Result:= True;
   Exit;
  end;

 Result:= Succeeded(DirectInput8Create(hInstance, DIRECTINPUT_VERSION,
  IID_IDirectInput8, DInput8, nil));
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.Initialize(): Boolean;
begin
 if (FInitialized) then
  begin
   Result:= False;
   Exit;
  end;

 // (1) Check whether DirectInput is initialized.
 Result:= CreateDirectInput();
 if (not Result) then Exit;

 // (2) Create Keyboard device
 Result:= Succeeded(DInput8.CreateDevice(GUID_SysKeyboard, FInputDevice, nil));
 if (not Result) then Exit;

 // (3) Set Keyboard data format.
 Result:= Succeeded(FInputDevice.SetDataFormat(c_dfDIKeyboard));
 if (not Result) then
  begin
   FInputDevice:= nil;
   Exit;
  end;

 // (4) Set cooperative level.
 if (FBackground) then
  begin
   Result:= Succeeded(FInputDevice.SetCooperativeLevel(FWindowHandle,
    DISCL_BACKGROUND or DISCL_NONEXCLUSIVE));
  end else
  begin
   Result:= Succeeded(FInputDevice.SetCooperativeLevel(FWindowHandle,
    DISCL_FOREGROUND or DISCL_NONEXCLUSIVE));
  end;

 if (not Result) then
  begin
   FInputDevice:= nil;
   Exit;
  end;

 FillChar(KeyBuffer, SizeOf(TDIKeyBuf), 0);
 FillChar(PrevBuffer, SizeOf(TDIKeyBuf), 0);
 FInitialized:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreKeyboard.Finalize();
begin
 if (FInputDevice <> nil) then
  begin
   FInputDevice.Unacquire();
   FInputDevice:= nil;
  end;

 FInitialized:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.Update(): Boolean;
var
 Res: Integer;
begin
 Result:= True;

 // (1) Verify initial conditions.
 if (not FInitialized) then
  begin
   Result:= Initialize();
   if (not Result) then Exit;
  end;

 // (2) Save current buffer state.
 Move(KeyBuffer, PrevBuffer, SizeOf(TDIKeyBuf));

 // (3) Attempt to retrieve device state.
 Res:= FInputDevice.GetDeviceState(SizeOf(TDIKeyBuf), @KeyBuffer);
 if (Res <> DI_OK) then
  begin
   // Can the error be corrected?
   if (Res <> DIERR_INPUTLOST)and(Res <> DIERR_NOTACQUIRED) then
    begin
     Result:= False;
     Exit;
    end;

   // Device might not be acquired.
   Res:= FInputDevice.Acquire();
   if (Res = DI_OK) then
    begin
     // Acquired successfully, now try retreiving the state again.
     Res:= FInputDevice.GetDeviceState(SizeOf(TDIKeyBuf), @KeyBuffer);
     if (Res <> DI_OK) then Result:= False;
    end else Result:= False;
  end; // if (Res <> DI_OK)
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.GetKey(KeyNum: Integer): Boolean;
begin
 Result:= (KeyBuffer[KeyNum] and $80) = $80;
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.GetKeyName(KeyNum: Integer): StdString;
var
 KeyName: array[0..255] of Char;
begin
 GetKeyNameText(KeyNum or $800000, @KeyName, 255);
 Result:= StdString(KeyName);
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.GetKeyPressed(KeyNum: Integer): Boolean;
begin
 Result:=
  (PrevBuffer[KeyNum] and $80 <> $80)and
  (KeyBuffer[KeyNum] and $80 = $80);
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.GetKeyReleased(KeyNum: Integer): Boolean;
begin
 Result:=
  (PrevBuffer[KeyNum] and $80 = $80)and
  (KeyBuffer[KeyNum] and $80 <> $80);
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.ConvertVKey(VCode: Cardinal): Integer;
begin
 Result:= MapVirtualKey(VCode, 0);
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.GetVKey(VCode: Cardinal): Boolean;
begin
 Result:= GetKey(ConvertVKey(VCode));
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.GetVKeyName(VCode: Cardinal): StdString;
begin
 Result:= GetKeyName(ConvertVKey(VCode));
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.GetVKeyPressed(VCode: Cardinal): Boolean;
begin
 Result:= GetKeyPressed(ConvertVKey(VCode));
end;

//---------------------------------------------------------------------------
function TAsphyreKeyboard.GetVKeyReleased(VCode: Cardinal): Boolean;
begin
 Result:= GetKeyReleased(ConvertVKey(VCode));
end;

//---------------------------------------------------------------------------
end.
