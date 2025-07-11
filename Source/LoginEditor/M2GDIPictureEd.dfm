object cxGDIPictureEditor: TcxGDIPictureEditor
  Left = 295
  Top = 158
  BorderIcons = [biSystemMenu]
  Caption = 'Picture Editor'
  ClientHeight = 326
  ClientWidth = 368
  Color = clBtnFace
  Constraints.MinHeight = 220
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnPaint = FormPaint
  OnResize = FormResize
  DesignSize = (
    368
    326)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 287
    Width = 352
    Height = 4
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object btnCancel: TcxButton
    Left = 264
    Top = 297
    Width = 81
    Height = 22
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btnOk: TcxButton
    Left = 178
    Top = 296
    Width = 80
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnClear: TcxButton
    Left = 281
    Top = 65
    Width = 79
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'C&lear'
    TabOrder = 2
    OnClick = btnClearClick
  end
  object btnLoad: TcxButton
    Left = 282
    Top = 8
    Width = 79
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&Load...'
    TabOrder = 3
    OnClick = btnLoadClick
  end
  object btnSave: TcxButton
    Left = 282
    Top = 36
    Width = 79
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&Save...'
    TabOrder = 4
    OnClick = btnSaveClick
  end
  object Panel: TPanel
    Left = 8
    Top = 8
    Width = 268
    Height = 273
    BevelOuter = bvLowered
    Caption = 'Panel'
    TabOrder = 5
    object Image: TAdvGDIPPicture
      Left = 1
      Top = 1
      Width = 266
      Height = 271
      Center = True
      ImageTypes = []
      Align = alClient
      Version = '1.4.3.0'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 268
      ExplicitHeight = 273
    end
  end
end
