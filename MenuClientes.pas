unit MenuClientes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MenuBase, FIBDatabase, pFIBDatabase, DB, FIBDataSet, pFIBDataSet,
  DBCtrls, Grids, DBGrids, StdCtrls, ExtCtrls, ModuloDatos, FichaCliente,
  FIBQuery, pFIBQuery;

type
  TFormMenuClientes = class(TFormMenuBase)
    pFIBDataSetTableNCODIGO: TFIBIntegerField;
    pFIBDataSetTableDFECHA_ULT_VENTA: TFIBDateField;
    pFIBDataSetTableCNOMBRE: TFIBStringField;
    pFIBDataSetTableCREG_FISCAL: TFIBStringField;
    pFIBDataSetTableCREG_NOMBRE: TStringField;
    procedure pFIBDataSetTableCalcFields(DataSet: TDataSet);
    procedure btnClick(Sender: TObject);
    procedure CargarRegimenes(FormFichaCliente: TFormFichaCliente);
    procedure rgGroupOrdenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuClientes.btnClick(Sender: TObject);
var
  FormFichaCliente: TFormFichaCliente;
begin
  if TButton(Sender).Tag <> 3 then
  begin

    FormFichaCliente := TFormFichaCliente.Create(Self, TButton(Sender).Tag);
    case TButton(Sender).Tag of
      0:
        begin

          FormFichaCliente.Caption := 'Cliente nuevo';
          FormFichaCliente.DateTimePickerFecha.Format := ' ';
          CargarRegimenes(FormFichaCliente);
          FormFichaCliente.ComboBoxRegimen.ItemIndex := 1;

          // si esta vacío el código se pone el del generador y si lo pongo a mano ese
        end;
      1:
        begin
          FormFichaCliente.Caption := 'Actualizar cliente seleccionado';
          FormFichaCliente.edtCodigo.Text := DataSourceTable.DataSet.FieldByName
            ('NCODIGO').AsString;
          FormFichaCliente.DateTimePickerFecha.Enabled := True;
          FormFichaCliente.DateTimePickerFecha.DateTime :=
            DataSourceTable.DataSet.FieldByName('DFECHA_ULT_VENTA').AsDateTime;
          FormFichaCliente.edtNombre.Enabled := True;
          FormFichaCliente.edtCodigo.ReadOnly := True;
          FormFichaCliente.DateTimePickerFecha.Enabled := False;
          FormFichaCliente.edtNombre.Text := DataSourceTable.DataSet.FieldByName
            ('CNOMBRE').AsString;
          CargarRegimenes(FormFichaCliente);

          FormFichaCliente.ComboBoxRegimen.ItemIndex :=
            FormFichaCliente.ComboBoxRegimen.Items.IndexOf
            (DataSourceTable.DataSet.FieldByName('CREG_NOMBRE').AsString);

        end;
      2:
        begin
          FormFichaCliente.Caption := 'Información del cliente seleccionado';
          FormFichaCliente.edtCodigo.ReadOnly := True;
          FormFichaCliente.edtNombre.ReadOnly := True;
          if DataSourceTable.DataSet.FieldByName('DFECHA_ULT_VENTA').IsNull then
            FormFichaCliente.DateTimePickerFecha.Format := ' '
          else
            FormFichaCliente.DateTimePickerFecha.DateTime :=
              DataSourceTable.DataSet.FieldByName('DFECHA_ULT_VENTA')
              .AsDateTime;

          FormFichaCliente.edtCodigo.Text := DataSourceTable.DataSet.FieldByName
            ('NCODIGO').AsString;
          FormFichaCliente.edtNombre.Text := DataSourceTable.DataSet.FieldByName
            ('CNOMBRE').AsString;
          FormFichaCliente.ComboBoxRegimen.Clear;
          FormFichaCliente.ComboBoxRegimen.Items.Add
            (DataSourceTable.DataSet.FieldByName('CREG_NOMBRE').AsString);
          FormFichaCliente.ComboBoxRegimen.ItemIndex := 0;
        end;

    end;
    FormFichaCliente.ShowModal;

    if FormFichaCliente.edtCodigo.Text <> '' then
    begin
      pFIBTransactionTable.Commit;
      pFIBDataSetTable.Close;
      pFIBTransactionTable.StartTransaction;
      pFIBDataSetTable.Open;

      // Realiza la búsqueda solo si el código no está vacío
      pFIBDataSetTable.Locate('NCODIGO',
        StrToInt(FormFichaCliente.edtCodigo.Text), []);
    end;
    pFIBDataSetTable.Close;
    pFIBTransactionTable.StartTransaction;
    pFIBDataSetTable.Open;

    FormFichaCliente.Free;

  end

  else
     try
      if not pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.StartTransaction;

      pFIBQueryDelete.Close;
      pFIBQueryDelete.SQL.Text := 'DELETE FROM CLIENTES WHERE NCODIGO = :OLD_NCODIGO';
      pFIBQueryDelete.ParamByName('OLD_NCODIGO').AsInteger := DataSourceTable.DataSet.FieldByName('NCODIGO').AsInteger;
      pFIBQueryDelete.ExecQuery;

      if pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.Commit;

      pFIBDataSetTable.Close;
      pFIBDataSetTable.Open;

      ShowMessage('El cliente se ha eliminado con éxito.');
    except
      on E: Exception do
      begin
        ShowMessage('Error, no puedes eliminar un cliente asociado en un albarán');
      end;
    end;

