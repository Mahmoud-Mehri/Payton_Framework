unit DMUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqlite3conn, sqlite3dyn, sqldb, FileUtil, Forms;

type

  { TDM }

  TDM = class(TDataModule)
    ModuleDS: TDataSource;
    Connection: TSQLite3Connection;
    ModuleQuery: TSQLQuery;
    SQLTransaction: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure ModuleDSDataChange(Sender: TObject; Field: TField);
  private

  public

  end;

var
  DM: TDM;

implementation

Uses
 MainUnit;

{$R *.lfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
 SQLiteDefaultLibrary := ExtractFilePath(Application.ExeName) + 'sqlite3.dll';

 Connection.DatabaseName := ExtractFilePath(Application.ExeName) + 'DB.db';
 Connection.Connected := True;
 ModuleQuery.Active := True;
end;

procedure TDM.ModuleDSDataChange(Sender: TObject; Field: TField);
begin
 if ModuleQuery.State = dsInactive then
  Exit;

 if ModuleQuery.RecordCount > 0 then
  begin
   if FileExists(ModuleQuery.FieldByName('FileAddr').Text) then
    MainFrm.ModuleEditor.Lines.LoadFromFile(ModuleQuery.FieldByName('FileAddr').Text);
  end
 else
  MainFrm.ModuleEditor.Lines.Clear;

 MainFrm.DeleteModuleBtn.Enabled := (ModuleQuery.RecordCount > 0);
end;

end.

