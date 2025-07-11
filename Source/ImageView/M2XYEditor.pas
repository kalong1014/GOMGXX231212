unit M2XYEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, Buttons, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus,
  cxButtons, Spin;

type
  TuFrmXYEditor = class(TForm)
    RzGroupBox1: TGroupBox;
    RzLabel1: TLabel;
    RzLabel2: TLabel;
    EditY: TcxTextEdit;
    EditX: TcxTextEdit;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    rg_XYEditor: TRadioGroup;
    grp_ImageNumber: TGroupBox;
    se_Start: TSpinEdit;
    se_End: TSpinEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure rg_XYEditorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetMaxImageIndex(nCount : Integer);
    procedure SetImageNumberEnable(bo:Boolean);
  end;

implementation

{$R *.dfm}

procedure TuFrmXYEditor.FormShow(Sender: TObject);
begin
  rg_XYEditor.ItemIndex := 0;
end;

procedure TuFrmXYEditor.rg_XYEditorClick(Sender: TObject);
begin
  case rg_XYEditor.ItemIndex of
    0:
    begin
      SetImageNumberEnable(False);
    end;
    1:
    begin
      SetImageNumberEnable(True);
    end;
    2:
    begin
      SetImageNumberEnable(True);
    end;
  end;
end;

procedure TuFrmXYEditor.SetImageNumberEnable(bo: Boolean);
begin
  lbl1.Enabled := bo;
  lbl2.Enabled := bo;
  se_Start.Enabled := bo;
  se_End.Enabled := bo;
end;

procedure TuFrmXYEditor.SetMaxImageIndex(nCount: Integer);
begin
  se_End.MaxValue := nCount;
  se_Start.MaxValue := nCount;
end;

end.
