unit FichaGridAlbaranVentas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FichaGridBase, FIBDatabase, pFIBDatabase, FIBQuery, pFIBQuery, DB,
  FIBDataSet, pFIBDataSet, Grids, DBGrids, StdCtrls, ComCtrls,
  ModuloDatos, FichaLineasAlbaranVentas, ExtCtrls;

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
            'A�adir nueva l�nea albar�n ' + EditCodigo.Text + ' - ' +
            nombreCliente;
        1:
          begin
            FichaLineasAlbaranVentas.Caption :=
              'Informaci�n de la l�nea albar�n seleccionada ' +
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
              'Actualizar l�nea albar�n ' + EditCodigo.Text + ' - ' +
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

        // Despu�s verificamos si hay registros
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
      ShowMessage('La l�nea albar�n se ha eliminado con �xito.');
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

  // Crear transacci�n y consulta
  pFIBTransactionCalculo := TpFIBTransaction.Create(nil);
  // Inicializar transacci�n
  try
    pFIBTransactionCalculo.DefaultDatabase :=
      ModuloDatos.DataModuleBDD.pFIBDatabase;

    if not pFIBTransactionCalculo.InTransaction then
      pFIBTransactionCalculo.StartTransaction;

    pFIBQueryCalculo := TpFIBQuery.Create(nil); // Inicializar consulta
    try
      pFIBQueryCalculo.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
      pFIBQueryCalculo.Transaction := ModuloDatos.DataModuleBDD.pFIBTransaction;

      // Obtener r�gimen fiscal del cliente
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

      // Cargar todas las l�neas del albar�n sin agrupar
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

    pFIBTransactionCalculo.Commit; // Confirmar la transacci�n

  except
    on E: Exception do
    begin
      pFIBTransactionCalculo.Rollback; // Hacer rollback en caso de error
      ShowMessage('Error: ' + E.Message);
    end;
  end;
  pFIBTransactionCalculo.Free; // Liberar la transacci�n
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

  // Utilizar StrToFloatDef con un formato expl�cito de punto como separador decimal
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
      // El DataSet ya deber�a estar en Insert por estar en NewRecord,
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

    pFIBQueryTable.ParamByName('NIVA').AsFloat := ConvertirStringToFloat(edtIVA.Text);

    pFIBQueryTable.ParamByName('NRECARGO').AsFloat := ConvertirStringToFloat
      (edtRecargo.Text);

    pFIBDataSetTable.Close;
    pFIBQueryTable.ExecQuery;

    pFIBTransactionTable.Commit;
    pFIBDataSetTable.Open;
    changeValues;
    ShowMessage('Albar�n actualizado correctamente.');
  except
    on E: Exception do
    begin
      if pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.Rollback;
      ShowMessage('Error al actualizar albar�n: ' + E.Message);
    end;
  end;
end;

procedure TFormFichaGridAlbaranVentas.btnAceptarClick(Sender: TObject);
var
  CodigoGenerador: Integer;
begin

  if mode = 1 then
    CalculoTotal;
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
                'El c�digo proporcionado es mayor que el valor del generador. Por favor, use un c�digo menor o igual.');
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
            ShowMessage('Albar�n de venta insertado correctamente.');
            DateTimePickerFecha.Enabled := False;
            contInsertar := contInsertar + 1;
          except
            on E: Exception do
            begin
              if pFIBTransactionTable.InTransaction then
                pFIBTransactionTable.Rollback;
              ShowMessage('Error al insertar albar�n: ' + E.Message);
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
        end;
      end;
    2:
      Self.Close;
  end;
end;

end.
