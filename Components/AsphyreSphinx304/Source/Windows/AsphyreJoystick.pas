unit AsphyreJoystick;
//---------------------------------------------------------------------------
// AsphyreJoystick.pas                                  Modified: 14-Sep-2012
// DirectInput Joystick wrapper for Asphyre.                     Version 1.05
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
// The Original Code is AsphyreJoystick.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< Joystick management implementation using DirectInput 8. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, Types, Classes, SysUtils, Forms, DirectInput;

//---------------------------------------------------------------------------
type
{ Joystick input class that uses DirectInput 8 for retrieving the state of
  the joystick, its axes buttons and other parameters. This class is usually
  created inside @link(TAsphyreJoysticks) for every joystick connected in
  the system. }
 TAsphyreJoystick = class
 private
  FInitialized: Boolean;
  FInputDevice: IDirectInputDevice8;
  FJoyState   : TDIJoyState2;
  FButtonCount: Integer;
  FAxisCount  : Integer;
  FPOVCount   : Integer;
  FDeviceCaps : TDIDevCaps;
  FBackground : Boolean;
 public
  {@exclude}
  property InputDevice: IDirectInputDevice8 read FInputDevice;

  { Indicates whether the component has been properly initialized and is
    ready to be used. }
  property Initialized: Boolean read FInitialized;

  { Provides access to the capabilities of the joystick device. }
  property DeviceCaps: TDIDevCaps read FDeviceCaps;

  { The current state of joystick buttons, axes and sliders. }
  property JoyState: TDIJoyState2 read FJoyState;

  { Indicates whether the joystick input is still available when the
    application is minimized or not focused. }
  property Background: Boolean read FBackground;

  { The number of buttons present in the joystick. }
  property ButtonCount: Integer read FButtonCount;

  { The number of axes present in the joystick. }
  property AxisCount: Integer read FAxisCount;

  { The number of point-of-views in the joystick. }
  property POVCount: Integer read FPOVCount;

  {@exclude}
  function Initialize(ddi: PDIDeviceInstance; WindowHandle: THandle): Boolean;
  {@exclude}
  procedure Finalize();

  { Updates the joystick state and refreshes values of @link(JoyState). }
  function Poll(): Boolean;

  {@exclude}constructor Create();
  {@exclude}destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
{ Multiple joystick implementation class that uses DirectInput 8 for joystick
  enumeration and management. }
 TAsphyreJoysticks = class
 private
  FInitialized : Boolean;
  FWindowHandle: THandle;
  FBackground  : Boolean;

  Data: array of TAsphyreJoystick;

  function CreateDirectInput(): Boolean;
  function GetCount(): Integer;
  function GetItem(Index: Integer): TAsphyreJoystick;
  procedure ReleaseJoysticks();
 protected
  function AddJoy(): TAsphyreJoystick;
 public
  { Indicates whether the component has been properly initialized and is
    ready to be used. }
  property Initialized: Boolean read FInitialized;

  { The handle of the application's main window. This should be properly set
    before initializing the component as it will not work otherwise. }
  property WindowHandle: THandle read FWindowHandle write FWindowHandle;

  { Determines whether the input should still be available when application is
    minimized or not focused. }
  property Background: Boolean read FBackground write FBackground;

  { Number of joysticks connected in the system. If no joysticks are connected,
    this value will be zero. }
  property Count: Integer read GetCount;

  { Provides access to individual joysticks connected in the system.
    @code(Index) can have values in range of [0..(Count - 1)]. If the specified
    index is out of valid range, the returned value is zero. }
  property Items[Index: Integer]: TAsphyreJoystick read GetItem; default;

  { Initializes the component and prepares DirectInput interface. If the
    method succeeds, the returned value is @True and @False otherwise.
    @link(WindowHandle) must be properly set before for this call to
    succeed. This also updates the number of joysticks present in the system
    and initializes each one of them. }
  function Initialize(): Boolean;

  { Finalizes the component releasing all previously created joysticks and the
    related DirectInput interfaces. }
  procedure Finalize();

  { Updates the status of all joysticks in the system. }
  function Update(): Boolean;

  {@exclude}constructor Create();
  {@exclude}destructor Destroy(); override;
 end;


//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 DX8Types;

