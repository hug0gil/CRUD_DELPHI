unit FichaAlmacen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FichaBase, FIBQuery, pFIBQuery, FIBDatabase, pFIBDatabase, StdCtrls,
  ExtCtrls, Menus, Grids, ComCtrls, FichaUbicacion;

type
  THueco = record
    NFila, NCapacidad: Integer;
    EsManual: Boolean; // True = manual (rosa), False = máquina (amarillo)
  end;

  TUbicacion = record
    NPasillo, NSeccion: Integer;
    lstHuecos: array of THueco;
  end;

type
  TFormFichaAlmacen = class(TFormFichaBase)
    StringGrid: TStringGrid;
    pm1: TPopupMenu;
    pnlDatos: TPanel;
    spl1: TSplitter;
    Insertarcolumna1: TMenuItem;
    Eliminarcolumna1: TMenuItem;
    N1: TMenuItem;
    Insertarfila1: TMenuItem;
    Eliminarfila1: TMenuItem;
    stat1: TStatusBar;
    N2: TMenuItem;
    MarcarComoEstanteria: TMenuItem;
    MarcarComoPasillo: TMenuItem;
    btnReestablecer: TButton;
    lblPasillo: TLabel;
    lblSeccion: TLabel;
    lblNPasillo: TLabel;
    lblNSeccion: TLabel;
    lblNFilas: TLabel;
    lblFilas: TLabel;
    strngrdFilas: TStringGrid;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    pmFilas: TPopupMenu;
    mniRecogidamanual: TMenuItem;
    mniRecogidaMaquina: TMenuItem;
    mniN3: TMenuItem;
    mniN51: TMenuItem;
    mniN52: TMenuItem;
    mniReestablecerfila1: TMenuItem;
    pmMenu: TPopupMenu;
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    procedure Insertarcolumna1Click(Sender: TObject);
    procedure Eliminarcolumna1Click(Sender: TObject);
    procedure Insertarfila1Click(Sender: TObject);
    procedure Eliminarfila1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MarcarComoEstanteriaClick(Sender: TObject);
    procedure MarcarComoPasilloClick(Sender: TObject);
    procedure btnReestablecerClick(Sender: TObject);
    procedure cargarPanelDatos;
    function TodoCorrectoUbicacion(FormFichaUbicacion: TFormFichaUbicacion)
      : Boolean;
    procedure strngrdFilasMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    procedure strngrdFilasKeyPress(Sender: TObject; var Key: Char);
    procedure strngrdFilasSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure strngrdFilasDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure mniN51Click(Sender: TObject);
    procedure mniN52Click(Sender: TObject);
    procedure mniReestablecerfila1Click(Sender: TObject);
    procedure strngrdFilasSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure mniRecogidamanualClick(Sender: TObject);
    procedure mniRecogidaMaquinaClick(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    procedure cargarAlmacen;
  private
    FLastRow: Integer;
    FLastCol: Integer;
    FAllowEdit: Boolean;

    MapaUbicaciones: array of array of TUbicacion;
    CeldaSeleccionadaX, CeldaSeleccionadaY: Integer;
  public
  end;

implementation

{$R *.dfm}

procedure TFormFichaAlmacen.FormCreate(Sender: TObject);
begin
  FAllowEdit := False; // Inicialmente no permitimos edición
  cargarAlmacen;
end;

procedure TFormFichaAlmacen.StringGridDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  inherited;

  // Pintar fondo según si es pasillo o estantería
  if Length(MapaUbicaciones[ACol][ARow].lstHuecos) = 0 then
  begin
    StringGrid.Canvas.Brush.Color := clGreen; // Pasillo
    StringGrid.Canvas.Font.Color := clWhite;
    StringGrid.Canvas.FillRect(Rect);
    StringGrid.Canvas.TextOut(Rect.Left + 4, Rect.Top + 2, 'P');
  end
  else
  begin
    StringGrid.Canvas.Brush.Color := RGB(139, 69, 19); // Estantería
    StringGrid.Canvas.Font.Color := clWhite;
    StringGrid.Canvas.FillRect(Rect);
    StringGrid.Canvas.TextOut(Rect.Left + 4, Rect.Top + 2, 'E');
  end;

  // Dibujar recuadro si la celda está seleccionada
  if (ACol = CeldaSeleccionadaX) and (ARow = CeldaSeleccionadaY) then
  begin
    StringGrid.Canvas.Pen.Color := clAqua;
    StringGrid.Canvas.Pen.Width := 2;
    StringGrid.Canvas.Brush.Style := bsClear;
    InflateRect(Rect, -1, -1); // Ajustar rect para que no se sobreponga
    StringGrid.Canvas.Rectangle(Rect);
  end;
end;

procedure TFormFichaAlmacen.StringGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
var
  col, row: Integer;
begin
  col := StringGrid.MouseCoord(x, y).x;
  row := StringGrid.MouseCoord(x, y).y;

  if (col >= 0) and (row >= 0) and (col < StringGrid.ColCount) and
    (row < StringGrid.RowCount) then
  begin
    CeldaSeleccionadaX := col;
    CeldaSeleccionadaY := row;
    stat1.Panels[1].Text := IntToStr(CeldaSeleccionadaX + 1) + ', ' + IntToStr
      (CeldaSeleccionadaY + 1);

    if Length(MapaUbicaciones[col][row].lstHuecos) = 0 then
    begin
      stat1.Panels[2].Text := 'Pasillo';
      pnlDatos.Visible := False;
      FAllowEdit := False;
      strngrdFilas.Options := strngrdFilas.Options - [goEditing];
    end
    else
    begin
      stat1.Panels[2].Text := 'Estantería';
      cargarPanelDatos;
      FAllowEdit := False;
      strngrdFilas.Options := strngrdFilas.Options - [goEditing];
    end;

  end;
end;

procedure TFormFichaAlmacen.strngrdFilasDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  texto: string;
  textoWidth, textoHeight: Integer;
  hueco: THueco; // Tipo de datos de tus huecos, reemplázalo si es diferente
begin
  // Si la celda está activa y se va a editar, no pintes encima
  if (gdFocused in State) and (strngrdFilas.EditorMode) then
    Exit;

  // Obtener el hueco correspondiente a la celda actual
  hueco := MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY].lstHuecos
    [ARow];

  // Cambiar el color del fondo según el tipo de recogida
  with strngrdFilas.Canvas do
  begin
    // Cambiar color según el tipo de recogida
    if hueco.EsManual then
      Brush.Color := clFuchsia // Rosa si la recogida es manual
    else
      Brush.Color := clYellow; // Amarillo si es con máquina

    FillRect(Rect); // Pinta el fondo de la celda

    // Texto en la celda
    texto := strngrdFilas.Cells[ACol, ARow];
    textoWidth := TextWidth(texto);
    textoHeight := TextHeight(texto);

    // Dibujar el texto centrado en la celda
    TextOut(Rect.Left + ((Rect.Right - Rect.Left) - textoWidth) div 2,
      Rect.Top + ((Rect.Bottom - Rect.Top) - textoHeight) div 2, texto);
  end;
