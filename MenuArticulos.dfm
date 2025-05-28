inherited FormMenuArticulos: TFormMenuArticulos
  Caption = 'Art'#237'culos'
  ClientHeight = 583
  ClientWidth = 1168
  OnCreate = FormCreate
  ExplicitLeft = -21
  ExplicitWidth = 1174
  ExplicitHeight = 612
  PixelsPerInch = 96
  TextHeight = 13
  inherited Shape1: TShape
    Left = 984
    Height = 583
  end
  inherited Panel1: TPanel
    Left = 986
    Height = 583
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
      ExplicitLeft = -55
      ExplicitTop = 380
    end
    inherited btnVer: TButton
      Tag = 2
      OnClick = btnClick
    end
    inherited rgGroupOrden: TRadioGroup
      Items.Strings = (
        'Ordenar por c'#243'digo'
        'Ordenar por nombre')
      TabOrder = 5
      OnClick = rgGroupOrdenClick
    end
    inherited btnImprimir: TButton
      TabOrder = 4
      OnClick = btnImprimirClick
    end
  end
  inherited Panel2: TPanel
    Width = 984
    Height = 583
    ExplicitHeight = 661
    inherited DBNavigator: TDBNavigator
      Width = 982
      Hints.Strings = ()
    end
    inherited DBGrid1: TDBGrid
      Width = 982
      Height = 513
      Columns = <
        item
          Expanded = False
          FieldName = 'CCODIGO'
          Title.Caption = 'C'#243'digo'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CNOMBRE'
          Title.Caption = 'Nombre'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSTOCK'
          Title.Caption = 'Stock'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NCOD_IVA'
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'CNOMBRE_IVA'
          Title.Caption = 'Tipo IVA'
          Width = 130
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NFACTCONV'
          Title.Caption = 'F.C'
          Width = 65
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NUNICAJ'
          Title.Caption = 'Unidad/Caja'
          Width = 65
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NPRECIO'
          Title.Caption = 'Precio base'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NPRECIO_COMPRA'
          Title.Caption = 'Precio compra'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NCOD_PROV'
          Title.Caption = 'C'#243'digo proveedor'
          Visible = True
        end>
    end
  end
  inherited pFIBTransactionTable: TpFIBTransaction
    Active = True
    DefaultDatabase = DataModuleBDD.pFIBDatabase
  end
  inherited pFIBDataSetTable: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ARTICULOS'
      'SET '
      '    CNOMBRE = :CNOMBRE,'
      '    NSTOCK = :NSTOCK,'
      '    NCOD_IVA = :NCOD_IVA,'
      '    NFACTCONV = :NFACTCONV,'
      '    NUNICAJ = :NUNICAJ,'
      '    NPRECIO = :NPRECIO,'
      '    NPRECIO_COMPRA = :NPRECIO_COMPRA,'
      '    NCOD_PROV = :NCOD_PROV'
      'WHERE'
      '    CCODIGO = :OLD_CCODIGO'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    ARTICULOS'
      'WHERE'
      '        CCODIGO = :OLD_CCODIGO'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO ARTICULOS('
      '    CCODIGO,'
      '    CNOMBRE,'
      '    NSTOCK,'
      '    NCOD_IVA,'
      '    NFACTCONV,'
      '    NUNICAJ,'
      '    NPRECIO,'
      '    NPRECIO_COMPRA,'
      '    NCOD_PROV'
      ')'
      'VALUES('
      '    :CCODIGO,'
      '    :CNOMBRE,'
      '    :NSTOCK,'
      '    :NCOD_IVA,'
      '    :NFACTCONV,'
      '    :NUNICAJ,'
      '    :NPRECIO,'
      '    :NPRECIO_COMPRA,'
      '    :NCOD_PROV'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    CCODIGO,'
      '    CNOMBRE,'
      '    NSTOCK,'
      '    NCOD_IVA,'
      '    NFACTCONV,'
      '    NUNICAJ,'
      '    NPRECIO,'
      '    NPRECIO_COMPRA,'
      '    NCOD_PROV'
      'FROM'
      '    ARTICULOS '
      ''
      ' WHERE '
      '        ARTICULOS.CCODIGO = :OLD_CCODIGO'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    CCODIGO,'
      '    CNOMBRE,'
      '    NSTOCK,'
      '    NCOD_IVA,'
      '    NFACTCONV,'
      '    NUNICAJ,'
      '    NPRECIO,'
      '    NPRECIO_COMPRA,'
      '    NCOD_PROV'
      'FROM'
      '    ARTICULOS ')
    OnCalcFields = pFIBDataSetTableCalcFields
    Database = DataModuleBDD.pFIBDatabase
    UpdateTransaction = DataModuleBDD.pFIBTransaction
    object fbstrngfldFIBDataSetTableCCODIGO: TFIBStringField
      FieldName = 'CCODIGO'
      Size = 5
      EmptyStrToNull = True
    end
    object fbstrngfldFIBDataSetTableCNOMBRE: TFIBStringField
      FieldName = 'CNOMBRE'
      Size = 100
      EmptyStrToNull = True
    end
    object fbcdfldFIBDataSetTableNSTOCK: TFIBBCDField
      FieldName = 'NSTOCK'
      Size = 3
      RoundByScale = True
    end
    object fbsmlntfldFIBDataSetTableNCOD_IVA: TFIBSmallIntField
      FieldName = 'NCOD_IVA'
    end
    object fbsmlntfldFIBDataSetTableNFACTCONV: TFIBSmallIntField
      FieldName = 'NFACTCONV'
    end
    object fbsmlntfldFIBDataSetTableNUNICAJ: TFIBSmallIntField
      FieldName = 'NUNICAJ'
    end
    object fbcdfldFIBDataSetTableNPRECIO: TFIBBCDField
      FieldName = 'NPRECIO'
      Size = 3
      RoundByScale = True
    end
    object strngfldFIBDataSetTableCNOMBRE_IVA: TStringField
      FieldKind = fkCalculated
      FieldName = 'CNOMBRE_IVA'
      Calculated = True
    end
    object pFIBDataSetTableNPRECIO_COMPRA: TFIBBCDField
      FieldName = 'NPRECIO_COMPRA'
      Size = 3
      RoundByScale = True
    end
    object pFIBDataSetTableNCOD_PROV: TFIBIntegerField
      FieldName = 'NCOD_PROV'
    end
  end
  inherited DataSetReport: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ARTICULOS'
      'SET '
      '    CNOMBRE = :CNOMBRE,'
      '    NSTOCK = :NSTOCK,'
      '    NCOD_IVA = :NCOD_IVA,'
      '    NFACTCONV = :NFACTCONV,'
      '    NUNICAJ = :NUNICAJ,'
      '    NPRECIO = :NPRECIO,'
      '    NPRECIO_COMPRA = :NPRECIO_COMPRA,'
      '    NCOD_PROV = :NCOD_PROV'
      'WHERE'
      '    CCODIGO = :OLD_CCODIGO'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    ARTICULOS'
      'WHERE'
      '        CCODIGO = :OLD_CCODIGO'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO ARTICULOS('
      '    CCODIGO,'
      '    CNOMBRE,'
      '    NSTOCK,'
      '    NCOD_IVA,'
      '    NFACTCONV,'
      '    NUNICAJ,'
      '    NPRECIO,'
      '    NPRECIO_COMPRA,'
      '    NCOD_PROV'
      ')'
      'VALUES('
      '    :CCODIGO,'
      '    :CNOMBRE,'
      '    :NSTOCK,'
      '    :NCOD_IVA,'
      '    :NFACTCONV,'
      '    :NUNICAJ,'
      '    :NPRECIO,'
      '    :NPRECIO_COMPRA,'
      '    :NCOD_PROV'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    CCODIGO,'
      '    CNOMBRE,'
      '    NSTOCK,'
      '    NCOD_IVA,'
      '    NFACTCONV,'
      '    NUNICAJ,'
      '    NPRECIO,'
      '    NPRECIO_COMPRA,'
      '    NCOD_PROV'
      'FROM'
      '    ARTICULOS '
      ''
      ' WHERE '
      '        ARTICULOS.CCODIGO = :OLD_CCODIGO'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    CCODIGO,'
      '    CNOMBRE,'
      '    NSTOCK,'
      '    NCOD_IVA,'
      '    NFACTCONV,'
      '    NUNICAJ,'
      '    NPRECIO,'
      '    NPRECIO_COMPRA,'
      '    NCOD_PROV'
      'FROM'
      '    ARTICULOS ')
    Active = True
  end
  inherited frxDBDatasetReport: TfrxDBDataset
    UserName = 'PRODUCTOS'
  end
  inherited frxReport: TfrxReport
    ReportOptions.CreateDate = 45798.433929513900000000
    ReportOptions.LastChange = 45803.569148807900000000
    Datasets = <
      item
        DataSet = frxDBDatasetReport
        DataSetName = 'PRODUCTOS'
      end>
    Variables = <>
    Style = <>
    inherited Page1: TfrxReportPage
      object ReportTitle1: TfrxReportTitle
        Height = 41.574830000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
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
            '<b>Listado de productos</b>')
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object PageHeader1: TfrxPageHeader
        Height = 56.692950000000000000
        Top = 83.149660000000000000
        Width = 718.110700000000000000
        object Memo4: TfrxMemoView
          Left = 15.118120000000000000
          Top = 7.559060000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'C'#243'digo cliente')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          Left = 170.078850000000000000
          Top = 7.559060000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Memo.UTF8W = (
            'Nombre')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 321.260050000000000000
          Top = 7.559060000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Stock')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Left = 468.661720000000000000
          Top = 7.559060000000000000
          Width = 83.149660000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Precio')
          ParentFont = False
        end
        object Line2: TfrxLineView
          Left = 15.118120000000000000
          Top = 38.740103780000000000
          Width = 684.094478430000000000
          ShowHint = False
          Diagonal = True
        end
        object Line1: TfrxLineView
          Left = 15.118120000000000000
          Top = 38.173174650000000000
          Width = 684.094478430000000000
          ShowHint = False
          Diagonal = True
        end
        object Memo2: TfrxMemoView
          Left = 574.488560000000000000
          Top = 7.559060000000000000
          Width = 132.283550000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'C'#243'digo proveedor')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        Height = 79.370130000000000000
        Top = 200.315090000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDatasetReport
        DataSetName = 'PRODUCTOS'
        RowCount = 0
        object PRODUCTOSCNOMBRE: TfrxMemoView
          Left = 170.078850000000000000
          Top = 26.456710000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'CNOMBRE'
          DataSet = frxDBDatasetReport
          DataSetName = 'PRODUCTOS'
          Memo.UTF8W = (
            '[PRODUCTOS."CNOMBRE"]')
        end
        object PRODUCTOSNSTOCK: TfrxMemoView
          Left = 321.260050000000000000
          Top = 26.456710000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'PRODUCTOS'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[PRODUCTOS."NSTOCK"]')
        end
        object PRODUCTOSNPRECIO: TfrxMemoView
          Left = 468.661720000000000000
          Top = 26.456710000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = frxDBDatasetReport
          DataSetName = 'PRODUCTOS'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[PRODUCTOS."NPRECIO"] '#8364)
        end
        object BarCode1: TfrxBarCodeView
          Left = 3.779530000000000000
          Top = 15.118120000000000000
          Width = 142.000000000000000000
          Height = 45.354360000000000000
          ShowHint = False
          BarType = bcCode39
          CalcCheckSum = True
          Expression = '<PRODUCTOS."CCODIGO">'
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
        object PRODUCTOSNCOD_PROV: TfrxMemoView
          Left = 600.945270000000000000
          Top = 26.456710000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'NCOD_PROV'
          DataSet = frxDBDatasetReport
          DataSetName = 'PRODUCTOS'
          Memo.UTF8W = (
            '[PRODUCTOS."NCOD_PROV"]')
        end
      end
      object Footer1: TfrxFooter
        Height = 22.677180000000000000
        Top = 302.362400000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          Left = 623.622450000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          HAlign = haRight
          Memo.UTF8W = (
            '[Page#]')
        end
      end
    end
  end
end
