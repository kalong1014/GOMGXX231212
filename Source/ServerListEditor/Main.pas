unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxPCdxBarPopupMenu, cxGraphics, cxControls, cxLookAndFeels, uEDCode,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxEdit, cxTextEdit, uServerList,
  cxHyperLinkEdit, cxLabel, ExtCtrls, dxBar, cxClasses, cxListView, cxPC,
  Menus, StdCtrls, cxMaskEdit, cxDropDownEdit, cxCheckBox, cxButtons, cxMemo,
  cxButtonEdit, uMD5, M2DownloadTest, dxSkinsCore, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxSpinEdit, Math{, Common}, dxBarBuiltInMenu, IOUtils,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxCore, cxDateUtils,
  cxCalendar, dxSkinOffice2019Colorful, dxSkinTheBezier;

const
  M2ServerListExt = '.txt';

type
  TFrmServerList = class(TForm)
    PageControl: TcxPageControl;
    TabSheetServerList: TcxTabSheet;
    TabSheetUpdateList: TcxTabSheet;
    lvServers: TcxListView;
    lvUpdates: TcxListView;
    BarManager: TdxBarManager;
    ToolBar: TdxBar;
    BtnOpen: TdxBarButton;
    dxBarButton2: TdxBarButton;
    Panel: TPanel;
    LabelHomeUrl: TcxLabel;
    LabelContactUrl: TcxLabel;
    LabelPayUrl: TcxLabel;
    LabelInnerUrl: TcxLabel;
    heHome: TcxHyperLinkEdit;
    heContact: TcxHyperLinkEdit;
    hePayUrl: TcxHyperLinkEdit;
    heLogin: TcxHyperLinkEdit;
    BtnSave: TdxBarButton;
    BtnClose: TdxBarButton;
    BtnNew: TdxBarButton;
    LabelResDir: TcxLabel;
    edtDir: TcxTextEdit;
    TabSheetClientSettings: TcxTabSheet;
    CheckFullScreen: TcxCheckBox;
    CheckDo3D: TcxCheckBox;
    CheckVBlank: TcxCheckBox;
    CombDisplaySize: TcxComboBox;
    LabelDefSize: TLabel;
    TabSheetMini: TcxTabSheet;
    CheckMiniResSrv: TcxCheckBox;
    LabelMiniPwd: TLabel;
    EditMiniPwd: TcxTextEdit;
    EditLinkMiniURL: TcxMemo;
    LabelMiniList: TLabel;
    LabelMiniInfo1: TLabel;
    LabelMiniInfo2: TLabel;
    TabSheetLoginUpdate: TcxTabSheet;
    TabSheetClientStyle: TcxTabSheet;
    EditMaxClient: TcxSpinEdit;
    Label1: TLabel;
    TabSheetDataSecurity: TcxTabSheet;
    lvSecurityFiles: TcxListView;
    dxBarDockControl1: TdxBarDockControl;
    BarManagerBar1: TdxBar;
    BtnSLAdd: TdxBarButton;
    BtnSLDel: TdxBarButton;
    BtnSLEdit: TdxBarButton;
    BtnSLMoveUp: TdxBarButton;
    BtnSLMoveDown: TdxBarButton;
    dxBarDockControl2: TdxBarDockControl;
    dxBarDockControl3: TdxBarDockControl;
    BarManagerBar2: TdxBar;
    BarManagerBar3: TdxBar;
    BtnULAdd: TdxBarButton;
    BtnULDel: TdxBarButton;
    BtnULEdit: TdxBarButton;
    BtnULMoveUp: TdxBarButton;
    BtnULMoveDown: TdxBarButton;
    BtnULTestDown: TdxBarButton;
    BtnSEAdd: TdxBarButton;
    BtnSEMoveDown: TdxBarButton;
    BtnSEDel: TdxBarButton;
    BtnSEEdit: TdxBarButton;
    BtnSEMoveUp: TdxBarButton;
    EditShortCut: TcxCheckBox;
    Label2: TLabel;
    EditClientExeName: TcxTextEdit;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    EditLoginURL: TcxHyperLinkEdit;
    EditLoginFile: TcxButtonEdit;
    EditLoginMD5: TcxTextEdit;
    EditLoginDownType: TcxComboBox;
    EditLoginZIP: TcxCheckBox;
    LabelLoginDownType: TcxLabel;
    LabelLoginMD5: TcxLabel;
    LabelLoginName: TLabel;
    LabelLoginURL: TcxLabel;
    GroupBox3: TGroupBox;
    EditRegIDLetterNum: TcxCheckBox;
    EditRegIDFirstLetter: TcxCheckBox;
    EditRegIDShowName: TcxCheckBox;
    EditRegIDNameReq: TcxCheckBox;
    EditRegIDShowBirth: TcxCheckBox;
    EditRegIDBirthReq: TcxCheckBox;
    EditRegIDShowQS: TcxCheckBox;
    EditRegIDQSReq: TcxCheckBox;
    EditRegIDShowMail: TcxCheckBox;
    EditRegIDMailReq: TcxCheckBox;
    EditRegIDShowQQ: TcxCheckBox;
    EditRegIDQQReq: TcxCheckBox;
    EditRegIDShowID: TcxCheckBox;
    EditRegIDIDReq: TcxCheckBox;
    EditRegIDShowMobile: TcxCheckBox;
    EditRegIDMobileReq: TcxCheckBox;
    GroupBoxLisence: TGroupBox;
    DateEditLisence: TcxDateEdit;
    cxLabel1: TcxLabel;
    CheckBoxUseLisence: TcxCheckBox;
    procedure BtnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure lvServersDblClick(Sender: TObject);
    procedure lvUpdatesDblClick(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure heHomePropertiesChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure lvServersSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure CheckFullScreenPropertiesChange(Sender: TObject);
    procedure CombDisplaySizePropertiesChange(Sender: TObject);
    procedure CheckMiniResSrvPropertiesChange(Sender: TObject);
    procedure EditLoginURLPropertiesChange(Sender: TObject);
    procedure lvUpdatesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure EditLoginFilePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditLoginMD5PropertiesChange(Sender: TObject);
    procedure EditLoginDownTypePropertiesChange(Sender: TObject);
    procedure EditLoginZIPPropertiesChange(Sender: TObject);
    procedure EditLoginFilePropertiesChange(Sender: TObject);
    procedure EditLinkMiniURLPropertiesChange(Sender: TObject);
    procedure BtnSLAddClick(Sender: TObject);
    procedure BtnULAddClick(Sender: TObject);
    procedure BtnSLDelClick(Sender: TObject);
    procedure BtnULDelClick(Sender: TObject);
    procedure BtnSLEditClick(Sender: TObject);
    procedure BtnULEditClick(Sender: TObject);
    procedure BtnSLMoveUpClick(Sender: TObject);
    procedure BtnULMoveUpClick(Sender: TObject);
    procedure BtnSLMoveDownClick(Sender: TObject);
    procedure BtnULMoveDownClick(Sender: TObject);
    procedure BtnULTestDownClick(Sender: TObject);
    procedure BtnSEDelClick(Sender: TObject);
    procedure BtnSEMoveUpClick(Sender: TObject);
    procedure BtnSEMoveDownClick(Sender: TObject);
    procedure BtnSEAddClick(Sender: TObject);
    procedure BtnSEEditClick(Sender: TObject);
    procedure EditShortCutPropertiesChange(Sender: TObject);
    procedure EditClientExeNamePropertiesChange(Sender: TObject);
    procedure EditClientExeNameKeyPress(Sender: TObject; var Key: Char);
    procedure lvUpdatesClick(Sender: TObject);
    procedure lvUpdatesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private declarations }
    FFileName: String;
    FServerInfo: TServerInfo;
    FReading: Boolean;
    FModified: Boolean;
    procedure LoadInfo;
    procedure SetModified(const Value: Boolean);
    procedure AddServerItemToListView(SerItem: TServerItem; const Index: Integer=-1);
    procedure AddUpdateItemToListView(UpdateItem: TUpdateItem; const Index: Integer=-1);
    procedure AddSecurityFileToListView(SecurityFile: TSecurityFile; const Index: Integer=-1);
    procedure UpdateServerItemToListView(SerItem: TServerItem);
    procedure UpdateUpdateItemToListView(UpdateItem: TUpdateItem);
    procedure UpdateSecurityFileToListView(SecurityFile: TSecurityFile);
    procedure UpdateButtonState;
  public
    { Public declarations }
    function Save: Boolean;
    procedure Open(const AFileName: String);
    property FileName: String read FFileName write FFileName;
    property Modified: Boolean read FModified write SetModified;
  end;

