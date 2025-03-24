unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,FormMenuAlbaranHeredado;

type
  TFormMain = class(TForm)
    ButtonAlbaran: TButton;
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

uses MenuAlbaran;

procedure TFormMain.ButtonAlbaranClick(Sender: TObject);

var FormMenuAlbaran:TFormMenuAlbaran;

begin
  FormMenuAlbaran := TFormMenuAlbaran.Create(Self);

  FormMenuAlbaran.ShowModal;
  FormMenuAlbaran.Free;
end;



end.
