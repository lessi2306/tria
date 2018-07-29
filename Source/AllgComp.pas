unit AllgComp;
// bei erstmaliger Verwendung muss directory ..\Delphi7\Projectd\Bpl
// angelegt werden

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, Grids, Math, ComCtrls, MaskUtils, Buttons, Character,
  AllgConst,AllgFunc,AllgObj;

type

 {allgemeine Funktionen in TriaForm
  TTriaForm = class(TForm)
  private
    HelpFensterAlt   : TWinControl;
    Updating         : Boolean;
  public
    constructor Create(AOwner: TComponent); override;
  end; }

  TTriaCustomMaskEdit        = class;
  TTriaGrid                  = class;
  TTriaLookUpGrid            = class;
  TGridGetColTextEvent       = procedure(Sender:TTriaGrid; Item:Pointer; ACol:Integer;
                                         var Value:String) of object;
  TGridPaintEvent            = procedure(Sender:TObject) of object;
  TGridColEditEvent          = procedure(Sender:TObject) of object;
  TLookUpGridGetRowTextEvent = procedure(Sender:TTriaLookUpGrid; Indx:Integer;
                                          var Value:String) of object;

  TTriaGrid = class(TCustomDrawGrid)
  protected
    FRowsMin           : Integer;
    FStopPaint         : Boolean;
    FPaintWartend      : Boolean;
    FOnPaint           : TGridPaintEvent;
    FOnColEdit         : TGridColEditEvent;
    FTopAbstand        : Integer;
    FColAlign          : array of TAlignment;
    FColEdits          : array of TTriaCustomMaskEdit;
    FColEditAssigned   : Boolean;
    FColEditMode       : Boolean;
    FEditFont          : TFont;
    FOnGetColText      : TGridGetColTextEvent;
    function  GetItem(Indx:Integer): Pointer;
    function  GetItemIndex: Integer;
    procedure SetItemIndex(Indx:Integer);
    function  GetFocusedItem: Pointer;
    procedure SetFocusedItem(Item:Pointer);
    function  GetItemCount: Integer;
    procedure SetColCount(Value: Integer);
    function  GetColCount: Integer;
    procedure SetColAlign(Index: Integer; Value: TAlignment);
    function  GetColAlign(Index: Integer): TAlignment;
    procedure SetColEdits(Index: Integer; Value: TTriaCustomMaskEdit);
    function  GetColEdits(Index: Integer): TTriaCustomMaskEdit;
    procedure SetColEditsPos;
    function  MinAssignedColumn: Integer;
    function  MaxAssignedColumn: Integer;
    procedure SetColEditFontName(NameNeu:String);
    procedure SetColEditFontSize(SizeNeu:Integer);
    procedure SetColEditFontColor(ColorNeu:TColor);
    procedure TopLeftChanged; override;
    procedure Paint; override;
    procedure SetStopPaint(StopNeu:Boolean);
    procedure CustomAlignPosition(Control: TControl;
                            var NewLeft,NewTop,NewWidth,NewHeight: Integer;
                            var AlignRect:TRect; AlignInfo:TAlignInfo); override;
    procedure Resize; override;
    function  MouseActivate(Button: TMouseButton; Shift: TShiftState;
                                     X, Y, HitTest: Integer): TMouseActivate; override;
    procedure MouseDown(Button:TMouseButton;Shift:TShiftState;X,Y:Integer); override;
    procedure Click; override;
    function  GetColText(ACol, ARow: Integer): String;
    procedure KeyPress(var Key: Char); override;
  public
    Collection    : TTriaSortColl;
    Sorted        : Boolean;
    DummySB       : TScrollBar;
    EnableOnClick : Boolean; // enable Ausf�hrung von OnClick Eventhandler
    FocusAlt      : Pointer;
    EditierMode   : Boolean;
    AktionsSpalte : Integer; // f�r AbglGrid

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(CollNeu:TTriaSortColl;SortMode:TSortMode;Scroll:TScrollStyle;
                   Focus:Pointer);
    function  GetColEditsPos(Indx:Integer; var LeftA,TopA,WidthA,HeightA: Integer): Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function  DoMouseWheel(Shift:TShiftState;WheelDelta:Integer;MousePos:TPoint):Boolean;override;
    procedure ClearItem(Item:Pointer);
    function  GetIndex(Item:Pointer): Integer;
    procedure AddItem(Item:Pointer);
    procedure DrawCellText(Rect:TRect; Text:String; Align:TAlignment);
    procedure FocusZelle(ACol,ARow:Integer);
    procedure NachRechts;
    procedure NachLinks;
    procedure NachUnten;
    procedure SetColEditMode;
    function  ResetColEditMode: Boolean;
    function  ColEditModified: Boolean;
    function  ColEditBreite(ACol:Integer): Integer;
    procedure CollectionUpdate;
    property Items[Indx: Integer]: Pointer read GetItem; default;
    property ItemIndex:Integer read GetItemIndex write SetItemIndex;
    property FocusedItem:Pointer read GetFocusedItem write SetFocusedItem;
    property ItemCount:Integer read GetItemCount;
    property StopPaint: Boolean read FStopPaint write SetStopPaint;
    property TopAbstand : Integer read FTopAbstand write FTopAbstand;
    property ColAlign[Index: Integer]:TAlignment read GetColAlign write SetColAlign;
    property ColEdits[Index: Integer]: TTriaCustomMaskEdit read GetColEdits write SetColEdits;
    property ColEditAssigned : Boolean read FColEditAssigned;
    property ColEditMode : Boolean read FColEditMode write FColEditMode {write SetColEditMode};
    property ColEditFont: TFont read FEditFont;
    property ColEditFontName : String write SetColEditFontName;
    property ColEditFontSize : Integer write SetColEditFontSize;
    property ColEditFontColor : TColor write SetColEditFontColor;
  published
    property Align;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BevelWidth;
    //property BiDiMode;
    property BorderStyle;
    property Color;
    //property ColCount ;
    property ColCount: Integer read GetColCount write SetColCount;
    property Constraints;
    //property Ctl3D;
    property DefaultColWidth;
    property DefaultRowHeight;
    property DefaultDrawing;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property FixedCols;
    property RowCount;
    property FixedRows;
    property Font;
    property GridLineWidth;
    //property Options;
    property Options default
             [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRowSelect];
    //property ParentBiDiMode;
    property ParentColor;
    //property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    //property ScrollBars;
    property ScrollBars default ssVertical;
    property ShowHint;
    property TabOrder;
    property Visible;
    property VisibleColCount;
    property VisibleRowCount;
    property OnClick;
    property OnColumnMoved;
    property OnContextPopup;
    property OnDblClick;
    //property OnDragDrop;
    //property OnDragOver;
    property OnDrawCell;
    //property OnEndDock;
    //property OnEndDrag;
    property OnEnter;
    property OnExit;
    //property OnGetEditMask;
    //property OnGetEditText;
    //property OnSetEditText;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnRowMoved;
    property OnSelectCell;
    //property OnStartDock;
    //property OnStartDrag;
    property OnTopLeftChanged;
    property OnPaint : TGridPaintEvent read FOnPaint write FOnPaint;
    //property OnSave  : TGridSaveObjEvent read FOnSave write FOnSave;
    property OnGetColText : TGridGetColTextEvent read FOnGetColText write FOnGetColText;
    property OnColEdit : TGridColEditEvent read FOnColEdit write FOnColEdit;
  end;

  TTriaEdit = class(TEdit)
  public
    TextAlt : String; // Funktion ?
    constructor Create(AOwner: TComponent); override;
  published
    property AutoSelect default false;
    property AutoSize default false;
  end;

  TTriaLookUpEdit = class(TTriaEdit)
  protected
  //  GridScrolling : Boolean;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Change; override;
  published
    Grid : TTriaLookupGrid;
  end;

  TTriaLookUpBtn = class(TBitBtn)
  public
    procedure Click; override;
  published
    Edit : TTriaLookUpEdit;
    //Grid : TTriaLookupGrid;
  end;

  TTriaLookupGrid = class(TCustomDrawGrid)
  protected
    FOnGetRowText : TLookUpGridGetRowTextEvent;
    FMaxRows : Integer;
    FItemIndex : Integer;
    procedure UpdateItems;
    function  GetRowText(Indx:Integer): String;
    procedure Click; override;
    procedure DrawCell(ACol,ARow:Longint;ARect:TRect;AState:TGridDrawState); override;
    procedure TopLeftChanged; override;
  public
    Items : TStringList;
    Liste : TStringList;  // Pointer, String und Object pro Item
    LookUpMode : TLookUpGridMode;
    DisableClick,DisableClickAlt : Boolean;
    //Aendernd : Boolean;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

  published
    Btn   : TTriaLookUpBtn; // Pointer auf vorhander Btn
    Edit  : TTriaLookUpEdit; // Pointer auf vorhander Edit
    property MaxRows : Integer read FMaxRows write FMaxRows;
    // von TDrawGrid
    property Align;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BevelWidth;
    //property BiDiMode;
    property BorderStyle;
    property Color;
    property ColCount default 1;
    property Constraints;
    //property Ctl3D;
    property DefaultColWidth;
    property DefaultRowHeight default 17;
    property DefaultDrawing default false;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property FixedCols default 0;
    property RowCount;
    property FixedRows default 0;
    property Font;
    property GridLineWidth;
    //property Options;
    property Options default [goThumbTracking];
    //property ParentBiDiMode;
    property ParentColor;
    //property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    //property ScrollBars;
    property ScrollBars default ssVertical;
    property ShowHint;
    property TabOrder;
    property Visible;
    property VisibleColCount;
    property VisibleRowCount;
    property OnClick;
    property OnColumnMoved;
    property OnContextPopup;
    property OnDblClick;
    //property OnDragDrop;
    //property OnDragOver;
    property OnDrawCell;
    //property OnEndDock;
    //property OnEndDrag;
    property OnEnter;
    property OnExit;
    //property OnGetEditMask;
    //property OnGetEditText;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnRowMoved;
    property OnSelectCell;
    //property OnSetEditText;
    //property OnStartDock;
    //property OnStartDrag;
    property OnTopLeftChanged;
    property OnGetRowText : TLookUpGridGetRowTextEvent read FOnGetRowText write FOnGetRowText;
  end;

  //TEditPaintEvent = procedure (Sender: TObject; var continue: boolean) of object;

  TTriaCustomMaskEdit = class(TCustomMaskEdit)
  protected
    FOrgText : String; // Funktion f�r ESC-Reset
    FTriaGrid : TTriaGrid;
    function GetText: String;
    procedure SetText(const Value: String);
    procedure KorrigiereCursor; virtual;
    property  TriaGrid : TTriaGrid read FTriaGrid write FTriaGrid;
  public
    TextAlt : String; // n�tig oder gleich TextOrg ?????
    ZahlFormat : TZahlFormat;
    constructor Create(AOwner: TComponent); override;
    function  ValidateEdit: Boolean; reintroduce;
    procedure AendereText(const Value: String);
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseUp(Button:TMouseButton;Shift:TShiftState;X,Y:Integer); override;
  published
    property Align;
    //property Anchors;
    property AutoSelect default false;
    property AutoSize default false;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    //property BiDiMode;
    property BorderStyle;
    //property CharCase;
    property Color;
    property Constraints;
    //property Ctl3D;
    //property DragCursor;
    //property DragKind;
    //property DragMode;
    property Enabled;
    property EditMask;
    property Font;
    //property ImeMode;
    //property ImeName;
    property MaxLength;
    //property ParentBiDiMode;
    property ParentColor;
    //property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    //property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    //property Text;
    property Text:String read GetText write SetText;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    //property OnDragDrop;
    //property OnDragOver;
    //property OnEndDock;
    //property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    //property OnMouseEnter;
    //property OnMouseLeave;
    //property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    //property OnMouseWheelDown;
    //property OnMouseWheelUp;
    //property OnStartDock;
    //property OnStartDrag;
  end;

  TTriaUpDown = class;
  TTriaMaskEdit = class(TTriaCustomMaskEdit)
  protected
    FUpDown : TTriaUpDown;
    procedure KorrigiereCursor; override;
    procedure Change; override;
  public
    Aendernd : Boolean;
    constructor Create(AOwner: TComponent); override;
    function  Validate(const Value: String; var Pos: Integer): Boolean; override;
    procedure ValidateError; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  published
    property TriaGrid;
    property UpDown : TTriaUpDown read FUpDown write FUpDown;
  end;

  TTriaUpDown = class(TCustomUpDown)
  // Position muss kleiner 32767 (SmallInt) bleiben, sonst �berlauf-Fehler
  protected
    FEdit : TTriaMaskEdit;
    //procedure ChangingEx(Sender:TObject; var AllowChange:Boolean;
    //                     NewValue:SmallInt; Direction: TUpDownDirection);
    procedure Click(Button: TUDBtnType); override;
  public
    //Aendernd : Boolean;
    constructor Create(AOwner: TComponent); override;
  published
    property DoubleBuffered;
    property Enabled;
    property Hint;
    property Min;
    property Max;
    property Increment;
    property Constraints;
    property Orientation;
    property ParentDoubleBuffered;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Thousands;
    property Visible;
    property Wrap;
    property OnChanging;
    property OnChangingEx;
    property OnContextPopup;
    property OnClick;
    property OnEnter;
    property OnExit;
    property Edit : TTriaMaskEdit read FEdit write FEdit;
  end;

  TDatumEdit = class(TTriaCustomMaskEdit)
  public
    function  Validate(const Value: String; var Pos: Integer): Boolean; override;
    procedure ValidateError; override;
  end;

  TZeitEdit = class(TTriaCustomMaskEdit)
  public
    constructor Create(AOwner: TComponent); override;
    procedure KeyPress(var Key: Char); override;
    function  IstLeer: Boolean;
    procedure InitEditMask; virtual; abstract;
  end;

  TUhrZeitEdit = class(TZeitEdit)
  public
    procedure InitEditMask; override;
    function  Validate(const Value: String; var Pos: Integer): Boolean; override;
    procedure ValidateError; override;
    function  Wert: Integer;
    function  ZeitGleich(const Value:String): Boolean;
  published
    property TriaGrid;
  end;

  TMinZeitEdit = class(TZeitEdit)
  public
    procedure InitEditMask; override;
    function  Validate(const Value: String; var Pos: Integer): Boolean; override;
    procedure ValidateError; override;
    function  Wert: Integer;
    function  ZeitGleich(const Value:String): Boolean;
  end;

  TStundenZeitEdit = class(TZeitEdit)
  public
    procedure InitEditMask; override;
    function  Validate(const Value: String; var Pos: Integer): Boolean; override;
    procedure ValidateError; override;
    function  Wert: Integer;
    function  ZeitGleich(const Value:String): Boolean;
  end;

  TStartZeitEdit = class(TZeitEdit)
  public
    procedure InitEditMask; override;
    function  Validate(const Value: String; var Pos: Integer): Boolean; override;
    procedure ValidateError; override;
    function  Wert: Integer;
    function  ZeitGleich(const Value:String): Boolean;
  published
    property TriaGrid;
  end;

