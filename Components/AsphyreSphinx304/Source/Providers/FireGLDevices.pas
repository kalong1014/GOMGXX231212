unit FireGLDevices;
//---------------------------------------------------------------------------
// FireOGLDevices.pas                                   Modified: 14-Sep-2012
// FireMonkey (Mac OS X) OpenGL device hook.                     Version 1.03
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
// The Original Code is FireOGLDevices.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Classes, AbstractDevices;

//---------------------------------------------------------------------------
type
 TFireGLDevice = class(TAsphyreDevice)
 private
  procedure Clear(Color: Cardinal);
 protected
  function InitDevice(): Boolean; override;
  procedure DoneDevice(); override;

  procedure RenderWith(SwapChainIndex: Integer; Handler: TNotifyEvent;
   Background: Cardinal); override;

  procedure RenderToTarget(Handler: TNotifyEvent;
   Background: Cardinal; FillBk: Boolean); override;
 public
  constructor Create(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 Macapi.OpenGL, AsphyreEvents, MonkeyTypes, OGLTypes;

//---------------------------------------------------------------------------
constructor TFireGLDevice.Create();
begin
 inherited;

 FTechnology:= adtOpenGL;
end;

//---------------------------------------------------------------------------
function TFireGLDevice.InitDevice(): Boolean;
begin
 FTechVersion:= GetOpenGLTechVersion();

 Result:= True;
end;

//---------------------------------------------------------------------------
procedure TFireGLDevice.DoneDevice();
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TFireGLDevice.Clear(Color: Cardinal);
begin
 glClearColor(
  ((Color shr 16) and $FF) / 255.0, ((Color shr 8) and $FF) / 255.0,
  (Color and $FF) / 255.0, ((Color shr 24) and $FF) / 255.0);

 glClearDepth(FillDepthValue);
 glClearStencil(FillStencilValue);

 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT or GL_STENCIL_BUFFER_BIT);
end;

//---------------------------------------------------------------------------
procedure TFireGLDevice.RenderWith(SwapChainIndex: Integer;
 Handler: TNotifyEvent; Background: Cardinal);
begin
 if (not FireContext.BeginScene()) then Exit;

 glViewport(0, 0, FireContext.Width, FireContext.Height);
 glDisable(GL_SCISSOR_TEST);

 Clear(Background);

 glShadeModel(GL_SMOOTH);
 glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
 glDisable(GL_CULL_FACE);
 glDisable(GL_DEPTH_TEST);

 glEnable(GL_TEXTURE_2D);

 glDisable(GL_VERTEX_PROGRAM_ARB);
 glDisable(GL_FRAGMENT_PROGRAM_ARB);

 glUseProgram(0);

 EventBeginScene.Notify(Self);

 Handler(Self);

 EventEndScene.Notify(Self);
 FireContext.EndScene();
end;

//---------------------------------------------------------------------------
procedure TFireGLDevice.RenderToTarget(Handler: TNotifyEvent;
 Background: Cardinal; FillBk: Boolean);
begin
 OGLUsingFrameBuffer:= True;

 if (FillBk) then Clear(Background);

 EventBeginScene.Notify(Self);
 Handler(Self);
 EventEndScene.Notify(Self);

 OGLUsingFrameBuffer:= False;
end;

//---------------------------------------------------------------------------
end.
