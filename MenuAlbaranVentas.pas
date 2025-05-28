unit MenuAlbaranVentas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MenuBase, DB, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase,
  Grids, DBGrids, DBCtrls, StdCtrls, ExtCtrls, FichaGridAlbaranVentas,
  pFIBQuery,
  ModuloDatos, FIBQuery, frxBarcode, frxExportDBF, frxExportODF, frxExportMail,
  frxExportCSV, frxExportText, frxExportImage, frxExportRTF, frxExportXML,
  frxExportXLS, frxExportHTML, frxClass, frxExportPDF, frxDBSet;

type
  TFormMenuAlbaranVentas = class(TFormMenuBase)
    fbntgrfldFIBDataSetTableNCODIGO: TFIBIntegerField;
    fbdtfldFIBDataSetTableDFECHA: TFIBDateField;
    pFIBDataSetTableCOBSERVACIONES: TFIBStringField;
    fbntgrfldFIBDataSetTableNCOD_CLIENTE: TFIBIntegerField;
    pFIBDataSetTableNTOTAL: TFIBBCDField;
    procedure FormCreate(Sender: TObject);
    procedure rgGroupOrdenClick(Sender: TObject);
    procedure btnClick(Sender: TObject);
    procedure getCodClientes(FormFichaGridAlbaranVentas
        : TFormFichaGridAlbaranVentas);
    procedure btnImprimirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuAlbaranVentas.btnClick(Sender: TObject);
var
  FormFichaGridAlbaranVentas: TFormFichaGridAlbaranVentas;
  i: Integer;
begin
  if TButton(Sender).Tag <> 3 then
  begin
    FormFichaGridAlbaranVentas := TFormFichaGridAlbaranVentas.Create(Self,
      TButton(Sender).Tag);
    case TButton(Sender).Tag of
      0: // Añadir nuevo artículo
        begin
          FormFichaGridAlbaranVentas.Caption := 'Albarán de venta nuevo';
          getCodClientes(FormFichaGridAlbaranVentas);
          FormFichaGridAlbaranVentas.EditCodigo.ReadOnly := False;
        end;

      1: // Actualizar artículo seleccionado
        begin
          FormFichaGridAlbaranVentas.Caption :=
            'Actualizar albarán de venta seleccionado';

          FormFichaGridAlbaranVentas.EditCodigo.ReadOnly := True;
          FormFichaGridAlbaranVentas.EditCodigo.Text :=
            DataSourceTable.DataSet.FieldByName('NCODIGO').AsString;

          FormFichaGridAlbaranVentas.DateTimePickerFecha.DateTime :=
            DataSourceTable.DataSet.FieldByName('DFECHA').AsDateTime;
          FormFichaGridAlbaranVentas.originalFecha :=
            DataSourceTable.DataSet.FieldByName('DFECHA').AsDateTime;

          FormFichaGridAlbaranVentas.MemoObservaciones.Lines.Text :=
            DataSourceTable.DataSet.FieldByName('COBSERVACIONES').AsString;
          FormFichaGridAlbaranVentas.originalObservaciones :=
            DataSourceTable.DataSet.FieldByName('COBSERVACIONES').AsString;

          getCodClientes(FormFichaGridAlbaranVentas);

          FormFichaGridAlbaranVentas.cbbCod.ItemIndex :=
            FormFichaGridAlbaranVentas.cbbCod.Items.IndexOf
            (DataSourceTable.DataSet.FieldByName('NCOD_CLIENTE').AsString);

          FormFichaGridAlbaranVentas.originalCodCliente :=
            DataSourceTable.DataSet.FieldByName('NCOD_CLIENTE').AsString;

          if FormFichaGridAlbaranVentas.cbbCod.ItemIndex = -1 then
          begin
            ShowMessage(
              'El código de cliente no se encuentra. Se seleccionará el primer cliente.');
            FormFichaGridAlbaranVentas.cbbCod.ItemIndex := 0;
          end;

          if FormFichaGridAlbaranVentas.cbbCod.ItemIndex = -1 then
          begin
            FormFichaGridAlbaranVentas.cbbCod.ItemIndex := 0;
          end;
        end;

      2: // Ver artículo seleccionado
        begin
          FormFichaGridAlbaranVentas.Caption :=
            'Información del albarán de venta seleccionado';

          FormFichaGridAlbaranVentas.EditCodigo.ReadOnly := True;
          FormFichaGridAlbaranVentas.EditCodigo.Text :=
            DataSourceTable.DataSet.FieldByName('NCODIGO').AsString;
          FormFichaGridAlbaranVentas.DateTimePickerFecha.DateTime :=
            DataSourceTable.DataSet.FieldByName('DFECHA').AsDateTime;
          FormFichaGridAlbaranVentas.MemoObservaciones.Lines.Text :=
            DataSourceTable.DataSet.FieldByName('COBSERVACIONES').AsString;

          FormFichaGridAlbaranVentas.cbbCod.Clear;

          FormFichaGridAlbaranVentas.cbbCod.Items.Add
            (DataSourceTable.DataSet.FieldByName('NCOD_CLIENTE').AsString);

          FormFichaGridAlbaranVentas.cbbCod.ItemIndex :=
            FormFichaGridAlbaranVentas.cbbCod.Items.IndexOf
            (DataSourceTable.DataSet.FieldByName('NCOD_CLIENTE').AsString);

          if FormFichaGridAlbaranVentas.cbbCod.ItemIndex = -1 then
            FormFichaGridAlbaranVentas.cbbCod.ItemIndex := 0;
        end;
    end;

    FormFichaGridAlbaranVentas.ShowModal;

    if FormFichaGridAlbaranVentas.EditCodigo.Text <> '' then
    begin
      pFIBTransactionTable.Commit;
      pFIBDataSetTable.Close;
      pFIBTransactionTable.StartTransaction;
      pFIBDataSetTable.Open;

      // Realiza la búsqueda solo si el código no está vacío para que al salir estemos en el registro creado/modificado/leido
      pFIBDataSetTable.Locate('NCODIGO',
        FormFichaGridAlbaranVentas.EditCodigo.Text, []);
    end;

    FormFichaGridAlbaranVentas.Free;
  end
  else
  begin
    try
      if not pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.StartTransaction;

      pFIBQueryDelete.Close;
      pFIBQueryDelete.SQL.Text :=
        'DELETE FROM ALBARAN_V WHERE NCODIGO = :OLD_NCODIGO';
      pFIBQueryDelete.ParamByName('OLD_NCODIGO').AsInteger :=
        DataSourceTable.DataSet.FieldByName('NCODIGO').AsInteger;
      pFIBQueryDelete.ExecQuery;

      if pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.Commit;

      pFIBDataSetTable.Close;
      pFIBDataSetTable.Open;

      ShowMessage('El albarán de venta se ha eliminado con éxito.');
    except
      on E: Exception do
      begin
        ShowMessage('Error al eliminar el registro: ' + E.Message);
      end;
    end;
  end;
