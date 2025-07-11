unit DX11Rasterizer;
//---------------------------------------------------------------------------
// DX11Rasterizer.pas                                   Modified: 14-Sep-2012
// Direct3D 11 Canvas implementation.                            Version 1.02
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
// The Original Code is DX11Rasterizer.pas.
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
 Windows, D3D11_JSB, Types, AsphyreDef, Vectors2, Vectors4, AsphyreTypes,
 AbstractTextures, AbstractRasterizer, DX11ShaderEffects;

//---------------------------------------------------------------------------
type
 TDX11RasterizerProgram = (rpUnknown, rpSolid, rpTextured);

//---------------------------------------------------------------------------
 TDX11Rasterizer = class(TAsphyreRasterizer)
 private
  SolidEffect: TDX11ShaderEffect;
  TexturedEffect: TDX11ShaderEffect;

  RasterState: ID3D11RasterizerState;
  DepthStencilState: ID3D11DepthStencilState;
  SamplerState: ID3D11SamplerState;

  VertexBuffer: ID3D11Buffer;
  VertexArray : Pointer;

  BlendingStates: array[TRasterEffect] of ID3D11BlendState;

  ActiveProgram: TDX11RasterizerProgram;
  ActiveEffect : TDX11ShaderEffect;

  FVertexCount: Integer;

  ActiveTexture  : TAsphyreCustomTexture;
  ActiveTexCoords: TPoint4;

  CachedTexture: TAsphyreCustomTexture;
  CachedBlend  : TRasterEffect;

  NormalSize : TPoint2;
  FAntialias : Boolean;
  FMipmapping: Boolean;
  ScissorRect: TRect;

  procedure CreateEffects();
  procedure DestroyEffects();

  function InitializeEffects(): Boolean;
  procedure FinalizeEffects();

  procedure CreateSystemBuffers();
  procedure DestroySystemBuffers();

  function CreateVertexBuffer(): Boolean;
  procedure DestroyVertexBuffer();

  function CreateDeviceStates(): Boolean;
  procedure DestroyDeviceStates();

  procedure CreateBlendStates();
  procedure DestroyBlendStates();

  function CreateDynamicObjects(): Boolean;
  procedure DestroyDynamicObjects();

  procedure ResetRasterState();
  procedure ResetDepthStencilState();

  procedure ResetActiveTexture();

  procedure UpdateSamplerState();
  procedure ResetSamplerState();

  function UploadVertexBuffer(): Boolean;
  procedure DrawBuffers();

  function NextVertexEntry(): Pointer;
  procedure AddVertexEntry(const Position: TVector4; const TexAt: TPoint2;
   DiffuseColor, SpecularColor: Cardinal);

  function RequestCache(NewProgram: TDX11RasterizerProgram; Vertices: Integer;
   RasterType: TRasterEffect; Texture: TAsphyreCustomTexture): Boolean;
 protected
  function HandleDeviceCreate(): Boolean; override;
  procedure HandleDeviceDestroy(); override;
  function HandleDeviceReset(): Boolean; override;
  procedure HandleDeviceLost(); override;

  procedure HandleBeginScene(); override;
  procedure HandleEndScene(); override;

  procedure GetViewport(out x, y, Width, Height: Integer); override;
  procedure SetViewport(x, y, Width, Height: Integer); override;
 public
  procedure FillTri(const Vtx0, Vtx1, Vtx2: TVector4; Diffuse0, Diffuse1,
   Diffuse2, Specular0, Specular1, Specular2: Cardinal;
   Effect: TRasterEffect = reNormal); override;

  procedure UseTexture(Texture: TAsphyreCustomTexture); override;

  procedure TexMap(const Vtx0, Vtx1, Vtx2: TVector4; Tex0, Tex1, Tex2: TPoint2;
   Diffuse0, Diffuse1, Diffuse2, Specular0, Specular1, Specular2: Cardinal;
   Effect: TRasterEffect = reNormal); override;

  procedure Flush(); override;
  procedure ResetStates(); override;

  constructor Create(); override;
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//--------------------------------------------------------------------------
uses
 DXGI_JSB, D3DCommon_JSB, SysUtils, AsphyreFPUStates, PixelUtils, DX11Types,
 DX11ShaderCodes;

