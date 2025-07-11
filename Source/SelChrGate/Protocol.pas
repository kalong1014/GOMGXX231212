unit Protocol;

interface

uses
  Windows, Messages, SysUtils, Classes, IniFiles,
  SyncObj;

const
  _STR_GRID_INDEX           = '����';
  _STR_GRID_IP              = '���ص�ַ';
  _STR_GRID_PORT            = '�˿�';
  _STR_GRID_CONNECT_STATUS  = '����״̬';
  _STR_GRID_ONLINE_USER     = 'ͨѶ';

  _STR_NOW_START            = '����������½����...';
  _STR_STARTED              = '��½�����������...';
  _STR_NOW_STOP             = '����';

  _STR_CONFIG_FILE          = '.\Config.ini';
  _STR_BLOCK_FILE           = '.\BlockIPList.txt';
  _STR_BLOCK_AREA_FILE      = '.\BlockIPAreaList.txt';
  _STR_USER_NAME_FILTER_FILE = '.\NewChrNameFilter.txt';

  _IDM_SERVERSOCK_MSG       = WM_USER + 1000;
  _IDM_TIMER_STARTSERVICE   = _IDM_SERVERSOCK_MSG + 1;
  _IDM_TIMER_STOPSERVICE    = _IDM_SERVERSOCK_MSG + 2;
  _IDM_TIMER_KEEP_ALIVE     = _IDM_SERVERSOCK_MSG + 3;
  _IDM_TIMER_THREAD_INFO    = _IDM_SERVERSOCK_MSG + 4;


const
  MAX_FUNC_COUNT            = 1024;
  MAX_SERVER_FUNC_SIZE      = 16 * 1024;
  MAX_CLIENT_FUNC_SIZE      = 16 * 1024;

type

  TBlockIPMethod = (mDisconnect, mBlock, mBlockList);
  TSockThreadStutas = (stConnecting, stConnected, stTimeOut);

  TPerIPAddr = record
    IPaddr: LongInt;
    Count: Integer;
  end;
  pTPerIPAddr = ^TPerIPAddr;

  TNewIDAddr = record
    IPaddr: LongInt;
    Count: Integer;
    dwIDCountTick: LongWord;
  end;
  pTNewIDAddr = ^TNewIDAddr;

  TIPArea = record
    Low: DWORD;
    High: DWORD;
  end;
  pTIPArea = ^TIPArea;

var
  g_hMainWnd                : HWND;
  g_hGameCenterHandle       : HWND;
  g_fCanClose               : Boolean = False;
  g_fServiceStarted         : Boolean = False;
implementation


end.

