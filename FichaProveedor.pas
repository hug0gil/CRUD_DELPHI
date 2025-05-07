unit FichaProveedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FichaBase, StdCtrls, ExtCtrls, ComCtrls, FIBQuery, pFIBQuery,
  FIBDatabase, pFIBDatabase, ModuloDatos;

type
  TFormFichaProveedor = class(TFormFichaBase)
    pnlNombre: TPanel;
    lblNombre: TLabel;
    edtNombre: TEdit;
    pnlFecha: TPanel;
    lblFecha: TLabel;
    DateTimePickerFecha: TDateTimePicker;
    pnlRegimen: TPanel;
    lblRegimen: TLabel;
    ComboBoxRegimen: TComboBox;
    procedure btnAceptarClick(Sender: TObject);
    constructor Create(AOwner: TComponent; Modo: Integer); overload; virtual;
    procedure btnCancelarClick(Sender: TObject);
    function TodoCorrecto(): Boolean;

  private
    { Private declarations }
  public
    { Public declarations }
    mode: Integer;
  end;

implementation

{$R *.dfm}

procedure TFormFichaProveedor.btnAceptarClick(Sender: TObject);
var
  regimen: string;
  codigoGenerado: Integer;
  codigoManual: Integer;
begin
  if ComboBoxRegimen.Text = 'Canarias' then
  begin
    regimen := 'G';
  end
  else if ComboBoxRegimen.Text = 'Extranjero' then
  begin
    regimen := 'X';
  end
  else
  begin
    regimen := Copy(ComboBoxRegimen.Text, 1, 1);
  end;

  if TodoCorrecto then
  begin
    pFIBTransaction.StartTransaction;
    try
      // Obtener el c�digo generado autom�ticamente
      pFIBQuery.SQL.Text := 'SELECT GEN_ID(GEN_NCODIGO_PROVEEDORES, 1) FROM rdb$database;';
      pFIBQuery.ExecQuery;
      codigoGenerado := pFIBQuery.Fields[0].AsInteger;

      // Si el c�digo est� vac�o, asignamos el c�digo generado
      if Length(Trim(edtCodigo.Text)) = 0 then
      begin
        edtCodigo.Text := IntToStr(codigoGenerado);
      end
      else
      begin
        // Intentar convertir el c�digo manual a entero si no est� vac�o
        try
          codigoManual := StrToInt(edtCodigo.Text);

          // Comprobamos que el c�digo insertado manualmente no sea mayor que el generado
          if codigoManual > codigoGenerado then
          begin
            ShowMessage('El c�digo insertado manualmente no puede ser mayor que el c�digo generado.');
            Exit;
          end;
        except
          on E: EConvertError do
          begin
            ShowMessage('El c�digo insertado no es un n�mero v�lido.');
            Exit;
          end;
        end;
      end;

      // Procedemos con la inserci�n del proveedor
      case mode of
        0: // A�adir
          begin
            pFIBQuery.Close;
            pFIBQuery.SQL.Text := 'INSERT INTO PROVEEDORES (NCODIGO, CNOMBRE, CREG_FISCAL) VALUES (:NCODIGO, :CNOMBRE, :CREG_FISCAL)';
            pFIBQuery.ParamByName('NCODIGO').AsInteger := StrToInt(edtCodigo.Text);
            pFIBQuery.ParamByName('CNOMBRE').AsString := edtNombre.Text;
            pFIBQuery.ParamByName('CREG_FISCAL').AsString := regimen;

            pFIBQuery.ExecQuery;
            pFIBTransaction.Commit;

            Self.Close;
          end;
        1: // Actualizar
          begin
            pFIBQuery.Close;  // Aseg�rate de cerrar el query antes de cambiar su SQL.Text
            pFIBQuery.SQL.Text := 'UPDATE PROVEEDORES SET CNOMBRE = :CNOMBRE, CREG_FISCAL = :CREG_FISCAL WHERE NCODIGO = :OLD_NCODIGO';
            pFIBQuery.ParamByName('OLD_NCODIGO').AsInteger := StrToInt(edtCodigo.Text);
            pFIBQuery.ParamByName('CNOMBRE').AsString := edtNombre.Text;
            pFIBQuery.ParamByName('CREG_FISCAL').AsString := regimen;

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


procedure TFormFichaProveedor.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

constructor TFormFichaProveedor.Create(AOwner: TComponent; Modo: Integer);
begin
  inherited Create(AOwner);
  mode := Modo;
end;

function TFormFichaProveedor.TodoCorrecto: Boolean;
var
  pFIBQueryComprobar: TpFIBQuery;
  pFIBTransactionComprobar: TpFIBTransaction;
begin

  if Trim(edtNombre.Text) = '' then
  begin
    ShowMessage('El nombre no puede estar vac�o.');
    Result := False;
    Exit;
  end;

  // Comprobaci�n solo cuando estamos a�adiendo un nuevo proveedor (mode = 0)
  if (mode = 0) and (Length(Trim(edtCodigo.Text)) > 0) then
  begin
    pFIBTransactionComprobar := TpFIBTransaction.Create(nil);
    pFIBTransactionComprobar.DefaultDatabase :=
      ModuloDatos.DataModuleBDD.pFIBDatabase;
    pFIBQueryComprobar := TpFIBQuery.Create(nil);
    pFIBQueryComprobar.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
    pFIBQueryComprobar.Transaction := pFIBTransactionComprobar;

    pFIBTransactionComprobar.StartTransaction;

    pFIBQueryComprobar.SQL.Text :=
      'SELECT COUNT(*) FROM PROVEEDORES WHERE NCODIGO = :codigo';
    pFIBQueryComprobar.ParamByName('codigo').AsString := edtCodigo.Text;

    pFIBQueryComprobar.ExecQuery;

    // Comprobar si ya existe un proveedor con el c�digo, solo si estamos a�adiendo un nuevo proveedor
    if pFIBQueryComprobar.Fields[0].AsInteger >= 1 then
    begin
      ShowMessage('Ya existe un proveedor con ese c�digo.');
      Result := False;
      Exit;
    end;

    pFIBTransactionComprobar.Commit;
    pFIBQueryComprobar.Free;
    pFIBTransactionComprobar.Free;
  end;

  Result := True;
end;

end.
