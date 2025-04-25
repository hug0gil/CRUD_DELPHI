unit ModuloDatos;

interface

uses
  SysUtils, Classes, FIBDatabase, pFIBDatabase;

type
  TDataModuleBDD = class(TDataModule)
    pFIBDatabase: TpFIBDatabase;
    pFIBTransaction: TpFIBTransaction;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleBDD: TDataModuleBDD;

implementation

{$R *.dfm}

procedure TDataModuleBDD.DataModuleCreate(Sender: TObject);
begin
  pFIBDatabase.Open();
  pFIBTransaction.StartTransaction;
end;

end.
