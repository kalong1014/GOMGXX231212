unit Convert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, HUtil32, DIB,
  Dialogs, StdCtrls, ComCtrls, Mask, RzEdit, RzBtnEdt, Buttons, ShlObj, ActiveX, M2Wil,
  ExtCtrls;

type
  TPackDataHeader = record // 新定义的Data文件头
    Title: String[40];
    ImageCount: integer;
    IndexOffSet: integer;
    XVersion: Word; // 0:普通 1:压缩
    Password: String[16];
  end;

  TPackDataImageInfo = packed record // 新定义Data图片信息
    nWidth: Word;
    nHeight: Word;
    BitCount: Byte;
    px: SmallInt;
    py: SmallInt;
    nSize: LongWord;
    GraphicType: TGraphicType; // 0:DIB,BMP 1:PNG
  end;

  TfrmConvertDlg = class(TForm)
    BitBtnClose: TBitBtn;
    BitBtnOK: TBitBtn;
    CheckBox1: TCheckBox;
    EditFileDir: TRzButtonEdit;
    EditSaveDir: TRzButtonEdit;
    Memo1: TMemo;
    OpenDialog: TOpenDialog;
    ProgressBar: TProgressBar;
    ProgressBar1: TProgressBar;
    RzLabel: TLabel;
    RzLabel1: TLabel;
    SaveDialog: TSaveDialog;
    RadioGroupFormat: TRadioGroup;
    procedure CheckBox1Click(Sender: TObject);
    procedure EditFileDirButtonClick(Sender: TObject);
    procedure EditSaveDirButtonClick(Sender: TObject);
    procedure BitBtnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BitBtnOKClick(Sender: TObject);
    procedure RadioGroupFormatClick(Sender: TObject);
  private
    { Private declarations }
    SourceType: TFormatType;
    DesType: TFormatType;
    procedure GetSourceList(sPath: string);
    procedure ConvertSource(SourceName, DestName: string; sText: string);
  public
    { Public declarations }
    procedure Open();
  end;

var
  frmConvertDlg: TfrmConvertDlg;
  StringList: TStringList;
  sFileName: string;
  g_boWalking: Boolean = False;

implementation

{$R *.dfm}

function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: lParam): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpData);
  Result := 0;
end;

function SelectDirectory(const Caption: string; const Root: WideString;
  var Directory: string; Owner: Thandle): Boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := False;
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do begin
        hwndOwner := Owner;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS + BIF_USENEWUI;
        if Directory <> '' then begin
          lpfn := SelectDirCB;
          lParam := Integer(PChar(Directory));
        end;
      end;
      WindowList := DisableTaskWindows(0);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        EnableTaskWindows(WindowList);
      end;
      Result := ItemIDList <> nil;
      if Result then begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

function DoSearchFile(Path, FType: string; var Files: TStringList): Boolean;
var
  Info: TSearchRec;
  s01: string;
  procedure ProcessAFile(FileName: string);
  begin
   {if Assigned(PnlPanel) then
     PnlPanel.Caption := FileName;
   Label2.Caption := FileName;}
  end;
  function IsDir: Boolean;
  begin
    with Info do
      Result := (Name <> '.') and (Name <> '..') and ((Attr and faDirectory) = faDirectory);
  end;
  function IsFile: Boolean;
  begin
    Result := (not ((Info.Attr and faDirectory) = faDirectory)) and (CompareText(ExtractFileExt(Info.Name), FType) = 0);
  end;
begin
  try
    Result := False;
    if FindFirst(Path + '*.*', faAnyFile, Info) = 0 then begin
      while True do begin
        if IsFile then begin
          s01 := Path + Info.Name;
          Files.Add(s01);
        end;

        Application.ProcessMessages;
        if FindNext(Info) <> 0 then Break;
      end;
    end;
    Result := True;
  finally
    FindClose(Info);
  end;
end;

procedure TfrmConvertDlg.GetSourceList(sPath: string);
var
  I: Integer;
  Ext: string;
begin
  StringList.Clear;

  case SourceType of
    WIL: Ext:= '.WIL';
    WZL: Ext:= '.WZL';
    WIS: Ext:= '.WIS';
    DATA: Ext:= '.DATA';
  end;

  DoSearchFile(sPath, Ext, StringList);

  for I := 0 to StringList.Count - 1 do
    Memo1.Lines.Add(StringList.Strings[I])
end;

