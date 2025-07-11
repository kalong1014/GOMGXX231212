object frmGeneralConfig: TfrmGeneralConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #37197#32622
  ClientHeight = 386
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 17
    Top = 19
    Width = 66
    Height = 13
    Caption = 'Server Name:'
  end
  object GroupBoxNet: TGroupBox
    Left = 9
    Top = 53
    Width = 400
    Height = 112
    Caption = 'ODBC'#25968#25454#28304
    TabOrder = 0
    object lblGateIPad: TLabel
      Left = 18
      Top = 27
      Width = 24
      Height = 13
      Caption = 'DNS:'
    end
    object LabelServerIPaddr: TLabel
      Left = 18
      Top = 53
      Width = 15
      Height = 13
      Caption = 'ID:'
    end
    object Label1: TLabel
      Left = 18
      Top = 80
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object Label2: TLabel
      Left = 218
      Top = 80
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object Label3: TLabel
      Left = 218
      Top = 27
      Width = 57
      Height = 13
      Caption = 'DNS for PC:'
    end
    object Label4: TLabel
      Left = 218
      Top = 53
      Width = 15
      Height = 13
      Caption = 'ID:'
    end
    object EditDataSource: TEdit
      Left = 80
      Top = 23
      Width = 105
      Height = 21
      TabOrder = 0
      Text = 'Account'
    end
    object EditDataID: TEdit
      Left = 80
      Top = 49
      Width = 105
      Height = 21
      TabOrder = 1
      Text = 'sa'
    end
    object EditDataPass: TEdit
      Left = 80
      Top = 76
      Width = 105
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
      Text = 'sa'
    end
    object EditDataPass2: TEdit
      Left = 281
      Top = 76
      Width = 105
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
      Text = 'sa'
    end
    object EditDataSource2: TEdit
      Left = 281
      Top = 22
      Width = 105
      Height = 21
      TabOrder = 4
      Text = 'Account'
    end
    object EditDataID2: TEdit
      Left = 281
      Top = 49
      Width = 105
      Height = 21
      TabOrder = 5
      Text = 'sa'
    end
  end
  object GroupBoxInfo: TGroupBox
    Left = 8
    Top = 171
    Width = 401
    Height = 162
    Caption = #31471#21475#37197#32622
    TabOrder = 1
    object Label5: TLabel
      Left = 13
      Top = 108
      Width = 57
      Height = 13
      Caption = 'SelChr Gate'
    end
    object Label6: TLabel
      Left = 13
      Top = 81
      Width = 62
      Height = 13
      Caption = 'Game Server'
    end
    object Label7: TLabel
      Left = 13
      Top = 27
      Width = 60
      Height = 13
      Caption = 'Login Server'
    end
    object Label8: TLabel
      Left = 13
      Top = 135
      Width = 62
      Height = 13
      Caption = 'Map Info File'
    end
    object EditLoginServerPort: TEdit
      Left = 83
      Top = 50
      Width = 60
      Height = 21
      TabOrder = 0
      Text = '5600'
    end
    object EditGameServerPort: TEdit
      Left = 83
      Top = 77
      Width = 60
      Height = 21
      TabOrder = 1
      Text = '6000'
    end
    object EditSelChrGatePort: TEdit
      Left = 83
      Top = 104
      Width = 60
      Height = 21
      TabOrder = 2
      Text = '5100'
    end
    object EditLoginServerAddr: TEdit
      Left = 83
      Top = 24
      Width = 105
      Height = 21
      TabOrder = 3
      Text = '127.0.0.1'
    end
    object EditMapInfoFilePath: TEdit
      Left = 81
      Top = 131
      Width = 232
      Height = 21
      TabOrder = 4
      Text = '..\M2Server\Envir'
    end
  end
  object ButtonOK: TButton
    Left = 243
    Top = 347
    Width = 70
    Height = 27
    Caption = #30830#23450' (&O)'
    TabOrder = 2
    OnClick = ButtonOKClick
  end
  object CheckBoxMinimize: TCheckBox
    Left = 21
    Top = 339
    Width = 148
    Height = 19
    Caption = #21551#21160#21518#26368#23567#21270
    TabOrder = 3
    OnClick = CheckBoxMinimizeClick
  end
  object ButtonCel: TButton
    Left = 325
    Top = 347
    Width = 70
    Height = 27
    Caption = #21462#28040'(&C)'
    TabOrder = 4
    OnClick = ButtonCelClick
  end
  object EditServerName: TEdit
    Left = 89
    Top = 16
    Width = 105
    Height = 21
    TabOrder = 5
    Text = #40857#30340#20256#35828
  end
end
