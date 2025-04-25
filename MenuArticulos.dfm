inherited FormMenuArticulos: TFormMenuArticulos
  Caption = 'Art'#237'culos'
  OnCreate = FormCreate
  ExplicitWidth = 716
  ExplicitHeight = 524
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited btnActualizar: TButton
      Tag = 1
      OnClick = btnClick
      ExplicitLeft = 25
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
      ExplicitTop = 193
    end
    inherited rgGroupOrden: TRadioGroup
      Items.Strings = (
        'Ordenar por c'#243'digo'
        'Ordenar por nombre')
      OnClick = rgGroupOrdenClick
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
          FieldName = 'CCODIGO'
          Title.Caption = 'C'#243'digo'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CNOMBRE'
          Title.Caption = 'Nombre'
          Width = 130
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSTOCK'
          Title.Caption = 'Stock'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NCOD_IVA'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'NFACTCONV'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'NUNICAJ'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'CNOMBRE_IVA'
          Title.Caption = 'Tipo IVA'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NPRECIO'
          Title.Caption = 'PVP/'#8364
          Width = 94
          Visible = True
        end>
    end
  end
  inherited pFIBTransactionTable: TpFIBTransaction
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
      '    NPRECIO = :NPRECIO'
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
      '    NPRECIO'
      ')'
      'VALUES('
      '    :CCODIGO,'
      '    :CNOMBRE,'
      '    :NSTOCK,'
      '    :NCOD_IVA,'
      '    :NFACTCONV,'
      '    :NUNICAJ,'
      '    :NPRECIO'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    CCODIGO,'
      '    CNOMBRE,'
      '    NSTOCK,'
      '    NCOD_IVA,'
      '    NFACTCONV,'
      '    NUNICAJ,'
      '    NPRECIO'
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
      '    NPRECIO'
      'FROM'
      '    ARTICULOS'
      'ORDER BY CCODIGO')
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
  end
end
