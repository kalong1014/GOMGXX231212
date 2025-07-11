unit OGLCanvasMini;
//---------------------------------------------------------------------------
// OGLCanvasMini.pas                                    Modified: 14-Sep-2012
// OpenGL minimalistic canvas implementation.                    Version 1.05
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
// The Original Code is OGLCanvasMini.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// This implementation tries to use the lowest OpenGL version possible to
// improve compatibility with low-end GPUs.
//
// Primitive caching (or "batching") is made implicitly by using immediate
// OpenGL mode, which itself uses batching. Although the approach is quite
// simplistic, it should work across different platforms reliably.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
uses
 Types, Vectors2, AsphyreTypes, AbstractTextures, AbstractCanvas;

//---------------------------------------------------------------------------
type
 TCanvasTopology = (ctNone, ctPoints, ctLines, ctTriangles, ctQuads);

//---------------------------------------------------------------------------
 TOGLCanvasMini = class(TAsphyreCanvas)
 private
  Topology    : TCanvasTopology;
  NormSize    : TPoint2;
  CachedEffect: TBlendingEffect;
  CachedTex   : TAsphyreCustomTexture;
  ActiveTex   : TAsphyreCustomTexture;
  QuadMapping : TPoint4;
  FAntialias  : Boolean;
  FMipmapping : Boolean;

  ClippingRect: TRect;
  ViewportRect: TRect;

  procedure ResetScene();
  procedure RequestTopology(NewTopology: TCanvasTopology);
  procedure RequestEffect(Effect: TBlendingEffect);
  procedure RequestTexture(Texture: TAsphyreCustomTexture);
  procedure AddVertexGL(x, y: Single);
  procedure AddPointGL(const Point: TPoint2; Color: Cardinal);
 protected
  procedure HandleBeginScene(); override;
  procedure HandleEndScene(); override;

  procedure GetViewport(out x, y, Width, Height: Integer); override;
  procedure SetViewport(x, y, Width, Height: Integer); override;

  function GetAntialias(): Boolean; override;
  procedure SetAntialias(const Value: Boolean); override;
  function GetMipMapping(): Boolean; override;
  procedure SetMipMapping(const Value: Boolean); override;
 public
  procedure PutPixel(const Point: TPoint2; Color: Cardinal); override;
  procedure Line(const Src, Dest: TPoint2; Color0, Color1: Cardinal); override;

  procedure DrawIndexedTriangles(Vertices: PPoint2; Colors: PLongWord;
   Indices: PLongInt; NoVertices, NoTriangles: Integer;
   Effect: TBlendingEffect = beNormal); override;

  procedure UseTexture(Texture: TAsphyreCustomTexture;
   const Mapping: TPoint4); override;

  procedure TexMap(const Points: TPoint4; const Colors: TColor4;
   Effect: TBlendingEffect = beNormal); override;

  procedure Flush(); override;
  procedure ResetStates(); override;

  constructor Create(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 {$ifdef FireMonkey}Macapi.CocoaTypes, Macapi.OpenGL{$else}AsphyreGL{$endif},
 OGLTypes;

//---------------------------------------------------------------------------
constructor TOGLCanvasMini.Create();
begin
 inherited;

 FAntialias := True;
 FMipmapping:= False;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.ResetStates();
var
 Viewport: array[0..3] of GLint;
begin
 Topology:= ctNone;
 CachedEffect:= beUnknown;

 CachedTex:= nil;
 ActiveTex:= nil;

 glGetIntegerv(GL_VIEWPORT, @Viewport[0]);

 NormSize.x:= Viewport[2] * 0.5;
 NormSize.y:= Viewport[3] * 0.5;

 glMatrixMode(GL_MODELVIEW);
 glLoadIdentity();

 glMatrixMode(GL_PROJECTION);
 glLoadIdentity();

 glDisable(GL_DEPTH_TEST);

 glDisable(GL_TEXTURE_1D);
 glDisable(GL_TEXTURE_2D);
 glEnable(GL_LINE_SMOOTH);

 if (GL_EXT_separate_specular_color)or(GL_VERSION_1_2) then
  glDisable(GL_COLOR_SUM_EXT);

 glEnable(GL_ALPHA_TEST);
 glAlphaFunc(GL_GREATER, 0.001);

 glScissor(Viewport[0], Viewport[1], Viewport[2], Viewport[3]);
 glEnable(GL_SCISSOR_TEST);

 ClippingRect:= Bounds(Viewport[0], Viewport[1], Viewport[2], Viewport[3]);
 ViewportRect:= Bounds(Viewport[0], Viewport[1], Viewport[2], Viewport[3]);
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.HandleBeginScene();
begin
 ResetStates();
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.HandleEndScene();
begin
 Flush();
end;

//---------------------------------------------------------------------------
function TOGLCanvasMini.GetAntialias(): Boolean;
begin
 Result:= FAntialias;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.SetAntialias(const Value: Boolean);
begin
 FAntialias:= Value;
end;

//---------------------------------------------------------------------------
function TOGLCanvasMini.GetMipMapping(): Boolean;
begin
 Result:= FMipmapping;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.SetMipMapping(const Value: Boolean);
begin
 FMipmapping:= Value;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.GetViewport(out x, y, Width, Height: Integer);
begin
 x:= ClippingRect.Left;
 y:= ClippingRect.Top;
 Width := ClippingRect.Right - ClippingRect.Left;
 Height:= ClippingRect.Bottom - ClippingRect.Top;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.SetViewport(x, y, Width, Height: Integer);
var
 ViewPos: Integer;
begin
 ResetScene();

 ViewPos:= (ViewportRect.Bottom - ViewportRect.Top) - (y + Height);

 glScissor(x, Viewpos, Width, Height);
 ClippingRect:= Bounds(x, y, Width, Height);
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.ResetScene();
begin
 if (Topology <> ctNone) then
  begin
   glEnd();
   NextDrawCall();
  end;

 Topology:= ctNone;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.RequestTopology(NewTopology: TCanvasTopology);
begin
 if (Topology <> NewTopology) then
  begin
   ResetScene();

   case NewTopology of
    ctPoints: glBegin(GL_POINTS);
    ctLines : glBegin(GL_LINES);
    ctTriangles  : glBegin(GL_TRIANGLES);
    ctQuads : glBegin(GL_QUADS);
   end;

   Topology:= NewTopology;
  end;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.RequestEffect(Effect: TBlendingEffect);
begin
 if (CachedEffect = Effect) then Exit;

 ResetScene();

 if (Effect <> beUnknown) then glEnable(GL_BLEND)
  else glDisable(GL_BLEND);

 case Effect of
  beNormal:
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  beShadow:
   glBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_ALPHA);

  beAdd:
   glBlendFunc(GL_SRC_ALPHA, GL_ONE);

  beMultiply:
   glBlendFunc(GL_ZERO, GL_SRC_COLOR);

  beSrcColor:
   glBlendFunc(GL_SRC_COLOR, GL_ONE_MINUS_SRC_COLOR);

  beSrcColorAdd:
   glBlendFunc(GL_SRC_COLOR, GL_ONE);

  beInvMultiply:
   glBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_COLOR);
 end;

 CachedEffect:= Effect;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.RequestTexture(Texture: TAsphyreCustomTexture);