end;

procedure TFormMenuClientes.CargarRegimenes
  (FormFichaCliente: TFormFichaCliente);
begin
  FormFichaCliente.ComboBoxRegimen.Items.Add('Exento');
  FormFichaCliente.ComboBoxRegimen.Items.Add('Normal');
  FormFichaCliente.ComboBoxRegimen.Items.Add('Recargo');
  FormFichaCliente.ComboBoxRegimen.Items.Add('Internacional');
  FormFichaCliente.ComboBoxRegimen.Items.Add('Extranjero');
  FormFichaCliente.ComboBoxRegimen.Items.Add('Canarias');
end;

procedure TFormMenuClientes.FormCreate(Sender: TObject);
begin
  inherited;
  pFIBDataSetTable.SQLs.SelectSQL.Text :=
    'SELECT NCODIGO, DFECHA_ULT_VENTA,CNOMBRE,CREG_FISCAL FROM CLIENTES ORDER BY CNOMBRE';
  pFIBDataSetTable.Open;
end;

procedure TFormMenuClientes.pFIBDataSetTableCalcFields(DataSet: TDataSet);
begin
  case DataSet.FieldByName('CREG_FISCAL').AsString[1] of
    'E':
      DataSet.FieldByName('CREG_NOMBRE').AsString := 'Exento';
    'N':
      DataSet.FieldByName('CREG_NOMBRE').AsString := 'Normal';
    'R':
      DataSet.FieldByName('CREG_NOMBRE').AsString := 'Recargo';
    'I':
      DataSet.FieldByName('CREG_NOMBRE').AsString := 'Internacional';
    'X':
      DataSet.FieldByName('CREG_NOMBRE').AsString := 'Extranjero';
    'G':
      DataSet.FieldByName('CREG_NOMBRE').AsString := 'Canarias'
  end;
end;

procedure TFormMenuClientes.rgGroupOrdenClick(Sender: TObject);
begin

  case rgGroupOrden.ItemIndex of
    0:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT NCODIGO, DFECHA_ULT_VENTA,CNOMBRE,CREG_FISCAL FROM CLIENTES ORDER BY CNOMBRE';
        pFIBDataSetTable.Open;
      end;

    1:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT NCODIGO, DFECHA_ULT_VENTA,CNOMBRE,CREG_FISCAL FROM CLIENTES ORDER BY NCODIGO';
        pFIBDataSetTable.Open;
      end;
  end;

end;

end.
