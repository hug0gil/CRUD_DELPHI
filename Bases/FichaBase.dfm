object FormFichaBase: TFormFichaBase
  Left = 0
  Top = 0
  Caption = 'FormFichaBase'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Shape1: TShape
    Left = 0
    Top = 398
    Width = 624
    Height = 2
    Align = alBottom
    ExplicitTop = 399
  end
  object Panel1: TPanel
    Left = 0
    Top = 400
    Width = 624
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Button1: TButton
      AlignWithMargins = True
      Left = 457
      Top = 5
      Width = 75
      Height = 31
      Margins.Top = 5
      Margins.Right = 7
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Aceptar'
      TabOrder = 0
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 539
      Top = 5
      Width = 75
      Height = 31
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Cancelar'
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 64
    Top = 64
    Width = 145
    Height = 81
    BevelOuter = bvNone
    TabOrder = 1
    object LabelCodigo: TLabel
      AlignWithMargins = True
      Left = 50
      Top = 10
      Width = 92
      Height = 28
      Margins.Left = 50
      Margins.Top = 10
      Margins.Bottom = 1
      Align = alTop
      Caption = 'C'#243'digo'
      ExplicitLeft = 3
      ExplicitTop = 5
      ExplicitWidth = 227
    end
    object EditCodigo: TEdit
      AlignWithMargins = True
      Left = 5
      Top = 44
      Width = 135
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      TabOrder = 0
      ExplicitLeft = -11
    end
  end
end
