object UpdateItemEditor: TUpdateItemEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #26356#26032#39033#32534#36753
  ClientHeight = 258
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object cxHyperLinkEdit1: TcxHyperLinkEdit
    Left = 80
    Top = 18
    Properties.OnChange = cxHyperLinkEdit1PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 0
    Width = 331
  end
  object cxTextEdit1: TcxTextEdit
    Left = 80
    Top = 45
    Properties.OnChange = cxTextEdit1PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 1
    Width = 331
  end
  object cxButtonEdit1: TcxButtonEdit
    Left = 80
    Top = 72
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.OnButtonClick = cxButtonEdit1PropertiesButtonClick
    Properties.OnChange = cxButtonEdit1PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 2
    Width = 331
  end
  object cxTextEdit2: TcxTextEdit
    Left = 80
    Top = 99
    Properties.OnChange = cxTextEdit2PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 3
    Width = 331
  end
  object cxComboBox1: TcxComboBox
    Left = 80
    Top = 126
    Properties.DropDownListStyle = lsFixedList
    Properties.Items.Strings = (
      'HTTP'
      #30334#24230#32593#30424
      '360'#32593#30424
      'FTP'
      #30334#24230#30456#20876)
    Properties.OnChange = cxComboBox1PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 4
    Width = 331
  end
  object cxCheckBox1: TcxCheckBox
    Left = 9
    Top = 180
    AutoSize = False
    Caption = #26159#21542#21387#32553
    Properties.Alignment = taRightJustify
    Properties.OnChange = cxCheckBox1PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 5
    Height = 21
    Width = 88
  end
  object cxLabel1: TcxLabel
    Left = 11
    Top = 20
    AutoSize = False
    Caption = #19979#36733#22320#22336
    Height = 17
    Width = 52
  end
  object cxLabel2: TcxLabel
    Left = 11
    Top = 47
    AutoSize = False
    Caption = #23433#35013#36335#24452
    Height = 17
    Width = 52
  end
  object cxLabel3: TcxLabel
    Left = 11
    Top = 74
    AutoSize = False
    Caption = #25991#20214#21517#31216
    Height = 17
    Width = 52
  end
  object cxLabel4: TcxLabel
    Left = 11
    Top = 101
    AutoSize = False
    Caption = 'MD5'#32534#30721
    Height = 17
    Width = 49
  end
  object cxLabel5: TcxLabel
    Left = 11
    Top = 128
    AutoSize = False
    Caption = #19979#36733#26041#24335
    Height = 17
    Width = 52
  end
  object cxButton1: TcxButton
    Left = 255
    Top = 225
    Width = 75
    Height = 25
    Caption = #24212#29992
    Default = True
    Enabled = False
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    ModalResult = 1
    TabOrder = 11
  end
  object cxButton2: TcxButton
    Left = 336
    Top = 225
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    ModalResult = 2
    TabOrder = 12
  end
  object cxCheckBox2: TcxCheckBox
    Left = 9
    Top = 203
    AutoSize = False
    Caption = #26159#21542#26377#25928
    Properties.Alignment = taRightJustify
    Properties.OnChange = cxCheckBox2PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 13
    Height = 21
    Width = 88
  end
  object cxComboBox2: TcxComboBox
    Left = 80
    Top = 153
    Properties.DropDownListStyle = lsFixedList
    Properties.Items.Strings = (
      #24517#35201#26356#26032#65288#26356#26032#23436#25104#25165#21487#36827#20837#28216#25103#65289
      #21518#21488#26356#26032#65288#24517#35201#26356#26032#23436#25104#21518#24320#22987#26356#26032#65292#21487#36793#28216#25103#36793#26356#26032#65289
      #38656#35201#26102#26356#26032#65288#23458#25143#31471#38656#35201#20351#29992#26102#20877#26356#26032#65289)
    Properties.OnChange = cxComboBox2PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 14
    Width = 331
  end
  object cxLabel6: TcxLabel
    Left = 11
    Top = 155
    AutoSize = False
    Caption = #26356#26032#20248#20808#32423
    Height = 17
    Width = 63
  end
end
