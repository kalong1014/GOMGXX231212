unit M2Wil;

interface

uses
  Windows, Classes, Graphics, SysUtils, Generics.Collections, DIB, ZLib, IOUtils,
  PngImage, Math, uEDCode, Dialogs;

type
  TGraphicType = (gtDIB, gtPng, gtRealPng,gtNone);
  TFormatType = (WIL, WZL, WIS, DATA);

  TWMImageHeader = record
    Title: String[40];
    ImageCount: integer;
    ColorCount: integer;
    PaletteSize: integer;
    VerFlag: integer;
  end;

  TWMIndexHeader = record
    Title: string[40];
    IndexCount: integer;
    VerFlag: integer;
  end;

  TWMImageInfo = record
    nWidth: Smallint;
    nHeight: SmallInt;
    px: SmallInt;
    py: SmallInt;
    ImageVerSion: LongWord;
    nSize: LongWord;
  end;

  TWZLImageHeader = record
    Title: string[43];
    IndexCount: integer;
    Reserved: array [0 .. 15] of Byte;
  end;
  PWZLImageHeader = ^TWZLImageHeader;

  TWZLIndexHeader = record
    Title: string[43];
    IndexCount: integer;
  end;
  PWZLIndexHeader = ^TWZLIndexHeader;

  TWZLImageInfo = packed record // 16
    m_Enc1: Byte; // 1 3:8位  5:16位
    m_Enc2: Byte; // 1 不清楚1
    m_type1: Byte; // 1 不清楚
    m_type2: Byte; // 1 不清楚0
    m_nWidth: SmallInt; // 2 宽度
    m_nHeight: SmallInt; // 2 高度
    m_wPx: SmallInt; // 2 x
    m_wPy: SmallInt; // 2 y
    m_Len: Cardinal; // 4 压缩数据长度
  end;
  PWZLImageInfo = ^TWZLImageInfo;

  TPackDataHeader = record // 新定义的Data文件头
    Title: String[40];
    ImageCount: integer;
    IndexOffSet: integer;
    XVersion: Word; // 0:普通 1:压缩
    Password: String[16];
  end;
  pTPackDataHeader = ^TPackDataHeader;

  TPackDataImageInfo = packed record // 新定义Data图片信息
    nWidth: Word;
    nHeight: Word;
    BitCount: Byte;
    px: SmallInt;
    py: SmallInt;
    nSize: LongWord;
    GraphicType: TGraphicType; // 0:DIB,BMP 1:PNG
  end;
  pTPackDataImageInfo = ^TPackDataImageInfo;

  TBmpImage = record
    DIB: TGraphic;
    MirrorXDIB: TGraphic;
    dwLatestTime: LongWord;
  end;
  pTBmpImage = ^TBmpImage;

  TBmpImageArr = array [0 .. 9999] of TBmpImage;
  PTBmpImageArr = ^TBmpImageArr;

  TWMImages = class;
  TOnFileCheck = procedure(Sender: TWMImages; var Password: String) of Object;

  TWMImages = class
  private
    btVersion: Byte;
    FBitFormat: TPixelFormat;
    BytesPerPixe: Byte;
    BitCount: Byte;
    FFileName: String;
    FImageCount: integer;
    FAppr: Word;
    m_dwMemChecktTick: LongWord;
    m_BmpArr: PTBmpImageArr;
    m_IndexList: TList<integer>;
    m_FileStream: TFileStream;
    m_boNeedRebuild: Boolean;
    FEditing: Boolean;
    FValidated: Boolean;
    FOnFileCheck: TOnFileCheck;
    procedure SetFileName(const Value: String);
    procedure FreeOldBmps;
  protected
    FWilImageInfo: TWMImageInfo;
    FWzlImageInfo: TWZLImageInfo;
    procedure LoadAllData; virtual;
    procedure LoadBmpImage(position: integer; var ADIB: TGraphic); virtual;
    function GetImageBitmap(Index: integer): TDIB;
    function GetGraphic(Index: integer): TGraphic;
    function GetImageMirrorXBitmap(Index: integer): TDIB;
    procedure DoGetImgSize(position: integer; var AWidth, AHeight: integer);
      overload; virtual;
    procedure DoGetImgSize(position: integer;
      var AWidth, AHeight, px, py: integer); overload; virtual;
    procedure DoGetImgSize(position: integer;
      var AWidth, AHeight, px, py: integer; var AGraphicType: TGraphicType);
      overload; virtual;
    function GetGraphicType(Index: integer): TGraphicType; virtual;
    procedure SetGraphicType(Index: integer;
      const Value: TGraphicType); virtual;
    procedure LoadGraphicImage(position: integer; var Graphic: TGraphic); virtual;
  public
    MainPalette: TRgbQuads;
    class procedure CreateNewFile(const FileName: String); virtual;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure ChangePassword(const New: String); virtual;
    function GetImgSize(index: integer; var AWidth, AHeight: integer)
      : Boolean; overload;
    function GetImgSize(index: integer; var AWidth, AHeight, px, py: integer)
      : Boolean; overload;
    function GetImgSize(index: integer; var AWidth, AHeight, px, py: integer;
      var AGraphicType: TGraphicType): Boolean; overload;
    procedure DrawZoom(ACanvas: TCanvas; X, Y, AIndex: integer; AZoom: Real;
      Leftzero: Boolean; MirrorX, MirrorY: Boolean);
    procedure DrawZoomEx(ACanvas: TCanvas; X, Y, AIndex: integer; AZoom: Real;
      Leftzero: Boolean; MirrorX, MirrorY: Boolean);
    procedure FreeBitmap(index: integer);
    procedure SetPos(index: integer; px, py: integer); virtual;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    function Add(Graphic: TGraphic; X, Y: integer; AGraphicType: TGraphicType)
      : Boolean; virtual;
    function Insert(Index: integer; Graphic: TGraphic; X, Y: integer;
      AGraphicType: TGraphicType): Boolean; virtual;
    function Replace(Index: integer; Graphic: TGraphic; X, Y: integer;
      AGraphicType: TGraphicType): Boolean; virtual;
    function Delete(StartIdx, EndIdx: integer): Boolean; virtual;
    function Fill(StartIdx, EndIdx: integer): Boolean; virtual;
    property FileName: String read FFileName write SetFileName;
    property ImageCount: integer read FImageCount;
    property Appr: Word read FAppr write FAppr;
    property Bitmaps[Index: integer]: TDIB read GetImageBitmap;
    property Graphics[index : integer] :TGraphic read GetGraphic;
    property GraphicType[Index: integer]: TGraphicType read GetGraphicType
      write SetGraphicType;
    property MirrorXBitmaps[Index: integer]: TDIB read GetImageMirrorXBitmap;
    property BitFormat: TPixelFormat read FBitFormat;
    property Editing: Boolean read FEditing;
    property Version: Byte read btVersion;
    property Validated: Boolean read FValidated;
    property OnFileCheck: TOnFileCheck read FOnFileCheck write FOnFileCheck;
    property LastWilImageInfo: TWMImageInfo read FWilImageInfo;
    property LastWzlImageInfo: TWZLImageInfo read FWzlImageInfo;
  end;

  TWILImages = class(TWMImages)
  private
    procedure LoadAllDataBmp;
    procedure LoadPalette;
  protected
    procedure LoadIndex(const FileName: string);
    procedure LoadBmpImage(position: integer; var ADIB: TGraphic); override;
    procedure DoGetImgSize(position: integer; var AWidth, AHeight: integer);
      overload; override;
    procedure DoGetImgSize(position: integer;
      var AWidth, AHeight, px, py: integer); overload; override;
    procedure DoGetImgSize(position: integer;
      var AWidth, AHeight, px, py: integer; var AGraphicType: TGraphicType);
      overload; override;
  public
    constructor Create; override;
    procedure Initialize; override;
    class procedure CreateNewFile(const FileName: String); override;
    function Delete(StartIdx, EndIdx: integer): Boolean; override;
    function Fill(StartIdx, EndIdx: integer): Boolean; override;
  end;

  TWZLImages = class(TWMImages)
  private
    FHeader: TWZLImageHeader;
  protected
    procedure LoadIndex(const FileName: string);
    procedure LoadBmpImage(position: integer; var ADIB: TGraphic); override;
    procedure DoGetImgSize(position: integer; var AWidth, AHeight: integer);
      overload; override;
    procedure DoGetImgSize(position: integer;
      var AWidth, AHeight, px, py: integer); overload; override;
    procedure DoGetImgSize(position: integer;
      var AWidth, AHeight, px, py: integer; var AGraphicType: TGraphicType);
      overload; override;
    function GetGraphicType(Index: integer): TGraphicType; override;
    procedure SetGraphicType(Index: integer;
      const Value: TGraphicType); override;
  public
    class procedure CreateNewFile(const FileName: String); override;
    procedure Initialize; override;
    procedure BeginUpdate; override;
    procedure EndUpdate; override;
    procedure SetPos(index: integer; px, py: integer); override;
    function Add(DIB: TGraphic; X, Y: integer; AGraphicType: TGraphicType)
      : Boolean; override;
    function Insert(Index: integer; DIB: TGraphic; X, Y: integer;
      AGraphicType: TGraphicType): Boolean; override;
    function Replace(Index: integer; DIB: TGraphic; X, Y: integer;
      AGraphicType: TGraphicType): Boolean; override;
  end;

  TWMPackageImages = class(TWMImages)
  private const
    _HKey = '7BB2FA4F-2A6A-4632-B72F-F98D440E8C36';
  const
    _Key = 'CFBA39C1-72A6-4171-9FF0-CF1920DD76F3';
  private
    FDataHeader: TPackDataHeader;
    FPassWord: AnsiString;
    FDisableCheck: Boolean;
    function ReadHeader(AStream: TStream): TPackDataHeader;
    class procedure WriteHeader(AStream: TStream; AHeader: TPackDataHeader);
    function ReadImageInfo(AStream: TStream; APosition, Ver: integer)
      : TPackDataImageInfo;
    procedure WriteImageInfo(AStream: TStream; APosition, Ver: integer;
      AImageInfo: TPackDataImageInfo);
    function CheckImageInfoSize(AStream: TStream;
      APosition, Ver: integer): Boolean;
  protected
    procedure LoadIndex;
    procedure LoadBmpImage(position: integer; var ADIB: TGraphic); override;
    procedure DoGetImgSize(position: integer;
      var AWidth, AHeight: integer); override;
    procedure DoGetImgSize(position: integer;
      var AWidth, AHeight, px, py: integer); overload; override;
    procedure DoGetImgSize(position: integer;
      var AWidth, AHeight, px, py: integer; var AGraphicType: TGraphicType);
      overload; override;
    function GetGraphicType(Index: integer): TGraphicType; override;
    procedure SetGraphicType(Index: integer;
      const Value: TGraphicType); override;
    procedure LoadGraphicImage(position: integer; var Graphic: TGraphic); override;
  public
    constructor Create; override;
    procedure Initialize; override;

    class procedure CreateNewFile(const FileName: String); override;
    procedure ChangePassword(const New: String); override;
    procedure BeginUpdate; override;
    procedure EndUpdate; override;
    procedure SetPos(index: integer; px, py: integer); override;
    function Add(Graphic: TGraphic; X, Y: integer; AGraphicType: TGraphicType)
      : Boolean; override;
    function Insert(Index: integer; Graphic: TGraphic; X, Y: integer;
      AGraphicType: TGraphicType): Boolean; override;
    function Replace(Index: integer; Graphic: TGraphic; X, Y: integer;
      AGraphicType: TGraphicType): Boolean; override;
  end;

function ImageFileExists(const AFileName: string; ISFixedFile: Boolean = False): Boolean;
function CreateImages(const AFileName: string; ISFixedFile: Boolean = False): TWMImages;
function CreateImageFile(const AFileName: string): TWMImages;
function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRgbQuads; AllowPalette256: Boolean): TPaletteEntries;
procedure ChangeDIBPixelFormat(ADIB: TDIB; pf: TPixelFormat); inline;
function LoadDIBFromFile(const AFileName: string; var AGraphicType: TGraphicType): TGraphic;
procedure SpliteBitmap(DC: hdc; X, Y: integer; bitmap: TBitmap; transcolor: TColor);
procedure DebugOutStr(msg: string);

var
  MIRPath: String = '';
  ResourcePath: String = '91Resource\';
  Bit8MainPalette: TRGBQuads;
  ColorTable_565: array[0..255] of Word;
  ColorTable_R5G6B5_32: array[0..65535] of Cardinal;
  ColorTable_A1R5G5B5: array[0..65535] of Word;
  DateTimeFormatSettings: TFormatSettings;
  ColorPalette: array[0..255] of Cardinal;
  g_OldWMImages: TWMImages;
  g_NewWMImages: TWMImages;
  tempindex : Integer;
implementation

procedure DebugOutStr (msg: string);
var
   flname: string;
   fhandle: TextFile;
begin
   flname := '.\!debug.txt';
   if FileExists(flname) then begin
      AssignFile (fhandle, flname);
      Append (fhandle);
   end else begin
      AssignFile (fhandle, flname);
      Rewrite (fhandle);
   end;
   WriteLn (fhandle, TimeToStr(Time) + ' ' + msg);
   CloseFile (fhandle);
end;

function WidthBytes(Width, BitCount: integer): integer;
begin
  Result := (((Width * BitCount) + 31) div 32) * 4;
end;
{$IF RTLVersion>= 29.0}//xe8+
{$LEGACYIFEND ON}
{$IFEND}

