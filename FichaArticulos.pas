unit FichaArticulos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FichaBase, StdCtrls, ExtCtrls, ModuloDatos, FIBDatabase,
  pFIBDatabase,
  FIBQuery, pFIBQuery, Mask;

type
  TFormFichaArticulos = class(TFormFichaBase)
    pnlNombre: TPanel;
    lblNombre: TLabel;
    edtNombre: TEdit;
    pnlStock: TPanel;
    lblStock: TLabel;
    edtStock: TEdit;
    Timer: TTimer;
    PanelPrecio: TPanel;
    Label4: TLabel;
    EditPrecio: TEdit;
    PanelFila2: TPanel;
    PanelCodigo: TPanel;
    Label8: TLabel;
    edtCodigo: TMaskEdit;
    pnlCodigoIVA: TPanel;
    lblCodigoIVA: TLabel;
    cbbCodIVA: TComboBox;
    PanelProveedor: TPanel;
    Label3: TLabel;
    cbbProveedor: TComboBox;
    PanelFactor: TPanel;
    Label1: TLabel;
    EditFactor: TEdit;
    PanelUniCaja: TPanel;
    Label2: TLabel;
    EditlUniCaja: TEdit;
    PanelPrecioCompra: TPanel;
    Label5: TLabel;
    EditPrecioCompra: TEdit;

    constructor Create(AOwner: TComponent; Modo: Integer); reintroduce;
      overload; virtual;
    function TodoCorrecto: Boolean;
    procedure btnAceptarClick(Sender: TObject);
    function getCodigoIVA(ObservacionIVA: String): Integer;
    procedure EditFactorChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure EditlUniCajaKeyPress(Sender: TObject; var Key: Char);
    procedure EditlUniCajaExit(Sender: TObject);
    procedure EditlUniCajaChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    mode: Integer;
  end;

implementation

{$R *.dfm}

procedure TFormFichaArticulos.btnAceptarClick(Sender: TObject);

begin
  if TodoCorrecto then
  begin
    pFIBTransaction.StartTransaction;
    try
      // Procedemos con la inserción del cliente
      case mode of
        0: // Añadir
          begin
            pFIBQuery.SQL.Text := 'INSERT INTO ARTICULOS ' +
              '(CCODIGO, CNOMBRE, NSTOCK, NCOD_IVA, NFACTCONV, NUNICAJ, NPRECIO, NPRECIO_COMPRA, NCOD_PROV) ' + 'VALUES (:CCODIGO, :CNOMBRE, :NSTOCK, :NCOD_IVA, :NFACTCONV, :NUNICAJ, :NPRECIO, :NPRECIO_COMPRA, :NCOD_PROV)';

            pFIBQuery.ParamByName('CCODIGO').AsString := edtCodigo.Text;
            pFIBQuery.ParamByName('CNOMBRE').AsString := edtNombre.Text;
            pFIBQuery.ParamByName('NSTOCK').AsFloat := StrToFloat
              (edtStock.Text);
            pFIBQuery.ParamByName('NCOD_IVA').AsInteger := getCodigoIVA
              (cbbCodIVA.Text);
            pFIBQuery.ParamByName('NFACTCONV').AsInteger := StrToInt
              (EditFactor.Text);
            if PanelUniCaja.Visible = True then
            begin
              pFIBQuery.ParamByName('NUNICAJ').AsInteger := StrToInt
                (EditlUniCaja.Text);
            end
            else
              pFIBQuery.ParamByName('NUNICAJ').AsInteger := 0;

            pFIBQuery.ParamByName('NPRECIO').AsFloat := StrToFloat
              (EditPrecio.Text);
            pFIBQuery.ParamByName('NPRECIO_COMPRA').AsFloat := StrToFloat
              (EditPrecioCompra.Text);
            pFIBQuery.ParamByName('NCOD_PROV').AsInteger := StrToInt
              (cbbProveedor.Text);

            pFIBQuery.ExecQuery;
            pFIBTransaction.Commit;
            Self.Close;
          end;

        1: // Actualizar
          begin
            pFIBQuery.Close;
            pFIBQuery.SQL.Text := 'UPDATE ARTICULOS SET ' +
              'CNOMBRE = :CNOMBRE, ' + 'NSTOCK = :NSTOCK, ' +
              'NCOD_IVA = :NCOD_IVA, ' + 'NFACTCONV = :NFACTCONV, ' +
              'NUNICAJ = :NUNICAJ, ' + 'NPRECIO = :NPRECIO, ' +
              'NPRECIO_COMPRA = :NPRECIO_COMPRA, ' +
              'NCOD_PROV = :NCOD_PROV ' + 'WHERE CCODIGO = :OLD_CCODIGO';

            pFIBQuery.ParamByName('CNOMBRE').AsString := edtNombre.Text;
            pFIBQuery.ParamByName('NSTOCK').AsFloat := StrToFloat
              (edtStock.Text);
            pFIBQuery.ParamByName('NCOD_IVA').AsInteger := getCodigoIVA
              (cbbCodIVA.Text);
            pFIBQuery.ParamByName('NFACTCONV').AsInteger := StrToInt
              (EditFactor.Text);
            if PanelUniCaja.Visible = True then
            begin
              pFIBQuery.ParamByName('NUNICAJ').AsInteger := StrToInt
                (EditlUniCaja.Text);
            end
            else
              pFIBQuery.ParamByName('NUNICAJ').AsInteger := 0;
            pFIBQuery.ParamByName('NPRECIO').AsFloat := StrToFloat
              (EditPrecio.Text);
            pFIBQuery.ParamByName('NPRECIO_COMPRA').AsFloat := StrToFloat
              (EditPrecioCompra.Text);
            pFIBQuery.ParamByName('NCOD_PROV').AsInteger := StrToInt
              (cbbProveedor.Text);

            pFIBQuery.ExecQuery;
            pFIBTransaction.Commit;
            Self.Close;
          end;
        2: // Ver
          begin
            Self.Close;
          end;
      end;
    except
      on E: Exception do
      begin
        pFIBTransaction.Rollback;
        ShowMessage('Error: ' + E.Message);
      end;
    end;
  end;
