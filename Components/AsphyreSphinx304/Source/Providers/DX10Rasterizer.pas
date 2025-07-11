unit DX10Rasterizer;
//---------------------------------------------------------------------------
// DX10Rasterizer.pas                                   Modified: 14-Sep-2012
// 3D Scene Rasterizer using Direct3D 10.x for Asphyre.          Version 1.01
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
// The Original Code is DX10Rasterizer.pas.
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
 Windows, AsphyreD3D10, Types, AsphyreDef, Vectors2, Vectors4, AsphyreTypes,
 AbstractTextures, AbstractRasterizer, DX10CanvasEffects;

//---------------------------------------------------------------------------
// Remove the dot "." to load the canvas default effect from file instead of
// the embedded one.
//---------------------------------------------------------------------------
{.$define DX10RasterizerEffectDebug}

//---------------------------------------------------------------------------
type
 TDX10Rasterizer = class(TAsphyreRasterizer)
 private
  FEffect: TDX10CanvasEffect;

  FCustomEffect: TDX10CanvasEffect;
  FCustomTechnique: StdString;

  VertexBuffer: ID3D10Buffer;

  RasterState: ID3D10RasterizerState;
  DepthStencilState: ID3D10DepthStencilState;

  BlendingStates: array[TRasterEffect] of ID3D10BlendState;

  VertexArray : Pointer;
  FVertexCount: Integer;

  ActiveTexture: TAsphyreCustomTexture;
  CachedTexture: TAsphyreCustomTexture;
  CachedBlend  : TRasterEffect;

  NormalSize : TPoint2;
  ScissorRect: TRect;

  procedure SetCustomEffect(const Value: TDX10CanvasEffect);
  procedure SetCustomTechnique(const Value: StdString);

  procedure CreateStaticBuffers();
  procedure DestroyStaticBuffers();

  function LoadRasterizerEffect(): Boolean;
  function CreateVertexBuffer(): Boolean;

  procedure CreateRasterState();
  procedure CreateDepthStencilState();

  procedure CreateBlendStates();
  procedure DestroyBlendStates();

  function CreateDynamicObjects(): Boolean;
  procedure DestroyDynamicObjects();

  procedure ResetRasterState();
  procedure ResetDepthStencilState();

  function UploadVertexBuffer(): Boolean;
  procedure SetBuffersAndTopology();
  procedure DrawPrimitives();
  procedure DrawTechBuffers(const TechName: StdString);
  procedure DrawCustomBuffers();
  procedure DrawBuffers();

  function NextVertexEntry(): Pointer;
  procedure AddVertexEntry1(const Vtx: TVector4; Diffuse, Specular: Cardinal);
  procedure AddVertexEntry2(const Vtx: TVector4; const TexAt: TPoint2;
   Diffuse, Specular: Cardinal);
  function RequestCache(Vertices: Integer; BlendType: TRasterEffect;
   Texture: TAsphyreCustomTexture): Boolean;
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
  property CustomEffect: TDX10CanvasEffect read FCustomEffect
   write SetCustomEffect;

  property CustomTechnique: StdString read FCustomTechnique
   write SetCustomTechnique;

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
 SysUtils, AsphyreUtils, AsphyreDXGI, AsphyreFPUStates, DX10Types, PixelUtils,
 DX10RasterizerEmbdFx;

//--------------------------------------------------------------------------
const
 // The following parameters roughly affect the rendering performance. The
 // higher values means that more primitives will fit in cache, but it will
 // also occupy more bandwidth, even when few primitives are rendered.
 //
 // These parameters can be fine-tuned in a finished product to improve the
 // overall performance.
 MaxCachedVertices   = 4096 * 3;
 MaxCachedPrimitives = 4096;

