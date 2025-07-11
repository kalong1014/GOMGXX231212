unit DX10EffectVariables;
//---------------------------------------------------------------------------
// DX10EffectVariables.pas                              Modified: 14-Sep-2012
// Wrapper for Direct3D 10.x effect variables.                   Version 1.01
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
// The Original Code is DX10EffectVariables.pas.
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
 AsphyreD3D10, AsphyreDef, Vectors2, Vectors3, Vectors4, Matrices4;

//---------------------------------------------------------------------------
type
 TDX10EffectVariable = record
  VarName: StdString;
  BaseVariable  : ID3D10EffectVariable;
  ShaderResource: ID3D10EffectShaderResourceVariable;
  ScalarVariable: ID3D10EffectScalarVariable;
  VectorVariable: ID3D10EffectVectorVariable;
  MatrixVariable: ID3D10EffectMatrixVariable;
 end;

//---------------------------------------------------------------------------
 TDX10EffectVariables = class
 private
  FEffect: ID3D10Effect;

  Data: array of TDX10EffectVariable;
  DataDirty: Boolean;

  function Add(const VarName: StdString): Integer;

  procedure DataListSwap(Index1, Index2: Integer);
  function DataListCompare(const Item1, Item2: TDX10EffectVariable): Integer;
  function DataListSplit(Start, Stop: Integer): Integer;
  procedure DataListSort(Start, Stop: Integer);
  procedure UpdateDataDirty();

  function IndexOf(const VarName: StdString): Integer;
  function CheckVarIndex(const VarName: StdString): Integer;
  function CheckScalarVarIndex(const VarName: StdString;
   out Index: Integer): Boolean;
  function CheckVectorVarIndex(const VarName: StdString;
   out Index: Integer): Boolean;
  function CheckMatrixVarIndex(const VarName: StdString;
   out Index: Integer): Boolean;
 public
  property Effect: ID3D10Effect read FEffect;

  function SetShaderResource(const VarName: StdString;
   ResourceView: ID3D10ShaderResourceView): Boolean;

  function SetFloat(const VarName: StdString; Value: Single): Boolean;
  function SetInteger(const VarName: StdString; Value: Integer): Boolean;
  function SetCardinal(const VarName: StdString; Value: Cardinal): Boolean;

  function SetPoint2(const VarName: StdString; const Point: TPoint2): Boolean;
  function SetVector3(const VarName: StdString; const Vec: TVector3): Boolean;
  function SetVector4(const VarName: StdString; const Vec: TVector4): Boolean;
  function SetMatrix4(const VarName: StdString; const Mtx: TMatrix4): Boolean;

  procedure ReleaseAll();

  constructor Create(AEffect: ID3D10Effect);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 Windows, SysUtils, AsphyreFPUStates;

//---------------------------------------------------------------------------
constructor TDX10EffectVariables.Create(AEffect: ID3D10Effect);
begin
 inherited Create();

 FEffect:= AEffect;
 DataDirty:= False;
end;

//---------------------------------------------------------------------------
destructor TDX10EffectVariables.Destroy();
begin
 ReleaseAll();
 if (Assigned(FEffect)) then FEffect:= nil;

 inherited;
end;

//---------------------------------------------------------------------------
procedure TDX10EffectVariables.ReleaseAll();
var
 i: Integer;
begin
 for i:= Length(Data) - 1 downto 0 do
  begin
   if (Assigned(Data[i].MatrixVariable)) then Data[i].MatrixVariable:= nil;
   if (Assigned(Data[i].VectorVariable)) then Data[i].VectorVariable:= nil;
   if (Assigned(Data[i].ScalarVariable)) then Data[i].ScalarVariable:= nil;
   if (Assigned(Data[i].ShaderResource)) then Data[i].ShaderResource:= nil;
   if (Assigned(Data[i].BaseVariable)) then Data[i].BaseVariable:= nil;
  end;

 SetLength(Data, 0);
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.Add(const VarName: StdString): Integer;
var
 NewVar: ID3D10EffectVariable;
begin
 Result:= -1;
 if (not Assigned(FEffect)) then Exit;

 PushClearFPUState();
 try
  NewVar:= FEffect.GetVariableByName(PAnsiChar(AnsiString(VarName)));
 finally
  PopFPUState();
 end;

 if (not Assigned(NewVar))or(not NewVar.IsValid()) then Exit;

 Result:= Length(Data);
 SetLength(Data, Result + 1);

 FillChar(Data[Result], SizeOf(TDX10EffectVariable), 0);

 Data[Result].VarName:= VarName;
 Data[Result].BaseVariable:= NewVar;

 DataDirty:= True;
