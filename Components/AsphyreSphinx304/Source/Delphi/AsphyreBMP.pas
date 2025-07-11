unit AsphyreBMP;
//---------------------------------------------------------------------------
// AsphyreBMP.pas                                       Modified: 14-Sep-2012
// Windows Bitmap image format connection for Asphyre.           Version 1.01
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
// The Original Code is AsphyreBMP.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2007 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 SysUtils, Classes, Graphics, AsphyreDef, SystemSurfaces, AsphyreBitmaps;

//---------------------------------------------------------------------------
type
 TAsphyreBMPBitmap = class(TAsphyreCustomBitmap)
 public
  function LoadFromStream(const Extension: StdString; Stream: TStream;
   Dest: TSystemSurface): Boolean; override;

  function SaveToStream(const Extension: StdString; Stream: TStream;
   Source: TSystemSurface): Boolean; override;

  constructor Create();
 end;

//---------------------------------------------------------------------------
var
 BMPBitmap: TAsphyreBMPBitmap = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TAsphyreBMPBitmap.Create();
begin
 inherited;

 FDesc:= 'Windows Bitmap';
end;

//---------------------------------------------------------------------------
function TAsphyreBMPBitmap.LoadFromStream(const Extension: StdString;
 Stream: TStream; Dest: TSystemSurface): Boolean;
var
 Bitmap: TBitmap;
 UnmaskAlpha: Boolean;
 i: Integer;
begin
 Result:= True;
 Bitmap:= TBitmap.Create();

 try
  Bitmap.LoadFromStream(Stream);
 except
  Result:= False;
 end;

 if (Result) then
  begin
   UnmaskAlpha:= Bitmap.PixelFormat <> pf32bit;
   Bitmap.PixelFormat:= pf32bit;

   Dest.SetSize(Bitmap.Width, Bitmap.Height);

   for i:= 0 to Bitmap.Height - 1 do
    Move(Bitmap.ScanLine[i]^, Dest.Scanline[i]^, Bitmap.Width * 4);

   if (UnmaskAlpha) then Dest.ResetAlpha();
  end;

 FreeAndNil(Bitmap);
end;

//---------------------------------------------------------------------------
function TAsphyreBMPBitmap.SaveToStream(const Extension: StdString;
 Stream: TStream; Source: TSystemSurface): Boolean;
var
 Bitmap: TBitmap;
 i: Integer;
begin
 Result:= True;

 Bitmap:= TBitmap.Create();
 Bitmap.PixelFormat:= pf32bit;
 Bitmap.SetSize(Source.Width, Source.Height);

 for i:= 0 to Source.Height - 1 do
  Move(Source.ScanLine[i]^, Bitmap.Scanline[i]^, Source.Width * 4);

 try
  Bitmap.SaveToStream(Stream);
 except
  Result:= False;
 end;

 FreeAndNil(Bitmap);
end;

//---------------------------------------------------------------------------
initialization
 BMPBitmap:= TAsphyreBMPBitmap.Create();
 BitmapManager.RegisterExt('.bmp', BMPBitmap);

//---------------------------------------------------------------------------
finalization
 BitmapManager.UnregisterExt('.bmp');
 FreeAndNil(BMPBitmap);

//---------------------------------------------------------------------------
end.
