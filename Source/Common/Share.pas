unit Share;

interface

uses Dialogs, Grobal2;

type
  TSceneLevel = (slNormal, slHigh);
  TMirStartupInfo = record
    sDisplayName: String[30];
    sServerName: String[30];
    sServeraddr: String[30];
    nServerPort: Integer;
    sServerKey: String[100];
    sResourceDir: String[50];
    boFullScreen: Boolean;
    boWaitVBlank: Boolean;
    bo3D: Boolean;
    boMini: Boolean;
    nLocalMiniPort: Integer;
    nScreenWidth: Integer;
    nScreenHegiht: Integer;
    sLogo: String[255];
    sWebSite: String[50];
    sPaySite: String[50];
    PassWordFileName:string[127];
  end;

  TMessageHandler = reference to procedure(AResult: Integer{TModalResult});
  TMessageDialogItem = record
    Text: String;
    Buttons: TMsgDlgButtons;
    Handler: TMessageHandler;
    Size: Integer;
  end;
  PTMessageDialogItem = ^TMessageDialogItem;

  TMiniResRequest = packed record
    _Type: Byte; //0:图片 1:单文件
    Important: Boolean; //是否重要，无需队列等待，立即下载
    FileName: String[200];
    Index: Integer;
    FailCount:Word; //失败次数
    Data:Pointer; //用以挂接其他数据
  end;
  PTMiniResRequest = ^TMiniResRequest;

  TMiniResResponse = packed record
    Ident: Integer;
    FileName: String[200];
    Index: Integer;
    Position: Integer;
  end;
  PTMiniResResponse = ^TMiniResResponse;

var
  g_MirStartupInfo: TMirStartupInfo;

implementation

end.
