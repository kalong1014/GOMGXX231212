unit DX10SwapChains;
//---------------------------------------------------------------------------
// DX10SwapChains.pas                                   Modified: 14-Sep-2012
// Direct3D 10.x multiple swap chains implementation.            Version 1.01
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
// The Original Code is DX10SwapChains.pas.
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
 AsphyreDXGI, AsphyreD3D10, AsphyreTypes, AsphyreSwapChains;

//---------------------------------------------------------------------------
type
 TDX10SwapChain = class
 private
  FInitialized: Boolean;

  FDXGISwapChain: IDXGISwapChain;
  FSwapChainDesc: DXGI_SWAP_CHAIN_DESC;

  FRenderTargetView: ID3D10RenderTargetView;
  FDepthStencilTex : ID3D10Texture2D;
  FDepthStencilView: ID3D10DepthStencilView;

  VSyncEnabled: Boolean;
  FIdleState: Boolean;

  function FindSwapChainFormat(Format: TAsphyrePixelFormat): DXGI_FORMAT;
  function CreateSwapChain(UserDesc: PSwapChainDesc): Boolean;
  procedure DestroySwapChain();

  function CreateRenderTargetView(): Boolean;
  procedure DestroyRenderTargetView();

  function CreateDepthStencil(UserDesc: PSwapChainDesc): Boolean;
  procedure DestroyDepthStencil();
 public
  property Initialized: Boolean read FInitialized;

  property DXGISwapChain: IDXGISwapChain read FDXGISwapChain;
  property SwapChainDesc: DXGI_SWAP_CHAIN_DESC read FSwapChainDesc;

  property RenderTargetView: ID3D10RenderTargetView read FRenderTargetView;
  property DepthStencilTex : ID3D10Texture2D read FDepthStencilTex;
  property DepthStencilView: ID3D10DepthStencilView read FDepthStencilView;

  property IdleState: Boolean read FIdleState write FIdleState;

  function Initialize(UserDesc: PSwapChainDesc): Boolean;
  procedure Finalize();

  function Resize(UserDesc: PSwapChainDesc): Boolean;

  function SetRenderTargets(): Boolean;
  function SetDefaultViewport(): Boolean;

  procedure ResetRenderTargets();

  function Present(): HResult;
  function PresentTest(): HResult;

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 TDX10SwapChains = class
 private
  Data: array of TDX10SwapChain;

  function GetCount(): Integer;
  function GetItem(Index: Integer): TDX10SwapChain;
 public
  property Count: Integer read GetCount;
  property Items[Index: Integer]: TDX10SwapChain read GetItem; default;

  function Add(UserDesc: PSwapChainDesc): Integer;
  procedure RemoveAll();

  function CreateAll(UserChains: TAsphyreSwapChains): Boolean;

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 Windows, SysUtils, AsphyreFPUStates, DX10Types, DX10Formats;

//---------------------------------------------------------------------------
constructor TDX10SwapChain.Create();
begin
 inherited;

 FDXGISwapChain:= nil;

 FRenderTargetView:= nil;
 FDepthStencilTex := nil;
 FDepthStencilView:= nil;

 FillChar(FSwapChainDesc, SizeOf(DXGI_SWAP_CHAIN_DESC), 0);

 FInitialized:= False;
 VSyncEnabled:= False;

 FIdleState:= False;
end;

//---------------------------------------------------------------------------
destructor TDX10SwapChain.Destroy();
begin
 if (FInitialized) then Finalize();

 inherited;
end;

//---------------------------------------------------------------------------
function TDX10SwapChain.FindSwapChainFormat(
 Format: TAsphyrePixelFormat): DXGI_FORMAT;
var
 NewFormat: TAsphyrePixelFormat;
begin
 if (Format = apf_Unknown) then Format:= apf_A8B8G8R8;
 NewFormat:= DX10FindDisplayFormat(Format);

 Result:= DXGI_FORMAT_UNKNOWN;
 if (NewFormat <> apf_Unknown) then Result:= AsphyreToDX10Format(NewFormat);

 // If no format was found for the swap chain, try some common format.
 if (Result = DXGI_FORMAT_UNKNOWN) then Result:= DXGI_FORMAT_R8G8B8A8_UNORM;
end;

//---------------------------------------------------------------------------
function TDX10SwapChain.CreateSwapChain(UserDesc: PSwapChainDesc): Boolean;
var
 SwapDesc: DXGI_SWAP_CHAIN_DESC;
 SampleCount, QualityLevel: Integer;
 NewFormat: TAsphyrePixelFormat;
