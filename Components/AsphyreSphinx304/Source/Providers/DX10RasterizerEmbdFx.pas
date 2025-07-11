unit DX10RasterizerEmbdFx;
//---------------------------------------------------------------------------
// DX10RasterizerEmbdFx.pas                             Modified: 14-Sep-2012
// Direct3D 10 Rasterizer Effect embedded in source code.         Version 1.0
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
// The Original Code is DX10RasterizerEmbdFx.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
procedure CreateDX10RasterizerEffect(out MemAddr: Pointer;
 out ByteSize: Integer);

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreData;

//---------------------------------------------------------------------------
const
 EffectOrigSize = 3605;

//---------------------------------------------------------------------------
 EffectZipBytes: packed array[0..910] of Byte = (
  $78, $DA, $ED, $57, $CD, $4F, $13, $51, $10, $7F, $BB, $E5, $A3, $4D, $2A,
  $6D, $82, $24, $46, $09, $6E, $82, $89, $1F, $D1, $42, $2B, $10, $B8, $F0,
  $D1, $2E, $05, $92, $D2, $D6, $6E, $31, $8D, $D1, $60, $81, $15, $8A, $25,
  $2D, $B5, $04, $E5, $60, $1A, $15, $E3, $C1, $84, $93, $37, $BF, $A2, $91,
  $48, $9A, $98, $10, $0F, $7E, $11, $0F, $9C, $3C, $10, $FF, $08, $83, $07,
  $39, $78, $C0, $C4, $8B, $86, $3A, $B3, $FB, $1E, $7D, $5D, $A8, $20, $18,
  $4E, $BC, $64, $FA, $E6, $CD, $9B, $99, $9D, $B7, $6F, $7E, $33, $5B, $39,
  $E2, $F6, $BC, $99, $16, $7F, $0D, $2C, $57, $0B, $47, $96, $2A, $5F, $FC,
  $98, $9B, $9D, $16, $08, $21, $55, $15, $84, $E0, $7C, $0C, $C8, $1B, $71,
  $D6, $7F, $3B, $00, $6B, $7B, $6E, $8D, $D0, $21, $92, $C2, $81, $EB, $79,
  $AB, $CE, $0B, $86, $3D, $7E, $5D, $42, $09, $47, $58, $BD, $9E, $9E, $48,
  $A9, $2E, $59, $93, $18, $3D, $E2, $40, $87, $4A, $62, $22, $35, $A8, $82,
  $2E, $51, $A2, $63, $C9, $B8, $9A, $52, $D2, $D1, $B4, $4A, $1A, $8A, $98,
  $54, $01, $F5, $C6, $92, $63, $D1, $24, $55, $D7, $1E, $2F, $D2, $1D, $C6,
  $9B, $0C, $BC, $12, $43, $5D, $4F, $22, $9E, $48, $79, $63, $F1, $38, $09,
  $D6, $13, $19, $E4, $32, $BC, $9D, $D7, $8F, $9F, $4F, $BD, $6F, $AE, $1D,
  $1D, $BF, $13, $5C, $99, $6A, $B3, $BE, $43, $33, $DC, $2B, $85, $19, $83,
  $B8, $0F, $74, $10, $84, $6F, $81, $3E, $81, $BF, $90, $DC, $E9, $0D, $1A,
  $82, $AA, $D6, $8E, $BE, $96, $C3, $67, $56, $6B, $01, $0E, $A6, $12, $D7,
  $12, $57, $D2, $D2, $89, $D0, $49, $A9, $DB, $A7, $F8, $24, $65, $24, $3A,
  $A4, $A6, $24, $4F, $62, $2C, $19, $83, $A8, $A5, $16, $87, $AB, $C5, $D1,
  $D2, $E8, $72, $9C, $75, $3A, $9D, $24, $9B, $CD, $F6, $28, $5D, $FE, $0C,
  $7D, $7B, $66, $A0, $11, $CE, $BF, $89, $CE, $36, $1B, $21, $E3, $06, $B9,
  $C0, $C9, $05, $4E, $2E, $52, $F9, $A4, $41, $5F, $23, $F8, $09, $06, $94,
  $9E, $70, $4F, $C0, $4F, $3C, $01, $5F, $20, $44, $C2, $9D, $11, $4F, $20,
  $10, $92, $49, $00, $E2, $78, $48, $F4, $F3, $63, $1C, $99, $CD, $E2, $A0,
  $72, $C1, $18, $07, $D0, $5D, $83, $BE, $76, $05, $56, $5D, $6E, $8C, $CF,
  $0A, $CC, $0C, $97, $45, $2C, $3E, $F4, $63, $08, $4B, $39, $DF, $BF, $1E,
  $71, $56, $E9, $96, $43, $66, $30, $68, $07, $2B, $37, $E8, $F6, $83, $D9,
  $AA, $DD, $AE, $F9, $61, $BC, $C0, $F1, $22, $E5, $5D, $C0, $A3, $7F, $15,
  $E5, $92, $AE, $CF, $78, $81, $F2, $2E, $49, $D7, $47, $7E, $91, $F2, $C3,
  $70, $2D, $A8, $C3, $CE, $D9, $04, $AF, $87, $D9, $7B, $6B, $EC, $05, $32,
  $81, $CA, $D0, $AE, $99, $90, $72, $E6, $EF, $E7, $51, $AA, $4F, $63, $40,
  $7D, $E6, $7F, $B6, $46, $DF, $43, $99, $8B, $3E, $C7, $6B, $5F, $97, $99,
  $17, $A9, $4C, $6C, $37, $C2, $21, $D3, $D6, $0A, $21, $29, $E1, $8E, $70,
  $1A, $56, $E5, $DC, $8E, $C5, $80, $4C, $81, $FC, $DB, $28, $DD, $A6, $DE,
  $33, $CE, $3F, $03, $6C, $83, $A8, $63, $EB, $95, $FF, $A9, $5C, $15, $F1,
  $27, $CF, $7D, $F9, $3C, $5F, $BB, $24, $A4, $05, $BA, $C7, $63, $AB, $1E,
  $84, $43, $14, $5F, $C5, $B1, $95, $DB, $35, $B6, $B6, $CC, $69, $5B, $91,
  $9C, $B6, $15, $C9, $69, $52, $24, $A7, $C9, $CE, $72, $1A, $71, $77, $9A,
  $DA, $60, $8C, $52, $11, $DC, $81, $51, $38, $9A, $1A, $56, $D3, $70, $30,
  $C4, $81, $8F, $20, $0E, $08, $A9, $04, $1A, $B0, $E7, $71, $C0, $78, $C1,
  $90, $EF, $98, $26, $7C, $EE, $F2, $39, $CC, $E7, $92, $B8, $49, $9D, $D9,
  $69, $2E, $6D, $77, $AC, $D1, $83, $42, $81, $A7, $CD, $23, $D4, $E5, $EE,
  $D8, $2F, $D5, $FB, $A5, $7A, $BF, $54, $FF, $87, $52, $DD, $5B, $B6, $B1,
  $54, $FF, $A6, $A5, $FA, $BB, $BD, $2C, $E3, $3E, $7E, $E3, $63, $DD, $E1,
  $EE, $AF, $8D, $BE, $0F, $7D, $02, $DD, $63, $D8, $5A, $06, $BA, $07, $C2,
  $05, $A0, $0C, $C5, $D6, $4B, $C3, $07, $22, $5F, $AA, $F1, $8C, $17, $B9,
  $3C, $DC, $EC, $83, $71, $94, $DA, $95, $52, $2C, $E5, $60, $B0, $7D, $EB,
  $86, $EF, $BC, $FC, $87, $E2, $9E, $B7, $80, $62, $58, $31, $15, $C1, $8A,
  $79, $6F, $5B, $C0, $02, $6D, $01, $75, $40, $17, $50, $F5, $B2, $9E, $8F,
  $91, $43, $F0, $5A, $93, $3A, $DF, $D7, $B7, $B1, $3D, $B8, $28, $DE, $90,
  $BF, $65, $CF, $63, $89, $E1, $05, $EA, $9A, $88, $B1, $54, $20, $36, $48,
  $1E, $13, $0C, $23, $38, $77, $42, $FA, $AE, $B2, $3D, $36, $DF, $A4, $AD,
  $86, $C6, $D1, $CC, $B7, $9C, $8A, $C2, $D6, $C3, $63, $A2, $84, $7B, $97,
  $C6, $BF, $0C, $7F, $C3, $C4, $6E, $DA, $D1, $9C, $45, $9F, $4F, $E9, $E7,
  $D4, $06, $CB, $C3, $4B, $40, $1D, $9C, $0C, $EF, $E0, $0C, $F7, $CC, $AB,
  $40, $0E, $6E, $3D, $49, $EF, $80, $AD, $6F, $53, $7E, $86, $8B, $F1, $09,
  $77, $97, $65, $AC, $1F, $03, $AD, $98, $F4, $3B, $67, $B6, $AB, $A6, $7C,
  $8D, $C0, $B9, $09, $94, $5B, $CB, $B6, $F6, $F3, $C0, $52, $E8, $E7, $91,
  $A5, $D0, $CF, $1C, $00, $EB, $0F, $34, $AA, $74, $4B);

//---------------------------------------------------------------------------
procedure CreateDX10RasterizerEffect(out MemAddr: Pointer;
 out ByteSize: Integer);
begin
 GetMem(MemAddr, EffectOrigSize);

 ByteSize:= DecompressData(@EffectZipBytes[0], MemAddr,
  SizeOf(EffectZipBytes), EffectOrigSize);
end;

//---------------------------------------------------------------------------
end.