{$IF RTLVersion>= 29.0}//xe8+
function ZLibPtr(Ptr:PAnsiChar):PByte;
begin
  Result := PByte(Ptr);
end;
{$ELSE}
function ZLibPtr(Ptr:PAnsiChar):PAnsiChar;
begin
  Result := Ptr;
end;
{$IFEND}

procedure CompressBufZ(const InBuf: PAnsiChar; InBytes: Integer; out OutBuf: PAnsiChar; out OutBytes: Integer);
const
  delta = 256;
var
  zstream: TZStreamRec;
begin
  FillChar(zstream, SizeOf(TZStreamRec), 0);

  OutBytes := ((InBytes + (InBytes div 10) + 12) + 255) and not 255;
  GetMem(OutBuf, OutBytes);

  try
    zstream.next_in := ZLibPtr(InBuf);
    zstream.avail_in := InBytes;
    zstream.next_out := ZLibPtr(OutBuf);
    zstream.avail_out := OutBytes;

    DeflateInit_(zstream, Z_BEST_COMPRESSION, ZLIB_VERSION, SizeOf(TZStreamRec));
    try
      while deflate(zstream, Z_FINISH) <> Z_STREAM_END do
      begin
        Inc(OutBytes, delta);
        ReallocMem(OutBuf, OutBytes);
        zstream.next_out := ZLibPtr(PAnsiChar(Integer(OutBuf) + zstream.total_out));
        zstream.avail_out := delta;
      end;
    finally
      deflateEnd(zstream);
    end;

    ReallocMem(OutBuf, zstream.total_out);
    OutBytes := zstream.total_out;
  except
    FreeMem(OutBuf);
    raise;
  end;
end;

procedure DecompressBufZ(const inBuffer: PAnsiChar; inSize: Integer; outEstimate: Integer;
  out outBuffer: PAnsiChar; out outSize: Integer);
var
  zstream: TZStreamRec;
  delta: Integer;
begin
  FillChar(zstream, SizeOf(TZStreamRec), 0);
  delta := (inSize + 255) and not 255;
  if outEstimate = 0 then
    outSize := delta
  else
    outSize := outEstimate;

  GetMem(outBuffer, outSize);
  zstream.next_in := ZLibPtr(inBuffer);
  zstream.avail_in := inSize;
  zstream.next_out := ZLibPtr(outBuffer);
  zstream.avail_out := outSize;
  inflateInit_(zstream, zlib_version, sizeof(zstream));
  try
    while inflate(zstream, Z_NO_FLUSH) <> Z_STREAM_END do
    begin
      Inc(outSize, delta);
      ReallocMem(outBuffer, outSize);

      zstream.next_out := ZLibPtr(PAnsiChar(Cardinal(outBuffer) + zstream.total_out));
      zstream.avail_out := delta;
    end;
  finally
    inflateEnd(zstream);
  end;
  ReallocMem(outBuffer, zstream.total_out);
  outSize := zstream.total_out;
end;

function ImageFileExists(const AFileName: String; ISFixedFile: Boolean)
  : Boolean;
var
  TmpFileName: String;
begin
  Result := False;
  if ISFixedFile then
    Result := FileExists(AFileName)
  else
  begin
    TmpFileName := ChangeFileExt(MIRPath + AFileName, '.wzl');
    if FileExists(TmpFileName) then
      Result := True
    else if FileExists(ChangeFileExt(TmpFileName, '.wil')) then
      Result := True
    else if FileExists(ChangeFileExt(TmpFileName, '.wis')) then
      Result := True
    else if FileExists(ChangeFileExt(TmpFileName, '.data')) then
      Result := True;
  end;
end;

function CreateImages(const AFileName: String; ISFixedFile: Boolean): TWMImages;
var
  Ext, TmpFileName: String;
begin
  Result := nil;
  if ISFixedFile then
  begin
    TmpFileName := AFileName;
    Ext := UpperCase(ExtractFileExt(AFileName));
  end
  else
  begin
    TmpFileName := MIRPath + AFileName;
    TmpFileName := ChangeFileExt(TmpFileName, '.wzl');
    if not FileExists(TmpFileName) then
    begin
      TmpFileName := ChangeFileExt(TmpFileName, '.wil');
      if not FileExists(TmpFileName) then
      begin
        TmpFileName := ChangeFileExt(TmpFileName, '.wis');
        if not FileExists(TmpFileName) then
          TmpFileName := ChangeFileExt(TmpFileName, '.data');
      end;
    end;
    Ext := UpperCase(ExtractFileExt(TmpFileName));
  end;
  if not FileExists(TmpFileName) then
    Exit;

  if SameText(Ext, '.WIL') or SameText(Ext, '.WIS') then
    Result := TWILImages.Create
  else if SameText(Ext, '.WZL') then
    Result := TWZLImages.Create
  else if SameText(Ext, '.DATA') then
    Result := TWMPackageImages.Create;
  if Result <> nil then
    Result.FileName := TmpFileName;
end;

function CreateImageFile(const AFileName: String): TWMImages;
var
  AExt: String;
begin
  Result := nil;
  AExt := UpperCase(ExtractFileExt(AFileName));
  if SameText(AExt, '.WZL') then
  begin
    TWZLImages.CreateNewFile(AFileName);
    Result := TWZLImages.Create;
    Result.FFileName := AFileName;
  end
  else if SameText(AExt, '.DATA') then
  begin
    TWMPackageImages.CreateNewFile(AFileName);
    Result := TWMPackageImages.Create;
    Result.FFileName := AFileName;
  end;
end;

function ExtractFileNameOnly(const fname: string): string;
var
  extpos: integer;
  Ext, fn: string;
begin
  Ext := ExtractFileExt(fname);
  fn := ExtractFileName(fname);
  if Ext <> '' then
  begin
    extpos := Pos(Ext, fn);
    Result := Copy(fn, 1, extpos - 1);
  end
  else
    Result := fn;
end;

function DuplicateBitmap(bitmap: TBitmap): HBitmap;
var
  hbmpOldSrc, hbmpOldDest, hbmpNew: HBitmap;
  hdcSrc, hdcDest: hdc;

begin
  hdcSrc := CreateCompatibleDC(0);
  hdcDest := CreateCompatibleDC(hdcSrc);

  hbmpOldSrc := SelectObject(hdcSrc, bitmap.Handle);

  hbmpNew := CreateCompatibleBitmap(hdcSrc, bitmap.Width, bitmap.Height);

  hbmpOldDest := SelectObject(hdcDest, hbmpNew);

  BitBlt(hdcDest, 0, 0, bitmap.Width, bitmap.Height, hdcSrc, 0, 0, SRCCOPY);

  SelectObject(hdcDest, hbmpOldDest);
  SelectObject(hdcSrc, hbmpOldSrc);

  DeleteDC(hdcDest);
  DeleteDC(hdcSrc);

  Result := hbmpNew;
end;

procedure SpliteBitmap(DC: hdc; X, Y: integer; bitmap: TBitmap;
  transcolor: TColor);
var
  hdcMixBuffer, hdcBackMask, hdcForeMask, hdcCopy: hdc;
  hOld, hbmCopy, hbmMixBuffer, hbmBackMask, hbmForeMask: HBitmap;
  oldColor: TColor;
begin
  hbmCopy := DuplicateBitmap(bitmap);
  hdcCopy := CreateCompatibleDC(DC);
  hOld := SelectObject(hdcCopy, hbmCopy);

  hdcBackMask := CreateCompatibleDC(DC);
  hdcForeMask := CreateCompatibleDC(DC);
  hdcMixBuffer := CreateCompatibleDC(DC);

  hbmBackMask := CreateBitmap(bitmap.Width, bitmap.Height, 1, 1, nil);
  hbmForeMask := CreateBitmap(bitmap.Width, bitmap.Height, 1, 1, nil);
  hbmMixBuffer := CreateCompatibleBitmap(DC, bitmap.Width, bitmap.Height);

  SelectObject(hdcBackMask, hbmBackMask);
  SelectObject(hdcForeMask, hbmForeMask);
  SelectObject(hdcMixBuffer, hbmMixBuffer);

  oldColor := SetBkColor(hdcCopy, transcolor); // clWhite);

  BitBlt(hdcForeMask, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0,
    SRCCOPY);

  SetBkColor(hdcCopy, oldColor);

  BitBlt(hdcBackMask, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0, 0,
    NOTSRCCOPY);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, DC, X, Y, SRCCOPY);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcForeMask, 0,
    0, SRCAND);

  BitBlt(hdcCopy, 0, 0, bitmap.Width, bitmap.Height, hdcBackMask, 0, 0, SRCAND);

  BitBlt(hdcMixBuffer, 0, 0, bitmap.Width, bitmap.Height, hdcCopy, 0, 0,
    SRCPAINT);

  BitBlt(DC, X, Y, bitmap.Width, bitmap.Height, hdcMixBuffer, 0, 0, SRCCOPY);

  DeleteObject(SelectObject(hdcCopy, hOld));
  DeleteObject(SelectObject(hdcForeMask, hOld));
  DeleteObject(SelectObject(hdcBackMask, hOld));
  DeleteObject(SelectObject(hdcMixBuffer, hOld));

  DeleteDC(hdcCopy);
  DeleteDC(hdcForeMask);
  DeleteDC(hdcBackMask);
  DeleteDC(hdcMixBuffer);
end;

function PaletteFromBmpInfo(BmpInfo: PBitmapInfo): HPalette;
var
  PalSize, n: integer;
  Palette: PLogPalette;
begin
  // Allocate Memory for Palette
  PalSize := SizeOf(TLogPalette) + (256 * SizeOf(TPaletteEntry));
  Palette := AllocMem(PalSize);

  // Fill in structure
  with Palette^ do
  begin
    palVersion := $300;
    palNumEntries := 256;
    for n := 0 to 255 do
    begin
      palPalEntry[n].peRed := BmpInfo^.bmiColors[n].rgbRed;
      palPalEntry[n].peGreen := BmpInfo^.bmiColors[n].rgbGreen;
      palPalEntry[n].peBlue := BmpInfo^.bmiColors[n].rgbBlue;
      palPalEntry[n].peFlags := 0;
    end;
  end;
  Result := CreatePalette(Palette^);
  FreeMem(Palette, PalSize);
end;

procedure CreateDIB256(var Bmp: TBitmap; BmpInfo: PBitmapInfo; bits: PByte);
var
  DC, MemDc: hdc;
  OldPal: HPalette;
begin
  DC := 0;
  MemDc := 0; // jacky
  // First Release Handle and Palette from BMP
  DeleteObject(Bmp.ReleaseHandle);
  DeleteObject(Bmp.ReleasePalette);

  try
    DC := GetDC(0);
    try
      MemDc := CreateCompatibleDC(DC);
      DeleteObject(SelectObject(MemDc, CreateCompatibleBitmap(DC, 1, 1)));

      OldPal := 0;
      Bmp.Palette := PaletteFromBmpInfo(BmpInfo);
      OldPal := SelectPalette(MemDc, Bmp.Palette, False);
      RealizePalette(MemDc);
      try
        Bmp.Handle := CreateDIBitmap(MemDc, BmpInfo^.bmiHeader, CBM_INIT,
          Pointer(bits), BmpInfo^, DIB_RGB_COLORS);
      finally
        if OldPal <> 0 then
          SelectPalette(MemDc, OldPal, True);
      end;
    finally
      if MemDc <> 0 then
        DeleteDC(MemDc);
    end;
  finally
    if DC <> 0 then
      ReleaseDC(0, DC);
  end;
  if Bmp.Handle = 0 then
    Exception.Create('CreateDIBitmap failed');
end;

function MakeBmp(w, h: integer; bits: Pointer; pal: TRgbQuads): TBitmap;
var
  i, k: integer;
  BmpInfo: PBitmapInfo;
  HeaderSize: integer;
  Bmp: TBitmap;
begin
  HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
  GetMem(BmpInfo, HeaderSize);
  for i := 0 to 255 do
  begin
    BmpInfo.bmiColors[i] := pal[i];
  end;
  with BmpInfo^.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := w;
    biHeight := h;
    biPlanes := 1;
    biBitCount := 8; // 8bit
    biCompression := BI_RGB;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
  Bmp := TBitmap.Create;
  CreateDIB256(Bmp, BmpInfo, bits);
  FreeMem(BmpInfo);
  Result := Bmp;
end;

procedure DrawBits(Canvas: TCanvas; XDest, YDest: integer; PSource: PByte;
  Width, Height: integer);
var
  HeaderSize: integer;
  BmpInfo: PBitmapInfo;
begin
  if PSource = nil then
    Exit;

  HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
  BmpInfo := AllocMem(HeaderSize);
  if BmpInfo = nil then
    raise Exception.Create('TNoryImg: Failed to allocate a DIB');
  with BmpInfo^.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := Width;
    biHeight := -Height;
    biPlanes := 1;
    biBitCount := 8;
    biCompression := BI_RGB;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
  SetDIBitsToDevice(Canvas.Handle, XDest, YDest, Width, Height, 0, 0, 0, Height,
    PSource, BmpInfo^, DIB_RGB_COLORS);
  FreeMem(BmpInfo, HeaderSize);
end;