//--------------------------------------------------------------------------
const
 // The following parameters roughly affect the rendering performance. The
 // higher values means that more primitives will fit in cache, but it will
 // also occupy more bandwidth, even when few primitives are rendered.
 //
 // These parameters can be fine-tuned in a finished product to improve the
 // overall performance.
 MaxCachedVertices = 4096;

//---------------------------------------------------------------------------
 CanvasVertexLayout: array[0..3] of D3D11_INPUT_ELEMENT_DESC =
 ((SemanticName: 'POSITION';
   SemanticIndex: 0;
   Format: DXGI_FORMAT_R32G32B32A32_FLOAT;
   InputSlot: 0;
   AlignedByteOffset: 0;
   InputSlotClass: D3D11_INPUT_PER_VERTEX_DATA;
   InstanceDataStepRate: 0),

  (SemanticName: 'TEXCOORD';
   SemanticIndex: 0;
   Format: DXGI_FORMAT_R32G32_FLOAT;
   InputSlot: 0;
   AlignedByteOffset: 16;
   InputSlotClass: D3D11_INPUT_PER_VERTEX_DATA;
   InstanceDataStepRate: 0),

  (SemanticName: 'COLOR';
   SemanticIndex: 0;
   Format: DXGI_FORMAT_R8G8B8A8_UNORM;
   InputSlot: 0;
   AlignedByteOffset: 24;
   InputSlotClass: D3D11_INPUT_PER_VERTEX_DATA;
   InstanceDataStepRate: 0),

  (SemanticName: 'COLOR';
   SemanticIndex: 1;
   Format: DXGI_FORMAT_R8G8B8A8_UNORM;
   InputSlot: 0;
   AlignedByteOffset: 28;
   InputSlotClass: D3D11_INPUT_PER_VERTEX_DATA;
   InstanceDataStepRate: 0));

//--------------------------------------------------------------------------
type
 PVertexRecord = ^TVertexRecord;
 TVertexRecord = packed record
  x, y, z, w: Single;
  u, v: Single;
  DiffuseColor : LongWord;
  SpecularColor: LongWord;
 end;

//--------------------------------------------------------------------------
constructor TDX11Rasterizer.Create();
begin
 inherited;

 CreateEffects();

 VertexArray := nil;
 VertexBuffer:= nil;
end;

//---------------------------------------------------------------------------
destructor TDX11Rasterizer.Destroy();
begin
 DestroyDynamicObjects();
 DestroySystemBuffers();

 DestroyEffects();

 inherited;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.CreateEffects();
begin
 // (1) Solid canvas effect.
 SolidEffect:= TDX11ShaderEffect.Create();

 SolidEffect.SetVertexLayout(@CanvasVertexLayout[0],
  High(CanvasVertexLayout) + 1);

 SolidEffect.SetShaderCodes(@RasterVertex[0], High(RasterVertex) + 1,
  @RasterSolid[0], High(RasterSolid) + 1);

 // (2) Textured canvas effect.
 TexturedEffect:= TDX11ShaderEffect.Create();

 TexturedEffect.SetVertexLayout(@CanvasVertexLayout[0],
  High(CanvasVertexLayout) + 1);

 TexturedEffect.SetShaderCodes(@RasterVertex[0], High(RasterVertex) + 1,
  @RasterTextured[0], High(RasterTextured) + 1);
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.DestroyEffects();
begin
 if (Assigned(TexturedEffect)) then FreeAndNil(TexturedEffect);
 if (Assigned(SolidEffect)) then FreeAndNil(SolidEffect);
end;

//---------------------------------------------------------------------------
function TDX11Rasterizer.InitializeEffects(): Boolean;
begin
 Result:= SolidEffect.Initialize();
 if (not Result) then Exit;

 Result:= TexturedEffect.Initialize();
 if (not Result) then
  begin
   SolidEffect.Finalize();
   Exit;
  end;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.FinalizeEffects();
begin
 if (Assigned(TexturedEffect)) then
  TexturedEffect.Finalize();

 if (Assigned(SolidEffect)) then
  SolidEffect.Finalize();
 end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.CreateSystemBuffers();
