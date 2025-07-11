unit AsphyreMouse;
//---------------------------------------------------------------------------
// AsphyreMouse.pas                                     Modified: 14-Sep-2012
// DirectInput Mouse wrapper for Asphyre.                        Version 1.02
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
// The Original Code is AsphyreMouse.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< Asynchronous mouse input implementation using DirectInput 8. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, DirectInput, Vectors2px;

//---------------------------------------------------------------------------
type
{ Mouse input class that uses DirectInput 8 for retrieving the mouse state
  and its individual buttons. }
 TAsphyreMouse = class
 private
  FInitialized: Boolean;
  FExclusive  : Boolean;
  FInputDevice: IDirectInputDevice8;
  FBackground : Boolean;
  FBufferSize : Integer;
  FDisplace   : TPoint2px;
  MouseEvent  : THandle;

  FWindowHandle : THandle;
  ButtonClick   : array[0..7] of Integer;
  ButtonRelease : array[0..7] of Integer;
  FClearOnUpdate: Boolean;

  function CreateDirectInput(): Boolean;

  procedure ResetButtonStatus();
  function GetPressed(Button: Integer): Boolean;
  function GetReleased(Button: Integer): Boolean;
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

  { The size of mouse buffer that will store the events. It is recommended to
    leave this at its default value unless @link(Update) is not called often
    enough; a larger buffer will accomodate more mouse movement events. }
  property BufferSize: Integer read FBufferSize write FBufferSize;

  { Determines whether the access to the mouse should be exclusive for this
    application. }
  property Exclusive: Boolean read FExclusive write FExclusive;

  { Determines whether the status of mouse buttons should be cleared each
    time @link(Update) is called. }
  property ClearOnUpdate: Boolean read FClearOnUpdate write FClearOnUpdate;

  { The mouse displacement computed since the previous call to @link(Update). }
  property Displace: TPoint2px read FDisplace;

  { Returns @True if the specified button has been pressed since the previous
    call to @link(Update). If the button has not been pressed, the returned
    value is @False. The first button has index of zero. }
  property Pressed[Button: Integer]: Boolean read GetPressed;

  { Returns @True if the specified button has been released since the previous
    call to @link(Update). If the button has not been released, the returned
    value is @False. The first button has index of zero. }
  property Released[Button: Integer]: Boolean read GetReleased;

  { Initializes the component and prepares DirectInput interface. If the
    method succeeds, the returned value is @True and @False otherwise.
    @link(WindowHandle) must be properly set before for this call to
    succeed. }
  function Initialize(): Boolean;

  { Finalizes the component releasing DirectInput interface. }
  procedure Finalize();

  { Updates the state of mouse buttons and calculates the displacement that
    occurred since the previous call. If the method succeeds, the returned
    value is @True and @False otherwise. }
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
constructor TAsphyreMouse.Create();
begin
 inherited;

 FInitialized := False;
 FBackground  := False;
 FWindowHandle:= 0;
 FBufferSize  := 256;
 FExclusive   := True;

 FClearOnUpdate:= False;
 FDisplace:= ZeroPoint2px;
end;

//---------------------------------------------------------------------------
destructor TAsphyreMouse.Destroy();
begin
 if (FInitialized) then Finalize();

 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreMouse.CreateDirectInput(): Boolean;
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
procedure TAsphyreMouse.ResetButtonStatus();
var
 i: Integer;
begin
 for i:= 0 to 7 do
  begin
   ButtonClick[i]  := 0;
   ButtonRelease[i]:= 0;
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreMouse.Initialize(): Boolean;
var
 DIProp: TDIPropDWord;
 Flags : Cardinal;
