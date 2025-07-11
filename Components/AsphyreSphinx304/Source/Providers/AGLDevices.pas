unit AGLDevices;
//---------------------------------------------------------------------------
// AGLDevices.pas                                       Modified: 14-Sep-2012
// Apple OpenGL context (via Carbon API) implementation.         Version 1.01
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
// The Original Code is AGLDevices.pas.
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
 AGL, Classes, AbstractDevices, AsphyreSwapChains;

//---------------------------------------------------------------------------
type
 TAGLDevice = class(TAsphyreDevice)
 private
  Context: TAGLContext;

  function InitAGL(): Boolean;
  procedure Clear(Color: Cardinal);
 protected
  function InitDevice(): Boolean; override;
  procedure DoneDevice(); override;

  function ResizeSwapChain(SwapChainIndex: Integer;
   NewUserDesc: PSwapChainDesc): Boolean; override;

  procedure RenderWith(SwapChainIndex: Integer; Handler: TNotifyEvent;
   Background: Cardinal); override;

  procedure RenderToTarget(Handler: TNotifyEvent;
   Background: Cardinal; FillBk: Boolean); override;
 public
  constructor Create(); override;
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 MacOSAll, CarbonDef, CarbonPrivate, AsphyreGL, SysUtils, AsphyreEvents,
 OGLTypes;

//---------------------------------------------------------------------------
var
 OpenGLCreated: Boolean = False;

//---------------------------------------------------------------------------
const
 Attribs8x: array[0..18] of Integer = (
  AGL_WINDOW, AGL_DOUBLEBUFFER, AGL_RGBA,
  AGL_RED_SIZE, 8, AGL_GREEN_SIZE, 8, AGL_BLUE_SIZE, 8,
  AGL_DEPTH_SIZE, 24, AGL_STENCIL_SIZE, 8,
  AGL_SAMPLE_BUFFERS_ARB, 1, AGL_MULTISAMPLE,
  AGL_SAMPLES_ARB, 8, AGL_NONE);

//---------------------------------------------------------------------------
 Attribs4x: array[0..18] of Integer = (
  AGL_WINDOW, AGL_DOUBLEBUFFER, AGL_RGBA,
  AGL_RED_SIZE, 8, AGL_GREEN_SIZE, 8, AGL_BLUE_SIZE, 8,
  AGL_DEPTH_SIZE, 24, AGL_STENCIL_SIZE, 8,
  AGL_SAMPLE_BUFFERS_ARB, 1, AGL_MULTISAMPLE,
  AGL_SAMPLES_ARB, 4, AGL_NONE);

//---------------------------------------------------------------------------
 Attribs2x: array[0..18] of Integer = (
  AGL_WINDOW, AGL_DOUBLEBUFFER, AGL_RGBA,
  AGL_RED_SIZE, 8, AGL_GREEN_SIZE, 8, AGL_BLUE_SIZE, 8,
  AGL_DEPTH_SIZE, 24, AGL_STENCIL_SIZE, 8,
  AGL_SAMPLE_BUFFERS_ARB, 1, AGL_MULTISAMPLE,
  AGL_SAMPLES_ARB, 2, AGL_NONE);

//---------------------------------------------------------------------------
 Attribs1x: array[0..13] of Integer = (
  AGL_WINDOW, AGL_DOUBLEBUFFER, AGL_RGBA,
  AGL_RED_SIZE, 8, AGL_GREEN_SIZE, 8, AGL_BLUE_SIZE, 8,
  AGL_DEPTH_SIZE, 24, AGL_STENCIL_SIZE, 8, AGL_NONE);

//---------------------------------------------------------------------------
constructor TAGLDevice.Create();
begin
 inherited;

 FTechnology:= adtOpenGL;
end;

//---------------------------------------------------------------------------
destructor TAGLDevice.Destroy();
begin

 inherited;
end;

//---------------------------------------------------------------------------
function TAGLDevice.InitAGL(): Boolean;
var
 UserDesc: PSwapChainDesc;
 Disp: GDHandle;
 PixelFormat: TAGLPixelFormat;
