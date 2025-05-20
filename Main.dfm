object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Men'#250' principal'
  ClientHeight = 592
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonArticulos: TButton
    AlignWithMargins = True
    Left = 70
    Top = 236
    Width = 495
    Height = 73
    Hint = 'Art'#237'culos | Men'#250' de art'#237'culos'
    Margins.Left = 70
    Margins.Top = 15
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = #193'rticulos'
    TabOrder = 2
    OnClick = ButtonArticulosClick
  end
  object btnCompras: TButton
    AlignWithMargins = True
    Left = 70
    Top = 30
    Width = 495
    Height = 73
    Hint = 'Compras| Men'#250' de albaranes de compra y proveedores'
    Margins.Left = 70
    Margins.Top = 30
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Compras'
    TabOrder = 0
    OnClick = btnComprasClick
  end
  object btnVentas: TButton
    AlignWithMargins = True
    Left = 70
    Top = 133
    Width = 495
    Height = 73
    Hint = 'Ventas | Men'#250' de albaranes de venta y clientes'
    Margins.Left = 70
    Margins.Top = 15
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Ventas'
    TabOrder = 1
    OnClick = ButtonAlbaranventaClick
    ExplicitLeft = 75
  end
  object stat1: TStatusBar
    Left = 0
    Top = 573
    Width = 635
    Height = 19
    Panels = <
      item
        Text = 'Hugo'
        Width = 50
      end
      item
        Width = 50
      end>
    ExplicitTop = 533
  end
  object btnAlmacen: TButton
    AlignWithMargins = True
    Left = 70
    Top = 442
    Width = 495
    Height = 73
    Hint = 'Almac'#233'n | Mapa de almac'#233'n'
    Margins.Left = 70
    Margins.Top = 15
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Almac'#233'n'
    TabOrder = 4
    OnClick = btnAlmacenClick
  end
  object btnUbicaciones: TButton
    AlignWithMargins = True
    Left = 70
    Top = 339
    Width = 495
    Height = 73
    Hint = 'Ubicaciones | Men'#250' de ubicaciones'
    Margins.Left = 70
    Margins.Top = 15
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Ubicaciones'
    TabOrder = 5
    OnClick = btnUbicacionesClick
  end
  object aplctnvnts1: TApplicationEvents
    OnHint = aplctnvnts1Hint
    Left = 584
    Top = 176
  end
end
