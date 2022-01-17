unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, SynEditHighlighter,
  SynHighlighterPython, PythonEngine, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  PythonGUIInputOutput, Vcl.ComCtrls, Vcl.ExtDlgs, PythonAtom, SyncObjs;

type
  TMainFrm = class(TForm)
    PyHighlighter: TSynPythonSyn;
    PyEngine: TPythonEngine;
    TopPanel: TPanel;
    EditorPanel: TPanel;
    Panel1: TPanel;
    PythonGUIInputOutput: TPythonGUIInputOutput;
    VarPanel: TPanel;
    VarPC: TPageControl;
    VarPage: TTabSheet;
    Records: TTabSheet;
    ClassPage: TTabSheet;
    OutputPanel: TPanel;
    Label5: TLabel;
    OutputMemo: TMemo;
    Editor: TSynEdit;
    Label1: TLabel;
    ExecBtn: TBitBtn;
    PythonModule: TPythonModule;
    Label6: TLabel;
    FuncNameEdit: TEdit;
    Label7: TLabel;
    FuncArgsEdit: TEdit;
    FuncExecBtn: TBitBtn;
    FuncResVar: TPythonDelphiVar;
    Label8: TLabel;
    PyFileEdit: TEdit;
    PyOpenBtn: TBitBtn;
    Label9: TLabel;
    OpenDlg: TOpenTextFileDialog;
    Label10: TLabel;
    ResultEdit: TEdit;
    ClassOpenFileBtn: TBitBtn;
    Label11: TLabel;
    ClassFileEdit: TEdit;
    Label12: TLabel;
    GetClassBtn: TBitBtn;
    Label13: TLabel;
    Label14: TLabel;
    AttrNameEdit: TEdit;
    AttrValueEdit: TEdit;
    ClassDelphiVar: TPythonDelphiVar;
    ClassNameEdit: TEdit;
    NewVarGBox: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    VarNameEdit: TEdit;
    VarCreateBtn: TBitBtn;
    VarValueEdit: TEdit;
    VarTypeCBox: TComboBox;
    VarList: TListBox;
    VarDeleteBtn: TBitBtn;
    Label15: TLabel;
    ArrayDelphiVar: TPythonDelphiVar;
    Button1: TButton;
    procedure ExecBtnClick(Sender: TObject);
    procedure VarCreateBtnClick(Sender: TObject);
    procedure VarDeleteBtnClick(Sender: TObject);
    procedure FuncExecBtnClick(Sender: TObject);
    procedure PyOpenBtnClick(Sender: TObject);
    procedure GetClassBtnClick(Sender: TObject);
    procedure ClassOpenFileBtnClick(Sender: TObject);
    procedure ClassDelphiVarExtGetData(Sender: TObject; var Data: PPyObject);
    procedure ClassDelphiVarExtSetData(Sender: TObject; Data: PPyObject);
    procedure Button1Click(Sender: TObject);
  private
   FMyPythonObject : PPyObject;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.dfm}

uses AndyDelphiPy;

function WideStringToString(const Source: UnicodeString; CodePage: UINT): RawByteString;
var
 strLen: Integer;
begin
 strLen := LocaleCharsFromUnicode(CodePage, 0, PWideChar(Source), Length(Source), nil, 0, nil, nil);
 if strLen > 0 then
  begin
   SetLength(Result, strLen);
   LocaleCharsFromUnicode(CodePage, 0, PWideChar(Source), Length(Source), PAnsiChar(Result), strLen, nil, nil);
   SetCodePage(Result, CodePage, False);
  end;
end;

procedure TMainFrm.Button1Click(Sender: TObject);
var
 S : String;
 L1, L2 : Integer;
 B1, B2 : Integer;

 F : Double;
begin
 Caption := IntToStr(Ord('S'));

// S := 'محمود Mehri';
//
// L1 := Length(S);
// B1 := Length(TEncoding.Unicode.GetBytes(S));
//
// L2 := Length(UTF8Encode(S));
// B2 := Length(TEncoding.UTF8.GetBytes(S));

 FormatSettings.DecimalSeparator := '.';
 F := StrToFloat('1.82');
end;

procedure TMainFrm.ClassDelphiVarExtGetData(Sender: TObject;
  var Data: PPyObject);
