{
  @html(<b>)
  ISAPI Component Registration
  @html(</b>)
  - Copyright 2004-2014 (c) RealThinClient.com (http://www.realthinclient.com)
  @html(<br><br>)

  RealThinClient ISAPI component is being registered to Delphi component palette.
  
  @exclude
}
unit rtcRegisterISAPI;

{$INCLUDE rtcDefs.inc}

interface

// This procedure is being called by Delphi to register the components.
procedure Register;

implementation

uses
  Classes,

  rtcTypes,
  rtcISAPISrv;

procedure Register;
  begin
  RegisterComponents('RTC Server',[TRtcISAPIServer]);
  end;

initialization
end.
