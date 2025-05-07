unit MenuProveedores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MenuBase, DB, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase,
  Grids, DBGrids, DBCtrls, StdCtrls, ExtCtrls, FichaGridAlbaranVentas,
  pFIBQuery,
  ModuloDatos, FichaProveedor, FIBQuery;

type
  TFormMenuProveedores = class(TFormMenuBase)
    fbntgrfldFIBDataSetTableNCODIGO: TFIBIntegerField;
    fbdtfldFIBDataSetTableDEFECHA_ULT_COMPRA: TFIBDateField;
    fbstrngfldFIBDataSetTableCNOMBRE: TFIBStringField;
    fbstrngfldFIBDataSetTableCREG_FISCAL: TFIBStringField;
    strngfldFIBDataSetTableCREG_NOMBRE: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure rgGroupOrdenClick(Sender: TObject);
    procedure btnClick(Sender: TObject);
    procedure pFIBDataSetTableCalcFields(DataSet: TDataSet);
    procedure CargarRegimenes(FormFichaProveedor: TFormFichaProveedor);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuProveedores.btnClick(Sender: TObject);
var
  FormFichaProveedor: TFormFichaProveedor;
begin
  if TButton(Sender).Tag <> 3 then
  begin

    FormFichaProveedor := TFormFichaProveedor.Create(Self, TButton(Sender).Tag);
    case TButton(Sender).Tag of
      0:
        begin

          FormFichaProveedor.Caption := 'Proveedor nuevo';
          FormFichaProveedor.DateTimePickerFecha.Format := ' ';
          CargarRegimenes(FormFichaProveedor);
          FormFichaProveedor.ComboBoxRegimen.ItemIndex := 1;

          // si esta vacío el código se pone el del generador y si lo pongo a mano ese
        end;
      1:
        begin
          FormFichaProveedor.Caption := 'Actualizar proveedor seleccionado';
          FormFichaProveedor.edtCodigo.Text := DataSourceTable.DataSet.FieldByName
            ('NCODIGO').AsString;
          FormFichaProveedor.DateTimePickerFecha.Enabled := True;
          FormFichaProveedor.DateTimePickerFecha.DateTime :=
            DataSourceTable.DataSet.FieldByName('DFECHA_ULT_COMPRA').AsDateTime;
          FormFichaProveedor.edtNombre.Enabled := True;
          FormFichaProveedor.edtCodigo.ReadOnly := True;
          FormFichaProveedor.DateTimePickerFecha.Enabled := False;
          FormFichaProveedor.edtNombre.Text := DataSourceTable.DataSet.FieldByName
            ('CNOMBRE').AsString;
          CargarRegimenes(FormFichaProveedor);

          FormFichaProveedor.ComboBoxRegimen.ItemIndex :=
            FormFichaProveedor.ComboBoxRegimen.Items.IndexOf
            (DataSourceTable.DataSet.FieldByName('CREG_NOMBRE').AsString);

        end;
      2:
        begin
          FormFichaProveedor.Caption := 'Información del proveedor seleccionado';
          FormFichaProveedor.edtCodigo.ReadOnly := True;
          FormFichaProveedor.edtNombre.ReadOnly := True;
          if DataSourceTable.DataSet.FieldByName('DFECHA_ULT_COMPRA').IsNull then
            FormFichaProveedor.DateTimePickerFecha.Format := ' '
          else
            FormFichaProveedor.DateTimePickerFecha.DateTime :=
              DataSourceTable.DataSet.FieldByName('DFECHA_ULT_COMPRA')
              .AsDateTime;

          FormFichaProveedor.edtCodigo.Text := DataSourceTable.DataSet.FieldByName
            ('NCODIGO').AsString;
          FormFichaProveedor.edtNombre.Text := DataSourceTable.DataSet.FieldByName
            ('CNOMBRE').AsString;
          FormFichaProveedor.ComboBoxRegimen.Clear;
          FormFichaProveedor.ComboBoxRegimen.Items.Add
            (DataSourceTable.DataSet.FieldByName('CREG_NOMBRE').AsString);
          FormFichaProveedor.ComboBoxRegimen.ItemIndex := 0;
        end;

    end;
    FormFichaProveedor.ShowModal;

    if FormFichaProveedor.edtCodigo.Text <> '' then
    begin
      pFIBTransactionTable.Commit;
      pFIBDataSetTable.Close;
      pFIBTransactionTable.StartTransaction;
      pFIBDataSetTable.Open;

      // Realiza la búsqueda solo si el código no está vacío
      pFIBDataSetTable.Locate('NCODIGO',
        StrToInt(FormFichaProveedor.edtCodigo.Text), []);
    end;
    pFIBDataSetTable.Close;
    pFIBTransactionTable.StartTransaction;
    pFIBDataSetTable.Open;

    FormFichaProveedor.Free;

  end

  else
     try
      if not pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.StartTransaction;

      pFIBQueryDelete.Close;
      pFIBQueryDelete.SQL.Text := 'DELETE FROM PROVEEDORES WHERE NCODIGO = :OLD_NCODIGO';
      pFIBQueryDelete.ParamByName('OLD_NCODIGO').AsInteger := DataSourceTable.DataSet.FieldByName('NCODIGO').AsInteger;
      pFIBQueryDelete.ExecQuery;

      if pFIBTransactionTable.InTransaction then
        pFIBTransactionTable.Commit;

      pFIBDataSetTable.Close;
      pFIBDataSetTable.Open;

      ShowMessage('El proveedor se ha eliminado con éxito.');
    except
      on E: Exception do
      begin
        ShowMessage('Error, no puedes eliminar un proveedor asociado en un albarán');
      end;
    end;
end;

procedure TFormMenuProveedores.FormCreate(Sender: TObject);
begin
  inherited;
  pFIBDataSetTable.Open;
end;

procedure TFormMenuProveedores.pFIBDataSetTableCalcFields(DataSet: TDataSet);
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

procedure TFormMenuProveedores.rgGroupOrdenClick(Sender: TObject);
begin
  case rgGroupOrden.ItemIndex of
    0:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT NCODIGO, DEFECHA_ULT_COMPRA,CNOMBRE,CREG_FISCAL FROM PROVEEDORES ORDER BY NCODIGO';
        pFIBDataSetTable.Open;
      end;

    1:
      begin
        pFIBDataSetTable.Close;
        pFIBDataSetTable.SQLs.SelectSQL.Text :=
          'SELECT NCODIGO, DEFECHA_ULT_COMPRA,CNOMBRE,CREG_FISCAL FROM PROVEEDORES ORDER BY DEFECHA_ULT_COMPRA';
        pFIBDataSetTable.Open;
      end;
  end;

end;

procedure TFormMenuProveedores.CargarRegimenes
  (FormFichaProveedor: TFormFichaProveedor);
begin
  FormFichaProveedor.ComboBoxRegimen.Items.Add('Exento');
  FormFichaProveedor.ComboBoxRegimen.Items.Add('Normal');
  FormFichaProveedor.ComboBoxRegimen.Items.Add('Recargo');
  FormFichaProveedor.ComboBoxRegimen.Items.Add('Internacional');
  FormFichaProveedor.ComboBoxRegimen.Items.Add('Extranjero');
  FormFichaProveedor.ComboBoxRegimen.Items.Add('Canarias');
end;

end.
