object FormMenuAlmacen: TFormMenuAlmacen
  Left = 0
  Top = 0
  Caption = 'Men'#250' almac'#233'n'
  ClientHeight = 343
  ClientWidth = 635
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
  object btnBorrar: TButton
    AlignWithMargins = True
    Left = 70
    Top = 236
    Width = 495
    Height = 73
    Hint = 'Borrar | Borrar almac'#233'n'
    Margins.Left = 70
    Margins.Top = 15
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Borrar'
    TabOrder = 2
    ExplicitTop = 226
  end
  object btnCrear: TButton
    AlignWithMargins = True
    Left = 70
    Top = 30
    Width = 495
    Height = 73
    Hint = 'Crear | Crear almac'#233'n'
    Margins.Left = 70
    Margins.Top = 30
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Crear'
    TabOrder = 0
    OnClick = btnCrearClick
  end
  object btnActualizar: TButton
    AlignWithMargins = True
    Left = 70
    Top = 133
    Width = 495
    Height = 73
    Hint = 'Actualizar| Actualizar almac'#233'n'
    Margins.Left = 70
    Margins.Top = 15
    Margins.Right = 70
    Margins.Bottom = 15
    Align = alTop
    Caption = 'Actualizar'
    TabOrder = 1
  end
end
