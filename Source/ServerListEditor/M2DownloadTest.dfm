object DownloadTestForm: TDownloadTestForm
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = #26356#26032#39033#27979#35797
  ClientHeight = 86
  ClientWidth = 443
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
  object LabInfo: TLabel
    Left = 8
    Top = 8
    Width = 427
    Height = 13
    AutoSize = False
  end
  object ProgressBar: TcxProgressBar
    Left = 8
    Top = 27
    TabOrder = 2
    Width = 427
  end
  object BtnClose: TcxButton
    Left = 360
    Top = 53
    Width = 75
    Height = 25
    Cancel = True
    Caption = #20851#38381
    Default = True
    TabOrder = 1
    OnClick = BtnCloseClick
  end
  object BtnDownload: TcxButton
    Left = 279
    Top = 53
    Width = 75
    Height = 25
    Caption = #19979#36733
    TabOrder = 0
    OnClick = BtnDownloadClick
  end
end
