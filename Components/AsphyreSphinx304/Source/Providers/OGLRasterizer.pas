unit OGLRasterizer;
//---------------------------------------------------------------------------
// OGLRasterizer.pas                                    Modified: 14-Sep-2012
// Modern OpenGL 3D rasterizer implementation for Asphyre.        Version 1.0
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
// The Original Code is OGLRasterizer.pas.
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
 Types, AsphyreDef, Vectors2, Vectors4, AbstractTextures, AbstractRasterizer;

//---------------------------------------------------------------------------
type
 TCanvasProgram = (cpNone, cpSolid, cpTextured);

//---------------------------------------------------------------------------
 TOGLRasterizer = class(TAsphyreRasterizer)
 private
  SystemVertexBuffer: Pointer;

  GPUVertexBuffer: GLuint;

  CachedVertexCount: Integer;

  CurProgram  : TCanvasProgram;
  NormSize    : TPoint2;
  CachedEffect: TRasterEffect;
  CachedTex   : TAsphyreCustomTexture;
  ActiveTex   : TAsphyreCustomTexture;

  ClippingRect: TRect;
  ViewportRect: TRect;

  CompiledVS: GLuint;
  CompiledSolidPS: GLuint;
  CompiledTexturedPS: GLuint;

  SolidProgram: GLuint;
  TexturedProgram: GLuint;
  SourceTexLocation: GLint;

  SolidInpVertex: GLint;
  SolidInpTexCoord: GLint;
  SolidInpDiffuseColor: GLint;
  SolidInpSpecularColor: GLint;

  TexturedInpVertex: GLint;
  TexturedInpTexCoord: GLint;
  TexturedInpDiffuseColor: GLint;
  TexturedInpSpecularColor: GLint;

  CurrentInpVertex: GLint;
  CurrentInpTexCoord: GLint;
  CurrentInpDiffuseColor: GLint;
  CurrentInpSpecularColor: GLint;

  procedure CreateSystemBuffers();
  procedure DestroySystemBuffers();

  function CreateGPUBuffers(): Boolean;
  procedure DestroyGPUBuffers();

  function CompileShader(ShaderType: GLenum;
   const ShaderText: AnsiString): GLuint;

  function CreateShaders(): Boolean;
  procedure DestroyShaders();

  function CreateSolidProgram(): Boolean;
  function CreateTexturedProgram(): Boolean;
  procedure DestroySolidProgram();
  procedure DestroyTexturedProgram();

  function UseSolidProgram(): Boolean;
  function UseTexturedProgram(): Boolean;
  function UploadBuffers(): Boolean;
  function DrawBuffers(): Boolean;

  procedure ResetScene();
  procedure RequestCache(NewProgram: TCanvasProgram; Vertices: Integer);
  procedure RequestEffect(Effect: TRasterEffect);
  procedure RequestTexture(Texture: TAsphyreCustomTexture);
  procedure InsertElementVertex(const VtxPos: TVector4; const TexCoord: TPoint2;
   DiffuseColor, SpecularColor: Cardinal);
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
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 PixelUtils, OGLTypes, OGLRasterizerShaders;

//---------------------------------------------------------------------------
type
 PVertexRecord = ^TVertexRecord;
 TVertexRecord = packed record
  x, y, z, w: GLfloat;
  u, v: GLfloat;
  DiffuseColor : GLuint;
  SpecularColor: GLuint;
 end;

//--------------------------------------------------------------------------
const
 // The following parameters roughly affect the rendering performance. The
 // higher values means that more primitives will fit in cache, but it will
 // also occupy more bandwidth, even when few primitives are rendered.
 //
 // These parameters can be fine-tuned in a finished product to improve the
 // overall performance.
 MaxCachedPrimitives = 4096;
 MaxCachedVertices   = 4096 * 3;

//---------------------------------------------------------------------------
constructor TOGLRasterizer.Create();
begin
 inherited;

