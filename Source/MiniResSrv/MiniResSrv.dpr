program MiniResSrv;

{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
//{$I MM.inc}

uses
  Forms,
  uMainFrm in 'uMainFrm.pas' {MainForm},
  uResModule in 'uResModule.pas' {ResoureModule: TDataModule},
  uStaticModule in 'uStaticModule.pas' {StaticModule: TDataModule},
  uCommon in 'uCommon.pas',
  uHTTPTypes in 'uHTTPTypes.pas',
  uURLModule in 'uURLModule.pas' {UrlMonModule: TDataModule},
  uWil in 'uWil.pas',
  uTypes in '..\Common\uTypes.pas',
  uEDCode in '..\Common\uEDCode.pas';

{$R *.res}

begin
//  VMProtectSDK.VMProtectBeginUltra('Run');
//  {$IFNDEF DEBUG}
//  if VMProtectSDK.VMProtectIsDebuggerPresent(True) then
//    Exit;
//  if not VMProtectSDK.VMProtectIsValidImageCRC then
//    Exit;
//  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TResoureModule, ResoureModule);
  Application.CreateForm(TStaticModule, StaticModule);
  Application.CreateForm(TUrlMonModule, UrlMonModule);
  Application.Run;
//  VMProtectSDK.VMProtectEnd;
end.
