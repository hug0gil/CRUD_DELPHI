inherited FormFichaAlmacen: TFormFichaAlmacen
  Caption = 'FormFichaAlmacen'
  ClientWidth = 638
  OnCreate = FormCreate
  ExplicitWidth = 644
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 13
  inherited shp: TShape
    Width = 638
    ExplicitWidth = 638
  end
  inherited shp1: TShape
    Width = 638
    ExplicitWidth = 638
  end
  object spl1: TSplitter [2]
    Left = 491
    Top = 49
    Height = 359
    Align = alRight
    ExplicitLeft = 486
    ExplicitTop = 50
  end
  inherited pnlBtns: TPanel
    Width = 638
    TabOrder = 1
    ExplicitWidth = 638
    inherited btnCancelar: TButton
      Left = 553
      TabOrder = 3
      ExplicitLeft = 553
    end
    inherited btnAceptar: TButton
      Left = 468
      OnClick = btnAceptarClick
      ExplicitLeft = 468
      ExplicitTop = 11
    end
    object stat1: TStatusBar
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 183
      Height = 26
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Panels = <
        item
          Text = 'Hugo'
          Width = 50
        end
        item
          Alignment = taCenter
          Width = 50
        end
        item
          Alignment = taCenter
          Width = 50
        end>
    end
    object btnReestablecer: TButton
      AlignWithMargins = True
      Left = 378
      Top = 10
      Width = 75
      Height = 26
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Reestablecer'
      TabOrder = 0
      OnClick = btnReestablecerClick
    end
  end
  inherited pnlObjects: TPanel
    Width = 491
    TabOrder = 2
    ExplicitWidth = 491
    inherited pnlFila: TPanel
      Width = 489
      ExplicitWidth = 489
      inherited pnlCode: TPanel
        inherited lblCodigo: TLabel
          Width = 127
        end
      end
    end
  end
  inherited pnlTitle: TPanel
    Width = 632
    TabOrder = 3
    ExplicitWidth = 632
  end
  object StringGrid: TStringGrid [6]
    AlignWithMargins = True
    Left = 3
    Top = 52
    Width = 485
    Height = 353
    Align = alClient
    Color = clGreen
    DefaultColWidth = 50
    DefaultRowHeight = 50
    DefaultDrawing = False
    FixedCols = 0
    FixedRows = 0
    PopupMenu = pm1
    TabOrder = 0
    OnDrawCell = StringGridDrawCell
    OnMouseDown = StringGridMouseDown
  end
  object pnlDatos: TPanel [7]
    Left = 494
    Top = 49
    Width = 144
    Height = 359
    Margins.Left = 10
    Margins.Top = 10
    Align = alRight
    TabOrder = 4
    Visible = False
    object lblPasillo: TLabel
      Left = 16
      Top = 48
      Width = 19
      Height = 16
      Caption = 'Pa:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblSeccion: TLabel
      Left = 88
      Top = 48
      Width = 26
      Height = 16
      Caption = 'Sec:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblNPasillo: TLabel
      Left = 41
      Top = 48
      Width = 7
      Height = 16
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblNSeccion: TLabel
      Left = 120
      Top = 48
      Width = 7
      Height = 16
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblNFilas: TLabel
      Left = 81
      Top = 80
      Width = 7
      Height = 16
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblFilas: TLabel
      Left = 44
      Top = 80
      Width = 31
      Height = 16
      Caption = 'Filas:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object strngrdFilas: TStringGrid
      Left = 32
      Top = 128
      Width = 89
      Height = 193
      ColCount = 1
      DefaultColWidth = 85
      FixedCols = 0
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goAlwaysShowEditor]
      PopupMenu = pmFilas
      TabOrder = 0
      OnDrawCell = strngrdFilasDrawCell
      OnKeyPress = strngrdFilasKeyPress
      OnMouseDown = strngrdFilasMouseDown
      OnSelectCell = strngrdFilasSelectCell
      OnSetEditText = strngrdFilasSetEditText
      RowHeights = (
        24
        24
        29
        24
        24)
    end
  end
  inherited pFIBTransaction: TpFIBTransaction
    Left = 512
    Top = 8
  end
  inherited pFIBQuery: TpFIBQuery
    Left = 448
    Top = 8
  end
  object pm1: TPopupMenu
    Left = 384
    Top = 8
    object Insertarcolumna1: TMenuItem
      Caption = 'Insertar columna'
      OnClick = Insertarcolumna1Click
    end
    object Eliminarcolumna1: TMenuItem
      Caption = 'Eliminar columna'
      OnClick = Eliminarcolumna1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Insertarfila1: TMenuItem
      Caption = 'Insertar fila'
      OnClick = Insertarfila1Click
    end
    object Eliminarfila1: TMenuItem
      Caption = 'Eliminar fila'
      OnClick = Eliminarfila1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MarcarComoEstanteria: TMenuItem
      Caption = 'Marcar como estanter'#237'a'
      OnClick = MarcarComoEstanteriaClick
    end
    object MarcarComoPasillo: TMenuItem
      Caption = 'Marcar como pasillo'
      OnClick = MarcarComoPasilloClick
    end
  end
  object pmMenu: TPopupMenu
    Left = 384
    Top = 8
    object MenuItem1: TMenuItem
      Caption = 'Insertar columna'
      OnClick = Insertarcolumna1Click
    end
    object MenuItem2: TMenuItem
      Caption = 'Eliminar columna'
      OnClick = Eliminarcolumna1Click
    end
    object MenuItem3: TMenuItem
      Caption = '-'
    end
    object MenuItem4: TMenuItem
      Caption = 'Insertar fila'
      OnClick = Insertarfila1Click
    end
    object MenuItem5: TMenuItem
      Caption = 'Eliminar fila'
      OnClick = Eliminarfila1Click
    end
    object MenuItem6: TMenuItem
      Caption = '-'
    end
    object MenuItem7: TMenuItem
      Caption = 'Marcar como estanter'#237'a'
      OnClick = MarcarComoEstanteriaClick
    end
    object MenuItem8: TMenuItem
      Caption = 'Marcar como pasillo'
      OnClick = MarcarComoPasilloClick
    end
  end
  object pmFilas: TPopupMenu
    Left = 584
    Top = 8
    object mniRecogidamanual: TMenuItem
      Caption = 'Recogida manual'
      RadioItem = True
      OnClick = mniRecogidamanualClick
    end
    object mniRecogidaMaquina: TMenuItem
      Caption = 'Recogida con m'#225'quina'
      Checked = True
      RadioItem = True
      OnClick = mniRecogidaMaquinaClick
    end
    object mniN3: TMenuItem
      Caption = '-'
    end
    object mniN51: TMenuItem
      Caption = '- 5'
      OnClick = mniN51Click
    end
    object mniN52: TMenuItem
      Caption = '+ 5'
      OnClick = mniN52Click
    end
    object mniReestablecerfila1: TMenuItem
      Caption = 'Reestablecer fila'
      OnClick = mniReestablecerfila1Click
    end
  end
end