begin
 // (1) Verify initial conditions.
 Result:= (Assigned(D3D10Device))and(Assigned(DXGIFactory))and
  (Assigned(UserDesc))and(UserDesc.Width > 0)and(UserDesc.Height > 0)and
  (UserDesc.WindowHandle <> 0);
 if (not Result) then Exit;

 // (2) Prepare DXGI swap chain declaration.
 FillChar(SwapDesc, SizeOf(DXGI_SWAP_CHAIN_DESC), 0);

 SwapDesc.BufferCount:= 1;

 SwapDesc.BufferDesc.Width := UserDesc.Width;
 SwapDesc.BufferDesc.Height:= UserDesc.Height;
 SwapDesc.BufferDesc.Format:= FindSwapChainFormat(UserDesc.Format);

 SwapDesc.BufferUsage := DXGI_USAGE_RENDER_TARGET_OUTPUT;
 SwapDesc.OutputWindow:= UserDesc.WindowHandle;

 DX10FindBestMultisampleType(SwapDesc.BufferDesc.Format, UserDesc.Multisamples,
  SampleCount, QualityLevel);

 SwapDesc.SampleDesc.Count  := SampleCount;
 SwapDesc.SampleDesc.Quality:= QualityLevel;

 SwapDesc.Windowed:= True;

 // (3) Create DXGI swap chain.
 PushClearFPUState();
 try
  Result:= Succeeded(DXGIFactory.CreateSwapChain(D3D10Device, SwapDesc,
   FDXGISwapChain));
 finally
  PopFPUState();
 end;
 if (not Result) then Exit;

 // (4) Retrieve the updated description of swap chain.
 FillChar(FSwapChainDesc, SizeOf(DXGI_SWAP_CHAIN_DESC), 0);

 PushClearFPUState();
 try
  Result:= Succeeded(FDXGISwapChain.GetDesc(FSwapChainDesc));
 finally
  PopFPUState();
 end;

 // (5) Update user swap chain parameters.
 if (Result) then
  begin
   VSyncEnabled:= UserDesc.VSync;

   UserDesc.Multisamples:= FSwapChainDesc.SampleDesc.Count;

   NewFormat:= DX10FormatToAsphyre(FSwapChainDesc.BufferDesc.Format);
   if (NewFormat <> apf_Unknown) then UserDesc.Format:= NewFormat;
  end;
end;

//---------------------------------------------------------------------------
procedure TDX10SwapChain.DestroySwapChain();
begin
 if (Assigned(FDXGISwapChain)) then FDXGISwapChain:= nil;

 FillChar(FSwapChainDesc, SizeOf(DXGI_SWAP_CHAIN_DESC), 0);
 VSyncEnabled:= False;
end;

//---------------------------------------------------------------------------
function TDX10SwapChain.CreateRenderTargetView(): Boolean;
var
 BackBuffer: ID3D10Texture2D;
begin
 // (1) Verify initial conditions.
 Result:= (Assigned(D3D10Device))and(Assigned(FDXGISwapChain));
 if (not Result) then Exit;

 // (2) Retrieve swap chain's back buffer.
 PushClearFPUState();
 try
  Result:= Succeeded(FDXGISwapChain.GetBuffer(0, ID3D10Texture2D, BackBuffer));
 finally
  PopFPUState();
 end;

 if (not Result) then Exit;

 // (3) Create render target view.
 PushClearFPUState();
 try
  Result:= Succeeded(D3D10Device.CreateRenderTargetView(BackBuffer, nil,
   @FRenderTargetView));
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
procedure TDX10SwapChain.DestroyRenderTargetView();
begin
 if (Assigned(FRenderTargetView)) then FRenderTargetView:= nil;
end;

//---------------------------------------------------------------------------
function TDX10SwapChain.CreateDepthStencil(UserDesc: PSwapChainDesc): Boolean;
var
 Format: DXGI_FORMAT;
 Desc  : D3D10_TEXTURE2D_DESC;
