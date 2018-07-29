unit MannsObj;

interface

uses
  Windows,Classes,SysUtils,Dialogs,Controls,Math,StrUtils,
  AllgConst,AllgFunc,AllgObj,AkObj,WettkObj,SGrpObj,SMldObj,TlnObj,DateiDlg;

procedure InitMschGrListe;

type

  TMannschNameColl = Class(TTriaSortColl)
  (* enth�lt alle Mannschaftsnamen *)
  (* alphabetisch sortiert in FSortItems *)
  (* gespeichert wird sortiert, dabei mu� *)
  (* SortIndex in TlnObj, MannschObj, SMldObj gespeichert werden *)
  protected
    function  GetBPObjType: Word; override;
    function  GetPItem(Indx:Integer): PString;
    procedure SetPItem(Indx:Integer; Item:PString);
    function  GetSortItem(Indx:Integer): PString;
    procedure FreeItem(Item: Pointer); override;
    function  LoadItem(Indx:Integer): Boolean; override;
    function  StoreItem(Indx:Integer): Boolean; override;
  public
    constructor Create(Veranst:Pointer);
    function    Store: Boolean; override;
    function    SortString(Item: Pointer): String; override;
    procedure   Sortieren(SortMode: TSortMode);
    function    GetNamePtr(Name:String):PString;
    function    GetNameIndex(Name:String): Integer;
    function    SucheNamePtr(Selbst:PString; Name:String): PString;
    procedure   InsertName(NameNeu:String);
    procedure   NameLoeschen(Name:String);
    property    PItems[Indx:Integer]: PString read GetPItem; default;
    property    SortItems[Indx:Integer]:PString read GetSortItem;
  end;

  TMannschObj = class;
  TMannschTlnListe = class(TTlnColl)
  protected
    FMannschPtr : TMannschObj;
    function    GetBPObjType: Word; override;
    procedure   FreeItem(Item: Pointer); override;
    function    LoadItem(Indx:Integer): Boolean; override;
    function    StoreItem(Indx:Integer): Boolean; override;
  public
    constructor Create(Veranst:Pointer;ItemClass:TTriaObjClass;Msch:TMannschObj);
    procedure   Clear; override;
    procedure   ClearSortIndex(Indx: Integer);
    function    AddItem(Item:Pointer): Integer; override;
    function    CollSize: Integer; override;
    procedure   Sortieren(OrtIndexNeu:Integer; ModeNeu:TSortMode; WettkNeu:TWettkObj;
                           AkNeu:TAkObj; StatusNeu: TStatus);
    property    MannschPtr:TMannschObj read FMannschPtr;
  end;

  TMannschObj = class(TTriaObj)
  protected
    FName             : PString;
    FWettk            : TWettkObj;
    FKlasse           : TAkObj;
    FSerSumSort       : Int64; // Punkt- oder ZeitSumme in 1/100 Sek (sonst Integer-�berlauf)
    FSerSumLst        : Int64; // Punkt- oder ZeitSumme in 1/100 Sek (sonst Integer-�berlauf)
    FSerieRang        : Integer;
    FSerieWertung     : Boolean; // mindestens eine Wertung f�r Serie
    FSerieEndwertung  : Boolean; // Endwertung erreicht / erreichbar
    FTlnListe         : TMannschTlnListe;   // alle gemeldete Mannsch.Tln
    FRngColl          : TWordCollection;    // Rang f�r Tageswertung in Klasse
    FSerSumColl       : TWordCollection;    // Summe pro Ort f�r Serienwertung in Klasse
    FRndColl          : TWordCollection;    // Runden f�r waRndRennen (wkAbs1)
    FStreckenColl     : TIntegerCollection; // f�r Stundenrennen (wkAbs1)
    FRngSerDummyColl  : TWordCollection;    // 2008: nicht benutzt, nur f�r Load
    FStZeitCollArr    : array [wkAbs1..wkAbs8] of TIntegerCollection;
    FZeitCollArr      : array [wkAbs1..wkAbs8] of TIntegerCollection;
    FPunktColl        : TWordCollection;    // Punkte f�r MschPktWrtg in Klasse
    FDisqColl         : TBoolCollection;
    FMschIndex        : Integer; // f�r mehrfach-Wertung einer Mannschaft
    function    GetBPObjType: Word; override;
    function    GetName: String;
    function    GetSortedTln(Indx:Integer): TTlnObj;
    function    GetOrtRng(Indx:Integer): Integer;
    procedure   SetRng(RngNeu:Integer);
    procedure   SetOrtRng(Indx:Integer;RngNeu:Integer);
    procedure   SetRunden(RndNeu:Integer);
    function    GetRunden: Integer;
    procedure   SetStrecken(StreckenNeu:Integer);
    function    GetStrecken: Integer;
    function    GetOrtEndZeit(Indx:Integer): Integer;
    function    GetEndZeit: Integer;
    function    GetAbsStZeitColl(const Abs:TWkAbschnitt): TIntegerCollection;
    function    GetAbsZeitColl(const Abs:TWkAbschnitt): TIntegerCollection;
    function    GetAbsStZeit(const Abs:TWkAbschnitt): Integer;
    function    GetAbsOrtStZeit(const Abs:TWkAbschnitt;const Indx:Integer): Integer;
    procedure   SetAbsStZeit(const Abs:TWkAbschnitt;ZeitNeu:Integer);
    function    GetAbsZeit(const Abs:TWkAbschnitt): Integer; overload;
    function    GetAbsOrtZeit(TlnIndx,OrtIndx:Integer): Integer; overload; // MschStaffel
    function    GetAbsOrtZeit(Abs:TWkAbschnitt;OrtIndx:Integer): Integer; overload;
    function    GetAbsZeit(const TlnIndx:Integer): Integer; overload; // MschStaffel
    procedure   SetAbsZeit(const Abs:TWkAbschnitt;const ZeitNeu:Integer);
    function    GetPunkte: Integer;
    procedure   SetPunkte(const PktNeu:Integer);
    function    GetDisq:Boolean;
    procedure   SetDisq(DisqNeu:Boolean);

  public
    DummyTln  : TTlnobj;
    Msch1     : TMannschObj;
    constructor Create(Veranst:Pointer;Coll:TTriaObjColl;Add:TOrtAdd); override;
    procedure   Init(NameNeu:String; WettkNeu:TWettkObj;
                     KlasseNeu:TAkObj; MschIndexNeu:Integer);
    destructor  Destroy; override;
    function    Load: Boolean; override;
    function    Store: Boolean; override;
    procedure   OrtCollAdd; override;
    procedure   OrtCollClear(Indx:Integer); override;
    procedure   OrtCollExch(Idx1,Idx2:Integer); override;
    function    TagesRng: Integer;
    function    TagesRngStr: String;
    function    GetOrtSerSumStr(Indx:Integer): String;
    function    TlnInStatus(St:TStatus): Integer;
    function    GetSerieRangStr: String;
    function    GetTagSumStr(MschTln:TTlnObj): String;
    function    GetTagSumEinh(MschTln:TTlnObj): String;
    function    GetSerieSumStr(Mode:TListMode): String;
    function    GetSerieSumEinh: String;
    procedure   BerechneSerieSumme;
    function    MannschInKlasse(AK:TAkObj): Boolean;
    procedure   OrtErgebnisseLoeschen(Indx:Integer);
    procedure   ErgebnisseLoeschen;
    //function    StartZeit: Integer;
    function    GetStrafZeit: Integer;
    function    GetGutschrift: Integer;
    function    SerWrtgSortZahl: Integer;
    function    ObjSize: Integer; override;

    property    MannschName:PString read FName;
    property    Name:String read GetName;
    property    Klasse:TAkObj read FKlasse write FKlasse;
    property    Wettk:TWettkObj read FWettk;
    property    SerieRang:Integer read FSerieRang write FSerieRang;
    property    MschIndex:Integer read FMschIndex write FMschIndex;
    property    RngColl[Indx:Integer]:Integer read GetOrtRng write SetOrtRng;
    property    MschOrtEndZeit[Indx:Integer]:Integer read GetOrtEndZeit {write SetEndZeit};
    property    MschEndZeit:Integer read GetEndZeit {write SetEndZeit};
    property    MschAbsStZeit[const Abs:TWkAbschnitt]:Integer read GetAbsStZeit write SetAbsStZeit;
    //property    MschAbsOrtStZeit[const Abs:TWkAbschnitt;const Indx:Integer]:Integer read GetAbsOrtStZeit;
    property    MschAbsZeit[const Abs:TWkAbschnitt]:Integer read GetAbsZeit;
    property    AbsStZeitColl[const Abs:TWkAbschnitt]:TIntegerCollection read GetAbsStZeitColl;//f�r Load in VeranstObj
    property    AbsZeitColl[const Abs:TWkAbschnitt]:TIntegerCollection read GetAbsZeitColl;    //f�r Load in VeranstObj
    property    DisqColl:TBoolCollection read FDisqColl;
    property    SortedTln[Indx:Integer]:TTlnObj read GetSortedTln;
    property    TlnListe:TMannschTlnListe read FTlnListe;
    property    Runden : Integer read GetRunden write SetRunden;
    property    Strecken : Integer read GetStrecken write SetStrecken;
    property    Punkte : Integer read GetPunkte write SetPunkte;
  end;

  TReportMschObj = class(TObject)
  // f�r RaveReports, wird beim Sortieren gesetzt
  public
    MschPtr    : TMannschObj;
    constructor Create(MschNeu:TMannschObj);
    function    GetReportAkSortStr: String;
  end;

  TReportMschList = class(TList)
  // zus�tzliche sortierte Pointer-Liste in TriaSortColl
  public
    function    Add(Item:TMannschObj): Integer;
    function    Find(Item:TReportMschObj; var Indx:Integer): Boolean;
    function    Compare(Item1, Item2: TReportMschObj): Integer;
  end;


  TMannschColl = class(TTriaObjColl)
  protected
    FReportItems   : TReportMschList; // unabh�ngige Liste f�r RaveReports
    FSortOrtIndex  : Integer;
    FSortWettk     : TWettkObj;
    FSortKlasse    : TAkObj;
    FSortStatus    : TStatus;
    FSortTlnColl   : TMannschSortMode;
    FTlnSortMode   : TSortMode; // 2005, f�r TlnColl UND FTlnListe
    FTlnSortStatus : TStatus; // 2005 f�r TlnColl UND FTlnListe
    function    GetBPObjType: Word; override;
    function    GetPItem(Indx:Integer): TMannschObj;
    procedure   SetPItem(Indx:Integer; Item:TMannschObj);
    function    GetReportCount: Integer;
    function    GetSortItem(Indx:Integer): TMannschObj;
    function    GetReportItem(Indx:Integer): TReportMschObj;
  public
    constructor Create(Veranst:Pointer;ItemClass:TTriaObjClass);
    destructor  Destroy; override;
    function    SortString(Item: Pointer): String; override;
    function    AddItem(Item:Pointer): Integer; override;
    function    SortModeValid(Item: Pointer): Boolean;
    function    AddSortItem(Item:Pointer): Integer; override;
    procedure   OrtCollExch(Idx1,Idx2:Integer); override;
    procedure   Sortieren(OrtIndexNeu:Integer; ModeNeu:TSortMode;
                          WettkNeu:TWettkObj; AkNeu:TAkObj;
                          StatusNeu:TStatus;
                          SortTlnCollNeu:TMannschSortMode);
    procedure   ReportSortieren; overload;
    procedure   ReportSortieren(WkNeu:TWettkObj); overload;
    procedure   ReportSortieren(WkNeu:TWettkObj;AkNeu:TAkObj); overload;
    procedure   ReportClear;
    procedure   SetzeRang(WertungsWk:TWettkObj);
    procedure   SetzeStaffelVorg(WertungsWk:TWettkObj);
    procedure   MannschWkWertung(WertungsWk:TWettkObj);
    procedure   EinzelWkWertung(WertungsWk:TWettkObj; WertungsAk:TAkObj);
    procedure   MannschWertung(WertungsWk:TWettkObj);
    function    MannschDefiniert(WertungsWk:TWettkObj): Boolean;
    function    SucheMannschaft(Msch:PString;Wk:TWettkObj;Kl:TAkObj;Indx:Integer): TMannschObj;
    function    MschAnzahl(Wk:TWettkObj;Kl:TAkObj):Integer; // immer stGemeldet
    function    TagesRngMax(Wk:TWettkObj;Kl:TAkObj):Integer;
    function    SerieRngMax(Wk:TWettkObj;Kl:TAkObj):Integer;
    procedure   SerieWertung(WertungsWk:TWettkObj);
    procedure   MschEinlesen(EinlWettk:TWettkObj);
    procedure   ClearKlassen(Wk:TWettkObj);
    procedure   SetzeMschAbsStZeit(Abs:TWkAbschnitt;Wk:TWettkObj);
    procedure   SetzeMschAbsZeit(Abs:TWkAbschnitt;Wk:TWettkObj);
    procedure   MschTlnLoeschen(Tln:TTlnObj);
    function    ZeitStrafe(Wk:TWettkObj; Klasse:TAkObj; Status:TStatus): Boolean;
    property    Items[Indx: Integer]: TMannschObj read GetPItem write SetPItem; default;
    property    SortItems[Indx:Integer]:TMannschObj read GetSortItem;
    property    ReportCount:Integer read GetReportCount;
    property    ReportItems[Indx:Integer]:TReportMschObj read GetReportItem;
    property    SortOrtIndex : Integer   read FSortOrtIndex write FSortOrtIndex;
    property    SortWettk    : TWettkObj read FSortWettk;
    property    SortKlasse   : TAkObj    read FSortKlasse;
    property    SortStatus   : TStatus   read FSortStatus;
    property    SortTlnColl  : TMannschSortMode read FSortTlnColl;
  end;

  var MschGrListe : TIntegerCollection; // Gr��e f�r jedem MannschName in MannschNameColl
                                        // unter Ber�cksichtigung von SortKlasse und SortStatus
implementation

uses TriaMain,VeranObj;

//******************************************************************************
procedure InitMschGrListe;
//******************************************************************************
// index MschGrListe entsprricht Index MannschNameColl
// nur aufgerufen bei (Ansicht = anAnmEinzel) and (SortMode = smTlnMschGroesse)
var i,j : Integer;
begin
  if Veranstaltung = nil then Exit;
  MschGrListe.Clear;
  with Veranstaltung do
    for i:=0 to MannschNameColl.Count-1 do
    begin
      if MschGrListe.Add(0) <> i then Exit;
      for j:=0 to TlnColl.Count-1 do
        if (TlnColl[j].MannschNamePtr = MannschNameColl[i]) and
           ((HauptFenster.SortWettk=WettkAlleDummy) or (TlnColl[j].Wettk = HauptFenster.SortWettk)) and
           TlnColl[j].TlnInKlasse(HauptFenster.SortKlasse,tmTln) and
           TlnColl[j].TlnInStatus(HauptFenster.SortStatus) then
          MschGrListe[i] := MschGrListe[i] + 1;
    end;
end;


