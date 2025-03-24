unit prueba;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.WinXPickers, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.DBCtrls;

type
  TPruebaAlbaran = class(TForm)
    FDQuerySelec: TFDQuery;
    ButtonVolver: TButton;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    DBNavigator: TDBNavigator;
    Connection: TFDConnection;
    FDQueryDetalle: TFDQuery;
    ButtonAgregar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonVolverClick(Sender: TObject);
    procedure ButtonAgregarClick(Sender: TObject);
  private
  public
  end;

var
  PruebaAlbaran: TPruebaAlbaran;

implementation

{$R *.dfm}

uses UpdateAlbaran;

procedure TPruebaAlbaran.FormCreate(Sender: TObject);
begin
  FDQuerySelec.Connection := Connection;
  FDQuerySelec.SQL.Text := 'SELECT * FROM ALBARAN';
  FDQuerySelec.Open;
  DataSource.DataSet := FDQuerySelec;
  DBGrid.DataSource := DataSource;

  DBGrid.Columns[0].Title.Caption := 'Código';
  DBGrid.Columns[0].Width := 70;
  DBGrid.Columns[1].Title.Caption := 'Fecha';
  DBGrid.Columns[1].Width := 90;
  DBGrid.Columns[2].Title.Caption := 'Observaciones';
  DBGrid.Columns[2].Width := 80;
  DBGrid.Columns[3].Title.Caption := 'Código del cliente';
end;

procedure TPruebaAlbaran.ButtonAgregarClick(Sender: TObject);
begin
FormUpdateAlbaran.EditCod.Text := 'prueba';
    FormUpdateAlbaran.ShowModal;
end;

procedure TPruebaAlbaran.ButtonVolverClick(Sender: TObject);
begin
  Self.Close;
end;

end.