end;

procedure TFormFichaAlmacen.strngrdFilasKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not(Key in ['0' .. '9', #8]) then
    Key := #0;
end;

procedure TFormFichaAlmacen.strngrdFilasMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
var
  col, row: Integer;
begin
  strngrdFilas.MouseToCell(x, y, col, row);
  if (col >= 0) and (row >= 0) then
  begin
    strngrdFilas.col := col;
    strngrdFilas.row := row;

    // Activamos la edición solo cuando se hace clic
    FAllowEdit := True;

    // Si es el botón derecho, mostramos el menú contextual
    if Button = mbRight then
    begin
      // Mostrar menú contextual en la posición del cursor
      pmFilas.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
    end
    // Si es el botón izquierdo y estamos en la columna de capacidad (columna 0)
    else if (Button = mbLeft) and (col = 0) then
    begin
      // Entramos en modo edición directamente
      strngrdFilas.EditorMode := True;
    end;
  end;

  if MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY].lstHuecos
    [strngrdFilas.row].EsManual then
  begin
    mniRecogidamanual.Checked := True;
    mniRecogidaMaquina.Checked := False;
  end
  else
  begin
    mniRecogidamanual.Checked := False;
    mniRecogidaMaquina.Checked := True;
  end;
end;

procedure TFormFichaAlmacen.strngrdFilasSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
var
  valor: Integer;
begin
  // Guarda los valores modificados antes de cambiar la celda
  if (FLastCol = 0) and (FLastRow >= 0) and (FLastRow < strngrdFilas.RowCount)
    then
  begin
    valor := StrToIntDef(strngrdFilas.Cells[0, FLastRow], 0);
    if valor < 10 then
      MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY].lstHuecos
        [FLastRow].NCapacidad := 10
    else
      MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY].lstHuecos
        [FLastRow].NCapacidad := valor;
  end;

  // Actualizar la celda actual como nueva celda anterior
  FLastRow := ARow;
  FLastCol := ACol;

  // Solo permitimos editar cuando se ha hecho clic explícitamente
  // y solo en la columna 0 (capacidad)
  strngrdFilas.Options := strngrdFilas.Options - [goEditing];
  if FAllowEdit and (ACol = 0) then
  begin
    strngrdFilas.Options := strngrdFilas.Options + [goEditing];
    strngrdFilas.PopupMenu := pmFilas;
  end;

  // Después de usar FAllowEdit, lo reseteamos para la próxima vez
  FAllowEdit := False;
