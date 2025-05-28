unit PruebaReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxClass, StdCtrls, frxDesgn, frxDBSet, ModuloDatos, FIBQuery,
  pFIBQuery, FIBDatabase, pFIBDatabase, DB, FIBDataSet, pFIBDataSet;

type
  TForm1 = class(TForm)
    frxReport: TfrxReport;
    btnVer: TButton;
    frxDBDataset: TfrxDBDataset;
    pFIBTransaction: TpFIBTransaction;
    btnEditar: TButton;
    DataSource: TDataSource;
    DataSet: TpFIBDataSet;
    procedure btnEditarClick(Sender: TObject);
    procedure btnVerClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnEditarClick(Sender: TObject);
begin
  if not pFIBTransaction.InTransaction then
    pFIBTransaction.StartTransaction;


  // frxDBDataset ya debe tener asignado el DataSet y UserName en el Object Inspector

  frxReport.DesignReport();

  if pFIBTransaction.InTransaction then
    pFIBTransaction.Commit;
end;

procedure TForm1.btnVerClick(Sender: TObject);
begin
  if not pFIBTransaction.InTransaction then
    pFIBTransaction.StartTransaction;

  frxReport.LoadFromFile('C:\Users\Pr1\Documents\PruebaBDDReport.fr3');
  frxReport.ShowReport;

  if pFIBTransaction.InTransaction then
    pFIBTransaction.Commit;
end;

end.
