unit GList;

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TGList = class(TList)
  private
    FLock: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

  TGStringList = class(TStringList)
  private
    FLock: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

implementation

{ TGList }

constructor TGList.Create;
begin
  inherited Create;
  InitializeCriticalSection(FLock);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(FLock);
end;

procedure TGList.UnLock;
begin
  LeaveCriticalSection(FLock);
end;

{ TGStringList }

constructor TGStringList.Create;
begin
  inherited Create;
  InitializeCriticalSection(FLock);
end;

destructor TGStringList.Destroy;
begin
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

procedure TGStringList.Lock;
begin
  EnterCriticalSection(FLock);
end;

procedure TGStringList.UnLock;
begin
  LeaveCriticalSection(FLock);
end;

end.

