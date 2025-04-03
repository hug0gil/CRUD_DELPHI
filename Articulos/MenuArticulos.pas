unit MenuArticulos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MenuBase, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, ModuloDatos,
  FichaArticulos;

type
  TFormMenuArticulos = class(TFormMenuBase)
    FDTableCCODIGO: TStringField;
    FDTableCNOMBRE: TStringField;
    FDTableNSTOCK: TFMTBCDField;
    FDTableNCOD_IVA: TSmallintField;
    FDTableTIPOIVA: TStringField;
    procedure OnCreate(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure DBNavigatorClick(Sender: TObject; Button: TNavigateBtn);
    function getCodArticulos: TArray<String>;
    procedure btnAgregarClick(Sender: TObject);
    procedure btnActualizarClick(Sender: TObject);
    procedure btnVerClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure FDTableCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    CodigoSeleccionado: string;
  end;

implementation

{$R *.dfm}

function TFormMenuArticulos.getCodArticulos: TArray<String>;
var
  QueryArticulos: TFDQuery;
  CodigosArticulos: TArray<String>;
  i: Integer;
begin
  QueryArticulos := TFDQuery.Create(nil);
  try
    QueryArticulos.Connection := ModuloDatos.DataModuleBDD.DataBaseFDConnection;
    QueryArticulos.SQL.Text := 'SELECT CCODIGO FROM ARTICULOS';
    QueryArticulos.Open;

    // Reservar espacio para los códigos
    SetLength(CodigosArticulos, QueryArticulos.RecordCount);

    // Usar un bucle FOR para llenar el array
    for i := 0 to QueryArticulos.RecordCount - 1 do
    begin
      CodigosArticulos[i] := QueryArticulos.FieldByName('NCODIGO').AsString;
      QueryArticulos.Next;
    end;

    Result := CodigosArticulos;
  finally
    QueryArticulos.Free;
  end;
end;

procedure TFormMenuArticulos.btnAgregarClick(Sender: TObject);
var
  FormAddArticulos: TFormFichaArticulos;
begin
  FormAddArticulos := TFormFichaArticulos.Create(Self, '', 1);
  FormAddArticulos.EditCodigo.ReadOnly := False;
  FormAddArticulos.EditNombre.ReadOnly := False;
  FormAddArticulos.EditStock.ReadOnly := False;
  FormAddArticulos.ShowModal;
  FormAddArticulos.Free;

  actualizarVista();
end;

procedure TFormMenuArticulos.btnEliminarClick(Sender: TObject);
var
  Confirmacion: Integer;
  DeleteQuery: TFDQuery;
begin
  if CodigoSeleccionado = '' then
  begin
    ShowMessage('Por favor, seleccione un artículo para eliminar.');
    Exit;
  end;

  Confirmacion := MessageDlg
    ('¿Está seguro de que desea eliminar este artículo?', mtConfirmation,
    [mbYes, mbNo], 0);

  if Confirmacion = mrYes then
  begin
    DeleteQuery := TFDQuery.Create(nil);
    try
      DeleteQuery.Connection := ModuloDatos.DataModuleBDD.DataBaseFDConnection;

      ModuloDatos.DataModuleBDD.DataBaseFDConnection.StartTransaction;
      try
        DeleteQuery.SQL.Text := 'DELETE FROM ARTICULOS WHERE CCODIGO = :Codigo';
        DeleteQuery.ParamByName('Codigo').AsString := CodigoSeleccionado;
        DeleteQuery.ExecSQL;

        ModuloDatos.DataModuleBDD.DataBaseFDConnection.Commit;
        ShowMessage('El artículo ha sido eliminado con éxito.');
      except
        on E: Exception do
        begin
          ModuloDatos.DataModuleBDD.DataBaseFDConnection.Rollback;
          ShowMessage('Error al eliminar el artículo: ' + E.Message);
        end;
      end;
    finally
      DeleteQuery.Free;
    end;
  end;
  actualizarVista();
end;

procedure TFormMenuArticulos.btnActualizarClick(Sender: TObject);
var
  FormUpdateticulos: TFormFichaArticulos;
begin
  FormUpdateticulos := TFormFichaArticulos.Create(Self, CodigoSeleccionado, 2);
  FormUpdateticulos.EditNombre.ReadOnly := False;
  FormUpdateticulos.EditStock.ReadOnly := False;
  FormUpdateticulos.EditNombre.Text := DataSource.DataSet.Fields[1].AsString;
  FormUpdateticulos.EditStock.Text := DataSource.DataSet.Fields[2].AsString;
  FormUpdateticulos.ComboBoxIVA.Text := DataSource.DataSet.Fields[3].AsString;
  FormUpdateticulos.ShowModal;
  FormUpdateticulos.Free;

  actualizarVista();

end;

procedure TFormMenuArticulos.btnVerClick(Sender: TObject);
var
  FormVerArticulos: TFormFichaArticulos;
begin
  FormVerArticulos := TFormFichaArticulos.Create(Self, CodigoSeleccionado, 3);
  FormVerArticulos.EditNombre.Text := DataSource.DataSet.Fields[1].AsString;
  FormVerArticulos.EditStock.Text := DataSource.DataSet.Fields[2].AsString;
  FormVerArticulos.ComboBoxIVA.Clear;
   FormVerArticulos.ComboBoxIVA.Text := DataSource.DataSet.Fields[3].AsString;

  FormVerArticulos.ShowModal;
  FormVerArticulos.Free;

  actualizarVista();

end;

procedure TFormMenuArticulos.DataSourceDataChange(Sender: TObject;
  Field: TField);
begin
  DataSource.DataSet.Edit;

  CodigoSeleccionado := 'null';
  if (DataSource <> nil) and (DataSource.DataSet <> nil) and
    (DataSource.DataSet.Active) and (not DataSource.DataSet.IsEmpty) then
  begin

    CodigoSeleccionado := DataSource.DataSet.Fields[0].AsString;

  end
  else
    ShowMessage('No hay datos en el DataSet o el DataSource está vacío.');

end;

procedure TFormMenuArticulos.DBNavigatorClick(Sender: TObject;
  Button: TNavigateBtn);
begin
  inherited;

  case Button of
    nbPost:
      begin
        try
          if not ModuloDatos.DataModuleBDD.FDTransaction.Active then
            ModuloDatos.DataModuleBDD.FDTransaction.StartTransaction;

          if DataSource.DataSet.State in [dsEdit, dsInsert] then
            DataSource.DataSet.Post;

          ModuloDatos.DataModuleBDD.FDTransaction.Commit;
          ShowMessage('Cambios guardados correctamente.');
        except
          on E: Exception do
          begin
            if ModuloDatos.DataModuleBDD.FDTransaction.Active then
              ModuloDatos.DataModuleBDD.FDTransaction.Rollback;
            ShowMessage('Error al guardar: ' + E.Message);
          end;
        end;
      end;

    nbCancel:
      begin
        if ModuloDatos.DataModuleBDD.FDTransaction.Active then
          ModuloDatos.DataModuleBDD.FDTransaction.Rollback;

        if DataSource.DataSet.State in [dsEdit, dsInsert] then
          DataSource.DataSet.Cancel;

        ShowMessage('Cambios cancelados.');
      end;
  end;
  actualizarVista();
end;

procedure TFormMenuArticulos.FDTableCalcFields(DataSet: TDataSet);
var
  codigoIva: Integer;
  FDQueryIVA: TFDQuery;
begin
  FDQueryIVA := TFDQuery.Create(Self);
  try
    FDQueryIVA.Connection := ModuloDatos.DataModuleBDD.DataBaseFDConnection;
    codigoIva := DataSet.Fields[3].AsInteger;

    FDQueryIVA.SQL.Text :=
      'SELECT CDESCRIPCION FROM TIPOS_IVA WHERE NCODIGO = :Codigo';
    FDQueryIVA.ParamByName('Codigo').AsInteger := codigoIva;
    FDQueryIVA.Open;

    if not FDQueryIVA.IsEmpty then
      DataSet.FieldByName('TIPOIVA').AsString :=
        FDQueryIVA.FieldByName('CDESCRIPCION').AsString
    else
      DataSet.FieldByName('TIPOIVA').AsString := 'No encontrado';

  finally
    FDQueryIVA.Free;
  end;
end;

procedure TFormMenuArticulos.OnCreate(Sender: TObject);
begin
  CodigoSeleccionado := '';
  if not ModuloDatos.DataModuleBDD.FDTransaction.Active then
    ModuloDatos.DataModuleBDD.FDTransaction.StartTransaction;

  if not DataSource.DataSet.Active then
    DataSource.DataSet.Open;

  if not(DataSource.DataSet.State in [dsEdit, dsInsert]) then
    DataSource.DataSet.Edit;

  DBNavigator.Enabled := True;
end;

end.
