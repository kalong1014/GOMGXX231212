unit DX10Providers;
//---------------------------------------------------------------------------
// DX10Providers.pas                                    Modified: 14-Sep-2012
// DirectX 10 provider for Asphyre.                               Version 1.0
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
// The Original Code is DX10Providers.pas.
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
 idDirectX10 = $10000A00;

//---------------------------------------------------------------------------
type
 TDX10Provider = class(TAsphyreProvider)
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
 DX10Provider: TDX10Provider = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 DX10Devices, DX10Canvas, DX10Textures, DX10Rasterizer;

//---------------------------------------------------------------------------
constructor TDX10Provider.Create();
begin
 inherited;

 FProviderID:= idDirectX10;

 Factory.Subscribe(Self);
end;

//---------------------------------------------------------------------------
destructor TDX10Provider.Destroy();
begin
 Factory.Unsubscribe(Self, True);

 inherited;
end;

//---------------------------------------------------------------------------
function TDX10Provider.CreateDevice(): TAsphyreDevice;
begin
 Result:= TDX10Device.Create();
end;

//---------------------------------------------------------------------------
function TDX10Provider.CreateCanvas(): TAsphyreCanvas;
begin
 Result:= TDX10Canvas.Create();
end;

//---------------------------------------------------------------------------
function TDX10Provider.CreateRasterizer: TAsphyreRasterizer;
begin
 Result:= TDX10Rasterizer.Create();
end;

//---------------------------------------------------------------------------
function TDX10Provider.CreateLockableTexture(): TAsphyreLockableTexture;
begin
 Result:= TDX10LockableTexture.Create();
end;

//---------------------------------------------------------------------------
function TDX10Provider.CreateRenderTargetTexture(): TAsphyreRenderTargetTexture;
begin
 Result:= TDX10RenderTargetTexture.Create();
end;

//---------------------------------------------------------------------------
initialization
 DX10Provider:= TDX10Provider.Create();

//---------------------------------------------------------------------------
finalization
 FreeAndNil(DX10Provider);

//---------------------------------------------------------------------------
end.
