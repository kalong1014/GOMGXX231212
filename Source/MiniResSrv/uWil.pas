unit uWil;

interface

uses
  Windows, Classes, SysUtils, Generics.Collections, RtcInfo, IOUtils, Math, uEDCode, ZLib;

const
  TYPE_IMG_WIL = 1;
  TYPE_IMG_WZL = 2;
  TYPE_IMG_DATA = 3;
  TYPE_ANY_FILE = 4;

  INT_SIZE = 4;

type
  TGraphicType = (gtDIB, gtPng, gtRealPng,gtNone);
  TExtractProgress = reference to procedure(Position, MaxValue: Integer);
  TImageItem = record
    Position: Integer;
    State: Byte; //0:未下载 1:下载中 2:下载成功     MINIServer: 0:未加载 1:已加载
    LastUpdate: LongWord;
    DataSize: Integer;
    Data: PAnsiChar;
  end;
  TImageArray = array[0..9999] of TImageItem;
  PTImageArray = ^TImageArray;

  TWMImages = class
  private
    m_FileStream: TFileStream;
    m_MemCheck: LongWord;
    FPassword: String;
    procedure FreeOldMemorys;
  protected
    procedure LoadImage(Index: Integer); virtual; abstract;
    procedure WriteImage(Index: Integer; Stream: TStream); virtual; abstract;
    procedure SaveIndexList; virtual; abstract;
  public
    _Type: Byte;
    FileName,
    RelativePath: String;
    ImageCount: Integer;
    ImageArray: PTImageArray;

    constructor Create;
    destructor Destroy; override;

    procedure BeginDownload(Index: Integer);
    procedure EndDownload(Index: Integer);
    procedure ResetDownload(Index: Integer);
    function CanDownload(Index: Integer): Boolean;

    function Position(Index: Integer): Integer;
    procedure Init; virtual; abstract;
    procedure Extract(Index: Integer; var DataSize: Integer);
    procedure ReadBuffer(Index: Integer; var AByteArray: RtcByteArray; APosition, ALength: Integer);
    procedure Write(Index: Integer; Stream: TStream);
    property Password: String read FPassword write FPassword;
  end;

  TWMImageHeader = record
    Title: String[40];
    ImageCount: integer;
    ColorCount: integer;
    PaletteSize: integer;
    VerFlag:integer;
  end;

  TWMIndexHeader = record
    Title: string[40];
    IndexCount: integer;
    VerFlag:integer;
  end;

  TWMImageInfo = record
    nWidth    :Word;
    nHeight   :Word;
    px: SmallInt;
    py: SmallInt;
    bits: PByte;
  end;

  TWILImages = class(TWMImages)
  private
    BytesPerPixe: Byte;
    Header: TWMImageHeader;
  protected
    procedure LoadImage(Index: Integer); override;
    procedure WriteImage(Index: Integer; Stream: TStream); override;
    procedure SaveIndexList; override;
  public
    procedure Init; override;
  end;

  TWZXIndexHeader = record
    Title: string[43];
    IndexCount: Integer;
  end;
  PWZXIndexHeader = ^TWZXIndexHeader;

  TWZLImageHeader = record
    Title: string[43];
    IndexCount: Integer;
    ColorCount: integer;
    PaletteSize: integer;
    VerFlag:integer;
    VerFlag1:integer;
  end;
  PWZLImageHeader = ^TWZLImageHeader;

  TWZLImageInfo = packed record //16
    m_Enc1: Byte; //1 3:8位  5:16位
    m_Enc2: Byte; //1 不清楚1
    m_type1: Byte; //1 不清楚
    m_type2: Byte; //1 不清楚0
    m_nWidth: SmallInt; //2 宽度
    m_nHeight: SmallInt; //2 高度
    m_wPx: SmallInt; //2 x
    m_wPy: SmallInt; //2 y
    m_Len: Cardinal; //4 压缩数据长度
  end;
  PWZLImageInfo = ^TWZLImageInfo;

  TWZLImages = class(TWMImages)
  protected
    procedure LoadImage(Index: Integer); override;
    procedure WriteImage(Index: Integer; Stream: TStream); override;
    procedure SaveIndexList; override;
  public
    procedure Init; override;
  end;

  TPackDataHeader = record //新定义的Data文件头
    Title: string[40];
    ImageCount: Integer;
    IndexOffSet: Integer;
    XVersion: Word;
    Password: String[16];
  end;
  pTPackDataHeader = ^TPackDataHeader;

  TPackDataImageInfo = packed record //新定义Data图片信息
    nWidth: Word;
    nHeight: Word;
    bitCount: Byte;
    Px: SmallInt;
    Py: SmallInt;
    nSize: LongWord; //数据大小
    GraphicType: TGraphicType; //0:DIB,BMP 1:PNG
  end;
  pTPackDataImageInfo = ^TPackDataImageInfo;

  TWMPackageImages = class(TWMImages)
  private
    const _HKey = '7BB2FA4F-2A6A-4632-B72F-F98D440E8C36';
    const _Key = 'CFBA39C1-72A6-4171-9FF0-CF1920DD76F3';
  private
    Header: TPackDataHeader;
    function ReadHeader: TPackDataHeader;
    function ReadImageInfo(APosition: Integer): TPackDataImageInfo;
    function CheckImageInfoSize(APosition: Integer): Boolean;
  protected
    procedure LoadImage(Index: Integer); override;
    procedure WriteImage(Index: Integer; Stream: TStream); override;
    procedure SaveIndexList; override;
  public
    class function ReadHeaderFromStream(F: TStream): TPackDataHeader;
    class procedure WriteHeaderToStream(F: TStream; AHeader: TPackDataHeader);
    procedure Init; override;
  end;

  TOnLog = procedure(const Value: String) of Object;
  TWMImagesManager = class
  private
    FImages: TObjectDictionary<String, TWMImages>;
    FOnLog: TOnLog;
    procedure Log(const Value: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearAllImages;

    function TryGet(const Name: String; out AImages: TWMImages): Boolean;
    procedure Add(const Password, FileName, AName: String);
    procedure WriteImage(const AFileName: String; Index: Integer; Stream: TStream; out Position: Integer);
    procedure WriteHeaders(Stream: TStream);
    procedure CreateOrUpdateWIL(const BaseDir, FileName: String; Header: TWMImageHeader);
    procedure CreateOrUpdateWZL(const BaseDir, FileName: String; Header: TWZLImageHeader);
    procedure CreateOrUpdateData(const BaseDir, FileName: String; Header: TPackDataHeader);
    property OnLog: TOnLog read FOnLog write FOnLog;
  end;

procedure CompressBufZ(const InBuf: PAnsiChar; InBytes: Integer;  out OutBuf: PAnsiChar; out OutBytes: Integer);
procedure DecompressBufZ(const inBuffer: PAnsiChar; inSize: Integer; outEstimate: Integer; out outBuffer: PAnsiChar; out outSize: Integer);

var
  ImagesManager: TWMImagesManager;

implementation

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

function _CreateImages(const AFileName: String): TWMImages;
var
  Ext, TmpFileName: String;
begin
  Result      :=  nil;
  TmpFileName :=  AFileName;
  Ext :=  UpperCase(ExtractFileExt(AFileName));
  if SameText(Ext, '.WIL') or SameText(Ext, '.WIS') then
    Result  :=  TWILImages.Create
  else if SameText(Ext, '.WZL') then
    Result  :=  TWZLImages.Create
  else if SameText(Ext, '.DATA') then
    Result  :=  TWMPackageImages.Create;
end;

function ExtractFileNameOnly(const fname: string): string;
var
  extpos: Integer;
  ext, fn: string;
begin
  ext := ExtractFileExt(fname);
  fn := ExtractFileName(fname);
  if ext <> '' then begin
    extpos := Pos(ext, fn);
    Result := Copy(fn, 1, extpos - 1);
  end else
    Result := fn;
end;

{TWILImages}

procedure TWILImages.Init;
var
  IdxFileName: string;
  i, Value, BufSize: integer;
  IdxFile: TFileStream;
  IdxHeader: TWMIndexHeader;
  Buff: PAnsiChar;
begin
  m_FileStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  m_FileStream.Position := 0;
  _Type := TYPE_IMG_WIL;
  m_FileStream.Read(Header, SizeOf(TWMImageHeader));
  ImageCount := Header.ImageCount;
  if Header.ColorCount = 256 then
    BytesPerPixe := 1
  else if header.ColorCount = 65536 then
    BytesPerPixe := 2
  else if header.colorcount = 16777216 then
    BytesPerPixe := 4
  else if header.ColorCount > 16777216 then
    BytesPerPixe := 4;
  IdxFileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.WIX';

  if (IdxFileName<>'') and FileExists(IdxFileName) then
  begin
    IdxFile := TFileStream.Create(IdxFileName, fmOpenRead or fmShareDenyNone);
    try
      if header.VerFlag <> 0 then
        IdxFile.ReadBuffer(IdxHeader, sizeof(TWMIndexHeader) - 4)
      else
        IdxFile.ReadBuffer(IdxHeader, sizeof(TWMIndexHeader));
      ImageArray := AllocMem(SizeOf(TImageItem) * ImageCount);

      BufSize := IdxFile.Size - IdxFile.Position;
      if BufSize > 0 then
      begin
        GetMem(Buff, BufSize);
        try
          IdxFile.ReadBuffer(Buff^, BufSize);
          I := 0;
          while True do
          begin
            Move(Buff[I * 4], Value, INT_SIZE);
            ImageArray[I].Position := Value;
            ImageArray[I].DataSize := 0;
            ImageArray[I].State := 0;
            Inc(I);
            if (I * 4 > BufSize) or (I >= ImageCount) then
              Break;
          end;
        finally
          FreeMem(Buff);
        end;
      end;
    finally
      IdxFile.Free;
    end;
  end;
end;

procedure TWILImages.LoadImage(Index: Integer);
var
  AImageInfo: TWMImageInfo;
  Buf, ZBuf: PAnsiChar;
  DataSize, ZBufSize, BufSize: Integer;
begin
  if m_FileStream.Size >= ImageArray[Index].Position then
  begin
    m_FileStream.Seek(ImageArray[Index].Position, 0);
    if header.VerFlag <> 0 then
      m_FileStream.Read(AImageInfo, Sizeof(TWMImageInfo) - 4)
    else
      m_FileStream.Read(AImageInfo, Sizeof(TWMImageInfo));
    DataSize := Max(0, AImageInfo.nWidth * AImageInfo.nHeight * BytesPerPixe);
    BufSize := DataSize + SizeOf(TWMImageInfo);
    if m_FileStream.Size >= m_FileStream.Position + DataSize then
    begin
      GetMem(Buf, BufSize);
      try
        Move(AImageInfo, Buf[0], SizeOf(TWMImageInfo));
        if DataSize > 0 then
          m_FileStream.ReadBuffer(Buf[SizeOf(TWMImageInfo)], DataSize);
        try
          CompressBufZ(Buf, BufSize, ZBuf, ZBufSize);
          ImageArray[Index].DataSize := ZBufSize;
          ImageArray[Index].Data := ZBuf;
          ImageArray[Index].State := 1;
        except
        end;
      finally
        FreeMem(Buf);
      end;
    end;
  end;
end;

procedure TWILImages.SaveIndexList;
var
  idxfileName: String;
  IdxFile: TFileStream;
  I, APosition: Integer;
  Buf: PAnsiChar;
begin
  idxfileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.WIX';

  if (idxfileName<>'') and FileExists(idxfileName) then
  begin
    IdxFile := TFileStream.Create(idxfileName, fmOpenReadWrite or fmShareDenyNone);
    try
      if Header.VerFlag <> 0 then
        IdxFile.Position := SizeOf(TWMIndexHeader) - 4
      else
        IdxFile.Position := SizeOf(TWMIndexHeader);

      GetMem(Buf, INT_SIZE * ImageCount);
      try
        for I := 0 to ImageCount - 1 do
        begin
          APosition := ImageArray[I].Position;
          Move(APosition, Buf[I * INT_SIZE], INT_SIZE);
        end;
        IdxFile.WriteBuffer(Buf^, INT_SIZE * ImageCount);
      finally
        FreeMem(Buf);
      end;
    finally
      IdxFile.Free;
    end;
  end;
end;

procedure TWILImages.WriteImage(Index: Integer; Stream: TStream);
begin
  if (Index >=0) and (Index < ImageCount) then
  begin
    m_FileStream.Position := m_FileStream.Size;
    ImageArray[Index].Position := m_FileStream.Position;
    m_FileStream.CopyFrom(Stream, Stream.Size);
  end;
end;

{ TWZLImages }

procedure TWZLImages.Init;
var
  AImageHeader: TWZLImageHeader;
  IdxHeader: TWZXIndexHeader;
  I, NValue, BufSize: Integer;
  IdxFileName: String;
  IdxFile: TFileStream;
  Buf: PAnsiChar;
begin
  _Type := TYPE_IMG_WZL;
  m_FileStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  m_FileStream.Position := 0;
  m_FileStream.Read(AImageHeader, SizeOf(TWZLImageHeader));
  ImageCount :=  AImageHeader.IndexCount;
  if ImageCount > 0 then
  begin
    IdxFileName :=  ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.WZX';
    if (IdxFileName<>'') and FileExists(IdxFileName) then
    begin
      IdxFile := TFileStream.Create(IdxFileName, fmOpenRead or fmShareDenyNone);
      try
        IdxFile.ReadBuffer(IdxHeader, SizeOf(TWZXIndexHeader));
        ImageArray := AllocMem(SizeOf(TImageItem) * ImageCount);

        BufSize := IdxFile.Size - IdxFile.Position;
        if BufSize > 0 then
        begin
          GetMem(Buf, BufSize);
          try
            IdxFile.ReadBuffer(Buf^, BufSize);
            I := 0;
            while True do
            begin
              Move(Buf[I*4], NValue, INT_SIZE);
              ImageArray[I].Position := NValue;
              ImageArray[I].DataSize := 0;
              ImageArray[I].State := 0;
              Inc(I);
              if (I * 4 > BufSize) or (I >= ImageCount) then
                Break;
            end;
          finally
            FreeMem(Buf);
          end;
        end;
      finally
        IdxFile.Free;
      end;
    end;
  end;
end;

procedure TWZLImages.LoadImage(Index: Integer);
var
  AImageInfo: TWZLImageInfo;
  Buf: PAnsiChar;
  ZBuf: PAnsiChar;
  DataSize,
  BufSize,
  ZBufSize: Integer;
  BytesPerPixe: Byte;
begin
  if m_FileStream.Size >= ImageArray[Index].Position  then
  begin
    m_FileStream.Seek(ImageArray[Index].Position, 0);
    m_FileStream.Read(AImageInfo, Sizeof(TWZLImageInfo));
    case AImageInfo.m_Enc1 of
      3: BytesPerPixe := 1;
      5: BytesPerPixe := 2;
    end;
    if AImageInfo.m_Len > 0 then
      DataSize := AImageInfo.m_Len
    else
      DataSize := AImageInfo.m_nWidth * AImageInfo.m_nHeight * BytesPerPixe;

    if m_FileStream.Size >= m_FileStream.Position + DataSize  then
    begin
      BufSize := DataSize + SizeOf(TWZLImageInfo);
      GetMem(Buf, BufSize);
      try
        Move(AImageInfo, Buf[0], SizeOf(TWZLImageInfo));
        m_FileStream.ReadBuffer(Buf[SizeOf(TWZLImageInfo)], DataSize);
        try
          CompressBufZ(Buf, BufSize, ZBuf, ZBufSize);
          ImageArray[Index].DataSize := ZBufSize;
          ImageArray[Index].Data := ZBuf;
          ImageArray[Index].State := 1;
        except
        end;
      finally
        FreeMem(Buf);
      end;
    end;
  end;
end;

procedure TWZLImages.SaveIndexList;
var
  idxfileName: String;
  IdxFile: TFileStream;
  I, APosition: Integer;
  Buf: PAnsiChar;
begin
  idxfileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName) + '.wzx';
  if (idxfileName<>'') and FileExists(idxfileName) then
  begin
    IdxFile := TFileStream.Create(idxfileName, fmOpenReadWrite or fmShareDenyNone);
    GetMem(Buf, INT_SIZE * ImageCount);
    try
      IdxFile.Position := SizeOf(TWZXIndexHeader);
      for I := 0 to ImageCount - 1 do
      begin
        APosition := ImageArray[I].Position;
        Move(APosition, Buf[INT_SIZE * I], INT_SIZE);
      end;
      IdxFile.WriteBuffer(Buf^, INT_SIZE * ImageCount);
    finally
      IdxFile.Free;
      FreeMem(Buf);
    end;
  end;
