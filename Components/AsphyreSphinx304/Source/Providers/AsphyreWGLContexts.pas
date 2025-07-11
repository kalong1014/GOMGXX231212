unit AsphyreWGLContexts;
//---------------------------------------------------------------------------
// AsphyreWGLContexts.pas                               Modified: 14-Sep-2012
// OpenGL windows rendering contexts.                             Version 1.1
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
// The Original Code is AsphyreWGLContexts.pas.
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
 Windows;

//---------------------------------------------------------------------------
type
 POGLContext = ^TOGLContext;
 TOGLContext = record
  Handle : THandle;
  WinDC  : HDC;
  Context: HGLRC;
 end;

//---------------------------------------------------------------------------
 TOGLContexts = class
 private
  Data: array of TOGLContext;

  SearchList : array of Integer;
  SearchDirty: Boolean;

  function GetCount(): Integer;
  function GetItem(Index: Integer): POGLContext;
  procedure Release(Index: Integer);

  procedure InitSearchList();
  procedure SearchListSwap(Index1, Index2: Integer);
  function SearchListCompare(Index1, Index2: Integer): Integer;
  function SearchListSplit(Start, Stop: Integer): Integer;
  procedure SearchListSort(Start, Stop: Integer);
  procedure UpdateSearchList();

  function SetPlainPixelFormat(DestDC: HDC): Boolean;

  function InitWindow(Index: Integer; MainHandle: THandle): Boolean;
 public
  property Count: Integer read GetCount;
  property Items[Index: Integer]: POGLContext read GetItem; default;

  function Insert(Handle: THandle): Integer;
  function IndexOf(Handle: THandle): Integer;

  procedure Remove(Index: Integer);
  procedure RemoveAll();

  function Activate(SubHandle, MainHandle: THandle): Boolean;

  function Flip(WinHandle: THandle): Boolean;

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreGL;

//---------------------------------------------------------------------------
constructor TOGLContexts.Create();
begin
 inherited;

 SearchDirty:= False;
end;

//---------------------------------------------------------------------------
destructor TOGLContexts.Destroy();
begin
 RemoveAll();

 inherited;
end;

//---------------------------------------------------------------------------
function TOGLContexts.GetCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TOGLContexts.GetItem(Index: Integer): POGLContext;
begin
 if (Index >= 0)and(Index < Length(Data)) then
  Result:= @Data[Index]
   else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TOGLContexts.Release(Index: Integer);
begin
 if (Index < 0)or(Index >= Length(Data)) then Exit;

 if (Data[Index].Context <> 0) then
  begin
   if (wglGetCurrentContext() = Data[Index].Context) then
    wglMakeCurrent(0, 0);

   wglDeleteContext(Data[Index].Context);

   Data[Index].Context:= 0;
  end;

 if (Data[Index].WinDC <> 0) then
  begin
   ReleaseDC(Data[Index].Handle, Data[Index].WinDC);
   Data[Index].WinDC:= 0;
  end;
end;

//---------------------------------------------------------------------------
procedure TOGLContexts.Remove(Index: Integer);
var
 i: Integer;
begin
 if (Index < 0)or(Index >= Length(Data)) then Exit;

 Release(Index);

 for i:= Index to Length(Data) - 2 do
  Data[i]:= Data[i + 1];

 SetLength(Data, Length(Data) - 1);

 SearchDirty:= True;
end;

//---------------------------------------------------------------------------
procedure TOGLContexts.RemoveAll();
var
 i: Integer;
begin
 for i:= Length(Data) - 1 downto 0 do
  Release(i);

 SetLength(Data, 0);
 SearchDirty:= True;
end;

//---------------------------------------------------------------------------
function TOGLContexts.Insert(Handle: THandle): Integer;
begin
 Result:= Length(Data);
 SetLength(Data, Result + 1);

 Data[Result].Handle:= Handle;
 Data[Result].WinDC := 0;
 Data[Result].Context:= 0;

 SearchDirty:= True;
end;

//---------------------------------------------------------------------------
procedure TOGLContexts.InitSearchList();
var
 i: Integer;
begin
 if (Length(SearchList) <> Length(Data)) then
  SetLength(SearchList, Length(Data));

 for i:= 0 to Length(SearchList) - 1 do
  SearchList[i]:= i;
end;

//---------------------------------------------------------------------------
procedure TOGLContexts.SearchListSwap(Index1, Index2: Integer);
var
 Aux: Integer;
begin
 Aux:= SearchList[Index1];

 SearchList[Index1]:= SearchList[Index2];
 SearchList[Index2]:= Aux;
end;

//---------------------------------------------------------------------------
function TOGLContexts.SearchListCompare(Index1, Index2: Integer): Integer;
begin
 Result:= 0;

 if (Data[Index1].Handle < Data[Index2].Handle) then Result:= -1;
 if (Data[Index1].Handle > Data[Index2].Handle) then Result:= 1;
end;

//---------------------------------------------------------------------------
function TOGLContexts.SearchListSplit(Start, Stop: Integer): Integer;
var
 Left, Right, Pivot: Integer;
