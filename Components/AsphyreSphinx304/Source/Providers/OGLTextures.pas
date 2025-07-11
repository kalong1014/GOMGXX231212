unit OGLTextures;
//---------------------------------------------------------------------------
// OGLTextures.pas                                      Modified: 14-Sep-2012
// OpenGL texture implementation.                                Version 1.06
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
// The Original Code is OGLTextures.pas.
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
 {$ifdef FireMonkey}Macapi.CocoaTypes, Macapi.OpenGL{$else}AsphyreGL{$endif},
 Types, AsphyreDef, AsphyreTypes, AbstractTextures, SystemSurfaces;

//---------------------------------------------------------------------------
type
 TOGLLockableTexture = class(TAsphyreLockableTexture)
 private
  FSurface: TSystemSurface;
  FTexture: GLuint;

  function CreateTextureSurface(): Boolean;
  procedure DestroyTextureSurface();
 protected
  procedure UpdateSize(); override;

  function CreateTexture(): Boolean; override;
  procedure DestroyTexture(); override;
 public
  property Surface: TSystemSurface read FSurface;

  property Texture: GLuint read FTexture;

  procedure Lock(const Rect: TRect; out Bits: Pointer;
   out Pitch: Integer); override;
  procedure Unlock(); override;

  procedure Bind(Stage: Integer); override;

  constructor Create(); override;
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 TOGLRenderTargetTexture = class(TAsphyreRenderTargetTexture)
 private
  FTexture: GLuint;
  FFrameBuffer: GLuint;
  FDepthBuffer: GLuint;

  function CreateTextureSurface(): Boolean;
  function CreateFrameObjects(): Boolean;
  function CreateTextureInstance(): Boolean;
  procedure DestroyTextureInstance();
 protected
  procedure UpdateSize(); override;

  function CreateTexture(): Boolean; override;
  procedure DestroyTexture(); override;
 public
  property Texture: GLuint read FTexture;

  property FrameBuffer: GLuint read FFrameBuffer;
  property DepthBuffer: GLuint read FDepthBuffer;

  procedure Bind(Stage: Integer); override;

  function BeginDrawTo(): Boolean; override;
  procedure EndDrawTo(); override;

  constructor Create(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 SysUtils, AsphyreFormats, OGLTypes;

//---------------------------------------------------------------------------
constructor TOGLLockableTexture.Create();
begin
 inherited;

 FSurface:= TSystemSurface.Create();
 FTexture:= 0;
end;

//---------------------------------------------------------------------------
destructor TOGLLockableTexture.Destroy();
begin
 FreeAndNil(FSurface);

 inherited;
end;

//---------------------------------------------------------------------------
function TOGLLockableTexture.CreateTextureSurface(): Boolean;
begin
 Result:= OGLCreateNewTexture(FTexture, Mipmapping);
 if (not Result) then Exit;

 Result:= OGLDefineTexture2D(Width, Height, FSurface.Bits);
 if (not Result) then Exit;

 if (Mipmapping) then OGLGenerateTextureMipmaps();

 OGLDisableTexture2D();
end;

//---------------------------------------------------------------------------
procedure TOGLLockableTexture.DestroyTextureSurface();
begin
 OGLDestroyTexture(FTexture);
end;

//---------------------------------------------------------------------------
function TOGLLockableTexture.CreateTexture(): Boolean;
begin
 FFormat:= apf_A8R8G8B8;

 FSurface.SetSize(Width, Height);
 FSurface.Clear($FF000000);

 Result:= CreateTextureSurface();
end;

//---------------------------------------------------------------------------
procedure TOGLLockableTexture.DestroyTexture();
begin
 DestroyTextureSurface();
end;

//---------------------------------------------------------------------------
procedure TOGLLockableTexture.UpdateSize();
begin
 DestroyTextureSurface();
 CreateTextureSurface();
end;

//---------------------------------------------------------------------------
procedure TOGLLockableTexture.Bind(Stage: Integer);
begin
 glBindTexture(GL_TEXTURE_2D, FTexture);
end;

//---------------------------------------------------------------------------
procedure TOGLLockableTexture.Lock(const Rect: TRect; out Bits: Pointer;
 out Pitch: Integer);
begin
 Bits := nil;
 Pitch:= 0;
 if (FTexture = 0) then Exit;

 if (FSurface.Width < 1)or(FSurface.Height < 1)or(Rect.Left < 0)or
  (Rect.Top < 0)or(Rect.Right > FSurface.Width)or
  (Rect.Bottom > FSurface.Height) then
  begin
   Bits := nil;
   Pitch:= 0;
   Exit;
  end;

 Pitch:= FSurface.Width * 4;

 Bits:= Pointer(PtrInt(FSurface.Bits) + (PtrInt(Pitch) * Rect.Top) +
  (PtrInt(Rect.Left) * 4));
end;

//---------------------------------------------------------------------------
procedure TOGLLockableTexture.Unlock();
begin
 if (FTexture = 0)or(FSurface.Width < 1)or(FSurface.Height < 1) then Exit;

 OGLUpdateTextureContents(FTexture, FSurface.Width, FSurface.Height,
  FSurface.Bits);

 if (Mipmapping) then OGLGenerateTextureMipmaps();

 OGLDisableTexture2D();
end;

//---------------------------------------------------------------------------
constructor TOGLRenderTargetTexture.Create();
begin
 inherited;

 FTexture:= 0;
 FFrameBuffer:= 0;
 FDepthBuffer:= 0;
end;

//---------------------------------------------------------------------------
function TOGLRenderTargetTexture.CreateTextureSurface(): Boolean;
begin
 Result:= OGLCreateNewTexture(FTexture, Mipmapping);
 if (not Result) then Exit;

 Result:= OGLDefineTexture2D(Width, Height);
 if (not Result) then Exit;

 if (Mipmapping) then OGLGenerateTextureMipmaps();

 OGLDisableTexture2D();
end;

//---------------------------------------------------------------------------
function TOGLRenderTargetTexture.CreateFrameObjects(): Boolean;
begin
 Result:= OGLCreateFrameBuffer(FFrameBuffer, FTexture);
 if (not Result) then Exit;

 if (DepthStencil) then
  begin
   Result:= OGLCreateDepthBuffer(Width, Height, FDepthBuffer);

   if (not Result) then
    begin
     glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
     Exit;
    end;
  end;

 if (Result) then
  begin
   Result:= glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT) =
    GL_FRAMEBUFFER_COMPLETE_EXT;
  end;

 glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
