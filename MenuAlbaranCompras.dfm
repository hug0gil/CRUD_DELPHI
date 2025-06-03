inherited FormMenuAlbaranCompras: TFormMenuAlbaranCompras
  Caption = 'Albaranes de compra'
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
          Width = 45
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
          FieldName = 'NCOD_PROVEEDOR'
          Title.Caption = 'C'#243'digo del proveedor'
          Width = 108
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NTOTAL'
          Title.Caption = 'Total/'#8364
          Width = 120
          Visible = True
        end>
    end
  end
  inherited pFIBTransactionTable: TpFIBTransaction
    DefaultDatabase = DataModuleBDD.pFIBDatabase
  end
  inherited pFIBDataSetTable: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ALBARAN_C'
      'SET '
      '    DFECHA = :DFECHA,'
      '    COBSERVACIONES = :COBSERVACIONES,'
      '    NCOD_PROVEEDOR = :NCOD_PROVEEDOR,'
      '    NTOTAL = :NTOTAL,'
      '    NTOTAL_BRUTO = :NTOTAL_BRUTO,'
      '    NIVA = :NIVA,'
      '    NRECARGO = :NRECARGO'
      'WHERE'
      '    NCODIGO = :OLD_NCODIGO'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    ALBARAN_C'
      'WHERE'
      '        NCODIGO = :OLD_NCODIGO'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO ALBARAN_C('
      '    NCODIGO,'
      '    DFECHA,'
      '    COBSERVACIONES,'
      '    NCOD_PROVEEDOR,'
      '    NTOTAL,'
      '    NTOTAL_BRUTO,'
      '    NIVA,'
      '    NRECARGO'
      ')'
      'VALUES('
      '    :NCODIGO,'
      '    :DFECHA,'
      '    :COBSERVACIONES,'
      '    :NCOD_PROVEEDOR,'
      '    :NTOTAL,'
      '    :NTOTAL_BRUTO,'
      '    :NIVA,'
      '    :NRECARGO'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA,'
      '    COBSERVACIONES,'
      '    NCOD_PROVEEDOR,'
      '    NTOTAL,'
      '    NTOTAL_BRUTO,'
      '    NIVA,'
      '    NRECARGO'
      'FROM'
      '    ALBARAN_C'
      ''
      ' WHERE '
      '        ALBARAN_C.NCODIGO = :OLD_NCODIGO'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA,'
      '    COBSERVACIONES,'
      '    NCOD_PROVEEDOR,'
      '    NTOTAL,'
      '    NTOTAL_BRUTO,'
      '    NIVA,'
      '    NRECARGO'
      'FROM'
      '    ALBARAN_C'
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
      FieldName = 'NCOD_PROVEEDOR'
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
    SelectSQL.Strings = (
      'SELECT'
      '    A.NCODIGO,'
      '    A.DFECHA,'
      '    A.COBSERVACIONES,'
      '    A.NCOD_PROVEEDOR,'
      '    A.NTOTAL,'
      '    A.NTOTAL_BRUTO,'
      '    A.NIVA,'
      '    A.NRECARGO,'
      ''
      '    L.NORDEN,'
      '    L.CCOD_ARTICULO,'
      '    L.NPRECIO,'
      '    L.NIVA AS LINEA_IVA,'
      '    L.NRECARGO AS LINEA_RECARGO,'
      '    L.NCANTIDAD1,'
      '    L.NCANTIDAD2,'
      '    L.NSUBTOTAL,'
      ''
      '    P.NCODIGO AS PROVEEDOR_CODIGO,'
      '    P.DFECHA_ULT_COMPRA,'
      '    P.CNOMBRE AS PROVEEDOR_NOMBRE,'
      '    P.CREG_FISCAL,'
      ''
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
      '    ALBARAN_C A'
      'JOIN'
      '    LINEAS_ALB_C L ON A.NCODIGO = L.NCOD_ALBARAN'
      'JOIN'
      '    PROVEEDORES P ON A.NCOD_PROVEEDOR = P.NCODIGO'
      'JOIN'
      '    ARTICULOS AR ON L.CCOD_ARTICULO = AR.CCODIGO'
      'ORDER BY'
      '    L.NORDEN;')
    Active = True
  end
  inherited frxDBDatasetReport: TfrxDBDataset
    UserName = 'COMPRAS'
  end
  inherited frxReport: TfrxReport
    ReportOptions.CreateDate = 45798.433929513900000000
    ReportOptions.LastChange = 45798.433929513900000000
    Datasets = <
      item
        DataSet = frxDBDatasetReport
        DataSetName = 'COMPRAS'
      end>
    Variables = <>
    Style = <>
    inherited Page1: TfrxReportPage
      object PageHeader1: TfrxPageHeader
        Height = 212.409448818898000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo2: TfrxMemoView
          Left = 11.338590000000000000
          Top = 181.417440000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'Art'#237'culos')
        end
        object Memo5: TfrxMemoView
          Left = 151.181200000000000000
          Top = 181.417440000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'Precio')
        end
        object Memo6: TfrxMemoView
          Left = 317.480520000000000000
          Top = 181.417440000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'Piezas')
        end
        object Memo8: TfrxMemoView
          Left = 449.764070000000000000
          Top = 181.417440000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'Cajas')
        end
        object Memo9: TfrxMemoView
          Left = 585.827150000000000000
          Top = 181.417440000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'Subtotal')
        end
        object Line4: TfrxLineView
          Top = 173.858380000000000000
          Width = 718.110248430000000000
          ShowHint = False
          Diagonal = True
        end
        object Line3: TfrxLineView
          Top = 211.653655590000000000
          Width = 718.110248430000000000
          ShowHint = False
          Diagonal = True
        end
        object Memo4: TfrxMemoView
          Top = 37.795300000000000000
          Width = 718.110700000000000000
          Height = 136.063080000000000000
          ShowHint = False
          Color = cl3DLight
        end
        object VENTASCOBSERVACIONES: TfrxMemoView
          Left = 11.338590000000000000
          Top = 105.826840000000000000
          Width = 321.260050000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          Memo.UTF8W = (
            'Observaciones: [COMPRAS."COBSERVACIONES"]')
        end
        object VENTASDFECHA: TfrxMemoView
          Left = 11.338590000000000000
          Top = 68.031540000000000000
          Width = 249.448980000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          Memo.UTF8W = (
            'Fecha: [COMPRAS."DFECHA"]')
        end
        object VENTASCLIENTE_NOMBRE: TfrxMemoView
          Left = 11.338590000000000000
          Top = 143.622140000000000000
          Width = 400.630180000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          Memo.UTF8W = (
            'Nombre del cliente: [COMPRAS."PROVEEDOR_NOMBRE"]')
        end
        object Memo10: TfrxMemoView
          Left = 306.141732280000000000
          Top = 68.031540000000000000
          Width = 400.630180000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          HAlign = haRight
          Memo.UTF8W = (
            'N'#186' de l'#237'neas: [COMPRAS."TOTAL_LINEAS"]')
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 18.897650000000000000
        Top = 691.653990000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          Align = baLeft
          Width = 75.590600000000000000
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
        Top = 291.023810000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDatasetReport
        DataSetName = 'COMPRAS'
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
          DataSetName = 'COMPRAS'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[COMPRAS."NPRECIO"] '#8364)
        end
        object VENTASNCANTIDAD1: TfrxMemoView
          Left = 317.480520000000000000
          Top = 37.795300000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[COMPRAS."NCANTIDAD1"]')
        end
        object VENTASNCANTIDAD2: TfrxMemoView
          Left = 449.764070000000000000
          Top = 37.795300000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[COMPRAS."NCANTIDAD2"]')
        end
        object VENTASNSUBTOTAL: TfrxMemoView
          Left = 585.827150000000000000
          Top = 37.795300000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          Memo.UTF8W = (
            '[COMPRAS."NSUBTOTAL"] '#8364)
        end
        object VENTASARTICULO_NOMBRE: TfrxMemoView
          Left = 3.779530000000000000
          Top = 37.795300000000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'ARTICULO_NOMBRE'
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          Memo.UTF8W = (
            '[COMPRAS."ARTICULO_NOMBRE"]')
        end
        object BarCode1: TfrxBarCodeView
          Left = 3.779527560000000000
          Top = 83.149660000000000000
          Width = 142.000000000000000000
          Height = 45.354330710000000000
          ShowHint = False
          BarType = bcCode39
          CalcCheckSum = True
          Expression = '<COMPRAS."ARTICULO_CODIGO">'
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
        Top = 495.118430000000000000
        Width = 718.110700000000000000
        object VENTASNTOTAL_BRUTO: TfrxMemoView
          Left = 411.968770000000000000
          Top = 11.338590000000000000
          Width = 283.464750000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'Base imponible: [COMPRAS."NTOTAL_BRUTO"]')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 411.968770000000000000
          Top = 86.929190000000000000
          Width = 283.464750000000000000
          Height = 22.677180000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'IVA: [COMPRAS."NIVA"]')
          ParentFont = False
        end
        object VENTASNRECARGO: TfrxMemoView
          Left = 411.968770000000000000
          Top = 49.133890000000000000
          Width = 283.464750000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'Recargo equivalente: [COMPRAS."NRECARGO"]')
          ParentFont = False
        end
        object VENTASNTOTAL: TfrxMemoView
          Left = 411.968770000000000000
          Top = 128.504020000000000000
          Width = 283.464750000000000000
          Height = 41.574830000000000000
          ShowHint = False
          AllowHTMLTags = True
          DataSet = frxDBDatasetReport
          DataSetName = 'COMPRAS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            '<b>Total: [COMPRAS."NTOTAL"] '#8364'</b>')
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
      object Memo11: TfrxMemoView
        Align = baWidth
        Top = 15.118120000000000000
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
          'Albar'#225'n de compra - N'#186' [COMPRAS."NCODIGO"]')
        ParentFont = False
        VAlign = vaCenter
      end
    end
  end
  inherited pFIBTransactionReport: TpFIBTransaction
    Active = True
  end
end