var
  FrmServerList: TFrmServerList;


implementation

uses
  M2SLItemEditor, M2SUpdateItemEditor, M2SecurityFileEditorFrm;

const
  BoolStr: array[Boolean] of String=('否', '是');
  DownKindStr: array[TupDownKind] of String=('HTTP', '百度网盘', '360网盘', 'FTP', '百度相册');
  DownTypeStr: array[TutDownType] of String=('必要更新（更新完成才可进入游戏）', '后台更新（必要更新完成后开始更新，可边游戏边更新）', '需要时更新（客户端需要使用时再更新）');

{$R *.dfm}

procedure TFrmServerList.AddServerItemToListView(SerItem: TServerItem; const Index: Integer);
var
  lvItem: TListItem;
begin
  if Index<>-1 then
    lvItem  :=  lvServers.Items.Insert(Index)
  else
    lvItem  :=  lvServers.Items.Add;
  lvItem.Caption  :=  SerItem.GroupName;
  lvItem.SubItems.Add(SerItem.ServerName);
  lvItem.SubItems.Add(SerItem.DisplayName);
  lvItem.SubItems.Add(SerItem.Host);
  lvItem.SubItems.Add(IntToStr(SerItem.Port));
  lvItem.SubItems.Add(SerItem.Key);
  lvItem.Checked  :=  SerItem.Enable;
  lvItem.Data   :=  SerItem;
  lvItem.Selected :=  True;
