object ServerItemEditor: TServerItemEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20998#21306#32534#36753
  ClientHeight = 255
  ClientWidth = 409
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
  object cxComboBox1: TcxComboBox
    Left = 91
    Top = 16
    Properties.OnChange = cxComboBox1PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 0
    Text = 'cxComboBox1'
    Width = 306
  end
  object cxTextEdit1: TcxTextEdit
    Left = 91
    Top = 43
    Properties.OnChange = cxTextEdit1PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 1
    Text = 'cxTextEdit1'
    Width = 306
  end
  object cxTextEdit2: TcxTextEdit
    Left = 91
    Top = 70
    Properties.OnChange = cxTextEdit2PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 2
    Text = 'cxTextEdit2'
    Width = 306
  end
  object cxTextEdit3: TcxTextEdit
    Left = 91
    Top = 97
    Properties.OnChange = cxTextEdit3PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 3
    Text = 'cxTextEdit3'
    Width = 306
  end
  object cxTextEdit4: TcxTextEdit
    Left = 91
    Top = 151
    Properties.EchoMode = eemPassword
    Properties.MaxLength = 16
    Properties.PasswordChar = '*'
    Properties.OnChange = cxTextEdit4PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 5
    Text = 'cxTextEdit4'
    Width = 306
  end
  object cxSpinEdit1: TcxSpinEdit
    Left = 91
    Top = 124
    Properties.MaxValue = 65535.000000000000000000
    Properties.OnChange = cxSpinEdit1PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 4
    Width = 306
  end
  object cxLabel1: TcxLabel
    Left = 56
    Top = 17
    Caption = #20998#32452
  end
  object cxLabel2: TcxLabel
    Left = 32
    Top = 44
    Caption = #20998#21306#21517#31216
  end
  object cxLabel3: TcxLabel
    Left = 32
    Top = 71
    Caption = #26174#31034#21517#31216
  end
  object cxLabel4: TcxLabel
    Left = 42
    Top = 98
    Caption = 'IP/'#22495#21517
  end
  object cxLabel5: TcxLabel
    Left = 56
    Top = 125
    Caption = #31471#21475
  end
  object cxLabel6: TcxLabel
    Left = 32
    Top = 152
    Caption = #23553#21253#23494#30721
  end
  object cxButton1: TcxButton
    Left = 241
    Top = 221
    Width = 75
    Height = 25
    Caption = #24212#29992
    Default = True
    Enabled = False
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    ModalResult = 1
    TabOrder = 7
  end
  object cxButton2: TcxButton
    Left = 322
    Top = 221
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    ModalResult = 2
    TabOrder = 8
  end
  object cxCheckBox1: TcxCheckBox
    Left = 24
    Top = 204
    Caption = '  '#26159#21542#26377#25928
    Properties.Alignment = taRightJustify
    Properties.OnChange = cxCheckBox1PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 6
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 180
    Caption = #33410#28857#22270#29255#24207#21495
  end
  object cxSpinEdit2: TcxSpinEdit
    Left = 91
    Top = 178
    Properties.MaxValue = 255.000000000000000000
    Properties.MinValue = -1.000000000000000000
    Properties.Nullstring = '-1'
    Properties.OnChange = cxSpinEdit2PropertiesChange
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 16
    Width = 306
  end
end
