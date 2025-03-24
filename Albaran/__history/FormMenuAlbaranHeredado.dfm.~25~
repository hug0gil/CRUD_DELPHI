inherited FormMenuAlbaran: TFormMenuAlbaran
  Caption = 'Men'#250' albaran'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 15
  inherited Panel1: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited Panel2: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited DBNavigator: TDBNavigator
      Hints.Strings = ()
    end
  end
  inherited FDTable: TFDTable
    Active = True
    IndexFieldNames = 'NCODIGO'
    Transaction = DataModuleBDD.FDTransaction
    UpdateOptions.AssignedValues = [uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    TableName = 'ALBARAN'
    object FDTableNCODIGO: TIntegerField
      FieldName = 'NCODIGO'
      Origin = 'NCODIGO'
      Required = True
    end
    object FDTableDFECHA: TDateField
      FieldName = 'DFECHA'
      Origin = 'DFECHA'
      Required = True
    end
    object FDTableCOBSERVACIONES: TStringField
      FieldName = 'COBSERVACIONES'
      Origin = 'COBSERVACIONES'
      Size = 255
    end
    object FDTableNCOD_CLIENTE: TIntegerField
      FieldName = 'NCOD_CLIENTE'
      Origin = 'NCOD_CLIENTE'
      Required = True
    end
  end
end