end;

function TFormFichaArticulos.getCodigoIVA(ObservacionIVA: String): Integer;
var
  pFIBQueryIVA: TpFIBQuery;
  pFIBTransactionIVA: TpFIBTransaction;
begin
  Result := -1;

  pFIBTransactionIVA := TpFIBTransaction.Create(nil);
  pFIBTransactionIVA.DefaultDatabase := ModuloDatos.DataModuleBDD.pFIBDatabase;
  pFIBQueryIVA := TpFIBQuery.Create(nil);
  pFIBQueryIVA.DataBase := ModuloDatos.DataModuleBDD.pFIBDatabase;
  pFIBQueryIVA.Transaction := pFIBTransactionIVA;

  // Iniciar la transacción
  pFIBTransactionIVA.StartTransaction;

  pFIBQueryIVA.SQL.Text :=
    'SELECT NCODIGO FROM TIPOS_IVA WHERE CDESCRIPCION = :ObservacionIVA';
  pFIBQueryIVA.ParamByName('ObservacionIVA').AsString := ObservacionIVA;

  pFIBQueryIVA.ExecQuery;

  if not pFIBQueryIVA.Eof then
    Result := pFIBQueryIVA.FieldByName('NCODIGO').AsInteger;

  // Confirmar la transacción
  pFIBTransactionIVA.Commit;

  pFIBQueryIVA.Free;
  pFIBTransactionIVA.Free;

end;

constructor TFormFichaArticulos.Create(AOwner: TComponent; Modo: Integer);
begin
  inherited Create(AOwner);
  mode := Modo;
end;

procedure TFormFichaArticulos.EditFactorChange(Sender: TObject);
begin
  inherited;
  Timer.Enabled := False;
  Timer.Enabled := True;
end;

procedure TFormFichaArticulos.EditlUniCajaChange(Sender: TObject);
begin
  inherited;
  if EditlUniCaja.Text = '0' then
    EditlUniCaja.Text := '1';
end;

procedure TFormFichaArticulos.EditlUniCajaExit(Sender: TObject);
var
  Valor: Integer;
begin
  inherited;

  if TryStrToInt(EditlUniCaja.Text, Valor) then
  begin
    if Valor < 1 then
      EditlUniCaja.Text := '1'; // Reemplaza automáticamente con 1
  end
  else
    EditlUniCaja.Text := '1'; // Si no es un número válido, también pone 1
end;

