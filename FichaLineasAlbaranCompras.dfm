inherited FormFichaLineasAlbaranCompras: TFormFichaLineasAlbaranCompras
  Caption = 'FormFichaLineasAlbaranCompras'
  ClientWidth = 788
  OnActivate = FormActivate
  OnCreate = FormCreate
  ExplicitWidth = 794
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 13
  inherited shp: TShape
    Width = 788
    ExplicitWidth = 809
  end
  inherited shp1: TShape
    Width = 788
    ExplicitWidth = 809
  end
  inherited pnlBtns: TPanel
    Width = 788
    ExplicitWidth = 788
    inherited btnCancelar: TButton
      Left = 703
      TabOrder = 1
      ExplicitLeft = 703
    end
    inherited btnAceptar: TButton
      Left = 618
      TabOrder = 0
      OnClick = btnAceptarClick
      ExplicitLeft = 618
    end
  end
  inherited pnlObjects: TPanel
    Width = 788
    ExplicitWidth = 788
    inherited pnlFila: TPanel
      Width = 786
      Height = 179
      ExplicitWidth = 786
      ExplicitHeight = 179
      inherited pnlCode: TPanel
        Top = 3
        Height = 173
        Margins.Top = 3
        Margins.Right = 5
        Margins.Bottom = 3
        Visible = False
        ExplicitTop = 3
        ExplicitHeight = 173
        inherited lblCodigo: TLabel
          Top = 15
          Width = 127
          Margins.Top = 15
          ExplicitTop = 15
        end
        inherited edtCodigo: TEdit
          Top = 112
          ExplicitTop = 112
        end
      end
      object pnlUnidadesPeso: TPanel
        AlignWithMargins = True
        Left = 440
        Top = 3
        Width = 137
        Height = 173
        Margins.Left = 5
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 3
        object lblUnidadesPeso: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 15
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 15
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'Peso/Ud'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 58
        end
        object medtUnidadesPeso: TMaskEdit
          AlignWithMargins = True
          Left = 15
          Top = 112
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Alignment = taCenter
          Enabled = False
          TabOrder = 0
          OnExit = medtUnidadesPesoExit
          OnKeyPress = medtUnidadesPesoKeyPress
        end
      end
      object pnlCodArticulo: TPanel
        AlignWithMargins = True
        Left = 150
        Top = 3
        Width = 137
        Height = 173
        Margins.Left = 5
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 1
        object lbllCodArticulo: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 15
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 15
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'C'#243'digo art'#237'culo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 106
        end
        object cbbCodArticulo: TComboBox
          AlignWithMargins = True
          Left = 15
          Top = 112
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Style = csDropDownList
          TabOrder = 0
          OnChange = cbbCodArticuloChange
        end
      end
      object pnlCajasPiezas: TPanel
        AlignWithMargins = True
        Left = 295
        Top = 3
        Width = 137
        Height = 173
        Margins.Left = 5
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 2
        object lblCajasPiezas: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 15
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 15
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'Pzas/Cajas'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 74
        end
        object medtCajasPiezas: TMaskEdit
          AlignWithMargins = True
          Left = 15
          Top = 112
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Alignment = taCenter
          Enabled = False
          TabOrder = 0
          OnExit = medtCajasPiezasExit
          OnKeyPress = medtCajasPiezasKeyPress
        end
      end
    end
    object pnlFila2: TPanel
      Left = 1
      Top = 179
      Width = 786
      Height = 179
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'pnlFila'
      ShowCaption = False
      TabOrder = 1
      object pnlPrecio: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 137
        Height = 173
        Margins.Right = 5
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 0
        object lblPrecio: TLabel
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
          Caption = 'Precio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 43
        end
        object medtPrecio: TMaskEdit
          AlignWithMargins = True
          Left = 15
          Top = 112
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Alignment = taCenter
          TabOrder = 0
          OnExit = medtPrecioExit
          OnKeyPress = medtPrecioKeyPress
        end
      end
      object pnlOrden: TPanel
        AlignWithMargins = True
        Left = 150
        Top = 3
        Width = 137
        Height = 173
        Margins.Left = 5
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 1
        Visible = False
        object lbllOrden: TLabel
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
          Caption = 'Orden'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 44
        end
        object edtOrden: TEdit
          AlignWithMargins = True
          Left = 15
          Top = 112
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 0
        end
      end
      object pnlIVA: TPanel
        AlignWithMargins = True
        Left = 295
        Top = 3
        Width = 137
        Height = 173
        Margins.Left = 5
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 2
        object lblIVA: TLabel
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
          Caption = 'IVA %'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 40
        end
        object edtIVA: TEdit
          AlignWithMargins = True
          Left = 15
          Top = 112
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 0
        end
      end
      object pnlRecargo: TPanel
        AlignWithMargins = True
        Left = 440
        Top = 3
        Width = 137
        Height = 173
        Margins.Left = 5
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 3
        object lblRecargo: TLabel
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
          Caption = 'Recargo %'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 74
        end
        object edtRecargo: TEdit
          AlignWithMargins = True
          Left = 15
          Top = 112
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
    object pnlSubTotal: TPanel
      Left = 623
      Top = 75
      Width = 137
      Height = 178
      Margins.Left = 100
      Margins.Right = 50
      Margins.Bottom = 50
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 2
      object lblSubTotal: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 40
        Width = 127
        Height = 21
        Margins.Left = 5
        Margins.Top = 40
        Margins.Right = 5
        Align = alTop
        Alignment = taCenter
        Caption = 'Subtotal/'#8364
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 73
      end
      object edtSubTotal: TEdit
        AlignWithMargins = True
        Left = 15
        Top = 117
        Width = 107
        Height = 21
        Margins.Left = 15
        Margins.Top = 40
        Margins.Right = 15
        Margins.Bottom = 40
        Align = alBottom
        Alignment = taCenter
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  inherited pnlTitle: TPanel
    Width = 782
    ExplicitWidth = 782
    object lblNombreProducto: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 7
      Width = 776
      Height = 34
      Margins.Top = 7
      Align = alClient
      Alignment = taCenter
      Caption = 'lblNombreProducto'
      ExplicitWidth = 272
      ExplicitHeight = 31
    end
    object lblDFactorConversion: TLabel
      Left = 617
      Top = 13
      Width = 21
      Height = 21
      Margins.Left = 5
      Margins.Top = 40
      Margins.Right = 5
      Caption = 'F.C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object edtFactorConversion: TEdit [5]
    Left = 661
    Top = 17
    Width = 84
    Height = 21
    Margins.Left = 15
    Margins.Top = 40
    Margins.Right = 15
    Margins.Bottom = 40
    TabStop = False
    Alignment = taCenter
    ReadOnly = True
    TabOrder = 3
  end
  inherited pFIBTransaction: TpFIBTransaction
    Left = 624
    Top = 344
  end
  inherited pFIBQuery: TpFIBQuery
    Left = 720
    Top = 352
  end
end