procedure Register;

implementation


(******************************************************************************)
procedure Register;
(******************************************************************************)
begin
  RegisterComponents('Tria', [TTriaLookUpEdit,TTriaLookUpBtn,TTriaLookupGrid,
                              TTriaGrid,TTriaEdit,TTriaMaskEdit,TDatumEdit,
                              TUhrZeitEdit,TMinZeitEdit,TStundenZeitEdit,
                              TStartZeitEdit,TTriaUpDown]);
end;


{(******************************************************************************)
(* Methoden von TTriaForm                                                     *)
(******************************************************************************)

(******************************************************************************)
constructor TTriaForm.Create(AOwner: TComponent);
(******************************************************************************)
begin
  inherited Create(AOwner);
  Updating      := false;
  HelpFensterAlt := HelpFenster;
  HelpFenster := Self;
  VistaFix.SetzeFonts(Font); // gilt nur f�r Controls mit ParenFont=true
end;}


(******************************************************************************)
(* Methoden von TTriaLookUpEdit                                               *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
procedure TTriaLookUpEdit.KeyPress(var Key: Char);
//------------------------------------------------------------------------------
// VK_ESCAPE hier abfangen, bei KeyDown kommt Beep
begin
  if Assigned(Grid) and (Grid.Items.Count > 0) then
  with Grid do
    case Word(Key) of
      VK_ESCAPE:
        if Visible then
        begin
          DisableClick := true;
          Self.Text := Self.TextAlt;
          Self.SelStart := Length(Self.Text);
          DisableClick := false;
          Hide;
          Key := #0;
        end;
    end;

  inherited KeyPress(Key);
end;

//------------------------------------------------------------------------------
procedure TTriaLookUpEdit.KeyDown(var Key: Word; Shift: TShiftState);
//------------------------------------------------------------------------------
begin
  if Assigned(Grid) and (Grid.Liste.Count > 0) then
  with Grid do
    case Key of
      VK_UP:
      begin
        DisableClick := true;
        if not Visible then
          if Length(Trim(Edit.Text)) > 0 then
          begin
            LookUpMode := lmShowEdit; // keine Zeile fokussiert
            UpdateItems;
            if Items.Count > 0 then Show;
          end else
          begin
            LookUpMode := lmShowAll; // ganze Liste zeigen
            UpdateItems;
            if Items.Count > 0 then Show;
          end
        else // Visible
        if Items.Count > 0 then
        begin
          if not Assigned(Edit) or
             (LookUpMode <> lmShowEdit) and (StrGleich(Items[Row],Edit.Text)) then //markiert
            if Row > 0 then // up-scrollen
            begin
              if ssCtrl in Shift then Row := 0        // Zeile 1
                                 else Row := Row - 1; // auf
              Self.Text := Items[Row];
              Self.SelStart := Length(Self.Text);
            end else // Row=0
              if (LookUpMode = lmShowAll) and
                 (Items.IndexOf(Trim(TextAlt)) >= 0) then // TextAlt in Liste vorhanden
                // keine Aktion
              else // alte Text wiederherstellen
              begin
                Self.Text := TextAlt;
                Self.SelStart := Length(Self.Text);
                if LookUpMode = lmFocusEdit then LookUpMode := lmShowEdit;
              end
          else // keine Zeile markiert
            begin
              if LookUpMode = lmShowEdit then LookUpMode := lmFocusEdit;
              Row := RowCount - 1; // letzte Zeile markieren
              Self.Text := Items[Row];
              Self.SelStart := Length(Self.Text);
            end;
          Refresh;
        end;
        DisableClick := false;
        Key := 0;
      end; // VK_UP

      VK_DOWN:
      begin
        DisableClick := true;
        if not Visible then
          if Length(Trim(Edit.Text)) > 0 then
          begin
            LookUpMode := lmShowEdit; // keine Zeile fokussiert
            UpdateItems;
            if Items.Count > 0 then Show;
          end else
          begin
            LookUpMode := lmShowAll; // ganze Liste zeigen
            UpdateItems;
            if Items.Count > 0 then Show;
          end
        else // Visible
        if Items.Count > 0 then
        begin
          if not Assigned(Edit) or
             (LookUpMode <> lmShowEdit) and (StrGleich(Items[Row],Edit.Text)) then //markiert
            if Row < RowCount-1 then // down-scrollen
            begin
              if ssCtrl in Shift then Row := RowCount - 1 // Ende
                                 else Row := Row + 1;     // ab
              Self.Text := Items[Row];
              Self.SelStart := Length(Self.Text);
            end else // letzte Zeile
              if (LookUpMode = lmShowAll) and
                 (Items.IndexOf(Trim(TextAlt)) >= 0) then // TextAlt in Liste vorhanden
                // keine Aktion
              else // alte Text wiederherstellen
              begin
                Self.Text := TextAlt;
                Self.SelStart := Length(Self.Text);
                if LookUpMode = lmFocusEdit then LookUpMode := lmShowEdit;
              end
          else // keine Zeile markiert
          begin
            if LookUpMode = lmShowEdit then LookUpMode := lmFocusEdit;
            Row := 0; // erste Zeile markieren
            Self.Text := Items[Row];
            Self.SelStart := Length(Self.Text);
          end;
          Refresh;
        end;
        DisableClick := false;
        Key := 0;
      end; // VK_DOWN
    end; // case Key of

  if Key <> 0 then
    inherited KeyDown(Key,Shift);
end;

//------------------------------------------------------------------------------
procedure TTriaLookUpEdit.Change;
//------------------------------------------------------------------------------
begin
  if Assigned(Grid) then
  with Grid do
    if not DisableClick then
    begin
      LookUpMode := lmShowEdit;
      Self.TextAlt := Self.Text; //TextAlt kann mit ESC oder mit Pfeil-Tasten wiederhergestellt werden
      UpdateItems;
      if not Visible and (Grid.Items.Count > 0) then Show
      else
      if Visible and (Grid.Items.Count = 0) then Hide;
    end;

  inherited Change;
end;

(******************************************************************************)
(* Methoden von TTriaLookUpBtn                                                *)
(******************************************************************************)

// public Methoden

//******************************************************************************
procedure TTriaLookUpBtn.Click;
//******************************************************************************
begin
  if Assigned(Edit) and Assigned(Edit.Grid) and Assigned(Edit.Grid.Items) then
  with Edit.Grid do
    if Visible and (Items.Count = Liste.Count) then // vollst�ndige Liste angezeigt
    begin
      DisableClick := true;
      Hide; // Hide zuerst
      Edit.SelStart := Length(Edit.Text);
      Edit.SetFocus;
      DisableClick := false;
    end else // not visible or Liste nicht voll (nur lmShowEdit,lmFocusEdit)
    begin
      DisableClick := true;
      LookUpMode := lmShowAll; // ganze Liste zeigen
      UpdateItems;
      if Items.Count > 0 then Show;
      Edit.TextAlt := Edit.Text; // beim Schliessen, TextAlt aktualisieren
      Edit.SelStart := Length(Edit.Text);
      Edit.SetFocus;
      DisableClick := false;
    end;

  inherited Click;
end;

(******************************************************************************)
(* Methoden von TTriaLookUpGrid                                               *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
procedure TTriaLookupGrid.UpdateItems;
//------------------------------------------------------------------------------
// aktueller Text in Item[0], Row=0
// Gro�- Kleinschreibung nicht unterscheiden
var i : Integer;
begin
  DisableClickAlt := DisableClick;
  DisableClick := true;

  Items.Clear;
  for i:=0 to Liste.Count-1 do
    if (LookUpMode = lmShowAll) or // alle Items
       (Length(Trim(Edit.Text)) > 0) and
       (Length(Liste[i]) >= Length(Trim(Edit.Text))) and
       (TxtGleich(Trim(Edit.Text),Copy(Liste[i],1,Length(Trim(Edit.Text))))) then
      Items.Add(GetRowText(i)); // Text wird in Event definiert
  RowCount := Items.Count; // RowCount nicht in Schleife �ndern, weil zu langsam

  if Assigned(Edit) and (Items.IndexOf(Trim(Edit.Text)) > 0) then
    Row := Items.IndexOf(Trim(Edit.Text))
  else Row := 0;
  if RowCount > MaxRows then // TopRow anpassen: Row in der Mitte
    // TopRow Min=0, Max=RowCount-Min(RowCount,MaxRows)
    TopRow := Min(Max(0, Row - Min(RowCount,MaxRows) DIV 2), RowCount - Min(RowCount,MaxRows));
  ClientHeight := DefaultRowHeight * Min(MaxRows,RowCount);
  Refresh;
  DisableClick := DisableClickAlt;
end;

//------------------------------------------------------------------------------
function TTriaLookupGrid.GetRowText(Indx: Integer): String;
//------------------------------------------------------------------------------
begin
  Result := '';
  if Assigned(OnGetRowText) then
    OnGetRowText(Self, Indx, Result);
end;

//------------------------------------------------------------------------------
procedure TTriaLookupGrid.Click;
//------------------------------------------------------------------------------
begin
  if not DisableClick then
  begin
    if Assigned(Edit) then
    with Edit do
    begin
      if Assigned(Items) and (Row < Items.Count) then
        Text := Items[Row];
      if Visible and CanFocus then
      begin
        SetFocus;
        SelStart := Length(Text);
      end;
      Self.Hide;
    end;
    inherited Click;
  end;
end;

//------------------------------------------------------------------------------
procedure TTriaLookupGrid.DrawCell(ACol,ARow:Longint;ARect:TRect;AState:TGridDrawState);
//------------------------------------------------------------------------------
begin
  inherited DrawCell(ACol,ARow,ARect,AState); // OnDrawCell Event
  if not Assigned(Items) or (ARow >= Items.Count) then Exit;

  if (ARow = Row) and
     ((not Assigned(Edit) or
      (LookUpMode<>lmShowEdit) and StrGleich(Items[ARow],Edit.Text))) then
  begin
    Canvas.Brush.Color := clHighLight;     //$00FFDBBF; // hellblau
    Canvas.Font.Color  := clHighLightText; //clWindowText;
  end else
  begin
    Canvas.Brush.Color := clWindow;
    Canvas.Font.Color  := clWindowText;
  end;
  Canvas.FillRect(ARect);
  Canvas.TextRect(ARect, ARect.Left+1, ARect.Top, Items[ARow]);
end;

//------------------------------------------------------------------------------
procedure TTriaLookupGrid.TopLeftChanged;
//------------------------------------------------------------------------------
begin
  // beim Scrollen ItemIndex/Row anpassen, damit dieser sichtbar bleibt
  // damit �ndert sich FocusedItem beim Scrollen
  {if Row < TopRow then Row := TopRow
  else if Row >= TopRow + VisibleRowCount then Row := TopRow+VisibleRowCount-1;}

  inherited TopLeftChanged;
end;

// public Methoden

//******************************************************************************
constructor TTriaLookupGrid.Create(AOwner:TComponent);
//******************************************************************************
// LookUpMode:
// lmEdit: nur Items mit Edittext am Anfang, keine Row selektiert
// lmEditScroll: Items, TextAlt unver�ndert, Row selektiert, Text:= Rowtext
// lmClick: alle Items incl. Leertext, Edittext selektiert
begin
  inherited Create(AOwner);
  Items := TStringList.Create;
  FItemIndex := -1;
  Liste := nil;
  LookUpMode := lmShowAll;
  DisableClick := false;

  ColCount := 1;
  DefaultRowHeight := 17;
  Options := [];
  ScrollBars := ssVertical;
  FixedCols := 0;
  FixedRows := 0;
  //Edit.Show;
  //Btn.Show;
end;

//******************************************************************************
destructor TTriaLookupGrid.Destroy;
//******************************************************************************
begin
  Items.Free;
  inherited Destroy;
end;


(******************************************************************************)
(* Methoden von TTriaGrid                                                     *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
function TTriaGrid.GetItem(Indx:integer):Pointer;
//------------------------------------------------------------------------------
begin
  if (Collection=nil) or (Indx < 0) or
     (Sorted and (Indx >= Collection.SortCount)) or
     (not Sorted and (Indx >= Collection.Count)) then Result := nil
  else
    if Sorted then Result := Collection.SortItems[Indx]
              else Result := Collection[Indx];
end;

//------------------------------------------------------------------------------
function TTriaGrid.GetItemIndex:Integer;
//------------------------------------------------------------------------------
begin
  Result := Row - FixedRows;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.SetItemIndex(Indx:Integer);
//------------------------------------------------------------------------------
var Buf : Boolean;
    R,C : Integer;
begin
  Buf := EnableOnClick;
  EnableOnClick := false;
  try
    if Indx < FixedRows then R := FixedRows // mindestens erste Zeile
    else if Indx < GetItemCount then R := Indx + FixedRows //Indx korrekt(0 bis Count-1)
    else R := GetItemCount-1 + FixedRows; // letzte Zeile

    if FColEditAssigned then // Col beibehalten
    begin
      if (Col>=FixedCols) and Assigned(ColEdits[Col]) then C := Col
      else
      for C:=FixedCols to ColCount-1 do
        if Assigned(ColEdits[C]) then Break;
      if C >= ColCount then C := FixedCols;
    end else
      C := FixedCols;

    if (R<>Row) or (C<>Col) then FocusCell(C,R,true);
  finally
    EnableOnClick := Buf;
  end;
end;

//------------------------------------------------------------------------------
function TTriaGrid.GetFocusedItem:Pointer;
//------------------------------------------------------------------------------
begin
  Result := GetItem(GetItemIndex);
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.SetFocusedItem(Item:Pointer);
//------------------------------------------------------------------------------
var i : Integer;
begin
  //wenn gleiche items vorhanden, wird immer 1. item focussiert
  if (Collection<>nil) and (Item<>nil) then
  begin
    i := Collection.IndexOf(Item);
    if (i >= 0) and //pointer muss g�ltig sein um fehler beim Suchen zu vermeiden
       Sorted then i := Collection.SortIndexOf(Item);
  end else i := -1;
  SetItemIndex(i);
end;

//------------------------------------------------------------------------------
function TTriaGrid.GetItemCount:Integer;
//------------------------------------------------------------------------------
begin
  if Collection<>nil then
    if Sorted then Result := Collection.SortCount
              else Result := Collection.Count
  else Result := 0;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.SetColCount(Value: Integer);
//------------------------------------------------------------------------------
var i : integer;
begin
  inherited ColCount := Value;

  SetLength(FColAlign,ColCount);
  for i:=0 to ColCount-1 do FColAlign[i] := taCenter;
  SetLength(FColEdits,ColCount);
end;

//------------------------------------------------------------------------------
function TTriaGrid.GetColCount: Integer;
//------------------------------------------------------------------------------
begin
  Result := inherited ColCount;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.SetColAlign(Index: Integer; Value: TAlignment);
//------------------------------------------------------------------------------
begin
  if (Index >= FixedCols) and (Index < ColCount) then
    FColAlign[Index] := Value;
end;

//------------------------------------------------------------------------------
function TTriaGrid.GetColAlign(Index: Integer): TAlignment;
//------------------------------------------------------------------------------
begin
  if (Index >= FixedCols) and (Index < ColCount) then
    Result := FColAlign[Index]
  else Result := taCenter;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.SetColEdits(Index: Integer; Value: TTriaCustomMaskEdit);
//------------------------------------------------------------------------------
// edits werden zun�chst im Designer auf formular einzeln erstellt
var i : Integer;
begin
  if (Index >= FixedCols) and (Index < ColCount) then
  begin
    FColEdits[Index] := Value;
    if FColEdits[Index] <> nil then
    with FColEdits[Index] do
    begin
      //TabStop     := true;
      Align       := alCustom;
      BorderStyle := bsNone;
      Color       := clWindow;
      Font        := FEditFont;
    end;
    FColEditAssigned := false;
    for i:=FixedCols to ColCount-1 do
      if Assigned(FColEdits[i]) then FColEditAssigned:= true;
  end;
end;

//------------------------------------------------------------------------------
function TTriaGrid.GetColEdits(Index: Integer): TTriaCustomMaskEdit;
//------------------------------------------------------------------------------
begin
  if (Index >= FixedCols) and (Index < ColCount) then
    Result := FColEdits[Index]
  else Result := nil;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.SetColEditsPos;
//------------------------------------------------------------------------------
var i,LeftA,TopA,WidthA,HeightA : Integer;
begin
  if (Row >= TopRow) and (Row < TopRow + VisibleRowCount) then
    for i:=FixedCols to ColCount-1 do
      if Assigned(ColEdits[i]) then
        if GetColEditsPos(i,LeftA,TopA,WidthA,HeightA) then
        with ColEdits[i] do
        begin
          Left   := LeftA;
          Top    := TopA;
          Height := HeightA;
          Width  := WidthA;
        end;
end;

//------------------------------------------------------------------------------
function TTriaGrid.MinAssignedColumn: Integer;
//------------------------------------------------------------------------------
var i : Integer;
begin
  Result := FixedCols;
  for i:=FixedCols to ColCount-1 do
    if Assigned(ColEdits[i]) then
    begin
      Result := i;
      Exit;
    end;
end;

//------------------------------------------------------------------------------
function TTriaGrid.MaxAssignedColumn: Integer;
//------------------------------------------------------------------------------
var i : Integer;
begin
  Result := ColCount-1;
  for i:=ColCount-1 downto FixedCols do
    if Assigned(ColEdits[i]) then
    begin
      Result := i;
      Exit;
    end;
end;

{//------------------------------------------------------------------------------
procedure TTriaGrid.SetNumFont(Value: TFont);
//------------------------------------------------------------------------------
var i : Integer;
begin
  FNumFont.Assign(Value);
  // Edits Updaten
  if FColEditAssigned then
    for i:=FixedCols to ColCount-1 do
      if Assigned(ColEdits[i]) then
        FColEdits[i].Font := Value;
end; }

//------------------------------------------------------------------------------
procedure TTriaGrid.SetColEditFontName(NameNeu:String);
//------------------------------------------------------------------------------
var i : Integer;
begin
  FEditFont.Name := NameNeu;
  // Edits Updaten
  if FColEditAssigned then
    for i:=FixedCols to ColCount-1 do
      if Assigned(ColEdits[i]) then
        FColEdits[i].Font.Name := NameNeu;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.SetColEditFontSize(SizeNeu:Integer);
//------------------------------------------------------------------------------
var i : Integer;
begin
  FEditFont.Size := SizeNeu;
  // Edits Updaten
  if FColEditAssigned then
    for i:=FixedCols to ColCount-1 do
      if Assigned(ColEdits[i]) then
        FColEdits[i].Font.Size  := SizeNeu;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.SetColEditFontColor(ColorNeu:TColor);
//------------------------------------------------------------------------------
var i : Integer;
begin
  FEditFont.Color := ColorNeu;
  // Edits Updaten
  if FColEditAssigned then
    for i:=FixedCols to ColCount-1 do
      if Assigned(ColEdits[i]) then
        FColEdits[i].Font.Color := ColorNeu;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.TopLeftChanged;
//------------------------------------------------------------------------------
begin
  // beim Scrollen ItemIndex/Row anpassen, damit dieser sichtbar bleibt
  // damit �ndert sich FocusedItem beim Scrollen
  if Row < TopRow then Row := TopRow
  else
  if Row >= TopRow + VisibleRowCount then Row := TopRow+VisibleRowCount-1;

  // Alle Edits neu positionieren, damit sie bei Resize im Grid bleiben
  if FColEditAssigned then SetColEditsPos;
  Invalidate;
  inherited TopLeftChanged;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.Paint;
//------------------------------------------------------------------------------
var ARect : TRect;
begin
  if FStopPaint then
  begin
    FPaintWartend := true;
    Exit;
  end else FPaintWartend := false;

  inherited Paint;

  if Assigned(FOnPaint) then FOnPaint(Self); // blauer Rahmen in TztGrid

  // Scrollbar
  // Criterium f�r Visibility DummySB:
  // wenn standard VertScrollBar sichtbar, ClientWidth=Width-20,sonst ClientWidth=Width-4
  if (ScrollBars=ssVertical) and (DummySB <> nil) then
    if ClientWidth < Width - 10 then DummySB.Visible := false //standard Scrollbar
                                else DummySB.Visible := true;

  // Rahmen um fokussierte Zelle, innen und aussen
  // ganz am Schluss, damit Rahmen ausserhalb nicht �berschrieben werden kann.
  if FColEditAssigned and // nur TriaZeit
     Assigned(FocusedItem) and
     (Col >= FixedCols) and (Row >= FixedRows) and // nicht �berschrift
     EditierMode and Assigned(ColEdits[Col]) then  // nicht AktionsSpalte
  begin
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Color := clWindowText;
    ARect := CellRect(Col,Row);
    // Rahmen innen
    Canvas.Polyline([Point(ARect.Left,ARect.Bottom-1),
                     Point(ARect.Left,ARect.Top),
                     Point(ARect.Right-1,ARect.Top),
                     Point(ARect.Right-1,ARect.Bottom-1),
                     Point(ARect.Left-1,ARect.Bottom-1)]);
    // Frame
    Canvas.Polyline([Point(ARect.Left-1,ARect.Bottom),
                     Point(ARect.Left-1,ARect.Top-1),
                     Point(ARect.Right,ARect.Top-1),
                     Point(ARect.Right,ARect.Bottom),
                     Point(ARect.Left-2,ARect.Bottom)]);
    // Rahmen aussen
    Canvas.Polyline([Point(ARect.Left-2,ARect.Bottom+1),
                     Point(ARect.Left-2,ARect.Top-2),
                     Point(ARect.Right+1,ARect.Top-2),
                     Point(ARect.Right+1,ARect.Bottom+1),
                     Point(ARect.Left-3,ARect.Bottom+1)]);
    // rechts extra Linie innen, Rahmen aussen von Scrollbar verdeckt
    if Col = ColCount-1 then
      Canvas.Polyline([Point(ARect.Right-2,ARect.Top),
                       Point(ARect.Right-2,ARect.Bottom)]);
  end;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.SetStopPaint(StopNeu:Boolean);
//------------------------------------------------------------------------------
begin
  if StopNeu <> FStopPaint then
  begin
    FStopPaint := StopNeu;
    // beim Freigeben Paint ausf�hren wenn vorher blokkiert wurde
    if not FStopPaint and FPaintWartend then Repaint;
  end;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.CustomAlignPosition(Control: TControl;
                              var NewLeft,NewTop,NewWidth,NewHeight: Integer;
                              var AlignRect:TRect; AlignInfo:TAlignInfo);
//------------------------------------------------------------------------------
// Reihenfolge nach CustomAlignInsertBefore
begin
  if Control = DummySB then
  begin
    NewLeft   := ClientWidth - DummySB.Width;
    NewHeight := ClientHeight;
  end;
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.Resize;
//------------------------------------------------------------------------------
begin
  // Row muss im sichtbaren Bereich bleiben
  if Row >= TopRow + VisibleRowCount then
    TopRow := Row-VisibleRowCount+1;

  inherited Resize; // OnResize Event
end;

//------------------------------------------------------------------------------
function TTriaGrid.MouseActivate(Button: TMouseButton; Shift: TShiftState;
                                 X, Y, HitTest: Integer): TMouseActivate;
//------------------------------------------------------------------------------
// alle Maus-Aktivit�ten hier abfangen (pr�fen, �bernehmen, ColEditMode:=false)
// dadurch werden doppelte Fehlermeldungen verhindert
var ACol,ARow:Integer;
begin
  if FColEditAssigned then // nur TriaZeit
  begin
    MouseToCell(X,Y,ACol,ARow);
    if ((ARow>=FixedRows)and(GetItem(ARow-FixedRows) = nil)) or // leeres Item am Anfang
       FColEditMode and (ACol=Col) and (ARow=Row) or // ColEdit sichtbar statt Grid
       not SelectCell(Col,Row) then  // EingabeOk = false
      Result := maNoActivateAndEat     // Abbruch nach Fehlermeldung
    else
      Result := inherited MouseActivate(Button,Shift,X,Y,HitTest);
  end else
    Result := inherited MouseActivate(Button,Shift,X,Y,HitTest);
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.MouseDown(Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
//------------------------------------------------------------------------------
var ACol,ARow:Integer;
begin
  if FColEditAssigned then
  begin
    MouseToCell(X,Y,ACol,ARow);

    if not (ssDouble in Shift) and (Button = mbLeft) then // EinzelClick
      if ARow=0 then
        if Assigned(ColEdits[ACol]) then  // EinzelClick Header (Sortieren)
          inherited MouseDown(Button,Shift,X,Y)
        else
      else // ARow >= FixedRows
        if Assigned(ColEdits[ACol]) or // EinzelClick in Edit-Spalte
           (ACol = AktionsSpalte) then // EinzelClick Aktion (AbglGrid)
          inherited MouseDown(Button,Shift,X,Y)
        else
          FocusCell(Col,ARow,true) // EinzelClick Spalte 0,3,4 (TztGrid)
    else
      if (ARow>=FixedRows) and Assigned(ColEdits[ACol]) then// Doppel-Click in Edit-Spalte
        inherited MouseDown(Button,Shift,X,Y);

  end else
    inherited MouseDown(Button,Shift,X,Y);
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.Click;
//------------------------------------------------------------------------------
begin
  if EnableOnClick then inherited Click;
end;

//------------------------------------------------------------------------------
function TTriaGrid.GetColText(ACol, ARow: Integer): String;
//------------------------------------------------------------------------------
begin
  Result := '';
  if GetItem(ARow-FixedRows) <> nil then
    if Assigned(OnGetColText) then
      OnGetColText(Self, GetItem(ARow-FixedRows), ACol, Result);
end;

//------------------------------------------------------------------------------
procedure TTriaGrid.KeyPress(var Key: Char);
//------------------------------------------------------------------------------
// f�r ColEdits
// Vor �nderung Eingabe pr�fen, da ValidateEdit nicht ausgef�hrt wird
begin
  if FColEditAssigned and EnableOnClick then
  try
    EnableOnClick := false;
    case Word(Key) of
      VK_RETURN : begin
                    // nur f�r AbglDlg. in HauptDlg durch AendernBtn (default) abgefangen
                    FocusCell(Col,Min(RowCount-1,Row+1),true); // n�chste Zeile,gleiche Spalte
                    Key := #0;
                  end;
      VK_ESCAPE	: if FColEditMode and not ColEditModified then  // kl�ren: erst 6, dann 1, dann ESC
                  begin
                    ResetColEditMode; // TextOrg muss Ok sein
                    Key := #0;
                  end; // else Text wird in Edit.Keypress zur�ckgesetzt
    end;
  finally
    EnableOnClick := true;
  end;

  inherited KeyPress(Key); // Event erzeugen, nicht vorher, weil Return-Key 0 gesetzt wird
end;


//******************************************************************************
// public Methoden
//******************************************************************************

//******************************************************************************
constructor TTriaGrid.Create(AOwner: TComponent);
//******************************************************************************
var i : Integer;
begin
  inherited Create(AOwner);
  FocusAlt      := nil;
  EnableOnClick := true;
  FStopPaint    := false;
  FPaintWartend := false;
  // folgende Parameters m�ssen nachtr�glich gesetzt werden, weil es hier aus
  // unbekanntem grund nicht funktioniert
  //DefaultRowHeight := {14}Canvas.TextHeight('Tg')+1; wird auf 24 gesetzt
  //FixedCols := 0;
  //FixedRows := 1;
  //Options := [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRowSelect];
  (* Dummy Scrollbar sichtbar wenn standard SB verschwindet *)
  DummySB := TScrollBar.Create(Self);
  DummySB.Parent := Self;
  DummySB.Kind := sbVertical;
  DummySB.Enabled := false;
  DummySB.Visible := false;
  DummySB.ControlStyle := DummySB.ControlStyle - [csFramed];
  DummySB.Top := 0;
  //DummySB.Width := 16;  default Wert
  DummySB.Align := alCustom;

  TopAbstand  := 0; // Margin von Oberkante der Zelle
  //FRowAktuell := Row;
  //FColAktuell := Col;
  SetLength(FColAlign,ColCount);
  for i:=0 to ColCount-1 do FColAlign[i] := taCenter;
  SetLength(FColEdits,ColCount);
  for i:=0 to ColCount-1 do SetColEdits(i,nil);
  FColEditMode := false;
  FEditFont    := TFont.Create;
  //SetNumFont(Font);
  EditierMode   := false;
  AktionsSpalte := -1;
end;

//******************************************************************************
destructor TTriaGrid.Destroy;
//******************************************************************************
begin
  FEditFont.Free;
  FColAlign := nil;
  FColEdits := nil;
  DummySB.Free;
  inherited Destroy;
end;

//******************************************************************************
procedure TTriaGrid.Init(CollNeu:TTriaSortColl;SortMode:TSortMode;
                            Scroll:TScrollStyle;Focus:Pointer);
//******************************************************************************
begin
  FixedCols := 0;
  // 26.2.: FixedRows muss immer kleiner sein als Rowcount
  // wenn Itemcount=0 bleibt rowcount=2
  // erste zeile muss als leerzeile dargestellt werden
  FRowsMin   := FixedRows+1{RowCount}; (* in Objectinspector gesetzter Wert *)
  //FTopRowAlt := TopRow;
  Collection := CollNeu;
  ScrollBars := Scroll;
  if SortMode=smNichtSortiert then Sorted := false
                              else Sorted := true;
  CollectionUpdate;
  Invalidate;
  BringToFront;
  //Refresh; // keine Wirkung da StopPaint=true
  SetFocusedItem(Focus);
end;

//------------------------------------------------------------------------------
function TTriaGrid.GetColEditsPos(Indx:Integer; var LeftA,TopA,WidthA,HeightA: Integer): Boolean;
//------------------------------------------------------------------------------
var R : TRect;
begin
  if (Row >= TopRow) and (Row < TopRow + VisibleRowCount) and
     Assigned(ColEdits[Indx]) then
    with ColEdits[Indx] do
    begin
      R       := CellRect(Indx,Row);
      TopA    := R.Top + Self.Top + 2 + FTopAbstand;
      HeightA := R.Bottom - R.Top - 2*FTopAbstand;
      WidthA  := ColEditBreite(Indx);
      LeftA   := R.Left + Self.Left + 2 + (R.Width-WidthA) DIV 2;
      Result  := true;
    end
  else Result := false;
end;

//******************************************************************************
procedure TTriaGrid.KeyDown(var Key: Word; Shift: TShiftState);
//******************************************************************************
// in ColEditMode von Edit aufgerufen, anschliessend weiter in Edit.KeyDown
// VK_TAB und Pfeiltasten gedruckt in Grid hier abfangen um nach n�chstes
// g�ltiges ColEditfeld zu springen, nicht definierte �berspringen
// KeyPressed geht nicht, weil dort Shift fehlt
// Pfeil-Tasten �hnlich wie Excel
// nur VK_LEFT,VK_RIGHT in ColEditMode ignorieren
// wieso so oft Key = 37, $25=% ????
var EditModeAlt : Boolean;
    S : String;
    i : Integer;
//..............................................................................
function GetCharFromVirtualKey(Key: Word): string;
 var
    keyboardState: TKeyboardState;
    asciiResult: Integer;
 begin
    GetKeyboardState(keyboardState) ;

    SetLength(Result, 2) ;
    asciiResult := ToAscii(key, MapVirtualKey(key, 0), keyboardState, @Result[1], 0) ;
    case asciiResult of
      0: Result := '';
      1: SetLength(Result, 1) ;
      2:;
      else
        Result := '';
    end;
 end;
//..............................................................................
begin
  EditModeAlt := FColEditMode;
  if FColEditAssigned and EnableOnClick then
  try
    EnableOnClick := false;
    case Key of                    
      $30..$39, // 0..9
      $60..$69: // NumPad 0..9
        if not FColEditMode then
        begin
          SetColEditMode;
          if FColEditMode and (Col >= 0) and (Col < ColCount) and
             Assigned(FColEdits[Col]) then
          with ColEdits[Col] do
          begin
            S := Text;
            if IsMasked then
            begin
              i := SelStart+1;
              Delete(S,i,1);
              //Insert(Char(Key),S,i);
              Insert(GetCharFromVirtualKey(Key),S,i);
              AendereText(S);
              SelStart  := i;
              SelLength := 1;
            end else // not Masked, alle Zeichen l�schen, wie in Excel
            begin
              S := '';
              Insert(GetCharFromVirtualKey(Key),S,0);
              AendereText(S);
              SelStart := 1;
            end;
          end;
          Key := 0;
        end;
      VK_HOME: // Pos1
      begin
        FocusCell(Col, FixedRows,true); // unabh�ngig ssCtrl
        Key := 0;
      end;
      VK_PRIOR:
      begin
        FocusCell(Col, Max(FixedRows,Row - VisibleRowCount+1),true); // Bild auf
        Key := 0;
      end;
      VK_UP:
      begin
        if ssCtrl in Shift then FocusCell(Col, FixedRows,true) // Zeile 1
                           else FocusCell(Col, Max(FixedRows,Row-1),true); // auf
        Key := 0;
      end;
      VK_DOWN:
      begin
        if ssCtrl in Shift then FocusCell(Col, RowCount-1,true) // Ende
                           else NachUnten; // ab
        Key := 0;
      end;
      VK_NEXT:
      begin
        FocusCell(Col, Min(RowCount-1,Row + VisibleRowCount-1),true); // Bild ab
        Key := 0;
      end;
      VK_END: // Ende
      begin
        FocusCell(Col,RowCount-1,true); // unabh�ngig ssCtrl
        Key := 0;
      end;
      VK_TAB:
        if not (ssCtrl in Shift) and not (ssAlt in Shift) then
          if not (ssShift in Shift) then
          begin
             NachRechts;
             Key := 0;
          end else
          if (ssShift in Shift) then
          begin
            NachLinks;
            Key := 0;
          end;
      VK_RIGHT:
        if not FColEditMode then // in ColEditMode bleibt Cursor in Edit
        begin
          if ssCtrl in Shift then FocusCell(MaxAssignedColumn,Row,true)
                             else NachRechts;
          Key := 0;
        end;
      VK_LEFT	  :
        if not FColEditMode then // in ColEditMode bleibt Cursor in Edit
        begin
          if ssCtrl in Shift then FocusCell(MinAssignedColumn,Row,true)
                             else NachLinks;
          Key := 0;
        end;
      VK_DELETE:
        if not FColEditMode then
        begin
          SetColEditMode;
          if FColEditMode and (Col >= 0) and (Col < ColCount) and
             Assigned(FColEdits[Col]) then
          with ColEdits[Col] do
          begin
            if (ClassType = TTriaMaskEdit) and IsMasked then
              S := '0'
            else S := ''; // entspricht InitWert mit und ohne Maske
            AendereText(S);
          end;
          Key := 0;
        end;

      else;
    end;
  finally
    EnableOnClick := true;
  end;
  Invalidate;
  if not EditModeAlt then inherited KeyDown(Key,Shift);
  //sonst zur�ck nach KeyDown in TTriaCustomEdit
end;

//******************************************************************************
function TTriaGrid.DoMouseWheel(Shift:TShiftState;WheelDelta:Integer;MousePos:TPoint):Boolean;
//******************************************************************************
// public function, benutzt in SnrEditMouseWheel
begin
  Result := inherited DoMouseWheel(Shift,WheelDelta,MousePos);
end;

//******************************************************************************
procedure TTriaGrid.ClearItem(Item:Pointer);
//******************************************************************************
var C : Integer;
begin
  if (Collection<>nil) and (Item<>nil) then
  begin
    if FColEditMode then
    begin
      BringToFront; // Edits nicht sichtbar
      FColEditMode := false; // ohne Pr�fung in SelectCell-Event
      for C:=FixedCols to ColCount-1 do
        if Assigned(ColEdits[C]) then ColEdits[C].Text := ''; // immer Modified false
      if Visible and CanFocus then SetFocus;
    end;
    Collection.ClearItem(Item);
    CollectionUpdate;
    Invalidate;
  end;
end;

//******************************************************************************
function TTriaGrid.GetIndex(Item:Pointer): Integer;
//******************************************************************************
begin
  if (Collection<>nil) and (Item<>nil) then
  begin
    Result := Collection.IndexOf(Item);
    if (Result >= 0) and //pointer muss g�ltig sein um fehler beim Suchen zu vermeiden
       Sorted then Result := Collection.SortIndexOf(Item);
  end else Result := -1;
end;

//******************************************************************************
procedure TTriaGrid.AddItem(Item:Pointer);
//******************************************************************************
begin
  if Collection<>nil then
  begin
    Collection.AddItem(Item);
    CollectionUpdate;
    Invalidate;
    // Refresh; entfernt um doppel-refresh zu vermeiden
    //SetFocusedItem(Item); entfernt weile dies OnClickEvent ausl�st
  end;
end;

//******************************************************************************
procedure TTriaGrid.DrawCellText(Rect:TRect; Text:String; Align:TAlignment);
//******************************************************************************
//TAlignment = (taLeftJustify, taRightJustify, taCenter);
var H,W : integer;
begin
  if not FColEditAssigned then // Tria, wie bisher
  begin
    H := TopAbstand;
    W := Canvas.TextWidth(' ');
  end else
  if Canvas.Font.Name = ColEditFont.Name then
  begin
    H := TopAbstand;
    W := Canvas.TextWidth('0');
  end else
  begin
    H := 0;
    W := Canvas.TextWidth(' ');
  end;

  case Align of
    taLeftJustify  : Canvas.TextRect(Rect, Rect.Left+W, Rect.Top+H, Text);
    taRightJustify : Canvas.TextRect(Rect, Rect.Right-W-Canvas.TextWidth(Text),
                                     Rect.Top+H, Text);
    taCenter       : Canvas.TextRect(Rect,(Rect.Left+Rect.Right-Canvas.TextWidth(Text)) div 2,
                                     Rect.Top+H, Text);
  end;
end;

//******************************************************************************
procedure TTriaGrid.FocusZelle(ACol,ARow:Integer);
//******************************************************************************
// public function benutzt in TztMain
// SelectCell wird immer ausgef�hrt, auch wenn ACol,ARow = Col,Row
// Exception wegen ung�ltiger ACol,ARow verhindern
begin
  if (ACol >= 0) and (ARow >= 0) and (ACol < ColCount) and (ARow < RowCount) then
    FocusCell(ACol,ARow,true);
end;

//******************************************************************************
procedure TTriaGrid.NachRechts;
//******************************************************************************
var ColNeu,RowNeu: Integer;
begin
  ColNeu := Col;
  RowNeu := Row;

  repeat
    Inc(ColNeu);
  until Assigned(ColEdits[ColNeu]) or (ColNeu >= ColCount);

  if ColNeu >= ColCount then
    if RowNeu < RowCount-1 then
    begin
      ColNeu := MinAssignedColumn;
      Inc(RowNeu);
    end else
      ColNeu := MaxAssignedColumn;

  FocusCell(ColNeu,RowNeu,true); // Col,Row muss g�ltig sein, sonst Exception
end;

//******************************************************************************
procedure TTriaGrid.NachLinks;
//******************************************************************************
var ColNeu,RowNeu: Integer;
begin
  ColNeu := Col;
  RowNeu := Row;

  repeat
    Dec(ColNeu);
  until Assigned(ColEdits[ColNeu]) or (ColNeu <= 0);

  if ColNeu <= 0 then
    if RowNeu < RowCount-1 then
    begin
      ColNeu := MaxAssignedColumn;
      Inc(RowNeu);
    end else
      ColNeu := MinAssignedColumn;

  FocusCell(ColNeu,RowNeu,true); // Col,Row muss g�ltig sein, sonst Exception
end;

//******************************************************************************
procedure TTriaGrid.NachUnten;
//******************************************************************************
begin
  if not FColEditAssigned then
    FocusCell(Col,Min(RowCount-1,Row+1),true) // ab
  else
    if Row < RowCount-1 then
      FocusCell(Col,Row+1,true) // ab
    else
      if SelectCell(Col,Row) then // ggf. neues Item addiert
        FocusCell(Col,RowCount-1,true);  // neue oder alte letzte Zeile
end;

//******************************************************************************
procedure TTriaGrid.SetColEditMode;
//******************************************************************************
// Row,Col vorher gesetzt und hier nicht ge�ndert
// EditierMode wird in SetzeButtons gesetzt wegen SetzeButtons
var C : Integer;
begin
  if FColEditAssigned then
  begin
    BringToFront; // Edits nicht sichtbar
    SetColEditsPos;
    if (Col >= FixedCols) and (Row >= FixedRows) and
       (GetFocusedItem <> nil) and Assigned(ColEdits[Col]) then
    begin
      FColEditMode := true;

      with FColEdits[Col] do
      begin
        // if ClassType = TUhrZeitEdit then   //nicht mehr n�tig ?????????????????????
        //  TUhrZeitEdit(ColEdits[Col]).InitEditMask; // Maske an ZeitFormat anpassen
        Text      := GetColText(Col,Row); // auch FOrgText gesetzt
        SelStart  := 0;  // SetCursor nicht verf�gbar
        if IsMasked then SelLength := 1;
        BringToFront;
        Refresh;
        if Visible and CanFocus then SetFocus;
      end;
    end
    else
    begin
      FColEditMode := false;
      for C:=FixedCols to ColCount-1 do
        if Assigned(ColEdits[C]) then ColEdits[C].Text := ''; // immer Modified false
      if Visible and CanFocus then SetFocus;
    end;

    Invalidate;
    if Assigned(FOnColEdit) then FOnColEdit(Self); //nicht benutzt
  end;
end;

//******************************************************************************
function TTriaGrid.ResetColEditMode: Boolean;
//******************************************************************************
// Row,Col vorher gesetzt und hier nicht ge�ndert
// EditierMode wird in TztMain gesetzt
var C : Integer;
begin
  if FColEditAssigned then
  begin
    if FColEditMode then
      Result := SelectCell(-1,-1)
    else
      Result := true;

    if Result then
    begin
      FColEditMode := false;
      for C:=FixedCols to ColCount-1 do
        if Assigned(ColEdits[C]) then ColEdits[C].Text := '';
      BringToFront;  // Grid in Front
      if Visible and CanFocus then SetFocus;
    end else
    if Assigned(ColEdits[Col]) then
      with ColEdits[Col] do // wenn Eingabe nicht OK, bleibt ColEditMode
      begin
        BringToFront;
        if Visible and CanFocus then SetFocus;
      end;

    Refresh;
  end else
    Result := true;
end;

//******************************************************************************
function TTriaGrid.ColEditModified: Boolean;
//******************************************************************************
begin
  if FColEditAssigned and
     (Col >= 0) and (Col < ColCount) and Assigned(ColEdits[Col]) then
    Result := ColEdits[Col].Modified
  else Result := false;
end;

//******************************************************************************
function TTriaGrid.ColEditBreite(ACol:Integer): Integer;
//******************************************************************************
var S : String;
begin
  Result := 0; // Warnung vermeiden
  if Assigned(ColEdits[ACol]) then
    with ColEdits[ACol] do
      if ClassType = TTriaMaskEdit then
        if RfidModus then
        begin
          S := '';
          while Length(S) < RfidZeichen do S := S+'0';
          Result := Canvas.TextWidth(S);
        end
        else
          Result := Canvas.TextWidth('0000')
      else
      if ClassType = TUhrZeitEdit then
        case ZeitFormat of
          zfHundertstel : Result := Canvas.TextWidth('00:00:00.00');
          zfZehntel     : Result := Canvas.TextWidth('00:00:00.0');
          else            Result := Canvas.TextWidth('00:00:00');
        end;
end;

//******************************************************************************
procedure TTriaGrid.CollectionUpdate;
//******************************************************************************
begin
  if Collection=nil then RowCount := Max(FixedRows,FRowsMin)
  else
    if Sorted then RowCount := Max(Collection.SortCount+FixedRows,FRowsMin)
              else RowCount := Max(Collection.Count+FixedRows,FRowsMin);
end;

(******************************************************************************)
(* Methoden von TTriaEdit                                                     *)
(******************************************************************************)

(******************************************************************************)
constructor TTriaEdit.Create(AOwner: TComponent);
(******************************************************************************)
begin
  inherited Create(AOwner);
  AutoSelect := false;
  AutoSize   := false;
  TextAlt    := '';
  //Height := 18;
  {EditMask := '>C<>ccccccccc;0; '; }
end;


(******************************************************************************)
(* Methoden von TTriaCustomMaskEdit                                           *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
function TTriaCustomMaskEdit.GetText: String;
//------------------------------------------------------------------------------
begin
  Result := inherited Text;
end;

//------------------------------------------------------------------------------
procedure TTriaCustomMaskEdit.SetText(const Value: String);
//------------------------------------------------------------------------------
// beim Drucken der ESC-Taste kein Reset von Text, da FOrgText und Modified false
// gesetzt werden
// bei AendereText() bleibt FOrgText unver�ndert und Modified wird gesetzt
// Modified wird in inherited SetText nicht false wenn ge�nderte Text gleich neuer
// Text ist, deshalb hier false setzen
begin
  inherited Text := Value;
  Modified := false;
  FOrgText := Text;
end;

//------------------------------------------------------------------------------
procedure TTriaCustomMaskEdit.KorrigiereCursor;
//------------------------------------------------------------------------------
// keine Funktion
begin
  {// am TextEnde Cursor eine position zur�ck, damit SelLength immer >= 1
  if SelStart >= Length(EditText) then
  begin
    SelStart  := Length(EditText) - 1;
    SelLength := 1;
  end;}
end;

// public Methoden

//==============================================================================
constructor TTriaCustomMaskEdit.Create(AOwner: TComponent);
//==============================================================================
begin
  inherited Create(AOwner);
  AutoSelect := false;
  AutoSize   := false;
  TextAlt    := '';
  FOrgText   := '';
  FTriaGrid  := nil;
  ZahlFormat := zfKein; // nur benutzt wenn EditMask = '', not IsMasked
end;

//==============================================================================
function TTriaCustomMaskEdit.ValidateEdit: Boolean;
//==============================================================================
// wie TCustomMaskEdit.ValidateEdit, aber function statt procedure
// Validate wird nicht immer automatisch ausgef�hrt, z.B. bei ENTER- oder Pfeil-Taste
// deshalb getrennt aufgerufen zur Pr�fung (z.B. in EingabeOK)
var
  Str: String;
  Pos: Integer;
begin
  Result := true;
  Str := EditText;
  if IsMasked and Modified then
  begin
    if not Validate(Str, Pos) then
    begin
      if not (csDesigning in ComponentState) then
      begin
        //Include(MaskState, msReEnter);  geht hier nicht, deshalb:
          MaskState := MaskState + [msReEnter];
        SetFocus;
      end;
      SetCursor(Pos);
      ValidateError;
      Result := false;
    end;
  end;
end;

//==============================================================================
procedure TTriaCustomMaskEdit.AendereText(const Value: String);
//==============================================================================
// FOrgText wird nicht ge�ndert und bleibt f�r Reset durch ESC-Taste erhalten.
// Modified wird in SetText zur�ckgesetzt, deshalb hier neu setzen, damit
// Pr�fung in ValidateEdit und mit ESC-Taste KeyPress ausgef�hrt werden
begin
  if Text <> Value then
  begin
    inherited Text := Value;
    if Text <> FOrgText then Modified := true;
  end;
end;

//==============================================================================
procedure TTriaCustomMaskEdit.KeyPress(var Key: Char);
//==============================================================================
begin
  if Assigned(FTriaGrid) then
  begin
    if not FTriaGrid.EnableOnClick then Exit;
    if FTriaGrid.ColEditMode then FTriaGrid.KeyPress(Key);
  end;

  if not IsMasked and (Word(Key) >= 32) then
    case ZahlFormat of
      zfDez  : if not CharInSet(Key,['0'..'9']) then
               begin
                 Key := #0; // keine weitere Aktion
                 Exit;
               end;
      zfHex  : if not CharInSet(Key,['0'..'9','a'..'f','A'..'F']) then
               begin
                 Key := #0; // keine weitere Aktion
                 Exit;
               end;
      else ; // zfKein, keine Aktion
    end;

  if Word(Key) = VK_ESCAPE then // kommt hier nur an wenn modified
    if Modified then // Text per Programm oder Taste ge�ndert
    begin
      SetText(FOrgText); // Modified wird false (wenn FOrgText<>Text)
      Key := #0;         // keine weitere Aktion in inherited KeyPress
    end;

  inherited KeyPress(Key);
end;

//==============================================================================
procedure TTriaCustomMaskEdit.KeyDown(var Key: Word; Shift: TShiftState);
//==============================================================================
begin
  if Assigned(FTriaGrid) then
  begin
    if not FTriaGrid.EnableOnClick then Exit;
    if FTriaGrid.ColEditMode then FTriaGrid.KeyDown(Key,Shift);
  end;

  // Backspace soll selektiertes Zeichen l�schen (wie Excel)
  if (SelLength > 0) and (Key = VK_BACK) then
  begin
    Key := VK_DELETE;
    inherited KeyDown(Key,Shift);
    if SelStart > 0 then
    begin
      Key := VK_LEFT;
      inherited KeyDown(Key,Shift);
    end;
    Key := 0; // keine weitere Aktion
  end;

  if Key <> 0 then
    inherited KeyDown(Key,Shift);
end;

//==============================================================================
procedure TTriaCustomMaskEdit.KeyUp(var Key: Word; Shift: TShiftState);
//==============================================================================
begin
  if Assigned(FTriaGrid) then
  begin
    if not FTriaGrid.EnableOnClick then Exit;
    if FTriaGrid.ColEditMode then FTriaGrid.KeyUp(Key,Shift);
  end;

  inherited KeyUp(Key,Shift);
  KorrigiereCursor;
end;

//==============================================================================
procedure TTriaCustomMaskEdit.MouseUp(Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
//==============================================================================
begin
  inherited MouseUp(Button,Shift,X,Y);
  KorrigiereCursor;
end;

(******************************************************************************)
(* Methoden von TTriaMaskEdit                                                 *)
(******************************************************************************)

//protected Methoden

//------------------------------------------------------------------------------
procedure TTriaMaskEdit.KorrigiereCursor;
//------------------------------------------------------------------------------
// Cursor soll nur auf text oder erste Pos. dahinter gesetzt werden,
// damit keine Blanks im Text entstehen k�nnen
// nur f�r Ziffern, nicht f�r RfidCode
begin
  inherited KorrigiereCursor; // SelStart < Length(EditText)

  if IsMasked then
    if Pos(',',EditText) <= 0 then // keine Dezimalen
    begin
      if Text = '0' then
      begin
        SelStart  := 0;
        SelLength := 1;
      end else
      begin
        if SelStart > Length(Text) then SelStart := Length(Text);
        if SelLength = 0 then SelLength := 1 // mindestens 1
        else // max bis Ende Text
        if (SelStart < Length(Text)) and (SelLength > Length(Text) - SelStart) then
          SelLength := Length(Text) - SelStart;
      end
    end else
    if SelStart = Pos(',',EditText) - 1 then // Cursor auf ','
      SelStart := SelStart-1;
end;

//------------------------------------------------------------------------------
procedure TTriaMaskEdit.Change;
//------------------------------------------------------------------------------
// TriaMaskEdit nur f�r Zahlen mit oder ohne Dezimalen, nicht f�r Zeit und Datum
// Change wird bei SetText immer aufgerufen und damit TextAlt gesetzt
// Text,TextAlt ist Wert vor Anwendung der Maske
// Text nach Change immer ein korrekter String, nur
// Bereichpsr�fung in Anwendungen (EingabeOK) checken
// nicht hier nach jede Ziffer-Eingabe
// initwert  ??
var i,V,TextIndx,EditIndx:Integer;
    S : String;
    MaskOffset: Integer;
    CType: TMaskCharType;
    DezPos : Integer;
begin
  // �nderung durch UpDown.Click erlauben
  if Aendernd {and ((FUpDown=nil) or not FUpDown.Aendernd)} then Exit;

  if IsMasked and Enabled and not ReadOnly then
  begin
    // Alle Blanks l�schen, damit ist Format immer g�ltig
    DezPos  := Pos(',',EditText);
    S := Text;
    if not MaskGetMaskSave(EditMask) then // Literal nicht in Text enthalten ('0')
      if DezPos <= 0 then // keine Dezimalen
      begin
        // Blanks am Ende, mitten drin und am Anfang l�schen, neuer Event
        for i:=Length(S) downto 1 do
          if S[i] = MaskGetMaskBlank(EditMask) then Delete(S,i,1);
        if S = '' then
          for i:=0 to Length(EditMask) do
          begin
            CType := MaskGetCharType(EditMask, i);
            if CType = mcMask then
            begin
              S := '0'; // wenn mindestens 1 Plichtziffer, dann '' nicht zulassen
              Break;
            end else
            if CType=mcFieldSeparator then Break;
          end;
      end else // Dezimalen, benutzt in TztOptDlg
      if EditMask[1] = mDirReverse then // leading Blanks entfernt, =true
      begin
        // in TztOptDlg: EditMask := '!90,0;0; '
        // zuerst Leading Zeros einf�gen wenn mcMask, nicht wenn mcMaskOpt
        TextIndx := 1;
        EditIndx := 1;
        while EditIndx <= Length(EditText) do
        begin
          MaskOffset := OffsetToMaskOffset(EditMask, EditIndx-1);
          CType := MaskGetCharType(EditMask, MaskOffset);
          if (CType in [mcMaskOpt,mcMask]) and
             (EditText[EditIndx] = MaskGetMaskBlank(EditMask)) then
            if CType = mcMask then
            begin
              S := '0'+S;
              Inc(TextIndx);
            end else // keine Aktion
          else
          if CType = mcLiteral then //Inc(TextIndx)
          else Break; // Separator oder 1. Zeichen
          Inc(EditIndx);
        end;
        // Blank oder '_' durch 0 ersetzen, wenn mcMask und wenn mcMaskOpt??
        while EditIndx <= Length(EditText)  do
        begin
          MaskOffset := OffsetToMaskOffset(EditMask, EditIndx-1);
          CType := MaskGetCharType(EditMask, MaskOffset);
          if CType in [mcMaskOpt,mcMask] then // Blanks sowohl in EditText als Text
          begin
            if EditText[EditIndx] = MaskGetMaskBlank(EditMask) then
              if TextIndx <= Length(S) then S[TextIndx] := '0';
            Inc(TextIndx);
          end;
          Inc(EditIndx);
        end;
      end;

    i := SelStart;
    Aendernd := true;
    AendereText(S); //neuer Event (wenn S ge�ndert), dann Modified = true
    // Cursor korrigieren f�r Backspace-Taste
    if Text='0' then SelStart := 0
    else SelStart := Min(i,Length(EditText));
    Aendernd := false;
  end;

  // UpDown.Position setzen, auch wenn Edit disabled
  // nur wenn Edit enabled: bei ung�ltigem Bereich Min oder Max setzen,
  // leerstring erlauben
  if Assigned(FUpDown) then
  begin
    Aendernd := true;
    if Enabled and TryStrToInt(Text,i) then
      if i < FUpDown.Min then
        Text := IntToStr(FUpDown.Min)
      else
      if i > FUpDown.Max then
        Text := IntToStr(FUpDown.Max);
    FUpDown.Position := StrToIntDef(Text,0);
    Aendernd := false;
  end;

  inherited Change; // Text in Event Handler nicht �ndern, weil bei FUpDown-Click (FUpDown.Aendernd)
                    // FUpDown.Position nicht angepasst werden kann.

  if TryDecStrToInt(Text,V) and
     ((FUpDown=nil) or {FUpDown.Aendernd or} // UpDown-Position wird erst sp�ter gesetzt
      (FUpDown.Position = StrToIntDef(Text,0))) then
    TextAlt := Text; // TextAlt immer g�ltig
end;

// public Methoden

//==============================================================================
constructor TTriaMaskEdit.Create(AOwner: TComponent);
//==============================================================================
// nur f�r Zahlenwerte
// z.B. EditMask !9990;0
begin
  inherited Create(AOwner);
  TextAlt    := '';
  FUpDown    := nil;
  Aendernd   := false;
end;

//==============================================================================
function TTriaMaskEdit.Validate(const Value: String; var Pos: Integer): Boolean;
//==============================================================================
// wird nach Exit ausgef�hrt
// Validate wird nicht automatisch ausgef�hrt bei ENTER-Taste,
// nur wenn Text modified
// Value = EditText
begin
  Result := inherited Validate(Value,Pos);
  if Result and
     Enabled and Visible and not ReadOnly then //sonst Exception bei ValidateError wegen SetFocus
    // keine Formatpr�fung, weil Fehler in Change korrigiert
    // nur pr�fen ob Wert innerhalb FUpDown-Range liegt
    if (FUpDown <> nil) and
       ((StrToIntDef(Text,0) < FUpDown.Min) or (StrToIntDef(Text,0) > FUpDown.Max)) then
    begin
      Pos := 0;
      Result := false;
    end;
end;

//==============================================================================
procedure TTriaMaskEdit.ValidateError;
//==============================================================================
var S1,S2 : String;
    I0,I1,I2 : Integer;
begin
  if FUpDown<>nil then
  begin
    I0 := Pos(',',EditMask); // ',' vorhanden
    S1 := IntToStr(FUpDown.Min);
    S2 := IntToStr(FUpDown.Max);

    if I0 > 0 then
      I0 := Pos(';',EditMask) - Pos(',',EditMask) - 1; // Zahl der Dez.stellen
    if I0 > 0 then
    begin
      if Length(S1) = I0 then S1 := '0' + S1;
      I1 := Length(S1) - I0 + 1; // Index von ','
      if I1 > 0 then Insert(',',S1,I1);
      if Length(S2) = I0 then S2 := '0' + S2;
      I2 := Length(S2) - I0 + 1;
      if I2 > 0 then Insert(',',S2,I2);
    end;
    //MessageBeep(0);  kein Beep
    TriaMessage('Der eingegebene Wert ist ung�ltig. Erlaubt sind Werte von ' +
                S1+' bis '+S2+'.'+#13+#13+
                'Mit der Taste ESC k�nnen Sie die �nderungen r�ckg�ngig machen.'
                ,mtInformation,[mbOk])
  end
  else inherited ValidateError;
end;

//==============================================================================
procedure TTriaMaskEdit.KeyDown(var Key: Word; Shift: TShiftState);
//==============================================================================
begin
  if Assigned(FUpDown) then
    case Key of
      VK_UP: // FUpDown.Click simulieren
        if FUpDown.Position <= FUpDown.Max - FUpDown.Increment then
        begin
          //FUpDown.Aendernd := true;
          FUpDown.Position := FUpDown.Position + FUpDown.Increment;
          Text := IntToStr(FUpDown.Position);
          //FUpDown.Aendernd := false;
          Key := 0; // keine weitere Aktion
        end;
      VK_DOWN: // FUpDown.Click simulieren
        if FUpDown.Position >= FUpDown.Min + FUpDown.Increment then
        begin
          //FUpDown.Aendernd := true;
          FUpDown.Position := FUpDown.Position - FUpDown.Increment;
          Text := IntToStr(FUpDown.Position);
          //FUpDown.Aendernd := false;
          Key := 0; // keine weitere Aktion
        end;
    end;

  if Key <> 0 then
    inherited KeyDown(Key,Shift);
end;

(******************************************************************************)
(* Methoden von TTriaUpDown                                                   *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
procedure TTriaUpDown.Click(Button: TUDBtnType);
//------------------------------------------------------------------------------
// Position noch nicht gesetzt (Delphi XE)
// Button: btNext,btPrev
// Korrekturen, weil der andere Button nach Klick manchmal verschwindet 
begin
  inherited Click(Button); // vorab, weil der andere Button nach Klick manchmal verschwindet

  if (FEdit <> nil) and not FEdit.Aendernd then
  begin
    if Assigned(FEdit) and not FEdit.ValidateEdit then
      Exit; // bei Exit aus FEdit wird FEdit.Validate nicht automatisch ausgef�hrt

    //Aendernd := true; 
    // Text in FEdit.Onchange Handler unver�ndert �bernehmen,
    // da sonst Position und Text nicht �bereinstimmen
    case Button of
      btNext : FEdit.Text := IntToStr(Self.Position + Self.Increment);
      btPrev : FEdit.Text := IntToStr(Self.Position - Self.Increment);
    end;
    //Aendernd := false; 
    Edit.SetFocus; // immer richtiger Wert gesetzt, kein ValidateError benutzt
    Self.RecreateWnd; // weil der andere Button nach Klick manchmal verschwindet
  end;
end;

// public Methoden

//==============================================================================
constructor TTriaUpDown.Create(AOwner: TComponent);
//==============================================================================
// FEdit statt Associate benutzen, hierbei bleibt Layout (G��e, Position)
// unver�ndert, aber FEdit.Text wird bei Click gleich Position gesetzt
begin
  inherited Create(AOwner);
  Height   := 24;
  Width    := 16;
  FEdit    := nil;
  //Aendernd := false;
end;

(******************************************************************************)
(* Methoden von TDatumEdit                                                    *)
(******************************************************************************)

// public Methoden

//==============================================================================
function TDatumEdit.Validate(const Value: String; var Pos: Integer): Boolean;
//==============================================================================
// Format = tt.mm.jjjj
// Jahr von 2000 bis 2099, wie cnJahrMin, cnJahrMax
// EditMask = !90/00/0000;1;_  (in Designer)
begin
  Result := inherited Validate(Value,Pos); // Maske pr�fen

  if Result and
     Enabled and Visible and not ReadOnly then // Datum auf G�ltigkeit pr�fen
  begin
    if (Value[1] <> '_') and (Value[1] > '3') then // max 3
    begin
      Pos := 0;
      Result := false;
    end else
    if ((Value[1] = '_') or (Value[1] = '0')) and (Value[2] = '0') or // min 01
       (Value[1] = '3') and (Value[2] > '1') then // max 31
    begin
      Pos := 1;
      Result := false;
    end else
    if Value[4] > '1' then  // max 1
    begin
      Pos := 3;
      Result := false;
    end else
    if (Value[4] = '1') and (Value[5] > '2') then // max 12
    begin
      Pos := 4;
      Result := false;
    end else
    if Value[7] <> '2' then // fix 2
    begin
      Pos := 6;
      Result := false;
    end else
    if Value[8] <> '0' then  // fix 0
    begin
      Pos := 7;
      Result := false;
    end;
  end;

end;

//==============================================================================
procedure TDatumEdit.ValidateError;
//==============================================================================
// EditMask = in Designer: '!90.00.0000;1;_' statt '!90/00/0000;1;_'
//             Das Zeichen / dient dazu, in Datumsangaben Jahr, Monat und Tag
//             voneinander zu trennen.
//             Wenn die L�ndereinstellungen in der Systemsteuerung Ihres Rechners
//             ein anderes Trennzeichen vorsehen, wird dieses an Stelle von / verwendet.
//             In NL z.B. '-' statt '.'
begin
  //MessageBeep(0);
  TriaMessage('Das eingegebene Datum ist ung�ltig.'+#13+#13+
              'G�ltige Werte sind:  01.01.2000  bis  31.12.2099.'+#13+ #13 +
              'Mit der Taste ESC k�nnen Sie die �nderungen r�ckg�ngig machen.'
              ,mtInformation,[mbOk]);
end;

(******************************************************************************)
(* Methoden von TZeitEdit                                                      *)
(******************************************************************************)

// public Methoden

//==============================================================================
constructor TZeitEdit.Create(AOwner: TComponent);
//==============================================================================
begin
  inherited Create(AOwner);
  if not (csDesigning in ComponentState) then InitEditMask;
  // EditMask leer in Designer, sonst wird Mask nach Create damit �berschrieben
  // Init nicht beim Design, sonst leere Maske mit Init �berschrieben
end;

//==============================================================================
procedure TZeitEdit.KeyPress(var Key: Char);
//==============================================================================
// Zeit kann mit Leertaste (und Entf-Taste) gel�scht werden
var i : Integer;
    S : String;
begin
  if Key = ' ' then
  begin
    S := SelText;
    for i:=1 to Length(S) do
      if (S[i]<>':')and(S[i]<>DecTrennZeichen) then S[i] := '_';
    SelText := S;   // SelText = '', SelStart auf n�chstes Zeichen, Length=0
    SelLength := 1; // n�chstes Zeichen markiert (wenn nicht am Ende)
    Key := Char(#0); // kein beep
  end;
  inherited KeyPress(Key);
end;

//==============================================================================
function TZeitEdit.IstLeer: Boolean;
//==============================================================================
// f�r TZeitEdit und Nachfolger: Zeit=-1 (keine Zeit) nicht als Fehler werten
var i : Integer;
    L,S : String;
begin
  Result := false;
  // EditText pr�fen
  if Length(EditMask) < 5 then Exit; // mask ung�ltig
  L := MaskGetMaskBlank(EditMask);
  i := 1;
  S := '';
  while not IsDigit(EditMask[i]) do Inc(i);
  while EditMask[i] <> ';' do
  begin
    if IsDigit(EditMask[i]) then S := S + L
    else
    if EditMask[i] <> '\' then
      S := S + EditMask[i]; // literal
    Inc(i);
  end;
  Result := EditText = S;
end;

(******************************************************************************)
(* Methoden von TUhrZeitEdit                                                  *)
(******************************************************************************)

// public Methoden

//==============================================================================
procedure TUhrZeitEdit.InitEditMask;
//==============================================================================
begin
  case ZeitFormat of
    zfHundertstel : EditMask := '!90:00:00'+ DecTrennZeichen+'00;1;_';
    zfZehntel     : EditMask := '!90:00:00'+ DecTrennZeichen+'0;1;_';
    else            EditMask := '!90:00:00;1;_';
  end;
end;

//==============================================================================
function TUhrZeitEdit.Validate(const Value: String; var Pos: Integer): Boolean;
//==============================================================================
// Validate wird nicht ausgef�hrt bei Exit, nicht beim Drucken der Enter-Taste
begin
  // Format = hh:mm:ss pr�fen
  // EditMask := !90:00:00;1;_;
  if IstLeer then Result := true // Zeit=-1 nicht als Fehler werten
  else
  begin
    Result := inherited Validate(Value,Pos); // Maske pr�fen
    if Result and
       Enabled and Visible and not ReadOnly then // g�ltige Uhrzeit pr�fen
    begin
      if (Value[1] <> '_') and (Value[1] > '2') then // max 2
      begin
        Pos := 0;
        Result := false;
      end else
      if (Value[1] = '2') and (Value[2] > '3') then // max 23
      begin
        Pos := 1;
        Result := false;
      end else
      if Value[4] > '5' then // max 5
      begin
        Pos := 3;
        Result := false;
      end else
      if Value[7] > '5' then // max 5
      begin
        Pos := 6;
        Result := false;
      end;
    end;
  end;
end;

//==============================================================================
procedure TUhrZeitEdit.ValidateError;
//==============================================================================
var S1,S2,S3 : String;
begin
  case ZeitFormat of
    zfHundertstel:
    begin
      S1 := '00:00:00'+DecTrennZeichen+'00';
      S2 := '23:59:59'+DecTrennZeichen+'99';
      S3 := '__:__:__'+DecTrennZeichen+'__';
    end;
    zfZehntel:
    begin
      S1 := '00:00:00'+DecTrennZeichen+'0';
      S2 := '23:59:59'+DecTrennZeichen+'9';
      S3 := '__:__:__'+DecTrennZeichen+'_';
    end;
    else
    begin
      S1 := '00:00:00';
      S2 := '23:59:59';
      S3 := '__:__:__';
    end;
  end;

  //MessageBeep(0);
  TriaMessage('Die eingegebene Uhrzeit ist ung�ltig.'+#13+#13+
              'G�ltige Werte sind:'+#13+
              '    >  '+S1+'  bis  '+S2+#13+
              '    >  '+S3+'  (keine Uhrzeit).'+#13+#13+
              'Mit der Taste ESC k�nnen Sie die �nderungen r�ckg�ngig machen.'
              ,mtInformation,[mbOk]);
end;

//==============================================================================
function TUhrZeitEdit.Wert: Integer;
//==============================================================================
// Result ist Zeit in 1/100 Sekunden
var hh,mm,ss,dd,d : Integer;
    S : String;
begin
  Result := -1;
  if IstLeer then Exit;
  S := EditText;
  if (Length(EditMask)>0) and (S[1]=EditMask[Length(EditMask)]) then S[1] := '0';
  if TryDecStrToInt(copy(S,1,2),hh) and
     TryDecStrToInt(copy(S,4,2),mm) and
     TryDecStrToInt(copy(S,7,2),ss) then
    case ZeitFormat of
      zfHundertstel:
        if TryDecStrToInt(copy(S,10,2),dd) then
          Result := (dd + 100*ss + 6000*mm + 360000*hh);
      zfZehntel:
        if TryDecStrToInt(copy(S,10,1),d) then
          Result := (d + 10*ss + 600*mm + 36000*hh) * 10;
      else
        Result := (ss + 60*mm + 3600*hh) * 100;
    end;
end;

//==============================================================================
function TUhrZeitEdit.ZeitGleich(const Value:String): Boolean;
//==============================================================================
// EditMask := !90:00:00;1;_;
// Value mit f�hrende NULL (mit UhrZeitStr generiert)
var S : String;
begin
  if IstLeer then Result := Value = ''
  else
  begin
    S := EditText;
    if (Length(EditMask)>0) and (S[1]=EditMask[Length(EditMask)]) then S[1] := '0';
    Result := SameText(S,Value);
  end;
end;

(******************************************************************************)
(* Methoden von TMinZeitEdit                                                  *)
(******************************************************************************)

// public Methoden

//==============================================================================
procedure TMinZeitEdit.InitEditMask;
//==============================================================================
begin
  EditMask := '!90:00;1;_';
end;

//==============================================================================
function TMinZeitEdit.Validate(const Value: String; var Pos: Integer): Boolean;
//==============================================================================
// Format = mm:ss, Mask = '!90:00;1;_'
begin
  if IstLeer then Result := true
  else
  begin
    Result := inherited Validate(Value,Pos);
    if Result and
       Enabled and Visible and not ReadOnly then
    begin
      if (Value[1] <> '_') and (Value[1] > '5') then // '_' > '5'
      begin
        Pos := 0;
        Result := false;
      end else
      if Value[4] > '5' then
      begin
        Pos := 3;
        Result := false;
      end;
    end;
  end;
end;

//==============================================================================
procedure TMinZeitEdit.ValidateError;
//==============================================================================
// nur Zeiten >= 0
begin
  //MessageBeep(0);
  TriaMessage('Die eingegebene Zeit ist ung�ltig.'+#13+#13+
              'G�ltige Werte sind:  00:00  bis  59:59.'#13+#13+
              'Mit der Taste ESC k�nnen Sie die �nderungen r�ckg�ngig machen.'
              ,mtInformation,[mbOk]);
end;

//==============================================================================
function TMinZeitEdit.Wert: Integer;
//==============================================================================
// Result ist Zeit in 1/100 Sekunden
// Format mm:ss
var mm,ss : Integer;
    S : String;
begin
  Result := -1;
  if IstLeer then Exit;
  S := EditText;
  if (Length(EditMask)>0) and (S[1]=EditMask[Length(EditMask)]) then S[1] := '0';
  if TryDecStrToInt(copy(S,1,2),mm) and TryDecStrToInt(copy(S,4,2),ss) then
    Result := 100 * (ss + 60*mm);
end;

//==============================================================================
function TMinZeitEdit.ZeitGleich(const Value:String): Boolean;
//==============================================================================
// EditMask := !90:00;1;_;
var S : String;
begin
  if IstLeer then Result := Value = ''
  else
  begin
    S := EditText;
    if (Length(EditMask)>0) and (S[1]=EditMask[Length(EditMask)]) then S[1] := '0';
    Result := SameText(S,Value);
  end;
end;

(******************************************************************************)
(* Methoden von TStundenZeitEdit                                              *)
(******************************************************************************)

// public Methoden

//==============================================================================
procedure TStundenZeitEdit.InitEditMask;
//==============================================================================
begin
  EditMask := '!90:00:00;1;_';  // 1. Zeichen optional
end;

//==============================================================================
function TStundenZeitEdit.Validate(const Value: String; var Pos: Integer): Boolean;
//==============================================================================
// Format = hh:mm:ss,  max cnZeit100_00
begin
  if IstLeer then Result := true
  else
  begin
    Result := inherited Validate(Value,Pos);
    if Result and
       Enabled and Visible and not ReadOnly then
    begin
      if Value[4] > '5' then
      begin
        Pos := 3;
        Result := false;
      end else
      if Value[7] > '5' then
      begin
        Pos := 6;
        Result := false;
      end;
    end;
  end;
end;

//==============================================================================
procedure TStundenZeitEdit.ValidateError;
//==============================================================================
begin
  //MessageBeep(0);
  TriaMessage('Die eingegebene Zeit ist ung�ltig.'+#13+#13+
              'G�ltige Werte sind:'+#13+
              '    >  00:00:00  bis  99:59:59'+#13+
              '    >  __:__:__  (keine Zeit)'+#13+#13+
              'Mit der Taste ESC k�nnen Sie die �nderungen r�ckg�ngig machen.'
              ,mtInformation,[mbOk]);
end;

//==============================================================================
function TStundenZeitEdit.Wert: Integer;
//==============================================================================
// Result ist Zeit in 1/100 Sekunden
// Format hh:mm:ss, keine Zehntel
var hh,mm,ss : Integer;
    S : String;
begin
  Result := -1;
  if IstLeer then Exit;
  S := EditText;
  if (Length(EditMask)>0) and (S[1]=EditMask[Length(EditMask)]) then S[1] := '0';
  if TryDecStrToInt(copy(S,1,2),hh) and
     TryDecStrToInt(copy(S,4,2),mm) and
     TryDecStrToInt(copy(S,7,2),ss) then
    Result := (ss + 60*mm + 3600*hh) * 100;
end;

//==============================================================================
function TStundenZeitEdit.ZeitGleich(const Value:String): Boolean;
//==============================================================================
// EditMask := !90:00:00;1;_;
var S : String;
begin
  if IstLeer then Result := Value = ''
  else
  begin
    S := EditText;
    if (Length(EditMask)>0) and (S[1]=EditMask[Length(EditMask)]) then S[1] := '0';
    Result := SameText(S,Value);
  end;
end;

(******************************************************************************)
(* Methoden von TStartZeitEdit                                                  *)
(******************************************************************************)

// public Methoden

//==============================================================================
procedure TStartZeitEdit.InitEditMask;
//==============================================================================
// '\:' statt ':' damit ':' als literal Zeichen verwendet wird,
// unabh�ngig von L�ndereinstellungen
begin
  case ZeitFormat of
    zfHundertstel : EditMask := '00\:00\:00'+ DecTrennZeichen+'00;1;_';
    zfZehntel     : EditMask := '00\:00\:00'+ DecTrennZeichen+'0;1;_';
    else            EditMask := '00\:00\:00;1;_';
  end;
end;

//==============================================================================
function TStartZeitEdit.Validate(const Value: String; var Pos: Integer): Boolean;
//==============================================================================
// Validate wird nicht ausgef�hrt bei Exit, nicht beim Drucken der Enter-Taste
// Zeiten von 00:00:00 - 23:59:59
begin
  Result := inherited Validate(Value,Pos); // Leerzeichen nicht erlaubt
  if Result and
     Enabled and Visible and not ReadOnly then // g�ltige Uhrzeit pr�fen
  begin
    if (Value[1] > '2') then // max 2
    begin
      Pos := 0;
      Result := false;
    end else
    if (Value[1] = '2') and (Value[2] > '3') then // max 23
    begin
      Pos := 1;
      Result := false;
    end else
    if Value[4] > '5' then // max 5
    begin
      Pos := 3;
      Result := false;
    end else
    if Value[7] > '5' then // max 5
    begin
      Pos := 6;
      Result := false;
    end;
  end;
end;

//==============================================================================
procedure TStartZeitEdit.ValidateError;
//==============================================================================
var S1,S2 : String;
begin
  case ZeitFormat of
    zfHundertstel:
    begin
      S1 := '00:00:00'+DecTrennZeichen+'00';
      S2 := '23:59:59'+DecTrennZeichen+'99';
    end;
    zfZehntel:
    begin
      S1 := '00:00:00'+DecTrennZeichen+'0';
      S2 := '23:59:59'+DecTrennZeichen+'9';
    end;
    else
    begin
      S1 := '00:00:00';
      S2 := '23:59:59';
    end;
  end;

  //MessageBeep(0);
  TriaMessage('Die eingegebene Zeit ist ung�ltig.'+#13+#13+
              'G�ltige Werte sind: '+S1+'  bis  '+S2+'.'+#13+#13+
              'Mit der Taste ESC k�nnen Sie die �nderungen r�ckg�ngig machen.'
              ,mtInformation,[mbOk]);
end;

//==============================================================================
function TStartZeitEdit.Wert: Integer;
//==============================================================================
// Result ist Zeit in 1/100 Sekunden
var hh,mm,ss,dd,d : Integer;
    S : String;
begin
  Result := 0;
  if IstLeer then Exit;
  S := EditText;
  //if (Length(EditMask)>0) and (S[1]=EditMask[Length(EditMask)]) then S[1] := '0';
  if TryDecStrToInt(copy(S,1,2),hh) and
     TryDecStrToInt(copy(S,4,2),mm) and
     TryDecStrToInt(copy(S,7,2),ss) then
    case ZeitFormat of
      zfHundertstel:
        if TryDecStrToInt(copy(S,10,2),dd) then
          Result := (dd + 100*ss + 6000*mm + 360000*hh);
      zfZehntel:
        if TryDecStrToInt(copy(S,10,1),d) then
          Result := (d + 10*ss + 600*mm + 36000*hh) * 10;
      else
        Result := (ss + 60*mm + 3600*hh) * 100;
    end;
end;

//==============================================================================
function TStartZeitEdit.ZeitGleich(const Value:String): Boolean;
//==============================================================================
// EditMask := 00:00:00;1;_;
// Value mit f�hrende NULL (mit UhrZeitStr generiert)
begin
  Result := SameText(Text,Value);
end;


end.
