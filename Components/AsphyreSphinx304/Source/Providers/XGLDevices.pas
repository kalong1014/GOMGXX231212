unit XGLDevices;
//---------------------------------------------------------------------------
// XGLDevices.pas                                       Modified: 14-Sep-2012
// Linux OpenGL device and context implementation.               Version 1.02
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
// The Original Code is XGLDevices.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// This file contains code for extraction of X-window ID that was kindly
// provided by Andrey Kemka, the developer of ZenGL library. Thank you!
//---------------------------------------------------------------------------

interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
uses
 XLib, XUtil, GTK2, GLX, Classes, AbstractDevices, AsphyreSwapChains;

//---------------------------------------------------------------------------
type
 TXGLDevice = class(TAsphyreDevice)
 private
  Display: PDisplay;
  Context: GLXContext;
  
  Widget: PGtkWidget;
  Drawable: GLXDrawable;

  function UpdateGLXVersion(Display: PDisplay): Boolean;

  function CreateDrawable(Handle: THandle): Boolean;
  procedure DestroyDrawable();

  function GetStdVisualInfo(Display: PDisplay): PXVisualInfo;
  function GetExtVisualInfo(Display: PDisplay): PXVisualInfo;

  function InitGLX(): Boolean;
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
 X, GDK2x, GTK2Proc, AsphyreGL, SysUtils, AsphyreEvents, OGLTypes;

//---------------------------------------------------------------------------
var
 OpenGLCreated: Boolean = False;

//---------------------------------------------------------------------------
constructor TXGLDevice.Create();
begin
 Widget:= nil;
 Drawable:= 0;

 inherited;
 
 FTechnology:= adtOpenGL;
end;

//---------------------------------------------------------------------------
destructor TXGLDevice.Destroy();
begin

 inherited;
end;

//---------------------------------------------------------------------------
function TXGLDevice.UpdateGLXVersion(Display: PDisplay): Boolean;
var
 GlxMajor, GlxMinor: Integer;
begin
 Result:= glXQueryVersion(Display, @GlxMajor, @GlxMinor);
 if (not Result) then Exit;

 if (GlxMajor >= 1)and(GlxMinor >= 3) then GLX_VERSION_1_3:= True;
 if (GlxMajor >= 1)and(GlxMinor >= 4) then GLX_VERSION_1_4:= True;
end;

//---------------------------------------------------------------------------
function TXGLDevice.CreateDrawable(Handle: THandle): Boolean;
begin
 Result:= False;

 Widget:= GetFixedWidget(PGtkWidget(Handle));
 if (not Assigned(Widget)) then Exit;

 gtk_widget_realize(Widget);

 Drawable:= GDK_WINDOW_XID(Widget.window);

 Result:= Drawable <> 0;
 if (not Result) then
   begin
    gtk_widget_unrealize(Widget);
    Widget:= nil;
   end;
end;

//---------------------------------------------------------------------------
procedure TXGLDevice.DestroyDrawable();
begin
 if (Assigned(Widget)) then
  begin
   gtk_widget_unrealize(Widget);
   Widget:= nil;
  end;
end;

//---------------------------------------------------------------------------
function TXGLDevice.GetStdVisualInfo(Display: PDisplay): PXVisualInfo;
const
 Attribs: array[0..6] of Integer = (GLX_DOUBLEBUFFER, GLX_RGBA,
  GLX_DEPTH_SIZE, 24, GLX_STENCIL_SIZE, 8, None);
begin
 Result:= glXChooseVisual(Display, DefaultScreen(Display), @Attribs[0]);
end;

//---------------------------------------------------------------------------
function TXGLDevice.GetExtVisualInfo(Display: PDisplay): PXVisualInfo;
const
 InitAttribs: array[0..20] of Integer = (GLX_X_RENDERABLE, GL_TRUE,
  GLX_DRAWABLE_TYPE, GLX_WINDOW_BIT, GLX_RENDER_TYPE, GLX_RGBA_BIT,
  GLX_X_VISUAL_TYPE, GLX_TRUE_COLOR, GLX_RED_SIZE, 8, GLX_GREEN_SIZE, 8,
  GLX_BLUE_SIZE, 8, GLX_DOUBLEBUFFER, GL_TRUE, GLX_SAMPLE_BUFFERS, 1,
  GLX_SAMPLES, 8, None);
var
 UserDesc : PSwapChainDesc;
 Attribs  : array[0..20] of Integer;
 FBConfigs: PGLXFBConfig;
 FBCount  : Integer;
