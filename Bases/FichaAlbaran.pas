unit FichaAlbaran;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FichaBase, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ModuloDatos;

type
  TFormFichaAlbaran = class(TFormFichaBase)
    PanelFecha: TPanel;
    LabelFecha: TLabel;
    DateTimePickerFecha: TDateTimePicker;
    PanelObservaciones: TPanel;
    LabelObservaciones: TLabel;
    PanelCodCliente: TPanel;
    LabelCodCliente: TLabel;
    ComboBoxCodCliente: TComboBox;
    MemoObservaciones: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFichaAlbaran: TFormFichaAlbaran;

implementation

{$R *.dfm}

end.
