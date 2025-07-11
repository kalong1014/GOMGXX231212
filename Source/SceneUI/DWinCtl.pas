unit DWinCtl;

interface

uses
  Windows, Classes, Graphics, SysUtils, Controls, StdCtrls, Messages, Forms,
  AsphyreUtils, Grids, HUtil32, AsphyreFactory, AsphyreTextureFonts, uDControls,
  AbstractTextures, AbstractCanvas, AsphyreTypes, uGameEngine, WIL, Clipbrd,
  Math, StrUtils;

const
  AllowedChars = [#32..#254];
  LineSpace = 5;
  LineSpace2 = 8;
  DECALW = 6;
  DECALH = 4;
  WINLEFT = 60;
  WINTOP = 60;

type
  TDControl = class;
  TDImageIndex = class;
  TButtonStyle = (bsButton, bsRadio, bsCheckBox);
  TDBtnState = (tnor, tdown, tmove, tdisable);
  TClickSound = (csNone, csStone, csGlass, csNorm);
  TOnDirectPaint = procedure(Sender: TObject; DSurface: TAsphyreCanvas) of object;
  TOnKeyPress = procedure(Sender: TObject; var Key: Char) of object;
  TOnKeyDown = procedure(Sender: TObject; var Key: Word; Shift: TShiftState) of object;
  TOnMouseMove = procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
  TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TOnClick = procedure(Sender: TObject) of object;
  TOnClickEx = procedure(Sender: TObject; X, Y: Integer) of object;
  TOnInRealArea = procedure(Sender: TObject; X, Y: Integer; var IsRealArea: Boolean) of object;
  TOnGridSelect = procedure(Sender: TObject; X, Y: Integer; ACol, ARow: Integer; Shift: TShiftState) of object;
  TOnGridPaint = procedure(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; DSurface: TAsphyreCanvas) of object;
  TOnClickSound = procedure(Sender: TObject; Clicksound: TClickSound) of object;
  TOnTextChanged = procedure(Sender: TObject; sText: string) of object;
  TOnEnter = procedure(Sender: TObject) of object;
  TOnLeave = procedure(Sender: TObject) of object;
  TOnAniDirectPaint = procedure(Sender: TObject) of object;
  TOnAniFinish = procedure(Sender: TDControl) of object; // 动画绘制完毕
  TClipType = (ctNone, ctHp, ctMP, ctExp, ctWeight,ctDynamicValue); // 裁剪类型
  TClipOrientation = (coBottom2Top, coTop2Bottom, coRight2Left, coLeftToRight); // 裁剪方向 垂直 水平
  TOnGetClipValue = function(clType: TClipType;  var Value, MaxValue: Int64): Single;

  TDImageIndex = class(TPersistent)
  private
    FOnChange: TNotifyEvent;
    FUp: Integer;
    FHot: Integer;
    FDown: Integer;
    FDisabled: Integer;
    procedure SetUp(Value: Integer);
    procedure SetHot(Value: Integer);
    procedure SetDown(Value: Integer);
    procedure SetDisabled(Value: Integer);
  protected
    procedure Changed; //dynamic;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Up: Integer read FUp write SetUp;
    property Hot: Integer read FHot write SetHot;
    property Down: Integer read FDown write SetDown;
    property Disabled: Integer read FDisabled write SetDisabled;
  end;

  TDControl = class(TCustomControl)
  protected
    bMouseMove: Boolean;
    FIsManager: Boolean;
    FPageActive: Boolean;
    FCaption: string;
    FDParent: TDControl;
    FEnableFocus: Boolean;
    FOnDirectPaint: TOnDirectPaint;
    FOnEndDirectPaint: TOnDirectPaint;
    FOnKeyPress: TOnKeyPress;
    FOnKeyDown: TOnKeyDown;
    FOnMouseMove: TOnMouseMove;
    FOnMouseDown: TOnMouseDown;
    FOnMouseUp: TOnMouseUp;
    FOnDblClick: TNotifyEvent;
    FOnClick: TOnClickEx;
    FOnEnter: TOnEnter;
    FOnLeave: TOnLeave;
    FOnInRealArea: TOnInRealArea;
    FOnBackgroundClick: TOnClick;
    FOnProcess: TNotifyEvent;
    procedure SetCaption(Str: string);
    function GetMouseMove: Boolean;
    function GetClientRect: TRect; override;
  private
    FCaptionHeight: Integer;
    FCaptionWidth: Integer;
  protected
    FVisible: Boolean;
    procedure CaptionChaged; dynamic;
  public
    ReloadTex: Boolean;
    ImageSurface: TAsphyreLockableTexture;
    Background: Boolean;
    DControls: TList;
    WLib: TWMImages;
    FaceIndex: Integer; //默认
    MoveIndex: Integer; //经过序号
    DownIndex: Integer; //按下序号
    DisabledIndex: Integer; //禁用
    CheckedIndex: Integer;
    AniCount: integer;
    AniInterval: integer;
    DecText: string;
    FaceName: string;
    FRightClick: Boolean;
    WantReturn: Boolean;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Loaded; override;
    procedure Process; dynamic;
    function SurfaceX(X: Integer): Integer;
    function SurfaceY(Y: Integer): Integer;
    function LocalX(X: Integer): Integer;
    function LocalY(Y: Integer): Integer;
    procedure AddChild(dcon: TDControl);
    procedure ChangeChildOrder(dcon: TDControl);
    function InRange(X, Y: Integer; Shift: TShiftState): Boolean; dynamic;
    function KeyPress(var Key: Char): Boolean; virtual;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; virtual;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; virtual;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; virtual;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; virtual;
    function DblClick(X, Y: Integer): Boolean; virtual;
    function Click(X, Y: Integer): Boolean; virtual;
    function CanFocusMsg: Boolean;
    procedure Leave(); dynamic;
    procedure Enter(); dynamic;
    procedure AdjustPos(X, Y: Integer); overload;
    procedure AdjustPos(X, Y, W, H: Integer); overload;
    procedure SetImgIndex(Lib: TWMImages; Index: Integer); overload;
    procedure SetImgIndex(Lib: TWMImages; Index, X, Y: Integer); overload;
    procedure DirectPaint(dsurface: TAsphyreCanvas); virtual;
    property PageActive: Boolean read FPageActive write FPageActive;
    property MouseMoveing: Boolean read GetMouseMove;
    property ClientRect: TRect read GetClientRect;
    procedure DragModePaint(dsurface: TAsphyreCanvas);
  published
    property OnProcess: TNotifyEvent read FOnProcess write FOnProcess;
    property OnDirectPaint: TOnDirectPaint read FOnDirectPaint write FOnDirectPaint;
    property OnEndDirectPaint: TOnDirectPaint read FOnEndDirectPaint write FOnEndDirectPaint;
    property OnKeyPress: TOnKeyPress read FOnKeyPress write FOnKeyPress;
    property OnKeyDown: TOnKeyDown read FOnKeyDown write FOnKeyDown;
    property OnMouseMove: TOnMouseMove read FOnMouseMove write FOnMouseMove;
    property OnMouseDown: TOnMouseDown read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TOnMouseUp read FOnMouseUp write FOnMouseUp;
    property OnEnter: TOnEnter read FOnEnter write FOnEnter;
    property OnLeave: TOnLeave read FOnLeave write FOnLeave;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnInRealArea: TOnInRealArea read FOnInRealArea write FOnInRealArea;
    property OnBackgroundClick: TOnClick read FOnBackgroundClick write FOnBackgroundClick;
    property Caption: string read FCaption write SetCaption;
    property DParent: TDControl read FDParent write FDParent;
    property Visible: Boolean read FVisible write FVisible;
    property EnableFocus: Boolean read FEnableFocus write FEnableFocus;
    property CaptionWidth:Integer read FCaptionWidth;
    property CaptionHeight:Integer read FCaptionHeight;
    property Color;
    property Font;
    property Hint;
    property ShowHint;
    property Align;
  end;

  TDButton = class(TDControl)
  private
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
    FButtonStyle: TButtonStyle;
    FOnbtnState: TDBtnState;
  public
    FFloating: Boolean;
    CaptionEx: string;
    Downed: Boolean;
    Arrived: Boolean;
    SpotX, SpotY: Integer;
    Clicked: Boolean;
//    ClickInv: LongWord;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
    property Floating: Boolean read FFloating write FFloating;
    property OnbtnState: TDBtnState read FOnbtnState write FOnbtnState;     //改变这里//    btnState: TDBtnState;

  end;
  TDCheckBox = class(TDControl)
  private
    FArrived: Boolean;
    FChecked: Boolean;
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
  public
    Downed: Boolean;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    property Checked: Boolean read FChecked write FChecked;
    property Arrived: Boolean read FArrived write FArrived;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDCustomControl = class(TDControl)
  protected
    FEnabled: Boolean;
    FTransparent: Boolean;
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
    FFrameVisible: Boolean;
    FFrameHot: Boolean;
    FFrameSize: byte;
    FFrameColor: TColor;
    FFrameHotColor: TColor;
    procedure SetTransparent(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetFrameVisible(Value: Boolean);
    procedure SetFrameHot(Value: Boolean);
    procedure SetFrameSize(Value: byte);
    procedure SetFrameColor(Value: TColor);
    procedure SetFrameHotColor(Value: TColor);
  protected
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Transparent: Boolean read FTransparent write SetTransparent default True;
    property FrameVisible: Boolean read FFrameVisible write SetFrameVisible default True;
    property FrameHot: Boolean read FFrameHot write SetFrameHot default False;
    property FrameSize: byte read FFrameSize write SetFrameSize default 1;
    property FrameColor: TColor read FFrameColor write SetFrameColor default $004A8494;
    property FrameHotColor: TColor read FFrameHotColor write SetFrameHotColor default $00599AA8;
  public
    Downed: Boolean;
    procedure OnDefaultEnterKey;
    procedure OnDefaultTabKey;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDHint = class(TDCustomControl)
  private
    FItems: TStrings;
    FBackColor: TColor;
    FSelectionColor: TColor;
    FParentControl: TDControl;
    function GetItemSelected: Integer;
    procedure SetItems(Value: TStrings);
    procedure SetBackColor(Value: TColor);
    procedure SetSelectionColor(Value: TColor);
    procedure SetItemSelected(Value: Integer);
  public
    FSelected: Integer;
    FOnChangeSelect: procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
    FOnMouseMoveSelect: procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
    property Items: TStrings read FItems write SetItems;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clSilver;
    property ItemSelected: Integer read GetItemSelected write SetItemSelected;
    property ParentControl: TDControl read FParentControl write FParentControl;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
  end;

  TDGrid = class(TDControl)
  private
    FColCount, FRowCount: Integer;
    FColWidth, FRowHeight: Integer;
    FColoffset, FRowoffset: Integer;
    FViewTopLine: Integer;
    SelectCell: TPoint;
    DownPos: TPoint;
    FOnGridSelect: TOnGridSelect;
    FOnGridMouseMove: TOnGridSelect;
    FOnGridPaint: TOnGridPaint;
    FOnButton: TMouseButton;
    function GetColRow(X, Y: Integer; var ACol, ARow: Integer): Boolean;
  public
    cx, cy: Integer;
    Col, Row: Integer;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function Click(X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
  published
    property ColCount: Integer read FColCount write FColCount;
    property RowCount: Integer read FRowCount write FRowCount;
    property ColWidth: Integer read FColWidth write FColWidth;
    property RowHeight: Integer read FRowHeight write FRowHeight;
    property Coloffset: integer read FColoffset write FColoffset;
    property Rowoffset: integer read FRowoffset write FRowoffset;
    property ViewTopLine: Integer read FViewTopLine write FViewTopLine;
    property OnGridSelect: TOnGridSelect read FOnGridSelect write FOnGridSelect;
    property OnGridMouseMove: TOnGridSelect read FOnGridMouseMove write FOnGridMouseMove;
    property OnGridPaint: TOnGridPaint read FOnGridPaint write FOnGridPaint;
    property OnButton: TMouseButton read FOnButton write FOnButton;
  end;

  TDWindow = class(TDButton)
  private
    FFloating: Boolean;
  protected
    procedure SetVisible(flag: Boolean);
  public
    FMoveRange: Boolean;
    SpotX, SpotY: Integer;
    DialogResult: TModalResult;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Show;
    function ShowModal: Integer;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Floating: Boolean read FFloating write FFloating;
  end;

  TDMoveButton = class(TDButton)
  private
    FFloating: Boolean;
    SpotX, SpotY: Integer;
  protected
    procedure SetVisible(flag: Boolean);
  public
    DialogResult: TModalResult;
    FOnClick: TOnClickEx;
    SlotLen: Integer;
    RLeft: Integer;
    RTop: Integer;
    Position: Integer;
    outHeight: Integer;
    Max: Integer;
    Reverse: Boolean;
    LeftToRight: Boolean;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Show;
    function ShowModal: Integer;
    procedure UpdatePos(pos: Integer; force: Boolean = False);
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Floating: Boolean read FFloating write FFloating;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property FBoxMoveTop: Integer read SlotLen write SlotLen;
    property TypeRLeft: Integer read RLeft write RLeft;
    property TypeRTop: Integer read RTop write RTop;
    property TReverse: Boolean read Reverse write Reverse;
  end;

  TDComboBox = class;
  TASPCustomListBox = class(TDCustomControl)
  private
    FItems: TStrings;
    FBackColor: TColor;
    FSelectionColor: TColor;
    FParentComboBox: TDComboBox;
    function GetItemSelected: Integer;
    procedure SetItems(Value: TStrings);
    procedure SetBackColor(Value: TColor);
    procedure SetSelectionColor(Value: TColor);
    procedure SetItemSelected(Value: Integer);
  public
    ChangingHero: Boolean;
    FSelected: Integer;
    FOnChangeSelect: procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
    FOnMouseMoveSelect: procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
    property Items: TStrings read FItems write SetItems;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clSilver;
    property ItemSelected: Integer read GetItemSelected write SetItemSelected;
    property ParentComboBox: TDComboBox read FParentComboBox write FParentComboBox;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
  end;

  TDListBox = class(TASPCustomListBox)
  published
    property Enabled;
    property Transparent;
    property BackColor;
    property SelectionColor;
    property FrameVisible;
    property FrameHot;
    property FrameSize;
    property FrameColor;
    property FrameHotColor;
    property ParentComboBox;
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

//  TAlignment = (taCenter, taLeftJustify );
  TDCustomEdit = class(TDCustomControl)
  private
    FAtom: Word;
    FHotKey: Cardinal;
    FIsHotKey: Boolean;
    FAlignment: TAlignment;
    FClick: Boolean;
    FSelClickStart: Boolean;
    FSelClickEnd: Boolean;
    FCurPos: Integer;
    FClickX: Integer;
    FSelStart: Integer;
    FSelEnd: Integer;
    FStartTextX: Integer;
    FSelTextStart: Integer;
    FSelTextEnd: Integer;
    FMaxLength: Integer;
    FShowCaretTick: LongWord;
    FShowCaret: Boolean;
    FNomberOnly: Boolean;
    FSecondChineseChar: Boolean;
    FPasswordChar: Char;
    FOnTextChanged: TOnTextChanged;
    FFontSelColor: TColor;
    procedure SetSelStart(Value: Integer);
    procedure SetSelEnd(Value: Integer);
    procedure SetMaxLength(Value: Integer);
    procedure SetPasswordChar(Value: Char);
    procedure SetNomberOnly(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure SetIsHotKey(Value: Boolean);
    procedure SetHotKey(Value: Cardinal);
    procedure SetAtom(Value: Word);
    procedure SetSelLength(Value: Integer);
    function ReadSelLength(): Integer;
    procedure SetFontSelColor(Value: TColor);
  protected
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property NomberOnly: Boolean read FNomberOnly write SetNomberOnly default False;
    property IsHotKey: Boolean read FIsHotKey write SetIsHotKey default False;
    property Atom: Word read FAtom write SetAtom default 0;
    property HotKey: Cardinal read FHotKey write SetHotKey default 0;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property PasswordChar: Char read FPasswordChar write SetPasswordChar default #0;
  public
    DHint: TDHint;
    m_InputHint: string;
    FMiniCaret: byte;
    FCaretColor: TColor;
    procedure ShowCaret();
    procedure SetFocus(); override;
    procedure Enter(); override;
    procedure Leave(); override;
    procedure ChangeCurPos(nPos: Integer; boLast: Boolean = False);
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
    function KeyPress(var Key: Char): Boolean; override;
    function KeyPressEx(var Key: Char): Boolean;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    function SetOfHotKey(HotKey: Cardinal): Word;
    property Text: string read FCaption write SetCaption;
    property SelStart: Integer read FSelStart write SetSelStart;
    property SelEnd: Integer read FSelEnd write SetSelEnd;
    property SelLength: Integer read ReadSelLength write SetSelLength;
    property FontSelColor: TColor read FFontSelColor write SetFontSelColor default clWhite;
  published
    property OnTextChanged: TOnTextChanged read FOnTextChanged write FOnTextChanged;
  end;

  TDEdit = class(TDCustomEdit)
  published
    property Alignment;
    property IsHotKey;
    property HotKey;
    property Enabled;
    property MaxLength;
    property NomberOnly;
    property Transparent;
    property PasswordChar;
    property FrameVisible;
    property FrameHot;
    property FrameSize;
    property FrameColor;
    property FrameHotColor;
    property OnEnter;
    property OnLeave;
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDComboBox = class(TDCustomEdit)
  private
    FDropDownList: TDListBox;
  protected
  public
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  published
    property Enabled;
    property MaxLength;
    property NomberOnly;
    property Transparent;
    property PasswordChar;
    property FrameVisible;
    property FrameHot;
    property FrameSize;
    property FrameColor;
    property FrameHotColor;
    property OnEnter;
    property OnLeave;
    property DropDownList: TDListBox read FDropDownList write FDropDownList;
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDUpDown = class(TDButton)
  private
    FUpButton: TDButton;
    FDownButton: TDButton;
    FMoveButton: TDButton;
    FPosition: Integer;
    FMaxPosition: Integer;
    FOnPositionChange: TOnClick;
    FTop: Integer;
    FAddTop: Integer;
    FMaxLength: Integer;
    FOffset: Integer;
    FBoMoveShow: Boolean;
    FboMoveFlicker: Boolean;
    FboNormal: Boolean;
    StopY: Integer;
    FStopY: Integer;
    FClickTime: LongWord;
    FMovePosition: Integer;
    procedure SetButton(Button: TDButton);
    procedure SetPosition(value: Integer);
    procedure SetMaxPosition(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    function MouseWheel(Shift: TShiftState; Wheel: TMouseWheel; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure ButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure ButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    property UpButton: TDButton read FUpButton;
    property DownButton: TDButton read FDownButton;
    property MoveButton: TDButton read FMoveButton;
  published
    property Position: Integer read FPosition write SetPosition;
    property Offset: Integer read FOffset write FOffset;
    property Normal: Boolean read FboNormal write FboNormal;
    property MovePosition: Integer read FMovePosition write FMovePosition;
    property MoveShow: Boolean read FBoMoveShow write FBoMoveShow;
    property MaxPosition: Integer read FMaxPosition write SetMaxPosition;
    property MoveFlicker: Boolean read FboMoveFlicker write FboMoveFlicker;
    property OnPositionChange: TOnClick read FOnPositionChange write FOnPositionChange;
  end;

  TDMemo = class(TDControl)
  private
    FLines: TStrings;
    FOnChange: TOnClick;
    FReadOnly: Boolean;
    FFrameColor: TColor;
    FCaretShowTime: LongWord;
    FCaretShow: Boolean;
    FTopIndex: Integer;
    FCaretX: Integer;
    FCaretY: Integer;
    FSCaretX: Integer;
    FSCaretY: Integer;
    FUpDown: TDUpDown;
    FMoveTick: LongWord;
    FInputStr: string;
    bDoubleByte: Boolean;
    KeyByteCount: Integer;
    FTransparent: Boolean;
    FMaxLength: integer;
    procedure DownCaret(X, Y: Integer);
    procedure MoveCaret(X, Y: Integer);
    procedure KeyCaret(Key: Word);
    procedure SetUpDown(const Value: TDUpDown);
    procedure SetCaret(boBottom: Boolean);
    function ClearKey(): Boolean;
    function GetKey(): string;
    procedure SetCaretY(const Value: Integer);
  public
    DHint: TDHint;
    Downed: Boolean;
    KeyDowned: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
    function KeyPress(var Key: Char): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure SetFocus();
    procedure PositionChange(Sender: TObject);
    procedure TextChange();
    property Lines: TStrings read FLines;
    property ItemIndex: Integer read FCaretY write SetCaretY;
    procedure RefListWidth(ItemIndex: Integer; nCaret: Integer);
  published
    property OnChange: TOnClick read FOnChange write FOnChange;
    property ReadOnly: Boolean read FReadOnly write FReadOnly default False;
    property FrameColor: TColor read FFrameColor write FFrameColor;
//    property TopIndex: Integer read FTopIndex write FTopIndex;
    property UpDown: TDUpDown read FUpDown write SetUpDown;
    property boTransparent: Boolean read FTransparent write FTransparent;
    property MaxLength: Integer read FMaxLength write FMaxLength default 0;
  end;

  TDMemoStringList = class(TStringList)
    DMemo: TDMemo;
  private
    procedure Put(Index: Integer; const Value: string);
    function SelfGet(Index: Integer): string;
  published
  public
    function Add(const S: string): Integer; override;
    function AddObject(const S: string; AObject: TObject): Integer; override;
    procedure InsertObject(Index: Integer; const S: string;  AObject: TObject); override;
    function Get(Index: Integer): string; override;
    function GetText: PChar; override;
    procedure LoadFromFile(const FileName: string); override;
    procedure SaveToFile(const FileName: string); override;
    property Str[Index: Integer]: string read SelfGet write Put; default;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
  end;

  TDLabel = class(TDControl)
  private
    FText: string;                  //显示的字符串 不用标题显示
    FAutoSize: Boolean;             //自动更改边框大小
    FAlignment: TAlignment;         //显示位置
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaptionChaged(Value: Boolean);
    procedure SetText(str: string);
  public
    Downed: Boolean;
    OldText: string;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
  published
    property AutoSize: Boolean read FAutoSize write SetCaptionChaged;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property Text: string read FText write SetText;
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TViewItem = record
    Caption: string;
    Data: Pointer;
    Style: TButtonStyle;
    Checked: Boolean;
    Color: TDCaptionColor;
    ImageIndex: TDImageIndex;
    Down, Move: Boolean;
    Transparent: Boolean;
    WLib: TWMImages;
    TimeTick: LongWord;
  end;
  pTViewItem = ^TViewItem;

  TDListItem = class;
  TOnListItem = procedure(Sender: TObject; ARow, ACol: Integer; ListItem: TDListItem; ViewItem: pTViewItem) of object;

  TDListItem = class(TStringList)
  private
    FItemList: array of TViewItem;
    function GetItem(Index: Integer): pTViewItem;
  public
    constructor Create;
    destructor Destroy; override;
    function AddObject(const S: string; AObject: TObject): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure InsertObject(Index: Integer; const S: string; AObject: TObject); override;
    function AddItem(const S: string; AObject: TObject): pTViewItem;
    property Items[Index: Integer]: pTViewItem read GetItem;
  end;

 TDChatMemoLines = class(TStringList)
  private
    FItemList: array of TViewItem;
    FItemHeightList: array of Integer;
    function GetItem(Index: Integer): pTViewItem;
    function GetItemHeight(Index: Integer): Integer;
    procedure SetItemHeight(Index: Integer; Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function AddObject(const S: string; AObject: TObject): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure InsertObject(Index: Integer; const S: string; AObject: TObject); override;
    function AddItem(const S: string; AObject: TObject): pTViewItem;
    property Items[Index: Integer]: pTViewItem read GetItem;
    property ItemHeights[Index: Integer]: Integer read GetItemHeight write SetItemHeight;
  end;

  TDChatMemo = class(TDControl) //聊天框专用
  private
    Downed: Boolean;
    FShowScroll: Boolean;
    FScrollSize: Integer;
    FItemHeight: Integer;
    FItemIndex: Integer;
    FOnChange: TNotifyEvent;
    FLines: TStrings;
    FTopLines: TStrings;
    FAutoScroll: Boolean;
    FTopIndex: Integer;
    FPosition: Integer;
    FFontBackTransparent: Boolean;
    FOffSetX, FOffSetY: Integer;
    FDrawLineCount: Integer;
    FBarTop: Integer;
    FPrevMouseDown: Boolean;
    FNextMouseDown: Boolean;
    FBarMouseDown: Boolean;
    FScrollMouseDown: Boolean;
    FPrevMouseMove: Boolean;
    FNextMouseMove: Boolean;
    FBarMouseMove: Boolean;
    FScrollImageIndex: TDImageIndex;
    FPrevImageIndex: TDImageIndex;
    FNextImageIndex: TDImageIndex;
    FBarImageIndex: TDImageIndex;
    FPrevImageSize: Integer;
    FNextImageSize: Integer;
    FBarImageSize: Integer;
    FVisibleItemCount: Integer;
    FExpandSize: Integer;
    procedure ScrollImageIndexChange(Sender: TObject);
    procedure PrevImageIndexChange(Sender: TObject);
    procedure NextImageIndexChange(Sender: TObject);
    procedure BarImageIndexChange(Sender: TObject);
    procedure SetExpandSize(Value: Integer);
    procedure SetLines(Value: TStrings);
    procedure SetTopLines(Value: TStrings);
    procedure SetScrollSize(Value: Integer);
    procedure SetItemIndex(Value: Integer);
    procedure SetItemHeight(Value: Integer);
    procedure SetPosition(Value: Integer);
    function GetVisibleHeight: Integer;
    procedure SetVisibleItemCount(Value: Integer);
    function InPrevRange(X, Y: Integer): Boolean;
    function InNextRange(X, Y: Integer): Boolean;
    function InBarRange(X, Y: Integer): Boolean;
  protected
    procedure DoScroll(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function MaxValue: Integer;
    procedure Next;
    procedure Previous;
    procedure First;
    procedure Last;
    procedure DirectPaint (dsurface: TAsphyreCanvas); override;
    function  MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure LoadFromFile(const FileName: string);
    procedure Add(const S: string; FC, BC: TColor);
    procedure Insert(Index: Integer; const S: string; FC, BC: TColor);
    procedure Delete(Index: Integer);
    procedure AddTop(const S: string; FC, BC: TColor; TimeOut: Integer);
    procedure InsertTop(Index: Integer; const S: string; FC, BC: TColor; TimeOut: Integer);
    procedure DeleteTop(Index: Integer);
    procedure DoResize();
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    procedure Clear;
    property TopIndex: Integer read FTopIndex write FTopIndex;
    property FontBackTransparent: Boolean read FFontBackTransparent write FFontBackTransparent;
    property VisibleHeight: Integer read GetVisibleHeight;
  published
    property Position: Integer read FPosition write SetPosition;
    property OffSetX: Integer read FOffSetX write FOffSetX;
    property OffSetY: Integer read FOffSetY write FOffSetY;
    property ScrollImageIndex: TDImageIndex read FScrollImageIndex write FScrollImageIndex;
    property PrevImageIndex: TDImageIndex read FPrevImageIndex write FPrevImageIndex;
    property NextImageIndex: TDImageIndex read FNextImageIndex write FNextImageIndex;
    property BarImageIndex: TDImageIndex read FBarImageIndex write FBarImageIndex;
    property ShowScroll: Boolean read FShowScroll write FShowScroll;
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property ScrollSize: Integer read FScrollSize write SetScrollSize;
    property Lines: TStrings read FLines write SetTopLines;
    property TopLines: TStrings read FTopLines write SetLines;
    property AutoScroll: Boolean read FAutoScroll write FAutoScroll;
    property DrawLineCount: Integer read FDrawLineCount write FDrawLineCount; //显示列表行数
    property VisibleItemCount: Integer read FVisibleItemCount write SetVisibleItemCount;
    property ExpandSize: Integer read FExpandSize write SetExpandSize;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TDTime = class(TDControl)
  private
    FText: WideString;
    FAlignment: TAlignment;         //显示位置
    procedure SetText(Value: string);
    function GetText(): string;
    procedure SetAlignment(const Value: TAlignment);
  public
    constructor Create(AOwner: TComponent); override;
    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
    property Text: string read GetText write SetText;
   published
    property Alignment: TAlignment read FAlignment write SetAlignment;
  end;
  // 动画按钮
  TDAniButton = class(TDButton)
  private
    FAniCount: Word;                          //播放图片数量
    FAniInterval: Cardinal;                   //播放图片间隔
    FAniLoop: Boolean;                        //是否循环 {循环不会触发结束事件}
    FOffsetX, FOffsetY: Integer;              //偏移坐标X Y
    FStart: Boolean;                          //控制是否开始绘制
    FFrameIndex: Integer;                     //帧索引当前绘制在第几帧
//    FOnAniDirectPaintBegin: TOnAniDirectPaint;//动画开始绘制触发事件()
//    FOnAniDirectPaintReset: TOnAniDirectPaint;//动画重置绘制触发事件()
//    FOnAniDirectPaintEnd: TOnAniDirectPaint;  //动画结束绘制触发事件()
    FChangeFrameTime: Cardinal;
    FDrawMode: TBlendingEffect;
    FClipType: TClipType; // 裁剪类型
    FClipOrientation: TClipOrientation;
    FDynamicClipValue:Single; //动态裁剪值
    FAniOverHide : Boolean; //动画结束隐藏
    function GetClipType: TClipType;
    procedure SetClipType(const Value: TClipType);
    function GetClipOrientation: TClipOrientation;
    procedure SetClipOrientation(const Value: TClipOrientation);
    function GetDrawFrameIndex: integer;
  public
    constructor Create(aowner: TComponent); override;
    procedure DirectPaint(DSurface: TAsphyreCanvas); override;
//    procedure Start();                        //绘制开始 唤醒
//    procedure Reset();                        //绘制重置
//    procedure Over();                         //绘制结束 结束
    property FrameIndex: integer read GetDrawFrameIndex;
  published
    property AniCount: Word read FAniCount write FAniCount;
    property AniInterval: Cardinal read FAniInterval write FAniInterval;
    property AniLoop: Boolean read FAniLoop write FAniLoop;
    property OffsetX: Integer read FOffsetX write FOffsetX;
    property OffsetY: Integer read FOffsetY write FOffsetY;
    property DrawMode: TBlendingEffect read FDrawMode write FDrawMode;
    property ClipType: TClipType read GetClipType write SetClipType;
    property DynamicClipValue:Single read FDynamicClipValue write FDynamicClipValue;
    property AniOverHide : Boolean read FAniOverHide write FAniOverHide;
    property ClipOrientation: TClipOrientation read GetClipOrientation write SetClipOrientation;
//    property OnAniDirectPaintBegin: TOnAniDirectPaint read FOnAniDirectPaintBegin write FOnAniDirectPaintBegin;
//    property OnAniDirectPaintReset: TOnAniDirectPaint read FOnAniDirectPaintReset write FOnAniDirectPaintReset;
//    property OnAniDirectPaintEnd: TOnAniDirectPaint read FOnAniDirectPaintEnd write FOnAniDirectPaintEnd;
  end;

  TDWinManager = class
  private
  public
    DWinList: TList;
    constructor Create;
    destructor Destroy; override;
    procedure AddDControl(dcon: TDControl; Visible: Boolean);
    procedure DelDControl(dcon: TDControl);
    procedure ClearAll;
    procedure Process;
    function KeyPress(var Key: Char): Boolean;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function DblClick(X, Y: Integer): Boolean;
    function Click(X, Y: Integer): Boolean;
    procedure DirectPaint(dsurface: TAsphyreCanvas);
  end;

procedure Register;
procedure SetDFocus(dcon: TDControl);
procedure ReleaseDFocus;
procedure SetDCapture(dcon: TDControl);
procedure ReleaseDCapture;

var
  g_DWinMan: TDWinManager;
  MouseCaptureControl: TDControl;
  FocusedControl: TDControl;
  MouseMoveControl: TDControl;
  MainWinHandle: Integer;
  ModalDWindow: TDControl;
  g_MainHWnd: HWnd;
  LastMenuControl: TDEdit = nil;
  g_TranFrame  : Boolean=False;
  GetClipValueProc: TOnGetClipValue;
  GUIFScreenWidth:Integer=800;
  GUIFScreenHeight:Integer=600;

implementation

procedure Register;
begin
  RegisterComponents('HGEGUI', [TDButton, TDCheckBox, TDMemo, TDLabel, TDUpDown,
  TDChatMemo, TDTime, TDAniButton, TDGrid, TDWindow, TDMoveButton, TDEdit,
  TDComboBox, TDListBox, TDHint]);
end;

procedure SetDFocus(dcon: TDControl);
begin
  if ( dcon.FEnableFocus)and(FocusedControl <> dcon) then begin
    if (FocusedControl <> nil) then
      FocusedControl.Leave;
    dcon.Enter;
  end;
  FocusedControl := dcon;
end;

procedure ReleaseDFocus;
begin
  if (FocusedControl <> nil) then begin
    FocusedControl.Leave;
  end;
  FocusedControl := nil;
end;

procedure SetDCapture(dcon: TDControl);
begin
    if dcon = nil then begin
    ReleaseDFocus;
  end else begin
    MouseCaptureControl := dcon;
  end;
end;
//释放鼠标捕获
procedure ReleaseDCapture;
begin
  ReleaseCapture;
  MouseCaptureControl := nil;
end;

constructor TDControl.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  DParent := nil;
  inherited Visible := False;
  FEnableFocus := False;
  Background := False;
  FIsManager := False;
  bMouseMove := False;
  FOnDirectPaint := nil;
  FOnEndDirectPaint := nil;
  FOnKeyPress := nil;
  FOnKeyDown := nil;
  FOnMouseMove := nil;
  FOnMouseDown := nil;
  FOnMouseUp := nil;
  FOnEnter:= nil;
  FOnLeave:= nil;
  FOnInRealArea := nil;
  DControls := TList.Create;
  FDParent := nil;
  FCaptionWidth:=0;
  FCaptionHeight:=0;
  Width := 80;
  Height := 24;
  FCaption := '';
  FVisible := True;
  WLib := nil;
  ImageSurface := nil;
  FaceIndex := -1;
  FaceName := '';
  PageActive := False;
  FRightClick := False;
  ReloadTex := False;
end;

destructor TDControl.Destroy;
begin
  if Self = MouseMoveControl then
    MouseMoveControl := nil;
  DControls.Free;
  inherited Destroy;
end;

procedure TDControl.SetCaption(Str: string);
begin
  FCaption := str;
  if FCaption<>'' then
  begin
   FCaptionWidth:= Canvas.TextWidth(FCaption)+ Width;
   FCaptionHeight:= MAX(Height,Canvas.TextHeight(FCaption));
  end;
  if csDesigning in ComponentState then begin
    Refresh;
   end  else
  CaptionChaged;
end;

function TDControl.GetMouseMove: Boolean;
begin
  Result := MouseMoveControl = Self;
end;

function TDControl.GetClientRect: TRect;
begin
  Result.Left := SurfaceX(Left);
  Result.Top := SurfaceY(Top);
  Result.Right := Result.Left + Width;
  Result.Bottom := Result.Top + Height;
end;

procedure TDControl.AdjustPos(X, Y: Integer);
begin
  Top := Y;
  Left := X;
end;

procedure TDControl.AdjustPos(X, Y, W, H: Integer);
begin
  Left := X;
  Top := Y;
  Width := W;
  Height := H;
end;

procedure TDControl.Paint;
begin
  if csDesigning in ComponentState then
  begin
    if self is TDWindow then
    begin
      with Canvas do
      begin
        FillRect(ClipRect);
        Pen.Color := clBlack;
        MoveTo(0, 0);
        LineTo(Width - 1, 0);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, 0);
        LineTo(Width - 1, Height - 1);
        MoveTo(Width - 1, 0);
        LineTo(0, Height - 1);
        TextOut((Width - TextWidth(Caption)) div 2, (Height - TextHeight(Caption)) div 2, Caption);
      end;
    end  else
    begin
      with Canvas do
      begin
        FillRect(ClipRect);
        Pen.Color := clBlack;
        MoveTo(0, 0);
        LineTo(Width - 1, 0);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, 0);
        SetBkMode(Handle, TRANSPARENT);
        Font.Color := self.Font.Color;
        TextOut((Width - TextWidth(Caption)) div 2, (Height - TextHeight(Caption)) div 2, Caption);
      end;
    end;
  end;
end;

procedure TDControl.Leave();
begin
  if Assigned(FOnLeave) then
    FOnLeave(Self);
end;

procedure TDControl.Loaded;
var
  i: integer;
  dcon: TDControl;
begin
  if not (csDesigning in ComponentState) then begin
    if Parent <> nil then
      for i := 0 to TControl(Parent).ComponentCount - 1 do begin
        if TControl(Parent).Components[i] is TDControl then begin
          dcon := TDControl(TControl(Parent).Components[i]);
          if dcon.DParent = self then begin
            AddChild(dcon);
          end;
        end;
      end;
  end;
end;

procedure TDControl.Process;
var
  I: Integer;
begin
  if Assigned(FOnProcess) then
    FOnProcess(Self);
  for I := 0 to DControls.Count - 1 do
    if TDControl(DControls[I]).Visible then
      TDControl(DControls[I]).Process;
end;

function TDControl.SurfaceX(x: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while TRUE do begin
    if d.DParent = nil then break;
    x := x + d.DParent.Left;
    d := d.DParent;
  end;
  Result := x;
end;

function TDControl.SurfaceY(y: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while TRUE do begin
    if d.DParent = nil then break;
    y := y + d.DParent.Top;
    d := d.DParent;
  end;
  Result := y;
end;

function TDControl.LocalX(x: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while TRUE do begin
    if d.DParent = nil then break;
    x := x - d.DParent.Left;
    d := d.DParent;
  end;
  Result := x;
end;

function TDControl.LocalY(y: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while TRUE do begin
    if d.DParent = nil then break;
    y := y - d.DParent.Top;
    d := d.DParent;
  end;
  Result := y;
end;

procedure TDControl.AddChild(dcon: TDControl);
begin
  DControls.Add(Pointer(dcon));
end;
procedure TDControl.ChangeChildOrder(dcon: TDControl);
var
  i: integer;
begin
  if not (dcon is TDWindow) then exit;
  if TDWindow(dcon).Floating then begin
    for i := 0 to DControls.Count - 1 do begin
      if dcon = DControls[i] then begin
        DControls.Delete(i);
        break;
      end;
    end;
    DControls.Add(dcon);
  end;
end;

function TDControl.InRange(X, Y: Integer; Shift: TShiftState): Boolean;
var
  boInRange: Boolean;
  d: TAsphyreLockableTexture;
begin
  if (X >= Left) and (X < (Left + Width)) and (Y >= Top) and (Y < (Top + Height)) and
  (((ssRight in Shift) and FRightClick) or not (ssRight in Shift))
  then
  begin
    boInRange := True;
    if Assigned(FOnInRealArea) then
      FOnInRealArea(self, X - Left, Y - Top, boInRange)
    else if ImageSurface <> nil then
    begin
      if ImageSurface.Pixels[X - Left, Y - Top] <= 0 then
        boInRange := False;
    end
    else if WLib <> nil then
    begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
      begin
        if d.Pixels[X - Left, Y - Top] <= 0 then
          boInRange := False;
      end;
    end;
    Result := boInRange;
  end
  else
    Result := False;
end;

function TDControl.KeyPress(var Key: Char): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Background then
    Exit;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).KeyPress(Key) then
      begin
        Result := True;
        Exit;
      end;
  if (FocusedControl = self) then
  begin
    if Assigned(FOnKeyPress) then
      FOnKeyPress(self, Key);
    Result := True;
  end;
end;

function TDControl.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Background then
    Exit;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).KeyDown(Key, Shift) then
      begin
        Result := True;
        Exit;
      end;
  if (FocusedControl = self) then
  begin
    if Assigned(FOnKeyDown) then
      FOnKeyDown(self, Key, Shift);
    Result := True;
  end;
end;

function TDControl.CanFocusMsg: Boolean;
begin
  if (MouseCaptureControl = nil) or ((MouseCaptureControl <> nil) and ((MouseCaptureControl = self) or (MouseCaptureControl = DParent))) then
    Result := True
  else
    Result := False;
end;

procedure TDControl.CaptionChaged;
begin
end;

function TDControl.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
  dc: TDControl;
begin
  Result := False;
  for i := DControls.count - 1 downto 0 do
  begin
    dc := TDControl(DControls[i]);
    if dc.Visible then
    begin
      if (ssRight in Shift) and not dc.FRightClick then
        Continue;
      if dc.MouseMove(Shift, X - Left, Y - Top) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
  if (MouseCaptureControl <> nil) then
  begin
    if (MouseCaptureControl = self) then
    begin
      if (ssRight in Shift) and not FRightClick then
        Exit;
      if not bMouseMove and Assigned(FOnMouseMove) then
        FOnMouseMove(self, Shift, X, Y);
      Result := True;
    end;
    Exit;
  end;
  if Background then
    Exit;
  if InRange(X, Y, Shift) then
  begin
    MouseMoveControl := Self;
    if not bMouseMove and Assigned(FOnMouseMove) then
      FOnMouseMove(self, Shift, X, Y);
    Result := True;
  end;
end;

function TDControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
  dc: TDControl;
begin
  Result := False;
  for i := DControls.count - 1 downto 0 do
  begin
    dc := TDControl(DControls[i]);
    if dc.Visible then
    begin
      if dc.MouseDown(Button, Shift, X - Left, Y - Top) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
  if Background then
  begin
    if Assigned(FOnBackgroundClick) then
    begin
      WantReturn := False;
      FOnBackgroundClick(self);
      if WantReturn then
        Result := True;
    end;
    ReleaseDFocus;
    Exit;
  end;
  if CanFocusMsg then
  begin
    if InRange(X, Y, Shift) or (MouseCaptureControl = self) then
    begin
      MouseMoveControl := nil;
      if (Button = mbRight) and not FRightClick then
        Exit;
      if Assigned(FOnMouseDown) then
        FOnMouseDown(self, Button, Shift, X, Y);
      if EnableFocus then
      begin
        if (self is TDHint) and (TDHint(self).ParentControl <> nil) then
        begin
          SetDFocus(TDHint(self).ParentControl);
        end
        else
          SetDFocus(self);
      end;
      Result := True;
    end;
  end;
end;

function TDControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
  dc: TDControl;
begin
  Result := False;
  for i := DControls.count - 1 downto 0 do
  begin
    dc := TDControl(DControls[i]);
    if dc.Visible then
    begin
      if (dc is TDHint) then
        dc.Visible := False;
      if (Button = mbRight) and not dc.FRightClick then
        Continue;
      if dc.MouseUp(Button, Shift, X - Left, Y - Top) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
  if (MouseCaptureControl <> nil) then
  begin
    if (MouseCaptureControl = self) then
    begin
      if (Button = mbRight) and not FRightClick then
        Exit;
      if Assigned(FOnMouseUp) then
        FOnMouseUp(self, Button, Shift, X, Y);
      Result := True;
    end;
    Exit;
  end;
  if Background then
    Exit;
  if InRange(X, Y, Shift) then
  begin
    if Assigned(FOnMouseUp) then
      FOnMouseUp(self, Button, Shift, X, Y);
    Result := True;
  end;
end;

function TDControl.DblClick(X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then
  begin
    if (MouseCaptureControl = self) then
    begin
      if Assigned(FOnDblClick) then
        FOnDblClick(self);
      Result := True;
    end;
    Exit;
  end;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).DblClick(X - Left, Y - Top) then
      begin
        Result := True;
        Exit;
      end;
  if Background then
    Exit;
  if InRange(X, Y, [ssDouble]) then
  begin
    if Assigned(FOnDblClick) then
      FOnDblClick(self);
    Result := True;
  end;
end;

function TDControl.Click(X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then
  begin
    if (MouseCaptureControl = self) then
    begin
      if Assigned(FOnClick) then
      begin
        FOnClick(self, X, Y);
      end;
      Result := True;
    end;
    Exit;
  end;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).Click(X - Left, Y - Top) then
      begin
        Result := True;
        Exit;
      end;
  if Background then
    Exit;
  if InRange(X, Y, [ssDouble]) then
  begin
    if Assigned(FOnClick) then
    begin
      FOnClick(self, X, Y);
    end;
    Result := True;
  end;
end;

procedure TDControl.SetImgIndex(Lib: TWMImages; Index: Integer);
var
  d: TAsphyreLockableTexture;
  pt: TPoint;
begin
  WLib := Lib;
  FaceIndex := Index;
  if Lib <> nil then
  begin
    d := Lib.Images[FaceIndex];
    if d <> nil then
    begin
      Width := d.Width;
      Height := d.Height;
    end
    else if not Background then
      ReloadTex := True;
  end;
end;

procedure TDControl.SetImgIndex(Lib: TWMImages; Index, X, Y: Integer);
var
  d: TAsphyreLockableTexture;
  pt: TPoint;
begin
  WLib := Lib;
  FaceIndex := Index;
  Self.Left := X;
  Self.Top := Y;
  if Lib <> nil then
  begin
    d := Lib.Images[FaceIndex];
    if d <> nil then
    begin
      Width := d.Width;
      Height := d.Height;
    end
    else if not Background then
      ReloadTex := True;
  end;
end;

procedure TDControl.DirectPaint(dsurface: TAsphyreCanvas);
var
  i: Integer;
  d: TAsphyreLockableTexture;
begin
  if Assigned(FOnDirectPaint) then
  begin
    FOnDirectPaint(self, dsurface);
    if ReloadTex then
    begin
      if (WLib <> nil) and (FaceIndex > 0) then
      begin
        d := WLib.Images[FaceIndex];
        if d <> nil then
        begin
          ReloadTex := False;
          Width := d.Width;
          Height := d.Height;
        end;
      end;
    end;
  end
  else if WLib <> nil then
  begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    if not Background and (WLib <> nil) and (FaceIndex > 0) then
    begin
      SetImgIndex(WLib, FaceIndex);
    end;
  end;
  for i := 0 to DControls.count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
  if Assigned(FOnEndDirectPaint) then
    FOnEndDirectPaint(self, dsurface);
    DragModePaint(dsurface);
end;

procedure TDControl.DragModePaint(dsurface: TAsphyreCanvas);
var
  dc, rc: TRect;
begin
  if g_TranFrame then  begin
    dc.Left := SurfaceX(Left);
    dc.Top := SurfaceY(Top);
    dc.Right := SurfaceX(left + Width);
    dc.Bottom := SurfaceY(top + Height);

//    if MouseEntry = msIn then
//      dsurface.FrameRect(Rect(dc.Left, dc.Top, dc.Right, dc.Bottom),(clBlue))
//    else
     dsurface.FrameRect(Rect(dc.Left, dc.Top, dc.Right, dc.Bottom),(clLime));
    if (FocusedControl = self) then begin
      dc.Left := SurfaceX(Left + 1);
      dc.Top := SurfaceY(Top + 1);
      dc.Right := SurfaceX(left + Width - 1);
      dc.Bottom := SurfaceY(top + Height - 1);
      dsurface.FrameRect(Rect(dc.Left, dc.Top, dc.Right, dc.Bottom),(clRed));
    end;
//    SetSelectedControl(Self);
  end;
end;

procedure TDControl.Enter();
begin
 if FocusedControl = nil then Exit;

  if Assigned(FOnEnter) then
    FOnEnter(Self)
end;

constructor TDButton.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  Downed := False;
  Arrived := False;
  FFloating := False;
  FOnClick := nil;
  CaptionEx := '';
  FEnableFocus := True;
  FClickSound := csNone;
  OnbtnState := tnor;
//  ClickInv := 0;
  Clicked := True;
  FRightClick := False;
end;

function TDButton.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  al, at: Integer;
begin
  Result := False;
  if OnbtnState = tdisable then Exit;
  OnbtnState := tnor;
  Result := inherited MouseMove(Shift, X, Y);
  Arrived := Result;
  if (not Background) and (not Result) then
  begin
    if MouseCaptureControl = self then
    if InRange(X, Y, Shift) then
    begin
      Downed := True;
    end else
    begin
      Downed := False;
    end;
  end;
  if Result and FFloating and (MouseCaptureControl = self) then
  begin
    if (SpotX <> X) or (SpotY <> Y) then
    begin
      al := Left + (X - SpotX);
      at := Top + (Y - SpotY);
      Left := al;
      Top := at;
      SpotX := X;
      SpotY := Y;
    end;
  end;
end;

function TDButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if OnbtnState = tdisable then
    Exit;

  if inherited MouseDown(Button, Shift, X, Y) then
  begin
//    if GetTickCount - ClickInv <= 150 then
//    begin
//      Result := True;
//      Exit;
//    end;
    if (not Background) and (MouseCaptureControl = nil) then
    begin
      Downed := TRUE;
      SetDCapture(self);
    end;
    Result := True;
    if Result then
    begin
      if Floating then
      begin
        if DParent <> nil then
          DParent.ChangeChildOrder(self);
      end;
      SpotX := X;
      SpotY := Y;
    end;
  end;
end;

function TDButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if OnbtnState = tdisable then
    Exit;
  if inherited MouseUp(Button, Shift, X, Y) then
  begin
    if not Downed then
    begin
      Result := True;
//      ClickInv := 0;
      Exit;
    end;
    ReleaseDCapture;
    if not Background then
    begin
      if InRange(X, Y, Shift) then
      begin
//        if GetTickCount - ClickInv <= 150 then
//        begin
//          Downed := False;
//          Exit;
//        end;
//        ClickInv := GetTickCount;
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := False;
    Result := True;
    Exit;
  end
  else
  begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

constructor TDCheckBox.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FArrived := False;
  Checked := False;
  Downed := False;
  FOnClick := nil;
  FEnableFocus := True;
  FClickSound := csNone;
end;

function TDCheckBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  FArrived := Result;
  if (not Background) and (not Result) then
  begin
    if MouseCaptureControl = self then
      if InRange(X, Y, Shift) then
        Downed := True
      else
        Downed := False;
  end;
end;

function TDCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then
  begin
    if (not Background) and (MouseCaptureControl = nil) then
    begin
      Downed := True;
      SetDCapture(self);
    end;
    Result := True;
  end;
end;

function TDCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then
  begin
    ReleaseDCapture;
    if not Background then
    begin
      if InRange(X, Y, Shift) then
      begin
        Checked := not Checked;
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := False;
    Result := True;
    Exit;
  end
  else
  begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

constructor TDCustomControl.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  Downed := False;
  FOnClick := nil;
  FEnableFocus := True;
  FClickSound := csNone;
  FTransparent := True;
  FEnabled := True;
  FFrameVisible := True;
  FFrameHot := False;
  FFrameSize := 1;
  FFrameColor := $00406F77;
  FFrameHotColor := $00599AA8;
end;

procedure TDCustomControl.SetTransparent(Value: Boolean);
begin
  if FTransparent <> Value then
    FTransparent := Value;
end;

procedure TDCustomControl.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
    FEnabled := Value;
end;

procedure TDCustomControl.SetFrameVisible(Value: Boolean);
begin
  if FFrameVisible <> Value then
    FFrameVisible := Value;
end;

procedure TDCustomControl.SetFrameHot(Value: Boolean);
begin
  if FFrameHot <> Value then
    FFrameHot := Value;
end;

procedure TDCustomControl.SetFrameSize(Value: byte);
begin
  if FFrameSize <> Value then
    FFrameSize := Value;
end;

procedure TDCustomControl.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDCustomControl.SetFrameHotColor(Value: TColor);
begin
  if FFrameHotColor <> Value then
  begin
    FFrameHotColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDCustomControl.OnDefaultEnterKey;
begin
end;

procedure TDCustomControl.OnDefaultTabKey;
begin
end;

function TDCustomControl.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if FEnabled and not Background then
  begin
    if Result then
      SetFrameHot(True)
    else if FocusedControl <> self then
      SetFrameHot(False);
  end;
end;

function TDCustomControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then
  begin
    if FEnabled then
    begin
      if (not Background) and (MouseCaptureControl = nil) then
      begin
        Downed := True;
        SetDCapture(self);
      end;
    end;
    Result := True;
  end;
end;

function TDCustomControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then
  begin
    ReleaseDCapture;
    if FEnabled and not Background then
    begin
      if InRange(X, Y, Shift) then
      begin
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := False;
    Result := True;
    Exit;
  end
  else
  begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

constructor TDHint.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FSelected := -1;
  FItems := TStringList.Create;
  FBackColor := clWhite;
  FSelectionColor := clSilver;
  FOnChangeSelect := nil;
  FOnMouseMoveSelect := nil;
  FParentControl := nil;
end;

destructor TDHint.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TDHint.GetItemSelected: Integer;
begin
  if (FSelected > FItems.count - 1) or (FSelected < 0) then
    Result := -1
  else
    Result := FSelected;
end;

procedure TDHint.SetItemSelected(Value: Integer);
begin
  if (Value > FItems.count - 1) or (Value < 0) then
    FSelected := -1
  else
    FSelected := Value;
end;

procedure TDHint.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDHint.SetSelectionColor(Value: TColor);
begin
  if FSelectionColor <> Value then
  begin
    FSelectionColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

function TDHint.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
end;
function TDHint.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  TmpSel: Integer;
begin
  FSelected := -1;
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FEnabled and not Background then
  begin
    TmpSel := FSelected;
    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y - LineSpace2 + 2) div (-Font.Height + LineSpace2);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
    if Assigned(FOnMouseMoveSelect) then
      FOnMouseMoveSelect(self, Shift, X, Y);
  end;
end;

function TDHint.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  c: Char;
  ret: Boolean;
  TmpSel: Integer;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if ret then
  begin
    TmpSel := FSelected;
    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y - LineSpace2 + 2) div (-Font.Height + LineSpace2);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
    if (FSelected > -1) and (FSelected < FItems.count) and (FParentControl <> nil) and (FParentControl is TDCustomEdit) then
    begin
      if (FItems.Objects[FSelected] <> nil) then
      begin
        Result := True;
        Exit;
      end;
      if tag = 0 then
      begin
        c := #0000;
        case FSelected of
          0:c := #0024;
          1:c := #0003;
          2:c := #0022;
          3:c := #0008;
          4:begin
              TDCustomEdit(FParentControl).SelStart := 0;
              TDCustomEdit(FParentControl).SelEnd := AnsiTextLength(TDCustomEdit(FParentControl).Caption);
              TDCustomEdit(FParentControl).ChangeCurPos(TDCustomEdit(FParentControl).SelEnd, True);
            end;
        end;
        if (c <> #0000) then
        begin
          TDCustomEdit(FParentControl).KeyPressEx(c);
        end;
      end
      else if tag = 1 then
      begin
      end;
    end;
    if Assigned(FOnChangeSelect) then
      FOnChangeSelect(self, Button, Shift, X, Y);
    Visible := False;
    ret := True;
  end;
  Result := ret;
end;

function TDHint.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  ret: Boolean;
begin
  ret := inherited KeyDown(Key, Shift);
  if ret then
  begin
    case Key of
      VK_PRIOR:
        begin
          ItemSelected := ItemSelected - Height div  - Font.Height;
          if (ItemSelected = -1) then
            ItemSelected := 0;
        end;
      VK_NEXT:
        begin
          ItemSelected := ItemSelected + Height div  - Font.Height;
          if ItemSelected = -1 then
            ItemSelected := FItems.count - 1;
        end;
      VK_UP:
        if ItemSelected - 1 > -1 then
          ItemSelected := ItemSelected - 1;
      VK_DOWN:
        if ItemSelected + 1 < FItems.count then
          ItemSelected := ItemSelected + 1;
    end;
  end;
  Result := ret;
end;

procedure TDHint.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TDHint.DirectPaint(dsurface: TAsphyreCanvas);
var
  fy, nY, L, T, i, oSize: Integer;
  OldColor: TColor;
begin
  if Assigned(FOnDirectPaint) then
  begin
    FOnDirectPaint(self, dsurface);
    Exit;
  end;
  L := SurfaceX(Left);
  T := SurfaceY(Top);
  try
    dsurface.FillRect(Rect(L, T + 1, L + Width, T + Height - 1), dxColorToAlphaColor(RGB(255, 251, 240), 255));
    dsurface.FrameRect(Rect(L, T + 1, L + Width, T + Height - 1), RGB(128, 128, 128));
    if (FSelected > -1) and (FSelected < FItems.count) then
    begin
      if (FItems.Objects[FSelected] = nil) then
      begin
        nY := T + (-Font.Height + LineSpace2) * FSelected;
        fy := nY + (-Font.Height + LineSpace2);
        if (nY < T + Self.Height - 1) and (fy > T + 1) then
        begin
          if (fy > T + Height - 1) then
            fy := T + Height - 1;
          if (nY < T + 1) then
            nY := T + 1;
          dsurface.FillRect(Rect(L + 2, nY + 2, L + Width - 2, fy + 5), dxColorToAlphaColor(RGB(0, 0, 128), 255));     //clBlue
        end;
      end;
    end;
    for i := 0 to FItems.count - 1 do
    begin
      if (FSelected = i) and (FItems.Objects[i] = nil) then
      begin
        Font.Color := clWhite
      end
      else if (FItems.Objects[i] <> nil) then
        Font.Color := rgb(132, 132, 132)
      else
      begin
        Font.Color := clBlack;
      end;
      dsurface.TextOut(L + LineSpace2, LineSpace2 + T + (-Font.Height + LineSpace2) * i, FItems.Strings[i], Font.Color);
    end;
  finally
  end;
  Exit;
  try
    if (FSelected > -1) and (FSelected < FItems.count) then
    begin
      if (FItems.Objects[FSelected] = nil) then
      begin
        nY := T + (-Font.Height + LineSpace2) * FSelected;
        fy := nY + (-Font.Height + LineSpace2);
        if (nY < T + Height - 1) and (fy > T + 1) then
        begin
          if (fy > T + Height - 1) then
            fy := T + Height - 1;
          if (nY < T + 1) then
            nY := T + 1;
          dsurface.FillRect(Rect(L, nY + 2, L + Width, fy + 5),clHighlight);
        end;
      end;
    end;
    for i := 0 to FItems.count - 1 do
    begin
      if (FSelected = i) and (FItems.Objects[i] = nil) then
      begin
        Font.Color := clWhite
      end
      else if (FItems.Objects[i] <> nil) then
        Font.Color := clSilver
      else
      begin
        Font.Color := clWhite;
      end;
      dsurface.TextOut(L + LineSpace2, LineSpace2 + T + (-Font.Height + LineSpace2) * i, FItems.Strings[i], Font.Color);
    end;
  finally
  end;
  DragModePaint(dsurface);
end;

constructor TDGrid.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FColCount := 8;
  FRowCount := 5;
  FColWidth := 36;
  FRowHeight := 32;
  FColoffset := 0;
  FRowoffset := 0;
  FOnGridSelect := nil;
  FOnGridMouseMove := nil;
  FOnGridPaint := nil;
  FOnButton := mbLeft;
end;

function TDGrid.GetColRow(X, Y: Integer; var ACol, ARow: Integer): Boolean;
var
  nX, nY: Integer;

begin
  Result := False;
  if InRange(X, Y, [ssDouble]) then
  begin
    nX := x - Left;
    nY := y - Top;
    acol := nX div (FColWidth + FColoffset);
    arow := nY div (FRowHeight + FRowoffset);
    if (nX - (FColWidth + FColoffset) * (acol) - FColWidth <= 0) and
      (nY - (FRowHeight + FRowoffset) * (arow) - FRowHeight <= 0) then
      Result := TRUE;
  end;
end;

function TDGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow: Integer;
begin
  Result := False;
  if Button in [mbLeft, mbRight] then
  begin
    if GetColRow(X, Y, ACol, ARow) then
    begin
      SelectCell.X := ACol;
      SelectCell.Y := ARow;
      DownPos.X := X;
      DownPos.Y := Y;
      SetDCapture(self);
      Result := True;
    end;
  end;
end;

function TDGrid.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow: Integer;
begin
  Result := False;
  if InRange(X, Y, Shift) then
  begin
    if GetColRow(X, Y, ACol, ARow) then
    begin
      if Assigned(FOnGridMouseMove) then
        FOnGridMouseMove(self, X, Y, ACol, ARow, Shift);
    end;
    Result := True;
  end;
end;

function TDGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow: Integer;
begin
  Result := False;
  if Button in [mbLeft, mbRight] then
  begin
    if GetColRow(X, Y, ACol, ARow) then
    begin
      if (SelectCell.X = ACol) and (SelectCell.Y = ARow) then
      begin
        Col := ACol;
        Row := ARow;
        if Assigned(FOnGridSelect) then
        begin
          self.FOnButton := Button;
          FOnGridSelect(self, X, Y, ACol, ARow, Shift);
        end;
      end;
      Result := True;
    end;
    ReleaseDCapture;
  end;
end;

function TDGrid.Click(X, Y: Integer): Boolean;
var
  ACol, ARow: Integer;
begin
  Result := False;
end;

procedure TDGrid.DirectPaint(dsurface: TAsphyreCanvas);
var
  i, j: Integer;
  rc: TRect;
begin
  if Assigned(FOnGridPaint) then
  for i := 0 to FRowCount - 1 do
  for j := 0 to FColCount - 1 do
  begin
    rc.Top := Top + i * FRowHeight + i * FRowoffset;
    rc.Left := Left + j * FColWidth + j * FColoffset;
    rc.Right := rc.Left + FColWidth;
    rc.Bottom := rc.Top + FRowHeight;

    if (SelectCell.Y = i) and (SelectCell.X = j) then
      FOnGridPaint(self, j, i, rc, [gdSelected], dsurface)
    else
      FOnGridPaint(self, j, i, rc, [], dsurface);
  end;
  DragModePaint(dsurface);
end;

constructor TDWindow.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FFloating := False;
  FMoveRange := False;
  FEnableFocus := True;
  FRightClick := True;
  Width := 120;
  Height := 120;
end;

procedure TDWindow.SetVisible(flag: Boolean);
begin
  FVisible := flag;
  if Floating then
  begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
end;

function TDWindow.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  al, at: Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FFloating and (MouseCaptureControl = self) then
  begin
    if (SpotX <> X) or (SpotY <> Y) then
    begin
      al := Left + (X - SpotX);
      at := Top + (Y - SpotY);
      if FMoveRange then
      begin
      end;
      if al + Width < WINLEFT then
        al := WINLEFT - Width;
      if al > (GUIFScreenWidth - WINLEFT) then
        al := (GUIFScreenWidth - WINLEFT);
      if at + Height < WINTOP then
        at := WINTOP - Height;
      if at  > (GUIFScreenHeight - WINTOP) then
        at := (GUIFScreenHeight - WINTOP) ;

      Left := al;
      Top := at;
      SpotX := X;
      SpotY := Y;
    end;
  end;
end;

function TDWindow.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then
  begin
    if Floating then
    begin
      if DParent <> nil then
        DParent.ChangeChildOrder(self);
    end;
    SpotX := X;
    SpotY := Y;
  end;
end;

function TDWindow.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
end;
procedure TDWindow.Show;
begin
  Visible := True;
  if Floating then
  begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
  if EnableFocus then
    SetDFocus(self);
end;

function TDWindow.ShowModal: Integer;
begin
  Result := 0;
  Visible := True;
  ModalDWindow := self;
  if EnableFocus then
    SetDFocus(self);
end;

constructor TDWinManager.Create;
begin
  DWinList := TList.Create;
  MouseCaptureControl := nil;
  FocusedControl := nil;
end;

destructor TDWinManager.Destroy;
begin
   DWinList.Free;
  inherited Destroy;
end;

procedure TDWinManager.ClearAll;
begin
  DWinList.Clear;
end;

procedure TDWinManager.Process;
var
  I: Integer;
begin
  for I := 0 to DWinList.Count - 1 do
  begin
    if TDControl(DWinList[I]).Visible then
    begin
      TDControl(DWinList[I]).Process;
    end;
  end;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
      with ModalDWindow do
        Process;
  end;
end;

procedure TDWinManager.AddDControl(dcon: TDControl; Visible: Boolean);
begin
  dcon.Visible := Visible;
  DWinList.Add(dcon);
end;
procedure TDWinManager.DelDControl(dcon: TDControl);
var
  i: Integer;
begin
  for i := 0 to DWinList.count - 1 do
    if DWinList[i] = dcon then
    begin
      DWinList.Delete(i);
      Break;
    end;
end;

function TDWinManager.KeyPress(var Key: Char): Boolean;
var
  i: Integer;
begin
  Result := False;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        Result := KeyPress(Key);
      Exit;
    end
    else
      ModalDWindow := nil;
    Key := #0;
  end;
  if FocusedControl <> nil then
  begin
    if FocusedControl.Visible then
    begin
      Result := FocusedControl.KeyPress(Key);
    end
    else
      ReleaseDFocus;
  end;
end;

function TDWinManager.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  i: Integer;
begin
  Result := False;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        Result := KeyDown(Key, Shift);
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if FocusedControl <> nil then
  begin
    if FocusedControl.Visible then
      Result := FocusedControl.KeyDown(Key, Shift)
    else
      ReleaseDFocus;
  end;
end;

function TDWinManager.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        MouseMove(Shift, LocalX(X), LocalY(Y));
      Result := True;
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then
  begin
    with MouseCaptureControl do
      Result := MouseMove(Shift, LocalX(X), LocalY(Y));
  end else
  for i := 0 to DWinList.count - 1 do
  begin
    if TDControl(DWinList[i]).Visible then
    begin
      if TDControl(DWinList[i]).MouseMove(Shift, X, Y) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

function TDWinManager.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        MouseDown(Button, Shift, LocalX(X), LocalY(Y));
      Result := True;
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then
  begin
    with MouseCaptureControl do
      Result := MouseDown(Button, Shift, LocalX(X), LocalY(Y));
  end else
  for i := 0 to DWinList.count - 1 do
  begin
    if TDControl(DWinList[i]).Visible then
    begin
      if TDControl(DWinList[i]).MouseDown(Button, Shift, X, Y) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

function TDWinManager.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then
  begin
    with MouseCaptureControl do
      Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
  end else
  for i := 0 to DWinList.count - 1 do
  begin
    if TDControl(DWinList[i]).Visible then
    begin
      if TDControl(DWinList[i]).MouseUp(Button, Shift, X, Y) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

function TDWinManager.DblClick(X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        Result := DblClick(LocalX(X), LocalY(Y));
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then
  begin
    with MouseCaptureControl do
      Result := DblClick(LocalX(X), LocalY(Y));
  end  else
  begin
    for i := 0 to DWinList.count - 1 do
    begin
      if TDControl(DWinList[i]).Visible then
      begin
        if TDControl(DWinList[i]).DblClick(X, Y) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

function TDWinManager.Click(X, Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if ModalDWindow <> nil then
  begin
    if ModalDWindow.Visible then
    begin
      with ModalDWindow do
        Result := Click(LocalX(X), LocalY(Y));
      Exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then
  begin
    with MouseCaptureControl do
      Result := Click(LocalX(X), LocalY(Y));
  end  else
  for i := 0 to DWinList.count - 1 do
  begin
    if TDControl(DWinList[i]).Visible then
    begin
      if TDControl(DWinList[i]).Click(X, Y) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

procedure TDWinManager.DirectPaint(dsurface: TAsphyreCanvas);
var
  i: Integer;
begin
  for i := 0 to DWinList.count - 1 do
  begin
    if TDControl(DWinList[i]).Visible then
    begin
      try
        TDControl(DWinList[i]).DirectPaint(dsurface);
      except
      end;
    end;
  end;
  try
    if ModalDWindow <> nil then
    begin
      if ModalDWindow.Visible then
        with ModalDWindow do
          DirectPaint(dsurface);
    end;
  except
  end;
end;

constructor TDMoveButton.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FFloating := True;
  FEnableFocus := False;
  Width := 30;
  Height := 30;
  LeftToRight := True;
  bMouseMove := True;
end;

procedure TDMoveButton.SetVisible(flag: Boolean);
begin
  FVisible := flag;
  if Floating then
  begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
end;

function TDMoveButton.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  n, al, at, ot: Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Max <= 0 then
    Exit;
  if ssLeft in Shift then
  begin
    if Result and FFloating and (MouseCaptureControl = self) then
    begin
      n := Position;
      try
        if Max <= 0 then
          Exit;
        if (SpotX <> X) or (SpotY <> Y) then
        begin
          if LeftToRight then
          begin
            if not Reverse then
            begin
              ot := SlotLen - Width;
              al := RTop;
              at := Left + (X - SpotX);
              if at < RLeft then
                at := RLeft;
              if at + Width > RLeft + SlotLen then
                at := RLeft + SlotLen - Width;
              Position := Round((at - RLeft) / (ot / Max));
              if Position < 0 then
                Position := 0;
              if Position > Max then
                Position := Max;
              Left := at;
              Top := al;
              SpotX := X;
              SpotY := Y;
            end
            else
            begin
              al := RTop;
              at := Left + (X - SpotX);
              if at < RLeft - SlotLen then
                at := RLeft - SlotLen;
              if at > RLeft then
                at := RLeft;
              Position := Round((at - RLeft) / (SlotLen / Max));
              if Position < 0 then
                Position := 0;
              if Position > Max then
                Position := Max;
              Left := at;
              Top := al;
              SpotX := X;
              SpotY := Y;
            end;
          end
          else
          begin
            if not Reverse then
            begin
              ot := SlotLen - Height;
              al := RLeft;
              at := Top + (Y - SpotY);
              if at < RTop then
                at := RTop;
              if at + Height > RTop + SlotLen then
                at := RTop + SlotLen - Height;
              Position := Round((at - RTop) / (ot / Max));
              if Position < 0 then
                Position := 0;
              if Position > Max then
                Position := Max;
              Left := al;
              Top := at;
              SpotX := X;
              SpotY := Y;
            end
            else
            begin
              al := RLeft;
              at := Top + (Y - SpotY);
              if at < RTop - SlotLen then
                at := RTop - SlotLen;
              if at > RTop then
                at := RTop;
              Position := Round((at - RTop) / (SlotLen / Max));
              if Position < 0 then
                Position := 0;
              if Position > Max then
                Position := Max;
              Left := al;
              Top := at;
              SpotX := X;
              SpotY := Y;
            end;
          end;
        end;
      finally
        if (n <> Position) and Assigned(FOnMouseMove) then
          FOnMouseMove(self, Shift, X, Y);
      end;
    end;
  end;
end;

procedure TDMoveButton.UpdatePos(pos: Integer; force: Boolean);
begin
  if Max <= 0 then
    Exit;
  Position := pos;
  if Position < 0 then
    Position := 0;
  if Position > Max then
    Position := Max;
  if LeftToRight then
  begin
    Left := RLeft + Round((SlotLen - Width) / Max * Position);
    if Left < RLeft then
      Left := RLeft;
    if Left > RLeft + SlotLen - Width then
      Left := RLeft + SlotLen - Width;
  end
  else
  begin
    Top := RTop + Round((SlotLen - Height) / Max * Position);
    if Top < RTop then
      Top := RTop;
    if Top > RTop + SlotLen - Height then
      Top := RTop + SlotLen - Height;
  end;
end;

function TDMoveButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then
  begin
    if Floating then
    begin
      if DParent <> nil then
        DParent.ChangeChildOrder(self);
    end;
    SpotX := X;
    SpotY := Y;
  end;
end;

function TDMoveButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
end;
procedure TDMoveButton.Show;
begin
  Visible := True;
  if Floating then
  begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
  if EnableFocus then
    SetDFocus(self);
end;

function TDMoveButton.ShowModal: Integer;
begin
  Result := 0;
  Visible := True;
  ModalDWindow := self;
  if EnableFocus then
    SetDFocus(self);
end;

function IsKeyPressed(Key: Byte): Boolean;
var
  keyvalue          : TKeyBoardState;
begin
  Result := False;
  FillChar(keyvalue, SizeOf(TKeyBoardState), #0);
  if GetKeyboardState(keyvalue) then
    if (keyvalue[Key] and $80) <> 0 then
      Result := True;
end;

const
  // Windows 2000/XP multimedia keys (adapted from winuser.h and renamed to avoid potential conflicts)
  // See also: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/WindowsUserInterface/UserInput/VirtualKeyCodes.asp
  _VK_BROWSER_BACK = $A6; // Browser Back key
  _VK_BROWSER_FORWARD = $A7; // Browser Forward key
  _VK_BROWSER_REFRESH = $A8; // Browser Refresh key
  _VK_BROWSER_STOP = $A9; // Browser Stop key
  _VK_BROWSER_SEARCH = $AA; // Browser Search key
  _VK_BROWSER_FAVORITES = $AB; // Browser Favorites key
  _VK_BROWSER_HOME = $AC; // Browser Start and Home key
  _VK_VOLUME_MUTE = $AD; // Volume Mute key
  _VK_VOLUME_DOWN = $AE; // Volume Down key
  _VK_VOLUME_UP = $AF; // Volume Up key
  _VK_MEDIA_NEXT_TRACK = $B0; // Next Track key
  _VK_MEDIA_PREV_TRACK = $B1; // Previous Track key
  _VK_MEDIA_STOP = $B2; // Stop Media key
  _VK_MEDIA_PLAY_PAUSE = $B3; // Play/Pause Media key
  _VK_LAUNCH_MAIL = $B4; // Start Mail key
  _VK_LAUNCH_MEDIA_SELECT = $B5; // Select Media key
  _VK_LAUNCH_APP1 = $B6; // Start Application 1 key
  _VK_LAUNCH_APP2 = $B7; // Start Application 2 key
  // Self-invented names for the extended keys
  NAME_VK_BROWSER_BACK = 'Browser Back';
  NAME_VK_BROWSER_FORWARD = 'Browser Forward';
  NAME_VK_BROWSER_REFRESH = 'Browser Refresh';
  NAME_VK_BROWSER_STOP = 'Browser Stop';
  NAME_VK_BROWSER_SEARCH = 'Browser Search';
  NAME_VK_BROWSER_FAVORITES = 'Browser Favorites';
  NAME_VK_BROWSER_HOME = 'Browser Start/Home';
  NAME_VK_VOLUME_MUTE = 'Volume Mute';
  NAME_VK_VOLUME_DOWN = 'Volume Down';
  NAME_VK_VOLUME_UP = 'Volume Up';
  NAME_VK_MEDIA_NEXT_TRACK = 'Next Track';
  NAME_VK_MEDIA_PREV_TRACK = 'Previous Track';
  NAME_VK_MEDIA_STOP = 'Stop Media';
  NAME_VK_MEDIA_PLAY_PAUSE = 'Play/Pause Media';
  NAME_VK_LAUNCH_MAIL = 'Start Mail';
  NAME_VK_LAUNCH_MEDIA_SELECT = 'Select Media';
  NAME_VK_LAUNCH_APP1 = 'Start Application 1';
  NAME_VK_LAUNCH_APP2 = 'Start Application 2';

const
  mmsyst = 'winmm.dll';
  kernel32 = 'kernel32.dll';
  HotKeyAtomPrefix = 'HotKeyManagerHotKey';
  ModName_Shift = 'Shift';
  ModName_Ctrl = 'Ctrl';
  ModName_Alt = 'Alt';
  ModName_Win = 'Win';
  VK2_SHIFT = 32;
  VK2_CONTROL = 64;
  VK2_ALT = 128;
  VK2_WIN = 256;

var
  EnglishKeyboardLayout: HKL;
  ShouldUnloadEnglishKeyboardLayout: Boolean;
  LocalModName_Shift: string = ModName_Shift;
  LocalModName_Ctrl: string = ModName_Ctrl;
  LocalModName_Alt: string = ModName_Alt;
  LocalModName_Win: string = ModName_Win;

function IsExtendedKey(Key: Word): Boolean;
begin
  Result := ((Key >= _VK_BROWSER_BACK) and (Key <= _VK_LAUNCH_APP2));
end;

function GetHotKey(Modifiers, Key: Word): Cardinal;
var
  HK: Cardinal;
begin
  HK := 0;
  if (Modifiers and MOD_ALT) <> 0 then
    Inc(HK, VK2_ALT);
  if (Modifiers and MOD_CONTROL) <> 0 then
    Inc(HK, VK2_CONTROL);
  if (Modifiers and MOD_SHIFT) <> 0 then
    Inc(HK, VK2_SHIFT);
  if (Modifiers and MOD_WIN) <> 0 then
    Inc(HK, VK2_WIN);
  HK := HK shl 8;
  Inc(HK, Key);
  Result := HK;
end;

procedure SeparateHotKey(HotKey: Cardinal; var Modifiers, Key: Word);
var
  Virtuals: Integer;
  v: Word;
  X: Word;
begin
  Key := Byte(HotKey);
  X := HotKey shr 8;
  Virtuals := X;
  v := 0;
  if (Virtuals and VK2_WIN) <> 0 then
    Inc(v, MOD_WIN);
  if (Virtuals and VK2_ALT) <> 0 then
    Inc(v, MOD_ALT);
  if (Virtuals and VK2_CONTROL) <> 0 then
    Inc(v, MOD_CONTROL);
  if (Virtuals and VK2_SHIFT) <> 0 then
    Inc(v, MOD_SHIFT);
  Modifiers := v;
end;

function HotKeyToText(HotKey: Cardinal; Localized: Boolean): string;
  function GetExtendedVKName(Key: Word): string;
  begin
    case Key of
      _VK_BROWSER_BACK: Result := NAME_VK_BROWSER_BACK;
      _VK_BROWSER_FORWARD: Result := NAME_VK_BROWSER_FORWARD;
      _VK_BROWSER_REFRESH: Result := NAME_VK_BROWSER_REFRESH;
      _VK_BROWSER_STOP: Result := NAME_VK_BROWSER_STOP;
      _VK_BROWSER_SEARCH: Result := NAME_VK_BROWSER_SEARCH;
      _VK_BROWSER_FAVORITES: Result := NAME_VK_BROWSER_FAVORITES;
      _VK_BROWSER_HOME: Result := NAME_VK_BROWSER_HOME;
      _VK_VOLUME_MUTE: Result := NAME_VK_VOLUME_MUTE;
      _VK_VOLUME_DOWN: Result := NAME_VK_VOLUME_DOWN;
      _VK_VOLUME_UP: Result := NAME_VK_VOLUME_UP;
      _VK_MEDIA_NEXT_TRACK: Result := NAME_VK_MEDIA_NEXT_TRACK;
      _VK_MEDIA_PREV_TRACK: Result := NAME_VK_MEDIA_PREV_TRACK;
      _VK_MEDIA_STOP: Result := NAME_VK_MEDIA_STOP;
      _VK_MEDIA_PLAY_PAUSE: Result := NAME_VK_MEDIA_PLAY_PAUSE;
      _VK_LAUNCH_MAIL: Result := NAME_VK_LAUNCH_MAIL;
      _VK_LAUNCH_MEDIA_SELECT: Result := NAME_VK_LAUNCH_MEDIA_SELECT;
      _VK_LAUNCH_APP1: Result := NAME_VK_LAUNCH_APP1;
      _VK_LAUNCH_APP2: Result := NAME_VK_LAUNCH_APP2;
    else
      Result := '';
    end;
  end;
  function GetModifierNames: string;
  var
    s: string;
  begin
    s := '';
    if Localized then begin
      if (HotKey and $4000) <> 0 then // scCtrl
        s := s + LocalModName_Ctrl + '+';
      if (HotKey and $2000) <> 0 then // scShift
        s := s + LocalModName_Shift + '+';
      if (HotKey and $8000) <> 0 then // scAlt
        s := s + LocalModName_Alt + '+';
      if (HotKey and $10000) <> 0 then
        s := s + LocalModName_Win + '+';
    end
    else begin
      if (HotKey and $4000) <> 0 then // scCtrl
        s := s + ModName_Ctrl + '+';
      if (HotKey and $2000) <> 0 then // scShift
        s := s + ModName_Shift + '+';
      if (HotKey and $8000) <> 0 then // scAlt
        s := s + ModName_Alt + '+';
      if (HotKey and $10000) <> 0 then
        s := s + ModName_Win + '+';
    end;
    Result := s;
  end;
  function GetVKName(Special: Boolean): string;
  var
    scanCode: Cardinal;
    KeyName: array[0..255] of Char;
    oldkl: HKL;
    Modifiers, Key: Word;
  begin
    Result := '';
    if Localized then {// Local language key names}  begin
      if Special then
        scanCode := (MapVirtualKey(Byte(HotKey), 0) shl 16) or (1 shl 24)
      else
        scanCode := (MapVirtualKey(Byte(HotKey), 0) shl 16);
      if scanCode <> 0 then begin
        GetKeyNameText(scanCode, KeyName, SizeOf(KeyName));
        Result := KeyName;
      end;
    end
    else {// English key names}  begin
      if Special then
        scanCode := (MapVirtualKeyEx(Byte(HotKey), 0, EnglishKeyboardLayout) shl 16) or (1 shl 24)
      else
        scanCode := (MapVirtualKeyEx(Byte(HotKey), 0, EnglishKeyboardLayout) shl 16);
      if scanCode <> 0 then begin
        oldkl := GetKeyboardLayout(0);
        if oldkl <> EnglishKeyboardLayout then
          ActivateKeyboardLayout(EnglishKeyboardLayout, 0); // Set English kbd. layout
        GetKeyNameText(scanCode, KeyName, SizeOf(KeyName));
        Result := KeyName;
        if oldkl <> EnglishKeyboardLayout then begin
          if ShouldUnloadEnglishKeyboardLayout then
            UnloadKeyboardLayout(EnglishKeyboardLayout); // Restore prev. kbd. layout
          ActivateKeyboardLayout(oldkl, 0);
        end;
      end;
    end;
    if Length(Result) <= 1 then begin
      // Try the internally defined names
      SeparateHotKey(HotKey, Modifiers, Key);
      if IsExtendedKey(Key) then
        Result := GetExtendedVKName(Key);
    end;
  end;
var
  KeyName: string;
begin
  case Byte(HotKey) of
    // PgUp, PgDn, End, Home, Left, Up, Right, Down, Ins, Del
    $21..$28, $2D, $2E: KeyName := GetVKName(True);
  else
    KeyName := GetVKName(False);
  end;
  Result := GetModifierNames + KeyName;
end;

constructor TDCustomEdit.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  Downed := False;
  FMiniCaret := 0;
  m_InputHint := '';
  DHint := nil;
  FCaretColor := clWhite;
  FOnClick := nil;
  FEnableFocus := True;
  FClick := False;
  FSelClickStart := False;
  FSelClickEnd := False;
  FClickX := 0;
  FSelStart := -1;
  FSelEnd := -1;
  FStartTextX := 0;
  FSelTextStart := 0;
  FSelTextEnd := 0;
  FCurPos := 0;
  FClickSound := csNone;
  FShowCaret := True;
  FNomberOnly := False;
  FIsHotKey := False;
  FHotKey := 0;
  FTransparent := True;
  FEnabled := True;
  FSecondChineseChar := False;
  FShowCaretTick := GetTickCount;
  FFrameVisible := True;
  FFrameHot := False;
  FFrameSize := 1;
  FFrameColor := $00406F77;
  FFrameHotColor := $00599AA8;
  FAlignment := taLeftJustify;
  FRightClick := True;
  FFontSelColor := clWhite;
end;

procedure TDCustomEdit.SetFontSelColor(Value: TColor);
begin
  if FFontSelColor <> Value then
  begin
    FFontSelColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDCustomEdit.SetSelLength(Value: Integer);
begin
  SetSelStart(Value - 1);
  SetSelEnd(Value - 1);
end;

function TDCustomEdit.ReadSelLength(): Integer;
begin
  Result := abs(FSelStart - FSelEnd);
end;

procedure TDCustomEdit.SetSelStart(Value: Integer);
begin
  if FSelStart <> Value then
    FSelStart := Value;
end;

procedure TDCustomEdit.SetSelEnd(Value: Integer);
begin
  if FSelEnd <> Value then
    FSelEnd := Value;
end;

procedure TDCustomEdit.SetMaxLength(Value: Integer);
begin
  if FMaxLength <> Value then
    FMaxLength := Value;
end;

procedure TDCustomEdit.SetPasswordChar(Value: Char);
begin
  if FPasswordChar <> Value then
    FPasswordChar := Value;
end;

procedure TDCustomEdit.SetNomberOnly(Value: Boolean);
begin
  if FNomberOnly <> Value then
    FNomberOnly := Value;
end;

procedure TDCustomEdit.SetIsHotKey(Value: Boolean);
begin
  if FIsHotKey <> Value then
    FIsHotKey := Value;
end;

procedure TDCustomEdit.SetHotKey(Value: Cardinal);
begin
  if FHotKey <> Value then
    FHotKey := Value;
end;

procedure TDCustomEdit.SetAtom(Value: Word);
begin
  if FAtom <> Value then
    FAtom := Value;
end;

procedure TDCustomEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
    FAlignment := Value;
end;

procedure TDCustomEdit.ShowCaret();
begin
  FShowCaret := True;
  FShowCaretTick := GetTickCount;
end;

procedure TDCustomEdit.SetFocus();
//begin
//  SetDFocus(self);
//end;
var
  I: Integer;
begin
  if EnableFocus and Visible then SetDFocus(Self);
  if (FocusedControl = nil) and Visible then begin
    for I := 0 to DControls.Count - 1 do begin
      if (FocusedControl = nil) then
        TDControl(DControls[I]).SetFocus
      else break;
    end;
  end;
end;

procedure TDCustomEdit.ChangeCurPos(nPos: Integer; boLast: Boolean = False);
begin
  if Caption = '' then
    Exit;
  if boLast then
  begin
    FCurPos := AnsiTextLength(Caption);
    Exit;
  end;
  if nPos = 1 then
  begin
    case ByteType(AnsiString(Caption), FCurPos + 1) of
      mbSingleByte:
        nPos := 1;
      mbLeadByte:
        nPos := 2;
      mbTrailByte:
        nPos := 2;
    end;
  end
  else
  begin
    case ByteType(AnsiString(Caption), FCurPos) of
      mbSingleByte:
        nPos := -1;
      mbLeadByte:
        nPos := -2;
      mbTrailByte:
        nPos := -2;
    end;
  end;
  if ((FCurPos + nPos) <= AnsiTextLength(Caption)) then
  begin
    if ((FCurPos + nPos) >= 0) then
      FCurPos := FCurPos + nPos;
  end;

  if FSelClickStart then
  begin
    FSelClickStart := False;
    FSelStart := FCurPos;
  end;
  if FSelClickEnd then
  begin
    FSelClickEnd := False;
    FSelEnd := FCurPos;
  end;
end;

function TDCustomEdit.KeyPress(var Key: Char): Boolean;
var
  s, cStr: String;
  i, nlen, cpLen: Integer;
  pStart: Integer;
  pEnd: Integer;
begin
  if not FEnabled or FIsHotKey then
    Exit;
  if not self.Visible then
    Exit;
  if (self.DParent = nil) or (not self.DParent.Visible) then
    Exit;
  s := Caption;
  try
    if (Ord(Key) in [0,VK_RETURN, VK_ESCAPE]) then
    begin
      Result := inherited KeyPress(Key);
      Exit;
    end;
    if not FNomberOnly and IsKeyPressed(VK_CONTROL) and (Ord(Key) in [1..27]) then
    begin

      if (Ord(Key) = 22) then
      begin
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Clipboard.AsText;
          if cStr <> '' then
          begin
            cpLen := FMaxLength - AnsiTextLength(Caption) + abs(FSelStart - FSelEnd);
            FSelStart := -1;
            FSelEnd := -1;
            Caption := CopyAnisText(Caption, 1, pStart) + CopyAnisText(Caption, pEnd + 1, AnsiTextLength(Caption));
            FCurPos := pStart;
            nlen := AnsiTextLength(cStr);
            if nlen < cpLen then
              cpLen := nlen;
            Caption := CopyAnisText(Caption, 1, FCurPos) + CopyAnisText(cStr, 1, cpLen) + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
            Inc(FCurPos, cpLen);
          end;
        end
        else
        begin
          cpLen := FMaxLength - AnsiTextLength(Caption);
          if cpLen > 0 then
          begin
            cStr := Clipboard.AsText;
            if cStr <> '' then
            begin
              nlen := AnsiTextLength(cStr);
              if nlen < cpLen then
                cpLen := nlen;
              Caption := CopyAnisText(Caption, 1, FCurPos) + CopyAnisText(cStr, 1, cpLen) + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
              Inc(FCurPos, cpLen);
            end;
          end
          else
            Beep;
        end;
      end;
      if (Ord(Key) = 3) and (FPasswordChar = #0000) and (Caption <> '') then
      begin
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := CopyAnisText(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then
          begin
            Clipboard.AsText := cStr;
          end;
        end;
      end;
      if (Ord(Key) = 24) and (FPasswordChar = #0000) and (Caption <> '') then
      begin
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := CopyAnisText(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then
          begin
            Clipboard.AsText := cStr;
          end;
          FSelStart := -1;
          FSelEnd := -1;
          Caption := CopyAnisText(Caption, 1, pStart) + CopyAnisText(Caption, pEnd + 1, AnsiTextLength(Caption));
          FCurPos := pStart;
        end;
      end;
      if (Ord(Key) = 1) and not FIsHotKey and (Caption <> '') then
      begin
        FSelStart := 0;
        FSelEnd := AnsiTextLength(Caption);
        FCurPos := FSelEnd;
      end;
      Result := inherited KeyPress(Key);
      Exit;
    end;
    Result := inherited KeyPress(Key);
    if Result then
    begin
      ShowCaret();
      case Ord(Key) of
        VK_BACK:
          begin
            if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
            begin
              if FSelStart > FSelEnd then
              begin
                pStart := FSelEnd;
                pEnd := FSelStart;
              end;
              if FSelStart < FSelEnd then
              begin
                pStart := FSelStart;
                pEnd := FSelEnd;
              end;
              FSelStart := -1;
              FSelEnd := -1;
              Caption := CopyAnisText(Caption, 1, pStart) + CopyAnisText(Caption, pEnd + 1, AnsiTextLength(Caption));
              FCurPos := pStart;
            end
            else
            begin
              if (FCurPos > 0) then
              begin
                nlen := 1;
                case ByteType(AnsiString(Caption), FCurPos) of
                  mbSingleByte:
                    nlen := 1;
                  mbLeadByte:
                    nlen := 2;
                  mbTrailByte:
                    nlen := 2;
                end;
                Caption := CopyAnisText(Caption, 1, FCurPos - nlen) + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
                Dec(FCurPos, nlen);
              end;
            end;
          end;
      else
        begin
          if (FMaxLength <= 0) or (FMaxLength > MaxChar) then
            FMaxLength := MaxChar;
          if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
          begin
            if FSelStart > FSelEnd then
            begin
              pStart := FSelEnd;
              pEnd := FSelStart;
            end;
            if FSelStart < FSelEnd then
            begin
              pStart := FSelStart;
              pEnd := FSelEnd;
            end;
            if FNomberOnly then
            begin
              if (Key >= #$0030) and (Key <= #$0039) then
              begin
                FSelStart := -1;
                FSelEnd := -1;
                Caption := CopyAnisText(Caption, 1, pStart) + CopyAnisText(Caption, pEnd + 1, AnsiTextLength(Caption));
                FCurPos := pStart;
                FSecondChineseChar := False;
                if AnsiTextLength(Caption) < FMaxLength then
                begin
                  Caption := CopyAnisText(Caption, 1, FCurPos) + Key + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
                  Inc(FCurPos);
                end
                else
                  Beep;
              end
              else
                Beep;
            end
            else
            begin
              FSelStart := -1;
              FSelEnd := -1;
              Caption := CopyAnisText(Caption, 1, pStart) + CopyAnisText(Caption, pEnd + 1, AnsiTextLength(Caption));
              FCurPos := pStart;
              if Key > #$0080 then
              begin
                if FSecondChineseChar then
                begin
                  FSecondChineseChar := False;
                  if AnsiTextLength(Caption) < FMaxLength then
                  begin
                    Caption := CopyAnisText(Caption, 1, FCurPos) + Key + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
                    Inc(FCurPos, 2);
                  end
                  else
                    Beep;
                end
                else
                begin
                  if AnsiTextLength(Caption) + 1 < FMaxLength then
                  begin
                    FSecondChineseChar := True;
                    Caption := CopyAnisText(Caption, 1, FCurPos) + Key + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
                    Inc(FCurPos, 2);
                  end
                  else
                    Beep;
                end;
              end
              else
              begin
                FSecondChineseChar := False;
                if AnsiTextLength(Caption) < FMaxLength then
                begin
                  Caption := CopyAnisText(Caption, 1, FCurPos) + Key + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
                  Inc(FCurPos);
                end
                else
                  Beep;
              end;
            end;
          end
          else
          begin
            if FNomberOnly then
            begin
              if (Key >= #$0030) and (Key <= #$0039) then
              begin
                FSelStart := -1;
                FSelEnd := -1;
                FSecondChineseChar := False;
                if AnsiTextLength(Caption) < FMaxLength then
                begin
                  Caption := CopyAnisText(Caption, 1, FCurPos) + Key + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
                  Inc(FCurPos);
                end;
              end
              else
                Beep;
            end
            else
            begin
              FSelStart := -1;
              FSelEnd := -1;
              if Key > #$0080 then
              begin
                if FSecondChineseChar then
                begin
                  FSecondChineseChar := False;
                  if AnsiTextLength(Caption) < FMaxLength then
                  begin
                    Caption := CopyAnisText(Caption, 1, FCurPos) + Key + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
                    Inc(FCurPos, 2);
                    FSelStart := FCurPos;
                  end
                  else
                    Beep;
                end
                else
                begin
                  if AnsiTextLength(Caption) + 1 < FMaxLength then
                  begin
                    FSecondChineseChar := True;
                    Caption := CopyAnisText(Caption, 1, FCurPos) + Key + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
                    Inc(FCurPos, 2);
                    FSelStart := FCurPos;
                  end
                  else
                    Beep;
                end;
              end
              else
              begin
                FSecondChineseChar := False;
                if AnsiTextLength(Caption) < FMaxLength then
                begin
                  Caption := CopyAnisText(Caption, 1, FCurPos) + Key + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
                  Inc(FCurPos);
                  FSelStart := FCurPos;
                end
                else
                  Beep;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    if s <> Caption then
    begin
      if Assigned(FOnTextChanged) then
        FOnTextChanged(self, Caption);
    end;
  end;
end;

function TDCustomEdit.KeyPressEx(var Key: Char): Boolean;
var
  s, cStr: string;
  i, nlen, cpLen: Integer;
  pStart: Integer;
  pEnd: Integer;
begin
  if not FEnabled or FIsHotKey then
    Exit;
  if not self.Visible then
    Exit;
  if (self.DParent = nil) or (not self.DParent.Visible) then
    Exit;
  s := Caption;
  try
    if not FNomberOnly and (Ord(Key) in [1..27]) then
    begin
      if (Ord(Key) = 22) then
      begin
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Clipboard.AsText;
          if cStr <> '' then
          begin
            cpLen := FMaxLength - AnsiTextLength(Caption) + abs(FSelStart - FSelEnd);
            FSelStart := -1;
            FSelEnd := -1;
            Caption := CopyAnisText(Caption, 1, pStart) + CopyAnisText(Caption, pEnd + 1, AnsiTextLength(Caption));
            FCurPos := pStart;
            nlen := AnsiTextLength(cStr);
            if nlen < cpLen then
              cpLen := nlen;
            Caption := CopyAnisText(Caption, 1, FCurPos) + CopyAnisText(cStr, 1, cpLen) + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
            Inc(FCurPos, cpLen);
          end;
        end
        else
        begin
          cpLen := FMaxLength - AnsiTextLength(Caption);
          if cpLen > 0 then
          begin
            cStr := Clipboard.AsText;
            if cStr <> '' then
            begin
              nlen := AnsiTextLength(cStr);
              if nlen < cpLen then
                cpLen := nlen;
              Caption := CopyAnisText(Caption, 1, FCurPos) + CopyAnisText(cStr, 1, cpLen) + CopyAnisText(Caption, FCurPos + 1, AnsiTextLength(Caption));
              Inc(FCurPos, cpLen);
            end;
          end
          else
            Beep;
        end;
      end;
      if (Ord(Key) = 3) and (FPasswordChar = #0000) and (Caption <> '') then
      begin
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := CopyAnisText(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then
          begin
            Clipboard.AsText := cStr;
          end;
        end;
      end;
      if (Ord(Key) = 24) and (FPasswordChar = #0000) and (Caption <> '') then
      begin
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := CopyAnisText(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then
          begin
            Clipboard.AsText := cStr;
          end;
          FSelStart := -1;
          FSelEnd := -1;
          Caption := CopyAnisText(Caption, 1, pStart) + CopyAnisText(Caption, pEnd + 1, AnsiTextLength(Caption));
          FCurPos := pStart;
        end;
      end;
      if (Ord(Key) = 1) and not FIsHotKey and (Caption <> '') then
      begin
        FSelStart := 0;
        FSelEnd := AnsiTextLength(Caption);
        FCurPos := FSelEnd;
      end;
      if (Ord(Key) = VK_BACK) and not FIsHotKey and (Caption <> '') then
      begin
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
        begin
          if FSelStart > FSelEnd then
          begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then
          begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          FSelStart := -1;
          FSelEnd := -1;
          Caption := CopyAnisText(Caption, 1, pStart) + CopyAnisText(Caption, pEnd + 1, AnsiTextLength(Caption));
          FCurPos := pStart;
        end;
      end;
    end;
  finally
    if s <> Caption then
    begin
      if Assigned(FOnTextChanged) then
        FOnTextChanged(self, Caption);
    end;
  end;
end;

procedure TDCustomEdit.Enter;
begin
  inherited;
end;
procedure TDCustomEdit.Leave;
begin
  FSelStart := -1;
  FSelEnd := -1;
  inherited;
end;

function TDCustomEdit.SetOfHotKey(HotKey: Cardinal): Word;
var
  Modifiers, Key: Word;
  Atom: Word;
begin
  Result := 0;
  if (HotKey <> 0){ and Assigned(HotKeyProc) and not HotKeyProc(HotKey)} then
  begin
    if FAtom <> 0 then
    begin
      UnregisterHotKey(g_MainHWnd, FAtom);
      GlobalDeleteAtom(FAtom);
    end;
    Result := 0;
    FHotKey := HotKey;
    Caption := HotKeyToText(HotKey, True);
  end;
end;

function TDCustomEdit.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  pStart, pEnd: Integer;
  M: Word;
  HK: Cardinal;
  ret       : Boolean;
  s, tmpStr: string;
begin
  Result := False;
  if not FEnabled then
    Exit;
  s := Caption;
  try
    ret := inherited KeyDown(Key, Shift);
    if ret then
    begin
      if FIsHotKey then
      begin
        if Key in [VK_BACK, VK_DELETE] then
        begin
          if (FHotKey <> 0) then
          begin
            FHotKey := 0;
            FAtom := 0;
          end;
          Caption := '';
          Result := True;
          Exit;
        end;
        if (Key = VK_TAB) or (Char(Key) in ['A'..'Z', 'a'..'z']) then
        begin
          M := 0;
          if ssCtrl in Shift then
            M := M or MOD_CONTROL;
          if ssAlt in Shift then
            M := M or MOD_ALT;
          if ssShift in Shift then
            M := M or MOD_SHIFT;
          HK := GetHotKey(M, Key);
          if (HK <> 0) and (FHotKey <> 0) then
          begin
            FAtom := 0;
            FHotKey := 0;
            Caption := '';
          end;
          if (HK <> 0) then
            SetOfHotKey(HK);
          Result := True;
        end;
      end
      else
      begin
        if (Char(Key) in ['0'..'9', 'A'..'Z', 'a'..'z']) then
          ShowCaret();
        if ssShift in Shift then
        begin
          case Key of
            VK_RIGHT:
              begin
                FSelClickEnd := True;
                ChangeCurPos(1);
                Result := True;
              end;
            VK_LEFT:
              begin
                FSelClickEnd := True;
                ChangeCurPos(-1);
                Result := True;
              end;
            VK_HOME:
              begin
                FSelEnd := FCurPos;
                FSelStart := 0;
                Result := True;
              end;
            VK_END:
              begin
                FSelStart := FCurPos;
                FSelEnd := AnsiTextLength(Text);
                Result := True;
              end;
          end;
        end
        else
        begin
          case Key of
            VK_LEFT:
              begin
                FSelStart := -1;
                FSelEnd := -1;
                FSelClickStart := True;
                ChangeCurPos(-1);
                Result := True;
              end;
            VK_RIGHT:
              begin
                FSelStart := -1;
                FSelEnd := -1;
                FSelClickStart := True;
                ChangeCurPos(1);
                Result := True;
              end;
            VK_HOME:
              begin
                FSelStart := -1;
                FSelEnd := -1;
                FCurPos := 0;
                FSelClickStart := True;
                Result := True;
              end;
            VK_END:
              begin
                FSelStart := -1;
                FSelEnd := -1;
                FCurPos := AnsiTextLength(Text);
                FSelClickStart := True;
                Result := True;
              end;
            VK_DELETE:
              begin
                if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then
                begin
                  if FSelStart > FSelEnd then
                  begin
                    pStart := FSelEnd;
                    pEnd := FSelStart;
                  end;
                  if FSelStart < FSelEnd then
                  begin
                    pStart := FSelStart;
                    pEnd := FSelEnd;
                  end;
                  FSelStart := -1;
                  FSelEnd := -1;
                  Caption := CopyAnisText(Caption, 1, pStart) + CopyAnisText(Caption, pEnd + 1, AnsiTextLength(Caption));
                  FCurPos := pStart;
                end
                else
                begin
                  if FCurPos < AnsiTextLength(Caption) then
                  begin
                    pEnd := 1;
                    case ByteType(AnsiString(Caption), FCurPos + 1) of
                      mbSingleByte:
                        pEnd := 1;
                      mbLeadByte:
                        pEnd := 2;
                      mbTrailByte:
                        pEnd := 2;
                    end;
                    Caption := CopyAnisText(Caption, 1, FCurPos) + CopyAnisText(Caption, FCurPos + pEnd + 1, AnsiTextLength(Caption));

                  end;
                end;
                Result := True;
              end;
          end;
        end;
      end;
    end;
//    Result := ret;
  finally
    if s <> Caption then
    begin
      if Assigned(FOnTextChanged) then
        FOnTextChanged(self, Caption);
    end;
  end;
end;

procedure TDCustomEdit.DirectPaint(dsurface: TAsphyreCanvas);
var
  bFocused, bIsChinese: Boolean;
  i, ii, oCSize, WidthX, WidthX2, nl, nr, nt: Integer;
  tmpword: string;
  tmpColor, OldColor, OldBColor: TColor;
  ob, op, ofc, oFColor: TColor;
  OldFont: TFont;
  off, ss, se, cPos: Integer;
  ATextLine: TAsphyreLockableTexture;
  ATextureFont: TAsphyreTextureFont;
//  procedure DrawText;
//  var
//    i, ii: Integer;
//    sL,sSel,sR: string;
//  begin
//    if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) and (FocusedControl = self) then
//    begin
//      if FSelStart < FSelEnd then begin
//        i := FSelStart;
//        ii := FSelEnd;
//      end else begin
//        ii := FSelStart;
//        i := FSelEnd;
//      end;
//      ConsoleDebug('FSelStart := ' + IntToStr(FSelStart)+' FSelEnd := ' + IntToStr(FSelEnd));
//
//      sL := CopyAnisText(tmpword, 1, i);
//      sSel := CopyAnisText(tmpword, i +1, ii - i);
//      sR := CopyAnisText(tmpword, ii + 1, 999);
//      ss := FontManager.Default.TextWidth(sL);
//      se := FontManager.Default.TextWidth(sSel);
//      if sL <> '' then
//        dsurface.TextOut(nl - FStartTextX, nt - Integer(FMiniCaret), sL, Font.Color);
//      if sR <> '' then
//        dsurface.TextOut(nl - FStartTextX + ss + se, nt - Integer(FMiniCaret), sR, Font.Color);
//
//      dsurface.TextRect(Bounds(_MAX(nl - 1, nl + ss - 1 - FStartTextX),
//      nt - Integer(FMiniCaret),
//      _MIN(self.Width + 1, se + 1 - FStartTextX),
//      FontManager.Default.TextHeight('日') + 1),
//        nl - FStartTextX + ss, nt - Integer(FMiniCaret), sSel,clWhite, clBlue);
//    end else
//    case FAlignment of
//      taCenter:
//        dsurface.TextOut((nl - FStartTextX) + ((Width - FontManager.Default.TextWidth(tmpword)) div 2 - 2), nt - Integer(FMiniCaret) * 1, tmpword, Font.Color);
//      taLeftJustify:
//        begin
//          ss := nl - FStartTextX;
//          dsurface.TextOut(ss, nt - Integer(FMiniCaret), Ansistring(tmpword), Font.Color);
//        end;
//    end;
//  end;
begin
  if not Visible then
    Exit;
  ATextureFont := FontManager.GetFont('宋体',9,[]);
  nl := SurfaceX(Left);
  nt := SurfaceY(Top);
  if (FocusedControl <> self) and (DHint <> nil) then
    DHint.Visible := False;
  if FEnabled and not FIsHotKey then
  begin
    if GetTickCount - FShowCaretTick >= 400 then
    begin
      FShowCaretTick := GetTickCount;
      FShowCaret := not FShowCaret;
    end;
    if (FCurPos > AnsiTextLength(Caption)) then
      FCurPos := AnsiTextLength(Caption);
  end;
  if (FPasswordChar <> #0000) and not FIsHotKey then
  begin
    tmpword := '';
    for i := 1 to AnsiTextLength(Caption) do
      if Caption[i] <> FPasswordChar then
        tmpword := tmpword + FPasswordChar;
  end
  else
    tmpword := Ansistring(Caption);

  if not FIsHotKey and FEnabled and FClick then
  begin
    FClick := False;
    if (FClickX < 0) then
      FClickX := 0;
    se := FontManager.Default.TextWidth(tmpword);
    if FClickX > se then
      FClickX := se;

    cPos := FClickX div 6;
//    ConsoleDebug('cPos := ' + IntToStr(cPos));
    case ByteType(AnsiString(Caption), cPos + 1) of
      mbSingleByte:
        begin
        FCurPos := cPos;
        end;
      mbLeadByte:
        begin
          FCurPos := cPos;
        end;
      mbTrailByte:
        begin
          if cPos mod 2 = 0 then
          begin
            if FClickX mod 6 in [3..5] then
              FCurPos := cPos + 1
            else
              FCurPos := cPos - 1;
          end
          else
          begin
            if FClickX mod 12 in [6..11] then
              FCurPos := cPos + 1
            else
              FCurPos := cPos - 1;
          end;
        end;
    end;
    if FSelClickStart then
    begin
      FSelClickStart := False;
      FSelStart := FCurPos;
    end;
    if FSelClickEnd then
    begin
      FSelClickEnd := False;
      FSelEnd := FCurPos;
    end;
  end;

  WidthX := FontManager.Default.TextWidth(CopyAnisText(tmpword, 1, FCurPos));
  if WidthX + 3 - FStartTextX > Width then
    FStartTextX := WidthX + 3 - Width;
  if ((WidthX - FStartTextX) < 0) then
    FStartTextX := FStartTextX + (WidthX - FStartTextX);
  if FTransparent then
  begin
    if FEnabled then
    begin
      if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) and (FocusedControl = self) then begin
        ss := FontManager.Default.TextWidth(CopyAnisText(tmpword, 1, FSelStart));
        se := FontManager.Default.TextWidth(CopyAnisText(tmpword, 1, FSelEnd));
        //增加选取复制文字背景
        dsurface.FillRectAlpha(Rect(_MAX(nl - 1, nl + ss - 1 - FStartTextX),
                                         nt - 1 - Integer(FMiniCaret),
                                         _MIN(nl + self.Width + 1, nl + se + 1 - FStartTextX),
                                         nt + FontManager.Default.TextHeight('c') + 1 - Integer(FMiniCaret)),
                                         dxColorToAlphaColor(RGB(0, 0, 128), 255), 255);
      end;
      case FAlignment of
        taCenter: begin
            dsurface.TextOut((nl - FStartTextX) + ((Width - FontManager.Default.TextWidth(tmpword)) div 2 - 2), nt+2, tmpword, self.Font.Color);
          end;
        taLeftJustify: begin
            ss := nl - FStartTextX;
            // 绘制文字
            ATextLine := ATextureFont.TextOut(tmpword);
            if ATextLine <> nil then
            begin
              dsurface.DrawInRect((nl - FStartTextX), nt - Integer(FMiniCaret) * 1,
              Rect(nl, nt - Integer(FMiniCaret), nl + Width - 1, nt + Height - 1),
              ATextLine, cColor4(cColor1(self.Font.Color)));
            end;

            if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) and (FocusedControl = self) then begin
              if FSelStart < FSelEnd then begin
                i := FSelStart;
                ii := FSelEnd;
              end else begin
                ii := FSelStart;
                i := FSelEnd;
              end;
              ss := FontManager.Default.TextWidth(CopyAnisText(tmpword, 1, i));
              se := FontManager.Default.TextWidth(CopyAnisText(tmpword, 1, ii));
              //增加选取复制文字颜色

              ATextLine := ATextureFont.TextOut(tmpword);
              if ATextLine <> nil then
              begin
                dsurface.DrawInRect((nl - FStartTextX), nt - Integer(FMiniCaret) * 1,
                Rect(_MAX(nl - 1, nl + ss - 1 - FStartTextX),
                                          nt - 1 - Integer(FMiniCaret),
                                          _MIN(nl + self.Width - 1, nl + se + 1 - FStartTextX),
                                          nt + FontManager.Default.TextHeight('c') + 1 - Integer(FMiniCaret)),
                ATextLine, cColor4(cColor1(FFontSelColor)));
              end;
            end;
          end;
      end;
//     if FNeedRedraw then
//      DrawText;
    end;
  end
  else
  begin
    if FFrameVisible then
    begin
      if FEnabled or (self is TDComboBox) then
      begin
        if FFrameHot then
          tmpColor := FFrameHotColor
        else
          tmpColor := $004A8494;
      end
      else
        tmpColor := FFrameColor;
      dsurface.FrameRect(Rect(nl - 3, nt - 3, nl + Width - 1, nt + Height - 1), tmpColor);
    end;
    if FIsHotKey then
    begin
      bFocused := FocusedControl = self;
      if FEnabled then
      begin
        dsurface.FillRect(Rect(nl + FFrameSize - 3 + Integer(bFocused), nt + FFrameSize - 3 + Integer(bFocused), nl + Width - FFrameSize - 1 - Integer(bFocused), nt + Height - FFrameSize - 1 - Integer(bFocused)), clBlack);
        if bFocused then
          tmpColor := clLime
        else
          tmpColor := self.Font.Color;
      end
      else
      begin
        dsurface.FillRect(Rect(nl + FFrameSize - 3, nt + FFrameSize - 3, nl + Width - FFrameSize - 1, nt + Height - FFrameSize - 1), self.Color);
        tmpColor := clGray;
      end;
      case FAlignment of
        taCenter:
          dsurface.TextOut((nl - FStartTextX) + ((Width - FontManager.Default.TextWidth(tmpword)) div 2 - 2), nt, tmpword, tmpColor);
        taLeftJustify:
          begin
            dsurface.TextOut(nl - FStartTextX, nt, tmpword, tmpColor);
          end;
      end;
    end
    else
    begin
      dsurface.FillRect(Rect(nl - 3 + FFrameSize, nt - 3 + FFrameSize, nl + Width - 1 - FFrameSize, nt + Height - 1 - FFrameSize), self.Color);
      if FEnabled then
      begin
//       if FNeedRedraw then
//        DrawText;
        //复制文字以及背景
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) and (FocusedControl = self) then begin
          if FSelStart < FSelEnd then begin
            i := FSelStart;
            ii := FSelEnd;
          end else begin
            ii := FSelStart;
            i := FSelEnd;
          end;
          ss := FontManager.Default.TextWidth(CopyAnisText(tmpword, 1, i));
          se := FontManager.Default.TextWidth(CopyAnisText(tmpword, 1, ii));
          //增加选取复制文字背景

          dsurface.FillRectAlpha(Rect(_MAX(nl - 1, nl + ss - 1 - FStartTextX),
                                      nt - 1 - Integer(FMiniCaret),
                                      _MIN(nl + self.Width - 1, nl + se + 1 - FStartTextX),
                                      nt + FontManager.Default.TextHeight('c') + 1 - Integer(FMiniCaret)),
                                      RGB(0, 0, 128), 255);
        end;

        case FAlignment of
          taCenter:   begin
              dsurface.TextOut(
                (nl - FStartTextX) + ((Width - FontManager.Default.TextWidth(tmpword)) div 2 - 2),
                nt - Integer(FMiniCaret) * 1,
                tmpword,self.Font.Color);
            end;
          taLeftJustify: begin
              ss := nl - FStartTextX;
              // 绘制文字
              ATextLine := ATextureFont.TextOut(tmpword);
              if ATextLine <> nil then
              begin
                dsurface.DrawInRect((nl - FStartTextX), nt - Integer(FMiniCaret) * 1,
                Rect(nl, nt - Integer(FMiniCaret), nl + Width - 1, nt + Height - 1),
                ATextLine, cColor4(cColor1(self.Font.Color)));
              end;


              if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) and (FocusedControl = self) then begin
                if FSelStart < FSelEnd then begin
                  i := FSelStart;
                  ii := FSelEnd;
                end else begin
                  ii := FSelStart;
                  i := FSelEnd;
                end;
                ss := FontManager.Default.TextWidth(CopyAnisText(tmpword, 1, i));
                se := FontManager.Default.TextWidth(CopyAnisText(tmpword, 1, ii));
                //增加选取复制文字颜色

                ATextLine := ATextureFont.TextOut(tmpword);
                if ATextLine <> nil then
                begin
                  dsurface.DrawInRect((nl - FStartTextX), nt - Integer(FMiniCaret) * 1,
                  Rect(_MAX(nl - 1, nl + ss - 1 - FStartTextX),
                                            nt - 1 - Integer(FMiniCaret),
                                            _MIN(nl + self.Width - 1, nl + se + 1 - FStartTextX),
                                            nt + FontManager.Default.TextHeight('c') + 1 - Integer(FMiniCaret)),
                  ATextLine, cColor4(cColor1(FFontSelColor)));
                end;
              end;
            end;
        end;
      end
      else
      begin
        case FAlignment of
          taCenter:
            dsurface.TextOut((nl - FStartTextX) + ((Width - FontManager.Default.TextWidth(tmpword)) div 2 - 2), nt - Integer(FMiniCaret) * 1, tmpword, clGray);
          taLeftJustify:
            begin
              ss := nl - FStartTextX;
              Brush.Style := bsClear;
              if FEnabled or (self is TDComboBox) then
              begin
                if FFrameHot then
                  tmpColor := $00FFFF
                else
                  tmpColor := Font.Color;
              end
              else
                tmpColor := Font.Color;
              dsurface.TextOut(ss, nt - Integer(FMiniCaret), string(tmpword), tmpColor);
            end;
        end;
      end;
    end;
    if self is TDComboBox then begin
      dsurface.FillTri(
        Point(nl + Width - DECALW * 2 + Integer(Downed),
           nt + (Height - DECALH) div 2 - 2 + Integer(Downed)),
          Point(nl + Width - DECALW + Integer(Downed),
          nt + (Height - DECALH) div 2 - 2 + Integer(Downed)),
          Point(nl + Width - DECALW - DECALW div 2 + Integer(Downed),
          nt + (Height - DECALH) div 2 + DECALH - 2 + Integer(Downed))
          ,cColor1(tmpColor),cColor1(tmpColor),cColor1(tmpColor));

    end;

  end;

  if (Text = '') and (m_InputHint <> '') then
  begin
    dsurface.TextOut(nl + self.Width - FontManager.Default.TextWidth(m_InputHint) - 4, nt - Integer(FMiniCaret), clGray, m_InputHint);
  end;

  if FEnabled then
  begin
    if (FocusedControl = self) then
    begin
//      if FNeedRedraw then
      begin
        SetFrameHot(True);
        if (AnsiTextLength(Caption) >= FCurPos) and (FShowCaret and not FIsHotKey) then
        begin
          case FAlignment of
            taCenter:
              begin
                dsurface.FillRect(Rect(nl + WidthX - FStartTextX + ((Width - FontManager.Default.TextWidth(tmpword)) div 2 - 2),
                nt - Integer(FMiniCaret <> 0) * 1,
                nl + WidthX + 2 - Integer(FMiniCaret <> 0) - FStartTextX + ((Width - FontManager.Default.TextWidth(tmpword)) div 2 - 2),
                nt - Integer(FMiniCaret <> 0) * 1 + FontManager.Default.TextHeight('c')), cColor1(FCaretColor));
              end;
            taLeftJustify:
              begin
                WidthX2 := -1;
                if WidthX <> 0 then
                  WidthX2 := 1;
                dsurface.FillRect(Rect( //
                nl + WidthX - FStartTextX,//
                nt - Integer(FMiniCaret) * 1 - Integer(FMiniCaret = 0), //
                nl + WidthX + 2 - FStartTextX - Integer(FMiniCaret <> 0),//
                nt - Integer(FMiniCaret) * 1 + FontManager.Default.TextHeight('c') + Integer(FMiniCaret = 0)), cColor1(FCaretColor));
              end;
          end;
        end;
      end;
    end;
  end;

  for i := 0 to DControls.count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
      DragModePaint(dsurface);
end;

function TDCustomEdit.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  FSelClickEnd := False;
  if inherited MouseMove(Shift, X, Y) then
  begin
    if [ssLeft] = Shift then
    begin
      if FEnabled and not FIsHotKey and (MouseCaptureControl = self) and (Caption <> '') then
      begin
        FClick := True;
        FSelClickEnd := True;
        FClickX := X - Left + FStartTextX;
      end;
    end
    else
    begin

    end;
    Result := True;
  end;
end;

function TDCustomEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  FSelClickStart := False;
  if inherited MouseDown(Button, Shift, X, Y) then
  begin
    if FEnabled and not FIsHotKey and (MouseCaptureControl = self) then
    begin
      if Button = mbLeft then
      begin
        FSelEnd := -1;
        FSelStart := -1;
        FClick := True;
        FSelClickStart := True;
        FClickX := X - Left + FStartTextX;
      end;
    end
    else
    begin

    end;
    Result := True;
  end;
end;

function TDCustomEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  FSelClickEnd := False;
  if inherited MouseUp(Button, Shift, X, Y) then
  begin
    if FEnabled and not FIsHotKey and (MouseCaptureControl = self) then
    begin
      if Button = mbLeft then
      begin
        FSelEnd := -1;
        FClick := True;
        FSelClickEnd := True;
        FClickX := X - Left + FStartTextX;
      end;
    end
    else
    begin

    end;
    Result := True;
  end;
end;

constructor TDComboBox.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  DropDownList := nil;
  FShowCaret := False;
  FTransparent := False;
  FEnabled := False;
  FDropDownList := nil;
end;

function TDComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;

begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then
  begin
    if (not Background) and (MouseCaptureControl = nil) then
    begin
      Downed := True;
      SetDCapture(self);
    end;
    if (FDropDownList <> nil) and not FDropDownList.ChangingHero then
    begin
      FDropDownList.Left := Left - 3;
      FDropDownList.Top := Top + Height;
      FDropDownList.Height := (FontManager.Default.TextHeight('A') + LineSpace) * (FDropDownList.Items.Count) + 2;
      FDropDownList.Visible := not FDropDownList.Visible;
    end;
    Result := True;
  end
  else if FDropDownList <> nil then
  begin
    if FDropDownList.Visible then
      FDropDownList.Visible := False;
  end;
end;

function TDComboBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if not Background then
  begin
    if Result then
      SetFrameHot(True)
    else if FocusedControl <> self then
      SetFrameHot(False);
  end;
end;

constructor TASPCustomListBox.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FSelected := -1;
  ChangingHero := False;
  FItems := TStringList.Create;
  FBackColor := clWhite;
  FSelectionColor := clSilver;
  FOnChangeSelect := nil;
  FOnMouseMoveSelect := nil;
  ParentComboBox := nil;
  FParentComboBox := nil;
end;

destructor TASPCustomListBox.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TASPCustomListBox.GetItemSelected: Integer;
begin
  if (FSelected > FItems.count - 1) or (FSelected < 0) then
    Result := -1
  else
    Result := FSelected;
end;

procedure TASPCustomListBox.SetItemSelected(Value: Integer);
begin
  if (Value > FItems.count - 1) or (Value < 0) then
    FSelected := -1
  else
    FSelected := Value;
end;

procedure TASPCustomListBox.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TASPCustomListBox.SetSelectionColor(Value: TColor);
begin
  if FSelectionColor <> Value then
  begin
    FSelectionColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

function TASPCustomListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
end;

function TASPCustomListBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  TmpSel: Integer;
begin
  FSelected := -1;
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FEnabled and not Background then
  begin
    TmpSel := FSelected;
    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y) div (FontManager.Default.TextHeight('A') + LineSpace);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
    if Assigned(FOnMouseMoveSelect) then
      FOnMouseMoveSelect(self, Shift, X, Y);
  end;
end;

function TASPCustomListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret: Boolean;
  TmpSel: Integer;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if ret then
  begin
    TmpSel := FSelected;

    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y) div (FontManager.Default.TextHeight('A') + LineSpace);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
    if FSelected <> -1 then
    begin
      if ParentComboBox <> nil then
      begin
        if ParentComboBox.Caption <> FItems[FSelected] then
        begin
          if Caption = 'SelectHeroList' then
          begin
            ChangingHero := True;
//             frmDlg.QueryChangeHero(FItems[FSelected]);
          end
          else
          begin
            ParentComboBox.Caption := FItems[FSelected];
            if Assigned(ParentComboBox.FOnTextChanged) then
              ParentComboBox.FOnTextChanged(self, Caption);
          end;
        end;
      end;
      if Integer(FItems.Objects[FSelected]) > 0 then
        ParentComboBox.tag := Integer(FItems.Objects[FSelected]);
    end;
    if Assigned(FOnChangeSelect) then
      FOnChangeSelect(self, Button, Shift, X, Y);
    Visible := False;
    ret := True;
  end;
  Result := ret;
end;

function TASPCustomListBox.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  ret: Boolean;
begin
  ret := inherited KeyDown(Key, Shift);
  if ret then
  begin
    case Key of
      VK_PRIOR:
        begin
          ItemSelected := ItemSelected - Height div  - FontManager.Default.TextHeight('A');
          if (ItemSelected = -1) then
            ItemSelected := 0;
        end;
      VK_NEXT:
        begin
          ItemSelected := ItemSelected + Height div  - FontManager.Default.TextHeight('A');
          if ItemSelected = -1 then
            ItemSelected := FItems.count - 1;
        end;
      VK_UP:
        if ItemSelected - 1 > -1 then
          ItemSelected := ItemSelected - 1;
      VK_DOWN:
        if ItemSelected + 1 < FItems.count then
          ItemSelected := ItemSelected + 1;
    end;

  end;
  Result := ret;
end;

procedure TASPCustomListBox.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;
procedure TASPCustomListBox.DirectPaint(dsurface: TAsphyreCanvas);
var
  fy, nY, L, T, i, oSize: Integer;
  OldColor: TColor;
begin
  if Assigned(FOnDirectPaint) then
  begin
    FOnDirectPaint(self, dsurface);
    Exit;
  end;
  L := SurfaceX(Left);
  T := SurfaceY(Top);
  try
    dsurface.FillRect(Rect(L, T, L + Self.Width, T + Self.Height), $F1FBFF{(BackColor)});
    if FSelected <> -1 then
    begin
      nY := T + (FontManager.Default.TextHeight('A') + LineSpace) * FSelected;
      fy := nY + (FontManager.Default.TextHeight('A') + LineSpace);
      if (nY < T + Self.Height - 1) and (fy > T + 1) then
      begin
        if (fy > T + Self.Height - 1) then
          fy := T + Self.Height - 1;
        if (nY < T + 1) then
          nY := T + 1;
        dsurface.FillRect(Rect(L + 1, nY, L + Self.Width - 1, fy), (SelectionColor));
      end;
    end;
    for i := 0 to FItems.count - 1 do
    begin
      if FSelected = i then
      begin
        dsurface.TextOut(L + 2, 2 + T + (FontManager.Default.TextHeight('A') + LineSpace) * i, FItems.Strings[i], clWhite);
      end
      else
      begin
        dsurface.TextOut(L + 2, 2 + T + (FontManager.Default.TextHeight('A') + LineSpace) * i, FItems.Strings[i], clBlack);
      end;
    end;
  finally
  end;
  DragModePaint(dsurface);
end;

procedure TDUpDown.ButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FClickTime := GetTickCount;
  if Sender = FUpButton then begin
    if FPosition >= FMovePosition then
      Dec(FPosition, FMovePosition)
    else
      FPosition := 0;
    FAddTop := Round(FMaxLength / FMaxPosition * FPosition);
    if Assigned(FOnPositionChange) then
      FOnPositionChange(Self);
  end
  else if Sender = FDownButton then begin
    if (FPosition + FMovePosition) <= FMaxPosition then
      Inc(FPosition, FMovePosition)
    else
      FPosition := FMaxPosition;
    FAddTop := Round(FMaxLength / FMaxPosition * FPosition);
    if Assigned(FOnPositionChange) then
      FOnPositionChange(Self);
  end
  else if Sender = FMoveButton then begin
    StopY := Y;
    FStopY := FAddTop;
  end;
  if Assigned(FOnMouseDown) then
    FOnMouseDown(self, Button, Shift, X, Y);
end;

procedure TDUpDown.ButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
  Integer);
var
  nIdx: Integer;
  OldPosition: Integer;
  nY: Integer;
  DButton: TDButton;
begin
  if Sender = FUpButton then begin
    DButton := TDButton(Sender);
    if (DButton.Downed) and ((GetTickCount - FClickTime) > 100) then
      ButtonMouseDown(Sender, mbLeft, Shift, X, Y);
  end
  else if Sender = FDownButton then begin
    DButton := TDButton(Sender);
    if (DButton.Downed) and ((GetTickCount - FClickTime) > 100) then
      ButtonMouseDown(Sender, mbLeft, Shift, X, Y);
  end
  else if Sender = FMoveButton then begin
    if (StopY < 0) or (StopY = y) then begin
      if Assigned(FOnMouseMove) then
        FOnMouseMove(self, Shift, X, Y);
      Exit;
    end;
    if FMaxPosition <> 0 then
    begin
    nY := Y - StopY;
    FAddTop := FStopY + nY;
    if FAddTop < 0 then
      FAddTop := 0;
    if FAddTop > FMaxLength then
      FAddTop := FMaxLength;

    OldPosition := FPosition;
    nIdx := Round(FAddTop / (FMaxLength / FMaxPosition));
    if nIdx <= 0 then
      FPosition := 0
    else if nIdx >= FMaxPosition then
      FPosition := FMaxPosition
    else
      FPosition := nIdx;
    end;
    if OldPosition <> FPosition then
      if Assigned(FOnPositionChange) then
        FOnPositionChange(Self);
  end;
  if Assigned(FOnMouseMove) then
    FOnMouseMove(self, Shift, X, Y);
end;

procedure TDUpDown.ButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  StopY := -1;
  if Assigned(FOnMouseUp) then
    FOnMouseUp(self, Button, Shift, X, Y);
end;

constructor TDUpDown.Create(AOwner: TComponent);
begin
  inherited;
  FUpButton := TDButton.Create(nil);
  FDownButton := TDButton.Create(nil);
  FMoveButton := TDButton.Create(nil);


  SetButton(UpButton);
  SetButton(DownButton);
  SetButton(MoveButton);

  FOffset := 1;
  FBoMoveShow := False;
  FboMoveFlicker := False;
  FboNormal := False;

  FMovePosition := 1;
  FPosition := 0;
  FMaxPosition := 0;
  FMaxLength := 0;
  FTop := 0;
  FAddTop := 0;
  StopY := -1;
//  FWheelDControl := Self;
end;

destructor TDUpDown.Destroy;
begin
  FUpButton.Free;
  FDownButton.Free;
  FMoveButton.Free;
  inherited;
end;

//function TDUpDown.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
//begin
//  Result := False;
//  if inherited MouseDown(Button, Shift, X, Y) then
//  begin
////    if FEnabled and not FIsHotKey and (MouseCaptureControl = self) then
////    begin
////      if Button = mbLeft then
////      begin
////        FSelEnd := -1;
////        FSelStart := -1;
////        FClick := True;
////        FSelClickStart := True;
////        FClickX := X - Left + FStartTextX;
////      end;
////    end
////    else
////    begin
////
////    end;
//    Result := True;
//  end;
//end;

function TDUpDown.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then
  begin
    if (not Background) and (MouseCaptureControl = nil) then
    begin
      Downed := True;
      SetDCapture(self);
    end;
    Result := True;
  end;
end;

function TDUpDown.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y:
  Integer): Boolean;
var
  nIdx: Integer;
  OldPosition: Integer;
  nY: Integer;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then
  begin
    ReleaseDCapture;
    if (not Background) {and (MouseCaptureControl = Self)} then
    begin
      if InRange(X, Y, Shift) then
      begin
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
        if (MouseCaptureControl <> FUpButton) and (MouseCaptureControl <> FDownButton) then
        begin
          if FMaxPosition <> 0 then
          begin
          nY := Y - 52 - FMoveButton.Height div 2;
          FAddTop := nY{ - FStopY};
          if FAddTop < 0 then
            FAddTop := 0;
          if FAddTop > FMaxLength then
            FAddTop := FMaxLength;
          if FMaxPosition = 0 then
            FAddTop := FMaxLength;

          OldPosition := FPosition;
          nIdx := Round(FAddTop / (FMaxLength / FMaxPosition));
          if nIdx <= 0 then
            FPosition := 0
          else if nIdx >= FMaxPosition then
            FPosition := FMaxPosition
          else
            FPosition := nIdx;
          if OldPosition <> FPosition then
            if Assigned(FOnPositionChange) then
              FOnPositionChange(Self);
          end;
        end;
      end;
      Downed := FALSE;
      Result := TRUE;
      exit;
    end
  end
  else
  begin
    ReleaseDCapture;
    Downed := FALSE;
  end;
end;

procedure TDUpDown.DirectPaint(dsurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  dc, rc: TRect;
begin
  if WLib <> nil then begin
    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      dc.Left := SurfaceX(Left);
      dc.Top := SurfaceY(Top);
      dc.Right := SurfaceX(left + Width);
      dc.Bottom := SurfaceY(top + Height);
      rc.Left := 0;
      rc.Top := 0;
      rc.Right := d.ClientRect.Right;
      rc.Bottom := d.ClientRect.Bottom;
      dsurface.StretchDraw(dc, rc, d, clWhite4, True);
    end;
    if FUpButton <> nil then begin
      with FUpButton do begin
        if FboNormal then begin
          Left := FOffset;
          Top := 0;
        end else begin
          Left := FOffset;
          Top := FOffset;
        end;
        if Downed then begin
          d := WLib.Images[FaceIndex + 1 + Integer(FBoMoveShow)];
        end
        else if Arrived then begin
          d := WLib.Images[FaceIndex + Integer(FBoMoveShow)];
        end
        else begin
          d := WLib.Images[FaceIndex];
        end;
        if d <> nil then begin
          FTop := d.Height + Top;
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end;
      end;
    end;
    if FDownButton <> nil then begin
      with FDownButton do begin
        if FboNormal then begin
          Left := FOffset;
          Top := Self.Height - d.Height;
        end else begin
          Left := FOffset;
          if FBoMoveShow then
            Top := Self.Height - d.Height + 1
          else
            Top := Self.Height - d.Height - 1;
        end;


        if Downed then begin
          d := WLib.Images[FaceIndex + 1 + Integer(FBoMoveShow)];
        end
        else if Arrived then begin
          d := WLib.Images[FaceIndex + Integer(FBoMoveShow)];
        end
        else begin
          d := WLib.Images[FaceIndex];
        end;
        if d <> nil then begin
          FMaxLength := Top - FTop;
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end;
      end;
    end;
    if FMoveButton <> nil then begin
      with FMoveButton do begin
        Left := FOffset;
        if FBoMoveShow then begin
          if Downed then begin
            d := WLib.Images[FaceIndex + 2];
          end
          else if Arrived then begin
            d := WLib.Images[FaceIndex + 1];
          end
          else begin
//            if FboMoveFlicker and ((GetTickCount - AppendTick) mod 400 < 200) then begin
//              d := WLib.Images[FaceIndex + 1];
//            end else
              d := WLib.Images[FaceIndex];
          end;
          if (d <> nil) then begin
            Dec(FMaxLength, d.Height);
            Top := FTop + FAddTop;
            if FMaxPosition > 0 then
              dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
          end;
        end
        else begin
          d := WLib.Images[FaceIndex];
          if d <> nil then begin
            Dec(FMaxLength, d.Height);
            Top := FTop + FAddTop;
            dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
          end;
        end;
      end;
    end;
  end;
  if Assigned(FOnEndDirectPaint) then
    FOnEndDirectPaint(self, dsurface);
end;

//function TDUpDown.MouseWheel(Shift: TShiftState; Wheel: TMouseWheel; X, Y: Integer): Boolean;
//begin
//  Result := True;
//  if Wheel = mw_Up then
//    ButtonMouseDown(FUpButton, mbLeft, Shift, X, Y)
//  else if Wheel = mw_Down then
//    ButtonMouseDown(FDownButton, mbLeft, Shift, X, Y);
//end;

procedure TDUpDown.SetButton(Button: TDButton);
begin
  Button.DParent := Self;
  Button.OnMouseMove := ButtonMouseMove;
//  Button.FWheelDControl := Self;
  Button.OnMouseDown := ButtonMouseDown;
  Button.OnMouseUp := ButtonMouseUp;
  AddChild(Button);
end;

procedure TDUpDown.SetMaxPosition(const Value: Integer);
var
  OldPosition: integer;
begin
  OldPosition := FMaxPosition;
  FMaxPosition := _Max(Value, 0);
  if OldPosition <> FMaxPosition then begin
    if FPosition > FMaxPosition then
      FPosition := FMaxPosition;
    if FMaxPosition >= 0 then
      FAddTop := Round(FMaxLength / FMaxPosition * FPosition);
  end;
end;

procedure TDUpDown.SetPosition(value: Integer);
var
  OldPosition: integer;
begin
  OldPosition := FPosition;
  FPosition := _Max(Value, 0);
  if FPosition > FMaxPosition then
    FPosition := FMaxPosition;
  if OldPosition <> FPosition then begin
    if FMaxPosition >= 0 then
      FAddTop := Round(FMaxLength / FMaxPosition * FPosition);
  end;
end;
{ TDMemo }

function TDMemo.ClearKey: Boolean;
var
  nStartY, nStopY: Integer;
  nStartX, nStopX: Integer;
  TempStr: WideString;
  i: Integer;
begin
  Result := False;
  if FLines.Count > 0 then begin
    if (FCaretX <> FSCaretX) or (FSCaretY <> FCaretY) then begin

      if FSCaretY < 0 then FSCaretY := 0;
      if FSCaretY >= FLines.Count then FSCaretY := FLines.Count - 1;
      if FCaretY < 0 then FCaretY := 0;
      if FCaretY >= FLines.Count then FCaretY := FLines.Count - 1;

      if FSCaretY = FCaretY then begin
        if FSCaretX > FCaretX then begin
          nStartX := FCaretX;
          nStopX := FSCaretX;
        end else begin
          nStartX := FSCaretX;
          nStopX := FCaretX;
        end;
        TempStr := TDMemoStringList(FLines).Str[FCaretY];
        Delete(TempStr, nStartX + 1, nStopX - nStartX);
        TDMemoStringList(FLines).Str[FCaretY] := TempStr;
        RefListWidth(FCaretY, 0);
        FCaretX := nStartX;
        SetCaret(True);
        Result := True;
      end else begin
        if FSCaretY > FCaretY then begin
          nStartY := FCaretY;
          nStopY := FSCaretY;
          nStartX := FCaretX;
          nStopX := FSCaretX;
        end else begin
          nStartY := FSCaretY;
          nStopY := FCaretY;
          nStartX := FSCaretX;
          nStopX := FCaretX;
        end;
        TempStr := TDMemoStringList(FLines).Str[nStartY];
        Delete(TempStr, nStartX + 1, 255);
        TDMemoStringList(FLines).Str[nStartY] := TempStr;

        TempStr := TDMemoStringList(FLines).Str[nStopY];
        Delete(TempStr, 1, nStopX);
        TDMemoStringList(FLines).Str[nStartY] := TDMemoStringList(FLines).Str[nStartY] + TempStr;
        FLines.Objects[nStartY] := FLines.Objects[nStopY];
        FLines.Delete(nStopY);
        if (nStopY - nStartY) > 1 then
          for i := nStopY - 1 downto nStartY + 1 do
            FLines.Delete(i);
        RefListWidth(nStartY, nStartX);
        SetCaret(True);
        Result := True;
      end;
    end;
  end;
end;

constructor TDMemo.Create(AOwner: TComponent);
begin
  inherited;
  FCaretShowTime := GetTickCount;

  Downed := False;
  KeyDowned := False;

  FTopIndex := 0;
  FCaretY := 0;
  FCaretX := 0;

  FSCaretX := 0;
  FSCaretY := 0;

  FUpDown := nil;

  FInputStr := '';
  bDoubleByte := False;
  KeyByteCount := 0;

  FTransparent := False;

  FMaxLength := 0;

  FOnChange := nil;
  FReadOnly := False;
  FFrameColor := clBlack;
  Color := clBlack;

  FLines := TDMemoStringList.Create;
  TDMemoStringList(FLines).DMemo := Self;

  Font.Color := clWhite;
  Canvas.Font.Name := Font.Name;
  Canvas.Font.Color := Font.Color;
  Canvas.Font.Size := Font.Size;

  FMoveTick := GetTickCount;
end;

destructor TDMemo.Destroy;
begin
  FLines.Free;
  inherited;
end;

procedure TDMemo.DirectPaint(dsurface: TAsphyreCanvas);
var
  dc: TRect;
  nShowCount, i: Integer;
  ax, ay: Integer;
  TempStr: string;
  nStartY, nStopY: Integer;
  nStartX, nStopX: Integer;
  addax: Integer;
begin
  dc.Left := SurfaceX(Left);
  dc.Top := SurfaceY(Top);
  dc.Right := SurfaceX(left + Width);
  dc.Bottom := SurfaceY(top + Height);
  with dsurface do begin
    if not FTransparent then begin
      Brush.Color := Color;
      FillRect(Rect(dc.Left, dc.Top, dc.Right, dc.Bottom),Brush.Color);
    end;
  end;

  if (GetTickCount - FCaretShowTime) > 500 then begin //光标闪动间隔时间
    FCaretShowTime := GetTickCount;
    FCaretShow := not FCaretShow;
  end;

  nShowCount := (Height - 2) div 14;
  if (FTopIndex + nShowCount - 1) > Lines.Count then begin
    FTopIndex := Max(Lines.Count - nShowCount + 1, 0);
  end;
  if (FCaretY >= Lines.Count) then FCaretY := Max(Lines.Count - 1, 0);
  if FCaretY < 0 then begin
    FTopIndex := 0;
    FCaretY := 0;
  end;

  if Lines.Count > nShowCount then begin
    if FUpDown <> nil then begin
      if not FUpDown.Visible then
        FUpDown.Visible := True;
      FUpDown.MaxPosition := Lines.Count - nShowCount;
      if FTopIndex = 0 then
        FUpDown.Position := FTopIndex
        else
      FUpDown.Position := FTopIndex;
    end;
  end
  else begin
    if FUpDown <> nil then begin
//      if FUpDown.Visible then
//        FUpDown.Visible := False;
      FUpDown.MaxPosition := Lines.Count - nShowCount;
      FUpDown.Position := FTopIndex;
      FTopIndex := 0;
    end;
  end;

  if FSCaretY > FCaretY then begin
    nStartY := FCaretY;
    nStopY := FSCaretY;
    nStartX := FCaretX;
    nStopX := FSCaretX;
  end else begin
    nStartY := FSCaretY;
    nStopY := FCaretY;
    nStartX := FSCaretX;
    nStopX := FCaretX;
  end;
  if FSCaretY = FCaretY then begin
    if FSCaretX > FCaretX then begin
      nStartX := FCaretX;
      nStopX := FSCaretX;
    end else if FSCaretX < FCaretX then begin
      nStartX := FSCaretX;
      nStopX := FCaretX;
    end else begin
      nStartX := -1;
    end;
  end;
  ax := SurfaceX(Left) + 2;
  ay := SurfaceY(Top) + 2;
  with dsurface do begin
    Font.Color := Self.Font.Color;
    for i := FTopIndex to (FTopIndex + nShowCount - 1) do begin
      if i >= Lines.Count then Break;
      if nStartY <> nStopY then begin
        if i = nStartY then begin
          TempStr := Copy(WideString(Lines[i]), 1, nStartX);
          TextOut(ax, ay + (i - FTopIndex) * 14, TempStr,Font.Color);
          addax := FontManager.Default.TextWidth(TempStr);
          TempStr := Copy(WideString(Lines[i]), nStartX + 1, 255);
          FillRect(ax + addax, ay + (i - FTopIndex) * 14 - 1, FontManager.Default.TextWidth(TempStr), 16, $FF0000FF);
          TextOut(ax + addax, ay + (i - FTopIndex) * 14, TempStr);
        end else if i = nStopY then begin
          TempStr := Copy(WideString(Lines[i]), 1, nStopX);
          addax := FontManager.Default.TextWidth(TempStr);
          FillRect(ax, ay + (i - FTopIndex) * 14 - 1, addax, 16, $FF0000FF);
          TextOut(ax, ay + (i - FTopIndex) * 14, TempStr);
          TempStr := Copy(WideString(Lines[i]), nStopX + 1, 255);
          TextOut(ax + addax, ay + (i - FTopIndex) * 14, TempStr);
        end else if (i > nStartY) and (i < nStopY) then begin
          FillRect(ax, ay + (i - FTopIndex) * 14 - 1, FontManager.Default.TextWidth(Lines[i]), 16, $FF0000FF);
          TextOut(ax, ay + (i - FTopIndex) * 14, Lines[i]);
        end else
          TextOut(ax, ay + (i - FTopIndex) * 14, Lines[i]);
      end else begin
        if (nStartX <> -1) and (i = FSCaretY) then begin
          TempStr := Copy(WideString(Lines[i]), 1, nStartX);
          TextOut(ax, ay + (i - FTopIndex) * 14, TempStr);
          addax := FontManager.Default.TextWidth(TempStr);
          TempStr := Copy(WideString(Lines[i]), nStartX + 1, nStopX - nStartX);
          FillRect(ax + addax, ay + (i - FTopIndex) * 14 - 1, FontManager.Default.TextWidth(TempStr), 16, $FF0000FF);
          TextOut(ax + addax, ay + (i - FTopIndex) * 14, TempStr);
          addax := addax + FontManager.Default.TextWidth(TempStr);
          TempStr := Copy(WideString(Lines[i]), nStopX + 1, 255);
          TextOut(ax + addax, ay + (i - FTopIndex) * 14, TempStr);
        end else
          TextOut(ax, ay + (i - FTopIndex) * 14, Lines[i]);
      end;
    end;
    if (FCaretY >= FTopIndex) and (FCaretY < (FTopIndex + nShowCount)) then begin
      ay := ay + (Max(FCaretY - FTopIndex, 0)) * 14;
      if FCaretY < Lines.Count then begin
        TempStr := LeftStr(WideString(Lines[FCaretY]), FCaretX);
        ax := ax + FontManager.Default.TextWidth(TempStr);
      end;
      if FCaretShow and (FocusedControl = Self) then begin //光标
        FrameRect(Rect(ax, ay, ax + 2, ay + 12),Self.Font.Color);
      end;
    end;
  end;
  for i := 0 to DControls.Count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
  DragModePaint(dsurface);
end;

function TDMemo.GetKey: string;
var
  nStartY, nStopY: Integer;
  nStartX, nStopX: Integer;
  TempStr: WideString;
  i: Integer;
begin
  Result := '';
  if FLines.Count > 0 then begin
    if (FCaretX <> FSCaretX) or (FSCaretY <> FCaretY) then begin
      if FSCaretY < 0 then FSCaretY := 0;
      if FSCaretY >= FLines.Count then FSCaretY := FLines.Count - 1;
      if FCaretY < 0 then FCaretY := 0;
      if FCaretY >= FLines.Count then FCaretY := FLines.Count - 1;

      if FSCaretY = FCaretY then begin
        if FSCaretX > FCaretX then begin
          nStartX := FCaretX;
          nStopX := FSCaretX;
        end else begin
          nStartX := FSCaretX;
          nStopX := FCaretX;
        end;
        TempStr := FLines[FCaretY];
        Result := Copy(TempStr, nStartX + 1, nStopX - nStartX);
      end else begin
        if FSCaretY > FCaretY then begin
          nStartY := FCaretY;
          nStopY := FSCaretY;
          nStartX := FCaretX;
          nStopX := FSCaretX;
        end else begin
          nStartY := FSCaretY;
          nStopY := FCaretY;
          nStartX := FSCaretX;
          nStopX := FCaretX;
        end;
        TempStr := FLines[nStartY];
        Result := Copy(TempStr, nStartX + 1, 255);
        if Integer(FLines.Objects[nStartY]) = 13 then Result := Result + #13#10;
        if (nStopY - nStartY) > 1 then
          for i := nStartY + 1 to nStopY - 1 do begin
            Result := Result + FLines[i];
            if Integer(FLines.Objects[i]) = 13 then Result := Result + #13#10;
          end;
        TempStr := FLines[nStopY];
        Result := Result + Copy(TempStr, 1, nStopX);
        if Integer(FLines.Objects[nStopY]) = 13 then Result := Result + #13#10;
      end;
    end;
  end;
end;

procedure TDMemo.KeyCaret(Key: Word);
var
  TempStr: WideString;
  nShowCount: Integer;
begin
  if FLines.Count > 0 then begin
    if FCaretY < 0 then FCaretY := 0;
    if FCaretY >= FLines.Count then FCaretY := FLines.Count - 1;
    TempStr := TDMemoStringList(FLines).Str[FCaretY];
    case Key of
      VK_UP: begin
          if FCaretY > 0 then Dec(FCaretY);
        end;
      VK_DOWN: begin
          if FCaretY < (FLines.Count - 1) then Inc(FCaretY);
        end;
      VK_RIGHT: begin
          if FCaretX < Length(TempStr) then Inc(FCaretX)
          else begin
            if FCaretY < (FLines.Count - 1) then begin
              Inc(FCaretY);
              FCaretX := 0;
            end;
          end;
        end;
      VK_LEFT: begin
          if FCaretX > 0 then Dec(FCaretX)
          else begin
            if FCaretY > 0 then begin
              Dec(FCaretY);
              FCaretX := Length(WideString(TDMemoStringList(FLines).Str[FCaretY]));
            end;
          end;
        end;
    end;
    nShowCount := (Height - 2) div 14;
    if FCaretY < FTopIndex then FTopIndex := FCaretY
    else begin
      if (FCaretY - FTopIndex) >= nShowCount then begin
        FTopIndex := Max(FCaretY - nShowCount + 1, 0);
      end;
    end;
    if not KeyDowned then SetCaret(False);
  end;
end;

function TDMemo.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  Clipboard: TClipboard;
  AddTx, Data: string;
  boAdd: Boolean;
  TempStr: WideString;
begin
  Result := FALSE;
  if (FocusedControl = self) then begin
    if Assigned(FOnKeyDown) then
      FOnKeyDown(self, Key, Shift);
    if Key = 0 then exit;
    if (ssCtrl in Shift) and (not Downed) and (Key = Word('A')) then begin
      if FLines.Count > 0 then begin
        FCaretY := FLines.Count - 1;
        FCaretX := Length(WideString(TDMemoStringList(FLines).Str[FSCaretY]));
        SetCaret(True);
        FSCaretX := 0;
        FSCaretY := 0;
      end;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssCtrl in Shift) and (not Downed) and (Key = Word('X')) then begin
      AddTx := GetKey;
      if AddTx <> '' then begin
        Clipboard := TClipboard.Create;
        Clipboard.AsText := AddTx;
        Clipboard.Free;
        ClearKey();
        TextChange();
      end;
      Key := 0;
      Result := True;
      Exit;
    end else if (ssCtrl in Shift) and (not Downed) and (Key = Word('C')) then begin
      AddTx := GetKey;
      if AddTx <> '' then begin
        Clipboard := TClipboard.Create;
        Clipboard.AsText := AddTx;
        Clipboard.Free;
      end;
      Key := 0;
      Result := True;
      Exit;
    end else if (ssCtrl in Shift) and (not Downed) and (Key = Word('V')) then begin
      ClearKey();
      Clipboard := TClipboard.Create;
      AddTx := Clipboard.AsText;
      boAdd := False;
      while True do begin
        if AddTx = '' then
          break;
        AddTx := GetValidStr3(AddTx, data, [#13]);
        if Data <> '' then begin
          data := AnsiReplaceText(data, #10, '');
          if Data = '' then
            Data := #9;
          if FLines.Count <= 0 then begin
            FLines.AddObject(Data, TObject(13));
            FCaretY := 0;
            RefListWidth(FCaretY, -1);
          end
          else if boAdd then begin
            Inc(FCaretY);
            FLines.InsertObject(FCaretY, Data, TObject(13));
            FCaretX := 0;
            RefListWidth(FCaretY, -1);
          end
          else begin
            TempStr := TDMemoStringList(FLines).Str[FCaretY];
            Insert(Data, TempStr, FCaretX + 1);
            TDMemoStringList(FLines).Str[FCaretY] := TempStr;
            Inc(FCaretX, Length(WideString(Data)));
            FLines.Objects[FCaretY] := TObject(13);
            RefListWidth(FCaretY, FCaretX);
          end;
          boAdd := True;
        end;
      end;
      Clipboard.Free;
      Key := 0;
      Result := True;
      Exit;
    end else if (ssShift in Shift) and (not Downed) then begin
      KeyDowned := True;
    end
    else
      KeyDowned := False;
    if FLines.Count <= 0 then exit;
    case Key of
      VK_UP, VK_DOWN, VK_RIGHT, VK_LEFT: begin
        KeyCaret(Key);
        Key := 0;
        Result := TRUE;
      end;
      VK_BACK: begin
          if (not FReadOnly) then begin
            if not ClearKey then begin
              while True do begin
                TempStr := TDMemoStringList(FLines).Str[FCaretY];
                if FCaretX > 0 then begin
                  Delete(TempStr, FCaretX, 1);
                  if TempStr = '' then begin
                    FLines.Delete(FCaretY);
                    if FCaretY > 0 then begin
                      Dec(FCaretY);
                      FCaretX :=
                        Length(WideString(TDMemoStringList(FLines).Str[FCaretY]));
                      SetCaret(True);
                    end else begin
                      FCaretY := 0;
                      FCaretX := 0;
                      SetCaret(False);
                    end;
                    Exit;
                  end
                  else begin
                    TDMemoStringList(FLines).Str[FCaretY] := TempStr;
                    Dec(FCaretX);
                  end;
                  break;
                end
                else if FCaretX = 0 then begin
                  if FCaretY > 0 then begin
                    if Integer(FLines.Objects[FCaretY - 1]) = 13 then begin
                      FLines.Objects[FCaretY - 1] := nil;
                      Break;
                    end
                    else begin
                      FLines.Objects[FCaretY - 1] := FLines.Objects[FCaretY];
                      FCaretX :=
                        Length(WideString(TDMemoStringList(FLines).Str[FCaretY -
                        1]));
                      TDMemoStringList(FLines).Str[FCaretY - 1] :=
                        TDMemoStringList(FLines).Str[FCaretY - 1] +
                        TDMemoStringList(FLines).Str[FCaretY];
                      FLines.Delete(FCaretY);
                      Dec(FCaretY);
                    end;
                  end
                  else
                    Break;
                end
                else
                  Break;
              end;
              RefListWidth(FCaretY, FCaretX);
              SetCaret(True);
            end;
            TextChange();
          end;
          Key := 0;
          Result := TRUE;
      end;
      VK_DELETE: begin
          if (not FReadOnly) then begin
            if not ClearKey then begin
              while True do begin
                TempStr := TDMemoStringList(FLines).Str[FCaretY];
                if Length(TempStr) > FCaretX then begin
                  Delete(TempStr, FCaretX + 1, 1);
                  if TempStr = '' then begin
                    FLines.Delete(FCaretY);
                    if FCaretY > 0 then begin
                      Dec(FCaretY);
                      FCaretX :=
                        Length(WideString(TDMemoStringList(FLines).Str[FCaretY]));
                      SetCaret(True);
                    end
                    else begin
                      FCaretY := 0;
                      FCaretX := 0;
                      SetCaret(False);
                    end;
                    Exit;
                  end
                  else
                    TDMemoStringList(FLines).Str[FCaretY] := TempStr;
                  break;
                end
                else if Integer(FLines.Objects[FCaretY]) = 13 then begin
                  FLines.Objects[FCaretY] := nil;
                  break;
                end
                else begin
                  if (FCaretY + 1) < FLines.Count then begin
                    TDMemoStringList(FLines).Str[FCaretY] :=
                      TDMemoStringList(FLines).Str[FCaretY] +
                      TDMemoStringList(FLines).Str[FCaretY + 1];
                    FLines.Objects[FCaretY] := FLines.Objects[FCaretY + 1];
                    FLines.Delete(FCaretY + 1);
                  end
                  else
                    Break;
                end;
              end;
              RefListWidth(FCaretY, FCaretX);
              SetCaret(True);
            end;
            TextChange();
          end;
          Key := 0;
          Result := TRUE;
      end;
    end;
  end;
end;

function TDMemo.KeyPress(var Key: Char): Boolean;
var
  TempStr, Temp: WideString;
  OldObject: Integer;
begin
  Result := False;
  if (FocusedControl = Self) then begin
    Result := TRUE;
    if (not Downed) and (not FReadOnly) then begin
      if Assigned(FOnKeyPress) then
        FOnKeyPress(self, Key);
      if Key = #0 then Exit;

      if (FCaretY >= Lines.Count) then
        FCaretY := Max(Lines.Count - 1, 0);
      if FCaretY < 0 then begin
        FTopIndex := 0;
        FCaretY := 0;
      end;
      if Key = #13 then begin
        if FLines.Count <= 0 then begin
          FLines.AddObject('', TObject(13));
          FLines.AddObject('', TObject(13));
          FCaretX := 0;
          FCaretY := 1;
          SetCaret(True);
        end
        else begin
          Temp := TDMemoStringList(FLines).Str[FCaretY];
          OldObject := Integer(FLines.Objects[FCaretY]);

          TempStr := Copy(Temp, 1, FCaretX);
          TDMemoStringList(FLines).Str[FCaretY] := TempStr;
          FLines.Objects[FCaretY] := TObject(13);

          TempStr := Copy(Temp, FCaretX + 1, 255);
          if TempStr <> '' then begin
            FLines.InsertObject(FCaretY + 1, TempStr, TObject(OldObject));
          end else begin
            FLines.InsertObject(FCaretY + 1, '', TObject(OldObject));
          end;
          RefListWidth(FCaretY + 1, 0);
          FCaretY := FCaretY + 1;
          FCaretX := 0;
          SetCaret(True);
        end;
        Exit;
      end;

//      if CharInSet(key ,AllowedChars) then begin
      if (ord(key) > 31) and ((ord(key) < 127) or (ord(key) > 159)) then begin
//      if (key in AllowedChars) then begin
//        if IsDBCSLeadByte(Ord(Key)) or bDoubleByte then begin
//          bDoubleByte := true;
//          Inc(KeyByteCount);
//          FInputStr := FInputStr + key;
//        end;
        if not bDoubleByte then begin
          ClearKey;
          if (MaxLength > 0) and (Length(strpas(FLines.GetText)) >= MaxLength) then begin
            Key := #0;
            exit;
          end;
          if FLines.Count <= 0 then begin
            FLines.AddObject(Key, nil);
            FCaretX := 1;
            FCaretY := 0;
          end else begin
            TempStr := TDMemoStringList(FLines).Str[FCaretY];
            Insert(Key, TempStr, FCaretX + 1);
            TDMemoStringList(FLines).Str[FCaretY] := TempStr;
            Inc(FCaretX);
            RefListWidth(FCaretY, FCaretX);
          end;
          SetCaret(True);
          Key := #0;
          TextChange();
        end else if KeyByteCount >= 2 then begin
          if Length(FInputStr) <> 2 then begin
            bDoubleByte := false;
            KeyByteCount := 0;
            FInputStr := '';
            Key := #0;
            exit;
          end;

          ClearKey;
          if (MaxLength > 0) and (Length(FLines.GetText) >= (MaxLength - 1)) then begin
            bDoubleByte := false;
            KeyByteCount := 0;
            FInputStr := '';
            Key := #0;
            exit;
          end;
          if FLines.Count <= 0 then begin
            FLines.AddObject(FInputStr, nil);
            FCaretX := 1;
            FCaretY := 0;
          end else begin
            TempStr := TDMemoStringList(FLines).Str[FCaretY];
            Insert(FInputStr, TempStr, FCaretX + 1);
            TDMemoStringList(FLines).Str[FCaretY] := TempStr;
            Inc(FCaretX);
            RefListWidth(FCaretY, FCaretX);
          end;
          SetCaret(True);
          bDoubleByte := false;
          KeyByteCount := 0;
          FInputStr := '';
          Key := #0;
          TextChange();
        end;
      end;
    end;
  end;
  Key := #0;
end;

function TDMemo.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      KeyDowned := False;
      if (FocusedControl = self) then begin
        DownCaret(X - left, Y - top);
      end;
      SetCaret(False);
      Downed := True;
      SetDCapture(self);
    end;
    Result := TRUE;
  end;
end;

function TDMemo.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and (MouseCaptureControl = self) then begin
    if Downed and (not KeyDowned) then
      MoveCaret(X - left, Y - top);
  end;
end;

function TDMemo.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  Downed := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y,Shift) then begin
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Result := TRUE;
    exit;
  end
  else begin
    ReleaseDCapture;
  end;
end;

procedure TDMemo.MoveCaret(X, Y: Integer);
var
  tempstrw: WideString;
  nShowCount, i: Integer;
  tempstr: string;
begin
  nShowCount := (Height - 2) div 14;
  if Y < 0 then begin //往上移动
    if (GetTickCount - FMoveTick) < 50 then Exit;
    if FTopIndex > 0 then Dec(FTopIndex);
    FCaretY := FTopIndex;
  end else if Y > Height then begin //往下移动
    if (GetTickCount - FMoveTick) < 50 then Exit;
    Inc(FCaretY);
    if FCaretY >= FLines.Count then FCaretY := Max(FLines.Count - 1, 0);
    FTopIndex := Max(FCaretY - nShowCount + 1, 0);
  end else FCaretY := (y - 2) div 14 + FTopIndex;
  FMoveTick := GetTickCount;

  if FCaretY >= FLines.Count then FCaretY := Max(FLines.Count - 1, 0);
  FCaretX := 0;
  if FCaretY < FLines.Count then begin
    tempstrw := TDMemoStringList(FLines).Str[FCaretY];
    if tempstrw <> '' then begin
      for i := 1 to Length(tempstrw) do begin
        tempstr := Copy(tempstrw, 1, i);
        if (FontManager.Default.TextWidth(tempstr)) > (X) then Exit;
        FCaretX := i;
      end;
    end;
  end;
end;

procedure TDMemo.RefListWidth(ItemIndex: Integer; nCaret: Integer);
var
  i, Fi, nIndex, nY: Integer;
  TempStr, AddStr: WideString;
begin
  TempStr := '';
  nIndex := 0;
  while True do begin
    if ItemIndex >= FLines.Count then Break;
    TempStr := TempStr + TDMemoStringList(FLines).Str[ItemIndex];
    nIndex := Integer(Lines.Objects[ItemIndex]);
    FLines.Delete(ItemIndex);
    if nIndex = 13 then Break;
  end;
  if TempStr <> '' then begin
    AddStr := '';
    Fi := 1;
    nY := ItemIndex;
    for i := 1 to Length(TempStr) + 1 do begin
      AddStr := Copy(TempStr, Fi, i - Fi + 1);
      if FontManager.Default.TextWidth(AddStr) > (Width - 20) then begin
        AddStr := Copy(TempStr, Fi, i - Fi);
        Fi := i;
        FLines.InsertObject(ItemIndex, AddStr, nil);
        nIndex := ItemIndex;
        Inc(ItemIndex);
        nY := ItemIndex;
        AddStr := '';
      end;
      if i = nCaret then begin
        FCaretX := i - Fi + 1;
        FCaretY := nY;
        SetCaret(True);
      end;
    end;
    if AddStr <> '' then begin
      FLines.InsertObject(ItemIndex, AddStr, TObject(13));
      nIndex := ItemIndex;
    end
    else begin
      FLines.Objects[nIndex] := TObject(13);
    end;
    if nCaret = -1 then begin
      FCaretY := nIndex;
      FCaretX := Length(WideString(TDMemoStringList(FLines).Str[nIndex]));
      SetCaret(True);
    end;
  end;
  if FCaretY >= FLines.Count then begin
    FCaretY := Max(FLines.Count - 1, 0);
    SetCaret(True);
  end;
end;

procedure TDMemo.DownCaret(X, Y: Integer);
var
  tempstrw: WideString;
  i: Integer;
  tempstr: string;
begin
  FCaretY := (y - 2) div 14 + FTopIndex;
  if FCaretY >= FLines.Count then FCaretY := Max(FLines.Count - 1, 0);
  FCaretX := 0;
  if FCaretY < FLines.Count then begin
    tempstrw := TDMemoStringList(FLines).Str[FCaretY];
    if tempstrw <> '' then begin
      for i := 1 to Length(tempstrw) do begin
        tempstr := Copy(tempstrw, 1, i);
        if (FontManager.Default.TextWidth(tempstr)) > (X) then Exit;
        FCaretX := i;
      end;
    end;
  end;
end;

procedure TDMemo.PositionChange(Sender: TObject);
begin
  FTopIndex := FUpDown.Position;
end;

procedure TDMemo.SetUpDown(const Value: TDUpDown);
begin
  FUpDown := Value;
//  FWheelDControl := Value;
  if FUpDown <> nil then begin
    FUpDown.OnPositionChange := PositionChange;
    FUpDown.Visible := False;
    FUpDown.MaxPosition := 0;
    FUpDown.Position := 0;
  end;
end;

procedure TDMemo.SetCaret(boBottom: Boolean);
var
  nShowCount: Integer;
begin
  FSCaretX := FCaretX;
  FSCaretY := FCaretY;
  if boBottom then begin
    nShowCount := (Height - 2) div 14;
    if FCaretY < FTopIndex then FTopIndex := FCaretY
    else begin
      if (FCaretY - FTopIndex) >= nShowCount then begin
        FTopIndex := Max(FCaretY - nShowCount + 1, 0);
      end;
    end;
  end;
end;

procedure TDMemo.SetCaretY(const Value: Integer);
begin
  FCaretY := Value;
  if FCaretY >= FLines.Count then FCaretY := Max(FLines.Count - 1, 0);
  if FCaretY < 0 then FCaretY := 0;
  SetCaret(True);
end;

procedure TDMemo.SetFocus;
begin
  SetDFocus (self);
end;

procedure TDMemo.TextChange;
begin
  if Assigned(FOnChange) then
    FOnChange(self);
end;

{ TDMemoStringList }

function TDMemoStringList.Add(const S: string): Integer;
begin
  Result := AddObject(S, TObject(13));
  DMemo.RefListWidth(Result, -1);
end;

function TDMemoStringList.AddObject(const S: string; AObject: TObject): Integer;
var
  AddStr: string;
begin
  AddStr := AnsiReplaceText(S, #13, '');
  AddStr := AnsiReplaceText(AddStr, #10, '');
  if AddStr = '' then begin
    Result := inherited AddObject(#9, AObject);
  end else
    Result := inherited AddObject(AddStr, AObject);
end;

procedure TDMemoStringList.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  DMemo.FCaretY := 0;
  DMemo.FCaretX := 0;
  DMemo.SetCaret(False);
end;

procedure TDMemoStringList.Clear;
begin
  inherited;
  DMemo.FCaretY := 0;
  DMemo.FCaretX := 0;
  DMemo.SetCaret(False);
end;

function TDMemoStringList.Get(Index: Integer): string;
begin
  Result := inherited Get(Index);
  Result := AnsiReplaceText(Result, #9, '');
end;

procedure TDMemoStringList.InsertObject(Index: Integer; const S: string;
  AObject: TObject);
var
  AddStr: string;
begin
  AddStr := AnsiReplaceText(S, #13, '');
  AddStr := AnsiReplaceText(AddStr, #10, '');
  if AddStr = '' then begin
    inherited InsertObject(Index, #9, AObject);
  end
  else
    inherited InsertObject(Index, AddStr, AObject);
end;

function TDMemoStringList.GetText: PChar;
var
  i: Integer;
  AddStr: string;
begin
  AddStr := '';
  for i := 0 to Count - 1 do begin
    AddStr := AddStr + Get(i);
    if Char(Objects[i]) = #13 then begin
      AddStr := AddStr + #13;
    end;
  end;
  Result := StrNew(PChar(AddStr));
end;

procedure TDMemoStringList.SaveToFile(const FileName: string);
var
  TempString: TStringList;
  i: Integer;
  AddStr: string;
begin
  TempString := TStringList.Create;
  try
    AddStr := '';
    for i := 0 to Count - 1 do begin
      AddStr := AddStr + Get(i);
      if Char(Objects[i]) = #13 then begin
        TempString.Add(AddStr);
        AddStr := '';
      end;
    end;
    if AddStr <> '' then
      TempString.Add(AddStr);

    TempString.SaveToFile(FileName);
  finally
    TempString.Free;
  end;
end;

procedure TDMemoStringList.LoadFromFile(const FileName: string);
var
  TempString: TStringList;
  i: Integer;
begin
  Clear;
  TempString := TStringList.Create;
  try
    if FileExists(Filename) then begin
      TempString.LoadFromFile(FileName);
      for i := 0 to TempString.Count - 1 do begin
        Add(TempString[i]);
      end;
    end;
  finally
    TempString.Free;
  end;
end;

procedure TDMemoStringList.Put(Index: Integer; const Value: string);
var
  AddStr: string;
begin
  if Value <> '' then begin
    AddStr := AnsiReplaceText(Value, #13, '');
    AddStr := AnsiReplaceText(AddStr, #10, '');
  end else
    AddStr := #9;
  inherited Put(Index, AddStr);
end;

function TDMemoStringList.SelfGet(Index: Integer): string;
begin
  Result := inherited Get(Index);
end;

{ TDLabel }

constructor TDLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Downed := FALSE;
  FOnClick := nil;

  OldText := '';
  Text := '';
  FClickSound := csNone;
  FAutoSize := True;
  FAlignment := taLeftJustify;
end;

function TDLabel.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if (not Background) and (not Result) then begin
    Result := inherited MouseMove(Shift, X, Y);
    if MouseCaptureControl = self then begin
      if InRange(X, Y,Shift) then
        Downed := TRUE
      else
        Downed := FALSE;
    end;
  end;
end;

procedure TDLabel.DirectPaint(dsurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  i, ImgWidth, ImgHeight: integer;
begin
  ImgWidth := 0;
  ImgHeight := 0;
  if Assigned(FOnDirectPaint) then begin
    FOnDirectPaint(self, dsurface)
  end else begin
    if WLib <> nil then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then begin
        ImgWidth := d.Width;
        ImgHeight := d.Height;
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      end;
    end;
//    if FTransparent then
//    dsurface.FillRect(IntRect(SurfaceX(Left-4), SurfaceY(Top-4), Width+8, Height+8),NewColorW(Color));
//   if FFrameparent then
//    dsurface.FrameRect(IntRect(SurfaceX(Left-4), SurfaceY(Top-4), Width+8, Height+8), FFrameColor);

    if Text <> '' then begin
      if FAutoSize and (OldText <> Text) then begin  //改变大小
        Width := FontManager.Default.TextWidth(Text) + 2 + ImgWidth;
        Height := FontManager.Default.TextHeight('0') + 2 + ImgHeight;
        OldText := Text;
      end;
      with dsurface do begin
        case FAlignment of //字符串位置
          taLeftJustify: TextOut(SurfaceX(Left) - ImgWidth, SurfaceY(Top) + (Height - FontManager.Default.TextHeight(Text)) div 2, Text, Self.Font.Color);
          taCenter: TextOut(SurfaceX(Left)- ImgWidth + (Width - FontManager.Default.TextWidth(Text)) div 2, SurfaceY(Top) + (Height - FontManager.Default.TextHeight(Text)) div 2, Text, Self.Font.Color);
          taRightJustify: TextOut(SurfaceX(Left)- ImgWidth + (Width - FontManager.Default.TextWidth(Text)), SurfaceY(Top) + (Height - FontManager.Default.TextHeight(Text)) div 2, Text, Self.Font.Color);
        end;
      end;
    end;
  end;

  for i := 0 to DControls.Count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
  if Assigned(FOnEndDirectPaint) then
    FOnEndDirectPaint(self, dsurface);
  DragModePaint(dsurface);
end;

function TDLabel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseDown(Button, Shift, X, Y) and FEnableFocus then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      Downed := TRUE;
      SetDCapture(self);
    end;
    Result := TRUE;
  end;
end;

function TDLabel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y:
  Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseUp(Button, Shift, X, Y) and FEnableFocus then begin
    ReleaseDCapture;
    if not Background then begin
      if Downed and InRange(X, Y,Shift) then begin
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := FALSE;
    Result := TRUE;
    exit;
  end
  else begin
    ReleaseDCapture;
    Downed := FALSE;
  end;
end;

procedure TDLabel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
  end;
end;

procedure TDLabel.SetText(str: string);
begin
  FText := str;
end;

procedure TDLabel.SetCaptionChaged(Value: Boolean);
begin
  FAutoSize := Value;
  if not (csDesigning in ComponentState) then begin
    if Text <> '' then begin
      if FAutoSize then begin
        Width := FontManager.Default.TextWidth(Text) + 2;
        Height := FontManager.Default.TextHeight('0') + 2;
      end;
    end;
  end;
end;

{ TDImageIndex }

constructor TDImageIndex.Create;
begin
  inherited;
  FUp := -1;
  FDown := -1;
  FHot := -1;
  FDisabled := -1;
end;

procedure TDImageIndex.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TDImageIndex then begin
    FUp := TDImageIndex(Source).Up;
    FDown := TDImageIndex(Source).Down;
    FHot := TDImageIndex(Source).Hot;
    FDisabled := TDImageIndex(Source).Disabled;
    Changed;
  end;
end;

procedure TDImageIndex.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TDImageIndex.SetDisabled(Value: Integer);
begin
  if FDisabled <> Value then begin
    FDisabled := Value;
    Changed;
  end;
end;

procedure TDImageIndex.SetDown(Value: Integer);
begin
  if FDown <> Value then begin
    FDown := Value;
    Changed;
  end;
end;

procedure TDImageIndex.SetHot(Value: Integer);
begin
  if FHot <> Value then begin
    FHot := Value;
    Changed;
  end;
end;

procedure TDImageIndex.SetUp(Value: Integer);
begin
  if FUp <> Value then begin
    FUp := Value;
    Changed;
  end;
end;

{ TDListItem }

function TDListItem.AddItem(const S: string;
  AObject: TObject): pTViewItem;
begin
  AddObject(S, AObject);
  Result := @FItemList[Length(FItemList) - 1];
end;

function TDListItem.AddObject(const S: string; AObject: TObject): Integer;
var
  ViewItem: pTViewItem;
begin
  SetLength(FItemList, Length(FItemList) + 1);
  ViewItem := @FItemList[Length(FItemList) - 1];
  ViewItem.Down := False;
  ViewItem.Move := False;
  ViewItem.Caption := S;
  ViewItem.Data := nil;
  ViewItem.WLib := nil;
  ViewItem.Style := bsButton;
  ViewItem.Checked := False;
  ViewItem.Color := TDCaptionColor.Create;
  ViewItem.ImageIndex := TDImageIndex.Create;
  ViewItem.TimeTick := GetTickCount;
  Result := inherited AddObject(S, AObject);
end;

procedure TDListItem.Clear;
var
  I: Integer;
begin
  for I := 0 to Length(FItemList) - 1 do begin
    FItemList[I].Color.Free;
    FItemList[I].ImageIndex.Free;
  end;
  SetLength(FItemList, 0);
  FItemList := nil;
  inherited Clear;
end;

constructor TDListItem.Create;
begin
  inherited;
  FItemList := nil;
end;

procedure TDListItem.Delete(Index: Integer);
var
  I: Integer;
begin
  FItemList[Index].Color.Free;
  FItemList[Index].ImageIndex.Free;
  for I := 0 to Length(FItemList) - 2 do begin
    FItemList[I] := FItemList[I + 1];
  end;
  SetLength(FItemList, Length(FItemList) - 1);
  inherited Delete(Index);
end;

destructor TDListItem.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FItemList) - 1 do begin
    FItemList[I].Color.Free;
    FItemList[I].ImageIndex.Free;
  end;
  SetLength(FItemList, 0);
  FItemList := nil;
  inherited;
end;

function TDListItem.GetItem(Index: Integer): pTViewItem;
begin
  Result := @FItemList[Index];
end;

procedure TDListItem.InsertObject(Index: Integer; const S: string;
  AObject: TObject);
var
  I: Integer;
  ViewItem: pTViewItem;
begin
  SetLength(FItemList, Length(FItemList) + 1);
  for I := Length(FItemList) - 1 downto Index do begin
    FItemList[I] := FItemList[I - 1];
  end;
  ViewItem := @FItemList[Index];
  ViewItem.Down := False;
  ViewItem.Move := False;
  ViewItem.Caption := S;
  ViewItem.Data := nil;
  ViewItem.WLib := nil;
  ViewItem.Style := bsButton;
  ViewItem.Checked := False;
  ViewItem.Color := TDCaptionColor.Create;
  ViewItem.ImageIndex := TDImageIndex.Create;
  ViewItem.TimeTick := GetTickCount;
  inherited InsertObject(Index, S, AObject);
end;

{ TDChatMemo }

procedure TDChatMemo.Add(const S: string; FC, BC: TColor);
var
  TextWidth: Integer;

  I, Len, ALine: integer;
  sText, DLine, Temp: string;

  ViewItem: pTViewItem;
begin
  if ShowScroll then
    TextWidth := Width - ScrollSize - FontManager.Default.TextWidth('0')
  else TextWidth := Width - FontManager.Default.TextWidth('0');

  sText := S;

  if FontManager.Default.TextWidth(sText) > TextWidth then begin
    Len := Length(sText);
    Temp := '';
    I := 1;
    while True do begin
      if I > Len then break;
      if Byte(sText[I]) >= 128 then begin
        Temp := Temp + sText[I];
        Inc(I);
        if I <= Len then Temp := Temp + sText[I]
        else break;
      end else
        Temp := Temp + sText[I];

      ALine := FontManager.Default.TextWidth(Temp);
      if ALine > TextWidth then begin
        ViewItem := TDChatMemoLines(FLines).AddItem(Temp, nil);
        ViewItem.Transparent := False;
        ViewItem.Caption := Temp;
        ViewItem.Color.Up.Color := FC;
        ViewItem.Color.Up.BColor := BC;
        ViewItem.Color.Up.Bold := False;
        ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
        ViewItem.Color.Down.Assign(ViewItem.Color.Up);
        ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);
        TDChatMemoLines(FLines).ItemHeights[FLines.Count - 1] := Max(TDChatMemoLines(FLines).ItemHeights[FLines.Count - 1], ALine);
        sText := Copy(sText, I + 1, Len - i);
        Temp := '';

        if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
        if (Assigned(FOnChange)) then FOnChange(Self);
        break;
      end;
      Inc(I);
    end;

    if Temp <> '' then begin
      ViewItem := TDChatMemoLines(FLines).AddItem(Temp, nil);
      ViewItem.Transparent := False;
      ViewItem.Caption := Temp;
      ViewItem.Color.Up.Color := FC;
      ViewItem.Color.Up.BColor := BC;
      ViewItem.Color.Up.Bold := False;
      ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
      ViewItem.Color.Down.Assign(ViewItem.Color.Up);
      ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);

      TDChatMemoLines(FLines).ItemHeights[FLines.Count - 1] := Max(TDChatMemoLines(FLines).ItemHeights[FLines.Count - 1], FontManager.Default.TextWidth(Temp));

      sText := '';

      if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
      if (Assigned(FOnChange)) then FOnChange(Self);
    end;

    if sText <> '' then
      Add(' ' + sText, FC, BC);
  end else begin
    ViewItem := TDChatMemoLines(FLines).AddItem(sText, nil);
    ViewItem.Transparent := False;
    ViewItem.Caption := sText;
    ViewItem.Color.Up.Color := FC;
    ViewItem.Color.Up.BColor := BC;
    ViewItem.Color.Up.Bold := False;
    ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
    ViewItem.Color.Down.Assign(ViewItem.Color.Up);
    ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);

    TDChatMemoLines(FLines).ItemHeights[FLines.Count - 1] := Max(TDChatMemoLines(FLines).ItemHeights[FLines.Count - 1], FontManager.Default.TextWidth(sText));

    if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
    if (Assigned(FOnChange)) then FOnChange(Self);
  end;
end;

procedure TDChatMemo.AddTop(const S: string; FC, BC: TColor; TimeOut: Integer);
var
  TextWidth: Integer;
  I, Len, ALine: integer;
  sText, DLine, Temp: string;
  ViewItem: pTViewItem;
begin
  if ShowScroll then
    TextWidth := Width - ScrollSize - FontManager.Default.TextWidth('0')
  else TextWidth := Width - FontManager.Default.TextWidth('0');

  sText := S;

  if FontManager.Default.TextWidth(sText) > TextWidth then begin
    Len := Length(sText);
    Temp := '';
    I := 1;
    while True do begin
      if I > Len then break;
      if Byte(sText[I]) >= 128 then begin
        Temp := Temp + sText[I];
        Inc(I);
        if I <= Len then Temp := Temp + sText[I]
        else break;
      end else
        Temp := Temp + sText[I];

      ALine := FontManager.Default.TextWidth(Temp);
      if ALine > TextWidth then begin
        ViewItem := TDChatMemoLines(FTopLines).AddItem(Temp, nil);
        ViewItem.TimeTick := GetTickCount + TimeOut * 1000;
        ViewItem.Transparent := False;
        ViewItem.Caption := Temp;
        ViewItem.Color.Up.Color := FC;
        ViewItem.Color.Up.BColor := BC;
        ViewItem.Color.Up.Bold := False;
        ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
        ViewItem.Color.Down.Assign(ViewItem.Color.Up);
        ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);

        sText := Copy(sText, I + 1, Len - i);
        Temp := '';

        if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
        if (Assigned(FOnChange)) then FOnChange(Self);
        break;
      end;
      Inc(I);
    end;

    if Temp <> '' then begin
      ViewItem := TDChatMemoLines(FTopLines).AddItem(Temp, nil);
      ViewItem.TimeTick := GetTickCount + TimeOut * 1000;
      ViewItem.Transparent := False;
      ViewItem.Caption := Temp;
      ViewItem.Color.Up.Color := FC;
      ViewItem.Color.Up.BColor := BC;
      ViewItem.Color.Up.Bold := False;
      ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
      ViewItem.Color.Down.Assign(ViewItem.Color.Up);
      ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);
      sText := '';
      if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
      if (Assigned(FOnChange)) then FOnChange(Self);
    end;

    if sText <> '' then
      AddTop(' ' + sText, FC, BC, TimeOut);
  end else begin
    ViewItem := TDChatMemoLines(FTopLines).AddItem(sText, nil);
    ViewItem.TimeTick := GetTickCount + TimeOut * 1000;
    ViewItem.Transparent := False;
    ViewItem.Caption := sText;
    ViewItem.Color.Up.Color := FC;
    ViewItem.Color.Up.BColor := BC;
    ViewItem.Color.Up.Bold := False;
    ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
    ViewItem.Color.Down.Assign(ViewItem.Color.Up);
    ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);

    if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
    if (Assigned(FOnChange)) then FOnChange(Self);
  end;
end;

procedure TDChatMemo.BarImageIndexChange(Sender: TObject);
var
  d: TAsphyreLockableTexture;
  nIndex: Integer;
begin
  if FBarImageIndex.Up >= 0 then
    nIndex := FBarImageIndex.Up
  else
    if FBarImageIndex.Hot >= 0 then
    nIndex := FBarImageIndex.Hot
  else
    if FBarImageIndex.Down >= 0 then
    nIndex := FBarImageIndex.Down;

  if (WLib <> nil) and (nIndex >= 0) then begin
    d := WLib.Images[nIndex];
    if d <> nil then
      FBarImageSize := d.Height;
  end;
end;

procedure TDChatMemo.Clear;
begin
  FLines.Clear;
  FTopLines.Clear;
  Position := 0;
end;

constructor TDChatMemo.Create(AOwner: TComponent);
begin
  inherited Create (AOwner);
  Downed := False;
  FLines := TDChatMemoLines.Create;
  FTopLines := TDChatMemoLines.Create;
  FAutoScroll := False;
  FShowScroll := True;
  FScrollSize := 16;
  FItemHeight := 12;
  FItemIndex := -1;
  FBarTop := 0;
  FOffSetX := 0;
  FOffSetY := 0;
  FPosition := 0;
  FVisibleItemCount := 1;
  FExpandSize := 0;
  FDrawLineCount := 0;
  FScrollImageIndex := TDImageIndex.Create;
  FPrevImageIndex := TDImageIndex.Create;
  FNextImageIndex := TDImageIndex.Create;
  FBarImageIndex := TDImageIndex.Create;

  FScrollMouseDown := False;
  FPrevMouseDown := False;
  FNextMouseDown := False;
  FBarMouseDown := False;
  FPrevMouseMove := False;
  FNextMouseMove := False;
  FBarMouseMove := False;

  FScrollImageIndex.OnChange := ScrollImageIndexChange;
  FPrevImageIndex.OnChange := PrevImageIndexChange;
  FNextImageIndex.OnChange := NextImageIndexChange;
  FBarImageIndex.OnChange := BarImageIndexChange;
  FDrawLineCount := 0;
end;

procedure TDChatMemo.Delete(Index: Integer);
begin
  FLines.Delete(Index);
  if FAutoScroll then Previous;
end;

procedure TDChatMemo.DeleteTop(Index: Integer);
begin
  FTopLines.Delete(Index);
  if FAutoScroll then Previous;
end;

destructor TDChatMemo.Destroy;
begin
  FLines.Free;
  FTopLines.Free;
  FScrollImageIndex.Free;
  FPrevImageIndex.Free;
  FNextImageIndex.Free;
  FBarImageIndex.Free;
  inherited Destroy;
end;

procedure TDChatMemo.DirectPaint(dsurface: TAsphyreCanvas);
var
  I, II, III, nIndex, nCount, nLeft, nTop, n01: Integer;
  FaceIndex: Integer;
  nHeight: Integer;
  nMaxValue: Integer;
  nBarTop: Integer;
  TextureRect: TAsphyreLockableTexture;
  Texture: TAsphyreLockableTexture;
  vtRect: TRect;
  vbRect: TRect;
  PaintRect: TRect;

  ListItem: TDListItem;
  ViewItem: pTViewItem;
  nLen: Integer;
  Font: TDFont;
begin
  if Assigned (OnDirectPaint) then
    OnDirectPaint (self, dsurface)
  else begin
    n01 := 0;
    nTop := OffSetY;
    nLeft := OffSetX;

    nMaxValue := Min(VisibleHeight div ItemHeight, FDrawLineCount);

    for I := 0 to FTopLines.Count - 1 do begin
      ViewItem := TDChatMemoLines(FTopLines).Items[I];
      if WLib <> nil then begin
        FaceIndex := -1;
        if ViewItem.Style = bsButton then begin
          if ViewItem.Down then begin
            FaceIndex := ViewItem.ImageIndex.Down;
            if (FaceIndex < 0) and (ViewItem.ImageIndex.Up >= 0) then
              FaceIndex := ViewItem.ImageIndex.Up;
          end else
            if ViewItem.Move then begin
            FaceIndex := ViewItem.ImageIndex.Hot;
            if (FaceIndex < 0) and (ViewItem.ImageIndex.Up >= 0) then
              FaceIndex := ViewItem.ImageIndex.Up;
          end else
            FaceIndex := ViewItem.ImageIndex.Up;
        end else begin
          if ViewItem.Move then begin
            if ViewItem.Checked then
              FaceIndex := ViewItem.ImageIndex.Down
            else
              if ViewItem.ImageIndex.Hot >= 0 then
              FaceIndex := ViewItem.ImageIndex.Hot
            else
              FaceIndex := ViewItem.ImageIndex.Up;
          end else begin
            if ViewItem.Checked then
              FaceIndex := ViewItem.ImageIndex.Down
            else
              FaceIndex := ViewItem.ImageIndex.Up;
          end;
        end;

        if FaceIndex >= 0 then begin
          Texture := WLib.Images[FaceIndex];
          if Texture <> nil then begin
            dsurface.Draw(SurfaceX(Left)+ nLeft, SurfaceY(Top)+nTop + (ItemHeight - Texture.Height) div 2, Texture.ClientRect, Texture, False);
          end;
        end;
      end;

      if ViewItem.Caption <> '' then begin
        if ViewItem.Down then begin
          Font := ViewItem.Color.Down;
        end else
          if ViewItem.Move then begin
          Font := ViewItem.Color.Hot;
        end else begin
          Font := ViewItem.Color.Up;
        end;

        if ViewItem.Style = bsButton then begin
          if ViewItem.Down then begin
            Font := ViewItem.Color.Down;
          end else
            if ViewItem.Move then begin
            Font := ViewItem.Color.Hot;
          end else
            Font := ViewItem.Color.Up;
        end else begin
          if ViewItem.Move then begin
            if ViewItem.Checked then
              Font := ViewItem.Color.Down
            else
              if ViewItem.ImageIndex.Hot >= 0 then
              Font := ViewItem.Color.Hot
            else
              Font := ViewItem.Color.Up;
          end else begin
            if ViewItem.Checked then
              Font := ViewItem.Color.Down
            else
              Font := ViewItem.Color.Up;
          end;
        end;

        if ViewItem.Caption <> '' then begin
          if Font.Bold then begin
            dsurface.BoldTextOut(SurfaceX(Left), SurfaceY(Top), Font.Color, Font.BColor, ViewItem.Caption);
          end else begin
            PaintRect.Left := SurfaceX(Left) + nLeft;
            PaintRect.Right := PaintRect.Left + Width - ScrollSize;
            PaintRect.Top := SurfaceY(Top) + nTop + (ItemHeight - FontManager.Default.TextHeight('0')) div 2;
            PaintRect.Bottom := PaintRect.Top + 12;
            if not FontBackTransparent then
            dsurface.FillRect(PaintRect, Font.BColor);
            dsurface.TextOut(PaintRect.Left, PaintRect.Top, Font.Color, ViewItem.Caption);
          end;
        end;
      end;
      Inc(n01);
      Inc(nTop, ItemHeight);
      if n01 >= nMaxValue then break;
    end;

    nMaxValue := Min(VisibleHeight div ItemHeight, FDrawLineCount);
    nMaxValue := nMaxValue - n01;

    n01 := 0;
    if nMaxValue > 0 then begin
      for I := FTopIndex to FLines.Count - 1 do begin
        ViewItem := TDChatMemoLines(FLines).Items[I];
        if WLib <> nil then begin
          FaceIndex := -1;
          if ViewItem.Style = bsButton then begin
            if ViewItem.Down then begin
              FaceIndex := ViewItem.ImageIndex.Down;
              if (FaceIndex < 0) and (ViewItem.ImageIndex.Up >= 0) then
                FaceIndex := ViewItem.ImageIndex.Up;
            end else
              if ViewItem.Move then begin
              FaceIndex := ViewItem.ImageIndex.Hot;
              if (FaceIndex < 0) and (ViewItem.ImageIndex.Up >= 0) then
                FaceIndex := ViewItem.ImageIndex.Up;
            end else
              FaceIndex := ViewItem.ImageIndex.Up;
          end else begin
            if ViewItem.Move then begin
              if ViewItem.Checked then
                FaceIndex := ViewItem.ImageIndex.Down
              else
                if ViewItem.ImageIndex.Hot >= 0 then
                FaceIndex := ViewItem.ImageIndex.Hot
              else
                FaceIndex := ViewItem.ImageIndex.Up;
            end else begin
              if ViewItem.Checked then
                FaceIndex := ViewItem.ImageIndex.Down
              else
                FaceIndex := ViewItem.ImageIndex.Up;
            end;
          end;

          if FaceIndex >= 0 then begin
            Texture := WLib.Images[FaceIndex];
            if Texture <> nil then begin
              dsurface.Draw(SurfaceX(Left)+ nLeft, SurfaceY(Top)+nTop + (ItemHeight - Texture.Height) div 2, Texture.ClientRect, Texture, False);
            end;
          end;
        end;

        if ViewItem.Caption <> '' then begin

          if ViewItem.Down then begin
            Font := ViewItem.Color.Down;
          end else
            if ViewItem.Move then begin
            Font := ViewItem.Color.Hot;
          end else begin
            Font := ViewItem.Color.Up;
          end;

          if ViewItem.Style = bsButton then begin
            if ViewItem.Down then begin
              Font := ViewItem.Color.Down;
            end else
              if ViewItem.Move then begin
              Font := ViewItem.Color.Hot;
            end else
              Font := ViewItem.Color.Up;
          end else begin
            if ViewItem.Move then begin
              if ViewItem.Checked then
                Font := ViewItem.Color.Down
              else
                if ViewItem.ImageIndex.Hot >= 0 then
                Font := ViewItem.Color.Hot
              else
                Font := ViewItem.Color.Up;
            end else begin
              if ViewItem.Checked then
                Font := ViewItem.Color.Down
              else
                Font := ViewItem.Color.Up;
            end;
          end;

          if ViewItem.Caption <> '' then begin
            if Font.Bold then begin
              dsurface.BoldTextOut(SurfaceX(Left), SurfaceY(Top), Font.Color, Font.BColor, ViewItem.Caption);
            end else begin
              PaintRect.Left := SurfaceX(Left) + nLeft;
              PaintRect.Right := PaintRect.Left + FontManager.Default.TextWidth(ViewItem.Caption);
              PaintRect.Top := SurfaceY(Top) + nTop + (ItemHeight - FontManager.Default.TextHeight('0')) div 2;
              PaintRect.Bottom := PaintRect.Top + 12;
              if not FontBackTransparent then
              dsurface.FillRect(PaintRect, Font.BColor);
              dsurface.TextOut(PaintRect.Left, PaintRect.Top, Font.Color, ViewItem.Caption);
            end;
          end;
        end;

        Inc(n01);
        Inc(nTop, ItemHeight);
        if n01 >= nMaxValue then break;
      end;
    end;

    if FShowScroll then begin
      if (WLib <> nil) and (FScrollImageIndex.Up >= 0) then begin
        Texture := WLib.Images[FScrollImageIndex.Up];
        if Texture <> nil then begin
          nLen := Top + Height;
          nTop := Top;
          while nTop < nLen do begin
            if nTop + Texture.Height <= nLen then
              PaintRect := Texture.ClientRect
            else
              PaintRect := Rect(0, 0, Width, nLen - nTop);

            dsurface.Draw(SurfaceX(Left) + (Width - Texture.Width), SurfaceY(nTop), PaintRect, Texture, True);
            Inc(nTop, Texture.Height);
          end;
        end;
      end;

      if WLib <> nil then begin
        nIndex := -1;
        if FPrevMouseDown and (FPrevImageIndex.Down >= 0) then nIndex := FPrevImageIndex.Down
        else if FPrevMouseMove and (FPrevImageIndex.Hot >= 0) then nIndex := FPrevImageIndex.Hot
        else if (FPrevImageIndex.Up >= 0) then nIndex := FPrevImageIndex.Up;
        if (nIndex >= 0) then begin
          Texture := WLib.Images[nIndex];
          if Texture <> nil then begin
            dsurface.Draw(SurfaceX(Left) +(Width - FScrollSize) + ((FScrollSize - Texture.Width) div 2), SurfaceY(Top), Texture.ClientRect, Texture, True);
          end;
        end;
      end;

      if WLib <> nil then begin
        nIndex := -1;
        if FNextMouseDown and (FNextImageIndex.Down >= 0) then nIndex := FNextImageIndex.Down
        else if FNextMouseMove and (FNextImageIndex.Hot >= 0) then nIndex := FNextImageIndex.Hot
        else if (FNextImageIndex.Up >= 0) then nIndex := FNextImageIndex.Up;

        if nIndex >= 0 then begin
          Texture := WLib.Images[nIndex];
          if Texture <> nil then begin
            dsurface.Draw(SurfaceX(Left) +(Width - FScrollSize) + ((FScrollSize - Texture.Width) div 2), SurfaceY(Top)+ (Height - Texture.Height - 1), Texture.ClientRect, Texture, True);
          end;
        end;
      end;

      if WLib <> nil then begin
        nIndex := -1;
        if FBarMouseDown and (FBarImageIndex.Down >= 0) then nIndex := FBarImageIndex.Down
        else if FBarMouseMove and (FBarImageIndex.Hot >= 0) then nIndex := FBarImageIndex.Hot
        else if (FBarImageIndex.Up >= 0) then nIndex := FBarImageIndex.Up;

        if nIndex >= 0 then begin
          Texture := WLib.Images[nIndex];
          if Texture <> nil then begin
            dsurface.Draw(SurfaceX(Left) +(Width - FScrollSize) + (FScrollSize - Texture.Width) div 2, SurfaceY(Top)+ FPrevImageSize + FBarTop, Texture.ClientRect, Texture, True);
          end;
        end;
      end;
    end;
  end;
  DragModePaint(dsurface);
end;

procedure TDChatMemo.DoResize;
var
  nMaxScrollValue: Integer;
  nMaxValue: Integer;
begin
  if FShowScroll then begin
    nMaxValue := MaxValue;
    nMaxScrollValue := Height - FPrevImageSize - FNextImageSize - FBarImageSize;

    if (nMaxValue > 0) and (nMaxScrollValue > 0) then
      FBarTop := Max(Round(FPosition * nMaxScrollValue / (nMaxValue - VisibleHeight)), 0)
    else
      FBarTop := 0;

    if nMaxValue > VisibleHeight then begin
      if FPosition + VisibleHeight >= nMaxValue then
        FBarTop := Height - FPrevImageSize - FNextImageSize - FBarImageSize
      else
        if FPosition = 0 then
        FBarTop := 0;
    end else begin
      FBarTop := 0;
      Position := 0;
    end;
  end;
end;

procedure TDChatMemo.DoScroll(Value: Integer);
begin
  FTopIndex := (Position - Value) div ItemHeight;
end;

procedure TDChatMemo.First;
var
  P: Integer;
  nMaxScrollValue: Integer;
  nMaxValue: Integer;
begin
  if FPosition > 0 then begin
    P := 0;
    DoScroll(FPosition - P);
    FPosition := P;
  end;

  if FShowScroll then begin
    nMaxValue := MaxValue;
    nMaxScrollValue := Height - FPrevImageSize - FNextImageSize - FBarImageSize;

    if (nMaxValue > 0) and (nMaxScrollValue > 0) then
      FBarTop := Max(Round(FPosition * nMaxScrollValue / (nMaxValue - VisibleHeight)), 0)
    else
      FBarTop := 0;

    if nMaxValue > VisibleHeight then begin
      if FPosition + VisibleHeight >= nMaxValue then
        FBarTop := nMaxScrollValue
      else
        if FPosition = 0 then
        FBarTop := 0;
    end else FBarTop := 0;
  end;
end;

function TDChatMemo.GetVisibleHeight: Integer;
begin
  Result := Height - OffSetY;
end;

function TDChatMemo.InBarRange(X, Y: Integer): Boolean;
var
  nHeight: Integer;
  nMaxValue: Integer;
  nBarTop: Integer;
begin
  Result := False;
  if FShowScroll then begin
    if (X >= Left + Width - FScrollSize) and (Y < Top +Height - FNextImageSize) and
      (Y > Top + FPrevImageSize) then begin
      if FPosition > 0 then begin
        nMaxValue := MaxValue;
        nHeight := Height - FPrevImageSize - FNextImageSize - FBarImageSize;
        if (nMaxValue > 0) and (nHeight > 0) and (nMaxValue > VisibleHeight) then
          nBarTop := Round(FPosition * nHeight / (nMaxValue - VisibleHeight))
        else
          nBarTop := 0;
        Result := (Y >= Top + FPrevImageSize + nBarTop) and (Y <= Top + FPrevImageSize + nBarTop + FBarImageSize);
      end else begin
        Result := (Y <= Top + FPrevImageSize + FBarImageSize);
      end;
    end;
  end;
end;

function TDChatMemo.InNextRange(X, Y: Integer): Boolean;
begin
  Result := (X >= Left + Width - FScrollSize) and (Y >= Top + (Height - FNextImageSize));
end;

function TDChatMemo.InPrevRange(X, Y: Integer): Boolean;
begin
  Result := (X >= Left + Width - FScrollSize) and (Y <= Top + FPrevImageSize);
end;

procedure TDChatMemo.Insert(Index: Integer; const S: string; FC, BC: TColor);
var
  TextWidth: Integer;

  I, Len, ALine: integer;
  sText, DLine, Temp: string;

  ViewItem: pTViewItem;
begin
  if ShowScroll then
    TextWidth := Width - ScrollSize - FontManager.Default.TextWidth('0')
  else TextWidth := Width - FontManager.Default.TextWidth('0');

  sText := S;

  if FontManager.Default.TextWidth(sText) > TextWidth then begin
    Len := Length(sText);
    Temp := '';
    I := 1;
    while True do begin
      if I > Len then break;
      if Byte(sText[I]) >= 128 then begin
        Temp := Temp + sText[I];
        Inc(I);
        if I <= Len then Temp := Temp + sText[I]
        else break;
      end else
        Temp := Temp + sText[I];

      ALine := FontManager.Default.TextWidth(Temp);
      if ALine > TextWidth then begin
        TDChatMemoLines(FLines).Insert(Index, Temp);
        ViewItem := pTViewItem(FLines.Objects[Index]);
        ViewItem.Transparent := False;
        ViewItem.Caption := Temp;
        ViewItem.Color.Up.Color := FC;
        ViewItem.Color.Up.BColor := BC;
        ViewItem.Color.Up.Bold := False;
        ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
        ViewItem.Color.Down.Assign(ViewItem.Color.Up);
        ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);

        sText := Copy(sText, I + 1, Len - i);
        Temp := '';

        if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
        if (Assigned(FOnChange)) then FOnChange(Self);
        break;
      end;
      Inc(I);
    end;

    if Temp <> '' then begin
      TDChatMemoLines(FLines).Insert(Index, Temp);
      ViewItem := pTViewItem(FLines.Objects[Index]);
      ViewItem.Transparent := False;
      ViewItem.Caption := Temp;
      ViewItem.Color.Up.Color := FC;
      ViewItem.Color.Up.BColor := BC;
      ViewItem.Color.Up.Bold := False;
      ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
      ViewItem.Color.Down.Assign(ViewItem.Color.Up);
      ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);
      sText := '';

      if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
      if (Assigned(FOnChange)) then FOnChange(Self);
    end;

    if sText <> '' then begin
      Inc(Index);
      Insert(Index, ' ' + sText, FC, BC);
    end;
  end else begin
    TDChatMemoLines(FLines).Insert(Index, Temp);
    ViewItem := pTViewItem(FLines.Objects[Index]);
    ViewItem.Transparent := False;
    ViewItem.Caption := sText;
    ViewItem.Color.Up.Color := FC;
    ViewItem.Color.Up.BColor := BC;
    ViewItem.Color.Up.Bold := False;
    ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
    ViewItem.Color.Down.Assign(ViewItem.Color.Up);
    ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);

    if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
    if (Assigned(FOnChange)) then FOnChange(Self);
  end;
end;

procedure TDChatMemo.InsertTop(Index: Integer; const S: string; FC, BC: TColor;
  TimeOut: Integer);
var
  TextWidth: Integer;

  I, Len, ALine: integer;
  sText, DLine, Temp: string;

  ViewItem: pTViewItem;
begin
  if ShowScroll then
    TextWidth := Width - ScrollSize - FontManager.Default.TextWidth('0')
  else TextWidth := Width - FontManager.Default.TextWidth('0');

  sText := S;

  if FontManager.Default.TextWidth(sText) > TextWidth then begin
    Len := Length(sText);
    Temp := '';
    I := 1;
    while True do begin
      if I > Len then break;
      if Byte(sText[I]) >= 128 then begin
        Temp := Temp + sText[I];
        Inc(I);
        if I <= Len then Temp := Temp + sText[I]
        else break;
      end else
        Temp := Temp + sText[I];

      ALine := FontManager.Default.TextWidth(Temp);
      if ALine > TextWidth then begin
        TDChatMemoLines(FTopLines).Insert(Index, Temp);
        ViewItem := pTViewItem(FTopLines.Objects[Index]);
        ViewItem.TimeTick := GetTickCount + TimeOut * 1000;
        ViewItem.Transparent := False;
        ViewItem.Caption := Temp;
        ViewItem.Color.Up.Color := FC;
        ViewItem.Color.Up.BColor := BC;
        ViewItem.Color.Up.Bold := False;
        ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
        ViewItem.Color.Down.Assign(ViewItem.Color.Up);
        ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);

        sText := Copy(sText, I + 1, Len - i);
        Temp := '';

        if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
        if (Assigned(FOnChange)) then FOnChange(Self);
        break;
      end;
      Inc(I);
    end;

    if Temp <> '' then begin
      TDChatMemoLines(FTopLines).Insert(Index, Temp);
      ViewItem := pTViewItem(FTopLines.Objects[Index]);
      //ViewItem.TimeTick := GetTickCount + TimeOut * 1000;
      ViewItem.Transparent := False;
      ViewItem.Caption := Temp;
      ViewItem.Color.Up.Color := FC;
      ViewItem.Color.Up.BColor := BC;
      ViewItem.Color.Up.Bold := False;
      ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
      ViewItem.Color.Down.Assign(ViewItem.Color.Up);
      ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);
      sText := '';
      if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
      if (Assigned(FOnChange)) then FOnChange(Self);
    end;

    if sText <> '' then begin
      Inc(Index);
      InsertTop(Index, ' ' + sText, FC, BC, TimeOut);
    end;
  end else begin
    TDChatMemoLines(FTopLines).Insert(Index, Temp);
    ViewItem := pTViewItem(FTopLines.Objects[Index]);
    //ViewItem.TimeTick := GetTickCount + TimeOut * 1000;
    ViewItem.Transparent := False;
    ViewItem.Caption := sText;
    ViewItem.Color.Up.Color := FC;
    ViewItem.Color.Up.BColor := BC;
    ViewItem.Color.Up.Bold := False;
    ViewItem.Color.Hot.Assign(ViewItem.Color.Up);
    ViewItem.Color.Down.Assign(ViewItem.Color.Up);
    ViewItem.Color.Disabled.Assign(ViewItem.Color.Up);

    if FAutoScroll and ((FTopLines.Count + FLines.Count) * ItemHeight > VisibleHeight) then Next;
    if (Assigned(FOnChange)) then FOnChange(Self);
  end;
end;

function TDChatMemo.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := False;
  if inherited KeyDown(Key, Shift) then begin
    Result := True;
    case Key of
      VK_UP: Previous;
      VK_DOWN: Next;
      VK_PRIOR: if Position >= Height then Position := Position - Height else Position := 0;
      VK_NEXT: if Position + Height < MaxValue then Position := Position + Height else Position := MaxValue;
    end;
  end;
end;

procedure TDChatMemo.Last;
var
  P: Integer;
  nMaxScrollValue: Integer;
  nMaxValue: Integer;
  nPosition: Integer;
begin
  nMaxValue := MaxValue;
  if (nMaxValue > 0) and (nMaxValue > VisibleHeight) then begin
    if FPosition + VisibleHeight < nMaxValue then begin
      P := nMaxValue - VisibleHeight;
      DoScroll(FPosition - P);
      FPosition := P;
    end;
  end else begin
    if FPosition > 0 then begin
      P := 0;
      DoScroll(FPosition - P);
      FPosition := P;
    end;
  end;

  if FShowScroll then begin
    nMaxScrollValue := Height - FPrevImageSize - FNextImageSize - FBarImageSize;

    if (nMaxValue > 0) and (nMaxScrollValue > 0) then
      FBarTop := Max(Round(FPosition * nMaxScrollValue / (nMaxValue - VisibleHeight)), 0)
    else
      FBarTop := 0;

    if nMaxValue > VisibleHeight then begin
      if FPosition + VisibleHeight >= nMaxValue then
        FBarTop := nMaxScrollValue
      else
        if FPosition = 0 then
        FBarTop := 0;
    end else FBarTop := 0;
  end;
end;

procedure TDChatMemo.LoadFromFile(const FileName: string);
begin
  FLines.LoadFromFile(FileName);
  FTopLines.Clear;
end;

function TDChatMemo.MaxValue: Integer;
begin
  Result := (FTopLines.Count + FLines.Count) * ItemHeight;
  if VisibleItemCount > 0 then begin
      Result := Result + (VisibleHeight - VisibleItemCount * ItemHeight);
  end;
  Result := Result + ExpandSize;
end;

function TDChatMemo.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
var
  I, P: Integer;
  nHeight: Integer;
  nMaxValue: Integer;
  nBarTop: Integer;
  vRect: TRect;
begin
  Result := FALSE;
  if (inherited MouseDown(Button, Shift, X, Y)) then begin
    Result := True;
    if (not Background) and (MouseCaptureControl=nil) then begin
      SetDCapture(Self);
      Downed := TRUE;
      if (Button = mbLeft) and FShowScroll then begin
        FScrollMouseDown := (X >= Left + Width - FScrollSize);
        if not (FPrevMouseDown or FNextMouseDown or FBarMouseDown) then begin
          FPrevMouseDown := InPrevRange(X, Y);
          FNextMouseDown := InNextRange(X, Y);
          FBarMouseDown := InBarRange(X, Y);
        end;

        if (not FPrevMouseDown) and (not FNextMouseDown) and (not FBarMouseDown) then begin
          vRect.Left := Left + Width - FScrollSize;
          vRect.Top := Top;
          vRect.Bottom := vRect.Top + Height;
          vRect.Right := vRect.Left + FScrollSize;
          if PointInRect(Point(X, Y), vRect) then begin
            nMaxValue := MaxValue;
            nHeight := Height - FPrevImageSize - FNextImageSize - FBarImageSize;
            if ((nMaxValue > 0) and (nMaxValue > VisibleHeight) and (nHeight > 0)) or (Position > 0) then begin
              nBarTop := Max(Y - vRect.Top - FPrevImageSize - FBarImageSize div 2, 0);
              Position := Round(nBarTop * (nMaxValue - VisibleHeight) / nHeight);
            end else begin
              Position := 0;
            end;

            Exit;
          end;
        end else begin
          if FPrevMouseDown and InPrevRange(X, Y) then begin
            Previous;
          end else
            if FNextMouseDown and InNextRange(X, Y) then begin
            Next;
          end;
        end;
      end;
      FItemIndex := (Y - Top - OffSetY) div FItemHeight + FPosition div FItemHeight;
      if FItemIndex >= (MaxValue - VisibleItemCount * ItemHeight) div FItemHeight then
        FItemIndex := -1;
    end;
  end;
end;

function TDChatMemo.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  P: Integer;
  nHeight: Integer;
  nMaxValue: Integer;
  nBarTop: Integer;
begin
  Result := inherited MouseMove (Shift, X, Y);
  if (not Background) and (Result) then begin
    Result := inherited MouseMove (Shift, X, Y);
      if MouseCaptureControl = self then Downed := TRUE;
      if FShowScroll then begin
        if not (FPrevMouseDown or FNextMouseDown or FBarMouseDown or Downed or FScrollMouseDown) then begin
          FPrevMouseMove := InPrevRange(X, Y);
          FNextMouseMove := InNextRange(X, Y);
          FBarMouseMove := InBarRange(X, Y);
        end;
      end;
      if FBarMouseDown and FShowScroll then begin
        FPrevMouseMove := False;
        FNextMouseMove := False;

        FNextMouseDown := False;
        FPrevMouseDown := False;

        nMaxValue := MaxValue;
        nHeight := Height - FPrevImageSize - FNextImageSize - FBarImageSize;
        if ((nMaxValue > 0) and (nMaxValue > VisibleHeight) and (nHeight > 0)) or (Position > 0) then begin
          nBarTop := Max(Y - Top - FPrevImageSize - FBarImageSize div 2, 0);
          Position := Round(nBarTop * (nMaxValue - VisibleHeight) / nHeight);
        end else begin
          Position := 0;
        end;
      end else begin
        if FPrevMouseDown then begin
            Previous;
        end else if FNextMouseDown then begin
            Next;
        end;
        FItemIndex := (Y - Top - OffSetY) div FItemHeight + FPosition div FItemHeight;
        if FItemIndex >= (MaxValue - VisibleItemCount * ItemHeight) div FItemHeight then
          FItemIndex := -1;
      end;
  end else if not (FPrevMouseDown or FNextMouseDown or FBarMouseDown or Downed) then begin
        FPrevMouseMove := False;
        FNextMouseMove := False;
        FBarMouseMove := False;
  end;
end;

function TDChatMemo.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseUp (Button, Shift, X, Y) then begin
    ReleaseDCapture;
    Downed := FALSE;
    Result := TRUE;
  end else begin
    ReleaseDCapture;
    Downed := FALSE;
  end;
  FBarMouseDown := False;
  FPrevMouseDown := False;
  FNextMouseDown := False;
  FPrevMouseMove := False;
  FNextMouseMove := False;
  FBarMouseMove := False;
  FScrollMouseDown := False;
end;

procedure TDChatMemo.Next;
var
  P: Integer;
  nMaxScrollValue: Integer;
  nMaxValue: Integer;
  nPosition: Integer;
begin
  nMaxValue := MaxValue;
  if (nMaxValue > 0) and (nMaxValue > VisibleHeight) then begin
    if (FPosition + VisibleHeight < nMaxValue) then begin
      if FPosition + VisibleHeight + FItemHeight <= nMaxValue then begin
        P := FPosition + FItemHeight;
        DoScroll(FPosition - P);
        FPosition := P;
      end else begin
        P := nMaxValue - VisibleHeight;
        DoScroll(FPosition - P);
        FPosition := P;
      end;
    end;
  end else begin
    if FPosition > 0 then begin
      P := 0;
      DoScroll(FPosition - P);
      FPosition := P;
    end;
  end;

  if FShowScroll then begin
    nMaxScrollValue := Height - FPrevImageSize - FNextImageSize - FBarImageSize;

    if (nMaxValue > 0) and (nMaxScrollValue > 0) then
      FBarTop := Max(Round(FPosition * nMaxScrollValue / (nMaxValue - VisibleHeight)), 0)
    else
      FBarTop := 0;

    if nMaxValue > (Height) then begin
      if FPosition + VisibleHeight >= nMaxValue then
        FBarTop := nMaxScrollValue
      else
        if FPosition = 0 then
        FBarTop := 0;
    end else FBarTop := 0;
  end;
end;

procedure TDChatMemo.NextImageIndexChange(Sender: TObject);
var
  d: TAsphyreLockableTexture;
  nIndex: Integer;
begin
  if FNextImageIndex.Up >= 0 then
    nIndex := FNextImageIndex.Up
  else
    if FNextImageIndex.Hot >= 0 then
    nIndex := FNextImageIndex.Hot
  else
    if FNextImageIndex.Down >= 0 then
    nIndex := FNextImageIndex.Down;

  if (WLib <> nil) and (nIndex >= 0) then begin
    d := WLib.Images[nIndex];
    if d <> nil then
      FNextImageSize := d.Height;
  end;
end;

procedure TDChatMemo.PrevImageIndexChange(Sender: TObject);
var
  d: TAsphyreLockableTexture;
  nIndex: Integer;
begin
  if (WLib <> nil) then begin
    if FPrevImageIndex.Up >= 0 then
      nIndex := FPrevImageIndex.Up
    else
      if FPrevImageIndex.Hot >= 0 then
      nIndex := FPrevImageIndex.Hot
    else
      if FPrevImageIndex.Down >= 0 then
      nIndex := FPrevImageIndex.Down;

    if (nIndex >= 0) then begin
      d := WLib.Images[nIndex];
      if d <> nil then
        FPrevImageSize := d.Height;
    end;
  end;
end;

procedure TDChatMemo.Previous;
var
  P: Integer;
  nMaxScrollValue: Integer;
  nMaxValue: Integer;
  nPosition: Integer;
begin
  nMaxValue := MaxValue;
  if FPosition > 0 then begin
    if (nMaxValue > 0) and (nMaxValue > VisibleHeight) then begin
      if FPosition - FItemHeight >= 0 then begin
        P := FPosition - FItemHeight;
        DoScroll(FPosition - P);
        FPosition := P;
      end else begin
        P := 0;
        DoScroll(FPosition - P);
        FPosition := P;
      end;
    end else begin
      P := 0;
      DoScroll(FPosition - P);
      FPosition := P;
    end;
  end;

  if FShowScroll then begin
    nMaxScrollValue := Height - FPrevImageSize - FNextImageSize - FBarImageSize;

    if (nMaxValue > 0) and (nMaxScrollValue > 0) then
      FBarTop := Max(Round(FPosition * nMaxScrollValue / (nMaxValue - VisibleHeight)), 0)
    else
      FBarTop := 0;

    if nMaxValue > VisibleHeight then begin
      if FPosition + VisibleHeight >= nMaxValue then
        FBarTop := nMaxScrollValue
      else
        if FPosition = 0 then
        FBarTop := 0;
    end else FBarTop := 0;
  end;
end;

procedure TDChatMemo.ScrollImageIndexChange(Sender: TObject);
var
  d: TAsphyreLockableTexture;
  nIndex: Integer;
begin
  if (WLib <> nil) then begin
    if FScrollImageIndex.Up >= 0 then
      nIndex := FScrollImageIndex.Up
    else
      if FScrollImageIndex.Hot >= 0 then
      nIndex := FScrollImageIndex.Hot
    else
      if FScrollImageIndex.Down >= 0 then
      nIndex := FScrollImageIndex.Down;

    if (nIndex >= 0) then begin
      d := WLib.Images[nIndex];
      if d <> nil then
        FScrollSize := d.Width;
    end;
  end;
end;

procedure TDChatMemo.SetExpandSize(Value: Integer);
var
  nMaxValue, nMaxScrollValue: Integer;
begin
  if FExpandSize <> Value then begin
    FExpandSize := Value;
    if FShowScroll then begin
      nMaxValue := MaxValue;
      nMaxScrollValue := Height - FPrevImageSize - FNextImageSize - FBarImageSize;

      if (nMaxValue > 0) and (nMaxScrollValue > 0) then
        FBarTop := Max(Round(FPosition * nMaxScrollValue / (nMaxValue - VisibleHeight)), 0)
      else
        FBarTop := 0;

      if nMaxValue > (Height) then begin
        if FPosition + VisibleHeight >= nMaxValue then
          FBarTop := nMaxScrollValue
        else
          if FPosition = 0 then
          FBarTop := 0;
      end else FBarTop := 0;
    end;
  end;
end;

procedure TDChatMemo.SetItemHeight(Value: Integer);
begin
  FItemHeight := Max(Value, 1);
end;

procedure TDChatMemo.SetItemIndex(Value: Integer);
var
  nItemCount: Integer;
begin
  if FItemIndex <> Value then begin
    FItemIndex := Value;
    nItemCount := (MaxValue - VisibleItemCount * ItemHeight) div FItemHeight;
    if FItemIndex >= nItemCount then FItemIndex := -1;
    if FItemIndex >= 0 then begin
      Position := FItemIndex * FItemHeight;
    end;
  end;
end;

procedure TDChatMemo.SetLines(Value: TStrings);
begin
  FLines.Clear;
  FLines.AddStrings(Value);
end;

procedure TDChatMemo.SetPosition(Value: Integer); //设置滚动指针
var
  P, nMaxValue, nMaxScrollValue: Integer;
begin
  nMaxValue := MaxValue;
  if FPosition <> Value then begin
    P := Value;
    if P < 0 then P := 0;

    if VisibleHeight > nMaxValue then begin
      P := 0;
    end else begin
      if P + VisibleHeight > nMaxValue then
        P := nMaxValue - VisibleHeight;
    end;

    DoScroll(FPosition - P);
    FPosition := P;
  end;

  if FShowScroll then begin
    nMaxScrollValue := Height - FPrevImageSize - FNextImageSize - FBarImageSize;

    if (nMaxValue > 0) and (nMaxScrollValue > 0) then
      FBarTop := Max(Round(FPosition * nMaxScrollValue / (nMaxValue - VisibleHeight)), 0)
    else
      FBarTop := 0;

    if nMaxValue > VisibleHeight then begin
      if FPosition + VisibleHeight >= nMaxValue then
        FBarTop := Height - FPrevImageSize - FNextImageSize - FBarImageSize
      else
        if FPosition = 0 then
        FBarTop := 0;
    end else FBarTop := 0;
  end;
end;

procedure TDChatMemo.SetScrollSize(Value: Integer);
begin
  if FScrollSize <> Value then begin
    FScrollSize := Value;
  end;
end;

procedure TDChatMemo.SetTopLines(Value: TStrings);
begin
  FTopLines.Clear;
  FTopLines.AddStrings(Value);
end;

procedure TDChatMemo.SetVisibleItemCount(Value: Integer);
var
  nMaxValue, nMaxScrollValue: Integer;
begin
  if VisibleHeight div ItemHeight < Value then
    FVisibleItemCount := 0
  else
    FVisibleItemCount := Value;

  if FShowScroll then begin
    nMaxValue := MaxValue;
    nMaxScrollValue := Height - FPrevImageSize - FNextImageSize - FBarImageSize;

    if (nMaxValue > 0) and (nMaxScrollValue > 0) then
      FBarTop := Max(Round(FPosition * nMaxScrollValue / (nMaxValue - VisibleHeight)), 0)
    else
      FBarTop := 0;

    if nMaxValue > (Height) then begin
      if FPosition + VisibleHeight >= nMaxValue then
        FBarTop := nMaxScrollValue
      else
        if FPosition = 0 then
        FBarTop := 0;
    end else FBarTop := 0;
  end;
end;

{ TDChatMemoLines }

function TDChatMemoLines.AddItem(const S: string; AObject: TObject): pTViewItem;
begin
  AddObject(S, AObject);
  Result := @FItemList[Length(FItemList) - 1];
end;

function TDChatMemoLines.AddObject(const S: string; AObject: TObject): Integer;
var
  ViewItem: pTViewItem;
begin
  SetLength(FItemList, Length(FItemList) + 1);
  SetLength(FItemHeightList, Length(FItemHeightList) + 1);
  FItemHeightList[Length(FItemHeightList) - 1] := 0;
  ViewItem := @FItemList[Length(FItemList) - 1];
  ViewItem.Down := False;
  ViewItem.Move := False;
  ViewItem.Caption := S;
  ViewItem.Data := nil;
  ViewItem.Style := bsButton;
  ViewItem.Checked := False;
  ViewItem.Color := TDCaptionColor.Create;
  ViewItem.ImageIndex := TDImageIndex.Create;
  ViewItem.TimeTick := GetTickCount;
  Result := inherited AddObject(S, AObject);
end;

procedure TDChatMemoLines.Clear;
var
  I: Integer;
begin
  for I := 0 to Length(FItemList) - 1 do begin
    FItemList[I].Color.Free;
    FItemList[I].ImageIndex.Free;
  end;
  SetLength(FItemList, 0);
  SetLength(FItemHeightList, 0);
  FItemList := nil;
  FItemHeightList := nil;
  inherited Clear;
end;

constructor TDChatMemoLines.Create;
begin
  inherited;
  FItemList := nil;
  FItemHeightList := nil;
end;

procedure TDChatMemoLines.Delete(Index: Integer);
var
  I: Integer;
begin
  FItemList[Index].Color.Free;
  FItemList[Index].ImageIndex.Free;
  for I := Index to Length(FItemList) - 2 do begin
    FItemList[I] := FItemList[I + 1];
    FItemHeightList[I] := FItemHeightList[I + 1];
  end;
  SetLength(FItemList, Length(FItemList) - 1);
  SetLength(FItemHeightList, Length(FItemHeightList) - 1);
  inherited Delete(Index);
end;

destructor TDChatMemoLines.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FItemList) - 1 do begin
    FItemList[I].Color.Free;
    FItemList[I].ImageIndex.Free;
  end;
  SetLength(FItemList, 0);
  SetLength(FItemHeightList, 0);
  FItemList := nil;
  FItemHeightList := nil;
  inherited;
end;

function TDChatMemoLines.GetItem(Index: Integer): pTViewItem;
begin
  Result := @FItemList[Index];
end;

function TDChatMemoLines.GetItemHeight(Index: Integer): Integer;
begin
  Result := FItemHeightList[Index];
end;

procedure TDChatMemoLines.InsertObject(Index: Integer; const S: string;
  AObject: TObject);
var
  I: Integer;
  ViewItem: pTViewItem;
begin
  SetLength(FItemList, Length(FItemList) + 1);
  SetLength(FItemHeightList, Length(FItemHeightList) + 1);
  for I := Length(FItemList) - 1 downto Index do begin
    FItemList[I] := FItemList[I - 1];
    FItemHeightList[I] := FItemHeightList[I - 1];
  end;
  FItemHeightList[Index] := 0;
  ViewItem := @FItemList[Index];
  ViewItem.Down := False;
  ViewItem.Move := False;
  ViewItem.Caption := S;
  ViewItem.Data := nil;
  ViewItem.Style := bsButton;
  ViewItem.Checked := False;
  ViewItem.Color := TDCaptionColor.Create;
  ViewItem.ImageIndex := TDImageIndex.Create;
  ViewItem.TimeTick := GetTickCount;
  inherited InsertObject(Index, S, AObject);
end;

procedure TDChatMemoLines.SetItemHeight(Index, Value: Integer);
begin
  FItemHeightList[Index] := Value;
end;
{ TDxTime }
constructor TDTime.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlignment := taLeftJustify;
//  FDFColor:= $FFFFFF;
//  FTransparent:= True;
//  FFrameparent:= True;
end;

function TDTime.GetText: string;
begin
  Result := string(FText);
end;

procedure TDTime.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
  end;
end;

procedure TDTime.SetText(Value: string);
begin
  FText:= Value;
end;

procedure TDTime.DirectPaint(dsurface: TAsphyreCanvas);
var
  dc, rc: TRect;
  ax, ay:Integer;
  SysTime: TsystemTime;
begin
   dc.Left := SurfaceX(Left);
   dc.Top := SurfaceY(Top);
   dc.Right := SurfaceX(left + Width);
   dc.Bottom := SurfaceY(top + Height);
//   if FTransparent then
//   dsurface.FillRect(IntRectBDS(dc.Left, dc.Top, dc.Right, dc.Bottom),cColorw(Color));
//   if FFrameparent then
//   dsurface.FrameRect(IntRectBDS(dc.Left, dc.Top, dc.Right, dc.Bottom),FrameColor);

  with dsurface do begin
    GetLocalTime(SysTime);
    FText:= Format('%.2d:%.2d:%.2d', [SysTime.wHour, SysTime.wMinute, SysTime.wSecond]);
    case FAlignment of //字符串位置
      taLeftJustify: BoldTextOut(SurfaceX(Left), SurfaceY(Top) + (Height - FontManager.Default.TextHeight(FText)) div 2, FText, Color, $212121);
      taCenter: BoldTextOut(SurfaceX(Left) + (Width - FontManager.Default.TextWidth(FText)) div 2, SurfaceY(Top) + (Height - FontManager.Default.TextHeight(FText)) div 2, FText, Color, $212121);
      taRightJustify: BoldTextOut(SurfaceX(Left)+ (Width - FontManager.Default.TextWidth(FText)), SurfaceY(Top) + (Height - FontManager.Default.TextHeight(FText)) div 2, FText, Color, $212121);
    end;
  end;
end;

{ TDAniButton }

constructor TDAniButton.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FAniCount := 1;            //播放图片数量
  FAniInterval := 1;       //绘制间隔
  FAniLoop := False;          //是否循环
  FOffsetX := 0;
  FOffsetY := 0;
  FDrawMode := beNormal;    //绘制模式
  FStart := False;           //是否开始绘制
  FFrameIndex := 0;
  FChangeFrameTime := GetTickCount;
  FAniOverHide := False;
//  FMouseThrough := True;
  FClipType := ctNone;
  FClipOrientation := coBottom2Top;
end;


procedure TDAniButton.DirectPaint(DSurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  dwTick: Cardinal;
  nMaxFrameIndex, nPx, nPy: integer;
  nValue, nMaxValue: Int64;
  DrawRect: TRect;
  BoAniFinished : Boolean;
begin
  if Assigned(WLib) then begin
    if (FaceIndex >= 0) and (FAniCount > 0)  then begin
      if FAniCount >= 0 then
        nMaxFrameIndex := FaceIndex + FAniCount - 1
      else
        nMaxFrameIndex := FaceIndex + FAniCount + 1;

      dwTick := GetTickCount;
      if FChangeFrameTime = 0 then
        FChangeFrameTime := dwTick;

      if FFrameIndex <= 0 then
        FFrameIndex := FaceIndex;

      BoAniFinished := False;
      if dwTick - FChangeFrameTime > FAniInterval then
      begin
        if FAniCount >= 0 then
        begin
          Inc(FFrameIndex); // 增加一帧
          if FFrameIndex > nMaxFrameIndex then
            BoAniFinished := True;
        end else
        begin
          Dec(FFrameIndex);
          if FFrameIndex < 0 then
            FFrameIndex := 0;
          if FFrameIndex < nMaxFrameIndex then
            BoAniFinished := True;
        end;

        if BoAniFinished then
        begin
          if FAniLoop then
            FFrameIndex := FaceIndex
          else
          begin
            FFrameIndex := nMaxFrameIndex;
            if FAniOverHide then Visible := False;
          end;
        end;
        FChangeFrameTime := dwTick;
      end;
      d := WLib.GetCachedImage(FFrameIndex, nPx, nPy);
      nPx := nPx + FOffsetX;
      nPy := nPy + FOffsetY;
     if D <> nil then
      begin
        if FClipType = ctNone then
        begin
           DSurface.Draw(SurfaceX(Left) + nPx, SurfaceY(Top) + nPy, D, clWhite4,  FDrawMode);
        end
        else
        begin
          nValue := 1;
          nMaxValue := 1;
          if FClipType <> ctDynamicValue then
          begin
            if Assigned(GetClipValueProc) then
              GetClipValueProc(FClipType, nValue, nMaxValue);
          end else
          begin
            nMaxValue := 100;
            nValue := Min(Trunc(100 * FDynamicClipValue),100);
          end;
          // 裁剪方向
          case FClipOrientation of
            coBottom2Top:
              begin
                DrawRect := D.ClientRect;
                DrawRect.Top :=Round(DrawRect.Bottom / nMaxValue * (nMaxValue - nValue));
                DSurface.Draw(SurfaceX(Left) + nPx, SurfaceY(Top) + nPy +DrawRect.Top, DrawRect, D, clWhite4, FDrawMode);
              end;
            coTop2Bottom:
              begin
                DrawRect := D.ClientRect;
                DrawRect.Bottom := D.Height - Round(DrawRect.Bottom / nMaxValue * (nMaxValue - nValue));
                DSurface.Draw(SurfaceX(Left) + nPx, SurfaceY(Top) + nPy, DrawRect, D, clWhite4, FDrawMode);
              end;
            coLeftToRight:
              begin
                DrawRect := D.ClientRect;
                DrawRect.Right := D.Width - Round(DrawRect.Right / nMaxValue * (nMaxValue - nValue));
                DSurface.Draw(SurfaceX(Left) + nPx, SurfaceY(Top) + nPy, DrawRect, D, clWhite4, FDrawMode);
              end;
            coRight2Left:
              begin
                DrawRect := D.ClientRect;
                DrawRect.Left := Round(DrawRect.Right / nMaxValue * (nMaxValue - nValue));
                DSurface.Draw(SurfaceX(Left) + nPx + DrawRect.Left, SurfaceY(Top) + nPy, DrawRect, D, clWhite4,FDrawMode);
              end;
          end;
        end;
      end;
    end;
  end;
  DragModePaint(dsurface);
  if Assigned(FOnDirectPaint) then
  begin
    try
      FOnDirectPaint(Self, DSurface);
    except
    end;
  end
end;

function TDAniButton.GetClipOrientation: TClipOrientation;
begin
  Result := FClipOrientation;
end;

function TDAniButton.GetClipType: TClipType;
begin
  Result := FClipType;
end;

function TDAniButton.GetDrawFrameIndex: integer;
begin
  if FFrameIndex <= 0 then
    Result := 0
  else
    Result := FFrameIndex - FaceIndex;
end;

procedure TDAniButton.SetClipOrientation(const Value: TClipOrientation);
begin
  FClipOrientation := Value;
end;

procedure TDAniButton.SetClipType(const Value: TClipType);
begin
  FClipType := Value;
end;

initialization
  g_DWinMan := TDWinManager.Create;

finalization
  FreeAndNil(g_DWinMan);
end.





