unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxBar, cxClasses, cxPC, dxDockControl, dxDockPanel, uDesigner, Grids,
  uPropertyGrid, StdCtrls, uComponentList, M2ComponentDesignContainer, ExtCtrls,
  uPropertyManager, ImgList, ButtonGroup, uCliTypes, OleCtrls, SHDocVw_EWB,
  EwbCore, EmbeddedWB, uEDCode, StrUtils, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinsdxStatusBarPainter, cxContainer, cxEdit,
  dxSkinsdxBarPainter, dxSkinsdxDockControlPainter, cxProgressBar, dxStatusBar,
  cxCheckBox, GDIPicture, cxStyles, cxInplaceContainer, cxVGrid, cxHOI,
  cxColorComboBox, W7ProgressBars, M2LoginEmbFiles, ActiveX, uTypes,
  M2RTTIInspector, Zlib;

const
  APP_VERSION = '版本: 2020.02.28';

type
  TFRMLgoinEditor = class(TForm)
    BarManager: TdxBarManager;
    ToolBar: TdxBar;
    dxNew: TdxBarButton;
    dxPrivew: TdxBarButton;
    dxSave: TdxBarButton;
    dxBarButton16: TdxBarButton;
    dxOpen: TdxBarButton;
    dxDockSite1: TdxDockSite;
    dxDockPanel2: TdxDockPanel;
    dxDockPanel3: TdxDockPanel;
    DockingManager: TdxDockingManager;
    FormDesigner: TuFormDesigner;
    Panel1: TPanel;
    bgComponents: TButtonGroup;
    dxDockPanel1: TdxDockPanel;
    dxLayoutDockSite1: TdxLayoutDockSite;
    dxLayoutDockSite2: TdxLayoutDockSite;
    dxLayoutDockSite3: TdxLayoutDockSite;
    uComponentList1: TuComponentList;
    PropertiesManager: TuPropertiesManager;
    ImgComps: TImageList;
    dxAlign1: TdxBarButton;
    dxAlign2: TdxBarButton;
    dxAlign3: TdxBarButton;
    dxAlign4: TdxBarButton;
    dxBarButton44: TdxBarButton;
    dxAlign5: TdxBarButton;
    dxAlign6: TdxBarButton;
    dxAlign7: TdxBarButton;
    dxAlign8: TdxBarButton;
    dxBarSubItem6: TdxBarSubItem;
    dxLocalExe: TdxBarButton;
    dxFreeExe: TdxBarButton;
    BtnResources: TdxBarButton;
    BtnAddEmbRes: TdxBarButton;
    StatusBar: TdxStatusBar;
    dxStatusBar1Container2: TdxStatusBarContainerControl;
    cxProgressBar: TcxProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure dxBarButton16Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDesignerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonGroup1Items0Click(Sender: TObject);
    procedure bgComponentsItems1Click(Sender: TObject);
    procedure bgComponentsItems2Click(Sender: TObject);
    procedure bgComponentsItems3Click(Sender: TObject);
    procedure bgComponentsItems4Click(Sender: TObject);
    procedure bgComponentsItems5Click(Sender: TObject);
    procedure bgComponentsItems6Click(Sender: TObject);
    procedure bgComponentsItems7Click(Sender: TObject);
    procedure bgComponentsItems8Click(Sender: TObject);
    procedure bgComponentsItems9Click(Sender: TObject);
    procedure bgComponentsItems12Click(Sender: TObject);
    procedure bgComponentsItems13Click(Sender: TObject);
    procedure dxSaveClick(Sender: TObject);
    procedure dxOpenClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dxPrivewClick(Sender: TObject);
    procedure FormDesignerModified(Sender: TObject);
    procedure dxNewClick(Sender: TObject);
    procedure FormDesignerFormSizeChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bgComponentsItems10Click(Sender: TObject);
    procedure dxBarButton44Click(Sender: TObject);
    procedure FormDesignerSelectionChange(Sender: TObject);
    procedure dxAlign1Click(Sender: TObject);
    procedure dxAlign2Click(Sender: TObject);
    procedure dxAlign3Click(Sender: TObject);
    procedure dxAlign4Click(Sender: TObject);
    procedure dxAlign5Click(Sender: TObject);
    procedure dxAlign6Click(Sender: TObject);
    procedure dxAlign7Click(Sender: TObject);
    procedure dxAlign8Click(Sender: TObject);
    procedure dxLocalExeClick(Sender: TObject);
    procedure bgComponentsItems11Click(Sender: TObject);
    procedure dxFreeExeClick(Sender: TObject);
    procedure bgComponentsItems14Click(Sender: TObject);
    procedure bgComponentsItemsGetBackPassWordClick(Sender: TObject);
    procedure bgComponentsItemsServerComboBox(Sender: TObject);
    procedure BtnResourcesClick(Sender: TObject);
    procedure BtnAddEmbResClick(Sender: TObject);
  private
    { Private declarations }
    FChanged: Boolean;
    FFileName: String;
    FCompnentCls: TComponentClass;
    FFormContainer: TFormDesignContainer;
    FRTTIInspector: TcxAdvRTTIInspector;
    function SaveSkin: Boolean;
    procedure OutExe(Local: Boolean; UrlIdx: Integer; const AUrl: String);
    procedure OnOutExeClick(Sender: TObject);
    procedure RttiEditValueChanged(Sender: TObject; ARowProperties: TcxCustomEditorRowProperties);
    procedure RttiFilterProperty(Sender: TObject; const PropertyName: string; var Accept: Boolean);
    procedure RttiDrawRowHeader(Sender: TObject; ACanvas: TcxCanvas; APainter: TcxvgPainter; AHeaderViewInfo: TcxCustomRowHeaderInfo; var Done: Boolean);
  public
    { Public declarations }
    procedure OpenSkin(const FileName: String);
  end;
  function CreateGUID: String;
