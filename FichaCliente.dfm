inherited FormFichaCliente: TFormFichaCliente
  Caption = 'FormFichaCliente'
  ExplicitWidth = 640
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBtns: TPanel
    inherited btnAceptar: TButton
      OnClick = btnAceptarClick
    end
  end
  inherited pnlObjects: TPanel
    ExplicitLeft = 145
    ExplicitWidth = 489
    inherited pnlFila: TPanel
      ExplicitWidth = 487
      object pnlNombre: TPanel
        AlignWithMargins = True
        Left = 307
        Top = 100
        Width = 137
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 0
        ExplicitLeft = 155
        object lblNombre: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'Nombre'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 58
        end
        object edtNombre: TEdit
          AlignWithMargins = True
          Left = 15
          Top = 87
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Alignment = taCenter
          TabOrder = 0
        end
      end
      object pnlFecha: TPanel
        AlignWithMargins = True
        Left = 155
        Top = 100
        Width = 137
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 2
        ExplicitLeft = 3
        object lblFecha: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'Fecha '#250'ltima venta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 130
        end
        object DateTimePickerFecha: TDateTimePicker
          AlignWithMargins = True
          Left = 15
          Top = 87
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Date = 45754.371326111110000000
          Time = 45754.371326111110000000
          Enabled = False
          TabOrder = 0
        end
      end
      object pnlRegimen: TPanel
        AlignWithMargins = True
        Left = 459
        Top = 100
        Width = 137
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 1
        ExplicitLeft = 307
        object lblRegimen: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'R'#233'gimen fiscal'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 101
        end
        object ComboBoxRegimen: TComboBox
          AlignWithMargins = True
          Left = 15
          Top = 87
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Style = csDropDownList
          TabOrder = 0
        end
      end
      object pnlCode: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 100
        Width = 137
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 3
        Visible = False
        ExplicitLeft = 5
        ExplicitTop = 3
        ExplicitHeight = 342
        object lblCodigo: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 15
          Width = 127
          Height = 21
          Margins.Left = 5
          Margins.Top = 15
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'C'#243'digo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 50
        end
        object edtCodigo: TMaskEdit
          AlignWithMargins = True
          Left = 15
          Top = 87
          Width = 107
          Height = 21
          Margins.Left = 15
          Margins.Top = 40
          Margins.Right = 15
          Margins.Bottom = 40
          Align = alBottom
          Alignment = taCenter
          Enabled = False
          TabOrder = 0
        end
      end
    end
  end
end