end;

procedure TFormFichaAlmacen.strngrdFilasSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
var
  n: Integer;
begin
  if TryStrToInt(Value, n) then
  begin
    if (n < 1) then
    begin
      strngrdFilas.Cells[ACol, ARow] := '1';
    end
    else if (n > 100) then
      strngrdFilas.Cells[ACol, ARow] := '100';

  end
  else
    strngrdFilas.Cells[ACol, ARow] := ''; // Borra si no es número

end;

procedure TFormFichaAlmacen.Insertarcolumna1Click(Sender: TObject);
begin
  inherited;
  StringGrid.ColCount := StringGrid.ColCount + 1;
  SetLength(MapaUbicaciones, StringGrid.ColCount, StringGrid.RowCount);
end;

procedure TFormFichaAlmacen.btnAceptarClick(Sender: TObject);
var
  contEstanterias, i, j, x: Integer;
begin
  inherited;
  pFIBTransaction.StartTransaction;
  try
    contEstanterias := 0;
    for i := 0 to Length(MapaUbicaciones) - 1 do
    begin
      for j := 0 to Length(MapaUbicaciones[i]) - 1 do
      begin
        if Length(MapaUbicaciones[i][j].lstHuecos) > 0 then
        begin
          // insertar
          contEstanterias := contEstanterias + 1;
          for x := 0 to Length(MapaUbicaciones[i][j].lstHuecos) - 1 do
          begin
            if (StrToIntDef(strngrdFilas.Cells[0, x], 0) = 0) or
              (StrToIntDef(strngrdFilas.Cells[0, x], 0) < 10) then
            begin
              MapaUbicaciones[i][j].lstHuecos[x].NCapacidad := 10;
            end
            else
            begin
              MapaUbicaciones[i][j].lstHuecos[x].NCapacidad := StrToIntDef
                (strngrdFilas.Cells[0, x], 0);
            end;

            pFIBQuery.Close;
            pFIBQuery.SQL.Text :=
              'INSERT INTO UBICACIONES (NPASILLO, NSECCION, NFILA, NCAPACIDAD, NTIPORECOGIDA, NPOSX, NPOSY) VALUES (:NPASILLO, :NSECCION, :NFILA, :NCAPACIDAD, :NTIPORECOGIDA, :NPOSX, :NPOSY)';

            pFIBQuery.ParamByName('NPASILLO').AsInteger := MapaUbicaciones[i][j]
              .NPasillo;
            pFIBQuery.ParamByName('NSECCION').AsInteger := MapaUbicaciones[i][j]
              .NSeccion;

            { ShowMessage('Pasillo: ' + IntToStr(MapaUbicaciones[i][j].NPasillo)
              + ' Seccion: ' + IntToStr(MapaUbicaciones[i][j].NSeccion)); }

            // Pos array+1 para que no salga el primero con cod 0
            MapaUbicaciones[i][j].lstHuecos[x].NFila := x + 1;
            pFIBQuery.ParamByName('NFILA').AsInteger := MapaUbicaciones[i][j]
              .lstHuecos[x].NFila;

            pFIBQuery.ParamByName('NCAPACIDAD').AsInteger := MapaUbicaciones[i]
              [j].lstHuecos[x].NCapacidad;

            if MapaUbicaciones[i][j].lstHuecos[x].EsManual then
            begin
              pFIBQuery.ParamByName('NTIPORECOGIDA').AsInteger := 1;
            end
            else
              pFIBQuery.ParamByName('NTIPORECOGIDA').AsInteger := 2;

            pFIBQuery.ParamByName('NPOSX').AsInteger := i;
            pFIBQuery.ParamByName('NPOSY').AsInteger := j;

            pFIBQuery.ExecQuery;
          end;
        end
      end;
    end;
    if contEstanterias = 0 then
      ShowMessage('Almacén vacío');
    pFIBTransaction.Commit;
    btnAceptar.Enabled := False;
    btnReestablecer.Enabled := False;
    btnCancelar.Caption := 'Salir';
  except
    on E: Exception do
    begin
      pFIBTransaction.Rollback;
      ShowMessage('Error al guardar los datos: ' + E.Message);
    end;
  end;
