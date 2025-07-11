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
    _Type: Byte; //0:ͼƬ 1:���ļ�
    Important: Boolean; //�Ƿ���Ҫ��������еȴ�����������
    FileName: String[200];
    Index: Integer;
    FailCount:Word; //ʧ�ܴ���
    Data:Pointer; //���Թҽ���������
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