//---------------------------------------------------------------------------
 RasterizerVertexLayout: array[0..3] of D3D10_INPUT_ELEMENT_DESC =
 ((SemanticName: 'POSITION';
   SemanticIndex: 0;
   Format: DXGI_FORMAT_R32G32B32A32_FLOAT;
   InputSlot: 0;
   AlignedByteOffset: 0;
   InputSlotClass: D3D10_INPUT_PER_VERTEX_DATA;
   InstanceDataStepRate: 0),

  (SemanticName: 'COLOR';
   SemanticIndex: 0;
   Format: DXGI_FORMAT_R8G8B8A8_UNORM;
   InputSlot: 0;
   AlignedByteOffset: 16;
   InputSlotClass: D3D10_INPUT_PER_VERTEX_DATA;
   InstanceDataStepRate: 0),

  (SemanticName: 'COLOR';
   SemanticIndex: 1;
   Format: DXGI_FORMAT_R8G8B8A8_UNORM;
   InputSlot: 0;
   AlignedByteOffset: 20;
   InputSlotClass: D3D10_INPUT_PER_VERTEX_DATA;
   InstanceDataStepRate: 0),

  (SemanticName: 'TEXCOORD';
   SemanticIndex: 0;
   Format: DXGI_FORMAT_R32G32_FLOAT;
   InputSlot: 0;
   AlignedByteOffset: 24;
   InputSlotClass: D3D10_INPUT_PER_VERTEX_DATA;
   InstanceDataStepRate: 0));

//--------------------------------------------------------------------------
 DebugRasterizerEffectFile = 'dx10raster.fx';

//--------------------------------------------------------------------------
 TextureVariable = 'SourceTex';

//--------------------------------------------------------------------------
 TechSimpleColorFill = 'SimpleColorFill';

//--------------------------------------------------------------------------
 TechMipTextureRGBA = 'MipTextureRGBA';

//--------------------------------------------------------------------------
type
 PVertexRecord = ^TVertexRecord;
 TVertexRecord = record
  x, y, z, w: Single;
  Diffuse : LongWord;
  Specular: LongWord;
  u, v    : Single;
 end;

//--------------------------------------------------------------------------
constructor TDX10Rasterizer.Create();
begin
 inherited;

 FEffect:= TDX10CanvasEffect.Create();
 VertexArray:= nil;
end;

//---------------------------------------------------------------------------
destructor TDX10Rasterizer.Destroy();
begin
 DestroyDynamicObjects();
 DestroyStaticBuffers();

 FreeAndNil(FEffect);

 inherited;
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.SetCustomEffect(const Value: TDX10CanvasEffect);
begin
 if (FCustomEffect = Value) then Exit;

 if (FCustomTechnique <> '') then Flush();

 FCustomEffect:= Value;

 if (Assigned(FCustomEffect)) then
  begin
   FCustomEffect.Techniques.LayoutDecl:= @RasterizerVertexLayout[0];
   FCustomEffect.Techniques.LayoutDeclCount:= High(RasterizerVertexLayout) + 1;
  end else FCustomTechnique:= '';
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.SetCustomTechnique(const Value: StdString);
begin
 if (Assigned(FCustomEffect))and(FCustomTechnique <> Value) then Flush();

 FCustomTechnique:= Value;
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.CreateStaticBuffers();
begin
 ReallocMem(VertexArray, MaxCachedVertices * SizeOf(TVertexRecord));
 FillChar(VertexArray^, MaxCachedVertices * SizeOf(TVertexRecord), 0);
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.DestroyStaticBuffers();
begin
 if (Assigned(VertexArray)) then
  FreeNullMem(VertexArray);
end;

//---------------------------------------------------------------------------
function TDX10Rasterizer.LoadRasterizerEffect(): Boolean;
{$ifndef DX10RasterizerEffectDebug}
var
 Data: Pointer;
 DataSize: Integer;
{$endif}
begin
 {$ifdef DX10RasterizerEffectDebug}
 Result:= FEffect.CompileFromFile(DebugRasterizerEffectFile);
 if (not Result) then Exit;
 {$else}
 CreateDX10RasterizerEffect(Data, DataSize);

 Result:= (Assigned(Data))and(DataSize > 0);
 if (not Result) then
  begin
   if (Assigned(Data)) then FreeMem(Data);
   Exit;
  end;

 Result:= FEffect.LoadCompiledFromMem(Data, DataSize);
 FreeNullMem(Data);
 {$endif}

 if (Result) then
  begin
   FEffect.Techniques.LayoutDecl:= @RasterizerVertexLayout[0];
   FEffect.Techniques.LayoutDeclCount:= High(RasterizerVertexLayout) + 1;
  end;
