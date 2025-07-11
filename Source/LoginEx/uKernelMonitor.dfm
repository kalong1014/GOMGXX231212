object DMKernelMonitor: TDMKernelMonitor
  OldCreateOrder = False
  Height = 150
  Width = 215
  object TimerExec: TTimer
    Enabled = False
    Interval = 250
    OnTimer = TimerExecTimer
    Left = 48
    Top = 56
  end
end
