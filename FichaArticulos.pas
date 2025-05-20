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
    pnlCodigoIVA: TPanel;
    lblCodigoIVA: TLabel;
    cbbCodIVA: TComboBox;
    pnlCode: TPanel;
    lblCodigo: TLabel;
    edtCodigo: TMaskEdit;

    constructor Create(AOwner: TComponent; Modo: Integer); reintroduce;
      overload; virtual;
    function TodoCorrecto: Boolean;
    procedure btnAceptarClick(Sender: TObject);
    function getCodigoIVA(ObservacionIVA: String): Integer;

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

            pFIBQuery.SQL.Text :=
              'INSERT INTO ARTICULOS (CCODIGO, CNOMBRE, NSTOCK, NCOD_IVA) VALUES (:CCODIGO, :CNOMBRE, :NSTOCK, :NCOD_IVA)';
            pFIBQuery.ParamByName('CCODIGO').AsString := edtCodigo.Text;
            pFIBQuery.ParamByName('CNOMBRE').AsString := edtNombre.Text;
            pFIBQuery.ParamByName('NSTOCK').AsFloat := StrToFloat
              (edtStock.Text);
            pFIBQuery.ParamByName('NCOD_IVA').AsInteger := getCodigoIVA
              (cbbCodIVA.Text);

            pFIBQuery.ExecQuery;
            pFIBTransaction.Commit;

            Self.Close;
          end;
        1: // Actualizar
          begin
            pFIBQuery.Close; // Asegúrate de cerrar el query antes de cambiar su SQL.Text
            pFIBQuery.SQL.Text :=
              'UPDATE ARTICULOS SET CNOMBRE = :CNOMBRE, NSTOCK = :NSTOCK, NCOD_IVA = :NCOD_IVA WHERE CCODIGO = :OLD_CCODIGO';
            pFIBQuery.ParamByName('OLD_CCODIGO').AsString := edtCodigo.Text;
            pFIBQuery.ParamByName('CNOMBRE').AsString := edtNombre.Text;
            pFIBQuery.ParamByName('NSTOCK').AsFloat := StrToFloat
              (edtStock.Text);
            pFIBQuery.ParamByName('NCOD_IVA').AsInteger := getCodigoIVA
              (cbbCodIVA.Text);

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

function TFormFichaArticulos.TodoCorrecto: Boolean;
var
  pFIBQueryComprobar: TpFIBQuery;
  pFIBTransactionComprobar: TpFIBTransaction;
  IVA: Integer;
  Stock: Double;
begin
  Result := True;

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
