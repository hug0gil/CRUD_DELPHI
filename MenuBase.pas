unit MenuBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, Grids, DBGrids, StdCtrls, DB, FIBDatabase,
  pFIBDatabase, FIBDataSet, pFIBDataSet, FIBQuery, pFIBQuery;

type
  TFormMenuBase = class(TForm)
    Panel1: TPanel;
    btnActualizar: TButton;
    btnAgregar: TButton;
    btnEliminar: TButton;
    btnVer: TButton;
    Panel2: TPanel;
    DBNavigator: TDBNavigator;
    Shape1: TShape;
    DBGrid1: TDBGrid;
    pFIBTransactionTable: TpFIBTransaction;
    DataSourceTable: TDataSource;
    pFIBDataSetTable: TpFIBDataSet;
    shp1: TShape;
    rgGroupOrden: TRadioGroup;
    pFIBQueryDelete: TpFIBQuery;
    procedure FormCreate(Sender: TObject);
    // function GetLastCodigo(const PrimaryKey: String;
    // const TableName: String): Integer;
  private
    { Private declarations }
  public
    { Public declarations }
    UltimoCodigo: Integer;
  end;

implementation

uses ModuloDatos;
{$R *.dfm}

procedure TFormMenuBase.FormCreate(Sender: TObject);
begin

  if not pFIBTransactionTable.InTransaction then
    pFIBTransactionTable.StartTransaction;

  pFIBDataSetTable.Close;
end;

{
  function TFormMenuBase.GetLastCodigo(const PrimaryKey: String;
  const TableName: String): Integer;
  //var
  //pFIBQuery: TpFIBQuery;
  begin
  Result := 1; // Valor por defecto en caso de error
  pFIBQuery := TpFIBQuery.Create(nil);
  try
  pFIBQuery.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
  pFIBQuery.Transaction := pFIBTransactionTable;
  pFIBTransactionTable.StartTransaction;

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
end.
