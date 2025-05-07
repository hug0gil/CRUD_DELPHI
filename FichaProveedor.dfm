inherited FormFichaProveedor: TFormFichaProveedor
  Caption = 'FormFichaProveedor'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBtns: TPanel
    inherited btnAceptar: TButton
      OnClick = btnAceptarClick
    end
  end
  inherited pnlObjects: TPanel
    inherited pnlFila: TPanel
      inherited pnlCode: TPanel
        inherited lblCodigo: TLabel
          Width = 127
        end
        inherited edtCodigo: TEdit
          NumbersOnly = True
          ReadOnly = False
        end
      end
      object pnlNombre: TPanel
        AlignWithMargins = True
        Left = 328
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
        Width = 158
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 2
        object lblFecha: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 148
          Height = 52
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'Fecha '#250'ltima compra'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 127
        end
        object DateTimePickerFecha: TDateTimePicker
          AlignWithMargins = True
          Left = 15
          Top = 87
          Width = 128
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
          ExplicitWidth = 107
        end
      end
      object pnlRegimen: TPanel
        AlignWithMargins = True
        Left = 480
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
        ExplicitLeft = 459
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
    end
  end
end