end;

procedure TWZLImages.WriteImage(Index: Integer; Stream: TStream);
var
  Buffer: PAnsiChar;
begin
  if (Index >=0) and (Index < ImageCount) then
  begin
    GetMem(Buffer, Stream.Size);
    try
      m_FileStream.Position := m_FileStream.Size;
      ImageArray[Index].Position := m_FileStream.Position;
      Stream.ReadBuffer(Buffer^, Stream.Size);
      m_FileStream.WriteBuffer(Buffer^, Stream.Size);
    finally
      FreeMem(Buffer, Stream.Size);
    end;
  end;
end;


{TWMPackageImages}

procedure TWMPackageImages.Init;
var
  I, Value, BufSize: integer;
  Buf: PAnsiChar;
begin
  _Type := TYPE_IMG_DATA;
  m_FileStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  Header := Self.ReadHeader;
  ImageCount :=  Header.ImageCount;
  if (Header.XVersion = 1) and (Header.Password <> '') then
  begin
    if Header.Password <> FPassword then
    begin
      ImageCount := 0;
      Header.ImageCount := 0;
      Header.IndexOffSet := 80;
      Header.XVersion := 0;
      Header.Password := '';
      if ImagesManager <> nil then
        ImagesManager.Log(Format('“%s”已被加密，请输入正确的密码。。。', [FileName]));
    end;
  end;
  ImageArray := AllocMem(SizeOf(TImageItem) * ImageCount);
  if ImageCount > 0 then
  begin
    m_FileStream.Position := Header.IndexOffSet;
    BufSize := m_FileStream.Size - m_FileStream.Position;
    if BufSize > 0 then
    begin
      GetMem(Buf, BufSize);
      try
        m_FileStream.ReadBuffer(Buf^, BufSize);
        I := 0;
        while True do
        begin
          Move(Buf[I * 4], Value, INT_SIZE);
          ImageArray[I].Position := Value;
          ImageArray[I].DataSize := 0;
          ImageArray[I].State := 0;
          Inc(I);
          if (I * 4 > BufSize) or (I >= ImageCount) then
            Break;
        end;
      finally
        FreeMem(Buf);
      end;
    end;
  end;
