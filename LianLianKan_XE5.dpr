program LianLianKan_XE5;

uses
  Forms,
  main in 'main.pas' {MainForm},
  common in 'common.pas',
  stack in 'stack.pas',
  share in 'share.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Á¬Á¬¿´';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

end.
