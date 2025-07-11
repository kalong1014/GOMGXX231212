unit DX10CanvasTechniques;
//---------------------------------------------------------------------------
// DX10CanvasTechniques.pas                             Modified: 14-Sep-2012
// Wrapper for Direct3D 10.x effect techniques.                  Version 1.01
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
// The Original Code is DX10CanvasTechniques.pas.
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
 AsphyreD3D10, AsphyreDef;

//---------------------------------------------------------------------------
type
 TDX10CanvasTechnique = record
  TechName: StdString;
  Technique: ID3D10EffectTechnique;
 end;

//---------------------------------------------------------------------------
 TDX10CanvasTechniques = class
 private
  FEffect: ID3D10Effect;
  FLayout: ID3D10InputLayout;

  FLayoutDecl: Pointer;
  FLayoutDeclCount: Integer;

  Data: array of TDX10CanvasTechnique;
  DataDirty: Boolean;

  function CanMakeLayout(): Boolean;
  function MakeLayout(Technique: ID3D10EffectTechnique): Boolean;
  function Add(const TechName: StdString): Integer;

  procedure DataListSwap(Index1, Index2: Integer);
  function DataListCompare(const Item1, Item2: TDX10CanvasTechnique): Integer;
  function DataListSplit(Start, Stop: Integer): Integer;
  procedure DataListSort(Start, Stop: Integer);
  procedure UpdateDataDirty();
  function IndexOf(const TechName: StdString): Integer;
 public
  property Effect: ID3D10Effect read FEffect;
  property Layout: ID3D10InputLayout read FLayout;

  property LayoutDecl: Pointer read FLayoutDecl write FLayoutDecl;
  property LayoutDeclCount: Integer read FLayoutDeclCount write FLayoutDeclCount;

  procedure ReleaseAll();

  function SetLayout(): Boolean;
  function CheckLayoutStatus(const TechName: StdString): Boolean;
  function Apply(const TechName: StdString): Boolean;

  constructor Create(AEffect: ID3D10Effect);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 Windows, SysUtils, AsphyreFPUStates, DX10Types;

//---------------------------------------------------------------------------
constructor TDX10CanvasTechniques.Create(AEffect: ID3D10Effect);
begin
 inherited Create();

 FEffect:= AEffect;
 FLayout:= nil;

 FLayoutDecl:= nil;
 FLayoutDeclCount:= 0;

 DataDirty:= False;
end;

//---------------------------------------------------------------------------
destructor TDX10CanvasTechniques.Destroy();
begin
 ReleaseAll();

 if (Assigned(FLayout)) then FLayout:= nil;
 if (Assigned(FEffect)) then FEffect:= nil;

 inherited;
end;

//---------------------------------------------------------------------------
function TDX10CanvasTechniques.CanMakeLayout(): Boolean;
begin
 Result:= (not Assigned(FLayout))and(Assigned(FLayoutDecl))and
  (FLayoutDeclCount > 0);
end;

//---------------------------------------------------------------------------
function TDX10CanvasTechniques.MakeLayout(
 Technique: ID3D10EffectTechnique): Boolean;
var
 Pass: ID3D10EffectPass;
 PassDesc: D3D10_PASS_DESC;
begin
 Result:= False;
 if (not Assigned(Technique))or(Assigned(FLayout))or
  (not Assigned(FLayoutDecl))or(FLayoutDeclCount < 1) then Exit;

 Pass:= Technique.GetPassByIndex(0);
 if (not Assigned(Pass)) then Exit;

 if (Failed(Pass.GetDesc(PassDesc))) then Exit;

 Result:= Succeeded(D3D10Device.CreateInputLayout(FLayoutDecl,
  FLayoutDeclCount, PassDesc.pIAInputSignature, PassDesc.IAInputSignatureSize,
  @FLayout));

 if (not Result) then FLayout:= nil;
end;

//---------------------------------------------------------------------------
function TDX10CanvasTechniques.Add(const TechName: StdString): Integer;
var
 NewTech: ID3D10EffectTechnique;
