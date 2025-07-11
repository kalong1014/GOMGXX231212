unit M2ImageInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, Buttons, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Menus, cxButtons,
  cxGroupBox, cxRadioGroup, cxTextEdit, dxSkinsCore, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
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
  TuFrmImgInput = class(TForm)
    cxGroupBox1: TcxGroupBox;
    EditX: TcxTextEdit;
    EditY: TcxTextEdit;
    RzLabel1: TLabel;
    RzLabel2: TLabel;
    cxRadioGroup1: TcxRadioGroup;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetImageInput(var X, Y: Integer; var _Type: Integer): Boolean;

implementation

{$R *.dfm}

function GetImageInput(var X, Y: Integer; var _Type: Integer): Boolean;
begin
  with TuFrmImgInput.Create(nil) do
    try
      EditX.Text  :=  IntToStr(X);
      EditY.Text  :=  IntToStr(Y);
      Result  :=  ShowModal = mrOk;
      if Result then
      begin
        X     :=  StrToIntDef(EditX.Text, 0);
        Y     :=  StrToIntDef(EditY.Text, 0);
        _Type :=  cxRadioGroup1.ItemIndex;
      end;
    finally
      Free;
    end;
end;

end.
