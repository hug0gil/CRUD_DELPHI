inherited FormMenuAlbaranVentas: TFormMenuAlbaranVentas
  Caption = 'Albaranes de venta'
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited btnActualizar: TButton
      Tag = 1
      OnClick = btnClick
    end
    inherited btnAgregar: TButton
      OnClick = btnClick
    end
    inherited btnEliminar: TButton
      Tag = 3
      OnClick = btnClick
    end
    inherited btnVer: TButton
      Tag = 2
      OnClick = btnClick
    end
    inherited rgGroupOrden: TRadioGroup
      Items.Strings = (
        'Ordenar por c'#243'digo'
        'Ordenar por fecha')
      OnClick = rgGroupOrdenClick
    end
    inherited btnImprimir: TButton
      OnClick = btnImprimirClick
    end
  end
  inherited Panel2: TPanel
    inherited DBNavigator: TDBNavigator
      Hints.Strings = ()
    end
    inherited DBGrid1: TDBGrid
      Columns = <
        item
          Expanded = False
          FieldName = 'NCODIGO'
          Title.Caption = 'C'#243'digo'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DFECHA'
          Title.Caption = 'Fecha'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COBSERVACIONES'
          Title.Caption = 'Observaciones'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NCOD_CLIENTE'
          Title.Caption = 'C'#243'digo del cliente'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NTOTAL'
          Title.Caption = 'Total/'#8364
          Width = 118
          Visible = True
        end>
    end
  end
  inherited pFIBTransactionTable: TpFIBTransaction
    DefaultDatabase = DataModuleBDD.pFIBDatabase
  end
  inherited pFIBDataSetTable: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ALBARAN'
      'SET '
      '    DFECHA = :DFECHA,'
      '    COBSERVACIONES = :COBSERVACIONES,'
      '    NCOD_CLIENTE = :NCOD_CLIENTE,'
      '    NTOTAL = :NTOTAL'
      'WHERE'
      '    NCODIGO = :OLD_NCODIGO'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    ALBARAN'
      'WHERE'
      '        NCODIGO = :OLD_NCODIGO'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO ALBARAN('
      '    NCODIGO,'
      '    DFECHA,'
      '    COBSERVACIONES,'
      '    NCOD_CLIENTE,'
      '    NTOTAL'
      ')'
      'VALUES('
      '    :NCODIGO,'
      '    :DFECHA,'
      '    :COBSERVACIONES,'
      '    :NCOD_CLIENTE,'
      '    :NTOTAL'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA,'
      '    COBSERVACIONES,'
      '    NCOD_CLIENTE,'
      '    NTOTAL'
      'FROM'
      '    ALBARAN '
      ''
      ' WHERE '
      '        ALBARAN.NCODIGO = :OLD_NCODIGO'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA,'
      '    COBSERVACIONES,'
      '    NCOD_CLIENTE,'
      '    NTOTAL,'
      '    NTOTAL_BRUTO,'
      '    NIVA,'
      '    NRECARGO'
      'FROM'
      '    ALBARAN_V'
      'ORDER BY NCODIGO  ')
    Database = DataModuleBDD.pFIBDatabase
    UpdateTransaction = DataModuleBDD.pFIBTransaction
    object fbntgrfldFIBDataSetTableNCODIGO: TFIBIntegerField
      FieldName = 'NCODIGO'
    end
    object fbdtfldFIBDataSetTableDFECHA: TFIBDateField
      FieldName = 'DFECHA'
      DisplayFormat = 'dd.mm.yyyy'
    end
    object pFIBDataSetTableCOBSERVACIONES: TFIBStringField
      FieldName = 'COBSERVACIONES'
      Size = 255
      EmptyStrToNull = True
    end
    object fbntgrfldFIBDataSetTableNCOD_CLIENTE: TFIBIntegerField
      FieldName = 'NCOD_CLIENTE'
    end
    object pFIBDataSetTableNTOTAL: TFIBBCDField
      DefaultExpression = '0'
      FieldName = 'NTOTAL'
      DisplayFormat = '#,##0.000'
      EditFormat = '0.000'
      Size = 3
      RoundByScale = True
    end
  end
  inherited DataSetReport: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ALBARAN_V'
      'SET '
      '    DFECHA = :DFECHA,'
      '    COBSERVACIONES = :COBSERVACIONES,'
      '    NCOD_CLIENTE = :NCOD_CLIENTE,'
      '    NTOTAL = :NTOTAL,'
      '    NTOTAL_BRUTO = :NTOTAL_BRUTO,'
      '    NIVA = :NIVA,'
      '    NRECARGO = :NRECARGO'
      'WHERE'
      '    NCODIGO = :OLD_NCODIGO'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    ALBARAN_V'
      'WHERE'
      '        NCODIGO = :OLD_NCODIGO'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO ALBARAN_V('
      '    NCODIGO,'
      '    DFECHA,'
      '    COBSERVACIONES,'
      '    NCOD_CLIENTE,'
      '    NTOTAL,'
      '    NTOTAL_BRUTO,'
      '    NIVA,'
      '    NRECARGO'
      ')'
      'VALUES('
      '    :NCODIGO,'
      '    :DFECHA,'
      '    :COBSERVACIONES,'
      '    :NCOD_CLIENTE,'
      '    :NTOTAL,'
      '    :NTOTAL_BRUTO,'
      '    :NIVA,'
      '    :NRECARGO'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    A.NCODIGO,'
      '    A.DFECHA,'
      '    A.COBSERVACIONES,'
      '    A.NCOD_CLIENTE,'
      '    A.NTOTAL,'
      '    A.NTOTAL_BRUTO,'
      '    A.NIVA,'
      '    A.NRECARGO,'
      '    L.NORDEN,'
      '    L.CCOD_ARTICULO,'
      '    L.NPRECIO,'
      '    L.NIVA AS LINEA_IVA,'
      '    L.NRECARGO AS LINEA_RECARGO,'
      '    L.NCANTIDAD1,'
      '    L.NCANTIDAD2,'
      '    L.NSUBTOTAL'
      'FROM'
      '    ALBARAN_V A'
      'JOIN'
      '    LINEAS_ALB_V L ON A.NCODIGO = L.NCOD_ALBARAN'
      ''
      ' WHERE '
      '        A.NCODIGO = :OLD_NCODIGO'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    A.NCODIGO,'
      '    A.DFECHA,'
      '    A.COBSERVACIONES,'
      '    A.NCOD_CLIENTE,'
      '    A.NTOTAL,'
      '    A.NTOTAL_BRUTO,'
      '    A.NIVA,'
      '    A.NRECARGO,'
      '    L.NORDEN,'
      '    L.CCOD_ARTICULO,'
      '    L.NPRECIO,'
      '    L.NIVA AS LINEA_IVA,'
      '    L.NRECARGO AS LINEA_RECARGO,'
      '    L.NCANTIDAD1,'
      '    L.NCANTIDAD2,'
      '    L.NSUBTOTAL,'
      '    C.NCODIGO AS CLIENTE_CODIGO,'
      '    C.DFECHA_ULT_VENTA,'
      '    C.CNOMBRE AS CLIENTE_NOMBRE,'
      '    C.CREG_FISCAL,'
      '    AR.CCODIGO AS ARTICULO_CODIGO,'
      '    AR.CNOMBRE AS ARTICULO_NOMBRE,'
      '    AR.NSTOCK,'
      '    AR.NCOD_IVA AS ARTICULO_IVA,'
      '    AR.NFACTCONV,'
      '    AR.NUNICAJ,'
      '    AR.NPRECIO AS ARTICULO_PRECIO_VENTA,'
      '    AR.NPRECIO_COMPRA,'
      '    AR.NCOD_PROV,'
      '    COUNT(*) OVER () AS TOTAL_LINEAS'
      'FROM'
      '    ALBARAN_V A'
      'JOIN'
      '    LINEAS_ALB_V L ON A.NCODIGO = L.NCOD_ALBARAN'
      'JOIN'
      '    CLIENTES C ON A.NCOD_CLIENTE = C.NCODIGO'
      'JOIN'
      '    ARTICULOS AR ON L.CCOD_ARTICULO = AR.CCODIGO'
      'ORDER BY'
      '    L.NORDEN;')
    Active = True
  end
  inherited frxDBDatasetReport: TfrxDBDataset
    UserName = 'VENTAS'
  end
  inherited frxReport: TfrxReport
    ReportOptions.CreateDate = 45798.433929513900000000
    ReportOptions.LastChange = 45799.564878888900000000
    Datasets = <
      item
        DataSet = frxDBDatasetReport
        DataSetName = 'VENTAS'
      end>
    Variables = <
      item
        Name = ' Estadisticas'
        Value = ''
      end
      item
        Name = 'MaxNCODIGO'
        Value = 'MAX(<VENTAS."NORDEN">)'#10
      end>
    Style = <>
    inherited Page1: TfrxReportPage
      object PageHeader1: TfrxPageHeader
        Height = 219.968503937008000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo2: TfrxMemoView
          Left = 11.338590000000000000
          Top = 192.756030000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'Art'#237'culos')
        end
        object Memo5: TfrxMemoView
          Left = 151.181200000000000000
          Top = 192.756030000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'Precio')
        end
        object Memo6: TfrxMemoView
          Left = 317.480520000000000000
          Top = 192.756030000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'Piezas')
        end
        object Memo8: TfrxMemoView
          Left = 449.764070000000000000
          Top = 192.756030000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'Cajas')
        end
        object Memo9: TfrxMemoView
          Left = 585.827150000000000000
          Top = 192.756030000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'Subtotal')
        end
        object Line4: TfrxLineView
          Top = 185.952755905512000000
          Width = 718.110248430000000000
          ShowHint = False
          ArrowLength = 40
          Diagonal = True
        end
        object Memo4: TfrxMemoView
          Top = 37.795300000000000000
          Width = 718.110700000000000000
          Height = 147.401670000000000000
          ShowHint = False
          Color = cl3DLight
        end
        object VENTASCOBSERVACIONES: TfrxMemoView
          Left = 11.338590000000000000
          Top = 109.606370000000000000
          Width = 302.362400000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          Memo.UTF8W = (
            'Observaciones: [VENTAS."COBSERVACIONES"]')
        end
        object VENTASDFECHA: TfrxMemoView
          Left = 11.338590000000000000
          Top = 71.811070000000000000
          Width = 249.448980000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          Memo.UTF8W = (
            'Fecha: [VENTAS."DFECHA"]')
        end
        object VENTASCLIENTE_NOMBRE: TfrxMemoView
          Left = 11.338590000000000000
          Top = 147.401670000000000000
          Width = 400.630180000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          Memo.UTF8W = (
            'Nombre del cliente: [VENTAS."CLIENTE_NOMBRE"]')
        end
        object Memo10: TfrxMemoView
          Left = 306.141732280000000000
          Top = 71.811070000000000000
          Width = 400.630180000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          HAlign = haRight
          Memo.UTF8W = (
            'N'#186' de l'#237'neas: [VENTAS."TOTAL_LINEAS"]')
        end
        object Memo11: TfrxMemoView
          Align = baWidth
          Width = 718.110700000000000000
          Height = 37.795300000000000000
          ShowHint = False
          AllowHTMLTags = True
          Color = clTeal
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'Albar'#225'n de venta - N'#186' [VENTAS."NCODIGO"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Line3: TfrxLineView
          Top = 219.212740000000000000
          Width = 718.110248430000000000
          ShowHint = False
          ArrowLength = 40
          Diagonal = True
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 18.897650000000000000
        Top = 699.213050000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          Align = baLeft
          Width = 75.590551181102400000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Page#]')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        Height = 143.622140000000000000
        Top = 298.582870000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDatasetReport
        DataSetName = 'VENTAS'
        RowCount = 0
        object Memo3: TfrxMemoView
          Width = 718.110700000000000000
          Height = 143.622140000000000000
          ShowHint = False
          DataSetName = 'Customers'
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = -370606080
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = []
          Highlight.Color = 15790320
          Highlight.Condition = '<Line#> mod 2'
          WordWrap = False
        end
        object VENTASNPRECIO: TfrxMemoView
          Left = 151.181200000000000000
          Top = 37.795300000000000000
          Width = 136.063080000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[VENTAS."NPRECIO"] '#8364)
        end
        object VENTASNCANTIDAD1: TfrxMemoView
          Left = 317.480520000000000000
          Top = 37.795300000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[VENTAS."NCANTIDAD1"]')
        end
        object VENTASNCANTIDAD2: TfrxMemoView
          Left = 449.764070000000000000
          Top = 37.795300000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[VENTAS."NCANTIDAD2"]')
        end
        object VENTASNSUBTOTAL: TfrxMemoView
          Left = 585.827150000000000000
          Top = 37.795300000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[VENTAS."NSUBTOTAL"] '#8364)
        end
        object VENTASARTICULO_NOMBRE: TfrxMemoView
          Left = 3.779530000000000000
          Top = 37.795300000000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'ARTICULO_NOMBRE'
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          Memo.UTF8W = (
            '[VENTAS."ARTICULO_NOMBRE"]')
        end
        object BarCode1: TfrxBarCodeView
          Left = 3.779527560000000000
          Top = 83.149660000000000000
          Width = 142.000000000000000000
          Height = 45.354360000000000000
          ShowHint = False
          BarType = bcCode39
          CalcCheckSum = True
          Expression = '<VENTAS."ARTICULO_CODIGO">'
          Rotation = 0
          Text = '12345678'
          WideBarRatio = 2.000000000000000000
          Zoom = 1.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
        end
      end
      object ReportSummary1: TfrxReportSummary
        Height = 173.858267720000000000
        Top = 502.677490000000000000
        Width = 718.110700000000000000
        object VENTASNTOTAL_BRUTO: TfrxMemoView
          Left = 411.968770000000000000
          Top = 22.677180000000000000
          Width = 283.464750000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'Base imponible: [VENTAS."NTOTAL_BRUTO"]')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 411.968770000000000000
          Top = 98.267780000000000000
          Width = 283.464750000000000000
          Height = 22.677180000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'IVA: [VENTAS."NIVA"]')
          ParentFont = False
        end
        object VENTASNRECARGO: TfrxMemoView
          Left = 411.968770000000000000
          Top = 60.472480000000000000
          Width = 283.464750000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'Recargo equivalente: [VENTAS."NRECARGO"]')
          ParentFont = False
        end
        object VENTASNTOTAL: TfrxMemoView
          Left = 411.968770000000000000
          Top = 139.842610000000000000
          Width = 283.464750000000000000
          Height = 30.236240000000000000
          ShowHint = False
          AllowHTMLTags = True
          DataSet = frxDBDatasetReport
          DataSetName = 'VENTAS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            '<b>Total: [VENTAS."NTOTAL"] '#8364'</b>')
          ParentFont = False
        end
        object Line1: TfrxLineView
          Width = 718.110248430000000000
          ShowHint = False
          Diagonal = True
        end
        object Line2: TfrxLineView
          Top = 0.377945430000000000
          Width = 718.110248430000000000
          ShowHint = False
          Diagonal = True
        end
      end
    end
  end
  inherited pFIBTransactionReport: TpFIBTransaction
    Active = True
  end
  inherited DataSourceReport: TDataSource
    Left = 280
  end
end