begin
 VertexArray:= AllocMem(MaxCachedVertices * SizeOf(TVertexRecord));
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.DestroySystemBuffers();
begin
 if (Assigned(VertexArray)) then
  FreeNullMem(VertexArray);
end;

//---------------------------------------------------------------------------
function TDX11Rasterizer.CreateVertexBuffer(): Boolean;
var
 Desc: D3D11_BUFFER_DESC;
begin
 Result:= Assigned(D3D11Device);
 if (not Result) then Exit;

 FillChar(Desc, SizeOf(D3D11_BUFFER_DESC), 0);

 Desc.ByteWidth:= SizeOf(TVertexRecord) * MaxCachedVertices;
 Desc.Usage    := D3D11_USAGE_DYNAMIC;
 Desc.BindFlags:= Ord(D3D11_BIND_VERTEX_BUFFER);
 Desc.MiscFlags:= 0;
 Desc.CPUAccessFlags:= Ord(D3D11_CPU_ACCESS_WRITE);

 PushClearFPUState();
 try
  Result:= Succeeded(D3D11Device.CreateBuffer(Desc, nil, VertexBuffer));
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.DestroyVertexBuffer();
begin
 if (Assigned(VertexBuffer)) then VertexBuffer:= nil;
end;

//--------------------------------------------------------------------------
function TDX11Rasterizer.CreateDeviceStates(): Boolean;
var
 RasterDesc: D3D11_RASTERIZER_DESC;
 DepthStencilDesc: D3D11_DEPTH_STENCIL_DESC;
 Desc: D3D11_SAMPLER_DESC;
begin
 Result:= False;
 if (not Assigned(D3D11Device)) then Exit;

 // Create Rasterizer state.
 FillChar(RasterDesc, SizeOf(D3D11_RASTERIZER_DESC), 0);

 RasterDesc.CullMode:= D3D11_CULL_NONE;
 RasterDesc.FillMode:= D3D11_FILL_SOLID;

 RasterDesc.DepthClipEnable:= False;
 RasterDesc.ScissorEnable  := True;

 RasterDesc.MultisampleEnable    := True;
 RasterDesc.AntialiasedLineEnable:= False;

 PushClearFPUState();
 try
  Result:= Succeeded(D3D11Device.CreateRasterizerState(RasterDesc,
   RasterState));
 finally
  PopFPUState();
 end;

 if (not Result) then Exit;

 // Create Depth/Stencil state.
 FillChar(DepthStencilDesc, SizeOf(D3D11_DEPTH_STENCIL_DESC), 0);

 DepthStencilDesc.DepthEnable:= False;
 DepthStencilDesc.StencilEnable:= False;

 PushClearFPUState();
 try
  Result:= Succeeded(D3D11Device.CreateDepthStencilState(DepthStencilDesc,
   DepthStencilState));
 finally
  PopFPUState();
 end;

 if (not Result) then
  begin
   RasterState:= nil;
   Exit;
  end;

 // Create Sampler state.
 FillChar(Desc, SizeOf(D3D11_SAMPLER_DESC), 0);

 Desc.Filter:= D3D11_FILTER_MIN_MAG_MIP_LINEAR;
 Desc.AddressU:= D3D11_TEXTURE_ADDRESS_WRAP;
 Desc.AddressV:= D3D11_TEXTURE_ADDRESS_WRAP;
 Desc.AddressW:= D3D11_TEXTURE_ADDRESS_WRAP;
 Desc.MaxAnisotropy:= 1;
 Desc.ComparisonFunc:= D3D11_COMPARISON_NEVER;
 Desc.BorderColor[0]:= 1.0;
 Desc.BorderColor[1]:= 1.0;
 Desc.BorderColor[2]:= 1.0;
 Desc.BorderColor[3]:= 1.0;
 Desc.BorderColor[0]:= 1.0;
 Desc.MinLOD:= -D3D11_FLOAT32_MAX;
 Desc.MaxLOD:= D3D11_FLOAT32_MAX;

 PushClearFPUState();
 try
  Result:= Succeeded(D3D11Device.CreateSamplerState(Desc, SamplerState));
 finally
  PopFPUState();
 end;

 if (not Result) then
  begin
   DepthStencilState:= nil;
   RasterState:= nil;
  end;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.DestroyDeviceStates();
