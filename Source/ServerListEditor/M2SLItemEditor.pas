unit M2SLItemEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxSpinEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxLabel, Menus, StdCtrls, cxButtons, uServerList, cxCheckBox, uEDCode,
  dxSkinsCore, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light;

type
  TServerItemEditor = class(TForm)
    cxComboBox1: TcxComboBox;
    cxTextEdit1: TcxTextEdit;
    cxTextEdit2: TcxTextEdit;
    cxTextEdit3: TcxTextEdit;
    cxTextEdit4: TcxTextEdit;
    cxSpinEdit1: TcxSpinEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxCheckBox1: TcxCheckBox;
    cxLabel7: TcxLabel;
    cxSpinEdit2: TcxSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cxComboBox1PropertiesChange(Sender: TObject);
    procedure cxTextEdit1PropertiesChange(Sender: TObject);
    procedure cxTextEdit2PropertiesChange(Sender: TObject);
    procedure cxTextEdit3PropertiesChange(Sender: TObject);
    procedure cxSpinEdit1PropertiesChange(Sender: TObject);
    procedure cxTextEdit4PropertiesChange(Sender: TObject);
    procedure cxCheckBox1PropertiesChange(Sender: TObject);
    procedure cxSpinEdit2PropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FTemp: TServerItem;
    InLoad: Boolean;
    procedure Load(AServerInfo: TServerInfo; Item: TServerItem);
  public
    { Public declarations }
  end;

  function EditServer(AServerInfo: TServerInfo; Item: TServerItem): Boolean;

implementation

{$R *.dfm}

function EditServer(AServerInfo: TServerInfo; Item: TServerItem): Boolean;
begin
  with TServerItemEditor.Create(nil) do
    try
      Load(AServerInfo, Item);
      Result  :=  ShowModal = mrOK;
      if Result then
        Item.Assign(FTemp);
    finally
      Free;
    end;
end;

{ TServerItemEditor }

procedure TServerItemEditor.cxCheckBox1PropertiesChange(Sender: TObject);
begin
  if InLoad then Exit;
  FTemp.Enable  :=  cxCheckBox1.Checked;
  cxButton1.Enabled :=  True;
end;

procedure TServerItemEditor.cxComboBox1PropertiesChange(Sender: TObject);
begin
  if InLoad then Exit;
  FTemp.GroupName :=  cxComboBox1.Text;
  cxButton1.Enabled :=  True;
end;

procedure TServerItemEditor.cxSpinEdit1PropertiesChange(Sender: TObject);
begin
  if InLoad then Exit;
  FTemp.Port  :=  cxSpinEdit1.Value;
  cxButton1.Enabled :=  True;
end;

procedure TServerItemEditor.cxSpinEdit2PropertiesChange(Sender: TObject);
begin
  if InLoad then Exit;
  FTemp.ImageIndex  :=  cxSpinEdit2.Value;
  cxButton1.Enabled :=  True;
end;

procedure TServerItemEditor.cxTextEdit1PropertiesChange(Sender: TObject);
begin
  if InLoad then Exit;
  FTemp.ServerName  :=  cxTextEdit1.Text;
  cxButton1.Enabled :=  True;
end;

procedure TServerItemEditor.cxTextEdit2PropertiesChange(Sender: TObject);
begin
  if InLoad then Exit;
  FTemp.DisplayName  :=  cxTextEdit2.Text;
  cxButton1.Enabled :=  True;
end;

procedure TServerItemEditor.cxTextEdit3PropertiesChange(Sender: TObject);
begin
  if InLoad then Exit;
  FTemp.Host  :=  cxTextEdit3.Text;
  cxButton1.Enabled :=  True;
end;

procedure TServerItemEditor.cxTextEdit4PropertiesChange(Sender: TObject);
begin
  if InLoad then Exit;

  FTemp.Key  :=  uEDCode.EncodeSource(cxTextEdit4.Text);
  cxButton1.Enabled :=  True;
end;

procedure TServerItemEditor.FormCreate(Sender: TObject);
begin
  FTemp :=  TServerItem.Create(nil);
end;

procedure TServerItemEditor.FormDestroy(Sender: TObject);
begin
  FTemp.Free;
end;

procedure TServerItemEditor.Load(AServerInfo: TServerInfo; Item: TServerItem);
var
  I: Integer;
begin
  InLoad := True;
  try
    FTemp.Assign(Item);
    for I := 0 to AServerInfo.ServerList.Count - 1 do
      if cxComboBox1.Properties.Items.IndexOf(AServerInfo.ServerList.Items[I].GroupName)=-1 then
        cxComboBox1.Properties.Items.Add(AServerInfo.ServerList.Items[I].GroupName);
    cxComboBox1.Text  :=  FTemp.GroupName;
    cxTextEdit1.Text  :=  FTemp.ServerName;
    cxTextEdit2.Text  :=  FTemp.DisplayName;
    cxTextEdit3.Text  :=  FTemp.Host;
    cxSpinEdit1.Value :=  FTemp.Port;
    cxTextEdit4.Text  :=  uEDCode.DecodeSource(FTemp.Key);
    cxSpinEdit2.Value :=  FTemp.ImageIndex;
    cxCheckBox1.Checked :=  FTemp.Enable;
  finally
    InLoad := False;
  end;
end;

end.
