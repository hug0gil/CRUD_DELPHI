program PROYECTO_CRUD;

uses
  Vcl.Forms,
  AddAlbaranAntiguo in 'Albaran\AddAlbaranAntiguo.pas' {FormAddAlbaranAntiguo},
  UpdateAlbaran in 'Albaran\UpdateAlbaran.pas' {FormUpdateAlbaran},
  Main in 'Main.pas' {FormMain},
  FichaBase in 'Bases\FichaBase.pas' {FormFichaBase},
  ModuloDatos in 'Bases\ModuloDatos.pas' {DataModuleBDD: TDataModule},
  MenuBase in 'Bases\MenuBase.pas' {FormMenuBase},
  FormMenuAlbaranHeredado in 'Albaran\FormMenuAlbaranHeredado.pas' {FormMenuAlbaran},
  AddAlbaran in 'Albaran\AddAlbaran.pas' {FormAddAlbaran};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModuleBDD, DataModuleBDD);
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
