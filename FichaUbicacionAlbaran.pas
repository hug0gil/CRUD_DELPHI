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
    lblOcupado: TLabel;
    lblCantidad: TLabel;
    LabelTotal: TLabel;
    constructor Create(AOwner: TComponent; Modo: Integer; TipoVenta: Boolean);
      overload;
    function GenerarNuevoCodigo(): Integer;
    function todoCorrecto(): Boolean;
    procedure edtCantidadKeyPress(Sender: TObject; var Key: Char);
    procedure btnAceptarClick(Sender: TObject);
    procedure metodosVenta(mode: Integer);
    procedure metodosCompra(mode: Integer);
    procedure FormActivate(Sender: TObject);
    procedure cbbPasilloChange(Sender: TObject);
    procedure cbbSeccionChange(Sender: TObject);
    procedure cbbFilaChange(Sender: TObject);
    procedure ubicarRestantes();
    procedure recargarLabels();
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
    mode: Integer;
    esVenta: Boolean;
    cantidadOcupadaFila, capacidadTotalFila: Integer;
    cantidadActualArticulo: Integer;
  public
    { Public declarations }
    fechaAlbaran: TDateTime;
    codArticulo: string;
    cantidadArticulo: Integer;
    hayStock: Boolean;
    esFaltante: Boolean;

    codigoAlbaran: Integer;
    NPasillo, NSeccion, NFila: Integer;
    huboRollback: Boolean;

  end;

var
  FormFichaUbicacionAlbaran: TFormFichaUbicacionAlbaran;

implementation

{$R *.dfm}

procedure TFormFichaUbicacionAlbaran.btnAceptarClick(Sender: TObject);
begin
  // cantidadActual
  if esVenta then
  begin
    metodosVenta(mode);
  end
  else
    metodosCompra(mode);

end;

