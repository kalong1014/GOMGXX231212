unit M2Validate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Menus, StdCtrls, cxButtons, cxLabel, cxTextEdit,
  dxSkinsCore, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TFRMVerValidate = class(TForm)
    cxTextEdit1: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetPassWord(out Pass: String; const ACaption: String=''): boolean;
  function GetText(out Value: String; const ACaption: String=''): boolean;

implementation

{$R *.dfm}

function GetPassWord(out Pass: String; const ACaption: String): boolean;
begin
  with TFRMVerValidate.Create(nil) do
    try
      if ACaption<>'' then
        cxLabel1.Caption  :=  ACaption;
      Result  :=  ShowModal = mrOK;
      Pass    :=  cxTextEdit1.Text;
    finally
      Free;
    end;
end;

function GetText(out Value: String; const ACaption: String=''): boolean;
begin
  with TFRMVerValidate.Create(nil) do
    try
      if ACaption<>'' then
        cxLabel1.Caption  :=  ACaption;
      cxTextEdit1.Properties.EchoMode := eemNormal;
      cxTextEdit1.Properties.PasswordChar := #0;
      Result  :=  ShowModal = mrOK;
      Value   :=  cxTextEdit1.Text;
    finally
      Free;
    end;
end;

end.
