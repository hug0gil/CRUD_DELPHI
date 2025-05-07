unit MenuCompras;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,MenuAlbaranCompras,MenuProveedores;

type
  TFormMenuCompras = class(TForm)
    btnAlbaranesCompra: TButton;
    btnProveedores: TButton;
    procedure btnAlbaranesCompraClick(Sender: TObject);
    procedure btnProveedoresClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFormMenuCompras.btnAlbaranesCompraClick(Sender: TObject);
var
  FormMenuAlbaranVenta: TFormMenuAlbaranCompras;
begin
  FormMenuAlbaranVenta := TFormMenuAlbaranCompras.Create(nil);
  FormMenuAlbaranVenta.ShowModal;
  FormMenuAlbaranVenta.Free;
end;

procedure TFormMenuCompras.btnProveedoresClick(Sender: TObject);
var
  FormMenuProveedores: TFormMenuProveedores;
begin
  FormMenuProveedores := TFormMenuProveedores.Create(nil);
  FormMenuProveedores.ShowModal;
  FormMenuProveedores.Free;

end;

end.
