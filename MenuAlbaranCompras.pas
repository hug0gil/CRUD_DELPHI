unit MenuAlbaranCompras;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MenuBase, DB, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase,
  Grids, DBGrids, DBCtrls, StdCtrls, ExtCtrls, FichaGridAlbaranCompras,
  pFIBQuery,
  ModuloDatos, FIBQuery, frxBarcode, frxExportDBF, frxExportODF, frxExportMail,
  frxExportCSV, frxExportText, frxExportImage, frxExportRTF, frxExportXML,
  frxExportXLS, frxExportHTML, frxClass, frxExportPDF, frxDBSet;

type
  TFormMenuAlbaranCompras = class(TFormMenuBase)
    fbntgrfldFIBDataSetTableNCODIGO: TFIBIntegerField;
    fbdtfldFIBDataSetTableDFECHA: TFIBDateField;
    pFIBDataSetTableCOBSERVACIONES: TFIBStringField;
    pFIBDataSetTableNTOTAL: TFIBBCDField;
    procedure FormCreate(Sender: TObject);
    procedure rgGroupOrdenClick(Sender: TObject);
    procedure btnClick(Sender: TObject);
    procedure getCodProveedores(FormFichaGridAlbaran: TFormFichaGridAlbaran);
    procedure btnImprimirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuAlbaranCompras.btnClick(Sender: TObject);
var
  FormFichaGridAlbaran: TFormFichaGridAlbaran;
  i: Integer;
begin
  if TButton(Sender).Tag <> 3 then
  begin
    FormFichaGridAlbaran := TFormFichaGridAlbaran.Create(Self,
      TButton(Sender).Tag);
    case TButton(Sender).Tag of
      0: // Añadir nuevo artículo
        begin
          FormFichaGridAlbaran.Caption := 'Albarán de compra nuevo';
          getCodProveedores(FormFichaGridAlbaran);
          FormFichaGridAlbaran.EditCodigo.ReadOnly := False;
        end;

      1: // Actualizar artículo seleccionado
        begin
          FormFichaGridAlbaran.Caption :=
            'Actualizar albarán de compra seleccionado';

          FormFichaGridAlbaran.EditCodigo.ReadOnly := True;
          FormFichaGridAlbaran.EditCodigo.Text :=
            DataSourceTable.DataSet.FieldByName('NCODIGO').AsString;

          FormFichaGridAlbaran.DateTimePickerFecha.DateTime :=
            DataSourceTable.DataSet.FieldByName('DFECHA').AsDateTime;
          FormFichaGridAlbaran.originalFecha :=
            DataSourceTable.DataSet.FieldByName('DFECHA').AsDateTime;

          FormFichaGridAlbaran.MemoObservaciones.Lines.Text :=
            DataSourceTable.DataSet.FieldByName('COBSERVACIONES').AsString;
          FormFichaGridAlbaran.originalObservaciones :=
            DataSourceTable.DataSet.FieldByName('COBSERVACIONES').AsString;

          getCodProveedores(FormFichaGridAlbaran);

          FormFichaGridAlbaran.cbbCod.ItemIndex :=
            FormFichaGridAlbaran.cbbCod.Items.IndexOf
            (DataSourceTable.DataSet.FieldByName('NCOD_PROVEEDOR').AsString);

          FormFichaGridAlbaran.originalCodProveedor :=
            DataSourceTable.DataSet.FieldByName('NCOD_PROVEEDOR').AsString;

          if FormFichaGridAlbaran.cbbCod.ItemIndex = -1 then
          begin
            ShowMessage(
              'El código de cliente no se encuentra. Se seleccionará el primer cliente.');
            FormFichaGridAlbaran.cbbCod.ItemIndex := 0;
          end;

          if FormFichaGridAlbaran.cbbCod.ItemIndex = -1 then
          begin
            FormFichaGridAlbaran.cbbCod.ItemIndex := 0;
          end;
        end;

      2: // Ver artículo seleccionado
        begin
          FormFichaGridAlbaran.Caption :=
            'Información del albarán de compra seleccionado';

          FormFichaGridAlbaran.EditCodigo.ReadOnly := True;
          FormFichaGridAlbaran.EditCodigo.Text :=
            DataSourceTable.DataSet.FieldByName('NCODIGO').AsString;
          FormFichaGridAlbaran.DateTimePickerFecha.DateTime :=
            DataSourceTable.DataSet.FieldByName('DFECHA').AsDateTime;
          FormFichaGridAlbaran.MemoObservaciones.Lines.Text :=
            DataSourceTable.DataSet.FieldByName('COBSERVACIONES').AsString;

          FormFichaGridAlbaran.cbbCod.Clear;

          FormFichaGridAlbaran.cbbCod.Items.Add
            (DataSourceTable.DataSet.FieldByName('NCOD_PROVEEDOR').AsString);

          FormFichaGridAlbaran.cbbCod.ItemIndex :=
            FormFichaGridAlbaran.cbbCod.Items.IndexOf
            (DataSourceTable.DataSet.FieldByName('NCOD_PROVEEDOR').AsString);

          if FormFichaGridAlbaran.cbbCod.ItemIndex = -1 then
            FormFichaGridAlbaran.cbbCod.ItemIndex := 0;
        end;
    end;

    FormFichaGridAlbaran.ShowModal;

    if FormFichaGridAlbaran.EditCodigo.Text <> '' then
    begin
      pFIBTransactionTable.Commit;
      pFIBDataSetTable.Close;
      pFIBTransactionTable.StartTransaction;
      pFIBDataSetTable.Open;

      // Realiza la búsqueda solo si el código no está vacío para que al salir estemos en el registro creado/modificado/leido
      pFIBDataSetTable.Locate('NCODIGO', FormFichaGridAlbaran.EditCodigo.Text,
        []);
    end;

    FormFichaGridAlbaran.Free;
  end
  else
  begin
    try
      if not pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.StartTransaction;

      pFIBQueryDelete.Close;
      pFIBQueryDelete.SQL.Text :=
        'DELETE FROM ALBARAN_C WHERE NCODIGO = :OLD_NCODIGO';
      pFIBQueryDelete.ParamByName('OLD_NCODIGO').AsInteger :=
        DataSourceTable.DataSet.FieldByName('NCODIGO').AsInteger;
      pFIBQueryDelete.ExecQuery;

      if pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.Commit;

      pFIBDataSetTable.Close;
      pFIBDataSetTable.Open;

      ShowMessage('El albarán de compra se ha eliminado con éxito.');
    except
      on E: Exception do
      begin
        ShowMessage('Error al eliminar el registro: ' + E.Message);
      end;
    end;
  end;
