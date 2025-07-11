unit MonkeyConnectors;
//---------------------------------------------------------------------------
// MonkeyConnectors.pas                                 Modified: 14-Sep-2012
// FireMonkey v2 Connection Manager.                              Version 1.1
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
// The Original Code is MonkeyConnectors.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< Asphyre and FireMonkey v2 hook management. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
uses
 System.SysUtils, FMX.Types3D;

//---------------------------------------------------------------------------
type
{ Asphyre and FireMonkey v2 hook manager. }
 TMonkeyAsphyreConnect = class
 private
  FInitialized: Boolean;
 public
  { Determines whether the connection between Asphyre and FireMonkey is
    currently established. }
  property Initialized: Boolean read FInitialized;

  { Creates the connection between Asphyre and FireMonkey, returning @True if
    the connection is successful, and @False otherwise. If the connection has
    previously been established, this function does nothing and returns @True.
    This function can be called as many times as possible in timer events to
    make sure that the connection remains established.
     @param(Context Valid FireMonkey's context taken from the main form
      (e.g. use @code(Self.Context) in the form's code).) }
  function Init(Context: TContext3D): Boolean;

  { Finalizes the connection between Asphyre and FireMonkey. }
  procedure Done();

  {@exclude}constructor Create();
  {@exclude}destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
var
{ Instance of @link(TMonkeyAsphyreConnect) that is ready to use in
  applications without having to create that class explicitly. }
 MonkeyAsphyreConnect: TMonkeyAsphyreConnect{$ifndef PasDoc} = nil{$endif};

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 FMX.Types,
 {$ifdef Windows}FMX.Context.DX9, DX9Types, DX9Providers,{$endif}
 {$ifdef Posix}FireGLProviders,{$endif}
 MonkeyTypes, AsphyreEvents, AsphyreFactory;

//---------------------------------------------------------------------------
constructor TMonkeyAsphyreConnect.Create();
begin
 inherited;

 FInitialized:= False;
end;

//---------------------------------------------------------------------------
destructor TMonkeyAsphyreConnect.Destroy();
begin

 inherited;
end;

//---------------------------------------------------------------------------
function TMonkeyAsphyreConnect.Init(Context: TContext3D): Boolean;
begin
 Result:= False;
 if (not Assigned(Context)) then Exit;

 if (FInitialized) then
  begin
   Result:= Context = FireContext;
   Exit;
  end;

 FireContext:= Context;

 //..........................................................................
 // Windows: Hook into FireMonkey v2 (DirectX 9).
 //..........................................................................
 {$ifdef Windows}
 if (not (Context is TCustomDX9Context)) then
  begin
   FireContext:= nil;
   Exit;
  end;

 D3D9Object:= TCustomDX9Context(Context).Direct3D9Obj;
 D3D9Device:= TCustomDX9Context(Context).SharedDevice;

 Factory.UseProvider(idDirectX9);
 {$endif}

 //..........................................................................
 // Mac OS X: Hook into FireMonkey v2 (OpenGL).
 //..........................................................................
 {$ifdef Posix}
 Factory.UseProvider(idFireOpenGL);
 {$endif}

 FInitialized:= True;
 Result:= True;

 EventAsphyreCreate.Notify(Self);
 EventTimerReset.Notify(Self);
end;

//---------------------------------------------------------------------------
procedure TMonkeyAsphyreConnect.Done();
begin
 if (not FInitialized) then Exit;

 EventAsphyreDestroy.Notify(Self);

 {$ifdef Windows}
 if (Assigned(D3D9Device)) then D3D9Device:= nil;
 if (Assigned(D3D9Object)) then D3D9Object:= nil;
 {$endif}

 FireContext := nil;
 FInitialized:= False;
end;

//---------------------------------------------------------------------------
initialization
 GlobalUseDX10:= False;

 MonkeyAsphyreConnect:= TMonkeyAsphyreConnect.Create();

//---------------------------------------------------------------------------
finalization
 FreeAndNil(MonkeyAsphyreConnect);

//---------------------------------------------------------------------------
end.
