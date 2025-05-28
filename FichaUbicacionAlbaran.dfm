inherited FormFichaUbicacionAlbaran: TFormFichaUbicacionAlbaran
  BorderIcons = []
  Caption = 'FormFichaUbicacionAlbaran'
  ClientWidth = 777
  OnActivate = FormActivate
  ExplicitWidth = 783
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 13
  inherited shp: TShape
    Width = 777
    ExplicitWidth = 619
  end
  inherited shp1: TShape
    Width = 777
    ExplicitWidth = 619
  end
  inherited pnlBtns: TPanel
    Width = 777
    ExplicitWidth = 777
    inherited btnCancelar: TButton
      Left = 692
      Caption = 'Salir'
      TabOrder = 1
      ExplicitLeft = 692
    end
    inherited btnAceptar: TButton
      Left = 607
      TabOrder = 0
      OnClick = btnAceptarClick
      ExplicitLeft = 607
    end
  end
  inherited pnlObjects: TPanel
    Width = 777
    ExplicitWidth = 777
    inherited pnlFila: TPanel
      Width = 775
      ExplicitWidth = 775
      object pnlCantidad: TPanel
        AlignWithMargins = True
        Left = 611
        Top = 100
        Width = 149
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 4
        object lblCantidadUbicacion: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 139
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'Cantidad ubicaci'#243'n'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 132
        end
        object edtCantidad: TEdit
          AlignWithMargins = True
          Left = 15
          Top = 87
          Width = 119
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Alignment = taCenter
          NumbersOnly = True
          TabOrder = 0
          OnKeyPress = edtCantidadKeyPress
        end
      end
      object pnlFilas: TPanel
        AlignWithMargins = True
        Left = 307
        Top = 100
        Width = 137
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 2
        object lblFilas: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'N'#186' de fila'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 65
        end
        object cbbFila: TComboBox
          AlignWithMargins = True
          Left = 15
          Top = 87
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Style = csDropDownList
          TabOrder = 0
          OnChange = cbbFilaChange
        end
      end
      object pnlPasillo: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 100
        Width = 137
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 0
        object lblPasillo: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'Pasillo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 44
        end
        object cbbPasillo: TComboBox
          AlignWithMargins = True
          Left = 15
          Top = 87
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Style = csDropDownList
          TabOrder = 0
          OnChange = cbbPasilloChange
        end
      end
      object pnlSeccion: TPanel
        Tag = 1
        AlignWithMargins = True
        Left = 155
        Top = 100
        Width = 137
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 1
        object lblSeccion: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'Secci'#243'n'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 53
        end
        object cbbSeccion: TComboBox
          AlignWithMargins = True
          Left = 15
          Top = 87
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Style = csDropDownList
          TabOrder = 0
          OnChange = cbbSeccionChange
        end
      end
      object pnlFechaMov: TPanel
        AlignWithMargins = True
        Left = 459
        Top = 100
        Width = 137
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 3
        object lblFechaMov: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'Fecha mov'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 75
        end
        object dtpFecha: TDateTimePicker
          AlignWithMargins = True
          Left = 15
          Top = 87
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Date = 45791.320526504630000000
          Time = 45791.320526504630000000
          Enabled = False
          TabOrder = 0
        end
      end
      object pnlLabel: TPanel
        Left = 566
        Top = 240
        Width = 179
        Height = 97
        BevelOuter = bvNone
        Color = cl3DLight
        ParentBackground = False
        TabOrder = 5
        object lblRestante: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 62
          Width = 169
          Height = 16
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          Caption = 'Capacidad restante:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 115
        end
        object lblOcupado: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 36
          Width = 169
          Height = 16
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          Caption = 'Capacidad ocupada:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 116
        end
        object LabelTotal: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 10
          Width = 169
          Height = 16
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          Caption = 'Capacidad total:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 93
        end
      end
    end
  end
  inherited pnlTitle: TPanel
    Width = 771
    ExplicitWidth = 771
    object lblCantidad: TLabel
      AlignWithMargins = True
      Left = 522
      Top = 26
      Width = 197
      Height = 16
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 5
      BiDiMode = bdLeftToRight
      Caption = 'Cantidad restante por almacenar: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
    end
  end
  inherited pFIBQuery: TpFIBQuery
    SQL.Strings = (
      'INSERT INTO MOV_UBICACIONES ('
      '    NCODIGO,'
      '    CCOD_ARTICULO,'
      '    NPASILLO,'
      '    NSECCION,'
      '    NFILA,'
      '    NCANTIDAD,'
      '    DFECHA_MOVIMIENTO,'
      '    NCOD_ALB_COMPRA,'
      '    NCOD_ALB_VENTA'
      ') VALUES ('
      '    :NCODIGO,'
      '    :CCOD_ARTICULO,'
      '    :NPASILLO,'
      '    :NSECCION,'
      '    :NFILA,'
      '    :NCANTIDAD,'
      '    :DFECHA_MOVIMIENTO,'
      '    :NCOD_ALB_COMPRA,'
      '    :NCOD_ALB_VENTA'
      ')')
    Top = 72
  end
end
