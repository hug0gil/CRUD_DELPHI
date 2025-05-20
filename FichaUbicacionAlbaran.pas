unit FichaUbicacionAlbaran;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FichaBase, StdCtrls, FIBQuery, pFIBQuery, FIBDatabase, pFIBDatabase,
  ExtCtrls, ComCtrls, ModuloDatos;

type
  TFormFichaUbicacionAlbaran = class(TFormFichaBase)
    pnlCantidad: TPanel;
    lblCantidadUbicacion: TLabel;
    edtCantidad: TEdit;
    pnlFilas: TPanel;
    lblFilas: TLabel;
    pnlPasillo: TPanel;
    lblPasillo: TLabel;
    pnlSeccion: TPanel;
    lblSeccion: TLabel;
    cbbPasillo: TComboBox;
    cbbSeccion: TComboBox;
    cbbFila: TComboBox;
    pnlFechaMov: TPanel;
    lblFechaMov: TLabel;
    dtpFecha: TDateTimePicker;
    pnlLabel: TPanel;
    lblRestante: TLabel;
    lblCapacidad: TLabel;
    lblCantidad: TLabel;
    constructor Create(AOwner: TComponent; Modo: Integer; TipoVenta: Boolean);
      overload;
    procedure FormActivate(Sender: TObject);
    procedure cbbPasilloChange(Sender: TObject);
    procedure cbbSeccionChange(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    function GenerarNuevoCodigo(): Integer;
    function todoCorrecto(): Boolean;
    function estaAlmacenado(): Integer;
    procedure cbbFilaChange(Sender: TObject);
    procedure edtCantidadKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    mode: Integer;
    esVenta: Boolean;
    cantidadOcupada, capacidadFila: Integer;
    cantidadActual: Integer;
  public
    { Public declarations }
    fechaAlbaran: TDateTime;
    codAlbaran: string;
    codArticulo: string;
    cantidadArticulo: Integer;
    hayStock: Boolean;
    esFaltante: Boolean;
    realizada: Boolean;

  end;

implementation

{$R *.dfm}

constructor TFormFichaUbicacionAlbaran.Create(AOwner: TComponent;
  Modo: Integer; TipoVenta: Boolean);
begin
  inherited Create(AOwner);
  mode := Modo;
  esVenta := TipoVenta;

  cantidadOcupada := 0;
  capacidadFila := 0;
  realizada := False;

end;

procedure TFormFichaUbicacionAlbaran.btnAceptarClick(Sender: TObject);
begin
  if mode = 1 then
  begin
    Self.Close;
  end
  else
  begin
    if (capacidadFila < (cantidadOcupada + StrToInt(edtCantidad.Text))) and
      (not esVenta) then
    begin
      ShowMessage('Introduce una cantidad que quepa en la fila');
    end
    else
    begin
      if todoCorrecto then
      begin
        pFIBTransaction.StartTransaction;
        pFIBQuery.Close;
        pFIBQuery.SQL.Clear;
        pFIBQuery.Params.ClearValues;
        pFIBQuery.SQL.Text := 'UPDATE OR INSERT INTO MOV_UBICACIONES ' +
          '(NCODIGO, CCOD_ARTICULO, NPASILLO, NSECCION, NFILA, NCANTIDAD, DFECHA_MOVIMIENTO, NCOD_ALB_COMPRA, NCOD_ALB_VENTA) ' + 'VALUES (:NCODIGO, :CCOD_ARTICULO, :NPASILLO, :NSECCION, :NFILA, :NCANTIDAD, :DFECHA_MOVIMIENTO, :NCOD_ALB_COMPRA, :NCOD_ALB_VENTA) ' + 'MATCHING (NCODIGO)';

        try
          // Asignación de parámetros
          pFIBQuery.ParamByName('NCODIGO').AsInteger := GenerarNuevoCodigo();
          if codArticulo = '' then
            raise Exception.Create('El código del artículo está vacío');

          pFIBQuery.ParamByName('CCOD_ARTICULO').AsString := codArticulo;
          pFIBQuery.ParamByName('NPASILLO').AsInteger := StrToInt
            (cbbPasillo.Text);
          pFIBQuery.ParamByName('NSECCION').AsInteger := StrToInt
            (cbbSeccion.Text);
          pFIBQuery.ParamByName('NFILA').AsInteger := StrToInt(cbbFila.Text);
          pFIBQuery.ParamByName('NCANTIDAD').AsInteger := StrToInt
            (edtCantidad.Text);
          pFIBQuery.ParamByName('DFECHA_MOVIMIENTO').AsDateTime := Now;
          if esVenta then
          begin
            pFIBQuery.ParamByName('NCOD_ALB_COMPRA').Clear;
            pFIBQuery.ParamByName('NCOD_ALB_VENTA').AsInteger := StrToInt
              (codAlbaran);
          end
          else
          begin
            pFIBQuery.ParamByName('NCOD_ALB_COMPRA').AsInteger := StrToInt
              (codAlbaran);
            pFIBQuery.ParamByName('NCOD_ALB_VENTA').Clear;
          end;
          pFIBQuery.ExecQuery;
          pFIBQuery.Close;
          pFIBTransaction.Commit;

          ShowMessage('Movimiento de ubicación guardado correctamente.');
          realizada := True;

          cantidadActual := cantidadArticulo - StrToInt(edtCantidad.Text);
          if not esVenta then
            lblCantidad.Caption := 'Cantidad restante por vender : ' + IntToStr
              (cantidadActual);

          if ((not esVenta) and (cantidadActual = 0)) or
            ((esVenta) and (cantidadActual = 0)) then
            Self.Close;

        except
          on E: Exception do
          begin
            ShowMessage('Error al guardar el movimiento: ' + E.Message);
            pFIBTransaction.Rollback;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFormFichaUbicacionAlbaran.cbbFilaChange(Sender: TObject);
begin
  // Resetear variables
  cantidadOcupada := 0;
  capacidadFila := 0;

  // Calcular capacidad restante
  pFIBQuery.Close;

  pFIBQuery.SQL.Text :=
    'SELECT U.NCAPACIDAD, A.NSTOCK ' +
    'FROM UBICACIONES U ' + 'LEFT JOIN ARTIUBICACIONES A ' +
    'ON A.NPASILLO = U.NPASILLO AND A.NSECCION = U.NSECCION AND A.NFILA = U.NFILA ' + 'WHERE U.NPASILLO = :NPASILLO AND U.NSECCION = :NSECCION AND U.NFILA = :NFILA';

  if esVenta then
    pFIBQuery.SQL.Text := pFIBQuery.SQL.Text + ' AND U.NCAPACIDAD > 0';

  pFIBTransaction.StartTransaction;
  try
    pFIBQuery.ParamByName('NPASILLO').AsInteger := StrToInt(cbbPasillo.Text);
    pFIBQuery.ParamByName('NSECCION').AsInteger := StrToInt(cbbSeccion.Text);
    pFIBQuery.ParamByName('NFILA').AsInteger := StrToInt(cbbFila.Text);
    pFIBQuery.ExecQuery;

    // Obtener la capacidad
    if not pFIBQuery.Eof then
      capacidadFila := pFIBQuery.FieldByName('NCAPACIDAD').AsInteger;

    // Calcular cantidad ocupada sumando NSTOCK si hay
    while not pFIBQuery.Eof do
    begin
      if not pFIBQuery.FieldByName('NSTOCK').IsNull then
        cantidadOcupada := cantidadOcupada + pFIBQuery.FieldByName('NSTOCK')
          .AsInteger;
      // ShowMessage(pFIBQuery.FieldByName('NSTOCK').AsString);
      pFIBQuery.Next;
    end;

    ShowMessage(IntToStr(capacidadFila));
    ShowMessage(IntToStr(cantidadArticulo));

    if esFaltante then
    begin
      edtCantidad.Text := IntToStr(capacidadFila - cantidadArticulo);
    end;

    lblRestante.Caption := 'Capacidad restante de la fila: ' + IntToStr
      (capacidadFila - cantidadOcupada);
    lblCapacidad.Caption := 'Capacidad ocupada de la fila: ' + IntToStr
      (cantidadOcupada);

    // Mensaje si está llena
    if (capacidadFila - cantidadOcupada <= 0) and not esVenta then
      ShowMessage('Fila llena, no se pueden almacenar más artículos aquí');
  finally
    pFIBQuery.Close;
    pFIBTransaction.Commit;
  end;
end;

procedure TFormFichaUbicacionAlbaran.cbbPasilloChange(Sender: TObject);
begin

  if esVenta then
  begin
    pFIBQuery.Close;
    pFIBTransaction.StartTransaction;
    pFIBQuery.SQL.Text := 'SELECT DISTINCT NSECCION FROM ARTIUBICACIONES ' +
      'WHERE CARTICULO = :CARTICULO AND NPASILLO = :NPASILLO AND NSTOCK > 0 ' +
      'ORDER BY NSECCION';
    pFIBQuery.ParamByName('CARTICULO').AsString := codArticulo;
    pFIBQuery.ParamByName('NPASILLO').AsString := cbbPasillo.Text;
    pFIBQuery.ExecQuery;

    cbbSeccion.Clear;
    while not pFIBQuery.Eof do
    begin
      cbbSeccion.Items.Add(pFIBQuery.FieldByName('NSECCION').AsString);
      pFIBQuery.Next;
    end;

    pFIBTransaction.Commit;
    cbbFila.Clear;
    pFIBQuery.Close;
  end
  else
  begin
    pFIBQuery.Close;
    pFIBTransaction.StartTransaction;
    pFIBQuery.SQL.Text := 'SELECT DISTINCT NSECCION FROM UBICACIONES ' +
      'WHERE NPASILLO = :NPASILLO ORDER BY NSECCION';
    pFIBQuery.ParamByName('NPASILLO').AsString := cbbPasillo.Text;
    pFIBQuery.ExecQuery;

    cbbSeccion.Clear;
    while not pFIBQuery.Eof do
    begin
      cbbSeccion.Items.Add(pFIBQuery.FieldByName('NSECCION').AsString);
      pFIBQuery.Next;
    end;

    pFIBTransaction.Commit;
    cbbFila.Clear;
    pFIBQuery.Close;
  end;
end;

procedure TFormFichaUbicacionAlbaran.cbbSeccionChange(Sender: TObject);
begin
  inherited;
  cbbFila.Clear;
  pFIBQuery.Close;

  if esVenta then
  begin
    pFIBQuery.Close;
    pFIBTransaction.StartTransaction;
    pFIBQuery.SQL.Text := 'SELECT DISTINCT NFILA FROM ARTIUBICACIONES ' +
      'WHERE CARTICULO = :CARTICULO AND NPASILLO = :NPASILLO AND NSECCION = :NSECCION AND NSTOCK > 0 ' + 'ORDER BY NFILA';
    pFIBQuery.ParamByName('CARTICULO').AsString := codArticulo;
    pFIBQuery.ParamByName('NPASILLO').AsString := cbbPasillo.Text;
    pFIBQuery.ParamByName('NSECCION').AsString := cbbSeccion.Text;
    pFIBQuery.ExecQuery;

    cbbFila.Clear;
    while not pFIBQuery.Eof do
    begin
      cbbFila.Items.Add(pFIBQuery.FieldByName('NFILA').AsString);
      pFIBQuery.Next;
    end;

    pFIBQuery.Close;
    pFIBTransaction.Commit;
  end
  else
  begin
    pFIBQuery.Close;
    pFIBTransaction.StartTransaction;

    pFIBQuery.SQL.Text := 'SELECT U.NFILA, U.NCAPACIDAD ' +
      'FROM UBICACIONES U ' +
      'LEFT JOIN ARTIUBICACIONES A ON A.NPASILLO = U.NPASILLO AND A.NSECCION = U.NSECCION AND A.NFILA = U.NFILA '
      + 'WHERE U.NPASILLO = :NPASILLO AND U.NSECCION = :NSECCION ' +
      'GROUP BY U.NFILA, U.NCAPACIDAD ' +
      'HAVING COALESCE(SUM(A.NSTOCK), 0) < U.NCAPACIDAD ' + 'ORDER BY U.NFILA';

    pFIBQuery.ParamByName('NPASILLO').AsString := cbbPasillo.Text;
    pFIBQuery.ParamByName('NSECCION').AsString := cbbSeccion.Text;
    pFIBQuery.ExecQuery;

    cbbFila.Clear;
    while not pFIBQuery.Eof do
    begin
      cbbFila.Items.Add(pFIBQuery.FieldByName('NFILA').AsString);
      pFIBQuery.Next;
    end;

    pFIBQuery.Close;
    pFIBTransaction.Commit;
  end;

end;

procedure TFormFichaUbicacionAlbaran.FormActivate(Sender: TObject);
begin
  inherited;
  hayStock := True;
  cantidadActual := cantidadArticulo;

  edtCantidad.Text := IntToStr(cantidadArticulo);

  if esVenta then
  begin
    lblRestante.Caption := 'Cantidad restante por vender : ' + edtCantidad.Text;
    pFIBQuery.Close;

    // Verificar si hay stock para el artículo
    pFIBQuery.SQL.Text :=
      'SELECT FIRST 1 1 FROM ARTIUBICACIONES WHERE CARTICULO = :CARTICULO AND NSTOCK > 0';

    pFIBTransaction.StartTransaction;
    try
      pFIBQuery.ParamByName('CARTICULO').AsString := codArticulo;
      pFIBQuery.ExecQuery;

      if pFIBQuery.Eof then
      begin
        cbbPasillo.Clear;
        cbbSeccion.Clear;
        cbbFila.Clear;
        hayStock := False;

        ShowMessage('Este artículo no tiene stock en el almacén.');
        CloseModal;
      end
      else
      begin
        hayStock := True;
        // ShowMessage(BoolToStr(hayStock));

        lblCantidad.Caption := 'Cantidad restante por almacenar: ' + IntToStr
          (cantidadArticulo);
        dtpFecha.DateTime := fechaAlbaran;

        // Cargar pasillos con stock para ese artículo
        pFIBQuery.Close;
        pFIBQuery.SQL.Text :=
          'SELECT DISTINCT NPASILLO FROM ARTIUBICACIONES WHERE CARTICULO = :CARTICULO AND NSTOCK > 0 ORDER BY NPASILLO';
        pFIBQuery.ParamByName('CARTICULO').AsString := codArticulo;
        pFIBQuery.ExecQuery;

        cbbPasillo.Clear;
        while not pFIBQuery.Eof do
        begin
          cbbPasillo.Items.Add(pFIBQuery.FieldByName('NPASILLO').AsString);
          pFIBQuery.Next;
        end;

        // Limpiar seccion y fila porque aún no se ha seleccionado pasillo
        cbbSeccion.Clear;
        cbbFila.Clear;
      end;

      pFIBQuery.Close;
      pFIBTransaction.Commit;
    except
      on E: Exception do
      begin
        pFIBTransaction.Rollback;
        ShowMessage('Error al consultar ubicaciones: ' + E.Message);
      end;
    end;
  end
  else
  begin

    lblCantidad.Caption :=
      'Cantidad restante por almacenar: ' + edtCantidad.Text;

    dtpFecha.DateTime := fechaAlbaran;
    pFIBQuery.Close;
    pFIBQuery.SQL.Text := 'SELECT DISTINCT NPASILLO FROM UBICACIONES';
    pFIBTransaction.StartTransaction;

    try
      pFIBQuery.ExecQuery;
      while not pFIBQuery.Eof do
      begin
        cbbPasillo.Items.Add(pFIBQuery.FieldByName('NPASILLO').AsString);
        pFIBQuery.Next;
      end;
    finally
      pFIBQuery.Close;
      pFIBTransaction.Commit;
    end;
  end;
end;

function TFormFichaUbicacionAlbaran.GenerarNuevoCodigo: Integer;
var
  pFIBTransactionGenerator: TpFIBTransaction;
  pFIBQueryGenerator: TpFIBQuery;
begin
  pFIBTransactionGenerator := TpFIBTransaction.Create(nil);
  pFIBQueryGenerator := TpFIBQuery.Create(nil);
  pFIBQueryGenerator.Transaction := pFIBTransactionGenerator;
  pFIBQueryGenerator.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
  pFIBTransactionGenerator.DefaultDatabase :=
    ModuloDatos.DataModuleBDD.pFIBDatabase;
  pFIBTransactionGenerator.StartTransaction;
  pFIBQueryGenerator.Close;
  pFIBQueryGenerator.SQL.Text :=
    'SELECT GEN_ID(GEN_NCODIGO_MOV_UBICACIONES, 1) FROM rdb$database;';
  pFIBQueryGenerator.ExecQuery;
  Result := pFIBQueryGenerator.Fields[0].AsInteger;
  pFIBTransactionGenerator.Commit;
end;

procedure TFormFichaUbicacionAlbaran.edtCantidadKeyPress(Sender: TObject;
  var Key: Char);
var
  valorTexto: string;
  valorNum: Integer;
begin
  inherited;

  // Solo permitir números y tecla backspace
  if not(Key in ['0' .. '9', #8]) then
  begin
    Key := #0;
    Exit;
  end;

  // Simula el texto resultante si se introduce la tecla
  valorTexto := edtCantidad.Text;
  if Key <> #8 then
    valorTexto := valorTexto + Key
  else if Length(valorTexto) > 0 then
    Delete(valorTexto, Length(valorTexto), 1);

  // Si hay texto, convierte a número y valida
  if (valorTexto <> '') then
  begin
    valorNum := StrToIntDef(valorTexto, 0);

    if (valorNum < 1) or (valorNum > cantidadArticulo) then
    begin
      Key := #0; // Bloquear tecla si se sale del rango
      Beep;
    end;
  end;

end;

function TFormFichaUbicacionAlbaran.estaAlmacenado: Integer;
begin
  { cantidadArticulo := cantidadArticulo - StrToInt(edtCantidad.Text);
    Result := cantidadArticulo;
    lblCantidad.Caption := 'Cantidad restante por almacenar: ' + IntToStr
    (cantidadArticulo);
    ShowMessage(IntToStr(Result)); }
end;

function TFormFichaUbicacionAlbaran.todoCorrecto: Boolean;
var
  correcto: Boolean;
begin
  correcto := True;

  if cbbPasillo.Text = '' then
  begin
    ShowMessage('Selecciona un pasillo válido');
    correcto := False;
  end
  else if cbbSeccion.Text = '' then
  begin
    ShowMessage('Selecciona una sección válida');
    correcto := False;
  end
  else if cbbFila.Text = '' then
  begin
    ShowMessage('Selecciona una fila válida');
    correcto := False;
  end;
  if not esVenta then
  begin
    if (capacidadFila - cantidadOcupada) = 0 then
    begin
      ShowMessage(
        'El espacio restante para almacenar en esa fila es de 0, busca otra');
      correcto := False;
    end;
  end;

  Result := correcto;
end;

end.
