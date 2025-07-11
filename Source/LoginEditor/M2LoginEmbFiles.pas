unit M2LoginEmbFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer,
  cxClasses, dxBar, cxButtonEdit, cxTextEdit, uCliTypes, dxStatusBar, cxCheckBox,
  IOUtils, ImgList, dxSkinsCore, dxSkinsdxStatusBarPainter, dxSkinsdxBarPainter,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light;

type
  TLoginEmbFilesEditor = class(TForm)
    BarManager: TdxBarManager;
    ToolBar: TdxBar;
    FilesTree: TcxTreeList;
    FileNameColumn: TcxTreeListColumn;
    PathColumn: TcxTreeListColumn;
    BtnSave: TdxBarButton;
    BtnAdd: TdxBarButton;
    BtnDel: TdxBarButton;
    dxBarButton4: TdxBarButton;
    BarPopupMenu: TdxBarPopupMenu;
    StatusBar: TdxStatusBar;
    dxBarButton1: TdxBarButton;
    ZLibCol: TcxTreeListColumn;
    RepColumn: TcxTreeListColumn;
    ImageList: TcxImageList;
    procedure dxBarButton4Click(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure FilesTreeSelectionChanged(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure FileNameColumnPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PathColumnPropertiesEditValueChanged(Sender: TObject);
    procedure FileNameColumnPropertiesChange(Sender: TObject);
    procedure FileNameColumnPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure ZLibColPropertiesEditValueChanged(Sender: TObject);
    procedure RepColumnPropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    FFiles: TEmbeddedFiles;
    FSaveCount: Integer;
    procedure Modify;
    procedure Save;
    procedure Load;
    procedure CalcAllSize;
  public
    { Public declarations }
  end;

function EditEmbeddedFiles(AFiles: TEmbeddedFiles): Boolean;

implementation

{$R *.dfm}

function EditEmbeddedFiles(AFiles: TEmbeddedFiles): Boolean;
begin
  with TLoginEmbFilesEditor.Create(nil) do
    try
      FFiles := AFiles;
      Load;
      ShowModal;
      Result := FSaveCount > 0;
    finally
      Free;
    end;
end;

{ TLoginEmbFilesEditor }

procedure TLoginEmbFilesEditor.BtnAddClick(Sender: TObject);
begin
  with FilesTree.Add do
  begin
    Values[1] := '\';
    Values[2] := False;
    Values[3] := False;
    Focused := True;
  end;
  Modify;
end;

procedure TLoginEmbFilesEditor.BtnDelClick(Sender: TObject);
begin
  FilesTree.DeleteSelection;
  Modify;
end;

procedure TLoginEmbFilesEditor.BtnSaveClick(Sender: TObject);
begin
  Save;
end;

procedure TLoginEmbFilesEditor.CalcAllSize;

  function GetFileSize(const FileName: String): LongInt;
  var
    SearchRec: TSearchRec;
  begin
    if FindFirst(FileName, faAnyFile, SearchRec) = 0 then
      Result := SearchRec.Size
    else
      Result := 0;
  end;

var
  AllSize: LongInt;
  Size: Double;
  I: Integer;
  AFileName: String;
begin
  AllSize := 0;
  for I := 0 to FilesTree.Count - 1 do
  begin
    AFileName := VarToStr(FilesTree.Items[I].Values[0]);
    if AFileName <> '' then
    begin
      if FileExists(AFileName) then
      begin
        AllSize := AllSize + GetFileSize(AFileName);
      end;
    end;
  end;
  Size := AllSize / 1024 / 1024;
  StatusBar.Panels[0].Text := Format('资源文件体积总和：%.2fMB', [Size]);
end;

procedure TLoginEmbFilesEditor.FileNameColumnPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var
  AExt: String;
begin
  with TOpenDialog.Create(nil) do
    try
      Filter := 'Rar压缩文件|*.rar|传奇资源文件|*.data;*.wzl;*.wzx;*.wil;*.wix;*.mp3;*.wav;*.map;*.lst;*.dat|其他文件|*.txt;*.html';
      if Execute then
      begin
        AExt := UpperCase(ExtractFileExt(FileName));
        if (AExt = '.RAR') or (AExt = '.DATA') or
          (AExt <> '.WZL') or (AExt <> '.WZX') or
          (AExt <> '.WIL') or (AExt <> '.WIX') or
          (AExt <> '.MP3') or (AExt <> '.WAV') or
          (AExt <> '.MAP') or (AExt <> '.LST') or (AExt <> '.DAT') or
          (AExt <> '.TXT') or (AExt <> '.HTML')
        then
        begin
          FilesTree.FocusedNode.Texts[0] := FileName;
          FilesTree.FocusedNode.ImageIndex := 0;
          FilesTree.FocusedNode.SelectedIndex := 0;
          FilesTree.FocusedNode.StateIndex := 0;
          PathColumn.Focused := True;
          Modify;
        end
        else
          Application.MessageBox('只允许添加压缩文件及传奇相关的资源文件类型', '提示', MB_OK);
      end;
    finally
      Free;
    end;
end;

procedure TLoginEmbFilesEditor.FileNameColumnPropertiesChange(Sender: TObject);
begin
  Modify;
end;

procedure TLoginEmbFilesEditor.FileNameColumnPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
  FilesTree.BeginUpdate;
  try
    if FileExists(VarToStr(DisplayValue)) then
    begin
      FilesTree.FocusedNode.ImageIndex := 0;
      FilesTree.FocusedNode.SelectedIndex := 0;
      FilesTree.FocusedNode.StateIndex := 0;
    end
    else
    begin
      FilesTree.FocusedNode.ImageIndex := 1;
      FilesTree.FocusedNode.SelectedIndex := 1;
      FilesTree.FocusedNode.StateIndex := 1;
    end;
  finally
    FilesTree.EndUpdate;
  end;
end;

procedure TLoginEmbFilesEditor.FilesTreeSelectionChanged(Sender: TObject);
begin
  BtnDel.Enabled := FilesTree.SelectionCount > 0;
end;

procedure TLoginEmbFilesEditor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
  if BtnSave.Enabled then
  begin
    case Application.MessageBox('登陆器内嵌资源已经发生改变，需要保存吗？', '提示', MB_YESNOCANCEL or MB_ICONQUESTION) of
      ID_YES: Self.Save;
      ID_CANCEL: CanClose := False;
    end;
  end;
end;

procedure TLoginEmbFilesEditor.dxBarButton4Click(Sender: TObject);
begin
  Close;
end;

procedure TLoginEmbFilesEditor.Load;
var
  I: Integer;
  ANode: TcxTreeListNode;
  FileItem:TEmbeddedFileItem;
begin
  for I := 0 to FFiles.Count - 1 do
  begin
    ANode := FilesTree.Add;
    FileItem := FFiles[I];
    ANode.Values[0] := FileItem.FileName;
    ANode.Values[1] := FileItem.Path;
    ANode.Values[2] := FileItem.ZLib;
    ANode.Values[3] := FileItem.Replace;
    if FileExists(FFiles[I].FileName) then
    begin
      ANode.ImageIndex := 0;
      ANode.SelectedIndex := 0;
    end
    else
    begin
      ANode.ImageIndex := 1;
      ANode.SelectedIndex := 1;
    end;
  end;
  CalcAllSize;
end;

procedure TLoginEmbFilesEditor.Modify;
begin
  BtnSave.Enabled := True;
  CalcAllSize;
end;

procedure TLoginEmbFilesEditor.PathColumnPropertiesEditValueChanged(
  Sender: TObject);
begin
  Modify;
end;

procedure TLoginEmbFilesEditor.RepColumnPropertiesEditValueChanged(
  Sender: TObject);
begin
  Modify;
end;

procedure TLoginEmbFilesEditor.Save;
var
  I: Integer;
  FileItem:TEmbeddedFileItem;
begin
  FFiles.Clear;
  for I := 0 to FilesTree.Count - 1 do
  begin
    FileItem := FFiles.Add;
    with FileItem do
    begin
      FileName := FilesTree.Items[I].Values[0];
      Path := FilesTree.Items[I].Values[1];
      ZLib := FilesTree.Items[I].Values[2];
      Replace := FilesTree.Items[I].Values[3];
    end;
  end;
  BtnSave.Enabled := False;
  Inc(FSaveCount);
end;

procedure TLoginEmbFilesEditor.ZLibColPropertiesEditValueChanged(
  Sender: TObject);
begin
  Modify;
end;


end.