end;

//---------------------------------------------------------------------------
procedure TDX10EffectVariables.DataListSwap(Index1, Index2: Integer);
var
 Aux: TDX10EffectVariable;
begin
 Aux:= Data[Index1];

 Data[Index1]:= Data[Index2];
 Data[Index2]:= Aux;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.DataListCompare(const Item1,
 Item2: TDX10EffectVariable): Integer;
begin
 Result:= CompareText(Item1.VarName, Item2.VarName);
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.DataListSplit(Start, Stop: Integer): Integer;
var
 Left, Right: Integer;
 Pivot: TDX10EffectVariable;
begin
 Left := Start + 1;
 Right:= Stop;
 Pivot:= Data[Start];

 while (Left <= Right) do
  begin
   while (Left <= Stop)and(DataListCompare(Data[Left], Pivot) < 0) do
    Inc(Left);

   while (Right > Start)and(DataListCompare(Data[Right], Pivot) >= 0) do
    Dec(Right);

   if (Left < Right) then DataListSwap(Left, Right);
  end;

 DataListSwap(Start, Right);

 Result:= Right;
end;

//---------------------------------------------------------------------------
procedure TDX10EffectVariables.DataListSort(Start, Stop: Integer);
var
 SplitPt: Integer;
begin
 if (Start < Stop) then
  begin
   SplitPt:= DataListSplit(Start, Stop);

   DataListSort(Start, SplitPt - 1);
   DataListSort(SplitPt + 1, Stop);
  end;
end;

//---------------------------------------------------------------------------
procedure TDX10EffectVariables.UpdateDataDirty();
begin
 if (Length(Data) > 1) then DatalistSort(0, Length(Data) - 1);
 DataDirty:= False;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.IndexOf(const VarName: StdString): Integer;
var
 Lo, Hi, Mid, Res: Integer;
begin
 if (DataDirty) then UpdateDataDirty();

 Result:= -1;

 Lo:= 0;
 Hi:= Length(Data) - 1;

 while (Lo <= Hi) do
  begin
   Mid:= (Lo + Hi) div 2;
   Res:= CompareText(Data[Mid].VarName, VarName);

   if (Res = 0) then
    begin
     Result:= Mid;
     Break;
    end;

   if (Res > 0) then Hi:= Mid - 1 else Lo:= Mid + 1;
 end;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.CheckVarIndex(const VarName: StdString): Integer;
begin
 Result:= IndexOf(VarName);
 if (Result = -1) then Result:= Add(VarName);
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.SetShaderResource(const VarName: StdString;
 ResourceView: ID3D10ShaderResourceView): Boolean;
var
 Index: Integer;
 ShaderRes: ID3D10EffectShaderResourceVariable;
begin
 Result:= False;

 Index:= CheckVarIndex(VarName);
 if (Index = -1) then Exit;

 if (not Assigned(Data[Index].ShaderResource)) then
  begin
   PushClearFPUState();
   try
    ShaderRes:= Data[Index].BaseVariable.AsShaderResource();
   finally
    PopFPUState();
   end;

   if (not Assigned(ShaderRes))or(not ShaderRes.IsValid()) then Exit;

   Data[Index].ShaderResource:= ShaderRes;
  end;

 PushClearFPUState();
 try
  Result:= Succeeded(Data[Index].ShaderResource.SetResource(ResourceView));
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.CheckScalarVarIndex(
 const VarName: StdString; out Index: Integer): Boolean;
var
 ScalarVar: ID3D10EffectScalarVariable;
begin
 Result:= False;

 Index:= CheckVarIndex(VarName);
 if (Index = -1) then Exit;

 if (not Assigned(Data[Index].ScalarVariable)) then
  begin
   PushClearFPUState();
   try
    ScalarVar:= Data[Index].BaseVariable.AsScalar();
   finally
    PopFPUState();
   end;

   if (not Assigned(ScalarVar))or(not ScalarVar.IsValid()) then Exit;

   Data[Index].ScalarVariable:= ScalarVar;
  end;

 Result:= True;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.CheckVectorVarIndex(const VarName: StdString;
 out Index: Integer): Boolean;