end;

procedure TWMPackageImages.LoadImage(Index: Integer);
var
  AImageInfo: TPackDataImageInfo;
  Buf: PAnsiChar;
  ZBuf: PAnsiChar;
  DataSize,
  ZBufSize: Integer;
begin
  if CheckImageInfoSize(ImageArray[Index].Position) then
  begin
    AImageInfo := ReadImageInfo(ImageArray[Index].Position);
    case Header.XVersion of
      0: DataSize := AImageInfo.nSize + SizeOf(TPackDataImageInfo);
      1: DataSize := AImageInfo.nSize + 22;
    end;
    m_FileStream.Position := ImageArray[Index].Position;
    if m_FileStream.Size >= m_FileStream.Position + DataSize then
    begin
      GetMem(Buf, DataSize);
      try
        m_FileStream.ReadBuffer(Buf^, DataSize);
        try
          CompressBufZ(Buf, DataSize, ZBuf, ZBufSize);
          ImageArray[Index].DataSize := ZBufSize;
          ImageArray[Index].Data := ZBuf;
          ImageArray[Index].State := 1;
        except
        end;
      finally
        FreeMem(Buf);
      end;
    end;
  end;
end;

function TWMPackageImages.ReadHeader: TPackDataHeader;
begin
  m_FileStream.Position := 0;
  Result := ReadHeaderFromStream(m_FileStream);
