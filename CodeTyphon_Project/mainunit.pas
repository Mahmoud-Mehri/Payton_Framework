unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynHighlighterPython, SynEdit, TplShapeLineUnit,
  AdvLed, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls, Buttons,
  DBGrids, ExtCtrls, PythonEngine, PythonGUIInputOutput, mainthreadunit,
  AsistantUnit, Windows;

type

  { TMainFrm }

  TMainFrm = class(TForm)
    EOLed: TAdvLed;
    EILed: TAdvLed;
    DILed: TAdvLed;
    DOLed: TAdvLed;
    ArrayDelphiVar: TPythonDelphiVar;
    ModuleBtn: TBitBtn;
    LogBtn: TBitBtn;
    ResultBtn: TBitBtn;
    Label12: TLabel;
    ModuleInfoGBox2: TGroupBox;
    EndTimeLB: TLabel;
    EICountLB: TLabel;
    EOCountLB: TLabel;
    DICountLB: TLabel;
    DOCountLB: TLabel;
    plShapeLine1: TplShapeLine;
    StopBtn: TBitBtn;
    PauseBtn: TBitBtn;
    PlayBtn: TBitBtn;
    BtnsGBox1: TGroupBox;
    DBGrid1: TDBGrid;
    BtnsGBox: TGroupBox;
    GroupBox1: TGroupBox;
    Image5: TImage;
    Image6: TImage;
    ResultTitleImg: TImage;
    ResultTileImg: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    ElapsedTimeLB: TLabel;
    ModuleInfoGBox: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ModuleInfoGBox1: TGroupBox;
    ModuleTitleLB: TLabel;
    LogMemo: TMemo;
    ModuleFileNameLB: TLabel;
    StartTimeLB: TLabel;
    StatusLB: TLabel;
    UpdateTimer: TTimer;
    TopGBox: TGroupBox;
    ModuleListBtnGBox: TGroupBox;
    Label2: TLabel;
    ModuleListGBox: TGroupBox;
    ModuleEditor: TSynEdit;
    DeleteModuleBtn: TBitBtn;
    NewModuleBtn: TBitBtn;
    OpenModuleBtn1: TBitBtn;
    MainPC: TPageControl;
    PyEngine: TPythonEngine;
    PythonOutput: TPythonGUIInputOutput;
    PythonSyntaxt: TSynPythonSyn;
    ModulePage: TTabSheet;
    LogPage: TTabSheet;
    ResultPage: TTabSheet;
    TitleFilterEdit: TEdit;
    procedure DeleteModuleBtnClick(Sender: TObject);
    procedure ModuleBtnClick(Sender: TObject);
    procedure LogBtnClick(Sender: TObject);
    procedure PauseBtnClick(Sender: TObject);
    procedure ResultBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure NewModuleBtnClick(Sender: TObject);
    procedure OpenModuleBtnClick(Sender: TObject);
    procedure PlayBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TitleFilterEditChange(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
  private

  public
   procedure UpdateUI(fUC : TController; UpdateMode : TUIUpdateMode);
  end;

var
  MainFrm: TMainFrm;

implementation

uses
 NewModuleUnit, DMUnit;

{$R *.lfm}

{ TMainFrm }

procedure TMainFrm.NewModuleBtnClick(Sender: TObject);
begin
 NewModuleFrm.Clean;

 NewModuleFrm.Position := poMainFormCenter;
 NewModuleFrm.ShowModal;
end;

procedure TMainFrm.OpenModuleBtnClick(Sender: TObject);
begin

end;

procedure TMainFrm.PlayBtnClick(Sender: TObject);
begin
 Controller.Start(DM.ModuleQuery.FieldByName('Title').AsString, DM.ModuleQuery.FieldByName('FileAddr').AsString);

 UpdateUI(Controller, [umEvent, umState, umModule, umTime, umVariable]);

 MainThread := TMainThread.Create(Handle, @Controller);
end;

procedure TMainFrm.StopBtnClick(Sender: TObject);
begin
 Controller.Stop;

 UpdateUI(Controller, [umState, umTime]);
end;

procedure TMainFrm.Timer1Timer(Sender: TObject);
begin

end;

procedure TMainFrm.TitleFilterEditChange(Sender: TObject);
begin
 if Trim(TitleFilterEdit.Text) <> '' then
  begin
   DM.ModuleQuery.ServerFilter := 'Title LIKE ' + QuotedStr('%' + Trim(TitleFilterEdit.Text) + '%');
   DM.ModuleQuery.ServerFiltered := True;
  end
 else
  DM.ModuleQuery.ServerFiltered := False;
end;

procedure TMainFrm.UpdateTimerTimer(Sender: TObject);
begin
 if Controller.State = stRunning then;
  UpdateUI(Controller, [umTime]);
end;

procedure TMainFrm.ModuleBtnClick(Sender: TObject);
begin
 MainPC.ActivePage := ModulePage;
end;

procedure TMainFrm.DeleteModuleBtnClick(Sender: TObject);
begin
 if MessageBox(Handle, 'Are you sure you want to delete this module ?', '', MB_YESNO+MB_ICONQUESTION) = IdYes then
  DM.ModuleQuery.Delete;
end;

procedure TMainFrm.LogBtnClick(Sender: TObject);
begin
 MainPC.ActivePage := LogPage;
end;

procedure TMainFrm.PauseBtnClick(Sender: TObject);
begin
 Controller.Pause;

 UpdateUI(Controller, [umState]);
end;

procedure TMainFrm.ResultBtnClick(Sender: TObject);
begin
 MainPC.ActivePage := ResultPage;
end;

procedure TMainFrm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 DM.ModuleQuery.Active := False;
 DM.Connection.Connected := False;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
 WindowState := wsMaximized;

 Controller := TController.Create;
 UpdateUI(Controller, [umState])
end;

procedure TMainFrm.UpdateUI(fUC : TController; UpdateMode : TUIUpdateMode);
var
 H, M, S : Integer;
begin
 if umState in UpdateMode then
  begin
   case fUC.State of
    stReady   : begin
                 UpdateTimer.Enabled := False;

                 StatusLB.Caption := 'Ready';
                 StatusLB.Font.Color := clGreen;

                 EILed.Blink := False;
                 EOLed.Blink := False;
                 DILed.Blink := False;
                 DOLed.Blink := False;

                 EILed.State := lsoff;
                 EOLed.State := lsOff;
                 DILed.State := lsOff;
                 DOLed.State := lsOff;
                end;
    stRunning : begin
                 UpdateTimer.Enabled := True;

                 StatusLB.Caption := 'Running';
                 StatusLB.Font.Color := clGreen;

                 EILed.State := lsoff;
                 EOLed.State := lsOff;
                 DILed.State := lsOff;
                 DOLed.State := lsOff;

                 EILed.Blink := (fUC.CurrentEvent = seEncoderInput);
                 EOLed.Blink := (fUC.CurrentEvent = seEncoderOutput);
                 DILed.Blink := (fUC.CurrentEvent = seDecoderInput);
                 DOLed.Blink := (fUC.CurrentEvent = seDecoderOutput);
                end;
    stPaused  : begin
                 UpdateTimer.Enabled := False;

                 StatusLB.Caption := 'Paused';
                 StatusLB.Font.Color := clMaroon;

                 EILed.Blink := False;
                 EOLed.Blink := False;
                 DILed.Blink := False;
                 DOLed.Blink := False;

                 case fUC.CurrentEvent of
                  seEncoderInput  : begin
                                     EILed.State := lsOn;
                                     EOLed.State := lsOff;
                                     DILed.State := lsOff;
                                     DOLed.State := lsOff;
                                    end;
                  seEncoderOutput : begin
                                     EILed.State := lsOff;
                                     EOLed.State := lsOn;
                                     DILed.State := lsOff;
                                     DOLed.State := lsOff;
                                    end;
                  seDecoderInput  : begin
                                     EILed.State := lsOff;
                                     EOLed.State := lsOff;
                                     DILed.State := lsOn;
                                     DOLed.State := lsOff;
                                    end;
                  seDecoderOutput : begin
                                    EILed.State := lsOn;
                                    EOLed.State := lsOff;
                                    DILed.State := lsOff;
                                    DOLed.State := lsOff;
                                   end;
                  end;
                end;
    stStopped : begin
                 UpdateTimer.Enabled := False;

                 StatusLB.Caption := 'Stopped';
                 StatusLB.Font.Color := clRed;

                 EILed.Blink := False;
                 EOLed.Blink := False;
                 DILed.Blink := False;
                 DOLed.Blink := False;

                 EILed.State := lsDisabled;
                 EOLed.State := lsDisabled;
                 DILed.State := lsDisabled;
                 DOLed.State := lsDisabled;
                end;
   end;

   PlayBtn.Enabled := (fUC.State <> stRunning);
   PauseBtn.Enabled := (fUC.State = stRunning);
   StopBtn.Enabled := (fUC.State in [stRunning, stPaused]);
  end;

 if umEvent in UpdateMode then
  begin
   EILed.Blink := False;
   EOLed.Blink := False;
   DILed.Blink := False;
   DOLed.Blink := False;

   case fUC.CurrentEvent of
    seEncoderInput  : EILed.Blink := True;
    seEncoderOutput : EOLed.Blink := True;
    seDecoderInput  : DILed.Blink := True;
    seDecoderOutput : DOLed.Blink := True;
   end;

   EICountLB.Caption := fUC.EICount.ToString;
   EOCountLB.Caption := fUC.EOCount.ToString;
   DICountLB.Caption := fUC.DICount.ToString;
   DOCountLB.Caption := fUC.DOCount.ToString;
  end;

 if umTime in UpdateMode then
  begin
   StartTimeLB.Caption := DateTimeToStr(fUC.StartTime);
   H := fUC.ElapsedSeconds div 3600;
   M := (fUC.ElapsedSeconds div 60) - (H * 60);
   S := fUC.ElapsedSeconds mod 60;
   ElapsedTimeLB.Caption := Format('%.2d:%.2d:%.2d', [H, M, S]);
   if fUC.EndTime > 0 then
    EndTimeLB.Caption := DateTimeToStr(fUC.EndTime)
   else
    EndTimeLB.Caption := '-';
  end;

 if umVariable in UpdateMode then
  begin
   {...}
  end;

 if umModule in UpdateMode then
  begin
   ModuleTitleLB.Caption := fUC.CurrentModuleTitle;
   ModuleFileNameLB.Caption := fUC.CurrentModuleFileName;
  end;
end;

end.

