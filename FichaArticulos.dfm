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
    inherited pnlFila: TPanel
      inherited pnlCode: TPanel
        inherited lblCodigo: TLabel
          Width = 127
        end
        inherited edtCodigo: TEdit
          Hint = 'Introduce un c'#243'digo alfanum'#233'rico de 5 caracteres'
          MaxLength = 5
          ParentShowHint = False
          ReadOnly = False
          ShowHint = True
        end
      end
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
        TabOrder = 1
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
        TabOrder = 3
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
          ExplicitWidth = 114
        end
      end
    end
  end
end
