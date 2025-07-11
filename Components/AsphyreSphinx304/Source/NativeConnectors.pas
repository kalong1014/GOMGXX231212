unit NativeConnectors;
//---------------------------------------------------------------------------
// NativeConnectors.pas                                 Modified: 14-Sep-2012
// Asphyre Native Connection Manager.                             Version 1.0
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
// The Original Code is NativeConnectors.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< VCL/LCL Asphyre compatibility hook management. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
type
{ Native (x86/x64) Asphyre compatibility hook manager. This manager works in
  a similar fashion to other hook managers such as those for Mac OS X and
  iOS, but it is meant to be used only on Windows. }
 TNativeAsphyreConnect = class
 private
  FInitialized: Boolean;
 public
  { Determines whether the component has been successfully initialized. }
  property Initialized: Boolean read FInitialized;

  { Initializes the component and calls the respective Asphyre events where
    Asphyre components should be created. This function returns @True in case
    of success and @False otherwise. If the component is already initialized,
    this function does nothing and returns @True; it can be called as many
    times as possible in timer events to make sure that Asphyre components are
    properly created. }
  function Init(): Boolean;

  { Finalizes the component and calls events where Asphyre components should
    be released. }
  procedure Done();

  {@exclude}constructor Create();
  {@exclude}destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
var
{ Instance of @link(TNativeAsphyreConnect) that is ready to use in
  applications without having to create that class explicitly. }
 NativeAsphyreConnect: TNativeAsphyreConnect{$ifndef PasDoc} = nil{$endif};

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 SysUtils, AsphyreEvents;

//---------------------------------------------------------------------------
constructor TNativeAsphyreConnect.Create();
begin
 inherited;

 FInitialized:= False;
end;

//---------------------------------------------------------------------------
destructor TNativeAsphyreConnect.Destroy();
begin

 inherited;
end;

//---------------------------------------------------------------------------
function TNativeAsphyreConnect.Init(): Boolean;
begin
 Result:= FInitialized;
 if (Result) then Exit;

 FInitialized:= True;
 Result:= True;

 EventAsphyreCreate.Notify(Self);
 EventTimerReset.Notify(Self);
end;

//---------------------------------------------------------------------------
procedure TNativeAsphyreConnect.Done();
begin
 if (not FInitialized) then Exit;

 EventAsphyreDestroy.Notify(Self);
 FInitialized:= False;
end;

//---------------------------------------------------------------------------
initialization
 NativeAsphyreConnect:= TNativeAsphyreConnect.Create();

//---------------------------------------------------------------------------
finalization
 FreeAndNil(NativeAsphyreConnect);

//---------------------------------------------------------------------------
end.
