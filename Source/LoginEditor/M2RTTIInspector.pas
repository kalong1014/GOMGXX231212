unit M2RTTIInspector;

interface
  uses Classes, SysUtils, Types, cxHOI, cxVGrid, cxGraphics, cxEdit, cxTextEdit, cxCheckBox;

type
  TOnFilterPropertyEvent = procedure(Sender: TObject; APropertyEditor: TcxPropertyEditor; var Accept: Boolean) of Object;
  TcxAdvRTTIInspector = class(TcxRTTIInspector)
  private
    FOnM2FilterProperty: TOnFilterPropertyEvent;
  protected
    function GetEditPropertiesClass(APropertyEditor: TcxPropertyEditor): TcxCustomEditPropertiesClass; override;
    procedure PrepareEditProperties(AProperties: TcxCustomEditProperties; APropertyEditor: TcxPropertyEditor); override;
    function DoDrawRowHeader(AHeaderViewInfo: TcxCustomRowHeaderInfo): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    property PropertyEditor;
    property OnM2FilterProperty: TOnFilterPropertyEvent read FOnM2FilterProperty write FOnM2FilterProperty;
  end;
  TcxPropertyEditorCracker = class(TcxPropertyEditor);

function IsNotFilterProperty(const PropertyName: String): Boolean;

implementation
  uses cxDrawTextUtils, Graphics;

type
  TcxPropertyEditorCrack = class(TcxPropertyEditor);

{ TcxAdvRTTIInspector }

constructor TcxAdvRTTIInspector.Create(AOwner: TComponent);
begin
  inherited;
  OptionsView.Sorted := False;
end;

function TcxAdvRTTIInspector.DoDrawRowHeader(AHeaderViewInfo: TcxCustomRowHeaderInfo): Boolean;
var
  _Name: String;
  R: TRect;
begin
  Result := False;
  _Name := TcxPropertyEditorCrack(TcxPropertyRow(AHeaderViewInfo.Row).PropertyEditor).PropList[0].PropInfo^.Name;
  if SameText(_Name, 'Name') or SameText(_Name, 'ScriptItem') or SameText(_Name, 'MainMethod') then
  begin
    with AHeaderViewInfo.CaptionsInfo[0] do
    begin
      cxApplyViewParams(TcxvgPainter(Painter).Canvas, ViewParams);
      if not AHeaderViewInfo.Transparent then
        Painter.Canvas.FillRect(AHeaderViewInfo.HeaderRect, ViewParams.Bitmap);
      Painter.Canvas.Brush.Style := bsClear;
      Painter.Canvas.Font.Style := [fsBold];
      R := CaptionTextRect;
      if AHeaderViewInfo.Focused then
        cxTextOut(Painter.Canvas.Canvas, Caption, R, TextFlags, nil, 0, 0, 0, ViewParams.TextColor)
      else
        cxTextOut(Painter.Canvas.Canvas, Caption, R, TextFlags, nil, 0, 0, 0, clMaroon);
      Painter.DrawBackground;
      Painter.Canvas.Brush.Style := bsSolid;
      Painter.DrawImage(AHeaderViewInfo.CaptionsInfo[0]);
    end;
    Result := True;
   end;
end;

function TcxAdvRTTIInspector.GetEditPropertiesClass(APropertyEditor: TcxPropertyEditor): TcxCustomEditPropertiesClass;
var
  AAccept: Boolean;
begin
  Result := nil;
  if Assigned(FOnM2FilterProperty) then
  begin
    AAccept:= True;
    FOnM2FilterProperty(Self, APropertyEditor, AAccept);
    if not AAccept then
      Exit;
  end;
  Result := inherited GetEditPropertiesClass(APropertyEditor);
  if (APropertyEditor is TcxBoolProperty) or (APropertyEditor is TcxSetElementProperty) then
    Result := TcxCheckBoxProperties;
end;

