unit FichaGridAlbaranVentas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FichaGridBase, FIBDatabase, pFIBDatabase, FIBQuery, pFIBQuery, DB,
  FIBDataSet, pFIBDataSet, Grids, DBGrids, StdCtrls, ComCtrls,
  ModuloDatos, FichaLineasAlbaranVentas, ExtCtrls, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdURI,
  StrUtils,
  IdCookieManager;

type
  TFormFichaGridAlbaranVentas = class(TFormFichaGridBase0)
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
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    constructor Create(AOwner: TComponent; Modo: Integer); reintroduce;
    procedure btnAceptarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    function getNombreCliente: string;
    procedure cbbCodClienteChange(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure pFIBDataSetTableNewRecord(DataSet: TDataSet);
    procedure ActualizarAlbaran();
    procedure CalculoTotal();
    function ConvertirStringToFloat(Valor: string): Double;
    function GetUUIDByTitle(const Title: string): string;
    function LimpiarNumero(const S: string): string;
    function EscapeJSONString(const S: string): string;
    procedure DrupalPOSTPATCH();
  private
    function hayCambios: Boolean;
    procedure changeValues;

  public
    mode: Integer;
    originalFecha: TDateTime;
    originalCodCliente: string;
    originalObservaciones: string;
    originalTotal: string;
    contInsertar: Integer;
    recargo: Boolean;
    falloInsert: Boolean;
    nombreCliente: string;
    fechaAlbaran: TDateTime;
  private
    username: string;
    pass: string;
  end;

implementation

{$R *.dfm}

procedure TFormFichaGridAlbaranVentas.ButtonClick(Sender: TObject);
var
  FichaLineasAlbaranVentas: TFormFichaLineasAlbaranVentas;
  ultimoOrden, codAlbaran, orden: Integer;
begin

  fechaAlbaran := DateTimePickerFecha.DateTime;

  if TButton(Sender).Tag <> 1 then
    CalculoTotal;

  if TButton(Sender).Tag <> 3 then
  begin
    FichaLineasAlbaranVentas := TFormFichaLineasAlbaranVentas.Create(Self,
      TButton(Sender).Tag);

    FichaLineasAlbaranVentas.fechaAlbaran := fechaAlbaran;

    try
      if recargo then
      begin
        FichaLineasAlbaranVentas.pnlRecargo.Enabled := False;
        FichaLineasAlbaranVentas.edtRecargo.Enabled := False;
        FichaLineasAlbaranVentas.lblRecargo.Enabled := False;
      end;
      FichaLineasAlbaranVentas.edtCodigo.Text := EditCodigo.Text;

      if TButton(Sender).Tag <> 0 then
        FichaLineasAlbaranVentas.cbbCodArticulo.Text :=
          DataSource.DataSet.FieldByName('CCOD_ARTICULO').AsString;

      if not pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.StartTransaction;

      if TButton(Sender).Tag = 0 then
      begin
        pFIBQueryTable.Close;
        pFIBQueryTable.SQL.Text :=
          'SELECT MAX(NORDEN) FROM LINEAS_ALB_V WHERE NCOD_ALBARAN = :NCODIGO';
        pFIBQueryTable.ParamByName('NCODIGO').AsInteger := StrToInt
          (EditCodigo.Text);
        pFIBQueryTable.ExecQuery;

        if (not pFIBQueryTable.Eof) and (not pFIBQueryTable.Fields[0].IsNull)
          then
          ultimoOrden := pFIBQueryTable.Fields[0].AsInteger + 1
        else
          ultimoOrden := 1;

        FichaLineasAlbaranVentas.edtOrden.Text := IntToStr(ultimoOrden);
      end;

      case TButton(Sender).Tag of
        0:
          FichaLineasAlbaranVentas.Caption :=
            'Añadir nueva línea albarán ' + EditCodigo.Text + ' - ' +
            nombreCliente;
        1:
          begin
            FichaLineasAlbaranVentas.Caption :=
              'Información de la línea albarán seleccionada ' +
              EditCodigo.Text + ' - ' + nombreCliente;
            FichaLineasAlbaranVentas.edtCodigo.Text := EditCodigo.Text;
            FichaLineasAlbaranVentas.edtOrden.Text :=
              DataSource.DataSet.FieldByName('NORDEN').AsString;

            FichaLineasAlbaranVentas.lblNombreProducto.Caption :=
              DataSource.DataSet.FieldByName('CNOMBRE_ARTICULO').AsString;

            FichaLineasAlbaranVentas.cbbCodArticulo.Clear;
            FichaLineasAlbaranVentas.cbbCodArticulo.Items.Add
              (DataSource.DataSet.FieldByName('CCOD_ARTICULO').AsString);
            FichaLineasAlbaranVentas.cbbCodArticulo.ItemIndex := 0;

            FichaLineasAlbaranVentas.medtUnidadesPeso.Text :=
              DataSource.DataSet.FieldByName('NCANTIDAD1').AsString;
            FichaLineasAlbaranVentas.medtCajasPiezas.Text :=
              DataSource.DataSet.FieldByName('NCANTIDAD2').AsString;
            FichaLineasAlbaranVentas.medtPrecio.Text :=
              DataSource.DataSet.FieldByName('NPRECIO').AsString;
            FichaLineasAlbaranVentas.edtIVA.Text :=
              DataSource.DataSet.FieldByName('NIVA').AsString;
            FichaLineasAlbaranVentas.edtRecargo.Text :=
              DataSource.DataSet.FieldByName('NRECARGO').AsString;
            FichaLineasAlbaranVentas.edtSubtotal.Text := FloatToStr
              (DataSource.DataSet.FieldByName('NSUBTOTAL').AsFloat);

            FichaLineasAlbaranVentas.medtUnidadesPeso.ReadOnly := True;
            FichaLineasAlbaranVentas.medtCajasPiezas.ReadOnly := True;
            FichaLineasAlbaranVentas.medtPrecio.Enabled := False;
          end;
        2:
          begin
            FichaLineasAlbaranVentas.Caption :=
              'Actualizar línea albarán ' + EditCodigo.Text + ' - ' +
              nombreCliente;
            FichaLineasAlbaranVentas.edtCodigo.Text := EditCodigo.Text;
            FichaLineasAlbaranVentas.edtOrden.Text :=
              DataSource.DataSet.FieldByName('NORDEN').AsString;
            FichaLineasAlbaranVentas.getCodArticulos;
            FichaLineasAlbaranVentas.cbbCodArticulo.ItemIndex :=
              FichaLineasAlbaranVentas.cbbCodArticulo.Items.IndexOf
              (DataSource.DataSet.FieldByName('CCOD_ARTICULO').AsString);

            FichaLineasAlbaranVentas.lblNombreProducto.Caption :=
              DataSource.DataSet.FieldByName('CNOMBRE_ARTICULO').AsString;

            FichaLineasAlbaranVentas.medtUnidadesPeso.Text :=
              DataSource.DataSet.FieldByName('NCANTIDAD1').AsString;
            FichaLineasAlbaranVentas.medtCajasPiezas.Text :=
              DataSource.DataSet.FieldByName('NCANTIDAD2').AsString;
            FichaLineasAlbaranVentas.medtPrecio.Text :=
              DataSource.DataSet.FieldByName('NPRECIO').AsString;
            FichaLineasAlbaranVentas.edtIVA.Text :=
              DataSource.DataSet.FieldByName('NIVA').AsString;
            FichaLineasAlbaranVentas.edtRecargo.Text :=
              DataSource.DataSet.FieldByName('NRECARGO').AsString;
            FichaLineasAlbaranVentas.edtSubtotal.Text :=
              DataSource.DataSet.FieldByName('NSUBTOTAL').AsString;

          end;
      end;

      FichaLineasAlbaranVentas.ShowModal;
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
          if FichaLineasAlbaranVentas.edtOrden.Text <> '' then
            pFIBDataSetTable.Locate('NCOD_ALBARAN;NORDEN',
              VarArrayOf([StrToInt(EditCodigo.Text),
                StrToInt(FichaLineasAlbaranVentas.edtOrden.Text)]), []);
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
        'DELETE FROM LINEAS_ALB_V WHERE NCOD_ALBARAN = :OLD_NCOD_ALBARAN and NORDEN = :OLD_NORDEN';
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

procedure TFormFichaGridAlbaranVentas.CalculoTotal;
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

      // Obtener régimen fiscal del cliente
      pFIBQueryCalculo.Close;
      pFIBQueryCalculo.SQL.Text :=
        'SELECT CREG_FISCAL FROM PROVEEDORES WHERE NCODIGO = :NCODIGO';
      pFIBQueryCalculo.ParamByName('NCODIGO').AsString := cbbCod.Text;
      pFIBQueryCalculo.ExecQuery;

      // Verificar que se obtuvieron resultados
      if not pFIBQueryCalculo.Eof then
        recargo := pFIBQueryCalculo.FieldByName('CREG_FISCAL').AsString
      else
        recargo := ''; // O manejar el caso cuando no se encuentre el cliente

      pFIBQueryCalculo.Close;

      // Cargar todas las líneas del albarán sin agrupar
      pFIBQueryCalculo.SQL.Text :=
        'SELECT NSUBTOTAL, NIVA, NRECARGO FROM LINEAS_ALB_V WHERE NCOD_ALBARAN = :NCOD_ALBARAN';
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

        // Aplicar el NRECARGO si el cliente tiene 'R'
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

procedure TFormFichaGridAlbaranVentas.cbbCodClienteChange(Sender: TObject);
begin
  nombreCliente := getNombreCliente;
end;

procedure TFormFichaGridAlbaranVentas.changeValues;
begin
  originalFecha := DateTimePickerFecha.Date;
  originalCodCliente := cbbCod.Text;
  originalObservaciones := MemoObservaciones.Text;
  originalTotal := edtTotal.Text;
end;

function TFormFichaGridAlbaranVentas.ConvertirStringToFloat(Valor: string)
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

constructor TFormFichaGridAlbaranVentas.Create(AOwner: TComponent;
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
      end;
  end;
  if (Modo = 1) or (Modo = 2) then
    DateTimePickerFecha.Enabled := False;
end;

procedure TFormFichaGridAlbaranVentas.DataSourceDataChange(Sender: TObject;
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
    end
    else if pFIBDataSetTable.RecordCount = 0 then
    begin
      ButtonActualizar.Enabled := False;
      ButtonVer.Enabled := False;
      ButtonBorrar.Enabled := False;
    end;
  end;
  if mode = 2 then
    if pFIBDataSetTable.RecordCount > 0 then
      ButtonVer.Enabled := True;
end;

procedure TFormFichaGridAlbaranVentas.FormActivate(Sender: TObject);
begin
  if mode = 2 then
    CalculoTotal;

  if mode = 0 then
  begin
    ButtonInsertar.Enabled := False;
    ButtonActualizar.Enabled := False;
    ButtonVer.Enabled := False;
    ButtonBorrar.Enabled := False;
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

  nombreCliente := getNombreCliente;

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

function TFormFichaGridAlbaranVentas.getNombreCliente: string;
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

function TFormFichaGridAlbaranVentas.GetUUIDByTitle(const Title: string)
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
    'https://barraca.demoastec.es/jsonapi/node/albaran_venta?filter[title]=' + filterTitle;

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

function TFormFichaGridAlbaranVentas.hayCambios: Boolean;
begin
  Result := (DateTimePickerFecha.Date <> originalFecha) or
    (cbbCod.Text <> originalCodCliente) or
    (MemoObservaciones.Text <> originalObservaciones) or
    (edtTotal.Text <> originalTotal);
end;

procedure TFormFichaGridAlbaranVentas.pFIBDataSetTableNewRecord
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

procedure TFormFichaGridAlbaranVentas.ActualizarAlbaran;
begin
  try
    pFIBQueryTable.Close;
    pFIBQueryTable.SQL.Text :=
      'UPDATE ALBARAN_V SET DFECHA = :DFECHA, COBSERVACIONES = :COBSERVACIONES, NCOD_CLIENTE = :NCOD_CLIENTE, NTOTAL = :NTOTAL, NTOTAL_BRUTO = :NTOTAL_BRUTO,NIVA = :NIVA,NRECARGO = :NRECARGO  ' + 'WHERE NCODIGO = :NCODIGO';
    pFIBQueryTable.ParamByName('DFECHA').AsDateTime :=
      DateTimePickerFecha.DateTime;
    pFIBQueryTable.ParamByName('COBSERVACIONES').AsString :=
      MemoObservaciones.Text;
    pFIBQueryTable.ParamByName('NCOD_CLIENTE').AsInteger := StrToInt
      (cbbCod.Text);
    pFIBQueryTable.ParamByName('NCODIGO').AsInteger := StrToInt
      (EditCodigo.Text);
    pFIBQueryTable.ParamByName('NTOTAL').AsFloat := ConvertirStringToFloat
      (edtTotal.Text);

    pFIBQueryTable.ParamByName('NTOTAL_BRUTO').AsFloat := ConvertirStringToFloat
      (edtSubtotal.Text);

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

procedure TFormFichaGridAlbaranVentas.btnAceptarClick(Sender: TObject);
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
            end
            else
            begin
              ButtonActualizar.Enabled := False;
              ButtonVer.Enabled := False;
              ButtonBorrar.Enabled := False;
            end;

            pFIBQueryTable.Close;
            pFIBQueryTable.SQL.Text :=
              'SELECT GEN_ID(GEN_NCODIGO_ALBARAN_V, 1) FROM rdb$database';
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
              Exit;
            end;

            pFIBQueryTable.Close;
            pFIBQueryTable.SQL.Text :=
              'INSERT INTO ALBARAN_V (NCODIGO, DFECHA, COBSERVACIONES, NCOD_CLIENTE,NTOTAL,NTOTAL_BRUTO,NIVA,NRECARGO) VALUES (:NCODIGO, :DFECHA, :COBSERVACIONES, :NCOD_CLIENTE,:NTOTAL,:NTOTAL_BRUTO,:NIVA,:NRECARGO)';

            CalculoTotal;

            pFIBQueryTable.ParamByName('NCODIGO').AsInteger := StrToInt
              (EditCodigo.Text);
            pFIBQueryTable.ParamByName('DFECHA').AsDateTime :=
              DateTimePickerFecha.DateTime;
            pFIBQueryTable.ParamByName('COBSERVACIONES').AsString :=
              MemoObservaciones.Text;
            pFIBQueryTable.ParamByName('NCOD_CLIENTE').AsInteger := StrToInt
              (cbbCod.Text);

            pFIBQueryTable.ParamByName('NTOTAL').AsFloat :=
              ConvertirStringToFloat(edtTotal.Text);

            pFIBQueryTable.ParamByName('NTOTAL_BRUTO').AsFloat := StrToFloat
              (edtSubtotal.Text);

            pFIBQueryTable.ParamByName('NIVA').AsFloat := StrToFloat
              (edtIVA.Text);

            pFIBQueryTable.ParamByName('NRECARGO').AsFloat := StrToFloat
              (edtRecargo.Text);

            pFIBQueryTable.ExecQuery;

            pFIBTransactionTable.Commit;
            DrupalPOSTPATCH();
            ShowMessage('Albarán de venta insertado correctamente.');
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
            'UPDATE ALBARAN_V SET  NTOTAL = :NTOTAL, NTOTAL_BRUTO = :NTOTAL_BRUTO,NIVA = :NIVA,NRECARGO = :NRECARGO  ' + 'WHERE NCODIGO = :NCODIGO';

          pFIBQueryTable.ParamByName('NCODIGO').AsInteger := StrToInt
            (EditCodigo.Text);

          pFIBQueryTable.ParamByName('NTOTAL').AsFloat := ConvertirStringToFloat
            (edtTotal.Text);

          pFIBQueryTable.ParamByName('NTOTAL_BRUTO').AsFloat := StrToFloat
            (edtSubtotal.Text);

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

procedure TFormFichaGridAlbaranVentas.DrupalPOSTPATCH;
var
  uuid, url, cJSON: string;
  jsonNode: TMemoryStream;
  cUTF8: AnsiString;
  crespuesta: string;

begin
  uuid := GetUUIDByTitle(EditCodigo.Text);
  cJSON := '{"data":{';

  if uuid <> '' then
    cJSON := cJSON + '"id":"' + uuid + '",';

  cJSON := cJSON + '"type":"node--albaran_venta",' + '"attributes":{' +
    '"title":"' + EditCodigo.Text + '",' + '"field_fecha":"' + FormatDateTime
    ('yyyy-mm-dd', DateTimePickerFecha.DateTime) + '",' +
    '"field_codigo_cliente":' + cbbCod.Text + ',' +
    '"field_nombre_del_cliente":"' + getNombreCliente + '",' +
    '"field_observaciones":{"value":"' + EscapeJSONString
    (MemoObservaciones.Text) + '","format":"basic_html"},' +
    '"field_total_bruto":' + LimpiarNumero(edtSubtotal.Text)
    + ',' + '"field_total_recargo":' + LimpiarNumero(edtRecargo.Text)
    + ',' + '"field_total_iva":' + LimpiarNumero(edtIVA.Text)
    + ',' + '"field_total":' + LimpiarNumero(edtTotal.Text) + '}}}';



  jsonNode := TMemoryStream.Create;
  try
    cUTF8 := UTF8Encode(cJSON);
    jsonNode.Write(cUTF8[1], Length(cUTF8));
    jsonNode.Position := 0;

    IdHTTP.ConnectTimeout := 10000;
    IdHTTP.Request.Clear;
    IdHTTP.Request.CustomHeaders.Clear;

    IdHTTP.Request.BasicAuthentication := True;
    IdHTTP.Request.username := username;
    IdHTTP.Request.Password := pass;
    IdHTTP.Request.ContentType := 'application/vnd.api+json';
    IdHTTP.Request.Accept := 'application/vnd.api+json';

    if uuid = '' then
    begin
      // Crear nuevo nodo con POST
      url := 'https://barraca.demoastec.es/jsonapi/node/albaran_venta';

      crespuesta := IdHTTP.Post(url, jsonNode);

    end
    else
    begin
      // Actualizar nodo existente con PATCH
      url := 'https://barraca.demoastec.es/jsonapi/node/albaran_venta' + uuid;
      IdHTTP.Request.Method := 'PATCH';
      crespuesta := IdHTTP.Patch(url, jsonNode);
    end;

    if (IdHTTP.ResponseCode = 200) or (IdHTTP.ResponseCode = 201) then
      // ShowMessage('✓ Albarán guardado correctamente')
    else
      ShowMessage('✗ Error HTTP ' + IntToStr(IdHTTP.ResponseCode));

  finally
    jsonNode.Free;
  end;

end;

function TFormFichaGridAlbaranVentas.LimpiarNumero(const S: string): string;
begin
  Result := StringReplace(S, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, ',', '.', [rfReplaceAll]);
end;

function TFormFichaGridAlbaranVentas.EscapeJSONString(const S: string): string;
begin
  Result := S;
  // Escapamos la barra invertida primero
  Result := StringReplace(Result, '\', '\\', [rfReplaceAll]);
  // Escapamos las comillas dobles
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
  // Escapamos el salto de línea CR+LF
  Result := StringReplace(Result, #13#10, '\n', [rfReplaceAll]);
  // Escapamos el salto de línea LF
  Result := StringReplace(Result, #10, '\n', [rfReplaceAll]);
  // Escapamos el retorno de carro (por si acaso)
  Result := StringReplace(Result, #13, '\n', [rfReplaceAll]);
end;



end.