procedure ChangeDIBPixelFormat(ADIB: TDIB; pf: TPixelFormat);
begin
  case pf of
    pf8bit:
      begin
        with ADIB.PixelFormat do
        begin
          RBitMask := $FF0000;
          GBitMask := $00FF00;
          BBitMask := $0000FF;
        end;
        ADIB.BitCount := 8;
      end;
    pf16bit:
      begin
        with ADIB.PixelFormat do
        begin
          RBitMask := $F800;
          GBitMask := $07E0;
          BBitMask := $001F;
        end;
        ADIB.BitCount := 16;
      end;
    pf24bit:
      begin
        with ADIB.PixelFormat do
        begin
          RBitMask := $FF0000;
          GBitMask := $00FF00;
          BBitMask := $0000FF;
        end;
        ADIB.BitCount := 24;
      end;
    pf32bit:
      begin
        with ADIB.PixelFormat do
        begin
          RBitMask := $FF0000;
          GBitMask := $00FF00;
          BBitMask := $0000FF;
        end;
        ADIB.BitCount := 32;
      end;
  end;
end;

function LoadDIBFromFile(const AFileName: String;
  var AGraphicType: TGraphicType): TGraphic;

  procedure LoadDIBFromStream(AStream: TStream; var ADIB: TDIB);
  var
    ABmp: TBitmap;
    APixelFormat: TPixelFormat;
  begin
    ABmp := TBitmap.Create;
    try
      ABmp.LoadFromStream(AStream);
      APixelFormat := ABmp.PixelFormat;
      if APixelFormat in [pfDevice, pfCustom] then
      begin
        if AStream.Size > ABmp.Width * ABmp.Height * 4 then
          APixelFormat := pf32bit
        else if AStream.Size > ABmp.Width * ABmp.Height * 3 then
          APixelFormat := pf24bit
        else if AStream.Size > ABmp.Width * ABmp.Height * 2 then
          APixelFormat := pf8bit
      end;
      ADIB := TDIB.Create;
      ChangeDIBPixelFormat(ADIB, APixelFormat);
      if ADIB.BitCount = 8 then
      begin
        ADIB.ColorTable := Bit8MainPalette;
        ADIB.UpdatePalette;
      end;
      ADIB.Width := ABmp.Width;
      ADIB.Height := ABmp.Height;
      ADIB.Canvas.Brush.Color := clblack;
      ADIB.Canvas.FillRect(ADIB.Canvas.ClipRect);
      ADIB.Canvas.Draw(0, 0, ABmp);
    finally
      ABmp.Free;
    end;
  end;

var
  AImg: TWICImage;
  ABmp: TStream;
  DIB :TDIB;
begin
  Result := nil;
  AGraphicType := gtDIB;
  try
    AImg := TWICImage.Create;
    ABmp := TMemoryStream.Create;
    try
      try
        AImg.LoadFromFile(AFileName);
      except
      end;
      if not AImg.Empty then
      begin
        case AImg.ImageFormat of
          wifPng:
            begin
              Result := TPngImage.Create;
              Try
                AGraphicType := gtRealPng;
                Result.LoadFromFile(AFileName);
                // 原来的PNG 转DIB 再导入 修改为 原图导入 以便支持 透明通道 随云 2016 - 9.18
                // ChangeDIBPixelFormat(Result, pf32Bit);
                // Result.Width := APng.Width;
                // Result.Height := APng.Height;
                // Result.Canvas.Brush.Color := clBlack;
                // Result.Canvas.FillRect(Result.Canvas.ClipRect);
                // Result.Canvas.Brush.Style := bsClear;
                // Result.Canvas.Draw(0, 0, APng);
                // AGraphicType := gtPng;
              except
                Result := nil;
              end;

            end
        else { wifBmp, other: }
          begin
             AImg.ImageFormat := wifBmp;
             AImg.SaveToStream(ABmp);
             ABmp.position := 0;
             LoadDIBFromStream(ABmp, DIB);
             Result := DIB;
//            Result := TDIB.Create;
//            try
//              Result.LoadFromFile(AFileName);
//            except
//              Result := nil;
//            end;
          end;
        end;
      end;
    finally
      AImg.Free;
       ABmp.Free;
    end;
  except
  end;
end;

procedure TWILImages.DoGetImgSize(position: integer;
  var AWidth, AHeight: integer);
var
  imginfo: TWMImageInfo;
begin
  AWidth := 0;
  AHeight := 0;
  if position + SizeOf(TWMImageInfo) <= m_FileStream.Size then
  begin
    m_FileStream.Seek(position, 0);
    m_FileStream.Read(imginfo, SizeOf(TWMImageInfo) - 4);
    AWidth := imginfo.nWidth;
    AHeight := imginfo.nHeight;
  end;
end;

constructor TWILImages.Create;
begin
  inherited;
  FEditing := False;
end;

class procedure TWILImages.CreateNewFile(const FileName: String);
var
  AHeader: TWMIndexHeader;
  ATmpFileName: String;
  AFile: TFileStream;
begin
  ATmpFileName := SysUtils.ChangeFileExt(FileName, '.wix');
  AHeader.Title := '91网络资源文件';
  AHeader.IndexCount := 0;
  AHeader.VerFlag := 0;
  AFile := TFileStream.Create(ATmpFileName, fmCreate);
  try
    AFile.Write(AHeader, SizeOf(TWMIndexHeader));
  finally
    AFile.Free;
  end;
  ATmpFileName := SysUtils.ChangeFileExt(FileName, '.wil');
  AFile := TFileStream.Create(ATmpFileName, fmCreate);
  AFile.Free;
end;

function TWILImages.Delete(StartIdx, EndIdx: integer): Boolean;
begin
  Result := False;
end;

procedure TWILImages.DoGetImgSize(position: integer;
  var AWidth, AHeight, px, py: integer; var AGraphicType: TGraphicType);
var
  imginfo: TWMImageInfo;
begin
  AWidth := 0;
  AHeight := 0;
  px := 0;
  py := 0;
  if position + SizeOf(TWMImageInfo) <= m_FileStream.Size then
  begin
    m_FileStream.Seek(position, 0);
    m_FileStream.Read(imginfo, SizeOf(TWMImageInfo) - 4);
    AWidth := imginfo.nWidth;
    AHeight := imginfo.nHeight;
    px := imginfo.px;
    py := imginfo.py;
    AGraphicType := gtDIB;
  end;
end;

procedure TWILImages.DoGetImgSize(position: integer;
  var AWidth, AHeight, px, py: integer);
var
  imginfo: TWMImageInfo;
begin
  AWidth := 0;
  AHeight := 0;
  px := 0;
  py := 0;
  if position + SizeOf(TWMImageInfo) <= m_FileStream.Size then
  begin
    m_FileStream.Seek(position, 0);
    m_FileStream.Read(imginfo, SizeOf(TWMImageInfo) - 4);
    AWidth := imginfo.nWidth;
    AHeight := imginfo.nHeight;
    px := imginfo.px;
    py := imginfo.py;
  end;
end;

function TWILImages.Fill(StartIdx, EndIdx: integer): Boolean;
begin
  Result := False;
end;

procedure TWILImages.Initialize;
var
  Idxfile: string;
  Header: TWMImageHeader;
begin
  inherited;
  if m_FileStream = nil then
    m_FileStream := TFileStream.Create(FFileName, fmOpenRead or
      fmShareDenyNone);

  if UpperCase(ExtractFileExt(FFileName)) = '.WIS' then
  begin
    FBitFormat := pf8bit;
    FImageCount := 300000;
    Idxfile := '';
  end
  else
  begin
    m_FileStream.Read(Header, SizeOf(TWMImageHeader));
    FImageCount := Header.ImageCount;
    if Header.VerFlag = 0 then
    begin
      btVersion := 1;
      m_FileStream.Seek(-4, soFromCurrent);
    end else if Header.VerFlag = $20 then  begin
      btVersion := 2;
    end;
    if Header.ColorCount = 256 then
    begin
      FBitFormat := pf8bit;
      BytesPerPixe := 1;
      BitCount:=8;
    end
    else if Header.ColorCount = 65536 then
    begin
      FBitFormat := pf16bit;
      BytesPerPixe := 2;
      BitCount:=16;
    end
    else if Header.ColorCount = 16777216 then
    begin
      FBitFormat := pf24bit;
      BytesPerPixe := 4;
      BitCount:=24;
    end
    else if Header.ColorCount > 16777216 then
    begin
      FBitFormat := pf32bit;
      BytesPerPixe := 4;
      BitCount:=32;
    end;

    if Header.VerFlag = $20 then begin  //韩国版本
      FBitFormat := pf16bit;
      BytesPerPixe := 2;
      BitCount:=16;
    end;

    Idxfile := ChangeFileExt(FFileName, '.wix');
  end;

  m_BmpArr := AllocMem(SizeOf(TBmpImage) * FImageCount);
  if Header.VerFlag <> $20 then LoadPalette;
  LoadIndex(Idxfile);
end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRgbQuads;
  AllowPalette256: Boolean): TPaletteEntries;
var
  Entries: TPaletteEntries;
  DC: THandle;
  i: integer;
begin
  Result := RGBQuadsToPaletteEntries(RGBQuads);

  if not AllowPalette256 then
  begin
    DC := GetDC(0);
    GetSystemPaletteEntries(DC, 0, 256, Entries);
    ReleaseDC(0, DC);

    for i := 0 to 9 do
      Result[i] := Entries[i];

    for i := 256 - 10 to 255 do
      Result[i] := Entries[i];
  end;

  for i := 0 to 255 do
    Result[i].peFlags := $;//{$IFDEF VER220}$40{$ELSE}D3DPAL_READONLY{$ENDIF};
end;

procedure TWILImages.LoadAllDataBmp;
var
  i: integer;
  pbuf: PByte;
  imgi: TWMImageInfo;
  Bmp: TBitmap;
begin
end;

procedure TWILImages.LoadIndex(const FileName: string);
var
  fhandle, i, Value: integer;
  Header: TWMIndexHeader;
  pvalue: PInteger;
