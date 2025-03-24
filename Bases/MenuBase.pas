unit MenuBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, ModuloDatos;

type
  TFormMenuBase = class(TForm)
    Panel1: TPanel;
    btnActualizar: TButton;
    btnAgregar: TButton;
    Shape1: TShape;
    Panel2: TPanel;
    DBGrid: TDBGrid;
    DBNavigator: TDBNavigator;
    btnEliminar: TButton;
    btnVer: TButton;
    FDTable: TFDTable;
    DataSource: TDataSource;
    procedure btnActualizarClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure btnAgregarClick(Sender: TObject);
    procedure DBNavigatorClick(Sender: TObject; Button: TNavigateBtn);
    function GetLastCodigo: Integer;
  private
    { Private declarations }
    LastCodigo: Integer;
  public
    { Public declarations }
  end;

var
  FormMenuBase: TFormMenuBase;

implementation

{$R *.dfm}

procedure TFormMenuBase.btnActualizarClick(Sender: TObject);
begin
  // Actualizar
end;

procedure TFormMenuBase.btnAgregarClick(Sender: TObject);
begin
  // Añadir
end;

procedure TFormMenuBase.btnEliminarClick(Sender: TObject);
begin
  // Eliminar
end;

function TFormMenuBase.GetLastCodigo: Integer;
begin
  FDTable.Last;
  Result := FDTable.FieldByName('NCODIGO').AsInteger + 1;
end;

procedure TFormMenuBase.DBNavigatorClick(Sender: TObject; Button: TNavigateBtn);

begin
  case Button of
    nbPost:
      begin
        if not ModuloDatos.DataModuleBDD.FDTransaction.Active then
          ModuloDatos.DataModuleBDD.FDTransaction.StartTransaction;

        // Guardar cambios en el dataset (FDTable está en el formulario)
        if FDTable.State in [dsEdit, dsInsert] then
          FDTable.Post; // Guardar cambios en el dataset

        // Confirmar la transacción desde el DataModule si está activa
        if ModuloDatos.DataModuleBDD.FDTransaction.Active then
          ModuloDatos.DataModuleBDD.FDTransaction.Commit;
        // Confirmar cambios en la BD
      end;

    nbCancel:
      begin
        if not ModuloDatos.DataModuleBDD.FDTransaction.Active then
          ModuloDatos.DataModuleBDD.FDTransaction.StartTransaction;

        // Cancelar cambios en el dataset (FDTable está en el formulario)
        if FDTable.State in [dsEdit, dsInsert] then
          FDTable.Cancel; // Cancelar cambios en el dataset

        // Revertir la transacción desde el DataModule si está activa
        if ModuloDatos.DataModuleBDD.FDTransaction.Active then
          ModuloDatos.DataModuleBDD.FDTransaction.Rollback;
        // Revertir cambios en la BD
      end;
  end;
end;

end.
