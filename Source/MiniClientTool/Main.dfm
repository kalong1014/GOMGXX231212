object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #24494#31471#36164#28304#26500#24314#22120
  ClientHeight = 681
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mm
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object mm_FileList: TMemo
    Left = 200
    Top = 109
    Width = 586
    Height = 340
    Lines.Strings = (
      'mm_FileList')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object rzspltr_PathAndLog: TRzSplitter
    Left = 0
    Top = 0
    Width = 744
    Height = 681
    Orientation = orVertical
    Position = 111
    Percent = 16
    Align = alClient
    Color = 15987699
    TabOrder = 1
    BarSize = (
      0
      111
      744
      115)
    UpperLeftControls = (
      SubLabel
      SubLabel
      SubLabel
      lbledt_Src
      lbledt_Target
      btn_Src
      btn_Target
      lbledt_Password)
    LowerRightControls = (
      mm_log
      grp_TestFunction
      pnl1
      grp_FileList)
    object lbledt_Src: TLabeledEdit
      Left = 85
      Top = 15
      Width = 545
      Height = 21
      EditLabel.Width = 64
      EditLabel.Height = 13
      EditLabel.Caption = #23458#25143#31471#30446#24405':'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object lbledt_Target: TLabeledEdit
      Left = 85
      Top = 42
      Width = 545
      Height = 21
      EditLabel.Width = 64
      EditLabel.Height = 13
      EditLabel.Caption = #30446#26631#25991#20214#22841':'
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object btn_Src: TButton
      Left = 636
      Top = 13
      Width = 85
      Height = 22
      Align = alCustom
      Caption = #36873#25321#30446#24405
      TabOrder = 2
      OnClick = btn_SrcClick
    end
    object btn_Target: TButton
      Left = 636
      Top = 41
      Width = 85
      Height = 21
      Align = alCustom
      Caption = #36873#25321#30446#24405
      TabOrder = 3
      OnClick = btn_TargetClick
    end
    object lbledt_Password: TLabeledEdit
      Left = 85
      Top = 74
      Width = 224
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #24494#31471#23494#30721':'
      LabelPosition = lpLeft
      TabOrder = 4
    end
    object mm_log: TMemo
      Left = 0
      Top = 236
      Width = 744
      Height = 251
      Align = alBottom
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object grp_TestFunction: TGroupBox
      Left = 452
      Top = 251
      Width = 265
      Height = 193
      Caption = 'grp_TestFunction'
      TabOrder = 1
      Visible = False
      object btn1: TButton
        Left = 84
        Top = 165
        Width = 121
        Height = 25
        Caption = #21015#20030#25152#26377#25991#20214
        TabOrder = 0
        OnClick = btn1Click
      end
      object btn_TestSplRes: TButton
        Left = 3
        Top = 20
        Width = 75
        Height = 25
        Caption = #27979#35797#20998#21106
        TabOrder = 1
        OnClick = btn_TestSplResClick
      end
      object btn_ListFileToTree: TButton
        Left = 3
        Top = 113
        Width = 145
        Height = 25
        Caption = #21015#20030#23458#25143#31471#25991#38598#21040#21015#34920
        TabOrder = 2
        OnClick = btn_ListFileToTreeClick
      end
      object btn_Meger: TButton
        Left = 3
        Top = 164
        Width = 75
        Height = 27
        Caption = #21512#24182
        TabOrder = 3
        OnClick = btn_MegerClick
      end
      object btn_PackageMiniData: TButton
        Left = 3
        Top = 51
        Width = 109
        Height = 25
        Caption = #25171#21253'MiniData'#25991#20214
        TabOrder = 4
        OnClick = btn_PackageMiniDataClick
      end
      object btn_EnumPackageFile: TButton
        Left = 3
        Top = 82
        Width = 124
        Height = 25
        Caption = #36733#20837#26174#31034'MiniData'#25991#20214
        TabOrder = 5
        OnClick = btn_EnumPackageFileClick
      end
    end
    object pnl1: TPanel
      Left = 0
      Top = 487
      Width = 744
      Height = 79
      Align = alBottom
      TabOrder = 2
      object Progress_Mini: TRzProgressStatus
        Left = 1
        Top = 21
        Width = 742
        Align = alTop
        ParentShowHint = False
        PartsComplete = 0
        Percent = 0
        ShowPercent = True
        ShowParts = True
        TotalParts = 100
        ExplicitTop = 33
        ExplicitWidth = 732
      end
      object Progress_Total: TRzProgressStatus
        Left = 1
        Top = 1
        Width = 742
        Align = alTop
        ParentShowHint = False
        PartsComplete = 0
        Percent = 0
        ShowPercent = True
        ShowParts = True
        TotalParts = 0
        ExplicitTop = 33
        ExplicitWidth = 732
      end
      object btn_BuilderMiniClientFile: TButton
        Left = 612
        Top = 43
        Width = 117
        Height = 32
        Caption = #26500#24314#25152#26377#25991#20214
        TabOrder = 0
        OnClick = btn_BuilderMiniClientFileClick
      end
      object btn_BuildDataRes: TButton
        Left = 21
        Top = 47
        Width = 124
        Height = 25
        Caption = #26500#24314#22270#29255#25991#20214#36164#28304
        TabOrder = 1
        OnClick = btn_BuildDataResClick
      end
      object btn_BuildMapRes: TButton
        Left = 151
        Top = 47
        Width = 129
        Height = 25
        Caption = #26500#24314#22320#22270#36164#28304
        TabOrder = 2
        OnClick = btn_BuildMapResClick
      end
      object btn_BuildWav: TButton
        Left = 286
        Top = 47
        Width = 129
        Height = 25
        Caption = #26500#24314#22768#38899#36164#28304
        TabOrder = 3
        OnClick = btn_BuildWavClick
      end
      object btn_DoOtherFiles: TButton
        Left = 421
        Top = 47
        Width = 121
        Height = 25
        Caption = #26500#24314#20854#20182#25991#20214
        TabOrder = 4
        OnClick = btn_DoOtherFilesClick
      end
    end
    object grp_FileList: TGroupBox
      Left = 0
      Top = 0
      Width = 744
      Height = 236
      Align = alClient
      Caption = #25903#25345#24494#31471#20256#36755#25991#20214#21015#34920
      TabOrder = 3
      object lst_FileName: TListBox
        Left = 2
        Top = 15
        Width = 740
        Height = 219
        Align = alClient
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
      end
      object btn_AddFile: TButton
        Left = 672
        Top = 5
        Width = 30
        Height = 18
        Caption = '+'
        TabOrder = 1
        OnClick = btn_AddFileClick
      end
      object btn_DelFile: TButton
        Left = 704
        Top = 5
        Width = 27
        Height = 18
        Caption = '-'
        TabOrder = 2
        OnClick = btn_DelFileClick
      end
    end
  end
  object mm: TMainMenu
    Left = 720
    Top = 40
    object MI_Menu: TMenuItem
      Caption = #33756#21333
      Visible = False
      object MI_MergeFile: TMenuItem
        Caption = #21512#24182#20998#35299#30340#25991#20214
        OnClick = MI_MergeFileClick
      end
    end
  end
  object dlgOpen1: TOpenDialog
    Left = 352
    Top = 208
  end
end