end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.CreateSystemBuffers();
begin
 SystemVertexBuffer:= AllocMem(SizeOf(TVertexRecord) * MaxCachedVertices);
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.DestroySystemBuffers();
begin
 if (Assigned(SystemVertexBuffer)) then FreeNullMem(SystemVertexBuffer);
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.CreateGPUBuffers(): Boolean;
begin
 glGenBuffers(1, @GPUVertexBuffer);
 glBindBuffer(GL_ARRAY_BUFFER, GPUVertexBuffer);
 glBufferData(GL_ARRAY_BUFFER, SizeOf(TVertexRecord) * MaxCachedVertices, nil,
  GL_DYNAMIC_DRAW);

 Result:= (glGetError() = GL_NO_ERROR)and(GPUVertexBuffer <> 0);
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.DestroyGPUBuffers();
begin
 if (GPUVertexBuffer <> 0) then
  begin
   glBindBuffer(GL_ARRAY_BUFFER, 0);
   glDeleteBuffers(1, @GPUVertexBuffer);

   GPUVertexBuffer:= 0;
  end;
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.CompileShader(ShaderType: GLenum;
 const ShaderText: AnsiString): GLuint;
var
 TextLen: GLint;
 ShaderSource: PPGLchar;
 CompileStatus: GLint;
begin
 TextLen:= Length(ShaderText) - 1;
 if (TextLen < 1) then
  begin
   Result:= 0;
   Exit;
  end;

 Result:= glCreateShader(ShaderType);
 if (Result = 0) then Exit;

 ShaderSource:= @ShaderText[1];

 glShaderSource(Result, 1, @ShaderSource, @TextLen);
 glCompileShader(Result);

 glGetShaderiv(Result, GL_COMPILE_STATUS, @CompileStatus);

 if (CompileStatus <> GL_TRUE) then
  begin
//   DebugCompilationProblem(Result);
   glDeleteShader(Result);
   Result:= 0;
  end;
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.CreateShaders(): Boolean;
begin
 // (1) Normal Vertex Shader.
 CompiledVS:= CompileShader(GL_VERTEX_SHADER, VertexShaderSource);

 Result:= CompiledVS <> 0;
 if (not Result) then Exit;

 // (2) Solid Pixel Shader.
 CompiledSolidPS:= CompileShader(GL_FRAGMENT_SHADER, PixelShaderSolidSource);

 Result:= CompiledSolidPS <> 0;
 if (not Result) then
  begin
   glDeleteShader(CompiledSolidPS);
   Exit;
  end;

 // (3) Textured Pixel Shader.
 CompiledTexturedPS:= CompileShader(GL_FRAGMENT_SHADER,
  PixelShaderTexturedSource);

 Result:= CompiledTexturedPS <> 0;
 if (not Result) then
  begin
   glDeleteShader(CompiledSolidPS);
   glDeleteShader(CompiledVS);
   Exit;
  end;
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.DestroyShaders();
begin
 if (CompiledTexturedPS <> 0) then
  begin
   glDeleteShader(CompiledTexturedPS);
   CompiledTexturedPS:= 0;
  end;

 if (CompiledSolidPS <> 0) then
  begin
   glDeleteShader(CompiledSolidPS);
   CompiledSolidPS:= 0;
  end;

 if (CompiledVS <> 0) then
  begin
   glDeleteShader(CompiledVS);
   CompiledVS:= 0;
  end;
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.CreateSolidProgram(): Boolean;
var
 LinkStatus: Integer;
begin
 SolidProgram:= glCreateProgram();

 glAttachShader(SolidProgram, CompiledVS);
 glAttachShader(SolidProgram, CompiledSolidPS);

 glLinkProgram(SolidProgram);
 glGetProgramiv(SolidProgram, GL_LINK_STATUS, @LinkStatus);

 Result:= LinkStatus <> 0;
 if (not Result) then
  begin
   glDeleteProgram(SolidProgram);
   SolidProgram:= 0;
   Exit;
  end;

 SolidInpVertex  := glGetAttribLocation(SolidProgram, 'InpVertex');
 SolidInpTexCoord:= glGetAttribLocation(SolidProgram, 'InpTexCoord');
 SolidInpDiffuseColor := glGetAttribLocation(SolidProgram, 'InpDiffuseColor');
 SolidInpSpecularColor:= glGetAttribLocation(SolidProgram, 'InpSpecularColor');
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.DestroySolidProgram();
begin
 if (SolidProgram <> 0) then
  begin
   glDeleteProgram(SolidProgram);
   SolidProgram:= 0;
  end;
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.CreateTexturedProgram(): Boolean;
var
 LinkStatus: Integer;
