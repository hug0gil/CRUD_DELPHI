unit MenuAlmacen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,FichaAlmacen;

type
  TFormMenuAlmacen = class(TForm)
    btnBorrar: TButton;
    btnCrear: TButton;
    btnActualizar: TButton;
    procedure btnCrearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuAlmacen.btnCrearClick(Sender: TObject);
var
  FormFichaAlmacen: TFormFichaAlmacen;
begin
  FormFichaAlmacen := TFormFichaAlmacen.Create(nil);
  FormFichaAlmacen.ShowModal;
  FormFichaAlmacen.Free;
end;

end.
