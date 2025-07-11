unit MiniResBuilderConfig;

interface
uses uTypes,classes;

type
   TMiniResBuilderConfig = class(TuSerialObject)
   private
     FClientPath:String;
     FTargetPath:String;
     FFileList:TStringList;
     FPassWord:String;
   public
     constructor Create();
     destructor Destroy; override;
   published
     property ClientPath:string read FClientPath write FClientPath;
     property TargetPath:String read FTargetPath write FTargetPath;
     property FileList:TStringList read FFileList write FFileList;
     Property PassWord:String read FPassWord write FPassWord;
   end;
implementation

{ TMiniResBuilderConfig }

constructor TMiniResBuilderConfig.Create;
begin
  FileList := TStringList.Create;
end;

destructor TMiniResBuilderConfig.Destroy;
begin
  FileList.Free;
  inherited;
end;

end.
