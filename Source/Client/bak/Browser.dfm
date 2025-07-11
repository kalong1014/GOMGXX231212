object frmBrowser: TfrmBrowser
  Left = 697
  Top = 445
  BorderStyle = bsNone
  ClientHeight = 259
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object NavPanel: TPanel
    Left = 0
    Top = 236
    Width = 319
    Height = 23
    Align = alBottom
    BevelOuter = bvNone
    Color = clBlack
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      319
      23)
    object SpeedButton1: TSpeedButton
      Left = 250
      Top = 0
      Width = 69
      Height = 23
      Anchors = [akTop, akRight]
      Caption = #20851#38381
      Flat = True
      Font.Charset = GB2312_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = SpeedButton1Click
    end
  end
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 0
    Width = 319
    Height = 236
    Align = alClient
    TabOrder = 1
    OnNewWindow2 = WebBrowser1NewWindow2
    OnWindowClosing = WebBrowser1WindowClosing
    ExplicitWidth = 383
    ExplicitHeight = 265
    ControlData = {
      4C000000F8200000641800000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