end;

procedure TFormFichaAlmacen.btnReestablecerClick(Sender: TObject);
var
  x, y: Integer;
begin
  inherited;
  for x := 0 to StringGrid.ColCount - 1 do
    for y := 0 to StringGrid.RowCount - 1 do
    begin
      MapaUbicaciones[x][y].lstHuecos := nil; // Reset a pasillo
    end;
  pnlDatos.Visible := False;
  StringGrid.Invalidate;
end;

procedure TFormFichaAlmacen.cargarAlmacen;
var
  x, y, i: Integer;
  MaxX, MaxY: Integer;

begin
  // Actualizar

  pFIBQuery.Close;
  pFIBTransaction.StartTransaction;
  pFIBQuery.SQL.Text := 'SELECT MAX(NPOSX), MAX(NPOSY) FROM UBICACIONES';
  pFIBQuery.ExecQuery;
  MaxX := pFIBQuery.Fields[0].AsInteger + 1;
  MaxY := pFIBQuery.Fields[1].AsInteger + 1;
  pFIBTransaction.Commit;

  // ShowMessage('X: ' + IntToStr(MaxX) + ' Y: ' + IntToStr(MaxY));
  if (MaxX = 1) and (MaxY = 1) then
  begin
    MaxX := 4;
    MaxY := 4;
  end;

  StringGrid.ColCount := MaxX;
  StringGrid.RowCount := MaxY;

  SetLength(MapaUbicaciones, MaxX, MaxY);

  pFIBTransaction.StartTransaction;
  for x := 0 to MaxX - 1 do
    for y := 0 to MaxY - 1 do
    begin
      pFIBQuery.Close;
      pFIBQuery.SQL.Text :=
        'SELECT MAX(NFILA), NPASILLO, NSECCION FROM UBICACIONES WHERE NPOSX = :x AND NPOSY = :y GROUP BY NPASILLO, NSECCION';
      pFIBQuery.ParamByName('x').AsInteger := x;
      pFIBQuery.ParamByName('y').AsInteger := y;
      pFIBQuery.ExecQuery;

      if not pFIBQuery.Eof and not pFIBQuery.Fields[0].IsNull then
      begin
        MapaUbicaciones[x][y].NPasillo := pFIBQuery.Fields[1].AsInteger;
        MapaUbicaciones[x][y].NSeccion := pFIBQuery.Fields[2].AsInteger;
        SetLength(MapaUbicaciones[x][y].lstHuecos,
          pFIBQuery.Fields[0].AsInteger);
      end
      else
      begin
        MapaUbicaciones[x][y].NPasillo := x + 1;
        MapaUbicaciones[x][y].NSeccion := y + 1;
        MapaUbicaciones[x][y].lstHuecos := nil;
      end;
    end;

  pFIBTransaction.Commit;

  pFIBTransaction.StartTransaction;
  pFIBQuery.Close;
  pFIBQuery.SQL.Text :=
    'SELECT NPOSX, NPOSY, NFILA, NCAPACIDAD,NTIPORECOGIDA FROM UBICACIONES';
  pFIBQuery.ExecQuery;

  while not pFIBQuery.Eof do
  begin
    x := pFIBQuery.FieldByName('NPOSX').AsInteger;
    y := pFIBQuery.FieldByName('NPOSY').AsInteger;
    i := pFIBQuery.FieldByName('NFILA').AsInteger;

    // Asigna solo si está dentro del rango y ya inicializado
    if (x < MaxX) and (y < MaxY) and (Assigned(MapaUbicaciones[x][y].lstHuecos)
      ) and (i > 0) and (i <= Length(MapaUbicaciones[x][y].lstHuecos)) then
    begin
      MapaUbicaciones[x][y].lstHuecos[i - 1].NFila := i - 1;
      MapaUbicaciones[x][y].lstHuecos[i - 1].NCapacidad := pFIBQuery.FieldByName
        ('NCAPACIDAD').AsInteger;
      if pFIBQuery.FieldByName('NTIPORECOGIDA').AsInteger = 1 then
      begin
        MapaUbicaciones[x][y].lstHuecos[i - 1].EsManual := True;
      end
      else
        MapaUbicaciones[x][y].lstHuecos[i - 1].EsManual := False;

    end;

    pFIBQuery.Next;
  end;

  // Crear
  { SetLength(MapaUbicaciones, StringGrid.ColCount, StringGrid.RowCount);

    for x := 0 to StringGrid.ColCount - 1 do
    for y := 0 to StringGrid.RowCount - 1 do
    begin
    MapaUbicaciones[x][y].NPasillo := x + 1;
    MapaUbicaciones[x][y].NSeccion := y + 1;
    MapaUbicaciones[x][y].lstHuecos := nil;
    end; }