begin
 Result:= False;

 UserDesc:= SwapChains[0];
 if (not Assigned(UserDesc)) then Exit;

 Disp:= GetMainDevice();

 PixelFormat:= nil;

 if (UserDesc.Multisamples >= 8) then
  PixelFormat:= aglChoosePixelFormat(@Disp, 1, @Attribs8x[0]);

 if (not Assigned(PixelFormat))and(UserDesc.Multisamples >= 4) then
  PixelFormat:= aglChoosePixelFormat(@Disp, 1, @Attribs4x[0]);

 if (not Assigned(PixelFormat))and(UserDesc.Multisamples >= 2) then
  PixelFormat:= aglChoosePixelFormat(@Disp, 1, @Attribs2x[0]);

 if (not Assigned(PixelFormat)) then
  PixelFormat:= aglChoosePixelFormat(@Disp, 1, @Attribs1x[0]);

 if (not Assigned(PixelFormat)) then Exit;

 Context:= aglCreateContext(PixelFormat, nil);
 aglDestroyPixelFormat(PixelFormat);

 if (not Assigned(Context)) then Exit;

 aglSetDrawable(Context,
  GetWindowPort(TCarbonWindow(UserDesc.WindowHandle).Window));

 Result:= aglSetCurrentContext(Context) <> 0;
end;

//---------------------------------------------------------------------------
function TAGLDevice.InitDevice(): Boolean;
begin
 Result:= False;

 // (1) Load basic OpenGL functions.
 if (not OpenGLCreated) then
  begin
   OpenGLCreated:= InitOpenGL();
   if (not OpenGLCreated) then Exit;
  end;

 // (2) Create Apple OpenGL context for the main window.
 Result:= InitAGL();
 if (not Result) then Exit;

 // (3) Retrieve OpenGL extensions.
 ReadExtensions();
 ReadImplementationProperties();

 FTechVersion:= GetOpenGLTechVersion();

 // (4) Specify some default OpenGL states.
 glShadeModel(GL_SMOOTH);
 glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
end;

//---------------------------------------------------------------------------
procedure TAGLDevice.DoneDevice();
begin
 if (Assigned(Context)) then
  begin
   aglDestroyContext(Context);
   Context:= nil;
  end;
end;

//---------------------------------------------------------------------------
function TAGLDevice.ResizeSwapChain(SwapChainIndex: Integer;
 NewUserDesc: PSwapChainDesc): Boolean;
var
 UserDesc: PSwapChainDesc;
 Window: TCarbonWindow;
 CrWin: WindowRef;
 RegRect: MacOSAll.Rect;
 ViewBounds: HIRect;
 Values: array [0..3] of Integer;
begin
 Result:= False;
 if (SwapChainIndex <> 0) then Exit;

 UserDesc:= SwapChains[0];
 if (not Assigned(UserDesc)) then Exit;

 Window:= TCarbonWindow(UserDesc.WindowHandle);

 CrWin:= HIViewGetWindow(Window.Widget);
 if (not Assigned(CrWin)) then Exit;

 GetWindowBounds(CrWin, kWindowStructureRgn, RegRect);

 HIViewGetBounds(Window.Widget, ViewBounds);
 HIViewConvertPoint(ViewBounds.origin, Window.Widget, nil);

 Values[0]:= Round(ViewBounds.origin.x);
 Values[1]:= Round((RegRect.bottom - RegRect.top) - ViewBounds.origin.y -
  ViewBounds.size.height);
 Values[2]:= Round(ViewBounds.size.width);
 Values[3]:= Round(ViewBounds.size.height);

 aglEnable(Context, AGL_BUFFER_RECT);
 aglSetInteger(Context, AGL_BUFFER_RECT, @Values[0]);

 UserDesc.Width := NewUserDesc.Width;
 UserDesc.Height:= NewUserDesc.Height;

 Result:= True;
end;

//---------------------------------------------------------------------------
procedure TAGLDevice.Clear(Color: Cardinal);
begin
 glClearColor(
  ((Color shr 16) and $FF) / 255.0, ((Color shr 8) and $FF) / 255.0,
  (Color and $FF) / 255.0, ((Color shr 24) and $FF) / 255.0);

 glClearDepth(FillDepthValue);
 glClearStencil(GLint(FillStencilValue));

 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT or GL_STENCIL_BUFFER_BIT);
end;

//---------------------------------------------------------------------------
procedure TAGLDevice.RenderWith(SwapChainIndex: Integer; Handler: TNotifyEvent;
 Background: Cardinal);
var
 UserDesc: PSwapChainDesc;
 Success: Boolean;
begin
 UserDesc:= SwapChains[SwapChainIndex];
 if (not Assigned(UserDesc)) then Exit;

 glViewport(0, 0, UserDesc.Width, UserDesc.Height);
 glDisable(GL_SCISSOR_TEST);

 Clear(Background);

 EventBeginScene.Notify(Self);
 Handler(Self);
 EventEndScene.Notify(Self);

 aglSwapBuffers(Context);
end;

//---------------------------------------------------------------------------
procedure TAGLDevice.RenderToTarget(Handler: TNotifyEvent;
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
