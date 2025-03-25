program PROYECTO_CRUD;

uses
  Vcl.Forms,
  AddAlbaranAntiguo in 'Albaran\AddAlbaranAntiguo.pas' {FormAddAlbaranAntiguo},
  Main in 'Main.pas' {FormMain},
  ModuloDatos in 'Bases\ModuloDatos.pas' {DataModuleBDD: TDataModule},
  MenuBase in 'Bases\MenuBase.pas' {FormMenuBase},
  FormMenuAlbaranHeredado in 'Albaran\FormMenuAlbaranHeredado.pas' {FormMenuAlbaran},
  FichaBase in 'Bases\FichaBase.pas' {FormFichaBase},
  FichaAlbaran in 'Bases\FichaAlbaran.pas' {FormFichaAlbaran},
  AddAlbaran in 'Albaran\AddAlbaran.pas' {FormAddAlbaran},
  UpdateAlbaran in 'Albaran\UpdateAlbaran.pas' {FormUpdateAlbaran},
  ReadAlbaran in 'Albaran\ReadAlbaran.pas' {FormReadAlbaran};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModuleBDD, DataModuleBDD);
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
