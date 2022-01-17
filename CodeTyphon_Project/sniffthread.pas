unit SniffThread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PythonEngine, Windows, SyncObjs, AsistantUnit;

type

  { TModuleThread }

  TSniffThread = class(TThread)
   private
    FCtrl : PController;
    FCS : TRTLCriticalSection;

    procedure EncoderInput(Input : TBytes);
    procedure EncoderOutput;
    procedure DecoderInput(Input : TBytes);
    procedure DecoderOutput;
   public
    procedure SetError(ErrorMsg : String);

    constructor Create(PCtrl : PController);
    destructor Destroy; override;
   protected
    procedure Execute; override;
  end;

implementation

{ TSniffThread }

procedure TSniffThread.EncoderInput(Input : TBytes);
begin

end;

procedure TSniffThread.EncoderOutput;
begin

end;

procedure TSniffThread.DecoderInput(Input : TBytes);
begin

end;

procedure TSniffThread.DecoderOutput;
begin

end;

procedure TSniffThread.SetError(ErrorMsg : String);
begin
 EnterCriticalSection(FCS);
 try
  FCtrl^.SetError(ErrorMsg);
 finally
  LeaveCriticalSection(FCS);
 end;
end;

constructor TSniffThread.Create(PCtrl: PController);
begin
 inherited Create(True);
 FreeOnTerminate := True;
 FCtrl := PCtrl;

 InitializeCriticalSection(FCS);
end;

destructor TSniffThread.Destroy;
begin
 DeleteCriticalSection(FCS);

 inherited Destroy;
end;

procedure TSniffThread.Execute;
var
 WR : TWaitResult;
begin
 { ... }

 while not Terminated do
  begin
   WR := EDoSniff.WaitFor(INFINITE);

   if WR = wrSignaled then
    begin
     case FCtrl^.CurrentEvent of
      seEncoderInput : EncoderInput(FCtrl^.CurrentArray);
      seEncoderOutput : EncoderOutput;
      seDecoderInput : DecoderInput(FCtrl^.CurrentArray);
      seDecoderOutput : DecoderOutput;
     end;

     //EDoSniff.ResetEvent;

     ESniffDone.SetEvent;
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