var
  FRMLgoinEditor: TFRMLgoinEditor;

implementation

uses
  M2Validate, M2GDIPictureEd, Grobal2, M2LoginServerList;

{$R *.dfm}

function CreateGUID: String;
var
  gid: TGUID;
begin
  SysUtils.CreateGUID(gid);
  Result  :=  GUIDToString(gid);
  Result  :=  Copy(Result, 2, 36);
end;

procedure TFRMLgoinEditor.bgComponentsItems1Click(Sender: TObject);
begin
  FCompnentCls  :=  TuImage;
end;

procedure TFRMLgoinEditor.bgComponentsItems2Click(Sender: TObject);
begin
  FCompnentCls  :=  TuStartBtton;
end;

procedure TFRMLgoinEditor.bgComponentsItems3Click(Sender: TObject);
begin
  FCompnentCls  :=  TuMinimizeButton;
end;

procedure TFRMLgoinEditor.bgComponentsItems4Click(Sender: TObject);
begin
  FCompnentCls  :=  TuCloseButton;
end;

procedure TFRMLgoinEditor.bgComponentsItems5Click(Sender: TObject);
begin
  FCompnentCls  :=  TuURLButton;
end;

procedure TFRMLgoinEditor.bgComponentsItems6Click(Sender: TObject);
begin
  FCompnentCls  :=  TuConfigButton;
end;

procedure TFRMLgoinEditor.bgComponentsItems7Click(Sender: TObject);
begin
  FCompnentCls  :=  TuRegisterButton;
end;

procedure TFRMLgoinEditor.bgComponentsItems8Click(Sender: TObject);
begin
  FCompnentCls  :=  TuChangePassButton;
end;

procedure TFRMLgoinEditor.bgComponentsItems9Click(Sender: TObject);
begin
  FCompnentCls  :=  TuWebBrowser;
end;

procedure TFRMLgoinEditor.bgComponentsItems10Click(Sender: TObject);
begin
  FCompnentCls  :=  TuTreeView;
end;

procedure TFRMLgoinEditor.bgComponentsItems11Click(Sender: TObject);
begin
  FCompnentCls  :=  TuInfLable;
end;

procedure TFRMLgoinEditor.bgComponentsItems12Click(Sender: TObject);
begin
  FCompnentCls  :=  TuCurProgressBar;
end;

procedure TFRMLgoinEditor.bgComponentsItems13Click(Sender: TObject);
begin
  FCompnentCls  :=  TuAllProgressBar;
end;

procedure TFRMLgoinEditor.bgComponentsItems14Click(Sender: TObject);
begin
  FCompnentCls := nil;
end;

procedure TFRMLgoinEditor.bgComponentsItemsServerComboBox(Sender: TObject);
begin
  FCompnentCls  :=  TuServerCombobox;
end;

procedure TFRMLgoinEditor.bgComponentsItemsGetBackPassWordClick(Sender: TObject);
begin
  FCompnentCls  :=  TuGetBackPassButton;
end;

procedure TFRMLgoinEditor.BtnResourcesClick(Sender: TObject);
begin
  if FFormContainer.Form <> nil then
  begin
    if M2LoginEmbFiles.EditEmbeddedFiles(TuForm(FFormContainer.Form).EmbeddedFiles) then
    begin
      FChanged  :=  True;
      dxSave.Enabled  :=  True;
    end;
  end;
end;

procedure TFRMLgoinEditor.ButtonGroup1Items0Click(Sender: TObject);
begin
  FCompnentCls  :=  TuLable;
end;

procedure TFRMLgoinEditor.dxAlign1Click(Sender: TObject);
begin
  FormDesigner.Align(alBottom);
end;

procedure TFRMLgoinEditor.dxAlign2Click(Sender: TObject);
begin
  FormDesigner.Align(alHCenter);
end;

procedure TFRMLgoinEditor.dxAlign3Click(Sender: TObject);
begin
  FormDesigner.Align(alLeft);
end;

procedure TFRMLgoinEditor.dxAlign4Click(Sender: TObject);
begin
  FormDesigner.Align(alRight);
end;

procedure TFRMLgoinEditor.dxAlign5Click(Sender: TObject);
begin
  FormDesigner.Align(alTop);
end;

procedure TFRMLgoinEditor.dxAlign6Click(Sender: TObject);
begin
  FormDesigner.Align(alVCenter);
end;

procedure TFRMLgoinEditor.dxAlign7Click(Sender: TObject);
begin
  FormDesigner.Size(saHeights, 0);
end;

procedure TFRMLgoinEditor.dxAlign8Click(Sender: TObject);
begin
  FormDesigner.Size(saWidths, 0);
end;

procedure TFRMLgoinEditor.dxBarButton16Click(Sender: TObject);
begin
  Close;
end;

procedure WriteLoginExeEmbeddedFile(EmbededFile:TEmbeddedFileItem;ExeStream:TStream);
var
  AEmbeddedFile: TEmbeddedFile;
  ATmp: TMemoryStream;
  FileStream:TFileStream;
