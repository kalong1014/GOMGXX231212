unit GuiBevels;
//---------------------------------------------------------------------------
// GuiBevels.pas                                        Modified: 14-Sep-2012
// Bevel controls for Asphyre GUI framework.                      Version 1.0
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
// The Original Code is GuiBevels.pas.
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
 Types, AsphyreTypes, GuiTypes, GuiControls;

//---------------------------------------------------------------------------
type
 TGuiBevel = class(TGuiControl)
 private
  FInsideFill  : TColor4;
  FBorderColor : Cardinal;
  FInside3DFeel: Boolean;
  FDrawAlpha   : Single;
 protected
  procedure DoPaint(); override;
  procedure SelfDescribe(); override;
 public
  property InsideFill : TColor4 read FInsideFill write FInsideFill;
  property BorderColor: Cardinal read FBorderColor write FBorderColor;

  property Inside3DFeel: Boolean read FInside3DFeel write FInside3DFeel;

  property DrawAlpha: Single read FDrawAlpha write FDrawAlpha;

  constructor Create(AOwner: TGuiControl); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreUtils, GuiGlobals;

//---------------------------------------------------------------------------
constructor TGuiBevel.Create(AOwner: TGuiControl);
begin
 inherited;

 FInsideFill  := cColor4($FF7D8FD2, $FF667BCA, $FF3F58B6, $FF536BC4);
 FBorderColor := $FF5057AD;
 FInside3DFeel:= False;
 FDrawAlpha   := 1.0;

 Width := 100;
 Height:= 100;
end;

//---------------------------------------------------------------------------
procedure TGuiBevel.DoPaint();
var
 PaintRect: TRect;
begin
 PaintRect:= VirtualRect;

 GuiCanvas.FillQuad(pRect4(PaintRect), cColor4Alpha1f(FInsideFill,
  GuiGlobalAlpha * FDrawAlpha));

 if (FInside3DFeel) then
  GuiCanvas.FrameRect(RectExtrude(PaintRect),
   cColor4Alpha1f(ExchangeColors(FInsideFill), GuiGlobalAlpha * FDrawAlpha));

 GuiCanvas.FrameRect(pRect4(PaintRect), cColor4(cColorAlpha1f(FBorderColor,
  GuiGlobalAlpha * FDrawAlpha)));
end;

//---------------------------------------------------------------------------
procedure TGuiBevel.SelfDescribe();
begin
 inherited;

 FNameOfClass:= 'TGuiBevel';

 AddProperty('InsideFill', gptColor4, gpfColor4, @FInsideFill, 
  SizeOf(TColor4));

 AddProperty('BorderColor', gptColor, gpfCardinal, @FBorderColor, 
  SizeOf(Cardinal));

 AddProperty('Inside3DFeel', gptBoolean, gpfBoolean, @FInside3DFeel, 
  SizeOf(Boolean));

 AddProperty('DrawAlpha', gptFloat, gpfSingle, @FDrawAlpha, 
  SizeOf(Single));
end;

//---------------------------------------------------------------------------
end.
