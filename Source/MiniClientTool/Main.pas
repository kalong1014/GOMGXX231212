unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, RzPathBar, StdCtrls, wil, Menus, RzShellDialogs,
  RzStatus, ComCtrls, HUtil32, ZLib, RzSplit, uMD5, FileCtrl, uMiniResFileInfo,
  MiniResBuilderConfig;

type
  TForm1 = class(TForm)
    lbledt_Src: TLabeledEdit;
    lbledt_Target: TLabeledEdit;
    btn_Src: TButton;
    btn_Target: TButton;
    btn_TestSplRes: TButton;
    btn_Meger: TButton;
    mm_FileList: TMemo;
    btn1: TButton;
    btn_BuildDataRes: TButton;
    mm_log: TMemo;
    btn_BuildMapRes: TButton;
    btn_BuildWav: TButton;
    btn_ListFileToTree: TButton;
    btn_BuilderMiniClientFile: TButton;
    rzspltr_PathAndLog: TRzSplitter;
    Progress_Mini: TRzProgressStatus;
    Progress_Total: TRzProgressStatus;
    mm: TMainMenu;
    MI_Menu: TMenuItem;
    MI_MergeFile: TMenuItem;
    grp_TestFunction: TGroupBox;
    btn_PackageMiniData: TButton;
    btn_EnumPackageFile: TButton;
    lst_FileName: TListBox;
    pnl1: TPanel;
    grp_FileList: TGroupBox;
    btn_AddFile: TButton;
    btn_DelFile: TButton;
    dlgOpen1: TOpenDialog;
    btn_DoOtherFiles: TButton;
    lbledt_Password: TLabeledEdit;
    procedure btn_TestSplResClick(Sender: TObject);
    procedure btn_MegerClick(Sender: TObject);
    procedure btn_SrcClick(Sender: TObject);
    procedure btn_TargetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn_BuildDataResClick(Sender: TObject);
    procedure btn_BuildMapResClick(Sender: TObject);
    procedure btn_BuildWavClick(Sender: TObject);
    procedure btn_ListFileToTreeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_BuilderMiniClientFileClick(Sender: TObject);
    procedure MI_MergeFileClick(Sender: TObject);
    procedure btn_PackageMiniDataClick(Sender: TObject);
    procedure btn_EnumPackageFileClick(Sender: TObject);
    procedure btn_AddFileClick(Sender: TObject);
    procedure btn_DelFileClick(Sender: TObject);
    procedure btn_DoOtherFilesClick(Sender: TObject);
  private
    { Private declarations }
    m_DataList : TStringList;
    m_WavList : TStringList;
    m_MapList : TStringList;
    m_Config: TMiniResBuilderConfig;
    procedure addLog(s:string);
    procedure CommomProcessFile(sTargetDir, sExt, sDesc: String ; FileList : TStrings);
  public
    { Public declarations }
    procedure OnException(Sender: TObject; E: Exception);
  end;

var
  Form1: TForm1;
  procedure FindAllFile(Path, DefExt: string; DestResult : TStrings ; boChild : Boolean = true);

implementation

uses
  WzlSpliter, WzlMerge, MergeFile, {Miros,} uJclExceptionLog, Grobal2;


{$R *.dfm}

function TickCountToStr(dwTickCount	:	Cardinal):String;
const
  ASecTick          = 1000;
  AMinTick          = ASecTick * 60;
  AHourTick         = AMinTick * 60;
  ADaysTick         = AHourTick * 24;
var
  TickCount: Cardinal;
  nVal: Integer;
begin
  Result := '';
  TickCount := dwTickCount;
  nVal := TickCount div ADaysTick;
  if nVal > 0 then
  begin
    Result := Result + IntToStr(nVal) + '天';
    Dec(TickCount, nVal * ADaysTick);
  end;
  nVal := TickCount div AHourTick;
  if nVal > 0 then
  begin
    Result := Result + IntToStr(nVal) + '小时';
    Dec(TickCount, nVal * AHourTick);
  end;
  nVal := TickCount div AMinTick;
  if nVal > 0 then
  begin
    Result := Result + IntToStr(nVal) + '分';
    Dec(TickCount, nVal * AMinTick);
  end;
  nVal := TickCount div ASecTick;
  if nVal > 0 then
  begin
    Result := Result + IntToStr(nVal) + '秒';
  end;
  nVal := TickCount mod ASecTick;
  if nVal > 0 then
  begin
    Result := Result + IntToStr(nVal) + '毫秒';
  end;
