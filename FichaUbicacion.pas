unit FichaUbicacion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FichaBase, FIBQuery, pFIBQuery, FIBDatabase, pFIBDatabase, StdCtrls,
  ExtCtrls;

type
  TFormFichaUbicacion = class(TFormFichaBase)
    pnlPasillo: TPanel;
    lblPasillo: TLabel;
    edtPasillo: TEdit;
    pnlSeccion: TPanel;
    lblSeccion: TLabel;
    edtSeccion: TEdit;
    pnlFilas: TPanel;
    lblFilas: TLabel;
    edtFilas: TEdit;
    procedure btnAceptarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    aceptando: Boolean end;

implementation

{$R *.dfm}

procedure TFormFichaUbicacion.btnAceptarClick(Sender: TObject);
begin
  inherited;
  aceptando := True;
  Self.Close;
end;

procedure TFormFichaUbicacion.btnCancelarClick(Sender: TObject);
begin
  aceptando := False;
  inherited;

end;

end.
