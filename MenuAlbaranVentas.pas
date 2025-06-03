unit MenuAlbaranVentas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MenuBase, DB, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase,
  Grids, DBGrids, DBCtrls, StdCtrls, ExtCtrls, FichaGridAlbaranVentas,
  pFIBQuery,
  ModuloDatos, FIBQuery, frxBarcode, frxExportDBF, frxExportODF, frxExportMail,
  frxExportCSV, frxExportText, frxExportImage, frxExportRTF, frxExportXML,
  frxExportXLS, frxExportHTML, frxClass, frxExportPDF, frxDBSet, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdURI, StrUtils,IdCookieManager;

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
    function GetUUIDByTitle(const Title: string): string;
    procedure DrupalDELETE;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  private
    username, pass: string;
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

      DrupalDELETE;
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

procedure TFormMenuAlbaranVentas.DrupalDELETE;
var
  uuid, url: string;
begin
  uuid := GetUUIDByTitle(pFIBDataSetTable.FieldByName('NCODIGO').AsString);

  if uuid = '' then
  begin
    ShowMessage('No se encontró albarán con ese código para eliminar.');
    Exit;
  end;

  url := 'https://barraca.demoastec.es/jsonapi/node/albaran_venta/' + uuid;

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

function TFormMenuAlbaranVentas.GetUUIDByTitle(const Title: string): string;
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

procedure TFormMenuAlbaranVentas.FormActivate(Sender: TObject);
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