procedure TFormFichaArticulos.EditlUniCajaKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;

  if not(Key in ['0' .. '9', #8]) then
    Key := #0;

end;

procedure TFormFichaArticulos.FormActivate(Sender: TObject);
begin
  inherited;
  cbbProveedor.Items.Clear;
  pFIBQuery.Close;
  pFIBQuery.SQL.Text := 'SELECT NCODIGO FROM PROVEEDORES';
  pFIBTransaction.StartTransaction;
  pFIBQuery.ExecQuery;

  while not pFIBQuery.Eof do
  begin
    cbbProveedor.Items.Add(pFIBQuery.Fields[0].AsString);
    pFIBQuery.Next;
  end;

  cbbProveedor.ItemIndex := 0;

  pFIBQuery.Close;
  pFIBTransaction.Commit;

  if mode <> 0 then
  begin
    if EditFactor.Text <> '0' then
    begin
      PanelUniCaja.Visible := True;
    end
    else
    begin
      PanelUniCaja.Visible := False;
    end;
  end;
end;

procedure TFormFichaArticulos.TimerTimer(Sender: TObject);
var
  Factor: Integer;
begin
  Timer.Enabled := False;

  if TryStrToInt(EditFactor.Text, Factor) and (Factor <> 0) then
  begin
    PanelUniCaja.Visible := True;
  end
  else
  begin
    PanelUniCaja.Visible := False;
  end;
end;

function TFormFichaArticulos.TodoCorrecto: Boolean;
var
  pFIBQueryComprobar: TpFIBQuery;
  pFIBTransactionComprobar: TpFIBTransaction;
  Stock, Precio, PrecioCompra: Double;
  IVA, FactorConv, UniCaja, Proveedor: Integer;
begin
  Result := True;

  // Verificar campos obligatorios de texto
  if (Trim(edtCodigo.Text) = '') or (Trim(edtNombre.Text) = '') or
    (Trim(cbbCodIVA.Text) = '') or (Trim(EditFactor.Text) = '') or
    (Trim(EditPrecio.Text) = '') or (Trim(EditPrecioCompra.Text) = '') or
    (Trim(cbbProveedor.Text) = '') then
  begin
    MessageDlg('Por favor, rellene todos los campos obligatorios.', mtError,
      [mbOK], 0);
    Result := False;
    Exit;
  end;

  // Verificar campos obligatorios
  if (Trim(edtNombre.Text) = '') or (Trim(cbbCodIVA.Text) = '') or
    (Trim(edtCodigo.Text) = '') then
  begin
    MessageDlg('Por favor, rellene todos los campos.', mtError, [mbOK], 0);
    Result := False;
    Exit;
  end;

  // Verificar que Stock sea un número válido y positivo
  if not TryStrToFloat(edtStock.Text, Stock) then
  begin
    MessageDlg('El valor del Stock debe ser un número válido.', mtError,
      [mbOK], 0);
    Result := False;
    Exit;
  end;

  if Stock < 0 then
  begin
    MessageDlg('El valor del Stock no puede ser negativo.', mtError, [mbOK], 0);
    Result := False;
    Exit;
  end;

  // Solo comprobar duplicado si estamos en modo "añadir"
  if (mode = 0) and (Length(Trim(edtCodigo.Text)) > 0) then
  begin
    pFIBTransactionComprobar := TpFIBTransaction.Create(nil);
    pFIBTransactionComprobar.DefaultDatabase :=
      ModuloDatos.DataModuleBDD.pFIBDatabase;

    pFIBQueryComprobar := TpFIBQuery.Create(nil);
    pFIBQueryComprobar.DataBase := ModuloDatos.DataModuleBDD.pFIBDatabase;
    pFIBQueryComprobar.Transaction := pFIBTransactionComprobar;

    try
      pFIBTransactionComprobar.StartTransaction;
      pFIBQueryComprobar.SQL.Text :=
        'SELECT COUNT(*) FROM ARTICULOS WHERE CCODIGO = :codigo';
      pFIBQueryComprobar.ParamByName('codigo').AsString := edtCodigo.Text;
      pFIBQueryComprobar.ExecQuery;

      if pFIBQueryComprobar.Fields[0].AsInteger >= 1 then
      begin
        MessageDlg('Ya existe un artículo con ese código.', mtError, [mbOK], 0);
        Result := False;
        Exit;
      end;

      pFIBTransactionComprobar.Commit;
    finally
      pFIBQueryComprobar.Free;
      pFIBTransactionComprobar.Free;
    end;
  end;
end;

end.