end;

procedure TFrmServerList.AddUpdateItemToListView(UpdateItem: TUpdateItem; const Index: Integer);
var
  lvItem: TListItem;
begin
  if Index<>-1 then
    lvItem  :=  lvUpdates.Items.Insert(Index)
  else
    lvItem  :=  lvUpdates.Items.Add;
  lvItem.Caption  :=  UpdateItem.Url;
  lvItem.SubItems.Add(BoolStr[UpdateItem.Zip]);
  lvItem.SubItems.Add(UpdateItem.Path);
  lvItem.SubItems.Add(UpdateItem.FileName);
  lvItem.SubItems.Add(UpdateItem.Code);
  lvItem.SubItems.Add(DownKindStr[UpdateItem.DownKind]);
  lvItem.SubItems.Add(DownTypeStr[UpdateItem.DownType]);
  lvItem.Checked  :=  UpdateItem.Enable;
  lvItem.Data   :=  UpdateItem;
  lvItem.Selected :=  True;
end;

procedure TFrmServerList.AddSecurityFileToListView(SecurityFile: TSecurityFile; const Index: Integer=-1);
var
  lvItem: TListItem;
begin
  if Index<>-1 then
    lvItem  :=  lvSecurityFiles.Items.Insert(Index)
  else
    lvItem  :=  lvSecurityFiles.Items.Add;
  lvItem.Caption  :=  SecurityFile.FileName;
  lvItem.SubItems.Add(SecurityFile.Password);
  lvItem.Data   :=  SecurityFile;
  lvItem.Selected :=  True;
end;

procedure TFrmServerList.CheckFullScreenPropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.CheckMiniResSrvPropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.CombDisplaySizePropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.BtnULMoveUpClick(Sender: TObject);
var
  ui: TUpdateItem;
begin
  ui  :=  TUpdateItem(lvUpdates.Selected.Data);
  ui.Index  :=  ui.Index-1;
  lvUpdates.Selected.Delete;
  AddUpdateItemToListView(ui, ui.Index);
  Modified :=  True;
end;

procedure TFrmServerList.BtnULMoveDownClick(Sender: TObject);
var
  ui: TUpdateItem;
begin
  ui  :=  TUpdateItem(lvUpdates.Selected.Data);
  ui.Index  :=  ui.Index+1;
  lvUpdates.Selected.Delete;
  AddUpdateItemToListView(ui, ui.Index);
  Modified :=  True;
end;

procedure TFrmServerList.BtnULTestDownClick(Sender: TObject);
var
  AUpdateItem: TUpdateItem;
begin
  AUpdateItem := TUpdateItem(lvUpdates.Selected.Data);
  if AUpdateItem <> nil then
    TestDownload(AUpdateItem);
end;

procedure TFrmServerList.BtnSLAddClick(Sender: TObject);
var
  SerItem: TServerItem;
begin
  SerItem :=  FServerInfo.ServerList.Add;
  if M2SLItemEditor.EditServer(FServerInfo, SerItem) then
  begin
    AddServerItemToListView(SerItem);
    Modified :=  True;
  end
  else
    FServerInfo.ServerList.Delete(SerItem.Index);
end;

procedure TFrmServerList.BtnSLDelClick(Sender: TObject);
begin
  FServerInfo.ServerList.Delete(TServerItem(lvServers.Selected.Data).Index);
  lvServers.Selected.Delete;
  Modified :=  True;
end;

procedure TFrmServerList.BtnSLEditClick(Sender: TObject);
begin
  if M2SLItemEditor.EditServer(FServerInfo, TServerItem(lvServers.Selected.Data)) then
  begin
    UpdateServerItemToListView(TServerItem(lvServers.Selected.Data));
    Modified :=  True;
  end;
