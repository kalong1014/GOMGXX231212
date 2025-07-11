unit OGLCanvasShaders;
//---------------------------------------------------------------------------
// OGLCanvasShaders.pas                                 Modified: 14-Sep-2012
// GLSL source code for modern Asphyre OpenGL canvas.             Version 1.0
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
// The Original Code is OGLCanvasShaders.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
const
 VertexShaderSource: AnsiString =
  '#version 110'#13#10 +
  'attribute vec2 InpVertex; attribute vec2 InpTexCoord; attribute vec4 InpColor;'#13#10 +
  'varying vec4 VarCol; varying vec2 VarTex;'#13#10 +
  'void main() { gl_Position = vec4(InpVertex, 0.0, 1.0); VarCol = InpColor; VarTex = InpTexCoord; }' + #0;

//---------------------------------------------------------------------------
 PixelShaderSolidSource: AnsiString =
  '#version 110'#13#10 +
  'varying vec4 VarCol;'#13#10 +
  'void main() { if (VarCol.w < 0.00390625) discard; gl_FragColor = VarCol; }' + #0;

//---------------------------------------------------------------------------
 PixelShaderTexturedSource: AnsiString =
  '#version 110'#13#10 +
  'uniform sampler2D SourceTex;'#13#10 +
  'varying vec4 VarCol; varying vec2 VarTex;'#13#10 +
  'void main() { vec4 TempCol = texture2D(SourceTex, VarTex) * VarCol; if (TempCol.w < 0.00390625) discard; gl_FragColor = TempCol; }' + #0;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
end.