begin
  m_IndexList.Clear;
  if FileExists(FileName) then
  begin
    fhandle := FileOpen(FileName, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then
    begin
      if btVersion = 1 then
        FileRead(fhandle, Header, SizeOf(TWMIndexHeader) - 4)
      else
        FileRead(fhandle, Header, SizeOf(TWMIndexHeader));

      GetMem(pvalue, 4 * Header.IndexCount);
      FileRead(fhandle, pvalue^, 4 * Header.IndexCount);
      for i := 0 to Header.IndexCount - 1 do
      begin
        Value := PInteger(integer(pvalue) + 4 * i)^;
        m_IndexList.Add(Value);
      end;
      FreeMem(pvalue);
      FileClose(fhandle);
    end;
  end;
end;

procedure TWILImages.LoadPalette;
begin
  if FBitFormat = pf8bit then
  begin
    if btVersion <> 0 then
      m_FileStream.Seek(SizeOf(TWMImageHeader) - 4, 0)
    else
      m_FileStream.Seek(SizeOf(TWMImageHeader), 0);

    m_FileStream.Read(MainPalette, SizeOf(TRGBQuad) * 256);
  end;
end;

procedure TWILImages.LoadBmpImage(position: integer; var ADIB: TGraphic);
var
  imginfo: TWMImageInfo;
  DIB:TDIB;
  inBuffer, outBuffer: PAnsiChar;
  S: Pointer;
  SrcP: PByte;
  Compressed: Byte;
  nSize, nlen: Integer;
  DesP: Pointer;
begin
  ADIB := nil;
  if position =0 then
    Exit;

  m_FileStream.Seek(position, 0);
//    m_FileStream.Position := Position;
  if btVersion = 2 then m_FileStream.Read(imginfo, SizeOf(TWMImageInfo))
  else if btVersion = 0 then m_FileStream.Read(imginfo, SizeOf(TWMImageInfo)-4)
  else m_FileStream.Read(imginfo, SizeOf(TWMImageInfo) -8);

  if (imginfo.nWidth < 2) or (imginfo.nHeight < 2) then Exit;

  if BitCount = 8 then
    nSize := WidthBytes(imginfo.nWidth, BitCount) * imginfo.nHeight
  else
    nSize := imginfo.nWidth * imginfo.nHeight * (BitCount div 8);

  if btVersion = 2 then begin

  end else begin
    GetMem(S, nSize);
    m_FileStream.Read(S^, nSize);
  end;
  SrcP := S;

  FWilImageInfo := imginfo;

  if position + SizeOf(TWMImageInfo) <= m_FileStream.Size then
  begin
    try
      DIB := TDIB.Create;
      ChangeDIBPixelFormat(DIB, FBitFormat);
      DIB.Width := imginfo.nWidth;
      DIB.Height := imginfo.nHeight;
      if FBitFormat = pf8bit then
      begin
        DIB.ColorTable := MainPalette;
        DIB.UpdatePalette;
      end;
      DIB.Canvas.Brush.Color := clblack;
      DIB.Canvas.FillRect(DIB.ClientRect);
      DesP := DIB.PBits;
      Move(SrcP^, DesP^, nSize);
      ADIB := DIB;
    finally
//      DIB.Free;
    end;
  end;
  FreeMem(S);
end;

procedure TWMImages.Finalize;
var
  i: integer;
begin
  m_IndexList.Clear;
  if m_BmpArr <> nil then
  begin
    for i := 0 to ImageCount - 1 do
      if m_BmpArr[i].DIB <> nil then
      begin
        m_BmpArr[i].DIB.Free;
        m_BmpArr[i].DIB := nil;
      end;
    FreeMem(m_BmpArr);
  end;

  m_BmpArr := nil;
  if m_FileStream <> nil then
    FreeAndNil(m_FileStream);
end;

procedure TWMImages.FreeBitmap(index: integer);
begin
  if (index >= 0) and (index < ImageCount) then
  begin
    if m_BmpArr[index].DIB <> nil then
    begin
      m_BmpArr[index].DIB.Free;
      m_BmpArr[index].DIB := nil;
    end;
  end;
end;

procedure TWMImages.DrawZoom(ACanvas: TCanvas; X, Y, AIndex: integer;
  AZoom: Real; Leftzero: Boolean; MirrorX, MirrorY: Boolean);
var
  Rc: TRect;
  Bmp: TDIB;
begin
  if Self = nil then
    Exit;

  if MirrorX then
    Bmp := MirrorXBitmaps[AIndex]
  else
    Bmp := Bitmaps[AIndex];
  if Bmp <> nil then
  begin
    if Leftzero then
    begin
      Rc.Left := X;
      Rc.Top := Y;
      Rc.Right := X + Ceil(Bmp.Width * AZoom);
      Rc.Bottom := Y + Ceil(Bmp.Height * AZoom);
    end
    else
    begin
      Rc.Left := X;
      Rc.Top := Y - Ceil(Bmp.Height * AZoom);
      Rc.Right := X + Ceil(Bmp.Width * AZoom);
      Rc.Bottom := Y;
    end;
    if (Rc.Right > Rc.Left) and (Rc.Bottom > Rc.Top) then
      ACanvas.StretchDraw(Rc, Bmp);
  end;
end;

procedure TWMImages.DrawZoomEx(ACanvas: TCanvas; X, Y, AIndex: integer;
  AZoom: Real; Leftzero: Boolean; MirrorX, MirrorY: Boolean);
var
  ARect: TRect;
  ABmp: TDIB;
  ATempBmp: TBitmap;
begin
  if MirrorX then
    ABmp := MirrorXBitmaps[AIndex]
  else
    ABmp := Bitmaps[AIndex];
  if ABmp <> nil then
  begin
    ATempBmp := TBitmap.Create;
    try
      ATempBmp.Width := Ceil(ABmp.Width * AZoom);
      ATempBmp.Height := Ceil(ABmp.Height * AZoom);
      ARect.Left := X;
      ARect.Top := Y;
      ARect.Right := X + Ceil(ABmp.Width * AZoom);
      ARect.Bottom := Y + Ceil(ABmp.Height * AZoom);
      if (ARect.Right > ARect.Left) and (ARect.Bottom > ARect.Top) then
      begin
        ATempBmp.Canvas.Lock;
        try
          ATempBmp.Canvas.StretchDraw(Rect(0, 0, ATempBmp.Width,
            ATempBmp.Height), ABmp);
          if Leftzero then
            SpliteBitmap(ACanvas.Handle, X, Y, ATempBmp, $0)
          else
            SpliteBitmap(ACanvas.Handle, X, Y - ATempBmp.Height, ATempBmp, $0);
        finally
          ATempBmp.Canvas.Unlock;
        end;
      end;
    finally
      ATempBmp.Free;
    end;
  end;
end;

procedure TWMImages.EndUpdate;
begin

end;

function TWMImages.Add(Graphic: TGraphic; X, Y: integer;
  AGraphicType: TGraphicType): Boolean;
begin

end;

function TWMImages.Replace(Index: integer; Graphic: TGraphic; X, Y: integer;
  AGraphicType: TGraphicType): Boolean;
begin

end;

function TWMImages.Insert(Index: integer; Graphic: TGraphic; X, Y: integer;
  AGraphicType: TGraphicType): Boolean;
begin

end;

function TWMImages.Delete(StartIdx, EndIdx: integer): Boolean;
var
  i: integer;
begin
  Result := False;
  if (m_IndexList.Count > 0) and (EndIdx >= StartIdx) and (StartIdx >= 0) and
    (EndIdx < m_IndexList.Count) then
  begin
    for i := EndIdx downto StartIdx do
      m_IndexList.Delete(i);
    Result := True;
    m_boNeedRebuild := True;
  end;
end;

function TWMImages.Fill(StartIdx, EndIdx: integer): Boolean;
var
  i: integer;
begin
  Result := False;
  if (m_IndexList.Count > 0) and (EndIdx >= StartIdx) and (StartIdx >= 0) and
    (EndIdx < m_IndexList.Count) then
  begin
    for i := StartIdx to EndIdx do
      m_IndexList[i] := 0;
    Result := True;
    m_boNeedRebuild := True;
  end;
end;

{ TWMPackageImages }

procedure TWMPackageImages.BeginUpdate;
begin
  inherited;

end;

constructor TWMPackageImages.Create;
begin
  inherited;
  btVersion := 10;
end;

class procedure TWMPackageImages.CreateNewFile(const FileName: String);
var
  AFile: TFileStream;
  ADataHeader: TPackDataHeader;
begin
  AFile := TFileStream.Create(FileName, fmCreate);
  try
    ADataHeader.Title := '龙的传说资源文件';
    ADataHeader.ImageCount := 0;
    ADataHeader.IndexOffSet := 80;
    ADataHeader.XVersion := 0;
    ADataHeader.Password := '';
    TWMPackageImages.WriteHeader(AFile, ADataHeader);
  finally
    AFile.Free;
  end;
end;

procedure TWMPackageImages.DoGetImgSize(position: integer;
  var AWidth, AHeight: integer);
var
  ImageInfo: TPackDataImageInfo;
begin
  AWidth := 0;
  AHeight := 0;
  if CheckImageInfoSize(m_FileStream, position, FDataHeader.XVersion) then
  begin
    ImageInfo := ReadImageInfo(m_FileStream, position, FDataHeader.XVersion);
    AWidth := ImageInfo.nWidth;
    AHeight := ImageInfo.nHeight;
  end;
end;

procedure TWMPackageImages.DoGetImgSize(position: integer;
  var AWidth, AHeight, px, py: integer);
var
  ImageInfo: TPackDataImageInfo;
begin
  AWidth := 0;
  AHeight := 0;
  px := 0;
  py := 0;
  if CheckImageInfoSize(m_FileStream, position, FDataHeader.XVersion) then
  begin
    ImageInfo := ReadImageInfo(m_FileStream, position, FDataHeader.XVersion);
    AWidth := ImageInfo.nWidth;
    AHeight := ImageInfo.nHeight;
    px := ImageInfo.px;
    py := ImageInfo.py;
  end;
end;

procedure TWMPackageImages.EndUpdate;
var
  i, nPosition: integer;
  ATempFileName: String;
  ATempFile: TFileStream;
  ImageInfo: TPackDataImageInfo;
  ABuffer: PAnsiChar;
  FNewHeader: TPackDataHeader;
begin
  if m_boNeedRebuild then
  begin
    ATempFileName := IOUtils.TPath.GetTempFileName;
    ATempFile := TFileStream.Create(ATempFileName, fmCreate);
    try
      FNewHeader.Title := FDataHeader.Title;
      FNewHeader.ImageCount := FDataHeader.ImageCount;
      FNewHeader.IndexOffSet := FDataHeader.IndexOffSet;
      FNewHeader.XVersion := 0;
      if FPassWord <> '' then
        FNewHeader.XVersion := 1;
      FNewHeader.Password := FPassWord;
      WriteHeader(ATempFile, FNewHeader);
      // 写入资源
      for i := 0 to m_IndexList.Count - 1 do
      begin
        nPosition := m_IndexList[i];
        if nPosition > 0 then
        begin
          m_IndexList[i] := ATempFile.position;
          ImageInfo := ReadImageInfo(m_FileStream, nPosition,
            FDataHeader.XVersion);
          WriteImageInfo(ATempFile, ATempFile.position, FNewHeader.XVersion,
            ImageInfo);
          if ImageInfo.nSize > 0 then
          begin
            GetMem(ABuffer, ImageInfo.nSize);
            try
              m_FileStream.ReadBuffer(ABuffer^, ImageInfo.nSize);
              ATempFile.WriteBuffer(ABuffer^, ImageInfo.nSize);
            finally
              FreeMem(ABuffer);
            end;
          end;
        end;
      end;
      FNewHeader.IndexOffSet := ATempFile.position;
      // 写入序号
      for i := 0 to m_IndexList.Count - 1 do
      begin
        nPosition := m_IndexList[i];
        ATempFile.WriteBuffer(nPosition, SizeOf(integer));
      end;
      // 重新写入正确的头
      FNewHeader.ImageCount := m_IndexList.Count;
      WriteHeader(ATempFile, FNewHeader);
      // 将临时文件写到当前资源文件
      m_FileStream.Size := 0;
      m_FileStream.position := 0;
      ATempFile.position := 0;
      m_FileStream.CopyFrom(ATempFile, ATempFile.Size);
    finally
      ATempFile.Free;
      IOUtils.TFile.Delete(ATempFileName);
    end;
  end
  else
  begin
    m_FileStream.position := FDataHeader.IndexOffSet;
    for i := 0 to m_IndexList.Count - 1 do
    begin
      nPosition := m_IndexList.Items[i];
      m_FileStream.Write(nPosition, SizeOf(integer));
    end;
    WriteHeader(m_FileStream, FDataHeader);
  end;
  m_boNeedRebuild := False;
  FDisableCheck := True;
  Finalize;
  Initialize;
end;


function TWMPackageImages.GetGraphicType(Index: integer): TGraphicType;
var
  APosition: integer;
  ImageInfo: TPackDataImageInfo;
begin
  Result := gtNone;
  APosition := m_IndexList[Index];
  if APosition > 0 then
  begin
    if CheckImageInfoSize(m_FileStream, APosition, FDataHeader.XVersion) then
    begin
      ImageInfo := ReadImageInfo(m_FileStream, APosition, FDataHeader.XVersion);
      Result := ImageInfo.GraphicType;
    end;
  end;
end;

procedure TWMPackageImages.Initialize;
var
  APass: String;
begin
  inherited;
  if m_FileStream = nil then
    m_FileStream := TFileStream.Create(FFileName, fmOpenReadWrite or
      fmShareDenyNone);
  FDataHeader := ReadHeader(m_FileStream);
  if (not FDisableCheck) and (FDataHeader.XVersion = 1) and
    (FDataHeader.Password <> '') then
  begin
    APass := '';
    if Assigned(FOnFileCheck) then
      FOnFileCheck(Self, APass);
    FValidated := APass = FDataHeader.Password;
    if not FValidated then
    begin
      FDataHeader.ImageCount := 0;
    end;
  end;

  FImageCount := FDataHeader.ImageCount;
  if FDataHeader.IndexOffSet = 0 then
    FDataHeader.IndexOffSet := 80;
  FBitFormat := pf16bit;
  BytesPerPixe := 2;
  m_BmpArr := AllocMem(SizeOf(TBmpImage) * FImageCount);
  if FImageCount > 0 then
    LoadIndex;
end;

procedure TWMPackageImages.LoadBmpImage(position: integer; var ADIB: TGraphic);
var
  ImageInfo: TPackDataImageInfo;
  Buf, AZlibBuf: PAnsiChar;
  APixelFormat: TPixelFormat;
  ASize: integer;
  DIB : TDIB;
begin
  DIB := nil;
  if CheckImageInfoSize(m_FileStream, position, FDataHeader.XVersion) then
  begin
    ImageInfo := ReadImageInfo(m_FileStream, position, FDataHeader.XVersion);
    if (ImageInfo.nWidth * ImageInfo.nHeight <= 0) then
      Exit;

    DIB := TDIB.Create;
    GetMem(AZlibBuf, ImageInfo.nSize);
    try
      case ImageInfo.BitCount of
        8:
          begin
            ChangeDIBPixelFormat(DIB, pf8bit);
            APixelFormat := pf8bit;
            DIB.ColorTable := Bit8MainPalette;
            DIB.UpdatePalette;
          end;
        16:
          begin
            ChangeDIBPixelFormat(DIB, pf16bit);
            APixelFormat := pf16bit;
          end;
        24:
          begin
            ChangeDIBPixelFormat(DIB, pf24bit);
            APixelFormat := pf24bit;
          end;
        32:
          begin
            ChangeDIBPixelFormat(DIB, pf32bit);
            APixelFormat := pf32bit;
          end;
      else
        begin
          ChangeDIBPixelFormat(DIB, pf24bit);
          APixelFormat := pf24bit;
        end;
      end;
      DIB.SetSize(ImageInfo.nWidth, ImageInfo.nHeight, DIB.BitCount);
      if ImageInfo.nSize + m_FileStream.position <= m_FileStream.Size then
      begin
        m_FileStream.Read(AZlibBuf^, ImageInfo.nSize);
        try
          DecompressBufZ(AZlibBuf, ImageInfo.nSize, 0, Buf, ASize);
          Move(Buf^, DIB.PBits^, ASize);
          DIB.Mirror(False, True);
        finally
          FreeMem(Buf, ASize);
        end;
      end;
    finally
      FreeMem(AZlibBuf);
    end;

    ADIB := DIB;



  end;
end;

procedure TWMPackageImages.LoadGraphicImage(position: integer;
  var Graphic: TGraphic);
var
  ImageInfo: TPackDataImageInfo;
  Buf, AZlibBuf: PAnsiChar;
  APixelFormat: TPixelFormat;
  ASize: integer;
  DIB : TGraphic;
  Png : TPngImage;
begin
  if CheckImageInfoSize(m_FileStream, position, FDataHeader.XVersion) then
  begin
    ImageInfo := ReadImageInfo(m_FileStream, position, FDataHeader.XVersion);
    if (ImageInfo.nWidth * ImageInfo.nHeight <= 0) then
      Exit;
    case ImageInfo.GraphicType of
      gtRealPng:
        begin
          Png := TPngImage.Create;
          Png.LoadFromStream(m_FileStream);
          Graphic := Png;
        end else
        begin
          LoadBmpImage(position,DIB);
          Graphic := DIB
        end;
    end;
  end;

end;

procedure TWMPackageImages.LoadIndex;
var
  i, Value, MaxImgCount: integer;
  pvalue: PInteger;
begin
  m_IndexList.Clear;
  m_FileStream.position := FDataHeader.IndexOffSet;
  if FDataHeader.IndexOffSet = 80 then
  begin
    for i := 0 to ImageCount - 1 do
      m_IndexList.Add(0);
  end
  else
  begin
    GetMem(pvalue, ImageCount * SizeOf(integer));
    FillChar(pvalue^, ImageCount * SizeOf(integer), #0);
    MaxImgCount := Min(ImageCount,
      (m_FileStream.Size - m_FileStream.position) div 4);
    m_FileStream.Read(pvalue^, MaxImgCount * 4);
    for i := 0 to ImageCount - 1 do
    begin
      if i < MaxImgCount then
        Value := PInteger(integer(pvalue) + SizeOf(integer) * i)^
      else
        Value := 0;
      m_IndexList.Add(Value);
    end;
    FreeMem(pvalue);
  end;
end;

function TWMPackageImages.Add(Graphic: TGraphic; X, Y: integer;
  AGraphicType: TGraphicType): Boolean;
var
  ImageInfo: TPackDataImageInfo;
  nSize: integer;
  Buf: PAnsiChar;
  DDIB: TDIB;
  Png: TPngImage;
  Mem: TMemoryStream;
begin
  if (Graphic <> nil) and not Graphic.Empty then
  begin
    if Graphic is TDIB then
    begin
      try
        DDIB := Graphic as TDIB;
        CompressBufZ(DDIB.PBits, DDIB.Size, Buf, nSize);
        ImageInfo.nWidth := DDIB.Width;
        ImageInfo.nHeight := DDIB.Height;
        ImageInfo.px := X;
        ImageInfo.py := Y;
        ImageInfo.BitCount := DDIB.BitCount;
        ImageInfo.nSize := nSize;
        ImageInfo.GraphicType := AGraphicType;

        m_IndexList.Add(FDataHeader.IndexOffSet);
        WriteImageInfo(m_FileStream, FDataHeader.IndexOffSet,
          FDataHeader.XVersion, ImageInfo);
        m_FileStream.Write(Buf^, ImageInfo.nSize);
        FDataHeader.ImageCount := FDataHeader.ImageCount + 1;
        FDataHeader.IndexOffSet := m_FileStream.position;
      finally
        FreeMem(Buf);
      end;
    end
    else if Graphic is TPngImage then
    begin
      Png := Graphic as TPngImage;

      ImageInfo.nWidth := Png.Width;
      ImageInfo.nHeight := Png.Height;
      ImageInfo.px := X;
      ImageInfo.py := Y;
      ImageInfo.GraphicType := AGraphicType;
      Mem := TMemoryStream.Create;
      Try
        Png.SaveToStream(Mem);
        ImageInfo.nSize := Mem.Size;

        m_IndexList.Add(FDataHeader.IndexOffSet);
        WriteImageInfo(m_FileStream, FDataHeader.IndexOffSet,
          FDataHeader.XVersion, ImageInfo);
        m_FileStream.Write(Mem.Memory^, ImageInfo.nSize);
        FDataHeader.ImageCount := FDataHeader.ImageCount + 1;
        FDataHeader.IndexOffSet := m_FileStream.position;
      Finally
        Mem.Free;
      End;
    end;
  end
  else
  begin
    if (X <> 0) or (Y <> 0) then
    begin
      ImageInfo.nWidth := 0;
      ImageInfo.nHeight := 0;
      ImageInfo.px := X;
      ImageInfo.py := Y;
      ImageInfo.BitCount := 16;
      ImageInfo.nSize := 0;
      m_IndexList.Add(FDataHeader.IndexOffSet);
      m_FileStream.position := FDataHeader.IndexOffSet;
      WriteImageInfo(m_FileStream, FDataHeader.IndexOffSet,
        FDataHeader.XVersion, ImageInfo);
      FDataHeader.IndexOffSet := m_FileStream.position;
    end
    else
      m_IndexList.Add(0);
    FDataHeader.ImageCount := FDataHeader.ImageCount + 1;
  end;
  Result := True;
end;

function TWMPackageImages.Insert(Index: integer; Graphic: TGraphic;
  X, Y: integer; AGraphicType: TGraphicType): Boolean;
var
  nSize: integer;
  ImageInfo: TPackDataImageInfo;
  ABuf: PAnsiChar;
  DDIB: TDIB;
  Png: TPngImage;
  Mem: TMemoryStream;
begin
  if (Graphic <> nil) and not Graphic.Empty then
  begin
    try
      if Graphic is TDIB then
      begin
        DDIB := Graphic as TDIB;
        CompressBufZ(DDIB.PBits, DDIB.Size, ABuf, nSize);
        ImageInfo.nWidth := DDIB.Width;
        ImageInfo.nHeight := DDIB.Height;
        ImageInfo.px := X;
        ImageInfo.py := Y;
        ImageInfo.BitCount := DDIB.BitCount;
        ImageInfo.nSize := nSize;
        ImageInfo.GraphicType := AGraphicType;

        m_IndexList.Insert(Index, FDataHeader.IndexOffSet);
        WriteImageInfo(m_FileStream, FDataHeader.IndexOffSet,
          FDataHeader.XVersion, ImageInfo);
        m_FileStream.Write(ABuf^, ImageInfo.nSize);
        FDataHeader.ImageCount := FDataHeader.ImageCount + 1;
        FDataHeader.IndexOffSet := m_FileStream.position;
      end
      else if Graphic is TPngImage then
      begin
        Png := Graphic as TPngImage;

        ImageInfo.nWidth := Png.Width;
        ImageInfo.nHeight := Png.Height;
        ImageInfo.px := X;
        ImageInfo.py := Y;
        ImageInfo.GraphicType := AGraphicType;
        Mem := TMemoryStream.Create;
        Try
          Png.SaveToStream(Mem);
          ImageInfo.nSize := Mem.Size;

          m_IndexList.Insert(Index, FDataHeader.IndexOffSet);
          WriteImageInfo(m_FileStream, FDataHeader.IndexOffSet,
            FDataHeader.XVersion, ImageInfo);
          m_FileStream.Write(Mem.Memory^, ImageInfo.nSize);
          FDataHeader.ImageCount := FDataHeader.ImageCount + 1;
          FDataHeader.IndexOffSet := m_FileStream.position;
        Finally
          Mem.Free;
        End;
      end;
    finally
      FreeMem(ABuf);
    end;
  end
  else
  begin
    if (X <> 0) or (Y <> 0) then
    begin
      ImageInfo.nWidth := 0;
      ImageInfo.nHeight := 0;
      ImageInfo.px := X;
      ImageInfo.py := Y;
      ImageInfo.BitCount := 16;
      ImageInfo.nSize := 0;
      m_IndexList.Insert(Index, FDataHeader.IndexOffSet);
      WriteImageInfo(m_FileStream, FDataHeader.IndexOffSet,
        FDataHeader.XVersion, ImageInfo);
      FDataHeader.IndexOffSet := m_FileStream.position;
    end
    else
      m_IndexList.Insert(Index, 0);
    FDataHeader.ImageCount := FDataHeader.ImageCount + 1;
  end;
  Result := True;
end;

function TWMPackageImages.ReadHeader(AStream: TStream): TPackDataHeader;
var
  AEncData, ADecData: PAnsiChar;
  ADecSize: integer;
begin
  FillChar(Result, SizeOf(TPackDataHeader), #0);
  AStream.position := 0;
  GetMem(AEncData, 80);
  try
    AStream.ReadBuffer(AEncData^, 80);
    uEDCode.DecodeData(AEncData^, 80, ADecData, ADecSize, _HKey);
    Move(ADecData^, Result, SizeOf(TPackDataHeader));
  finally
    FreeMem(AEncData, 80);
    FreeMem(ADecData, ADecSize);
  end;
end;

class procedure TWMPackageImages.WriteHeader(AStream: TStream;
  AHeader: TPackDataHeader);
var
  AEncData: PAnsiChar;
  AEncSize: integer;
begin
  try
    uEDCode.EncodeData(AHeader, SizeOf(TPackDataHeader), _HKey, AEncData,
      AEncSize);
    AStream.position := 0;
    AStream.WriteBuffer(AEncData^, AEncSize);
  finally
    FreeMem(AEncData, AEncSize);
  end;
end;

function TWMPackageImages.ReadImageInfo(AStream: TStream;
  APosition, Ver: integer): TPackDataImageInfo;
var
  AEncData, ADecData: PAnsiChar;
  ADecSize: integer;
begin
  AStream.position := APosition;
  case Ver of
    0:
      begin
        AStream.ReadBuffer(Result, SizeOf(TPackDataImageInfo));
      end;
    1:
      begin
        GetMem(AEncData, 22);
        try
          AStream.ReadBuffer(AEncData^, 22);
          uEDCode.DecodeData(AEncData^, 22, ADecData, ADecSize, _Key);
          Move(ADecData^, Result, SizeOf(TPackDataImageInfo));
        finally
          FreeMem(AEncData, 22);
          FreeMem(ADecData, ADecSize);
        end;
      end;
  end;
end;

procedure TWMPackageImages.WriteImageInfo(AStream: TStream;
  APosition, Ver: integer; AImageInfo: TPackDataImageInfo);
var
  AEncData: PAnsiChar;
  AEncSize: integer;
begin
  AStream.position := APosition;
  case Ver of
    0:
      begin
        AStream.WriteBuffer(AImageInfo, SizeOf(TPackDataImageInfo));
      end;
    1:
      begin
        try
          uEDCode.EncodeData(AImageInfo, SizeOf(TPackDataImageInfo), _Key,
            AEncData, AEncSize);
          AStream.WriteBuffer(AEncData^, AEncSize);
        finally
          FreeMem(AEncData, AEncSize);
        end;
      end;
  end;
end;

procedure TWMPackageImages.ChangePassword(const New: String);
begin
  if New <> FDataHeader.Password then
  begin
    FPassWord := New;
    if (New = '') or (FDataHeader.Password = '') then
      m_boNeedRebuild := True;
    FDataHeader.Password := New;
    BeginUpdate;
    EndUpdate;
  end;
end;

function TWMPackageImages.CheckImageInfoSize(AStream: TStream;
  APosition, Ver: integer): Boolean;
begin
  Result := True;
  case Ver of
    0:
      begin
        Result := APosition + SizeOf(TPackDataImageInfo) <= AStream.Size;
      end;
    1:
      begin
        Result := APosition + 22 <= AStream.Size;
      end;
  end;
end;

function TWMPackageImages.Replace(Index: integer; Graphic: TGraphic;
  X, Y: integer; AGraphicType: TGraphicType): Boolean;
var
  nSize: integer;
  ImageInfo: TPackDataImageInfo;
  ABuf: PAnsiChar;
  DDIB: TDIB;
  Mem: TMemoryStream;
  Png: TPngImage;
begin
  if (Graphic <> nil) and not Graphic.Empty then
  begin

    if Graphic is TDIB then
    begin
      DDIB := Graphic as TDIB;
      try
        CompressBufZ(DDIB.PBits, DDIB.Size, ABuf, nSize);
        ImageInfo.nWidth := DDIB.Width;
        ImageInfo.nHeight := DDIB.Height;
        ImageInfo.px := X;
        ImageInfo.py := Y;
        ImageInfo.BitCount := DDIB.BitCount;
        ImageInfo.nSize := nSize;
        ImageInfo.GraphicType := AGraphicType;

        m_IndexList[Index] := FDataHeader.IndexOffSet;
        WriteImageInfo(m_FileStream, FDataHeader.IndexOffSet,
          FDataHeader.XVersion, ImageInfo);
        m_FileStream.Write(ABuf^, ImageInfo.nSize);
        FDataHeader.IndexOffSet := m_FileStream.position;
      finally
        FreeMem(ABuf);
      end;

    end
    else if Graphic is TPngImage then
    begin
      Png := Graphic as TPngImage;

      ImageInfo.nWidth := Png.Width;
      ImageInfo.nHeight := Png.Height;
      ImageInfo.px := X;
      ImageInfo.py := Y;
      ImageInfo.GraphicType := AGraphicType;
      Mem := TMemoryStream.Create;
      Try
        Png.SaveToStream(Mem);
        ImageInfo.nSize := Mem.Size;

        m_IndexList[Index] := FDataHeader.IndexOffSet;
        WriteImageInfo(m_FileStream, FDataHeader.IndexOffSet,
          FDataHeader.XVersion, ImageInfo);
        m_FileStream.Write(Mem.Memory^, ImageInfo.nSize);
        FDataHeader.ImageCount := FDataHeader.ImageCount + 1;
        FDataHeader.IndexOffSet := m_FileStream.position;
        m_FileStream.Write(Mem.Memory^, ImageInfo.nSize);
      Finally
        Mem.Free;
      End;
    end;

  end
  else
  begin
    if (X <> 0) or (Y <> 0) then
    begin
      ImageInfo.nWidth := 0;
      ImageInfo.nHeight := 0;
      ImageInfo.px := X;
      ImageInfo.py := Y;
      ImageInfo.BitCount := 16;
      ImageInfo.nSize := 0;
      m_IndexList[Index] := FDataHeader.IndexOffSet;
      WriteImageInfo(m_FileStream, FDataHeader.IndexOffSet,
        FDataHeader.XVersion, ImageInfo);
      FDataHeader.IndexOffSet := m_FileStream.position;
    end
    else
      m_IndexList[Index] := 0;
  end;
  m_boNeedRebuild := True;
  Result := True;
end;

procedure TWMPackageImages.SetGraphicType(Index: integer;
  const Value: TGraphicType);
var
  ImageInfo: TPackDataImageInfo;
begin
  ImageInfo := ReadImageInfo(m_FileStream, m_IndexList[index],
    FDataHeader.XVersion);
  ImageInfo.GraphicType := Value;
  WriteImageInfo(m_FileStream, m_IndexList[index], FDataHeader.XVersion,
    ImageInfo);
end;

procedure TWMPackageImages.SetPos(index, px, py: integer);
var
  ImageInfo: TPackDataImageInfo;
begin
  ImageInfo := ReadImageInfo(m_FileStream, m_IndexList.Items[index],
    FDataHeader.XVersion);
  ImageInfo.px := px;
  ImageInfo.py := py;
  WriteImageInfo(m_FileStream, m_IndexList.Items[index], FDataHeader.XVersion,
    ImageInfo);
end;

{ TWMImages2 }

procedure TWZLImages.DoGetImgSize(position: integer;
  var AWidth, AHeight: integer);
var
  ImageInfo: TWZLImageInfo;
begin
  AWidth := 0;
  AHeight := 0;
  if position + SizeOf(TWZLImageInfo) <= m_FileStream.Size then
  begin
    m_FileStream.Seek(position, 0);
    m_FileStream.Read(ImageInfo, SizeOf(TWZLImageInfo));
    AWidth := ImageInfo.m_nWidth;
    AHeight := ImageInfo.m_nHeight;
  end;
end;

function TWZLImages.Add(DIB: TGraphic; X, Y: integer;
  AGraphicType: TGraphicType): Boolean;
var
  ImageInfo: TWZLImageInfo;
  nSize: integer;
  Buf: PAnsiChar;
  DDIB: TDIB;
begin
  FillChar(ImageInfo, SizeOf(TWZLImageInfo), #0);
  if (DIB <> nil) and not DIB.Empty then
  begin
    if DIB is TDIB then
    begin
      DDIB := DIB as TDIB;

      DDIB.Mirror(False, True);
      CompressBufZ(DDIB.PBits, DDIB.Size, Buf, nSize);
      try
        case DDIB.BitCount of
          8:
            ImageInfo.m_Enc1 := 3;
          16:
            ImageInfo.m_Enc1 := 5;
          24:  ImageInfo.m_Enc1 := 6;
          32:  ImageInfo.m_Enc1 := 7;
        end;
        ImageInfo.m_nWidth := DDIB.Width;
        ImageInfo.m_nHeight := DDIB.Height;
        ImageInfo.m_wPx := X;
        ImageInfo.m_wPy := Y;
        ImageInfo.m_Len := nSize;

        m_FileStream.position := m_FileStream.Size;
        m_IndexList.Add(m_FileStream.position);
        FHeader.IndexCount := FHeader.IndexCount + 1;
        m_FileStream.Write(ImageInfo, SizeOf(TWZLImageInfo));
        m_FileStream.Write(Buf^, ImageInfo.m_Len);
      finally
        FreeMem(Buf);
      end;
    end;
  end
  else
  begin
    if (X <> 0) or (Y <> 0) then
    begin
      ImageInfo.m_wPx := X;
      ImageInfo.m_wPy := Y;
      m_FileStream.position := m_FileStream.Size;
      m_IndexList.Add(m_FileStream.position);
      m_FileStream.Write(ImageInfo, SizeOf(TWZLImageInfo));
    end
    else
      m_IndexList.Add(0);
    FHeader.IndexCount := FHeader.IndexCount + 1;
  end;
  Result := True;
end;

procedure TWZLImages.BeginUpdate;
begin
  inherited;

end;

class procedure TWZLImages.CreateNewFile(const FileName: String);
const
  _TITLE: array [0 .. 18] of AnsiChar =
    #$77#$77#$77#$2E#$73#$68#$61#$6E#$64#$61#$67#$61#$6D#$65#$73#$2E#$63#$6F#$6D;
var
  AFile, AIndexFile: TFileStream;
  AIdxfile: string;
  AHeader: TWZLImageHeader;
  AIndexHeader: TWZLIndexHeader;
begin
  AIdxfile := ChangeFileExt(FileName, '.wzx');
  AFile := TFileStream.Create(FileName, fmCreate);
  AIndexFile := TFileStream.Create(AIdxfile, fmCreate);
  try
    FillChar(AHeader, SizeOf(TWZLImageHeader), #0);
    FillChar(AIndexHeader, SizeOf(TWZLIndexHeader), #0);
    Move(_TITLE[0], AHeader.Title[0], Length(_TITLE));
    Move(_TITLE[0], AIndexHeader.Title[0], Length(_TITLE));
    AHeader.IndexCount := 0;
    AFile.Write(AHeader, SizeOf(TWZLImageHeader));
    AIndexFile.Write(AIndexHeader, SizeOf(TWZLIndexHeader));
  finally
    AFile.Free;
    AIndexFile.Free;
  end;
end;

procedure TWZLImages.DoGetImgSize(position: integer;
  var AWidth, AHeight, px, py: integer);
var
  ImageInfo: TWZLImageInfo;
begin
  AWidth := 0;
  AHeight := 0;
  px := 0;
  py := 0;
  if position + SizeOf(TWZLImageInfo) <= m_FileStream.Size then
  begin
    m_FileStream.Seek(position, 0);
    m_FileStream.Read(ImageInfo, SizeOf(TWZLImageInfo));
    AWidth := ImageInfo.m_nWidth;
    AHeight := ImageInfo.m_nHeight;
    px := ImageInfo.m_wPx;
    py := ImageInfo.m_wPy;
  end;
end;

procedure TWZLImages.EndUpdate;
var
  i, nPosition: integer;
  ATempFileName, Idxfile: String;
  ATempFile: TFileStream;
  ImageInfo: TWZLImageInfo;
  ABuffer: PAnsiChar;
  IdxHeader: TWZLIndexHeader;
begin
  if m_boNeedRebuild then
  begin
    ATempFileName := IOUtils.TPath.GetTempFileName;
    ATempFile := TFileStream.Create(ATempFileName, fmCreate);
    try
      // 写入头
      FHeader.IndexCount := m_IndexList.Count;
      ATempFile.WriteBuffer(FHeader, SizeOf(TWZLImageHeader));
      // 写入资源
      for i := 0 to m_IndexList.Count - 1 do
      begin
        nPosition := m_IndexList[i];
        if nPosition > 0 then
        begin
          m_IndexList[i] := ATempFile.position;
          m_FileStream.position := nPosition;
          m_FileStream.ReadBuffer(ImageInfo, SizeOf(TWZLImageInfo));
          ATempFile.WriteBuffer(ImageInfo, SizeOf(TWZLImageInfo));
          if ImageInfo.m_Len > 0 then
          begin
            GetMem(ABuffer, ImageInfo.m_Len);
            try
              m_FileStream.ReadBuffer(ABuffer^, ImageInfo.m_Len);
              ATempFile.WriteBuffer(ABuffer^, ImageInfo.m_Len);
            finally
              FreeMem(ABuffer);
            end;
          end;
        end;
      end;
      // 将临时文件写到当前资源文件
      m_FileStream.Size := 0;
      m_FileStream.position := 0;
      ATempFile.position := 0;
      m_FileStream.CopyFrom(ATempFile, ATempFile.Size);
    finally
      ATempFile.Free;
      IOUtils.TFile.Delete(ATempFileName);
    end;
  end
  else
  begin
    m_FileStream.position := 0;
    m_FileStream.WriteBuffer(FHeader, SizeOf(TWZLImageHeader));
  end;
  // 重写Idx文件
  Idxfile := ChangeFileExt(FFileName, '.WZX');
  ATempFile := TFileStream.Create(Idxfile, fmCreate);
  try
    IdxHeader.Title := FHeader.Title;
    IdxHeader.IndexCount := m_IndexList.Count;
    ATempFile.WriteBuffer(IdxHeader, SizeOf(TWZLIndexHeader));
    for i := 0 to m_IndexList.Count - 1 do
    begin
      nPosition := m_IndexList.Items[i];
      ATempFile.Write(nPosition, SizeOf(integer));
    end;
  finally
    ATempFile.Free;
  end;
  m_boNeedRebuild := False;
  Finalize;
  Initialize;
end;

function TWZLImages.GetGraphicType(Index: integer): TGraphicType;
var
  nPosition: integer;
  ImageInfo: TWZLImageInfo;
begin
  Result := gtDIB;
  nPosition := m_IndexList[index];
  if nPosition + SizeOf(TWZLImageInfo) <= m_FileStream.Size then
  begin
    m_FileStream.Seek(nPosition, 0);
    m_FileStream.Read(ImageInfo, SizeOf(TWZLImageInfo));
    if ImageInfo.m_Enc2 = 9 then
      Result := gtPng;
  end;
end;

procedure TWZLImages.Initialize;
var
  Idxfile: string;
begin
  inherited;

  if m_FileStream = nil then
    m_FileStream := TFileStream.Create(FFileName, fmOpenReadWrite or
      fmShareDenyNone);
  m_FileStream.Read(FHeader, SizeOf(TWZLImageHeader));
  FImageCount := FHeader.IndexCount;

  m_BmpArr := AllocMem(SizeOf(TBmpImage) * FImageCount);
  Idxfile := ChangeFileExt(FFileName, '.WZX');
  LoadIndex(Idxfile);
end;

function TWZLImages.Insert(Index: integer; DIB: TGraphic; X, Y: integer;
  AGraphicType: TGraphicType): Boolean;
var
  nSize: integer;
  ImageInfo: TWZLImageInfo;
  ABuf: PAnsiChar;
  DDIB: TDIB;
begin
  FillChar(ImageInfo, SizeOf(TWZLImageInfo), #0);
  if (DIB <> nil) and not DIB.Empty then
  begin
    if DIB is TDIB then
    begin
      DDIB := DIB as TDIB;
      DDIB.Mirror(False, True);
      CompressBufZ(DDIB.PBits, DDIB.Size, ABuf, nSize);
      try
        case DDIB.BitCount of
          8:
            ImageInfo.m_Enc1 := 3;
          16:
            ImageInfo.m_Enc1 := 5;
          24:  ImageInfo.m_Enc1 := 6;
          32:  ImageInfo.m_Enc1 := 7;
        end;
        ImageInfo.m_nWidth := DDIB.Width;
        ImageInfo.m_nHeight := DDIB.Height;
        ImageInfo.m_wPx := X;
        ImageInfo.m_wPy := Y;
        ImageInfo.m_Len := nSize;

        m_FileStream.position := m_FileStream.Size;
        m_IndexList.Insert(Index, m_FileStream.position);
        FHeader.IndexCount := FHeader.IndexCount + 1;
        m_FileStream.Write(ImageInfo, SizeOf(TWZLImageInfo));
        m_FileStream.Write(ABuf^, ImageInfo.m_Len);
      finally
        FreeMem(ABuf);
      end;
    end;
  end
  else
  begin
    if (X <> 0) or (Y <> 0) then
    begin
      ImageInfo.m_wPx := X;
      ImageInfo.m_wPy := Y;
      m_FileStream.position := m_FileStream.Size;
      m_IndexList.Insert(Index, m_FileStream.position);
      m_FileStream.Write(ImageInfo, SizeOf(TPackDataImageInfo));
    end
    else
      m_IndexList.Insert(Index, 0);
    FHeader.IndexCount := FHeader.IndexCount + 1;
  end;
  Result := True;
end;

procedure TWZLImages.LoadBmpImage(position: integer; var ADIB: TGraphic);
var
  ABitFormat: TPixelFormat;
  ImageInfo: TWZLImageInfo;
  DBits, PInBits, ALineBuf: PAnsiChar;
  OutSize: integer;
  AMaxLineSize, ACurLineSize, i, BitSize: integer;
  DIB : TDIB;
begin
  ADIB := nil;
  if position = 0 then
    Exit;

  if position + SizeOf(TWZLImageInfo) <= m_FileStream.Size then
  begin
    m_FileStream.Seek(position, 0);
    m_FileStream.Read(ImageInfo, SizeOf(TWZLImageInfo));
    BitSize := 16;
    ABitFormat := pf16bit;
    case ImageInfo.m_Enc1 of
      3:
        begin
          ABitFormat := pf8bit;
          BytesPerPixe := 1;
          BitSize := 8;
        end;
      5:
        begin
          ABitFormat := pf16bit;
          BytesPerPixe := 2;
          BitSize := 16;
        end;
      6:begin
          ABitFormat := pf24bit;
          BytesPerPixe := 3;
          BitSize := 24;
       end;
       7:begin
          ABitFormat := pf32bit;
          BytesPerPixe := 4;
          BitSize := 32;
       end;
    end;

    FWzlImageInfo := ImageInfo;

    DIB := TDIB.Create;
    ChangeDIBPixelFormat(DIB, ABitFormat);
    DIB.Width := ImageInfo.m_nWidth;
    DIB.Height := ImageInfo.m_nHeight;
    case ABitFormat of
      pf8bit:
        begin
          DIB.ColorTable := Bit8MainPalette;
          DIB.UpdatePalette;
        end;
    end;
    if ImageInfo.m_Len > 0 then
    begin
      if ImageInfo.m_Len + m_FileStream.position <= m_FileStream.Size then
      begin
        GetMem(PInBits, ImageInfo.m_Len);
        try
          AMaxLineSize := WidthBytes(ImageInfo.m_nWidth, BitSize);
          m_FileStream.Read(PInBits^, ImageInfo.m_Len);
          DecompressBufZ(PInBits, ImageInfo.m_Len, 0, DBits, OutSize);
          for i := 0 to ImageInfo.m_nHeight - 1 do
          begin
            ALineBuf := DIB.ScanLine[i];
            ACurLineSize := Min(AMaxLineSize, OutSize);
            OutSize := OutSize - ACurLineSize;
            Move(DBits[(ImageInfo.m_nHeight - 1 - i) * AMaxLineSize],
              ALineBuf[0], ACurLineSize);
          end;
        finally
          FreeMem(PInBits, ImageInfo.m_Len);
          FreeMem(DBits);
        end;
      end;
    end
    else
    begin
      if ImageInfo.m_nWidth * ImageInfo.m_nHeight * BytesPerPixe +
        m_FileStream.position <= m_FileStream.Size then
      begin
        DBits := DIB.PBits;
        m_FileStream.Read(DBits^, ImageInfo.m_nWidth * ImageInfo.m_nHeight *
          BytesPerPixe);
      end;
    end;
  end;

  ADIB := DIB;
end;

procedure TWZLImages.LoadIndex(const FileName: string);
var
  fhandle, i, Value: integer;
  IdxHeader: TWZLIndexHeader;
  pvalue: PInteger;
begin
  if FileExists(FileName) then
  begin
    fhandle := FileOpen(FileName, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then
    begin
      FileRead(fhandle, IdxHeader, SizeOf(TWZLIndexHeader));
      FImageCount := IdxHeader.IndexCount;
      GetMem(pvalue, 4 * IdxHeader.IndexCount);
      FileRead(fhandle, pvalue^, 4 * IdxHeader.IndexCount);
      for i := 0 to IdxHeader.IndexCount - 1 do
      begin
        Value := PInteger(integer(pvalue) + 4 * i)^;
        m_IndexList.Add(Value);
      end;
      FreeMem(pvalue);
    end;
    FileClose(fhandle);
  end;
end;

function TWZLImages.Replace(Index: integer; DIB: TGraphic; X, Y: integer;
  AGraphicType: TGraphicType): Boolean;
var
  nSize: integer;
  ImageInfo: TWZLImageInfo;
  ABuf: PAnsiChar;
  DDIB: TDIB;
begin
  FillChar(ImageInfo, SizeOf(TWZLImageInfo), #0);
  if (DIB <> nil) and not DIB.Empty then
  begin
    if DIB is TDIB then
    begin
      DDIB := DIB as TDIB;
      DDIB.Mirror(False, True);
      CompressBufZ(DDIB.PBits, DDIB.Size, ABuf, nSize);
      try
        case DDIB.BitCount of
          8:
            ImageInfo.m_Enc1 := 3;
          16:
            ImageInfo.m_Enc1 := 5;
          24:  ImageInfo.m_Enc1 := 6;
          32:  ImageInfo.m_Enc1 := 7;
        end;
        ImageInfo.m_nWidth := DDIB.Width;
        ImageInfo.m_nHeight := DDIB.Height;
        ImageInfo.m_wPx := X;
        ImageInfo.m_wPy := Y;
        ImageInfo.m_Len := nSize;

        m_FileStream.position := m_FileStream.Size;
        m_IndexList[Index] := m_FileStream.position;
        m_FileStream.Write(ImageInfo, SizeOf(TWZLImageInfo));
        m_FileStream.Write(ABuf^, ImageInfo.m_Len);
      finally
        FreeMem(ABuf);
      end;
    end;
  end
  else
  begin
    if (X <> 0) or (Y <> 0) then
    begin
      ImageInfo.m_wPx := X;
      ImageInfo.m_wPy := Y;
      m_FileStream.position := m_FileStream.Size;
      m_IndexList[Index] := m_FileStream.position;
      m_FileStream.Write(ImageInfo, SizeOf(TPackDataImageInfo));
    end
    else
      m_IndexList[Index] := 0;
  end;
  Result := True;
  m_boNeedRebuild := True;
end;

procedure TWZLImages.SetGraphicType(Index: integer; const Value: TGraphicType);
var
  ImageInfo: TWZLImageInfo;
begin
  m_FileStream.position := m_IndexList.Items[index];
  m_FileStream.Read(ImageInfo, SizeOf(TWZLImageInfo));
  case Value of
    gtDIB:
      ImageInfo.m_Enc2 := 1;
    gtPng:
      ImageInfo.m_Enc2 := 9;
  end;
  m_FileStream.position := m_IndexList.Items[Index];
  m_FileStream.Write(ImageInfo, SizeOf(TWZLImageInfo));
end;

procedure TWZLImages.SetPos(index, px, py: integer);
var
  ImageInfo: TWZLImageInfo;
begin
  m_FileStream.position := m_IndexList.Items[index];
  m_FileStream.Read(ImageInfo, SizeOf(TWZLImageInfo));
  ImageInfo.m_wPx := px;
  ImageInfo.m_wPy := py;
  m_FileStream.position := m_IndexList.Items[Index];
  m_FileStream.Write(ImageInfo, SizeOf(TWZLImageInfo));
end;

procedure TWMPackageImages.DoGetImgSize(position: integer;
  var AWidth, AHeight, px, py: integer; var AGraphicType: TGraphicType);
var
  ImageInfo: TPackDataImageInfo;
begin
  AWidth := 0;
  AHeight := 0;
  px := 0;
  py := 0;
  if CheckImageInfoSize(m_FileStream, position, FDataHeader.XVersion) then
  begin
    ImageInfo := ReadImageInfo(m_FileStream, position, FDataHeader.XVersion);
    AWidth := ImageInfo.nWidth;
    AHeight := ImageInfo.nHeight;
    px := ImageInfo.px;
    py := ImageInfo.py;
    AGraphicType := ImageInfo.GraphicType;
  end;
end;

{ TWMImages }

procedure TWMImages.BeginUpdate;
begin

end;

procedure TWMImages.ChangePassword(const New: String);
begin

end;

constructor TWMImages.Create;
begin
  btVersion := 0;
  FFileName := '';
  FImageCount := 0;
  m_dwMemChecktTick := GetTickCount;
  m_boNeedRebuild := False;
  FEditing := True;
  FValidated := True;

  m_FileStream := nil;
  m_BmpArr := nil;
  m_IndexList := TList<integer>.Create;
end;

class procedure TWMImages.CreateNewFile(const FileName: String);
begin
end;

destructor TWMImages.Destroy;
begin
  m_IndexList.Clear;
  m_IndexList.Free;
//  Finalize;
  if m_FileStream <> nil then
    FreeAndNil(m_FileStream);
  inherited;
end;

procedure TWMImages.DoGetImgSize(position: integer;
  var AWidth, AHeight: integer);
begin

end;

procedure TWMImages.DoGetImgSize(position: integer;
  var AWidth, AHeight, px, py: integer);
begin

end;

procedure TWMImages.DoGetImgSize(position: integer;
  var AWidth, AHeight, px, py: integer; var AGraphicType: TGraphicType);
begin

end;

procedure TWMImages.FreeOldBmps;
var
  i, n, ntime, curtime, limit: integer;
begin
  n := -1;
  ntime := 0;
  // limit := FMaxMemorySize * 9 div 10;
  for i := 0 to ImageCount - 1 do
  begin
    curtime := GetTickCount;
    if m_BmpArr[i].DIB <> nil then
    begin
      if GetTickCount - m_BmpArr[i].dwLatestTime > 5 * 1000 then
      begin
        m_BmpArr[i].DIB.Free;
        m_BmpArr[i].DIB := nil;
        if m_BmpArr[i].MirrorXDIB <> nil then
        begin
          m_BmpArr[i].MirrorXDIB.Free;
          m_BmpArr[i].MirrorXDIB := nil;
        end;
      end
      else
      begin
        if GetTickCount - m_BmpArr[i].dwLatestTime > ntime then
        begin
          ntime := GetTickCount - m_BmpArr[i].dwLatestTime;
          n := i;
        end;
      end;
    end;
  end;
end;

//function TWMImages.GetGraphic(Index: integer): TGraphic;
//var
//  APosition: integer;
//  ImageInfo: TPackDataImageInfo;
//  GType : TGraphicType;
//  DIB : TDIB;
//begin
//  Result := nil;
//  GType := GetGraphicType(Index);
//  case GType of
//    gtRealPng:
//    begin
//      APosition := m_IndexList[Index];
//      LoadGraphicImage(APosition,Result);
//    end else
//    begin
//      Try
//        APosition := m_IndexList[Index];
//        LoadBmpImage(APosition,DIB);
//        Result := DIB;
//      Except
//        //ShowMessage('获取图片资源异常: 图片序号:' +  IntToStr(Index) + ',为了我们更好的发展请 将文件提交给管理员');
//        Result := nil;
//      End;
//    end;
//  end;
//end;


function TWMImages.GetGraphic(Index: integer): TGraphic;
var
  position: integer;
  ImageInfo: TPackDataImageInfo;
  GType : TGraphicType;
begin
  Result := nil;
  if Self = nil then
    Exit;
  if (index < 0) or (index >= ImageCount) then
    Exit;

  GType := GetGraphicType(Index);
  case GType of
    gtRealPng:
    begin
      if m_BmpArr[index].DIB = nil then
      begin
        if index < m_IndexList.Count then
        begin
          position := m_IndexList[index];
          if position > 0 then
          begin
            LoadGraphicImage(position, m_BmpArr[index].DIB);
            m_BmpArr[index].dwLatestTime := GetTickCount;
            Result := m_BmpArr[index].DIB;
            FreeOldBmps;
          end;
        end;
      end
      else
      begin
        m_BmpArr[index].dwLatestTime := GetTickCount;
        Result := m_BmpArr[index].DIB;
      end;
    end else
    begin
      if m_BmpArr[index].DIB = nil then
      begin
        if index < m_IndexList.Count then
        begin
          position := m_IndexList[index];
          if position > 0 then
          begin
            tempindex := index;
            LoadBmpImage(position, m_BmpArr[index].DIB);
            m_BmpArr[index].dwLatestTime := GetTickCount;
            Result := m_BmpArr[index].DIB;
//            FreeOldBmps;
          end;
        end;
      end
      else
      begin
        m_BmpArr[index].dwLatestTime := GetTickCount;
        Result := m_BmpArr[index].DIB;
      end;
    end;
  end;


end;


function TWMImages.GetGraphicType(Index: integer): TGraphicType;
begin
  Result := gtDIB;
end;

function TWMImages.GetImageBitmap(Index: integer): TDIB;
var
  position: integer;
begin
  Result := nil;
  if Self = nil then
    Exit;
  if (index < 0) or (index >= ImageCount) then
    Exit;

  if m_BmpArr[index].DIB = nil then
  begin
    if index < m_IndexList.Count then
    begin
      position := m_IndexList[index];
      if position > 0 then
      begin
        LoadBmpImage(position, m_BmpArr[index].DIB);
        m_BmpArr[index].dwLatestTime := GetTickCount;
        Result := m_BmpArr[index].DIB as TDIB;
        FreeOldBmps;
      end;
    end;
  end
  else
  begin
    m_BmpArr[index].dwLatestTime := GetTickCount;
    Result := m_BmpArr[index].DIB as TDIB;
  end;
end;

function TWMImages.GetImageMirrorXBitmap(Index: integer): TDIB;
var
  position: integer;
begin
  Result := nil;
  if Self = nil then
    Exit;
  if (index < 0) or (index >= ImageCount) then
    Exit;

  if m_BmpArr[index].MirrorXDIB = nil then
  begin
    if index < m_IndexList.Count then
    begin
      position := m_IndexList[index];
      if position > 0 then
      begin
        LoadBmpImage(position, m_BmpArr[index].MirrorXDIB);
        m_BmpArr[index].dwLatestTime := GetTickCount;
        TDIB(m_BmpArr[index].MirrorXDIB).Mirror(True, False);
        Result := m_BmpArr[index].MirrorXDIB as TDIB;
        FreeOldBmps;
      end;
    end;
  end
  else
  begin
    m_BmpArr[index].dwLatestTime := GetTickCount;
    Result := m_BmpArr[index].MirrorXDIB as  TDIB;
  end;
end;

function TWMImages.GetImgSize(index: integer;
  var AWidth, AHeight: integer): Boolean;
var
  nPosition: integer;
begin
  Result := False;
  if (index < 0) or (index >= ImageCount) then
    Exit;
  nPosition := m_IndexList[index];
  if nPosition > 0 then
    DoGetImgSize(nPosition, AWidth, AHeight)
  else
  begin
    AWidth := 0;
    AHeight := 0;
  end;
  Result := True;
end;

function TWMImages.GetImgSize(index: integer;
  var AWidth, AHeight, px, py: integer): Boolean;
var
  nPosition: integer;
begin
  Result := False;
  if (index < 0) or (index >= ImageCount) then
    Exit;
  nPosition := m_IndexList[index];
  if nPosition > 0 then
    DoGetImgSize(nPosition, AWidth, AHeight, px, py)
  else
  begin
    AWidth := 0;
    AHeight := 0;
    px := 0;
    py := 0;
  end;
  Result := True;
end;

function TWMImages.GetImgSize(index: integer;
  var AWidth, AHeight, px, py: integer; var AGraphicType: TGraphicType)
  : Boolean;
var
  nPosition: integer;
begin
  Result := False;
  if (index < 0) or (index >= ImageCount) then
    Exit;
  nPosition := m_IndexList[index];
  if nPosition > 0 then
    DoGetImgSize(nPosition, AWidth, AHeight, px, py)
  else
  begin
    AWidth := 0;
    AHeight := 0;
    AGraphicType := gtDIB;
    px := 0;
    py := 0;
  end;
  Result := True;
end;

procedure TWMImages.Initialize;
begin
  if FFileName = '' then
    raise Exception.Create('FileName not assigned..');

  if not FileExists(FFileName) then
    raise Exception.Create('File not found:' + FFileName);
end;

procedure TWMImages.LoadAllData;
begin

end;

procedure TWMImages.LoadBmpImage(position: integer; var ADIB: TGraphic);
begin
end;

procedure TWMImages.LoadGraphicImage(position: integer; var Graphic: TGraphic);
begin

end;

procedure TWMImages.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

procedure TWMImages.SetGraphicType(Index: integer; const Value: TGraphicType);
begin

end;

procedure TWMImages.SetPos(index, px, py: integer);
begin

end;

procedure TWZLImages.DoGetImgSize(position: integer;
  var AWidth, AHeight, px, py: integer; var AGraphicType: TGraphicType);
var
  ImageInfo: TWZLImageInfo;
begin
  AWidth := 0;
  AHeight := 0;
  px := 0;
  py := 0;
  if position + SizeOf(TWZLImageInfo) <= m_FileStream.Size then
  begin
    m_FileStream.Seek(position, 0);
    m_FileStream.Read(ImageInfo, SizeOf(TWZLImageInfo));
    AWidth := ImageInfo.m_nWidth;
    AHeight := ImageInfo.m_nHeight;
    px := ImageInfo.m_wPx;
    py := ImageInfo.m_wPy;
    AGraphicType := gtDIB;
    if ImageInfo.m_Enc2 = 9 then
      AGraphicType := gtPng;
  end;
end;

const
  ColorArray: array[0..1023] of Byte = (
    $00, $00, $00, $00, $00, $00, $80, $00, $00, $80, $00, $00, $00, $80, $80, $00,
    $80, $00, $00, $00, $80, $00, $80, $00, $80, $80, $00, $00, $C0, $C0, $C0, $00,
    $97, $80, $55, $00, $C8, $B9, $9D, $00, $73, $73, $7B, $00, $29, $29, $2D, $00,
    $52, $52, $5A, $00, $5A, $5A, $63, $00, $39, $39, $42, $00, $18, $18, $1D, $00,
    $10, $10, $18, $00, $18, $18, $29, $00, $08, $08, $10, $00, $71, $79, $F2, $00,
    $5F, $67, $E1, $00, $5A, $5A, $FF, $00, $31, $31, $FF, $00, $52, $5A, $D6, $00,
    $00, $10, $94, $00, $18, $29, $94, $00, $00, $08, $39, $00, $00, $10, $73, $00,
    $00, $18, $B5, $00, $52, $63, $BD, $00, $10, $18, $42, $00, $99, $AA, $FF, $00,
    $00, $10, $5A, $00, $29, $39, $73, $00, $31, $4A, $A5, $00, $73, $7B, $94, $00,
    $31, $52, $BD, $00, $10, $21, $52, $00, $18, $31, $7B, $00, $10, $18, $2D, $00,
    $31, $4A, $8C, $00, $00, $29, $94, $00, $00, $31, $BD, $00, $52, $73, $C6, $00,
    $18, $31, $6B, $00, $42, $6B, $C6, $00, $00, $4A, $CE, $00, $39, $63, $A5, $00,
    $18, $31, $5A, $00, $00, $10, $2A, $00, $00, $08, $15, $00, $00, $18, $3A, $00,
    $00, $00, $08, $00, $00, $00, $29, $00, $00, $00, $4A, $00, $00, $00, $9D, $00,
    $00, $00, $DC, $00, $00, $00, $DE, $00, $00, $00, $FB, $00, $52, $73, $9C, $00,
    $4A, $6B, $94, $00, $29, $4A, $73, $00, $18, $31, $52, $00, $18, $4A, $8C, $00,
    $11, $44, $88, $00, $00, $21, $4A, $00, $10, $18, $21, $00, $5A, $94, $D6, $00,
    $21, $6B, $C6, $00, $00, $6B, $EF, $00, $00, $77, $FF, $00, $84, $94, $A5, $00,
    $21, $31, $42, $00, $08, $10, $18, $00, $08, $18, $29, $00, $00, $10, $21, $00,
    $18, $29, $39, $00, $39, $63, $8C, $00, $10, $29, $42, $00, $18, $42, $6B, $00,
    $18, $4A, $7B, $00, $00, $4A, $94, $00, $7B, $84, $8C, $00, $5A, $63, $6B, $00,
    $39, $42, $4A, $00, $18, $21, $29, $00, $29, $39, $46, $00, $94, $A5, $B5, $00,
    $5A, $6B, $7B, $00, $94, $B1, $CE, $00, $73, $8C, $A5, $00, $5A, $73, $8C, $00,
    $73, $94, $B5, $00, $73, $A5, $D6, $00, $4A, $A5, $EF, $00, $8C, $C6, $EF, $00,
    $42, $63, $7B, $00, $39, $56, $6B, $00, $5A, $94, $BD, $00, $00, $39, $63, $00,
    $AD, $C6, $D6, $00, $29, $42, $52, $00, $18, $63, $94, $00, $AD, $D6, $EF, $00,
    $63, $8C, $A5, $00, $4A, $5A, $63, $00, $7B, $A5, $BD, $00, $18, $42, $5A, $00,
    $31, $8C, $BD, $00, $29, $31, $35, $00, $63, $84, $94, $00, $4A, $6B, $7B, $00,
    $5A, $8C, $A5, $00, $29, $4A, $5A, $00, $39, $7B, $9C, $00, $10, $31, $42, $00,
    $21, $AD, $EF, $00, $00, $10, $18, $00, $00, $21, $29, $00, $00, $6B, $9C, $00,
    $5A, $84, $94, $00, $18, $42, $52, $00, $29, $5A, $6B, $00, $21, $63, $7B, $00,
    $21, $7B, $9C, $00, $00, $A5, $DE, $00, $39, $52, $5A, $00, $10, $29, $31, $00,
    $7B, $BD, $CE, $00, $39, $5A, $63, $00, $4A, $84, $94, $00, $29, $A5, $C6, $00,
    $18, $9C, $10, $00, $4A, $8C, $42, $00, $42, $8C, $31, $00, $29, $94, $10, $00,
    $10, $18, $08, $00, $18, $18, $08, $00, $10, $29, $08, $00, $29, $42, $18, $00,
    $AD, $B5, $A5, $00, $73, $73, $6B, $00, $29, $29, $18, $00, $4A, $42, $18, $00,
    $4A, $42, $31, $00, $DE, $C6, $63, $00, $FF, $DD, $44, $00, $EF, $D6, $8C, $00,
    $39, $6B, $73, $00, $39, $DE, $F7, $00, $8C, $EF, $F7, $00, $00, $E7, $F7, $00,
    $5A, $6B, $6B, $00, $A5, $8C, $5A, $00, $EF, $B5, $39, $00, $CE, $9C, $4A, $00,
    $B5, $84, $31, $00, $6B, $52, $31, $00, $D6, $DE, $DE, $00, $B5, $BD, $BD, $00,
    $84, $8C, $8C, $00, $DE, $F7, $F7, $00, $18, $08, $00, $00, $39, $18, $08, $00,
    $29, $10, $08, $00, $00, $18, $08, $00, $00, $29, $08, $00, $A5, $52, $00, $00,
    $DE, $7B, $00, $00, $4A, $29, $10, $00, $6B, $39, $10, $00, $8C, $52, $10, $00,
    $A5, $5A, $21, $00, $5A, $31, $10, $00, $84, $42, $10, $00, $84, $52, $31, $00,
    $31, $21, $18, $00, $7B, $5A, $4A, $00, $A5, $6B, $52, $00, $63, $39, $29, $00,
    $DE, $4A, $10, $00, $21, $29, $29, $00, $39, $4A, $4A, $00, $18, $29, $29, $00,
    $29, $4A, $4A, $00, $42, $7B, $7B, $00, $4A, $9C, $9C, $00, $29, $5A, $5A, $00,
    $14, $42, $42, $00, $00, $39, $39, $00, $00, $59, $59, $00, $2C, $35, $CA, $00,
    $21, $73, $6B, $00, $00, $31, $29, $00, $10, $39, $31, $00, $18, $39, $31, $00,
    $00, $4A, $42, $00, $18, $63, $52, $00, $29, $73, $5A, $00, $18, $4A, $31, $00,
    $00, $21, $18, $00, $00, $31, $18, $00, $10, $39, $18, $00, $4A, $84, $63, $00,
    $4A, $BD, $6B, $00, $4A, $B5, $63, $00, $4A, $BD, $63, $00, $4A, $9C, $5A, $00,
    $39, $8C, $4A, $00, $4A, $C6, $63, $00, $4A, $D6, $63, $00, $4A, $84, $52, $00,
    $29, $73, $31, $00, $5A, $C6, $63, $00, $4A, $BD, $52, $00, $00, $FF, $10, $00,
    $18, $29, $18, $00, $4A, $88, $4A, $00, $4A, $E7, $4A, $00, $00, $5A, $00, $00,
    $00, $88, $00, $00, $00, $94, $00, $00, $00, $DE, $00, $00, $00, $EE, $00, $00,
    $00, $FB, $00, $00, $94, $5A, $4A, $00, $B5, $73, $63, $00, $D6, $8C, $7B, $00,
    $D6, $7B, $6B, $00, $FF, $88, $77, $00, $CE, $C6, $C6, $00, $9C, $94, $94, $00,
    $C6, $94, $9C, $00, $39, $31, $31, $00, $84, $18, $29, $00, $84, $00, $18, $00,
    $52, $42, $4A, $00, $7B, $42, $52, $00, $73, $5A, $63, $00, $F7, $B5, $CE, $00,
    $9C, $7B, $8C, $00, $CC, $22, $77, $00, $FF, $AA, $DD, $00, $2A, $B4, $F0, $00,
    $9F, $00, $DF, $00, $B3, $17, $E3, $00, $F0, $FB, $FF, $00, $A4, $A0, $A0, $00,
    $80, $80, $80, $00, $00, $00, $FF, $00, $00, $FF, $00, $00, $00, $FF, $FF, $00,
    $FF, $00, $00, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $00, $FF, $FF, $FF, $00
  );


procedure Pixel565To32(Value: Word; var AResult: Cardinal);
 var
  R, G, B, A: Byte;
begin
  if Value <> 0 then
  begin
    R := Value and $F800 shr 8;
    G := Value and $07E0 shr 3;
    B := Value and $001F shl 3;
    A := $FF;
    AResult := B or (G shl 8) or (R shl 16) or (A shl 24);
  end else
  begin
    AResult := 0;
  end;
end;

procedure Pixel32To1555(Source: Cardinal; var Value: Word);
var
  AValue: Cardinal;
begin
  Value := 0;
  if Source > 0 then
  begin
    AValue := ((Source and $FF) * 31) div 255;
    AValue := AValue or ((((Source shr 8) and $FF) * 31) div 255) shl 5;
    AValue := AValue or ((((Source shr 16) and $FF) * 31) div 255) shl 10;
    AValue := AValue or (((Source shr 24) and $FF) div 255) shl 15;
  end;
  Value := AValue;
end;

function RGBToASPColor(RGB:TRGBQuad):Cardinal;
begin
  Result := RGB.rgbBlue or (RGB.rgbGreen shl 8) or (RGB.rgbRed shl 16) or ($FF000000);
end;

procedure BuildColorTable;
var
  I: Integer;
  ACardinal: Cardinal;
begin
  Move(ColorArray[0], Bit8MainPalette[0], SizeOf(ColorArray));
  for I := 0 to Length(ColorTable_565) - 1 do
  begin
    if Integer(Bit8MainPalette[I]) = 0 then
      ColorTable_565[I] := 0
    else
      ColorTable_565[I] := Word((Max(Bit8MainPalette[I].rgbRed and $F8, 8) shl 8)
      or (Max(Bit8MainPalette[I].rgbGreen and $FC, 8) shl 3)
      or (Max(Bit8MainPalette[I].rgbBlue and $F8, 8) shr 3));
  end;

  for I := Low(Word) to High(Word) do
    Pixel565To32(I, ColorTable_R5G6B5_32[I]);
  for I := Low(Word) to High(Word) do
    Pixel32To1555(ColorTable_R5G6B5_32[I], ColorTable_A1R5G5B5[I]);

  for i := 0 to High(ColorPalette) do
  begin
    ColorPalette[i] := RGBToASPColor(Bit8MainPalette[i]);
  end;

end;

procedure UnBuildColorTable;
begin
  Finalize(Bit8MainPalette);
  Finalize(ColorTable_565);
  Finalize(ColorTable_R5G6B5_32);
  Finalize(ColorTable_A1R5G5B5);
end;

initialization
  BuildColorTable;

finalization
  UnBuildColorTable;

end.

