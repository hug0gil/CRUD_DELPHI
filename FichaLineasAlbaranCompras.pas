unit FichaLineasAlbaranCompras;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FichaBase, StdCtrls, ExtCtrls, FIBQuery, pFIBQuery, FIBDatabase,
  pFIBDatabase, Mask, Types;

type
  TFormFichaLineasAlbaranCompras = class(TFormFichaBase)
    pnlFila2: TPanel;
    pnlPrecio: TPanel;
    lblPrecio: TLabel;
    pnlOrden: TPanel;
    lbllOrden: TLabel;
    edtOrden: TEdit;
    pnlUnidadesPeso: TPanel;
    lblUnidadesPeso: TLabel;
    pnlCodArticulo: TPanel;
    lbllCodArticulo: TLabel;
    pnlCajasPiezas: TPanel;
    lblCajasPiezas: TLabel;
    pnlIVA: TPanel;
    lblIVA: TLabel;
    edtIVA: TEdit;
    pnlRecargo: TPanel;
    lblRecargo: TLabel;
    edtRecargo: TEdit;
    pnlSubTotal: TPanel;
    lblSubTotal: TLabel;
    edtSubTotal: TEdit;
    cbbCodArticulo: TComboBox;
    medtPrecio: TMaskEdit;
    medtCajasPiezas: TMaskEdit;
    medtUnidadesPeso: TMaskEdit;
    lblNombreProducto: TLabel;
    edtFactorConversion: TEdit;
    lblDFactorConversion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure getCodArticulos;
    procedure cbbCodArticuloChange(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    procedure calcularSubtotal();
    procedure calcularSubtotalGranel();
    procedure getFactorConversion;
    function TodoCorrecto: Boolean;

    procedure medtUnidadesPesoExit(Sender: TObject);
    procedure medtCajasPiezasExit(Sender: TObject);
    procedure medtPrecioExit(Sender: TObject);
    procedure medtUnidadesPesoKeyPress(Sender: TObject; var Key: Char);
    procedure medtCajasPiezasKeyPress(Sender: TObject; var Key: Char);
    procedure medtPrecioKeyPress(Sender: TObject; var Key: Char);
    function getNombreArticulo: String;
    constructor Create(AOwner: TComponent; Modo: Integer); overload;
    procedure FormActivate(Sender: TObject);
  private
    CambiandoValor: Boolean;

  public
    { Public declarations }
    FactorConversion: Integer;
    UnidadCaja: Integer;
    contCbb: Integer;
    mode: Integer;
    codArticulo: string;
  end;

implementation

{$R *.dfm}

constructor TFormFichaLineasAlbaranCompras.Create(AOwner: TComponent;
  Modo: Integer);
begin
  inherited Create(AOwner);
  mode := Modo;
end;

procedure TFormFichaLineasAlbaranCompras.FormActivate(Sender: TObject);
begin
  inherited;
  if mode <> 0 then
    getFactorConversion;
end;

procedure TFormFichaLineasAlbaranCompras.FormCreate(Sender: TObject);
begin

  if mode = 0 then
    lblNombreProducto.Visible := False;
  if not pFIBTransaction.InTransaction then
    pFIBTransaction.StartTransaction;
  getCodArticulos;
  contCbb := 0;
end;

procedure TFormFichaLineasAlbaranCompras.btnAceptarClick(Sender: TObject);
begin
  if TodoCorrecto then
  begin
    try
      if not pFIBTransaction.InTransaction then
        pFIBTransaction.StartTransaction;
      if FactorConversion = 0 then
      begin
        if ((Trim(medtUnidadesPeso.Text) = '') or (Trim(medtUnidadesPeso.Text)
              = '0')) or ((Trim(medtCajasPiezas.Text) = '') or
            (Trim(medtCajasPiezas.Text) = '0')) then
        begin
          ShowMessage(
            'El valor unidades o el valor de peso tiene que ser mayor que 0');
          Exit;
        end
        else
          calcularSubtotalGranel;
      end
      else
        calcularSubtotal;

      case mode of
        0: // Insertar
          begin
            pFIBQuery.SQL.Text :=
              'INSERT INTO LINEAS_ALB_C (NCOD_ALBARAN, CCOD_ARTICULO, NCANTIDAD1, NCANTIDAD2, NPRECIO, NORDEN, NIVA, NRECARGO,NSUBTOTAL) '
              + 'VALUES (:NCOD_ALBARAN, :CCOD_ARTICULO, :NCANTIDAD1, :NCANTIDAD2, :NPRECIO, :NORDEN, :NIVA, :NRECARGO,:NSUBTOTAL)';
            pFIBQuery.ParamByName('NCOD_ALBARAN').AsInteger := StrToInt
              (edtCodigo.Text);
            pFIBQuery.ParamByName('CCOD_ARTICULO').AsString :=
              cbbCodArticulo.Text;

            pFIBQuery.ParamByName('NCANTIDAD1').AsFloat := StrToFloat
              (medtUnidadesPeso.Text);

            pFIBQuery.ParamByName('NCANTIDAD2').AsFloat := StrToFloat
              (medtCajasPiezas.Text);

            if FactorConversion > 1 then
            begin
              pFIBQuery.ParamByName('NPRECIO').AsFloat := StrToFloat
                (medtPrecio.Text) / FactorConversion;
            end
            else
              pFIBQuery.ParamByName('NPRECIO').AsFloat := StrToFloat
                (medtPrecio.Text);

            pFIBQuery.ParamByName('NORDEN').AsInteger := StrToInt
              (edtOrden.Text);
            pFIBQuery.ParamByName('NIVA').AsFloat := StrToFloat(edtIVA.Text);
            if not pnlRecargo.Enabled then
              edtRecargo.Text := '0';
            pFIBQuery.ParamByName('NSUBTOTAL').AsFloat := StrToFloat
              (edtSubTotal.Text);
            pFIBQuery.ParamByName('NRECARGO').AsFloat := StrToFloat
              (edtRecargo.Text);
            pFIBQuery.ExecQuery;
            pFIBTransaction.Commit;
            Self.Close;
          end;
        1: // Ver
          begin
            Self.Close;
          end;
        2: // Actualizar
          begin
            pFIBQuery.SQL.Text :=
              'UPDATE LINEAS_ALB_C SET CCOD_ARTICULO = :CCOD_ARTICULO, NCANTIDAD1 = :NCANTIDAD1, NCANTIDAD2 = :NCANTIDAD2, NPRECIO = :NPRECIO, NIVA = :NIVA, NRECARGO = :NRECARGO, NSUBTOTAL = :NSUBTOTAL WHERE NCOD_ALBARAN = :NCOD_ALBARAN AND NORDEN = :NORDEN';
            pFIBQuery.ParamByName('NCOD_ALBARAN').AsInteger := StrToInt
              (edtCodigo.Text);
            pFIBQuery.ParamByName('CCOD_ARTICULO').AsString :=
              cbbCodArticulo.Text;

            pFIBQuery.ParamByName('NCANTIDAD1').AsFloat := StrToFloat
              (medtUnidadesPeso.Text);

            pFIBQuery.ParamByName('NCANTIDAD2').AsFloat := StrToFloat
              (medtCajasPiezas.Text);

            if FactorConversion > 1 then
            begin
              pFIBQuery.ParamByName('NPRECIO').AsFloat := StrToFloat
                (medtPrecio.Text) / FactorConversion;
            end
            else
              pFIBQuery.ParamByName('NPRECIO').AsFloat := StrToFloat
                (medtPrecio.Text);

            pFIBQuery.ParamByName('NORDEN').AsInteger := StrToInt
              (edtOrden.Text);
            pFIBQuery.ParamByName('NIVA').AsFloat := StrToFloat(edtIVA.Text);
            if not pnlRecargo.Enabled then
              edtRecargo.Text := '0';
            pFIBQuery.ParamByName('NSUBTOTAL').AsFloat := StrToFloat
              (edtSubTotal.Text);
            pFIBQuery.ParamByName('NRECARGO').AsFloat := StrToFloat
              (edtRecargo.Text);
            pFIBQuery.ExecQuery;
            pFIBTransaction.Commit;
            Self.Close;
          end;
      end;
    except
      on E: Exception do
      begin
        if pFIBTransaction.InTransaction then
          pFIBTransaction.Rollback;
        ShowMessage('Error en la operación: ' + E.Message);
      end;
    end;
  end;
end;

function TFormFichaLineasAlbaranCompras.TodoCorrecto: Boolean;
var
  Precio: Double;
begin
  Result := False;
  if cbbCodArticulo.ItemIndex = -1 then
  begin
    ShowMessage('Debe seleccionar un artículo.');
    Exit;
  end;
  if Trim(medtPrecio.Text) = '' then
  begin
    ShowMessage('El precio no puede estar vacío.');
    Exit;
  end;
  if not TryStrToFloat(medtPrecio.Text, Precio) then
  begin
    ShowMessage('El precio debe ser un número válido.');
    Exit;
  end;

  // Asegurarse de que los campos vacíos se traten como '0'
  if medtCajasPiezas.Text = '' then
    medtCajasPiezas.Text := '0';
  if medtUnidadesPeso.Text = '' then
    medtUnidadesPeso.Text := '0';

  if FactorConversion = 0 then
  begin
    if medtCajasPiezas.Text = '0' then
      medtCajasPiezas.Text := '1';

    if medtUnidadesPeso.Text = '0' then
      medtUnidadesPeso.Text := '1';
  end
  else if FactorConversion = 1 then
  begin
    if UnidadCaja = 1 then
    begin
      if medtUnidadesPeso.Text = '0' then
      begin
        medtUnidadesPeso.Text := '1';
        medtCajasPiezas.Text := '0';
      end;
    end
    else if (medtCajasPiezas.Text = '0') and (UnidadCaja > 1) then
    begin
      medtCajasPiezas.Text := '1';
      medtUnidadesPeso.Text := '0';
    end;
  end
  else
  begin
    if medtCajasPiezas.Text = '0' then
      medtCajasPiezas.Text := '1';

    if medtUnidadesPeso.Text = '0' then
      medtUnidadesPeso.Text := '1';
  end;

  Result := True;
end;

procedure TFormFichaLineasAlbaranCompras.calcularSubtotal;
begin

  case FactorConversion of
    1:
      begin
        if UnidadCaja = 1 then
        begin

          lblSubTotal.Caption := 'Subtotal €/Ud';
          edtSubTotal.Text := FloatToStr(StrToFloat(medtUnidadesPeso.Text)
              * StrToFloat(medtPrecio.Text));
        end
        else if UnidadCaja > 1 then
        begin

          lblSubTotal.Caption := 'Subtotal €/Caja';
          edtSubTotal.Text := FloatToStr(StrToFloat(medtCajasPiezas.Text)
              * StrToFloat(medtPrecio.Text));
        end;
      end;
  end;
  if FactorConversion > 1 then
  begin

    lblSubTotal.Caption := 'Subtotal €/Caja|Ud';
    edtSubTotal.Text := FloatToStr
      (((StrToFloat(medtCajasPiezas.Text) * FactorConversion) + StrToFloat
          (medtUnidadesPeso.Text)) * StrToFloat(medtPrecio.Text));
  end;
end;

procedure TFormFichaLineasAlbaranCompras.calcularSubtotalGranel;
begin

  begin
    edtSubTotal.Text := FloatToStr(StrToFloat(Trim(medtUnidadesPeso.Text))
        * StrToFloat(Trim(medtCajasPiezas.Text)) * StrToFloat(medtPrecio.Text)
      );
  end
end;

procedure TFormFichaLineasAlbaranCompras.cbbCodArticuloChange(Sender: TObject);
begin

  lblNombreProducto.Caption := getNombreArticulo;
  try
    if mode <> 1 then
    begin
      pFIBQuery.Close;
      if not pFIBTransaction.InTransaction then
        pFIBTransaction.StartTransaction;
      pFIBQuery.SQL.Text :=
        'SELECT TI.NIVA, TI.NRECARGO_EQ, A.NPRECIO ' + 'FROM ARTICULOS A ' +
        'JOIN TIPOS_IVA TI ON A.NCOD_IVA = TI.NCODIGO ' +
        'WHERE A.CCODIGO = :CCODIGO';
      pFIBQuery.ParamByName('CCODIGO').AsString := cbbCodArticulo.Text;
      pFIBQuery.ExecQuery;
      if not pFIBQuery.Eof then
      begin
        edtIVA.Text := pFIBQuery.FieldByName('NIVA').AsString;
        edtRecargo.Text := pFIBQuery.FieldByName('NRECARGO_EQ').AsString;
        if FactorConversion > 1 then
        begin
          medtPrecio.Text := FloatToStr
            (pFIBQuery.FieldByName('NPRECIO')
              .AsFloat / FactorConversion);
        end
        else
          medtPrecio.Text := pFIBQuery.FieldByName('NPRECIO').AsString;
      end;
      if contCbb = 0 then
      begin
        medtCajasPiezas.Enabled := True;
        medtUnidadesPeso.Enabled := True;
      end;
      getFactorConversion;
      contCbb := 1;
      pFIBQuery.Close;
      if pFIBTransaction.InTransaction then
        pFIBTransaction.Commit;

      { ShowMessage('FactorConversion: ' + IntToStr(FactorConversion)
        + ' UnidadCaja: ' + IntToStr(UnidadCaja)); }

      if (FactorConversion > 1) or (UnidadCaja = 1) then
      begin
        lblPrecio.Caption := 'Precio €/Ud';
      end
      else if FactorConversion = 1 then
      begin
        lblPrecio.Caption := 'Precio €/Caja';
      end
      else if FactorConversion = 0 then
        lblPrecio.Caption := 'Precio €/Kg';

      edtFactorConversion.Text := IntToStr(FactorConversion);
    end;
  except
    on E: Exception do
    begin
      if pFIBTransaction.InTransaction then
        pFIBTransaction.Rollback;
      ShowMessage('Error al cargar IVA y recargo: ' + E.Message);
    end;
  end;
end;

procedure TFormFichaLineasAlbaranCompras.getCodArticulos;
begin
  try
    pFIBQuery.Close;
    if not pFIBTransaction.InTransaction then
      pFIBTransaction.StartTransaction;
    pFIBQuery.SQL.Text := 'SELECT CCODIGO FROM ARTICULOS ORDER BY CCODIGO';
    pFIBQuery.ExecQuery;
    cbbCodArticulo.Items.Clear;
    while not pFIBQuery.Eof do
    begin
      cbbCodArticulo.Items.Add(pFIBQuery.FieldByName('CCODIGO').AsString);
      pFIBQuery.Next;
    end;
    pFIBQuery.Close;
    if pFIBTransaction.InTransaction then
      pFIBTransaction.Commit;
  except
    on E: Exception do
    begin
      if pFIBTransaction.InTransaction then
        pFIBTransaction.Rollback;
      ShowMessage('Error al obtener los códigos de artículos: ' + E.Message);
    end;
  end;
end;

procedure TFormFichaLineasAlbaranCompras.getFactorConversion;
begin
  try
    pFIBQuery.Close;
    if not pFIBTransaction.InTransaction then
      pFIBTransaction.StartTransaction;
    pFIBQuery.SQL.Text :=
      'SELECT A.NFACTCONV, A.NUNICAJ FROM ARTICULOS A WHERE A.CCODIGO = :COD_ARTICULO';
    pFIBQuery.ParamByName('COD_ARTICULO').AsString := cbbCodArticulo.Text;
    pFIBQuery.ExecQuery;

    if not pFIBQuery.Eof then
    begin
      FactorConversion := pFIBQuery.FieldByName('NFACTCONV').AsInteger;
      UnidadCaja := pFIBQuery.FieldByName('NUNICAJ').AsInteger;
      edtFactorConversion.Text := IntToStr(FactorConversion);
      case FactorConversion of
        0:
          begin
            pnlUnidadesPeso.Enabled := True;
            medtUnidadesPeso.Enabled := True;
            pnlCajasPiezas.Enabled := True;
            medtCajasPiezas.Enabled := True;
            lblCajasPiezas.Caption := 'Piezas';
            lblUnidadesPeso.Caption := 'Peso/Kg';
          end;
        1:
          begin
            if UnidadCaja = 1 then
            begin

              pnlUnidadesPeso.Enabled := True;
              medtUnidadesPeso.Enabled := True;
              pnlCajasPiezas.Enabled := False;
              medtCajasPiezas.Enabled := False;
              medtCajasPiezas.Text := '';
              lblUnidadesPeso.Caption := 'Unidades';
            end
            else
            begin

              pnlCajasPiezas.Enabled := True;
              medtCajasPiezas.Enabled := True;
              pnlUnidadesPeso.Enabled := False;
              medtUnidadesPeso.Enabled := False;
              medtUnidadesPeso.Text := '';
              lblCajasPiezas.Caption := 'Cajas';
            end;
          end;
      else
        if FactorConversion > 1 then
        begin
          pnlCajasPiezas.Enabled := True;
          medtCajasPiezas.Enabled := True;
          pnlUnidadesPeso.Enabled := True;
          medtUnidadesPeso.Enabled := True;
          lblCajasPiezas.Caption := 'Cajas';
          lblUnidadesPeso.Caption := 'Unidades';
        end;
      end;
    end
    else
    begin
      ShowMessage('No se encontró el artículo.');
    end;

    { ShowMessage('El factor de conversión actual es: ' + IntToStr
      (FactorConversion)); }
    pFIBQuery.Close;
    if pFIBTransaction.InTransaction then
      pFIBTransaction.Commit;
  except
    on E: Exception do
    begin
      if pFIBTransaction.InTransaction then
        pFIBTransaction.Rollback;
      ShowMessage('Error al obtener el factor de conversión: ' + E.Message);
    end;
  end;
end;

function TFormFichaLineasAlbaranCompras.getNombreArticulo: String;
begin
  Result := '';
  lblNombreProducto.Visible := True;
  try
    pFIBQuery.Close;
    if not pFIBTransaction.InTransaction then
      pFIBTransaction.StartTransaction;

    pFIBQuery.SQL.Text :=
      'SELECT CNOMBRE FROM ARTICULOS WHERE CCODIGO = :CODIGO';
    pFIBQuery.ParamByName('CODIGO').AsString := cbbCodArticulo.Text;
    pFIBQuery.ExecQuery;

    if not pFIBQuery.Eof then
      Result := pFIBQuery.FieldByName('CNOMBRE').AsString;

    pFIBQuery.Close;

    if pFIBTransaction.InTransaction then
      pFIBTransaction.Commit;
  except
    on E: Exception do
    begin
      if pFIBTransaction.InTransaction then
        pFIBTransaction.Rollback;
      ShowMessage('Error al obtener el nombre del artículo: ' + E.Message);
    end;
  end;
end;

procedure TFormFichaLineasAlbaranCompras.medtUnidadesPesoExit(Sender: TObject);

begin
  inherited;
  if (FactorConversion = 0) then
    calcularSubtotalGranel()
  else
    calcularSubtotal();
end;

procedure TFormFichaLineasAlbaranCompras.medtCajasPiezasExit(Sender: TObject);

begin
  inherited;
  if (FactorConversion = 0) then
    calcularSubtotalGranel()
  else
    calcularSubtotal();
end;

procedure TFormFichaLineasAlbaranCompras.medtPrecioExit(Sender: TObject);
begin
  inherited;

  // Si el campo está vacío, establecer el valor a 0
  if not(Trim(medtPrecio.Text) = '') then
    // Convertir a número para asegurarse de que el valor es válido
    try
      StrToFloat(medtPrecio.Text); // Asegúrate de que el texto es un número válido
    except
      on E: EConvertError do
      begin
        ShowMessage('El valor ingresado no es válido. Se ha establecido a 0.');
        medtPrecio.Text := '0';
      end;
    end;

  if FactorConversion = 0 then
    calcularSubtotalGranel()
  else
    calcularSubtotal();
end;



// KEYPRESSED

procedure TFormFichaLineasAlbaranCompras.medtPrecioKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Solo permitir números, coma y la tecla de retroceso
  if not(Key in ['0' .. '9', #8, ',']) then
  begin
    Key := #0; // Si no es un número o una coma, cancelamos la tecla
    ShowMessage('Solo se permiten números y una coma decimal.');
  end;

  // Evitar más de una coma decimal
  if (Key = ',') and (Pos(',', medtPrecio.Text) > 0) then
  begin
    Key := #0; // Si ya tiene una coma, cancelar el ingreso de la siguiente coma
    ShowMessage('Ya existe una coma decimal.');
  end;
end;

procedure TFormFichaLineasAlbaranCompras.medtUnidadesPesoKeyPress
  (Sender: TObject; var Key: Char);
begin
  // Solo permitir números, coma y la tecla de retroceso
  if not(Key in ['0' .. '9', #8, ',']) then
  begin
    Key := #0; // Si no es un número o una coma, cancelamos la tecla
    ShowMessage('Solo se permiten números y una coma decimal.');
  end;

  // Evitar más de una coma decimal
  if (Key = ',') and (Pos(',', medtUnidadesPeso.Text) > 0) then
  begin
    Key := #0; // Si ya tiene una coma, cancelar el ingreso de la siguiente coma
  end;
end;

procedure TFormFichaLineasAlbaranCompras.medtCajasPiezasKeyPress
  (Sender: TObject; var Key: Char);
begin
  // Solo permitir números, coma y la tecla de retroceso
  if not(Key in ['0' .. '9', #8]) then
  begin
    Key := #0; // Si no es un número o una coma, cancelamos la tecla
    ShowMessage('Solo se permiten números enteros.');
  end;
end;

end.