procedure TfrmConvertDlg.BitBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConvertDlg.BitBtnOKClick(Sender: TObject);
var
  I: Integer;
  sFileName, sDestFile, Name: string;
  btEncr: Byte;
begin
  if g_boWalking then Exit;
  sFileName := Trim(EditFileDir.Text);
  sDestFile := Trim(EditSaveDir.Text);

  if CompareText(sFileName, sDestFile) = 0 then
  begin
    Application.MessageBox('转换路径或文件名不能相同 ！！！', '提示信息', MB_ICONQUESTION);
    Exit;
  end;
  CheckBox1.Enabled := False;
  BitBtnOK.Enabled := False;
  BitBtnClose.Enabled := False;
  EditFileDir.Enabled := False;
  EditSaveDir.Enabled := False;
  g_boWalking := True;
  try
    if CheckBox1.Checked then
    begin
      Memo1.Clear;
      ProgressBar1.Max := StringList.Count;
      ProgressBar1.Position := 0;
      case DesType of
        WZL: Name:= '.WZL';
        DATA: Name:= '.DATA';
      end;

      for I := 0 to StringList.Count - 1 do
      begin
     //   Application.ProcessMessages;
        sFileName := StringList.Strings[I];
        sDestFile := Trim(EditSaveDir.Text) + ExtractFileNameOnly(sFileName) + Name;
        Memo1.Lines.Add(sFileName + ' -> ' + sDestFile);

        ConvertSource(sFileName, sDestFile, '批量数据转换(%d/%d)');
        ProgressBar1.Position := ProgressBar1.Position + 1;
      end;
      Application.MessageBox('转换成功 ！！！', '提示信息', MB_ICONQUESTION);
    end
    else
    begin
      ConvertSource(sFileName, sDestFile, '数据转换(%d/%d)');
      Application.MessageBox('转换成功 ！！！', '提示信息', MB_ICONQUESTION);
    end;

  finally
    g_boWalking := False;
    CheckBox1.Enabled := True;
    BitBtnOK.Enabled := True;
    BitBtnClose.Enabled := True;
    EditFileDir.Enabled := True;
    EditSaveDir.Enabled := True;
  end;
end;

procedure TfrmConvertDlg.ConvertSource(SourceName, DestName: string; sText: string);
const
  MAXBUFFERLEN = 1024 * 1024 * 50;
var
  fhandle: THandle;
  I, nX, nY, nShadowX, nShadowY, nShadow: Integer;
  WMImageHeader: TPackDataHeader;
  ImageInfo: TPackDataImageInfo;
  WMImages: TWMPackageImages;
  Bitmap: TDIB;
  DataBuffer: PChar;
  DataBufferLen: Integer;
  Source: TGraphic;
begin
  try
    DataBuffer := nil;
    Bitmap := nil;
    ProgressBar.Max := 0;
    ProgressBar.Position := 0;
    if FileExists(SourceName) then begin
//      if g_OldWMImages <> nil then begin
//        g_OldWMImages.Free;
//        g_OldWMImages := nil;
//      end;

//      g_OldWMImages := CreateImages(SourceName);
      g_OldWMImages := CreateImages(SourceName, True);
      if g_OldWMImages <> nil then begin
        g_OldWMImages.Initialize;
        ProgressBar.Max := g_OldWMImages.ImageCount;

        if FileExists(DestName) then begin
          if MessageBox(Handle, '文件已经存在，是否覆盖原文件？', '提示信息', MB_OKCANCEL + MB_ICONWARNING) = IDCANCEL then
            exit;
          DeleteFile(DestName);
        end;
//        fhandle := FileCreate(DestName, fmOpenWrite);
        {if fhandle > 0 then }begin
//          FillChar(WMImageHeader, SizeOf(TPackDataHeader), #0);
//          WMImageHeader.Title := '奇奇网络资源文件';
//          WMImageHeader.ImageCount := 0;
//          WMImageHeader.IndexOffSet := 80;
//          WMImageHeader.XVersion := 0;
//          WMImageHeader.Password := '';
//          FileWrite(fhandle, WMImageHeader, SizeOf(WMImageHeader));
//          FileClose(fhandle);

          g_NewWMImages := CreateImageFile(DestName);

          if g_NewWMImages <> nil then begin
            g_NewWMImages.Free;
            g_NewWMImages := nil;
          end;
