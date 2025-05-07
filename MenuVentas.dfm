object FormMenuVentas: TFormMenuVentas
  Left = 0
  Top = 0
  Caption = 'Men'#250' de ventas'
  ClientHeight = 245
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnAlbaranesVenta: TButton
    AlignWithMargins = True
    Left = 70
    Top = 30
    Width = 495
    Height = 73
    Margins.Left = 70
    Margins.Top = 30
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Albaranes de venta'
    TabOrder = 0
    OnClick = btnAlbaranesVentaClick
    ExplicitLeft = 65
    ExplicitTop = -19
  end
  object btnClientes: TButton
    AlignWithMargins = True
    Left = 70
    Top = 133
    Width = 495
    Height = 73
    Margins.Left = 70
    Margins.Top = 15
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Clientes'
    TabOrder = 1
    OnClick = btnClientesClick
    ExplicitLeft = 75
    ExplicitTop = 68
  end
end
