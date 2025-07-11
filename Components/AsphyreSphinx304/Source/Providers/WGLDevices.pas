unit WGLDevices;
//---------------------------------------------------------------------------
// WGLDevices.pas                                       Modified: 14-Sep-2012
// Windows OpenGL device and context implementation.             Version 1.07
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
// The Original Code is WGLDevices.pas.
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
 Classes, AbstractDevices, AsphyreSwapChains, AsphyreWGLContexts;

//---------------------------------------------------------------------------
type
 TWGLDevice = class(TAsphyreDevice)
 private
  FContexts: TOGLContexts;

  procedure UpdateVSync(VSyncEnabled: Boolean);

  procedure Clear(Color: Cardinal);
 protected
  function InitDevice(): Boolean; override;
  procedure DoneDevice(); override;

  procedure RenderWith(SwapChainIndex: Integer; Handler: TNotifyEvent;
   Background: Cardinal); override;

  procedure RenderToTarget(Handler: TNotifyEvent;
   Background: Cardinal; FillBk: Boolean); override;
 public
  property Contexts: TOGLContexts read FContexts;

  constructor Create(); override;
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 Windows, SysUtils, AsphyreGL, AsphyreEvents, OGLTypes;

//---------------------------------------------------------------------------
var
 OpenGLCreated: Boolean = False;

//---------------------------------------------------------------------------
constructor TWGLDevice.Create();
begin
 FContexts:= TOGLContexts.Create();

 inherited;

 FTechnology:= adtOpenGL;
end;

//---------------------------------------------------------------------------
destructor TWGLDevice.Destroy();
begin
 inherited;

 FreeAndNil(FContexts);
end;

//---------------------------------------------------------------------------
function TWGLDevice.InitDevice(): Boolean;
var
 UserDesc: PSwapChainDesc;
begin
 Result:= False;

 // (1) Check whether OpenGL has been created.
 if (not OpenGLCreated) then
  begin
   OpenGLCreated:= InitOpenGL();
   if (not OpenGLCreated) then Exit;
  end;

 // (2) Retrieve the first swap chain to be designated as the primary chain.
 UserDesc:= SwapChains[0];
 if (not Assigned(UserDesc)) then Exit;

 // (3) Create the context for the main window.
 Result:= FContexts.Activate(UserDesc.WindowHandle, 0);
 if (not Result) then Exit;

 // (4) Retrieve OpenGL extensions.
 ReadExtensions();
 ReadImplementationProperties();

 FTechVersion:= GetOpenGLTechVersion();

 // (5) Specify some default OpenGL states.
 glShadeModel(GL_SMOOTH);
 glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
end;

//---------------------------------------------------------------------------
procedure TWGLDevice.DoneDevice();
begin
 FContexts.RemoveAll();
end;

//---------------------------------------------------------------------------
procedure TWGLDevice.UpdateVSync(VSyncEnabled: Boolean);
var
 Interval: Integer;
begin
 if (not WGL_EXT_swap_control) then Exit;

 Interval:= wglGetSwapIntervalEXT();

 if (VSyncEnabled)and(Interval <> 1) then wglSwapIntervalEXT(1);
 if (not VSyncEnabled)and(Interval <> 0) then wglSwapIntervalEXT(0);
end;

//---------------------------------------------------------------------------
procedure TWGLDevice.Clear(Color: Cardinal);
begin
 glClearColor(
  ((Color shr 16) and $FF) / 255.0, ((Color shr 8) and $FF) / 255.0,
  (Color and $FF) / 255.0, ((Color shr 24) and $FF) / 255.0);

 glClearDepth(FillDepthValue);
 glClearStencil(GLint(FillStencilValue));

 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT or GL_STENCIL_BUFFER_BIT);
end;

//---------------------------------------------------------------------------
procedure TWGLDevice.RenderWith(SwapChainIndex: Integer; Handler: TNotifyEvent;
 Background: Cardinal);
var
 UserDesc, FirstDesc: PSwapChainDesc;
 Success: Boolean;
begin
 UserDesc:= SwapChains[SwapChainIndex];
 if (not Assigned(UserDesc)) then Exit;

 FirstDesc:= nil;
 if (SwapChainIndex <> 0) then FirstDesc:= SwapChains[0];

 if (Assigned(FirstDesc)) then
  Success:= FContexts.Activate(UserDesc.WindowHandle, FirstDesc.WindowHandle)
   else Success:= FContexts.Activate(UserDesc.WindowHandle, 0);

 if (not Success) then Exit;

 UpdateVSync(UserDesc.VSync);
 glViewport(0, 0, UserDesc.Width, UserDesc.Height);
 glDisable(GL_SCISSOR_TEST);

 Clear(Background);

 EventBeginScene.Notify(Self);
 Handler(Self);
 EventEndScene.Notify(Self);

 FContexts.Flip(UserDesc.WindowHandle);
end;

//---------------------------------------------------------------------------
procedure TWGLDevice.RenderToTarget(Handler: TNotifyEvent;
 Background: Cardinal; FillBk: Boolean);
begin
 OGLUsingFrameBuffer:= True;

 glDisable(GL_SCISSOR_TEST);

 if (FillBk) then Clear(Background);

 EventBeginScene.Notify(Self);
 Handler(Self);
 EventEndScene.Notify(Self);

 OGLUsingFrameBuffer:= False;
end;

//---------------------------------------------------------------------------
end.