var
 VectorVar: ID3D10EffectVectorVariable;
begin
 Result:= False;

 Index:= CheckVarIndex(VarName);
 if (Index = -1) then Exit;

 if (not Assigned(Data[Index].ScalarVariable)) then
  begin
   PushClearFPUState();
   try
    VectorVar:= Data[Index].BaseVariable.AsVector();
   finally
    PopFPUState();
   end;

   if (not Assigned(VectorVar))or(not VectorVar.IsValid()) then Exit;

   Data[Index].VectorVariable:= VectorVar;
  end;

 Result:= True;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.CheckMatrixVarIndex(const VarName: StdString;
 out Index: Integer): Boolean;
var
 MatrixVar: ID3D10EffectMatrixVariable;
begin
 Result:= False;

 Index:= CheckVarIndex(VarName);
 if (Index = -1) then Exit;

 if (not Assigned(Data[Index].MatrixVariable)) then
  begin
   PushClearFPUState();
   try
    MatrixVar:= Data[Index].BaseVariable.AsMatrix();
   finally
    PopFPUState();
   end;

   if (not Assigned(MatrixVar))or(not MatrixVar.IsValid()) then Exit;

   Data[Index].MatrixVariable:= MatrixVar;
  end;

 Result:= True;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.SetFloat(const VarName: StdString;
 Value: Single): Boolean;
var
 Index: Integer;
begin
 Result:= CheckScalarVarIndex(VarName, Index);
 if (not Result) then Exit;

 PushClearFPUState();
 try
  Result:= Succeeded(Data[Index].ScalarVariable.SetFloat(Value));
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.SetInteger(const VarName: StdString;
 Value: Integer): Boolean;
var
 Index: Integer;
begin
 Result:= CheckScalarVarIndex(VarName, Index);
 if (not Result) then Exit;

 PushClearFPUState();
 try
  Result:= Succeeded(Data[Index].ScalarVariable.SetInt(Value));
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.SetCardinal(const VarName: StdString;
 Value: Cardinal): Boolean;
begin
 Result:= SetInteger(VarName, Integer(Value));
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.SetPoint2(const VarName: StdString;
 const Point: TPoint2): Boolean;
var
 Index: Integer;
 Values: array[0..3] of Single;
begin
 Result:= CheckVectorVarIndex(VarName, Index);
 if (not Result) then Exit;

 Values[0]:= Point.x;
 Values[1]:= Point.y;
 Values[2]:= 0.0;
 Values[3]:= 0.0;

 PushClearFPUState();
 try
  Result:= Succeeded(Data[Index].VectorVariable.SetFloatVector(@Values[0]));
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.SetVector3(const VarName: StdString;
 const Vec: TVector3): Boolean;
var
 Index: Integer;
 Values: array[0..3] of Single;
begin
 Result:= CheckVectorVarIndex(VarName, Index);
 if (not Result) then Exit;

 Values[0]:= Vec.x;
 Values[1]:= Vec.y;
 Values[2]:= Vec.z;
 Values[3]:= 0.0;

 PushClearFPUState();
 try
  Result:= Succeeded(Data[Index].VectorVariable.SetFloatVector(@Values[0]));
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.SetVector4(const VarName: StdString;
 const Vec: TVector4): Boolean;
var
 Index: Integer;
 Values: array[0..3] of Single;
begin
 Result:= CheckVectorVarIndex(VarName, Index);
 if (not Result) then Exit;

 Values[0]:= Vec.x;
 Values[1]:= Vec.y;
 Values[2]:= Vec.z;
 Values[3]:= Vec.w;

 PushClearFPUState();
 try
  Result:= Succeeded(Data[Index].VectorVariable.SetFloatVector(@Values[0]));
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX10EffectVariables.SetMatrix4(const VarName: StdString;
 const Mtx: TMatrix4): Boolean;
var
 Index: Integer;
 i, j : Integer;
 Values: array[0..3, 0..3] of Single;
begin
 Result:= CheckMatrixVarIndex(VarName, Index);
 if (not Result) then Exit;

 for j:= 0 to 3 do
  for i:= 0 to 3 do
   Values[j, i]:= Mtx.Data[j, i];

 PushClearFPUState();
 try
  Result:= Succeeded(Data[Index].MatrixVariable.SetMatrix(@Values[0, 0]));
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
end.
