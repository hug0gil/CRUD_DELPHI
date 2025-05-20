object FormMenuUbicaciones: TFormMenuUbicaciones
  Left = 0
  Top = 0
  Caption = 'Men'#250' de ubicaciones'
  ClientHeight = 534
  ClientWidth = 826
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 825
    Height = 534
    Margins.Top = 100
    Align = alLeft
    TabOrder = 0
    ExplicitHeight = 483
    object DBNavigator: TDBNavigator
      Left = 1
      Top = 0
      Width = 464
      Height = 70
      Margins.Bottom = 300
      DataSource = dsTable
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      TabOrder = 0
    end
    object dbgrd1: TDBGrid
      Left = 1
      Top = 70
      Width = 824
      Height = 465
      TabStop = False
      DataSource = dsTable
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'NCODIGO'
          Title.Caption = 'C'#243'digo ubicaci'#243'n'
          Width = 87
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CCOD_ARTICULO'
          Title.Caption = 'C'#243'digo art'#237'culo'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NPASILLO'
          Title.Caption = 'N'#186' de pasillo'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSECCION'
          Title.Caption = 'N'#186' de secci'#243'n'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NFILA'
          Title.Caption = 'Fila'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NCANTIDAD'
          Title.Caption = 'Cantidad'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DFECHA_MOVIMIENTO'
          Title.Caption = 'Fecha de movimiento'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NCOD_ALB_COMPRA'
          Title.Caption = 'C'#243'digo albar'#225'n compra'
          Width = 113
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NCOD_ALB_VENTA'
          Title.Caption = 'C'#243'digo albar'#225'n venta'
          Width = 106
          Visible = True
        end>
    end
    object pnl: TPanel
      Left = 631
      Top = -6
      Width = 187
      Height = 70
      BevelOuter = bvNone
      TabOrder = 2
      object shp1: TShape
        Left = -11
        Top = 73
        Width = 196
        Height = 0
      end
      object rgGroupOrden: TRadioGroup
        Tag = 1
        Left = 30
        Top = 13
        Width = 131
        Height = 52
        Margins.Left = 25
        Margins.Top = 10
        Margins.Right = 25
        Margins.Bottom = 5
        ItemIndex = 0
        Items.Strings = (
          'Ordenar por c'#243'digo'
          'Ordenar por fecha')
        TabOrder = 0
        TabStop = True
        OnClick = rgGroupOrdenClick
      end
    end
    object rgGroupOrden1: TRadioGroup
      Left = 480
      Top = 7
      Width = 131
      Height = 55
      Margins.Left = 25
      Margins.Top = 10
      Margins.Right = 25
      Margins.Bottom = 5
      ItemIndex = 2
      Items.Strings = (
        'Compras'
        'Ventas'
        'Todos')
      TabOrder = 3
      TabStop = True
      OnClick = rgGroupOrdenClick
    end
  end
  object dsTable: TDataSource
    DataSet = pfbdtstTable
    Left = 288
    Top = 136
  end
  object pfbdtstTable: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE MOV_UBICACIONES'
      'SET '
      '    CCOD_ARTICULO = :CCOD_ARTICULO,'
      '    NPASILLO = :NPASILLO,'
      '    NSECCION = :NSECCION,'
      '    NFILA = :NFILA,'
      '    NCANTIDAD = :NCANTIDAD,'
      '    DFECHA_MOVIMIENTO = :DFECHA_MOVIMIENTO,'
      '    NCOD_ALB_COMPRA = :NCOD_ALB_COMPRA,'
      '    NCOD_ALB_VENTA = :NCOD_ALB_VENTA'
      'WHERE'
      '    NCODIGO = :OLD_NCODIGO'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    MOV_UBICACIONES'
      'WHERE'
      '        NCODIGO = :OLD_NCODIGO'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO MOV_UBICACIONES('
      '    NCODIGO,'
      '    CCOD_ARTICULO,'
      '    NPASILLO,'
      '    NSECCION,'
      '    NFILA,'
      '    NCANTIDAD,'
      '    DFECHA_MOVIMIENTO,'
      '    NCOD_ALB_COMPRA,'
      '    NCOD_ALB_VENTA'
      ')'
      'VALUES('
      '    :NCODIGO,'
      '    :CCOD_ARTICULO,'
      '    :NPASILLO,'
      '    :NSECCION,'
      '    :NFILA,'
      '    :NCANTIDAD,'
      '    :DFECHA_MOVIMIENTO,'
      '    :NCOD_ALB_COMPRA,'
      '    :NCOD_ALB_VENTA'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    CCOD_ARTICULO,'
      '    NPASILLO,'
      '    NSECCION,'
      '    NFILA,'
      '    NCANTIDAD,'
      '    DFECHA_MOVIMIENTO,'
      '    NCOD_ALB_COMPRA,'
      '    NCOD_ALB_VENTA'
      'FROM'
      '    MOV_UBICACIONES '
      ''
      ' WHERE '
      '        MOV_UBICACIONES.NCODIGO = :OLD_NCODIGO'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    NCODIGO,'
      '    CCOD_ARTICULO,'
      '    NPASILLO,'
      '    NSECCION,'
      '    NFILA,'
      '    NCANTIDAD,'
      '    DFECHA_MOVIMIENTO,'
      '    NCOD_ALB_COMPRA,'
      '    NCOD_ALB_VENTA'
      'FROM'
      '    MOV_UBICACIONES '
      'ORDER BY NCODIGO')
    Transaction = pFIBTransaction1
    Database = DataModuleBDD.pFIBDatabase
    Left = 344
    Top = 248
    object fbntgrfldTableNCODIGO: TFIBIntegerField
      FieldName = 'NCODIGO'
    end
    object fbstrngfldTableCCOD_ARTICULO: TFIBStringField
      FieldName = 'CCOD_ARTICULO'
      Size = 5
      EmptyStrToNull = True
    end
    object fbsmlntfldTableNPASILLO: TFIBSmallIntField
      FieldName = 'NPASILLO'
    end
    object fbsmlntfldTableNSECCION: TFIBSmallIntField
      FieldName = 'NSECCION'
    end
    object fbsmlntfldTableNFILA: TFIBSmallIntField
      FieldName = 'NFILA'
    end
    object fbcdfldTableNCANTIDAD: TFIBBCDField
      FieldName = 'NCANTIDAD'
      Size = 3
      RoundByScale = True
    end
    object fbdtmfldTableDFECHA_MOVIMIENTO: TFIBDateTimeField
      FieldName = 'DFECHA_MOVIMIENTO'
    end
    object fbntgrfldTableNCOD_ALB_COMPRA: TFIBIntegerField
      FieldName = 'NCOD_ALB_COMPRA'
    end
    object fbntgrfldTableNCOD_ALB_VENTA: TFIBIntegerField
      FieldName = 'NCOD_ALB_VENTA'
    end
  end
  object pFIBTransaction1: TpFIBTransaction
    DefaultDatabase = DataModuleBDD.pFIBDatabase
    TimeoutAction = TARollback
    Left = 480
    Top = 176
  end
end