begin
  Try
    FileStream := TFileStream.Create(EmbededFile.FileName, fmOpenRead or fmShareDenyNone);
  except
    ShowMessage('无法内嵌资源文件被占用:' + EmbededFile.FileName);
  end;

  if FileStream <> nil then
  begin
    Try
      if FileStream.Size > 0 then
      begin
        FillChar(AEmbeddedFile, SizeOf(TEmbeddedFile), #0);
        AEmbeddedFile.Path := EmbededFile.Path;
        AEmbeddedFile.FileName := ExtractFileName(EmbededFile.FileName);
        AEmbeddedFile.ZLib := EmbededFile.ZLib;
        AEmbeddedFile.Replace := EmbededFile.Replace;

        if AEmbeddedFile.ZLib then
        begin
          ATmp := TMemoryStream.Create;
          Try
            FileStream.Position := 0;
            ZCompressStream(FileStream,ATmp,zcMax);
            AEmbeddedFile.Size := ATmp.Size;
            ATmp.Position := 0;
            ExeStream.WriteBuffer(AEmbeddedFile, SizeOf(TEmbeddedFile));
            ExeStream.CopyFrom(ATmp, ATmp.Size);
          finally
            ATmp.Free;
          end;
        end else
        begin
          AEmbeddedFile.Size := FileStream.Size;
          ExeStream.WriteBuffer(AEmbeddedFile, SizeOf(TEmbeddedFile));
          ExeStream.CopyFrom(FileStream, FileStream.Size);
        end;
      end;
    finally
      FileStream.Free;
    end;
  end;
end;

procedure TFRMLgoinEditor.BtnAddEmbResClick(Sender: TObject);

  procedure BuildLoginExeEx(AExeDest: TFileStream);
  var
    I, AFileSize: Integer;
    AEbmFile: TStream;
    OldExeStructure, ExeStructure: TuExecutableStructure;
    AExecutableStream, ExeStructureStream, EcdExeStructureStream, ATmp: TMemoryStream;
    ABuf: PAnsiChar;
    AEmbeddedFile: TEmbeddedFile;
    EncodeDataSize:Integer;
  begin
    EncodeDataSize := SizeOf(TuExecutableStructure) + 16;
//    VMProtectSDK.VMProtectBeginUltra('BuildLoginExeEx');
    AExeDest.Position := AExeDest.Size - EncodeDataSize;

    AExecutableStream := TMemoryStream.Create;
    ATmp := TMemoryStream.Create;
    GetMem(ABuf, EncodeDataSize);
    try
      AExeDest.ReadBuffer(ABuf^, EncodeDataSize);
      AExecutableStream.WriteBuffer(ABuf^, EncodeDataSize);

      uEDCode.DecodeStream(AExecutableStream, ATmp, uEDCode.DecodeSource('Ll1Y+A4rDt8rOPrGcM1EOplrcBCgtiVfDIwoHrWuHHK0kPwHBNKPhIdmhUf1A6tRLd42eA2QYeS3WygIoQE67DAtLwIB+BkvLUTEhDv0yDo='));
      AExecutableStream.Clear;
      uEDCode.DecodeStream(ATmp, AExecutableStream, uEDCode.DecodeSource('FzOIYQP/MOqlAMNHjqk2AXl4DncjTQU39X7zdmFYgHWKe3Q4sfCMdhQ6KwLzYucQZje70HIYCUNTEItppmN2UaYvDQhUiGts4SzCol7jXoM='));
      AExecutableStream.Seek(0, soFromBeginning);
      AExecutableStream.ReadBuffer(OldExeStructure, SizeOf(TuExecutableStructure));
      if (OldExeStructure.Title <> '') or (OldExeStructure.SkinDataLen > 0) then
      begin
        Application.MessageBox(PChar(uEDCode.DecodeSource('DGSsRnab9e4B09cRa/BtXvSnGRRjGUy9UBdr5j2U5cTmlYofnt0=')), PChar(uEDCode.DecodeSource('HYrrvP9Wk/Uo71sl')), MB_OK);
        Exit;
      end;
    finally
      AExecutableStream.Free;
      ATmp.Free;
      FreeMem(ABuf);
    end;

    ATmp := TMemoryStream.Create;
    try
      AExeDest.Position := 0;
      if OldExeStructure.Offset = -1 then
        ATmp.CopyFrom(AExeDest, AExeDest.Size - EncodeDataSize)
      else
        ATmp.CopyFrom(AExeDest, OldExeStructure.Offset);
      ATmp.Position := 0;
      AExeDest.Size := 0;
      AExeDest.CopyFrom(ATmp, ATmp.Size);
    finally
      ATmp.Free;
    end;

    FillChar(ExeStructure, SizeOf(TuExecutableStructure), #0);
    ExeStructure.Offset := AExeDest.Position;
    if TuForm(FFormContainer.Form).EmbeddedFiles.Count > 0 then
    begin
      for I := 0 to TuForm(FFormContainer.Form).EmbeddedFiles.Count - 1 do
      begin
        if FileExists(TuForm(FFormContainer.Form).EmbeddedFiles[I].FileName) then
        begin
          WriteLoginExeEmbeddedFile(TuForm(FFormContainer.Form).EmbeddedFiles[I],AExeDest);
        end;
      end;
    end;
    ExeStructureStream := TMemoryStream.Create;
    EcdExeStructureStream := TMemoryStream.Create;
    try
      ExeStructureStream.WriteBuffer(ExeStructure, SizeOf(TuExecutableStructure));
      uEDCode.EncodeStream(ExeStructureStream, EcdExeStructureStream, '08719071-B701-4F41-A8FB-3F4F04406621');
      ExeStructureStream.Clear;
      uEDCode.EncodeStream(EcdExeStructureStream, ExeStructureStream, '58C3CCD4-010E-4F11-8050-BB09060B4895');
      ExeStructureStream.Position := 0;
      AExeDest.WriteBuffer(ExeStructureStream.Memory^, ExeStructureStream.Size);
    finally
      ExeStructureStream.Free;
      EcdExeStructureStream.Free;
    end;
//    VMProtectSDK.VMProtectEnd;
  end;

var
  ALogin: TFileStream;
begin
  with TOpenDialog.Create(nil) do
  begin
    try
      Filter := '可执行文件|*.exe';
      if Execute then
      begin
        ALogin := TFileStream.Create(FileName, fmOpenReadWrite);
        try
          BuildLoginExeEx(ALogin);
        finally
          ALogin.Free;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TFRMLgoinEditor.dxFreeExeClick(Sender: TObject);
var
  AUrl: String;
begin
  if M2LoginServerList.GetList(AURL) then
  begin
    OutExe(True, 0, AUrl);
  end;
end;

procedure TFRMLgoinEditor.dxLocalExeClick(Sender: TObject);
begin
//  VMProtectSDK.VMProtectBegin('OutLocalExe');
  OutExe(True, 0, '');
//  VMProtectSDK.VMProtectEnd;
end;

procedure TFRMLgoinEditor.dxBarButton44Click(Sender: TObject);
begin
  FFormContainer.ShowRuler  :=  not FFormContainer.ShowRuler;
  if FFormContainer.ShowRuler then
    dxBarButton44.Hint  :=  '隐藏标尺'
  else
    dxBarButton44.Hint  :=  '显示标尺';
  FFormContainer.AdjustScroll;
  FFormContainer.Invalidate;
end;

procedure TFRMLgoinEditor.dxOpenClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
    try
      Filter  :=  uEDCode.DecodeSource('GqrMDd72NTLZGj4HWcun05VxHo084cKgI+Rr5yVRsybhM+VYMc6OYw==');
      if Execute then
      begin
        OpenSkin(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TFRMLgoinEditor.dxNewClick(Sender: TObject);
begin
//  VMProtectSDK.VMProtectBegin('NewCliSkin');
  FormDesigner.QuitDesign;
  if FFormContainer.Form <> nil then
    FFormContainer.Form.Free;
  FFormContainer.Form :=  CreateCliFrom(nil);
  FFormContainer.Invalidate;
  FormDesigner.Design(FFormContainer.Form);
  uComponentList1.ClearComponents;
  uComponentList1.LoadComponents;
  FChanged :=  False;
  dxPrivew.Enabled  :=  True;
  dxPrivew.Enabled  :=  True;
  dxFreeExe.Enabled :=  True;
  BtnResources.Enabled := True;
  BtnAddEmbRes.Enabled := True;
  dxLocalExe.Enabled:=  True;
//  VMProtectSDK.VMProtectEnd;
end;

procedure TFRMLgoinEditor.dxPrivewClick(Sender: TObject);
var
  S: TMemoryStream;
  F: TuForm;
begin
  if FFormContainer.Form = nil then Exit;
  
  S :=  TMemoryStream.Create;
  try
    TForm(FFormContainer.Form).Visible := False;
    S.WriteComponent(FFormContainer.Form);
    S.Seek(0, soFromBeginning);
    F :=  CreateCliFrom(Self);
    S.ReadComponent(F);
    F.Name  :=  '_' + ReplaceText(CreateGUID, '-', '_');
    F.Position  :=  poDesktopCenter;
    F.Show;
  finally
    TForm(FFormContainer.Form).Visible := True;
    S.Free;
  end;
end;

procedure TFRMLgoinEditor.dxSaveClick(Sender: TObject);
begin
//  VMProtectSDK.VMProtectBegin('SaveCliSkin');
  SaveSkin;
//  VMProtectSDK.VMProtectEnd;
end;

procedure TFRMLgoinEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action  :=  caFree;
end;

procedure TFRMLgoinEditor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if FChanged then
    case Application.MessageBox(PChar(uEDCode.DecodeSource('k8x+rhEHoHVpJ/vA+G5vmElULjyYAuAwKI7ULFsgtWu7xYq3')), PChar(uEDCode.DecodeSource('2OJVSQxKhDeRfayd')), MB_YESNOCANCEL) of
      ID_YES:     CanClose  :=  SaveSkin;
      ID_NO:      CanClose  :=  True;
      ID_CANCEL:  CanClose  :=  False;
    end
  else
    CanClose  :=  True;
end;

procedure TFRMLgoinEditor.FormCreate(Sender: TObject);
begin
  FCompnentCls    :=  nil;
  FFormContainer  :=  TFormDesignContainer.Create(Self);
  FFormContainer.Parent     :=  Panel1;
  FFormContainer.Color      :=  clWhite;
  FFormContainer.ShowRuler  :=  True;
  FFormContainer.ShowFrame  :=  True;
  FFormContainer.Align      :=  alClient;
  FFormContainer.Form       :=  nil;

  FRTTIInspector := TcxAdvRTTIInspector.Create(Self);
  FRTTIInspector.Parent := dxDockPanel1;
  FRTTIInspector.Align := alClient;
  FRTTIInspector.OptionsView.PaintStyle :=  psDotNet;
  FRTTIInspector.OptionsView.Sorted  :=  False;
  FRTTIInspector.LookAndFeel.Kind  :=  lfFlat;
  FRTTIInspector.OptionsView.RowHeaderWidth  :=  200;
  FRTTIInspector.OnDrawRowHeader     :=  RttiDrawRowHeader;
  FRTTIInspector.OnEditValueChanged  :=  RttiEditValueChanged;
  FRTTIInspector.OnFilterProperty    :=  RttiFilterProperty;
  FRTTIInspector.OptionsBehavior.GoToNextCellOnTab :=  True;
  ActiveX.OleInitialize(nil);
  StatusBar.Panels[0].Text := APP_VERSION;
end;

procedure TFRMLgoinEditor.FormDestroy(Sender: TObject);
begin
  if FFormContainer.Form <> nil then
    FFormContainer.Form.Free;
  OleUninitialize;
end;

procedure TFRMLgoinEditor.OnOutExeClick(Sender: TObject);
begin
//  VMProtectSDK.VMProtectBegin('OutPublicExe');
  OutExe(False, TdxBarButton(Sender).Tag, '');
//  VMProtectSDK.VMProtectEnd;
end;

procedure TFRMLgoinEditor.OpenSkin(const FileName: String);
begin
//  VMProtectSDK.VMProtectBegin('OpenCliSkin');
  if FileExists(FileName) then
  begin
    FormDesigner.QuitDesign;
    if FFormContainer.Form <> nil then
      FFormContainer.Form.Free;
    FFormContainer.Form :=  CreateCliFrom(nil);
    FFileName :=  FileName;
    Caption :=  uEDCode.DecodeSource('+Qdap9cKkOiMkp6YCQWNdEW1')+FFileName;
    FormDesigner.Design(FFormContainer.Form);
    TuForm(FFormContainer.Form).LoadFromFile(FileName);
    uComponentList1.ClearComponents;
    uComponentList1.LoadComponents;
    FFormContainer.AdjustScroll;
    FFormContainer.Invalidate;
    FChanged :=  False;
    dxPrivew.Enabled  :=  True;
    BtnResources.Enabled := True;
    dxLocalExe.Enabled:=  True;
    dxFreeExe.Enabled :=  True;
    BtnAddEmbRes.Enabled := True;
  end;
//  VMProtectSDK.VMProtectEnd;
end;

procedure TFRMLgoinEditor.OutExe(Local: Boolean; UrlIdx: Integer; const AUrl: String);
var
  ExeRes: TResourceStream;
  AExeDest,
  AEbmFile: TFileStream;
  ASkinStream: TMemoryStream;
  ExeStructure: TuExecutableStructure;
  ExeStructureStream,
  EcdExeStructureStream: TMemoryStream;
  I: Integer;
  boA, boB: Boolean;
  AEmbeddedFile: TEmbeddedFile;
  List : TStringList;
  function TryGetStrings(Index:Integer):String;
  begin
      if Index < List.Count then
        Result := List[Index]
      else
        Result := '';
  end;

begin
//  VMProtectSDK.VMProtectBeginUltra('BuildLoginExe');
  boA :=  False;
  boB :=  False;
  for I := 0 to FFormContainer.Form.ComponentCount - 1 do
  begin
    if (FFormContainer.Form.Components[I] is TuTreeView) then
      boA :=  True;
    if (FFormContainer.Form.Components[I] is TuServerCombobox) then
      boA :=  True;
    if (FFormContainer.Form.Components[I] is TuStartBtton) then
      boB :=  True;
  end;
  if boA and boB then
  begin
    with TSaveDialog.Create(nil) do
    begin
      try
        DefaultExt  :=  uEDCode.DecodeSource('xu20pHfAGwSgcfzNpYQskg==');
        Filter      :=  uEDCode.DecodeSource('zwUB4nBH+bmCGKzrplTXGe3GwWlALv+KByKyPr6r');
        if Execute then
        begin
          FillChar(ExeStructure, SizeOf(TuExecutableStructure), #0);
          ExeRes :=  TResourceStream.Create(HInstance, uEDCode.DecodeSource('ZLaKEau4RCWEC5phenYyNQhVg+qLIQ2+dbjncaN9om7xjA=='), RT_RCDATA);
          ASkinStream :=  TMemoryStream.Create;
          ExeStructureStream    :=  TMemoryStream.Create;
          EcdExeStructureStream :=  TMemoryStream.Create;
          AExeDest :=  TFileStream.Create(FileName, fmCreate);
          try
            //Step.1     //写入登录器 exe文件
            AExeDest.WriteBuffer(ExeRes.Memory^, ExeRes.Size);
            //Step.2  //写入皮肤
            TuForm(FFormContainer.Form).SaveToStream(ASkinStream);
            ExeStructure.Offset := AExeDest.Position;
            AExeDest.WriteBuffer(ASkinStream.Memory^, ASkinStream.Size);
            //Step.3 //写入嵌入文件

            for I := 0 to TuForm(FFormContainer.Form).EmbeddedFiles.Count - 1 do
            begin
              if FileExists(TuForm(FFormContainer.Form).EmbeddedFiles[I].FileName) then
              begin
                WriteLoginExeEmbeddedFile(TuForm(FFormContainer.Form).EmbeddedFiles[I],AExeDest);
              end;
            end;

            //Step.4   //写入列表以及
            List := TStringList.Create;
            List.Text := AUrl;
            ExeStructure.ServerListURL  :=  TryGetStrings(0);
            ExeStructure.ServerListURL2  :=  TryGetStrings(1);
            ExeStructure.ServerListURL3  :=  TryGetStrings(2);

            ExeStructure.Title          :=  ChangeFileExt(ExtractFileName(FileName),'');
            ExeStructure.SkinDataLen    :=  ASkinStream.Size;
            ExeStructureStream.WriteBuffer(ExeStructure, SizeOf(TuExecutableStructure));
            uEDCode.EncodeStream(ExeStructureStream, EcdExeStructureStream, '08719071-B701-4F41-A8FB-3F4F04406621');
            ExeStructureStream.Clear;
            uEDCode.EncodeStream(EcdExeStructureStream, ExeStructureStream, '58C3CCD4-010E-4F11-8050-BB09060B4895');
            AExeDest.WriteBuffer(ExeStructureStream.Memory^, ExeStructureStream.Size);
          finally
            AExeDest.Free;
            ExeRes.Free;
            ExeStructureStream.Free;
            EcdExeStructureStream.Free;
          end;
        end;
      finally
        Free;
      end;
    end;
  end
  else
  begin
    Application.MessageBox(PChar(uEDCode.DecodeSource('lasRvjsXVUqGNSCxyusj9p3zyf2Q/XxAgFlXyIeKh9B26qgIRgIuJRMUVMIe8IWfbyelo6A89dOjp6+T')), PChar(uEDCode.DecodeSource('MhTzRjXFeEwe3cCZ')), MB_OK and MB_ICONERROR);
  end;
//  VMProtectSDK.VMProtectEnd;
end;

procedure TFRMLgoinEditor.RttiDrawRowHeader(Sender: TObject; ACanvas: TcxCanvas;
  APainter: TcxvgPainter; AHeaderViewInfo: TcxCustomRowHeaderInfo;
  var Done: Boolean);
begin

end;

procedure TFRMLgoinEditor.RttiEditValueChanged(Sender: TObject;
  ARowProperties: TcxCustomEditorRowProperties);
begin
  dxSave.Enabled := True;
  FChanged := True;
end;

procedure TFRMLgoinEditor.RttiFilterProperty(Sender: TObject; const PropertyName: string; var Accept: Boolean);
begin
  Accept := not (PropertyName[1] in ['A'..'Z', 'a'..'z']);
end;

function TFRMLgoinEditor.SaveSkin: Boolean;
begin
  Result  :=  False;
  if FFileName = '' then
    with TSaveDialog.Create(nil) do
      try
        Filter  :=  uEDCode.DecodeSource('y1rZqNPC7q/bICYWEHM6BeA3RiOEWsMATDHOIC7quLRjvX9obFWM5w==');
        DefaultExt  :=  uEDCode.DecodeSource('sKpmnh1/6vXBrrRloP6yGLFU3dThQg==');
        if Execute then
        begin
          FFileName :=  FileName;
          Caption :=  uEDCode.DecodeSource('8VApXyd394rJAbltPG2gmwxA')+FFileName;
        end;
      finally
        Free;
      end;

  if FFileName <> '' then
  begin
    TuForm(FFormContainer.Form).SaveToFile(FFileName);
    dxSave.Enabled  :=  False;
    FChanged  :=  False;
    Result  :=  True;
  end;
end;

procedure TFRMLgoinEditor.FormDesignerFormSizeChange(Sender: TObject);
begin
  if not FFormContainer.InDragging then
  begin
    FFormContainer.AdjustScroll;
    FFormContainer.Invalidate;
  end;
end;

procedure TFRMLgoinEditor.FormDesignerModified(Sender: TObject);
begin
  FChanged  :=  True;
  dxSave.Enabled  :=  True;
end;

procedure TFRMLgoinEditor.FormDesignerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FCompnentCls <> nil then
    FormDesigner.InsertNewComponent(FCompnentCls);
  FCompnentCls  :=  nil;
end;

procedure TFRMLgoinEditor.FormDesignerSelectionChange(Sender: TObject);
begin
  dxAlign1.Enabled  :=  FormDesigner.SelectionCount > 1;
  dxAlign2.Enabled  :=  FormDesigner.SelectionCount > 1;
  dxAlign3.Enabled  :=  FormDesigner.SelectionCount > 1;
  dxAlign4.Enabled  :=  FormDesigner.SelectionCount > 1;
  dxAlign5.Enabled  :=  FormDesigner.SelectionCount > 1;
  dxAlign6.Enabled  :=  FormDesigner.SelectionCount > 1;
  dxAlign7.Enabled  :=  FormDesigner.SelectionCount > 1;
  dxAlign8.Enabled  :=  FormDesigner.SelectionCount > 1;
  FRTTIInspector.InspectedObject := FormDesigner.Selections[0];
end;

type
  TuImageButtonGraphicProperty = class(TcxGraphicProperty)
  public
    procedure Edit; override;
    function GetName: String; override;
    function GetValue: String; override;
  end;
  TXXPictureProperty = class(TcxPictureProperty)
  public
    function GetName: String; override;
    function GetValue: String; override;
  end;
  TControlIntProperty = class(TcxIntegerProperty)
  public
    function GetName: String; override;
  end;
  TControlCurProperty = class(TcxCursorProperty)
  public
    function GetName: String; override;
  end;
  TControlStrProperty = class(TcxStringProperty)
  public
    function GetName: String; override;
  end;
  TControlAlignProperty = class(TcxEnumProperty)
  public
    function GetName: String; override;
  end;
  TImageBoolProperty = class(TcxBoolProperty)
  public
    function GetName: String; override;
  end;
  TuURLKindProperty = class(TcxEnumProperty)
    function GetName: String; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;
  TuURLProperty  = class(TcxStringProperty)
  public
    function GetName: String; override;
  end;
  TuLableCaptionProperty = class(TcxCaptionProperty)
  public
    function GetName: String; override;
  end;
  TWinControlBevelProperty = class(TcxEnumProperty)
    function GetName: String; override;
  end;
  TWinControlBevelKindProperty = class(TcxEnumProperty)
    function GetName: String; override;
  end;
  TXXFontProperty = class(TcxFontProperty)
    function GetName: String; override;
    function GetValue: string; override;
    function GetAttributes: TcxPropertyAttributes; override;
  end;
  TFormBoolProperty = class(TcxBoolProperty)
  public
    function GetName: String; override;
  end;
  TFormTransparentColorProperty = class(TcxColorProperty)
  public
    function GetName: String; override;
  end;
  TFormAlphaBlendValueProperty = class(TcxIntegerProperty)
  public
    function GetName: String; override;
  end;
  TTreeViewColorProperty = class(TcxColorProperty)
  public
    function GetName: String; override;
  end;
  TW7ProgressBarBoolProperty = class(TcxBoolProperty)
  public
    function GetName: String; override;
  end;
  TW7ProgressBarStyleProperty = class(TcxEnumProperty)
  public
    function GetName: String; override;
  end;

{ TuImageButtonGraphicProperty }

procedure TuImageButtonGraphicProperty.Edit;
var
  Data: TcxGDIPictureEditorDlgData;
  P: TGDIPPicture;
begin
  P := TGDIPPicture.Create;
  try
    P.Assign(GetGraphic);
    Data.Caption := GetComponent(0).GetNamePath + '.' + GetName;
    Data.LookAndFeel := nil;
    if Inspector <> nil then
      Data.LookAndFeel := TcxCustomRTTIInspector(Inspector).LookAndFeel;
    Data.Picture := P;
    if cxShowGDIPictureEditor(@Data) then
    begin
      SetGraphic(P);
      PostChangedNotification;
    end;
  finally
    P.Free;
  end;
end;

function TuImageButtonGraphicProperty.GetName: String;
var
  AName: String;
begin
  AName :=  GetPropInfo^.Name;
  if SameText(AName, 'Picture') then
    Result  :=  '正常状态图片'
  else if SameText(AName, 'PictureHot') then
    Result  :=  '获取焦时显示图片'
  else if SameText(AName, 'PictureDown') then
    Result  :=  '鼠标按下时显示图片'
  else if SameText(AName, 'PictureDisabled') then
    Result  :=  '禁用时显示图片';
end;

function TuImageButtonGraphicProperty.GetValue: String;
begin
  if (GetGraphic <> nil) and not GetGraphic.Empty then
    Result := '(图片)'
  else
    Result := '(空)';
end;

{ TControlIntProperty }

function TControlIntProperty.GetName: String;
var
  AName: String;
begin
  AName :=  GetPropInfo^.Name;
  if SameText(AName, 'Left') then
    Result  :=  '左边距'
  else if SameText(AName, 'Top') then
    Result  :=  '顶边距'
  else if SameText(AName, 'Width') then
    Result  :=  '宽'
  else if SameText(AName, 'Height') then
    Result  :=  '高';
end;

{ TControlStrProperty }

function TControlStrProperty.GetName: String;
var
  AName: String;
begin
  AName :=  GetPropInfo^.Name;
  if SameText(AName, 'Name') then
    Result  :=  '名称';
end;

{ TImageBoolProperty }

function TImageBoolProperty.GetName: String;
var
  AName: String;
begin
  AName :=  GetPropInfo^.Name;
  if SameText(AName, 'Center') then
    Result  :=  '居中显示'
  else if SameText(AName, 'Stretch') then
    Result  :=  '拉伸'
  else if SameText(AName, 'Transparent') then
    Result  :=  '透明显示'
  else if SameText(AName, 'AutoSize') then
    Result  :=  '自适应大小';
end;

{ TControlCurProperty }

function TControlCurProperty.GetName: String;
begin
  Result := '鼠标样式';
end;

{ TuURLKindProperty }

const
  TuStrURLKind: array[TuURLKind] of String= ('自定义网址', '访问主页', '访问充值页面', '访问联系页面');

function TuURLKindProperty.GetName: String;
begin
  Result := '功能链接类型';
end;

function TuURLKindProperty.GetValue: string;
begin
  Result  :=  TuStrURLKind[TuURLButton(GetComponent(0)).URLKind];
end;

procedure TuURLKindProperty.GetValues(Proc: TGetStrProc);
var
  I: TuURLKind;
begin
  for I := Low(TuStrURLKind) to High(TuStrURLKind) do
    Proc(TuStrURLKind[I]);
end;

procedure TuURLKindProperty.SetValue(const Value: string);
var
  I,
  AType: TuURLKind;
begin
  AType :=  TuURLKind.ukCustom;
  for I := Low(TuStrURLKind) to High(TuStrURLKind) do
    if SameText(TuStrURLKind[I], Value) then
    begin
      AType :=  I;
      Break;
    end;

  TuURLButton(GetComponent(0)).URLKind  :=  AType;
end;

{ TuURLProperty }

function TuURLProperty.GetName: String;
begin
  Result := '网址';
end;

{ TuLableCaptionProperty }

function TuLableCaptionProperty.GetName: String;
begin
  Result := '标签内容';
end;

{ TControlAlignProperty }

function TControlAlignProperty.GetName: String;
begin
  Result := '对齐方式';
end;

{ TXXPictureProperty }

function TXXPictureProperty.GetName: String;
begin
  Result := '图片';
end;

function TXXPictureProperty.GetValue: String;
begin
  if (GetGraphic <> nil) and not GetGraphic.Empty then
    Result := '(图片)'
  else
    Result := '(空)';
end;

{ TXXFontProperty }

function TXXFontProperty.GetAttributes: TcxPropertyAttributes;
begin
  Result := [ipaDialog, ipaReadOnly];
end;

function TXXFontProperty.GetName: String;
begin
  Result := '字体设置';
end;

function TXXFontProperty.GetValue: string;
begin
  Result := '(字体)';
end;

{ TFormBoolProperty }

function TFormBoolProperty.GetName: String;
var
  AName: String;
begin
  AName :=  GetPropInfo^.Name;
  if SameText(AName, 'AlphaBlend') then
    Result  :=  '透明显示'
  else if SameText(AName, 'TransparentColor') then
    Result  :=  '对指定颜色透明'
  else if SameText(AName, 'AutoSize') then
    Result := '自适应大小';
end;

{ TFormTransparentColorProperty }

function TFormTransparentColorProperty.GetName: String;
begin
  Result := '透明色';
end;

{ TFormAlphaBlendValueProperty }

function TFormAlphaBlendValueProperty.GetName: String;
begin
  Result := '透明度';
end;

{ TTreeViewColorProperty }

function TTreeViewColorProperty.GetName: String;
begin
  Result := '背景色';
end;

{ TW7ProgressBarBoolProperty }

function TW7ProgressBarBoolProperty.GetName: String;
begin
  Result := '透明显示';
end;

{ TW7ProgressBarStyleProperty }

function TW7ProgressBarStyleProperty.GetName: String;
begin
  Result := '进度条样式';
end;

{ TWinControlBevelProperty }

function TWinControlBevelProperty.GetName: String;
var
  AName: String;
begin
  AName :=  GetPropInfo^.Name;
  if SameText(AName, 'BevelInner') then
    Result  :=  '内斜面样式'
  else if SameText(AName, 'BevelOuter') then
    Result  :=  '外斜面样式';
end;

{ TWinControlBevelKindProperty }

function TWinControlBevelKindProperty.GetName: String;
begin
  Result  :=  '斜面样式';
end;

initialization
  cxRegisterPropertyEditor(TypeInfo(TComponentName), TControl, 'Name', TControlStrProperty);
  cxRegisterPropertyEditor(TypeInfo(TAlign), TControl, 'Align', TControlAlignProperty);
  cxRegisterPropertyEditor(TypeInfo(TCursor), TControl, 'Cursor', TControlCurProperty);
  cxRegisterPropertyEditor(TypeInfo(Integer), TControl, 'Left', TControlIntProperty);
  cxRegisterPropertyEditor(TypeInfo(Integer), TControl, 'Top', TControlIntProperty);
  cxRegisterPropertyEditor(TypeInfo(Integer), TControl, 'Width', TControlIntProperty);
  cxRegisterPropertyEditor(TypeInfo(Integer), TControl, 'Height', TControlIntProperty);
  cxRegisterPropertyEditor(TypeInfo(Boolean), TuImage, 'Center', TImageBoolProperty);
  cxRegisterPropertyEditor(TypeInfo(Boolean), TuImage, 'Stretch', TImageBoolProperty);
  cxRegisterPropertyEditor(TypeInfo(Boolean), TuImage, 'Transparent', TImageBoolProperty);
  cxRegisterPropertyEditor(TypeInfo(Boolean), TuImage, 'AutoSize', TImageBoolProperty);
  cxRegisterPropertyEditor(TypeInfo(TuURLKind), TuURLButton, 'URLKind', TuURLKindProperty);
  cxRegisterPropertyEditor(TypeInfo(String), TuURLButton, 'URL', TuURLProperty);
  cxRegisterPropertyEditor(TypeInfo(TCaption), TuLable, 'Caption', TuLableCaptionProperty);
  cxRegisterPropertyEditor(TypeInfo(TCaption), TuInfLable, 'Caption', TuLableCaptionProperty);

  cxRegisterPropertyEditor(TypeInfo(TBevelCut), TWinControl, 'BevelInner', TWinControlBevelProperty);
  cxRegisterPropertyEditor(TypeInfo(TBevelCut), TWinControl, 'BevelOuter', TWinControlBevelProperty);
  cxRegisterPropertyEditor(TypeInfo(TBevelKind), TWinControl, 'BevelKind', TWinControlBevelKindProperty);
  cxRegisterPropertyEditor(TypeInfo(TColor), TWinControl, 'Color', TTreeViewColorProperty);

  cxRegisterPropertyEditor(TypeInfo(Boolean), TCustomForm, 'AlphaBlend', TFormBoolProperty);
  cxRegisterPropertyEditor(TypeInfo(Boolean), TCustomForm, 'TransparentColor', TFormBoolProperty);
  cxRegisterPropertyEditor(TypeInfo(Boolean), TCustomForm, 'AutoSize', TFormBoolProperty);
  cxRegisterPropertyEditor(TypeInfo(TColor), TCustomForm, 'TransparentColorValue', TFormTransparentColorProperty);
  cxRegisterPropertyEditor(TypeInfo(Byte), TCustomForm, 'AlphaBlendValue', TFormAlphaBlendValueProperty);
  cxRegisterPropertyEditor(TypeInfo(TColor), TuTreeView, 'Color', TTreeViewColorProperty);
  cxRegisterPropertyEditor(TypeInfo(TColor), TW7CustomProgressBar, 'BackgroundColor', TTreeViewColorProperty);
  cxRegisterPropertyEditor(TypeInfo(Boolean), TW7CustomProgressBar, 'Transparent', TW7ProgressBarBoolProperty);
  cxRegisterPropertyEditor(TypeInfo(TW7ProgressBarStyle), TW7CustomProgressBar, 'Style', TW7ProgressBarStyleProperty);
  cxRegisterEditPropertiesClass(TFormTransparentColorProperty, TcxColorComboBoxProperties);
  cxRegisterEditPropertiesClass(TTreeViewColorProperty, TcxColorComboBoxProperties);

  cxRegisterPropertyEditor(TypeInfo(TPicture), nil, '', TXXPictureProperty);
  cxRegisterPropertyEditor(TypeInfo(TFont), nil, '', TXXFontProperty);
  cxRegisterPropertyEditor(TypeInfo(TGDIPPicture), TuImageButton, 'Picture', TuImageButtonGraphicProperty);
  cxRegisterPropertyEditor(TypeInfo(TGDIPPicture), TuImageButton, 'PictureHot', TuImageButtonGraphicProperty);
  cxRegisterPropertyEditor(TypeInfo(TGDIPPicture), TuImageButton, 'PictureDown', TuImageButtonGraphicProperty);
  cxRegisterPropertyEditor(TypeInfo(TGDIPPicture), TuImageButton, 'PictureDisabled', TuImageButtonGraphicProperty);

end.
