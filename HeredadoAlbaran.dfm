inherited FormAddHeredado: TFormAddHeredado
  Caption = 'FormAddHeredado'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 15
  inherited Panel1: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited PanelLbl: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited Label1: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
  end
  inherited PanelBtn: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
end
