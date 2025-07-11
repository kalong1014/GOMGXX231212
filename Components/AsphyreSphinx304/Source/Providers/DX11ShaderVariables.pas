unit DX11ShaderVariables;
//---------------------------------------------------------------------------
// DX11ShaderVariables.pas                              Modified: 14-Sep-2012
// Wrapper for Direct3D 11 constant buffer shader variables.      Version 1.0
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
// The Original Code is DX11ShaderVariables.pas.
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
 SysUtils, AsphyreDef;

//---------------------------------------------------------------------------
type
 PDX11BufferVariable = ^TDX11BufferVariable;
 TDX11BufferVariable = record
  VariableName: StdString;
  ByteAddress: Integer;
  SizeInBytes: Integer;
 end;

//---------------------------------------------------------------------------
 TDX11BufferVariables = class
 private
  Data: array of TDX11BufferVariable;
  DataDirty: Boolean;

  procedure DataListSwap(Index1, Index2: Integer);
  function DataListCompare(const Item1, Item2: TDX11BufferVariable): Integer;
  function DataListSplit(Start, Stop: Integer): Integer;
  procedure DataListSort(Start, Stop: Integer);
  procedure UpdateDataDirty();

  function IndexOf(const Name: StdString): Integer;

  function GetVariable(const Name: StdString): PDX11BufferVariable;
 public
  property Variable[const Name: StdString]: PDX11BufferVariable
   read GetVariable; default;

  procedure Declare(const Name: StdString; AByteAddress, ASizeInBytes: Integer);
  procedure Clear();

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TDX11BufferVariables.Create();
begin
 inherited;

 DataDirty:= False;
end;

//---------------------------------------------------------------------------
destructor TDX11BufferVariables.Destroy();
begin
 Clear();

 inherited;
end;

//---------------------------------------------------------------------------
procedure TDX11BufferVariables.DataListSwap(Index1, Index2: Integer);
var
 Aux: TDX11BufferVariable;
begin
 Aux:= Data[Index1];

 Data[Index1]:= Data[Index2];
 Data[Index2]:= Aux;
end;

//---------------------------------------------------------------------------
function TDX11BufferVariables.DataListCompare(const Item1,
 Item2: TDX11BufferVariable): Integer;
begin
 Result:= CompareText(Item1.VariableName, Item2.VariableName);
end;

//---------------------------------------------------------------------------
function TDX11BufferVariables.DataListSplit(Start, Stop: Integer): Integer;
var
 Left, Right: Integer;
 Pivot: TDX11BufferVariable;
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
procedure TDX11BufferVariables.DataListSort(Start, Stop: Integer);
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
procedure TDX11BufferVariables.UpdateDataDirty();
begin
 if (Length(Data) > 1) then DatalistSort(0, Length(Data) - 1);
 DataDirty:= False;
end;

//---------------------------------------------------------------------------
function TDX11BufferVariables.IndexOf(const Name: StdString): Integer;
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
   Res:= CompareText(Data[Mid].VariableName, Name);

   if (Res = 0) then
    begin
     Result:= Mid;
     Break;
    end;

   if (Res > 0) then Hi:= Mid - 1 else Lo:= Mid + 1;
 end;
end;

//---------------------------------------------------------------------------
procedure TDX11BufferVariables.Clear();
begin
 SetLength(Data, 0);
 DataDirty:= False;
end;

//---------------------------------------------------------------------------
function TDX11BufferVariables.GetVariable(
 const Name: StdString): PDX11BufferVariable;
var
 Index: Integer;
begin
 Index:= IndexOf(Name);

 if (Index <> -1) then
  Result:= @Data[Index]
   else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TDX11BufferVariables.Declare(const Name: StdString; AByteAddress,
 ASizeInBytes: Integer);
var
 Index: Integer;
begin
 Index:= IndexOf(Name);

 if (Index = -1) then
  begin
   Index:= Length(Data);
   SetLength(Data, Index + 1);

   DataDirty:= True;
  end;

 Data[Index].VariableName:= Name;

 Data[Index].ByteAddress:= AByteAddress;
 Data[Index].SizeInBytes:= ASizeInBytes;
end;

//---------------------------------------------------------------------------
end.
