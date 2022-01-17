program PyWork;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainFrm},
  AndyDelphiPy in 'AndyDelphiPy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