begin
 if (FInitialized) then
  begin
   Result:= False;
   Exit;
  end;

 // (1) Check whether DirectInput is initialized.
 Result:= CreateDirectInput();
 if (not Result) then Exit;

 // (2) Create Mouse device.
 Result:= Succeeded(DInput8.CreateDevice(GUID_SysMouse, FInputDevice, nil));
 if (not Result) then Exit;

 // (3) Set Mouse data format.
 Result:= Succeeded(FInputDevice.SetDataFormat(c_dfDIMouse));
 if (not Result) then
  begin
   FInputDevice:= nil;
   Exit;
  end;

 // (4) Define device flags.
 Flags:= DISCL_FOREGROUND;
 if (FBackground) then Flags:= DISCL_BACKGROUND;
 if (FExclusive) then Flags:= Flags or DISCL_EXCLUSIVE
  else Flags:= Flags or DISCL_NONEXCLUSIVE;

 // (5) Set cooperative level.
 Result:= Succeeded(FInputDevice.SetCooperativeLevel(FWindowHandle, Flags));
 if (not Result) then
  begin
   FInputDevice:= nil;
   Exit;
  end;

 // (6) Create a new event.
 MouseEvent:= CreateEvent(nil, False, False, nil);
 if (MouseEvent = 0) then
  begin
   FInputDevice:= nil;
   Result:= False;
   Exit;
  end;

 // (7) Set the recently created event for mouse notifications.
 Result:= Succeeded(FInputDevice.SetEventNotification(MouseEvent));
 if (not Result) then
  begin
   FInputDevice:= nil;
   Exit;
  end;

 // (8) Setup property info for mouse buffer size.
 FillChar(DIProp, SizeOf(DIProp), 0);
 with DIProp do
  begin
   diph.dwSize:= SizeOf(TDIPropDWord);
   diph.dwHeaderSize:= SizeOf(TDIPropHeader);
   diph.dwObj:= 0;
   diph.dwHow:= DIPH_DEVICE;
   dwData:= FBufferSize;
  end;

 // (9) Update mouse buffer size.
 Result:= Succeeded(FInputDevice.SetProperty(DIPROP_BUFFERSIZE, DIProp.diph));
 if (not Result) then
  begin
   FInputDevice:= nil;
   Exit;
  end;

 ResetButtonStatus();
 FInitialized:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreMouse.Finalize();
begin
 if (FInputDevice <> nil) then
  begin
   FInputDevice.Unacquire();
   FInputDevice:= nil;
  end;

 FInitialized:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreMouse.Update(): Boolean;
var
 Res: Integer;
 ObjData: TDIDeviceObjectData;
 EventCount: Cardinal;
 EventClick: Integer;
 ButtonIndex : Integer;
 EventRelease: Integer;
begin
 Result:= True;

 // (1) If the component has not been initialized, try it first.
 if (not FInitialized) then
  begin
   Result:= Initialize();
   if (not Result) then Exit;
  end;

 // (2) Set initial state of the mouse.
 FDisplace:= ZeroPoint2px;
 if (FClearOnUpdate) then ResetButtonStatus();

 repeat
  EventCount:= 1;

  // (3) Retrieve Mouse Data.
  Res:= FInputDevice.GetDeviceData(SizeOf(TDIDeviceObjectData), @ObjData,
   EventCount, 0);
  if (Res <> DI_OK)and(Res <> DI_BUFFEROVERFLOW) then
   begin
    if (Res <> DIERR_INPUTLOST)and(Res <> DIERR_NOTACQUIRED) then
     begin
      Result:= False;
      Exit;
     end;

    Res:= FInputDevice.Acquire();
    if (Res = DI_OK) then
     begin
      // If acquired successfully, try to retrieve data again.
      Res:= FInputDevice.GetDeviceData(SizeOf(TDIDeviceObjectData), @ObjData,
       EventCount, 0);
      if (Res <> DI_OK)and(Res <> DI_BUFFEROVERFLOW) then
       begin
        Result:= False;
        Exit;
       end;
     end else
     begin
      Result:= False;
      Exit;
     end;
   end; // if (Res <> DI_OK)

  // (4) See if there are any mouse events available.
  if (EventCount < 1) then Break;

  // (5) Process mouse event.
  case ObjData.dwOfs of
   DIMOFS_X: Inc(FDisplace.x, Integer(ObjData.dwData));
   DIMOFS_Y: Inc(FDisplace.y, Integer(ObjData.dwData));

   DIMOFS_BUTTON0..DIMOFS_BUTTON7:
    begin
     EventClick  := 0;
     EventRelease:= 1;

     if ((ObjData.dwData and $80) = $80) then
      begin
       EventClick  := 1;
       EventRelease:= 0;
      end;

     ButtonIndex:= ObjData.dwOfs - DIMOFS_BUTTON0;

     ButtonClick[ButtonIndex]  := EventClick;
     ButtonRelease[ButtonIndex]:= EventRelease;
    end;
  end;

 until (EventCount < 1);
end;

//---------------------------------------------------------------------------
function TAsphyreMouse.GetPressed(Button: Integer): Boolean;
begin
 if (Button >= 0)and(Button < 8) then
  Result:= ButtonClick[Button] > 0
   else Result:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreMouse.GetReleased(Button: Integer): Boolean;
begin
 if (Button >= 0)and(Button < 8) then
  Result:= ButtonRelease[Button] > 0
   else Result:= False;
end;

//---------------------------------------------------------------------------
end.
