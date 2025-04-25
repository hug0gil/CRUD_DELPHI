program ProyectoCRUD2010;

uses
  Forms,
  MenuBase in 'MenuBase.pas' {FormMenuBase},
  Main in 'Main.pas' { FormMain },
  ModuloDatos in 'ModuloDatos.pas' {DataModuleBDD: TDataModule},
  MenuClientes in 'MenuClientes.pas' { FormMenuClientes },
  MenuArticulos in 'MenuArticulos.pas' { FormMenuArticulos },
  MenuAlbaran in 'MenuAlbaran.pas' { FormMenuAlbaran },
  FichaCliente in 'FichaCliente.pas' { FormFichaCliente },
  FichaArticulos in 'FichaArticulos.pas' { FormFichaArticulos },
  FichaBase in 'FichaBase.pas' {FormFichaBase},
  FichaGridAlbaran in 'FichaGridAlbaran.pas' {FormFichaGridAlbaran},
  FichaGridBase in 'FichaGridBase.pas' {FormFichaGridBase0},
  FichaLineasAlbaran in 'FichaLineasAlbaran.pas' {FormFichaLineasAlbaran};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModuleBDD, DataModuleBDD);
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;

end.
