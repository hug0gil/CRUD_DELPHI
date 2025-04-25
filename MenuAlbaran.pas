unit MenuAlbaran;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MenuBase, DB, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase,
  Grids, DBGrids, DBCtrls, StdCtrls, ExtCtrls, FichaGridAlbaran, pFIBQuery,
  ModuloDatos, FIBQuery;

type
  TFormMenuAlbaran = class(TFormMenuBase)
    fbntgrfldFIBDataSetTableNCODIGO: TFIBIntegerField;
    fbdtfldFIBDataSetTableDFECHA: TFIBDateField;
    pFIBDataSetTableCOBSERVACIONES: TFIBStringField;
    fbntgrfldFIBDataSetTableNCOD_CLIENTE: TFIBIntegerField;
    pFIBDataSetTableNTOTAL: TFIBBCDField;
    procedure FormCreate(Sender: TObject);
    procedure rgGroupOrdenClick(Sender: TObject);
    procedure btnClick(Sender: TObject);
    procedure getCodClientes(FormFichaGridAlbaran: TFormFichaGridAlbaran);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuAlbaran.btnClick(Sender: TObject);
var
  FormFichaGridAlbaran: TFormFichaGridAlbaran;
  i: Integer;
begin
  if TButton(Sender).Tag <> 3 then
  begin
    FormFichaGridAlbaran := TFormFichaGridAlbaran.Create(Self,
      TButton(Sender).Tag);
    case TButton(Sender).Tag of
      0: // Añadir nuevo artículo
        begin
          FormFichaGridAlbaran.Caption := 'Albarán nuevo';
          getCodClientes(FormFichaGridAlbaran);
          FormFichaGridAlbaran.EditCodigo.ReadOnly := False;
        end;

      1: // Actualizar artículo seleccionado
        begin
          FormFichaGridAlbaran.Caption := 'Actualizar albarán seleccionado';

          FormFichaGridAlbaran.EditCodigo.ReadOnly := True;
          FormFichaGridAlbaran.EditCodigo.Text :=
            DataSourceTable.DataSet.FieldByName('NCODIGO').AsString;

          FormFichaGridAlbaran.DateTimePickerFecha.DateTime :=
            DataSourceTable.DataSet.FieldByName('DFECHA').AsDateTime;
          FormFichaGridAlbaran.originalFecha :=
            DataSourceTable.DataSet.FieldByName('DFECHA').AsDateTime;

          FormFichaGridAlbaran.MemoObservaciones.Lines.Text :=
            DataSourceTable.DataSet.FieldByName('COBSERVACIONES').AsString;
          FormFichaGridAlbaran.originalObservaciones :=
            DataSourceTable.DataSet.FieldByName('COBSERVACIONES').AsString;

          getCodClientes(FormFichaGridAlbaran);

          FormFichaGridAlbaran.cbbCodCliente.ItemIndex :=
            FormFichaGridAlbaran.cbbCodCliente.Items.IndexOf
            (DataSourceTable.DataSet.FieldByName('NCOD_CLIENTE').AsString);

          FormFichaGridAlbaran.originalCodCliente :=
            DataSourceTable.DataSet.FieldByName('NCOD_CLIENTE').AsString;

          if FormFichaGridAlbaran.cbbCodCliente.ItemIndex = -1 then
          begin
            ShowMessage(
              'El código de cliente no se encuentra. Se seleccionará el primer cliente.');
            FormFichaGridAlbaran.cbbCodCliente.ItemIndex := 0;
          end;

          if FormFichaGridAlbaran.cbbCodCliente.ItemIndex = -1 then
          begin
            FormFichaGridAlbaran.cbbCodCliente.ItemIndex := 0;
          end;
        end;

      2: // Ver artículo seleccionado
        begin
          FormFichaGridAlbaran.Caption :=
            'Información del albarán seleccionado';

          FormFichaGridAlbaran.EditCodigo.ReadOnly := True;
          FormFichaGridAlbaran.EditCodigo.Text :=
            DataSourceTable.DataSet.FieldByName('NCODIGO').AsString;
          FormFichaGridAlbaran.DateTimePickerFecha.DateTime :=
            DataSourceTable.DataSet.FieldByName('DFECHA').AsDateTime;
          FormFichaGridAlbaran.MemoObservaciones.Lines.Text :=
            DataSourceTable.DataSet.FieldByName('COBSERVACIONES').AsString;

          FormFichaGridAlbaran.cbbCodCliente.Clear;

          FormFichaGridAlbaran.cbbCodCliente.Items.Add
            (DataSourceTable.DataSet.FieldByName('NCOD_CLIENTE').AsString);

          FormFichaGridAlbaran.cbbCodCliente.ItemIndex :=
            FormFichaGridAlbaran.cbbCodCliente.Items.IndexOf
            (DataSourceTable.DataSet.FieldByName('NCOD_CLIENTE').AsString);

          if FormFichaGridAlbaran.cbbCodCliente.ItemIndex = -1 then
            FormFichaGridAlbaran.cbbCodCliente.ItemIndex := 0;
        end;
    end;

    FormFichaGridAlbaran.ShowModal;

    if FormFichaGridAlbaran.EditCodigo.Text <> '' then
    begin
      pFIBTransactionTable.Commit;
      pFIBDataSetTable.Close;
      pFIBTransactionTable.StartTransaction;
      pFIBDataSetTable.Open;

      // Realiza la búsqueda solo si el código no está vacío para que al salir estemos en el registro creado/modificado/leido
      pFIBDataSetTable.Locate('NCODIGO', FormFichaGridAlbaran.EditCodigo.Text,
        []);
    end;

    FormFichaGridAlbaran.Free;
  end
  else
  begin
    try
      if not pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.StartTransaction;

      pFIBQueryDelete.Close;
      pFIBQueryDelete.SQL.Text :=
        'DELETE FROM ALBARAN WHERE NCODIGO = :OLD_NCODIGO';
      pFIBQueryDelete.ParamByName('OLD_NCODIGO').AsInteger :=
        DataSourceTable.DataSet.FieldByName('NCODIGO').AsInteger;
      pFIBQueryDelete.ExecQuery;

      if pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.Commit;

      pFIBDataSetTable.Close;
      pFIBDataSetTable.Open;

      ShowMessage('El albarán se ha eliminado con éxito.');
    except
      on E: Exception do
      begin
        ShowMessage('Error al eliminar el registro: ' + E.Message);
      end;
    end;
  end;
