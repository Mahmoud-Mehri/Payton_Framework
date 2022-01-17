unit ModuleThread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PythonEngine, Windows, SyncObjs, AsistantUnit;

type

  { TModuleThread }

  TModuleThread = class(TThread)
   private
    FCtrl : PController;
    FCS : TRTLCriticalSection;

    FEngine : TPythonEngine;

    procedure EncoderInput();
    procedure EncoderOutput(Output : TBytes);
    procedure DecoderInput();
    procedure DecoderOutput(Output : TBytes);
   public
    procedure SetError(ErrorMsg : String);

    constructor Create(PCtrl : PController);
    destructor Destroy; override;
   protected
    procedure Execute; override;
  end;

implementation

{ TModuleThread }

procedure TModuleThread.EncoderInput;
begin

end;

procedure TModuleThread.EncoderOutput(Output: TBytes);
begin

end;

procedure TModuleThread.DecoderInput;
begin

end;

procedure TModuleThread.DecoderOutput(Output: TBytes);
begin

end;

procedure TModuleThread.SetError(ErrorMsg : String);
begin
 EnterCriticalSection(FCS);
 try
  FCtrl^.SetError(ErrorMsg);
 finally
  LeaveCriticalSection(FCS);
 end;
end;

constructor TModuleThread.Create(PCtrl: PController);
begin
 inherited Create(True);
 FreeOnTerminate := True;
 FCtrl := PCtrl;

 FEngine := TPythonEngine.Create(nil);

 InitializeCriticalSection(FCS);
end;

destructor TModuleThread.Destroy;
begin
 FEngine.Free;
 DeleteCriticalSection(FCS);

 inherited Destroy;
end;

procedure TModuleThread.Execute;
var
 WR : TWaitResult;
 S : TStringList;
 Err : Boolean;
begin
 Err := False;
 S := TStringList.Create;
 try
  try
   S.LoadFromFile(FCtrl^.CurrentModuleFileName);
   FEngine.ExecStrings(S);
  except
   on E:Exception do
    begin
     Err := True;

     SetError(E.Message);
    end;
  end;
 finally
  S.Free;
 end;

 while (not Terminated) and (Err = False) do
  begin
   WR := EDoModule.WaitFor(INFINITE);

   if WR = wrSignaled then
    begin
     case FCtrl^.CurrentEvent of
      seEncoderInput : EncoderInput;
      seEncoderOutput : EncoderOutput(FCtrl^.CurrentArray);
      seDecoderInput : DecoderInput;
      seDecoderOutput : DecoderOutput(FCtrl^.CurrentArray);
     end;

     //EDoModule.ResetEvent;

     EModuleDone.SetEvent;
    end
   else
    begin
     case WR of
      wrError : ;
      wrAbandoned : ;
      wrTimeout : ;
     end;
    end;
  end;
end;

end.