end;

//---------------------------------------------------------------------------
function TDX10Rasterizer.CreateVertexBuffer(): Boolean;
var
 Desc: D3D10_BUFFER_DESC;
begin
 Result:= Assigned(D3D10Device);
 if (not Result) then Exit;

 FillChar(Desc, SizeOf(D3D10_BUFFER_DESC), 0);

 Desc.ByteWidth:= SizeOf(TVertexRecord) * MaxCachedVertices;
 Desc.Usage    := D3D10_USAGE_DYNAMIC;
 Desc.BindFlags:= Ord(D3D10_BIND_VERTEX_BUFFER);
 Desc.MiscFlags:= 0;
 Desc.CPUAccessFlags:= Ord(D3D10_CPU_ACCESS_WRITE);

 PushClearFPUState();
 try
  Result:= Succeeded(D3D10Device.CreateBuffer(Desc, nil, @VertexBuffer));
 finally
  PopFPUState();
 end;
end;

//--------------------------------------------------------------------------
procedure TDX10Rasterizer.CreateRasterState();
var
 Desc: D3D10_RASTERIZER_DESC;
begin
 if (not Assigned(D3D10Device)) then Exit;

 FillChar(Desc, SizeOf(D3D10_RASTERIZER_DESC), 0);

 Desc.CullMode:= D3D10_CULL_NONE;
 Desc.FillMode:= D3D10_FILL_SOLID;

 Desc.DepthClipEnable:= False;
 Desc.ScissorEnable  := True;

 Desc.MultisampleEnable    := True;
 Desc.AntialiasedLineEnable:= False;

 PushClearFPUState();
 try
  D3D10Device.CreateRasterizerState(Desc, @RasterState);
 finally
  PopFPUState();
 end;
end;

//--------------------------------------------------------------------------
procedure TDX10Rasterizer.CreateDepthStencilState();
var
 Desc: D3D10_DEPTH_STENCIL_DESC;
begin
 if (not Assigned(D3D10Device)) then Exit;

 FillChar(Desc, SizeOf(D3D10_DEPTH_STENCIL_DESC), 0);

 Desc.DepthEnable:= False;
 Desc.StencilEnable:= False;

 PushClearFPUState();
 try
  D3D10Device.CreateDepthStencilState(Desc, @DepthStencilState);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.CreateBlendStates();
begin
 // "Normal"
 DX10CreateBasicBlendState(D3D10_BLEND_SRC_ALPHA, D3D10_BLEND_INV_SRC_ALPHA,
  BlendingStates[reNormal]);

 // "Shadow"
 DX10CreateBasicBlendState(D3D10_BLEND_ZERO, D3D10_BLEND_INV_SRC_ALPHA,
  BlendingStates[reShadow]);

 // "Add"
 DX10CreateBasicBlendState(D3D10_BLEND_SRC_ALPHA, D3D10_BLEND_ONE,
  BlendingStates[reAdd]);

 // "Multiply"
 DX10CreateBasicBlendState(D3D10_BLEND_ZERO, D3D10_BLEND_SRC_COLOR,
  BlendingStates[reMultiply]);

 // "SrcAlphaAdd"
 DX10CreateBasicBlendState(D3D10_BLEND_SRC_ALPHA, D3D10_BLEND_ONE,
  BlendingStates[reSrcAlphaAdd]);

 // "SrcColor"
 DX10CreateBasicBlendState(D3D10_BLEND_SRC_COLOR, D3D10_BLEND_INV_SRC_COLOR,
  BlendingStates[reSrcColor]);

 // "SrcColorAdd"
 DX10CreateBasicBlendState(D3D10_BLEND_SRC_COLOR, D3D10_BLEND_ONE,
  BlendingStates[reSrcColorAdd]);
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.DestroyBlendStates();
var
 State: TRasterEffect;
