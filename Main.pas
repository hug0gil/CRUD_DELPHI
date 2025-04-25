unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,MenuClientes,MenuArticulos,MenuAlbaran;

type
  TFormMain = class(TForm)
    ButtonAlbaran: TButton;
    ButtonArticulos: TButton;
    ButtonClientes: TButton;
    procedure ButtonClientesClick(Sender: TObject);
    procedure ButtonArticulosClick(Sender: TObject);
    procedure ButtonAlbaranClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.ButtonAlbaranClick(Sender: TObject);
var FormMenuAlbaran : TFormMenuAlbaran;
begin
FormMenuAlbaran := TFormMenuAlbaran.Create(nil);
FormMenuAlbaran.ShowModal;
FormMenuAlbaran.Free;

end;

procedure TFormMain.ButtonArticulosClick(Sender: TObject);
var FormMenuArticulos : TFormMenuArticulos;
begin
FormMenuArticulos := TFormMenuArticulos.Create(nil);
FormMenuArticulos.ShowModal;
FormMenuArticulos.Free;
end;

procedure TFormMain.ButtonClientesClick(Sender: TObject);
var FormMenuClientes : TFormMenuClientes;
begin
FormMenuClientes := TFormMenuClientes.Create(nil);
FormMenuClientes.ShowModal;
FormMenuClientes.Free;

end;

end.
