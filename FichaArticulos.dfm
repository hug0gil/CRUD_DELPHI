inherited FormFichaArticulos: TFormFichaArticulos
  Caption = 'FormFichaArticulos'
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
      ExplicitLeft = 233
      ExplicitTop = 41
      object pnlNombre: TPanel
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
        TabOrder = 0
        ExplicitLeft = 3
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
      object pnlStock: TPanel
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
        TabOrder = 2
        ExplicitLeft = 155
        object lblStock: TLabel
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
          Caption = 'Stock'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 37
        end
        object edtStock: TEdit
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
      object pnlCodigoIVA: TPanel
        AlignWithMargins = True
        Left = 459
        Top = 100
        Width = 158
        Height = 148
        Margins.Top = 100
        Margins.Right = 12
        Margins.Bottom = 100
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 1
        ExplicitLeft = 307
        object lblCodigoIVA: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 148
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Align = alTop
          Alignment = taCenter
          Caption = 'C'#243'digo IVA'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 77
        end
        object cbbCodIVA: TComboBox
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
          ExplicitTop = 281
        end
      end
    end
  end
end
