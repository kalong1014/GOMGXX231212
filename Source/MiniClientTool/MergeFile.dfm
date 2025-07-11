object frmMerge: TfrmMerge
  Left = 300
  Top = 374
  BorderStyle = bsSizeToolWin
  Caption = 'frmMerge'
  ClientHeight = 106
  ClientWidth = 441
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 8
    Width = 100
    Height = 13
    Caption = #38656#35201#21512#24182#30340#25991#20214#22841':'
  end
  object lbl2: TLabel
    Left = 8
    Top = 41
    Width = 88
    Height = 13
    Caption = #21512#24182#38656#35201#20445#23384#21040':'
  end
  object edt_Dir: TRzButtonEdit
    Left = 114
    Top = 8
    Width = 305
    Height = 21
    TabOrder = 0
    OnAltBtnClick = edt_DirButtonClick
    OnButtonClick = edt_DirButtonClick
  end
  object edt_TargetFile: TRzButtonEdit
    Left = 114
    Top = 35
    Width = 305
    Height = 21
    TabOrder = 1
    OnAltBtnClick = edt_DirButtonClick
    OnButtonClick = edt_DirButtonClick
  end
  object btn_Save: TButton
    Left = 192
    Top = 62
    Width = 75
    Height = 25
    Caption = 'btn_Save'
    TabOrder = 2
    OnClick = btn_SaveClick
  end
  object SelDirDlg1: TRzSelectFolderDialog
    Left = 200
  end
end
