object frmDirChoose: TfrmDirChoose
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #35831#36873#25321#20256#22855#23433#35013#36335#24452
  ClientHeight = 161
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object LabCaption: TLabel
    Left = 8
    Top = 8
    Width = 204
    Height = 13
    AutoSize = False
    Caption = #20197#19979#26159#20174#20320#31995#32479#20013#26597#25214#21040#30340#20256#22855#36335#24452':'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 123
    Width = 370
    Height = 2
  end
  object LabSearch: TLabel
    Left = 8
    Top = 103
    Width = 370
    Height = 13
    AutoSize = False
    Caption = #20934#22791#23601#32490'...'
  end
  object BtnOK: TBitBtn
    Left = 222
    Top = 131
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = BtnOKClick
  end
  object BtnCancel: TBitBtn
    Left = 303
    Top = 131
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 4
  end
  object ListClientDirs: TListBox
    Left = 8
    Top = 27
    Width = 370
    Height = 70
    ItemHeight = 13
    TabOrder = 0
  end
  object BtnSearch: TBitBtn
    Left = 8
    Top = 131
    Width = 75
    Height = 25
    Caption = #28145#24230#25628#32034'...'
    TabOrder = 1
    OnClick = BtnSearchClick
  end
  object BtnChoose: TBitBtn
    Left = 89
    Top = 131
    Width = 75
    Height = 25
    Caption = #25163#24037#36873#25321
    TabOrder = 2
    OnClick = BtnChooseClick
  end
end
