object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 435
  ClientWidth = 639
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnVer: TButton
    AlignWithMargins = True
    Left = 70
    Top = 100
    Width = 499
    Height = 73
    Margins.Left = 70
    Margins.Top = 100
    Margins.Right = 70
    Margins.Bottom = 50
    Align = alTop
    Caption = 'Ver'
    TabOrder = 0
    OnClick = btnVerClick
  end
  object btnEditar: TButton
    AlignWithMargins = True
    Left = 70
    Top = 273
    Width = 499
    Height = 73
    Margins.Left = 70
    Margins.Top = 50
    Margins.Right = 70
    Margins.Bottom = 70
    Align = alTop
    Caption = 'Editar'
    TabOrder = 1
    OnClick = btnEditarClick
  end
  object frxReport: TfrxReport
    Version = '4.9.20'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45797.572589768500000000
    ReportOptions.LastChange = 45798.387524849540000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'begin'
      ''
      'end.')
    ShowProgress = False
    Left = 552
    Top = 32
    Datasets = <
      item
        DataSet = frxDBDataset
        DataSetName = 'CLIENTES'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 128.504020000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo4: TfrxMemoView
          Align = baLeft
          Top = 86.929190000000000000
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
          Left = 166.299320000000000000
          Top = 86.929190000000000000
          Width = 147.401670000000000000
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
          Left = 366.614410000000000000
          Top = 86.929190000000000000
          Width = 94.488250000000000000
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
          Left = 566.929500000000000000
          Top = 83.149660000000000000
          Width = 139.842610000000000000
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
          Top = 118.110233780000000000
          Width = 691.653538430000000000
          ShowHint = False
          Diagonal = True
        end
        object Line1: TfrxLineView
          Top = 117.543304650000000000
          Width = 691.653538430000000000
          ShowHint = False
          Diagonal = True
        end
      end
      object MasterData1: TfrxMasterData
        Height = 75.590600000000000000
        Top = 207.874150000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDataset
        DataSetName = 'CLIENTES'
        RowCount = 0
        object Memo2: TfrxMemoView
          Top = 45.354360000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'NCODIGO'
          DataSet = frxDBDataset
          DataSetName = 'CLIENTES'
          Memo.UTF8W = (
            '[CLIENTES."NCODIGO"]')
        end
        object Memo6: TfrxMemoView
          Left = 170.078850000000000000
          Top = 45.354360000000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'DFECHA_ULT_VENTA'
          DataSet = frxDBDataset
          DataSetName = 'CLIENTES'
          Memo.UTF8W = (
            '[CLIENTES."DFECHA_ULT_VENTA"]')
        end
        object Memo8: TfrxMemoView
          Left = 362.834880000000000000
          Top = 45.354360000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'CNOMBRE'
          DataSet = frxDBDataset
          DataSetName = 'CLIENTES'
          Memo.UTF8W = (
            '[CLIENTES."CNOMBRE"]')
        end
        object Memo10: TfrxMemoView
          Left = 566.929500000000000000
          Top = 45.354360000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'CREG_FISCAL'
          DataSet = frxDBDataset
          DataSetName = 'CLIENTES'
          Memo.UTF8W = (
            '[CLIENTES."CREG_FISCAL"]')
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 22.677180000000000000
        Top = 343.937230000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          Left = 642.520100000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          HAlign = haRight
          Memo.UTF8W = (
            '[Page#]')
        end
      end
      object Memo3: TfrxMemoView
        Align = baLeft
        Top = 15.118120000000000000
        Width = 362.834880000000000000
        Height = 37.795300000000000000
        ShowHint = False
        AllowHTMLTags = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        Memo.UTF8W = (
          '<b>Listado de clientes</b>')
        ParentFont = False
      end
    end
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'CLIENTES'
    CloseDataSource = False
    OpenDataSource = False
    DataSet = DataSet
    BCDToCurrency = False
    Left = 472
    Top = 32
  end
  object pFIBTransaction: TpFIBTransaction
    Active = True
    DefaultDatabase = DataModuleBDD.pFIBDatabase
    TimeoutAction = TARollback
    Left = 176
    Top = 24
  end
  object DataSource: TDataSource
    DataSet = DataSet
    Left = 288
    Top = 24
  end
  object DataSet: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    DFECHA_ULT_VENTA,'
      '    CNOMBRE,'
      '    CREG_FISCAL'
      'FROM'
      '    CLIENTES ')
    Active = True
    Transaction = pFIBTransaction
    Database = DataModuleBDD.pFIBDatabase
    Left = 384
    Top = 32
  end
end
