unit FichaBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, FIBQuery, pFIBQuery, FIBDatabase, pFIBDatabase,ModuloDatos;

type
  TFormFichaBase = class(TForm)
    pnlBtns: TPanel;
    btnCancelar: TButton;
    btnAceptar: TButton;
    pnlObjects: TPanel;
    pnlFila: TPanel;
    pnlCode: TPanel;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    pnlTitle: TPanel;
    shp: TShape;
    shp1: TShape;
    pFIBTransaction: TpFIBTransaction;
    pFIBQuery: TpFIBQuery;
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormFichaBase.btnCancelarClick(Sender: TObject);
begin
Self.Close;
end;

end.
