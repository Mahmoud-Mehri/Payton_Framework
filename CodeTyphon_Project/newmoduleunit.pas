unit NewModuleUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Windows,
  Buttons, DB;

type

  { TNewModuleFrm }

  TNewModuleFrm = class(TForm)
    OpenFileBtn: TBitBtn;
    FileAddrEdit: TEdit;
    OpenDlg: TOpenDialog;
    PostBtn: TBitBtn;
    TitleEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ModuleFileGBox: TGroupBox;
    procedure PostBtnClick(Sender: TObject);
    procedure OpenFileBtnClick(Sender: TObject);
  private

  public
   procedure Clean;
  end;

var
  NewModuleFrm: TNewModuleFrm;

implementation

uses
 DMUnit;

{$R *.lfm}

{ TNewModuleFrm }

procedure TNewModuleFrm.OpenFileBtnClick(Sender: TObject);
begin
 if OpenDlg.Execute then
  FileAddrEdit.Text := OpenDlg.FileName;
end;

procedure TNewModuleFrm.Clean;
begin
 TitleEdit.Text := '';
 FileAddrEdit.Text := '';

 ActiveControl := TitleEdit;
end;

procedure TNewModuleFrm.PostBtnClick(Sender: TObject);
begin
 if Trim(TitleEdit.Text) = '' then
  begin
   MessageBox(Handle, 'Please enter a Title for module', '', MB_OK+MB_ICONEXCLAMATION);
   Exit;
  end;

 if Trim(FileAddrEdit.Text) = '' then
  begin
   MessageBox(Handle, 'Please select module file', '', MB_OK+MB_ICONEXCLAMATION);
   Exit;
  end;

 if DM.ModuleQuery.Locate('FileAddr', Trim(FileAddrEdit.Text), []) = True then
  MessageBox(Handle, 'The module file is exists', '', MB_OK+MB_ICONEXCLAMATION)
 else
  begin
   try
    DM.ModuleQuery.Append;
    DM.ModuleQuery.FieldByName('Title').AsString := Trim(TitleEdit.Text);
    DM.ModuleQuery.FieldByName('FileAddr').AsString := Trim(FileAddrEdit.Text);
    DM.ModuleQuery.Post;

    Clean;
   except
    on E:Exception do
     begin
      MessageBox(Handle, PChar('Error on adding new module :' + #13 + E.Message), '', MB_OK+MB_ICONEXCLAMATION);

      if DM.ModuleQuery.State = dsInsert then
       DM.ModuleQuery.Cancel;
     end;
   end;
  end;
end;

end.

