unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MenuVentas, MenuArticulos, MenuCompras, Menus, AppEvnts,
  ComCtrls, FichaAlmacen, MenuUbicaciones, Unit_principal;

type
  TFormMain = class(TForm)
    ButtonArticulos: TButton;
    btnCompras: TButton;
    btnVentas: TButton;
    stat1: TStatusBar;
    aplctnvnts1: TApplicationEvents;
    btnAlmacen: TButton;
    btnUbicaciones: TButton;
    Button1: TButton;
    procedure btnComprasClick(Sender: TObject);
    procedure ButtonArticulosClick(Sender: TObject);
    procedure ButtonAlbaranventaClick(Sender: TObject);
    procedure aplctnvnts1Hint(Sender: TObject);
    procedure btnAlmacenClick(Sender: TObject);
    procedure btnUbicacionesClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.Button1Click(Sender: TObject);
var
  Principal: TForm_Principal;
begin
  Principal := TForm_Principal.Create(nil);
  Principal.ShowModal;
  Principal.Free;
end;

procedure TFormMain.ButtonAlbaranventaClick(Sender: TObject);
var
  FormMenuVentas: TFormMenuVentas;
begin
  FormMenuVentas := TFormMenuVentas.Create(nil);
  FormMenuVentas.ShowModal;
  FormMenuVentas.Free;

end;

procedure TFormMain.ButtonArticulosClick(Sender: TObject);
var
  FormMenuArticulos: TFormMenuArticulos;
begin
  FormMenuArticulos := TFormMenuArticulos.Create(nil);
  FormMenuArticulos.ShowModal;
  FormMenuArticulos.Free;
end;

procedure TFormMain.aplctnvnts1Hint(Sender: TObject);
begin
  stat1.Panels[1].Text := Application.Hint;
end;

procedure TFormMain.btnAlmacenClick(Sender: TObject);
var
  FormFichaAlmacen: TFormFichaAlmacen;
begin
  FormFichaAlmacen := TFormFichaAlmacen.Create(nil);
  FormFichaAlmacen.ShowModal;
  FormFichaAlmacen.Free;
end;

procedure TFormMain.btnComprasClick(Sender: TObject);
var
  FormMenuCompras: TFormMenuCompras;
begin
  FormMenuCompras := TFormMenuCompras.Create(nil);
  FormMenuCompras.ShowModal;
  FormMenuCompras.Free;
end;

procedure TFormMain.btnUbicacionesClick(Sender: TObject);
var
  FormMenuUbicaciones: TFormMenuUbicaciones;
begin
  FormMenuUbicaciones := TFormMenuUbicaciones.Create(nil);
  FormMenuUbicaciones.ShowModal;
  FormMenuUbicaciones.Free;
end;

end.