begin
 for State:= High(TRasterEffect) downto Low(TRasterEffect) do
  if (Assigned(BlendingStates[State])) then BlendingStates[State]:= nil;
end;

//--------------------------------------------------------------------------
function TDX10Rasterizer.CreateDynamicObjects(): Boolean;
begin
 Result:= LoadRasterizerEffect();
 if (not Result) then Exit;

 if (Result) then Result:= CreateVertexBuffer();

 if (Result) then
  begin
   CreateRasterState();
   CreateDepthStencilState();
   CreateBlendStates();
  end;
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.DestroyDynamicObjects();
begin
 DestroyBlendStates();
 if (Assigned(DepthStencilState)) then DepthStencilState:= nil;
 if (Assigned(RasterState)) then RasterState:= nil;
 if (Assigned(VertexBuffer)) then VertexBuffer:= nil;

 FEffect.ReleaseAll();
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.ResetRasterState();
begin
 if (not Assigned(RasterState))or(not Assigned(D3D10Device)) then Exit;

 ScissorRect:= Bounds(D3D10Viewport.TopLeftX, D3D10Viewport.TopLeftY,
  D3D10Viewport.Width, D3D10Viewport.Height);

 PushClearFPUState();
 try
  D3D10Device.RSSetState(RasterState);
  D3D10Device.RSSetScissorRects(1, @ScissorRect);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.ResetDepthStencilState();
begin
 if (not Assigned(DepthStencilState))or(not Assigned(D3D10Device)) then Exit;

 PushClearFPUState();
 try
  D3D10Device.OMSetDepthStencilState(DepthStencilState, 0);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.ResetStates();
begin
 FVertexCount:= 0;
 CachedBlend:= reUnknown;
 CachedTexture:= nil;
 ActiveTexture:= nil;

 NormalSize.x:= D3D10Viewport.Width * 0.5;
 NormalSize.y:= D3D10Viewport.Height * 0.5;

 ResetRasterState();
 ResetDepthStencilState();

 FCustomTechnique:= '';
end;

//--------------------------------------------------------------------------
function TDX10Rasterizer.HandleDeviceCreate(): Boolean;
begin
 CreateStaticBuffers();

 Result:= True;
end;

//--------------------------------------------------------------------------
procedure TDX10Rasterizer.HandleDeviceDestroy();
begin
 DestroyStaticBuffers();
end;

//--------------------------------------------------------------------------
function TDX10Rasterizer.HandleDeviceReset(): Boolean;
begin
 Result:= CreateDynamicObjects();
end;

//--------------------------------------------------------------------------
procedure TDX10Rasterizer.HandleDeviceLost();
begin
 DestroyDynamicObjects();
end;

//--------------------------------------------------------------------------
procedure TDX10Rasterizer.HandleBeginScene();
begin
 ResetStates();
end;

//--------------------------------------------------------------------------
procedure TDX10Rasterizer.HandleEndScene();
begin
 Flush();
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.GetViewport(out x, y, Width, Height: Integer);
begin
 x:= ScissorRect.Left;
 y:= ScissorRect.Top;

 Width := ScissorRect.Right - ScissorRect.Left;
 Height:= ScissorRect.Bottom - ScissorRect.Top;
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.SetViewport(x, y, Width, Height: Integer);
begin
 if (not Assigned(D3D10Device)) then Exit;

 Flush();

 ScissorRect:= Bounds(x, y, Width, Height);

 PushClearFPUState();
 try
  D3D10Device.RSSetScissorRects(1, @ScissorRect);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX10Rasterizer.UploadVertexBuffer(): Boolean;
var
 MemAddr: Pointer;
 BufSize: Integer;
