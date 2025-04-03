unit FichaGridAlbaran;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FichaGridBase,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls,
  FichaLineasAlbaran, ModuloDatos, System.Generics.Collections;
// <-- Añadir esta línea

type
  TFormFichaGridAlbaran = class(TFormFichaGridBase)
    FDTableNCOD_ALBARAN: TIntegerField;
    FDTableCCOD_ARTICULO: TStringField;
    FDTableNCANTIDAD: TFMTBCDField;
    FDTableNPRECIO: TFMTBCDField;
    FDTableNORDEN: TSmallintField;
    FDTableCBSUBTOTAL: TFMTBCDField;
    FDTableNIVA: TCurrencyField;
    FDTableNRECARGO: TCurrencyField;
    procedure btnAceptarClick(Sender: TObject);
    function TodoCorrectoAlbaran: Boolean;
    procedure btnCancelarClick(Sender: TObject);
    procedure ButtonInsertarClick(Sender: TObject);
    procedure ButtonVerClick(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    function getCodArticulos: TArray<String>;
    procedure ButtonBorrarClick(Sender: TObject);
    procedure ButtonActualizarClick(Sender: TObject);

  private
    procedure FiltrarLineasAlbaran;
  public
    CodigoAlbLinea: Integer;
    opcion: Integer;
    contAceptar: Integer;
    constructor Create(AOwner: TComponent; CodigoAlbaran: Integer;
      Modo: Integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

procedure TFormFichaGridAlbaran.FiltrarLineasAlbaran;
var
  CodigoAlbaran: Integer;
begin
  if not TryStrToInt(EditCodigo.Text, CodigoAlbaran) then
  begin
    FDTable.Filtered := False; // Si el código no es válido, quitar el filtro
    Exit;
  end;

  FDTable.Filter := 'NCOD_ALBARAN = ' + IntToStr(CodigoAlbaran);
  FDTable.Filtered := True;
end;

procedure TFormFichaGridAlbaran.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormFichaGridAlbaran.ButtonActualizarClick(Sender: TObject);
var
  FormAddLineasAlbaran: TFormFichaLineasAlbaran;
  CodArticulos: TArray<String>;
  i: Integer;
  LastOrden: Integer;
begin
  // Obtener el último valor de NORDEN
  FDQuery.Close;
  FDQuery.SQL.Text :=
    'SELECT MAX(NORDEN) AS LastOrden FROM LINEAS_ALB WHERE NCOD_ALBARAN = :CodigoAlbaran';
  FDQuery.ParamByName('CodigoAlbaran').AsInteger := StrToInt(EditCodigo.Text);
  FDQuery.Open;

  // Si se obtiene un valor, incrementar 1, si no, empezar desde 1
  if not FDQuery.Eof then
    LastOrden := FDQuery.FieldByName('LastOrden').AsInteger + 1
  else
    LastOrden := 1;

  // Crear la instancia del formulario para agregar las líneas
  FormAddLineasAlbaran := TFormFichaLineasAlbaran.Create(Self,
    StrToInt(EditCodigo.Text), LastOrden, 1);

  // Obtener los códigos de artículos y agregarlos al ComboBox
  CodArticulos := getCodArticulos;
  for i := 0 to High(CodArticulos) do
  begin
    FormAddLineasAlbaran.ComboBoxCodArticulo.Items.Add(CodArticulos[i]);
  end;

  // Establecer el primer elemento como seleccionado por defecto
  if Length(CodArticulos) > 0 then
    FormAddLineasAlbaran.ComboBoxCodArticulo.ItemIndex := 0;

  FormAddLineasAlbaran.ComboBoxCodArticulo.ItemIndex :=
    FormAddLineasAlbaran.ComboBoxCodArticulo.Items.IndexOf
    (DataSource.DataSet.FieldByName('CCOD_ARTICULO').AsString);
  FormAddLineasAlbaran.EditCantidad.Text := DataSource.DataSet.FieldByName
    ('NCANTIDAD').AsString;
  FormAddLineasAlbaran.EditPrecio.Text := DataSource.DataSet.FieldByName
    ('NPRECIO').AsString;

  FormAddLineasAlbaran.ShowModal;
  FormAddLineasAlbaran.Free;

end;

procedure TFormFichaGridAlbaran.ButtonBorrarClick(Sender: TObject);
var
  Confirmacion: Integer;
  DeleteQuery: TFDQuery;
  RetryCount: Integer;
  Success: Boolean;
const
  MAX_RETRIES = 3;
begin
  // Verificar si se ha seleccionado un albarán
  if CodigoAlbLinea = -1 then
  begin
    ShowMessage('Por favor, seleccione una línea para eliminar.');
    Exit;
  end;

  // Preguntar si estamos seguros de eliminar el albarán
  Confirmacion := MessageDlg('¿Está seguro de que desea eliminar esta línea?',
    mtConfirmation, [mbYes, mbNo], 0);

  // Si el usuario selecciona "Sí", proceder con la eliminación
  if Confirmacion = mrYes then
  begin
    DeleteQuery := TFDQuery.Create(nil);
    try
      DeleteQuery.Connection := ModuloDatos.DataModuleBDD.DataBaseFDConnection;

      // Añadir lógica de reintento para manejar deadlocks
      RetryCount := 0;
      Success := False;

      while (not Success) and (RetryCount < MAX_RETRIES) do
      begin
        try
          // Iniciar una nueva transacción
          ModuloDatos.DataModuleBDD.DataBaseFDConnection.StartTransaction;

          // Corregir la sintaxis SQL añadiendo AND entre condiciones
          DeleteQuery.SQL.Text :=
            'DELETE FROM LINEAS_ALB WHERE NCOD_ALBARAN = :Codigo AND NORDEN = :Orden';
          DeleteQuery.ParamByName('Codigo').AsInteger := CodigoAlbLinea;
          DeleteQuery.ParamByName('Orden').AsInteger := DataSource.DataSet.FieldByName('NORDEN').AsInteger;
          DeleteQuery.ExecSQL;

          // Confirmar si tiene éxito
          ModuloDatos.DataModuleBDD.DataBaseFDConnection.Commit;
          Success := True;
          ShowMessage('La línea ha sido eliminada con éxito.');

          // Refrescar los datos
          FDTable.Refresh;
        except
          on E: Exception do
          begin
            // Rollback en caso de error
            if ModuloDatos.DataModuleBDD.DataBaseFDConnection.InTransaction then
              ModuloDatos.DataModuleBDD.DataBaseFDConnection.Rollback;

            // Si es un deadlock, reintentar
            if (Pos('deadlock', LowerCase(E.Message)) > 0) or
               (Pos('update conflicts', LowerCase(E.Message)) > 0) then
            begin
              Inc(RetryCount);
              if RetryCount >= MAX_RETRIES then
                ShowMessage('Error al eliminar la línea después de varios intentos: ' + E.Message);
              // Pequeña pausa antes de reintentar
              Sleep(100 * RetryCount);
            end
            else
            begin
              // Para otros errores, mostrar mensaje y salir del bucle de reintentos
              ShowMessage('Error al eliminar la línea: ' + E.Message);
              Break;
            end;
          end;
        end;
      end;
    finally
      DeleteQuery.Free;
    end;
  end;
end;

procedure TFormFichaGridAlbaran.ButtonInsertarClick(Sender: TObject);
var
  FormAddLineasAlbaran: TFormFichaLineasAlbaran;
  CodArticulos: TArray<String>;
  i: Integer;
  LastOrden: Integer;
begin
  // Obtener el último valor de NORDEN
  FDQuery.Close;
  FDQuery.SQL.Text :=
    'SELECT MAX(NORDEN) AS LastOrden FROM LINEAS_ALB WHERE NCOD_ALBARAN = :CodigoAlbaran';
  FDQuery.ParamByName('CodigoAlbaran').AsInteger := StrToInt(EditCodigo.Text);
  FDQuery.Open;

  // Si se obtiene un valor, incrementar 1, si no, empezar desde 1
  if not FDQuery.Eof then
    LastOrden := FDQuery.FieldByName('LastOrden').AsInteger + 1
  else
    LastOrden := 1;

  // Crear la instancia del formulario para agregar las líneas
  FormAddLineasAlbaran := TFormFichaLineasAlbaran.Create(Self,
    StrToInt(EditCodigo.Text), LastOrden, 1);

  // Obtener los códigos de artículos y agregarlos al ComboBox
  CodArticulos := getCodArticulos;
  for i := 0 to High(CodArticulos) do
  begin
    FormAddLineasAlbaran.ComboBoxCodArticulo.Items.Add(CodArticulos[i]);
  end;

  // Establecer el primer elemento como seleccionado por defecto
  if Length(CodArticulos) > 0 then
    FormAddLineasAlbaran.ComboBoxCodArticulo.ItemIndex := 0;

  FormAddLineasAlbaran.ShowModal;
  FormAddLineasAlbaran.Free;
end;

function TFormFichaGridAlbaran.getCodArticulos: TArray<String>;
var
  QueryArticulos: TFDQuery;
  CodigosArticulos: TList<String>;
  i: Integer;
begin
  QueryArticulos := TFDQuery.Create(nil);
  CodigosArticulos := TList<String>.Create;
  try
    QueryArticulos.Connection := ModuloDatos.DataModuleBDD.DataBaseFDConnection;
    QueryArticulos.SQL.Text := 'SELECT CCODIGO FROM ARTICULOS';
    QueryArticulos.Open;

    // Agregar cada código de artículo a la lista dinámica
    while not QueryArticulos.Eof do
    begin
      CodigosArticulos.Add(QueryArticulos.FieldByName('CCODIGO').AsString);
      QueryArticulos.Next;
    end;

    // Convertir la lista en un array
    Result := CodigosArticulos.ToArray;
  finally
    QueryArticulos.Free;
    CodigosArticulos.Free;
  end;
end;

procedure TFormFichaGridAlbaran.ButtonVerClick(Sender: TObject);
var
  FormAddLineasAlbaran: TFormFichaLineasAlbaran;
begin
  FormAddLineasAlbaran := TFormFichaLineasAlbaran.Create(Self, CodigoAlbLinea,
    DataSource.DataSet.FieldByName('NORDEN').AsInteger, 3);
  FormAddLineasAlbaran.EditPrecio.Text := DataSource.DataSet.FieldByName
    ('NPRECIO').AsString;
  FormAddLineasAlbaran.EditCantidad.Text := DataSource.DataSet.FieldByName
    ('NCANTIDAD').AsString;
  FormAddLineasAlbaran.EditTotal.Text := DataSource.DataSet.FieldByName
    ('CBTOTAL').AsString;
  FormAddLineasAlbaran.ComboBoxCodArticulo.Enabled := True;
  FormAddLineasAlbaran.ComboBoxCodArticulo.Clear;
  FormAddLineasAlbaran.ComboBoxCodArticulo.Items.Add
    (DataSource.DataSet.FieldByName('CCOD_ARTICULO').AsString);
  FormAddLineasAlbaran.ComboBoxCodArticulo.ItemIndex := 0;
  FormAddLineasAlbaran.EditPrecio.ReadOnly := True;
  FormAddLineasAlbaran.EditCantidad.ReadOnly := True;
  FormAddLineasAlbaran.ShowModal;
  FormAddLineasAlbaran.Free;
end;

constructor TFormFichaGridAlbaran.Create(AOwner: TComponent;
  CodigoAlbaran: Integer; Modo: Integer);
begin
  inherited Create(AOwner);
  EditCodigo.Text := IntToStr(CodigoAlbaran);
  FiltrarLineasAlbaran;
  opcion := Modo;
  contAceptar := 1;

  // Lógica de habilitación de botones
  if Modo = 2 then
  begin
    ButtonInsertar.Enabled := True;
    ButtonBorrar.Enabled := True;
    ButtonActualizar.Enabled := True;
    ButtonVer.Enabled := True;
  end;

  if Modo = 3 then
  begin
    // Habilitar solo los botones Ver, Aceptar y Cancelar
    ButtonInsertar.Enabled := False;
    ButtonBorrar.Enabled := False;
    ButtonActualizar.Enabled := False;
    ButtonVer.Enabled := True; // Ver habilitado
  end;
end;

procedure TFormFichaGridAlbaran.DataSourceDataChange(Sender: TObject;
  Field: TField);
begin
  DataSource.DataSet.Edit;

  CodigoAlbLinea := -1;
  if (DataSource <> nil) and (DataSource.DataSet <> nil) and
    (DataSource.DataSet.Active) and (not DataSource.DataSet.IsEmpty) then
  begin
    if opcion <> 3 then

      ButtonBorrar.Enabled := True;

    ButtonVer.Enabled := True;
    CodigoAlbLinea := DataSource.DataSet.Fields[0].AsInteger;
  end
  else if opcion = 3 then
  begin
    ButtonBorrar.Enabled := False;
    ButtonActualizar.Enabled := False;
    ButtonInsertar.Enabled := False;
  end
  else
  begin
    ButtonBorrar.Enabled := False;
    ButtonActualizar.Enabled := False;
    ButtonVer.Enabled := False;
  end;
end;

procedure TFormFichaGridAlbaran.btnAceptarClick(Sender: TObject);
var
  FechaFormateada: string;
begin
  if opcion <> 3 then
  begin
    case contAceptar of
      1:
        if TodoCorrectoAlbaran() then
          try
            FechaFormateada := FormatDateTime('YYYY-MM-DD',
              DateTimePickerFecha.Date);

            if not FDTransactionTable.Active then
              FDTransactionTable.StartTransaction;

            // Preparar la consulta según la operación
            FDQuery.Close; // Cerrar la consulta antes de asignar nueva SQL
            case opcion of
              1: // Agregar nuevo albarán
                begin
                  FDQuery.SQL.Text :=
                    'INSERT INTO ALBARAN (NCODIGO, DFECHA, COBSERVACIONES, NCOD_CLIENTE) '
                    + 'VALUES (:Codigo, :Fecha, :Observaciones, :Cliente)';
                  FDQuery.ParamByName('Codigo').AsInteger :=
                    StrToInt(EditCodigo.Text);
                end;

              2: // Actualizar albarán
                begin
                  FDQuery.SQL.Text :=
                    'UPDATE ALBARAN SET DFECHA = :Fecha, COBSERVACIONES = :Observaciones, '
                    + 'NCOD_CLIENTE = :Cliente WHERE NCODIGO = :Codigo';
                  FDQuery.ParamByName('Codigo').AsInteger :=
                    StrToInt(EditCodigo.Text);
                end;
            end;

            FDQuery.ParamByName('Fecha').AsString := FechaFormateada;
            FDQuery.ParamByName('Observaciones').AsString :=
              MemoObservaciones.Lines.Text;
            FDQuery.ParamByName('Cliente').AsInteger :=
              StrToInt(ComboBoxCodCliente.Text);

            FDQuery.ExecSQL;
            FDTransactionTable.Commit;

            contAceptar := contAceptar + 1;

            ButtonInsertar.Enabled := True;
            ButtonBorrar.Enabled := True;
            ButtonActualizar.Enabled := True;
            ButtonVer.Enabled := True;
          except
            on E: Exception do
            begin
              FDTransactionTable.Rollback; // Revertir cambios en caso de error
              MessageDlg('Error en la operación: ' + E.Message, mtError,
                [mbOK], 0);
            end;
          end;
      2:
        begin
          Self.Close;
        end;
    end;
  end
  else
  begin
    Self.Close;
  end;
end;

function TFormFichaGridAlbaran.TodoCorrectoAlbaran: Boolean;
begin
  Result := True;

  // Verificar que los campos requeridos no estén vacíos
  if (ComboBoxCodCliente.Text = '') or (MemoObservaciones.Lines.Text = '') then
  begin
    MessageDlg('Por favor, rellene todos los campos.', mtError, [mbOK], 0);
    Result := False;
  end;
end;

end.
