unit FichaArticulos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FichaBase, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.Comp.DataSet,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB;

type
  TFormFichaArticulos = class(TFormFichaBase)
    PanelNombre: TPanel;
    LabelNombre: TLabel;
    EditNombre: TEdit;
    PanelIVA: TPanel;
    LabelIVA: TLabel;
    EditIVA: TEdit;
    PanelStock: TPanel;
    LabelStock: TLabel;
    EditStock: TEdit;
    FDQueryArticulos: TFDQuery;
    FDTransactionArticulos: TFDTransaction;
    // Asegúrate de tener un campo para el código de artículo

    procedure btnAceptarClick(Sender: TObject);
    function TodoCorrecto: Boolean;
  private
    { Private declarations }
    function CodigoExiste(Codigo: String): Boolean;
    // Función para verificar si el código ya existe
  public
    { Public declarations }
    opcion: Integer;
    constructor Create(AOwner: TComponent; CodigoArticulo: String;
      Modo: Integer); reintroduce; overload;
  end;

implementation

{$R *.dfm}

uses ModuloDatos;

{ TFormFichaArticulos }

function TFormFichaArticulos.CodigoExiste(Codigo: String): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := ModuloDatos.DataModuleBDD.DataBaseFDConnection;
    Query.SQL.Text := 'SELECT * FROM ARTICULOS WHERE CCODIGO = :Codigo';
    Query.ParamByName('Codigo').AsString := Codigo;
    Query.Open;

    if not Query.IsEmpty then
      Result := True;
  finally
    Query.Free;
  end;
end;

procedure TFormFichaArticulos.btnAceptarClick(Sender: TObject);
begin
  if not TodoCorrecto then
    Exit; // Si hay un error en la validación, no seguimos ejecutando el código.

  try
    FDTransactionArticulos.StartTransaction;

    case opcion of
      1: // Lógica para agregar un nuevo artículo
        begin
          FDQueryArticulos.SQL.Text :=
            'INSERT INTO ARTICULOS (CCODIGO, CNOMBRE, NSTOCK, NCOD_IVA) ' +
            'VALUES (:Codigo, :Nombre, :Stock, :IVA)';
          FDQueryArticulos.ParamByName('Codigo').AsString := EditCodigo.Text;
          FDQueryArticulos.ParamByName('Nombre').AsString := EditNombre.Text;
          FDQueryArticulos.ParamByName('Stock').AsFloat := StrToFloat(EditStock.Text);
          FDQueryArticulos.ParamByName('IVA').AsInteger := StrToInt(EditIVA.Text);
        end;
      2: // Lógica para actualizar un artículo
        begin
          FDQueryArticulos.SQL.Text :=
            'UPDATE ARTICULOS SET CNOMBRE = :Nombre, NSTOCK = :Stock, NCOD_IVA = :IVA WHERE CCODIGO = :Codigo';
          FDQueryArticulos.ParamByName('Codigo').AsString := EditCodigo.Text;
          FDQueryArticulos.ParamByName('Nombre').AsString := EditNombre.Text;
          FDQueryArticulos.ParamByName('Stock').AsFloat := StrToFloat(EditStock.Text);
          FDQueryArticulos.ParamByName('IVA').AsInteger := StrToInt(EditIVA.Text);
        end;
    end;

    FDQueryArticulos.ExecSQL;
    FDTransactionArticulos.Commit;

    // Solo cerramos el formulario si todo se ejecutó sin errores
    Self.Close;
  except
    on E: Exception do
    begin
      FDTransactionArticulos.Rollback; // Deshacemos cambios en caso de error
      MessageDlg('Error al guardar los datos: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;


constructor TFormFichaArticulos.Create(AOwner: TComponent;
  CodigoArticulo: String; Modo: Integer);
begin
  inherited Create(AOwner);
  opcion := Modo;
  EditCodigo.Text := CodigoArticulo; // Asignar el código de artículo al Edit
  case Modo of
    1:
      begin
        lblTitulo.Caption := 'Agregar nuevo artículo';
        Self.Caption := 'Añadir';
      end;
    2:
      begin
        lblTitulo.Caption := 'Actualizar artículo';
        Self.Caption := 'Actualizar';
      end;
    3:
      begin
        Self.Caption := 'Información';
        lblTitulo.Caption := 'Información del artículo seleccionado';
      end;
  end;
end;

function TFormFichaArticulos.TodoCorrecto: Boolean;
var
  IVA: Integer;
  Stock: Double;
begin
  Result := True;

  if (Length(EditCodigo.Text) > 5) then
  begin
    MessageDlg
      ('El código del artículo no puede tener más de 5 caracteres alfanuméricos. Por favor, ingrese un código válido.',
      mtError, [mbOK], 0);
    Result := False;

  end;

  if (opcion = 1) and CodigoExiste(EditCodigo.Text) then
  begin
    MessageDlg
      ('El código del artículo ya existe. Por favor, ingrese un código único.',
      mtError, [mbOK], 0);
    Result := False;

  end;

  // Verificar que los campos requeridos no estén vacíos
  if (EditNombre.Text = '') or (EditIVA.Text = '') or (EditStock.Text = '') or
    (EditCodigo.Text = '') then
  begin
    MessageDlg('Por favor, rellene todos los campos.', mtError, [mbOK], 0);
    Result := False;

  end;

  // Verificar que el IVA sea un número entre 1 y 4
  if not TryStrToInt(EditIVA.Text, IVA) then
  begin
    MessageDlg('El valor del IVA debe ser un número entero.', mtError,
      [mbOK], 0);
    Result := False;

  end;

  if (IVA < 1) or (IVA > 4) then
  begin
    MessageDlg('El valor del IVA debe ser entre 1 y 4.', mtError, [mbOK], 0);
    Result := False;

  end;

  // Verificar que el Stock sea un número flotante válido
  if not TryStrToFloat(EditStock.Text, Stock) then
  begin
    MessageDlg('El valor del Stock debe ser un número flotante.', mtError,
      [mbOK], 0);
    Result := False;

  end;

  if Stock < 0 then
  begin
    MessageDlg('El valor del Stock no puede ser negativo.', mtError, [mbOK], 0);
    Result := False;

  end;
end;

end.
