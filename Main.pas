unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MenuVentas, MenuArticulos, MenuCompras, Menus, AppEvnts,
  ComCtrls,MenuAlmacen;

type
  TFormMain = class(TForm)
    ButtonArticulos: TButton;
    btnCompras: TButton;
    btnVentas: TButton;
    mm1: TMainMenu;
    Archivos1: TMenuItem;
    Articulos1: TMenuItem;
    N1: TMenuItem;
    Compras1: TMenuItem;
    N2: TMenuItem;
    Ventas1: TMenuItem;
    pm1: TPopupMenu;
    Artculos1: TMenuItem;
    Compras2: TMenuItem;
    Ventas2: TMenuItem;
    stat1: TStatusBar;
    aplctnvnts1: TApplicationEvents;
    btnAlmacen: TButton;
    procedure btnComprasClick(Sender: TObject);
    procedure ButtonArticulosClick(Sender: TObject);
    procedure ButtonAlbaranventaClick(Sender: TObject);
    procedure aplctnvnts1Hint(Sender: TObject);
    procedure btnAlmacenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

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
  FormMenuAlmacen: TFormMenuAlmacen;
begin
  FormMenuAlmacen := TFormMenuAlmacen.Create(nil);
  FormMenuAlmacen.ShowModal;
  FormMenuAlmacen.Free;
end;

procedure TFormMain.btnComprasClick(Sender: TObject);
var
  FormMenuCompras: TFormMenuCompras;
begin
  FormMenuCompras := TFormMenuCompras.Create(nil);
  FormMenuCompras.ShowModal;
  FormMenuCompras.Free;

end;

end.
