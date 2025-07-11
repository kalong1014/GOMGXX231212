unit DX11Providers;
//---------------------------------------------------------------------------
// DX11Providers.pas                                    Modified: 14-Sep-2012
// DirectX 11 provider for Asphyre.                              Version 1.01
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
// The Original Code is DX11Providers.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//--------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
uses
 AsphyreFactory, AbstractDevices, AbstractCanvas, AbstractTextures,
 AbstractRasterizer;

//---------------------------------------------------------------------------
const
 idDirectX11 = $10000B00;

//---------------------------------------------------------------------------
type
 TDX11Provider = class(TAsphyreProvider)
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
 DX11Provider: TDX11Provider = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 SysUtils, DX11Devices, DX11Canvas, DX11Textures, DX11Rasterizer;

//---------------------------------------------------------------------------
constructor TDX11Provider.Create();
begin
 inherited;

 FProviderID:= idDirectX11;

 Factory.Subscribe(Self);
end;

//---------------------------------------------------------------------------
destructor TDX11Provider.Destroy();
begin
 Factory.Unsubscribe(Self, True);

 inherited;
end;

//---------------------------------------------------------------------------
function TDX11Provider.CreateDevice(): TAsphyreDevice;
begin
 Result:= TDX11Device.Create();
end;

//---------------------------------------------------------------------------
function TDX11Provider.CreateCanvas(): TAsphyreCanvas;
begin
 Result:= TDX11Canvas.Create();
end;

//---------------------------------------------------------------------------
function TDX11Provider.CreateRasterizer(): TAsphyreRasterizer;
begin
 Result:= TDX11Rasterizer.Create();
end;

//---------------------------------------------------------------------------
function TDX11Provider.CreateLockableTexture(): TAsphyreLockableTexture;
begin
 Result:= TDX11LockableTexture.Create();
end;

//---------------------------------------------------------------------------
function TDX11Provider.CreateRenderTargetTexture(): TAsphyreRenderTargetTexture;
begin
 Result:= TDX11RenderTargetTexture.Create();
end;

//---------------------------------------------------------------------------
initialization
 DX11Provider:= TDX11Provider.Create();

//---------------------------------------------------------------------------
finalization
 FreeAndNil(DX11Provider);

//---------------------------------------------------------------------------
end.