(******************************************************************************)
(*  Methoden von TMannschNameColl                                             *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
function TMannschNameColl.GetBPObjType: Word;
//------------------------------------------------------------------------------
(* Object Types aus Version 7.4 Stream Registration Records *)
begin
  Result := rrMannschNameColl;
end;

//------------------------------------------------------------------------------
function TMannschNameColl.GetPItem(Indx:Integer): PString;
//------------------------------------------------------------------------------
begin
  Result := PString(inherited GetPItem(Indx));
end;

//------------------------------------------------------------------------------
procedure TMannschNameColl.SetPItem(Indx:Integer; Item:PString);
//------------------------------------------------------------------------------
begin
  inherited SetPItem(Indx,Item);
end;

//------------------------------------------------------------------------------
function TMannschNameColl.GetSortItem(Indx:Integer): PString;
//------------------------------------------------------------------------------
begin
  Result := PString(inherited GetSortItem(Indx));
end;

//------------------------------------------------------------------------------
procedure TMannschNameColl.FreeItem(Item: Pointer);
//------------------------------------------------------------------------------
begin
  if (Item<>nil) then FreeMem(Item,cnSizeOfString);
end;

//------------------------------------------------------------------------------
function TMannschNameColl.LoadItem(Indx:Integer): Boolean;
//------------------------------------------------------------------------------
var P : PString;
    S : String;
begin
  Result := false;
  try
    TriaStream.ReadStr(S);
    New(P);
    P^:= S;
    if AddItem(P) <> Indx then Exit;
  except
    Exit;
  end;
  Result := true;
end;

//------------------------------------------------------------------------------
function TMannschNameColl.StoreItem(Indx:Integer): Boolean;
//------------------------------------------------------------------------------
// namen sortiert speichern, compatible mit BP *)
var P : PString;
begin
  Result := false;
  try
    P := GetSortItem(Indx);
    if P <> nil then
      TriaStream.WriteStr(P^);
  except
    Exit;
  end;
  Result := true;
end;


// public Methoden

//==============================================================================
constructor TMannschNameColl.Create(Veranst:Pointer);
//==============================================================================
begin
  inherited Create(Veranst);
  // Items m�ssen beim Laden in SortItems Inserted werden, deshalb
  // muss SortMode <> smNichtSortiert (=Default)
  FSortMode := smMschName;
  FSortItems.Duplicates := true;
  FItemSize := cnSizeOfString;
end;

//==============================================================================
function TMannschNameColl.Store: Boolean;
//==============================================================================
// nicht �bernommen von TriaSortColl weil sortiert gespeichert wird
var
  i : Integer;
  C : SmallInt;
  W : Word;
begin
  Result := false;
  W := BPObjType;
  if TriaStream = nil then Exit;
  try
    TriaStream.WriteBuffer(W, cnSizeOfWord);
    C := GetSortCount;  (* sortiert speichern *)
    TriaStream.WriteBuffer(C,cnSizeOfSmallInt);
    for i:=0 to C-1 do
      if not StoreItem(i) then Exit;
  except
    Exit;
  end;
  Result := true;
end;

//==============================================================================
function TMannschNameColl.SortString(Item:Pointer): String;
//==============================================================================
begin
  if Item <> nil then Result := PString(Item)^
                 else Result := ' ';
end;

//==============================================================================
procedure TMannschNameColl.Sortieren(SortMode: TSortMode);
//==============================================================================
var i: integer;
begin
  FSortMode := SortMode;
  SortClear;
  for i:=0 to Count-1 do AddSortItem(GetPItem(i));
end;

//==============================================================================
function TMannschNameColl.GetNamePtr(Name:String):PString;
//==============================================================================
// nach Trim(Name) suchen
// Gross/Klein NICHT unterscheiden, ss/� unterscheiden
var i : Integer;
begin
  i := GetNameIndex(Name);
  if i <> -1 then Result := GetPItem(i)
             else Result := nil;
end;

//==============================================================================
function TMannschNameColl.GetNameIndex(Name:String): Integer;
//==============================================================================
// nach Trim(Name) suchen
// Gross/Klein NICHT unterscheiden, ss/� unterscheiden
begin
  for Result:=0 to Count-1 do
    if (GetPItem(Result)<>nil) and TxtGleich(GetPItem(Result)^,Name) then Exit;
  Result := -1;
end;

//==============================================================================
function TMannschNameColl.SucheNamePtr(Selbst:PString; Name:String):PString;
//==============================================================================
// nach Trim(Name) suchen
// Gross/Klein NICHT unterscheiden, ss/� unterscheiden
var i : Integer;
begin
  Result := nil;
  for i:=0 to Count-1 do
    if (GetPItem(i) <> Selbst) and (GetPItem(i) <> nil ) then
      if TxtGleich(GetPItem(i)^,Name) then
      begin
        Result := GetPItem(i);
        Exit;
      end;
end;

//==============================================================================
procedure TMannschNameColl.InsertName(NameNeu:String);
//==============================================================================
// Trim(NameNeu) einf�gen
var P : PString;
begin
  if StrGleich(Trim(NameNeu),'') or (NameNeu=cnKein) then Exit;
  P := GetNamePtr(NameNeu);
  if P = nil then
  begin
    New(P);
    P^ := Trim(NameNeu);
    AddItem(P);
  end else
  begin
    (* wenn Unterschied nur in Gro�buchstaben, dann wird neue Name gespeichert *)
    ClearSortItem(P);
    P^:= Trim(NameNeu);
    AddSortItem(P);
  end;
end;

//==============================================================================
procedure TMannschNameColl.NameLoeschen(Name:String);
//==============================================================================
// MannschName erstellt wenn in TlnColl oder SMldColl vorhanden
// MannschColl ist abgeleitet von TlnColl, deshalb hier nicht ber�cksichtigen
var P : PString;
begin
  P := GetNamePtr(Name);
  if P <> nil then
    if ((TVeranstObj(FVPtr).TlnColl = nil) or
        not TVeranstObj(FVPtr).TlnColl.MannschNameVorhanden(P)) and
       ((TVeranstObj(FVPtr).SMldColl = nil) or
        not TVeranstObj(FVPtr).SMldColl.MannschNameVorhanden(P)) then
      ClearItem(P);
end;

(******************************************************************************)
(*                  Methoden von TMannschTlnListe                             *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
function TMannschTlnListe.GetBPObjType: Word;
//------------------------------------------------------------------------------
(* Object Types aus Version 7.4 Stream Registration Records *)
begin
  Result := rrMannschTlnListe;
end;

//------------------------------------------------------------------------------
procedure TMannschTlnListe.FreeItem(Item: Pointer);
//------------------------------------------------------------------------------
begin
  // Pointer-Inhalt (=Tln) wird nicht gel�scht
  // neu in TriaWin:
  // Item in TlnListe wird beim L�schen von TlnObj auch gel�scht
  // sonst hier ein Exception wenn Mannschaft sp�ter gel�scht wird
  // 2003-1.7: MannschPtr nur nil gesetzt wenn Msch mit gleicher MschIndex
  if Item<>nil then
    case FMannschPtr.FKlasse.Wertung of
      kwAlle  : if TTlnObj(Item).MannschAllePtr=FMannschPtr then
                  TTlnObj(Item).MannschAllePtr := nil;
      kwSex   : if TTlnObj(Item).MannschSexPtr=FMannschPtr then
                  TTlnObj(Item).MannschSexPtr := nil;
      kwAltKl : if TTlnObj(Item).MannschAkPtr=FMannschPtr then
                  TTlnObj(Item).MannschAkPtr := nil;
      else ;
    end;
end;

//------------------------------------------------------------------------------
function TMannschTlnListe.LoadItem(Indx:Integer): Boolean;
//------------------------------------------------------------------------------
// kein StepProgressCounter
begin
  if (TriDatei.Version.Jahr='2003') or
     (TriDatei.Version.Jahr='2004')and(TriDatei.Version.Nr<'1.10') then
    // Tln-Index �berspringen
    TriaStream.Position := TriaStream.Position + cnSizeOfSmallInt;
  Result := true;
end;

//------------------------------------------------------------------------------
function TMannschTlnListe.StoreItem(Indx:Integer): Boolean;
//------------------------------------------------------------------------------
// kein StepProgressCounter
var I : SmallInt;
begin
  Result := false;
  if (Indx<0)or(Indx>=Count) then Exit;
  if GetPItem(Indx) <> nil then I := TVeranstObj(FVPtr).TlnColl.IndexOf(GetPItem(Indx))
                           else I := -1;
  if TriaStream.Write(I,cnSizeOfSmallInt) <> cnSizeOfSmallInt then Exit;
  Result := true;
end; 

// public Methoden

//==============================================================================
constructor TMannschTlnListe.Create(Veranst:Pointer;ItemClass:TTriaObjClass;
                                    Msch:TMannschObj);
//==============================================================================
begin
  inherited Create(Veranst,ItemClass,pbOhneStepping,tmMsch);
  FVPtr := Veranst;
  FMannschPtr := Msch;
  FItemSize := cnSizeOfPointer;
end;

//==============================================================================
procedure TMannschTlnListe.Clear;
//==============================================================================
// kein StepProgressCounter
begin
  if FItems<>nil then
    while FItems.Count > 0 do
    begin
      FreeItem(FItems.Last); // Item.MannschPtr := nil wenn gleich FMannschPtr
      FItems.Delete(FItems.Count-1);
    end;
end;

//==============================================================================
procedure TMannschTlnListe.ClearSortIndex(Indx:Integer);
//==============================================================================
begin
  if (Indx>=0)and(Indx<FSortItems.Count) then FSortItems.Delete(Indx);
end;

//==============================================================================
function TMannschTlnListe.AddItem(Item:Pointer): Integer;
//==============================================================================
begin
  Result := FItems.Add(Item);
  FSortItems.Capacity := FItems.Capacity;
  AddSortItem(Item);
  // FMannschPtr wird hier gesetzt, ge�ndert in .Sortieren
  // Item.MannschPtr nur setzen wenn MschIndex=0
  if (Item<>nil) and (FMannschPtr.MschIndex=0) then
    case FMannschPtr.FKlasse.Wertung of
      kwAlle  : TTlnObj(Item).MannschAllePtr := FMannschPtr;
      kwSex   : TTlnObj(Item).MannschSexPtr  := FMannschPtr;
      kwAltKl : TTlnObj(Item).MannschAkPtr   := FMannschPtr;
      else ;
    end;
end;

//==============================================================================
function TMannschTlnListe.CollSize: Integer;
//==============================================================================
begin
  Result := cnMinCollSize + FItems.Count * FItemSize;
end;

//==============================================================================
procedure TMannschTlnListe.Sortieren(OrtIndexNeu:Integer; ModeNeu:TSortMode;
                                     WettkNeu:TWettkObj; AkNeu:TAkObj;
                                     StatusNeu:TStatus);
//==============================================================================
var i,IndxMax: Integer;
begin
  // Reihenfolge der Mannschaften in MannschColl ist sortiert nach Index
  // wenn MschIndex>0 werden nur gewertete Tln eingef�gt (bei mwMulti)
  // FMannschPtr in Tln wird nur hier ge�ndert
  if FMannschPtr.FMschIndex=0 then
    for i:=0 to Count-1 do
      if GetPItem(i)<>nil then
        case FMannschPtr.FKlasse.Wertung of
          kwAlle  : GetPItem(i).MannschAllePtr := FMannschPtr;
          kwSex   : GetPItem(i).MannschSexPtr  := FMannschPtr;
          kwAltKl : GetPItem(i).MannschAkPtr   := FMannschPtr;
          else ;
        end
      else
  // bei FMschIndex > 0 mu� immer neu sortiert werden, weil nach Sortierung Tln
  // gel�scht werden (abh�ngig von MannschGrWertung) und damit bei gleicher
  // Sortier-Parameter Liste ung�ltig sein kann
  else SortMode := smNichtSortiert;

  inherited Sortieren(OrtIndexNeu,ModeNeu,WettkNeu,wgStandWrtg,AkNeu,
                      nil,StatusNeu);

  if WettkNeu.OrtMschGroesse[AkNeu.Sex,OrtIndexNeu] > 0 then
    IndxMax := Max(1,SortCount DIV WettkNeu.OrtMschGroesse[AkNeu.Sex,OrtIndexNeu])
  else IndxMax := 0;

  if FMannschPtr.FMschIndex > 0 then  // nie bei Schultour
  begin
    for i:=SortCount-1 downto 0 do
      // SortItems nach Sortieren immer <> nil
      // Tln in richtige Msch einsortieren (mwMulti)
      if (WettkNeu.OrtMschGroesse[AkNeu.Sex,OrtIndexNeu] > 0) and
         (i >= (FMannschPtr.FMschIndex-1)*WettkNeu.OrtMschGroesse[AkNeu.Sex,OrtIndexNeu]) and
         ((FMannschPtr.FMschIndex = IndxMax)or // alle restliche Tln in letzter MschIndex
          (FMannschPtr.FMschIndex < IndxMax)and // sonst Tln doppel
          (i < FMannschPtr.FMschIndex*WettkNeu.OrtMschGroesse[AkNeu.Sex,OrtIndexNeu])) then
        case FMannschPtr.FKlasse.Wertung of
          kwAlle  : GetSortItem(i).MannschAllePtr := FMannschPtr;
          kwSex   : GetSortItem(i).MannschSexPtr  := FMannschPtr;
          kwAltKl : GetSortItem(i).MannschAkPtr   := FMannschPtr;
          else ;
        end
      else ClearSortItem(GetSortItem(i));
  end;
end;


(******************************************************************************)
(*                  Methoden von TMannschObj                                  *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
function TMannschObj.GetBPObjType: Word;
//------------------------------------------------------------------------------
// Object Types aus Version 7.4 Stream Registration Records
begin
  Result := rrMannschObj;
end;

//------------------------------------------------------------------------------
function TMannschObj.GetName: String;
//------------------------------------------------------------------------------
begin
  if FName<>nil then Result := FName^
                else Result := '';
end;

//------------------------------------------------------------------------------
function TMannschObj.GetSortedTln(Indx:Integer): TTlnObj;
//------------------------------------------------------------------------------
begin
  if (Indx >= 0) and (Indx < FTlnListe.SortCount) then
    Result := FTlnListe.SortItems[Indx]
  else Result:=nil;
end;

//------------------------------------------------------------------------------
function TMannschObj.GetOrtRng(Indx:Integer): Integer;
//------------------------------------------------------------------------------
begin
  if (Indx>=0) and (Indx<TVeranstObj(FVPtr).OrtZahl) then
    Result := FRngColl[Indx]
  else Result := 0;
end;

//------------------------------------------------------------------------------
procedure TMannschObj.SetRng(RngNeu:Integer);
//------------------------------------------------------------------------------
begin
  FRngColl[TVeranstObj(FVPtr).OrtIndex] := RngNeu;
end;

//------------------------------------------------------------------------------
procedure TMannschObj.SetOrtRng(Indx:Integer;RngNeu:Integer);
//------------------------------------------------------------------------------
begin
  // kein SortRemove/SortAdd
  if (Indx>=0) and (Indx<TVeranstObj(FVPtr).OrtZahl) then
    FRngColl[Indx] := RngNeu;
end;

//------------------------------------------------------------------------------
procedure TMannschObj.SetRunden(RndNeu:Integer);
//------------------------------------------------------------------------------
begin
  FRndColl[TVeranstObj(FVPtr).OrtIndex] := RndNeu;
end;

//------------------------------------------------------------------------------
function TMannschObj.GetRunden: Integer;
//------------------------------------------------------------------------------
begin
  Result := FRndColl[TVeranstObj(FVPtr).OrtIndex];
end;

//------------------------------------------------------------------------------
procedure TMannschObj.SetStrecken(StreckenNeu:Integer);
//------------------------------------------------------------------------------
begin
  FStreckenColl[TVeranstObj(FVPtr).OrtIndex] := StreckenNeu;
end;

//------------------------------------------------------------------------------
function TMannschObj.GetStrecken: Integer;
//------------------------------------------------------------------------------
begin
  Result := FStreckenColl[TVeranstObj(FVPtr).OrtIndex];
end;

//------------------------------------------------------------------------------
function TMannschObj.GetOrtEndZeit(Indx:Integer): Integer;
//------------------------------------------------------------------------------
// bei MschStaffel bis 16 Tln, letzte 8 zu Abs8 addiert, ab 8 nur Start ohne Pause
// Zeit auch definiert wenn Tln < MschGr bei Staffel
var i : Integer;
begin
  Result := 0;
  if FWettk.OrtWettkArt[Indx] = waMschStaffel then
    for i:=1 to Min(Integer(wkAbs8),FWettk.OrtMschGroesse[FKlasse.Sex,Indx]) do
      Result := Result + GetAbsOrtZeit(i,Indx)
  else // waTeam, alle andere ????
  begin
    Result := GetAbsOrtZeit(FWettk.OrtAbschnZahl[Indx],Indx);
    if Result > 0 then // g�ltige Endzeit  ??????????????????????? warum?, testen !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    for i:=1 to FWettk.OrtAbschnZahl[Indx]-1 do
      Result := Result + GetAbsOrtZeit(i,Indx)
  end;
end;

//------------------------------------------------------------------------------
function TMannschObj.GetEndZeit: Integer;
//------------------------------------------------------------------------------
begin
  Result := GetOrtEndZeit(TVeranstObj(FVPtr).OrtIndex);
end;

//------------------------------------------------------------------------------
function TMannschObj.GetAbsStZeitColl(const Abs:TWkAbschnitt): TIntegerCollection;
//------------------------------------------------------------------------------
begin
  Result := FStZeitCollArr[Abs];
end;

//------------------------------------------------------------------------------
function TMannschObj.GetAbsZeitColl(const Abs:TWkAbschnitt): TIntegerCollection;
//------------------------------------------------------------------------------
begin
  Result := FZeitCollArr[Abs];
end;

//------------------------------------------------------------------------------
function TMannschObj.GetAbsStZeit(const Abs:TWkAbschnitt): Integer;
//------------------------------------------------------------------------------
begin
  Result := FStZeitCollArr[Abs][TVeranstObj(FVPtr).OrtIndex];
end;

//------------------------------------------------------------------------------
function TMannschObj.GetAbsOrtStZeit(const Abs:TWkAbschnitt;const Indx:Integer): Integer;
//------------------------------------------------------------------------------
begin
  Result := FStZeitCollArr[Abs][Indx];
end;

//------------------------------------------------------------------------------
procedure TMannschObj.SetAbsStZeit(const Abs:TWkAbschnitt;ZeitNeu:Integer);
//------------------------------------------------------------------------------
begin
  while ZeitNeu >= cnZeit24_00 do Zeitneu := ZeitNeu - cnZeit24_00;
  FStZeitCollArr[Abs][TVeranstObj(FVPtr).OrtIndex] := ZeitNeu;
end;

//------------------------------------------------------------------------------
function TMannschObj.GetAbsOrtZeit(TlnIndx,OrtIndx:Integer): Integer;
//------------------------------------------------------------------------------
// f�r MschStaffel bis 16 Tln, letzte 8 zu wkAbs8 addiert
begin
  if TlnIndx <= Integer(wkAbs8) then
    Result := FZeitCollArr[TWkAbschnitt(TlnIndx)][OrtIndx]
  else Result := FZeitCollArr[wkAbs8][OrtIndx];
end;

//------------------------------------------------------------------------------
function TMannschObj.GetAbsOrtZeit(Abs:TWkAbschnitt;OrtIndx:Integer): Integer;
//------------------------------------------------------------------------------
begin
  Result := FZeitCollArr[Abs][OrtIndx];
end;

//------------------------------------------------------------------------------
function TMannschObj.GetAbsZeit(const Abs:TWkAbschnitt): Integer;
//------------------------------------------------------------------------------
begin
  Result := FZeitCollArr[Abs][TVeranstObj(FVPtr).OrtIndex];
end;

//------------------------------------------------------------------------------
function TMannschObj.GetAbsZeit(const TlnIndx:Integer): Integer;
//------------------------------------------------------------------------------
// f�r MschStaffel bis 16 Tln, letzte 8 zu wkAbs8 addiert
begin
  if TlnIndx <= Integer(wkAbs8) then
    Result := FZeitCollArr[TWkAbschnitt(TlnIndx)][TVeranstObj(FVPtr).OrtIndex]
  else Result := FZeitCollArr[wkAbs8][TVeranstObj(FVPtr).OrtIndex];
end;

//------------------------------------------------------------------------------
procedure TMannschObj.SetAbsZeit(const Abs:TWkAbschnitt;const ZeitNeu:Integer);
//------------------------------------------------------------------------------
begin
  FZeitCollArr[Abs][TVeranstObj(FVPtr).OrtIndex] := ZeitNeu;
end;

//------------------------------------------------------------------------------
function TMannschObj.GetPunkte: Integer;
//------------------------------------------------------------------------------
begin
   Result := FPunktColl[TVeranstObj(FVPtr).OrtIndex];
end;

//------------------------------------------------------------------------------
procedure TMannschObj.SetPunkte(const PktNeu:Integer);
//------------------------------------------------------------------------------
begin
  FPunktColl[TVeranstObj(FVPtr).OrtIndex] := PktNeu;
end;

//------------------------------------------------------------------------------
function TMannschObj.GetDisq: Boolean;
//------------------------------------------------------------------------------
begin
  Result := FDisqColl[TVeranstObj(FVPtr).OrtIndex];
end;

//------------------------------------------------------------------------------
procedure TMannschObj.SetDisq(DisqNeu:Boolean);
//------------------------------------------------------------------------------
begin
  FDisqColl[TVeranstObj(FVPtr).OrtIndex] := Disqneu;
end;

{//------------------------------------------------------------------------------
function TMannschObj.GetPunkte: Integer;
//------------------------------------------------------------------------------
begin
  Result := FPunktColl[TVeranstObj(FVPtr).OrtIndex]^;
end;}

{//------------------------------------------------------------------------------
procedure TMannschObj.SetPunkte(PktNeu:Integer);
//------------------------------------------------------------------------------
begin
  FPunktColl[TVeranstObj(FVPtr).OrtIndex]^ := PktNeu;
end;}

{//------------------------------------------------------------------------------
procedure TMannschObj.SetSeriePunkte(PktNeu:Integer);
//------------------------------------------------------------------------------
begin
  FSeriePunkte := PktNeu;
end;}


// public Methoden

//==============================================================================
constructor TMannschObj.Create(Veranst:Pointer;Coll:TTriaObjColl;Add:TOrtAdd);
//==============================================================================
var i : Integer;
    AbsCnt : TWkAbschnitt;
begin
  inherited Create(Veranst,Coll,Add);
  Msch1      := nil; // beim Einlesen gesetzt, f�r WordUrk in anMschAStart und MschWertg = mwMulti
  FWettk     := nil;
  FKlasse    := AkUnbekannt;
  //FSerienTln := TVeranstObj(FVPtr).Serie; // nicht mehr benutzt
  //FAusserKonkurrenz := false; // nicht mehr benutzt
  FSerSumSort      := 0;
  FSerSumLst       := 0;
  FSerieWertung    := false;
  FSerieEndWertung := false;
  FSerieRang       := 0;
  FTlnListe        := TMannschTlnListe.Create(FVPtr,TTlnObj,Self);
  FRngColl         := TWordCollection.Create(FVPtr);
  FSerSumColl      := TWordCollection.Create(FVPtr);
  FRndColl         := TWordCollection.Create(FVPtr);
  FStreckenColl    := TIntegerCollection.Create(FVPtr);
  FRngSerDummyColl := TWordCollection.Create(FVPtr);
  //FEndZeitColl   := TIntegerCollection.Create(FVPtr,seOrtMax,0);
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    FStZeitCollArr[AbsCnt] := TIntegerCollection.Create(FVPtr);
    FZeitCollArr[AbsCnt]   := TIntegerCollection.Create(FVPtr);
  end;
  FPunktColl      := TWordCollection.Create(FVPtr);
  FDisqColl       := TBoolCollection.Create(FVPtr);
  DummyTln        := TTlnObj.Create(FVPtr,TVeranstObj(FVPtr).TlnColl,oaNoAdd);
  // DummyTln ausschreiben, weil sonst gleiche namen in MannschObj gesetzt werden
  DummyTln.Dummy          := true;
  DummyTln.MannschAllePtr := Self;
  DummyTln.MannschSexPtr  := Self;
  DummyTln.MannschAkPtr   := Self;
  DummyTln.Name           := cnDummyName;
  DummyTln.MannschName    := cnDummyName;
  // ab 2004-1.1
  if Add=oaAdd then for i:=0 to TVeranstObj(FVPtr).OrtZahl-1 do OrtCollAdd;
end;

//==============================================================================
procedure TMannschObj.Init(NameNeu:String;WettkNeu:TWettkObj;
                           KlasseNeu:TAkObj;MschIndexNeu:Integer);
//==============================================================================
begin
  TVeranstObj(FVPtr).MannschNameColl.InsertName(NameNeu);
  FName := TVeranstObj(FVPtr).MannschNameColl.GetNamePtr(NameNeu);
  DummyTln.MannschNamePtr := FName;
  FWettk := WettkNeu;
  DummyTln.Wettk := FWettk;
  FKlasse := KlasseNeu;
  DummyTln.Sex := FKlasse.Sex;
  DummyTln.Jg  := FWettk.OrtJahr[0] - FKlasse.AlterVon;
  DummyTln.KlassenSetzen;
  FMschIndex := MschIndexNeu;
  // Tln werden in MschEinlesen eingelesen
  FSerSumSort := 0;
  FSerSumLst  := 0;
  FSerieRang  := 0;
  // ab 2004-1.1 in Create
  //for i:=0 to TVeranstObj(FVPtr).OrtZahl-1 do OrtCollAdd;
end;

//==============================================================================
destructor TMannschObj.Destroy;
//==============================================================================
var AbsCnt : TWkAbschnitt;
begin
  FreeAndNil(FTlnListe);
  FreeAndNil(FRngColl);
  FreeAndNil(FSerSumColl);
  FreeAndNil(FRndColl);
  FreeAndNil(FStreckenColl);
  FreeAndNil(FRngSerDummyColl);
  //FEndZeitColl.Free;
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    FreeAndNil(FStZeitCollArr[AbsCnt]);
    FreeAndNil(FZeitCollArr[AbsCnt]);
  end;
  FreeAndNil(FPunktColl);
  FreeAndNil(FDisqColl);
  if (FVPtr=Veranstaltung) and (Veranstaltung<>nil) and
     (Veranstaltung.TlnColl <> nil) then
    Veranstaltung.TlnColl.ClearSortItem(DummyTln);
  FreeAndNil(DummyTln);
  inherited Destroy;
end;

//==============================================================================
function TMannschObj.Load: Boolean;
//==============================================================================
// ab 2004-1.1 wird nicht mehr geladen,
// Mannschaften werden nach dem Laden immer neu eingelesen
// �berspringen f�r �ltere Dateien zu komplex
var Buff           : SmallInt;
    SeriePunkteBuf : Word;
    SerieRangBuf   : Word;
    KlStrBuf       : String;
    Bool           : Boolean;
 begin
  if (TriDatei.Version.Jahr='2003') or
     (TriDatei.Version.Jahr='2004')and(TriDatei.Version.Nr<'1.10') then
  begin
    Result := false;
    try
      if FVPtr <> EinlVeranst then Exit;
      if not inherited Load then Exit;
      with TriaStream do
      begin
        ReadBuffer(Buff, cnSizeOfSmallInt);
        ReadBuffer(Buff, cnSizeOfSmallInt);
        ReadStr(KlStrBuf);
        ReadBuffer(Bool{FSerienTln}, cnSizeOfBoolean);
        ReadBuffer(Bool{FAusserKonkurrenz}, cnSizeOfBoolean);
        if not FTlnListe.Load then Exit;
        if not FRngColl.Load then Exit;
        if not FRngSerDummyColl.Load then Exit;
        //if not FEndZeitColl.Load then Exit;
        if not FZeitCollArr[wkAbs3].Load then Exit; // Dummy load
        //if not FPunktColl.Load then Exit;
        ReadBuffer(SeriePunkteBuf, cnSizeOfWord);
        ReadBuffer(SerieRangBuf, cnSizeOfWord);
        ReadBuffer(Buff, cnSizeOfSmallInt);
      end;
    except
      Exit;
    end;
  end;
  Result := true;
end;

//==============================================================================
function TMannschObj.Store: Boolean;
//==============================================================================
begin
  Result := false;
end;

//==============================================================================
procedure TMannschObj.OrtCollAdd;
//==============================================================================
var AbsCnt : TWkAbschnitt;
begin
  FRngColl.Add(0);
  FSerSumColl.Add(0);
  FRndColl.Add(0);
  FStreckenColl.Add(0);
  FRngSerDummyColl.Add(0);
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    FStZeitCollArr[AbsCnt].Add(-1);
    FZeitCollArr[AbsCnt].Add(0);
  end;
  FPunktColl.Add(0);
  FDisqColl.Add(false);
  DummyTln.OrtCollAdd;
end;

//==============================================================================
procedure TMannschObj.OrtCollClear(Indx:Integer);
//==============================================================================
var AbsCnt : TWkAbschnitt;
begin
  if (Indx<0) or (Indx>FRngColl.Count-1) then Exit;
  FRngColl.ClearIndex(Indx);
  FSerSumColl.ClearIndex(Indx);
  FRndColl.ClearIndex(Indx);
  FStreckenColl.ClearIndex(Indx);
  FRngSerDummyColl.ClearIndex(Indx);
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    FStZeitCollArr[AbsCnt].ClearIndex(Indx);
    FZeitCollArr[AbsCnt].ClearIndex(Indx);
  end;
  FPunktColl.ClearIndex(Indx);
  FDisqColl.ClearIndex(Indx);
  DummyTln.OrtCollClear(Indx);
end;

//==============================================================================
procedure TMannschObj.OrtCollExch(Idx1,Idx2:Integer);
//==============================================================================
var AbsCnt : TWkAbschnitt;
begin
  FRngColl.List.Exchange(Idx1,Idx2);
  FSerSumColl.List.Exchange(Idx1,Idx2);
  FRndColl.List.Exchange(Idx1,Idx2);
  FStreckenColl.List.Exchange(Idx1,Idx2);
  FRngSerDummyColl.List.Exchange(Idx1,Idx2);
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    FStZeitCollArr[AbsCnt].List.Exchange(Idx1,Idx2);
    FZeitCollArr[AbsCnt].List.Exchange(Idx1,Idx2);
  end;
  FPunktColl.List.Exchange(Idx1,Idx2);
  FDisqColl.List.Exchange(Idx1,Idx2);
  DummyTln.OrtCollExch(Idx1,Idx2);
end;

//==============================================================================
function TMannschObj.TagesRng: Integer;
//==============================================================================
begin
  Result := FRngColl[TVeranstObj(FVPtr).OrtIndex];
end;

//==============================================================================
function TMannschObj.TagesRngStr: String;
//==============================================================================
begin
  if FDisqColl[TVeranstObj(FVPtr).OrtIndex] then Result := 'disq'
  else if FRngColl[TVeranstObj(FVPtr).OrtIndex] = 0 then Result := '-'
  else Result := IntToStr(FRngColl[TVeranstObj(FVPtr).OrtIndex]);
end;

//==============================================================================
function TMannschObj.GetOrtSerSumStr(Indx:Integer): String;
//==============================================================================
begin
  if FWettk.SerWrtgMode[tmMsch] = swZeit then
    Result := EffZeitStr(FSerSumColl[Indx]) // Zeit=0 als '-'
  else // Punktwertung
  if FSerSumColl[Indx] = 0 then
    Result := '-'
  else
  if FRngColl[Indx] > 0 then
    Result := IntToStr(FSerSumColl[Indx])
  else
    Result := '('+IntToStr(FSerSumColl[Indx])+')';
end;

//==============================================================================
function TMannschObj.GetSerieRangStr: String;
//==============================================================================
begin
  if FSerieRang = 0 then Result := '-'
                    else Result := IntToStr(FSerieRang);
end;

//==============================================================================
function TMannschObj.GetTagSumStr(MschTln:TTlnObj): String;
//==============================================================================
begin
  if FWettk.MschWrtgMode = wmTlnZeit then  //wmTlnZeit,wmTlnPlatz,wmSchultour
    if FWettk.WettkArt=waStndRennen then
      if MschTln=nil then
        Result := KmStr(Strecken)
      else
        Result := KmStr(MschTln.Rundenzahl(wkAbs1)*FWettk.RundLaenge + MschTln.Reststrecke)
    else
      if MschTln=nil then
        Result := EffZeitStr(MschEndZeit)
      else
        Result := EffZeitStr(MschTln.EndZeit)
  else
    if MschTln=nil then
      Result := IntToStr(Punkte)
    else
      Result := IntToStr(MschTln.TagesRng(wkAbs0,FKlasse.Wertung,wgMschPktWrtg));
end;

//==============================================================================
function TMannschObj.GetTagSumEinh(MschTln:TTlnObj): String;
//==============================================================================
begin
  if FWettk.MschWrtgMode = wmTlnZeit then  //wmTlnZeit,wmTlnPlatz,wmSchultour
    if FWettk.WettkArt=waStndRennen then
      Result := 'km.'
    else
      if MschTln=nil then
        Result := ZeitEinhStr(MschEndZeit)
      else
        Result := ZeitEinhStr(MschTln.EndZeit)
  else
    Result := '-'; // Punkte
end;

//==============================================================================
function TMannschObj.GetSerieSumStr(Mode:TListMode): String;
//==============================================================================
var Buf : Integer;
begin
  if FWettk.SerWrtgMode[tmMsch] = swZeit then
  begin
    Buf := (FSerSumLst + 50) DIV 100; // in Sek und Integer umwandeln
    if Mode = lmExport then
      Result := ExpZeitSekStr(Buf)
    else
      Result := EffZeitSekStr(Buf)
  end else
  begin
    Buf    := FSerSumLst; // in Integer umwandeln
    Result := IntToStr(Buf); // Punkte
  end;
end;

//==============================================================================
function TMannschObj.GetSerieSumEinh: String;
//==============================================================================
begin
  if FWettk.SerWrtgMode[tmMsch] = swZeit then
    Result := ZeitEinhStr(FSerSumLst)
  else
    Result := '-'; // Punkte
end;

//==============================================================================
function TMannschObj.TlnInStatus(St:TStatus): Integer;
//==============================================================================
var i : Integer;
begin
  Result := 0;
  for i:=0 to FTlnListe.Count-1 do
    if (FTlnListe[i]<>nil) and FTlnListe[i].TlnInStatus(St) then
      Inc(Result);
end;

//==============================================================================
procedure TMannschObj.BerechneSerieSumme;
//==============================================================================
// Punkte oder Zeitsumme f�r Serie berechnen, immer �ber alle Orte
// nicht gestartete Orte werden nicht ber�cksichtigt

var i, MschOrteGewertet, WkLetztOrtGewertet,
    ErstPktZahl,LetztPktZahl              : Integer; // auch f�r Zeiten bei Zeitaddition
    PflichtWkErfuellt, PflichtWkErfuellt1 : Boolean;

//..............................................................................
procedure SetPflichtWkErfuellt(Indx:Integer);
// PflichtWkErfuellt nur �ndern, wenn true
begin
  with FWettk do
    case PflichtWkMode[tmMsch] of
      pw1:
        if Indx = PflichtWkOrt1Indx[tmMsch] then PflichtWkErfuellt := true;
      pw1v2:
        if (Indx = PflichtWkOrt1Indx[tmMsch]) or
           (Indx = PflichtWkOrt2Indx[tmMsch]) then PflichtWkErfuellt := true;
      pw2:
        if (Indx = PflichtWkOrt1Indx[tmMsch]) or
           (Indx = PflichtWkOrt2Indx[tmMsch]) then
          if not PflichtWkErfuellt1 then PflichtWkErfuellt1 := true
                                    else PflichtWkErfuellt := true;
      else PflichtWkErfuellt := true; // pw0
    end;
end;

//------------------------------------------------------------------------------
procedure StreichergEntfernen;
// pro Klassenwertung aufgerufen, weil Rng-Folge unterschiedlich sein kann
// Items aus RngColl nicht entfernen, sondern Rng=0 setzen
var StreichZahl,
    StreichIndx,
    StreichSortIndx : Integer;
    StreichErg1v2   : Boolean;
begin
  // OrtZahlGestartet in TlnErg berechnet
  with FWettk do
  begin
    // Streichzahl wird um Zahl der nicht durchgef�hrte Wettk gek�rzt
    StreichZahl := StreichErg[tmMsch] - TVeranstObj(FVPtr).OrtZahl + OrtZahlGestartet[tmMsch];
    StreichSortIndx := SerPktBuffColl.SortCount-1; // schlechteste PktZahl am Ende
    StreichErg1v2 := true;

    // bei Streichung Rng=0 setzen, wird bei Seriesumme ignoriert
    // F�r Streichung schlechteste Punktzahl ber�cksichtigen, nicht letzter Rng
    // SerPktBuffColl nach Punktzahl sortiert, nicht nach Rng
    // schlechteste Punktzahl am Ende (h�chste bei Incr oder niedrigste bei Decr)
    while (StreichZahl > 0) and (StreichSortIndx >= 0) do
    begin
      // letzter Punktzahl steht immer am Ende von SortListe, auch nach Streichung
      StreichIndx := SerPktBuffColl.IndexOf(SerPktBuffColl.PSortItems[StreichSortIndx]);
      // StreichErg entfernen, falls kein PflichtWk
      case PflichtWkMode[tmMsch] of
        pw1:
          if StreichIndx <> PflichtWkOrt1Indx[tmMsch] then
          begin
            SerPktBuffColl[StreichIndx] := ErstPktZahl; // am Anfang der Liste
            StreichZahl := StreichZahl - 1;
          end else
            StreichSortIndx := StreichSortIndx - 1;
        pw1v2:
          if (StreichIndx <> PflichtWkOrt1Indx[tmMsch]) and
             (StreichIndx <> PflichtWkOrt2Indx[tmMsch]) then
          begin
            SerPktBuffColl[StreichIndx] := ErstPktZahl; // am Anfang der Liste
            StreichZahl := StreichZahl - 1;
          end else
          if StreichErg1v2 then
          begin
            SerPktBuffColl[StreichIndx] := ErstPktZahl; // am Anfang der Liste
            StreichZahl := StreichZahl - 1;
            StreichErg1v2 := false;
          end else
            StreichSortIndx := StreichSortIndx - 1;
        pw2:
          if (StreichIndx <> PflichtWkOrt1Indx[tmMsch]) and
             (StreichIndx <> PflichtWkOrt2Indx[tmMsch]) then
          begin
            SerPktBuffColl[StreichIndx] := ErstPktZahl; // am Anfang der Liste
            StreichZahl := StreichZahl - 1;
          end else
            StreichSortIndx := StreichSortIndx - 1;
        else // pw0, kein PflichtWk
        begin
          SerPktBuffColl[StreichIndx] := ErstPktZahl; // am Anfang der Liste
          StreichZahl := StreichZahl - 1;
        end;
      end;
    end;
  end;
end;

//begin Hauptprocedure ---------------------------------------------------------
begin
  FSerSumSort      := 0;
  FSerSumLst       := 0;
  FSerieWertung    := false;
  FSerieEndWertung := false;
  for i:=0 to TVeranstObj(FVPtr).OrtZahl-1 do
    FSerSumColl[i] := 0;

  if not TVeranstObj(FVPtr).Serie then Exit;

  with FWettk do
  begin
    if (OrtZahlGestartet[tmMsch] <= 0) or
       (OrtZahlGestartet[tmMsch] > TVeranstObj(FVPtr).OrtZahl) then Exit;

    // alle OrtsWertungen in OrtRngColl's nach Platzierung sortieren
    // Rng = 0, bei Punkteberechnung nicht ber�cksichtigt
    PflichtWkErfuellt1 := false;
    if PflichtWkMode[tmMsch] = pw0 then PflichtWkErfuellt := true // auch ohne Wertung
                                   else PflichtWkErfuellt := false;

    if (SerWrtgMode[tmMsch] = swZeit) then
    begin
      SerPktBuffColl.SortMode := smIncr; // Summe von 1 bis Max-MschZeit
      ErstPktZahl  := -1;        // < 0(=keine Zeit)
      LetztPktZahl := cnMschSerOrtZeitMax; // > Max-MschZeit (1.111.678.400)
    end else
    if (SerWrtgMode[tmMsch] = swRngUpPkt) or (SerWrtgMode[tmMsch] = swRngUpEqPkt) or
       (SerWrtgMode[tmMsch] = swFlexPkt) and CupPktIncr(tmMsch) then
    begin
      SerPktBuffColl.SortMode := smIncr; // Punkte von 1 bis cnTlnMax+1
      ErstPktZahl  := 0; // < 1
      LetztPktZahl := cnTlnMax+2; // > cnTlnMax+1
    end else
    begin
      SerPktBuffColl.SortMode := smDecr; // Punkte von cnTlnMax bis 0
      ErstPktZahl  := cnTlnMax+1; // > cnTlnMax
      LetztPktZahl := -1;  // < 0
    end;
    SerPktBuffColl.SortClear; // weil nur bis OrteGewertet �berschrieben
    MschOrteGewertet   := 0;
    WkLetztOrtGewertet := -1;

    for i:=0 to TVeranstObj(FVPtr).OrtZahl-1 do

      if MschOrtSerWertung(i) then // PktWrtg oder (ZeitWrtg f�r Ser und Msch)
        if TlnImZielColl[tmMsch][i] then // Wettk durchgef�hrt
        begin
          WkLetztOrtGewertet := i;
          if GetOrtRng(i) > 0 then // Disq nicht ber�cksichtigen
          begin
            Inc(MschOrteGewertet);
            SetPflichtWkErfuellt(i);
            if SerWrtgMode[tmMsch] = swZeit then
              SerPktBuffColl[i] := GetOrtEndZeit(i)
            else
              SerPktBuffColl[i] := OrtSerPkt(tmMsch,i,Klasse,GetOrtRng(i));
            FSerSumColl[i] := SerPktBuffColl[i];
          end else // Rng=0 am Ende setzen, damit diese zuerst gestrichen wird
          begin
            SerPktBuffColl[i] := LetztPktZahl;
            if SerWrtgMode[tmMsch] <> swZeit then
              FSerSumColl[i] := OrtSerPkt(tmMsch,i,Klasse,0);
          end
        end else // Wettk (noch) nicht durchgef�hrt
        begin
          SetPflichtWkErfuellt(i);
          SerPktBuffColl[i] := ErstPktZahl;
        end
      else // bei swZeit muss auch MschWrtg nach Zeit sein
        SerPktBuffColl[i] := ErstPktZahl; // egal ob Tln Gestartet

    if MschOrteGewertet > 0 then
    begin
      FSerieWertung := true; // Msch in mindestens 1 Ort gewertet
      if PflichtWkErfuellt and
         (MschOrteGewertet >= WkLetztOrtGewertet+1 - StreichOrt[tmMsch]) then
        FSerieEndWertung := true; // Endwertung erreichbar oder erreicht, f�r Sortierung
    end;

    // Streichergebnisse entfernen (Rng := 0 setzen):
    // Rng = 0, bei Punkteberechnung nicht ber�cksichtigt
    // Items nicht l�schen, damit PflichtWkOrtIndx sich nicht �ndert
    StreichergEntfernen;

    // SerieSumme berechnen
    for i:=0 to SerPktBuffColl.Count-1 do // Count = TVeranstObj(FVPtr).OrtZahl
      if SerPktBuffColl[i] <> ErstPktZahl then // Rng=0 incl. StreichErgebnisse ignorieren
      begin
        if SerPktBuffColl[i] = LetztPktZahl then // Rng war urspr�nglich 0
          // LetztPktZahl zu SerieSumSort/Lst addieren
          if SerWrtgMode[tmMsch] = swZeit then // Summe=cnMschSerOrtZeitMax
            FSerSumSort := FSerSumSort + LetztPktZahl
            //FSerSumLst unver�ndert (Sum=0)
          else // Summe=Punkte f�r Rng=0
          begin
            FSerSumSort := FSerSumSort + OrtSerPkt(tmMsch,i,Klasse,0);
            FSerSumLst  := FSerSumLst + OrtSerPkt(tmMsch,i,Klasse,0);
          end
        else
        begin
          FSerSumSort := FSerSumSort + SerPktBuffColl[i]; // Int64, sonst �berlauf
          FSerSumLst  := FSerSumLst + SerPktBuffColl[i];
        end;
      end;
  end;
end;

//==============================================================================
function TMannschObj.MannschInKlasse(AK:TAkObj): Boolean;
//==============================================================================
begin
  if Ak.Wertung = FKlasse.Wertung then
    case Ak.Wertung of
      kwAlle  : Result := true;
      kwSex   : Result := AK.Sex = FKlasse.Sex; // auch f�r AkMixed
      kwAltKl : Result := (AK.Sex = FKlasse.Sex) and
                          (AK.AlterVon <= FKlasse.AlterVon) and
                          (AK.AlterBis >= FKlasse.AlterBis);
                        {AK = FKlasse;}
      else Result := false;
    end
  else Result := false;
end;

//==============================================================================
procedure TMannschObj.OrtErgebnisseLoeschen(Indx:Integer);
//==============================================================================
var AbsCnt : TWkAbschnitt;
begin
  for AbsCnt:=wkabs1 to wkAbs8 do
  begin
    FStZeitCollArr[AbsCnt][Indx] := -1;
    FZeitCollArr[AbsCnt][Indx]   := 0;
  end;
  FRngColl[Indx]      := 0;
  FRndColl[Indx]      := 0;
  FStreckenColl[Indx] := 0;
  FDisqColl[Indx]     := false;
  FPunktColl[Indx]    := 0;
end;

//==============================================================================
procedure TMannschObj.ErgebnisseLoeschen;
//==============================================================================
(* gilt f�r alle Orte *)
var i : Integer;
begin
  FSerSumSort      := 0;
  FSerSumLst       := 0;
  FSerieRang       := 0;
  FSerieWertung    := false;
  FSerieEndWertung := false;
  for i:=0 to TVeranstObj(FVPtr).OrtZahl-1 do OrtErgebnisseLoeschen(i);
end;

{//==============================================================================
function TMannschObj.StartZeit: Integer;
//==============================================================================
begin
  Result := DummyTln.StrtZeit(wkAbs1);
end; }

//==============================================================================
function TMannschObj.GetStrafZeit: Integer;
//==============================================================================
var i : Integer;
// 2006: default -1 statt 0
begin
  Result := -1;
  if Wettk.MschWettk then
    for i:=0 to FTlnListe.Count-1 do with FTlnListe[i] do
      if StrafZeit >= 0 then
        if Result = -1 then Result := StrafZeit
                       else Result := Result + StrafZeit;
end;

//==============================================================================
function TMannschObj.GetGutschrift: Integer;
//==============================================================================
var i : Integer;
// default  0
begin
  Result := 0;
  if Wettk.MschWettk then
    for i:=0 to FTlnListe.Count-1 do with FTlnListe[i] do
      if Gutschrift > 0 then
        Result := Result + Gutschrift;
end;

{//==============================================================================
function TMannschObj.PflichtWkTeilnahme: Boolean;
//==============================================================================
// Teilnahme-Pflicht nur f�r Wettk die bereits stattgefunden haben
begin
  Result := false;
  if (FWettk = nil) or (FCollection = nil) then Exit;
  case FWettk.PflichtWkMode of
    pw1:
      if (GetRngSer(FWettk.PflichtWkOrt1Indx) > 0) or
         not TTlnColl(FCollection).OrtTlnGestartet(FWettk.PflichtWkOrt1Indx,
                            WettkAlleDummy,AkAlle) then
        Result := true;
    pw1v2:
      if (GetRngSer(FWettk.PflichtWkOrt1Indx) > 0) or
         not TTlnColl(FCollection).OrtTlnGestartet(FWettk.PflichtWkOrt1Indx,
                            WettkAlleDummy,AkAlle) or
         (GetRngSer(FWettk.PflichtWkOrt2Indx) > 0) or
         not TTlnColl(FCollection).OrtTlnGestartet(FWettk.PflichtWkOrt2Indx,
                            WettkAlleDummy,AkAlle) then
        Result := true;
    pw2:
      if ((GetRngSer(FWettk.PflichtWkOrt1Indx) > 0) or
          not TTlnColl(FCollection).OrtTlnGestartet(FWettk.PflichtWkOrt1Indx,
                            WettkAlleDummy,AkAlle)) and
          ((GetRngSer(FWettk.PflichtWkOrt2Indx) > 0) or
         not TTlnColl(FCollection).OrtTlnGestartet(FWettk.PflichtWkOrt2Indx,
                            WettkAlleDummy,AkAlle)) then
        Result := true;
    else Result := true; // pw0
  end;
end;}

//==============================================================================
function TMannschObj.SerWrtgSortZahl: Integer;
//==============================================================================
// bei swZeit FSerSumSort = ZeitSumme, Int64, Max = 22.233.568.000
// in Sek und Integer umwandeln (9 Stellen) , wegen Format-Funktion
begin
  Result := 0; // compiler-warnung vermeiden
  if TVeranstObj(FVPtr).Serie then
    case FWettk.SerWrtgMode[tmMsch] of
      swZeit:
        Result := (FSerSumSort + 50) DIV 100; // in Sek und Integer umwandeln
    swRngUpPkt,swRngUpEqPkt:
      Result := FSerSumSort;
    swRngDwnPkt,swRngDwnEqPkt:
      Result := seSerPktMax - FSerSumSort;
    swFlexPkt :
      if FWettk.CupPktIncr(tmMsch) then Result := FSerSumSort
                                   else Result := seSerPktMax - FSerSumSort;
  end;
end;

//==============================================================================
function TMannschObj.ObjSize: Integer;
//==============================================================================
begin
  Result := 2*cnSizeOfInteger +
            cnSizeOfString + 2*cnSizeOfBoolean + cnSizeOfPointer +
            FTlnListe.CollSize +
            FRngColl.CollSize +
            FRndColl.CollSize +
            FStreckenColl.CollSize +
            cnAbsZahlMax*FStZeitCollArr[wkAbs1].CollSize +
            cnAbsZahlMax*FZeitCollArr[wkAbs1].CollSize +
            FDisqColl.CollSize +
            FPunktColl.CollSize;
end;


(******************************************************************************)
(*             Methoden von TMannschColl                                      *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
function TMannschColl.GetBPObjType: Word;
//------------------------------------------------------------------------------
(* Object Types aus Version 7.4 Stream Registration Records *)
begin
  Result := rrMannschColl;
end;

//------------------------------------------------------------------------------
function TMannschColl.GetPItem(Indx:Integer): TMannschObj;
//------------------------------------------------------------------------------
begin
  Result := TMannschObj(inherited GetPItem(Indx));
end;

//------------------------------------------------------------------------------
procedure TMannschColl.SetPItem(Indx:Integer; Item:TMannschObj);
//------------------------------------------------------------------------------
begin
  inherited SetPItem(Indx,Item);
end;

//------------------------------------------------------------------------------
function TMannschColl.GetSortItem(Indx:Integer): TMannschObj;
//------------------------------------------------------------------------------
begin
  Result := TMannschObj(inherited GetSortItem(Indx));
end;

//------------------------------------------------------------------------------
function TMannschColl.GetReportCount: Integer;
//------------------------------------------------------------------------------
begin
  Result := FReportItems.Count;
end;

//------------------------------------------------------------------------------
function TMannschColl.GetReportItem(Indx:Integer): TReportMschObj;
//------------------------------------------------------------------------------
begin
  if (Indx>=0)and(Indx<FReportItems.Count) then
    Result := TReportMschObj(FReportItems[Indx])
  else Result := nil;
end;

// public Methoden

//==============================================================================
Constructor TMannschColl.Create(Veranst:Pointer; ItemClass:TTriaObjClass);
//==============================================================================
begin
  inherited Create(Veranst,ItemClass);
  FStepProgressBar := true;
  //FReportItems := TTriaSortList.Create(Self);
  //FStepMeldung := true;
  FReportItems := TReportMschList.Create;
  FSortItems.Duplicates := true;
  //FReportItems.Duplicates := false; (* keine gleiche Eintr�ge *)
  if FVPtr <> nil then FSortOrtIndex := TVeranstObj(FVPtr).OrtIndex
                  else FSortOrtIndex:= 0;
  FSortMode      := smNichtSortiert;
  FTlnSortMode   := smNichtSortiert;
  FTlnSortStatus := stKein;
  FSortWettk     := WettkAlleDummy;
  FSortKlasse    := AkAlle;  (* alle Altersklassen *)
  FSortStatus    := stGemeldet;
  FSortTlnColl   := smOhneTlnColl;
end;

//==============================================================================
destructor TMannschColl.Destroy;
//==============================================================================
begin
  FreeAndNil(FReportItems); // bei RemoveItem abgefragt
  inherited Destroy;
end;

//==============================================================================
function TMannschColl.SortString(Item:Pointer): String;
//==============================================================================
var Z   : Integer;
    Buf : Integer;
begin
  Result := ' ';
  if (Item = nil) or(TMannschObj(Item).FName = nil) or
     (TMannschObj(Item).FWettk = nil) then Exit;

  with TMannschObj(Item) do
  begin
    case FSortMode of
      smMschName,smMschErgMschName:
        Result := Format('%s  %u  %s  %s',
                         [FName^,FMschIndex,FWettk.Name,FKlasse.Name]);

      smMschTlnSnr,smMschTlnStartZeit:
        Result := Format('%4u  %s  %u  %s  %s',
                         [DummyTln.Snr,
                          FName^,FMschIndex,FWettk.Name,FKlasse.Name]);

      smMschAbs1Startzeit..smMschAbs8Startzeit:
        if GetAbsStZeit(TWkAbschnitt(Integer(FSortMode)-Integer(smMschAbs1Startzeit)+1)) >= 0 then
          Result := Format('%7d  %s  %u  %s  %s',
                           [GetAbsStZeit(TWkAbschnitt(Integer(FSortMode)-Integer(smMschAbs1Startzeit)+1)),
                            FName^,FMschIndex,FWettk.Name,FKlasse.Name])
        else Result := Format('    0  %s  %u  %s  %s',
                              [FName^,FMschIndex,FWettk.Name,FKlasse.Name]);

      smMschErg: // Platz-Wertung
      begin
        Z := TagesRng;
        if GetDisq then
          Result := Format('X  %s  %u  %s  %s',
                              [FName^,FMschIndex,FWettk.Name,FKlasse.Name])
        else if Z>0 then // TlnInStatus(stGewertet) >= FWettk.MannschGrWrtg
          Result := Format('A  %4u  %s  %u  %s  %s',
                           [Z,FName^,FMschIndex,FWettk.Name,FKlasse.Name])
        else if FWettk.WettkArt = waRndRennen then
          Result := Format('Y  %4u  %5u  %s  %u  %s  %s',
                           [cnTlnMax-TlnInStatus(stGewertet),cnRundenMax+1-Runden,
                            FName^,FMschIndex,FWettk.Name,FKlasse.Name])
        else if FWettk.WettkArt = waStndRennen then
          Result := Format('Y  %4u  %7u  %s  %u  %s  %s',
                           [cnTlnMax-TlnInStatus(stGewertet),cnStreckeMax+1-Strecken,
                            FName^,FMschIndex,FWettk.Name,FKlasse.Name])
        else
          Result := Format('Y  %4u  %s  %u  %s  %s',
                           [cnTlnMax-TlnInStatus(stGewertet),
                            FName^,FMschIndex,FWettk.Name,FKlasse.Name]);
      end;

      smMschTlnZeit: // f�r Zeit-Wertung (wmTlnZeit)
        if FWettk.WettkArt = waRndRennen then
        begin
          Z := GetEndZeit;
          if Z > 0 then // mindestens 1 Runde
            Result := Format('%5u %10u  %s  %u  %s  %s',
                             [cnRundenMax+1-Runden,Z,
                              FName^,FMschIndex,FWettk.Name,FKlasse.Name])
           else Result := Format('Z  %s  %u  %s  %s',
                                [FName^,FMschIndex,FWettk.Name,FKlasse.Name]);
        end else
        if FWettk.WettkArt = waStndRennen then  // Strecken-Wertung
        begin
          if Strecken > 0 then
            Result := Format('%7u  %s  %u  %s  %s',
                             [cnStreckeMax+1-Strecken,
                              FName^,FMschIndex,FWettk.Name,FKlasse.Name])
          else Result := Format('Z  %s  %u  %s  %s',
                                [FName^,FMschIndex,FWettk.Name,FKlasse.Name]);
        end else
        begin
          Z := GetEndZeit;
          if Z>0 then
            Result := Format('%10u  %s  %u  %s  %s',
                             [Z,FName^,FMschIndex,FWettk.Name,FKlasse.Name])
           else Result := Format('Z  %s  %u  %s  %s',
                                [FName^,FMschIndex,FWettk.Name,FKlasse.Name]);
        end;

      smMschTlnPlatz: // f�r Punkte-Wertung (wmTlnPlatz)
      begin
        Z := GetPunkte;
        if Z > 0 then
          Result := Format('%6u  %s  %u  %s  %s',
                          [Z,FName^,FMschIndex,FWettk.Name,FKlasse.Name])
        else Result := Format('Z  %s  %u  %s  %s',
                             [FName^,FMschIndex,FWettk.Name,FKlasse.Name]);
      end;

      smMschSchultour: // f�r DTU Schultour (wmSchultour)
      begin
        Z := cnMschPktMax - GetPunkte;
        if Z > 0 then
          Result := Format('%6u  %s  %u  %s  %s',
                          [Z,FName^,FMschIndex,FWettk.Name,FKlasse.Name])
        else Result := Format('Z  %s  %u  %s  %s',
                             [FName^,FMschIndex,FWettk.Name,FKlasse.Name]);
      end;

      smMschSerErg:
      begin
        if (FWettk.PunktGleichOrtIndx[tmMsch] >= 0) and
           (GetOrtRng(FWettk.PunktGleichOrtIndx[tmMsch]) > 0)
          then Buf := GetOrtRng(FWettk.PunktGleichOrtIndx[tmMsch])
          else Buf := cnTlnMax+1;
        if FSerieEndWertung then
          Result := Format('A %9u  %5u  %s  %u  %s  %s',
                           [SerWrtgSortZahl,Buf,
                            FName^,FMschIndex,FWettk.Name,FKlasse.Name])
        else
          Result := Format('B %9u  %5u  %s  %u  %s  %s',
                           [SerWrtgSortZahl,Buf,
                            FName^,FMschIndex,FWettk.Name,FKlasse.Name]);
      end;

      {smMschSerPkt: //Berechnung MschAbs1StZeit bei Liga-Jagdstart
        Result := Format('%5u  %s  %u  %s  %s',
                         [SerPktSort,
                          FName^,FMschIndex,FWettk.Name,FKlasse.Name]);}
    end;
  end;
end;

//==============================================================================
function TMannschColl.AddItem(Item: Pointer): Integer;
//==============================================================================
begin
  Result := inherited AddItem(Item);
  FReportItems.Capacity := FItems.Capacity;
  // MschModified wird hier nicht gesetzt, bei MschEinlesen nicht berechnen
end;

//==============================================================================
function TMannschColl.SortModeValid(Item: Pointer): Boolean;
//==============================================================================
// nur f�r Erstellung von Listen (Anzeige, Reports, UrkDruck, Export),
// nicht f�r Wertungen (dort FSortItems.Add benutzt)
var i : Integer;

//..............................................................................
procedure SetDummyTln(Msch:TMannschObj);
// muss nach TlnListe sortieren und vor AddSortItem
begin
  // DummyTln.Wettk = FWettk, immer gesetzt wenn FWettk gesetzt wird
  with Msch do
    with DummyTln do
    begin
      if FTlnListe.SortCount>0 then
      begin
        DummyTln.LoadPtr     := FTlnListe.SortItems[0];
        DummyTln.Staffelvorg := -1;
        SGrp                 := FTlnListe.SortItems[0].SGrp;
        SBhn                 := FTlnListe.SortItems[0].SBhn;
        Snr                  := FTlnListe.SortItems[0].Snr;
        CopyZeitRecCollArr(FTlnListe.SortItems[0]);
      end else
      begin
        DummyTln.LoadPtr     := DummyTln;
        DummyTln.Staffelvorg := -1;
        SGrp                 := nil;
        SBhn                 := 0;
        Snr                  := 0;
        ClearZeitRecCollArr; //  Startzeit,AbschnZeit = -1
      end;
      Name                   := cnDummyName; (* DummyTln als erste in Sortliste *)
      MannschNamePtr         := Msch.FName; // Name wird in Liste gebraucht
      //Status  := stkein;
      //Jg      := Veranstaltung.AkStrColl.GetJg(FSortKlasse);
      //Sex     := Veranstaltung.AkStrColl.GetSex(FSortKlasse);

      if (FWettk.WettkArt=waMschStaffel) and
         (FSortMode in [smMschAbs2Startzeit..smMschAbs8Startzeit]) then
        if (FTlnListe.SortCount >= Integer(FSortMode)-Integer(smMschAbs2Startzeit)+2) and
           // DummyTln in N. Abschnitt, nur wenn (N-1). Tln im Ziel =[N-2]
           FTlnListe.SortItems[Integer(FSortMode)-Integer(smMschAbs2Startzeit)].TlnInStatus(stImZiel) then
        begin
          // beim setzen von DummyTln darf dieser nicht aus TlnColl.SortItems
          // gel�scht werden, wenn gleicher Wert wieder gesetzt wird
          // Dies passiert beim ReportSortieren
          // Deshalb kein SortClear in TlnObj wenn Daten unver�ndert
          DummyTln.LoadPtr := FTlnListe.SortItems[Integer(FSortMode)-Integer(smMschAbs2Startzeit)+1];
          DummyTln.Staffelvorg :=
            TVeranstObj(FVPtr).TlnColl.IndexOf(FTlnListe.SortItems[Integer(FSortMode)-Integer(smMschAbs2Startzeit)]);
          SGrp := FTlnListe.SortItems[Integer(FSortMode)-Integer(smMschAbs2Startzeit)+1].SGrp;
          SBhn := FTlnListe.SortItems[Integer(FSortMode)-Integer(smMschAbs2Startzeit)+1].SBhn;
          Snr  := FTlnListe.SortItems[Integer(FSortMode)-Integer(smMschAbs2Startzeit)+1].Snr;
          CopyZeitRecCollArr(FTlnListe.SortItems[Integer(FSortMode)-Integer(smMschAbs2Startzeit)+1]);
        end else
          DummyTln.LoadPtr := DummyTln;
          
    end;
end;

//..............................................................................
begin
  Result := false;
  if (Item=nil) or (TMannschObj(Item).FName=nil) then Exit;

  with TMannschObj(Item) do // eine Msch vorhanden f�r jede Klasse
  begin
    // FTlnListe immer l�schen
    FTlnliste.SortMode := smNichtSortiert;
    FTlnListe.SortClear;

    case FSortMode of
      smNichtSortiert: Exit;

      smMschAbs2Startzeit..smMschAbs8Startzeit:
        if not TVeranstObj(FVPtr).SGrpColl.WettkJagdStartMannsch(FWettk,
                 TWkAbschnitt(Integer(FSortMode)-Integer(smMschAbs2Startzeit)+2))
        then Exit;

      {smMschErg:
        if (Msch.GetRngGes=0) and (FSortStatus=stGewertet) and
                             (Veranstaltung.Art<>vaLiga) then Exit;}
                             // wenn gar kein Tln imZiel, dann Tlnlist.Count=0
                             // und wird DummyTln nicht in TlnColl aufgenommen,
                             // damit auch nicht gelistet
      smMschSerErg: // Seriewertung
        case FSortStatus of
          stSerWertung    : if not FSerieWertung then Exit;
          stSerEndWertung : if not FSerieEndwertung then Exit;
          else // stGemeldet: alle Msch;
        end;
      else ;
    end;

    case FSortMode of
      smMschName,smMschTlnSnr,smMschTlnStartZeit,
      smMschAbs1Startzeit..smMschAbs8Startzeit:
      begin
        // Startliste
        if FMschIndex<>0 then Exit; // auch bei mwMulti nur f�r Msch 0
        // In ReportMode neu, aber gleich sortiert
        FTlnListe.Sortieren(TVeranstObj(FVPtr).OrtIndex,FTlnSortMode,
                                                 FWettk,FKlasse,FTlnSortStatus);
        Result := true;//SortItemHinzuFuegen(Item);
      end;
      smMschErg,smMschErgMschName:
      begin
        // Ergebnisliste
        // bei mwMulti nur FMschIndex>0 (=Multi-Mannschaften), sonst nur Msch 0
        if (FWettk.MschWertg <> mwEinzel) and (FMschIndex = 0) then Exit;
        FTlnListe.Sortieren(TVeranstObj(FVPtr).OrtIndex,FTlnSortMode,
                                                 FWettk,FKlasse,FTlnSortStatus);
        if (FSortStatus=stGewertet) and (FWettk.MschWrtgMode<>wmSchultour) then
        begin
          // nicht f�r Msch gewertete Tln l�schen, bei Schultour z�hlen alle
          for i:=FTlnListe.SortCount-1 downto FWettk.MschGroesse[FKlasse.Sex] do
            FTlnListe.ClearSortIndex(i);
            // Sortmode neu definieren, weil Tln nach Sortieren gel�scht wurden
          FTlnListe.SortMode := smMschErg; //existiert nicht f�r Tln
        end;
        Result := true;//SortItemHinzuFuegen(Item);
      end;
      smMschSerErg:
        if (FWettk.MschWertg = mwEinzel)or(FMschIndex>0) then
          Result := true;//SortItemHinzuFuegen(Item);

      {smMschSerPkt:
      begin
        FTlnListe.Sortieren(TVeranstObj(FVPtr).OrtIndex,FTlnSortMode,
                                                 FWettk,FKlasse,FTlnSortStatus);
        Result := true;//SortItemHinzuFuegen(Item); // nur f�r Liga/MschJagdSart
      end;}
    end;

    
    if Result then // TlnListe vorher sortiert
      SetDummyTln(TMannschObj(Item));  // immer setzen wegen Reportliste

    // 2006: Msch nur in Liste, wenn gen�gend Tln
    // 2009: wegen Live Zeiterfassung nur bei stGewertet eingeschr�nkt
    if (FSortStatus = stGewertet) and
       (FTlnListe.SortCount < FWettk.MschGroesse[FKlasse.Sex]) and
       (FWettk.MschWrtgMode <> wmSchultour) and
       (FSortMode <> smMschSerErg) then Result := false;
  end;
end;


//==============================================================================
function TMannschColl.AddSortItem(Item: Pointer): Integer;
//==============================================================================
// nur f�r Erstellung von Listen (Anzeige, Reports, UrkDruck, Export),
// nicht f�r Wertungen (dort FSortItems.Add benutzt)
var i : Integer;
begin
  with TMannschObj(Item) do
    if ((FSortWettk=WettkAlleDummy)or(FSortWettk=FWettk)) and
       MannschInKlasse(FSortKlasse) and
       SortModeValid(Item) then
    begin
      Result := FSortItems.Add(Item);
      if (Result >= 0) and
         (FVPtr=Veranstaltung) and (FSortTlnColl=smMitTlnColl) then
      with TMannschObj(Item) do
      begin
        // nur f�r Listen: MschTln in TlnSortColl einf�gen, TlnListe vorher sortiert
        // TlnColl.AddSortItem wegen Performance nicht verwenden
        if (HauptFenster.SortStatus = stKein) or
           (HauptFenster.Ansicht = anMschErgSerie) or
           (HauptFenster.Ansicht = anMschErgKompakt) then
          Veranstaltung.TlnColl.SortList.Add(DummyTln)
        else for i:=0 to FTlnListe.SortCount-1 do
          Veranstaltung.TlnColl.SortList.Add(FTlnListe.SortItems[i]);
      end;
    end
    else Result := -1;
end;

{//==============================================================================
procedure TMannschColl.ClearIndex(Indx: Integer);
//==============================================================================
// ClearIndex wird nur von MschEinlesen benutzt,
// FWettk.MschModified nicht setzen und MannschName nicht l�schen
var MannschName : PString;
begin
  if (Indx<0)or(Indx>=Count) then Exit;
  MannschName := GetPItem(Indx).FName;
  // ClearIndex wird nur von MschKlasseEinlesen benutzt
  // if (GetPItem(Indx).FWettk <> nil) and (MannschName <> nil) then
  //  GetPItem(Indx).FWettk.MschModified := true;

  inherited ClearIndex(Indx);

  // MannschName l�schen wenn nicht mehr benutzt
  if MannschName <> nil then
    TVeranstObj(FVPtr).MannschNameColl.NameLoeschen(MannschName^);
end;}

//==============================================================================
procedure TMannschColl.OrtCollExch(Idx1,Idx2:Integer);
//==============================================================================
begin
  if (Idx1<0) or (Idx1>TVeranstObj(FVPtr).OrtZahl-1) then Exit;
  if (Idx2<0) or (Idx2>TVeranstObj(FVPtr).OrtZahl-1) then Exit;
  inherited OrtCollExch(Idx1,Idx2);
end;

//==============================================================================
procedure TMannschColl.Sortieren(OrtIndexNeu:Integer; ModeNeu:TSortMode;
                                 WettkNeu:TWettkObj; AkNeu:TAkObj;
                                 StatusNeu:TStatus;
                                 SortTlnCollNeu:TMannschSortMode);
//==============================================================================
var i: integer;
begin
  // Mannsch immer sortieren, wegen TlnColl
  if not HauptFenster.ProgressBarStehenLassen then
    HauptFenster.ProgressBarInit('Mannschaften werden sortiert',FItems.Count);

  FSortOrtIndex := OrtIndexNeu;
  FSortMode     := ModeNeu;
  FSortWettk    := WettkNeu;
  FSortKlasse   := AkNeu;
  FSortStatus   := StatusNeu;
  FSortTlnColl  := SortTlnCollNeu;
  SortClear;

  case FSortMode of
    smMschName:
    begin
      FTlnSortMode := smTlnName;
      if FSortStatus<>stKein then FTlnSortStatus := FSortStatus
                             else FTlnSortStatus := stGemeldet;
    end;
    smMschTlnSnr:
    begin
      FTlnSortMode := smTlnSnr;
      if FSortStatus<>stKein then FTlnSortStatus := FSortStatus
                             else FTlnSortStatus := stGemeldet;
    end;

    smMschTlnStartZeit: // Msch nach Snr f�r StartListe, Tln nach StartZeit f�r SetStartzeit
    begin
      FTlnSortMode := smTlnAbs1StartZeit;
      if FSortStatus<>stKein then FTlnSortStatus := FSortStatus
                             else FTlnSortStatus := stGemeldet;
    end;

    smMschAbs1StartZeit:
    begin
      FTlnSortMode := smTlnAbs1StartZeit;
      if FSortStatus<>stKein then FTlnSortStatus := FSortStatus
                             else FTlnSortStatus := stGemeldet;
    end;

    smMschAbs2StartZeit..smMschAbs8StartZeit: // JagdStartMannsch
    begin
      if FSortWettk.WettkArt=waMschStaffel then
        FTlnSortMode := TSortMode(Integer(smRelAbs1UhrZeit)+WettkNeu.AbschnZahl-1) // letzter Abschnitt
      else
        FTlnSortMode := TSortMode(Integer(FSortMode)-Integer(smMschAbs2StartZeit) + Integer(smTlnAbs2StartZeit));
      FTlnSortStatus := stEingeteilt;
    end;

    smMschSerErg:
    begin
      FTlnSortMode   := smTlnMschSerErg;
      FTlnSortStatus := stGemeldet
    end;

    smMschErg,smMschErgMschName:
    begin
      if FSortWettk.MschWettk then
        FTlnSortMode := TSortMode(Integer(smRelAbs1UhrZeit)+FSortWettk.AbschnZahl-1)
      else
        FTlnSortMode := smTlnErg; // EinzelWettk
      FTlnSortStatus := FSortStatus;
    end;

    {smMschSerPkt:
    begin
      FTlnSortMode   := smTlnName; // nur f�r TlnListe
      FTlnSortStatus := stEingeteilt;
    end;}
  end;

  if (FVPtr=Veranstaltung) and (FSortTlnColl=smMitTlnColl) then
  begin
    Veranstaltung.TlnColl.SortClear;
    Veranstaltung.TlnColl.MschAkWrtg   := SortKlasse.Wertung;//TlnColl nach Msch sortiert
    // es werden nur die Tln aus TlnListe in TlnSortColl eingf�gt
    Veranstaltung.TlnColl.SortMode     := FTlnSortMode;
    Veranstaltung.TlnColl.SortWettk    := WettkAlleDummy;
    Veranstaltung.TlnColl.SortWrtgMode := wgStandWrtg;
    Veranstaltung.TlnColl.SortKlasse   := AkAlle;
    Veranstaltung.TlnColl.SortSMld     := nil;
    Veranstaltung.TlnColl.SortStatus   := FTlnSortStatus;
    Veranstaltung.TlnColl.SortOrtIndex := FSortOrtIndex;
  end;

  if (FSortWettk.MschWertg = mwKein) or
     (HauptFenster.Ansicht = anMschErgKompakt) and
     ((FSortWettk.MschWrtgMode = wmSchultour)or(FSortWettk.MschGroesse[FSortKlasse.Sex] > cnMschGrMaxKompakt)) then
  begin
    if FStepProgressBar then HauptFenster.ProgressBarStep(FItems.Count);
    Exit;
  end;

  if FSortItems.Capacity < FItems.Capacity then
    FSortItems.Capacity := FItems.Capacity;
  for i:=0 to FItems.Count-1 do
  begin
    AddSortItem(GetPItem(i));
    if FStepProgressBar then HauptFenster.ProgressBarStep(1);
  end;
  if (FVPtr=Veranstaltung) and (FSortTlnColl=smMitTlnColl) then
    Veranstaltung.TlnColl.MschAkWrtg := kwKein;
  if not HauptFenster.ProgressBarStehenLassen then
    HauptFenster.StatusBarClear;
end;

//==============================================================================
procedure TMannschColl.ReportSortieren;
//==============================================================================
// es werden nur ReportItems sortiert. SortMode, etc wie bei SortItems
// entsprechend in LstFrm dargestellte Liste
// f�r alle Wettk in ReportWkListe
var i,j,k : integer;
begin
  FReportItems.Clear;
  if FSortTlnColl=smMitTlnColl then
    Veranstaltung.TlnColl.ReportTlnlist.Clear;

  for i:=0 to FItems.Count-1 do
  begin
    if SortModeValid(GetPItem(i)) then
      for j:=0 to ReportWkListe.Count-1 do
      with TReportWkObj(ReportWkListe[j]) do
        if (Wettk=WettkAlleDummy) or (Wettk=GetPItem(i).FWettk) then
          for k:=0 to ReportAkListe.Count-1 do
            if GetPItem(i).MannschInKlasse(ReportAkListe[k]) then
            begin
              FReportItems.Add(GetPItem(i));
              Break; // nur eine Klasse ist g�ltig pro Mannschaft
            end;
    if FStepProgressBar then HauptFenster.ProgressBarStep(1); // MeldungInit vorher
  end;
end;

//==============================================================================
procedure TMannschColl.ReportSortieren(WkNeu:TWettkObj);
//==============================================================================
// es werden nur ReportItems sortiert. SortMode, etc wie bei SortItems
// entsprechend in LstFrm dargestellte Liste
// nur wgStandWrtg
var i,k : integer;
begin
  FReportItems.Clear;
  if FSortTlnColl=smMitTlnColl then
    Veranstaltung.TlnColl.ReportTlnlist.Clear;

  for i:=0 to FItems.Count-1 do
  begin
    if SortModeValid(GetPItem(i)) and
      ((WkNeu=WettkAlleDummy) or (WkNeu=GetPItem(i).FWettk)) then
        for k:=0 to ReportAkListe.Count-1 do
          if GetPItem(i).MannschInKlasse(ReportAkListe[k]) then
          begin
            FReportItems.Add(GetPItem(i));
            Break; // nur eine Klasse ist g�ltig pro Mannschaft
          end;
    if FStepProgressBar then HauptFenster.ProgressBarStep(1); // MeldungInit vorher
  end;
end;

//==============================================================================
procedure TMannschColl.ReportSortieren(WkNeu:TWettkObj;AkNeu:TAkObj);
//==============================================================================
// es werden nur ReportItems sortiert. SortMode, etc wie bei SortItems
// entsprechend in LstFrm dargestellte Liste
// nur wgStandWrtg
var i : integer;
begin
  FReportItems.Clear;
  if FSortTlnColl=smMitTlnColl then
    Veranstaltung.TlnColl.ReportTlnlist.Clear;

  for i:=0 to FItems.Count-1 do
  begin
    if SortModeValid(GetPItem(i)) and
       ((WkNeu=WettkAlleDummy) or (WkNeu=GetPItem(i).FWettk)) and
       GetPItem(i).MannschInKlasse(AkNeu) then
      FReportItems.Add(GetPItem(i));
    if FStepProgressBar then HauptFenster.ProgressBarStep(1); // MeldungInit vorher
  end;
end;

//==============================================================================
procedure TMannschColl.ReportClear;
//==============================================================================
begin
  FReportItems.Clear;
end;

//==============================================================================
procedure TMannschColl.SetzeRang(WertungsWk:TWettkObj);
//==============================================================================
// SortColl enth�lt Mannschaften in richtige Reihenfolge
// Loop getrennt pro Wertungsklasse
// keine unterschiedliche Werte f�r Tages- und Serienwertung
var i,
    RangBuff,
    MschZahl,
    SumBuff,
    RndBuff,
    StreckenBuff,
    Zeit         : Integer;
    MschKlasse   : TAkObj;
begin
  SumBuff      := 0;
  RndBuff      := 0;
  StreckenBuff := 0;
  RangBuff     := 0;
  MschZahl     := 0;

  for i:=0 to SortCount-1 do
    with GetSortItem(i) do
      begin
        SetRng(0);
        if not GetDisq then
        begin
          Inc(MschZahl);
          // Platzierungen berechnen
          if WertungsWk.MschWrtgMode = wmTlnZeit then
          begin
            // Zeitgleichheiten ber�cksichtigen
            Zeit := GetEndZeit;
            if (WertungsWk.WettkArt<>waStndRennen)and
                 ((Zeit<>SumBuff)or(WertungsWk.WettkArt=waRndRennen)and(Runden<>RndBuff)) or
               (WertungsWk.WettkArt=waStndRennen)and(Strecken<>StreckenBuff) then
            begin
              SumBuff      := Zeit;
              RndBuff      := Runden;
              StreckenBuff := Strecken; // nur Stundenrennen
              RangBuff     := MschZahl;
            end;
            if (SumBuff>0) or (StreckenBuff>0) then SetRng(RangBuff);
          end else // wmTlnPlatz, wmSchultour
          begin
            // Punktgleichheiten ber�cksichtigen
            if GetPunkte<>SumBuff then
            begin
              SumBuff  := GetPunkte;
              RangBuff := MschZahl;
            end;
            if SumBuff>0 then SetRng(RangBuff)
          end;
        end;
      end;

  if SortCount > 0 then
  begin
    MschKlasse := GetSortItem(0).Klasse;
    WertungsWk.SetSerRngMax(tmMsch,MschKlasse,MschZahl);
  end;

end;

//==============================================================================
procedure TMannschColl.SetzeStaffelVorg(WertungsWk:TWettkObj);
//==============================================================================
// Staffelwertung nur �ber alle Klassen und nur f�r Staffelwettkampf
// vor SetzeMschAbsStZeit(AbsCnt,WertungsWk) und SetzeMschAbsZeit(AbsCnt,WertungsWk);
// nur eine Wertung pro Mannschaft
// nur pro EinzelWettk
var i,j          : Integer;
    FinisherZahl : Integer;
    TlnBuff      : TTlnObj;
begin
  // Staffelvorg. f�r alle Wettk-Arten zur�cksetzen
  for i:=0 to Count-1 do with GetPItem(i) do
    if FWettk=WertungsWk then
      for j:=0 to FTlnListe.Count - 1 do
        FTlnListe[j].StaffelVorg := -1;

  // nur f�r waMschStaffel neu definieren
  if WertungsWk.WettkArt = waMschStaffel then
    for i:=0 to Count-1 do with GetPItem(i) do
    begin
      if (FWettk=WertungsWk) and (FKlasse=AkAlle) then
      begin
        // Tln nach EndUhrzeit rel. zur SGrp.Startzeit/EinzelStartzeit sortieren,wegen Tages�bergang
        // MschAbsStZeiten noch nicht gesetzt
        // bei EinzelStart (Abs1) Tln mit EinzelStartzeit nach Sortieren vor Tln ohne Startzeit
        FTlnliste.SortMode := smNichtSortiert; // immer sortieren
        FTlnListe.Sortieren(TVeranstObj(FVPtr).OrtIndex,
                            TSortMode(Integer(smRelAbs1UhrZeit)+WertungsWk.AbschnZahl-1),
                            WertungsWk,AkAlle,stEingeteilt);
        FinisherZahl := 0;
        TlnBuff := nil;  // um Warning zu vermeiden
        for j:=0 to FTlnListe.SortCount-1 do
          with FTlnListe.SortItems[j] do
            // nur Uhrzeit pr�fen, weil Startzeiten ohne Staffelvorg noch nicht g�ltig sind
            // auch disq. Tln und ung�ltige Endzeiten ber�cksicht
            if StoppZeit < 0 then Break
            else
            begin
              Inc(FinisherZahl);
              (* Set Staffelvorg�nger f�r alle Tln *)
              if FinisherZahl=1 then // 1. StaffelTln
              begin
                TlnBuff := FTlnListe.SortItems[j]; // eigen Index f�r 1. Tln.
                StaffelVorg := TVeranstObj(FVPtr).TlnColl.IndexOf(TlnBuff);
              end
              else // auch f�r > MannschGrWrtg (nur wegen Einzelwertung)
              begin
                // TlnBuff beim vorigen Durchlauf gesetzt
                StaffelVorg := TVeranstObj(FVPtr).TlnColl.IndexOf(TlnBuff);
                TlnBuff := FTlnListe.SortItems[j];
              end;
            end;
      end;
    end;
  if FStepProgressBar then HauptFenster.ProgressBarStep(Count);
end;


//==============================================================================
procedure TMannschColl.MannschWkWertung(WertungsWk:TWettkObj);
//==============================================================================
// Wertung f�r Msch-Wettk�mpfe (Team,Staffel)
// nur eine Wertung pro Mannschaft
// nur f�r akAlle
// Tln-Gutschrift, Tln-Strafzeit und Tln-disqual. gilt f�r Mannschaft
// Alle Abszeiten vorher gesetzt, ohne Gutschrift und Strafzeit
var i,j     : Integer;
    Msch    : TMannschObj;
    Zeit,
    StrZeit,
    Gutschr : Integer;
begin
  FSortOrtIndex := TVeranstObj(FVPtr).OrtIndex;
  FSortMode     := smMschTlnZeit;
  FSortWettk    := WertungsWk;
  FSortKlasse   := AkAlle;
  FSortStatus   := stImZiel;
  FSortTlnColl  := smOhneTlnColl;

  SortClear;
  for i:=0 to Count-1 do
  begin
    if FStepProgressBar then HauptFenster.ProgressBarStep(1);
    Msch := GetPItem(i);
    with Msch do
    begin
      if (FWettk=WertungsWk) and (FKlasse=AkAlle) then
      begin
        SetRng(0);
        SetDisq(false);
        Runden   := 0;
        Strecken := 0; // Msch-Wettk�mpfe nicht als Stundenrennen

        // Msch disqualifizieren, wenn einer der Tln disq. wurde
        for j:=0 to FTlnListe.Count-1 do with FTlnListe[j] do
          if TlnInStatus(stDisqualifiziert) then
          begin
            SetDisq(true);
            Break;
          end;

        if (GetEndZeit > 0) and not GetDisq then
        begin
          // Strafzeiten und Gutschriften aller Tln zu letzter Abszeit addieren
          StrZeit := Max(0,GetStrafZeit); // default -1
          Gutschr := GetGutschrift;       // default 0
          Zeit := GetAbsZeit(TWkAbschnitt(WertungsWk.AbschnZahl)); // Zeit > 0
          if Zeit + StrZeit > Gutschr then
            SetAbsZeit(TWkAbschnitt(WertungsWk.AbschnZahl),Zeit + StrZeit - Gutschr);
          // Msch in SortColl einf�gen um Rang zu berechnen in SetzeRang
          if FTlnListe.TlnGewertet(FWettk) >= FWettk.MschGroesse[FKlasse.Sex] then
            FSortItems.Add(Msch);
        end;
      end;
    end;
  end;
  SetzeRang(WertungsWk);
end;

//==============================================================================
procedure TMannschColl.EinzelWkWertung(WertungsWk:TWettkObj;WertungsAk:TAkObj);
//==============================================================================
// Wertung f�r waEinzel,waRndRennen,waStndRennen, keine Wertung bei waTlnStaffel oder waTlnTeam
// Wertung durch Zeitaddition der Teilnehmerzeiten, inkl. Strafzeiten
// oder Platz-Addition
// Mannschaftswertung gilt f�r Tages- und Serienwertung.
// SerienTln von Mannschaft und Tln gleich, d.h. TlnListe gilt f�r beide
// Wertungen und damit Gesamtzeitgleich
// mehrere Wertungen pro Mannschaft m�glich
// Alle Abszeiten vorher = 0 gesetzt
// Gesamtzeit wird hier gespeichert in letzter g�ltiger Abschnitt
// disqual. Tln nicht ber�cksichtigt
var i,j,
    ZeitSumme,
    RndSumme,
    StreckenSumme,
    PktSumme,
    Buf       : Integer;
    Msch      : TMannschObj;

//..............................................................................
function DTUSchultourPunkte(Platz:Integer): Integer;
//..............................................................................
begin
  if Platz < 1 then Result := 0
  else
  case Platz of
    1: Result := 4;
    2: Result := 3;
    3: Result := 2;
    else Result := 1;
  end;
end;

//..............................................................................
begin
  FSortOrtIndex := TVeranstObj(FVPtr).OrtIndex;
  case WertungsWk.MschWrtgMode of
    wmTlnZeit   : FSortMode := smMschTlnZeit;
    wmTlnPlatz  : FSortMode := smMschTlnPlatz;
    wmSchultour : FSortMode := smMschSchultour;
  end;
  FSortWettk    := WertungsWk;
  FSortKlasse   := WertungsAk;
  FSortStatus   := stImZiel;
  FSortTlnColl  := smOhneTlnColl;
  SortClear;

  for i:=0 to Count-1 do
  begin
    if FStepProgressBar then HauptFenster.ProgressBarStep(1);
    Msch := GetPItem(i);
    with Msch do
      if (FWettk=WertungsWk) and (FKlasse=WertungsAk) then
      begin
        SetRng(0);
        SetDisq(false);
        SetAbsZeit(TWkAbschnitt(WertungsWk.AbschnZahl),0);
        Runden   := 0;
        Strecken := 0; // auch Stundenrennen
        SetPunkte(0);

        if (FWettk.MschWertg = mwEinzel) or (FMschIndex > 0) then
        begin
          ZeitSumme     := 0;
          RndSumme      := 0;
          StreckenSumme := 0;
          PktSumme      := 0;
          // Tln nach Endzeit+Strafzeit sortiert
          FTlnListe.SortMode := smNichtSortiert; // immer sortieren
          FTlnListe.Sortieren(TVeranstObj(FVPtr).OrtIndex,smTlnEndZeit,
                                FWettk,FKlasse,stGewertet);
          // Zeit-oder Punkte-ergebnis setzen
          case FWettk.MschWrtgMode of
            wmTlnZeit:
              if FTlnListe.SortCount >= FWettk.MschGroesse[FKlasse.Sex] then
              begin
                // Tln>MannschGrWrt spielen keine Rolle
                for j:=0 to FWettk.MschGroesse[FKlasse.Sex] - 1 do
                with FTlnListe.SortItems[j] do
                begin
                  Buf := EndZeit;
                  if (Buf>=0)and(ZeitSumme>=0) then ZeitSumme := ZeitSumme + Buf
                                               else ZeitSumme := -1;
                  if FWettk.WettkArt = waRndRennen then
                    RndSumme := RndSumme + RundenZahl(wkAbs1)
                  else
                  if FWettk.WettkArt = waStndRennen then
                    StreckenSumme := StreckenSumme + Gesamtstrecke;
                end;
                SetAbsZeit(TWkAbschnitt(WertungsWk.AbschnZahl),ZeitSumme);//letzte Zeit gilt
                Runden   := RndSumme;
                Strecken := StreckenSumme;
                // gewertete Msch in SortColl einf�gen um Rang zu berechnen in SetzeRang
                if (ZeitSumme > 0) or (StreckenSumme > 0) then FSortItems.Add(Msch);
              end;

            wmTlnPlatz:
              if FTlnListe.SortCount >= FWettk.MschGroesse[FKlasse.Sex] then
              begin
                // Tln>MannschGrWrt spielen keine Rolle
                for j:=0 to FWettk.MschGroesse[FKlasse.Sex] - 1 do
                with FTlnListe.SortItems[j] do
                begin
                  Buf := TagesRng(wkAbs0,FKlasse.Wertung,wgMschPktWrtg);
                  if Buf>0 then PktSumme := PktSumme + Buf
                           else PktSumme := 0; // alle Tln m�ssen g�ltige Platzierung haben
                end;
                SetPunkte(PktSumme); // letzter Wert gilt
                // gewertete Msch in SortColl einf�gen um Rang zu berechnen in SetzeRang
                if PktSumme > 0 then FSortItems.Add(Msch);
              end;

            wmSchultour:
              begin
                // alle gewertete Tln werden ber�cksichtigt, unabh�ngig MannschGrWrtg
                for j:=0 to FTlnListe.SortCount-1 do
                with FTlnListe.SortItems[j] do
                  PktSumme := PktSumme + DTUSchultourPunkte(TagesRng(wkAbs0,FKlasse.Wertung,wgMschPktWrtg));
                SetPunkte(PktSumme); // letzter Wert gilt
                // gewertete Msch in SortColl einf�gen um Rang zu berechnen in SetzeRang
                if PktSumme > 0 then FSortItems.Add(Msch);
              end;

          end;
        end;
      end;
  end;

  SetzeRang(WertungsWk);
end;

//==============================================================================
procedure TMannschColl.MannschWertung(WertungsWk:TWettkObj);
//==============================================================================
(* Mannschaftswertung f�r Tages- und Serienwertung *)
(* SerienTln von Mannschaft und Tln gleich, d.h. TlnListe f�r beide
   Wertungen und damit Gesamtzeitgleich *)
// nur einzeln pro Wettkampf
var i : Integer;

begin
  if WertungsWk.MschWettk then
    MannschWkWertung(WertungsWk) // waMschStaffel,waMschTeam nur f�r AkAlle
  else // waEinzel,waRndRennen,waStndRennen, keine MschWertung bei waTlnStaffel,waTlnTeam
  begin
    EinzelWkWertung(WertungsWk,AkAlle);
    EinzelWkWertung(WertungsWk,WertungsWk.MaennerKlasse[tmMsch]);
    EinzelWkWertung(WertungsWk,WertungsWk.FrauenKlasse[tmMsch]);
    EinzelWkWertung(WertungsWk,AkMixed);
    with Veranstaltung do with WertungsWk do
    begin
      for i:=0 to AltMKlasseColl[tmMsch].Count-1 do
        EinzelWkWertung(WertungsWk,AltMKlasseColl[tmMsch][i]);
      for i:=0 to AltWKlasseColl[tmMsch].Count-1 do
        EinzelWkWertung(WertungsWk,AltWKlasseColl[tmMsch][i]);
    end;
  end;
end;

//==============================================================================
function TMannschColl.MannschDefiniert(WertungsWk:TWettkObj): Boolean;
//==============================================================================
var i : integer;
begin
  Result := false;
  for i:=0 to Count-1 do
    if GetPItem(i).FWettk = WertungsWk then
    begin
      Result := true;
      Exit;
    end;
end;

//==============================================================================
function TMannschColl.SucheMannschaft(Msch:PString;Wk:TWettkObj;Kl:TAkObj;
                                      Indx:Integer):TMannschObj;
//==============================================================================
(* nur nach dieser Methode unterschiedliche Obj werden in Coll aufgenommen *)
(* bei Compare werden diese Kriterien immer benutzt *)
var i : Integer;
    M : TMannschObj;
begin
  Result := nil;
  if Msch = nil then Exit;
  for i:=0 to Count-1 do
  begin
    M := GetPItem(i);
    if (M.FMschIndex=Indx)and(M.FName=Msch)and(M.FWettk=Wk)and(M.FKlasse=Kl) then
    begin
      Result := M;
      Exit;
    end;
  end;
end;

//==============================================================================
function TMannschColl.MschAnzahl(Wk:TWettkObj;Kl:TAkObj):Integer;
//==============================================================================
// f�r Anzeige StatusBar
// Msch nur z�hlen wenn gen�gend Tln gemeldet
// mwMulti ignorieren, immer nur eine Msch z�hlen
// bei mwMulti immer alle Tln in jede Msch, nur in SortColl richtige Tln
var i : Integer;
begin
  Result := 0;
  for i:=0 to Count-1 do with GetPItem(i) do
    if ((FWettk=Wk)or(Wk=WettkAlleDummy)) and
        MannschInKlasse(Kl) and (FMschIndex=0) and
       ((FTlnListe.TlnZahl(Wk,wgStandWrtg,Kl,stGemeldet)>=FWettk.MschGroesse[Kl.Sex])or
        (FWettk.MschWrtgMode = wmSchultour)) then
      Inc(Result);
end;

//==============================================================================
function TMannschColl.TagesRngMax(Wk:TWettkObj;Kl:TAkObj): Integer;
//==============================================================================
// f�r AusgDlg
var i : Integer;
begin
  Result := 0;
  for i:=0 to Count-1 do with GetPItem(i) do
    if ((FWettk=Wk)or(Wk=WettkAlleDummy)) and
       //((FKlasse=Kl)or(Kl=AkAlle)) and
       MannschInKlasse(Kl) and
       ((FWettk.MschWertg=mwEinzel)and(FMschIndex=0)or
        (FWettk.MschWertg=mwMulti)and(FMschIndex>0)) and
         (TagesRng > Result) then
      Result := TagesRng;
end;

//==============================================================================
function TMannschColl.SerieRngMax(Wk:TWettkObj;Kl:TAkObj): Integer;
//==============================================================================
// f�r AusgDlg
var i : Integer;
begin
  Result := 0;
  for i:=0 to Count-1 do with GetPItem(i) do
    if ((FWettk=Wk)or(Wk=WettkAlleDummy)) and
       //((FKlasse=Kl)or(Kl=AkAlle)) and
       MannschInKlasse(Kl) and
       ((FWettk.MschWertg=mwEinzel)and(FMschIndex=0)or
        (FWettk.MschWertg=mwMulti)and(FMschIndex>0)) and
         (FSerieRang > Result) then
      Result := FSerieRang;
end;

//==============================================================================
procedure TMannschColl.SerieWertung(WertungsWk:TWettkObj);
//==============================================================================
// Berechnung SeriePunkte und SerieRang f�r alle WertungsKlassen
// Nur pro Einzel-Wettk

type TIndx=(ixRngZahl,ixRngBuff,ixPktBuff,ixOrtRngBuff);

var Msch    : TMannschObj;
    WrtgArr : array of array of array of Int64;

const
  cnDim1=4; //ixRngZahl,ixRngBuff,ixPktBuff,ixOrtRngBuff
  // cnDim2 wird in TlnErg berechnet, max KlasseColl.Count
  cnDim3=3; //Sex: cnMaennlich, cnWeiblich, cnMixed

//------------------------------------------------------------------------------
procedure ClearWrtgArr;
// WrtgArr initialisieren
var j,k,m : integer;
begin
  for j:=0 to cnDim1-2 do
    for k:=0 to WertungsWk.MschAkZahlMax-1 do
      for m:=0 to cnDim3-1 do WrtgArr[j,k,m] := 0;
  for k:=0 to WertungsWk.MschAkZahlMax-1 do
    for m:=0 to cnDim3-1 do WrtgArr[Integer(ixOrtRngBuff)-1,k,m] := cnTlnMax;
end;

//------------------------------------------------------------------------------
procedure SetzeSerieRang(const AkWrtg:TKlassenWertung);
// wird pro Msch f�r alle AkWrtg einzeln ausgef�hrt:
// AkWrtg = kwAlle,kwSex,kwAltKl (kein kwSondKl)
var KlasseIndx,SexIndx : Integer;
begin
  if Msch=nil then Exit;
    if (AkWrtg=kwAlle) or (Msch.Klasse.Sex=cnMaennlich) then SexIndx := 0
    else if Msch.Klasse.Sex=cnWeiblich then SexIndx := 1
    else if (AkWrtg=kwSex)and(Msch.Klasse.Sex=cnMixed) then SexIndx := 2
    else SexIndx := -1; // cnKeinSex kommt bei Msch nicht vor

  // Setze KlasseIndx
  case AkWrtg of
    kwAlle:
      KlasseIndx := 0;
    kwSex:
      if SexIndx >= 0 then KlasseIndx := 0
                      else KlasseIndx := -1;
    kwAltKl:
      case SexIndx of
        0: KlasseIndx := WertungsWk.AltMKlasseColl[tmMsch].IndexOf(Msch.Klasse);
        1: KlasseIndx := WertungsWk.AltWKlasseColl[tmMsch].IndexOf(Msch.Klasse);
        else KlasseIndx := -1;
      end;
    else KlasseIndx := -1;
  end;

  if KlasseIndx >= 0 then
  begin
    Inc(WrtgArr[Integer(ixRngZahl),KlasseIndx,SexIndx]); // RangZahl jedesmal erh�ht
    if Msch.FSerSumSort <> WrtgArr[Integer(ixPktBuff),KlasseIndx,SexIndx] then
    begin
      WrtgArr[Integer(ixPktBuff),KlasseIndx,SexIndx] := Msch.FSerSumSort;
      WrtgArr[Integer(ixRngBuff),KlasseIndx,SexIndx] :=
                          WrtgArr[Integer(ixRngZahl),KlasseIndx,SexIndx];
      if WertungsWk.PunktGleichOrtIndx[tmMsch] >= 0 then // Wertung bei Punktgleichheit
        WrtgArr[Integer(ixOrtRngBuff),KlasseIndx,SexIndx] :=
                                  Msch.GetOrtRng(WertungsWk.PunktGleichOrtIndx[tmMsch]);
    end else
      if WertungsWk.PunktGleichOrtIndx[tmMsch] >= 0 then
        // jetzt gilt Wertung in ausgew�hltem Ort
        if WrtgArr[Integer(ixOrtRngBuff),KlasseIndx,SexIndx] <>
                              Msch.GetOrtRng(WertungsWk.PunktGleichOrtIndx[tmMsch]) then
        begin
          WrtgArr[Integer(ixRngBuff),KlasseIndx,SexIndx] :=
                 WrtgArr[Integer(ixRngZahl),KlasseIndx,SexIndx];
          WrtgArr[Integer(ixOrtRngBuff),KlasseIndx,SexIndx] :=
                                  Msch.GetOrtRng(WertungsWk.PunktGleichOrtIndx[tmMsch]);
        end; // Wertung gleich wie Vorg�nger
    Msch.FSerieRang := WrtgArr[Integer(ixRngBuff),KlasseIndx,SexIndx];
  end;
end;

//------------------------------------------------------------------------------
procedure KlassenWertung(AkWrtg:TKlassenWertung);
// Berechnung SerieSumme und SerieRang pro Wertungsklasse
// AkWrtg muss nacheinander getrennt erfolgen, weil Sortierung Msch unterschiedlich ist
var i: Integer;
begin
  SortClear;
  for i:=0 to Count-1 do
  begin
    Msch := GetPItem(i);
    with Msch do
      if (WertungsWk = FWettk) and // Seriewertung nur pro Einzel-Wettk
         (Klasse.Wertung = AkWrtg) and // f�r jede Wertung wird Msch definiert
         ((FWettk.MschWertg=mwEinzel)or(FMschIndex>0)) then
      begin
        BerechneSerieSumme;
        FSerieRang := 0;
        if FSerieEndWertung then FSortItems.Add(Msch); //schneller als AddSortItem
      end;
    if FStepProgressBar then HauptFenster.ProgressBarStep(1);
  end;
  ClearWrtgArr;
  for i:=0 to FSortItems.Count-1 do
  begin
    Msch := GetSortItem(i);
    if Msch.FSerSumSort > 0 then SetzeSerieRang(AkWrtg);
  end;
end;

//------------------------------------------------------------------------------
// Begin Haupt-Procedure
begin
  if not TVeranstObj(FVPtr).Serie then Exit;

  FSortOrtIndex := TVeranstObj(FVPtr).OrtIndex;
  FSortMode     := smMschSerErg; //SerieSumme + OrtGleichRng
  FSortWettk    := WertungsWk;
  FSortKlasse   := AkAlle;
  FSortStatus   := stGemeldet;
  FSortTlnColl  := smOhneTlnColl;

  try
    // 3-dimensionales dynamisches Array WrtgArr anlegen
    SetLength(WrtgArr,cnDim1,WertungsWk.MschAkZahlMax,cnDim3);
    KlassenWertung(kwAlle);
    KlassenWertung(kwSex);
    KlassenWertung(kwAltKl);

  finally
    WrtgArr := nil;
  end;
end;

//==============================================================================
procedure TMannschColl.MschEinlesen(EinlWettk:TWettkObj);
//==============================================================================
// nur in TlnErg aufgerufen, wenn MschModified gesetzt ist
// wird bei Serie nur 1x, f�r OrtAktuell, aufgerufen
// f�r jede Wertungsklasse wird eigene Msch definiert, wenn gen�gend Tln gemeldet
var i,j,k       : Integer;
    MschGrAlle,MschGrMaenner,MschGrFrauen,MschGrMixed : Integer;
    TlnZahlArr,
    MschZahlArr : array of array of array of Integer; //0:AkWrtg,1:AkIndex,2:Sex
    MschName    : PString;
    MschTlnLst  : TList;
const
  cnDim0=3; //KlassenWertung: kwAlle,kwSex,kwAltKl
  // cnDim1 wird berechnet, max KlasseColl.Count
  cnDim2=3; //Sex: cnMaennlich, cnWeiblich, cnMixed

//------------------------------------------------------------------------------
procedure ClearZahlArr;
// TlnZahlArr,MschZahlArr initialisieren
var i,j,k : integer;
begin
  for i:=0 to cnDim0-1 do
    for j:=0 to EinlWettk.MschAkZahlMax-1 do
      for k:=0 to cnDim2-1 do
  begin
    TlnZahlArr[i,j,k] := 0;
    MschZahlArr[i,j,k] := 0;
  end;
end;

//------------------------------------------------------------------------------
procedure AddMschToColl(Klasse:TAkObj;MschZahl:Integer);
var j,k    : Integer;
    Mschj,Msch0   : TMannschObj;
begin
  Msch0 := TMannschObj.Create(FVPtr,Self,oaAdd);
  Msch0.Init(MschName^,EinlWettk,Klasse,0); // MschIndx = 0
  AddItem(Msch0);

  with Msch0 do
    for j:=0 to MschTlnLst.Count-1 do
      if TTlnObj(MschTlnLst[j]).TlnInKlasse(Klasse,tmMsch) then
        FTlnListe.AddItem(MschTlnLst[j]);

  if EinlWettk.MschWertg = mwMulti then
    for j:=1 to MschZahl do
    begin
      // MschIndx = j
      Mschj := TMannschObj.Create(FVPtr,Self,oaAdd);
      Mschj.Init(MschName^,EinlWettk,Klasse,j);
      AddItem(Mschj);
      if j=1 then Msch0.Msch1 := Mschj; // Pointer f�r WordUrk
      for k:=0 to Msch0.FTlnListe.Count-1 do
        Mschj.FTlnListe.AddItem(Msch0.FTlnListe[k]); // ge�ndert 11.5.5
    end;
end;

//------------------------------------------------------------------------------
begin
  with EinlWettk do
  begin

  // zuerst alle Msch f�r Wettk l�schen
  for i := Veranstaltung.MannschColl.Count-1 downto 0 do
    if Veranstaltung.MannschColl[i].Wettk = EinlWettk then
      Veranstaltung.MannschColl.ClearIndex(i);

  if (MschWertg = mwKein) or
     (Veranstaltung.TlnColl.WettkTlnZahl(EinlWettk) = 0) then Exit;

  // und dann neu einlesen
  // immer erste Mannschaft einlesen (FMschIndex=0)
  // bei wmMulti werden weitere Mannschaften mit FMschIndex > 0 eingelesen
  // wobei FMschIndex=1 beginnt bei erste Tln, also immer da ist
  // wegen Serienwertung alle Msch und deshalb alle gemeldete Tln ber�cksichtigen

  try
    // 3-dimensionales dynamisches Array TlnZahlArr,MschZahlArr anlegen
    SetLength(TlnZahlArr,cnDim0,MschAkZahlMax,cnDim2);
    SetLength(MschZahlArr,cnDim0,MschAkZahlMax,cnDim2);
    MschTlnLst := TList.Create;
    for i:=0 to TVeranstObj(FVPtr).MannschNameColl.Count-1 do
    begin
      MschName := TVeranstObj(FVPtr).MannschNameColl[i];
      ClearZahlArr;
      {for j:=0 to 3 do
      begin
        TlnZahl[j] := 0;
        MschZahl[j] := 0;
      end;}
      MschTlnLst.Clear;
      // Liste aller MschTln erstellen, f�r alle Klassen
      for j:=0 to TVeranstObj(FVPtr).TlnColl.Count-1 do
        if (TVeranstObj(FVPtr).TlnColl[j].MannschNamePtr = MschName) and
           (TVeranstObj(FVPtr).TlnColl[j].Wettk=EinlWettk) and
            TVeranstObj(FVPtr).TlnColl[j].MschWrtg and
           (not TVeranstObj(FVPtr).Serie or TVeranstObj(FVPtr).TlnColl[j].SerienWrtg) {and
           not TVeranstObj(FVPtr).TlnColl[j].AusserKonkurrenz} then  // 2008
        begin
          MschTlnLst.Add(TVeranstObj(FVPtr).TlnColl[j]);
          if TVeranstObj(FVPtr).TlnColl[j].MschMixWrtg then
            Inc(TlnZahlArr[Integer(kwSex),0,Integer(cnMixed)])
          else
          if TVeranstObj(FVPtr).TlnColl[j].Sex = cnMaennlich then
            Inc(TlnZahlArr[Integer(kwSex),0,Integer(cnMaennlich)])
          else
          if TVeranstObj(FVPtr).TlnColl[j].Sex = cnWeiblich then
            Inc(TlnZahlArr[Integer(kwSex),0,Integer(cnWeiblich)]);

          if TVeranstObj(FVPtr).TlnColl[j].Sex = cnMaennlich then
            for k:=0 to AltMKlasseColl[tmMsch].Count-1 do
              if TVeranstObj(FVPtr).TlnColl[j].TlnInKlasse(AltMKlasseColl[tmMsch][k],tmMsch) then
              begin
                Inc(TlnZahlArr[Integer(kwAltKl),k,Integer(cnMaennlich)]);
                Break;
              end else
          else // cnKeinSex bei Tln m�glich, nicht einlesen
          if TVeranstObj(FVPtr).TlnColl[j].Sex = cnWeiblich then
            for k:=0 to AltWKlasseColl[tmMsch].Count-1 do
              if TVeranstObj(FVPtr).TlnColl[j].TlnInKlasse(AltWKlasseColl[tmMsch][k],tmMsch) then
              begin
                Inc(TlnZahlArr[Integer(kwAltKl),k,Integer(cnWeiblich)]);
                Break;
              end;
        end;
      TlnZahlArr[Integer(kwAlle),0,0] := MschTlnLst.Count;

      // Bei gen�gend Tln f�r jede Wertungsklasse eine eigene Msch definieren:
      // AkAlle,M�nner,Frauen,MschAltMKlasseColl,MschAltWKlasseColl
      // alle Tln in alle Msch einlesen
      if MschWrtgMode = wmSchultour then
      begin
        MschGrAlle    := 1;
        MschGrMaenner := 1;
        MschGrFrauen  := 1;
        MschGrMixed   := 1;
      end else
      begin
        MschGrAlle    := MschGroesse[cnSexBeide];
        MschGrMaenner := MschGroesse[cnMaennlich];
        MschGrFrauen  := MschGroesse[cnWeiblich];
        MschGrMixed   := MschGroesse[cnMixed];
      end;
      if MschGrAlle > 0 then
      begin
        MschZahlArr[Integer(kwAlle),0,0] := MschTlnLst.Count DIV MschGrAlle;
        if MschZahlArr[Integer(kwAlle),0,0] > 0 then
          AddMschToColl(AkAlle,MschZahlArr[Integer(kwAlle),0,0]);
      end;
      if MschGrMixed > 0 then
      begin
        MschZahlArr[Integer(kwSex),0,Integer(cnMixed)] :=
           TlnZahlArr[Integer(kwSex),0,Integer(cnMixed)] DIV MschGrMixed;
        if MschZahlArr[Integer(kwSex),0,Integer(cnMixed)] > 0 then
          AddMschToColl(AkMixed,MschZahlArr[Integer(kwSex),0,Integer(cnMixed)]);
      end;
      if MschGrMaenner > 0 then
      begin
        MschZahlArr[Integer(kwSex),0,Integer(cnMaennlich)] :=
          TlnZahlArr[Integer(kwSex),0,Integer(cnMaennlich)] DIV MschGrMaenner;
        if MschZahlArr[Integer(kwSex),0,Integer(cnMaennlich)] > 0 then
          AddMschToColl(MaennerKlasse[tmMsch],MschZahlArr[Integer(kwSex),0,Integer(cnMaennlich)]);
        for k:=0 to AltMKlasseColl[tmMsch].Count-1 do
        begin
          MschZahlArr[Integer(kwAltKl),k,Integer(cnMaennlich)] :=
            TlnZahlArr[Integer(kwAltKl),k,Integer(cnMaennlich)] DIV MschGrMaenner;
          if MschZahlArr[Integer(kwAltKl),k,Integer(cnMaennlich)] > 0 then
            AddMschToColl(AltMKlasseColl[tmMsch][k],MschZahlArr[Integer(kwAltKl),k,Integer(cnMaennlich)]);
        end;
      end;

      if MschGrFrauen > 0 then
      begin
        MschZahlArr[Integer(kwSex),0,Integer(cnWeiblich)] :=
          TlnZahlArr[Integer(kwSex),0,Integer(cnWeiblich)] DIV MschGrFrauen;
        if MschZahlArr[Integer(kwSex),0,Integer(cnWeiblich)] > 0 then
          AddMschToColl(FrauenKlasse[tmMsch],MschZahlArr[Integer(kwSex),0,Integer(cnWeiblich)]);
        for k:=0 to AltWKlasseColl[tmMsch].Count-1 do
        begin
          MschZahlArr[Integer(kwAltKl),k,Integer(cnWeiblich)] :=
            TlnZahlArr[Integer(kwAltKl),k,Integer(cnWeiblich)] DIV MschGrFrauen;
          if MschZahlArr[Integer(kwAltKl),k,Integer(cnWeiblich)] > 0 then
            AddMschToColl(AltWKlasseColl[tmMsch][k],MschZahlArr[Integer(kwAltKl),k,Integer(cnWeiblich)]);
        end;
      end;

      if FStepProgressBar then HauptFenster.ProgressBarStep(1);
    end;

  finally
    MschTlnLst.Free;
    TlnZahlArr := nil;
    MschZahlArr := nil;
  end;

  end; // with EinlWettk do
end;

//==============================================================================
procedure TMannschColl.ClearKlassen(Wk:TWettkObj);
//==============================================================================
var i : Integer;
begin
  for i:=0 to Count-1 do with Items[i] do
    if Wettk = Wk then FKlasse := AkUnbekannt;
end;

//==============================================================================
procedure TMannschColl.SetzeMschAbsStZeit(Abs:TWkAbschnitt;Wk:TWettkObj);
//==============================================================================
// Startzeit f�r MschWettk�mpfe (waMschTeam, waMschStaffel),
// wird ausgef�hrt wenn Wk.ErgModified(OrtIndex) gesetzt ist
// TlnListe beim MschStaffel nach Stoppzeit rel.zur SGrp.Startzeit sortiert,
// damit Zuordnung �ber Tagesgrenze hinaus g�ltig
// in wkAbs1 kein stOhnePause (=EinzelStart)

var i,Zeit: Integer;
    Abs_1,AbsCnt : TWkAbschnitt;
begin
  Abs_1 := TWkAbschnitt(Integer(Abs)-1); // nur ab wkAbs2 benutzt

  if Wk.EinzelWettk or
     ((Wk.WettkArt <> waMschStaffel) or (Wk.MschGroesse[cnSexBeide] < Integer(Abs)))and
      (Wk.AbSchnZahl < Integer(Abs)) then // MschAbsStZeit nicht benutzt
    for i:=0 to Count-1 do with GetPItem(i) do
      if Wettk=Wk then SetAbsStZeit(Abs,-1)
      else
  else

  if Abs = wkAbs1 then
  begin
    // DummyTln beim Sortieren gesetzt, nur 1x sortieren
    Sortieren(TVeranstObj(FVPtr).OrtIndex,smMschTlnSnr,Wk,AkAlle,stEingeteilt,smOhneTlnColl);
    for i:=0 to Count-1 do with GetPItem(i) do
      if Wettk=Wk then
      begin
        Zeit := -1;
        if (DummyTln.SGrp<>nil) and (DummyTln.Snr>0) and (SortCollIndex>=0) then
        begin
          Zeit := DummyTln.SGrp.StartZeit[wkAbs1];
          if (DummyTln.SGrp.StartModus[wkAbs1] = stJagdStart) and (Zeit >= 0) then
            Zeit := Zeit + SortCollIndex * DummyTln.SGrp.Start1Delta;
        end;
        SetAbsStZeit(wkAbs1,Zeit);
      end;
  end

  else // Abs > wkAbs1
  begin
    // DummyTln.SGrp beim fr�heren Sortieren gesetzt
    // MschAbsZeit[wkAbs-1] und SGrp.ErstZeit[wkAbs-1] vorher gesetzt
    for i:=0 to Count-1 do with GetPItem(i) do
      if Wettk=Wk then
        if (DummyTln.SGrp<>nil)and(DummyTln.Snr>0)and(GetAbsStZeit(Abs_1)>=0) then
          case DummyTln.SGrp.StartModus[Abs] of
            stOhnePause:
              SetAbsStZeit(Abs,GetAbsStZeit(Abs_1)+GetAbsZeit(Abs_1)); // tages�berlauf wird korrigiert
            stMassenStart:
              if GetAbsZeit(Abs_1) > 0 then SetAbsStZeit(Abs,DummyTln.SGrp.StartZeit[Abs])
                                       else SetAbsStZeit(Abs,-1);
            stJagdStart :
              if (GetAbsZeit(Abs_1) > 0) and
                 (DummyTln.SGrp.ErstZeit[Abs_1] > 0) and
                 (DummyTln.SGrp.StartZeit[Abs] >= 0) then
              begin
                Zeit := DummyTln.SGrp.StartZeit[Abs];
                for AbsCnt:=wkAbs1 to Abs_1 do
                  Zeit := Zeit + GetAbsZeit(AbsCnt);
                if Zeit >= DummyTln.SGrp.ErstZeit[Abs_1] then
                  SetAbsStZeit(Abs,Zeit-DummyTln.SGrp.ErstZeit[Abs_1])
                else
                  SetAbsStZeit(Abs,cnZeit24_00+Zeit-DummyTln.SGrp.ErstZeit[Abs_1]);
              end
              else SetAbsStZeit(Abs,-1);
          end
        else SetAbsStZeit(Abs,-1);
  end;
  if FStepProgressBar then HauptFenster.ProgressBarStep(Count);
end;

//==============================================================================
procedure TMannschColl.SetzeMschAbsZeit(Abs:TWkAbschnitt;Wk:TWettkObj);
//==============================================================================
// wird ausgef�hrt in TlnErg, wenn Wk.ErgModified(OrtIndex) gesetzt ist
// MschAbsZeit nur ausgewertet in TlnErg f�r Berechnung SGrp.ErstZeiten
// hat nur Funktion f�r MannschaftsWettk�mpfe und
// StartModus[Abs+1]<>stOhnePause, (SGrp.StartZeit[Abs+1] >= 0)
// deshalb Tln-Zeiten ohne Strafzeit
// Msch-Wertungen immer f�r AkAlle
// nur Tln.StoppZeit benutzen, weil StrtZeit/Endzeit noch nicht berechnet sind
// AbsCnt: wkAbs1 to wkAbs8
var i,j,StZeit,SumZeit : Integer;
    AbsSortMode   : TSortMode;
    AbsStatus     : TStatus;

//..............................................................................
function GetTlnAbsZeit(const Tln:TTlnObj; Abschn:TWkAbschnitt): Integer;
// StZeit vorher berechnet, f�r Team
begin
  Result := Tln.AbsStoppZeit(Abschn);
  if Result >= 0 then
    if Result > StZeit then Result := Result - StZeit
                       else Result := cnZeit24_00 + Result - StZeit
  else Result := 0;
end;

//..............................................................................
function GetTlnGesZeit(const Tln:TTlnObj): Integer;
// StZeit vorher berechnet, f�r Staffel
var AbsCnt : TWkAbschnitt;
    Zeit   : Integer;
begin
  Result := 0;
  for AbsCnt:=wkAbs1 to TWkAbschnitt(Wk.AbschnZahl) do
  begin
    Zeit := Tln.AbsStoppZeit(AbsCnt);
    if Zeit >= 0 then
    begin
      if Zeit > StZeit then Result := Result + Zeit - StZeit
                       else Result := Result + cnZeit24_00 + Zeit - StZeit;
      StZeit := Zeit; // keine Pause zwischen Abs von StaffelTln
    end;
  end;
end;

//..............................................................................
begin
  if Wk.EinzelWettk or // EinzelWettk
     ((Wk.WettkArt <> waMschStaffel)or(Wk.MschGroesse[cnSexBeide] < Integer(Abs)))and
      (Wk.AbSchnZahl < Integer(Abs)) then
    for i:=0 to Count-1 do with GetPItem(i) do
      if Wettk=Wk then SetAbsZeit(Abs,0)
      else
  else
  case Wk.WettkArt of
    waMschTeam: // nur AkAlle
    begin
      FSortMode   := smNichtSortiert;
      AbsSortMode := TSortMode(Integer(smRelAbs1UhrZeit)+Integer(Abs)-1);
      //if Abs < wkAbs8 then AbsStatus := TStatus(Integer(stAbs1Ziel)+Integer(Abs)-1)
      //                else AbsStatus := stImZiel;
      // stAbs1Ziel,stImZiel setzen g�ltige Tln-AbsZeit voraus und damit g�ltige AbsStZeit,
      // diese wird aber erst sp�ter, nach MschZeiten gesetzt
      AbsStatus := TStatus(Integer(stAbs1UhrZeit)+Integer(Abs)-1);
      // nur Tln mit g�ltiger Stoppzeit f�r den Abschnitt und nicht disq.
      for i:=0 to Count-1 do with GetPItem(i) do
        if FWettk=Wk then
        begin
          StZeit := GetAbsStZeit(Abs);
          if StZeit >= 0 then
          begin
            // alle Tln nach Abs-UhrZeit rel. zur Abs1-Startzeit sortiert, nur Tln mit g�ltigen Zeiten
            // Tages�bergang ber�cksichtigt
            FTlnliste.SortMode := smNichtSortiert;
            FTlnListe.Sortieren(TVeranstObj(FVPtr).OrtIndex,AbsSortMode,Wk,AkAlle,AbsStatus);
            // Zeit vom letzten Tln
            if FTlnListe.SortCount >= Wk.MschGroesse[cnSexBeide] then
              SetAbsZeit(Abs,GetTlnAbsZeit(FTlnListe.SortItems[Wk.MschGroesse[cnSexBeide]-1],Abs))
            else
            if FTlnListe.SortCount > 0 then
              SetAbsZeit(Abs,GetTlnAbsZeit(FTlnListe.SortItems[FTlnListe.SortCount-1],Abs))
            else SetAbsZeit(Abs,0);
          end else SetAbsZeit(Abs,0);
        end;
    end;

    else //waMschStaffel, nur AkAlle
    begin
      FSortMode := smNichtSortiert;
      for i:=0 to Count-1 do with GetPItem(i) do
        if FWettk = Wk then
        begin
          if FWettk.MschGroesse[cnSexBeide] >= Integer(Abs) then // bis 16 Tln
          begin
            StZeit := GetAbsStZeit(Abs);
            if StZeit >= 0 then
            begin
              //TlnImZiel nach EndUhrzeit rel. zur StartUhrzeit sortiert, ohne disq. Tln
              FTlnliste.SortMode := smNichtSortiert;
              AbsSortMode := TSortMode(Integer(smRelAbs1UhrZeit)+FWettk.AbschnZahl-1); // letzter Abschnitt
              // stImZiel NICHT benutzen, weil StZeiten noch nicht g�ltig
              AbsStatus := TStatus(Integer(stAbs1UhrZeit)+FWettk.AbschnZahl-1); // letzter Abschnitt, nicht disq.
              FTlnListe.Sortieren(TVeranstObj(FVPtr).OrtIndex,AbsSortMode,
                                  Wk,AkAlle,AbsStatus);
              // g�ltige AbsZeit nur wenn Integer(Abs) Tln im Ziel
              if (FTlnListe.SortCount >= Integer(Abs)) {and
                 (FTlnListe.SortCount >= Wk.MannschGrWrtg)} then          // 2009
              begin
                SumZeit := GetTlnGesZeit(FTlnListe.SortItems[Integer(Abs)-1]);
                if (Abs = wkAbs8) and (FWettk.MschGroesse[cnSexBeide] > Integer(wkAbs8)) then
                  // restliche (bis 8) Tln-Endzeiten zu Abs8 addieren
                  for j:=9 to Min(FWettk.MschGroesse[cnSexBeide],FTlnListe.SortCount-1) do
                    // keine Pause zwischen Tln ab wkAbs8
                    SumZeit := SumZeit + GetTlnGesZeit(FTlnListe.SortItems[j-1]);
                SetAbsZeit(Abs,SumZeit);
              end else SetAbsZeit(Abs,0);
            end else SetAbsZeit(Abs,0);
          end else SetAbsZeit(Abs,0);
        end;
    end;
  end;

  if FStepProgressBar then HauptFenster.ProgressBarStep(Count);
end;

//==============================================================================
procedure TMannschColl.MschTlnLoeschen(Tln:TTlnObj);
//==============================================================================
// Tln in Mannschaft l�schen, wenn Mannsch vorhanden
// im TlnDialog benutzt vor TlnEntfernen und vor �nderung (TlnAktuell <> nil)
var MannschKlasse : TAkObj;
    Mannschaft    : TMannschObj;
    i             : Integer;

procedure MschLoeschen(AkWrtg:TKlassenWertung);
begin
  MannschKlasse := Tln.Wettk.GetKlasse(tmMsch,AkWrtg,Tln.Sex,Tln.Jg);
  // Msch mit MschIndex=0 suchen
  // bei mwMulti Tln in alle Indexen vorhanden
  // Msch nach Index sortiert in MannschColl eingelesen
  Mannschaft := SucheMannschaft(Tln.MannschNamePtr,Tln.Wettk,MannschKlasse,0);
  if Mannschaft <> nil then
  begin
    Mannschaft.FTlnListe.ClearItem(Tln);
    if Tln.Wettk.MschWertg = mwMulti then
    begin
      // Tln in weiteren Msch l�schen; wenn Index=0 andere Msch, also abbrechen
      i := IndexOf(Mannschaft);
      while i < Count-1 do
      begin
        Inc(i);
        Mannschaft := Items[i];
        with Mannschaft do
          if (FMschIndex <> 0) and (FName=Tln.MannschNamePtr) and
             (FWettk=Tln.Wettk) and (FKlasse=MannschKlasse) then
            FTlnListe.ClearItem(Tln)
          else Exit;
      end;
    end;
  end;
end;

begin
  if (Tln=nil) or (Tln.MannschNamePtr=nil) then Exit;
  MschLoeschen(kwAlle);
  MschLoeschen(kwSex);
  MschLoeschen(kwAltKl);
end;

//==============================================================================
function TMannschColl.ZeitStrafe(Wk:TWettkObj;Klasse:TAkObj;
                                  Status:TStatus): Boolean;
//==============================================================================
var i : Integer;
// 2006: True auch wenn Strafzeit = 0
begin
  Result := false;
  for i:=0 to FItems.Count-1 do
    with GetPItem(i) do
      if Wk.MschWettk and
         ((Wk=WettkAlleDummy) or (Wk=FWettk)) and
         (FKlasse=Klasse) and (GetEndZeit > 0) and (GetStrafZeit >= 0)  then
      begin
        Result := true;
        Exit;
      end;
end;

{(******************************************************************************)
procedure TMannschColl.SetAlleSerienTln(SerienTlnNeu: Boolean);
(******************************************************************************)
var i: Integer;
begin
  for i:=0 to Count-1 do
  begin
    GetPItem(i).FSerienTln := SerienTlnNeu;
    HauptFenster.StepProgressBar(1);
  end;
  for i:=0 to TVeranstObj(FVPtr).WettkColl.Count-1 do
    TVeranstObj(FVPtr).WettkColl[i].MannschModified := true;
  HauptFenster.MeldungClear;
end;}

{
(****************************************************************************)
procedure TMannschColl.CopyAll(SourceColl: PMannschColl);
(****************************************************************************)
var i,j,x    : Integer;
    Msch     : PMannschObj;
    WettkNeu : PWettkObj;
begin
  for i:=0 to SourceColl^.Count-1 do with PMannschObj(SourceColl^.At(i))^ do
  begin
    if Assigned(Wettk) then
    begin
      x := PVeranstObj(SourceColl^.VPtr)^.WettkColl^.IndexOf(Wettk);
      if x >= 0 then WettkNeu := TVeranstObj(FVPtr).WettkColl^.At(x)
                else WettkNeu := nil;
    end else WettkNeu := nil;

    Msch := New(PMannschObj, Init(VPtr,GetName,WettkNeu,Klasse,
                                  SerienTln,AusserKonkurrenz));
  end;
end;
}


(******************************************************************************)
(*         Methoden von TReportMschObj                                        *)
(******************************************************************************)

// public Methoden

//==============================================================================
constructor TReportMschObj.Create(MschNeu:TMannschObj);
//==============================================================================
begin
  MschPtr := MschNeu;
end;

//==============================================================================
function TReportMschObj.GetReportAkSortStr: String;
//==============================================================================
// Reihenfolge: Alle, M�nner, Frauen, Mixed, Ak-m�nnl., Ak-weibl.
begin
  with MschPtr.FKlasse do
    case Sex of
      cnSexBeide  : Result := 'a';
      cnWeiblich  : if Wertung = kwSex then Result := 'bW'
                    else Result := 'd'+Strng(AlterVon,2)+'W';
      cnMaennlich : if Wertung = kwSex then Result := 'bM'
                    else Result := 'd'+Strng(AlterVon,2)+'M';
      cnMixed     : Result := 'c';
      else          Result := 'e';
    end;
end;


(******************************************************************************)
(*         Methoden von TReportMschList                                       *)
(******************************************************************************)

// public Methoden

//==============================================================================
function TReportMschList.Add(Item:TMannschObj): Integer;
//==============================================================================
// keine Liste �ber Alle Wettk
var i : Integer;
    RepMsch : TReportMschObj;

//..............................................................................
function RepTlnAdd(Tln:TTlnObj): Integer;
var RepTln : TReportTlnObj;
begin
  Result := -1;
  with HauptFenster do
    RepTln := TReportTlnObj.Create(Tln,Item.FWettk,wgStandWrtg,Item.FKlasse);
  with Veranstaltung.TlnColl do
  begin
    MschAkWrtg := Item.FKlasse.Wertung;
    if not ReportTlnlist.Find(RepTln, Result) then
      ReportTlnlist.Insert(Result,RepTln) // nach Msch-AkWrtg sortiert
    else RepTln.Free;
    MschAkWrtg := kwKein; // Ausgangszustand
  end;
end;

//..............................................................................
begin
  Result := -1;
  if Item=nil then Exit;

  with HauptFenster do
    if ((Ansicht<>anMschStart)and(Ansicht<>anMschErgDetail)and(Ansicht<>anMschErgKompakt) or
        (Item.TagesRng>=ReportRngVon)and(Item.TagesRng<=ReportRngBis)) and
       ((Ansicht<>anMschErgSerie) or
        (Item.FSerieRang>=ReportRngVon)and(Item.FSerieRang<=ReportRngBis)) then
    begin
      RepMsch := TReportMschObj.Create(Item);
      if not Find(RepMsch, Result) then
      begin
        Insert(Result,RepMsch);
        if Veranstaltung.MannschColl.SortTlnColl=smMitTlnColl then
          // nur f�r Listen
          if (SortStatus = stkein) or
             (Ansicht = anMschErgSerie) or (Ansicht = anMschErgKompakt) then
            RepTlnAdd(Item.DummyTln)
          else for i:=0 to Item.FTlnListe.SortCount-1 do
            RepTlnAdd(Item.FTlnListe.SortItems[i]);
      end
      else RepMsch.Free;
    end;
end;

//==============================================================================
function TReportMschList.Find(Item:TReportMschObj; var Indx:Integer):Boolean;
//==============================================================================
var
  L, H, I, C: Integer;
begin
  Result := false;
  L := 0;
  H := Count-1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    //C := Compare(List^[I],Item);
    C := Compare(Items[I],Item);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := true;
        L := I;
      end;
    end;
  end;
  Indx := L;
end;

//==============================================================================
function TReportMschList.Compare(Item1, Item2: TReportMschObj): Integer;
//==============================================================================
// bei rmWkAlle (nur Urkunden) immer nach Wettk sortieren, MschWrtg nur pro Wettk
begin
  Result := AnsiCompareStr(
               Format('%s  %s  %s',
                      [Item1.MschPtr.FWettk.Name,
                       Item1.GetReportAkSortStr,
                       Veranstaltung.MannschColl.SortString(Item1.MschPtr)]),
               Format('%s  %s  %s',
                      [Item2.MschPtr.FWettk.Name,
                       Item2.GetReportAkSortStr,
                       Veranstaltung.MannschColl.SortString(Item2.MschPtr)]));
  // Unterschied ss/� ber�cksichtigen
  if Result = 0 then
    Result := CompareStr(
               Format('%s  %s  %s',
                      [Item1.MschPtr.FWettk.Name,
                       Item1.GetReportAkSortStr,
                       Veranstaltung.MannschColl.SortString(Item1.MschPtr)]),
               Format('%s  %s  %s',
                      [Item2.MschPtr.FWettk.Name,
                       Item2.GetReportAkSortStr,
                       Veranstaltung.MannschColl.SortString(Item2.MschPtr)]));
end;


end.
