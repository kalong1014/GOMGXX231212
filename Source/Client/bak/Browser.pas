unit Browser;

interface

uses
  Windows, Messages, Classes, Controls, Forms,
  SHDocVw, StdCtrls, Buttons, ExtCtrls, SysUtils, OleCtrls;

type
  TfrmBrowser = class(TForm)
    NavPanel: TPanel;
    SpeedButton1: TSpeedButton;
    WebBrowser1: TWebBrowser;
    procedure SpeedButton1Click(Sender: TObject);
    procedure WebBrowser1NewWindow2(ASender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure WebBrowser1WindowClosing(ASender: TObject;
      IsChildWindow: WordBool; var Cancel: WordBool);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open(AParent : TForm; Web:string);
    procedure CreateParams(var Params:TCreateParams);override;//设置程序的类名 20080412
  end;

var
  frmBrowser: TfrmBrowser;
  sBrowser: string;

implementation

uses
  ClMain, MShare;

{$R *.dfm}

procedure TfrmBrowser.CreateParams(var Params: TCreateParams);
  function RandomGetPass():string;
  var
    s,s1:string;
    I,i0:Byte;
  begin
    s:='123456789ABCDEFGHIJKLMNPQRSTUVWXYZ';
    s1:='';
    Randomize(); //随机种子
    for i:=0 to 5 do begin
      i0:=random(35);
      s1:=s1+copy(s,i0,1);
    end;
    Result := s1;
  end;
begin
  inherited CreateParams(Params);
  sBrowser := RandomGetPass;
  strpcopy(pChar(@Params.WinClassName),sBrowser);
end;

procedure TfrmBrowser.FormCreate(Sender: TObject);
begin
  Top := 0;
  Left := 0;
  Height := g_FScreenHeight;
  Width := g_FScreenWidth;
  Windows.SetParent(Handle, FrmMain.Handle);
end;

procedure TfrmBrowser.Open(AParent : TForm; Web:string);
begin
//  Parent := AParent;
//  ParentWindow := AParent.Handle;
//  BoundsRect := Bounds(0,0,AParent.ClientWidth, AParent.ClientHeight);
  WebBrowser1.Navigate(WideString(Web));
  Show;
end;

procedure TfrmBrowser.SpeedButton1Click(Sender: TObject);
begin
  Close;
//  FrmDlg.DBackground.SetFocus;
end;

procedure TfrmBrowser.WebBrowser1NewWindow2(ASender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
var
  NewApp                    : TfrmBrowser;
begin
  NewApp := TfrmBrowser.Create(Self);
  NewApp.ParentWindow := frmBrowser.Handle;
  NewApp.Show;
  NewApp.SetFocus;
  ppDisp := NewApp.WebBrowser1.Application;
end;

procedure TfrmBrowser.WebBrowser1WindowClosing(ASender: TObject;
  IsChildWindow: WordBool; var Cancel: WordBool);
begin
  Cancel := True;
  Close;
end;

end.