begin
 if (Assigned(SamplerState)) then SamplerState:= nil;
 if (Assigned(DepthStencilState)) then DepthStencilState:= nil;
 if (Assigned(RasterState)) then RasterState:= nil;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.CreateBlendStates();
begin
 // "Normal"
 DX11CreateBasicBlendState(D3D11_BLEND_SRC_ALPHA, D3D11_BLEND_INV_SRC_ALPHA,
  BlendingStates[reNormal]);

 // "Shadow"
 DX11CreateBasicBlendState(D3D11_BLEND_ZERO, D3D11_BLEND_INV_SRC_ALPHA,
  BlendingStates[reShadow]);

 // "Add"
 DX11CreateBasicBlendState(D3D11_BLEND_SRC_ALPHA, D3D11_BLEND_ONE,
  BlendingStates[reAdd]);

 // "Multiply"
 DX11CreateBasicBlendState(D3D11_BLEND_ZERO, D3D11_BLEND_SRC_COLOR,
  BlendingStates[reMultiply]);

 // "SrcAlphaAdd"
 DX11CreateBasicBlendState(D3D11_BLEND_SRC_ALPHA, D3D11_BLEND_ONE,
  BlendingStates[reSrcAlphaAdd]);

 // "SrcColor"
 DX11CreateBasicBlendState(D3D11_BLEND_SRC_COLOR, D3D11_BLEND_INV_SRC_COLOR,
  BlendingStates[reSrcColor]);

 // "SrcColorAdd"
 DX11CreateBasicBlendState(D3D11_BLEND_SRC_COLOR, D3D11_BLEND_ONE,
  BlendingStates[reSrcColorAdd]);
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.DestroyBlendStates();
var
 State: TRasterEffect;
begin
 for State:= High(TRasterEffect) downto Low(TRasterEffect) do
  if (Assigned(BlendingStates[State])) then BlendingStates[State]:= nil;
end;

//--------------------------------------------------------------------------
function TDX11Rasterizer.CreateDynamicObjects(): Boolean;
begin
 Result:= InitializeEffects();
 if (not Result) then Exit;

 Result:= CreateDeviceStates();
 if (not Result) then
  begin
   FinalizeEffects();
   Exit;
  end;

 Result:= CreateVertexBuffer();
 if (not Result) then
  begin
   DestroyDeviceStates();
   FinalizeEffects();
   Exit;
  end;

 CreateBlendStates();
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.DestroyDynamicObjects();
begin
 DestroyBlendStates();
 DestroyVertexBuffer();
 DestroyDeviceStates();
 FinalizeEffects();
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.ResetRasterState();
begin
 if (not Assigned(RasterState))or(not Assigned(D3D11Context)) then Exit;

 ScissorRect:= Bounds(
  Round(D3D11Viewport.TopLeftX),
  Round(D3D11Viewport.TopLeftY),
  Round(D3D11Viewport.Width),
  Round(D3D11Viewport.Height));

 PushClearFPUState();
 try
  D3D11Context.RSSetState(RasterState);
  D3D11Context.RSSetScissorRects(1, @ScissorRect);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.ResetDepthStencilState();
begin
 if (not Assigned(DepthStencilState))or(not Assigned(D3D11Context)) then Exit;

 PushClearFPUState();
 try
  D3D11Context.OMSetDepthStencilState(DepthStencilState, 0);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.ResetActiveTexture();
var
 NullView: ID3D11ShaderResourceView;
begin
 if (Assigned(D3D11Context)) then
  begin
   NullView:= nil;
   D3D11Context.PSSetShaderResources(0, 1, @NullView);
  end;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.UpdateSamplerState();
begin
 if (Assigned(D3D11Context)) then
  D3D11Context.PSSetSamplers(0, 1, @SamplerState);
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.ResetSamplerState();
var
 NullSampler: ID3D11SamplerState;
