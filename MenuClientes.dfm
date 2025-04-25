inherited FormMenuClientes: TFormMenuClientes
  Caption = 'Clientes'
  OnCreate = FormCreate
  ExplicitWidth = 716
  ExplicitHeight = 524
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
end
