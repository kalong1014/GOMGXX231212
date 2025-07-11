unit DX10CanvasEffects;
//---------------------------------------------------------------------------
// DX10CanvasEffects.pas                                Modified: 14-Sep-2012
// Wrapper for Direct3D 10 Effect files used in 2D canvas        Version 1.01
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
// The Original Code is DX10CanvasEffects.pas.
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
 AsphyreD3D10, Classes, SysUtils, AsphyreDef, DX10EffectVariables,
 DX10CanvasTechniques;

//---------------------------------------------------------------------------
// Remove dot "." to enable loading shaders from external files. This will
// include "D3DX10.pas" to USES and require distributing "d3dx10_41.dll".
//---------------------------------------------------------------------------
{.$define EnableD3DX10}

//---------------------------------------------------------------------------
type
 TDX10CanvasEffect = class
 private
  FEffect: ID3D10Effect;
  FVariables : TDX10EffectVariables;
  FTechniques: TDX10CanvasTechniques;

  function GetActive(): Boolean;
 public
  property Effect: ID3D10Effect read FEffect;

  property Variables : TDX10EffectVariables read FVariables;
  property Techniques: TDX10CanvasTechniques read FTechniques;

  property Active: Boolean read GetActive;

  procedure ReleaseAll();

  {$ifdef EnableD3DX10}
  function CompileFromFile(const FileName: StdString): Boolean;
  {$endif}

  function LoadCompiledFromMem(Data: Pointer; DataLength: Integer): Boolean;
  function LoadCompiledFromFile(const FileName: StdString): Boolean;

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 Windows, DX10Types, AsphyreFPUStates;

//---------------------------------------------------------------------------
constructor TDX10CanvasEffect.Create();
begin
 inherited;

 FEffect    := nil;
 FVariables := nil;
 FTechniques:= nil;
end;

//---------------------------------------------------------------------------
destructor TDX10CanvasEffect.Destroy();
begin
 ReleaseAll();

 inherited;
end;

//---------------------------------------------------------------------------
function TDX10CanvasEffect.GetActive(): Boolean;
begin
 Result:= (Assigned(FEffect))and(Assigned(FVariables))and
  (Assigned(FTechniques));
end;

//---------------------------------------------------------------------------
procedure TDX10CanvasEffect.ReleaseAll();
begin
 if (Assigned(FTechniques)) then FreeAndNil(FTechniques);
 if (Assigned(FVariables)) then FreeAndNil(FVariables);
 if (Assigned(FEffect)) then FEffect:= nil;
end;

//---------------------------------------------------------------------------
{$ifdef EnableD3DX10}
function TDX10CanvasEffect.CompileFromFile(const FileName: StdString): Boolean;
var
 Flags: Cardinal;
 Errors: ID3D10Blob;
begin
 Result:= (Assigned(D3D10Device))and(not Assigned(FEffect));
 if (not Result) then Exit;

 Flags:= D3D10_SHADER_ENABLE_STRICTNESS;
 {$ifdef DEBUG}Flags:= Flags or D3D10_SHADER_DEBUG;{$endif}

 PushClearFPUState();

 try
  Result:= Succeeded(D3DX10CreateEffectFromFile(PChar(FileName),
   TD3D10_ShaderMacro(nil^), nil, 'fx_4_0', Flags, 0, D3D10Device, nil, nil,
   FEffect, Errors, nil));
 finally
  PopFPUState();
 end;

 if (Result) then
  begin
   FVariables := TDX10EffectVariables.Create(FEffect);
   FTechniques:= TDX10CanvasTechniques.Create(FEffect);
  end;
end;
{$endif}

//---------------------------------------------------------------------------
function TDX10CanvasEffect.LoadCompiledFromMem(Data: Pointer;
 DataLength: Integer): Boolean;
begin
 Result:= (Assigned(Data))and(DataLength > 0)and(Assigned(D3D10Device))and
  (not Assigned(FEffect));
 if (not Result) then Exit;

 PushClearFPUState();
 try
  Result:= Succeeded(D3D10CreateEffectFromMemory(Data, DataLength, 0,
   D3D10Device, nil, FEffect));
 finally
  PopFPUState();
 end;

 if (Result) then
  begin
   FVariables := TDX10EffectVariables.Create(FEffect);
   FTechniques:= TDX10CanvasTechniques.Create(FEffect);
  end;
end;

//---------------------------------------------------------------------------
function TDX10CanvasEffect.LoadCompiledFromFile(
 const FileName: StdString): Boolean;
var
 FileSt: TFileStream;
 MemSt : TMemoryStream;
begin
 Result:= False;

 try
  FileSt:= TFileStream.Create(FileName, fmOpenRead or fmShareExclusive);
 except
  Exit;
 end;

 MemSt:= TMemoryStream.Create();

 try
  MemSt.LoadFromStream(FileSt);
 except
  FreeAndNil(MemSt);
  FreeAndNil(FileSt);
  Exit;
 end;

 FreeAndNil(FileSt);

 Result:= LoadCompiledFromMem(MemSt.Memory, MemSt.Size);
 FreeAndNil(MemSt);
end;

//---------------------------------------------------------------------------
end.