end;

procedure TFrmServerList.BtnSLMoveUpClick(Sender: TObject);
var
  si: TServerItem;
begin
  si  :=  TServerItem(lvServers.Selected.Data);
  si.Index  :=  si.Index-1;
  lvServers.Selected.Delete;
  AddServerItemToListView(si, si.Index);
  Modified :=  True;
end;

procedure TFrmServerList.BtnSLMoveDownClick(Sender: TObject);
var
  si: TServerItem;
begin
  si  :=  TServerItem(lvServers.Selected.Data);
  si.Index  :=  si.Index+1;
  lvServers.Selected.Delete;
  AddServerItemToListView(si, si.Index);
  Modified :=  True;
end;

procedure TFrmServerList.BtnULAddClick(Sender: TObject);
var
  UpItem: TUpdateItem;
begin
  UpItem :=  FServerInfo.UpdateItems.Add;
  if M2SUpdateItemEditor.EditUpdateItem(UpItem) then
  begin
    AddUpdateItemToListView(UpItem);
    Modified :=  True;
  end
  else
    FServerInfo.UpdateItems.Delete(UpItem.Index);
end;

procedure TFrmServerList.BtnULDelClick(Sender: TObject);
begin
  FServerInfo.UpdateItems.Delete(TUpdateItem(lvUpdates.Selected.Data).Index);
  lvUpdates.Selected.Delete;
  Modified :=  True;
end;

procedure TFrmServerList.BtnULEditClick(Sender: TObject);
begin
  if M2SUpdateItemEditor.EditUpdateItem(TUpdateItem(lvUpdates.Selected.Data)) then
  begin
    UpdateUpdateItemToListView(TUpdateItem(lvUpdates.Selected.Data));
    Modified :=  True;
  end;
end;

procedure TFrmServerList.BtnOpenClick(Sender: TObject);
var
  boOpen: Boolean;
begin
  boOpen :=  not Modified;
  if Modified then
    case Application.MessageBox('列表文件已经更新,需要保存吗?', '提示', MB_YESNOCANCEL) of
      ID_YES:
      begin
        if Save then
          boOpen  :=  True;
      end;
      ID_NO:  boOpen  :=  True;
    end;
  if boOpen then
  begin
    with TOpenDialog.Create(nil) do
      try
        DefaultExt  :=  M2ServerListExt;
        Filter      :=  '登陆器列表文件|*'+ M2ServerListExt;
        if Execute then
        begin
          FFileName :=  FileName;
          Open(FFileName);
        end;
      finally
        Free;
      end;
  end;
end;

procedure TFrmServerList.BtnSaveClick(Sender: TObject);
begin
  Save;
end;

procedure TFrmServerList.BtnSEAddClick(Sender: TObject);
var
  AFile: TSecurityFile;
begin
  AFile :=  FServerInfo.SecurityFiles.Add;
  if M2SecurityFileEditorFrm.TM2SecurityFileEditorForm.EditFile(AFile) then
  begin
    AddSecurityFileToListView(AFile);
    Modified :=  True;
  end
  else
    FServerInfo.SecurityFiles.Delete(AFile.Index);
end;

procedure TFrmServerList.BtnSEDelClick(Sender: TObject);
begin
  FServerInfo.SecurityFiles.Delete(TSecurityFile(lvSecurityFiles.Selected.Data).Index);
  lvSecurityFiles.Selected.Delete;
  Modified :=  True;
end;

procedure TFrmServerList.BtnSEEditClick(Sender: TObject);
begin
  if TM2SecurityFileEditorForm.EditFile(TSecurityFile(lvSecurityFiles.Selected.Data)) then
  begin
    UpdateSecurityFileToListView(TSecurityFile(lvSecurityFiles.Selected.Data));
    Modified :=  True;
  end;
end;

procedure TFrmServerList.BtnSEMoveDownClick(Sender: TObject);
var
  sf: TSecurityFile;
begin
  sf  :=  TSecurityFile(lvSecurityFiles.Selected.Data);
  sf.Index  :=  sf.Index+1;
  lvSecurityFiles.Selected.Delete;
  AddSecurityFileToListView(sf, sf.Index);
  Modified :=  True;
end;

procedure TFrmServerList.BtnSEMoveUpClick(Sender: TObject);
var
  sf: TSecurityFile;
begin
  sf  :=  TSecurityFile(lvSecurityFiles.Selected.Data);
  sf.Index  :=  sf.Index-1;
  lvSecurityFiles.Selected.Delete;
  AddSecurityFileToListView(sf, sf.Index);
  Modified :=  True;
end;

