unit MenuArticulos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MenuBase, DB, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase,
  Grids, DBGrids, DBCtrls, StdCtrls, ExtCtrls, FichaArticulos, ModuloDatos,
  pFIBQuery, FIBQuery;

type
  TFormMenuArticulos = class(TFormMenuBase)
    fbstrngfldFIBDataSetTableCCODIGO: TFIBStringField;
    fbstrngfldFIBDataSetTableCNOMBRE: TFIBStringField;
    fbcdfldFIBDataSetTableNSTOCK: TFIBBCDField;
    fbsmlntfldFIBDataSetTableNCOD_IVA: TFIBSmallIntField;
    fbsmlntfldFIBDataSetTableNFACTCONV: TFIBSmallIntField;
    fbsmlntfldFIBDataSetTableNUNICAJ: TFIBSmallIntField;
    fbcdfldFIBDataSetTableNPRECIO: TFIBBCDField;
    strngfldFIBDataSetTableCNOMBRE_IVA: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure rgGroupOrdenClick(Sender: TObject);
    procedure btnClick(Sender: TObject);
    function ObtenerCodigos: TArray<string>;
    procedure pFIBDataSetTableCalcFields(DataSet: TDataSet);
    procedure CargarIVAS(FormFichaArticulos: TFormFichaArticulos);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuArticulos.btnClick(Sender: TObject);
var
  FormFichaArticulos: TFormFichaArticulos;
begin
  if TButton(Sender).Tag <> 3 then
  begin
    FormFichaArticulos := TFormFichaArticulos.Create(Self, TButton(Sender).Tag);
    case TButton(Sender).Tag of
      0: // Añadir nuevo artículo
        begin
          FormFichaArticulos.Caption := 'Artículo nuevo';
          CargarIVAS(FormFichaArticulos);
          FormFichaArticulos.cbbCodIVA.ItemIndex := 3;
          // Valor por defecto si lo deseas
        end;

      1: // Actualizar artículo seleccionado
        begin
          FormFichaArticulos.Caption := 'Actualizar artículo seleccionado';

          // Configuración de los campos para la actualización
          FormFichaArticulos.edtCodigo.ReadOnly := True;
          FormFichaArticulos.edtCodigo.ShowHint := False;
          FormFichaArticulos.edtCodigo.Text :=
            DataSourceTable.DataSet.FieldByName('CCODIGO').AsString;
          FormFichaArticulos.edtNombre.Text :=
            DataSourceTable.DataSet.FieldByName('CNOMBRE').AsString;
          FormFichaArticulos.edtStock.Text :=
            DataSourceTable.DataSet.FieldByName('NSTOCK').AsString;

          // Limpiar y cargar las opciones de IVA en el ComboBox
          FormFichaArticulos.cbbCodIVA.Clear;
          CargarIVAS(FormFichaArticulos);

          // Seleccionar el código IVA correspondiente en el ComboBox
          // Usamos el valor de NCOD_IVA que ya está en el DataSet
          FormFichaArticulos.cbbCodIVA.ItemIndex :=
            FormFichaArticulos.cbbCodIVA.Items.IndexOf
            (DataSourceTable.DataSet.FieldByName('CNOMBRE_IVA').AsString);

          // Asegúrate de que la selección se haya realizado correctamente
          if FormFichaArticulos.cbbCodIVA.ItemIndex = -1 then
            FormFichaArticulos.cbbCodIVA.ItemIndex := 0;
          // Valor por defecto si no se encuentra el IVA
        end;

      2: // Ver artículo seleccionado
        begin
          FormFichaArticulos.Caption := 'Información del artículo seleccionado';

          FormFichaArticulos.edtCodigo.ReadOnly := True;
          FormFichaArticulos.edtCodigo.ShowHint := False;
          FormFichaArticulos.edtCodigo.Text :=
            DataSourceTable.DataSet.FieldByName('CCODIGO').AsString;
          FormFichaArticulos.edtNombre.Text :=
            DataSourceTable.DataSet.FieldByName('CNOMBRE').AsString;
          FormFichaArticulos.edtStock.Text :=
            DataSourceTable.DataSet.FieldByName('NSTOCK').AsString;

          FormFichaArticulos.cbbCodIVA.Clear;

          FormFichaArticulos.cbbCodIVA.Items.Add
            (DataSourceTable.DataSet.FieldByName('CNOMBRE_IVA').AsString);
          FormFichaArticulos.cbbCodIVA.ItemIndex :=
            FormFichaArticulos.cbbCodIVA.Items.IndexOf
            (DataSourceTable.DataSet.FieldByName('CNOMBRE_IVA').AsString);

          if FormFichaArticulos.cbbCodIVA.ItemIndex = -1 then
            FormFichaArticulos.cbbCodIVA.ItemIndex := 0;
            FormFichaArticulos.edtNombre.ReadOnly := True;
            FormFichaArticulos.edtStock.ReadOnly := True;
        end;
    end;

    FormFichaArticulos.ShowModal;

    if FormFichaArticulos.edtCodigo.Text <> '' then
    begin
      pFIBTransactionTable.Commit;
      pFIBDataSetTable.Close;
      pFIBTransactionTable.StartTransaction;
      pFIBDataSetTable.Open;

      // Realiza la búsqueda solo si el código no está vacío para que al salir estemos en el registro creado/modificado/leido
      pFIBDataSetTable.Locate('CCODIGO', FormFichaArticulos.edtCodigo.Text, []);
    end;

    FormFichaArticulos.Free;
  end
  else
  begin
    try
      if not pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.StartTransaction;

      pFIBQueryDelete.Close;
      pFIBQueryDelete.SQL.Text :=
        'DELETE FROM ARTICULOS WHERE CCODIGO = :OLD_CCODIGO';
      pFIBQueryDelete.ParamByName('OLD_CCODIGO').AsString :=
        DataSourceTable.DataSet.FieldByName('CCODIGO').AsString;
      pFIBQueryDelete.ExecQuery;

      if pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.Commit;

      pFIBDataSetTable.Close;
      pFIBDataSetTable.Open;

      ShowMessage('El artículo se ha eliminado con éxito.');
    except
      on E: Exception do
      begin
        ShowMessage('Error, no puedes eliminar un artículo asociado en un albarán');

      end;
    end;
  end;
