unit WzlMerge;

interface

uses HUtil32, Classes, Windows, SysUtils, wil, Generics.Collections,WzlSpliter,uMiniResFileInfo;

Type
  TWzlMerge = class
  private
    m_sDir: string;
    m_PartIndex: TList<Integer>;
    m_ImageCount: Integer;
    m_Format: TWZLDATAFormat;
    m_DataHeader : array[1..80] of Byte;
    function GetDirFileName: string;

    function GetPartStartEnd(nPart: Integer; var nStart, nEnd: Integer)
      : Boolean;
    function LoadMiniDataFromStream(Stream:TStream):Boolean;
    function LoadMiniDataFromFile(): Boolean;
  public
    constructor Create(sDir: String);
    procedure SaveToWzl(const sFileName: String; MergePartList: TList = nil);
    procedure SaveToDir(sDir: String; MergePartList: TList = nil);
  end;
function DoMerge(const FileName:string; StartIndex,EndIndex,ImageCount:Integer; Format:TWZLDATAFormat;PartStream:TStream ;DataFileHeader:TStream):Boolean;
implementation


{ TWzlMerge }

procedure FindAllDirFile(Path: string; DestResult: TStrings);
var
  Sr: TSearchRec;
begin
  if FindFirst(Path + '\*.*', faAnyfile, Sr) = 0 then
    if (Sr.Name <> '.') and (Sr.Name <> '..') then
      if (Sr.Attr and faDirectory) = faDirectory then
      begin
        DestResult.Add(Path + '\' + Sr.Name);
        FindAllDirFile(Path + '\' + Sr.Name, DestResult);
      end;
  while FindNext(Sr) = 0 do
  begin
    if (Sr.Name <> '.') and (Sr.Name <> '..') then
      if (Sr.Attr and faAnyfile) <> 0 then
      begin
        DestResult.Add(Path + '\' + Sr.Name);
        FindAllDirFile(Path + '\' + Sr.Name, DestResult);
      end;
  end;
  FindClose(Sr);
end;

constructor TWzlMerge.Create(sDir: String);
begin
  m_sDir := sDir;
  m_PartIndex := TList<Integer>.Create;
  if not DirectoryExists(sDir) then
  begin
    raise Exception.Create('�ļ��в������޷��ϲ�');
  end;

end;

function TWzlMerge.GetDirFileName: string;
var
  FileList: TStrings;
  sName, sExt: string;
  i: Integer;
begin
  if m_sDir <> '' then
  begin
    if m_sDir[Length(m_sDir)] = '\' then
    begin
      Result := ExtractFileNameOnly(Copy(m_sDir,1,Length(m_sDir) - 1));
      Result := m_sDir + Result;
    end else
    begin
      Result := '';
    end;
  end else
  begin
    Result := '';
  end;
end;

function TWzlMerge.GetPartStartEnd(nPart: Integer;
  var nStart, nEnd: Integer): Boolean;
var
  i: Integer;
begin
  if (nPart >= 0) and (nPart < m_PartIndex.Count) then
  begin
    if nPart = 0 then
    begin
      nStart := 0;
      nEnd := m_PartIndex[0];
    end
    else
    begin
      nStart := m_PartIndex[nPart - 1] + 1;
      nEnd := m_PartIndex[nPart];
    end;
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

function TWzlMerge.LoadMiniDataFromFile: Boolean;
var
  sFileName: String;
  FileStream: TMemoryStream;
begin
  Result := False;
  sFileName := GetDirFileName();
  sFileName := ChangeFileExt(sFileName, '.MiniData');
  if FileExists(sFileName) then
  begin
    FileStream := TMemoryStream.Create;
    FileStream.LoadFromFile(sFileName);
    Result := LoadMiniDataFromStream(FileStream);
    FileStream.Free;
  end;
end;

function TWzlMerge.LoadMiniDataFromStream(Stream: TStream):Boolean;
var
  Flag: Cardinal;
  Index: Integer;
  i ,PartCount: Integer;
  DataHeader : TMiniDataHeader;
  WZLHeader : TMiniWZLHeader;
begin
  Result := False;
  Stream.Position := 0;
  Stream.Read(Flag,SizeOf(Flag));
  if (Flag = MINIDATA_CHECKCODE) or (Flag = MINIWZL_CHECKCODE) then
  begin
    Stream.Position := 0;
    if Flag = MINIDATA_CHECKCODE then
    begin
      Stream.Read(DataHeader,SizeOf(DataHeader));
      m_ImageCount := DataHeader.ImageCount;
      PartCount := DataHeader.PartCount;
      Move(Dataheader.DataHeader[1],m_DataHeader[1],80);
      m_Format := wDATA;
    end
    else
    begin
      Stream.Read(WZLHeader,SizeOf(WZLHeader));
      m_ImageCount := WZLHeader.ImageCount;
      PartCount := WZLHeader.PartCount;
      m_Format := wWZL;
    end;

    for i := 0 to PartCount - 1 do
    begin
      Stream.Read(Index, 4);
      m_PartIndex.Add(Index);
    end;

    if m_PartIndex.Count = PartCount then
      Result := True
    else
      m_PartIndex.Clear;
  end;
end;

procedure TWzlMerge.SaveToDir(sDir: String; MergePartList: TList);
var
  sFileName: string;
begin
  sFileName := GetDirFileName;
  if LoadMiniDataFromFile() then
  begin
    if m_Format = wWZL then
      sFileName := sDir + ExtractFileNameOnly(sFileName) + '.wzl'
    else
      sFileName := sDir + ExtractFileNameOnly(sFileName) + '.Data';
    SaveToWzl(sFileName, MergePartList);
  end;
end;

//procedure TWzlMerge.SaveToWzl(const sFileName: String; MergePartList: TList);
//var
//  sName, sName2,WzxFileName: string;
//  i, K, nIdx, nStart, nEnd: Integer;
//  WZLStream, PartMem: TMemoryStream;
//  wzxStream: TFileStream;
//  dwCheckCode: Cardinal;
//
//  WzxHeader: TWZXIndexHeader;
//  nPart, nMergePart: Integer;
//  IndexArr: Array of Integer;
//  nRealLen: Integer;
//  SelfList: TList;
//  boFreeSelfList: Boolean;
//  DataHeader: TPackDataHeader;
//  Header: TWZLImageHeader;
//  TempMemoryStream: TMemoryStream;
//begin
//
//  sName := GetDirFileName;
//
//  if sName = '' then
//  begin
//    raise Exception.Create('�ļ��������޷��ϲ�');
//  end;
//
//  nPart := m_PartIndex.Count;
//  WZLStream := TMemoryStream.Create;
//  if m_Format = wWZL then
//  begin
//    Header.IndexCount := m_ImageCount;
//    Header.Title := '91GameEngineMiniResource';
//    WZLStream.Write(Header, SizeOf(Header));
//  end else
//  begin
//   //Data�ļ��� ǰ�治д��Header ��ȫ��Ū������ͷ  ��ռλ
//    TWMPackageImages.WriteHeader(WZLStream,DataHeader);
//  end;
//  SetLength(IndexArr, m_ImageCount);
//
//  //�ںϲ���ʱ���Ƚ���������������Ϊ -1 ��ʾ��֧��΢�� �ȴ����ص�
//  for i := 0 to m_ImageCount - 1 do
//  begin
//    IndexArr[i] := -1;
//  end;
//  PartMem := TMemoryStream.Create;
//
//  boFreeSelfList := False;
//
//  // ���ݴ��ݽ����Ĳ���ȷ�� ��Щ������Ҫ�󱻺ϲ���  ���Ϊnil ��˵��ȫ���ϲ�
//  if MergePartList = nil then
//  begin
//    SelfList := TList.Create;
//    for i := 0 to nPart - 1 do
//    begin
//      SelfList.Add(Pointer(i));
//    end;
//    boFreeSelfList := True;
//  end
//  else
//  begin
//    SelfList := MergePartList;
//  end;
//
//  // ���ֺϲ�����Ϊ��
//  if SelfList <> nil then
//  begin
//    // ����Ҫ���ϵĲ��� ��������
//    for i := 0 to SelfList.Count - 1 do
//    begin
//      nMergePart := Integer(SelfList.Items[i]);
//
//      if m_Format = wData then
//        sName2 := ChangeFileExt(sName, '.data' + IntToStr(nMergePart))
//      else
//        sName2 := ChangeFileExt(sName, '.wzl' + IntToStr(nMergePart));
//
//
//      if not FileExists(sName2) then
//      begin
//        raise Exception.Create('�ļ��������޷��ϲ� :' + sName2);
//      end;
//
//      PartMem.Clear;
//      PartMem.LoadFromFile(sName2);
//      PartMem.Read(dwCheckCode, SizeOf(dwCheckCode));
//
//      if dwCheckCode <> PART_CHK_CODE then
//      begin
//        raise Exception.Create('У��ʧ�� Part : ' + IntToStr(i));
//      end;
//
//      if GetPartStartEnd(nMergePart, nStart, nEnd) then
//      begin
//
//        for K := nStart to nEnd do
//        begin
//          IndexArr[K] := WZLStream.Position;
//          // �����ȡ���ĳ��Ȳ��� һ���ṹ��Ϣ ˵���ǿ�ͼƬ
//          if PartMem.Read(nRealLen, SizeOf(nRealLen)) < SizeOf(nRealLen) then
//          begin
//            IndexArr[k] := 0;
//          end
//          else
//          begin
//            if nRealLen <> 0 then
//              WZLStream.CopyFrom(PartMem, nRealLen)
//            else
//              IndexArr[k] := 0;
//          end;
//        end;
//
//      end;
//
//    end;
//
//  end;
//
//  //д����������
//  if m_Format = wDATA then
//  begin
//    //���ͷ��������
//    TempMemoryStream := TMemoryStream.Create;
//    TempMemoryStream.Write(m_DataHeader[1],80);
//    DataHeader := TWMPackageImages.ReadFileHeader(TempMemoryStream);
//    DataHeader.Title := '91GameEngine';
//    DataHeader.ImageCount := m_ImageCount;
//    DataHeader.IndexOffSet := WZLStream.Position;
//    //д������
//    WZLStream.Write(IndexArr[0], Length(IndexArr) * SizeOf(IndexArr[0]));
//    WZLStream.Position := 0;
//
//    //��дͷ
//    TWMPackageImages.WriteHeader(WZLStream,DataHeader);;
//    TempMemoryStream.Free;
//  end else
//  begin
//    WzxFileName := ChangeFileExt(sFileName, '.wzx');
//    wzxStream := TFileStream.Create(WzxFileName, fmCreate);
//    WzxHeader.IndexCount := m_ImageCount;
//    wzxStream.Write(WzxHeader, SizeOf(WzxHeader));
//    wzxStream.Write(IndexArr[0], Length(IndexArr) * SizeOf(IndexArr[0]));
//    wzxStream.Free;
//  end;
//
//   WZLStream.SaveToFile(sFileName);
//   WZLStream.Free;
//
//
//  if boFreeSelfList then
//    SelfList.Free;
//
//end;


function VaildIndexCount(Stream:TStream;ImageCount:Integer):Boolean;
begin
  if (Stream.Size - Stream.Position) >= (ImageCount *  4) then
    Result := True
  else
    Result := False;
end;

function DoMerge(const FileName:string; StartIndex,EndIndex,ImageCount:Integer; Format:TWZLDATAFormat;PartStream:TStream ;DataFileHeader:TStream):Boolean;
var
  I , nRealLen:Integer;
  WzxHeader: TWZXIndexHeader;
  WzxStream: TFileStream;
  IndexArr: Array of Integer;
  DataHeader : TPackDataHeader;
  wzxFileName:string;
  FileStream : TFileStream;
  WZLHeader: TWZLImageHeader;
  boNeedUpDataHeader:Boolean;
  dwCheckCode : Cardinal;
  MinPosition,MaxPosition : Integer;
  procedure ClearIndex();
  var I :Integer;
  begin
    for i := 0 to ImageCount - 1 do
    begin
      IndexArr[i] := -1;
    end;
  end;
begin
  Result := False;
  boNeedUpDataHeader := False;

  if not DirectoryExists(ExtractFilePath(FileName)) then
    ForceDirectories(ExtractFilePath(FileName));

  //���Ҫ�ϳɵ����ļ�
  if Not FileExists(FileName) then
  begin
    FileStream := TFileStream.Create(FileName,fmCreate);
    if Format = wWZL then
    begin
      WZLHeader.IndexCount := ImageCount;
      WZLHeader.Title := '91GameEngineMiniResource';
      FileStream.Write(WZLHeader, SizeOf(WZLHeader));
    end else
    begin
     //Data�ļ��� ǰ�治д��Header ��ȫ��Ū������ͷ  ��ռλ
      TWMPackageImages.WriteHeader(FileStream,DataHeader);
    end;
    boNeedUpDataHeader := True;
  end else
  begin
    FileStream := TFileStream.Create(FileName,fmOpenReadWrite or fmShareDenyNone);
  end;


   // �����wzl ��ô ����FileStream ����д�뼴�ɡ�Ȼ�����������
   if Format = wWZL then
   begin
     wzxFileName := ChangeFileExt(FileName,'.wzx');
     if not FileExists(wzxFileName) then
      boNeedUpDataHeader := True;

     if  boNeedUpDataHeader  then
     begin   //���������ļ�
       WzxStream := TFileStream.Create(wzxFileName, fmCreate);
       WzxHeader.IndexCount := ImageCount;
       WzxStream.Write(wzxHeader,SizeOf(wzxHeader));
       SetLength(IndexArr, ImageCount);
       ClearIndex;
     end else
     begin    // ��ȡ����
       WzxStream := TFileStream.Create(wzxFileName, fmOpenReadWrite or fmShareDenyNone);
       WzxStream.Read(WzxHeader, SizeOf(WzxHeader)); // ��ͷ
       SetLength(IndexArr, ImageCount);
       WzxStream.Read(IndexArr[0], SizeOf(Integer) * ImageCount);
     end;
   end
   else
   begin
     if  boNeedUpDataHeader then
     begin
       DataHeader := TWMPackageImages.ReadFileHeader(DataFileHeader);
       TWMPackageImages.WriteHeader(FileStream,DataHeader);
       SetLength(IndexArr, ImageCount);
       ClearIndex;
     end else
     begin   // ��ȡ����
       DataHeader := TWMPackageImages.ReadFileHeader(FileStream);
       FileStream.Position := DataHeader.IndexOffSet;
       SetLength(IndexArr, ImageCount);
       if VaildIndexCount(FileStream,ImageCount) then
         FileStream.Read(IndexArr[0], SizeOf(Integer) * ImageCount)
       else
       begin
         TWMPackageImages.WriteHeader(FileStream,DataHeader);
         FileStream.Size := 80;
         ClearIndex;
       end;
     end;

   end;


   PartStream.Position := 0;
   PartStream.Read(dwCheckCode, SizeOf(dwCheckCode));

   if dwCheckCode <> PART_CHK_CODE then
   begin
     raise Exception.Create('У��ʧ�� Part !');
   end;

   //�����Ѿ����ڵ�����Ҫ�����Ƿ���Ҫ����ɾ���� ��������ظ����ݾͲ����в�����
   for i := StartIndex to EndIndex do
   begin
     if IndexArr[i] <> -1 then
     begin
       FileStream.Free;
       Exit;
     end;
   end;



   FileStream.Position := FileStream.Size;
   for i := StartIndex to EndIndex do
   begin
     IndexArr[i] := FileStream.Position;
     // �����ȡ���ĳ��Ȳ��� һ���ṹ��Ϣ ˵���ǿ�ͼƬ
     if PartStream.Read(nRealLen, SizeOf(nRealLen)) < SizeOf(nRealLen) then
     begin
       IndexArr[i] := 0;
     end
     else
     begin
       if nRealLen <> 0 then
         FileStream.CopyFrom(PartStream, nRealLen)
       else
         IndexArr[i] := 0;
     end;
   end;

   // ���� ����
   if Format = wWZL then
   begin
     WzxStream.Position := SizeOf(WzxHeader);
     WzxStream.Write(IndexArr[0], SizeOf(Integer) * ImageCount);
     WzxStream.Free;
   end
   else
   begin
     //ע�� �������ܱ��浽80λ�� ����Data �ļ�����Ϊ ���ǿ�ͼƬ
     if boNeedUpDataHeader then
     begin
       DataHeader.IndexOffSet := FileStream.Position;
       FileStream.Write(IndexArr[0], SizeOf(Integer) * ImageCount);
       TWMPackageImages.WriteHeader(FileStream,DataHeader);
     end else
     begin
       FileStream.Position := DataHeader.IndexOffSet;
       FileStream.Write(IndexArr[0], SizeOf(Integer) * ImageCount);
     end;
   end;

   Result := True;
   FileStream.Free;


end;



procedure TWzlMerge.SaveToWzl(const sFileName: String; MergePartList: TList);
var
  sName, sName2,WzxFileName: string;
  i, K, nIdx, nStart, nEnd: Integer;
  WZLStream, PartMem: TMemoryStream;
  wzxStream: TFileStream;
  dwCheckCode: Cardinal;

  WzxHeader: TWZXIndexHeader;
  nPart, nMergePart: Integer;
  IndexArr: Array of Integer;
  nRealLen: Integer;
  SelfList: TList;
  boFreeSelfList: Boolean;
  DataHeader: TPackDataHeader;
  Header: TWZLImageHeader;
  TempMemoryStream: TMemoryStream;
begin
   sName := GetDirFileName();
   nPart := m_PartIndex.Count;
  // ���ݴ��ݽ����Ĳ���ȷ�� ��Щ������Ҫ�󱻺ϲ���  ���Ϊnil ��˵��ȫ���ϲ�
  if MergePartList = nil then
  begin
    SelfList := TList.Create;
    for i := 0 to nPart - 1 do
    begin
      SelfList.Add(Pointer(i));
    end;
    boFreeSelfList := True;
  end
  else
  begin
    SelfList := MergePartList;
  end;
  TempMemoryStream := TMemoryStream.Create;
  TempMemoryStream.Write(m_DataHeader[1],80);
  PartMem := TMemoryStream.Create;

  for i := 0 to SelfList.Count - 1 do
  begin
    nMergePart := Integer(SelfList.Items[i]);
    PartMem.Clear;

    if m_Format = wData then
      sName2 := ChangeFileExt(sName, '.data' + IntToStr(nMergePart))
    else
      sName2 := ChangeFileExt(sName, '.wzl' + IntToStr(nMergePart));

    PartMem.LoadFromFile(sName2);

    if GetPartStartEnd(nMergePart, nStart, nEnd) then
    begin
      DoMerge(sFileName,nStart,nEnd,m_ImageCount,m_Format,PartMem,TempMemoryStream);
    end;
  end;
  TempMemoryStream.Free;

  if boFreeSelfList then
    SelfList.Free;


end;

end.