begin
 Result:= Assigned(VertexBuffer);
 if (not Result) then Exit;

 Result:= Succeeded(VertexBuffer.Map(D3D10_MAP_WRITE_DISCARD, 0, MemAddr));
 if (not Result) then Exit;

 BufSize:= FVertexCount * SizeOf(TVertexRecord);

 Move(VertexArray^, MemAddr^, BufSize);
 VertexBuffer.Unmap();
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.SetBuffersAndTopology();
var
 VtxStride, VtxOffset: LongWord;
begin
 if (not Assigned(D3D10Device))or(not Assigned(VertexBuffer)) then Exit;

 VtxStride:= SizeOf(TVertexRecord);
 VtxOffset:= 0;

 PushClearFPUState();
 try
  with D3D10Device do
   begin
    IASetVertexBuffers(0, 1, @VertexBuffer, @VtxStride, @VtxOffset);
    IASetPrimitiveTopology(D3D10_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
   end;
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.DrawPrimitives();
begin
 if (not Assigned(D3D10Device)) then Exit;

 PushClearFPUState();
 try
  D3D10Device.Draw(FVertexCount, 0);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.DrawTechBuffers(const TechName: StdString);
begin
 if (not FEffect.Active) then Exit;

 if (not FEffect.Techniques.CheckLayoutStatus(TechName)) then Exit;
 FEffect.Techniques.SetLayout();

 SetBuffersAndTopology();
 if (not FEffect.Techniques.Apply(TechName)) then Exit;

 DrawPrimitives();
 NextDrawCall();
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.DrawCustomBuffers();
begin
 if (not FCustomEffect.Active) then Exit;

 if (not FCustomEffect.Techniques.CheckLayoutStatus(FCustomTechnique)) then Exit;
 FCustomEffect.Techniques.SetLayout();

 SetBuffersAndTopology();
 if (not FCustomEffect.Techniques.Apply(FCustomTechnique)) then Exit;

 DrawPrimitives();
 NextDrawCall();
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.DrawBuffers();
begin
 if (Assigned(FCustomEffect))and(FCustomTechnique <> '') then
  begin
   DrawCustomBuffers();
   Exit;
  end;

 if (not Assigned(CachedTexture)) then
  begin
   DrawTechBuffers(TechSimpleColorFill);
   Exit;
  end;

 DrawTechBuffers(TechMipTextureRGBA);
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.Flush();
var
 Success: Boolean;
begin
 if (FVertexCount > 0) then
  begin
   PushClearFPUState();
   try
    Success:= UploadVertexBuffer();
   finally
    PopFPUState();
   end;

   if (Success) then DrawBuffers();
  end;

 if (Assigned(FEffect))and(FEffect.Active) then
  FEffect.Variables.SetShaderResource(TextureVariable, nil);

 if (Assigned(FCustomEffect))and(FCustomEffect.Active) then
  FCustomEffect.Variables.SetShaderResource(TextureVariable, nil);

 FVertexCount:= 0;
 CachedBlend:= reUnknown;

 CachedTexture:= nil;
 ActiveTexture:= nil;
end;

//---------------------------------------------------------------------------
function TDX10Rasterizer.RequestCache(Vertices: Integer;
 BlendType: TRasterEffect; Texture: TAsphyreCustomTexture): Boolean;
var
 NeedReset: Boolean;
 ResourceView: Pointer;
begin
 Result:= (Vertices <= MaxCachedVertices);
 if (not Result) then Exit;

 NeedReset:= (FVertexCount + Vertices > MaxCachedVertices);
 NeedReset:= (NeedReset)or(CachedBlend = reUnknown)or(CachedBlend <> BlendType);
 NeedReset:= (NeedReset)or(CachedTexture <> Texture);

 if (NeedReset) then
  begin
   Flush();

   if (CachedBlend = reUnknown)or(CachedBlend <> BlendType) then
    DX10SetSimpleBlendState(BlendingStates[BlendType]);

   if ((CachedBlend = reUnknown)or(CachedTexture <> Texture)) then
    begin
     ResourceView:= nil;
     if (Assigned(Texture)) then ResourceView:= Texture.GetResourceView();

     if (Assigned(FEffect))and(FEffect.Active) then
      FEffect.Variables.SetShaderResource(TextureVariable,
       ID3D10ShaderResourceView(ResourceView));

     if (Assigned(FCustomEffect))and(FCustomEffect.Active) then
      FCustomEffect.Variables.SetShaderResource(TextureVariable,
       ID3D10ShaderResourceView(ResourceView));
    end;

   CachedBlend:= BlendType;
   CachedTexture   := Texture;
  end;
end;

//---------------------------------------------------------------------------
function TDX10Rasterizer.NextVertexEntry(): Pointer;
begin
 Result:= Pointer(PtrInt(VertexArray) + FVertexCount * SizeOf(TVertexRecord));
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.AddVertexEntry1(const Vtx: TVector4; Diffuse,
 Specular: Cardinal);
var
 NormAt: TPoint2;
 Entry : PVertexRecord;
begin
 NormAt.x:= (Vtx.x - NormalSize.x) / NormalSize.x;
 NormAt.y:= (Vtx.y - NormalSize.y) / NormalSize.y;

 Entry:= NextVertexEntry();
 Entry.x:= NormAt.x;
 Entry.y:= -NormAt.y;
 Entry.z:= Vtx.z;
 Entry.w:= Vtx.w;
 Entry.Diffuse := DisplaceRB(Diffuse);
 Entry.Specular:= DisplaceRB(Specular);
 Entry.u:= 0.0;
 Entry.v:= 0.0;

 Inc(FVertexCount);
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.AddVertexEntry2(const Vtx: TVector4;
 const TexAt: TPoint2; Diffuse, Specular: Cardinal);
var
 NormAt: TPoint2;
 Entry : PVertexRecord;
begin
 NormAt.x:= (Vtx.x - NormalSize.x) / NormalSize.x;
 NormAt.y:= (Vtx.y - NormalSize.y) / NormalSize.y;

 Entry:= NextVertexEntry();
 Entry.x:= NormAt.x;
 Entry.y:= -NormAt.y;
 Entry.z:= Vtx.z;
 Entry.w:= Vtx.w;
 Entry.Diffuse := DisplaceRB(Diffuse);
 Entry.Specular:= DisplaceRB(Specular);
 Entry.u:= TexAt.x;
 Entry.v:= TexAt.y;

 Inc(FVertexCount);
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.FillTri(const Vtx0, Vtx1, Vtx2: TVector4; Diffuse0,
 Diffuse1, Diffuse2, Specular0, Specular1, Specular2: Cardinal;
 Effect: TRasterEffect);
begin
 if (not RequestCache(3, Effect, nil)) then Exit;

 AddVertexEntry1(Vtx0, Diffuse0, Specular0);
 AddVertexEntry1(Vtx1, Diffuse1, Specular1);
 AddVertexEntry1(Vtx2, Diffuse2, Specular2);
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.UseTexture(Texture: TAsphyreCustomTexture);
begin
 ActiveTexture:= Texture;
end;

//---------------------------------------------------------------------------
procedure TDX10Rasterizer.TexMap(const Vtx0, Vtx1, Vtx2: TVector4; Tex0, Tex1,
 Tex2: TPoint2; Diffuse0, Diffuse1, Diffuse2, Specular0, Specular1,
 Specular2: Cardinal; Effect: TRasterEffect);
begin
 if (not RequestCache(3, Effect, ActiveTexture)) then Exit;

 AddVertexEntry2(Vtx0, Tex0, Diffuse0, Specular0);
 AddVertexEntry2(Vtx1, Tex1, Diffuse1, Specular1);
 AddVertexEntry2(Vtx2, Tex2, Diffuse2, Specular2);
end;

//---------------------------------------------------------------------------
end.
