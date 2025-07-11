object uFrmImgInput: TuFrmImgInput
  Left = 682
  Top = 368
  BorderStyle = bsDialog
  Caption = #22270#29255#23548#20837
  ClientHeight = 135
  ClientWidth = 332
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
  object cxGroupBox1: TcxGroupBox
    Left = 8
    Top = 8
    Caption = #22352#26631
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 0
    Height = 89
    Width = 161
    object RzLabel1: TLabel
      Left = 8
      Top = 28
      Width = 12
      Height = 12
      Caption = 'X:'
      Transparent = False
    end
    object RzLabel2: TLabel
      Left = 8
      Top = 54
      Width = 12
      Height = 12
      Caption = 'Y:'
      Transparent = False
    end
    object EditX: TcxTextEdit
      Left = 26
      Top = 24
      Properties.Alignment.Horz = taRightJustify
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 0
      Text = '0'
      Width = 121
    end
    object EditY: TcxTextEdit
      Left = 26
      Top = 50
      Properties.Alignment.Horz = taRightJustify
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 1
      Text = '0'
      Width = 121
    end
  end
  object cxRadioGroup1: TcxRadioGroup
    Left = 175
    Top = 8
    Caption = #23548#20837#26041#24335
    Properties.Items = <
      item
        Caption = #35206#30422#22270#29255
        Value = 0
      end
      item
        Caption = #25554#20837#22270#29255
        Value = 1
      end
      item
        Caption = #28155#21152#21040#26411#23614
        Value = 2
      end>
    ItemIndex = 2
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 1
    Height = 89
    Width = 146
  end
  object cxButton1: TcxButton
    Left = 165
    Top = 103
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    ModalResult = 1
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 246
    Top = 103
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    ModalResult = 2
    TabOrder = 3
  end
end
