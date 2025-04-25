object FormMenuBase: TFormMenuBase
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FormMenuBase'
  ClientHeight = 495
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
    Height = 495
    Align = alRight
    ExplicitLeft = 525
    ExplicitTop = 3
    ExplicitHeight = 489
  end
  object Panel1: TPanel
    Left = 528
    Top = 0
    Width = 182
    Height = 495
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
      ExplicitLeft = 26
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
      Top = 388
      Width = 132
      Height = 80
      Margins.Left = 25
      Margins.Top = 15
      Margins.Right = 25
      Margins.Bottom = 25
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
      ExplicitTop = 176
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
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 526
    Height = 495
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
      Height = 420
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
end
