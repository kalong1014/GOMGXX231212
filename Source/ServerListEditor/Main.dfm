object FrmServerList: TFrmServerList
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = #30331#38470#22120#21015#34920#21046#20316#65288#25480#26435#29256#65289
  ClientHeight = 561
  ClientWidth = 771
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TcxPageControl
    AlignWithMargins = True
    Left = 8
    Top = 159
    Width = 755
    Height = 394
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alClient
    TabOrder = 0
    Properties.ActivePage = TabSheetServerList
    Properties.CustomButtons.Buttons = <>
    Properties.ShowFrame = True
    Properties.Style = 10
    ClientRectBottom = 393
    ClientRectLeft = 1
    ClientRectRight = 754
    ClientRectTop = 19
    object TabSheetServerList: TcxTabSheet
      Caption = #20998#21306#21015#34920
      ImageIndex = 0
      object lvServers: TcxListView
        AlignWithMargins = True
        Left = 8
        Top = 30
        Width = 737
        Height = 336
        Margins.Left = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = #20998#32452
            Width = 90
          end
          item
            AutoSize = True
            Caption = #21517#31216
          end
          item
            Caption = #26174#31034#21517#31216
            Width = 150
          end
          item
            Caption = 'IP/'#22495#21517
            Width = 150
          end
          item
            Caption = #31471#21475
            Width = 55
          end
          item
            Caption = #23553#21253#23494#30721
            Width = 95
          end>
        ReadOnly = True
        RowSelect = True
        Style.BorderStyle = cbsFlat
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = True
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = lvServersDblClick
        OnSelectItem = lvServersSelectItem
      end
      object dxBarDockControl1: TdxBarDockControl
        Left = 0
        Top = 0
        Width = 753
        Height = 27
        Align = dalTop
        BarManager = BarManager
      end
    end
    object TabSheetUpdateList: TcxTabSheet
      Caption = #34917#19969#26356#26032#21015#34920
      ImageIndex = 1
      object lvUpdates: TcxListView
        AlignWithMargins = True
        Left = 8
        Top = 30
        Width = 737
        Height = 336
        Margins.Left = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            AutoSize = True
            Caption = #22320#22336
          end
          item
            Caption = #26159#21542#21387#32553
            Width = 60
          end
          item
            Caption = #23433#35013#36335#24452
            Width = 100
          end
          item
            Caption = #25991#20214#21517#31216
            Width = 100
          end
          item
            Caption = 'MD5'#20540
            Width = 100
          end
          item
            Caption = #19979#36733#26041#24335
            Width = 75
          end
          item
            Caption = #20248#20808#32423
            Width = 100
          end>
        ReadOnly = True
        RowSelect = True
        Style.BorderStyle = cbsFlat
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = True
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvUpdatesChange
        OnClick = lvUpdatesClick
        OnDblClick = lvUpdatesDblClick
        OnSelectItem = lvUpdatesSelectItem
      end
      object dxBarDockControl2: TdxBarDockControl
        Left = 0
        Top = 0
        Width = 753
        Height = 27
        Align = dalTop
        BarManager = BarManager
      end
    end
    object TabSheetDataSecurity: TcxTabSheet
      Caption = #32032#26448#23494#30721
      ImageIndex = 6
      object lvSecurityFiles: TcxListView
        AlignWithMargins = True
        Left = 8
        Top = 30
        Width = 737
        Height = 336
        Margins.Left = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = 'Data'#25991#20214
          end
          item
            Caption = #23494#30721
            Width = 150
          end>
        ReadOnly = True
        RowSelect = True
        Style.BorderStyle = cbsFlat
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = True
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = lvUpdatesDblClick
        OnSelectItem = lvUpdatesSelectItem
      end
      object dxBarDockControl3: TdxBarDockControl
        Left = 0
        Top = 0
        Width = 753
        Height = 27
        Align = dalTop
        BarManager = BarManager
      end
    end
    object TabSheetClientSettings: TcxTabSheet
      Caption = #23458#25143#31471#25511#21046
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object LabelDefSize: TLabel
        Left = 16
        Top = 93
        Width = 73
        Height = 13
        AutoSize = False
        Caption = #40664#35748#20998#36776#29575
      end
      object Label1: TLabel
        Left = 16
        Top = 126
        Width = 129
        Height = 13
        AutoSize = False
        Caption = #21487#25171#24320#23458#25143#31471#26368#22823#25968#37327
      end
      object Label2: TLabel
        Left = 8
        Top = 212
        Width = 71
        Height = 13
        Caption = 'Client.dat'#26356#21517
      end
      object Label3: TLabel
        Left = 297
        Top = 212
        Width = 92
        Height = 13
        Caption = '('#21830#19994#30331#24405#22120#26377#25928')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object CheckFullScreen: TcxCheckBox
        Left = 8
        Top = 8
        Caption = #20840#23631
        Properties.OnChange = CheckFullScreenPropertiesChange
        Style.BorderStyle = ebsFlat
        TabOrder = 0
      end
      object CheckDo3D: TcxCheckBox
        Left = 8
        Top = 35
        Caption = '3D'#21152#36895
        Properties.OnChange = CheckFullScreenPropertiesChange
        Style.BorderStyle = ebsFlat
        TabOrder = 1
      end
      object CheckVBlank: TcxCheckBox
        Left = 8
        Top = 62
        Caption = #22402#30452#21516#27493
        Properties.OnChange = CheckFullScreenPropertiesChange
        Style.BorderStyle = ebsFlat
        TabOrder = 2
      end
      object CombDisplaySize: TcxComboBox
        Left = 82
        Top = 89
        Properties.DropDownListStyle = lsFixedList
        Properties.Items.Strings = (
          #26080
          '1024X768'
          '800X600')
        Properties.OnChange = CombDisplaySizePropertiesChange
        Style.BorderStyle = ebsFlat
        TabOrder = 3
        Text = '1024X768'
        Width = 121
      end
      object EditMaxClient: TcxSpinEdit
        Left = 151
        Top = 122
        Properties.MaxValue = 30.000000000000000000
        Properties.MinValue = 1.000000000000000000
        Properties.OnChange = EditLoginZIPPropertiesChange
        Style.BorderStyle = ebsFlat
        TabOrder = 4
        Value = 1
        Width = 52
      end
      object EditShortCut: TcxCheckBox
        Left = 8
        Top = 176
        Caption = #20801#35768#21019#24314#24555#25463#26041#24335
        Properties.OnChange = EditShortCutPropertiesChange
        Style.BorderStyle = ebsFlat
        TabOrder = 5
      end
      object EditClientExeName: TcxTextEdit
        Left = 143
        Top = 209
        Properties.OnChange = EditClientExeNamePropertiesChange
        Style.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.Kind = lfFlat
        TabOrder = 6
        Text = 'Client.dat'
        OnKeyPress = EditClientExeNameKeyPress
        Width = 148
      end
    end
    object TabSheetMini: TcxTabSheet
      Caption = #24494#31471#25511#21046
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object LabelMiniPwd: TLabel
        Left = 8
        Top = 39
        Width = 101
        Height = 13
        AutoSize = False
        Caption = #24494#31471#36164#28304#19979#36733#23494#30721
      end
      object LabelMiniList: TLabel
        Left = 8
        Top = 62
        Width = 118
        Height = 13
        AutoSize = False
        Caption = #24494#31471#36164#28304#26381#21153#22120#21015#34920
      end
      object LabelMiniInfo1: TLabel
        Left = 127
        Top = 165
        Width = 374
        Height = 13
        AutoSize = False
        Caption = #27880#65306#24494#31471#26381#21153#22120#22320#22336#12290#26684#24335#20026#65306'IP/'#22495#21517':'#31471#21475#65292#22914'http://127.0.0.1:8080'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelMiniInfo2: TLabel
        Left = 150
        Top = 182
        Width = 585
        Height = 13
        AutoSize = False
        Caption = #36164#28304#26381#21153#22120#21487#20197#20026#22810#20010#65292#21015#34920#20013#27599#19968#34892#22635#20889#19968#20010#26381#21153#22120#22320#22336#65288#36164#28304#26381#21153#22120#21487#20301#20110#19981#21516#26426#22120#21644#19981#21516#32593#32476#29615#22659#65289
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object CheckMiniResSrv: TcxCheckBox
        Left = 8
        Top = 8
        Caption = #21551#29992#24494#31471
        Properties.OnChange = CheckMiniResSrvPropertiesChange
        Style.BorderStyle = ebsFlat
        TabOrder = 0
      end
      object EditMiniPwd: TcxTextEdit
        Left = 127
        Top = 35
        Hint = #26412#23494#30721#38656#35201#21644#24494#31471#26381#21153#22120#23494#30721#19968#33268#65292#21487#26377#25928#38450#27490#36164#28304#34987#20854#20182#23458#25143#31471#19979#36733
        ParentShowHint = False
        Properties.EchoMode = eemPassword
        Properties.PasswordChar = '*'
        Properties.OnChange = CheckMiniResSrvPropertiesChange
        ShowHint = True
        Style.BorderStyle = ebsFlat
        TabOrder = 1
        TextHint = #26412#23494#30721#38656#35201#21644#24494#31471#26381#21153#22120#23494#30721#19968#33268#65292#21487#26377#25928#38450#27490#36164#28304#34987#20854#20182#23458#25143#31471#19979#36733
        Width = 608
      end
      object EditLinkMiniURL: TcxMemo
        Left = 127
        Top = 62
        Properties.ScrollBars = ssBoth
        Properties.OnChange = EditLinkMiniURLPropertiesChange
        Style.BorderStyle = ebsFlat
        TabOrder = 2
        Height = 99
        Width = 608
      end
    end
    object TabSheetLoginUpdate: TcxTabSheet
      Caption = #30331#38470#22120#35774#32622
      ImageIndex = 4
      object GroupBox2: TGroupBox
        Left = 8
        Top = 8
        Width = 735
        Height = 163
        Caption = #30331#24405#22120#26356#26032#35774#32622
        TabOrder = 0
        object LabelLoginName: TLabel
          Left = 8
          Top = 55
          Width = 48
          Height = 13
          Caption = #25991#20214#21517#31216
        end
        object EditLoginURL: TcxHyperLinkEdit
          Left = 78
          Top = 24
          Hint = #25351#23450#30331#38470#22120#19979#36733#22320#22336
          Properties.OnChange = EditLoginURLPropertiesChange
          Style.BorderStyle = ebsFlat
          Style.LookAndFeel.NativeStyle = True
          StyleDisabled.LookAndFeel.NativeStyle = True
          StyleFocused.LookAndFeel.NativeStyle = True
          StyleHot.LookAndFeel.NativeStyle = True
          TabOrder = 0
          TextHint = #25351#23450#30331#38470#22120#19979#36733#22320#22336
          Width = 331
        end
        object EditLoginFile: TcxButtonEdit
          Left = 78
          Top = 51
          Hint = #36873#25321#30331#38470#22120#25991#20214#21462#20986#25991#20214#21517#21450'MD5'#32534#30721
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = False
          Properties.OnButtonClick = EditLoginFilePropertiesButtonClick
          Properties.OnChange = EditLoginFilePropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 1
          Text = 'EditLoginFile'
          TextHint = #36873#25321#30331#38470#22120#25991#20214#21462#20986#25991#20214#21517#21450'MD5'#32534#30721
          Width = 331
        end
        object EditLoginMD5: TcxTextEdit
          Left = 78
          Top = 78
          Properties.OnChange = EditLoginMD5PropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 2
          Text = 'EditLoginMD5'
          Width = 331
        end
        object EditLoginDownType: TcxComboBox
          Left = 78
          Top = 105
          Properties.DropDownListStyle = lsFixedList
          Properties.Items.Strings = (
            'HTTP'
            #30334#24230#32593#30424
            '360'#32593#30424
            'FTP'
            #30334#24230#30456#20876)
          Properties.OnChange = EditLoginDownTypePropertiesChange
          Style.BorderStyle = ebsFlat
          Style.LookAndFeel.NativeStyle = True
          StyleDisabled.LookAndFeel.NativeStyle = True
          StyleFocused.LookAndFeel.NativeStyle = True
          StyleHot.LookAndFeel.NativeStyle = True
          TabOrder = 3
          Width = 331
        end
        object EditLoginZIP: TcxCheckBox
          Left = 8
          Top = 132
          Hint = #25351#23450#19979#36733#30340#25991#20214#26159#21542#20026'RAR'#26684#24335
          AutoSize = False
          Caption = #26159#21542#21387#32553
          Properties.Alignment = taRightJustify
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          Style.LookAndFeel.NativeStyle = True
          StyleDisabled.LookAndFeel.NativeStyle = True
          StyleFocused.LookAndFeel.NativeStyle = True
          StyleHot.LookAndFeel.NativeStyle = True
          TabOrder = 4
          Height = 21
          Width = 88
        end
        object LabelLoginDownType: TcxLabel
          Left = 8
          Top = 107
          AutoSize = False
          Caption = #19979#36733#26041#24335
          Height = 17
          Width = 52
        end
        object LabelLoginMD5: TcxLabel
          Left = 8
          Top = 80
          AutoSize = False
          Caption = 'MD5'#32534#30721
          Height = 17
          Width = 49
        end
        object LabelLoginURL: TcxLabel
          Left = 8
          Top = 26
          AutoSize = False
          Caption = #19979#36733#22320#22336
          Height = 17
          Width = 52
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 177
        Width = 735
        Height = 188
        Caption = #36134#21495#27880#20876
        TabOrder = 1
        object EditRegIDLetterNum: TcxCheckBox
          Left = 8
          Top = 16
          Caption = #36134#21495#24517#39035#21253#21547#23383#27597#21644#25968#23383
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 0
        end
        object EditRegIDFirstLetter: TcxCheckBox
          Left = 8
          Top = 40
          Caption = #36134#21495#31532#19968#20301#24517#39035#26159#23383#27597
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 1
        end
        object EditRegIDShowName: TcxCheckBox
          Left = 216
          Top = 16
          Caption = #26174#31034#22995#21517#23383#27573
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 2
        end
        object EditRegIDNameReq: TcxCheckBox
          Left = 359
          Top = 16
          Caption = #22995#21517#23383#27573#24517#39035#36755#20837
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 3
        end
        object EditRegIDShowBirth: TcxCheckBox
          Left = 216
          Top = 40
          Caption = #26174#31034#29983#26085#23383#27573
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 4
        end
        object EditRegIDBirthReq: TcxCheckBox
          Left = 359
          Top = 40
          Caption = #29983#26085#23383#27573#24517#39035#36755#20837
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 5
        end
        object EditRegIDShowQS: TcxCheckBox
          Left = 216
          Top = 64
          Caption = #26174#31034#38382#31572#39033#23383#27573
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 6
        end
        object EditRegIDQSReq: TcxCheckBox
          Left = 359
          Top = 64
          Caption = #38382#31572#39033#23383#27573#24517#39035#36755#20837
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 7
        end
        object EditRegIDShowMail: TcxCheckBox
          Left = 216
          Top = 88
          Caption = #26174#31034#37038#31665#22320#22336#23383#27573
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 8
        end
        object EditRegIDMailReq: TcxCheckBox
          Left = 359
          Top = 88
          Caption = #37038#31665#22320#22336#23383#27573#24517#39035#36755#20837
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 9
        end
        object EditRegIDShowQQ: TcxCheckBox
          Left = 216
          Top = 112
          Caption = #26174#31034'QQ'#23383#27573
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 10
        end
        object EditRegIDQQReq: TcxCheckBox
          Left = 359
          Top = 112
          Caption = 'QQ'#23383#27573#24517#39035#36755#20837
          Enabled = False
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 11
        end
        object EditRegIDShowID: TcxCheckBox
          Left = 216
          Top = 136
          Caption = #26174#31034#36523#20221#35777#21495#30721#23383#27573
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 12
        end
        object EditRegIDIDReq: TcxCheckBox
          Left = 359
          Top = 136
          Caption = #36523#20221#35777#21495#30721#23383#27573#24517#39035#36755#20837
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 13
        end
        object EditRegIDShowMobile: TcxCheckBox
          Left = 216
          Top = 159
          Caption = #26174#31034#25163#26426#21495#30721#23383#27573
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 14
        end
        object EditRegIDMobileReq: TcxCheckBox
          Left = 359
          Top = 159
          Caption = #25163#26426#21495#30721#23383#27573#24517#39035#36755#20837
          Properties.OnChange = EditLoginZIPPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 15
        end
      end
    end
    object TabSheetClientStyle: TcxTabSheet
      Caption = #21015#34920#25480#26435#35774#32622
      ImageIndex = 5
      object GroupBoxLisence: TGroupBox
        Left = 8
        Top = 9
        Width = 249
        Height = 96
        Caption = #25480#26435#20449#24687
        TabOrder = 0
        object DateEditLisence: TcxDateEdit
          Left = 76
          Top = 47
          Properties.InputKind = ikRegExpr
          Properties.MaxDate = 73050.000000000000000000
          Properties.Nullstring = '1999-01-01'
          Properties.ReadOnly = False
          Properties.OnChange = CheckMiniResSrvPropertiesChange
          TabOrder = 0
          Width = 121
        end
        object cxLabel1: TcxLabel
          Left = 12
          Top = 49
          AutoSize = False
          Caption = #21040#26399#26102#38388
          Height = 17
          Width = 52
        end
        object CheckBoxUseLisence: TcxCheckBox
          Left = 8
          Top = 20
          Caption = #21551#29992#25480#26435
          Properties.OnChange = CheckMiniResSrvPropertiesChange
          Style.BorderStyle = ebsFlat
          TabOrder = 2
        end
      end
    end
  end
  object Panel: TPanel
    AlignWithMargins = True
    Left = 8
    Top = 26
    Width = 755
    Height = 125
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel'
    ShowCaption = False
    TabOrder = 5
    object LabelHomeUrl: TcxLabel
      Left = 0
      Top = 10
      Caption = #20027#39029#32593#22336
    end
    object LabelContactUrl: TcxLabel
      Left = 0
      Top = 34
      Caption = #32852#31995#26041#24335#32593#22336
    end
    object LabelPayUrl: TcxLabel
      Left = 0
      Top = 58
      Caption = #20805#20540#32593#22336
    end
    object LabelInnerUrl: TcxLabel
      Left = 0
      Top = 82
      Caption = #30331#38470#22120#20869#23884#32593#39029#22320#22336
    end
    object heHome: TcxHyperLinkEdit
      Left = 129
      Top = 8
      ParentShowHint = False
      Properties.OnChange = heHomePropertiesChange
      ShowHint = True
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 0
      Width = 626
    end
    object heContact: TcxHyperLinkEdit
      Left = 129
      Top = 32
      ParentShowHint = False
      Properties.OnChange = heHomePropertiesChange
      ShowHint = True
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 1
      Width = 626
    end
    object hePayUrl: TcxHyperLinkEdit
      Left = 129
      Top = 56
      ParentShowHint = False
      Properties.OnChange = heHomePropertiesChange
      ShowHint = True
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 2
      Width = 626
    end
    object heLogin: TcxHyperLinkEdit
      Left = 129
      Top = 80
      ParentShowHint = False
      Properties.OnChange = heHomePropertiesChange
      ShowHint = True
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 3
      Width = 626
    end
    object LabelResDir: TcxLabel
      Left = 0
      Top = 106
      Caption = #36164#28304#25991#20214#22841#21517#31216
    end
    object edtDir: TcxTextEdit
      Left = 129
      Top = 104
      ParentShowHint = False
      Properties.OnChange = heHomePropertiesChange
      ShowHint = True
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 4
      TextHint = #22312#23458#25143#31471#19987#23646#36164#28304#25991#20214#20648#23384#20301#32622#65292#40664#35748#20026#8220'Resource\'#8221
      Width = 626
    end
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft YaHei UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    LookAndFeel.NativeStyle = True
    PopupMenuLinks = <>
    Style = bmsFlat
    UseF10ForMenu = False
    UseSystemFont = True
    Left = 472
    Top = 64
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      26
      0)
    object ToolBar: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = #24037#20855#26639
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 1289
      FloatTop = 203
      FloatClientWidth = 75
      FloatClientHeight = 178
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BtnNew'
        end
        item
          Visible = True
          ItemName = 'BtnOpen'
        end
        item
          Visible = True
          ItemName = 'BtnSave'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnClose'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object BarManagerBar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockControl = dxBarDockControl1
      DockedDockControl = dxBarDockControl1
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 795
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BtnSLAdd'
        end
        item
          Visible = True
          ItemName = 'BtnSLDel'
        end
        item
          Visible = True
          ItemName = 'BtnSLEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnSLMoveUp'
        end
        item
          Visible = True
          ItemName = 'BtnSLMoveDown'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object BarManagerBar2: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'Custom 2'
      CaptionButtons = <>
      DockControl = dxBarDockControl2
      DockedDockControl = dxBarDockControl2
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 795
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BtnULAdd'
        end
        item
          Visible = True
          ItemName = 'BtnULDel'
        end
        item
          Visible = True
          ItemName = 'BtnULEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnULMoveUp'
        end
        item
          Visible = True
          ItemName = 'BtnULMoveDown'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnULTestDown'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object BarManagerBar3: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'Custom 3'
      CaptionButtons = <>
      DockControl = dxBarDockControl3
      DockedDockControl = dxBarDockControl3
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 795
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BtnSEAdd'
        end
        item
          Visible = True
          ItemName = 'BtnSEDel'
        end
        item
          Visible = True
          ItemName = 'BtnSEEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnSEMoveUp'
        end
        item
          Visible = True
          ItemName = 'BtnSEMoveDown'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object BtnOpen: TdxBarButton
      Caption = #25171#24320
      Category = 0
      Hint = #25171#24320
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFF0274ACFF0274
        ACFF0274ACFF0274ACFF0274ACFF0274ACFF0274ACFF0274ACFF0274ACFF0274
        ACFF0274ACFF0274ACFF0274ACFFFF00FFFFFF00FFFF0274ACFF48BCF6FF0274
        ACFF8CD8FAFF4BBFF7FF4ABFF6FF4ABFF7FF4ABFF7FF4ABFF6FF4ABFF7FF4ABF
        F6FF4BBFF6FF2398CCFF97E0F2FF0274ACFFFF00FFFF0274ACFF4FC4F7FF0274
        ACFF92DDFBFF54C7F8FF54C7F7FF53C7F8FF54C7F7FF54C7F8FF54C7F8FF54C7
        F8FF53C7F7FF279DCEFF9DE3F2FF0274ACFFFF00FFFF0274ACFF57CAF8FF0274
        ACFF99E3FBFF5ED1FAFF5ED1FAFF5ED1FAFF5ED1FAFF5ED1FAFF5FD1FAFF5ED1
        F8FF5ED1F8FF2CA1CEFFA3E9F3FF0274ACFFFF00FFFF0274ACFF5ED3FAFF0274
        ACFFA1E9FCFF69DCFAFF2C9D67FF036908FF04740AFF2C9C67FF5ED0E2FF69DC
        FAFF6ADDFBFF2FA6CFFFA9EEF3FF0274ACFFFF00FFFF0274ACFF67D9F7FF0274
        ABFFA7EFFCFF74E5FBFF74E5FBFF39AC7EFF057F0BFF04800BFF157F2EFF70E2
        F6FF74E5FBFF33A9CFFFACF0F4FF0274ACFFFF00FFFF0274ACFF6FE3FAFF0274
        ABFFFFFFFFFFBAF4FEFFB8F4FEFFBAF4FEFF58B27EFF05860DFF047E0AFF1E81
        2DFFB8F4FEFF83C9E0FFD4F7FAFF0274ACFFFF00FFFF0274ACFF7AEBFEFF0274
        ACFF0274ACFF0274ACFF0274ACFF0274ACFF026C70FF05830CFF06910DFF0368
        11FF02709AFF0274ACFF0274ACFF0274ACFFFF00FFFF0274ACFF83F2FEFF82F3
        FEFF82F3FEFF83F2FCFF83F3FEFF82F3FEFF5BC7B0FF0A8014FF0A9A14FF047B
        0BFF49B591FF036FA7FFFF00FFFFFF00FFFFFF00FFFF0274ACFFFEFEFEFF89FA
        FFFF89FAFEFF89FAFEFF8AF8FEFF8AFAFEFF6CD9C9FF0F871FFF13A926FF098E
        12FF2D9754FF036FA7FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF0274ACFFFEFE
        FEFF8FFEFFFF046B0BFF046B0BFF046B0BFF046B0BFF15932AFF1FB538FF12A1
        23FF046B0BFF046B0BFF046B0BFF046B0BFFFF00FFFFFF00FFFFFF00FFFF0274
        ACFF0274ACFF027399FF046B0BFF107D1DFF36CE60FF32C95AFF27BC47FF1DB0
        36FF14A527FF098713FF046B0BFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFF046B0BFF1D9935FF41DE75FF35CC5DFF2BC2
        4DFF1AA732FF046B0BFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF046B0BFF27AC45FF46E37AFF35CA
        5CFF046B0BFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF046B0BFF2DB851FF046B
        0BFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF046B0BFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF}
      OnClick = BtnOpenClick
    end
    object dxBarButton2: TdxBarButton
      Caption = #20445#23384
      Category = 0
      Hint = #20445#23384
      Visible = ivAlways
    end
    object BtnSave: TdxBarButton
      Caption = #20445#23384
      Category = 0
      Enabled = False
      Hint = #20445#23384
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF7F2B
        28FF7F2B28FFA18283FFA18283FFA18283FFA18283FFA18283FFA18283FFA182
        83FF7A1C1CFF7F2B28FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF7F2B28FFCA4D
        4DFFB64545FFDDD4D5FF791617FF791617FFDCE0E0FFD7DADEFFCED5D7FFBDBA
        BDFF76100FFF9A2D2DFF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFC24A
        4BFFB14444FFE2D9D9FF791617FF791617FFD9D8DAFFD9DEE1FFD3D9DCFFC1BD
        C1FF761111FF982D2DFF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFC24A
        4AFFB04242FFE6DCDCFF791617FF791617FFD5D3D5FFD8DEE1FFD7DDE0FFC6C2
        C5FF700F0FFF962C2CFF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFC24A
        4AFFB04141FFEADEDEFFE7DDDDFFDDD4D5FFD7D3D5FFD5D7D9FFD7D8DAFFCAC2
        C5FF7E1717FF9E3131FF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFBF47
        48FFB84545FFBA4C4CFFBD5757FFBB5756FFB64E4EFFB44949FFBD5251FFBB4B
        4CFFB54242FFBF4A4AFF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFA33B
        39FFB1605DFFC68684FFCB918FFFCC9190FFCC908FFFCB8988FFC98988FFCB93
        91FFCC9696FFBD4B4CFF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFBD4B
        4CFFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFBD4B4CFF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFBD4B
        4CFFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFBD4B4CFF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFBD4B
        4CFFF7F7F7FFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBF
        BFFFF7F7F7FFBD4B4CFF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFBD4B
        4CFFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFBD4B4CFF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFBD4B
        4CFFF7F7F7FFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBF
        BFFFF7F7F7FFBD4B4CFF7F2B28FFFF00FFFFFF00FFFFFF00FFFF7F2B28FFBD4B
        4CFFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFBD4B4CFF7F2B28FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF7F2B
        28FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FF7F2B28FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF}
      OnClick = BtnSaveClick
    end
    object BtnClose: TdxBarButton
      Caption = #20851#38381
      Category = 0
      Hint = #20851#38381
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF9A6666FF693334FFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF9A6666FF9A6666FFB96666FFBB6868FF693334FFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF9A66
        66FF9A6666FFC66A6BFFD06A6BFFD26869FFC36869FF693334FF9A6666FF9A66
        66FF9A6666FF9A6666FF9A6666FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FFDE7374FFD77071FFD56F70FFD56D6EFFC76A6DFF693334FFFEA2A3FFFCAF
        B0FFFABCBDFFF9C5C6FFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FFE07778FFDB7576FFDA7475FFDA7273FFCC6E71FF693334FF39C565FF25CF
        63FF29CC63FF19CB5BFFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FFE57D7EFFE07A7BFFDF797AFFDF7778FFD07275FF693334FF42C468FF30CD
        67FF33CB67FF24CB60FFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FFEA8283FFE57F80FFE37D7EFFE68081FFD37476FF693334FF3DC264FF29CB
        63FF2FCA64FF20CA5EFFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FFF08788FFE98182FFEC9697FFFBDDDEFFD8888AFF693334FFB8E1ACFF6BDC
        89FF5DD580FF46D473FFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FFF58C8DFFEE8687FFF0999AFFFDDCDDFFDA888AFF693334FFFFF5D8FFFFFF
        E0FFFFFFDEFFECFDD4FFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FFFA9192FFF48E8FFFF28B8CFFF48C8DFFDC7F80FF693334FFFDF3D4FFFFFF
        DFFFFFFFDDFFFFFFE0FFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FFFE9798FFF99394FFF89293FFF99092FFE08585FF693334FFFDF3D4FFFFFF
        DFFFFFFFDDFFFFFFDFFFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FFFF9B9CFFFD9798FFFC9697FFFE9798FFE38889FF693334FFFDF3D4FFFFFF
        DFFFFFFFDDFFFFFFDFFFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FFFF9FA0FFFF9A9BFFFF999AFFFF9A9BFFE78C8DFF693334FFFDF3D4FFFFFF
        DFFFFFFFDDFFFFFFDFFFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFF9A66
        66FF9A6666FFE98E8FFFFE999AFFFF9D9EFFEB8F90FF693334FFFBF0D2FFFDFC
        DCFFFDFCDAFFFDFCDCFFF9C5C6FF9A6666FFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF9A6666FFB07172FFD78687FFDA8888FF693334FF9A6666FF9A66
        66FF9A6666FF9A6666FF9A6666FF9A6666FFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFF9A6666FF9A6666FF693334FFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF}
      OnClick = BtnCloseClick
    end
    object BtnNew: TdxBarButton
      Caption = #26032#24314
      Category = 0
      Hint = #26032#24314
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFA467
        69FFA46769FFA46769FFA46769FFA46769FFA46769FFA46769FFA46769FFA467
        69FFA46769FFA46769FFA46769FFA46769FFFF00FFFFFF00FFFFFF00FFFFB791
        84FFFEE9C7FFF4DAB5FFF3D5AAFFF2D0A0FFEFCB96FFEFC68BFFEDC182FFEBC1
        7FFFEBC180FFEBC180FFF2C782FFA46769FFFF00FFFFFF00FFFFFF00FFFFB791
        87FFFCEACEFFF3DABCFFF2D5B1FFF0D0A7FFEECB9EFFEDC793FFEDC28BFFE9BD
        81FFE9BD7FFFE9BD7FFFEFC481FFA46769FFFF00FFFFFF00FFFFFF00FFFFB793
        8AFFFEEFDAFFF6E0C6FFF2DABCFFF2D5B2FFEFD0A9FFEECB9EFFEDC796FFEBC2
        8CFFE9BD82FFE9BD7FFFEFC481FFA46769FFFF00FFFFFF00FFFFFF00FFFFBA97
        8FFFFFF4E5FFF7E5CFFFF4E0C5FFF3DABBFFF2D5B1FFF0D0A6FFEECB9EFFEDC7
        95FFEBC28AFFEABF81FFEFC480FFA46769FFFF00FFFFFF00FFFFFF00FFFFC09E
        95FFFFFBF0FFF8EADCFFF6E3CFFFF4E0C6FFF2D9BCFFF2D5B1FFF0D0A9FFEDCB
        9EFFEDC695FFEBC28AFFEFC583FFA46769FFFF00FFFFFF00FFFFFF00FFFFC6A4
        9AFFFFFFFCFFFAF0E6FFF8EADAFFF7E5CFFFF4E0C5FFF2DABAFFF2D5B1FFF0D0
        A7FFEECB9DFFEBC793FFF2C98CFFA46769FFFF00FFFFFF00FFFFFF00FFFFCBA9
        9EFFFFFFFFFFFEF7F2FFFAEFE6FFF8EAD9FFF7E3CFFFF6E0C5FFF2DABBFFF2D4
        B1FFF0D0A7FFEECC9EFFF3CE97FFA46769FFFF00FFFFFF00FFFFFF00FFFFCFAC
        9FFFFFFFFFFFFFFEFCFFFCF6F0FFFAEFE6FFF7EADAFFF6E3CFFFF4E0C5FFF3D9
        BBFFF3D4B0FFF0D0A6FFF6D3A0FFA46769FFFF00FFFFFF00FFFFFF00FFFFD4B0
        A1FFFFFFFFFFFFFFFFFFFFFEFCFFFEF7F0FFFAEFE5FFF8EAD9FFF7E5CEFFF6DE
        C4FFF3D9B8FFF4D8B1FFEBCFA4FFA46769FFFF00FFFFFF00FFFFFF00FFFFD9B5
        A1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFFFCF7F0FFFAEFE5FFF8E9D9FFF8E7
        D1FFFBEACEFFDECEB4FFB6AA93FFA46769FFFF00FFFFFF00FFFFFF00FFFFDDB7
        A4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFFFCF6EFFFFCF3E6FFEDD8
        C9FFB68A7BFFA17B6FFF9C7667FFA46769FFFF00FFFFFF00FFFFFF00FFFFE2BC
        A5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFBFFFFFEF7FFDAC1
        BAFFAD735BFFE19E55FFE68F31FFB56D4DFFFF00FFFFFF00FFFFFF00FFFFE6BF
        A7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCC7
        C5FFB88265FFF8B55CFFBF7A5CFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFE4BC
        A4FFFBF4F0FFFBF4EFFFFAF3EFFFFAF3EFFFF8F2EFFFF7F2EFFFF7F2EFFFD8C2
        C0FFB77F62FFC1836CFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFE8C4
        ADFFEBCBB7FFEBCBB7FFEACBB7FFEACAB6FFEACAB6FFEACAB6FFEACAB6FFE3C2
        B1FFA56B5FFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF}
      OnClick = BtnNewClick
    end
    object BtnSLAdd: TdxBarButton
      Caption = #22686#21152
      Category = 0
      Enabled = False
      Hint = #22686#21152
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFCC6701FFCC6701FFD06A00FF9C3B0DFFFFCF92FFEBA45AFFDD882EFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9B390BFF9C3B0DFF9C3A0DFF9B3A0CFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFCC6701FFCC6701FFCC6701FF9C3B0DFFFFCF92FFEBA45AFFDD882EFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9B390BFF9C3B0DFF9C3A0DFF9B3A0CFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFCC6701FFCC6701FFCC6701FF9C3B0DFFFFCF92FFEBA45AFFDD882EFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9B390BFF9C3B0DFF9C3A0DFF9B3A0CFF9C3B
        0DFFFF00FFFF2C7E1AFF307C1AFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B
        0DFF9C3B0DFF9C3B0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF307F1CFF30801DFFFF00FFFFFF00FFFF9C3B0DFFFFCF92FFEBA4
        5AFFDD882EFF9C3B0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF2F81
        1EFF2C8D28FF2C912BFF2C8F2AFF2E8723FF307F1CFF9B390BFF9C3B0DFF9C3A
        0DFF9B3A0CFF9C3B0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF2F81
        1EFF2D8C28FF2B9630FF2C942FFF2E8622FF307F1CFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF2C922DFF2C922DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF2F8320FF2F8320FFFF00FFFFFF00FFFF}
      PaintStyle = psCaptionGlyph
      UnclickAfterDoing = False
      OnClick = BtnSLAddClick
    end
    object BtnSLDel: TdxBarButton
      Caption = #21024#38500
      Category = 0
      Enabled = False
      Hint = #21024#38500
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF842405FF842405FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFBD4C00FFBD4C00FFC24F00FF842405FFFFC179FFE58E40FFD36E1AFF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF832304FF842405FF842305FF832304FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF842405FF842405FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFBD4C00FFBD4C00FFBD4C00FF842405FFFFC179FFE58E40FFD36E1AFF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF832304FF842405FF842305FF832304FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF842405FF842405FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFBD4C00FFBD4C00FFBD4C00FF842405FFFFC179FFE58E40FFD36E1AFF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF832304FF842405FF842305FF832304FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF8424
        05FF842405FF842405FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FFFF00FFFF0000B5FF0000B5FF842405FFFFC179FFE58E
        40FFD36E1AFF842405FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FF0000B5FF0000B5FF0000B5FF832304FF842405FF8423
        05FF832304FF842405FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF0000B5FF0000B5FF0000B5FFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FF0000B5FF0000B5FF0000B5FFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FFFF00FFFF0000B5FF0000B5FF}
      PaintStyle = psCaptionGlyph
      UnclickAfterDoing = False
      OnClick = BtnSLDelClick
    end
    object BtnSLEdit: TdxBarButton
      Caption = #32534#36753
      Category = 0
      Enabled = False
      Hint = #32534#36753
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFB78183FFB78183FFB781
        83FFB78183FFB78183FFB78183FFB78183FFB78183FFB78183FFB78183FFB781
        83FFB78183FFB78183FFFF00FFFFFF00FFFFFF00FFFFB78183FFFDEFD9FFF4E1
        C9FFE4CFB4FFD1BCA0FFCDB798FFDAC09AFFE4C599FFE9C896FFEDCB96FFEECC
        97FFF3D199FFB78183FFFF00FFFFFF00FFFFFF00FFFFB48176FFFEF3E3FFF8E7
        D3FF494645FF373C3EFF516061FFAE9C82FFBFA889FFD0B48DFFE4C393FFEDCB
        96FFF3D199FFB78183FFFF00FFFFFF00FFFFFF00FFFFB48176FFFFF7EBFFF9EB
        DAFFB0A598FF1B617DFF097CA8FF18556FFF66625BFFA79479FFC5AC86FFDCBD
        8DFFEECD95FFB78183FFFF00FFFFFF00FFFFFF00FFFFBA8E85FFFFFCF4FFFAEF
        E4FFF2E5D6FF387286FF29799AFF8D787FFF956D6FFF795953FF9D8B73FFBAA3
        80FFD9BC8CFFB47F81FFFF00FFFFFF00FFFFFF00FFFFBA8E85FFFFFFFDFFFBF4
        ECFFFAEFE3FFA5B3B1FF7C7078FFE5A6A3FFC89292FFA47272FF765751FF9585
        6CFFAF9978FFA87779FFFF00FFFFFF00FFFFFF00FFFFCB9A82FFFFFFFFFFFEF9
        F5FFFBF3ECFFF4EBDFFF85787CFFEEB7B5FFDAA6A6FFC38E8EFF9E6E6EFF7356
        4FFF93836BFF996E6FFFFF00FFFFFF00FFFFFF00FFFFCB9A82FFFFFFFFFFFFFE
        FDFFFDF8F4FFFBF3ECFFF0E4D9FFA37978FFE9B5B5FFD9A5A5FFC48F8FFF9D6D
        6DFF775952FF8F6769FFFF00FFFFFF00FFFFFF00FFFFDCA887FFFFFFFFFFFFFF
        FFFFFFFEFDFFFEF9F4FFFBF3EBFFE8D9CEFF9E7473FFE8B5B5FFD8A4A4FFC18D
        8DFF9D6C6CFF7D5556FFFF00FFFFFF00FFFFFF00FFFFDCA887FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFEFDFFFDF9F4FFFBF3EBFFE0CFC5FFA17676FFECB9B9FFD6A2
        A2FFC68E8EFF965F5DFF585C60FFFF00FFFFFF00FFFFE3B18EFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFEFDFFFDF8F3FFFDF6ECFFDAC5BCFFAC8080FFF3BC
        BBFFA3878CFF3392B3FF19ADCCFF19ADCCFFFF00FFFFE3B18EFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFFFFFEF9FFE3CFC9FFAA7A71FFB278
        73FF469CBAFF0FCAF4FF00A4E6FF021EAAFF000099FFEDBD92FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4D4D2FFB8857AFFDCA7
        6AFF10A5CFFF04A8E6FF0936C9FF092CC3FF0318AEFFEDBD92FFFCF7F4FFFCF7
        F3FFFBF6F3FFFBF6F3FFFAF5F3FFF9F5F3FFF9F5F3FFE1D0CEFFB8857AFFCF9B
        86FFFF00FFFF077DCDFF4860F1FF204ADDFF0416AAFFEDBD92FFDCA887FFDCA8
        87FFDCA887FFDCA887FFDCA887FFDCA887FFDCA887FFDCA887FFB8857AFFFF00
        FFFFFF00FFFFFF00FFFF3E4BDBFF192DC4FFFF00FFFF}
      PaintStyle = psCaptionGlyph
      UnclickAfterDoing = False
      OnClick = BtnSLEditClick
    end
    object BtnSLMoveUp: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Enabled = False
      Hint = 'New Button'
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFF331400FF451B00FF572200FF572200FF471C00FF3616
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF491C00FF491C00FF803200FFA54100FFAA4200FFAA4200FFA74100FF8434
        00FF511F00FF511F00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF5923
        00FF6E2B00FFAF4400FFB14500FFAA4200FFA54100FFAA4200FFAA4200FFAF44
        00FFB14500FF702C00FF361600FFFF00FFFFFF00FFFFFF00FFFF592300FF7B30
        00FFC54D00FFB84800FFAA4200FFA54100FFE7CAAFFFFFFFFFFFC07231FFA741
        00FFAA4200FFB14500FF702C00FF511F00FFFF00FFFFFF00FFFF592300FFD453
        00FFCC5000FFBB4900FFAA4200FFA74100FFE7C9ACFFFFFFFFFFC07332FFA741
        00FFA74100FFAA4200FFB14500FF511F00FFFF00FFFF5F2500FFA03F00FFEB5C
        00FFCC5000FFB14500FFAC4300FFA74100FFE7C9ABFFFFFFFFFFC07231FFA741
        00FFA74100FFA74100FFAF4400FF843400FF451B00FF5F2500FFD75400FFEB5C
        00FFD45300FFBB5910FFAC4703FFAC4300FFE9C9ABFFFFFFFFFFC07231FFA741
        00FFB25711FFAC4A05FFAC4300FF9E3E00FF451B00FF772E00FFF66000FFF862
        00FFF86200FFFBE7D4FFEFB47EFFE35900FFF7CEA6FFFFFFFFFFBA6825FFC072
        30FFFBF7F2FFE1BA95FFAA4200FFAA4200FF4F1F00FF893500FFFF7813FFFF6A
        04FFFB6300FFFFF3E7FFFFFFFFFFFFB26FFFFFD3AAFFFFFFFFFFD59A66FFF4E7
        DAFFFFFFFFFFD9A77AFFAC4300FFAA4200FF572200FF893500FFFF8829FFFF80
        1EFFF05E00FFFC9742FFFFFAF4FFFFFEFCFFFFFAF6FFFFFEFCFFFEFBF8FFFFFF
        FFFFE2A670FFC44F01FFB84800FFA54100FF4B1D00FF893500FFFF801EFFFFAD
        67FFFF6400FFEE5D00FFFC923AFFFFF8F3FFFFFFFFFFFFFFFFFFFFFFFFFFEAAF
        79FFCF5200FFC54D00FFBB4900FF953A00FF4B1D00FFFF00FFFFE65A00FFFFC6
        93FFFF9842FFE15800FFEB5C00FFFC9138FFFFF6EEFFFFFFFFFFF3BD8CFFCF52
        00FFCA4F00FFC04B00FFC74E00FF752D00FFFF00FFFFFF00FFFFE65A00FFFF89
        2BFFFFDAB7FFFF9741FFF86200FFE95B00FFFB9E4FFFFED1A7FFE6670BFFD955
        00FFD45300FFD75400FFB44600FF752D00FFFF00FFFFFF00FFFFFF00FFFFC54D
        00FFFF9842FFFFE2C6FFFFBB7FFFFF8728FFFF750FFFFF6B05FFFF6E08FFFF6E
        08FFFF6701FFCA4F00FF702C00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF801EFFFF801EFFFFBA7DFFFFD5ADFFFFC591FFFFB574FFFFA558FFFF83
        23FFD75400FFD75400FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFE15800FFFF700AFFFF7D19FFFF7813FFFB6300FFB647
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF}
      UnclickAfterDoing = False
      OnClick = BtnSLMoveUpClick
    end
    object BtnSLMoveDown: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Enabled = False
      Hint = 'New Button'
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFF331400FF451B00FF572200FF572200FF471C00FF3616
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF491C00FF491C00FF803200FFA54100FFAA4200FFAA4200FFA74100FF8434
        00FF511F00FF511F00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF5923
        00FF6E2B00FFAF4400FFB14500FFAA4200FFA54100FFAA4200FFAA4200FFAF44
        00FFB14500FF702C00FF361600FFFF00FFFFFF00FFFFFF00FFFF592300FF7B30
        00FFC54D00FFB84800FFAA4200FFA54100FFCA884FFFE6C6A7FFAF500BFFA741
        00FFAA4200FFB14500FF702C00FF511F00FFFF00FFFFFF00FFFF592300FFD453
        00FFCC5000FFBB4900FFAA4200FFC27738FFFAF4EEFFFFFFFFFFDEB48CFFA942
        00FFA74100FFAA4200FFB14500FF511F00FFFF00FFFF5F2500FFA03F00FFEB5C
        00FFCC5000FFB14500FFC67A3AFFFCF7F3FFFFFFFFFFFFFFFFFFFFFFFFFFD9A6
        79FFA94200FFA74100FFAF4400FF843400FF451B00FF5F2500FFD75400FFEB5C
        00FFD45300FFCC8242FFFCF8F4FFFEFEFCFFFCFAF6FFFEFEFCFFFEFBF8FFFFFF
        FFFFD5A070FFA94401FFAC4300FF9E3E00FF451B00FF772E00FFF66000FFF862
        00FFF86200FFFEF2E7FFFFFFFFFFF2AD6FFFF7CFAAFFFFFFFFFFD19866FFF4E7
        DAFFFFFFFFFFD9A77AFFAA4200FFAA4200FF4F1F00FF893500FFFF7813FFFF6A
        04FFFB6300FFFFEAD4FFFFBB7EFFFF6400FFFFD1A6FFFFFFFFFFBF6A25FFC072
        30FFFBF7F2FFE1BA95FFAC4300FFAA4200FF572200FF893500FFFF8829FFFF80
        1EFFF05E00FFFB7410FFFB6703FFFB6300FFFCD3ABFFFFFFFFFFD77D31FFC54D
        00FFCA6011FFC65405FFB84800FFA54100FF4B1D00FF893500FFFF801EFFFFAD
        67FFFF6400FFEE5D00FFFB6300FFFB6300FFFED3ABFFFFFFFFFFE18031FFCF51
        00FFCF5100FFC54D00FFBB4900FF953A00FF4B1D00FFFF00FFFFE65A00FFFFC6
        93FFFF9842FFE15800FFEB5C00FFFB6300FFFED4ACFFFFFFFFFFE78332FFCF51
        00FFCA4F00FFC04B00FFC74E00FF752D00FFFF00FFFFFF00FFFFE65A00FFFF89
        2BFFFFDAB7FFFF9741FFF86200FFE95B00FFFED5AFFFFFFFFFFFEB8431FFD955
        00FFD45300FFD75400FFB44600FF752D00FFFF00FFFFFF00FFFFFF00FFFFC54D
        00FFFF9842FFFFE2C6FFFFBB7FFFFF8728FFFF750FFFFF6B05FFFF6E08FFFF6E
        08FFFF6701FFCA4F00FF702C00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF801EFFFF801EFFFFBA7DFFFFD5ADFFFFC591FFFFB574FFFFA558FFFF83
        23FFD75400FFD75400FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFE15800FFFF700AFFFF7D19FFFF7813FFFB6300FFB647
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF}
      UnclickAfterDoing = False
      OnClick = BtnSLMoveDownClick
    end
    object BtnULAdd: TdxBarButton
      Caption = #22686#21152
      Category = 0
      Enabled = False
      Hint = #22686#21152
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFCC6701FFCC6701FFD06A00FF9C3B0DFFFFCF92FFEBA45AFFDD882EFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9B390BFF9C3B0DFF9C3A0DFF9B3A0CFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFCC6701FFCC6701FFCC6701FF9C3B0DFFFFCF92FFEBA45AFFDD882EFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9B390BFF9C3B0DFF9C3A0DFF9B3A0CFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFCC6701FFCC6701FFCC6701FF9C3B0DFFFFCF92FFEBA45AFFDD882EFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9B390BFF9C3B0DFF9C3A0DFF9B3A0CFF9C3B
        0DFFFF00FFFF2C7E1AFF307C1AFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B
        0DFF9C3B0DFF9C3B0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF307F1CFF30801DFFFF00FFFFFF00FFFF9C3B0DFFFFCF92FFEBA4
        5AFFDD882EFF9C3B0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF2F81
        1EFF2C8D28FF2C912BFF2C8F2AFF2E8723FF307F1CFF9B390BFF9C3B0DFF9C3A
        0DFF9B3A0CFF9C3B0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF2F81
        1EFF2D8C28FF2B9630FF2C942FFF2E8622FF307F1CFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF2C922DFF2C922DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF2F8320FF2F8320FFFF00FFFFFF00FFFF}
      PaintStyle = psCaptionGlyph
      UnclickAfterDoing = False
      OnClick = BtnULAddClick
    end
    object BtnULDel: TdxBarButton
      Caption = #21024#38500
      Category = 0
      Enabled = False
      Hint = #21024#38500
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF842405FF842405FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFBD4C00FFBD4C00FFC24F00FF842405FFFFC179FFE58E40FFD36E1AFF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF832304FF842405FF842305FF832304FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF842405FF842405FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFBD4C00FFBD4C00FFBD4C00FF842405FFFFC179FFE58E40FFD36E1AFF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF832304FF842405FF842305FF832304FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF842405FF842405FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFBD4C00FFBD4C00FFBD4C00FF842405FFFFC179FFE58E40FFD36E1AFF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF832304FF842405FF842305FF832304FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF8424
        05FF842405FF842405FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FFFF00FFFF0000B5FF0000B5FF842405FFFFC179FFE58E
        40FFD36E1AFF842405FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FF0000B5FF0000B5FF0000B5FF832304FF842405FF8423
        05FF832304FF842405FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF0000B5FF0000B5FF0000B5FFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FF0000B5FF0000B5FF0000B5FFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FFFF00FFFF0000B5FF0000B5FF}
      PaintStyle = psCaptionGlyph
      UnclickAfterDoing = False
      OnClick = BtnULDelClick
    end
    object BtnULEdit: TdxBarButton
      Caption = #32534#36753
      Category = 0
      Enabled = False
      Hint = #32534#36753
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFB78183FFB78183FFB781
        83FFB78183FFB78183FFB78183FFB78183FFB78183FFB78183FFB78183FFB781
        83FFB78183FFB78183FFFF00FFFFFF00FFFFFF00FFFFB78183FFFDEFD9FFF4E1
        C9FFE4CFB4FFD1BCA0FFCDB798FFDAC09AFFE4C599FFE9C896FFEDCB96FFEECC
        97FFF3D199FFB78183FFFF00FFFFFF00FFFFFF00FFFFB48176FFFEF3E3FFF8E7
        D3FF494645FF373C3EFF516061FFAE9C82FFBFA889FFD0B48DFFE4C393FFEDCB
        96FFF3D199FFB78183FFFF00FFFFFF00FFFFFF00FFFFB48176FFFFF7EBFFF9EB
        DAFFB0A598FF1B617DFF097CA8FF18556FFF66625BFFA79479FFC5AC86FFDCBD
        8DFFEECD95FFB78183FFFF00FFFFFF00FFFFFF00FFFFBA8E85FFFFFCF4FFFAEF
        E4FFF2E5D6FF387286FF29799AFF8D787FFF956D6FFF795953FF9D8B73FFBAA3
        80FFD9BC8CFFB47F81FFFF00FFFFFF00FFFFFF00FFFFBA8E85FFFFFFFDFFFBF4
        ECFFFAEFE3FFA5B3B1FF7C7078FFE5A6A3FFC89292FFA47272FF765751FF9585
        6CFFAF9978FFA87779FFFF00FFFFFF00FFFFFF00FFFFCB9A82FFFFFFFFFFFEF9
        F5FFFBF3ECFFF4EBDFFF85787CFFEEB7B5FFDAA6A6FFC38E8EFF9E6E6EFF7356
        4FFF93836BFF996E6FFFFF00FFFFFF00FFFFFF00FFFFCB9A82FFFFFFFFFFFFFE
        FDFFFDF8F4FFFBF3ECFFF0E4D9FFA37978FFE9B5B5FFD9A5A5FFC48F8FFF9D6D
        6DFF775952FF8F6769FFFF00FFFFFF00FFFFFF00FFFFDCA887FFFFFFFFFFFFFF
        FFFFFFFEFDFFFEF9F4FFFBF3EBFFE8D9CEFF9E7473FFE8B5B5FFD8A4A4FFC18D
        8DFF9D6C6CFF7D5556FFFF00FFFFFF00FFFFFF00FFFFDCA887FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFEFDFFFDF9F4FFFBF3EBFFE0CFC5FFA17676FFECB9B9FFD6A2
        A2FFC68E8EFF965F5DFF585C60FFFF00FFFFFF00FFFFE3B18EFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFEFDFFFDF8F3FFFDF6ECFFDAC5BCFFAC8080FFF3BC
        BBFFA3878CFF3392B3FF19ADCCFF19ADCCFFFF00FFFFE3B18EFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFFFFFEF9FFE3CFC9FFAA7A71FFB278
        73FF469CBAFF0FCAF4FF00A4E6FF021EAAFF000099FFEDBD92FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4D4D2FFB8857AFFDCA7
        6AFF10A5CFFF04A8E6FF0936C9FF092CC3FF0318AEFFEDBD92FFFCF7F4FFFCF7
        F3FFFBF6F3FFFBF6F3FFFAF5F3FFF9F5F3FFF9F5F3FFE1D0CEFFB8857AFFCF9B
        86FFFF00FFFF077DCDFF4860F1FF204ADDFF0416AAFFEDBD92FFDCA887FFDCA8
        87FFDCA887FFDCA887FFDCA887FFDCA887FFDCA887FFDCA887FFB8857AFFFF00
        FFFFFF00FFFFFF00FFFF3E4BDBFF192DC4FFFF00FFFF}
      PaintStyle = psCaptionGlyph
      UnclickAfterDoing = False
      OnClick = BtnULEditClick
    end
    object BtnULMoveUp: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Enabled = False
      Hint = 'New Button'
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFF331400FF451B00FF572200FF572200FF471C00FF3616
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF491C00FF491C00FF803200FFA54100FFAA4200FFAA4200FFA74100FF8434
        00FF511F00FF511F00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF5923
        00FF6E2B00FFAF4400FFB14500FFAA4200FFA54100FFAA4200FFAA4200FFAF44
        00FFB14500FF702C00FF361600FFFF00FFFFFF00FFFFFF00FFFF592300FF7B30
        00FFC54D00FFB84800FFAA4200FFA54100FFE7CAAFFFFFFFFFFFC07231FFA741
        00FFAA4200FFB14500FF702C00FF511F00FFFF00FFFFFF00FFFF592300FFD453
        00FFCC5000FFBB4900FFAA4200FFA74100FFE7C9ACFFFFFFFFFFC07332FFA741
        00FFA74100FFAA4200FFB14500FF511F00FFFF00FFFF5F2500FFA03F00FFEB5C
        00FFCC5000FFB14500FFAC4300FFA74100FFE7C9ABFFFFFFFFFFC07231FFA741
        00FFA74100FFA74100FFAF4400FF843400FF451B00FF5F2500FFD75400FFEB5C
        00FFD45300FFBB5910FFAC4703FFAC4300FFE9C9ABFFFFFFFFFFC07231FFA741
        00FFB25711FFAC4A05FFAC4300FF9E3E00FF451B00FF772E00FFF66000FFF862
        00FFF86200FFFBE7D4FFEFB47EFFE35900FFF7CEA6FFFFFFFFFFBA6825FFC072
        30FFFBF7F2FFE1BA95FFAA4200FFAA4200FF4F1F00FF893500FFFF7813FFFF6A
        04FFFB6300FFFFF3E7FFFFFFFFFFFFB26FFFFFD3AAFFFFFFFFFFD59A66FFF4E7
        DAFFFFFFFFFFD9A77AFFAC4300FFAA4200FF572200FF893500FFFF8829FFFF80
        1EFFF05E00FFFC9742FFFFFAF4FFFFFEFCFFFFFAF6FFFFFEFCFFFEFBF8FFFFFF
        FFFFE2A670FFC44F01FFB84800FFA54100FF4B1D00FF893500FFFF801EFFFFAD
        67FFFF6400FFEE5D00FFFC923AFFFFF8F3FFFFFFFFFFFFFFFFFFFFFFFFFFEAAF
        79FFCF5200FFC54D00FFBB4900FF953A00FF4B1D00FFFF00FFFFE65A00FFFFC6
        93FFFF9842FFE15800FFEB5C00FFFC9138FFFFF6EEFFFFFFFFFFF3BD8CFFCF52
        00FFCA4F00FFC04B00FFC74E00FF752D00FFFF00FFFFFF00FFFFE65A00FFFF89
        2BFFFFDAB7FFFF9741FFF86200FFE95B00FFFB9E4FFFFED1A7FFE6670BFFD955
        00FFD45300FFD75400FFB44600FF752D00FFFF00FFFFFF00FFFFFF00FFFFC54D
        00FFFF9842FFFFE2C6FFFFBB7FFFFF8728FFFF750FFFFF6B05FFFF6E08FFFF6E
        08FFFF6701FFCA4F00FF702C00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF801EFFFF801EFFFFBA7DFFFFD5ADFFFFC591FFFFB574FFFFA558FFFF83
        23FFD75400FFD75400FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFE15800FFFF700AFFFF7D19FFFF7813FFFB6300FFB647
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF}
      UnclickAfterDoing = False
      OnClick = BtnULMoveUpClick
    end
    object BtnULMoveDown: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Enabled = False
      Hint = 'New Button'
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFF331400FF451B00FF572200FF572200FF471C00FF3616
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF491C00FF491C00FF803200FFA54100FFAA4200FFAA4200FFA74100FF8434
        00FF511F00FF511F00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF5923
        00FF6E2B00FFAF4400FFB14500FFAA4200FFA54100FFAA4200FFAA4200FFAF44
        00FFB14500FF702C00FF361600FFFF00FFFFFF00FFFFFF00FFFF592300FF7B30
        00FFC54D00FFB84800FFAA4200FFA54100FFCA884FFFE6C6A7FFAF500BFFA741
        00FFAA4200FFB14500FF702C00FF511F00FFFF00FFFFFF00FFFF592300FFD453
        00FFCC5000FFBB4900FFAA4200FFC27738FFFAF4EEFFFFFFFFFFDEB48CFFA942
        00FFA74100FFAA4200FFB14500FF511F00FFFF00FFFF5F2500FFA03F00FFEB5C
        00FFCC5000FFB14500FFC67A3AFFFCF7F3FFFFFFFFFFFFFFFFFFFFFFFFFFD9A6
        79FFA94200FFA74100FFAF4400FF843400FF451B00FF5F2500FFD75400FFEB5C
        00FFD45300FFCC8242FFFCF8F4FFFEFEFCFFFCFAF6FFFEFEFCFFFEFBF8FFFFFF
        FFFFD5A070FFA94401FFAC4300FF9E3E00FF451B00FF772E00FFF66000FFF862
        00FFF86200FFFEF2E7FFFFFFFFFFF2AD6FFFF7CFAAFFFFFFFFFFD19866FFF4E7
        DAFFFFFFFFFFD9A77AFFAA4200FFAA4200FF4F1F00FF893500FFFF7813FFFF6A
        04FFFB6300FFFFEAD4FFFFBB7EFFFF6400FFFFD1A6FFFFFFFFFFBF6A25FFC072
        30FFFBF7F2FFE1BA95FFAC4300FFAA4200FF572200FF893500FFFF8829FFFF80
        1EFFF05E00FFFB7410FFFB6703FFFB6300FFFCD3ABFFFFFFFFFFD77D31FFC54D
        00FFCA6011FFC65405FFB84800FFA54100FF4B1D00FF893500FFFF801EFFFFAD
        67FFFF6400FFEE5D00FFFB6300FFFB6300FFFED3ABFFFFFFFFFFE18031FFCF51
        00FFCF5100FFC54D00FFBB4900FF953A00FF4B1D00FFFF00FFFFE65A00FFFFC6
        93FFFF9842FFE15800FFEB5C00FFFB6300FFFED4ACFFFFFFFFFFE78332FFCF51
        00FFCA4F00FFC04B00FFC74E00FF752D00FFFF00FFFFFF00FFFFE65A00FFFF89
        2BFFFFDAB7FFFF9741FFF86200FFE95B00FFFED5AFFFFFFFFFFFEB8431FFD955
        00FFD45300FFD75400FFB44600FF752D00FFFF00FFFFFF00FFFFFF00FFFFC54D
        00FFFF9842FFFFE2C6FFFFBB7FFFFF8728FFFF750FFFFF6B05FFFF6E08FFFF6E
        08FFFF6701FFCA4F00FF702C00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF801EFFFF801EFFFFBA7DFFFFD5ADFFFFC591FFFFB574FFFFA558FFFF83
        23FFD75400FFD75400FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFE15800FFFF700AFFFF7D19FFFF7813FFFB6300FFB647
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF}
      UnclickAfterDoing = False
      OnClick = BtnULMoveDownClick
    end
    object BtnULTestDown: TdxBarButton
      Caption = #27979#35797#19979#36733
      Category = 0
      Enabled = False
      Hint = #27979#35797#19979#36733
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E0000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000020F10000E82A000006CC000000D1000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000250500007F0F00020E0FF0000306000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000002020000048600000547000000F1000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000710000051900007D2F000000C2000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000044040000EC3F00008D0FF0000384000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000091882A04070FFFF0000F0FF0006A8E000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000E43D2F090B0FFFF0008F0FF0000B6D000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000C3AC3D0B0C0FFFF4070FFFF0005B4C000000000000000000000
        0000000000000000000030160C3082461DA0684726D0805030FF50321DA02014
        0C40000000001E2A4E6026409CD00E34D2F00010384000000000000000000000
        004000000000200F0820E1703BF0D08030FF708830FFE07030FFB05830FF7045
        29E028190F500000001000000070000000000000000000000000000000500000
        00D0000000008C4B1DA0FF7840FFE0A040FF30A840FFB08030FFFF6030FF9068
        30FF482D1B9000000010000000F0000000500000000000000070000000D00000
        001000000000D07030FFFF9040FF508840FF30C040FFFF8840FFD07830FF40A8
        20FF59701DF00000000000000010000000D000000060000000F0000000700000
        000000000000B66937E050A850FF30C050FF50C050FFFF6840FF60B030FF20C0
        10FF59701DF0000000000000000000000060000000F000000020000000E00000
        006000000000688840D040C850FF40E060FF70F090FFE0B070FFFFA040FF60C8
        20FF366712900000000000000050000000E00000002000000000000000300000
        00B0000000001E1F153070A850FF60D870FF80FFA0FF80FFB0FF80A820FF59B4
        1DF00C19042000000000000000B0000000300000000000000000000000000000
        0020000000000000000021241B30587942B070B850FFA09050FF5A4C36901225
        06300000000000000000000000200000000000000000}
      PaintStyle = psCaptionGlyph
      UnclickAfterDoing = False
      OnClick = BtnULTestDownClick
    end
    object BtnSEAdd: TdxBarButton
      Caption = #22686#21152
      Category = 0
      Enabled = False
      Hint = #22686#21152
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFCC6701FFCC6701FFD06A00FF9C3B0DFFFFCF92FFEBA45AFFDD882EFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9B390BFF9C3B0DFF9C3A0DFF9B3A0CFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFCC6701FFCC6701FFCC6701FF9C3B0DFFFFCF92FFEBA45AFFDD882EFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9B390BFF9C3B0DFF9C3A0DFF9B3A0CFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B0DFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFCC6701FFCC6701FFCC6701FF9C3B0DFFFFCF92FFEBA45AFFDD882EFF9C3B
        0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFCC67
        01FFFF00FFFFFF00FFFFFF00FFFF9B390BFF9C3B0DFF9C3A0DFF9B3A0CFF9C3B
        0DFFFF00FFFF2C7E1AFF307C1AFFFF00FFFFFF00FFFF9C3B0DFF9C3B0DFF9C3B
        0DFF9C3B0DFF9C3B0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF307F1CFF30801DFFFF00FFFFFF00FFFF9C3B0DFFFFCF92FFEBA4
        5AFFDD882EFF9C3B0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF2F81
        1EFF2C8D28FF2C912BFF2C8F2AFF2E8723FF307F1CFF9B390BFF9C3B0DFF9C3A
        0DFF9B3A0CFF9C3B0DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF2F81
        1EFF2D8C28FF2B9630FF2C942FFF2E8622FF307F1CFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF2C922DFF2C922DFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF2F8320FF2F8320FFFF00FFFFFF00FFFF}
      PaintStyle = psCaptionGlyph
      UnclickAfterDoing = False
      OnClick = BtnSEAddClick
    end
    object BtnSEMoveDown: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Enabled = False
      Hint = 'New Button'
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFF331400FF451B00FF572200FF572200FF471C00FF3616
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF491C00FF491C00FF803200FFA54100FFAA4200FFAA4200FFA74100FF8434
        00FF511F00FF511F00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF5923
        00FF6E2B00FFAF4400FFB14500FFAA4200FFA54100FFAA4200FFAA4200FFAF44
        00FFB14500FF702C00FF361600FFFF00FFFFFF00FFFFFF00FFFF592300FF7B30
        00FFC54D00FFB84800FFAA4200FFA54100FFCA884FFFE6C6A7FFAF500BFFA741
        00FFAA4200FFB14500FF702C00FF511F00FFFF00FFFFFF00FFFF592300FFD453
        00FFCC5000FFBB4900FFAA4200FFC27738FFFAF4EEFFFFFFFFFFDEB48CFFA942
        00FFA74100FFAA4200FFB14500FF511F00FFFF00FFFF5F2500FFA03F00FFEB5C
        00FFCC5000FFB14500FFC67A3AFFFCF7F3FFFFFFFFFFFFFFFFFFFFFFFFFFD9A6
        79FFA94200FFA74100FFAF4400FF843400FF451B00FF5F2500FFD75400FFEB5C
        00FFD45300FFCC8242FFFCF8F4FFFEFEFCFFFCFAF6FFFEFEFCFFFEFBF8FFFFFF
        FFFFD5A070FFA94401FFAC4300FF9E3E00FF451B00FF772E00FFF66000FFF862
        00FFF86200FFFEF2E7FFFFFFFFFFF2AD6FFFF7CFAAFFFFFFFFFFD19866FFF4E7
        DAFFFFFFFFFFD9A77AFFAA4200FFAA4200FF4F1F00FF893500FFFF7813FFFF6A
        04FFFB6300FFFFEAD4FFFFBB7EFFFF6400FFFFD1A6FFFFFFFFFFBF6A25FFC072
        30FFFBF7F2FFE1BA95FFAC4300FFAA4200FF572200FF893500FFFF8829FFFF80
        1EFFF05E00FFFB7410FFFB6703FFFB6300FFFCD3ABFFFFFFFFFFD77D31FFC54D
        00FFCA6011FFC65405FFB84800FFA54100FF4B1D00FF893500FFFF801EFFFFAD
        67FFFF6400FFEE5D00FFFB6300FFFB6300FFFED3ABFFFFFFFFFFE18031FFCF51
        00FFCF5100FFC54D00FFBB4900FF953A00FF4B1D00FFFF00FFFFE65A00FFFFC6
        93FFFF9842FFE15800FFEB5C00FFFB6300FFFED4ACFFFFFFFFFFE78332FFCF51
        00FFCA4F00FFC04B00FFC74E00FF752D00FFFF00FFFFFF00FFFFE65A00FFFF89
        2BFFFFDAB7FFFF9741FFF86200FFE95B00FFFED5AFFFFFFFFFFFEB8431FFD955
        00FFD45300FFD75400FFB44600FF752D00FFFF00FFFFFF00FFFFFF00FFFFC54D
        00FFFF9842FFFFE2C6FFFFBB7FFFFF8728FFFF750FFFFF6B05FFFF6E08FFFF6E
        08FFFF6701FFCA4F00FF702C00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF801EFFFF801EFFFFBA7DFFFFD5ADFFFFC591FFFFB574FFFFA558FFFF83
        23FFD75400FFD75400FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFE15800FFFF700AFFFF7D19FFFF7813FFFB6300FFB647
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF}
      UnclickAfterDoing = False
      OnClick = BtnSEMoveDownClick
    end
    object BtnSEDel: TdxBarButton
      Caption = #21024#38500
      Category = 0
      Enabled = False
      Hint = #21024#38500
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF842405FF842405FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFBD4C00FFBD4C00FFC24F00FF842405FFFFC179FFE58E40FFD36E1AFF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF832304FF842405FF842305FF832304FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF842405FF842405FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFBD4C00FFBD4C00FFBD4C00FF842405FFFFC179FFE58E40FFD36E1AFF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF832304FF842405FF842305FF832304FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF842405FF842405FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFBD4C00FFBD4C00FFBD4C00FF842405FFFFC179FFE58E40FFD36E1AFF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFBD4C
        00FFFF00FFFFFF00FFFFFF00FFFF832304FF842405FF842305FF832304FF8424
        05FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF842405FF842405FF8424
        05FF842405FF842405FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FFFF00FFFF0000B5FF0000B5FF842405FFFFC179FFE58E
        40FFD36E1AFF842405FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FF0000B5FF0000B5FF0000B5FF832304FF842405FF8423
        05FF832304FF842405FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFF0000B5FF0000B5FF0000B5FFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FF0000B5FF0000B5FF0000B5FFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF0000B5FF0000B5FFFF00FFFF0000B5FF0000B5FF}
      PaintStyle = psCaptionGlyph
      UnclickAfterDoing = False
      OnClick = BtnSEDelClick
    end
    object BtnSEEdit: TdxBarButton
      Caption = #32534#36753
      Category = 0
      Enabled = False
      Hint = #32534#36753
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFB78183FFB78183FFB781
        83FFB78183FFB78183FFB78183FFB78183FFB78183FFB78183FFB78183FFB781
        83FFB78183FFB78183FFFF00FFFFFF00FFFFFF00FFFFB78183FFFDEFD9FFF4E1
        C9FFE4CFB4FFD1BCA0FFCDB798FFDAC09AFFE4C599FFE9C896FFEDCB96FFEECC
        97FFF3D199FFB78183FFFF00FFFFFF00FFFFFF00FFFFB48176FFFEF3E3FFF8E7
        D3FF494645FF373C3EFF516061FFAE9C82FFBFA889FFD0B48DFFE4C393FFEDCB
        96FFF3D199FFB78183FFFF00FFFFFF00FFFFFF00FFFFB48176FFFFF7EBFFF9EB
        DAFFB0A598FF1B617DFF097CA8FF18556FFF66625BFFA79479FFC5AC86FFDCBD
        8DFFEECD95FFB78183FFFF00FFFFFF00FFFFFF00FFFFBA8E85FFFFFCF4FFFAEF
        E4FFF2E5D6FF387286FF29799AFF8D787FFF956D6FFF795953FF9D8B73FFBAA3
        80FFD9BC8CFFB47F81FFFF00FFFFFF00FFFFFF00FFFFBA8E85FFFFFFFDFFFBF4
        ECFFFAEFE3FFA5B3B1FF7C7078FFE5A6A3FFC89292FFA47272FF765751FF9585
        6CFFAF9978FFA87779FFFF00FFFFFF00FFFFFF00FFFFCB9A82FFFFFFFFFFFEF9
        F5FFFBF3ECFFF4EBDFFF85787CFFEEB7B5FFDAA6A6FFC38E8EFF9E6E6EFF7356
        4FFF93836BFF996E6FFFFF00FFFFFF00FFFFFF00FFFFCB9A82FFFFFFFFFFFFFE
        FDFFFDF8F4FFFBF3ECFFF0E4D9FFA37978FFE9B5B5FFD9A5A5FFC48F8FFF9D6D
        6DFF775952FF8F6769FFFF00FFFFFF00FFFFFF00FFFFDCA887FFFFFFFFFFFFFF
        FFFFFFFEFDFFFEF9F4FFFBF3EBFFE8D9CEFF9E7473FFE8B5B5FFD8A4A4FFC18D
        8DFF9D6C6CFF7D5556FFFF00FFFFFF00FFFFFF00FFFFDCA887FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFEFDFFFDF9F4FFFBF3EBFFE0CFC5FFA17676FFECB9B9FFD6A2
        A2FFC68E8EFF965F5DFF585C60FFFF00FFFFFF00FFFFE3B18EFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFEFDFFFDF8F3FFFDF6ECFFDAC5BCFFAC8080FFF3BC
        BBFFA3878CFF3392B3FF19ADCCFF19ADCCFFFF00FFFFE3B18EFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFFFFFEF9FFE3CFC9FFAA7A71FFB278
        73FF469CBAFF0FCAF4FF00A4E6FF021EAAFF000099FFEDBD92FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4D4D2FFB8857AFFDCA7
        6AFF10A5CFFF04A8E6FF0936C9FF092CC3FF0318AEFFEDBD92FFFCF7F4FFFCF7
        F3FFFBF6F3FFFBF6F3FFFAF5F3FFF9F5F3FFF9F5F3FFE1D0CEFFB8857AFFCF9B
        86FFFF00FFFF077DCDFF4860F1FF204ADDFF0416AAFFEDBD92FFDCA887FFDCA8
        87FFDCA887FFDCA887FFDCA887FFDCA887FFDCA887FFDCA887FFB8857AFFFF00
        FFFFFF00FFFFFF00FFFF3E4BDBFF192DC4FFFF00FFFF}
      PaintStyle = psCaptionGlyph
      UnclickAfterDoing = False
      OnClick = BtnSEEditClick
    end
    object BtnSEMoveUp: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Enabled = False
      Hint = 'New Button'
      Visible = ivAlways
      Glyph.SourceDPI = 96
      Glyph.Data = {
        424D360400000000000036000000280000001000000010000000010020000000
        000000000000C40E0000C40E00000000000000000000FF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFF331400FF451B00FF572200FF572200FF471C00FF3616
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFF491C00FF491C00FF803200FFA54100FFAA4200FFAA4200FFA74100FF8434
        00FF511F00FF511F00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF5923
        00FF6E2B00FFAF4400FFB14500FFAA4200FFA54100FFAA4200FFAA4200FFAF44
        00FFB14500FF702C00FF361600FFFF00FFFFFF00FFFFFF00FFFF592300FF7B30
        00FFC54D00FFB84800FFAA4200FFA54100FFE7CAAFFFFFFFFFFFC07231FFA741
        00FFAA4200FFB14500FF702C00FF511F00FFFF00FFFFFF00FFFF592300FFD453
        00FFCC5000FFBB4900FFAA4200FFA74100FFE7C9ACFFFFFFFFFFC07332FFA741
        00FFA74100FFAA4200FFB14500FF511F00FFFF00FFFF5F2500FFA03F00FFEB5C
        00FFCC5000FFB14500FFAC4300FFA74100FFE7C9ABFFFFFFFFFFC07231FFA741
        00FFA74100FFA74100FFAF4400FF843400FF451B00FF5F2500FFD75400FFEB5C
        00FFD45300FFBB5910FFAC4703FFAC4300FFE9C9ABFFFFFFFFFFC07231FFA741
        00FFB25711FFAC4A05FFAC4300FF9E3E00FF451B00FF772E00FFF66000FFF862
        00FFF86200FFFBE7D4FFEFB47EFFE35900FFF7CEA6FFFFFFFFFFBA6825FFC072
        30FFFBF7F2FFE1BA95FFAA4200FFAA4200FF4F1F00FF893500FFFF7813FFFF6A
        04FFFB6300FFFFF3E7FFFFFFFFFFFFB26FFFFFD3AAFFFFFFFFFFD59A66FFF4E7
        DAFFFFFFFFFFD9A77AFFAC4300FFAA4200FF572200FF893500FFFF8829FFFF80
        1EFFF05E00FFFC9742FFFFFAF4FFFFFEFCFFFFFAF6FFFFFEFCFFFEFBF8FFFFFF
        FFFFE2A670FFC44F01FFB84800FFA54100FF4B1D00FF893500FFFF801EFFFFAD
        67FFFF6400FFEE5D00FFFC923AFFFFF8F3FFFFFFFFFFFFFFFFFFFFFFFFFFEAAF
        79FFCF5200FFC54D00FFBB4900FF953A00FF4B1D00FFFF00FFFFE65A00FFFFC6
        93FFFF9842FFE15800FFEB5C00FFFC9138FFFFF6EEFFFFFFFFFFF3BD8CFFCF52
        00FFCA4F00FFC04B00FFC74E00FF752D00FFFF00FFFFFF00FFFFE65A00FFFF89
        2BFFFFDAB7FFFF9741FFF86200FFE95B00FFFB9E4FFFFED1A7FFE6670BFFD955
        00FFD45300FFD75400FFB44600FF752D00FFFF00FFFFFF00FFFFFF00FFFFC54D
        00FFFF9842FFFFE2C6FFFFBB7FFFFF8728FFFF750FFFFF6B05FFFF6E08FFFF6E
        08FFFF6701FFCA4F00FF702C00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF801EFFFF801EFFFFBA7DFFFFD5ADFFFFC591FFFFB574FFFFA558FFFF83
        23FFD75400FFD75400FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
        FFFFFF00FFFFFF00FFFFE15800FFFF700AFFFF7D19FFFF7813FFFB6300FFB647
        00FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF}
      UnclickAfterDoing = False
      OnClick = BtnSEMoveUpClick
    end
  end
end
