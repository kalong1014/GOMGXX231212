unit MergeFile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzShellDialogs, Mask, RzEdit, RzBtnEdt;

type
  TfrmMerge = class(TForm)
    edt_Dir: TRzButtonEdit;
    edt_TargetFile: TRzButtonEdit;
    SelDirDlg1: TRzSelectFolderDialog;
    lbl1: TLabel;
    lbl2: TLabel;
    btn_Save: TButton;
    procedure edt_DirButtonClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMerge: TfrmMerge;

implementation
uses WzlMerge;

{$R *.dfm}

procedure TfrmMerge.btn_SaveClick(Sender: TObject);
var
  Merge : TWzlMerge;
  List : TList;
begin
  Try
    Merge := TWzlMerge.Create(edt_Dir.Text + '\');
    Merge.SaveToDir(edt_TargetFile.Text + '\',nil);
  Finally
    Merge.Free;
  End;

end;

procedure TfrmMerge.edt_DirButtonClick(Sender: TObject);
begin
  if SelDirDlg1.Execute then
  begin
    if Sender = edt_Dir then
    begin
      edt_Dir.Text := SelDirDlg1.SelectedPathName;
    end else
    begin
      edt_TargetFile.Text := SelDirDlg1.SelectedPathName;
    end;
  end;
end;

end.
