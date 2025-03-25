unit UpdateAlbaran;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FichaAlbaran, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls,MenuBase, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,ModuloDatos;

type
  TFormUpdateAlbaran = class(TFormFichaAlbaran)
    FDQueryActualizar: TFDQuery;
    procedure btnAceptarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormUpdateAlbaran: TFormUpdateAlbaran;

implementation

{$R *.dfm}

procedure TFormUpdateAlbaran.btnAceptarClick(Sender: TObject);
var
  FechaFormateada: string;
begin
  // Comprobar que todos los campos necesarios están completos
  if (ComboBoxCodCliente.Text = '') or (MemoObservaciones.Lines.Text = '') then
  begin
    MessageDlgPosHelp('Por favor, rellene todos los campos',
      TMsgDlgType.mtError, [mbOK], 0, -1, -1, 'Error de actualización');
    Exit;
  end;

  // Comprobar que el código de cliente seleccionado está en la lista del ComboBox
  if ComboBoxCodCliente.ItemIndex = -1 then
  begin
    MessageDlg('Por favor, seleccione un código de cliente válido de la lista.',
      mtError, [mbOK], 0);
    Exit;
  end;

  // Obtener la fecha seleccionada y formatearla a formato MM/DD/YYYY
  FechaFormateada := FormatDateTime('MM/DD/YYYY', DateTimePickerFecha.Date);

  FDQueryActualizar := TFDQuery.Create(nil);
  try
    FDQueryActualizar.Connection := ModuloDatos.DataModuleBDD.DataBaseFDConnection;

    // SQL de actualización con parámetros
    FDQueryActualizar.SQL.Text :=
      'UPDATE ALBARAN SET DFECHA = :Fecha, COBSERVACIONES = :Observaciones, NCOD_CLIENTE = :Cliente WHERE NCODIGO = :Codigo';

    // Asignar valores a los parámetros
    FDQueryActualizar.ParamByName('Codigo').AsInteger := StrToInt(EditCodigo.Text); // El código del albarán que se va a actualizar
    FDQueryActualizar.ParamByName('Fecha').AsString := FechaFormateada;
    FDQueryActualizar.ParamByName('Observaciones').AsString := MemoObservaciones.Lines.Text;
    FDQueryActualizar.ParamByName('Cliente').AsInteger := StrToInt(ComboBoxCodCliente.Text); // El nuevo cliente seleccionado

    // Ejecutar la consulta de actualización
    FDQueryActualizar.ExecSQL;

  finally
    FDQueryActualizar.Free;
    Self.Close; // Cerrar el formulario después de la actualización
  end;
end;


end.
