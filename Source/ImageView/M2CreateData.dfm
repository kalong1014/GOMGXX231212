object uFrmCreateData: TuFrmCreateData
  Left = 1077
  Top = 196
  BorderStyle = bsDialog
  Caption = #26032#24314
  ClientHeight = 110
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object RadioGroup: TcxRadioGroup
    Left = 8
    Top = 8
    Caption = #31867#22411
    Properties.Items = <
      item
        Caption = '.Data('#32593#32476#36164#28304#26684#24335')'
        Value = 0
      end
      item
        Caption = '.Wzl('#26032#26684#24335')'
        Value = 1
      end>
    ItemIndex = 0
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 0
    Height = 65
    Width = 255
  end
  object cxButton1: TcxButton
    Left = 108
    Top = 79
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    ModalResult = 1
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 189
    Top = 79
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    ModalResult = 2
    TabOrder = 2
  end
end
