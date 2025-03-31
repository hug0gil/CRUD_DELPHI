program PROYECTO_CRUD;

uses
  Vcl.Forms,
  Main in 'Main.pas' {FormMain},
  ModuloDatos in 'Bases\ModuloDatos.pas' {DataModuleBDD: TDataModule},
  MenuBase in 'Bases\MenuBase.pas' {FormMenuBase},
  MenuAlbaran in 'Albaran\MenuAlbaran.pas' {FormMenuAlbaran},
  FichaBase in 'Bases\FichaBase.pas' {FormFichaBase},
  MenuArticulos in 'Articulos\MenuArticulos.pas' {FormMenuArticulos},
  FichaArticulos in 'Articulos\FichaArticulos.pas' {FormFichaArticulos},
  MenuClientes in 'Clientes\MenuClientes.pas' {FormMenuClientes},
  FichaClientes in 'Clientes\FichaClientes.pas' {FormFichaClientes},
  FichaLineasAlbaran in 'Albaran\FichaLineasAlbaran.pas' {FormFichaLineasAlbaran},
  FichaGridBase in 'Bases\FichaGridBase.pas' {FormFichaGridBase},
  FichaGridAlbaran in 'Albaran\FichaGridAlbaran.pas' {FormFichaGridAlbaran};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModuleBDD, DataModuleBDD);
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;

end.
