object FrmFindUserId: TFrmFindUserId
  Left = 212
  Top = 421
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #30331#24405#24080#21495#31649#29702
  ClientHeight = 198
  ClientWidth = 623
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object IdGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 623
    Height = 160
    Align = alClient
    ColCount = 16
    DefaultRowHeight = 20
    FixedCols = 0
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
    ParentFont = False
    TabOrder = 0
    OnDblClick = BtnEditClick
    ColWidths = (
      64
      64
      71
      91
      89
      150
      141
      169
      170
      83
      90
      72
      76
      182
      159
      218)
  end
  object Panel1: TPanel
    Left = 0
    Top = 160
    Width = 623
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 13
      Width = 48
      Height = 12
      Caption = #26597#25214#36134#21495
    end
    object EdFindId: TEdit
      Left = 70
      Top = 9
      Width = 121
      Height = 20
      TabOrder = 0
      OnKeyPress = EdFindIdKeyPress
    end
    object BtnFindAll: TButton
      Left = 197
      Top = 8
      Width = 64
      Height = 22
      Caption = #25628#32034'(&S)'
      TabOrder = 1
      OnClick = BtnFindAllClick
    end
    object BtnEdit: TButton
      Left = 312
      Top = 8
      Width = 64
      Height = 22
      Caption = #32534#36753'(&E)'
      TabOrder = 2
      OnClick = BtnEditClick
    end
    object Button2: TButton
      Left = 400
      Top = 8
      Width = 64
      Height = 22
      Caption = #26032#24314'(&N)'
      TabOrder = 3
      OnClick = Button2Click
    end
  end
end
