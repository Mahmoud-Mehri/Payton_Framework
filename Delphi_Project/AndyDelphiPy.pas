unit AndyDelphiPy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PythonEngine, AtomPythonEngine, ComCtrls, pythonAtom;

  procedure PyExe(cmds: string; engine: TAtomPythonEngine);
  procedure PyExeFile(fp: string; engine: TAtomPythonEngine);
  function  PyClass(pyclass: string; pydelphivar : TPythonDelphiVar; engine: TAtomPythonEngine): OleVariant;
  function  PyVarToAtom(pydelphivar : TPythonDelphiVar; engine: TAtomPythonEngine): OleVariant;
  procedure PyConsoleOut(const Data: String);

implementation

procedure PyExe(cmds: string; engine: TAtomPythonEngine);
var
  s: TStringList;
begin
  s := TStringList.create;
  try
    s.text := cmds;
    engine.ExecStrings( s );
  finally
    s.free;
  end;
end;

procedure PyExeFile(fp: string; engine: TAtomPythonEngine);
var
  s: TStringList;
begin
  s := TStringList.create;
  try
    if pos(':\', fp) = 0 then
      fp := ExtractFilePath(Application.ExeName) + fp;
    s.LoadFromFile( fp );
    engine.ExecStrings( s );
  finally
    s.free;
  end;
end;

function PyVarToAtom(pydelphivar : TPythonDelphiVar; engine: TAtomPythonEngine): OleVariant;
var
  v: PPyObject;
begin
  v := pydelphivar.ValueObject;
  result := getAtom(v);
  GetPythonEngine.Py_XDECREF(v);
end;

function PyClass(pyclass: string; pydelphivar : TPythonDelphiVar; engine: TAtomPythonEngine): OleVariant;
begin
  PyExe(pydelphivar.VarName + '.Value = ' + pyclass, engine);
  result := PyVarToAtom(pydelphivar, engine);
end;

procedure PyConsoleOut(const Data: String);
begin
  OutputDebugString( PChar(Data));
end;

end.

