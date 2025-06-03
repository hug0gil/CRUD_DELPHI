object FormMenuBase: TFormMenuBase
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FormMenuBase'
  ClientHeight = 586
  ClientWidth = 710
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
  object Shape1: TShape
    Left = 526
    Top = 0
    Width = 2
    Height = 586
    Align = alRight
    ExplicitLeft = 525
    ExplicitTop = 3
    ExplicitHeight = 489
  end
  object Panel1: TPanel
    Left = 528
    Top = 0
    Width = 182
    Height = 586
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object shp1: TShape
      Left = -11
      Top = 79
      Width = 196
      Height = 2
    end
    object btnActualizar: TButton
      AlignWithMargins = True
      Left = 25
      Top = 288
      Width = 132
      Height = 80
      Margins.Left = 25
      Margins.Top = 10
      Margins.Right = 25
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Actualizar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object btnAgregar: TButton
      AlignWithMargins = True
      Left = 25
      Top = 98
      Width = 132
      Height = 80
      Margins.Left = 25
      Margins.Top = 25
      Margins.Right = 25
      Margins.Bottom = 5
      Align = alTop
      Caption = 'A'#241'adir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object btnEliminar: TButton
      AlignWithMargins = True
      Left = 25
      Top = 383
      Width = 132
      Height = 80
      Margins.Left = 25
      Margins.Top = 10
      Margins.Right = 25
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Eliminar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object btnVer: TButton
      AlignWithMargins = True
      Left = 25
      Top = 193
      Width = 132
      Height = 80
      Margins.Left = 25
      Margins.Top = 10
      Margins.Right = 25
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Ver'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object rgGroupOrden: TRadioGroup
      AlignWithMargins = True
      Left = 25
      Top = 3
      Width = 132
      Height = 65
      Margins.Left = 25
      Margins.Right = 25
      Margins.Bottom = 5
      Align = alTop
      ItemIndex = 0
      Items.Strings = (
        'Ordenar por nombre'
        'Ordenar por c'#243'digo')
      TabOrder = 4
      TabStop = True
    end
    object btnImprimir: TButton
      Tag = 3
      AlignWithMargins = True
      Left = 25
      Top = 483
      Width = 132
      Height = 80
      Margins.Left = 25
      Margins.Top = 15
      Margins.Right = 25
      Margins.Bottom = 25
      Align = alTop
      Caption = 'Imprimir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 526
    Height = 586
    Margins.Top = 100
    Align = alClient
    TabOrder = 1
    object DBNavigator: TDBNavigator
      Left = 1
      Top = 1
      Width = 524
      Height = 69
      Margins.Bottom = 300
      DataSource = DataSourceTable
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Align = alTop
      TabOrder = 0
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 70
      Width = 524
      Height = 545
      TabStop = False
      Align = alTop
      DataSource = DataSourceTable
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object pFIBTransactionTable: TpFIBTransaction
    TimeoutAction = TARollback
    Left = 392
    Top = 144
  end
  object DataSourceTable: TDataSource
    DataSet = pFIBDataSetTable
    Left = 288
    Top = 136
  end
  object pFIBDataSetTable: TpFIBDataSet
    Transaction = pFIBTransactionTable
    Left = 344
    Top = 248
  end
  object pFIBQueryDelete: TpFIBQuery
    Transaction = pFIBTransactionTable
    Database = DataModuleBDD.pFIBDatabase
    Left = 240
    Top = 208
  end
  object DataSetReport: TpFIBDataSet
    Transaction = pFIBTransactionReport
    Database = DataModuleBDD.pFIBDatabase
    Left = 112
    Top = 488
  end
  object frxDBDatasetReport: TfrxDBDataset
    UserName = 'CLIENTES'
    CloseDataSource = False
    OpenDataSource = False
    DataSet = DataSetReport
    BCDToCurrency = False
    Left = 152
    Top = 488
  end
  object frxReport: TfrxReport
    Version = '4.9.20'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45798.433929513890000000
    ReportOptions.LastChange = 45798.433929513890000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'begin'
      ''
      'end.')
    ShowProgress = False
    Left = 216
    Top = 488
    Datasets = <>
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
    end
  end
  object pFIBTransactionReport: TpFIBTransaction
    DefaultDatabase = DataModuleBDD.pFIBDatabase
    TimeoutAction = TARollback
    Left = 64
    Top = 488
  end
  object DataSourceReport: TDataSource
    DataSet = DataSetReport
    Left = 264
    Top = 488
  end
  object frxPDFExport1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 344
    Top = 312
  end
  object frxHTMLExport1: TfrxHTMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    FixedWidth = True
    Background = False
    Centered = False
    EmptyLines = True
    Print = False
    Left = 352
    Top = 320
  end
  object frxXLSExport1: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 360
    Top = 328
  end
  object frxXMLExport1: TfrxXMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    RowsCount = 0
    Split = ssNotSplit
    Left = 368
    Top = 336
  end
  object frxRTFExport1: TfrxRTFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ExportEMF = True
    Wysiwyg = True
    Creator = 'FastReport'
    SuppressPageHeadersFooters = False
    HeaderFooterMode = hfText
    AutoSize = False
    Left = 376
    Top = 344
  end
  object frxBMPExport1: TfrxBMPExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Left = 384
    Top = 352
  end
  object frxJPEGExport1: TfrxJPEGExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Left = 392
    Top = 360
  end
  object frxTIFFExport1: TfrxTIFFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Left = 400
    Top = 368
  end
  object frxGIFExport1: TfrxGIFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Left = 408
    Top = 376
  end
  object frxSimpleTextExport1: TfrxSimpleTextExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Frames = False
    EmptyLines = False
    OEMCodepage = False
    Left = 416
    Top = 384
  end
  object frxCSVExport1: TfrxCSVExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Separator = ';'
    OEMCodepage = False
    NoSysSymbols = True
    Left = 424
    Top = 392
  end
  object frxMailExport1: TfrxMailExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ShowExportDialog = True
    SmtpPort = 25
    UseIniFile = True
    TimeOut = 60
    ConfurmReading = False
    Left = 432
    Top = 400
  end
  object frxODSExport1: TfrxODSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ExportEMF = True
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 440
    Top = 408
  end
  object frxODTExport1: TfrxODTExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ExportEMF = True
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 448
    Top = 416
  end
  object frxDBFExport1: TfrxDBFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    OEMCodepage = False
    Left = 456
    Top = 424
  end
  object frxBarCodeObject1: TfrxBarCodeObject
    Left = 248
    Top = 336
  end
  object IdHTTP: TIdHTTP
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 128
    Top = 344
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 56
    Top = 384
  end
end
