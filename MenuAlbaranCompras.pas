unit MenuAlbaranCompras;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MenuBase, DB, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase,
  Grids, DBGrids, DBCtrls, StdCtrls, ExtCtrls, FichaGridAlbaranCompras,
  pFIBQuery,
  ModuloDatos, FIBQuery, frxBarcode, frxExportDBF, frxExportODF, frxExportMail,
  frxExportCSV, frxExportText, frxExportImage, frxExportRTF, frxExportXML,
  frxExportXLS, frxExportHTML, frxClass, frxExportPDF, frxDBSet, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdCookieManager, IdURI,
  StrUtils;

type
  TFormMenuAlbaranCompras = class(TFormMenuBase)
    fbntgrfldFIBDataSetTableNCODIGO: TFIBIntegerField;
    fbdtfldFIBDataSetTableDFECHA: TFIBDateField;
    pFIBDataSetTableCOBSERVACIONES: TFIBStringField;
    pFIBDataSetTableNTOTAL: TFIBBCDField;
    procedure FormCreate(Sender: TObject);
    procedure rgGroupOrdenClick(Sender: TObject);
    procedure btnClick(Sender: TObject);
    procedure getCodProveedores(FormFichaGridAlbaran
        : TFormFichaGridAlbaranCompras);
    procedure btnImprimirClick(Sender: TObject);
    procedure DrupalDELETE;
    function GetUUIDByTitle(const Title: string): string;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    username, pass: string;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuAlbaranCompras.btnClick(Sender: TObject);
var
  FormFichaGridAlbaran: TFormFichaGridAlbaranCompras;
  i: Integer;
begin
  if TButton(Sender).Tag <> 3 then
  begin
    FormFichaGridAlbaran := TFormFichaGridAlbaranCompras.Create(Self,
      TButton(Sender).Tag);
    case TButton(Sender).Tag of
      0: // Añadir nuevo artículo
        begin
          FormFichaGridAlbaran.Caption := 'Albarán de compra nuevo';
          getCodProveedores(FormFichaGridAlbaran);
          FormFichaGridAlbaran.EditCodigo.ReadOnly := False;
          FormFichaGridAlbaran.Report := frxReport;
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
          FormFichaGridAlbaran.Report := frxReport;
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

      DrupalDELETE;
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
    +
    '  P.NCODIGO AS PROVEEDOR_CODIGO, P.DFECHA_ULT_COMPRA, P.CNOMBRE AS PROVEEDOR_NOMBRE, P.CREG_FISCAL, '
    +
    '  AR.CCODIGO AS ARTICULO_CODIGO, AR.CNOMBRE AS ARTICULO_NOMBRE, AR.NSTOCK, AR.NCOD_IVA AS ARTICULO_IVA, '
    + '  AR.NFACTCONV, AR.NUNICAJ, AR.NPRECIO AS ARTICULO_PRECIO_VENTA, AR.NPRECIO_COMPRA, AR.NCOD_PROV, COUNT(*) OVER () AS TOTAL_LINEAS ' + 'FROM ALBARAN_C A ' + 'JOIN LINEAS_ALB_C L ON A.NCODIGO = L.NCOD_ALBARAN ' + 'JOIN PROVEEDORES P ON A.NCOD_PROVEEDOR = P.NCODIGO ' + 'JOIN ARTICULOS AR ON L.CCOD_ARTICULO = AR.CCODIGO ' + 'WHERE A.NCODIGO = :NCODIGO ' + 'AND P.NCODIGO = :NCOD_PROVEEDOR ' + 'ORDER BY L.NORDEN';

  DataSetReport.ParamByName('NCODIGO').AsInteger :=
    DataSourceTable.DataSet.FieldByName('NCODIGO').AsInteger;

  DataSetReport.ParamByName('NCOD_PROVEEDOR').AsInteger :=
    DataSourceTable.DataSet.FieldByName('NCOD_PROVEEDOR').AsInteger;

  DataSetReport.Open;
  frxReport.ShowReport;

  if pFIBTransactionReport.InTransaction then
    pFIBTransactionReport.Commit;

end;

procedure TFormMenuAlbaranCompras.FormActivate(Sender: TObject);
begin
  inherited;
  username := 'adminastec';
  pass := '[Di!A&5b95(S';

  if IdHTTP.CookieManager = nil then
    IdHTTP.CookieManager := TIdCookieManager.Create(IdHTTP);

  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method := sslvTLSv1_2;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.SSLVersions := [sslvTLSv1_2];
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.mode := sslmClient;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.VerifyMode := [];
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.VerifyDepth := 0;

  IdHTTP.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
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
  (FormFichaGridAlbaran: TFormFichaGridAlbaranCompras);
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

function TFormMenuAlbaranCompras.GetUUIDByTitle(const Title: string): string;
var
  response, url: string;
  pStart, pEnd: Integer;
  filterTitle: string;
begin
  Result := '';

  // Para evitar problemas con caracteres especiales en la URL, codificamos el título
  filterTitle := TIdURI.ParamsEncode(Title);
  url :=
    'https://barraca.demoastec.es/jsonapi/node/albaran_compra?filter[title]='
    + filterTitle;
  try
    response := IdHTTP.Get(url);

    // Buscar la cadena "id":" para extraer el UUID
    pStart := Pos('"id":"', response);
    if pStart > 0 then
    begin
      Inc(pStart, Length('"id":"')); // posición inicial del UUID
      pEnd := PosEx('"', response, pStart); // buscar cierre de comillas después del id
      if (pEnd > pStart) and ((pEnd - pStart) = 36) then
      begin
        Result := Copy(response, pStart, 36);
        // UUID estándar tiene 36 caracteres
      end;
    end;
  except
    on E: Exception do
      ShowMessage('Error buscando UUID: ' + E.Message);
  end;
end;

procedure TFormMenuAlbaranCompras.DrupalDELETE;
var
  uuid, url: string;
begin
  uuid := GetUUIDByTitle(pFIBDataSetTable.FieldByName('NCODIGO').AsString);

  if uuid = '' then
  begin
    ShowMessage('No se encontró albarán con ese código para eliminar.');
    Exit;
  end;

  url := 'https://barraca.demoastec.es/jsonapi/node/albaran_compra/' + uuid;

  try
    IdHTTP.Request.Clear;
    IdHTTP.Request.BasicAuthentication := True;
    IdHTTP.Request.username := username;
    IdHTTP.Request.Password := pass;

    IdHTTP.Request.Accept := 'application/vnd.api+json';
    IdHTTP.Request.ContentType := 'application/vnd.api+json';
    IdHTTP.Request.Method := 'DELETE';

    IdHTTP.Delete(url);

    if (IdHTTP.ResponseCode = 204) then
      // ShowMessage('✓ Albarán eliminado correctamente')
    else
      ShowMessage('✗ Error al eliminar albarán. Código HTTP: ' + IntToStr
          (IdHTTP.ResponseCode));
  except
    on E: Exception do
      ShowMessage('✗ Error al eliminar albarán: ' + E.Message);
  end;
end;



end.