procedure TcxAdvRTTIInspector.PrepareEditProperties(AProperties: TcxCustomEditProperties; APropertyEditor: TcxPropertyEditor);
begin
  inherited;
  if AProperties is TcxCheckBoxProperties then
  begin
    TcxCheckBoxProperties(AProperties).UseAlignmentWhenInplace := True;
    TcxCheckBoxProperties(AProperties).Alignment := taLeftJustify;
  end
  else if AProperties is TcxTextEditProperties then
  begin
    if APropertyEditor.GetName = '密码' then
    begin
      TcxTextEditProperties(AProperties).EchoMode := eemPassword;
      TcxTextEditProperties(AProperties).PasswordChar := '*';
    end
    else
    begin
      TcxTextEditProperties(AProperties).EchoMode := eemNormal;
      TcxTextEditProperties(AProperties).PasswordChar := #0;
    end
  end;
end;

function IsNotFilterProperty(const PropertyName: String): Boolean;
begin
  Result := not SameText(PropertyName, 'FixedNpcs') and not SameText(PropertyName, 'VerCopyright') and not SameText(PropertyName, 'Maps') and
    not SameText(PropertyName, 'MapQuest') and not SameText(PropertyName, 'Robots') and not SameText(PropertyName, 'ScriptExt') and
    not SameText(PropertyName, 'MapEvent') and not SameText(PropertyName, 'Merchants') and not SameText(PropertyName, 'Npcs') and
    not SameText(PropertyName, 'MonGen') and not SameText(PropertyName, 'Goods') and not SameText(PropertyName, 'DropItems') and
    not SameText(PropertyName, 'LineNotices') and not SameText(PropertyName, 'LoginNotices') and not SameText(PropertyName, 'Shop') and
    not SameText(PropertyName, 'GiftShop') and not SameText(PropertyName, 'DeckShop') and not SameText(PropertyName, 'SupplyShop') and
    not SameText(PropertyName, 'FortifierShop') and not SameText(PropertyName, 'FriendShop') and not SameText(PropertyName, 'LimitShop') and
    not SameText(PropertyName, 'Connections') and not SameText(PropertyName, 'Config') and not SameText(PropertyName, 'SpecItemSet') and
    not SameText(PropertyName, 'UnknowItemSet') and not SameText(PropertyName, 'AddValueItemSet') and not SameText(PropertyName, 'General') and
    not SameText(PropertyName, 'DBConfig') and not SameText(PropertyName, 'LevelExps') and not SameText(PropertyName, 'ItemSet') and
    not SameText(PropertyName, 'ShopGoods') and not SameText(PropertyName, 'HotShop') and not SameText(PropertyName, 'MerchantShops') and
    not SameText(PropertyName, 'Scripts') and not SameText(PropertyName, 'ScriptGroups') and not SameText(PropertyName, 'Guard') and
    not SameText(PropertyName, 'Resources') and not SameText(PropertyName, 'MineDrop') and not SameText(PropertyName, 'StartPoints') and
    not SameText(PropertyName, 'Duplicates') and not SameText(PropertyName, 'MasterList') and not SameText(PropertyName, 'LateralList') and
    not SameText(PropertyName, 'DailyList') and not SameText(PropertyName, 'BountyList') and not SameText(PropertyName, 'Envir') and
    not SameText(PropertyName, 'TaskCenter') and not SameText(PropertyName, 'RunType') and not SameText(PropertyName, 'ScriptLanguage') and
    not SameText(PropertyName, 'UI') and not SameText(PropertyName, 'SuiteItems') and not SameText(PropertyName, 'GameData') and
    not SameText(PropertyName, 'UnbindList') and not SameText(PropertyName, 'TypeNames') and not SameText(PropertyName, 'TypeNameVer') and
    not SameText(PropertyName, 'PlayMonConfig') and not SameText(PropertyName, 'MonSays') and not SameText(PropertyName, 'Boxs') and
    not SameText(PropertyName, 'Missions') and not SameText(PropertyName,'CustomActorAction') and not SameText(PropertyName,'SkillConfig') and
    not SameText(PropertyName, 'SkillEffectConfig');
end;

end.