begin
 with GetPythonEngine do
   begin
     Data := FMyPythonObject;
     Py_XIncRef(Data); // This is very important
   end;
end;

procedure TMainFrm.ClassDelphiVarExtSetData(Sender: TObject; Data: PPyObject);
begin
 with GetPythonEngine do
  begin
   Py_XDecRef(FMyPythonObject); // This is very important
   FMyPythonObject := Data;
   Py_XIncRef(FMyPythonObject); // This is very important
  end;
end;

procedure TMainFrm.ClassOpenFileBtnClick(Sender: TObject);
begin
 if OpenDlg.Execute then
  ClassFileEdit.Text := OpenDlg.FileName;
end;

procedure TMainFrm.ExecBtnClick(Sender: TObject);
var
 S : UTF8String;
 B : Array of Byte Absolute S;
 B1, B2 : TArray<Byte>;

 I : Integer;

 S2 : String;
begin
 try

//  Editor.Lines.DefaultEncoding := TEncoding.UTF8;
  PyEngine.ExecStrings(Editor.Lines);

 except
  on E:Exception do
   begin
    ShowMessage(E.Message);
   end;
 end;


 S := ArrayDelphiVar.ValueAsString;
 ShowMessage(S + ' | ' + IntToStr(Length(S)) + ' | ' + IntToStr(SizeOf(S)));

// S := 'Mahmood';
//
// B1 := TEncoding.UTF8.GetBytes(S);
// ShowMessage(TEncoding.UTF8.GetString(B1));
//
// B2 := TEncoding.Unicode.GetBytes(S);
// ShowMessage(TEncoding.Unicode.GetString(B2));

// SetLength(B, Length(ArrayDelphiVar.Value));
//
// S := AnsiString(ArrayDelphiVar.Value);
//
// for I := 1 to Length(ArrayDelphiVar.Value) do
//  B[I] := Ord(S[I]);
//
// SetString(S, PAnsiChar(@B), Length(B));
//
// ShowMessage(S);
end;

procedure TMainFrm.FuncExecBtnClick(Sender: TObject);
var
 Err : Boolean;
 S : TStringList;