begin
 Left := Start + 1;
 Right:= Stop;
 Pivot:= SearchList[Start];

 while (Left <= Right) do
  begin
   while (Left <= Stop)and(SearchListCompare(SearchList[Left], Pivot) < 0) do
    Inc(Left);

   while (Right > Start)and(SearchListCompare(SearchList[Right], Pivot) >= 0) do
    Dec(Right);

   if (Left < Right) then SearchListSwap(Left, Right);
  end;

 SearchListSwap(Start, Right);

 Result:= Right;
end;

//---------------------------------------------------------------------------
procedure TOGLContexts.SearchListSort(Start, Stop: Integer);
var
 SplitPt: Integer;
begin
 if (Start < Stop) then
  begin
   SplitPt:= SearchListSplit(Start, Stop);

   SearchListSort(Start, SplitPt - 1);
   SearchListSort(SplitPt + 1, Stop);
  end;
end;

//---------------------------------------------------------------------------
procedure TOGLContexts.UpdateSearchList();
begin
 InitSearchList();
 if (Length(SearchList) > 1) then SearchListSort(0, Length(SearchList) - 1);

 SearchDirty:= False;
end;

//---------------------------------------------------------------------------
function TOGLContexts.IndexOf(Handle: THandle): Integer;
var
 Lo, Hi, Mid: Integer;
begin
 if (SearchDirty) then UpdateSearchList();

 Result:= -1;

 Lo:= 0;
 Hi:= Length(SearchList) - 1;

 while (Lo <= Hi) do
  begin
   Mid:= (Lo + Hi) div 2;

   if (Data[SearchList[Mid]].Handle = Handle) then
    begin
     Result:= SearchList[Mid];
     Break;
    end;

   if (Data[SearchList[Mid]].Handle > Handle) then Hi:= Mid - 1
    else Lo:= Mid + 1;
 end;
end;

//---------------------------------------------------------------------------
function TOGLContexts.SetPlainPixelFormat(DestDC: HDC): Boolean;
var
 FormatIndex: Integer;
 FormatDesc : TPixelFormatDescriptor;
begin
 FillChar(FormatDesc, SizeOf(TPixelFormatDescriptor), 0);

 FormatDesc.nSize     := SizeOf(TPixelFormatDescriptor);
 FormatDesc.nVersion  := 1;
 FormatDesc.iPixelType:= PFD_TYPE_RGBA;
 FormatDesc.cColorBits:= 32;
 FormatDesc.cDepthBits:= 24;
 FormatDesc.cStencilBits:= 8;
 FormatDesc.iLayerType:= PFD_MAIN_PLANE;
 FormatDesc.dwFlags   := PFD_SUPPORT_OPENGL or PFD_DRAW_TO_WINDOW or
  PFD_DOUBLEBUFFER;

 FormatIndex:= ChoosePixelFormat(DestDC, @FormatDesc);

 Result:= FormatIndex <> 0;
 if (not Result) then Exit;

 Result:= SetPixelFormat(DestDC, FormatIndex, nil);
end;

//---------------------------------------------------------------------------
function TOGLContexts.InitWindow(Index: Integer; MainHandle: THandle): Boolean;
var
 MainIndex: Integer;
begin
 // (1) Retrieve DC from window handle.
 Data[Index].WinDC:= GetDC(Data[Index].Handle);
 Result:= Data[Index].WinDC <> 0;

 if (not Result) then Exit;

 // (2) Prepare window's pixel format.
 Result:= SetPlainPixelFormat(Data[Index].WinDC);
 if (not Result) then Exit;

 // (3) Create OpenGL rendering context.
 Data[Index].Context:= wglCreateContext(Data[Index].WinDC);

 Result:= Data[Index].Context <> 0;
 if (not Result) then Exit;

 // (4) Share resources with the new context.
 if (MainHandle <> 0)and(MainHandle <> Data[Index].Handle) then
  begin
   MainIndex:= IndexOf(MainHandle);

   if (MainIndex <> -1) then
    Result:= wglShareLists(Data[MainIndex].Context, Data[Index].Context);
  end;
end;

//---------------------------------------------------------------------------
function TOGLContexts.Activate(SubHandle, MainHandle: THandle): Boolean;
var
 Index: Integer;
begin
 Index:= IndexOf(SubHandle);
 if (Index = -1) then
  begin
   Index:= Insert(SubHandle);
   Result:= InitWindow(Index, MainHandle);

   if (not Result) then
    begin
     Remove(Index);
     Exit;
    end;
  end;

 Result:= wglMakeCurrent(Data[Index].WinDC, Data[Index].Context);
end;

//---------------------------------------------------------------------------
function TOGLContexts.Flip(WinHandle: THandle): Boolean;
var
 Index: Integer;
begin
 Index:= IndexOf(WinHandle);

 if (Index <> -1) then
  Result:= SwapBuffers(Data[Index].WinDC)
   else Result:= False;
end;

//---------------------------------------------------------------------------
end.
