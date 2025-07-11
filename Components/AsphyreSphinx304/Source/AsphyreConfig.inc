//---------------------------------------------------------------------------
// AsphyreConfig.pas                                    Modified: 14-Sep-2012
// Compiler configuration for Asphyre framework.                 Version 1.02
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
// The Original Code is AsphyreConfig.inc.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------

{$define AllowPreciseFloat}

//---------------------------------------------------------------------------
// The following parameters make the framework compliant with FreePascal.
//---------------------------------------------------------------------------
{$ifdef fpc}
 {$ifdef cpu32}{$define cpux86}{$endif}
 {$ifdef cpu64}{$define cpux64}{$endif}
{$endif}

//---------------------------------------------------------------------------
// Provide shorter keyword for Windows platform.
//---------------------------------------------------------------------------
{$ifdef MsWindows}
{$define Windows}
{$endif}

//---------------------------------------------------------------------------
// Determine Delphi version.
//---------------------------------------------------------------------------
{$ifndef fpc}

{$define Delphi}

{$ifdef ver180} // Delphi 2006
 {$define DelphiLegacy}
{$endif}

{$ifdef ver185} // Delphi 2007
 {$define DelphiLegacy}
{$endif}

{$ifdef ver200} // Delphi 2009
 {$define Delphi2009Up}
{$endif}

{$ifdef ver210} // Delphi 2010
 {$define Delphi2009Up}
 {$define Delphi2010Up}
{$endif}

{$ifdef ver220} // Delphi XE
 {$define Delphi2009Up}
 {$define Delphi2010Up}
 {$define DelphiXEUp}
{$endif}

{$ifdef ver230} // Delphi XE 2
 {$define Delphi2009Up}
 {$define Delphi2010Up}
 {$define DelphiXEUp}
 {$define DelphiXE2Up}
{$endif}

{$ifdef ver240} // Delphi XE 3
 {$define Delphi2009Up}
 {$define Delphi2010Up}
 {$define DelphiXEUp}
 {$define DelphiXE2Up}
 {$define DelphiXE3Up}
{$endif}

{$endif}

//---------------------------------------------------------------------------
{$ifdef DelphiLegacy}
 // Earlier Delphi versions do not have CPUX86 symbol defined.
 {$define cpux86}
{$endif}

//---------------------------------------------------------------------------
// On Mac OS X, FireMonkey is always used. This flag needs to be configured
// manually on Windows.
//---------------------------------------------------------------------------
{$if defined(Delphi) and defined(posix)}
 {$define FireMonkey}
{$ifend}

//---------------------------------------------------------------------------
// FreePascal does not support assembly instructions on 64-bit platform.
//---------------------------------------------------------------------------
{$ifdef fpc}
 {$ifdef cpux64}
  {$define PurePascal}
 {$endif}
{$endif}

//---------------------------------------------------------------------------
// On 32-bit Intel platform, assembly instructions are explicitly allowed.
//---------------------------------------------------------------------------
{$ifndef PurePascal}
 {$ifdef cpux86}
  {$define AsmIntelX86}
 {$endif}
{$endif}

//---------------------------------------------------------------------------
// Disable excess precision for 32-bit floating-point operations in latest
// versions of Delphi XE 2 and up, to speed up intermediary calculations.
//---------------------------------------------------------------------------
{$ifdef DelphiXE2Up}
 {$ExcessPrecision off}
{$endif}

//---------------------------------------------------------------------------
// Enable Delphi compatibility mode in FreePascal
//---------------------------------------------------------------------------
{$ifdef fpc}
 {$mode delphi}
{$endif}
