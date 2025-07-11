object M2ImportFromOtherForm: TM2ImportFromOtherForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = #29256#26412#23548#20837
  ClientHeight = 315
  ClientWidth = 585
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 67
    Width = 585
    Height = 2
    Align = alTop
    ExplicitLeft = 112
    ExplicitTop = 88
    ExplicitWidth = 50
  end
  object Bevel2: TBevel
    Left = 0
    Top = 276
    Width = 585
    Height = 2
    Align = alBottom
    ExplicitLeft = 8
    ExplicitTop = 299
    ExplicitWidth = 561
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 585
    Height = 67
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = clWhite
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 121
      Height = 13
      AutoSize = False
      Caption = #26087#29256#26412#23548#20837#21040'91M2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabTitle: TLabel
      Left = 16
      Top = 27
      Width = 537
      Height = 42
      AutoSize = False
      Caption = 'LabTitle'
      WordWrap = True
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 278
    Width = 585
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    object BtnPrPage: TcxButton
      Left = 293
      Top = 6
      Width = 70
      Height = 24
      Caption = #19978#19968#27493
      TabOrder = 0
      OnClick = BtnPrPageClick
    end
    object BtnNxPage: TcxButton
      Left = 364
      Top = 6
      Width = 70
      Height = 24
      Caption = #19979#19968#27493
      TabOrder = 1
      OnClick = BtnNxPageClick
    end
    object BtnExec: TcxButton
      Left = 435
      Top = 6
      Width = 70
      Height = 24
      Caption = #23548#20837
      TabOrder = 2
      OnClick = BtnExecClick
    end
    object BtnClose: TcxButton
      Left = 507
      Top = 6
      Width = 70
      Height = 24
      Cancel = True
      Caption = #20851#38381
      ModalResult = 2
      TabOrder = 3
      OnClick = BtnCloseClick
    end
  end
  object PageNoteBook: TcxPageControl
    Left = 0
    Top = 69
    Width = 585
    Height = 207
    Align = alClient
    TabOrder = 2
    Properties.ActivePage = Sheet1
    Properties.CustomButtons.Buttons = <>
    Properties.HideTabs = True
    LookAndFeel.Kind = lfUltraFlat
    LookAndFeel.NativeStyle = False
    ClientRectBottom = 207
    ClientRectRight = 585
    ClientRectTop = 0
    object Sheet1: TcxTabSheet
      Caption = 'Sheet1'
      ImageIndex = 0
      object GroupBox1: TGroupBox
        AlignWithMargins = True
        Left = 8
        Top = 3
        Width = 569
        Height = 196
        Margins.Left = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Caption = #36873#25321#29256#26412#25991#20214#22841
        TabOrder = 0
        object EditPath: TcxButtonEdit
          Left = 8
          Top = 24
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditPathPropertiesButtonClick
          TabOrder = 0
          Text = 'D:\MirServer\'
          Width = 553
        end
        object Memo1: TMemo
          Left = 8
          Top = 51
          Width = 553
          Height = 94
          BorderStyle = bsNone
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Lines.Strings = (
            #27880#24847#65306
            '1. '#29256#26412#23548#20837#23436#25104#21518#35831#20351#29992#32534#35793#21151#33021#26816#26597#24182#20462#27491#19981#27491#30830#30340#33050#26412
            '2. '#33050#26412#23548#20837#26102#21482#23548#20837#24403#21069#29256#26412#30495#27491#20351#29992#21040#30340#33050#26412#65288'NPC'#35843#29992#20102#25110#32773#33050#26412#20351#29992'#CALL'#24341#29992#20102#65289
            '3. '#33050#26412#23548#20837#21518#24212#35813#36880#20010#33050#26412#36827#34892#26816#26597#20197#20415#20462#27491#27491#30830#30340#20195#30721)
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
    object Sheet2: TcxTabSheet
      Caption = 'Sheet2'
      ImageIndex = 1
      object GroupBox2: TGroupBox
        AlignWithMargins = True
        Left = 8
        Top = 6
        Width = 569
        Height = 190
        Margins.Left = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Caption = #23548#20837#20869#23481#36873#39033
        TabOrder = 0
        object EditOptions: TcxCheckListBox
          Left = 8
          Top = 16
          Width = 552
          Height = 165
          Items = <>
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 0
        end
      end
    end
    object Sheet3: TcxTabSheet
      Caption = 'Sheet3'
      ImageIndex = 2
      object LabelWorking: TLabel
        Left = 8
        Top = 8
        Width = 569
        Height = 13
        AutoSize = False
        Caption = 'LabelWorking'
      end
      object ProgressBar: TcxProgressBar
        Left = 8
        Top = 29
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 0
        Width = 569
      end
      object TreeWorking: TcxTreeList
        Left = 8
        Top = 56
        Width = 569
        Height = 140
        Bands = <
          item
          end>
        LookAndFeel.Kind = lfFlat
        LookAndFeel.NativeStyle = False
        Navigator.Buttons.CustomButtons = <>
        OptionsCustomizing.ColumnVertSizing = False
        OptionsSelection.CellSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.Headers = False
        OptionsView.ShowRoot = False
        TabOrder = 1
        object WorkingStateColumn: TcxTreeListColumn
          DataBinding.ValueType = 'String'
          Position.ColIndex = 0
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
      end
    end
  end
end
