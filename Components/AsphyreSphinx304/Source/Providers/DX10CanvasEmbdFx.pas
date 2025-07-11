unit DX10CanvasEmbdFx;
//---------------------------------------------------------------------------
// DX10CanvasEmbdFx.pas                                 Modified: 14-Sep-2012
// Direct3D 10.x canvas effect embedded in source code.           Version 1.0
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
// The Original Code is DX10CanvasEmbdFx.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
procedure CreateDX10CanvasEffect(out MemAddr: Pointer; out ByteSize: Integer);

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreData;

//---------------------------------------------------------------------------
const
 EffectOrigSize = 11183;

//---------------------------------------------------------------------------
 EffectZipBytes: packed array[0..1331] of Byte = (
  $78, $DA, $ED, $9A, $7F, $68, $1B, $65, $18, $C7, $9F, $CB, $A5, $69, $B4,
  $B5, $BF, $88, $74, $19, $D5, $86, $69, $59, $DB, $B5, $DD, $92, $D5, $75,
  $5D, $D5, $AD, $CB, $8F, $B5, $AE, $6D, $62, $2E, $2D, $B1, $CE, $75, $71,
  $8B, $6D, $6A, $BA, $C4, $2C, $43, $45, $18, $D5, $C2, $10, $99, $1B, $E2,
  $5F, $22, $3A, $84, $C2, $56, $3B, $D8, $0F, $37, $41, $C4, $EA, $46, $D5,
  $3F, $64, $2A, $28, $45, $A4, $C2, $C4, $22, $0E, $44, $68, $9D, $BA, $C9,
  $68, $7D, $DE, $DC, $7B, $ED, $DD, $9B, $A6, $97, $5A, $29, $A6, $BD, $17,
  $5E, $EE, $BD, $E7, $7D, $DE, $EF, $FB, $DE, $DD, $37, $1F, $DE, $1C, $E7,
  $F0, $EF, $B4, $BB, $9D, $FE, $17, $3F, $FE, $6D, $62, $EA, $8F, $57, $26,
  $D7, $17, $BD, $BB, $E6, $6D, $0E, $00, $CE, $6E, $00, $20, $C7, $FB, $B1,
  $BA, $FC, $D6, $4D, $03, $E4, $BC, $60, $66, $1A, $68, $D1, $83, $B2, $64,
  $63, $15, $CA, $C5, $36, $C7, $F4, $F1, $B2, $76, $1E, $AD, $A4, $F8, $82,
  $CF, $C5, $0F, $C7, $82, $36, $47, $42, $4D, $07, $C9, $25, $97, $A8, $46,
  $0E, $C7, $F6, $07, $31, $17, $84, $40, $5F, $34, $1C, $8C, $09, $F1, $40,
  $3C, $08, $B5, $29, $86, $DC, $8D, $B5, $35, $14, $ED, $0B, $44, $69, $7A,
  $62, $39, $3A, $DA, $23, $B5, $79, $A6, $DD, $12, $3A, $18, $0C, $C4, $D8,
  $11, $A6, $05, $46, $78, $22, $A1, $83, $71, $76, $00, $2C, $30, $40, $08,
  $91, $5C, $7B, $24, $1C, $89, $B9, $42, $E1, $30, $78, $36, $C1, $69, $EC,
  $73, $E0, $03, $B8, $D1, $95, $73, $F5, $42, $B4, $F8, $C6, $99, $4A, $E3,
  $E5, $CA, $EB, $BB, $1B, $C8, $30, $D2, $97, $85, $47, $72, $9D, $C7, $B0,
  $DE, $C6, $1A, $C5, $8E, $2A, $8C, $7B, $1D, $4E, $97, $87, $B9, $EE, $92,
  $C4, $53, $99, $9E, $21, $73, $96, $24, $EE, $C1, $FE, $58, $E4, $50, $E4,
  $A9, $B8, $A5, $DC, $5B, $61, $69, $6A, $11, $5A, $2C, $42, $4F, $E0, $40,
  $30, $66, $B1, $47, $FA, $A2, $21, $5C, $B5, $A5, $BE, $C6, $56, $5F, $53,
  $FF, $80, $AD, $66, $B3, $D5, $6A, $85, $E1, $E1, $E1, $66, $61, $57, $5B,
  $0F, $5D, $AE, $91, $5C, $E3, $3C, $0F, $91, $C7, $C6, $63, $4C, $9C, $AC,
  $37, $3F, $1F, $A0, $8B, $89, $EB, $68, $BE, $C7, $2D, $34, $FB, $9A, $DD,
  $6D, $60, $77, $B7, $B8, $BD, $E0, $73, $FA, $ED, $6E, $B7, $D7, $01, $6E,
  $9C, $2F, $AC, $32, $1F, $CA, $42, $C7, $3C, $F3, $F1, $B9, $73, $F3, $71,
  $B2, $F9, $48, $3E, $33, $8D, $D0, $D1, $35, $BB, $82, $61, $A1, $C9, $E1,
  $BD, $88, $39, $3B, $70, $54, $35, $24, $34, $78, $5B, $41, $41, $42, $87,
  $B4, $A7, $B0, $CD, $C9, $E2, $44, $33, $48, $E2, $16, $31, $87, $B4, $6D,
  $16, $31, $A7, $1B, $EF, $38, $89, $EB, $E8, $1A, $B6, $E0, $23, $93, $F2,
  $5C, $F7, $16, $CC, $C6, $A4, $7C, $17, $D5, $93, $62, $3A, $1A, $03, $31,
  $66, $BC, $42, $63, $BA, $1D, $AC, $AB, $FB, $B7, $3F, $8C, $53, $08, $BE,
  $46, $5F, $1C, $44, $5F, $48, $C5, $C0, $64, $72, $B0, $B8, $A2, $4F, $33,
  $2F, $8B, $53, $DA, $9B, $14, $0B, $F5, $EF, $D0, $D9, $8F, $BE, $79, $C1,
  $63, $BB, $FD, $A3, $E1, $64, $C3, $AB, $DF, $7E, $31, $C6, $D1, $3E, $B9,
  $7F, $C9, $C0, $5A, $AC, $83, $DC, $42, $FE, $9D, $59, $B2, $7F, $55, $FD,
  $94, $9F, $C2, $4F, $F0, $EF, $FC, $44, $3C, $5C, $45, $C7, $90, $39, $2D,
  $29, $3C, $8C, $83, $7C, $81, $58, $77, $30, $8E, $0B, $25, $1E, $EC, $49,
  $78, $10, $60, $2D, $D6, $27, $0B, $44, $DF, $01, $E3, $35, $CC, $D1, $11,
  $5D, $2B, $F2, $B5, $08, $C4, $D8, $36, $9A, $C7, $25, $3C, $D2, $DF, $70,
  $17, $E8, $F9, $3B, $61, $D6, $43, $0A, $FF, $91, $22, $F7, $8D, $5E, $E6,
  $0F, $1D, $E3, $95, $C5, $FA, $46, $97, $66, $DE, $A7, $F4, $26, $20, $93,
  $29, $EF, $BD, $BB, $76, $36, $6A, $E8, $D3, $D0, $97, $31, $E8, $93, $26,
  $92, $A3, $EF, $1A, $F5, $EF, $DF, $C7, $47, $AA, $6B, $C7, $FB, $FF, $9C,
  $1E, $1D, $FB, $E1, $FD, $BD, $CE, $20, $47, $FB, $24, $FF, $4E, $60, $F5,
  $63, $F0, $18, $D6, $03, $D4, $BF, $A7, $99, $9F, $91, $1C, $7D, $E4, $1A,
  $F7, $30, $7B, $26, $F6, $FA, $7A, $E9, $B8, $2C, $7A, $0D, $33, $58, $A4,
  $FE, $DC, $A4, $ED, $CF, $DC, $FE, $69, $D9, $91, $CA, $2F, $2F, $52, $BF,
  $A6, $48, $25, $F7, $BD, $93, $A4, $EE, $13, $FD, $E5, $5F, $83, $B7, $29,
  $2A, $B6, $DB, $DB, $95, $B8, $25, $6D, $1B, $F5, $3D, $8B, $5E, $B2, $56,
  $27, $C0, $1D, $53, $14, $AF, $2E, $9A, $E7, $3A, $22, $9E, $4B, $FA, $5B,
  $11, $CF, $B3, $39, $79, $4A, $FC, $4A, $E8, $26, $E3, $B6, $C1, $FC, $E8,
  $4E, $FA, $FD, $E4, $25, $A3, $DB, $20, $F3, $1E, $CF, $E0, $77, $21, $DF,
  $73, $4B, $40, $F7, $27, $46, $F1, $28, $6E, $8E, $35, $7A, $6B, $F4, $CE,
  $44, $7A, $8F, $E4, $24, $D3, $FB, $17, $EA, $5F, $E3, $9E, $37, $3E, $BC,
  $30, $34, $5A, $71, $65, $EC, $B5, $68, $7B, $A7, $E7, $26, $47, $FB, $E6,
  $A3, $77, $78, $99, $E8, $AD, $FC, $2B, $BA, $7A, $E8, $FD, $1D, $A5, $F7,
  $96, $FF, $90, $DE, $4D, $00, $39, $6A, $F4, $E6, $A8, $67, $FF, $CF, $14,
  $9F, $AF, $3F, $5D, $8A, $1F, $A1, $AF, $5B, $12, $2F, $2C, $34, $88, $6B,
  $10, $CF, $44, $88, $0F, $14, $26, $43, $7C, $9C, $FA, $B7, $6E, $F2, $D6,
  $4F, $15, $5F, $E5, $66, $D7, $95, $9E, $1F, $7D, $C6, $60, $6E, $E3, $68,
  $9F, $E4, $DF, $6B, $E4, $55, $23, $06, $5F, $C6, $BA, $8F, $FA, $77, $70,
  $01, $88, $1F, $4A, $03, $E2, $21, $15, $88, $2B, $DE, $0E, $2E, $81, $E1,
  $DA, $F6, $7B, $F5, $6E, $BF, $ED, $26, $F6, $CD, $49, $8B, $06, $6D, $0D,
  $DA, $99, $03, $ED, $AD, $C5, $A9, $DF, $9B, $5C, $6A, $2D, $3D, $37, $60,
  $9A, $DE, $FC, $59, $F6, $C8, $D1, $CE, $D1, $56, $BD, $F6, $DE, $64, $75,
  $83, $DB, $A0, $5F, $39, $E0, $BE, $69, $4E, $DE, $71, $6B, $E8, $D6, $D0,
  $9D, $41, $E8, $FE, $BD, $24, $F5, $7E, $FB, $9D, $5B, $51, $30, $EB, $87,
  $AE, $AE, $F5, $3F, $E4, $39, $7A, $FC, $AF, $2A, $6D, $BF, $AD, $61, $7B,
  $25, $60, $FB, $BD, $D2, $A4, $FD, $B6, $C6, $6C, $8D, $D9, $19, $C3, $EC,
  $53, $EB, $52, $6F, $B7, $3B, $1E, $59, $3F, $F0, $E0, $5E, $F3, $E7, $45,
  $F7, $54, $9D, $7B, $F4, $F9, $7C, $97, $B6, $DD, $5E, $39, $DC, $5E, $CC,
  $17, $22, $E9, $F0, $9D, $78, $FF, $25, $25, $BB, $B7, $27, $98, $4F, $E7,
  $34, $E4, $A6, $FE, $C2, $C4, $20, $7B, $FE, $4B, $E5, $36, $9F, $A6, $EF,
  $BB, $CB, $C4, $63, $A5, $EC, $D3, $42, $C9, $6B, $4F, $60, $6D, $94, $C5,
  $88, $66, $B5, $6C, $CE, $A7, $B1, $D6, $C8, $CE, $9F, $C5, $BA, $51, $76,
  $3E, $40, $DB, $27, $54, $74, $DE, $62, $74, $86, $18, $9D, $4B, $B4, $7D,
  $59, $45, $E7, $4B, $46, $E7, $7B, $46, $E7, $67, $DA, $9E, $92, $7F, $C9,
  $C3, $CD, $DD, $2B, $83, $EC, $73, $CC, $F3, $BC, $E8, $4B, $69, $EC, $07,
  $BC, $18, $97, $FA, $AF, $E3, $0F, $73, $32, $4B, $5D, $E7, $8C, $51, $A9,
  $73, $D1, $A8, $D4, $19, $CC, $C1, $9C, $1C, $75, $9D, $DE, $3C, $A5, $4E,
  $2C, $4F, $A9, $D3, $5B, $88, $B1, $42, $75, $9D, $8D, $26, $A5, $4E, $9D,
  $49, $A9, $73, $5F, $31, $C0, $86, $62, $75, $9D, $09, $B3, $52, $E7, $57,
  $B3, $52, $67, $1C, $81, $37, $51, $A2, $AE, $73, $B2, $54, $A9, $73, $AA,
  $54, $A9, $F3, $3A, $72, $F9, $CD, $75, $EA, $3A, $42, $99, $52, $E7, $F1,
  $32, $A5, $CE, $EE, $72, $80, $7F, $00, $96, $A0, $A2, $7D);

//---------------------------------------------------------------------------
procedure CreateDX10CanvasEffect(out MemAddr: Pointer; out ByteSize: Integer);
begin
 GetMem(MemAddr, EffectOrigSize);

 ByteSize:= DecompressData(@EffectZipBytes[0], MemAddr,
  SizeOf(EffectZipBytes), EffectOrigSize);
end;

//---------------------------------------------------------------------------
end.
