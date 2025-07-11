unit AsphyreEvents;
//---------------------------------------------------------------------------
// AsphyreEvents.pas                                    Modified: 14-Sep-2012
// Declarations of important Asphyre events.                      Version 1.0
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
// The Original Code is AsphyreEvents.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< Common Asphyre events that deal with device creation, resource
   initialization and GUI management. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
uses
 AsphyreEventTypes;

//---------------------------------------------------------------------------
var
{ Asphyre creation event, where all Asphyre components should be created. }
 EventAsphyreCreate : TEventProvider{$ifndef PasDoc} = nil{$endif};

{ Asphyre release event, where all Asphyre components should be released. }
 EventAsphyreDestroy: TEventProvider{$ifndef PasDoc} = nil{$endif};

//---------------------------------------------------------------------------
{ Device initialization event, where device and swap chain configuration should
  be specified. This event occurs right before Asphyre device is about to be
  initialized. }
 EventDeviceInit: TEventProvider{$ifndef PasDoc} = nil{$endif};

{ Device creation event, which occurs right after the device has been
  initialized. In this event it is possible to load some essential artwork and
  fonts. }
 EventDeviceCreate: TEventProvider{$ifndef PasDoc} = nil{$endif};

{ Device finalization event, which occurs right before the device is to be
  finalized to release all other device-dependant resources such as images and
  fonts. }
 EventDeviceDestroy: TEventProvider{$ifndef PasDoc} = nil{$endif};

//---------------------------------------------------------------------------
{ Device reset event, which occurs either after device has been initialized or
  recovered from lost scenario. In this event all volatile device-dependant
  resources should be created. }
 EventDeviceReset: TEventProvider{$ifndef PasDoc} = nil{$endif};

{ Device lost event, which occurs either before the device is to be finalized
  or when the device has been lost. In this event all volatile device-dependant
  resources should be released. }
 EventDeviceLost: TEventProvider{$ifndef PasDoc} = nil{$endif};

//---------------------------------------------------------------------------
{ Start of rendering scene event, which occurs when the scene is being
  prepared to be rendered. In this event the necessary device states can
  be updated. }
 EventBeginScene: TEventProvider{$ifndef PasDoc} = nil{$endif};

{ End of rendering scene event, which  occurs when the scene has finished
  rendering and is about to be presented on the screen (or render target).
  In this event it is necessary to finish all cached rendering processes. }
 EventEndScene: TEventProvider{$ifndef PasDoc} = nil{$endif};

//---------------------------------------------------------------------------
{ Sound device creation event, which occurs right after the audio device has
  been initialized. In this event it is possible to load some essential sound
  samples and music. }
 EventAudioCreate: TEventProvider{$ifndef PasDoc} = nil{$endif};

{ Sound device finalization event, which occurs right before the audio device
  is to be finalized to release all other device-dependant sound resources
  such as samples and music. }
 EventAudioDestroy: TEventProvider{$ifndef PasDoc} = nil{$endif};

//---------------------------------------------------------------------------
{ Timer reset event, which occurs when a time-consuming operation has
  taken place so it is necessary to reset the timer to prevent stalling. }
 EventTimerReset: TEventProvider{$ifndef PasDoc} = nil{$endif};

//---------------------------------------------------------------------------
{ Button click event, which occurs when one of GUI buttons have been clicked.
  Typically, @link(EventControlName) and @link(EventControlForm) are set to
  define what control on which form has been clicked. }
 EventButtonClick: TEventProvider{$ifndef PasDoc} = nil{$endif};

//---------------------------------------------------------------------------
{ This variable usually contains the name of the control that has sent the
  latest event notification, such as button click. }
 EventControlName: string{$ifndef PasDoc} = ''{$endif};

{ This variable usually contains the name of the form, which contained the
  control that sent the latest event notification, such as button click. }
 EventControlForm: string{$ifndef PasDoc} = ''{$endif};

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
initialization
 EventAsphyreCreate := EventProviders.Add();
 EventAsphyreDestroy:= EventProviders.Add();

 EventDeviceInit   := EventProviders.Add();
 EventDeviceCreate := EventProviders.Add();
 EventDeviceDestroy:= EventProviders.Add();

 EventAudioCreate := EventProviders.Add();
 EventAudioDestroy:= EventProviders.Add();

 EventDeviceReset:= EventProviders.Add();
 EventDeviceLost := EventProviders.Add();

 EventBeginScene:= EventProviders.Add();
 EventEndScene  := EventProviders.Add();

 EventTimerReset:= EventProviders.Add();

 EventButtonClick:= EventProviders.Add();

//---------------------------------------------------------------------------
end.
