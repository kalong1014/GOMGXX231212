unit M2ImportFromOtherFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxSkinsCore, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  cxPC, StdCtrls, cxTextEdit, cxMaskEdit, cxButtonEdit, Menus, ComCtrls,
  cxListView, cxButtons, ExtCtrls, FileCtrl, uM2Project, cxRadioGroup,
  cxCheckBox, cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxProgressBar, cxCheckListBox, dxBarBuiltInMenu;

type
  TM2ImportFromOtherForm = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Panel1: TPanel;
    Label2: TLabel;
    LabTitle: TLabel;
    Panel2: TPanel;
    BtnPrPage: TcxButton;
    BtnNxPage: TcxButton;
    BtnExec: TcxButton;
    BtnClose: TcxButton;
    PageNoteBook: TcxPageControl;
    Sheet1: TcxTabSheet;
    Sheet2: TcxTabSheet;
    GroupBox1: TGroupBox;
    EditPath: TcxButtonEdit;
    Sheet3: TcxTabSheet;
    GroupBox2: TGroupBox;
    LabelWorking: TLabel;
    ProgressBar: TcxProgressBar;
    TreeWorking: TcxTreeList;
    WorkingStateColumn: TcxTreeListColumn;
    Memo1: TMemo;
    EditOptions: TcxCheckListBox;
    procedure EditPathPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnPrPageClick(Sender: TObject);
    procedure BtnNxPageClick(Sender: TObject);
    procedure BtnExecClick(Sender: TObject);
  private
    { Private declarations }
    FPageIndex: Integer;
    FProject: TM2Project;
    procedure SetPageIndex(AIndex: Integer);
    procedure BeginWork(const ATitle, AMessage: String);
    procedure EndWork(const AMessage: String);
    procedure WorkState(const AMessage: String; APosition, AMax: Integer);
  public
    { Public declarations }
    class procedure Execute(AProject: TM2Project);
  end;

implementation
  uses M2ProjectConv;

const
  _IO_Items = 0;
  _IO_Monster = 1;
  _IO_Magic = 2;
  _IO_MapInfo = 3;
  _IO_Guard = 4;
  _IO_Merchants = 5;
  _IO_Mogen = 6;
  _IO_DropItems = 7;
  _IO_Robot = 8;
  _IO_Script = 9;
  _IO_MapEvent = 10;
  _IO_MapQuest = 11;

{$R *.dfm}

procedure TM2ImportFromOtherForm.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TM2ImportFromOtherForm.BtnExecClick(Sender: TObject);

  function _Checked(ATag: Integer): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to EditOptions.Count - 1 do
    begin
      if EditOptionS.Items[I].Tag = ATag then
      begin
        Result := EditOptionS.Items[I].Checked;
        Exit;
      end;
    end;

  end;

  procedure __Inc(AConvetor: TuProjectConvetor; V: Boolean; O: TImportOption);
  begin
    if V then
      AConvetor.Options := AConvetor.Options + [O];
  end;

var
  AConvetor: TuProjectConvetor;
begin
  BtnClose.Enabled := False;
  BtnPrPage.Enabled := False;
  BtnNxPage.Enabled := False;
  BtnExec.Enabled := False;
  AConvetor := TuProjectConvetor.Create(FProject);
  try
    AConvetor.OnBeginWork := BeginWork;
    AConvetor.OnEndWork := EndWork;
    AConvetor.OnWorkState := WorkState;
    AConvetor.Options := [];
    __Inc(AConvetor, _Checked(_IO_Items), ioItems);
    __Inc(AConvetor, _Checked(_IO_Monster), ioMonster);
    __Inc(AConvetor, _Checked(_IO_Magic), ioMagic);
    __Inc(AConvetor, _Checked(_IO_MapInfo), ioMapInfo);
    __Inc(AConvetor, _Checked(_IO_MapEvent), ioMapEvent);
    __Inc(AConvetor, _Checked(_IO_MapQuest), ioMapQuest);
    __Inc(AConvetor, _Checked(_IO_Guard), ioGuard);
    __Inc(AConvetor, _Checked(_IO_Robot), ioRobot);
    __Inc(AConvetor, _Checked(_IO_Merchants), ioMerchants);
    __Inc(AConvetor, _Checked(_IO_Mogen), ioMogen);
    __Inc(AConvetor, _Checked(_IO_DropItems), ioDropItems);
    __Inc(AConvetor, _Checked(_IO_Script), ioScript);
    AConvetor.Convert(EditPath.Text);
  finally
    BtnClose.Enabled := True;
    AConvetor.Free;
  end;
end;

