unit MenuVentas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,MenuAlbaranVentas,MenuClientes;

type
  TFormMenuVentas = class(TForm)
    btnAlbaranesVenta: TButton;
    btnClientes: TButton;
    procedure btnAlbaranesVentaClick(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuVentas.btnAlbaranesVentaClick(Sender: TObject);
var
  FormMenuAlbaranVenta: TFormMenuAlbaranVentas;
begin
  FormMenuAlbaranVenta := TFormMenuAlbaranVentas.Create(nil);
  FormMenuAlbaranVenta.ShowModal;
  FormMenuAlbaranVenta.Free;
end;

procedure TFormMenuVentas.btnClientesClick(Sender: TObject);
var
  FormMenuClientes: TFormMenuClientes;
begin
  FormMenuClientes := TFormMenuClientes.Create(nil);
  FormMenuClientes.ShowModal;
  FormMenuClientes.Free;

end;

end.
