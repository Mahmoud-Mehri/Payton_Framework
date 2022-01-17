program PyWork;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, python4lazarus_pkg, MainUnit, mainthreadunit, dmunit, newmoduleunit, 
  ModuleThread, SniffThread
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TNewModuleFrm, NewModuleFrm);
  Application.Run;
end.