begin
 // (1) Verify initial conditions.
 Result:= False;
 if (not Assigned(D3D10Device))or(not Assigned(FDXGISwapChain)) then Exit;

 // (2) If no depth-stencil buffer is required, return success.
 if (UserDesc.DepthStencil = dstNone) then
  begin
   Result:= True;
   Exit;
  end;

 // (3) Find a compatible depth-stencil format.
 Format:= DX10FindDepthStencilFormat(Integer(UserDesc.DepthStencil));
 if (Format = DXGI_FORMAT_UNKNOWN) then Exit;

 // (4) Create a new depth-stencil buffer.
 FillChar(Desc, SizeOf(D3D10_TEXTURE2D_DESC), 0);

 Desc.Format:= Format;
 Desc.Width := FSwapChainDesc.BufferDesc.Width;
 Desc.Height:= FSwapChainDesc.BufferDesc.Height;

 Desc.MipLevels:= 1;
 Desc.ArraySize:= 1;

 Desc.SampleDesc.Count  := FSwapChainDesc.SampleDesc.Count;
 Desc.SampleDesc.Quality:= FSwapChainDesc.SampleDesc.Quality;

 Desc.Usage:= D3D10_USAGE_DEFAULT;
 Desc.BindFlags:= Ord(D3D10_BIND_DEPTH_STENCIL);

 PushClearFPUState();
 try
  Result:= Succeeded(D3D10Device.CreateTexture2D(Desc, nil, FDepthStencilTex));
 finally
  PopFPUState();
 end;
 if (not Result) then Exit;

 // (5) Create a depth-stencil view.
 Result:= Succeeded(D3D10Device.CreateDepthStencilView(FDepthStencilTex, nil,
  @FDepthStencilView));
 if (not Result) then
  begin
   FDepthStencilTex:= nil;
   Exit;
  end;
end;

//---------------------------------------------------------------------------
procedure TDX10SwapChain.DestroyDepthStencil();
begin
 if (Assigned(FDepthStencilView)) then FDepthStencilView:= nil;
 if (Assigned(FDepthStencilTex)) then FDepthStencilTex:= nil;
end;

//---------------------------------------------------------------------------
function TDX10SwapChain.Initialize(UserDesc: PSwapChainDesc): Boolean;
begin
 Result:= (not FInitialized)and(Assigned(UserDesc));
 if (not Result) then Exit;

 Result:= CreateSwapChain(UserDesc);
 if (not Result) then Exit;

 Result:= CreateRenderTargetView();
 if (not Result) then
  begin
   DestroySwapChain();
   Exit;
  end;

 Result:= CreateDepthStencil(UserDesc);
 if (not Result) then
  begin
   DestroyRenderTargetView();
   DestroySwapChain();
   Exit;
  end;

 FInitialized:= True;
 FIdleState:= False;
end;

//---------------------------------------------------------------------------
procedure TDX10SwapChain.Finalize();
begin
 if (not FInitialized) then Exit;

 DestroyDepthStencil();
 DestroyRenderTargetView();
 DestroySwapChain();

 FInitialized:= False;
end;

//---------------------------------------------------------------------------
function TDX10SwapChain.Resize(UserDesc: PSwapChainDesc): Boolean;
begin
 // (1) Verify initial conditions.
 Result:= (FInitialized)and(Assigned(UserDesc))and(Assigned(FDXGISwapChain));
 if (not Result) then Exit;

 // (2) Destroy the depth-stencil and render target views because they will be
 // of different size.
 DestroyDepthStencil();
 DestroyRenderTargetView();

 // (3) Resize the swap chain itself.
 PushClearFPUState();
 try
  Result:= Succeeded(FDXGISwapChain.ResizeBuffers(1, UserDesc.Width,
   UserDesc.Height, FSwapChainDesc.BufferDesc.Format, 0));
 finally
  PopFPUState();
 end;

 if (not Result) then
  begin
   DestroySwapChain();
   Exit;
  end;

 // (4) Retrieve the updated description of swap chain.
 FillChar(FSwapChainDesc, SizeOf(DXGI_SWAP_CHAIN_DESC), 0);

 PushClearFPUState();
 try
  Result:= Succeeded(FDXGISwapChain.GetDesc(FSwapChainDesc));
 finally
  PopFPUState();
 end;

 if (not Result) then
  begin
   DestroySwapChain();
   Exit;
  end;

 // (5) Create render target view with the new size.
 Result:= CreateRenderTargetView();
 if (not Result) then
  begin
   DestroySwapChain();
   Exit;
  end;

 // (6) Create depth stencil with the new size.
 Result:= CreateDepthStencil(UserDesc);
 if (not Result) then
  begin
   DestroyRenderTargetView();
   DestroySwapChain();
   Exit;
  end;