end;

function TWMPackageImages.ReadImageInfo(APosition: Integer): TPackDataImageInfo;
var
  AEncData,
  ADecData: PAnsiChar;
  ADecSize: Integer;
begin
  m_FileStream.Position := APosition;
  case Header.XVersion of
    0:
    begin
      m_FileStream.ReadBuffer(Result, SizeOf(TPackDataImageInfo));
    end;
    1:
    begin
      GetMem(AEncData, 22);
      try
        m_FileStream.ReadBuffer(AEncData^, 22);
        uEDCode.DecodeData(AEncData^, 22, ADecData, ADecSize, _Key);
        Move(ADecData^, Result, SizeOf(TPackDataImageInfo));
      finally
        FreeMem(AEncData, 22);
        FreeMem(ADecData, ADecSize);
      end;
    end;
  end;
end;

function TWMPackageImages.CheckImageInfoSize(APosition: Integer): Boolean;
begin
  Result := True;
  case Header.XVersion of
    0:
    begin
      Result := APosition + SizeOf(TPackDataImageInfo) <= m_FileStream.Size;
    end;
    1:
    begin
      Result := APosition + 22 <= m_FileStream.Size;
    end;
  end;
end;

procedure TWMPackageImages.SaveIndexList;
var
  I, APosition: Integer;
  Buf: PAnsiChar;