begin
 if (Assigned(D3D11Context)) then
  begin
   NullSampler:= nil;
   D3D11Context.PSSetSamplers(0, 1, @NullSampler);
  end;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.ResetStates();
begin
 FVertexCount:= 0;

 ActiveProgram := rpUnknown;
 ActiveEffect  := nil;
 CachedBlend   := reUnknown;
 CachedTexture := nil;
 ActiveTexture := nil;

 FillChar(ActiveTexCoords, SizeOf(ActiveTexCoords), 0);

 NormalSize.x:= D3D11Viewport.Width * 0.5;
 NormalSize.y:= D3D11Viewport.Height * 0.5;

 ResetRasterState();
 ResetDepthStencilState();
 ResetActiveTexture();
 ResetSamplerState();

 FAntialias := True;
 FMipmapping:= False;
end;

//--------------------------------------------------------------------------
function TDX11Rasterizer.HandleDeviceCreate(): Boolean;
begin
 CreateSystemBuffers();

 Result:= True;
end;

//--------------------------------------------------------------------------
procedure TDX11Rasterizer.HandleDeviceDestroy();
begin
 DestroySystemBuffers();
end;

//--------------------------------------------------------------------------
function TDX11Rasterizer.HandleDeviceReset(): Boolean;
begin
 Result:= CreateDynamicObjects();
end;

//--------------------------------------------------------------------------
procedure TDX11Rasterizer.HandleDeviceLost();
begin
 DestroyDynamicObjects();
end;

//--------------------------------------------------------------------------
procedure TDX11Rasterizer.HandleBeginScene();
begin
 ResetStates();
end;

//--------------------------------------------------------------------------
procedure TDX11Rasterizer.HandleEndScene();
begin
 Flush();
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.GetViewport(out x, y, Width, Height: Integer);
begin
 x:= ScissorRect.Left;
 y:= ScissorRect.Top;

 Width := ScissorRect.Right - ScissorRect.Left;
 Height:= ScissorRect.Bottom - ScissorRect.Top;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.SetViewport(x, y, Width, Height: Integer);
begin
 if (not Assigned(D3D11Device)) then Exit;

 Flush();

 ScissorRect:= Bounds(x, y, Width, Height);

 PushClearFPUState();
 try
  D3D11Context.RSSetScissorRects(1, @ScissorRect);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX11Rasterizer.UploadVertexBuffer(): Boolean;
var
 Mapped : D3D11_MAPPED_SUBRESOURCE;
 BufSize: Integer;
begin
 Result:= (Assigned(VertexBuffer))and(Assigned(D3D11Context));
 if (not Result) then Exit;

 Result:= Succeeded(D3D11Context.Map(VertexBuffer, 0, D3D11_MAP_WRITE_DISCARD,
  0, Mapped));
 if (not Result) then Exit;

 BufSize:= FVertexCount * SizeOf(TVertexRecord);

 Move(VertexArray^, Mapped.pData^, BufSize);
 D3D11Context.Unmap(VertexBuffer, 0);
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.DrawBuffers();
var
 VtxStride, VtxOffset: LongWord;
begin
 if (not Assigned(D3D11Context)) then Exit;

 VtxStride:= SizeOf(TVertexRecord);
 VtxOffset:= 0;

 with D3D11Context do
  begin
   IASetVertexBuffers(0, 1, @VertexBuffer, @VtxStride, @VtxOffset);
   IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
   D3D11Context.Draw(FVertexCount, 0);
  end;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.Flush();
begin
 if (FVertexCount > 0) then
  begin
   PushClearFPUState();
   try
    if (UploadVertexBuffer()) then
     DrawBuffers();
   finally
    PopFPUState();
   end;

   NextDrawCall();
  end;

 ResetActiveTexture();
 ResetSamplerState();

 if (Assigned(ActiveEffect)) then
  begin
   ActiveEffect.Deactivate();
   ActiveEffect:= nil;
  end;

 FVertexCount := 0;
 CachedBlend  := reUnknown;
 ActiveProgram:= rpUnknown;
 CachedTexture:= nil;
 ActiveTexture:= nil;
end;

