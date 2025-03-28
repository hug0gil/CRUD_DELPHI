unit FichaGridBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ModuloDatos;

type
  TFormFichaGridBase = class(TForm)
    PanelAlbaranes: TPanel;
    PanelLineas: TPanel;
    PanelBtns: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    btnAceptar: TButton;
    btnCancelar: TButton;
    ButtonBorrar: TButton;
    ButtonInsertar: TButton;
    ButtonActualizar: TButton;
    ButtonVer: TButton;
    LabelObservaciones: TLabel;
    LabelCodCliente: TLabel;
    LabelFecha: TLabel;
    Label1: TLabel;
    EditCodigo: TEdit;
    DateTimePickerFecha: TDateTimePicker;
    MemoObservaciones: TMemo;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    FDTable: TFDTable;
    FDTransactionTable: TFDTransaction;
    FDQuery: TFDQuery;
    ComboBoxCodCliente: TComboBox;
    procedure FormActivate(Sender: TObject);
    function GetLastCodigo(const PrimaryKey: String;
      const TableName: String): Integer;
  private

  public
  end;

implementation

{$R *.dfm}

procedure TFormFichaGridBase.FormActivate(Sender: TObject);
begin
  try
    try
      FDTable.Connection := ModuloDatos.DataModuleBDD.DataBaseFDConnection;
      FDTable.Transaction := FDTransactionTable;
    except
      on E: Exception do
        ShowMessage('Error configurando la conexión: ' + E.Message);
    end;

    if not FDTransactionTable.Active then
      FDTransactionTable.StartTransaction;

    if not FDTable.Active then
      FDTable.Open;

    DataSource.DataSet := FDTable;
    DBGrid.DataSource := DataSource;

    FDTable.Refresh;
    DataSource.DataSet.Refresh;
    DBGrid.Refresh;
  except
    on E: Exception do
      ShowMessage('Error al abrir la tabla: ' + E.Message);
  end;
end;

function TFormFichaGridBase.GetLastCodigo(const PrimaryKey: String;
  const TableName: String): Integer;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := ModuloDatos.DataModuleBDD.DataBaseFDConnection;
    FDQuery.SQL.Text := 'SELECT MAX(' + PrimaryKey + ') FROM ' + TableName;
    FDQuery.Open;

    if FDQuery.Fields[0].IsNull then
      Result := 1
    else
      Result := (FDQuery.Fields[0].AsInteger + 1);
  finally
    FDQuery.Free;
  end;
end;

end.
