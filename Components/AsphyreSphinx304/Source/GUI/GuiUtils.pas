unit GuiUtils;
//---------------------------------------------------------------------------
// GuiUtils.pas                                         Modified: 14-Sep-2012
// Usage helper routines for Asphyre GUI framework.              Version 1.01
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
// The Original Code is GuiUtils.pas.
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
 AsphyreDef, GuiControls;

//---------------------------------------------------------------------------
procedure SetControlText(Parent: TGuiControl; const CtrlName: StdString;
 const Text: UniString);

function GetControlText(Parent: TGuiControl;
 const CtrlName: StdString): UniString;

//---------------------------------------------------------------------------
procedure SetControlItemIndex(Parent: TGuiControl; const CtrlName: StdString;
 NewIndex: Integer);

function GetControlItemIndex(Parent: TGuiControl;
 const CtrlName: StdString): Integer;

//---------------------------------------------------------------------------
procedure SetControlVisible(Parent: TGuiControl; const CtrlName: StdString;
 Visible: Boolean);

function GetControlVisible(Parent: TGuiControl;
 const CtrlName: StdString): Boolean;

//---------------------------------------------------------------------------
procedure SetControlEnabled(Parent: TGuiControl; const CtrlName: StdString;
 Enabled: Boolean);

function GetControlEnabled(Parent: TGuiControl;
 const CtrlName: StdString): Boolean;

//---------------------------------------------------------------------------
procedure SetControlChecked(Parent: TGuiControl; const CtrlName: StdString;
 Checked: Boolean);

function GetControlChecked(Parent: TGuiControl;
 const CtrlName: StdString): Boolean;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 GuiTypes, GuiComboBoxes;

//---------------------------------------------------------------------------
procedure SetControlText(Parent: TGuiControl; const CtrlName: StdString;
 const Text: UniString);
var
 Ctrl: TGuiControl;
begin
 Ctrl:= Parent.Ctrl[CtrlName];
 if (not Assigned(Ctrl)) then Exit;

 if (Ctrl.IndexOfProperty('Caption') <> -1) then
  begin
   Ctrl.ValueString['Caption']:= Text;
   Exit;
  end;

 if (Ctrl.IndexOfProperty('Text') <> -1) then
  begin
   Ctrl.ValueString['Text']:= Text;
   Exit;
  end;

 if (Ctrl.IndexOfProperty('Items') <> -1) then
  begin
   Ctrl.ValueString['Items']:= Text;
   Exit;
  end;
end;

//---------------------------------------------------------------------------
function GetControlText(Parent: TGuiControl;
 const CtrlName: StdString): UniString;
var
 Ctrl: TGuiControl;
begin
 Result:= '';

 Ctrl:= Parent.Ctrl[CtrlName];
 if (not Assigned(Ctrl)) then Exit;

 if (Ctrl.IndexOfProperty('Caption') <> -1) then
  begin
   Result:= Ctrl.ValueString['Caption'];
   Exit;
  end;

 if (Ctrl.IndexOfProperty('Text') <> -1) then
  begin
   Result:= Ctrl.ValueString['Text'];
   Exit;
  end;

 if (Ctrl.IndexOfProperty('Items') <> -1) then
  begin
   Result:= Ctrl.ValueString['Items'];
   Exit;
  end;
end;

//---------------------------------------------------------------------------
procedure SetControlItemIndex(Parent: TGuiControl; const CtrlName: StdString;
 NewIndex: Integer);
var
 Ctrl: TGuiControl;
begin
 Ctrl:= Parent.Ctrl[CtrlName];
 if (not Assigned(Ctrl)) then Exit;

 Ctrl.ValueInteger['ItemIndex']:= NewIndex;
end;

//---------------------------------------------------------------------------
function GetControlItemIndex(Parent: TGuiControl;
 const CtrlName: StdString): Integer;
var
 Ctrl: TGuiControl;
begin
 Result:= -1;

 Ctrl:= Parent.Ctrl[CtrlName];
 if (not Assigned(Ctrl)) then Exit;

 if (Ctrl.IndexOfProperty('ItemIndex') <> -1) then
  Result:= Ctrl.ValueInteger['ItemIndex'];
end;

//---------------------------------------------------------------------------
procedure SetControlVisible(Parent: TGuiControl; const CtrlName: StdString;
 Visible: Boolean);
var
 Ctrl: TGuiControl;
begin
 Ctrl:= Parent.Ctrl[CtrlName];
 if (Assigned(Ctrl)) then Ctrl.Visible:= Visible;
end;

//---------------------------------------------------------------------------
function GetControlVisible(Parent: TGuiControl;
 const CtrlName: StdString): Boolean;
var
 Ctrl: TGuiControl;
begin
 Ctrl:= Parent.Ctrl[CtrlName];
 if (Assigned(Ctrl)) then Result:= Ctrl.Visible
  else Result:= False;
end;

//---------------------------------------------------------------------------
procedure SetControlEnabled(Parent: TGuiControl; const CtrlName: StdString;
 Enabled: Boolean);
var
 Ctrl: TGuiControl;
begin
 Ctrl:= Parent.Ctrl[CtrlName];
 if (Assigned(Ctrl)) then Ctrl.Enabled:= Enabled;
end;

//---------------------------------------------------------------------------
function GetControlEnabled(Parent: TGuiControl;
 const CtrlName: StdString): Boolean;
var
 Ctrl: TGuiControl;
begin
 Ctrl:= Parent.Ctrl[CtrlName];
 if (Assigned(Ctrl)) then Result:= Ctrl.Enabled
  else Result:= False;
end; 

//---------------------------------------------------------------------------
procedure SetControlChecked(Parent: TGuiControl; const CtrlName: StdString;
 Checked: Boolean);
var
 Ctrl: TGuiControl;
begin
 Ctrl:= Parent.Ctrl[CtrlName];

 if (Assigned(Ctrl)) then
  Ctrl.ValueBoolean['Checked']:= Checked;
end;

//---------------------------------------------------------------------------
function GetControlChecked(Parent: TGuiControl;
 const CtrlName: StdString): Boolean;
var
 Ctrl: TGuiControl;
begin
 Ctrl:= Parent.Ctrl[CtrlName];

 if (Assigned(Ctrl)) then
  Result:= Ctrl.ValueBoolean['Checked']
   else Result:= False;
end;

//---------------------------------------------------------------------------
end.
