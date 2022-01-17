unit mainthreadunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, SyncObjs, AsistantUnit;

type

 { TMainThread }

 TMainThread = class(TThread)
  private
   FResultHandle : THandle;
   FCtrl : PController;
   FUIUpdateMode : TUIUpdateMode;
   FCS : TRTLCriticalSection;

   procedure UpdateUI;
  public
   procedure SetNextEvent(EventName : TSystemEvent);

   constructor Create(ResultHandle : THandle; PCtrl : PController);
   destructor Destroy; override;
  protected
   procedure Execute; override;
 end;

var
 MainThread : TMainThread;

const
 MSG_MODULELOADERROR = WM_USER + 1;

implementation

uses
 MainUnit;

{ TMainThread }

procedure TMainThread.UpdateUI;
begin
 MainFrm.UpdateUI(FCtrl^, FUIUpdateMode);
end;

procedure TMainThread.SetNextEvent(EventName : TSystemEvent);
begin
 EnterCriticalSection(FCS);
 try
  FCtrl^.SetEvent(EventName);
 finally
  LeaveCriticalSection(FCS);
 end;
end;

constructor TMainThread.Create(ResultHandle: THandle; PCtrl : PController);
begin
 inherited Create(True);
 FreeOnTerminate := True;
 FResultHandle := ResultHandle;
 FCtrl := PCtrl;

 InitializeCriticalSection(FCS);
end;

destructor TMainThread.Destroy;
begin
 DeleteCriticalSection(FCS);

 inherited Destroy;
end;

procedure TMainThread.Execute;
var
 WR : Cardinal;
 WaitingHandles : Array[0..1] of THandle;
begin
 WaitingHandles[0] := THandle(EModuleDone.Handle);
 WaitingHandles[1] := THandle(ESniffDone.Handle);

 while not Terminated do
  begin
   WR := WaitForMultipleObjects(2, @WaitingHandles, False, INFINITE);

   case WR of
    WAIT_OBJECT_0 : begin
                     case FCtrl^.CurrentEvent of
                      seEncoderInput  : ;
                      seEncoderOutput : ;
                      seDecoderInput  : ;
                      seDecoderOutput : ;
                     end;
                    end;
    WAIT_OBJECT_0+1 : begin
                       case FCtrl^.CurrentEvent of
                        seEncoderInput  : ;
                        seEncoderOutput : ;
                        seDecoderInput  : ;
                        seDecoderOutput : ;
                       end;
                      end;
    WAIT_TIMEOUT : begin

                   end;
   end;
  end;
end;

initialization

finalization

end.

