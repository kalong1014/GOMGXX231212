unit uHTTPTypes;

interface
  uses Classes, SysUtils, Generics.Collections, rtcDataSrv;

type
  TURLResponder = class
  public
    procedure Request(Sender: TRtcDataServer); virtual; abstract;
  end;
  TURLResponderClass = class of TURLResponder;

  TURLManager = class
  private
    class var URLManager: TURLManager;
  private
    FUrls: TDictionary<String, TURLResponderClass>;
    constructor Create;
    destructor Destroy; override;
    procedure _Register(const FileName: String; ResponderClass: TURLResponderClass);
    function _TryGetResponder(const FileName: String; out ResponderClass: TURLResponderClass): Boolean;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure Register(const FileName: String; ResponderClass: TURLResponderClass);
    class function TryGetResponder(const FileName: String; out ResponderClass: TURLResponderClass): Boolean;
  end;

implementation

{ TURLManager }

constructor TURLManager.Create;
begin
  FUrls := TDictionary<String, TURLResponderClass>.Create;
end;

destructor TURLManager.Destroy;
begin
  FreeAndNil(FUrls);
  inherited;
end;

procedure TURLManager._Register(const FileName: String; ResponderClass: TURLResponderClass);
begin
  FUrls.AddOrSetValue(UpperCase(FileName), ResponderClass);
end;

function TURLManager._TryGetResponder(const FileName: String;
  out ResponderClass: TURLResponderClass): Boolean;
begin
  Result := FUrls.TryGetValue(UpperCase(FileName), ResponderClass);
end;

class constructor TURLManager.Create;
begin
  URLManager := TURLManager.Create;
end;

class destructor TURLManager.Destroy;
begin
  URLManager.Free;
end;

class procedure TURLManager.Register(const FileName: String; ResponderClass: TURLResponderClass);
begin
  URLManager._Register(FileName, ResponderClass);
end;

class function TURLManager.TryGetResponder(const FileName: String;
  out ResponderClass: TURLResponderClass): Boolean;
begin
  Result := URLManager._TryGetResponder(FileName, ResponderClass);
end;

end.
