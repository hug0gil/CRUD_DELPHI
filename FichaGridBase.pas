unit FichaGridBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, FIBDatabase, pFIBDatabase, FIBQuery, pFIBQuery, DB,
  FIBDataSet, pFIBDataSet, Grids, DBGrids, StdCtrls, ComCtrls, ModuloDatos;

type
  TFormFichaGridBase0 = class(TForm)
    DataSource: TDataSource;
    PanelAlbaranes: TPanel;
    LabelObservaciones: TLabel;
    LabelCodCliente: TLabel;
    LabelFecha: TLabel;
    Label1: TLabel;
    EditCodigo: TEdit;
    DateTimePickerFecha: TDateTimePicker;
    MemoObservaciones: TMemo;
    PanelBtns: TPanel;
    btnAceptar: TButton;
    btnCancelar: TButton;
    ButtonBorrar: TButton;
    ButtonInsertar: TButton;
    ButtonActualizar: TButton;
    ButtonVer: TButton;
    PanelLineas: TPanel;
    DBGrid: TDBGrid;
    pFIBQueryTable: TpFIBQuery;
    pFIBDataSetTable: TpFIBDataSet;
    pFIBTransactionTable: TpFIBTransaction;
    Shape1: TShape;
    Shape2: TShape;
    cbbCodCliente: TComboBox;
    procedure btnCancelarClick(Sender: TObject);
    // procedure FormActivate(Sender: TObject);
    // function GetLastCodigo(const PrimaryKey: String;
    // const TableName: String): Integer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFormFichaGridBase }
{
  procedure TFormFichaGridBase.FormActivate(Sender: TObject);
  begin {
  try
  try
  pFIBDataSetTable.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
  pFIBDataSetTable.Transaction := pFIBTransactionTable;
  except
  on E: Exception do
  ShowMessage('Error configurando la conexión: ' + E.Message);
  end;

  if not pFIBTransactionTable.Active then
  pFIBTransactionTable.StartTransaction;

  if not pFIBDataSetTable.Active then
  pFIBDataSetTable.Open;

  DataSource.DataSet := pFIBDataSetTable;
  DBGrid.DataSource := DataSource;

  pFIBDataSetTable.Refresh;
  DataSource.DataSet.Refresh;
  DBGrid.Refresh;
  except
  on E: Exception do
  ShowMessage('Error al abrir la tabla: ' + E.Message);
  end;
  end;

  function TFormFichaGridBase.GetLastCodigo(const PrimaryKey: String;
  const TableName: String): Integer;
  var
  pFIBQuery: TpFIBQuery;
  pFIBTransactionTable : TpFIBTransaction;
  begin {
  Result := 1; // Valor por defecto en caso de error
  pFIBQuery := TpFIBQuery.Create(nil);
  pFIBTransactionTable := TpFIBTransaction.Create(nil);
  try
  pFIBQuery.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
  pFIBQuery.Transaction := pFIBTransactionTable;
  pFIBTransactionTable.StartTransaction;

  if not pFIBQuery.Database.Connected then
  pFIBQuery.Database.Connected := True;

  if not pFIBQuery.Transaction.InTransaction then
  pFIBQuery.Transaction.StartTransaction;

  pFIBQuery.SQL.Text := 'SELECT MAX(' + PrimaryKey + ') FROM ' + TableName;

  ShowMessage('Ejecutando consulta: ' + pFIBQuery.SQL.Text); // Para depuración

  pFIBQuery.ExecQuery;

  if not pFIBQuery.Fields[0].IsNull then
  Result := pFIBQuery.Fields[0].AsInteger + 1;

  pFIBQuery.Transaction.Commit;
  except
  on E: Exception do
  begin
  ShowMessage('Error en la consulta: ' + E.Message);
  pFIBQuery.Transaction.Rollback;
  end;
  end;
  pFIBQuery.Free;

  end;
}
procedure TFormFichaGridBase0.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

end.
