unit GuiRegistry;
//---------------------------------------------------------------------------
// GuiRegistry.pas                                      Modified: 14-Sep-2012
// Component creator (factory pattern) for Asphyre GUI framework.        v1.0
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
// The Original Code is GuiRegistry.pas.
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
 SysUtils, AsphyreDef, GuiControls;

//---------------------------------------------------------------------------
type
 TGuiRegistry = class
 private
  function GetCount(): Integer;
  function GetCtrlName(CtrlIndex: Integer): StdString;
  function FindControl(const Name: StdString): Integer;
 public
  property Count: Integer read GetCount;
  property CtrlName[CtrlIndex: Integer]: StdString read GetCtrlName;

  function NewControl(const Name: StdString;
   Owner: TGuiControl): TGuiControl;
 end;

//---------------------------------------------------------------------------
var
 MasterRegistry: TGuiRegistry = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 GuiForms, GuiEdits, GuiLabels, GuiButtons, GuiScrollBars, GuiListBoxes,
 GuiComboBoxes, GuiRadioButtons, GuiCheckBoxes, GuiTrackBars, GuiBevels;

//---------------------------------------------------------------------------
const
 ControlCount = 11;
 ControlNames: array[0..(ControlCount - 1)] of StdString = ('TGuiForm',
  'TGuiEdit', 'TGuiLabel', 'TGuiButton', 'TGuiScrollBar', 'TGuiListBox',
  'TGuiComboBox', 'TGuiRadioButton', 'TGuiCheckBox', 'TGuiTrackBar',
  'TGuiBevel');

//---------------------------------------------------------------------------
function TGuiRegistry.NewControl(const Name: StdString;
 Owner: TGuiControl): TGuiControl;
var
 Index: Integer;
begin
 Result:= nil;

 Index:= FindControl(Name);
 case Index of
  0: Result:= TGuiForm.Create(Owner);
  1: Result:= TGuiEdit.Create(Owner);
  2: Result:= TGuiLabel.Create(Owner);
  3: Result:= TGuiButton.Create(Owner);
  4: Result:= TGuiScrollBar.Create(Owner);
  5: Result:= TGuiListBox.Create(Owner);
  6: Result:= TGuiComboBox.Create(Owner);
  7: Result:= TGuiRadioButton.Create(Owner);
  8: Result:= TGuiCheckBox.Create(Owner);
  9: Result:= TGuiTrackBar.Create(Owner);
  10: Result:= TGuiBevel.Create(Owner);
 end;
end;

//---------------------------------------------------------------------------
function TGuiRegistry.GetCount(): Integer;
begin
 Result:= ControlCount;
end;

//---------------------------------------------------------------------------
function TGuiRegistry.GetCtrlName(CtrlIndex: Integer): StdString;
begin
 if (CtrlIndex >= 0)and(CtrlIndex < ControlCount) then
  Result:= ControlNames[CtrlIndex] else Result:= '';
end;

//---------------------------------------------------------------------------
function TGuiRegistry.FindControl(const Name: StdString): Integer;
var
 i: Integer;
begin
 for i:= 0 to ControlCount - 1 do
  if (SameText(Name, ControlNames[i])) then
   begin
    Result:= i;
    Exit;
   end;

 Result:= -1;
end;

//---------------------------------------------------------------------------
initialization
 MasterRegistry:= TGuiRegistry.Create();

//---------------------------------------------------------------------------
finalization
 FreeAndNil(MasterRegistry);

//---------------------------------------------------------------------------
end.