procedure TFrmServerList.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmServerList.BtnNewClick(Sender: TObject);
var
  boNew: Boolean;
begin
  boNew :=  not Modified;
  if Modified then
    case Application.MessageBox('列表文件已经更新,需要保存吗?', '提示', MB_YESNOCANCEL) of
      ID_YES:
      begin
        if Save then
          boNew  :=  True;
      end;
      ID_NO:  boNew  :=  True;
    end;
  if boNew then
  begin
    if FServerInfo <> nil then
      FServerInfo.Free;
    FServerInfo := TServerInfo.Create;
    LoadInfo;
  end;
end;

procedure TFrmServerList.EditClientExeNameKeyPress(Sender: TObject; var Key: Char);
begin
  if not TPath.IsValidFileNameChar(Key) then
    Key := #0;
end;

procedure TFrmServerList.EditClientExeNamePropertiesChange(Sender: TObject);
begin
  if not FReading then
  begin
    FServerInfo.ClientFileName := EditClientExeName.Text;
    Modified :=  True;
  end;
end;

procedure TFrmServerList.EditLinkMiniURLPropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.EditLoginDownTypePropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.EditLoginFilePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  with TOpenDialog.Create(nil) do
    try
      Filter := '可执行文件|*.exe';
      if Execute then
      begin
        EditLoginMD5.Text := uMD5.MD5File(FileName);
        EditLoginFile.Text := ExtractFileName(FileName);
        Modified :=  True;
      end;
    finally
      Free;
    end;
end;

procedure TFrmServerList.EditLoginFilePropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.EditLoginMD5PropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.EditLoginURLPropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.EditLoginZIPPropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.EditShortCutPropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose  :=  not Modified;
  if not CanClose then
    case Application.MessageBox('列表文件已经更新,需要保存吗?', '提示', MB_YESNOCANCEL) of
      ID_YES:
      begin
        if Save then
          CanClose  :=  True;
      end;
      ID_NO:  CanClose  :=  True;
    end;
end;

procedure TFrmServerList.FormCreate(Sender: TObject);
begin
  FServerInfo := nil;
  BtnNewClick(nil);
{$IFDEF USER}
  GroupBoxLisence.Visible := False;
  TabSheetClientStyle.Caption := '关于程序';
  Caption := '登陆器列表制作（用户版）';
{$ENDIF}
end;

procedure TFrmServerList.FormDestroy(Sender: TObject);
begin
  FServerInfo.Free;
end;

procedure TFrmServerList.FormShow(Sender: TObject);
begin
  if FFileName<>'' then
    Open(FFileName);
end;

procedure TFrmServerList.heHomePropertiesChange(Sender: TObject);
begin
  if not FReading then
    Modified :=  True;
end;

procedure TFrmServerList.LoadInfo;
var
  I: Integer;