begin
 TexturedProgram:= glCreateProgram();

 glAttachShader(TexturedProgram, CompiledVS);
 glAttachShader(TexturedProgram, CompiledTexturedPS);

 glLinkProgram(TexturedProgram);
 glGetProgramiv(TexturedProgram, GL_LINK_STATUS, @LinkStatus);

 Result:= LinkStatus <> 0;
 if (not Result) then
  begin
   glDeleteProgram(TexturedProgram);
   TexturedProgram:= 0;
   Exit;
  end;

 SourceTexLocation:= glGetUniformLocation(TexturedProgram, 'SourceTex');

 TexturedInpVertex  := glGetAttribLocation(TexturedProgram, 'InpVertex');
 TexturedInpTexCoord:= glGetAttribLocation(TexturedProgram, 'InpTexCoord');

 TexturedInpDiffuseColor:= glGetAttribLocation(TexturedProgram,
  'InpDiffuseColor');

 TexturedInpSpecularColor:= glGetAttribLocation(TexturedProgram,
  'InpSpecularColor');
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.DestroyTexturedProgram();
begin
 if (TexturedProgram <> 0) then
  begin
   glDeleteProgram(TexturedProgram);
   TexturedProgram:= 0;
  end;
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.HandleDeviceCreate(): Boolean;
begin
 Result:= GL_VERSION_2_0;
 if (not Result) then Exit;

 Result:= CreateGPUBuffers();
 if (not Result) then Exit;

 CreateSystemBuffers();
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.HandleDeviceDestroy();
begin
 DestroyGPUBuffers();
 DestroySystemBuffers();
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.HandleDeviceReset(): Boolean;
begin
 Result:= CreateShaders();
 if (not Result) then Exit;

 Result:= CreateSolidProgram();
 if (not Result) then
  begin
   DestroyShaders();
   Exit;
  end;

 Result:= CreateTexturedProgram();
 if (not Result) then
  begin
   DestroySolidProgram();
   DestroyShaders();
   Exit;
  end;
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.HandleDeviceLost();
begin
 DestroyTexturedProgram();
 DestroySolidProgram();
 DestroyShaders();
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.ResetStates();
var
 Viewport: array[0..3] of GLint;
begin
 CurProgram:= cpNone;
 CachedEffect:= reUnknown;

 CachedTex:= nil;
 ActiveTex:= nil;

 CachedVertexCount:= 0;

 glGetIntegerv(GL_VIEWPORT, @Viewport[0]);

 NormSize.x:= Viewport[2] * 0.5;
 NormSize.y:= Viewport[3] * 0.5;

 glDisable(GL_DEPTH_TEST);

 glDisable(GL_TEXTURE_1D);
 glDisable(GL_TEXTURE_2D);
 glDisable(GL_LINE_SMOOTH);

 glScissor(Viewport[0], Viewport[1], Viewport[2], Viewport[3]);
 glEnable(GL_SCISSOR_TEST);

 ClippingRect:= Bounds(Viewport[0], Viewport[1], Viewport[2], Viewport[3]);
 ViewportRect:= Bounds(Viewport[0], Viewport[1], Viewport[2], Viewport[3]);
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.HandleBeginScene();
begin
 ResetStates();
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.HandleEndScene();
begin
 Flush();
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.GetViewport(out x, y, Width, Height: Integer);
begin
 x:= ClippingRect.Left;
 y:= ClippingRect.Top;
 Width := ClippingRect.Right - ClippingRect.Left;
 Height:= ClippingRect.Bottom - ClippingRect.Top;
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.SetViewport(x, y, Width, Height: Integer);
var
 ViewPos: Integer;