end;

procedure TFormMenuAlbaran.FormCreate(Sender: TObject);
begin
  inherited;
  pFIBDataSetTable.Open;
end;

procedure TFormMenuAlbaran.rgGroupOrdenClick(Sender: TObject);
begin
  case rgGroupOrden.ItemIndex of
    0:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT NCODIGO, DFECHA,COBSERVACIONES,NCOD_CLIENTE,NTOTAL FROM ALBARAN ORDER BY NCODIGO';
        pFIBDataSetTable.Open;
      end;

    1:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT NCODIGO, DFECHA,COBSERVACIONES,NCOD_CLIENTE,NTOTAL FROM ALBARAN ORDER BY DFECHA';
        pFIBDataSetTable.Open;
      end;
  end;

end;

procedure TFormMenuAlbaran.getCodClientes
  (FormFichaGridAlbaran: TFormFichaGridAlbaran);
var
  QueryClientes: TpFIBQuery;
  i: Integer;
begin
  QueryClientes := TpFIBQuery.Create(nil);
  try
    QueryClientes.Database := ModuloDatos.DataModuleBDD.pFIBDatabase;
    QueryClientes.SQL.Text := 'SELECT NCODIGO FROM CLIENTES';
    QueryClientes.ExecQuery;

    while not QueryClientes.EOF do
    begin
      FormFichaGridAlbaran.cbbCodCliente.Items.Add
        (QueryClientes.FieldByName('NCODIGO').AsString);
      QueryClientes.Next;
    end;
  finally
    QueryClientes.Free;
  end;
end;

end.
