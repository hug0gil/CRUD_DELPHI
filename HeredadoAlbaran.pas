unit HeredadoAlbaran;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FichaBase, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Phys.Intf, FireDAC.Stan.Option, FireDAC.Stan.Intf, FireDAC.Comp.Client;

type
  TFormAddHeredado = class(TFormFichaBase)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAddHeredado: TFormAddHeredado;

implementation

{$R *.dfm}

end.
