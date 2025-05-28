inherited FormMenuProveedores: TFormMenuProveedores
  Caption = 'Proveedores'
  OnCreate = FormCreate
  ExplicitWidth = 716
  ExplicitHeight = 615
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
          Width = 75
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DFECHA_ULT_COMPRA'
          Title.Caption = 'Fecha '#250'ltima compra'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CNOMBRE'
          Title.Caption = 'Nombre'
          Width = 170
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CREG_FISCAL'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'CREG_NOMBRE'
          Title.Caption = 'R'#233'gimen fiscal'
          Width = 122
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
      'UPDATE PROVEEDORES'
      'SET '
      '    DFECHA_ULT_COMPRA = :DFECHA_ULT_COMPRA,'
      '    CNOMBRE = :CNOMBRE,'
      '    CREG_FISCAL = :CREG_FISCAL'
      'WHERE'
      '    NCODIGO = :OLD_NCODIGO'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    PROVEEDORES'
      'WHERE'
      '        NCODIGO = :OLD_NCODIGO'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO PROVEEDORES('
      '    NCODIGO,'
      '    DFECHA_ULT_COMPRA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      ')'
      'VALUES('
      '    :NCODIGO,'
      '    :DFECHA_ULT_COMPRA,'
      '    :CNOMBRE,'
      '    :CREG_FISCAL'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA_ULT_COMPRA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      'FROM'
      '    PROVEEDORES '
      ''
      ' WHERE '
      '        PROVEEDORES.NCODIGO = :OLD_NCODIGO'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA_ULT_COMPRA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      'FROM'
      '    PROVEEDORES ')
    OnCalcFields = pFIBDataSetTableCalcFields
    Database = DataModuleBDD.pFIBDatabase
    UpdateTransaction = DataModuleBDD.pFIBTransaction
    object fbntgrfldFIBDataSetTableNCODIGO: TFIBIntegerField
      FieldName = 'NCODIGO'
    end
    object fbdtfldFIBDataSetTableDEFECHA_ULT_COMPRA: TFIBDateField
      FieldName = 'DFECHA_ULT_COMPRA'
    end
    object fbstrngfldFIBDataSetTableCNOMBRE: TFIBStringField
      FieldName = 'CNOMBRE'
      Size = 100
      EmptyStrToNull = True
    end
    object fbstrngfldFIBDataSetTableCREG_FISCAL: TFIBStringField
      FieldName = 'CREG_FISCAL'
      Size = 1
      EmptyStrToNull = True
    end
    object strngfldFIBDataSetTableCREG_NOMBRE: TStringField
      FieldKind = fkCalculated
      FieldName = 'CREG_NOMBRE'
      Calculated = True
    end
  end
  inherited DataSetReport: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE PROVEEDORES'
      'SET '
      '    DFECHA_ULT_COMPRA = :DFECHA_ULT_COMPRA,'
      '    CNOMBRE = :CNOMBRE,'
      '    CREG_FISCAL = :CREG_FISCAL'
      'WHERE'
      '    NCODIGO = :OLD_NCODIGO'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    PROVEEDORES'
      'WHERE'
      '        NCODIGO = :OLD_NCODIGO'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO PROVEEDORES('
      '    NCODIGO,'
      '    DFECHA_ULT_COMPRA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      ')'
      'VALUES('
      '    :NCODIGO,'
      '    :DFECHA_ULT_COMPRA,'
      '    :CNOMBRE,'
      '    :CREG_FISCAL'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA_ULT_COMPRA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      'FROM'
      '    PROVEEDORES '
      ''
      ' WHERE '
      '        PROVEEDORES.NCODIGO = :OLD_NCODIGO'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA_ULT_COMPRA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      'FROM'
      '    PROVEEDORES ')
  end
  inherited frxDBDatasetReport: TfrxDBDataset
    UserName = 'PROVEEDORES'
  end
  inherited frxReport: TfrxReport
    ReportOptions.CreateDate = 45798.433929513900000000
    ReportOptions.LastChange = 45798.433929513900000000
    Datasets = <
      item
        DataSet = frxDBDatasetReport
        DataSetName = 'PROVEEDORES'
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
            '<b>Listado de proveedores</b>')
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
          Top = 7.559059999999999000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'C'#243'digo cliente')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          Left = 181.417440000000000000
          Top = 7.559060000000000000
          Width = 162.519790000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Fecha '#250'ltima compra')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 381.732530000000000000
          Top = 7.559059999999999000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Nombre')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Left = 585.827150000000000000
          Top = 3.779529999999999000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'R'#233'gimen fiscal')
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
      end
      object MasterData1: TfrxMasterData
        Height = 34.015770000000000000
        Top = 200.315090000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDatasetReport
        DataSetName = 'PROVEEDORES'
        RowCount = 0
        object Memo2: TfrxMemoView
          Left = 15.118120000000000000
          Top = 7.559060000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = FormMenuBase.frxDBDatasetReport
          DataSetName = 'CLIENTES'
          HAlign = haRight
          Memo.UTF8W = (
            '[PROVEEDORES."NCODIGO"]')
        end
        object Memo8: TfrxMemoView
          Left = 381.732530000000000000
          Top = 7.559060000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = FormMenuBase.frxDBDatasetReport
          DataSetName = 'CLIENTES'
          Memo.UTF8W = (
            '[PROVEEDORES."CNOMBRE"]')
        end
        object Memo10: TfrxMemoView
          Left = 585.827150000000000000
          Top = 7.559060000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          OnBeforePrint = 'Memo10OnBeforePrint'
          ShowHint = False
          DataSet = FormMenuBase.frxDBDatasetReport
          DataSetName = 'CLIENTES'
          Memo.UTF8W = (
            '[PROVEEDORES."CREG_FISCAL"]')
        end
        object Memo6: TfrxMemoView
          Left = 181.417440000000000000
          Top = 7.559060000000000000
          Width = 139.842610000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataSet = FormMenuBase.frxDBDatasetReport
          DataSetName = 'CLIENTES'
          Memo.UTF8W = (
            '[PROVEEDORES."DFECHA_ULT_COMPRA"]')
        end
      end
      object Footer1: TfrxFooter
        Height = 22.677180000000000000
        Top = 257.008040000000000000
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