begin
 Result:= -1;
 if (not Assigned(FEffect)) then Exit;

 PushClearFPUState();
 try
  NewTech:= FEffect.GetTechniqueByName(PAnsiChar(AnsiString(TechName)));
 finally
  PopFPUState();
 end;

 if (not Assigned(NewTech))or(not NewTech.IsValid()) then Exit;

 Result:= Length(Data);
 SetLength(Data, Result + 1);

 FillChar(Data[Result], SizeOf(TDX10CanvasTechnique), 0);

 Data[Result].TechName := TechName;
 Data[Result].Technique:= NewTech;

 DataDirty:= True;

 if (CanMakeLayout()) then
  begin
   PushClearFPUState();
   try
    MakeLayout(NewTech);
   finally
    PopFPUState();
   end;
  end;
end;

//---------------------------------------------------------------------------
procedure TDX10CanvasTechniques.ReleaseAll();
var
 i: Integer;
begin
 for i:= Length(Data) - 1 downto 0 do
  if (Assigned(Data[i].Technique)) then Data[i].Technique:= nil;

 SetLength(Data, 0);
end;

//---------------------------------------------------------------------------
procedure TDX10CanvasTechniques.DataListSwap(Index1, Index2: Integer);
var
 Aux: TDX10CanvasTechnique;
begin
 Aux:= Data[Index1];

 Data[Index1]:= Data[Index2];
 Data[Index2]:= Aux;
end;

//---------------------------------------------------------------------------
function TDX10CanvasTechniques.DataListCompare(const Item1,
 Item2: TDX10CanvasTechnique): Integer;
begin
 Result:= CompareText(Item1.TechName, Item2.TechName);
end;

//---------------------------------------------------------------------------
function TDX10CanvasTechniques.DataListSplit(Start, Stop: Integer): Integer;
var
 Left, Right: Integer;
 Pivot: TDX10CanvasTechnique;
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
procedure TDX10CanvasTechniques.DataListSort(Start, Stop: Integer);
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
procedure TDX10CanvasTechniques.UpdateDataDirty();
begin
 if (Length(Data) > 1) then DatalistSort(0, Length(Data) - 1);
 DataDirty:= False;
end;

//---------------------------------------------------------------------------
function TDX10CanvasTechniques.IndexOf(const TechName: StdString): Integer;
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
   Res:= CompareText(Data[Mid].TechName, TechName);

   if (Res = 0) then
    begin
     Result:= Mid;
     Break;
    end;

   if (Res > 0) then Hi:= Mid - 1 else Lo:= Mid + 1;
 end;
end;

//---------------------------------------------------------------------------
function TDX10CanvasTechniques.SetLayout(): Boolean;
begin
 Result:= (Assigned(D3D10Device))and(Assigned(FLayout));
 if (not Result) then Exit;

 PushClearFPUState();
 try
  D3D10Device.IASetInputLayout(FLayout);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX10CanvasTechniques.CheckLayoutStatus(
 const TechName: StdString): Boolean;
var
 Index: Integer;
begin
 Result:= Assigned(FLayout);
 if (Result) then Exit;

 Index:= IndexOf(TechName);
 if (Index = -1) then Index:= Add(TechName);

 Result:= Index <> -1;
end;

//---------------------------------------------------------------------------
function TDX10CanvasTechniques.Apply(const TechName: StdString): Boolean;
var
 Index: Integer;
 Pass: ID3D10EffectPass;
begin
 Result:= False;

 Index:= IndexOf(TechName);
 if (Index = -1) then
  begin
   Index:= Add(TechName);
   if (Index = -1) then Exit;
  end;

 PushClearFPUState();
 try
  Pass:= Data[Index].Technique.GetPassByIndex(0);
 finally
  PopFPUState();
 end;

 if (not Assigned(Pass)) then Exit;

 PushClearFPUState();
 try
  Result:= Succeeded(Pass.Apply(0));
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
end.
