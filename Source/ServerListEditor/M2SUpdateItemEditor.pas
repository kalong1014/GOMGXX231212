unit M2SUpdateItemEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxLabel, cxCheckBox, cxDropDownEdit, cxMaskEdit,
  cxButtonEdit, cxTextEdit, cxHyperLinkEdit, Menus, StdCtrls, cxButtons,
  uServerList;

type
  TUpdateItemEditor = class(TForm)
    cxHyperLinkEdit1: TcxHyperLinkEdit;
    cxTextEdit1: TcxTextEdit;
    cxButtonEdit1: TcxButtonEdit;
    cxTextEdit2: TcxTextEdit;
    cxComboBox1: TcxComboBox;
    cxCheckBox1: TcxCheckBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxCheckBox2: TcxCheckBox;
    cxComboBox2: TcxComboBox;
    cxLabel6: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cxHyperLinkEdit1PropertiesChange(Sender: TObject);
    procedure cxTextEdit1PropertiesChange(Sender: TObject);
    procedure cxButtonEdit1PropertiesChange(Sender: TObject);
    procedure cxTextEdit2PropertiesChange(Sender: TObject);
    procedure cxComboBox1PropertiesChange(Sender: TObject);
    procedure cxCheckBox1PropertiesChange(Sender: TObject);
    procedure cxCheckBox2PropertiesChange(Sender: TObject);
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxComboBox2PropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FTemp:  TUpdateItem;
    procedure Load(Source: TUpdateItem);
  public
    { Public declarations }
  end;

  function EditUpdateItem(Item: TUpdateItem): Boolean;

implementation
  uses uMD5;

{$R *.dfm}

function EditUpdateItem(Item: TUpdateItem): Boolean;
begin
  with TUpdateItemEditor.Create(nil) do
    try
      Load(Item);
      Result  :=  ShowModal = mrOK;
      if Result then
        Item.Assign(FTemp);
    finally
      Free;
    end;
end;

procedure TUpdateItemEditor.cxButtonEdit1PropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  with TOpenDialog.Create(nil) do
    try
      if Execute then
      begin
        cxButtonEdit1.Text  :=  ExtractFileName(FileName);
        cxTextEdit2.Text    :=  uMD5.MD5File(FileName);;
      end;
    finally
      Free;
    end;
end;

procedure TUpdateItemEditor.cxButtonEdit1PropertiesChange(Sender: TObject);
begin
  cxButton1.Enabled :=  True;
  FTemp.FileName  :=  cxButtonEdit1.Text;
end;

procedure TUpdateItemEditor.cxCheckBox1PropertiesChange(Sender: TObject);
begin
  cxButton1.Enabled :=  True;
  FTemp.Zip  :=  cxCheckBox1.Checked;
end;

procedure TUpdateItemEditor.cxCheckBox2PropertiesChange(Sender: TObject);
begin
  cxButton1.Enabled :=  True;
  FTemp.Enable  :=  cxCheckBox2.Checked;
end;

procedure TUpdateItemEditor.cxComboBox1PropertiesChange(Sender: TObject);
begin
  cxButton1.Enabled :=  True;
  FTemp.DownKind  :=  TupDownKind(cxComboBox1.ItemIndex);
end;

procedure TUpdateItemEditor.cxComboBox2PropertiesChange(Sender: TObject);
begin
  cxButton1.Enabled :=  True;
  FTemp.DownType  :=  TutDownType(cxComboBox2.ItemIndex);
end;

procedure TUpdateItemEditor.cxHyperLinkEdit1PropertiesChange(Sender: TObject);
begin
  FTemp.Url :=  cxHyperLinkEdit1.Text;
  cxButton1.Enabled :=  True;
end;

procedure TUpdateItemEditor.cxTextEdit1PropertiesChange(Sender: TObject);
begin
  cxButton1.Enabled :=  True;
  FTemp.Path  :=  cxTextEdit1.Text;
end;

procedure TUpdateItemEditor.cxTextEdit2PropertiesChange(Sender: TObject);
begin
  cxButton1.Enabled :=  True;
  FTemp.Code  :=  cxTextEdit2.Text;
end;

procedure TUpdateItemEditor.FormCreate(Sender: TObject);
begin
  FTemp :=  TUpdateItem.Create(nil);
end;

procedure TUpdateItemEditor.FormDestroy(Sender: TObject);
begin
  FTemp.Free;
end;

procedure TUpdateItemEditor.Load(Source: TUpdateItem);
begin
  FTemp.Assign(Source);
  cxHyperLinkEdit1.Text :=  FTemp.Url;
  cxTextEdit1.Text :=  FTemp.Path;
  cxButtonEdit1.Text :=  FTemp.FileName;
  cxTextEdit2.Text :=  FTemp.Code;
  cxComboBox1.ItemIndex :=  Ord(FTemp.DownKind);
  cxCheckBox1.Checked :=  FTemp.Zip;
  cxCheckBox2.Checked :=  FTemp.Enable;
  cxComboBox2.ItemIndex := Ord(FTemp.DownType);
end;

end.
