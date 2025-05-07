inherited FormMenuProveedores: TFormMenuProveedores
  Caption = 'Proveedores'
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
end