procedure TM2ImportFromOtherForm.BtnNxPageClick(Sender: TObject);
begin
  Inc(FPageIndex);
  if FPageIndex > 2 then
    FPageIndex := 2;
  SetPageIndex(FPageIndex);
end;

procedure TM2ImportFromOtherForm.BtnPrPageClick(Sender: TObject);
begin
  Dec(FPageIndex);
  if FPageIndex < 0 then
    FPageIndex := 0;
  SetPageIndex(FPageIndex);
end;

procedure TM2ImportFromOtherForm.EditPathPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  APath: String;
begin
  if FileCtrl.SelectDirectory('��ѡ����Դ�汾�ļ���', '', APath) then
    EditPath.Text := SysUtils.IncludeTrailingPathDelimiter(APath);
end;

class procedure TM2ImportFromOtherForm.Execute(AProject: TM2Project);
begin
  with TM2ImportFromOtherForm.Create(nil) do
  begin
    try
      FProject := AProject;
      Showmodal;
    finally
      Free;
    end;
  end;
end;

procedure TM2ImportFromOtherForm.FormCreate(Sender: TObject);

  procedure AddItem(ATag: Integer; const ACaption: String; AChecked: Boolean);
  begin
    with EditOptions.Items.Add do
    begin
      Text := ACaption;
      Tag := ATag;
      Checked := AChecked;
    end;
  end;

begin
  PageNoteBook.Properties.HideTabs := True;
  FPageIndex := 0;
  LabelWorking.Caption := '';
  SetPageIndex(FPageIndex);

  EditOptions.Clear;
  AddItem(_IO_Items, '������Ʒ���ݿ�', True);
  AddItem(_IO_Monster, '����������ݿ�', True);
  AddItem(_IO_Magic, '���뼼�����ݿ�', True);
  AddItem(_IO_MapInfo, '�����ͼ��Ϣ', True);
  AddItem(_IO_MapEvent, '�����¼���Ϣ', True);
  AddItem(_IO_MapQuest, '�����ͼɱ�ִ�����Ϣ(MapQuest.txt)', True);
  AddItem(_IO_Guard, '������ʿ��Ϣ', True);
  AddItem(_IO_Merchants, '����������Ϣ', True);
  AddItem(_IO_Robot, '�����������Ϣ', True);
  AddItem(_IO_Mogen, '����ˢ����Ϣ', True);
  AddItem(_IO_DropItems, '���뱬����Ϣ', True);
  AddItem(_IO_Script, '����ű�', True);
end;

procedure TM2ImportFromOtherForm.SetPageIndex(AIndex: Integer);
begin
  PageNoteBook.ActivePageIndex := AIndex;
  case AIndex of
    0:
    begin
      BtnPrPage.Enabled := False;
      BtnNxPage.Enabled := True;
      BtnExec.Enabled := False;
      LabTitle.Caption := '��ѡ����Դ�汾�����ļ��У���"D:\M2Server"��"D:\M2Server\Mir200\"�����ѡ����ļ����а���'+
                          'Mud2�ļ�����������н��Զ�������Ϸ���ݿ���Ϣ';
    end;
    1:
    begin
      BtnPrPage.Enabled := True;
      BtnNxPage.Enabled := True;
      BtnExec.Enabled := False;
      LabTitle.Caption := '��ѡ����汾���ѡ��';
    end;
    2:
    begin
      BtnPrPage.Enabled := True;
      BtnNxPage.Enabled := False;
      BtnExec.Enabled := True;
      LabTitle.Caption := '���"����"��ť��ʼ����汾�����ݰ汾�ĸ��ӳ̶�����ĵ����ʱ������ͬ';
    end;
  end;
end;

procedure TM2ImportFromOtherForm.BeginWork(const ATitle, AMessage: String);
begin
  LabelWorking.Caption := ATitle;
  with TreeWorking.Add do
  begin
    Values[0] := AMessage;
    MakeVisible;
  end;
  Application.ProcessMessages;
end;

procedure TM2ImportFromOtherForm.EndWork(const AMessage: String);
begin
  with TreeWorking.Add do
  begin
    Values[0] := AMessage;
    MakeVisible;
  end;
  //LabelWorking.Caption := AMessage;
  Application.ProcessMessages;
end;

procedure TM2ImportFromOtherForm.WorkState(const AMessage: String; APosition, AMax: Integer);
begin
  if AMessage <> '' then
  begin
    with TreeWorking.Add do
    begin
      Values[0] := AMessage;
      MakeVisible;
    end;
  end;
  ProgressBar.Properties.Max := AMax;
  ProgressBar.Position := APosition;
  Application.ProcessMessages;
end;

end.
