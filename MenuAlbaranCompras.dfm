inherited FormMenuAlbaranCompras: TFormMenuAlbaranCompras
  Caption = 'Albaranes de compra'
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
        'Ordenar por fecha')
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
end
