object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Men'#250' principal'
  ClientHeight = 465
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  PopupMenu = pm1
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
    Hint = 'Compras'
    Margins.Left = 70
    Margins.Top = 30
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Compras'
    TabOrder = 0
    OnClick = btnAlmacenClick
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
    OnClick = btnAlmacenClick
  end
  object stat1: TStatusBar
    Left = 0
    Top = 446
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
    ExplicitTop = 344
  end
  object btnAlmacen: TButton
    AlignWithMargins = True
    Left = 70
    Top = 339
    Width = 495
    Height = 73
    Margins.Left = 70
    Margins.Top = 15
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Almac'#233'n'
    TabOrder = 4
    OnClick = btnAlmacenClick
    ExplicitLeft = 78
    ExplicitTop = 244
  end
  object mm1: TMainMenu
    Left = 568
    Top = 24
    object Archivos1: TMenuItem
      Caption = 'Archivos'
      object Articulos1: TMenuItem
        Caption = '&Art'#237'culos'
        OnClick = ButtonArticulosClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Compras1: TMenuItem
        Caption = 'Compras'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Ventas1: TMenuItem
        Caption = 'Ventas'
      end
    end
  end
  object pm1: TPopupMenu
    Left = 576
    Top = 104
    object Artculos1: TMenuItem
      Caption = 'Art'#237'culos'
      OnClick = ButtonArticulosClick
    end
    object Compras2: TMenuItem
      Caption = 'Compras'
    end
    object Ventas2: TMenuItem
      Caption = 'Ventas'
    end
  end
  object aplctnvnts1: TApplicationEvents
    OnHint = aplctnvnts1Hint
    Left = 584
    Top = 176
  end
end