end;
procedure FindAllDir(Path: string; DestResult : TStrings);
var
  Sr: TSearchRec;
begin
  if FindFirst(Path + '\*.*', faAnyfile, Sr) = 0 then
  if (Sr.Name <> '.' ) and (Sr.Name <> '..') then
   if (Sr.Attr and faDirectory)=faDirectory then
    begin
      DestResult.Add(path + '\' + Sr.Name);
      FindAllDir(Path + '\' + Sr.Name, DestResult);
    end;
   while FindNext(Sr) = 0 do
    begin
     if (Sr.Name <> '.' ) and (Sr.Name <> '..') then
     if (Sr.Attr and faDirectory)=faDirectory then
      begin
       DestResult.Add(path + '\' + Sr.Name);
       FindAllDir(Path + '\' + Sr.Name, DestResult);
      end;
      Application.ProcessMessages;
    end;
  FindClose(Sr);
end;
procedure FindAllFile(Path, DefExt: string; DestResult : TStrings ; boChild : Boolean);
var
  Sr: TSearchRec;
  SL: TStrings;
  I : Integer;
begin
  if boChild then
  begin
    SL := TStringList.Create;
    SL.Add(Path);
    FindAllDir(Path, SL);
    for I := 0 to SL.Count - 1 do
    begin
       if FindFirst(SL[I] + '\' + DefExt, faAnyFile, Sr) = 0 then
       begin
        if (Sr.Name <> '..') and (Sr.Name <> '.') then
        DestResult.Add(SL[I] + '\' + Sr.Name);
       end;
      while FindNext(Sr) = 0 do
        begin
          if (Sr.Name <> '..') and (Sr.Name <> '.') then
          begin
            DestResult.Add(SL[I] + '\' + Sr.Name);
            Application.ProcessMessages;
          end;
        end;
    end;
    FreeAndNil(SL);
    FindClose(Sr);
  end else
  begin
    if FindFirst(Path + DefExt , faAnyFile ,Sr) = 0 then
    begin
      if (Sr.Attr and faArchive <> 0) and ( Sr.Attr and faDirectory = 0) then
      begin
        DestResult.Add(Path + Sr.Name);
      end;
      while FindNext(Sr) = 0 do
      begin
        if (Sr.Attr and faArchive <> 0) and ( Sr.Attr and faDirectory = 0) then
        begin
          DestResult.Add(Path + Sr.Name);
        end;
      end;
    end;
    FindClose(Sr);
  end;
end;

procedure TForm1.addLog(s: string);
begin
  mm_log.Lines.Add(s);
end;

procedure TForm1.btn1Click(Sender: TObject);
var
  List : TStrings;
  List2 : TStringList;
  i:Integer;
begin
  List := TStringList.Create;

  List2 := TStringList.Create;
  List2.Sorted := True;
  List2.Duplicates := dupIgnore;

  FindAllFile(lbledt_Src.Text + 'Data','*.wil',List);
  FindAllFile(lbledt_Src.Text + 'Data','*.wzl',List);

  for I := 0 to List.Count - 1 do
  begin
    List2.Add(ChangeFileExt(List[i],'.wzl'));
  end;

  FindAllFile(lbledt_Src.Text + 'Wav','*.wav',List2);
  FindAllFile(lbledt_Src.Text + 'Wav','*.lst',List2);
  FindAllFile(lbledt_Src.Text + 'Map','*.map',List2);

  //FindAllFile(lbledt_Src.Text ,'*.*',List2 , False);

   mm_FileList.Lines.Assign(List2);

  List2.Free;
  List.Free;
end;

procedure TForm1.btn_BuilderMiniClientFileClick(Sender: TObject);
var
 dwTickCount : Cardinal;
begin
  dwTickCount := GetTickCount;
  Progress_Total.TotalParts := 5;
  Progress_Total.PartsComplete := 0;
  
  btn_ListFileToTreeClick(nil);
  Progress_Total.IncPartsByOne;

  btn_BuildDataResClick(nil);  //Data资源
   Progress_Total.IncPartsByOne;

  btn_BuildMapResClick(nil);   //地图资源
  Progress_Total.IncPartsByOne;

  btn_BuildWavClick(nil);     //音频资源
  Progress_Total.IncPartsByOne;

  btn_DoOtherFilesClick(nil);    //其他资源
  Progress_Total.IncPartsByOne;

  btn_PackageMiniDataClick(Self); //打包minidata描述

  ShowMessage('处理完成 : ' + TickCountToStr(GetTickCount - dwTickCount ));
end;

procedure TForm1.btn_BuildMapResClick(Sender: TObject);
var
  MapList:TStringList;
  I: Integer;
  Ext:string;
begin
  MapList := TStringList.Create;
  Try

    for i := 0 to lst_FileName.Items.Count - 1 do
    begin
      Ext := UpperCase(ExtractFileExt(lst_FileName.Items[i]));
      if (Ext = '.MAP') then
        MapList.Add(lst_FileName.Items[i]);
    end;

    CommomProcessFile('Map','*.map','地图文件',MapList);

  Finally
    MapList.Free;
  End;
  if Sender <> nil then
  begin
    btn_PackageMiniDataClick(Self); //打包minidata描述
    ShowMessage('完成!');
  end;
end;

procedure TForm1.btn_AddFileClick(Sender: TObject);
var
  I :Integer;
  Duplicast : TStringList;  //用以过滤重复的文件
begin
  with TOpenDialog.Create(nil) do
  try
    Filter := '资源文件|*.wzl;*.data|音频文件|*.wav;*.mp3;*.ogg|地图文件|*.map|所有文件|*.*';
    Options := Options + [ofAllowMultiSelect];
    InitialDir := m_Config.ClientPath;
    if Execute then
    begin
      Duplicast := TStringList.Create;
      Try
        Duplicast.Duplicates := dupIgnore;
        for i := 0 to lst_FileName.Items.Count - 1 do
        begin
          Duplicast.Add(lst_FileName.Items[i]);
        end;

        for I := 0 to Files.Count - 1 do
        begin
          Duplicast.Add(StringReplace(Files[i],m_Config.ClientPath,'',[rfReplaceAll]));
        end;

        lst_FileName.Items.Assign(Duplicast);
      Finally
        Duplicast.Free;
      End;
    end;
  finally
    Free;
  end;
end;

procedure TForm1.btn_BuildDataResClick(Sender: TObject);
var
  SP : TWzlSpliter;
  Image : TWMImages;
  I : Integer;
  sFileName : string;
  dwTick , dwTotalTickCount : Cardinal;
  sMD5 : string;
  nRetCode : Integer;
  DataList:TStringList;
  Ext : string;
begin
  //开始处理
  DataList := TStringList.Create;
  for i := 0 to lst_FileName.Items.Count - 1 do
  begin
    Ext := UpperCase(ExtractFileExt(lst_FileName.Items[i]));
    if (Ext = '.WZL') or (Ext = '.DATA') then
      DataList.Add(lst_FileName.Items[i]);
  end;

  dwTotalTickCount := GetTickCount;
  Progress_Mini.TotalParts := DataList.Count;
  for i := 0 to DataList.Count - 1 do
  begin
    Progress_Mini.IncPartsByOne;
    dwTick := GetTickCount;
    sFileName := m_Config.ClientPath + ChangeFileExt(DataList[i],'.Data');
    if FileExists(sFileName) then
    begin
      Image := TWMPackageImages.Create();
    end else
    begin
      sFileName := ChangeFileExt(sFileName,'.wzl');
      Image := TWZLImages.Create();
    end;

    Image.FileName := sFileName;
    addLog('[处理] : ' + sFileName);

    Image.Initialize;

    SP := TWzlSpliter.Create(Image);
    nRetCode := SP.SaveToDir(lbledt_Target.Text + ExtractFilePath(DataList[i]));
    SP.Free;
    case nRetCode of
      0:addLog('[处理完毕] : 耗时 ' + TickCountToStr(GetTickCount - dwTick ) + ' |' + sFileName);
      1:addLog('[文件无需更新] : ' + sFileName);
      2:addLog('[文件图片数量为 0  跳过 ] : ' + sFileName);
    end;

  end;

  DataList.Free;
  Application.ProcessMessages;
  addLog('处理完毕:共计耗时:' + TickCountToStr(GetTickCount - dwTotalTickCount ));
  if Sender <> nil then
  begin
    btn_PackageMiniDataClick(Self); //打包minidata描述
    ShowMessage('完成');
  end;
end;

procedure TForm1.btn_BuildWavClick(Sender: TObject);
var
  SoundList:TStringList;
  I:Integer;
  Ext:String;
begin
  SoundList := TStringList.Create;
  Try
    for i := 0 to lst_FileName.Items.Count - 1 do
    begin
      Ext := UpperCase(ExtractFileExt(lst_FileName.Items[i]));
      if (Ext = '.WAV') or (Ext = '.OGG') or (Ext = 'MP3') then
        SoundList.Add(lst_FileName.Items[i]);
    end;
    CommomProcessFile('Wav','*.wav','音频文件',SoundList);

  Finally
    SoundList.Free;
  End;

  if Sender <> nil then
  begin
    btn_PackageMiniDataClick(Self); //打包minidata描述
    ShowMessage('完成');
  end;
end;

procedure TForm1.btn_DelFileClick(Sender: TObject);
var
  I : Integer;
begin
  for i := lst_FileName.Items.Count - 1 downto 0  do
  begin
    if lst_FileName.Selected[i] then
      lst_FileName.Items.Delete(i);
  end;
end;

procedure TForm1.btn_DoOtherFilesClick(Sender: TObject);
var
  OtherList:TStringList;
  I: Integer;
  Ext:string;
begin
  OtherList := TStringList.Create;
  Try

    for i := 0 to lst_FileName.Items.Count - 1 do
    begin
      Ext := UpperCase(ExtractFileExt(lst_FileName.Items[i]));
      if (Ext <> '.MAP') and (Ext <> '.DATA') and (Ext <> '.WZL')
         and (Ext <> '.OGG') and (ext <> '.MP3') and (ext <> '.WAV')then
        OtherList.Add(lst_FileName.Items[i]);
    end;

    CommomProcessFile('','*.Map','其他文件',OtherList);

  Finally
    OtherList.Free;
  End;
  if Sender <> nil then
  begin
    btn_PackageMiniDataClick(Self); //打包minidata描述
    ShowMessage('完成！');
  end;
end;

procedure TForm1.btn_EnumPackageFileClick(Sender: TObject);
var
  Package : TMiniResFilePackage;
begin
  Package := TMiniResFilePackage.Create;
  Package.LoadPackageFromFile(lbledt_Target.Text + '\MiniVer.db','123456');

  Package.EachFileMD5(procedure (const FileName:String ; const MD5:String)
  begin
    Self.mm_log.Lines.Add(FileName);
  end);

  Package.SetRoot('H:\游戏\热血传奇');
  Package.IncludeFile('H:\游戏\热血传奇\Map\3.map');
  Package.IncludeImageFile('H:\游戏\热血传奇\data\cbohair.wzl');
  Package.IncludeSoundFile('H:\游戏\热血传奇\wav\005.wav');
  Package.Free;
end;

procedure TForm1.btn_ListFileToTreeClick(Sender: TObject);
var
  List : TStringList;
  DataList : TStringList;
  i: Integer;
  DataNode , WavNode, MapNode : TTreeNode;
begin
  List := TStringList.Create;
  List.Sorted := True;
  List.Duplicates := dupIgnore;

  DataList := TStringList.Create;

  //列举图片资源文件
  FindAllFile(lbledt_Src.Text + 'Data','*.Data',DataList);
  FindAllFile(lbledt_Src.Text + 'Data','*.wzl',DataList);
  for i := 0 to DataList.Count - 1 do
  begin
    List.Add(ChangeFileExt(DataList[i],'.wzl'));  //去重复wil  wzl
  end;
  DataList.Free;

//  tv_FileList.Items.Clear;
//  tv_FileList.Items.BeginUpdate;
//  DataNode := tv_FileList.Items.AddChild(nil,'图片资源');
//  for I := 0 to List.Count - 1 do
//  begin
//    tv_FileList.Items.AddChild(DataNode,ExtractFileName(List[i]));
//  end;
//
//  m_DataList.Assign(List);
//  m_DataList.SaveToFile(lbledt_Target.Text + '\MiniClientFileList.txt');
//  List.Clear;
//
//  //列举音频文件
//  FindAllFile(lbledt_Src.Text + 'wav','*.wav',List);
//  FindAllFile(lbledt_Src.Text + 'wav','*.lst',List);
//  WavNode := tv_FileList.Items.AddChild(nil,'音频文件');
//  for I := 0 to List.Count - 1 do
//  begin
//    tv_FileList.Items.AddChild(WavNode,ExtractFileName(List[i]));
//  end;
//
//  m_WavList.Assign(List);
//  List.Clear;
//
//  //列举地图文件
//  MapNode := tv_FileList.Items.AddChild(nil,'地图文件');
//  FindAllFile(lbledt_Src.Text + 'map','*.map',List);
//  for I := 0 to List.Count - 1 do
//  begin
//    tv_FileList.Items.AddChild(MapNode,ExtractFileName(List[i]));
//  end;
//
//  tv_FileList.Items.EndUpdate;
//  m_MapList.Assign(List);
//  List.Free;

end;

procedure TForm1.btn_MegerClick(Sender: TObject);
var
  Merge : TWzlMerge;
  List:TList;
begin
  List := TList.Create;
  List.Add(Pointer(1));
  //Merge := TWzlMerge.Create('D:\MiniClient\Data\ChrSel\');
  Merge := TWzlMerge.Create('J:\MiniClientData\StateItem\');
  Merge.SaveToDir('J:\',List);
  Merge.Free;
  List.Free;
  ShowMessage('Done');
end;

procedure TForm1.btn_PackageMiniDataClick(Sender: TObject);
var
  MiniDataList : TStringList;
  Package : TMiniResFilePackage;
  i: Integer;
  TargetPath:String;
begin
  MiniDataList := TStringList.Create;
  TargetPath := lbledt_Target.Text;

  if TargetPath[Length(TargetPath)] = '\' then
    Delete(TargetPath,Length(TargetPath),1);

  //列举图片资源文件
  FindAllFile(TargetPath,'*.MiniData',MiniDataList);
  FindAllFile(TargetPath,'*.z',MiniDataList);

  if TargetPath[Length(TargetPath)] <> '\' then
    TargetPath :=  TargetPath + '\';

  Package := TMiniResFilePackage.Create;
  Package.SetRoot(TargetPath);
  Package.BuildPackage(MiniDataList,TargetPath + 'MiniVer.db',lbledt_Password.Text);
  Package.Free;
end;

procedure TForm1.btn_TestSplResClick(Sender: TObject);
var
  Image : TWMImages;
  uRes : TWzlSpliter;
begin
  Image := TWZLImages.Create();
  Image.FileName := 'H:\游戏\热血传奇\data\Objects2.wzl';

  //Image := TWMPackageImages.Create;
  //Image.FileName := 'H:\游戏\热血传奇\91Resource\Data\StateItem.Data';

  Image.Initialize;
  uRes := TWzlSpliter.Create(Image);
  uRes.SaveToDir('D:\MiniClient\');
  uRes.Free;
  ShowMessage('Ok');
end;

procedure TForm1.btn_SrcClick(Sender: TObject);
var
  DirName:String;
begin
  if SelectDirectory('选择传奇客户端目录','',DirName,[sdNewFolder],Self) then
  begin
    lbledt_Src.Text := DirName + '\';
    m_Config.ClientPath := DirName + '\';
    //btn_ListFileToTreeClick(Self);//重新分析文件
  end;

end;

procedure TForm1.btn_TargetClick(Sender: TObject);
var
  DirName:String;
begin
  if SelectDirectory('选择传奇客户端目录','',DirName,[sdNewFolder],Self) then
  begin
    lbledt_Target.Text := DirName + '\';
    m_Config.TargetPath := DirName + '\';
  end;

end;

procedure TForm1.CommomProcessFile(sTargetDir, sExt, sDesc: String ; FileList : TStrings);
var
  List : TStringList;
  I: Integer;
  FileStream , TargetFileStream : TFileStream;
  CompressStream : TCompressionStream;
  DestStream : TMemoryStream;
  sName , sTargetName , sPath :string;
  dwCheckCode : Cardinal;
  MD5,MD52:AnsiString;
begin

  List := TStringList.Create;
  
  sPath := lbledt_Target.Text + sTargetDir + '\';

  if FileList = nil then
  begin
    FindAllFile(lbledt_Src.Text + sTargetDir,sExt,List);
  end else
  begin
    List.Assign(FileList);
  end;

  if not DirectoryExists(sPath) then
    ForceDirectories(sPath);

  Progress_Mini.TotalParts := List.Count;
  for I := 0 to List.Count - 1 do
  begin
    Progress_Mini.IncPartsByOne;
    sName := m_Config.ClientPath + List[i];

    addLog(Format('[处理%s文件:] %s',[sDesc,sName]));

    //获取地图MD5
    MD5 := MD5File(sName);
    sExt := ExtractFileExt(sName);
    //检查地图是否改变 没有改变不需要进行写入
    if sTargetDir <> '' then
      sTargetName := sPath + ExtractFileNameOnly(sName) + sExt +'.z'
    else
      sTargetName := sPath + List[i] + '.z';

    if FileExists(sTargetName) then
    begin
      TargetFileStream := TFileStream.Create(sTargetName,fmOpenRead or fmShareDenyNone);
      TargetFileStream.Read(dwCheckCode,SizeOf(dwCheckCode));
      SetLength(MD52,Length(MD5));
      if dwCheckCode = PART_CHK_CODE then
      begin
        TargetFileStream.Read(MD52[1],Length(MD5));
        if MD52 = MD5 then
        begin
          addLog(Format('[%s无需更新:] %s',[sDesc,sName]));
          TargetFileStream.Free;
          Continue;
        end;

      end;
      TargetFileStream.Free;
    end;


    FileStream := TFileStream.Create(sName,fmOpenRead or fmShareDenyNone);

    //压缩文件
    DestStream := TMemoryStream.Create;

    //写入文件验证
    dwCheckCode := PART_CHK_CODE;
    DestStream.Write(dwCheckCode,SizeOf(dwCheckCode));
    //写入MD5
    DestStream.Write(MD5[1],Length(MD5));
    
    //写入原文件流
    CompressStream := TCompressionStream.Create(clMax,DestStream);
    CompressStream.CopyFrom(FileStream,FileStream.Size);
    CompressStream.Free;
    DestStream.SaveToFile(sTargetName);

    Application.ProcessMessages;

    FileStream.Free;
    DestStream.Free;
  end;
  addLog(Format('========【%s文件完毕】=======',[sDesc]));
  List.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  lbledt_Src.Text := 'H:\游戏\热血传奇\';
  lbledt_Target.Text := 'D:\MiniClient\';

  m_DataList := TStringList.Create;
  m_WavList := TStringList.Create;
  m_MapList := TStringList.Create;

  if DirectoryExists(lbledt_Src.Text) then
  begin
    btn_ListFileToTreeClick(self);
  end;

  m_Config := TMiniResBuilderConfig.Create;
  m_Config.LoadFromXMLFile('.\Config.xml');
  lbledt_Src.Text := m_Config.ClientPath;
  lbledt_Target.Text := m_Config.TargetPath;
  lbledt_Password.Text := m_Config.PassWord;
  lst_FileName.Items.Assign(m_Config.FileList);
  Application.OnException := Self.OnException;
  Caption := '微端资源构建器'{ + Grobal2.APP_VERSION};
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  m_DataList.Free;
  m_WavList.Free;
  m_MapList.Free;

  m_Config.PassWord := lbledt_Password.Text;
  m_Config.FileList.Assign(lst_FileName.Items);
  m_Config.SaveToXMLFile('.\Config.xml');
  m_Config.Free;
end;

procedure TForm1.MI_MergeFileClick(Sender: TObject);
begin
  With TfrmMerge.Create(Self) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TForm1.OnException(Sender: TObject; E: Exception);
begin
  LogException(Sender,E);
end;

end.
