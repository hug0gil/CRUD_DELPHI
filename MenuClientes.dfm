inherited FormMenuClientes: TFormMenuClientes
  Caption = 'Clientes'
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
          FieldName = 'DFECHA_ULT_VENTA'
          Title.Caption = 'Fecha '#250'ltima venta'
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
          Width = 122
          Visible = True
        end>
    end
  end
  inherited pFIBTransactionTable: TpFIBTransaction
    DefaultDatabase = DataModuleBDD.pFIBDatabase
  end
  inherited pFIBDataSetTable: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE CLIENTES'
      'SET '
      '    DFECHA_ULT_VENTA = :DFECHA_ULT_VENTA,'
      '    CNOMBRE = :CNOMBRE,'
      '    CREG_FISCAL = :CREG_FISCAL'
      'WHERE'
      '    NCODIGO = :OLD_NCODIGO'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    CLIENTES'
      'WHERE'
      '        NCODIGO = :OLD_NCODIGO'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO CLIENTES('
      '    NCODIGO,'
      '    DFECHA_ULT_VENTA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      ')'
      'VALUES('
      '    :NCODIGO,'
      '    :DFECHA_ULT_VENTA,'
      '    :CNOMBRE,'
      '    :CREG_FISCAL'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA_ULT_VENTA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      'FROM'
      '    CLIENTES '
      ''
      ' WHERE '
      '        CLIENTES.NCODIGO = :OLD_NCODIGO'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA_ULT_VENTA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      'FROM'
      '    CLIENTES '
      '')
    OnCalcFields = pFIBDataSetTableCalcFields
    object pFIBDataSetTableNCODIGO: TFIBIntegerField
      FieldName = 'NCODIGO'
    end
    object pFIBDataSetTableDFECHA_ULT_VENTA: TFIBDateField
      FieldName = 'DFECHA_ULT_VENTA'
    end
    object pFIBDataSetTableCNOMBRE: TFIBStringField
      FieldName = 'CNOMBRE'
      Size = 100
      EmptyStrToNull = True
    end
    object pFIBDataSetTableCREG_FISCAL: TFIBStringField
      FieldName = 'CREG_FISCAL'
      Visible = False
      Size = 1
      EmptyStrToNull = True
    end
    object pFIBDataSetTableCREG_NOMBRE: TStringField
      DisplayLabel = 'R'#233'gimen fiscal'
      FieldKind = fkCalculated
      FieldName = 'CREG_NOMBRE'
      Calculated = True
    end
  end
  inherited DataSetReport: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA_ULT_VENTA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      'FROM'
      '    CLIENTES ')
    Active = True
    Left = 104
    Top = 456
  end
  inherited frxReport: TfrxReport
    ReportOptions.CreateDate = 45797.572589768500000000
    ReportOptions.LastChange = 45798.572045578700000000
    ScriptText.Strings = (
      'begin'
      ''
      'end.            ')
    Datasets = <
      item
        DataSet = frxDBDatasetReport
        DataSetName = 'CLIENTES'
      end>
    Variables = <>
    Style = <>
    inherited Page1: TfrxReportPage
      object ReportTitle1: TfrxReportTitle
        Height = 41.574830000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
      end
      object PageFooter1: TfrxPageFooter
        Height = 22.677180000000000000
        Top = 340.157700000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          Left = 638.740570000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          HAlign = haRight
          Memo.UTF8W = (
            '[Page#]')
        end
      end
      object PageHeader1: TfrxPageHeader
        Height = 71.811070000000000000
        Top = 83.149660000000000000
        Width = 718.110700000000000000
        object Memo4: TfrxMemoView
          Left = 7.559060000000000000
          Top = 26.456710000000000000
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
          Left = 173.858380000000000000
          Top = 26.456710000000000000
          Width = 139.842610000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Fecha '#250'ltima venta')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 374.173470000000000000
          Top = 26.456710000000000000
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
          Left = 578.268090000000000000
          Top = 22.677180000000000000
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
          Left = 7.559060000000000000
          Top = 57.637753780000000000
          Width = 684.094478430000000000
          ShowHint = False
          Diagonal = True
        end
        object Line1: TfrxLineView
          Left = 7.559060000000000000
          Top = 57.070824650000000000
          Width = 684.094478430000000000
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
          '<b>Listado de clientes</b>')
        ParentFont = False
        VAlign = vaCenter
      end
      object MasterData1: TfrxMasterData
        Height = 64.252010000000000000
        Top = 215.433210000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDatasetReport
        DataSetName = 'CLIENTES'
        RowCount = 0
        object Memo12: TfrxMemoView
          Width = 718.110700000000000000
          Height = 64.252010000000000000
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
        object Memo10: TfrxMemoView
          Left = 578.268090000000000000
          Top = 22.677180000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          OnBeforePrint = 'Memo10OnBeforePrint'
          ShowHint = False
          DataField = 'CREG_FISCAL'
          DataSet = FormMenuBase.frxDBDatasetReport
          DataSetName = 'CLIENTES'
          Memo.UTF8W = (
            '[CLIENTES."CREG_FISCAL"]')
        end
        object Memo3: TfrxMemoView
          Left = 374.173470000000000000
          Top = 22.677180000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'CNOMBRE'
          DataSet = FormMenuBase.frxDBDatasetReport
          DataSetName = 'CLIENTES'
          Memo.UTF8W = (
            '[CLIENTES."CNOMBRE"]')
        end
        object Memo13: TfrxMemoView
          Left = 173.858380000000000000
          Top = 22.677180000000000000
          Width = 139.842610000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'DFECHA_ULT_VENTA'
          DataSet = FormMenuBase.frxDBDatasetReport
          DataSetName = 'CLIENTES'
          Memo.UTF8W = (
            '[CLIENTES."DFECHA_ULT_VENTA"]')
        end
        object Memo14: TfrxMemoView
          Left = 7.559060000000000000
          Top = 22.677180000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'NCODIGO'
          DataSet = FormMenuBase.frxDBDatasetReport
          DataSetName = 'CLIENTES'
          HAlign = haRight
          Memo.UTF8W = (
            '[CLIENTES."NCODIGO"]')
        end
      end
    end
  end
end
