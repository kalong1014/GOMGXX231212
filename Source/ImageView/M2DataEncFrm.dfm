object DataEncForm: TDataEncForm
  Left = 0
  Top = 0
  ActiveControl = EditPwd
  BorderStyle = bsDialog
  Caption = #32032#26448#21152#23494
  ClientHeight = 86
  ClientWidth = 299
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
  object LabelCaption: TLabel
    Left = 8
    Top = 8
    Width = 185
    Height = 13
    AutoSize = False
    Caption = #35831#36755#20837#23494#30721#65306
  end
  object EditPwd: TcxTextEdit
    Left = 8
    Top = 27
    Properties.EchoMode = eemPassword
    Properties.MaxLength = 16
    TabOrder = 0
    Width = 281
  end
  object BtnOK: TcxButton
    Left = 133
    Top = 54
    Width = 75
    Height = 25
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 1
  end
  object BtnCancel: TcxButton
    Left = 214
    Top = 54
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
  end
end