//---------------------------------------------------------------------------
function TDX11Rasterizer.RequestCache(NewProgram: TDX11RasterizerProgram;
 Vertices: Integer; RasterType: TRasterEffect;
 Texture: TAsphyreCustomTexture): Boolean;
begin
 Result:= (Vertices <= MaxCachedVertices);
 if (not Result) then Exit;

 if (FVertexCount + Vertices > MaxCachedVertices)or
  (ActiveProgram = rpUnknown)or(ActiveProgram <> NewProgram)or
  (CachedBlend = reUnknown)or(CachedBlend <> RasterType)or
  (CachedTexture <> Texture) then
  begin
   Flush();

   if (CachedBlend = reUnknown)or(CachedBlend <> RasterType) then
    DX11SetSimpleBlendState(BlendingStates[RasterType]);

   if (CachedTexture <> Texture) then
    begin
     if (Assigned(Texture)) then
      begin
       Texture.Bind(0);
       UpdateSamplerState();
      end else
      begin
       ResetActiveTexture();
       ResetSamplerState();
      end;
    end;

   if (ActiveProgram = rpUnknown)or(ActiveProgram <> NewProgram) then
    begin
     case NewProgram of
      rpSolid:
       ActiveEffect:= SolidEffect;

      rpTextured:
       ActiveEffect:= TexturedEffect;

      else ActiveEffect:= nil;
     end;

     if (Assigned(ActiveEffect)) then
      Result:= ActiveEffect.Activate();
    end;

   ActiveProgram:= NewProgram;
   CachedBlend  := RasterType;
   CachedTexture:= Texture;
  end;
end;

//---------------------------------------------------------------------------
function TDX11Rasterizer.NextVertexEntry(): Pointer;
begin
 Result:= Pointer(PtrInt(VertexArray) + FVertexCount * SizeOf(TVertexRecord));
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.AddVertexEntry(const Position: TVector4;
 const TexAt: TPoint2; DiffuseColor, SpecularColor: Cardinal);
var
 NormAt: TPoint2;
 Entry : PVertexRecord;
begin
 NormAt.x:= (Position.x - NormalSize.x) / NormalSize.x;
 NormAt.y:= (Position.y - NormalSize.y) / NormalSize.y;

 Entry:= NextVertexEntry();
 Entry.x:= NormAt.x;
 Entry.y:= -NormAt.y;
 Entry.z:= Position.z;
 Entry.w:= Position.w;
 Entry.u:= TexAt.x;
 Entry.v:= TexAt.y;
 Entry.DiffuseColor := DisplaceRB(DiffuseColor);
 Entry.SpecularColor:= DisplaceRB(SpecularColor);

 Inc(FVertexCount);
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.FillTri(const Vtx0, Vtx1, Vtx2: TVector4; Diffuse0,
 Diffuse1, Diffuse2, Specular0, Specular1, Specular2: Cardinal;
 Effect: TRasterEffect);
begin
 if (not RequestCache(rpSolid, 3, Effect, nil)) then Exit;

 AddVertexEntry(Vtx0, ZeroVec2, Diffuse0, Specular0);
 AddVertexEntry(Vtx1, ZeroVec2, Diffuse1, Specular1);
 AddVertexEntry(Vtx2, ZeroVec2, Diffuse2, Specular2);
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.UseTexture(Texture: TAsphyreCustomTexture);
begin
 ActiveTexture:= Texture;
end;

//---------------------------------------------------------------------------
procedure TDX11Rasterizer.TexMap(const Vtx0, Vtx1, Vtx2: TVector4; Tex0, Tex1,
 Tex2: TPoint2; Diffuse0, Diffuse1, Diffuse2, Specular0, Specular1,
 Specular2: Cardinal; Effect: TRasterEffect);
begin
 if (not RequestCache(rpTextured, 3, Effect, ActiveTexture)) then Exit;

 AddVertexEntry(Vtx0, Tex0, Diffuse0, Specular0);
 AddVertexEntry(Vtx1, Tex1, Diffuse1, Specular1);
 AddVertexEntry(Vtx2, Tex2, Diffuse2, Specular2);
end;

//---------------------------------------------------------------------------
end.

