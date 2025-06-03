unit FichaGridAlbaranCompras;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FichaGridBase, FIBDatabase, pFIBDatabase, FIBQuery, pFIBQuery, DB,
  FIBDataSet, pFIBDataSet, Grids, DBGrids, StdCtrls, ComCtrls,
  ModuloDatos, FichaLineasAlbaranCompras, ExtCtrls, FichaUbicacionAlbaran,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdURI,
  StrUtils, frxClass,
  IdCookieManager, frxExportPDF, IdMultipartFormData;

type
  TFormFichaGridAlbaranCompras = class(TFormFichaGridBase0)
    fbntgrfldFIBDataSetTableNCOD_ALBARAN: TFIBIntegerField;
    fbstrngfldFIBDataSetTableCCOD_ARTICULO: TFIBStringField;
    fbcdfldFIBDataSetTableNPRECIO: TFIBBCDField;
    fbsmlntfldFIBDataSetTableNORDEN: TFIBSmallIntField;
    fbfltfldFIBDataSetTableNIVA: TFIBFloatField;
    fbfltfldFIBDataSetTableNRECARGO: TFIBFloatField;
    fbcdfldFIBDataSetTableNCANTIDAD1: TFIBBCDField;
    fbcdfldFIBDataSetTableNCANTIDAD2: TFIBBCDField;
    fbcdfldFIBDataSetTableNSUBTOTAL: TFIBBCDField;
    fbstrngfldFIBDataSetTableCNOMBRE_ARTICULO: TFIBStringField;
    pnlTotal: TPanel;
    edtTotal: TEdit;
    lblTotal: TLabel;
    edtRecargo: TEdit;
    lblRecargo: TLabel;
    edtIVA: TEdit;
    lblIVA: TLabel;
    edtSubtotal: TEdit;
    lblSubtotal: TLabel;
    btnUbicar: TButton;
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    constructor Create(AOwner: TComponent; Modo: Integer); reintroduce;
    procedure btnAceptarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    function getNombreProveedor: string;
    procedure cbbCodChange(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure pFIBDataSetTableNewRecord(DataSet: TDataSet);
    procedure ActualizarAlbaran();
    procedure CalculoTotal();
    function ConvertirStringToFloat(Valor: string): Double;
    procedure btnUbicarClick(Sender: TObject);
    function EscapeJSONString(const S: string): string;
    procedure DrupalPOSTPATCH();
    function SubirArchivoPDF(const FileName: string): string;
    function ExtraerUUIDDeJSON(const JSONRespuesta: string): string;
  private
    function hayCambios: Boolean;
    procedure changeValues;
    function GetUUIDByTitle(const Title: string): string;
    function LimpiarNumero(const S: string): string;

  public
    mode: Integer;
    originalFecha: TDateTime;
    originalCodProveedor: string;
    originalObservaciones: string;
    originalTotal: string;
    contInsertar: Integer;
    recargo: Boolean;
    falloInsert: Boolean;
    nombreProveedor: string;
    fechaAlbaran: TDateTime;
    Report: TfrxReport;
  private
    username: string;
    pass: string;
  end;

implementation

{$R *.dfm}

procedure TFormFichaGridAlbaranCompras.ButtonClick(Sender: TObject);
var
  FichaLineasAlbaranCompras: TFormFichaLineasAlbaranCompras;
  ultimoOrden, codAlbaran, orden: Integer;
begin

  fechaAlbaran := DateTimePickerFecha.DateTime;

  if TButton(Sender).Tag <> 1 then
    CalculoTotal;

  if TButton(Sender).Tag <> 3 then
  begin
    FichaLineasAlbaranCompras := TFormFichaLineasAlbaranCompras.Create(Self,
      TButton(Sender).Tag);

    FichaLineasAlbaranCompras.fechaAlbaran := fechaAlbaran;
    try
      if recargo then
      begin
        FichaLineasAlbaranCompras.pnlRecargo.Enabled := False;
        FichaLineasAlbaranCompras.edtRecargo.Enabled := False;
        FichaLineasAlbaranCompras.lblRecargo.Enabled := False;
      end;
      FichaLineasAlbaranCompras.edtCodigo.Text := EditCodigo.Text;
      if TButton(Sender).Tag <> 0 then
        FichaLineasAlbaranCompras.cbbCodArticulo.Text :=
          DataSource.DataSet.FieldByName('CCOD_ARTICULO').AsString;

      if not pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.StartTransaction;

      if TButton(Sender).Tag = 0 then
      begin
        pFIBQueryTable.Close;
        pFIBQueryTable.SQL.Text :=
          'SELECT MAX(NORDEN) FROM LINEAS_ALB_C WHERE NCOD_ALBARAN = :NCODIGO';
        pFIBQueryTable.ParamByName('NCODIGO').AsInteger := StrToInt
          (EditCodigo.Text);
        pFIBQueryTable.ExecQuery;

        if (not pFIBQueryTable.Eof) and (not pFIBQueryTable.Fields[0].IsNull)
          then
          ultimoOrden := pFIBQueryTable.Fields[0].AsInteger + 1
        else
          ultimoOrden := 1;

        FichaLineasAlbaranCompras.edtOrden.Text := IntToStr(ultimoOrden);
      end;

      case TButton(Sender).Tag of
        0:
          FichaLineasAlbaranCompras.Caption :=
            'Añadir nueva línea albarán ' + EditCodigo.Text + ' - ' +
            nombreProveedor;
        1:
          begin
            FichaLineasAlbaranCompras.Caption :=
              'Información de la línea albarán seleccionada ' +
              EditCodigo.Text + ' - ' + nombreProveedor;
            FichaLineasAlbaranCompras.edtCodigo.Text := EditCodigo.Text;
            FichaLineasAlbaranCompras.edtOrden.Text :=
              DataSource.DataSet.FieldByName('NORDEN').AsString;

            FichaLineasAlbaranCompras.lblNombreProducto.Caption :=
              DataSource.DataSet.FieldByName('CNOMBRE_ARTICULO').AsString;

            FichaLineasAlbaranCompras.cbbCodArticulo.Clear;
            FichaLineasAlbaranCompras.cbbCodArticulo.Items.Add
              (DataSource.DataSet.FieldByName('CCOD_ARTICULO').AsString);
            FichaLineasAlbaranCompras.cbbCodArticulo.ItemIndex := 0;

            FichaLineasAlbaranCompras.medtUnidadesPeso.Text :=
              DataSource.DataSet.FieldByName('NCANTIDAD1').AsString;
            FichaLineasAlbaranCompras.medtCajasPiezas.Text :=
              DataSource.DataSet.FieldByName('NCANTIDAD2').AsString;
            FichaLineasAlbaranCompras.medtPrecio.Text :=
              DataSource.DataSet.FieldByName('NPRECIO').AsString;
            FichaLineasAlbaranCompras.edtIVA.Text :=
              DataSource.DataSet.FieldByName('NIVA').AsString;
            FichaLineasAlbaranCompras.edtRecargo.Text :=
              DataSource.DataSet.FieldByName('NRECARGO').AsString;
            FichaLineasAlbaranCompras.edtSubtotal.Text := FloatToStr
              (DataSource.DataSet.FieldByName('NSUBTOTAL').AsFloat);

            FichaLineasAlbaranCompras.medtUnidadesPeso.ReadOnly := True;
            FichaLineasAlbaranCompras.medtCajasPiezas.ReadOnly := True;
            FichaLineasAlbaranCompras.medtPrecio.Enabled := False;
          end;
        2:
          begin
            FichaLineasAlbaranCompras.Caption :=
              'Actualizar línea albarán ' + EditCodigo.Text + ' - ' +
              nombreProveedor;
            FichaLineasAlbaranCompras.edtCodigo.Text := EditCodigo.Text;
            FichaLineasAlbaranCompras.edtOrden.Text :=
              DataSource.DataSet.FieldByName('NORDEN').AsString;
            FichaLineasAlbaranCompras.getCodArticulos;
            FichaLineasAlbaranCompras.cbbCodArticulo.ItemIndex :=
              FichaLineasAlbaranCompras.cbbCodArticulo.Items.IndexOf
              (DataSource.DataSet.FieldByName('CCOD_ARTICULO').AsString);

            FichaLineasAlbaranCompras.lblNombreProducto.Caption :=
              DataSource.DataSet.FieldByName('CNOMBRE_ARTICULO').AsString;

            FichaLineasAlbaranCompras.medtUnidadesPeso.Text :=
              DataSource.DataSet.FieldByName('NCANTIDAD1').AsString;
            FichaLineasAlbaranCompras.medtCajasPiezas.Text :=
              DataSource.DataSet.FieldByName('NCANTIDAD2').AsString;
            FichaLineasAlbaranCompras.medtPrecio.Text :=
              DataSource.DataSet.FieldByName('NPRECIO').AsString;
            FichaLineasAlbaranCompras.edtIVA.Text :=
              DataSource.DataSet.FieldByName('NIVA').AsString;
            FichaLineasAlbaranCompras.edtRecargo.Text :=
              DataSource.DataSet.FieldByName('NRECARGO').AsString;
            FichaLineasAlbaranCompras.edtSubtotal.Text :=
              DataSource.DataSet.FieldByName('NSUBTOTAL').AsString;

          end;
      end;

      FichaLineasAlbaranCompras.ShowModal;
    finally
      if (TButton(Sender).Tag = 0) or (TButton(Sender).Tag = 2) then
      begin
        if pFIBTransactionTable.InTransaction then
          pFIBTransactionTable.Commit;
        if not pFIBTransactionTable.InTransaction then
          pFIBTransactionTable.StartTransaction;
        // Primero cerramos el dataset
        pFIBDataSetTable.Close;

        pFIBDataSetTable.ParamByName('NCOD_ALBARAN').AsInteger := StrToInt
          (EditCodigo.Text);

        // Abrir el dataset
        pFIBDataSetTable.Open;

        // Después verificamos si hay registros
        if pFIBDataSetTable.RecordCount > 0 then
        begin
          if FichaLineasAlbaranCompras.edtOrden.Text <> '' then
            pFIBDataSetTable.Locate('NCOD_ALBARAN;NORDEN',
              VarArrayOf([StrToInt(EditCodigo.Text),
                StrToInt(FichaLineasAlbaranCompras.edtOrden.Text)]), []);
        end
        else
        begin
          ShowMessage('No hay registros disponibles');
        end;
      end;
    end;
    if TButton(Sender).Tag <> 1 then
      CalculoTotal;
  end
  else // Borrar
  begin
    try
      codAlbaran := DataSource.DataSet.FieldByName('NCOD_ALBARAN').AsInteger;
      orden := DataSource.DataSet.FieldByName('NORDEN').AsInteger;

      if not pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.StartTransaction;

      pFIBQueryTable.Close;
      pFIBQueryTable.SQL.Text :=
        'DELETE FROM LINEAS_ALB_C WHERE NCOD_ALBARAN = :OLD_NCOD_ALBARAN and NORDEN = :OLD_NORDEN';
      pFIBQueryTable.ParamByName('OLD_NCOD_ALBARAN').AsInteger := codAlbaran;
      pFIBQueryTable.ParamByName('OLD_NORDEN').AsInteger := orden;
      pFIBQueryTable.ExecQuery;

      if pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.Commit;

      pFIBDataSetTable.Close;
      pFIBDataSetTable.Open;

      CalculoTotal;
      ShowMessage('La línea albarán se ha eliminado con éxito.');
    except
      on E: Exception do
      begin
        if pFIBTransactionTable.InTransaction then
          pFIBTransactionTable.Rollback;
        ShowMessage('Error al eliminar el registro: ' + E.Message);
      end;
    end;
  end;
end;

procedure TFormFichaGridAlbaranCompras.CalculoTotal;
var
  Total, BaseImponible, IVA, RecargoLinea, sumaIVA, sumaREQ, TotalBase: Double;
  recargo: string;
  pFIBQueryCalculo: TpFIBQuery;
  pFIBTransactionCalculo: TpFIBTransaction;
begin
  Total := 0;
  BaseImponible := 0;
  TotalBase := 0;
  IVA := 0;
  RecargoLinea := 0;
  sumaIVA := 0;
  sumaREQ := 0;

  // Crear transacción y consulta
  pFIBTransactionCalculo := TpFIBTransaction.Create(nil);
  // Inicializar transacción
  try
    pFIBTransactionCalculo.DefaultDatabase :=
      ModuloDatos.DataModuleBDD.pFIBDatabase;

    if not pFIBTransactionCalculo.InTransaction then
      pFIBTransactionCalculo.StartTransaction;

    pFIBQueryCalculo := TpFIBQuery.Create(nil); // Inicializar consulta
    try
      pFIBQueryCalculo.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
      pFIBQueryCalculo.Transaction := ModuloDatos.DataModuleBDD.pFIBTransaction;

      // Obtener régimen fiscal del Proveedor
      pFIBQueryCalculo.Close;
      pFIBQueryCalculo.SQL.Text :=
        'SELECT CREG_FISCAL FROM PROVEEDORES WHERE NCODIGO = :NCODIGO';
      pFIBQueryCalculo.ParamByName('NCODIGO').AsString := cbbCod.Text;
      pFIBQueryCalculo.ExecQuery;

      // Verificar que se obtuvieron resultados
      if not pFIBQueryCalculo.Eof then
        recargo := pFIBQueryCalculo.FieldByName('CREG_FISCAL').AsString
      else
        recargo := ''; // O manejar el caso cuando no se encuentre el Proveedor

      pFIBQueryCalculo.Close;

      // Cargar todas las líneas del albarán sin agrupar
      pFIBQueryCalculo.SQL.Text :=
        'SELECT NSUBTOTAL, NIVA, NRECARGO FROM LINEAS_ALB_C WHERE NCOD_ALBARAN = :NCOD_ALBARAN';
      pFIBQueryCalculo.ParamByName('NCOD_ALBARAN').AsString := EditCodigo.Text;
      pFIBQueryCalculo.ExecQuery;

      while not pFIBQueryCalculo.Eof do
      begin
        // Verificar que los campos no sean nulos antes de usarlos
        if not pFIBQueryCalculo.FieldByName('NSUBTOTAL').IsNull then
          BaseImponible := pFIBQueryCalculo.FieldByName('NSUBTOTAL').AsFloat;
        if not pFIBQueryCalculo.FieldByName('NIVA').IsNull then
          IVA := pFIBQueryCalculo.FieldByName('NIVA').AsFloat;

        Total := Total + BaseImponible;
        Total := Total + (BaseImponible * IVA / 100);
        sumaIVA := sumaIVA + (BaseImponible * IVA / 100);
        TotalBase := TotalBase + BaseImponible;

        // Aplicar el NRECARGO si el Proveedor tiene 'R'
        if recargo = 'R' then
        begin
          if not pFIBQueryCalculo.FieldByName('NRECARGO').IsNull then
            RecargoLinea := pFIBQueryCalculo.FieldByName('NRECARGO').AsFloat;
          Total := Total + (BaseImponible * RecargoLinea / 100);
          sumaREQ := sumaREQ + (BaseImponible * RecargoLinea / 100);
        end;

        pFIBQueryCalculo.Next;
      end;

      edtSubtotal.Text := FormatFloat('#,##0.00', TotalBase);
      edtRecargo.Text := FormatFloat('#,##0.00', RecargoLinea);
      edtIVA.Text := FormatFloat('#,##0.00', sumaIVA);
      edtTotal.Text := FormatFloat('#,##0.00', Total);

    finally
      pFIBQueryCalculo.Free; // Liberar la consulta
    end;

    pFIBTransactionCalculo.Commit; // Confirmar la transacción

  except
    on E: Exception do
    begin
      pFIBTransactionCalculo.Rollback; // Hacer rollback en caso de error
      ShowMessage('Error: ' + E.Message);
    end;
  end;
  pFIBTransactionCalculo.Free; // Liberar la transacción
end;

procedure TFormFichaGridAlbaranCompras.cbbCodChange(Sender: TObject);
begin
  nombreProveedor := getNombreProveedor;
end;

procedure TFormFichaGridAlbaranCompras.changeValues;
begin
  originalFecha := DateTimePickerFecha.Date;
  originalCodProveedor := cbbCod.Text;
  originalObservaciones := MemoObservaciones.Text;
  originalTotal := edtTotal.Text;
end;

function TFormFichaGridAlbaranCompras.ConvertirStringToFloat(Valor: string)
  : Double;
var
  ValorFormateado: string;
begin
  // Eliminar puntos
  ValorFormateado := StringReplace(Valor, '.', '', [rfReplaceAll]);

  // Reemplazar coma por punto
  ValorFormateado := StringReplace(ValorFormateado, '.', ',', [rfReplaceAll]);

  // Utilizar StrToFloatDef con un formato explícito de punto como separador decimal
  Result := StrToFloat(ValorFormateado);
end;

constructor TFormFichaGridAlbaranCompras.Create(AOwner: TComponent;
  Modo: Integer);
begin
  inherited Create(AOwner);
  mode := Modo;
  changeValues;
  contInsertar := 0;

  case Modo of
    0, 1:
      begin
        ButtonInsertar.Enabled := True;
        ButtonVer.Enabled := True;
        ButtonActualizar.Enabled := True;
        ButtonBorrar.Enabled := True;
        btnUbicar.Enabled := True;
      end;
    2:
      begin
        MemoObservaciones.Enabled := False;
        DateTimePickerFecha.Enabled := False;
        if pFIBDataSetTable.RecordCount = 0 then
        begin
          ButtonVer.Enabled := False;
        end
        else
          ButtonVer.Enabled := True;
        ButtonInsertar.Enabled := False;
        ButtonActualizar.Enabled := False;
        ButtonBorrar.Enabled := False;
        btnUbicar.Enabled := False;
      end;
  end;
  if (Modo = 1) or (Modo = 2) then
    DateTimePickerFecha.Enabled := False;
end;

procedure TFormFichaGridAlbaranCompras.DataSourceDataChange(Sender: TObject;
  Field: TField);
begin
  if pFIBDataSetTable.RecordCount > 0 then
  begin
    cbbCod.Enabled := False;
  end
  else
    cbbCod.Enabled := True;
  if mode <> 2 then
  begin
    if pFIBDataSetTable.RecordCount > 0 then
    begin
      ButtonActualizar.Enabled := True;
      ButtonVer.Enabled := True;
      ButtonBorrar.Enabled := True;
      btnUbicar.Enabled := True;
    end
    else if pFIBDataSetTable.RecordCount = 0 then
    begin
      ButtonActualizar.Enabled := False;
      ButtonVer.Enabled := False;
      ButtonBorrar.Enabled := False;
      btnUbicar.Enabled := False;
    end;
  end;
  if mode = 2 then
    if pFIBDataSetTable.RecordCount > 0 then
      ButtonVer.Enabled := True;
end;

function TFormFichaGridAlbaranCompras.GetUUIDByTitle(const Title: string)
  : string;
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

procedure TFormFichaGridAlbaranCompras.DrupalPOSTPATCH;
var
  uuid, url, cJSON: string;
  jsonNode: TMemoryStream;
  cUTF8: UTF8String; // Cambiado a UTF8String
  crespuesta: string;
  uuidPDF: string;
begin
  try
    uuid := GetUUIDByTitle(EditCodigo.Text);

    // Subir PDF primero
    uuidPDF := SubirArchivoPDF('albaran.pdf');
    if uuidPDF = '' then
    begin
      ShowMessage('Error al subir PDF. No se puede continuar.');
      Exit;
    end;

    // Construir JSON
    cJSON := '{"data":{';

    // Solo añadir ID si estamos actualizando (PATCH)
    if uuid <> '' then
      cJSON := cJSON + '"id":"' + uuid + '",';

    // Tipo del nodo
    cJSON := cJSON + '"type":"node--albaran_compra",';

    // Atributos del nodo
    cJSON := cJSON + '"attributes":{';
    cJSON := cJSON + '"title":"' + EscapeJSONString(EditCodigo.Text) + '",';
    cJSON := cJSON + '"field_fecha":"' + FormatDateTime('yyyy-mm-dd',
      DateTimePickerFecha.DateTime) + '",';
    cJSON := cJSON + '"field_codigo_proveedor":' + cbbCod.Text + ',';
    cJSON := cJSON + '"field_nombre_proveedor":"' + EscapeJSONString
      (getNombreProveedor) + '",';
    cJSON := cJSON + '"field_observaciones":{"value":"' + EscapeJSONString
      (MemoObservaciones.Text) + '","format":"basic_html"},';
    cJSON := cJSON + '"field_total_bruto":' + LimpiarNumero(edtSubtotal.Text)
      + ',';
    cJSON := cJSON + '"field_total_recargo":' + LimpiarNumero(edtRecargo.Text)
      + ',';
    cJSON := cJSON + '"field_total_iva":' + LimpiarNumero(edtIVA.Text) + ',';
    cJSON := cJSON + '"field_total":' + LimpiarNumero(edtTotal.Text);
    cJSON := cJSON + '}'; // Cerrar attributes

    // Añadir relación al PDF si tenemos UUID
    if uuidPDF <> '' then
    begin
      cJSON := cJSON + ','; // Coma después de attributes
      cJSON := cJSON + '"relationships":{';
      cJSON := cJSON + '"field_pdf_albaran":{';
      cJSON := cJSON + '"data":{';
      cJSON := cJSON + '"type":"file--file",';
      cJSON := cJSON + '"id":"' + uuidPDF + '"';
      cJSON := cJSON + '}'; // Cerrar data
      cJSON := cJSON + '}'; // Cerrar field_pdf_albaran
      cJSON := cJSON + '}'; // Cerrar relationships
    end;

    cJSON := cJSON + '}}'; // Cerrar data y root

    // Crear stream para el JSON
    jsonNode := TMemoryStream.Create;
    try
      // Mejorar la codificación UTF-8
      cUTF8 := UTF8Encode(cJSON);
      jsonNode.WriteBuffer(cUTF8[1], Length(cUTF8));
      jsonNode.Position := 0;

      // Configurar HTTP con headers más específicos
      IdHTTP.ConnectTimeout := 10000;
      IdHTTP.ReadTimeout := 30000;
      IdHTTP.Request.Clear;
      IdHTTP.Request.CustomHeaders.Clear;

      // Configuración de autenticación
      IdHTTP.Request.BasicAuthentication := True;
      IdHTTP.Request.Username := username;
      IdHTTP.Request.Password := pass;

      // Headers específicos para Drupal JSON:API
      IdHTTP.Request.ContentType := 'application/vnd.api+json';
      IdHTTP.Request.Accept := 'application/vnd.api+json';
      IdHTTP.Request.CharSet := 'utf-8';
      IdHTTP.Request.ContentLength := jsonNode.Size;

      // Headers adicionales que pueden ayudar con Drupal
      IdHTTP.Request.CustomHeaders.Add('X-Requested-With: XMLHttpRequest');

      // Log del JSON para depuración (activar si necesitas debug)
      {$IFDEF DEBUG}
      ShowMessage('JSON a enviar: ' + cJSON);
      ShowMessage('Content-Length: ' + IntToStr(jsonNode.Size));
      {$ENDIF}

      try
        if uuid = '' then
        begin
          // Crear nuevo nodo con POST
          url := 'https://barraca.demoastec.es/jsonapi/node/albaran_compra';
          crespuesta := IdHTTP.Post(url, jsonNode);
        end
        else
        begin
          // Actualizar nodo existente con PATCH
          url := 'https://barraca.demoastec.es/jsonapi/node/albaran_compra/' + uuid;
          crespuesta := IdHTTP.Patch(url, jsonNode);
        end;

        // Verificar respuesta
        case IdHTTP.ResponseCode of
          200:
            ShowMessage('✓ Albarán actualizado correctamente');
          201:
            ShowMessage('✓ Albarán creado correctamente');
          400:
            ShowMessage('✗ Error 400: Datos inválidos en la petición' + #13#10 +
                       'Respuesta: ' + Copy(crespuesta, 1, 200));
          401:
            ShowMessage('✗ Error 401: No autorizado - Verificar credenciales');
          403:
            ShowMessage('✗ Error 403: Prohibido - Sin permisos');
          404:
            ShowMessage('✗ Error 404: Recurso no encontrado');
          415:
            ShowMessage('✗ Error 415: Tipo de media no soportado' + #13#10 +
                       'Content-Type enviado: ' + IdHTTP.Request.ContentType + #13#10 +
                       'Verificar configuración del servidor');
          422:
            ShowMessage('✗ Error 422: Entidad no procesable - Verificar formato JSON' + #13#10 +
                       'Respuesta: ' + Copy(crespuesta, 1, 200));
        else
          ShowMessage('✗ Error HTTP ' + IntToStr(IdHTTP.ResponseCode) + ': ' +
                     IdHTTP.ResponseText + #13#10 + 'Respuesta: ' + Copy(crespuesta, 1, 200));
        end;

      except
        on E: EIdHTTPProtocolException do
        begin
          ShowMessage('Error HTTP: ' + E.Message + #13#10 +
                     'Código: ' + IntToStr(E.ErrorCode) + #13#10 +
                     'Respuesta del servidor: ' + E.ErrorMessage + #13#10 +
                     'Content-Type usado: ' + IdHTTP.Request.ContentType);
        end;
      end;

    finally
      jsonNode.Free;
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Error general: ' + E.Message);
    end;
  end;
end;

// Función auxiliar para escapar strings JSON (si no la tienes ya)
function TFormFichaGridAlbaranCompras.EscapeJSONString(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    case S[i] of
      '"':
        Result := Result + '\"';
      '\':
        Result := Result + '\\';
      #8:
        Result := Result + '\b';
      #9:
        Result := Result + '\t';
      #10:
        Result := Result + '\n';
      #12:
        Result := Result + '\f';
      #13:
        Result := Result + '\r';
    else
      if Ord(S[i]) < 32 then
        Result := Result + '\u' + IntToHex(Ord(S[i]), 4)
      else
        Result := Result + S[i];
    end;
  end;
end;

function TFormFichaGridAlbaranCompras.LimpiarNumero(const S: string): string;
begin
  Result := StringReplace(S, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, ',', '.', [rfReplaceAll]);
end;

procedure TFormFichaGridAlbaranCompras.FormActivate(Sender: TObject);
begin
  if mode = 2 then
    CalculoTotal;

  if mode = 0 then
  begin
    ButtonInsertar.Enabled := False;
    ButtonActualizar.Enabled := False;
    ButtonVer.Enabled := False;
    ButtonBorrar.Enabled := False;
    btnUbicar.Enabled := False;
  end
  else
  begin
    if not pFIBTransactionTable.InTransaction then
      pFIBTransactionTable.StartTransaction;

    pFIBDataSetTable.Close;
    pFIBDataSetTable.ParamByName('NCOD_ALBARAN').AsInteger := StrToInt
      (EditCodigo.Text);
    pFIBDataSetTable.Open;

    pFIBQueryTable.Close;
    pFIBQueryTable.SQL.Text :=
      'SELECT CREG_FISCAL FROM PROVEEDORES WHERE NCODIGO = :NCODIGO';
    pFIBQueryTable.ParamByName('NCODIGO').AsInteger := StrToInt(cbbCod.Text);
    pFIBQueryTable.ExecQuery;

    if not pFIBQueryTable.Eof then
      recargo := (pFIBQueryTable.Fields[0].AsString = 'R')
    else
      recargo := False;
  end;
  if mode <> 1 then
    cbbCod.ItemIndex := 0;

  nombreProveedor := getNombreProveedor;

  if mode = 1 then
    CalculoTotal;

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

function TFormFichaGridAlbaranCompras.getNombreProveedor: string;
var
  transAbiertaPorMi: Boolean;
begin
  Result := '';
  transAbiertaPorMi := False;

  if not pFIBTransactionTable.InTransaction then
  begin
    pFIBTransactionTable.StartTransaction;
    transAbiertaPorMi := True;
  end;

  try
    pFIBQueryTable.Close;
    pFIBQueryTable.SQL.Text :=
      'SELECT CNOMBRE FROM PROVEEDORES WHERE NCODIGO = :NCODIGO';
    pFIBQueryTable.ParamByName('NCODIGO').AsInteger := StrToInt(cbbCod.Text);
    pFIBQueryTable.ExecQuery;

    if not pFIBQueryTable.Eof then
      Result := pFIBQueryTable.FieldByName('CNOMBRE').AsString;

    if transAbiertaPorMi then
      pFIBTransactionTable.Commit;
  except
    on E: Exception do
    begin
      if transAbiertaPorMi and pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.Rollback;
      raise ;
    end;
  end;
end;

function TFormFichaGridAlbaranCompras.hayCambios: Boolean;
begin
  Result := (DateTimePickerFecha.Date <> originalFecha) or
    (cbbCod.Text <> originalCodProveedor) or
    (MemoObservaciones.Text <> originalObservaciones) or
    (edtTotal.Text <> originalTotal);
end;

procedure TFormFichaGridAlbaranCompras.pFIBDataSetTableNewRecord
  (DataSet: TDataSet);
begin
  inherited;

  pFIBQueryTable.Close;
  pFIBQueryTable.SQL.Text :=
    'SELECT CREG_FISCAL FROM PROVEEDORES WHERE NCODIGO = :NCODIGO';
  pFIBQueryTable.ParamByName('NCODIGO').AsString := cbbCod.Text;
  pFIBQueryTable.ExecQuery;

  if not pFIBQueryTable.Eof then
  begin
    if Trim(pFIBQueryTable.FieldByName('CREG_FISCAL').AsString) = 'G' then
    begin
      // El DataSet ya debería estar en Insert por estar en NewRecord,
      // pero si no, lo forzamos por seguridad
      if not(DataSet.State in [dsInsert, dsEdit]) then
        DataSet.Edit;

      DataSet.FieldByName('NIVA').AsInteger := 7;
      DataSet.Post; // Importante para guardar el valor en el DataSet y reflejarlo en BDD al aplicar cambios
    end;
  end;
end;

procedure TFormFichaGridAlbaranCompras.ActualizarAlbaran;
begin
  try
    pFIBQueryTable.Close;
    pFIBQueryTable.SQL.Text :=
      'UPDATE ALBARAN_C SET DFECHA = :DFECHA, COBSERVACIONES = :COBSERVACIONES, NCOD_PROVEEDOR = :NCOD_PROVEEDOR, NTOTAL = :NTOTAL, NTOTAL_BRUTO = :NTOTAL_BRUTO, NIVA = :NIVA, NRECARGO = :NRECARGO WHERE NCODIGO = :NCODIGO';

    pFIBQueryTable.ParamByName('DFECHA').AsDateTime :=
      DateTimePickerFecha.DateTime;
    pFIBQueryTable.ParamByName('COBSERVACIONES').AsString :=
      MemoObservaciones.Text;
    pFIBQueryTable.ParamByName('NCOD_PROVEEDOR').AsInteger := StrToInt
      (cbbCod.Text);
    pFIBQueryTable.ParamByName('NCODIGO').AsInteger := StrToInt
      (EditCodigo.Text);

    pFIBQueryTable.ParamByName('NTOTAL').AsFloat := ConvertirStringToFloat
      (edtTotal.Text);
    pFIBQueryTable.ParamByName('NTOTAL_BRUTO').AsFloat := ConvertirStringToFloat
      (edtTotal.Text);
    pFIBQueryTable.ParamByName('NIVA').AsFloat := ConvertirStringToFloat
      (edtIVA.Text);
    pFIBQueryTable.ParamByName('NRECARGO').AsFloat := ConvertirStringToFloat
      (edtRecargo.Text);

    pFIBDataSetTable.Close;
    pFIBQueryTable.ExecQuery;
    pFIBTransactionTable.Commit;
    pFIBDataSetTable.Open;
    changeValues;
    ShowMessage('Albarán actualizado correctamente.');
  except
    on E: Exception do
    begin
      if pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.Rollback;
      ShowMessage('Error al actualizar albarán: ' + E.Message);
    end;
  end;
end;

procedure TFormFichaGridAlbaranCompras.btnAceptarClick(Sender: TObject);
var
  CodigoGenerador: Integer;
begin

  if mode = 1 then
    CalculoTotal;

  if MemoObservaciones.Text = '' then
    MemoObservaciones.Text := 'MemoObservaciones';
  case mode of
    0: // Insertar
      begin
        if (contInsertar = 0) then
        begin
          try
            if not pFIBTransactionTable.InTransaction then
              pFIBTransactionTable.StartTransaction;

            falloInsert := True;

            ButtonInsertar.Enabled := True;
            if pFIBDataSetTable.RecordCount > 0 then
            begin

              ButtonActualizar.Enabled := True;
              ButtonVer.Enabled := True;
              ButtonBorrar.Enabled := True;
              btnUbicar.Enabled := True;
            end
            else
            begin
              ButtonActualizar.Enabled := False;
              ButtonVer.Enabled := False;
              ButtonBorrar.Enabled := False;
              btnUbicar.Enabled := False;
            end;

            pFIBQueryTable.Close;
            pFIBQueryTable.SQL.Text :=
              'SELECT GEN_ID(GEN_NCODIGO_ALBARAN_C, 1) FROM rdb$database';
            pFIBQueryTable.ExecQuery;
            CodigoGenerador := pFIBQueryTable.Fields[0].AsInteger;

            if Trim(EditCodigo.Text) = '' then
              EditCodigo.Text := IntToStr(CodigoGenerador)
            else if StrToInt(EditCodigo.Text) > CodigoGenerador then
            begin
              ShowMessage(
                'El código proporcionado es mayor que el valor del generador. Por favor, use un código menor o igual.');
              pFIBTransactionTable.Rollback;
              falloInsert := False;
              ButtonInsertar.Enabled := False;
              ButtonActualizar.Enabled := False;
              ButtonVer.Enabled := False;
              ButtonBorrar.Enabled := False;
              btnUbicar.Enabled := False;
              Exit;
            end;

            pFIBQueryTable.Close;
            pFIBQueryTable.SQL.Text :=
              'INSERT INTO ALBARAN_C (NCODIGO, DFECHA, COBSERVACIONES, NCOD_PROVEEDOR,NTOTAL,NTOTAL_BRUTO,NIVA,NRECARGO) VALUES (:NCODIGO, :DFECHA, :COBSERVACIONES, :NCOD_PROVEEDOR,:NTOTAL,:NTOTAL_BRUTO,:NIVA,:NRECARGO)';

            CalculoTotal;

            pFIBQueryTable.ParamByName('NCODIGO').AsInteger := StrToInt
              (EditCodigo.Text);
            pFIBQueryTable.ParamByName('DFECHA').AsDateTime :=
              DateTimePickerFecha.DateTime;
            pFIBQueryTable.ParamByName('COBSERVACIONES').AsString :=
              MemoObservaciones.Text;
            pFIBQueryTable.ParamByName('NCOD_PROVEEDOR').AsInteger := StrToInt
              (cbbCod.Text);

            pFIBQueryTable.ParamByName('NTOTAL').AsFloat :=
              ConvertirStringToFloat(edtTotal.Text);

            pFIBQueryTable.ParamByName('NTOTAL_BRUTO').AsFloat := StrToFloat
              (edtTotal.Text);

            pFIBQueryTable.ParamByName('NIVA').AsFloat := StrToFloat
              (edtIVA.Text);

            pFIBQueryTable.ParamByName('NRECARGO').AsFloat := StrToFloat
              (edtRecargo.Text);

            pFIBQueryTable.ExecQuery;

            pFIBTransactionTable.Commit;
            ShowMessage('Albarán de compra insertado correctamente.');
            DrupalPOSTPATCH();
            DateTimePickerFecha.Enabled := False;
            contInsertar := contInsertar + 1;
          except
            on E: Exception do
            begin
              if pFIBTransactionTable.InTransaction then
                pFIBTransactionTable.Rollback;
              ShowMessage('Error al insertar albarán: ' + E.Message);
            end;
          end;
        end
        else if DataSource.DataSet.RecordCount > 0 then
        begin
          pFIBTransactionTable.StartTransaction;
          pFIBQueryTable.SQL.Text :=
            'UPDATE ALBARAN_C SET  NTOTAL = :NTOTAL, NTOTAL_BRUTO = :NTOTAL_BRUTO,NIVA = :NIVA,NRECARGO = :NRECARGO  ' + 'WHERE NCODIGO = :NCODIGO';

          pFIBQueryTable.ParamByName('NCODIGO').AsInteger := StrToInt
            (EditCodigo.Text);

          pFIBQueryTable.ParamByName('NTOTAL').AsFloat := ConvertirStringToFloat
            (edtTotal.Text);

          pFIBQueryTable.ParamByName('NTOTAL_BRUTO').AsFloat := StrToFloat
            (edtTotal.Text);

          pFIBQueryTable.ParamByName('NIVA').AsFloat := StrToFloat(edtIVA.Text);

          pFIBQueryTable.ParamByName('NRECARGO').AsFloat := StrToFloat
            (edtRecargo.Text);
          pFIBDataSetTable.Close;
          pFIBQueryTable.ExecQuery;

          pFIBTransactionTable.Commit;
          Self.Close;
        end
        else

          Self.Close;
      end;
    1: // Actualizar
      begin
        if not hayCambios then
        begin
          Self.Close;
        end
        else
        begin
          ActualizarAlbaran();
          DrupalPOSTPATCH();
        end;
      end;
    2:
      Self.Close;
  end;
end;

procedure TFormFichaGridAlbaranCompras.btnUbicarClick(Sender: TObject);
var
  FichaUbicacionAlbaran: TFormFichaUbicacionAlbaran;
  pFIBTransaction: TpFIBTransaction;
  codArticulo: string;
  FactorConversion: Integer;
begin
  inherited;
  codArticulo := DBGrid.Fields[1].AsString;
  pFIBTransaction := TpFIBTransaction.Create(nil);
  pFIBTransaction.DefaultDatabase := ModuloDatos.DataModuleBDD.pFIBDatabase;
  FichaUbicacionAlbaran := TFormFichaUbicacionAlbaran.Create(nil, 2, False);
  FichaUbicacionAlbaran.fechaAlbaran := DateTimePickerFecha.DateTime; ;
  FichaUbicacionAlbaran.codigoAlbaran := StrToInt(EditCodigo.Text);
  FichaUbicacionAlbaran.Caption := 'Ubicar productos restantes';

  pFIBQueryTable.Close;
  pFIBTransaction.StartTransaction;
  pFIBQueryTable.SQL.Text :=
    'SELECT SUM(NCANTIDAD) FROM MOV_UBICACIONES WHERE CCOD_ARTICULO= :CCOD_ARTICULO AND NCOD_ALB_COMPRA= :NCOD_ALB_COMPRA';
  pFIBQueryTable.ParamByName('CCOD_ARTICULO').AsString := codArticulo;
  pFIBQueryTable.ParamByName('NCOD_ALB_COMPRA').AsInteger := StrToInt
    (EditCodigo.Text);

  pFIBQueryTable.ExecQuery;

  ShowMessage(IntToStr(pFIBQueryTable.Fields[0].AsInteger));
  pFIBTransaction.Commit;

  pFIBQueryTable.Close;
  if not pFIBTransaction.InTransaction then
    pFIBTransaction.StartTransaction;
  pFIBQueryTable.SQL.Text :=
    'SELECT A.NFACTCONV, A.NUNICAJ FROM ARTICULOS A WHERE A.CCODIGO = :COD_ARTICULO';
  pFIBQueryTable.ParamByName('COD_ARTICULO').AsString := codArticulo;
  pFIBQueryTable.ExecQuery;

  FactorConversion := pFIBQueryTable.FieldByName('NFACTCONV').AsInteger;

  if FactorConversion = 1 then
  begin
    if (pFIBDataSetTable.FieldByName('NCANTIDAD1').AsString = '0') or
      (pFIBDataSetTable.FieldByName('NCANTIDAD1').AsString = '1') then
    begin
      FichaUbicacionAlbaran.cantidadArticulo := pFIBDataSetTable.FieldByName
        ('NCANTIDAD2').AsInteger - pFIBQueryTable.Fields[0].AsInteger;
    end
    else
      FichaUbicacionAlbaran.cantidadArticulo := pFIBDataSetTable.FieldByName
        ('NCANTIDAD1').AsInteger - pFIBQueryTable.Fields[0].AsInteger;
  end
  else
    FichaUbicacionAlbaran.cantidadArticulo :=
      (pFIBDataSetTable.FieldByName('NCANTIDAD1')
        .AsInteger + pFIBDataSetTable.FieldByName('NCANTIDAD2').AsInteger)
      - pFIBQueryTable.Fields[0].AsInteger;

  FichaUbicacionAlbaran.esFaltante := True;
  FichaUbicacionAlbaran.codArticulo := DBGrid.Fields[1].AsString;
  FichaUbicacionAlbaran.codigoAlbaran := StrToInt(EditCodigo.Text);
  if FichaUbicacionAlbaran.cantidadArticulo > 0 then
  begin
    FichaUbicacionAlbaran.ShowModal;
  end
  else
    ShowMessage('Todos los artículos de este tipo están ya ubicados');

  pFIBTransaction.Commit;
end;

// PDF

function TFormFichaGridAlbaranCompras.SubirArchivoPDF(const FileName: string): string;
var
  PDFStream: TMemoryStream;
  Respuesta: string;
  PDFExport: TfrxPDFExport;
  MultipartData: TIdMultiPartFormDataStream;
begin
  Result := '';
  PDFStream := TMemoryStream.Create;
  PDFExport := TfrxPDFExport.Create(nil);
  MultipartData := TIdMultiPartFormDataStream.Create;
  try
    // Generar PDF
    PDFExport.ShowDialog := False;
    PDFExport.FileName := '';
    PDFExport.Stream := PDFStream;
    Report.PrepareReport;
    Report.Export(PDFExport);
    PDFStream.Position := 0;

    // Configurar petición HTTP
    IdHTTP.Request.Clear;
    IdHTTP.Request.BasicAuthentication := True;
    IdHTTP.Request.Username := username;
    IdHTTP.Request.Password := pass;

    // Para JSON:API de Drupal, necesitas enviar como multipart/form-data
    // Agregar el archivo PDF al formulario multipart
    MultipartData.AddFormField('data', '{"type":"file--file","attributes":{"filename":"' + FileName + '"}}');
    //MultipartData.AddFile('file', PDFStream, 'application/pdf', FileName);

    // El Content-Type se establece automáticamente por TIdMultiPartFormDataStream
    IdHTTP.Request.Accept := 'application/vnd.api+json';
    IdHTTP.Request.ContentType := 'application/vnd.api+json';

    try
      // Para JSON:API de Drupal, primero necesitas crear el entity file
      Respuesta := IdHTTP.Post('https://barraca.demoastec.es/jsonapi/file/file', MultipartData);
      Result := ExtraerUUIDDeJSON(Respuesta);
    except
      on E: EIdHTTPProtocolException do
      begin
                Result := '';
      end;
    end;

  finally
    MultipartData.Free;
    PDFExport.Free;
    PDFStream.Free;
  end;
end;

// Función auxiliar mejorada para extraer UUID
function TFormFichaGridAlbaranCompras.ExtraerUUIDDeJSON(const JSONRespuesta: string): string;
var
  pStart, pEnd: Integer;
  clave: string;
begin
  Result := '';

  // Buscar tanto en "id" como en "uuid" por si acaso
  clave := '"id":"';
  pStart := Pos(clave, JSONRespuesta);

  if pStart = 0 then
  begin
    clave := '"uuid":"';
    pStart := Pos(clave, JSONRespuesta);
  end;

  if pStart > 0 then
  begin
    Inc(pStart, Length(clave));
    pEnd := PosEx('"', JSONRespuesta, pStart);

    if pEnd > pStart then
    begin
      Result := Copy(JSONRespuesta, pStart, pEnd - pStart);
      // Validar que sea un UUID válido (36 caracteres con guiones)
      if (Length(Result) <> 36) or (Result[9] <> '-') or (Result[14] <> '-') or
         (Result[19] <> '-') or (Result[24] <> '-') then
        Result := '';
    end;
  end;
end;
end.