end;

procedure TFormMenuArticulos.CargarIVAS
  (FormFichaArticulos: TFormFichaArticulos);
var
  i: Integer;
begin
  for i := 0 to High(ObtenerCodigos) do
  begin
    FormFichaArticulos.cbbCodIVA.Items.Add(ObtenerCodigos[i]);
  end;
end;

procedure TFormMenuArticulos.FormCreate(Sender: TObject);
begin

  inherited;
  pFIBDataSetTable.Open;

end;

procedure TFormMenuArticulos.rgGroupOrdenClick(Sender: TObject);
begin
  case rgGroupOrden.ItemIndex of
    0:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT CCODIGO, CNOMBRE, NSTOCK, NCOD_IVA, NFACTCONV, NUNICAJ, NPRECIO FROM ARTICULOS ORDER BY CCODIGO';
        pFIBDataSetTable.Open;
      end;

    1:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT CCODIGO, CNOMBRE, NSTOCK, NCOD_IVA, NFACTCONV, NUNICAJ, NPRECIO FROM ARTICULOS ORDER BY CNOMBRE';
        pFIBDataSetTable.Open;
      end;
  end;

end;

function TFormMenuArticulos.ObtenerCodigos: TArray<string>;
var
  FDQueryArticulos: TpFIBQuery;
  pFIBTransaction: TpFIBTransaction;
  Lista: TArray<string>;
  i: Integer;
begin
  FDQueryArticulos := TpFIBQuery.Create(nil);
  pFIBTransaction := TpFIBTransaction.Create(nil);

  FDQueryArticulos.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
  pFIBTransaction.DefaultDatabase := ModuloDatos.DataModuleBDD.pFIBDatabase;

  FDQueryArticulos.Transaction := pFIBTransaction;

  try
    pFIBTransaction.StartTransaction;
    FDQueryArticulos.SQL.Text := 'SELECT CDESCRIPCION FROM TIPOS_IVA';
    FDQueryArticulos.ExecQuery;

    SetLength(Lista, 0);
    i := 0;
    while not FDQueryArticulos.Eof do
    begin
      SetLength(Lista, Length(Lista) + 1);
      Lista[i] := FDQueryArticulos.FieldByName('CDESCRIPCION').AsString;
      Inc(i);
      FDQueryArticulos.Next;
    end;
    pFIBTransaction.Commit;
    Result := Lista;
  finally
    FDQueryArticulos.Free;
    pFIBTransaction.Free;
  end;
end;

procedure TFormMenuArticulos.pFIBDataSetTableCalcFields(DataSet: TDataSet);
var
  codigoIva: Integer;
  QueryIVA: TpFIBQuery;
begin
  QueryIVA := TpFIBQuery.Create(Self);
  try
    QueryIVA.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
    codigoIva := DataSet.FieldByName('NCOD_IVA').AsInteger;

    QueryIVA.SQL.Text :=
      'SELECT CDESCRIPCION FROM TIPOS_IVA WHERE NCODIGO = :Codigo';
    QueryIVA.ParamByName('Codigo').AsInteger := codigoIva;
    QueryIVA.ExecQuery;
    if not QueryIVA.Eof then
      DataSet.FieldByName('CNOMBRE_IVA').AsString := QueryIVA.FieldByName
        ('CDESCRIPCION').AsString
    else
      DataSet.FieldByName('CNOMBRE_IVA').AsString := 'No encontrado';

  finally
    QueryIVA.Free;
  end;
end;

end.
