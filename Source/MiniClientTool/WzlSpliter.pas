unit WzlSpliter;

interface

uses wil, Classes, ZLib, SysUtils, HUtil32, Dialogs, Windows, Math, Forms,
  Generics.Collections,uMD5,Generics.Defaults,uMiniResFileInfo;

const
  IMAGE_PART_COUNT = 10; // 图片分开的数量
  PART_CHK_CODE = $CCFFEEDD; // 分割部分的验证码
  PART_SIZE = 1024 * 64; // 最佳分割大小 根据64k对数据进行分割


type

//微端 Data 描述文件
  TMiniDataHeader = packed record
    CheckCode : Cardinal;
    MD5 : array [1..32] of AnsiChar;
    ImageCount:Integer;
    PartCount:Integer;
    DataHeader : array[1..80] of Byte;
  end;

//微端 Wzl描述文件
  TMiniWZLHeader = packed record
    CheckCode : Cardinal;
    MD5 : array [1..32] of AnsiChar;
    ImageCount:Integer;
    PartCount:Integer;
  end;


  TWzlSpliter = class
  private
    m_Foramt : TWZLDATAFormat;
    m_GameImage: TWMImages;
    m_PartIndex: TList<Integer>;

    procedure BuildPart(nPart: Integer; M: TMemoryStream);
    function GetImageIndexData(nIndex: Integer; M: TMemoryStream): Boolean;
    function  FileIsChange(FileName:string; MD5:AnsiString):Boolean;
    procedure SavePartDesc(const Path:String ; MD5:AnsiString);
  public
    constructor Create(Image: TWMImages);
    procedure CalcPart(); // 将文件的部分写入到文件流内。
    destructor Destroy(); override;
    function SaveToDir(sPath: String): Integer;
  end;
implementation

{ TWzlSpliter }
procedure TWzlSpliter.BuildPart(nPart: Integer; M: TMemoryStream);
var
  i: Integer;
  nPartStart: Integer;
  nPartEnd: Integer;
  nIndex: Integer;
begin

  nIndex := m_PartIndex[nPart];
  // 写入头部信息
  if nPart = 0 then
  begin
    nPartStart := 0;
    nPartEnd := nIndex;
  end
  else
  begin
    // 生成的范围
    nPartStart := m_PartIndex[nPart - 1] + 1;
    nPartEnd := Min(m_GameImage.ImageCount - 1, nIndex);
  end;

  for i := nPartStart to nPartEnd do
  begin
    if GetImageIndexData(i, M) = false then
    begin
      raise Exception.Create(Format('BuildPart Error !Part : %d', [nPart]));
    end;
  end;
end;

procedure TWzlSpliter.CalcPart();
var
  i: Integer;
  nSize: Integer;
  MaxIndex:Integer;
begin
  m_PartIndex.Clear;
  nSize := 0;

  MaxIndex := m_GameImage.ImageCount - 1;
  for i := 0 to MaxIndex do
  begin
    nSize := nSize + m_GameImage.GetImgDataSize(i);
    if (nSize > PART_SIZE) or (MaxIndex = i) then
    begin
      nSize := 0;
      m_PartIndex.Add(i);
    end;
  end;
end;

constructor TWzlSpliter.Create(Image: TWMImages);
begin
  m_PartIndex := TList<Integer>.Create;
  if Image is TWZLImages then
  begin
    m_Foramt := wWZL;
  end
  else if Image is TWMPackageImages then
  begin
    m_Foramt := wDATA;
  end
  else
  begin
    raise Exception.Create('[异常] : 无法转换data wzl 格式之外的图片');
  end;
  m_GameImage := Image;
end;

destructor TWzlSpliter.Destroy;
begin

  inherited;
end;

function TWzlSpliter.FileIsChange(FileName:string; MD5:AnsiString):Boolean;
var
  FileStream:TMemoryStream;
  Header:TMiniDataHeader;
begin
  FileName := ChangeFileExt(FileName,'.MiniData');
  if FileExists(FileName) then
  begin
    FileStream := TMemoryStream.Create;
    Try
      Try
        FileStream.LoadFromFile(FileName);
        if FileStream.Read(Header,SizeOf(Header)) = SizeOf(Header) then
        begin
          if MD5 = Header.MD5 then
          begin
            Result := False;
          end;
        end
      except
        Result := True;
      End;
    Finally
      FileStream.Free;
    End;
  end else
  begin
    Result := True;
  end;
end;

// |4字节包含WZLINFO以及压缩字段的长度PBIT|
function TWzlSpliter.GetImageIndexData(nIndex: Integer;
  M: TMemoryStream): Boolean;
var
  nPosition: Integer;
  WzlImageInfo: TWZLImageInfo;
  wilImageInfo: TWMImageInfo;
  pCompress, pOut: Pointer;
  nOutLen: Integer;
  nSize: Integer;
  nRealLen: Integer;
  DataImageInfo : TPackDataImageInfo;
