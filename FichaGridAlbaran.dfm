inherited FormFichaGridAlbaran: TFormFichaGridAlbaran
  Caption = 'FormFichaGridAlbaran'
  ClientHeight = 545
  ClientWidth = 847
  OnActivate = FormActivate
  ExplicitWidth = 863
  ExplicitHeight = 584
  PixelsPerInch = 96
  TextHeight = 13
  inherited Shape1: TShape
    Width = 847
    ExplicitWidth = 802
  end
  inherited Shape2: TShape
    Top = 494
    Width = 847
    ExplicitTop = 459
    ExplicitWidth = 802
  end
  inherited PanelAlbaranes: TPanel
    Width = 847
    ExplicitWidth = 847
    inherited LabelObservaciones: TLabel
      Left = 232
      Top = 13
      ExplicitLeft = 232
      ExplicitTop = 13
    end
    inherited EditCodigo: TEdit
      Width = 44
      NumbersOnly = True
      ExplicitWidth = 44
    end
    inherited DateTimePickerFecha: TDateTimePicker
      Width = 100
      TabOrder = 2
      ExplicitWidth = 100
    end
    inherited MemoObservaciones: TMemo
      Left = 335
      Top = 13
      TabOrder = 3
      ExplicitLeft = 335
      ExplicitTop = 13
    end
    inherited cbbCodCliente: TComboBox
      Width = 61
      TabOrder = 1
      OnChange = cbbCodClienteChange
      ExplicitWidth = 61
    end
  end
  inherited PanelBtns: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 499
    Width = 841
    ExplicitLeft = 3
    ExplicitTop = 499
    ExplicitWidth = 841
    inherited btnAceptar: TButton
      Left = 671
      TabOrder = 4
      OnClick = btnAceptarClick
      ExplicitLeft = 671
    end
    inherited btnCancelar: TButton
      Left = 756
      TabOrder = 5
      ExplicitLeft = 756
    end
    inherited ButtonBorrar: TButton
      Tag = 3
      TabOrder = 3
      OnClick = ButtonClick
    end
    inherited ButtonInsertar: TButton
      TabOrder = 0
      OnClick = ButtonClick
    end
    inherited ButtonActualizar: TButton
      Tag = 2
      TabOrder = 2
      OnClick = ButtonClick
    end
    inherited ButtonVer: TButton
      Tag = 1
      TabOrder = 1
      OnClick = ButtonClick
    end
  end
  inherited PanelLineas: TPanel
    Width = 847
    Height = 339
    ExplicitWidth = 847
    ExplicitHeight = 339
    inherited DBGrid: TDBGrid
      Top = 0
      Width = 847
      Height = 281
      TabStop = False
      Align = alTop
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      Columns = <
        item
          Expanded = False
          FieldName = 'NCOD_ALBARAN'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'CCOD_ARTICULO'
          Title.Caption = 'C'#243'digo art'#237'culo'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CNOMBRE_ARTICULO'
          Title.Caption = 'Nombre art'#237'culo'
          Width = 132
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NORDEN'
          Title.Caption = 'Orden'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NPRECIO'
          Title.Caption = 'Precio'
          Width = 105
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NIVA'
          Title.Caption = 'IVA/%'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NRECARGO'
          Title.Caption = 'Recargo/%'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NCANTIDAD2'
          Title.Caption = 'Pzas/Cajas'
          Width = 87
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NCANTIDAD1'
          Title.Caption = 'Peso/Ud'
          Width = 87
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSUBTOTAL'
          Title.Caption = 'Subtotal'
          Width = 130
          Visible = True
        end>
    end
    object pnlTotal: TPanel
      Left = 0
      Top = 259
      Width = 847
      Height = 80
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lblTotal: TLabel
        AlignWithMargins = True
        Left = 599
        Top = 30
        Width = 51
        Height = 25
        Margins.Left = 20
        Margins.Top = 30
        Margins.Right = 20
        Margins.Bottom = 25
        Align = alRight
        Alignment = taCenter
        Caption = 'Total/'#8364
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitHeight = 19
      end
      object lblRecargo: TLabel
        AlignWithMargins = True
        Left = 413
        Top = 30
        Width = 57
        Height = 25
        Margins.Left = 15
        Margins.Top = 30
        Margins.Right = 10
        Margins.Bottom = 25
        Align = alRight
        Alignment = taCenter
        Caption = 'Recargo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitHeight = 19
      end
      object lblIVA: TLabel
        AlignWithMargins = True
        Left = 235
        Top = 30
        Width = 27
        Height = 25
        Margins.Left = 15
        Margins.Top = 30
        Margins.Right = 10
        Margins.Bottom = 25
        Align = alRight
        Alignment = taCenter
        Caption = 'IVA'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitHeight = 19
      end
      object lblSubtotal: TLabel
        AlignWithMargins = True
        Left = 31
        Top = 30
        Width = 32
        Height = 25
        Margins.Left = 15
        Margins.Top = 30
        Margins.Right = 10
        Margins.Bottom = 25
        Align = alRight
        Alignment = taCenter
        Caption = 'Base'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitHeight = 19
      end
      object edtTotal: TEdit
        AlignWithMargins = True
        Left = 685
        Top = 20
        Width = 142
        Height = 40
        Margins.Left = 15
        Margins.Top = 20
        Margins.Right = 20
        Margins.Bottom = 20
        Align = alRight
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Text = '0'
      end
      object edtRecargo: TEdit
        AlignWithMargins = True
        Left = 490
        Top = 20
        Width = 79
        Height = 40
        Margins.Left = 10
        Margins.Top = 20
        Margins.Right = 10
        Margins.Bottom = 20
        Align = alRight
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        Text = '0'
      end
      object edtIVA: TEdit
        AlignWithMargins = True
        Left = 282
        Top = 20
        Width = 106
        Height = 40
        Margins.Left = 10
        Margins.Top = 20
        Margins.Right = 10
        Margins.Bottom = 20
        Align = alRight
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        Text = '0'
      end
      object edtSubtotal: TEdit
        AlignWithMargins = True
        Left = 93
        Top = 20
        Width = 117
        Height = 40
        Margins.Left = 20
        Margins.Top = 20
        Margins.Right = 10
        Margins.Bottom = 20
        Align = alRight
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        Text = '0'
      end
    end
  end
  inherited DataSource: TDataSource
    OnDataChange = DataSourceDataChange
  end
  inherited pFIBDataSetTable: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE LINEAS_ALB'
      'SET '
      '    CCOD_ARTICULO = :CCOD_ARTICULO,'
      '    NPRECIO = :NPRECIO,'
      '    NIVA = :NIVA,'
      '    NRECARGO = :NRECARGO,'
      '    NCANTIDAD1 = :NCANTIDAD1,'
      '    NCANTIDAD2 = :NCANTIDAD2,'
      '    NSUBTOTAL = :NSUBTOTAL'
      'WHERE'
      '    NCOD_ALBARAN = :OLD_NCOD_ALBARAN'
      '    and NORDEN = :OLD_NORDEN'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    LINEAS_ALB'
      'WHERE'
      '        NCOD_ALBARAN = :OLD_NCOD_ALBARAN'
      '    and NORDEN = :OLD_NORDEN'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO LINEAS_ALB('
      '    NCOD_ALBARAN,'
      '    CCOD_ARTICULO,'
      '    NPRECIO,'
      '    NORDEN,'
      '    NIVA,'
      '    NRECARGO,'
      '    NCANTIDAD1,'
      '    NCANTIDAD2,'
      '    NSUBTOTAL'
      ')'
      'VALUES('
      '    :NCOD_ALBARAN,'
      '    :CCOD_ARTICULO,'
      '    :NPRECIO,'
      '    :NORDEN,'
      '    :NIVA,'
      '    :NRECARGO,'
      '    :NCANTIDAD1,'
      '    :NCANTIDAD2,'
      '    :NSUBTOTAL'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    NCOD_ALBARAN,'
      '    CCOD_ARTICULO,'
      '    NPRECIO,'
      '    NORDEN,'
      '    NIVA,'
      '    NRECARGO,'
      '    NCANTIDAD1,'
      '    NCANTIDAD2,'
      '    NSUBTOTAL'
      'FROM'
      '    LINEAS_ALB '
      ''
      ' WHERE '
      '        LINEAS_ALB.NCOD_ALBARAN = :OLD_NCOD_ALBARAN'
      '    and LINEAS_ALB.NORDEN = :OLD_NORDEN'
      '    ')
    SelectSQL.Strings = (
      'SELECT '
      '  l.NCOD_ALBARAN, '
      '  l.CCOD_ARTICULO, '
      '  a.CNOMBRE AS CNOMBRE_ARTICULO,'
      '  l.NCANTIDAD1, '
      '  l.NCANTIDAD2, '
      '  l.NPRECIO, '
      '  l.NORDEN, '
      '  l.NSUBTOTAL, '
      '  l.NIVA, '
      '  l.NRECARGO'
      'FROM LINEAS_ALB l'
      'LEFT JOIN ARTICULOS a ON l.CCOD_ARTICULO = a.CCODIGO'
      'WHERE l.NCOD_ALBARAN = :NCOD_ALBARAN')
    OnNewRecord = pFIBDataSetTableNewRecord
    Database = DataModuleBDD.pFIBDatabase
    UpdateTransaction = DataModuleBDD.pFIBTransaction
    object fbntgrfldFIBDataSetTableNCOD_ALBARAN: TFIBIntegerField
      FieldName = 'NCOD_ALBARAN'
    end
    object fbstrngfldFIBDataSetTableCCOD_ARTICULO: TFIBStringField
      FieldName = 'CCOD_ARTICULO'
      Size = 5
      EmptyStrToNull = True
    end
    object fbcdfldFIBDataSetTableNPRECIO: TFIBBCDField
      FieldName = 'NPRECIO'
      Size = 3
      RoundByScale = True
    end
    object fbsmlntfldFIBDataSetTableNORDEN: TFIBSmallIntField
      FieldName = 'NORDEN'
    end
    object fbfltfldFIBDataSetTableNIVA: TFIBFloatField
      FieldName = 'NIVA'
    end
    object fbfltfldFIBDataSetTableNRECARGO: TFIBFloatField
      FieldName = 'NRECARGO'
    end
    object fbcdfldFIBDataSetTableNCANTIDAD1: TFIBBCDField
      FieldName = 'NCANTIDAD1'
      Size = 3
      RoundByScale = True
    end
    object fbcdfldFIBDataSetTableNCANTIDAD2: TFIBBCDField
      FieldName = 'NCANTIDAD2'
      Size = 3
      RoundByScale = True
    end
    object fbcdfldFIBDataSetTableNSUBTOTAL: TFIBBCDField
      FieldName = 'NSUBTOTAL'
      Size = 3
      RoundByScale = True
    end
    object fbstrngfldFIBDataSetTableCNOMBRE_ARTICULO: TFIBStringField
      FieldName = 'CNOMBRE_ARTICULO'
      Size = 100
      EmptyStrToNull = True
    end
  end
end
