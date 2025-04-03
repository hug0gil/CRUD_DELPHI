inherited FormFichaGridAlbaran: TFormFichaGridAlbaran
  Caption = 'FormFichaGridAlbaran'
  Position = poScreenCenter
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 15
  inherited PanelAlbaranes: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited LabelObservaciones: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited LabelCodCliente: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited LabelFecha: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited Label1: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited EditCodigo: TEdit
      StyleElements = [seFont, seClient, seBorder]
    end
    inherited MemoObservaciones: TMemo
      StyleElements = [seFont, seClient, seBorder]
    end
  end
  inherited PanelLineas: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited DBGrid: TDBGrid
      Top = 0
      Height = 235
      Align = alClient
      Columns = <
        item
          Expanded = False
          FieldName = 'NCOD_ALBARAN'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CCOD_ARTICULO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NCANTIDAD'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NPRECIO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NORDEN'
          Visible = True
        end>
    end
  end
  inherited PanelBtns: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited btnAceptar: TButton
      OnClick = btnAceptarClick
    end
    inherited btnCancelar: TButton
      OnClick = btnCancelarClick
    end
    inherited ButtonBorrar: TButton
      OnClick = ButtonBorrarClick
    end
    inherited ButtonInsertar: TButton
      OnClick = ButtonInsertarClick
    end
    inherited ButtonActualizar: TButton
      OnClick = ButtonActualizarClick
    end
    inherited ButtonVer: TButton
      OnClick = ButtonVerClick
    end
  end
  inherited ComboBoxCodCliente: TComboBox
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited DataSource: TDataSource
    OnDataChange = DataSourceDataChange
  end
  inherited FDTable: TFDTable
    IndexFieldNames = 'NORDEN;NCOD_ALBARAN'
    TableName = 'LINEAS_ALB'
    object FDTableNCOD_ALBARAN: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = 'C'#243'digo albar'#225'n'
      FieldName = 'NCOD_ALBARAN'
      Origin = 'NCOD_ALBARAN'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDTableCCOD_ARTICULO: TStringField
      DisplayLabel = 'C'#243'digo art'#237'culo'
      FieldName = 'CCOD_ARTICULO'
      Origin = 'CCOD_ARTICULO'
      Required = True
      Size = 5
    end
    object FDTableNCANTIDAD: TFMTBCDField
      Alignment = taLeftJustify
      DisplayLabel = 'Cantidad'
      FieldName = 'NCANTIDAD'
      Origin = 'NCANTIDAD'
      Required = True
      Precision = 18
      Size = 3
    end
    object FDTableNPRECIO: TFMTBCDField
      Alignment = taLeftJustify
      DisplayLabel = 'Precio'
      FieldName = 'NPRECIO'
      Origin = 'NPRECIO'
      Required = True
      Precision = 18
      Size = 3
    end
    object FDTableNORDEN: TSmallintField
      Alignment = taLeftJustify
      DisplayLabel = 'Orden'
      FieldName = 'NORDEN'
      Origin = 'NORDEN'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  inherited FDTransactionTable: TFDTransaction
    Left = 560
    Top = 192
  end
end
