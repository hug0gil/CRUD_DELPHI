unit ReadAlbaran;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FichaAlbaran, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFormReadAlbaran = class(TFormFichaAlbaran)
    procedure btnAceptarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormReadAlbaran: TFormReadAlbaran;

implementation

{$R *.dfm}

procedure TFormReadAlbaran.btnAceptarClick(Sender: TObject);
begin
  Self.Close;

end;

end.