end;

procedure TFormMenuAlbaranVentas.btnImprimirClick(Sender: TObject);
begin
  inherited;
  if not pFIBTransactionReport.InTransaction then
    pFIBTransactionReport.StartTransaction;

  DataSetReport.Close;

  DataSetReport.SQLs.SelectSQL.Text := 'SELECT ' +
    '  A.NCODIGO, A.DFECHA, A.COBSERVACIONES, A.NCOD_CLIENTE, ' +
    '  A.NTOTAL, A.NTOTAL_BRUTO, A.NIVA, A.NRECARGO, ' +
    '  L.NORDEN, L.CCOD_ARTICULO, L.NPRECIO, L.NIVA AS LINEA_IVA, ' +
    '  L.NRECARGO AS LINEA_RECARGO, L.NCANTIDAD1, L.NCANTIDAD2, L.NSUBTOTAL, '
    + '  C.NCODIGO AS CLIENTE_CODIGO, C.DFECHA_ULT_VENTA, C.CNOMBRE AS CLIENTE_NOMBRE, C.CREG_FISCAL, ' + '  AR.CCODIGO AS ARTICULO_CODIGO, AR.CNOMBRE AS ARTICULO_NOMBRE, AR.NSTOCK, AR.NCOD_IVA AS ARTICULO_IVA, ' + '  AR.NFACTCONV, AR.NUNICAJ, AR.NPRECIO AS ARTICULO_PRECIO_VENTA, AR.NPRECIO_COMPRA, AR.NCOD_PROV, ' + '  COUNT(*) OVER () AS TOTAL_LINEAS ' + 'FROM ALBARAN_V A ' + 'JOIN LINEAS_ALB_V L ON A.NCODIGO = L.NCOD_ALBARAN ' + 'JOIN CLIENTES C ON A.NCOD_CLIENTE = C.NCODIGO ' + 'JOIN ARTICULOS AR ON L.CCOD_ARTICULO = AR.CCODIGO ' + 'WHERE A.NCODIGO = :NCODIGO ' + 'AND C.NCODIGO = :NCOD_CLIENTE ' + 'ORDER BY L.NORDEN';

  DataSetReport.ParamByName('NCODIGO').AsInteger :=
    DataSourceTable.DataSet.FieldByName('NCODIGO').AsInteger;

  DataSetReport.ParamByName('NCOD_CLIENTE').AsInteger :=
    DataSourceTable.DataSet.FieldByName('NCOD_CLIENTE').AsInteger;

  DataSetReport.Open;
  frxReport.ShowReport;

  if pFIBTransactionReport.InTransaction then
    pFIBTransactionReport.Commit;
end;

procedure TFormMenuAlbaranVentas.FormCreate(Sender: TObject);
begin
  inherited;
  pFIBDataSetTable.Open;
end;

procedure TFormMenuAlbaranVentas.rgGroupOrdenClick(Sender: TObject);
begin
  case rgGroupOrden.ItemIndex of
    0:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT NCODIGO, DFECHA,COBSERVACIONES,NCOD_CLIENTE,NTOTAL FROM ALBARAN_V ORDER BY NCODIGO';
        pFIBDataSetTable.Open;
      end;

    1:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT NCODIGO, DFECHA,COBSERVACIONES,NCOD_CLIENTE,NTOTAL FROM ALBARAN_V ORDER BY DFECHA';
        pFIBDataSetTable.Open;
      end;
  end;

end;

procedure TFormMenuAlbaranVentas.getCodClientes
  (FormFichaGridAlbaranVentas: TFormFichaGridAlbaranVentas);
var
  QueryClientes: TpFIBQuery;
  i: Integer;
begin
  QueryClientes := TpFIBQuery.Create(nil);
  try
    QueryClientes.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
    QueryClientes.SQL.Text := 'SELECT NCODIGO FROM CLIENTES';
    QueryClientes.ExecQuery;

    while not QueryClientes.EOF do
    begin
      FormFichaGridAlbaranVentas.cbbCod.Items.Add
        (QueryClientes.FieldByName('NCODIGO').AsString);
      QueryClientes.Next;
    end;
  finally
    QueryClientes.Free;
  end;
end;

end.
