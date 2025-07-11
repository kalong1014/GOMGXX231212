object GateClientForm: TGateClientForm
  Left = 201
  Top = 116
  BorderStyle = bsNone
  Caption = 'Simple Gate Test Client'
  ClientHeight = 103
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PrintScale = poNone
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 147
    Height = 84
    TabOrder = 0
    OnMouseDown = InfoPanelMouseDown
    OnMouseMove = InfoPanelMouseMove
    OnMouseUp = InfoPanelMouseUp
    object shInput: TShape
      Left = 71
      Top = 0
      Width = 17
      Height = 17
      Brush.Color = clRed
      Pen.Width = 3
    end
    object shOutput: TShape
      Left = 71
      Top = 17
      Width = 17
      Height = 17
      Brush.Color = clRed
      Pen.Width = 3
    end
    object lblSendBuffSize: TLabel
      Left = 90
      Top = 19
      Width = 13
      Height = 13
      Caption = '0K'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      OnMouseDown = InfoPanelMouseDown
      OnMouseMove = InfoPanelMouseMove
      OnMouseUp = InfoPanelMouseUp
    end
    object lblRecvBufferSize: TLabel
      Left = 90
      Top = 2
      Width = 13
      Height = 13
      Caption = '0K'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      OnMouseDown = InfoPanelMouseDown
      OnMouseMove = InfoPanelMouseMove
      OnMouseUp = InfoPanelMouseUp
    end
    object btnCLR: TLabel
      Left = 104
      Top = 35
      Width = 42
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'CLR'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -10
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      OnClick = btnCLRClick
    end
    object btnClose: TLabel
      Left = 88
      Top = 0
      Width = 61
      Height = 34
      Alignment = taCenter
      AutoSize = False
      Caption = 'X'
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      OnClick = btnCloseClick
    end
    object btnLogIN: TSpeedButton
      Left = 0
      Top = 0
      Width = 37
      Height = 35
      Caption = 'GO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      OnClick = btnLogInClick
    end
    object btnSendFile: TSpeedButton
      Left = 36
      Top = 0
      Width = 35
      Height = 35
      Caption = 'SEND'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      OnClick = btnSendFileClick
    end
    object l_Groups: TLabel
      Left = 3
      Top = 37
      Width = 15
      Height = 12
      Caption = '0/0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      OnMouseDown = InfoPanelMouseDown
      OnMouseMove = InfoPanelMouseMove
      OnMouseUp = InfoPanelMouseUp
    end
    object l_Status3: TLabel
      Left = 68
      Top = 35
      Width = 33
      Height = 15
      Alignment = taRightJustify
      Caption = '0 KBit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      OnMouseDown = InfoPanelMouseDown
      OnMouseMove = InfoPanelMouseMove
      OnMouseUp = InfoPanelMouseUp
    end
    object InfoPanel: TPanel
      Left = 2
      Top = 51
      Width = 145
      Height = 33
      TabOrder = 0
      OnMouseDown = InfoPanelMouseDown
      OnMouseMove = InfoPanelMouseMove
      OnMouseUp = InfoPanelMouseUp
      object l_Status1: TLabel
        Left = 48
        Top = 1
        Width = 49
        Height = 14
        Caption = 'Logged OUT'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -10
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        OnMouseDown = InfoPanelMouseDown
        OnMouseMove = InfoPanelMouseMove
        OnMouseUp = InfoPanelMouseUp
      end
      object l_Status2: TLabel
        Left = 48
        Top = 17
        Width = 11
        Height = 14
        Caption = 'OK'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -10
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        OnMouseDown = InfoPanelMouseDown
        OnMouseMove = InfoPanelMouseMove
        OnMouseUp = InfoPanelMouseUp
      end
      object eYourID: TSpeedButton
        Left = -1
        Top = 0
        Width = 46
        Height = 18
        Caption = '999999'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -10
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = eYourIDClick
      end
      object eToID: TSpeedButton
        Left = -1
        Top = 17
        Width = 30
        Height = 16
        Caption = '>>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -10
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = eToIDClick
      end
      object btnReset: TSpeedButton
        Left = 27
        Top = 16
        Width = 18
        Height = 16
        Caption = 'R'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -10
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        OnClick = btnResetClick
      end
    end
  end
  object StatusUpdate: TTimer
    Enabled = False
    Interval = 250
    OnTimer = StatusUpdateTimer
    Left = 276
    Top = 52
  end
  object StartAnother: TTimer
    Enabled = False
    Interval = 100
    OnTimer = StartAnotherTimer
    Left = 242
    Top = 51
  end
  object udpServer: TRtcUdpServer
    ServerPort = '8888'
    UdpReuseAddr = True
    OnDataReceived = udpServerDataReceived
    Left = 158
    Top = 51
  end
  object udpClient: TRtcUdpClient
    ServerAddr = '255.255.255.255'
    ServerPort = '8888'
    UdpReuseAddr = True
    Left = 190
    Top = 51
  end
  object GateCli: TRtcHttpGateClient
    GateAddr = 'localhost'
    GatePort = '80'
    GateFileName = '/'
    StreamBlockSizeOut = 125000
    Left = 160
    Top = 8
  end
  object GCM: TRtcGateClientLink
    Client = GateCli
    BeforeLogIn = BeforeLogIN
    AfterLogIn = AfterLogIN
    AfterLoginFail = AfterLoginFail
    AfterLogOut = AfterLogOUT
    OnDataReceived = DataReceived
    OnInfoReceived = InfoReceived
    OnReadyToSend = ReadyToSend
    OnStreamReset = StreamReset
    Left = 192
    Top = 8
  end
end