begin
 ResetScene();

 ViewPos:= (ViewportRect.Bottom - ViewportRect.Top) - (y + Height);

 glScissor(x, Viewpos, Width, Height);
 ClippingRect:= Bounds(x, y, Width, Height);
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.UseSolidProgram(): Boolean;
begin
 Result:= SolidProgram <> 0;
 if (not Result) then Exit;

 glUseProgram(SolidProgram);

 CurrentInpVertex:= SolidInpVertex;
 CurrentInpTexCoord:= SolidInpTexCoord;
 CurrentInpDiffuseColor := SolidInpDiffuseColor;
 CurrentInpSpecularColor:= SolidInpSpecularColor;
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.UseTexturedProgram(): Boolean;
begin
 Result:= TexturedProgram <> 0;
 if (not Result) then Exit;

 glUseProgram(TexturedProgram);

 CurrentInpVertex:= TexturedInpVertex;
 CurrentInpTexCoord:= TexturedInpTexCoord;
 CurrentInpDiffuseColor := TexturedInpDiffuseColor;
 CurrentInpSpecularColor:= TexturedInpSpecularColor;

 glUniform1i(SourceTexLocation, 0);
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.UploadBuffers(): Boolean;
begin
 if (CachedVertexCount > 0) then
  begin
   glBindBuffer(GL_ARRAY_BUFFER, GPUVertexBuffer);
   glBufferSubData(GL_ARRAY_BUFFER, 0, SizeOf(TVertexRecord) *
    CachedVertexCount, SystemVertexBuffer);
  end;

 Result:= glGetError() = GL_NO_ERROR;
end;

//---------------------------------------------------------------------------
function TOGLRasterizer.DrawBuffers(): Boolean;
var
 RecordSize: GLsizei;
begin
 glBindBuffer(GL_ARRAY_BUFFER, GPUVertexBuffer);
 RecordSize:= SizeOf(TVertexRecord);

 if (CurrentInpVertex >= 0) then
  begin
   glVertexAttribPointer(CurrentInpVertex, 4, GL_FLOAT, False, RecordSize,
    nil);
   glEnableVertexAttribArray(CurrentInpVertex);
  end;

 if (CurrentInpTexCoord >= 0) then
  begin
   glVertexAttribPointer(CurrentInpTexCoord, 2, GL_FLOAT, False, RecordSize,
    Pointer(16));
   glEnableVertexAttribArray(CurrentInpTexCoord);
  end;

 if (CurrentInpDiffuseColor >= 0) then
  begin
   glVertexAttribPointer(CurrentInpDiffuseColor, 4, GL_UNSIGNED_BYTE, True,
    RecordSize, Pointer(24));
   glEnableVertexAttribArray(CurrentInpDiffuseColor);
  end;

 if (CurrentInpSpecularColor >= 0) then
  begin
   glVertexAttribPointer(CurrentInpSpecularColor, 4, GL_UNSIGNED_BYTE, True,
    RecordSize, Pointer(28));
   glEnableVertexAttribArray(CurrentInpSpecularColor);
  end;

 glDrawArrays(GL_TRIANGLES, 0, CachedVertexCount);

 Result:= glGetError() = GL_NO_ERROR;
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.ResetScene();
begin
 if (CachedVertexCount > 0) then
  if (UploadBuffers()) then
   begin
    DrawBuffers();
    NextDrawCall();
   end;

 CachedVertexCount:= 0;

 if (CurProgram <> cpNone) then
  begin
   CurProgram:= cpNone;
   glUseProgram(0);
  end;
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.RequestCache(NewProgram: TCanvasProgram;
 Vertices: Integer);