begin
  FReading  :=  True;
  heHome.Text     :=  FServerInfo.HomeURL;
  heContact.Text  :=  FServerInfo.ContactURL;
  hePayUrl.Text   :=  FServerInfo.PayURL;
  heLogin.Text    :=  FServerInfo.LoginURL;
  edtDir.Text     :=  FServerInfo.ResFolder;
  EditLinkMiniURL.Text :=  FServerInfo.MiniURL;
  CheckFullScreen.Checked := FServerInfo.FullScreen;
  CheckDo3D.Checked := FServerInfo.Do3D;
  CheckVBlank.Checked := FServerInfo.VBlank;
  CheckMiniResSrv.Checked := FServerInfo.EnabledMini;
  EditLinkMiniURL.Text := FServerInfo.MiniURL;
  EditMiniPwd.Text := FServerInfo.MiniPwd;
  EditLoginURL.Text := FServerInfo.LoginVerURL;
  EditLoginMD5.Text := FServerInfo.LoginVerMD5;
  EditLoginDownType.ItemIndex := Ord(FServerInfo.LoginVerKind);
  EditLoginZIP.Checked := FServerInfo.LoginVerZip;
  EditShortCut.Checked := FServerInfo.CreateShortCut;
  EditClientExeName.Text := FServerInfo.ClientFileName;
  EditLoginFile.Text := FServerInfo.LoginVerFile;
  case FServerInfo.DisplaySize of
    TDisplaySize.dsNormal: CombDisplaySize.ItemIndex := 0;
    TDisplaySize.ds1024: CombDisplaySize.ItemIndex := 1;
    TDisplaySize.ds800: CombDisplaySize.ItemIndex := 2;
  end;
{$IFNDEF USER}
  CheckBoxUseLisence.Checked := FServerInfo.UseLisence;
  DateEditLisence.Date := StrToDate(uEDCode.DecodeLisence(FServerInfo.DataTimeLisence));
{$ENDIF}
//  CheckBoxAllowAutoClient.Checked := FServerInfo.AutoClientType;
//  case FServerInfo.ClientType of
//    0: RadioButtonDefaultClientStyle.Checked := True;
//    1: RadioButtonMir4ClientStyle.Checked := True;
//    2: RadioButtonReturnClientStyle.Checked := True;
//  end;
//  EditAssistantKind.ItemIndex := FServerInfo.AssistantKind;
  lvServers.Clear;
  lvUpdates.Clear;
  for I := 0 to FServerInfo.ServerList.Count - 1 do
    AddServerItemToListView(FServerInfo.ServerList.Items[I]);
  for I := 0 to FServerInfo.UpdateItems.Count - 1 do
    AddUpdateItemToListView(FServerInfo.UpdateItems.Items[I]);
  for I := 0 to FServerInfo.SecurityFiles.Count - 1 do
    AddSecurityFileToListView(FServerInfo.SecurityFiles.Items[I]);
  EditMaxClient.Value := Max(1, FServerInfo.MaxClient);

  EditRegIDLetterNum.Checked := FServerInfo.IDLetterNum;
  EditRegIDFirstLetter.Checked := FServerInfo.IDFirstLetter;
  EditRegIDShowName.Checked := FServerInfo.IDShowName;
  EditRegIDNameReq.Checked := FServerInfo.IDNameReq;
  EditRegIDShowBirth.Checked := FServerInfo.IDShowBirth;
  EditRegIDBirthReq.Checked := FServerInfo.IDBirthReq;
  EditRegIDShowQS.Checked := FServerInfo.IDShowQS;
  EditRegIDQSReq.Checked := FServerInfo.IDQSReq;
  EditRegIDShowQQ.Checked := FServerInfo.IDShowQQ;
  EditRegIDQQReq.Checked := FServerInfo.IDQQReq;
  EditRegIDShowMobile.Checked := FServerInfo.IDShowMobile;
  EditRegIDMobileReq.Checked := FServerInfo.IDMobileReq;
  EditRegIDShowID.Checked := FServerInfo.IDShowID;
  EditRegIDIDReq.Checked := FServerInfo.IDIDReq;
  EditRegIDShowMail.Checked := FServerInfo.IDShowMail;
  EditRegIDMailReq.Checked := FServerInfo.IDMailReq;

  FReading  :=  False;
  UpdateButtonState;
end;

procedure TFrmServerList.lvServersDblClick(Sender: TObject);
begin
  if lvServers.Selected<>nil then
    if M2SLItemEditor.EditServer(FServerInfo, TServerItem(lvServers.Selected.Data)) then
    begin
      UpdateServerItemToListView(TServerItem(lvServers.Selected.Data));
      Modified :=  True;
    end;
end;

procedure TFrmServerList.lvServersSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  UpdateButtonState;
end;

procedure TFrmServerList.lvUpdatesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  ui: TUpdateItem;
begin
  ui  :=  TUpdateItem(Item.Data);
  if ui <> nil then
  begin
    ui.Enable := Item.Checked;
    Modified :=  True;
    BtnSave.Enabled := True;
  end;
end;

procedure TFrmServerList.lvUpdatesClick(Sender: TObject);
var
  ListItem : TListItem;
  I : Integer;
begin
//  for i := 0 to lvUpdates.Items.Count - 1 do
//  begin
//    ListItem := lvUpdates.Items.Item[I];
//    ListItem.Checked := not ListItem.Checked;
//  end;
end;

procedure TFrmServerList.lvUpdatesDblClick(Sender: TObject);
begin
  if lvSecurityFiles.Selected<>nil then
    if TM2SecurityFileEditorForm.EditFile(TSecurityFile(lvSecurityFiles.Selected.Data)) then
    begin
      UpdateSecurityFileToListView(TSecurityFile(lvSecurityFiles.Selected.Data));
      Modified :=  True;
    end;
end;

procedure TFrmServerList.lvUpdatesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  UpdateButtonState;
end;

procedure TFrmServerList.Open(const AFileName: String);
var
  LS: TStrings;
begin
  LS  :=  TStringList.Create;
  try
    LS.LoadFromFile(AFileName);
    FFileName  :=  AFileName;
    if FServerInfo <> nil then
      FServerInfo.Free;
    FServerInfo := TServerInfo.Create;
    FServerInfo.LoadFromString(LS.Text);
    LoadInfo;
  finally
    LS.Free;
  end;
end;

function TFrmServerList.Save: Boolean;
var
  LS: TStrings;
