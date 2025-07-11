unit M2SecurityFileEditorFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uServerList, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, Menus, StdCtrls,
  cxButtons, cxTextEdit, cxGroupBox;

type
  TM2SecurityFileEditorForm = class(TForm)
    cxGroupBox1: TcxGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditFileName: TcxTextEdit;
    EditPassword: TcxTextEdit;
    BtnOK: TcxButton;
    BtnCancel: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
    class function EditFile(Item: TSecurityFile): Boolean;
  end;

implementation

{$R *.dfm}

{ TM2SecurityFileEditorForm }

class function TM2SecurityFileEditorForm.EditFile(Item: TSecurityFile): Boolean;
begin
  Result := False;
  with TM2SecurityFileEditorForm.Create(nil) do
  begin
    try
      EditFileName.Text := Item.FileName;
      EditPassword.Text := Item.Password;
      if ShowModal = mrOK then
      begin
        Item.FileName := EditFileName.Text;
        Item.Password := EditPassword.Text;
        Result := True;
      end;
    finally
      Free;
    end;
  end;
end;

end.