end;

procedure TFormFichaAlmacen.cargarPanelDatos;
var
  i: Integer;
begin
  pnlDatos.Visible := True;
  lblNPasillo.Caption := IntToStr(MapaUbicaciones[CeldaSeleccionadaX]
      [CeldaSeleccionadaY].NPasillo);
  lblNSeccion.Caption := IntToStr(MapaUbicaciones[CeldaSeleccionadaX]
      [CeldaSeleccionadaY].NSeccion);
  lblNFilas.Caption := IntToStr(Length(MapaUbicaciones[CeldaSeleccionadaX]
        [CeldaSeleccionadaY].lstHuecos));
  strngrdFilas.ColCount := 1;
  strngrdFilas.RowCount := Length(MapaUbicaciones[CeldaSeleccionadaX]
      [CeldaSeleccionadaY].lstHuecos);

  if Length(MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY].lstHuecos)
    > 0 then
  begin
    i := 0;
    for i := 0 to Length(MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY]
        .lstHuecos) - 1 do
    begin
      strngrdFilas.Cells[0, i] := IntToStr
        (MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY].lstHuecos[i]
          .NCapacidad)
    end;
  end;

end;

procedure TFormFichaAlmacen.Eliminarcolumna1Click(Sender: TObject);
begin
  inherited;
  StringGrid.ColCount := StringGrid.ColCount - 1;
  SetLength(MapaUbicaciones, StringGrid.ColCount, StringGrid.RowCount);
end;

procedure TFormFichaAlmacen.Insertarfila1Click(Sender: TObject);
begin
  inherited;
  StringGrid.RowCount := StringGrid.RowCount + 1;
  SetLength(MapaUbicaciones, StringGrid.ColCount, StringGrid.RowCount);
end;

procedure TFormFichaAlmacen.Eliminarfila1Click(Sender: TObject);
begin
  inherited;
  StringGrid.RowCount := StringGrid.RowCount - 1;
  SetLength(MapaUbicaciones, StringGrid.ColCount, StringGrid.RowCount);
end;

procedure TFormFichaAlmacen.MarcarComoEstanteriaClick(Sender: TObject);
var
  FormFichaUbicacion: TFormFichaUbicacion;
  UbicacionEstanteria: TUbicacion;
begin
  inherited;

  FormFichaUbicacion := TFormFichaUbicacion.Create(nil);

  FormFichaUbicacion.ShowModal;

  if (CeldaSeleccionadaX >= 0) and (CeldaSeleccionadaY >= 0) then
  begin
    if FormFichaUbicacion.aceptando = True then
    begin
      if TodoCorrectoUbicacion(FormFichaUbicacion) then
      begin
        UbicacionEstanteria.NPasillo := StrToInt
          (FormFichaUbicacion.edtPasillo.Text);
        UbicacionEstanteria.NSeccion := StrToInt
          (FormFichaUbicacion.edtSeccion.Text);
        SetLength(UbicacionEstanteria.lstHuecos,
          StrToInt(FormFichaUbicacion.edtFilas.Text));
        MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY] :=
          UbicacionEstanteria;
        stat1.Panels[2].Text := 'Estantería';
        StringGrid.Invalidate;
        cargarPanelDatos;
        FormFichaUbicacion.Close;
        FormFichaUbicacion.Free;
      end;
    end;
  end;
end;