//          g_NewWMImages := CreateImages(DestName);
          g_NewWMImages := CreateImages(DestName, True);
          if g_NewWMImages <> nil then begin
            g_NewWMImages.Initialize;
            WMImages := TWMPackageImages(g_NewWMImages);
            if g_OldWMImages.ImageCount > 0 then
            begin
//              DataBuffer := nil;
//              Bitmap := nil;
              try
                g_NewWMImages.BeginUpdate;
                for I := 0 to g_OldWMImages.ImageCount - 1 do
                begin
                  Application.ProcessMessages;
                  ProgressBar.Position := ProgressBar.Position + 1;

                  nX := 0;
                  nY := 0;

//                  if DataBuffer <> nil then begin
//                    FreeMem(DataBuffer);
//                  end;
//                  if Bitmap <> nil then begin
//                    Bitmap.Free;
//                  end;
//                  DataBuffer := nil;
//                  Bitmap := nil;
//                  DataBufferLen := 0;

//                  Bitmap := TBitmap.Create;
//                  Bitmap.PixelFormat := pf16bit;
//                  try
                  Source := g_OldWMImages.Graphics[I];


                  if (Source <> nil) and (Source.Width = 1) and (Source.Height = 1) {and (Source.Pixels[0, 0] = 0)} then
                  begin
                    FreeAndNil(Source);
                  end;
//                  except
//                    Bitmap := nil;
//                  end;
//                  BitMap.Clear;
//                  if Bitmap <> nil then begin
//                    nX := g_OldWMImages.LastImageInfo.px;
//                    nY := g_OldWMImages.LastImageInfo.py;
//                  end;
                  if SourceType in [WIL,WIS] then begin
                    nX := g_OldWMImages.LastWilImageInfo.px;
                    nY := g_OldWMImages.LastWilImageInfo.py;
                  end else if SourceType = WZL then begin
                    nX := g_OldWMImages.LastWzlImageInfo.m_wPx;
                    nY := g_OldWMImages.LastWzlImageInfo.m_wPy;
                  end;

//                  BitMap.SaveToFile('1.BMP');

//                  if Bitmap.Empty then begin
//                    g_NewWMImages.Add(nil, 0, 0, gtDIB);
//                    Continue;
//                  end
//                  else begin
//                   Source.SaveToFile('1.BMP');
//                    Source := Bitmap;
                  if (Source <> nil) and (Source is TDIB) then
                    TDIB(Source).Mirror(False, True);

                  g_NewWMImages.Add(Source, nX, nY, gtDIB);

//                      g_NewWMImages.BeginUpdate;
//                      if g_NewWMImages.Add(Source, nX, nY, gtDIB) then
//                      begin
//                        g_NewWMImages.EndUpdate;
//                      end;
//                      Source.Free;
//                    end;

//                    将图型数据转换为存储数据
//                    DataBufferLen := FormatBitmap(Bitmap, g_OutBackColor, DataBuffer);
//                    FillChar(ImageInfo, SizeOf(ImageInfo), #0);
//                    ImageInfo.px := nX;
//                    ImageInfo.py := nY;
//                    ImageInfo.nWidth := Bitmap.Width;
//                    ImageInfo.nHeight := Bitmap.Height;
//                    ImageInfo.nDataSize := DataBufferLen;
//                    ImageInfo.btImageFormat := WILFMT_R5G6B5;
//                  end;
//                  if Bitmap <> nil then begin
//                    Bitmap.Free;
//                    Bitmap := nil;
//                  end;
                  if Source <> nil then
                    Source.Free;
//                  if (DataBufferLen > 0) and (DataBuffer <> nil) then begin
//                    if DataBufferLen + SizeOf(ImageInfo) > MAXBUFFERLEN then begin
//                      Application.MessageBox(PChar(Format('第%d号图像',[I]) + #13#10 +
//                        '内存溢出，数据大小(' + IntToStr(DataBufferLen) + ')'), '提示信息', MB_OK + MB_ICONSTOP);
//                      break;
//                    end;
//                    WMImages.AddDataToFile(@ImageInfo, DataBuffer, DataBufferLen);
//                  end else begin
//                    g_NewWMImages.AddIndex(-1, 0);
//                  end;
//                  if DataBuffer <> nil then begin
//                    FreeMem(DataBuffer);
//                    DataBuffer := nil;
//                  end;
                end;
                g_NewWMImages.EndUpdate;

//                WMImages.SaveIndexList;
              finally
                if Assigned(g_NewWMImages) then
                begin
                  g_NewWMImages.Free;
                end;
                if Assigned(g_OldWMImages) then
                begin
                  g_OldWMImages.Free;
                end;
