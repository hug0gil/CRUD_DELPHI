program ProyectoCRUD2010;

uses
  Forms,
  MenuBase in 'MenuBase.pas' {FormMenuBase},
  Main in 'Main.pas' { FormMain },
  ModuloDatos in 'ModuloDatos.pas' {DataModuleBDD: TDataModule},
  MenuClientes in 'MenuClientes.pas' { FormMenuClientes },
  MenuArticulos in 'MenuArticulos.pas' { FormMenuArticulos },
  FichaCliente in 'FichaCliente.pas' { FormFichaCliente },
  FichaArticulos in 'FichaArticulos.pas' { FormFichaArticulos },
  FichaBase in 'FichaBase.pas' {FormFichaBase},
  FichaGridBase in 'FichaGridBase.pas' {FormFichaGridBase0},
  MenuVentas in 'MenuVentas.pas' {FormMenuVentas},
  MenuCompras in 'MenuCompras.pas' {FormMenuCompras},
  MenuAlbaranVentas in 'MenuAlbaranVentas.pas' {FormMenuAlbaranVentas},
  FichaGridAlbaranVentas in 'FichaGridAlbaranVentas.pas' {FormFichaGridAlbaranVentas},
  FichaLineasAlbaranVentas in 'FichaLineasAlbaranVentas.pas' {FormFichaLineasAlbaranVentas},
  MenuAlbaranCompras in 'MenuAlbaranCompras.pas' {FormMenuAlbaranCompras},
  FichaGridAlbaranCompras in 'FichaGridAlbaranCompras.pas' {FormFichaGridAlbaran},
  FichaLineasAlbaranCompras in 'FichaLineasAlbaranCompras.pas' {FormFichaLineasAlbaranCompras},
  MenuProveedores in 'MenuProveedores.pas' {FormMenuProveedores},
  FichaProveedor in 'FichaProveedor.pas' {FormFichaProveedor},
  FichaAlmacen in 'FichaAlmacen.pas' {FormFichaAlmacen},
  FichaUbicacion in 'FichaUbicacion.pas' {FormFichaUbicacion},
  MenuUbicaciones in 'MenuUbicaciones.pas' {FormMenuUbicaciones},
  FichaUbicacionAlbaran in 'FichaUbicacionAlbaran.pas' {FormFichaUbicacionAlbaran};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModuleBDD, DataModuleBDD);
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;

end.