function TFormFichaAlmacen.TodoCorrectoUbicacion
  (FormFichaUbicacion: TFormFichaUbicacion): Boolean;
var
  resultado: Boolean;
begin
  resultado := True;
  if (FormFichaUbicacion.edtPasillo.Text = '') or
    (FormFichaUbicacion.edtPasillo.Text = '0') then
  begin
    // ShowMessage('El nº de pasillo tiene que ser mínimo mayor que 0');
    resultado := False;
  end;
  if (FormFichaUbicacion.edtSeccion.Text = '') or
    (FormFichaUbicacion.edtSeccion.Text = '0') then
  begin
    // ShowMessage('El nº de sección tiene que ser mínimo mayor que 0');
    resultado := False;
  end;
  if (FormFichaUbicacion.edtFilas.Text = '') or
    (FormFichaUbicacion.edtFilas.Text = '0') then
  begin
    // ShowMessage('El nº de filas tiene que ser mínimo mayor que 0');
    resultado := False;
  end;
  if not resultado then
    ShowMessage(
      'Corrija los campos, tienen que ser numéricos, no pueden ser nulos');

  Result := resultado;

end;

procedure TFormFichaAlmacen.MarcarComoPasilloClick(Sender: TObject);
begin
  inherited;
  if (CeldaSeleccionadaX >= 0) and (CeldaSeleccionadaY >= 0) then
  begin
    MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY].lstHuecos := nil;

    stat1.Panels[2].Text := 'Pasillo';
    StringGrid.Invalidate;
  end;
end;

procedure TFormFichaAlmacen.mniN51Click(Sender: TObject);
var
  texto: string;
  col, row: Integer;
begin
  inherited;
  col := strngrdFilas.col;
  row := strngrdFilas.row;

  if strngrdFilas.Cells[col, row] = '' then
  begin
    texto := '1';
  end
  else
    texto := IntToStr(StrToInt(strngrdFilas.Cells[col, row]) - 5);

  // Cambiar el texto de la celda
  strngrdFilas.Cells[col, row] := texto;
end;

procedure TFormFichaAlmacen.mniN52Click(Sender: TObject);
var
  texto: string;
  col, row: Integer;
begin
  inherited;
  col := strngrdFilas.col;
  row := strngrdFilas.row;

  if strngrdFilas.Cells[col, row] = '' then
  begin
    texto := '5'
  end
  else
    texto := IntToStr(StrToInt(strngrdFilas.Cells[col, row]) + 5);

  // Cambiar el texto de la celda
  strngrdFilas.Cells[col, row] := texto;
end;

procedure TFormFichaAlmacen.mniRecogidamanualClick(Sender: TObject);
begin
  inherited;
  mniRecogidamanual.Checked := True;
  mniRecogidaMaquina.Checked := False;
  MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY].lstHuecos
    [strngrdFilas.row].EsManual := True;

end;

procedure TFormFichaAlmacen.mniRecogidaMaquinaClick(Sender: TObject);
begin
  inherited;
  mniRecogidamanual.Checked := False;
  mniRecogidaMaquina.Checked := True;
  MapaUbicaciones[CeldaSeleccionadaX][CeldaSeleccionadaY].lstHuecos
    [strngrdFilas.row].EsManual := False;

end;

procedure TFormFichaAlmacen.mniReestablecerfila1Click(Sender: TObject);
var
  texto: string;
  col, row: Integer;
  textoWidth, textoHeight: Integer;
begin
  inherited;
  col := strngrdFilas.col;
  row := strngrdFilas.row;

  // Establecemos el texto a '1'
  texto := '1';

  // Cambiar el texto de la celda
  strngrdFilas.Cells[col, row] := texto;

  // Calcular el ancho y altura del texto para centrarlo
  textoWidth := strngrdFilas.Canvas.TextWidth(texto);
  textoHeight := strngrdFilas.Canvas.TextHeight(texto);

  // Dibujar el texto centrado en la celda
  strngrdFilas.Canvas.TextOut((strngrdFilas.CellRect(col,
        row).Left + ((strngrdFilas.CellRect(col,
            row).Right - strngrdFilas.CellRect(col, row).Left) - textoWidth)
        div 2), (strngrdFilas.CellRect(col,
        row).Top + ((strngrdFilas.CellRect(col,
            row).Bottom - strngrdFilas.CellRect(col, row).Top) - textoHeight)
        div 2), texto);
end;

end.