//---------------------------------------------------------------------------
type
 PClassReference = ^TClassReference;
 TClassReference = record
  MainObj: TObject;
  Success: Boolean;
 end;

//---------------------------------------------------------------------------
function AxisEnumCallback(var ddoi: TDIDeviceObjectInstance;
 Ref: Pointer): Boolean; stdcall;
var
 DIPropRange: TDIPropRange;
 ClassRef   : PClassReference;
 Res        : Integer;
begin
 // (1) Retrieve caller's class reference.
 ClassRef:= Ref;

 // (2) Configure the axis.
 DIPropRange.diph.dwSize:= SizeOf(TDIPropRange);
 DIPropRange.diph.dwHeaderSize:= SizeOf(TDIPropHeader);
 DIPropRange.diph.dwHow:= DIPH_BYID;
 DIPropRange.diph.dwObj:= ddoi.dwType;

 // -> use range [-32768..32767]
 DIPropRange.lMin:= Low(SmallInt);
 DIPropRange.lMax:= High(SmallInt);

 // (3) Set axis properties.
 Res:= TAsphyreJoystick(ClassRef.MainObj).InputDevice.SetProperty(DIPROP_RANGE,
  DIPropRange.diph);
 if (Res <> DI_OK) then
  begin
   Result:= DIENUM_STOP;
   ClassRef.Success:= False;
  end else Result:= DIENUM_CONTINUE;
end;

//---------------------------------------------------------------------------
function JoyEnumCallback(ddi: PDIDeviceInstance;
 Ref: Pointer): Boolean; stdcall;
var
 ClassRef: PClassReference;
 Joystick: TAsphyreJoystick;
begin
 ClassRef:= Ref;

 Joystick:= TAsphyreJoysticks(ClassRef.MainObj).AddJoy();

 ClassRef.Success:= Joystick.Initialize(ddi,
  TAsphyreJoysticks(ClassRef.MainObj).WindowHandle);

 if (not ClassRef.Success) then
  Result:= DIENUM_STOP
   else Result:= DIENUM_CONTINUE;
end;

//---------------------------------------------------------------------------
constructor TAsphyreJoystick.Create();
begin
 inherited;

 FInitialized:= False;
 FBackground := False;
end;

//---------------------------------------------------------------------------
destructor TAsphyreJoystick.Destroy();
begin
 if (FInitialized) then Finalize();

 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreJoystick.Initialize(ddi: PDIDeviceInstance;
 WindowHandle: THandle): Boolean;
var
 ClassRef: TClassReference;
 Flags: Cardinal;
begin
 if (DInput8 = nil) then
  begin
   Result:= False;
   Exit;
  end;

 Result:= Succeeded(DInput8.CreateDevice(ddi.guidInstance, FInputDevice, nil));
 if (not Result) then Exit;

 Result:= Succeeded(FInputDevice.SetDataFormat(c_dfDIJoystick2));
 if (not Result) then
  begin
   FInputDevice:= nil;
   Exit;
  end;

 Flags:= DISCL_FOREGROUND or DISCL_EXCLUSIVE;
 if (FBackground) then Flags:= DISCL_BACKGROUND or DISCL_NONEXCLUSIVE;

 Result:= Succeeded(FInputDevice.SetCooperativeLevel(WindowHandle, Flags));
 if (not Result) then
  begin
   FInputDevice:= nil;
   Exit;
  end;

 ClassRef.MainObj:= Self;
 ClassRef.Success:= True;

 Result:= Succeeded(FInputDevice.EnumObjects(@AxisEnumCallback, @ClassRef,
  DIDFT_AXIS))and(ClassRef.Success);
 if (not Result) then
  begin
   FInputDevice:= nil;
   Exit;
  end;

 FillChar(FDeviceCaps, SizeOf(TDIDevCaps), 0);
 FDeviceCaps.dwSize:= SizeOf(TDIDevCaps);

 Result:= Succeeded(FInputDevice.GetCapabilities(FDeviceCaps));
 if (not Result) then
  begin
   FInputDevice:= nil;
   Exit;
  end;

 FButtonCount:= FDeviceCaps.dwButtons;
 FAxisCount  := FDeviceCaps.dwAxes;
 FPOVCount   := FDeviceCaps.dwPOVs;

 FInitialized:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreJoystick.Finalize();
