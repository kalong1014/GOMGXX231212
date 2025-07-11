unit M2DataEncFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Menus, StdCtrls, cxButtons, cxTextEdit;

type
  TDataEncForm = class(TForm)
    EditPwd: TcxTextEdit;
    LabelCaption: TLabel;
    BtnOK: TcxButton;
    BtnCancel: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetDataPassword(const ACaption: String; var Password: String): Boolean;

implementation

{$R *.dfm}

function GetDataPassword(const ACaption: String; var Password: String): Boolean;
begin
  with TDataEncForm.Create(nil) do
    try
      LabelCaption.Caption := ACaption;
      Result := ShowModal = mrOK;
      Password := EditPwd.Text;
    finally
      Free;
    end;
end;

end.
