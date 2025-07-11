object uFrmDelImages: TuFrmDelImages
  Left = 860
  Top = 345
  BorderStyle = bsDialog
  Caption = #21024#38500#22270#29255
  ClientHeight = 143
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 12
  object ProgressBar: TProgressBar
    Left = 0
    Top = 126
    Width = 409
    Height = 17
    Align = alBottom
    TabOrder = 3
  end
  object cxGroupBox1: TcxGroupBox
    Left = 8
    Top = 8
    Caption = #22270#29255#32534#21495
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 0
    Height = 82
    Width = 201
    object RzLabel1: TLabel
      Left = 8
      Top = 28
      Width = 54
      Height = 12
      Caption = #36215#22987#32534#21495':'
      Transparent = False
    end
    object RzLabel2: TLabel
      Left = 8
      Top = 54
      Width = 54
      Height = 12
      Caption = #32467#26463#32534#21495':'
      Transparent = False
    end
    object EditX: TcxTextEdit
      Left = 68
      Top = 24
      Properties.Alignment.Horz = taRightJustify
      Style.BorderStyle = ebsFlat
      TabOrder = 0
      Text = '0'
      Width = 121
    end
    object EditY: TcxTextEdit
      Left = 68
      Top = 50
      Properties.Alignment.Horz = taRightJustify
      Style.BorderStyle = ebsFlat
      TabOrder = 1
      Text = '0'
      Width = 121
    end
  end
  object RadioGroup: TcxRadioGroup
    Left = 215
    Top = 8
    Caption = #21024#38500#26041#24335
    Properties.Items = <
      item
        Caption = #24443#22320#21024#38500
        Value = 0
      end
      item
        Caption = #31354#22270#29255#26367#25442
        Value = 1
      end>
    ItemIndex = 0
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 1
    Height = 82
    Width = 185
  end
  object BitBtnOK: TcxButton
    Left = 244
    Top = 96
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    TabOrder = 2
    OnClick = BitBtnOKClick
  end
  object BitBtnClose: TcxButton
    Left = 325
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    TabOrder = 4
    OnClick = BitBtnCloseClick
  end
end
