program Tetris;

uses
  Forms,
  UForm in 'UForm.pas' {Form2},
  UTetris in 'UTetris.pas',
  About in 'About.pas' {AboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ТетрИСТ';
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
