unit DX9Providers;
//---------------------------------------------------------------------------
// DX9Providers.pas                                     Modified: 14-Sep-2012
// Direct3D 9 provider for Asphyre.                              Version 1.02
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
// The Original Code is DX9Providers.pas.
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
 SysUtils, AsphyreFactory, AbstractDevices, AbstractCanvas, AbstractTextures,
 AbstractRasterizer;

//---------------------------------------------------------------------------
const
 idDirectX9 = $10000900;

//---------------------------------------------------------------------------
type
 TDX9Provider = class(TAsphyreProvider)
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
 DX9Provider: TDX9Provider = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 DX9Devices, DX9Canvas, DX9Textures, DX9Rasterizer;

//---------------------------------------------------------------------------
constructor TDX9Provider.Create();
begin
 inherited;

 FProviderID:= idDirectX9;

 Factory.Subscribe(Self);
end;

//---------------------------------------------------------------------------
destructor TDX9Provider.Destroy();
begin
 Factory.Unsubscribe(Self, True);

 inherited;
end;

//---------------------------------------------------------------------------
function TDX9Provider.CreateDevice(): TAsphyreDevice;
begin
 Result:= TDX9Device.Create();
end;

//---------------------------------------------------------------------------
function TDX9Provider.CreateCanvas(): TAsphyreCanvas;
begin
 Result:= TDX9Canvas.Create();
end;

//---------------------------------------------------------------------------
function TDX9Provider.CreateRasterizer(): TAsphyreRasterizer;
begin
 Result:= TDX9Rasterizer.Create();
end;

//---------------------------------------------------------------------------
function TDX9Provider.CreateLockableTexture(): TAsphyreLockableTexture;
begin
 Result:= TDX9LockableTexture.Create();
end;

//---------------------------------------------------------------------------
function TDX9Provider.CreateRenderTargetTexture(): TAsphyreRenderTargetTexture;
begin
 Result:= TDX9RenderTargetTexture.Create();
end;

//---------------------------------------------------------------------------
initialization
 DX9Provider:= TDX9Provider.Create();

//---------------------------------------------------------------------------
finalization
 FreeAndNil(DX9Provider);

//---------------------------------------------------------------------------
end.