begin
 if (FInputDevice <> nil) then
  begin
   FInputDevice.Unacquire();
   FInputDevice:= nil;
  end;

 FInitialized:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreJoystick.Poll(): Boolean;
var
 Res: Integer;
begin
 Result:= True;
 
 Res:= FInputDevice.Poll();

 if (Res <> DI_OK)and(Res <> DI_NOEFFECT) then
  begin
   if (Res <> DIERR_INPUTLOST)and(Res <> DIERR_NOTACQUIRED) then
    begin
     Result:= False;
     Exit;
    end;

   Result:= Succeeded(FInputDevice.Acquire());
   if (Result) then
    begin
     Res:= FInputDevice.Poll();
     if (Res <> DI_OK)and(Res <> DI_NOEFFECT) then
      begin
       Result:= False;
       Exit;
      end;
    end else Exit;
  end;

 Res:= FInputDevice.GetDeviceState(SizeOf(TDIJoyState2), @FJoyState);
 if (Res <> DI_OK) then
  begin
   if (Res <> DIERR_INPUTLOST)and(Res <> DIERR_NOTACQUIRED) then
    begin
     Result:= False;
     Exit;
    end;

   Result:= Succeeded(FInputDevice.Acquire());
   if (Result) then
    begin
     Result:= Succeeded(FInputDevice.GetDeviceState(SizeOf(TDIJoyState2),
      @FJoyState));
     if (not Result) then Exit;
    end;
  end;
end;

//---------------------------------------------------------------------------
constructor TAsphyreJoysticks.Create();
begin
 inherited;

 FBackground  := False;
 FWindowHandle:= 0;
 FInitialized := False;
end;

//---------------------------------------------------------------------------
destructor TAsphyreJoysticks.Destroy();
begin
 if (FInitialized) then Finalize();

 inherited;
end;

//---------------------------------------------------------------------------
procedure TAsphyreJoysticks.ReleaseJoysticks();
var
 i: Integer;
begin
 for i:= 0 to Length(Data) - 1 do
  if (Data[i] <> nil) then FreeAndNil(Data[i]);

 SetLength(Data, 0);
end;

//---------------------------------------------------------------------------
function TAsphyreJoysticks.CreateDirectInput(): Boolean;
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
function TAsphyreJoysticks.GetCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TAsphyreJoysticks.GetItem(Index: Integer): TAsphyreJoystick;
begin
 if (Index >= 0)and(Index < Length(Data)) then
  Result:= Data[Index]
   else Result:= nil;
end;

//---------------------------------------------------------------------------
function TAsphyreJoysticks.AddJoy(): TAsphyreJoystick;
var
 Index: Integer;
begin
 Index:= Length(Data);
 SetLength(Data, Length(Data) + 1);

 Data[Index]:= TAsphyreJoystick.Create();
 Data[Index].FBackground:= FBackground;
 Result:= Data[Index];
end;

//---------------------------------------------------------------------------
function TAsphyreJoysticks.Initialize(): Boolean;
var
 ClassRef: TClassReference;
begin
 Result:= CreateDirectInput();
 if (not Result) then Exit;

 ReleaseJoysticks();

 ClassRef.MainObj:= Self;
 ClassRef.Success:= False;

 Result:= Succeeded(DInput8.EnumDevices(DI8DEVCLASS_GAMECTRL,
  @JoyEnumCallback, @ClassRef, DIEDFL_ATTACHEDONLY))and(ClassRef.Success);

 if (not Result) then ReleaseJoysticks();

 FInitialized:= Result;
end;

//---------------------------------------------------------------------------
procedure TAsphyreJoysticks.Finalize();
begin
 ReleaseJoysticks();
 FInitialized:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreJoysticks.Update(): Boolean;
var
 i: Integer;
begin
 Result:= True;

 if (not FInitialized) then
  begin
   Result:= Initialize();
   if (not Result) then Exit;
  end;

 for i:= 0 to Length(Data) - 1 do
  if (Data[i] <> nil)and(Data[i].Initialized) then
   begin
    Result:= Data[i].Poll();
    if (not Result) then Break;
   end;
end;

//---------------------------------------------------------------------------
end.