begin
 if (CachedVertexCount + Vertices > MaxCachedVertices)or
  (CurProgram = cpNone)or(CurProgram <> NewProgram) then ResetScene();

 CurProgram:= NewProgram;

 case CurProgram of
  cpSolid:
   UseSolidProgram();

  cpTextured:
   UseTexturedProgram();
 end;
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.RequestEffect(Effect: TRasterEffect);
begin
 if (CachedEffect = Effect) then Exit;

 ResetScene();

 if (Effect <> reUnknown) then glEnable(GL_BLEND)
  else glDisable(GL_BLEND);

 case Effect of
  reNormal:
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  reShadow:
   glBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_ALPHA);

  reAdd:
   glBlendFunc(GL_SRC_ALPHA, GL_ONE);

  reMultiply:
   glBlendFunc(GL_ZERO, GL_SRC_COLOR);

  reSrcAlphaAdd:
   glBlendFunc(GL_SRC_ALPHA, GL_ONE);

  reSrcColor:
   glBlendFunc(GL_SRC_COLOR, GL_ONE_MINUS_SRC_COLOR);

  reSrcColorAdd:
   glBlendFunc(GL_SRC_COLOR, GL_ONE);
 end;

 CachedEffect:= Effect;
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.RequestTexture(Texture: TAsphyreCustomTexture);
begin
 if (CachedTex = Texture) then Exit;

 ResetScene();

 if (Assigned(Texture)) then
  begin
   glEnable(GL_TEXTURE_2D);

   Texture.Bind(0);

   if (Texture.Mipmapping) then
    begin
     glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
      GL_LINEAR_MIPMAP_LINEAR);
    end else
    begin
     glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    end;

   glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  end else glDisable(GL_TEXTURE_2D);

 CachedTex:= Texture;
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.InsertElementVertex(const VtxPos: TVector4;
 const TexCoord: TPoint2; DiffuseColor, SpecularColor: Cardinal);
var
 DestValue: PVertexRecord;
begin
 DestValue:= Pointer(PtrInt(SystemVertexBuffer) + CachedVertexCount *
  SizeOf(TVertexRecord));

 DestValue.x:= (VtxPos.x - NormSize.x) / NormSize.x;
 DestValue.y:= (VtxPos.y - NormSize.y) / NormSize.y;

 if (not OGLUsingFrameBuffer) then
  DestValue.y:= -DestValue.y;

 DestValue.z:= VtxPos.z;
 DestValue.w:= VtxPos.w;

 DestValue.DiffuseColor := DisplaceRB(DiffuseColor);
 DestValue.SpecularColor:= DisplaceRB(SpecularColor);

 DestValue.u:= TexCoord.x;
 DestValue.v:= TexCoord.y;

 Inc(CachedVertexCount);
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.Flush();
begin
 ResetScene();
 RequestEffect(reUnknown);
 RequestTexture(nil);
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.FillTri(const Vtx0, Vtx1, Vtx2: TVector4; Diffuse0,
 Diffuse1, Diffuse2, Specular0, Specular1, Specular2: Cardinal;
 Effect: TRasterEffect);
begin
 RequestEffect(Effect);
 RequestTexture(nil);
 RequestCache(cpSolid, 3);

 InsertElementVertex(Vtx0, ZeroVec2, Diffuse0, Specular0);
 InsertElementVertex(Vtx1, ZeroVec2, Diffuse1, Specular1);
 InsertElementVertex(Vtx2, ZeroVec2, Diffuse2, Specular2);
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.UseTexture(Texture: TAsphyreCustomTexture);
begin
 ActiveTex:= Texture;
end;

//---------------------------------------------------------------------------
procedure TOGLRasterizer.TexMap(const Vtx0, Vtx1, Vtx2: TVector4; Tex0, Tex1,
 Tex2: TPoint2; Diffuse0, Diffuse1, Diffuse2, Specular0, Specular1,
 Specular2: Cardinal; Effect: TRasterEffect);
begin
 RequestEffect(Effect);
 RequestTexture(ActiveTex);
 RequestCache(cpTextured, 3);

 InsertElementVertex(Vtx0, Tex0, Diffuse0, Specular0);
 InsertElementVertex(Vtx1, Tex1, Diffuse1, Specular1);
 InsertElementVertex(Vtx2, Tex2, Diffuse2, Specular2);
end;

//---------------------------------------------------------------------------
end.
