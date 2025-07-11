unit uKernelMonitor;

interface

uses
  Windows, Messages, SysUtils, Classes, ExtCtrls, Generics.Collections, DateUtils, uGameEngine;

type
  TOnKernelEvent = procedure(ErrorCode: Integer) of Object;
  TDMKernelMonitor = class(TDataModule)
    TimerExec: TTimer;
    procedure TimerExecTimer(Sender: TObject);
  private
    { Private declarations }
    FLastTime: TDateTime;
    FLastTick: LongWord;
    FSpeedCount: Integer;
    FKernelEvent: TOnKernelEvent;
    procedure SetSpeed(const Value: Boolean);
    function GetSpeed: Boolean;
    procedure SendKernelEvent(ErrorCode: Integer);
  public
    { Public declarations }
    property Speed: Boolean read GetSpeed write SetSpeed;
    property OnKernelEvent: TOnKernelEvent read FKernelEvent write FKernelEvent;
  end;

var
  DMKernelMonitor: TDMKernelMonitor;

implementation

{$R *.dfm}

function TDMKernelMonitor.GetSpeed: Boolean;
begin
  Result := TimerExec.Enabled;
end;

procedure TDMKernelMonitor.SetSpeed(const Value: Boolean);
begin
  FLastTime :=  Time;
  FLastTick :=  GetTickCount;
  TimerExec.Enabled := Value;
end;

procedure TDMKernelMonitor.SendKernelEvent(ErrorCode: Integer);
begin
  if Assigned(FKernelEvent) then
    FKernelEvent(ErrorCode);
end;

procedure TDMKernelMonitor.TimerExecTimer(Sender: TObject);
var
  gcount, timer: longword;
  AHour, AMin, ASec, AMsec: word;
begin
  //检查是否被加速
  if Abs((GetTickCount - FLastTick) - DateUtils.MilliSecondsBetween(Now, FLastTime)) > 20 then
  begin
    Inc(FSpeedCount);
    SendKernelEvent(10016);
    if FSpeedCount > 5 then
    begin
      SendKernelEvent(10017);
      FSpeedCount := 0;
    end;
  end;
  FLastTime :=  Now;
  FLastTick :=  GetTickCount;
end;

end.
