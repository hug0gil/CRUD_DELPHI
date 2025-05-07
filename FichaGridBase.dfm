object FormFichaGridBase0: TFormFichaGridBase0
  Left = 0
  Top = 0
  Caption = 'FormFichaGridBase0'
  ClientHeight = 441
  ClientWidth = 784
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
    Left = 0
    Top = 153
    Width = 784
    Height = 2
    Align = alTop
    ExplicitLeft = -149
  end
  object Shape2: TShape
    Left = 0
    Top = 396
    Width = 784
    Height = 2
    Align = alBottom
    ExplicitLeft = -149
    ExplicitTop = 297
  end
  object PanelAlbaranes: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 153
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object LabelObservaciones: TLabel
      AlignWithMargins = True
      Left = 331
      Top = 14
      Width = 86
      Height = 17
      Margins.Left = 25
      Margins.Top = 15
      Margins.Right = 30
      Margins.Bottom = 10
      Caption = 'Observaciones'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelCodCliente: TLabel
      AlignWithMargins = True
      Left = 31
      Top = 63
      Width = 43
      Height = 17
      Margins.Left = 25
      Margins.Top = 15
      Margins.Right = 30
      Margins.Bottom = 10
      Caption = 'C'#243'digo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelFecha: TLabel
      AlignWithMargins = True
      Left = 31
      Top = 119
      Width = 37
      Height = 17
      Margins.Left = 25
      Margins.Top = 15
      Margins.Right = 30
      Margins.Bottom = 10
      Caption = 'Fecha '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 31
      Top = 14
      Width = 43
      Height = 17
      Margins.Left = 25
      Margins.Top = 15
      Margins.Right = 30
      Margins.Bottom = 10
      Caption = 'C'#243'digo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object EditCodigo: TEdit
      Left = 101
      Top = 13
      Width = 121
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object DateTimePickerFecha: TDateTimePicker
      Left = 101
      Top = 113
      Width = 121
      Height = 23
      Date = 45743.741379814810000000
      Time = 45743.741379814810000000
      TabOrder = 1
    end
    object MemoObservaciones: TMemo
      Left = 434
      Top = 14
      Width = 271
      Height = 122
      Lines.Strings = (
        'MemoObservaciones')
      TabOrder = 2
    end
    object cbbCod: TComboBox
      Left = 148
      Top = 62
      Width = 121
      Height = 21
      BevelInner = bvNone
      Style = csDropDownList
      TabOrder = 3
    end
  end
  object PanelBtns: TPanel
    Left = 0
    Top = 398
    Width = 784
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnAceptar: TButton
      AlignWithMargins = True
      Left = 614
      Top = 10
      Width = 75
      Height = 28
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Aceptar'
      TabOrder = 0
    end
    object btnCancelar: TButton
      AlignWithMargins = True
      Left = 699
      Top = 10
      Width = 75
      Height = 28
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = btnCancelarClick
    end
    object ButtonBorrar: TButton
      AlignWithMargins = True
      Left = 275
      Top = 10
      Width = 75
      Height = 28
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Borrar'
      Enabled = False
      TabOrder = 2
    end
    object ButtonInsertar: TButton
      AlignWithMargins = True
      Left = 5
      Top = 10
      Width = 75
      Height = 28
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Insertar'
      Enabled = False
      TabOrder = 3
    end
    object ButtonActualizar: TButton
      AlignWithMargins = True
      Left = 185
      Top = 10
      Width = 75
      Height = 28
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Actualizar'
      Enabled = False
      TabOrder = 4
    end
    object ButtonVer: TButton
      AlignWithMargins = True
      Left = 95
      Top = 10
      Width = 75
      Height = 28
      Margins.Left = 5
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Ver'
      Enabled = False
      TabOrder = 5
    end
  end
  object PanelLineas: TPanel
    Left = 0
    Top = 155
    Width = 784
    Height = 241
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object DBGrid: TDBGrid
      Left = 0
      Top = -178
      Width = 784
      Height = 419
      Align = alBottom
      DataSource = DataSource
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object DataSource: TDataSource
    DataSet = pFIBDataSetTable
    Left = 728
    Top = 192
  end
  object pFIBDataSetTable: TpFIBDataSet
    Transaction = pFIBTransactionTable
    Left = 384
    Top = 224
  end
  object pFIBQueryTable: TpFIBQuery
    Transaction = pFIBTransactionTable
    Database = DataModuleBDD.pFIBDatabase
    Left = 616
    Top = 232
  end
  object pFIBTransactionTable: TpFIBTransaction
    DefaultDatabase = DataModuleBDD.pFIBDatabase
    TimeoutAction = TARollback
    Left = 512
    Top = 192
  end
end