procedure TFormFichaUbicacionAlbaran.btnCancelarClick(Sender: TObject);
begin
  if (esVenta) and (mode = 0) then
  begin
    if MessageDlg(
      'Elige obligatoriamente una ubicación de la que extraer el producto, ¿estás seguro de querer salir?', mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      if pFIBTransaction.InTransaction then
        pFIBTransaction.Rollback;
      huboRollback := True;
      Close; // Cerramos el formulario
    end;
    // Si el usuario dice que NO, no hacemos nada y se queda en la pantalla
  end
  else
    Self.Close;
end;

procedure TFormFichaUbicacionAlbaran.cbbFilaChange(Sender: TObject);
begin
  inherited;
  recargarLabels();
end;

procedure TFormFichaUbicacionAlbaran.cbbPasilloChange(Sender: TObject);
begin
  inherited;
  cbbSeccion.Clear;
  cbbFila.Clear;

  pFIBQuery.Close;

  if not esVenta then
  begin
    // Mostrar todas las secciones posibles del pasillo
    pFIBQuery.SQL.Text := 'SELECT DISTINCT NSECCION FROM UBICACIONES ' +
      'WHERE NPASILLO = :NPASILLO ORDER BY NSECCION';
  end
  else
  begin
    // Mostrar solo secciones con stock del artículo en ese pasillo
    pFIBQuery.SQL.Text := 'SELECT DISTINCT U.NSECCION FROM UBICACIONES U ' +
      'JOIN MOV_UBICACIONES M ON U.NPASILLO = M.NPASILLO AND U.NSECCION = M.NSECCION AND U.NFILA = M.NFILA '
      + 'WHERE M.CCOD_ARTICULO = :COD_ARTICULO AND U.NPASILLO = :NPASILLO ' +
      'ORDER BY U.NSECCION';
    pFIBQuery.ParamByName('COD_ARTICULO').AsString := codArticulo;
  end;

  pFIBQuery.ParamByName('NPASILLO').AsInteger := StrToInt(cbbPasillo.Text);

  pFIBTransaction.StartTransaction;
  pFIBQuery.ExecQuery;

  while not pFIBQuery.Eof do
  begin
    cbbSeccion.Items.Add(pFIBQuery.FieldByName('NSECCION').AsString);
    pFIBQuery.Next;
  end;

  pFIBTransaction.Commit;
end;

procedure TFormFichaUbicacionAlbaran.cbbSeccionChange(Sender: TObject);
begin
  inherited;
  cbbFila.Clear;

  pFIBQuery.Close;

  if not esVenta then
  begin
    // Mostrar todas las filas posibles
    pFIBQuery.SQL.Text := 'SELECT DISTINCT NFILA FROM UBICACIONES ' +
      'WHERE NPASILLO = :NPASILLO AND NSECCION = :NSECCION ' + 'ORDER BY NFILA';
  end
  else
  begin
    // Mostrar solo filas con stock del artículo en la sección y pasillo seleccionados
    pFIBQuery.SQL.Text := 'SELECT DISTINCT U.NFILA ' + 'FROM UBICACIONES U ' +
      'JOIN MOV_UBICACIONES M ON U.NPASILLO = M.NPASILLO AND U.NSECCION = M.NSECCION AND U.NFILA = M.NFILA '
      + 'WHERE M.CCOD_ARTICULO = :COD_ARTICULO AND U.NPASILLO = :NPASILLO AND U.NSECCION = :NSECCION ' + 'ORDER BY U.NFILA';
    pFIBQuery.ParamByName('COD_ARTICULO').AsString := codArticulo;
  end;

  pFIBQuery.ParamByName('NPASILLO').AsInteger := StrToInt(cbbPasillo.Text);
  pFIBQuery.ParamByName('NSECCION').AsInteger := StrToInt(cbbSeccion.Text);

  pFIBTransaction.StartTransaction;
  pFIBQuery.ExecQuery;

  while not pFIBQuery.Eof do
  begin
    cbbFila.Items.Add(pFIBQuery.FieldByName('NFILA').AsString);
    pFIBQuery.Next;
  end;

  pFIBTransaction.Commit;
end;

constructor TFormFichaUbicacionAlbaran.Create(AOwner: TComponent;
  Modo: Integer; TipoVenta: Boolean);
begin
  inherited Create(AOwner);
  mode := Modo;
  esVenta := TipoVenta;
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

procedure TFormFichaUbicacionAlbaran.metodosCompra(mode: Integer);
begin
  if not todoCorrecto then
    Exit;

  case mode of
    // Insertar y Actualizar
    0, 2:
      begin
        if not pFIBTransaction.InTransaction then
          pFIBTransaction.StartTransaction;

        pFIBQuery.Close;
        pFIBQuery.SQL.Text :=
          'INSERT INTO MOV_UBICACIONES ' +
          '(NCODIGO, CCOD_ARTICULO, NPASILLO, NSECCION, NFILA, NCANTIDAD, DFECHA_MOVIMIENTO, NCOD_ALB_COMPRA) ' +
          'VALUES (:NCODIGO, :CCOD_ARTICULO, :NPASILLO, :NSECCION, :NFILA, :NCANTIDAD, :DFECHA_MOVIMIENTO, :NCOD_ALB_COMPRA)';

        // Asignación de parámetros
        pFIBQuery.Params.ParamByName('NCODIGO').AsInteger := GenerarNuevoCodigo();
        pFIBQuery.Params.ParamByName('CCOD_ARTICULO').AsString := codArticulo;
        pFIBQuery.Params.ParamByName('NPASILLO').AsInteger := StrToInt(cbbPasillo.Text);
        pFIBQuery.Params.ParamByName('NSECCION').AsInteger := StrToInt(cbbSeccion.Text);
        pFIBQuery.Params.ParamByName('NFILA').AsInteger := StrToInt(cbbFila.Text);
        pFIBQuery.Params.ParamByName('NCANTIDAD').AsInteger := StrToInt(edtCantidad.Text);
        pFIBQuery.Params.ParamByName('DFECHA_MOVIMIENTO').AsDate := Date;
        pFIBQuery.Params.ParamByName('NCOD_ALB_COMPRA').AsInteger := codigoAlbaran;

        pFIBQuery.ExecQuery;

        // Actualizar cantidad y etiquetas
        cantidadArticulo := cantidadArticulo - StrToInt(edtCantidad.Text);
        recargarLabels;

        // Cerrar si no queda más
        if cantidadArticulo = 0 then
        begin
          pFIBTransaction.Commit;
          Self.Close;
        end;
      end;

    // Ver
    1:
      begin
        Self.Close;
      end;
  end;
end;


procedure TFormFichaUbicacionAlbaran.metodosVenta(mode: Integer);
begin
  if not todoCorrecto then
    Exit;

  case mode of
    // Insertar y Actualizar
    0, 2:
      begin
        if not pFIBTransaction.InTransaction then
          pFIBTransaction.StartTransaction;

        pFIBQuery.Close;
        pFIBQuery.SQL.Text :=
          'INSERT INTO MOV_UBICACIONES ' +
          '(NCODIGO, CCOD_ARTICULO, NPASILLO, NSECCION, NFILA, NCANTIDAD, DFECHA_MOVIMIENTO, NCOD_ALB_VENTA) ' +
          'VALUES (:NCODIGO, :CCOD_ARTICULO, :NPASILLO, :NSECCION, :NFILA, :NCANTIDAD, :DFECHA_MOVIMIENTO, :NCOD_ALB_VENTA)';

        // Asignación de parámetros
        pFIBQuery.Params.ParamByName('NCODIGO').AsInteger := GenerarNuevoCodigo();
        pFIBQuery.Params.ParamByName('CCOD_ARTICULO').AsString := codArticulo;
        pFIBQuery.Params.ParamByName('NPASILLO').AsInteger := StrToInt(cbbPasillo.Text);
        pFIBQuery.Params.ParamByName('NSECCION').AsInteger := StrToInt(cbbSeccion.Text);
        pFIBQuery.Params.ParamByName('NFILA').AsInteger := StrToInt(cbbFila.Text);
        pFIBQuery.Params.ParamByName('NCANTIDAD').AsInteger := StrToInt(edtCantidad.Text);
        pFIBQuery.Params.ParamByName('DFECHA_MOVIMIENTO').AsDate := Date;
        pFIBQuery.Params.ParamByName('NCOD_ALB_VENTA').AsInteger := codigoAlbaran;

        pFIBQuery.ExecQuery;

        // Actualizar cantidad y etiquetas
        cantidadArticulo := cantidadArticulo - StrToInt(edtCantidad.Text);
        recargarLabels;

        // Cerrar si no queda más
        if cantidadArticulo = 0 then
        begin
          pFIBTransaction.Commit;
          Self.Close;
        end;
      end;

    // Ver
    1:
      begin
        Self.Close;
      end;
  end;
end;



// bloqueado en donde esta el valor supuesto que ibamos a insertar, lo necesito para poder hacer la ubicación del artículo
// en varios pasos

procedure TFormFichaUbicacionAlbaran.recargarLabels;
var
  pFIBQueryLabel: TpFIBQuery;
  pFIBTransactionLabel: TpFIBTransaction;
begin

  pFIBTransactionLabel := TpFIBTransaction.Create(nil);
  pFIBTransactionLabel.DefaultDatabase :=
    ModuloDatos.DataModuleBDD.pFIBDatabase;

  pFIBQueryLabel := TpFIBQuery.Create(nil);
  pFIBQueryLabel.Transaction := pFIBTransactionLabel;

  pFIBQueryLabel.Close;
  pFIBQueryLabel.SQL.Text :=
    'SELECT COALESCE(SUM(NSTOCK), 0) AS TOTAL_STOCK ' +
    'FROM ARTIUBICACIONES ' +
    'WHERE NPASILLO = :NPASILLO AND NSECCION = :NSECCION AND NFILA = :NFILA';

  pFIBQueryLabel.Params.ParamByName('NPASILLO').AsInteger := StrToInt
    (cbbPasillo.Text);
  pFIBQueryLabel.Params.ParamByName('NSECCION').AsInteger := StrToInt
    (cbbSeccion.Text);
  pFIBQueryLabel.Params.ParamByName('NFILA').AsInteger := StrToInt
    (cbbFila.Text);

  pFIBTransactionLabel.StartTransaction;
  pFIBQueryLabel.ExecQuery;

  cantidadOcupadaFila := pFIBQueryLabel.FieldByName('TOTAL_STOCK').AsInteger;

  pFIBQueryLabel.Close;
  pFIBQueryLabel.SQL.Text := 'SELECT NCAPACIDAD ' + 'FROM UBICACIONES ' +
    'WHERE NPASILLO = :NPASILLO AND NSECCION = :NSECCION AND NFILA = :NFILA';

  pFIBQueryLabel.Params.ParamByName('NPASILLO').AsInteger := StrToInt
    (cbbPasillo.Text);
  pFIBQueryLabel.Params.ParamByName('NSECCION').AsInteger := StrToInt
    (cbbSeccion.Text);
  pFIBQueryLabel.Params.ParamByName('NFILA').AsInteger := StrToInt
    (cbbFila.Text);

  pFIBTransactionLabel.StartTransaction;
  pFIBQueryLabel.ExecQuery;

  capacidadTotalFila := pFIBQueryLabel.FieldByName('NCAPACIDAD').AsInteger;

  LabelTotal.Caption := 'Capacidad total: ' + IntToStr(capacidadTotalFila);
  lblOcupado.Caption := 'Capacidad ocupada: ' + IntToStr(cantidadOcupadaFila);
  if not esVenta then
  begin
    lblRestante.Caption := 'Capacidad restante: ' + IntToStr
      (capacidadTotalFila - cantidadOcupadaFila);
    lblCantidad.Caption := 'Cantidad restante por almacenar: ' + IntToStr
      (cantidadActualArticulo);
  end
  else
  begin
    lblRestante.Caption := 'Capacidad restante: ' + IntToStr
      (capacidadTotalFila - cantidadOcupadaFila);
    lblCantidad.Caption := 'Cantidad restante por extraer: ' + IntToStr
      (cantidadActualArticulo);
  end;

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

procedure TFormFichaUbicacionAlbaran.FormActivate(Sender: TObject);
begin
  inherited;

  cantidadActualArticulo := cantidadArticulo;
  huboRollback := False;

  // Pasar desde el otro form para que no haga la query
  // cantidadArticulo := 10;

  if mode = 4 then
  begin
    ubicarRestantes();
  end;

  if not esVenta then
  begin
    lblCantidad.Caption := 'Cantidad restante por almacenar: ' + IntToStr
      (cantidadArticulo);
    // Mostrar todas las ubicaciones (todos los pasillos)
    pFIBQuery.Close;
    pFIBTransaction.StartTransaction;
    pFIBQuery.SQL.Text :=
      'SELECT DISTINCT NPASILLO FROM UBICACIONES ORDER BY NPASILLO';
    pFIBQuery.ExecQuery;
    while not pFIBQuery.Eof do
    begin
      cbbPasillo.Items.Add(pFIBQuery.FieldByName('NPASILLO').AsString);
      pFIBQuery.Next;
    end;
    pFIBTransaction.Commit;
  end
  else
  begin
    lblCantidad.Caption := 'Cantidad restante por extraer: ' + IntToStr
      (cantidadArticulo);

    // Mostrar solo los pasillos donde esté el artículo
    pFIBQuery.Close;
    pFIBTransaction.StartTransaction;
    pFIBQuery.SQL.Text :=
      'SELECT DISTINCT U.NPASILLO ' +
      'FROM UBICACIONES U ' + 'JOIN MOV_UBICACIONES M ON U.NPASILLO = M.NPASILLO AND U.NSECCION = M.NSECCION AND U.NFILA = M.NFILA ' + 'WHERE M.CCOD_ARTICULO = :COD_ARTICULO ' + 'ORDER BY U.NPASILLO';
    pFIBQuery.ParamByName('COD_ARTICULO').AsString := codArticulo;
    pFIBQuery.ExecQuery;

    // Forma correcta de comprobar si no hay resultados
    if pFIBQuery.BOF and pFIBQuery.Eof then
    begin
      pFIBTransaction.Commit; // Cierra la transacción antes de salir
      ShowMessage('No hay stock de ese artículo en ninguna ubicación.');
      Self.Close;

    end;

    pFIBTransaction.StartTransaction;

    // Si hay stock, rellenar pasillos
    while not pFIBQuery.Eof do
    begin
      cbbPasillo.Items.Add(pFIBQuery.FieldByName('NPASILLO').AsString);
      pFIBQuery.Next;
    end;

    pFIBTransaction.Commit;
  end;

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
    if (capacidadTotalFila - cantidadOcupadaFila) = 0 then
    begin
      ShowMessage(
        'El espacio restante para almacenar en esa fila es de 0, busca otra');
      correcto := False;
    end;
  end;

  Result := correcto;
end;

procedure TFormFichaUbicacionAlbaran.ubicarRestantes;
begin
  if cantidadArticulo = 0 then
  begin
    if not esVenta then
    begin
      pFIBQuery.Close;
      pFIBQuery.SQL.Text :=
        'SELECT a.NSTOCK - COALESCE(SUM(m.NCANTIDAD), 0) AS CantidadFaltante '
        + 'FROM ARTIUBICACIONES a ' + 'LEFT JOIN MOV_UBICACIONES m ON ' +
        'a.CARTICULO = m.CCOD_ARTICULO AND ' + 'a.NPASILLO = m.NPASILLO AND ' +
        'a.NSECCION = m.NSECCION AND ' + 'a.NFILA = m.NFILA AND ' +
        'm.NCOD_ALB_COMPRA = :CodigoAlbaran ' +
        'WHERE a.CARTICULO = :CodigoArticulo AND ' +
        'a.NPASILLO = :NPasillo AND ' + 'a.NSECCION = :NSeccion AND ' +
        'a.NFILA = :NFila ' + 'GROUP BY a.NSTOCK';

      pFIBQuery.Params.ParamByName('CodigoAlbaran').AsInteger := codigoAlbaran;
      pFIBQuery.Params.ParamByName('CodigoArticulo').AsString := codArticulo;
      pFIBQuery.Params.ParamByName('NPasillo').AsInteger := NPasillo;
      pFIBQuery.Params.ParamByName('NSeccion').AsInteger := NSeccion;
      pFIBQuery.Params.ParamByName('NFila').AsInteger := NFila;

      pFIBTransaction.StartTransaction;
      pFIBQuery.ExecQuery;

      cantidadActualArticulo := pFIBQuery.FieldByName('CantidadFaltante')
        .AsInteger;

      ShowMessage('Falta por ubicar de esta línea ' + IntToStr
          (cantidadActualArticulo) + ' unidades');

      pFIBTransaction.Commit;
    end;
  end;
end;

end.