//                if Bitmap <> nil then
//                  Bitmap.Free;
//                if DataBuffer <> nil then begin
//                  FreeMem(DataBuffer);
//                end;                                                    h
              end;
            end;
          end;
        end;
      end;
    end;

//    if g_NewWMImages <> nil then begin
//      FreeAndNil(g_NewWMImages);
//    end;
//    if g_OldWMImages <> nil then begin
//      FreeAndNil(g_OldWMImages);
//    end;
  except
    Memo1.Lines.Add('effor ');
  end;
end;

procedure TfrmConvertDlg.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    RzLabel.Caption := '旧文件目录:';
    RzLabel1.Caption := '新文件目录:';
  end
  else
  begin
    RzLabel.Caption := '旧文件:';
    RzLabel1.Caption := '新文件:';
  end;
end;

procedure TfrmConvertDlg.EditFileDirButtonClick(Sender: TObject);
var
  Directory: string;
  sPath: string;
begin
  if CheckBox1.Checked then
  begin
    if SelectDirectory('浏览文件夹', '', sPath, frmConvertDlg.Handle) then
    begin
      if (sPath <> '') and (sPath[Length(sPath)] <> '\') then sPath := sPath + '\';
      EditFileDir.Text := sPath;
      GetSourceList(EditFileDir.Text);
    end;
  end
  else
  begin
    with OpenDialog do
    begin
       case SourceType of
         WIL,WIS:begin
           Filter := 'Mir2 Library File|*.WIL;*.WZL';
         end;
         WZL:begin
           Filter := 'Mir2 Library ZIP File|*.WZL';
         end;
         DATA:begin
           Filter := 'Mir2 Data File|*.Data';
         end;
       end;

      if Execute and (FileName <> '') then
      begin
        sFileName := OpenDialog.FileName;
        EditFileDir.Text := FileName;
      end;
    end;
  end;
end;

procedure TfrmConvertDlg.EditSaveDirButtonClick(Sender: TObject);
var
  sPath, Ext: string;
begin
  if CheckBox1.Checked then
  begin
    if SelectDirectory('浏览文件夹', '', sPath, frmConvertDlg.Handle) then
    begin
      if (sPath <> '') and (sPath[Length(sPath)] <> '\') then sPath := sPath + '\';
      EditSaveDir.Text := sPath;
    end;
  end
  else
  begin
    with SaveDialog do
    begin
       case DesType of
         WIL:begin
           Ext:= '.WIL';
           Filter := 'Mir2 Library File (*.WIL)|*.WIL';
         end;
         WZL:begin
           Ext:= '.WZL';
           Filter := 'Mir2 Library ZIP File (*.WZL)|*.WZL';
         end;
         DATA:begin
           Ext:= '.DATA';
           Filter := 'Mir2 Data File (*.Data)|*.Data';
         end;
       end;

      FileName := ExtractFilePath(EditFileDir.Text) + ExtractFileNameOnly(EditFileDir.Text){ + ExtractFileExt(EditFileDir.Text)};
      if Execute and (FileName <> '') then
      begin
        FileName := ExtractFilePath(FileName) + ExtractFileNameOnly(FileName)+ Ext;

        EditSaveDir.Text := FileName;
      end;
    end;
  end;
end;

procedure TfrmConvertDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not g_boWalking;
end;

procedure TfrmConvertDlg.FormCreate(Sender: TObject);
begin
  ModalResult := 0;
  StringList := TStringList.Create;
  OpenDialog.Filter := '传奇3复刻版资源文件|*.Lib;*.Wil';
end;

procedure TfrmConvertDlg.FormDestroy(Sender: TObject);
begin
  StringList.Free;
end;

procedure TfrmConvertDlg.Open;
begin
  RadioGroupFormat.ItemIndex := 0;
  ShowModal;
end;


procedure TfrmConvertDlg.RadioGroupFormatClick(Sender: TObject);
begin
  case RadioGroupFormat.ItemIndex of
    0:begin
      SourceType:= WIL;
      DesType:= DATA;
    end;
    1:begin
      SourceType:= WIL;
      DesType:= WZL;
    end;
    2:begin
      SourceType:= WZL;
      DesType:= DATA;
    end;
    3:begin
      SourceType:= WIS;
      DesType:= DATA;
    end;
    4:begin
      SourceType:= WIS;
      DesType:= WZL;
    end;
  end;
end;

end.
