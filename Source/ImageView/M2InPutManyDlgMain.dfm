object uFrmInputMany: TuFrmInputMany
  Left = 796
  Top = 291
  BorderStyle = bsDialog
  Caption = #25209#37327#23548#20837#22270#29255
  ClientHeight = 363
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object RzLabel: TLabel
    Left = 8
    Top = 66
    Width = 54
    Height = 12
    Caption = #22270#29255#20301#32622':'
    Transparent = False
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 346
    Width = 417
    Height = 17
    Align = alBottom
    TabOrder = 7
  end
  object RadioGroup1: TcxRadioGroup
    Left = 8
    Top = 8
    Caption = #23548#20837#20869#23481
    Properties.Columns = 4
    Properties.Items = <
      item
        Caption = #22270#29255#21644#22352#26631
      end
      item
        Caption = #22270#29255
      end
      item
        Caption = #22352#26631
      end
      item
        Caption = #31354#22270#29255
      end>
    Properties.OnChange = RadioGroup1PropertiesChange
    ItemIndex = 0
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 0
    Height = 49
    Width = 401
  end
  object EditFileDir: TcxButtonEdit
    Left = 68
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.OnButtonClick = EditFileDirPropertiesButtonClick
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 1
    Text = 'C:\Users\Administrator\Desktop\123'
    Width = 341
  end
  object GroupBox2: TcxGroupBox
    Left = 8
    Top = 89
    Caption = #22270#29255#32034#24341#21495
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 2
    Height = 73
    Width = 209
    object RzLabel1: TLabel
      Left = 8
      Top = 20
      Width = 54
      Height = 12
      Caption = #36215#22987#32534#21495':'
      Transparent = False
    end
    object RzLabel2: TLabel
      Left = 8
      Top = 46
      Width = 54
      Height = 12
      Caption = #32467#26463#32534#21495':'
      Transparent = False
    end
    object EditX: TcxTextEdit
      Left = 68
      Top = 16
      Properties.Alignment.Horz = taRightJustify
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 0
      Text = '0'
      Width = 101
    end
    object EditY: TcxTextEdit
      Left = 68
      Top = 42
      Properties.Alignment.Horz = taRightJustify
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 1
      Text = '0'
      Width = 101
    end
  end
  object RadioGroup3: TcxRadioGroup
    Left = 229
    Top = 89
    Caption = #23548#20837#26041#24335
    Properties.Items = <
      item
        Caption = #20174#26411#23614#28155#21152
      end
      item
        Caption = #25353#32534#21495#25554#20837
      end
      item
        Caption = #25353#32534#21495#35206#30422
      end>
    Properties.OnChange = RadioGroup3PropertiesChange
    ItemIndex = 0
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 3
    Height = 73
    Width = 180
  end
  object GroupBox4: TcxGroupBox
    Left = 8
    Top = 168
    Caption = #22352#26631#33719#24471#26041#24335
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 4
    Height = 49
    Width = 401
    object RadioButton1: TcxRadioButton
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Caption = #21516#21517#22352#26631#25991#20214
      Checked = True
      TabOrder = 0
      TabStop = True
      LookAndFeel.Kind = lfFlat
    end
    object RadioButton2: TcxRadioButton
      Left = 173
      Top = 16
      Width = 113
      Height = 17
      Caption = #30456#21516#22352#26631
      TabOrder = 1
      LookAndFeel.Kind = lfFlat
    end
    object EditXY: TcxTextEdit
      Left = 245
      Top = 16
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 2
      Text = '0,0'
      Width = 121
    end
  end
  object BitBtnOK: TcxButton
    Left = 253
    Top = 312
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    TabOrder = 5
    OnClick = BitBtnOKClick
  end
  object BitBtnClose: TcxButton
    Left = 334
    Top = 312
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    TabOrder = 6
    OnClick = BitBtnCloseClick
  end
  object GroupBoxAtt: TGroupBox
    Left = 8
    Top = 223
    Width = 401
    Height = 83
    Caption = #38468#21152
    TabOrder = 8
    object CheckBoxEmpty1X1: TCheckBox
      Left = 8
      Top = 24
      Width = 377
      Height = 25
      Caption = '1X1'#23610#23544#40657#24213#22270#29255#20197#31354#22270#29255#22788#29702#65288#20854#20182#24037#20855#21487#33021#20250#23558#31354#22270#23548#20986#20026'1X1'#23610#23544#30340#40657#24213#22270#29255#65289
      Checked = True
      State = cbChecked
      TabOrder = 0
      WordWrap = True
    end
    object CheckBoxInputEmpty: TCheckBox
      Left = 8
      Top = 56
      Width = 329
      Height = 17
      Caption = #27599#38548'            '#24352#22270#25554#20837'            '#24352#31354#22270
      TabOrder = 1
    end
    object EditSkipNum: TcxSpinEdit
      Left = 56
      Top = 54
      TabOrder = 2
      Width = 57
    end
    object EditAddNum: TcxSpinEdit
      Left = 176
      Top = 54
      TabOrder = 3
      Width = 57
    end
  end
end