begin
 if (CachedTex = Texture) then Exit;

 ResetScene();

 if (Assigned(Texture)) then
  begin
   Texture.Bind(0);

   if (FAntialias) then
    begin
     if (FMipmapping)and(Texture.Mipmapping)and(GL_VERSION_1_4) then
      begin
       glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
        GL_LINEAR_MIPMAP_LINEAR);
      end else
      begin
       glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      end;

     glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    end else
    begin
     if (FMipmapping)and(Texture.Mipmapping)and(GL_VERSION_1_4) then
      begin
       glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
        GL_LINEAR_MIPMAP_NEAREST);
      end else
      begin
       glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
      end;

     glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    end;

   glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
   glEnable(GL_TEXTURE_2D);
  end else
  begin
   glBindTexture(GL_TEXTURE_2D, 0);
   glDisable(GL_TEXTURE_2D);
  end;

 CachedTex:= Texture;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.AddVertexGL(x, y: Single);
var
 xNorm, yNorm: Single;
begin
 xNorm:= (x - NormSize.x) / NormSize.x;
 yNorm:= (y - NormSize.y) / NormSize.y;

 if (OGLUsingFrameBuffer) then glVertex2f(xNorm, yNorm)
  else glVertex2f(xNorm, -yNorm);
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.AddPointGL(const Point: TPoint2; Color: Cardinal);
var
 Colors: array[0..3] of Single;