end;

//---------------------------------------------------------------------------
function TDX10SwapChain.SetRenderTargets(): Boolean;
begin
 Result:= (Assigned(D3D10Device))and(Assigned(FRenderTargetView));
 if (not Result) then Exit;

 PushClearFPUState();
 try
  D3D10Device.OMSetRenderTargets(1, @FRenderTargetView, FDepthStencilView);
 finally
  PopFPUState();
 end;

 ActiveRenderTargetView:= FRenderTargetView;
 ActiveDepthStencilView:= FDepthStencilView;
end;

//---------------------------------------------------------------------------
procedure TDX10SwapChain.ResetRenderTargets();
begin
 ActiveDepthStencilView:= nil;
 ActiveRenderTargetView:= nil;
end;

//---------------------------------------------------------------------------
function TDX10SwapChain.SetDefaultViewport(): Boolean;
begin
 Result:= (Assigned(D3D10Device))and(FSwapChainDesc.BufferDesc.Width > 0)and
  (FSwapChainDesc.BufferDesc.Height > 0);
 if (not Result) then Exit;

 FillChar(D3D10Viewport, SizeOf(D3D10_VIEWPORT), 0);

 D3D10Viewport.Width := FSwapChainDesc.BufferDesc.Width;
 D3D10Viewport.Height:= FSwapChainDesc.BufferDesc.Height;
 D3D10Viewport.MinDepth:= 0.0;
 D3D10Viewport.MaxDepth:= 1.0;

 PushClearFPUState();
 try
  D3D10Device.RSSetViewports(1, @D3D10Viewport);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX10SwapChain.Present(): HResult;
var
 Interval: Cardinal;
begin
 Result:= DXGI_ERROR_INVALID_CALL;
 if (not Assigned(FDXGISwapChain)) then Exit;

 Interval:= 0;
 if (VSyncEnabled) then Interval:= 1;

 PushClearFPUState();
 try
  Result:= DXGISwapChain.Present(Interval, 0);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
function TDX10SwapChain.PresentTest(): HResult;
begin
 Result:= DXGI_ERROR_INVALID_CALL;
 if (not Assigned(FDXGISwapChain)) then Exit;

 PushClearFPUState();
 try
  Result:= DXGISwapChain.Present(0, DXGI_PRESENT_TEST);
 finally
  PopFPUState();
 end;
end;

//---------------------------------------------------------------------------
constructor TDX10SwapChains.Create();
begin
 inherited;

end;

//---------------------------------------------------------------------------
destructor TDX10SwapChains.Destroy();
begin
 RemoveAll();

 inherited;
end;

//---------------------------------------------------------------------------
function TDX10SwapChains.GetCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TDX10SwapChains.GetItem(Index: Integer): TDX10SwapChain;
begin
 if (Index >= 0)and(Index < Length(Data)) then
  Result:= Data[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TDX10SwapChains.RemoveAll();
var
 i: Integer;
begin
 for i:= Length(Data) - 1 downto 0 do
  if (Assigned(Data[i])) then FreeAndNil(Data[i]);

 SetLength(Data, 0);
end;

//---------------------------------------------------------------------------
function TDX10SwapChains.Add(UserDesc: PSwapChainDesc): Integer;
var
 NewItem: TDX10SwapChain;
begin
 NewItem:= TDX10SwapChain.Create();

 if (not NewItem.Initialize(UserDesc)) then
  begin
   FreeAndNil(NewItem);
   Result:= -1;
   Exit;
  end;

 Result:= Length(Data);
 SetLength(Data, Result + 1);

 Data[Result]:= NewItem;
end;

//---------------------------------------------------------------------------
function TDX10SwapChains.CreateAll(UserChains: TAsphyreSwapChains): Boolean;
var
 i, Index: Integer;
 UserDesc: PSwapChainDesc;
begin
 Result:= Assigned(UserChains);
 if (not Result) then Exit;

 if (Length(Data) > 0) then RemoveAll();
 Result:= False;

 for i:= 0 to UserChains.Count - 1 do
  begin
   UserDesc:= UserChains[i];
   if (not Assigned(UserDesc)) then
    begin
     Result:= False;
     Break;
    end;

   Index:= Add(UserDesc);

   Result:= Index <> -1;
   if (not Result) then Break;
  end;

 if (not Result)and(Length(Data) > 0) then RemoveAll();
end;

//---------------------------------------------------------------------------
end.