begin
  m_FileStream.Position := Header.IndexOffSet;
  GetMem(Buf, INT_SIZE * ImageCount);
  try
    for I := 0 to ImageCount - 1 do
    begin
      APosition := ImageArray[I].Position;
      Move(APosition, Buf[INT_SIZE * I], INT_SIZE);
    end;
    m_FileStream.WriteBuffer(Buf^, INT_SIZE * ImageCount);
    WriteHeaderToStream(m_FileStream, Header);
  finally
    FreeMem(Buf);
  end;
end;

class function TWMPackageImages.ReadHeaderFromStream(F: TStream): TPackDataHeader;
var
  AEncData,
  ADecData: PAnsiChar;
  ADecSize: Integer;
begin
  FillChar(Result, SizeOf(TPackDataHeader), #0);
  GetMem(AEncData, 80);
  try
    F.ReadBuffer(AEncData^, 80);
    uEDCode.DecodeData(AEncData^, 80, ADecData, ADecSize, _HKey);
    Move(ADecData^, Result, SizeOf(TPackDataHeader));
  finally
    FreeMem(AEncData, 80);
    FreeMem(ADecData, ADecSize);
  end;
end;

class procedure TWMPackageImages.WriteHeaderToStream(F: TStream; AHeader: TPackDataHeader);
var
  AEncData: PAnsiChar;
  AEncSize: Integer;
begin
  try
    uEDCode.EncodeData(AHeader, SizeOf(TPackDataHeader), _HKey, AEncData, AEncSize);
    F.Position := 0;
    F.WriteBuffer(AEncData^, AEncSize);
  finally
    FreeMem(AEncData, AEncSize);
  end;
end;

procedure TWMPackageImages.WriteImage(Index: Integer; Stream: TStream);
begin
  if (Index >=0) and (Index < ImageCount) then
  begin
    m_FileStream.Position := Header.IndexOffSet;
    ImageArray[Index].Position := m_FileStream.Position;
    m_FileStream.CopyFrom(Stream, Stream.Size);
    Header.IndexOffSet := m_FileStream.Position;
  end;
end;

{ TWMImages }

constructor TWMImages.Create;
begin
  ImageCount := 0;
  _Type := 0;
  m_MemCheck := 0;
end;

destructor TWMImages.Destroy;
begin
  if ImageArray <> nil then
    FreeMem(ImageArray);
  if m_FileStream <> nil then
    FreeAndNil(m_FileStream);
  inherited;
end;

procedure TWMImages.BeginDownload(Index: Integer);
begin
  if (Index >= 0) and (Index < ImageCount) then
    ImageArray[Index].State := 1;
end;

procedure TWMImages.EndDownload(Index: Integer);
begin
  if (Index >= 0) and (Index < ImageCount) then
    ImageArray[Index].State := 2;
end;

procedure TWMImages.Extract(Index: Integer; var DataSize: Integer);
begin
  DataSize := 0;
  if GetTickCount - m_MemCheck > 10000{5000} then
  begin
    m_MemCheck := GetTickCount;
    FreeOldMemorys;
  end;
  if (Index >= 0) and (Index < ImageCount) then
  begin
    if ImageArray[Index].State = 0 then
      LoadImage(Index);
    DataSize := ImageArray[Index].DataSize;
    if DataSize > 0 then
      ImageArray[Index].LastUpdate := GetTickCount;
  end;
end;

procedure TWMImages.ReadBuffer(Index: Integer; var AByteArray: RtcByteArray; APosition, ALength: Integer);
begin
  if GetTickCount - m_MemCheck > 10000{5000} then
  begin
    m_MemCheck := GetTickCount;
    FreeOldMemorys;
  end;
  if (Index >= 0) and (Index < ImageCount) then
  begin
    if ImageArray[Index].State = 0 then
      LoadImage(Index);
    ImageArray[Index].LastUpdate := GetTickCount;
    SetLength(AByteArray, ALength);
    Move(ImageArray[Index].Data[APosition], AByteArray[0], ALength);
  end;
end;

procedure TWMImages.FreeOldMemorys;
var
  I, ACurTime: integer;
begin
  ACurTime := GetTickCount;
  for I := 0 to ImageCount - 1 do
  begin
    if ImageArray[I].Data <> nil then
    begin
      if ACurTime - ImageArray[I].LastUpdate > 180000{3 * 60 * 1000} then
      begin
        FreeMem(ImageArray[I].Data, ImageArray[I].DataSize);
        ImageArray[I].DataSize := 0;
        ImageArray[I].State := 0;
        ImageArray[I].Data := nil;
      end;
    end;
  end;
end;

function TWMImages.CanDownload(Index: Integer): Boolean;
begin
  Result := True;
  if (Index >= 0) and (Index < ImageCount) then
    Result := ImageArray[Index].State = 0;
end;

function TWMImages.Position(Index: Integer): Integer;
begin
  Result := 0;
  if (Index >=0) and (Index < ImageCount) then
    Result := ImageArray[Index].Position;
end;

procedure TWMImages.ResetDownload(Index: Integer);
begin
  if (Index >= 0) and (Index < ImageCount) then
    ImageArray[Index].State := 0;
end;

procedure TWMImages.Write(Index: Integer; Stream: TStream);
begin
  WriteImage(Index, Stream);
  SaveIndexList;
end;

{ TWMImagesManager }

procedure TWMImagesManager.ClearAllImages;
begin
  FImages.Clear;
end;

constructor TWMImagesManager.Create;
begin
  FImages := TObjectDictionary<String, TWMImages>.Create([doOwnsValues]);
end;

destructor TWMImagesManager.Destroy;
begin
  FreeAndNil(FImages);
  inherited;
end;

procedure TWMImagesManager.Log(const Value: String);
begin
  if Assigned(FOnLog) then
    FOnLog(Value);
end;

procedure TWMImagesManager.Add(const Password, FileName, AName: String);
var
  AImages: TWMImages;
begin
  if FileName = 'H:\游戏\热血传奇\data\humeffect8.wzl' then
  begin
    AImages := nil;
  end;

  AImages := _CreateImages(FileName);
  if AImages <> nil then
  begin
    try
      AImages.FileName := FileName;
      AImages.RelativePath := AName;
      AImages.Password := Password;
      AImages.Init;
      FImages.AddOrSetValue(Uppercase(AName), AImages);
    except
      on E: Exception do
      begin
        AImages.Free;
        Raise E;
      end;
    end;
  end;
end;

function TWMImagesManager.TryGet(const Name: String;
  out AImages: TWMImages): Boolean;
begin
  Result := FImages.TryGetValue(Name, AImages);
end;

procedure TWMImagesManager.WriteHeaders(Stream: TStream);
var
  AEnumerator: TObjectDictionary<String, TWMImages>.TPairEnumerator;
  AData: PAnsiChar;
  ANameBytes: TBytes;
  ANameLen: Integer;
begin
  AEnumerator := FImages.GetEnumerator;
  if AEnumerator <> nil then
  begin
    while AEnumerator.MoveNext do
    begin
      ANameBytes := TEncoding.UTF8.GetBytes(AEnumerator.Current.Value.RelativePath);
      ANameLen := Length(ANameBytes);
      try
        case AEnumerator.Current.Value._Type of
          TYPE_IMG_WIL:
          begin
            if AEnumerator.Current.Value.m_FileStream.Size >= SizeOf(TWMImageHeader) then
            begin
              GetMem(AData, SizeOf(TWMImageHeader));
              try
                AEnumerator.Current.Value.m_FileStream.Position := 0;
                AEnumerator.Current.Value.m_FileStream.Read(AData^, SizeOf(TWMImageHeader));
                Stream.WriteBuffer(AEnumerator.Current.Value._Type, 1);
                Stream.WriteBuffer(ANameLen, SizeOf(Integer));
                Stream.WriteBuffer(ANameBytes[0], ANameLen);
                Stream.WriteBuffer(AData^, SizeOf(TWMImageHeader));
              finally
                FreeMem(AData);
              end;
            end;
          end;
          TYPE_IMG_WZL:
          begin
            if AEnumerator.Current.Value.m_FileStream.Size >= SizeOf(TWZLImageHeader) then
            begin
              GetMem(AData, SizeOf(TWZLImageHeader));
              try
                AEnumerator.Current.Value.m_FileStream.Position := 0;
                AEnumerator.Current.Value.m_FileStream.ReadBuffer(AData^, SizeOf(TWZLImageHeader));
                Stream.WriteBuffer(AEnumerator.Current.Value._Type, 1);
                Stream.WriteBuffer(ANameLen, SizeOf(Integer));
                Stream.WriteBuffer(ANameBytes[0], ANameLen);
                Stream.WriteBuffer(AData^, SizeOf(TWZLImageHeader));
              finally
                FreeMem(AData);
              end;
            end;
          end;
          TYPE_IMG_DATA:
          begin
            if AEnumerator.Current.Value.m_FileStream.Size >= 80 then
            begin
              GetMem(AData, 80);
              try
                AEnumerator.Current.Value.m_FileStream.Position := 0;
                AEnumerator.Current.Value.m_FileStream.ReadBuffer(AData^, 80);
                Stream.WriteBuffer(AEnumerator.Current.Value._Type, 1);
                Stream.WriteBuffer(ANameLen, SizeOf(Integer));
                Stream.WriteBuffer(ANameBytes[0], ANameLen);
                Stream.WriteBuffer(AData^, 80);
              finally
                FreeMem(AData);
              end;
            end;
          end;
        end;
      finally
        System.Finalize(ANameBytes);
      end;
    end;
  end;
end;

procedure TWMImagesManager.WriteImage(const AFileName: String; Index: Integer; Stream: TStream; out Position: Integer);
var
  AImages: TWMImages;
begin
  Position := 0;
  if TryGet(UpperCase(AFileName), AImages) then
  begin
    AImages.Write(Index, Stream);
    Position := AImages.Position(Index);
  end;
end;

procedure TWMImagesManager.CreateOrUpdateWIL(const BaseDir, FileName: String; Header: TWMImageHeader);
var
  AFileName,
  AIdxFileName: String;
  F, FIdx: TFileStream;
  AOldHeader: TWMImageHeader;
  IdxFile: String;
  AIndexHeader: TWMIndexHeader;
begin
  AFileName := BaseDir + FileName;
  AIdxFileName := ChangeFileExt(AFileName, '.wix');
  if not (FileExists(AFileName) and FileExists(AIdxFileName)) then
  begin
    F := TFileStream.Create(AFileName, fmCreate);
    FIdx := TFileStream.Create(AIdxFileName, fmCreate);
    try
      F.WriteBuffer(Header, SizeOf(TWMImageHeader));
      AIndexHeader.Title := Header.Title;
      AIndexHeader.IndexCount := Header.ImageCount;
      AIndexHeader.VerFlag := Header.VerFlag;
      FIdx.WriteBuffer(AIndexHeader, SizeOf(TWMIndexHeader));
    finally
      F.Free;
      FIdx.Free;
    end;
  end
  else
  begin
    F := TFileStream.Create(AFileName, fmOpenReadWrite or fmShareDenyNone);
    FIdx := TFileStream.Create(AIdxFileName, fmOpenReadWrite or fmShareDenyNone);
    try
      F.ReadBuffer(AOldHeader, SizeOf(TWMImageHeader));
      if not CompareMem(@Header, @AOldHeader, SizeOf(TWMImageHeader)) then
      begin
        F.Position := 0;
        F.WriteBuffer(Header, SizeOf(TWMImageHeader));
        AIndexHeader.Title := Header.Title;
        AIndexHeader.IndexCount := Header.ImageCount;
        AIndexHeader.VerFlag := Header.VerFlag;
        FIdx.Position := 0;
        FIdx.WriteBuffer(AIndexHeader, SizeOf(TWMIndexHeader));
      end;
    finally
      F.Free;
      FIdx.Free;
    end;
  end;
  Add('', AFileName, FileName);
end;

procedure TWMImagesManager.CreateOrUpdateWZL(const BaseDir, FileName: String; Header: TWZLImageHeader);
var
  AFileName, AIdxFileName: String;
  F, FIdx: TFileStream;
  AOldHeader: TWZLImageHeader;
  IdxFile: String;
  AIndexHeader: TWZXIndexHeader;
begin
  AFileName := BaseDir + FileName;
  AIdxFileName := ChangeFileExt(AFileName, '.wzx');
  if not (FileExists(AFileName) and FileExists(AIdxFileName)) then
  begin
    F := TFileStream.Create(AFileName, fmCreate);
    FIdx := TFileStream.Create(AIdxFileName, fmCreate);
    try
      F.WriteBuffer(Header, SizeOf(TWZLImageHeader));
      AIndexHeader.Title := Header.Title;
      AIndexHeader.IndexCount := Header.IndexCount;
      FIdx.WriteBuffer(AIndexHeader, SizeOf(TWZXIndexHeader));
    finally
      F.Free;
      FIdx.Free;
    end;
  end
  else
  begin
    F := TFileStream.Create(AFileName, fmOpenReadWrite or fmShareDenyNone);
    FIdx := TFileStream.Create(AIdxFileName, fmOpenReadWrite or fmShareDenyNone);
    try
      F.ReadBuffer(AOldHeader, SizeOf(TWZLImageHeader));
      if not CompareMem(@Header, @AOldHeader, SizeOf(TWZLImageHeader)) then
      begin
        F.Position := 0;
        F.WriteBuffer(Header, SizeOf(TWZLImageHeader));
        AIndexHeader.Title := Header.Title;
        AIndexHeader.IndexCount := Header.IndexCount;
        FIdx.Position := 0;
        FIdx.WriteBuffer(AIndexHeader, SizeOf(TWZXIndexHeader));
      end;
    finally
      F.Free;
      FIdx.Free;
    end;
  end;
  Add('', AFileName, FileName);
end;

procedure TWMImagesManager.CreateOrUpdateData(const BaseDir, FileName: String; Header: TPackDataHeader);
var
  AFileName: String;
  F: TFileStream;
  AOldHeader: TPackDataHeader;
begin
  AFileName := BaseDir + FileName;
  if not FileExists(AFileName) then
  begin
    F := TFileStream.Create(AFileName, fmCreate);
    try
      Header.IndexOffSet := 80;
      TWMPackageImages.WriteHeaderToStream(F, Header);
    finally
      F.Free;
    end;
  end
  else
  begin
    F := TFileStream.Create(AFileName, fmOpenReadWrite or fmShareDenyNone);
    try
      F.Position := 0;
      AOldHeader := TWMPackageImages.ReadHeaderFromStream(F);
      if not CompareMem(@Header, @AOldHeader, SizeOf(TPackDataHeader)) then
      begin
        if Header.Password = AOldHeader.Password then
        begin
          Header.IndexOffSet := AOldHeader.IndexOffSet;
          TWMPackageImages.WriteHeaderToStream(F, Header);
        end
        else
        begin
          F.Size := 0;
          Header.IndexOffSet := 80;
          TWMPackageImages.WriteHeaderToStream(F, Header);
        end;
      end;
    finally
      F.Free;
    end;
  end;
  Add(Header.Password, AFileName, FileName);
end;

initialization
  ImagesManager := TWMImagesManager.Create;

finalization
  FreeAndNil(ImagesManager);

end.
