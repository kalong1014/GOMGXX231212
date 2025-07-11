object frmLoginSrvList: TfrmLoginSrvList
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #30331#24405#22120#21015#34920#22320#22336
  ClientHeight = 119
  ClientWidth = 661
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
  object lbl_FirstURL: TLabel
    Left = 8
    Top = 8
    Width = 88
    Height = 13
    Caption = #26381#21153#22120#21015#34920#22320#22336':'
  end
  object lbl_SecondURL: TLabel
    Left = 8
    Top = 33
    Width = 112
    Height = 13
    Caption = #22791#29992#26381#21153#22120#21015#34920#22320#22336':'
  end
  object lbl_ThridURL: TLabel
    Left = 8
    Top = 60
    Width = 112
    Height = 13
    Caption = #22791#29992#26381#21153#22120#21015#34920#22320#22336':'
  end
  object edt_First: TEdit
    Left = 126
    Top = 5
    Width = 521
    Height = 21
    TabOrder = 0
  end
  object edt_Second: TEdit
    Left = 126
    Top = 32
    Width = 521
    Height = 21
    TabOrder = 1
  end
  object edt_ThridURL: TEdit
    Left = 126
    Top = 57
    Width = 521
    Height = 21
    TabOrder = 2
  end
  object btn_OK: TButton
    Left = 288
    Top = 84
    Width = 75
    Height = 25
    Caption = #30830#35748
    ModalResult = 1
    TabOrder = 3
  end
end
