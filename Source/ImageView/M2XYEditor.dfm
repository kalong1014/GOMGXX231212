object uFrmXYEditor: TuFrmXYEditor
  Left = 589
  Top = 296
  BorderStyle = bsDialog
  Caption = #20559#31227#22352#26631
  ClientHeight = 240
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object lbl3: TLabel
    Left = 8
    Top = 180
    Width = 198
    Height = 24
    Caption = 'PS:'#23545#20110#25209#37327#20943#23569#20559#31227#65292#13#10#20351#29992#25209#37327#22686#21152#20559#31227' X Y '#20026#36127#25968#21363#21487#12290
    Color = clRed
    ParentColor = False
    WordWrap = True
  end
  object RzGroupBox1: TGroupBox
    Left = 5
    Top = 93
    Width = 264
    Height = 81
    Caption = #22352#26631
    TabOrder = 0
    object RzLabel1: TLabel
      Left = 8
      Top = 23
      Width = 12
      Height = 12
      Caption = 'X:'
      Transparent = False
    end
    object RzLabel2: TLabel
      Left = 8
      Top = 49
      Width = 12
      Height = 12
      Caption = 'Y:'
      Transparent = False
    end
    object EditY: TcxTextEdit
      Left = 34
      Top = 45
      Properties.Alignment.Horz = taRightJustify
      Style.BorderStyle = ebsFlat
      TabOrder = 1
      Text = '0'
      Width = 215
    end
    object EditX: TcxTextEdit
      Left = 34
      Top = 19
      Properties.Alignment.Horz = taRightJustify
      Style.BorderStyle = ebsFlat
      TabOrder = 0
      Text = '0'
      Width = 215
    end
  end
  object cxButton1: TcxButton
    Left = 8
    Top = 210
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    LookAndFeel.Kind = lfFlat
    ModalResult = 1
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 194
    Top = 210
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    LookAndFeel.Kind = lfFlat
    ModalResult = 2
    TabOrder = 2
  end
  object rg_XYEditor: TRadioGroup
    Left = 3
    Top = 4
    Width = 115
    Height = 83
    Caption = #22352#26631#32534#36753#27169#24335
    Items.Strings = (
      #21333#24352#32534#36753
      #25209#37327#35774#32622
      #25209#37327#22686#21152#20559#31227)
    TabOrder = 3
    OnClick = rg_XYEditorClick
  end
  object grp_ImageNumber: TGroupBox
    Left = 124
    Top = 4
    Width = 145
    Height = 83
    Caption = #22270#29255#24207#21495
    TabOrder = 4
    object lbl1: TLabel
      Left = 8
      Top = 24
      Width = 54
      Height = 12
      Caption = #36215#22987#24207#21495':'
    end
    object lbl2: TLabel
      Left = 8
      Top = 53
      Width = 54
      Height = 12
      Caption = #32467#26463#24207#21495':'
    end
    object se_Start: TSpinEdit
      Left = 68
      Top = 19
      Width = 69
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object se_End: TSpinEdit
      Left = 68
      Top = 50
      Width = 71
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
  end
end