begin
 Colors[0]:= ((Color shr 16) and $FF) / 255.0;
 Colors[1]:= ((Color shr 8) and $FF) / 255.0;
 Colors[2]:= (Color and $FF) / 255.0;
 Colors[3]:= ((Color shr 24) and $FF) / 255.0;

 glColor4fv(@Colors[0]);
 AddVertexGL(Point.x, Point.y);
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.PutPixel(const Point: TPoint2; Color: Cardinal);
begin
 RequestEffect(beNormal);
 RequestTexture(nil);
 RequestTopology(ctPoints);

 AddPointGL(Point, Color);
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.Line(const Src, Dest: TPoint2; Color0, Color1: Cardinal);
begin
 RequestEffect(beNormal);
 RequestTexture(nil);
 RequestTopology(ctLines);

 AddPointGL(Src + Point2(0.5, 0.5), Color0);
 AddPointGL(Dest + Point2(0.5, 0.5), Color1);
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.DrawIndexedTriangles(Vertices: PPoint2;
 Colors: PLongWord; Indices: PLongInt; NoVertices, NoTriangles: Integer;
 Effect: TBlendingEffect);
var
 i, i0, i1, i2: Integer;
 Vertex: PPoint2;
 Color : PLongWord;
begin
 RequestEffect(Effect);
 RequestTexture(nil);
 RequestTopology(ctTriangles);

 for i:= 0 to NoTriangles - 1 do
  begin
   i0:= Indices^; Inc(Indices);

   i1:= Indices^; Inc(Indices);

   i2:= Indices^; Inc(Indices);

   // Vertex 0
   Vertex:= Vertices;
   Inc(Vertex, i0);

   Color:= Colors;
   Inc(Color, i0);

   AddPointGL(Vertex^, Color^);

   // Vertex 1
   Vertex:= Vertices;
   Inc(Vertex, i1);

   Color:= Colors;
   Inc(Color, i1);

   AddPointGL(Vertex^, Color^);

   // Vertex 2
   Vertex:= Vertices;
   Inc(Vertex, i2);

   Color:= Colors;
   Inc(Color, i2);

   AddPointGL(Vertex^, Color^);
  end;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.UseTexture(Texture: TAsphyreCustomTexture;
 const Mapping: TPoint4);
begin
 ActiveTex  := Texture;
 QuadMapping:= Mapping;
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.TexMap(const Points: TPoint4; const Colors: TColor4;
 Effect: TBlendingEffect);
begin
 RequestEffect(Effect);
 RequestTexture(ActiveTex);
 RequestTopology(ctQuads);

 glTexCoord2f(QuadMapping[3].x, QuadMapping[3].y);
 AddPointGL(Points[3], Colors[3]);

 glTexCoord2f(QuadMapping[0].x, QuadMapping[0].y);
 AddPointGL(Points[0], Colors[0]);

 glTexCoord2f(QuadMapping[1].x, QuadMapping[1].y);
 AddPointGL(Points[1], Colors[1]);

 glTexCoord2f(QuadMapping[2].x, QuadMapping[2].y);
 AddPointGL(Points[2], Colors[2]);
end;

//---------------------------------------------------------------------------
procedure TOGLCanvasMini.Flush();
begin
 ResetScene();
 RequestEffect(beUnknown);
 RequestTexture(nil);
end;

//---------------------------------------------------------------------------
end.
