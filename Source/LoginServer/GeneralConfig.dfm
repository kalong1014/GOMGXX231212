object frmGeneralConfig: TfrmGeneralConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #37197#32622
  ClientHeight = 260
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBoxNet: TGroupBox
    Left = 9
    Top = 9
    Width = 400
    Height = 112
    Caption = 'ODBC'#25968#25454#28304
    TabOrder = 0
    object lblGateIPad: TLabel
      Left = 13
      Top = 27
      Width = 24
      Height = 13
      Caption = 'DNS:'
    end
    object LabelServerIPaddr: TLabel
      Left = 13
      Top = 53
      Width = 15
      Height = 13
      Caption = 'ID:'
    end
    object Label1: TLabel
      Left = 13
      Top = 80
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object Label2: TLabel
      Left = 213
      Top = 80
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object Label3: TLabel
      Left = 213
      Top = 27
      Width = 57
      Height = 13
      Caption = 'DNS for PC:'
    end
    object Label4: TLabel
      Left = 213
      Top = 53
      Width = 15
      Height = 13
      Caption = 'ID:'
    end
    object EditDataSource: TEdit
      Left = 75
      Top = 23
      Width = 105
      Height = 21
      TabOrder = 0
      Text = 'Account'
    end
    object EditDataID: TEdit
      Left = 75
      Top = 49
      Width = 105
      Height = 21
      TabOrder = 1
      Text = 'sa'
    end
    object EditDataPass: TEdit
      Left = 75
      Top = 76
      Width = 105
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
      Text = 'sa'
    end
    object EditPCDataPass: TEdit
      Left = 276
      Top = 76
      Width = 105
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
      Text = 'sa'
    end
    object EditPCDataSource: TEdit
      Left = 276
      Top = 22
      Width = 105
      Height = 21
      TabOrder = 4
      Text = 'Account'
    end
    object EditPCDataID: TEdit
      Left = 276
      Top = 49
      Width = 105
      Height = 21
      TabOrder = 5
      Text = 'sa'
    end
  end
  object GroupBoxInfo: TGroupBox
    Left = 8
    Top = 127
    Width = 169
    Height = 114
    Caption = #31471#21475#37197#32622
    TabOrder = 1
    object Label5: TLabel
      Left = 13
      Top = 80
      Width = 55
      Height = 13
      Caption = 'Login Gate:'
    end
    object Label6: TLabel
      Left = 13
      Top = 53
      Width = 52
      Height = 13
      Caption = 'DB Server:'
    end
    object Label7: TLabel
      Left = 13
      Top = 27
      Width = 64
      Height = 13
      Caption = 'Check Server'
    end
    object EditCheckServerPort: TEdit
      Left = 83
      Top = 23
      Width = 60
      Height = 21
      TabOrder = 0
      Text = '3000'
    end
    object EditDBServerPort: TEdit
      Left = 83
      Top = 49
      Width = 60
      Height = 21
      TabOrder = 1
      Text = '5600'
    end
    object EditLoginGatePort: TEdit
      Left = 83
      Top = 76
      Width = 60
      Height = 21
      TabOrder = 2
      Text = '5500'
    end
  end
  object ButtonOK: TButton
    Left = 242
    Top = 207
    Width = 70
    Height = 27
    Caption = #30830#23450' (&O)'
    TabOrder = 2
    OnClick = ButtonOKClick
  end
  object CheckBoxMinimize: TCheckBox
    Left = 200
    Top = 137
    Width = 148
    Height = 19
    Caption = #21551#21160#21518#26368#23567#21270
    TabOrder = 3
    OnClick = CheckBoxMinimizeClick
  end
  object ButtonCel: TButton
    Left = 330
    Top = 207
    Width = 70
    Height = 27
    Caption = #21462#28040'(&C)'
    TabOrder = 4
    OnClick = ButtonCelClick
  end
end
