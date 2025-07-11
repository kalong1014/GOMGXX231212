unit XGLProviders;
//---------------------------------------------------------------------------
// XGLProviders.pas                                     Modified: 14-Sep-2012
// Linux OpenGL support provider.                                 Version 1.0
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
// The Original Code is XGLProviders.pas.
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
 AsphyreFactory, AbstractDevices, AbstractCanvas, AbstractTextures,
 AbstractRasterizer;

//---------------------------------------------------------------------------
const
 idLinuxOpenGL = $20002001;

//---------------------------------------------------------------------------
type
 TXGLProvider = class(TAsphyreProvider)
 private
 public
  function CreateDevice(): TAsphyreDevice; override;
  function CreateCanvas(): TAsphyreCanvas; override;
  function CreateRasterizer(): TAsphyreRasterizer; override;
  function CreateLockableTexture(): TAsphyreLockableTexture; override;
  function CreateRenderTargetTexture(): TAsphyreRenderTargetTexture; override;

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
var
 XGLProvider: TXGLProvider = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 SysUtils, XGLDevices, 
 {$ifdef LegacyGL}OGLCanvasMini,{$else}OGLCanvas,{$endif}
 {$ifdef LegacyGL}OGLRasterizerMini,{$else}OGLRasterizer,{$endif}
 OGLTextures;

//---------------------------------------------------------------------------
constructor TXGLProvider.Create();
begin
 inherited;

 FProviderID:= idLinuxOpenGL;

 Factory.Subscribe(Self);
end;

//---------------------------------------------------------------------------
destructor TXGLProvider.Destroy();
begin
 Factory.Unsubscribe(Self, True);

 inherited;
end;

//---------------------------------------------------------------------------
function TXGLProvider.CreateDevice(): TAsphyreDevice;
begin
 Result:= TXGLDevice.Create();
end;

//---------------------------------------------------------------------------
function TXGLProvider.CreateCanvas(): TAsphyreCanvas;
begin
 {$ifdef LegacyGL}
 Result:= TOGLCanvasMini.Create();
 {$else}
 Result:= TOGLCanvas.Create();
 {$endif}
end;

//---------------------------------------------------------------------------
function TXGLProvider.CreateRasterizer(): TAsphyreRasterizer;
begin
 {$ifdef LegacyGL}
 Result:= TOGLRasterizerMini.Create();
 {$else}
 Result:= TOGLRasterizer.Create();
 {$endif}
end;

//---------------------------------------------------------------------------
function TXGLProvider.CreateLockableTexture(): TAsphyreLockableTexture;
begin
 Result:= TOGLLockableTexture.Create();
end;

//---------------------------------------------------------------------------
function TXGLProvider.CreateRenderTargetTexture(): TAsphyreRenderTargetTexture;
begin
 Result:= TOGLRenderTargetTexture.Create();
end;

//---------------------------------------------------------------------------
initialization
 XGLProvider:= TXGLProvider.Create();

//---------------------------------------------------------------------------
finalization
 FreeAndNil(XGLProvider);

//---------------------------------------------------------------------------
end.
