inherited FormFichaUbicacion: TFormFichaUbicacion
  Caption = 'FormFichaUbicacion'
  ClientWidth = 461
  ExplicitWidth = 467
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 13
  inherited shp: TShape
    Width = 461
    ExplicitWidth = 461
  end
  inherited shp1: TShape
    Width = 461
    ExplicitWidth = 461
  end
  inherited pnlBtns: TPanel
    Width = 461
    TabOrder = 1
    ExplicitWidth = 461
    inherited btnCancelar: TButton
      Left = 376
      TabOrder = 1
      ExplicitLeft = 376
    end
    inherited btnAceptar: TButton
      Left = 291
      TabOrder = 0
      OnClick = btnAceptarClick
      ExplicitLeft = 291
    end
  end
  inherited pnlObjects: TPanel
    Width = 461
    TabOrder = 0
    ExplicitWidth = 461
    inherited pnlFila: TPanel
      Width = 459
      ExplicitWidth = 459
      object pnlPasillo: TPanel
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
        TabOrder = 0
        object lblPasillo: TLabel
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
          Caption = 'Pasillo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 44
        end
        object edtPasillo: TEdit
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
          NumbersOnly = True
          TabOrder = 0
        end
      end
      object pnlSeccion: TPanel
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
        object lblSeccion: TLabel
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
          Caption = 'Secci'#243'n'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 53
        end
        object edtSeccion: TEdit
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
          NumbersOnly = True
          TabOrder = 0
        end
      end
      object pnlFilas: TPanel
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
        object lblFilas: TLabel
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
          Caption = 'N'#186' de filas'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 72
        end
        object edtFilas: TEdit
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
          NumbersOnly = True
          TabOrder = 0
        end
      end
    end
  end
  inherited pnlTitle: TPanel
    Width = 455
    ExplicitWidth = 455
  end
  inherited pFIBTransaction: TpFIBTransaction
    Left = 368
    Top = 80
  end
  inherited pFIBQuery: TpFIBQuery
    Left = 296
    Top = 80
  end
end