begin
  if FFileName = '' then
    with TSaveDialog.Create(nil) do
      try
        DefaultExt  :=  M2ServerListExt;
        Filter      :=  '登陆器列表文件|*'+ M2ServerListExt;
        if Execute then
          FFileName :=  FileName;
      finally
        Free;
      end;
  if FFileName<>'' then
  begin
    LS  :=  TStringList.Create;
    FServerInfo.HomeURL     :=  heHome.Text;
    FServerInfo.ContactURL  :=  heContact.Text;
    FServerInfo.PayURL      :=  hePayUrl.Text;
    FServerInfo.LoginURL    :=  heLogin.Text;
    FServerInfo.ResFolder   :=  edtDir.Text;
    FServerInfo.EnabledMini :=  CheckMiniResSrv.Checked;
    FServerInfo.MiniURL     :=  EditLinkMiniURL.Text;
    FServerInfo.MiniPwd     :=  EditMiniPwd.Text;
    FServerInfo.FullScreen  :=  CheckFullScreen.Checked;
    FServerInfo.Do3D        :=  CheckDo3D.Checked;
    FServerInfo.VBlank      :=  CheckVBlank.Checked;
    FServerInfo.CreateShortCut := EditShortCut.Checked;
    FServerInfo.LoginVerURL :=  EditLoginURL.Text;
    FServerInfo.LoginVerMD5 :=  EditLoginMD5.Text;
    FServerInfo.LoginVerKind:=  TupDownKind(EditLoginDownType.ItemIndex);
    FServerInfo.LoginVerZip :=  EditLoginZIP.Checked;
    FServerInfo.LoginVerFile:=  EditLoginFile.Text;
    case CombDisplaySize.ItemIndex of
      0: FServerInfo.DisplaySize := TDisplaySize.dsNormal;
      1: FServerInfo.DisplaySize := TDisplaySize.ds1024;
      2: FServerInfo.DisplaySize := TDisplaySize.ds800;
    end;
{$IFNDEF USER}
    FServerInfo.UseLisence := CheckBoxUseLisence.Checked;
    FServerInfo.DataTimeLisence :=  uEDCode.EncodeLisence(DateToStr(DateEditLisence.Date));
{$ENDIF}
//    FServerInfo.AutoClientType := CheckBoxAllowAutoClient.Checked;
//    if RadioButtonDefaultClientStyle.Checked then
//      FServerInfo.ClientType := 0
//    else if RadioButtonMir4ClientStyle.Checked then
//      FServerInfo.ClientType := 1
//    else if RadioButtonReturnClientStyle.Checked then
//      FServerInfo.ClientType := 2;
//    FServerInfo.AssistantKind := EditAssistantKind.ItemIndex;

    FServerInfo.MaxClient := Max(1, EditMaxClient.Value);

    FServerInfo.IDLetterNum := EditRegIDLetterNum.Checked;
    FServerInfo.IDFirstLetter := EditRegIDFirstLetter.Checked;
    FServerInfo.IDShowName := EditRegIDShowName.Checked;
    FServerInfo.IDNameReq := EditRegIDNameReq.Checked;
    FServerInfo.IDShowBirth := EditRegIDShowBirth.Checked;
    FServerInfo.IDBirthReq := EditRegIDBirthReq.Checked;
    FServerInfo.IDShowQS := EditRegIDShowQS.Checked;
    FServerInfo.IDQSReq := EditRegIDQSReq.Checked;
    FServerInfo.IDShowQQ := EditRegIDShowQQ.Checked;
    FServerInfo.IDQQReq := EditRegIDQQReq.Checked;
    FServerInfo.IDShowMobile := EditRegIDShowMobile.Checked;
    FServerInfo.IDMobileReq := EditRegIDMobileReq.Checked;
    FServerInfo.IDShowID := EditRegIDShowID.Checked;
    FServerInfo.IDIDReq := EditRegIDIDReq.Checked;
    FServerInfo.IDIDReq := EditRegIDIDReq.Checked;
    FServerInfo.IDShowMail := EditRegIDShowMail.Checked;
    FServerInfo.IDMailReq := EditRegIDMailReq.Checked;

    LS.Text :=  FServerInfo.SaveToString;
    LS.SaveToFile(FFileName);
//    FServerInfo.SaveToFile(FFileName);
    Modified :=  False;
    Result  :=  True;
  end;
end;

procedure TFrmServerList.SetModified(const Value: Boolean);
begin
  FModified := Value;
  UpdateButtonState;
end;