end;

//---------------------------------------------------------------------------
function TOGLRenderTargetTexture.CreateTextureInstance(): Boolean;
begin
 Result:= CreateTextureSurface();
 if (not Result) then Exit;

 Result:= CreateFrameObjects();
end;

//---------------------------------------------------------------------------
procedure TOGLRenderTargetTexture.DestroyTextureInstance();
begin
 glBindTexture(GL_TEXTURE_2D, 0);
 glDisable(GL_TEXTURE_2D);

 if (FDepthBuffer <> 0) then glDeleteRenderbuffersEXT(1, @FDepthBuffer);
 if (FFrameBuffer <> 0) then glDeleteFramebuffersEXT(1, @FFrameBuffer);

 if (FTexture <> 0) then glDeleteTextures(1, @FTexture);
end;

//---------------------------------------------------------------------------
function TOGLRenderTargetTexture.CreateTexture(): Boolean;
begin
 Result:= GL_EXT_framebuffer_object;
 if (not Result) then Exit;

 FFormat:= apf_A8R8G8B8;

 Result:= CreateTextureInstance();
end;

//---------------------------------------------------------------------------
procedure TOGLRenderTargetTexture.DestroyTexture();
begin
 DestroyTextureInstance();
end;

//---------------------------------------------------------------------------
procedure TOGLRenderTargetTexture.Bind(Stage: Integer);
begin
 glBindTexture(GL_TEXTURE_2D, FTexture);
end;

//---------------------------------------------------------------------------
function TOGLRenderTargetTexture.BeginDrawTo(): Boolean;
begin
 glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, FFrameBuffer);
 glViewport(0, 0, Width, Height);

 Result:= glGetError() = GL_NO_ERROR;
end;

//---------------------------------------------------------------------------
procedure TOGLRenderTargetTexture.EndDrawTo();
begin
 glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);

 if (Mipmapping) then
  begin
   glActiveTexture(GL_TEXTURE0);
   glEnable(GL_TEXTURE_2D);
   glBindTexture(GL_TEXTURE_2D, FTexture);

   OGLGenerateTextureMipmaps();
   OGLDisableTexture2D();
  end;
end;

//---------------------------------------------------------------------------
procedure TOGLRenderTargetTexture.UpdateSize();
begin
 DestroyTextureInstance();
 CreateTextureInstance();
end;

//---------------------------------------------------------------------------
end.