end;

procedure TFormMenuAlbaranCompras.btnImprimirClick(Sender: TObject);
begin
  inherited;
  if not pFIBTransactionReport.InTransaction then
    pFIBTransactionReport.StartTransaction;

  DataSetReport.Close;

  DataSetReport.SQLs.SelectSQL.Text := 'SELECT ' +
    '  A.NCODIGO, A.DFECHA, A.COBSERVACIONES, A.NCOD_PROVEEDOR, ' +
    '  A.NTOTAL, A.NTOTAL_BRUTO, A.NIVA, A.NRECARGO, ' +
    '  L.NORDEN, L.CCOD_ARTICULO, L.NPRECIO, L.NIVA AS LINEA_IVA, ' +
    '  L.NRECARGO AS LINEA_RECARGO, L.NCANTIDAD1, L.NCANTIDAD2, L.NSUBTOTAL, '
    + '  P.NCODIGO AS PROVEEDOR_CODIGO, P.DFECHA_ULT_COMPRA, P.CNOMBRE AS PROVEEDOR_NOMBRE, P.CREG_FISCAL, ' + '  AR.CCODIGO AS ARTICULO_CODIGO, AR.CNOMBRE AS ARTICULO_NOMBRE, AR.NSTOCK, AR.NCOD_IVA AS ARTICULO_IVA, ' + '  AR.NFACTCONV, AR.NUNICAJ, AR.NPRECIO AS ARTICULO_PRECIO_VENTA, AR.NPRECIO_COMPRA, AR.NCOD_PROV, COUNT(*) OVER () AS TOTAL_LINEAS ' + 'FROM ALBARAN_C A ' + 'JOIN LINEAS_ALB_C L ON A.NCODIGO = L.NCOD_ALBARAN ' + 'JOIN PROVEEDORES P ON A.NCOD_PROVEEDOR = P.NCODIGO ' + 'JOIN ARTICULOS AR ON L.CCOD_ARTICULO = AR.CCODIGO ' + 'WHERE A.NCODIGO = :NCODIGO ' + 'AND P.NCODIGO = :NCOD_PROVEEDOR ' + 'ORDER BY L.NORDEN';

  DataSetReport.ParamByName('NCODIGO').AsInteger :=
    DataSourceTable.DataSet.FieldByName('NCODIGO').AsInteger;

  DataSetReport.ParamByName('NCOD_PROVEEDOR').AsInteger :=
    DataSourceTable.DataSet.FieldByName('NCOD_PROVEEDOR').AsInteger;

  DataSetReport.Open;
  frxReport.ShowReport;

  if pFIBTransactionReport.InTransaction then
    pFIBTransactionReport.Commit;

end;

procedure TFormMenuAlbaranCompras.FormCreate(Sender: TObject);
begin
  inherited;
  pFIBDataSetTable.Open;
end;

procedure TFormMenuAlbaranCompras.rgGroupOrdenClick(Sender: TObject);
begin
  case rgGroupOrden.ItemIndex of
    0:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT NCODIGO, DFECHA,COBSERVACIONES,NCOD_PROVEEDOR,NTOTAL FROM ALBARAN_C ORDER BY NCODIGO';
        pFIBDataSetTable.Open;
      end;

    1:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT NCODIGO, DFECHA,COBSERVACIONES,NCOD_PROVEEDOR,NTOTAL FROM ALBARAN_C ORDER BY DFECHA';
        pFIBDataSetTable.Open;
      end;
  end;

end;

procedure TFormMenuAlbaranCompras.getCodProveedores
  (FormFichaGridAlbaran: TFormFichaGridAlbaran);
var
  QueryClientes: TpFIBQuery;
  i: Integer;
begin
  QueryClientes := TpFIBQuery.Create(nil);
  try
    QueryClientes.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
    QueryClientes.SQL.Text := 'SELECT NCODIGO FROM PROVEEDORES';
    QueryClientes.ExecQuery;

    while not QueryClientes.EOF do
    begin
      FormFichaGridAlbaran.cbbCod.Items.Add
        (QueryClientes.FieldByName('NCODIGO').AsString);
      QueryClientes.Next;
    end;
  finally
    QueryClientes.Free;
  end;
end;

end.
