unit MenuAlmacen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FichaAlmacen;

type
  TFormMenuAlmacen = class(TForm)
    btnBorrar: TButton;
    btnCrear: TButton;
    btnActualizar: TButton;
    procedure btnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuAlmacen.btnClick(Sender: TObject);
var
  FormFichaAlmacen: TFormFichaAlmacen;
begin
  case TButton(Sender).Tag of
    1, 2: // Crear o Actualizar
      begin
        FormFichaAlmacen := TFormFichaAlmacen.Create(nil, TButton(Sender).Tag);
        try
          FormFichaAlmacen.ShowModal;
        finally
          FormFichaAlmacen.Free;
        end;
      end;

    3: // Eliminar
      ShowMessage('Eliminar');
  end;
end;


end.