begin
    Result := false;
  if (nIndex >= 0) and (nIndex < m_GameImage.ImageCount) then
  begin
    Try
      nPosition := Integer(m_GameImage.Index[nIndex]);
      if nPosition <= 0 then
      begin
        Result := True;
        nRealLen := 0;
        M.Write(nRealLen, SizeOf(nRealLen));
        Exit;
      end;

      m_GameImage.FileStream.Position := nPosition;
      nRealLen := m_GameImage.GetImgDataSize(nIndex);
      // 先写入长度。
      M.Write(nRealLen, SizeOf(nRealLen));
      if nRealLen <> 0 then
        M.CopyFrom(m_GameImage.FileStream, nRealLen);
      Result := True;
      Exit;
    except
      on E: Exception do
      begin
        ShowMessage(Format('%s : nIndex : %d', [E.Message, nIndex]));
      end;
    End;
  end;
end;

procedure TWzlSpliter.SavePartDesc(const Path:String ; MD5:AnsiString);
var
  RealPath:String;
  FileStream:TMemoryStream;
  PartCount : Integer;
  i: Integer;
  DataHeader : TMiniDataHeader;
  WzlHeader  : TMiniWZLHeader;
begin
  RealPath :=  ChangeFileExt(Path,'.MiniData');
  FileStream := TMemoryStream.Create;
  FillChar(DataHeader,SizeOf(DataHeader),0);
  FillChar(WzlHeader,SizeOf(WzlHeader),0);
  case m_Foramt of
    wWZL:begin
       WzlHeader.CheckCode := MINIWZL_CHECKCODE;
       Move(MD5[1],WzlHeader.MD5[1],SizeOf(WzlHeader.MD5));
       WzlHeader.ImageCount := m_GameImage.ImageCount;
       WzlHeader.PartCount := m_PartIndex.Count;
       FileStream.Write(WzlHeader,SizeOf(WzlHeader));
    end;
    wDATA:begin
      DataHeader.CheckCode := MINIDATA_CHECKCODE;
      Move(MD5[1],DataHeader.MD5[1],SizeOf(DataHeader.MD5));
      DataHeader.ImageCount := m_GameImage.ImageCount;
      DataHeader.PartCount := m_PartIndex.Count;
      m_GameImage.FileStream.Position := 0;
      m_GameImage.FileStream.Read(DataHeader.DataHeader[1],80);

      FileStream.Write(DataHeader,SizeOf(DataHeader));
    end;
  end;



  for i := 0 to m_PartIndex.Count - 1 do
  begin
    PartCount := m_PartIndex[i];
    FileStream.Write(PartCount,4);
  end;
  FileStream.SaveToFile(RealPath);
  FileStream.Free;
end;

function TWzlSpliter.SaveToDir(sPath: String): Integer;
const
  Flag = 'KIMC';
var
  sFileName, sName, sCheckMD5: string;
  i: Integer;
  nPartCount: Integer;
  M: TMemoryStream;
  nCheckCode: Cardinal;
  nMD5Len: Integer;
  MD5CheckMem: TMemoryStream;
  FileStream: TFileStream;
  sMD5:AnsiString;

begin
  Result := 2;
  if sPath = '' then
    Exit;
  sMD5 := uMd5.MD5File(m_GameImage.FileName);
  sFileName := ExtractFileNameOnly(m_GameImage.FileName);
  sFileName := sPath + sFileName + '\' + sFileName;
  //文件改变了才需要重新生成否则不需要
  if FileIsChange(sFileName,sMD5) then
  begin
    //计算分割的部分。
    CalcPart( );

    sPath := sPath + ExtractFileNameOnly(m_GameImage.FileName) + '\';
    if not DirectoryExists(sPath) then
      ForceDirectories(sPath);

    if m_GameImage.ImageCount <= 0 then
      Exit;

    nPartCount := m_PartIndex.Count;
    sName := ExtractFileNameOnly(m_GameImage.FileName);

    for i := 0 to nPartCount - 1 do
    begin
      if m_Foramt = wDATA then
        sFileName := Format('%s%s%s%d', [sPath, sName, '.data', i])
      else
        sFileName := Format('%s%s%s%d', [sPath, sName, '.wzl', i]);

      M := TMemoryStream.Create;
      nCheckCode := PART_CHK_CODE;
      M.Write(nCheckCode, SizeOf(nCheckCode));
      BuildPart(i, M);

      M.SaveToFile(sFileName);
      M.Free;
      Application.ProcessMessages;
    end;

    SavePartDesc(sFileName,sMD5);

    Result := 0;
  end else
  begin
    Result := 1;
  end;
end;


end.
