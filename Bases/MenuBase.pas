unit MenuBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls;

type
  TFormMenuBase = class(TForm)
    Panel1: TPanel;
    btnActualizar: TButton;
    btnAgregar: TButton;
    Shape1: TShape;
    Panel2: TPanel;
    DBGrid: TDBGrid;
    DBNavigator: TDBNavigator;
    btnEliminar: TButton;
    btnVer: TButton;
    procedure btnActualizarClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure btnAgregarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMenuBase: TFormMenuBase;

implementation

{$R *.dfm}

procedure TFormMenuBase.btnActualizarClick(Sender: TObject);
begin
  // Actualizar
end;

procedure TFormMenuBase.btnAgregarClick(Sender: TObject);
begin
  //Añadir
end;

procedure TFormMenuBase.btnEliminarClick(Sender: TObject);
begin
  // Eliminar
end;

procedure TFormMenuBase.FormCreate(Sender: TObject);
begin
//OnCreate
end;

end.
