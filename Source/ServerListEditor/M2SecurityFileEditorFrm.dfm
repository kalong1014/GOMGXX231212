object M2SecurityFileEditorForm: TM2SecurityFileEditorForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #25991#20214#20449#24687
  ClientHeight = 128
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object cxGroupBox1: TcxGroupBox
    Left = 8
    Top = 8
    Caption = #25991#20214#20449#24687
    Style.BorderStyle = ebsUltraFlat
    TabOrder = 0
    Height = 81
    Width = 377
    object Label1: TLabel
      Left = 16
      Top = 25
      Width = 24
      Height = 13
      Caption = #25991#20214
    end
    object Label2: TLabel
      Left = 16
      Top = 52
      Width = 24
      Height = 13
      Caption = #23494#30721
    end
    object EditFileName: TcxTextEdit
      Left = 56
      Top = 21
      Style.BorderStyle = ebsFlat
      TabOrder = 0
      Width = 313
    end
    object EditPassword: TcxTextEdit
      Left = 56
      Top = 48
      Properties.EchoMode = eemPassword
      Style.BorderStyle = ebsFlat
      TabOrder = 1
      Width = 313
    end
  end
  object BtnOK: TcxButton
    Left = 229
    Top = 95
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    LookAndFeel.NativeStyle = True
    ModalResult = 1
    TabOrder = 1
  end
  object BtnCancel: TcxButton
    Left = 310
    Top = 95
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    LookAndFeel.NativeStyle = True
    ModalResult = 2
    TabOrder = 2
  end
end
