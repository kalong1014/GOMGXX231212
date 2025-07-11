object uFrmExport: TuFrmExport
  Left = 739
  Top = 312
  BorderStyle = bsDialog
  Caption = #25209#37327#23548#20986#22270#29255
  ClientHeight = 176
  ClientWidth = 369
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
  object RzLabel: TLabel
    Left = 8
    Top = 10
    Width = 66
    Height = 12
    Caption = #22270#29255#25991#20214#22841':'
    Transparent = False
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 159
    Width = 369
    Height = 17
    Align = alBottom
    TabOrder = 0
  end
  object EditFileDir: TcxButtonEdit
    Left = 80
    Top = 6
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
    Width = 281
  end
  object cxGroupBox1: TcxGroupBox
    Left = 8
    Top = 39
    Caption = #22270#29255#32534#21495
    Style.BorderStyle = ebsFlat
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 2
    Height = 82
    Width = 353
    object RzLabel1: TLabel
      Left = 8
      Top = 24
      Width = 54
      Height = 12
      Caption = #36215#22987#32534#21495':'
      Transparent = False
    end
    object RzLabel2: TLabel
      Left = 8
      Top = 48
      Width = 54
      Height = 12
      Caption = #32467#26463#32534#21495':'
      Transparent = False
    end
    object EditX: TcxTextEdit
      Left = 72
      Top = 21
      Properties.Alignment.Horz = taRightJustify
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 0
      Text = '0'
      Width = 265
    end
    object EditY: TcxTextEdit
      Left = 72
      Top = 47
      Properties.Alignment.Horz = taRightJustify
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 1
      Text = '0'
      Width = 265
    end
  end
  object BitBtnOK: TcxButton
    Left = 205
    Top = 127
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    TabOrder = 3
    OnClick = BitBtnOKClick
  end
  object BitBtnClose: TcxButton
    Left = 286
    Top = 127
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    TabOrder = 4
    OnClick = cxButton2Click
  end
end
