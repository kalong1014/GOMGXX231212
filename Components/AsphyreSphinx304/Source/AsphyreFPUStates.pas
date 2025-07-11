unit AsphyreFPUStates;
//---------------------------------------------------------------------------
// AsphyreFPUStates.pas                                 Modified: 14-Sep-2012
// FPU state manager for Asphyre and DX10+ components.           Version 1.02
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
// The Original Code is AsphyreFPUStates.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
// Note: this file has been preformatted to be used with PasDoc.
//---------------------------------------------------------------------------
{< Utility functions for preserving, clearing and restoring FPU state when
   working with Direct3D classes to prevent FPU exceptions and overflows. }
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
uses
 AsphyreDef;

//---------------------------------------------------------------------------
{ Adds the current FPU state to the stack. If the stack is full, this
  function does nothing. }
procedure PushFPUState();

//---------------------------------------------------------------------------
{ Adds the current FPU state to the stack and clears FPU state so that all
  FPU exceptions are disabled. If the stack is full, this function still
  disables FPU exceptions without saving original FPU state. }
procedure PushClearFPUState();

//---------------------------------------------------------------------------
{ Restores the FPU state stored that was previously added to the stack. If
  the stack is empty, this function does nothing. }
procedure PopFPUState();

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 Math;

//---------------------------------------------------------------------------
const
 FPUStateStackLength = 16;

 //---------------------------------------------------------------------------
{$ifndef DelphiXE2Up}
type
 TArithmeticExceptionMask = TFPUExceptionMask;

 //---------------------------------------------------------------------------
const
 exAllArithmeticExceptions = [exInvalidOp, exDenormalized, exZeroDivide,
  exOverflow, exUnderflow, exPrecision];
{$endif}

//---------------------------------------------------------------------------
var
 FPUStateStack: array[0..FPUStateStackLength - 1] of TArithmeticExceptionMask;

//---------------------------------------------------------------------------
 FPUStackAt: Integer = 0;

//---------------------------------------------------------------------------
procedure PushFPUState();
begin
 if (FPUStackAt >= FPUStateStackLength) then Exit;

 FPUStateStack[FPUStackAt]:= GetExceptionMask();
 Inc(FPUStackAt);
end;

//---------------------------------------------------------------------------
procedure PushClearFPUState();
begin
 PushFPUState();
 SetExceptionMask(exAllArithmeticExceptions);
end;

//---------------------------------------------------------------------------
procedure PopFPUState();
begin
 if (FPUStackAt <= 0) then Exit;

 Dec(FPUStackAt);

 SetExceptionMask(FPUStateStack[FPUStackAt]);
 FPUStateStack[FPUStackAt]:= [];
end;

//---------------------------------------------------------------------------
end.