begin
 if Trim(PyFileEdit.Text) = '' then
  begin
   MessageBox(Handle, 'Please open your Python module file', '', MB_OK+MB_ICONEXCLAMATION);

   Exit;
  end
 else
  begin
   if not FileExists(PyFileEdit.Text) then
    begin
     MessageBox(Handle, 'File does not exists', '', MB_OK+MB_ICONEXCLAMATION);

     Exit;
    end;
  end;

 S := TStringList.Create;
 try
  S.LoadFromFile(PyFileEdit.Text);
  Err := False;
  try
   PyEngine.ExecStrings(S);
  except
   on E:Exception do
    begin
     Err := True;

     MessageBox(Handle, PChar('Load Error : ' + #13 + E.Message), '', MB_OK+MB_ICONEXCLAMATION);
    end;
  end;
 finally
  S.Free;
 end;

 if Err then
  Exit;

 if Trim(FuncNameEdit.Text) = '' then
  begin
   MessageBox(Handle, 'Enter Function Name', '', MB_OK+MB_ICONEXCLAMATION);

   Exit;
  end;

 if Trim(FuncArgsEdit.Text) = '' then
  begin
//   MessageBox(Handle, 'Enter Function Argumants', '', MB_OK+MB_ICONEXCLAMATION);
//
//   Exit;
  end;

 try
  try
   PyEngine.ExecString(Trim(FuncNameEdit.Text)+'(' + Trim(FuncArgsEdit.Text) + ')');
  except
   on E:Exception do
    begin
     MessageBox(Handle, PChar('Function Error : ' + #13 + E.Message), '', MB_OK+MB_ICONEXCLAMATION);
    end;
  end;
 finally
  ResultEdit.Text := FuncResVar.ValueAsString;
 end;
end;

procedure TMainFrm.GetClassBtnClick(Sender: TObject);
var
 Err : Boolean;
 S : TStringList;
 MyClass : OLEVariant;
 PObj : PPyObject;
begin
 if Trim(ClassFileEdit.Text) = '' then
  begin
   MessageBox(Handle, 'Please open your Python module file', '', MB_OK+MB_ICONEXCLAMATION);

   Exit;
  end
 else
  begin
   if not FileExists(ClassFileEdit.Text) then
    begin
     MessageBox(Handle, 'File does not exists', '', MB_OK+MB_ICONEXCLAMATION);

     Exit;
    end;
  end;

 if Trim(ClassNameEdit.Text) = '' then
  begin
   MessageBox(Handle, 'Enter Class Name', '', MB_OK+MB_ICONEXCLAMATION);

   Exit;
  end;

 if Trim(AttrNameEdit.Text) = '' then
  begin
   MessageBox(Handle, 'Enter Attribute Name', '', MB_OK+MB_ICONEXCLAMATION);

   Exit;
  end;

 Err := False;
 S := TStringList.Create;
 try
  try
   S.LoadFromFile(ClassFileEdit.Text);
   S.Add('ClassVar.Value = ' + ClassNameEdit.Text + '()');

   PyEngine.ExecStrings(S);
  except
   on E:Exception do
    begin
     Err := True;

     MessageBox(Handle, PChar('Execute Error : ' + #13 + E.Message), '', MB_OK+MB_ICONEXCLAMATION);
    end;
  end;
 finally
  if not Err then
   begin
    PObj := GetPythonEngine.PyObject_GetAttrString(FMyPythonObject, PAnsiChar(WideStringToString(AttrNameEdit.Text, 0)));
    AttrValueEdit.Text := GetPythonEngine.PyObjectAsString(PObj);
   end;

  S.Free;
 end;
end;

procedure TMainFrm.PyOpenBtnClick(Sender: TObject);
begin
 if OpenDlg.Execute then
  PyFileEdit.Text := OpenDlg.FileName;
end;

procedure TMainFrm.VarCreateBtnClick(Sender: TObject);
var
 V : TPythonDelphiVar;
 I : Integer;
 B : Boolean;
begin
 if Trim(VarNameEdit.Text) = '' then
  begin
   MessageBox(Handle, 'Enter Variable Name', '', MB_OK+MB_ICONEXCLAMATION);

   Exit;
  end
 else
  begin
   if (Pos(' ', VarNameEdit.Text) > 0) or (Copy(VarNameEdit.Text, 1, 1)[1] in ['1'..'9']) then
    begin
     MessageBox(Handle, 'Invalid Variable Name', '', MB_OK+MB_ICONEXCLAMATION);

     Exit;
    end;
  end;

 case VarTypeCBox.ItemIndex of
  0 : begin
       V := TPythonDelphiVar.Create(nil);
       V.Engine := PyEngine;
       V.VarName := VarNameEdit.Text;
       V.Initialize;
       V.Value := VarValueEdit.Text;

       VarList.Items.AddObject(VarNameEdit.Text + ' : String = ' + V.ValueAsString, V);
      end;
  1 : begin
       try
        I := StrToInt(VarValueEdit.Text);

        V := TPythonDelphiVar.Create(nil);
        V.Engine := PyEngine;
        V.VarName := VarNameEdit.Text;
        V.Initialize;
        V.Value := I;

        VarList.Items.AddObject(VarNameEdit.Text + ' : Integer = ' + V.ValueAsString, V);
       except
        on E:EXception do
         MessageBox(Handle, 'Invalid Integer Value', '', MB_OK+MB_ICONEXCLAMATION);
       end;
      end;
  2 : begin
       try
        B := StrToBool(VarValueEdit.Text);

        V := TPythonDelphiVar.Create(nil);
        V.Engine := PyEngine;
        V.VarName := VarNameEdit.Text;
        V.Initialize;
        V.Value := B;

        VarList.Items.AddObject(VarNameEdit.Text + ' : Boolean = ' + V.ValueAsString, V);
       except
        on E:Exception do
         MessageBox(Handle, 'Invalid Boolean Value', '', MB_OK+MB_ICONEXCLAMATION);
       end;
      end;
 end;
end;

procedure TMainFrm.VarDeleteBtnClick(Sender: TObject);
begin
 if VarList.ItemIndex > -1 then
  begin
   TPythonDelphiVar(VarList.Items.Objects[VarList.ItemIndex]).Finalize;

   VarList.Items.Delete(VarList.ItemIndex);
  end;
end;

end.
