unit M2LoginServerList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles;

type
  TfrmLoginSrvList = class(TForm)
    lbl_FirstURL: TLabel;
    lbl_SecondURL: TLabel;
    lbl_ThridURL: TLabel;
    edt_First: TEdit;
    edt_Second: TEdit;
    edt_ThridURL: TEdit;
    btn_OK: TButton;
  private
    { Private declarations }
    procedure LoadConfig;
    procedure SaveConfig;
  public
    { Public declarations }
  end;

var
  frmLoginSrvList: TfrmLoginSrvList;

function GetList(out List: string): boolean;

implementation


procedure TfrmLoginSrvList.LoadConfig;
var
  I: Integer;
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'LoginEditor.ini');
  edt_First.Text := IniFile.ReadString('Config', 'GameList1', edt_First.Text);
  edt_Second.Text := IniFile.ReadString('Config', 'GameList2', edt_Second.Text);
  edt_ThridURL.Text := IniFile.ReadString('Config', 'GameList3', edt_ThridURL.Text);
  IniFile.WriteString('Config', 'GameList1', edt_First.Text);
  IniFile.WriteString('Config', 'GameList2', edt_Second.Text);
  IniFile.WriteString('Config', 'GameList3', edt_ThridURL.Text);
  IniFile.Free;
end;

procedure TfrmLoginSrvList.SaveConfig;
var
  I: Integer;
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'LoginEditor.ini');
  IniFile.WriteString('Config', 'GameList1', edt_First.Text);
  IniFile.WriteString('Config', 'GameList2', edt_Second.Text);
  IniFile.WriteString('Config', 'GameList3', edt_ThridURL.Text);
  IniFile.Free;
end;

{$R *.dfm}
function GetList(out List: String): boolean;
begin
  List := '';
  with TfrmLoginSrvList.Create(nil) do
    try
      LoadConfig;
      Result  := ShowModal = mrOK;
      if Result then
      begin
        SaveConfig;
        List := edt_First.Text + #13#10 + edt_Second.Text +#13#10 + edt_ThridURL.Text;
      end;
    finally
      Free;
    end;
end;
end.
