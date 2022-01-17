unit AsistantUnit;

interface

uses
 Windows, SysUtils, Classes, ExtCtrls, SyncObjs;

type

 TUIUpdateMode = Set of (umState, umEvent, umTime, umVariable, umModule, umError);
 TSystemEvent  = (seEncoderInput, seEncoderOutput, seDecoderInput, seDecoderOutput);
 TSystemState  = (stReady, stRunning, stPaused, stStopped, stWaiting, stError);

 PController = ^TController;

 { TController }

 TController = Class
  private
   FModuleTitle : String;
   FModuleFileName : String;
   FState : TSystemState;
   FCurrentEvent : TSystemEvent;
   FStartTime : TDateTime;
   FElapsedSeconds : Integer;
   FEndTime : TDateTime;
   FEICount, FEOCount, FDICount, FDOCount : Integer;
   FCurrentArray : TBytes;
   FError : String;

   FTimer : TTimer;
  published
   property CurrentModuleTitle : String read FModuleTitle;
   property CurrentModuleFileName : String read FModuleFileName;
   property State : TSystemState read FState default stReady;
   property CurrentEvent : TSystemEvent read FCurrentEvent;
   property StartTime : TDateTime read FStartTime;
   property ElapsedSeconds : Integer read FElapsedSeconds default 0;
   property EndTime : TDateTime read FEndTime;
   property EICount : Integer read FEICount default 0;
   property EOCount : Integer read FEOCount default 0;
   property DICount : Integer read FDICount default 0;
   property DOCount : Integer read FDOCount default 0;
   property CurrentArray : TBytes read FCurrentArray;
   property Error : String read FError;
  public
   procedure Start(ModuleTitle, ModuleFileName : String);
   procedure Pause;
   procedure Stop;
   procedure Wait;

   procedure SetEvent(Event : TSystemEvent);
   procedure IncEventCount(Event : TSystemEvent);
   procedure SetArray(BArray : TBytes);

   procedure SetError(ErrorMsg : String);

   procedure OnTimer(Sender : TObject);

   constructor Create;
   destructor Destroy; override;
 end;

 { TLog }

 TLog = class(TThread)
  private
   fFileName : String;
   fMsg : String;
   fCS : TRTLCriticalSection;
   procedure UpdateLog;
   procedure ClearLog;
  public
   procedure WriteLog(Msg : String);
   procedure ClearLogFile;
   constructor Create(FileName : String);
   destructor Destroy; override;
  protected
   procedure Execute; override;
 end;

 procedure PostString(Window: HWND; Msg: UINT; wParam: WPARAM; const Value: string);

const
 MyShortDateFormat =  'yyyy/MM/dd';

var
 Controller : TController;
 EDoModule, EModuleDone, EDoSniff, ESniffDone : TEvent;

implementation

uses MainUnit;

function HeapAllocatedPChar(const Value: string): PChar;
var
 BufferSize : Integer;
begin
 BufferSize := (Length(Value)+1)*SizeOf(Char);
 GetMem(Result, BufferSize);
 Move(PChar(Value)^, Result^, BufferSize);
end;

procedure PostString(Window: HWND; Msg: UINT; wParam: WPARAM;
  const Value: string);
var
 P : PChar;
begin
 P := HeapAllocatedPChar(Value);
 if not PostMessage(Window, Msg, wParam, LPARAM(P)) then
  FreeMem(P);
end;

{ TController }

procedure TController.Start(ModuleTitle, ModuleFileName : String);
begin
 if State <> stPaused then
  begin
   FModuleTitle := ModuleTitle;
   FModuleFileName := ModuleFileName;

   FStartTime := Now;
   FElapsedSeconds := 0;
   FEndTime := 0;

   FCurrentEvent := seEncoderInput;

   FEICount := 0;
   FEOCount := 0;
   FDICount := 0;
   FDOCount := 0;
  end;

 FState := stRunning;
 FTimer.Enabled := True;
end;

procedure TController.Pause;
begin
 FState := stPaused;
 FTimer.Enabled := False;
end;

procedure TController.Stop;
begin
 FState := stStopped;
 FTimer.Enabled := False;
 FEndTime := Now;
end;

procedure TController.Wait;
begin
 FState := stWaiting;
end;

procedure TController.SetEvent(Event: TSystemEvent);
begin
 FCurrentEvent := Event;
end;

procedure TController.IncEventCount(Event: TSystemEvent);
begin
 case Event of
  seEncoderInput  : FEICount := FEICount + 1;
  seEncoderOutput : FEOCount := FEOCount + 1;
  seDecoderInput  : FDICount := FDICount + 1;
  seDecoderOutput : FDOCount := FDOCount + 1;
 end;
end;

procedure TController.SetArray(BArray: TBytes);
begin
 FCurrentArray := BArray;
end;

procedure TController.SetError(ErrorMsg: String);
begin
 FError := ErrorMsg;
end;

procedure TController.OnTimer(Sender : TObject);
begin
 FElapsedSeconds := FElapsedSeconds + 1;
end;

constructor TController.Create;
begin
 FTimer := TTimer.Create(nil);
 FTimer.Enabled := False;
 FTimer.Interval := 1000;
 FTimer.OnTimer := @OnTimer;

 FStartTime := 0;
 FEndTime := 0;
end;

destructor TController.Destroy;
begin
 FTimer.Free;

 inherited;
end;

{ TLog }

procedure TLog.ClearLogFile;
var
 F : TextFile;
begin
 EnterCriticalSection(fCS);
 try
  AssignFile(F, fFileName);
  if FileExists(fFileName) then
   Rewrite(F);
 finally
  CloseFile(F);

  Synchronize(@ClearLog);

  LeaveCriticalSection(fCS);
 end;
end;

constructor TLog.Create(FileName: String);
begin
 inherited Create(True);
 FreeOnTerminate := True;
 fFileName := FileName;
 fMsg := '';
 if FileExists(fFileName) then
  Synchronize(@UpdateLog);

 InitializeCriticalSection(fCS);
end;

destructor TLog.Destroy;
begin
 DeleteCriticalSection(fCS);

 inherited Destroy;
end;

procedure TLog.Execute;
var
 F : TextFile;
begin
 while not Terminated do
  begin
   if fMsg <> '' then
    begin
     EnterCriticalSection(fCS);
     try
      AssignFile(F, fFileName);
      if FileExists(fFileName) then
       Append(F)
      else
       Rewrite(F);

      WriteLn(F, fMsg);
     finally
      CloseFile(F);

      LeaveCriticalSection(fCS);

      fMsg := '';

      Synchronize(@UpdateLog);
     end;
    end
   else
    Sleep(50);
  end;
end;

procedure TLog.UpdateLog;
begin
 MainFrm.LogMemo.Lines.Clear;
 MainFrm.LogMemo.Lines.LoadFromFile(fFileName);
end;

procedure TLog.ClearLog;
begin
 MainFrm.LogMemo.Lines.Clear;
end;

procedure TLog.WriteLog(Msg: String);
begin
 fMsg := Msg;
end;

initialization
 EDoModule := TEvent.Create(nil, True, False, '');
 EModuleDone := TEvent.Create(nil, True, False, '');

 EDoSniff := TEvent.Create(nil, True, False, '');
 ESniffDone := TEvent.Create(nil, True, False, '');

finalization
 EDoModule.Free;
 EModuleDone.Free;

 EDoSniff.Free;
 ESniffDone.Free;
end.