begin
 Result:= nil;

 UserDesc:= SwapChains[0];
 if (not Assigned(UserDesc)) then Exit;

 Move(InitAttribs, Attribs, SizeOf(InitAttribs));

 // 8x multisampling
 FBCount:= 0;

 if (UserDesc.Multisamples >= 8) then
  FBConfigs:= glXChooseFBConfig(Display, DefaultScreen(Display),
   @Attribs[0], @FBCount);

 // 4x multisampling
 if (FBCount < 1)and(UserDesc.Multisamples >= 4) then
  begin
   Attribs[19]:= 4;

   FBConfigs:= glXChooseFBConfig(Display, DefaultScreen(Display),
    @Attribs[0], @FBCount);
  end;

 // 2x multisampling
 if (FBCount < 1)and(UserDesc.Multisamples >= 2) then
  begin
   Attribs[19]:= 2;

   FBConfigs:= glXChooseFBConfig(Display, DefaultScreen(Display),
    @Attribs[0], @FBCount);
  end;

 // No multisampling
 if (FBCount < 1) then
  begin
   Attribs[16]:= None;
   Attribs[17]:= 0;
   Attribs[18]:= 0;
   Attribs[19]:= 0;
   Attribs[20]:= 0;

   FBConfigs:= glXChooseFBConfig(Display, DefaultScreen(Display),
    @Attribs[0], @FBCount);
  end;

 if (FBCount < 1)or(not Assigned(FBConfigs)) then Exit;

 Result:= glXGetVisualFromFBConfig(Display, FBConfigs^);

 XFree(FBConfigs);
end;

//---------------------------------------------------------------------------
function TXGLDevice.InitGLX(): Boolean;
var
 VisualInfo: PXVisualInfo;
 FBConfigs, InpConfig: PGLXFBConfig;
 FBCount, i, NoSamplBuffers, NoSamples: Integer;
 BestConfig: GLXFBConfig;
begin
 Result:= False;

 Display:= GDK_DISPLAY;
 if (not UpdateGLXVersion(Display)) then Exit;

 VisualInfo:= nil;

 if (GLX_VERSION_1_3) then
  VisualInfo:= GetExtVisualInfo(Display);

 if (not Assigned(VisualInfo)) then
  VisualInfo:= GetStdVisualInfo(Display);

 if (not Assigned(VisualInfo)) then Exit;

 Context:= glXCreateContext(Display, VisualInfo, nil, True);

 XFree(VisualInfo);

 if (not Assigned(Context)) then Exit;

 glXMakeCurrent(Display, Drawable, Context);
 
 Result:= True;
end;

//---------------------------------------------------------------------------
function TXGLDevice.InitDevice(): Boolean;
var
 UserDesc: PSwapChainDesc;
begin
 Result:= False;

 UserDesc:= SwapChains[0];
 if (not Assigned(UserDesc)) then Exit;

 Result:= CreateDrawable(UserDesc.WindowHandle);
 if (not Result) then Exit;

 if (not OpenGLCreated) then
  begin
   OpenGLCreated:= InitOpenGL();
   if (not OpenGLCreated) then
    begin
     DestroyDrawable();
     Exit;
    end;
  end;

 Result:= InitGLX();
 if (not Result) then
  begin
   DestroyDrawable();
   Exit;
  end;

 ReadExtensions();
 ReadImplementationProperties();

 FTechVersion:= GetOpenGLTechVersion();

 glShadeModel(GL_SMOOTH);
 glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
end;

//---------------------------------------------------------------------------
procedure TXGLDevice.DoneDevice();
begin
 DestroyDrawable();
 Display:= nil;
end;

//---------------------------------------------------------------------------
function TXGLDevice.ResizeSwapChain(SwapChainIndex: Integer;
 NewUserDesc: PSwapChainDesc): Boolean;
begin
 Result:= True;
end;

//---------------------------------------------------------------------------
procedure TXGLDevice.Clear(Color: Cardinal);
begin
 glClearColor(
  ((Color shr 16) and $FF) / 255.0, ((Color shr 8) and $FF) / 255.0,
  (Color and $FF) / 255.0, ((Color shr 24) and $FF) / 255.0);

 glClearDepth(FillDepthValue);
 glClearStencil(GLint(FillStencilValue));

 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT or GL_STENCIL_BUFFER_BIT);
end;

//---------------------------------------------------------------------------
procedure TXGLDevice.RenderWith(SwapChainIndex: Integer; Handler: TNotifyEvent;
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

 glXSwapBuffers(Display, Drawable);
end;

//---------------------------------------------------------------------------
procedure TXGLDevice.RenderToTarget(Handler: TNotifyEvent;
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
