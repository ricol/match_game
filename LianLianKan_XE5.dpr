program LianLianKan_XE5;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {MainForm},
  UnitData in 'UnitData.pas',
  UnitStack in 'UnitStack.pas',
  UnitShare in 'UnitShare.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Á¬Á¬¿´';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