procedure TFrmServerList.UpdateButtonState;
begin
  BtnSave.Enabled := FModified;
  BtnSLAdd.Enabled := FServerInfo <> nil;
  BtnSLDel.Enabled := (FServerInfo <> nil) and (lvServers.Selected <> nil);
  BtnSLEdit.Enabled := (FServerInfo <> nil) and (lvServers.Selected <> nil);
  BtnSLMoveUp.Enabled := (FServerInfo <> nil) and (lvServers.Selected <> nil) and (lvServers.Selected.Index > 0);
  BtnSLMoveDown.Enabled := (FServerInfo <> nil) and (lvServers.Selected <> nil) and (lvServers.Selected.Index < lvServers.Items.Count - 1);

  BtnULAdd.Enabled := FServerInfo <> nil;
  BtnULDel.Enabled := (FServerInfo <> nil) and (lvUpdates.Selected <> nil);
  BtnULEdit.Enabled := (FServerInfo <> nil) and (lvUpdates.Selected <> nil);
  BtnULMoveUp.Enabled := (FServerInfo <> nil) and (lvUpdates.Selected <> nil) and (lvUpdates.Selected.Index > 0);
  BtnULMoveDown.Enabled := (FServerInfo <> nil) and (lvUpdates.Selected <> nil) and (lvUpdates.Selected.Index < lvUpdates.Items.Count - 1);
  BtnULTestDown.Enabled := (FServerInfo <> nil) and (lvUpdates.Selected <> nil);

  BtnSEAdd.Enabled := FServerInfo <> nil;
  BtnSEDel.Enabled := (FServerInfo <> nil) and (lvSecurityFiles.Selected <> nil);
  BtnSEEdit.Enabled := (FServerInfo <> nil) and (lvSecurityFiles.Selected <> nil);
  BtnSEMoveUp.Enabled := (FServerInfo <> nil) and (lvSecurityFiles.Selected <> nil) and (lvSecurityFiles.Selected.Index > 0);
  BtnSEMoveDown.Enabled := (FServerInfo <> nil) and (lvSecurityFiles.Selected <> nil) and (lvSecurityFiles.Selected.Index < lvSecurityFiles.Items.Count - 1);
end;

procedure TFrmServerList.UpdateServerItemToListView(SerItem: TServerItem);
var
  I: Integer;
begin
  for I := 0 to lvServers.Items.Count - 1 do
    if lvServers.Items[I].Data = SerItem then
    begin
      lvServers.Items[I].SubItems.Clear;
      lvServers.Items[I].Caption  :=  SerItem.GroupName;
      lvServers.Items[I].SubItems.Add(SerItem.ServerName);
      lvServers.Items[I].SubItems.Add(SerItem.DisplayName);
      lvServers.Items[I].SubItems.Add(SerItem.Host);
      lvServers.Items[I].SubItems.Add(IntToStr(SerItem.Port));
      lvServers.Items[I].SubItems.Add(SerItem.Key);
      lvServers.Items[I].Checked  :=  SerItem.Enable;
      Break;
    end;
end;

procedure TFrmServerList.UpdateUpdateItemToListView(UpdateItem: TUpdateItem);
var
  I: Integer;
begin
  for I := 0 to lvUpdates.Items.Count - 1 do
    if lvUpdates.Items[I].Data = UpdateItem then
    begin
      lvUpdates.Items[I].SubItems.Clear;
      lvUpdates.Items[I].Caption  :=  UpdateItem.Url;
      lvUpdates.Items[I].SubItems.Add(BoolStr[UpdateItem.Zip]);
      lvUpdates.Items[I].SubItems.Add(UpdateItem.Path);
      lvUpdates.Items[I].SubItems.Add(UpdateItem.FileName);
      lvUpdates.Items[I].SubItems.Add(UpdateItem.Code);
      lvUpdates.Items[I].SubItems.Add(DownKindStr[UpdateItem.DownKind]);
      lvUpdates.Items[I].SubItems.Add(DownTypeStr[UpdateItem.DownType]);
      lvUpdates.Items[I].Checked  :=  UpdateItem.Enable;
      lvUpdates.Items[I].Data   :=  UpdateItem;
      Break;
    end;
end;

procedure TFrmServerList.UpdateSecurityFileToListView(SecurityFile: TSecurityFile);
var
  I: Integer;
begin
  for I := 0 to lvSecurityFiles.Items.Count - 1 do
    if lvSecurityFiles.Items[I].Data = SecurityFile then
    begin
      lvSecurityFiles.Items[I].SubItems.Clear;
      lvSecurityFiles.Items[I].Caption  :=  SecurityFile.FileName;
      lvSecurityFiles.Items[I].SubItems.Add(SecurityFile.Password);
      lvSecurityFiles.Items[I].Data   :=  SecurityFile;
      Break;
    end;
end;

end.
