unit SGrpObj;

interface

uses
  Classes,SysUtils,Dialogs,
  AllgConst,AllgObj,AllgFunc,AkObj,WettkObj;

type

  TStartModeArr  = array [wkAbs1..wkAbs8] of TStartMode;

  TSGrpObj = class(TTriaObj)
  protected
    FName          : String;
    FStart1Delta   : Integer;
    FStartZeitArr  : TAbsZeitArr;
    FStartnrVon    : Integer;
    FStartnrBis    : Integer;
    FWettkampf     : TWettkObj;
    FWkOrtIndex    : Integer;
    FStartModeArr  : TStartModeArr;
    FErstZeitArr   : TAbsZeitArr;
    function    GetBPObjType: Word; override;
    procedure   SetName(NameNeu:String);
    procedure   SetStart1Delta(ZeitNeu:Integer);
    procedure   SetStartZeit(const Abs:TWkAbschnitt; const ZeitNeu:Integer);
    function    GetStartZeit(const Abs:TWkAbschnitt): Integer;
    procedure   SetStartnrVon(SnrNeu:Integer);
    procedure   SetWettkampf(WkNeu:TWettkObj);
    procedure   SetStartModus(const Abs:TWkAbschnitt; const ModeNeu:TStartMode);
    function    GetStartModus(const Abs:TWkAbschnitt): TStartMode;
    procedure   SetErstZeit(const Abs:TWkAbschnitt; const ZeitNeu:Integer);
    function    GetErstZeit(const Abs:TWkAbschnitt): Integer;

  public
    constructor Create(Veranst:Pointer;Coll:TTriaObjColl;Add:TOrtAdd); override;
    procedure   Init(NameNeu: String; WettkampfNeu:TWettkObj); overload;
    procedure   Init(NameNeu: String; WettkampfNeu:TWettkObj;
                     StartnrVonNeu,StartnrBisNeu: Integer); overload;
    procedure   Init(NameNeu: String; WettkampfNeu:TWettkObj;
                     Start1DeltaNeu: Integer;
                     StartZeitNeuArr: TAbsZeitArr; StartModusNeuArr: TStartModeArr;
                     StartnrVonNeu,StartnrBisNeu: Integer); overload;
    function    Load: Boolean; override;
    function    Store: Boolean; override;
    procedure   OrtCollAdd; override;
    procedure   OrtCollClear(Indx:Integer); override;
    procedure   OrtCollExch(Idx1,Idx2:Integer); override;
    function    JagdStartEinzel(Abs:TWkAbschnitt): Boolean;
    function    JagdStartMannsch(Abs:TWkAbschnitt): Boolean;
    procedure   ZeitenRunden;
    function    InitValue: Boolean;
    function    ObjSize: Integer; override;
    property    Name : String read FName write SetName;
    property    StartnrVon: Integer read FStartNrVon;
    property    StartnrBis: Integer read FStartNrBis;
    property    Wettkampf: TWettkObj read FWettkampf write SetWettkampf;
    property    WkOrtIndex: Integer read FWkOrtIndex;
    property    Start1Delta: Integer read FStart1Delta write SetStart1Delta;
    property    Startzeit[const Abs:TWkAbschnitt]: Integer read GetStartZeit write SetStartZeit;
    property    StartZeitArr: TAbsZeitArr read FStartZeitArr write FStartZeitArr;
    property    StartModus[const Abs:TWkAbschnitt]: TStartMode read GetStartModus write SetStartModus;
    property    StartModeArr: TStartModeArr read FStartModeArr write FStartModeArr;
    property    ErstZeit[Const Abs:TWkAbschnitt]: Integer read GetErstZeit write SetErstZeit;
  end;

  TSGrpColl = class(TTriaObjColl)
  protected
    FSortOrtIndex : Integer;
    FSortWettk    : TWettkObj;
    function    GetBPObjType: Word; override;
    function    GetPItem(Indx:Integer): TSGrpObj;
    procedure   SetPItem(Indx:Integer; Item:TSGrpObj);
    function    GetSortItem(Indx:Integer): TSGrpObj;
  public
    constructor Create(Veranst:Pointer;ItemClass:TTriaObjClass);
    function    SortString(Item: Pointer): String; override;
    procedure   OrtCollAdd; override;
    procedure   OrtCollClear(Indx:Integer); override;
    procedure   OrtCollExch(Idx1,Idx2:Integer); override;
    procedure   Sortieren(OrtIndexNeu:Integer; WettkNeu:TWettkObj);
    function    AddSortItem(Item: Pointer): Integer; override;
    function    SGrpMitSnr(Wk:TWettkObj; Snr:Integer):TSGrpObj;
    function    SnrUeberlap(Wk:TWettkObj; NrVon,NrBis: Integer): Boolean;
    function    FreierSnrBereich(var SnrVon:Integer; var SnrBis:Integer): Boolean;
    function    TlnGestartet(Item: TSGrpObj): Boolean;
    function    GetStartGruppe(NameNeu:String;
                               WkOrtIndexNeu:Integer; WettkampfNeu:TWettkObj;
                               Startzeit1Neu: Integer; StartnrVonNeu: Integer): TSGrpObj;
    function    SGrpZahl(Wettk:TWettkObj): Integer;
    function    Definiert: Boolean;
    //function    SGrpGesamtZahl(Wettk:TWettkObj): Integer;
    //function    SGrpOrtZahl(Ort:Pointer): Integer;
    procedure   SGrpLoeschen(Wk:TWettkObj);
    function    JagdStartEinzel(Abschnitt:TWkAbschnitt): Boolean;
    function    JagdStartMannsch(Abschnitt:TWkAbschnitt): Boolean;
    function    WettkJagdStartEinzel(Wk:TWettkObj; Abschnitt:TWkAbschnitt): Boolean;
    function    WettkJagdStartMannsch(Wk:TWettkObj; Abschnitt:TWkAbschnitt): Boolean;
    function    WettkStartModus(Wk:TWettkObj; Abs:TWkAbschnitt): TStartMode;
    function    StartModeVorgegeben(SG:TSGrpObj; Abs:TWkAbschnitt; var StrtMode:TStartMode): Boolean;
    procedure   ZeitenRunden;
    property Items[Indx: Integer]: TSGrpObj read GetPItem write SetPItem; default;
    property SortItems[Indx:Integer]:TSGrpObj read GetSortItem;
    property SortOrtIndex : Integer read FSortOrtIndex write FSortOrtIndex;
    property SortWettk    : TWettkObj read FSortWettk write FSortWettk;
  end;

(************************** Implementation **********************************)
implementation

uses TriaMain, VeranObj, MannsObj,DateiDlg,TlnObj;

(******************************************************************************)
(*                   Methoden von TSGrpObj                                    *)
(******************************************************************************)

// protected Methoden

//-------------------------------------------------------------------------------
function TSGrpObj.GetBPObjType: Word;
//-------------------------------------------------------------------------------
(* Object Types aus Version 7.4 Stream Registration Records *)
begin
  Result := rrSGrpObj;
end;

//-------------------------------------------------------------------------------
procedure TSGrpObj.SetName(NameNeu:String);
//------------------------------------------------------------------------------
begin
  if NameNeu <> FName then
  begin
    SortRemove;
    FName := Trim(NameNeu);
    SortAdd;
  end;
end;

//------------------------------------------------------------------------------
procedure TSGrpObj.SetStart1Delta(ZeitNeu: Integer);
//------------------------------------------------------------------------------
// 9.10. 0 = ung�ltig
begin
  (* nur g�ltige Werte speichern *)
  if (ZeitNeu > 0) and (ZeitNeu < cnZeit_1Std) then FStart1Delta := ZeitNeu
  else FStart1Delta := 0;
end;

//------------------------------------------------------------------------------
procedure TSGrpObj.SetStartZeit(const Abs:TWkAbschnitt; const ZeitNeu:Integer);
//------------------------------------------------------------------------------
var Zeit : Integer;
begin
  // nur g�ltige Uhrzeit speichern
  if (ZeitNeu >= 0) and (ZeitNeu < cnZeit24_00) then Zeit := ZeitNeu
                                                else Zeit := -1;
  SortRemove;
  FStartZeitArr[Abs] := Zeit;
  SortAdd;
end;

//------------------------------------------------------------------------------
function TSGrpObj.GetStartZeit(const Abs:TWkAbschnitt): Integer;
//------------------------------------------------------------------------------
begin
  Result := FStartZeitArr[Abs];
end;

//------------------------------------------------------------------------------
procedure TSGrpObj.SetStartnrVon(SnrNeu:Integer);
//------------------------------------------------------------------------------
begin
  SortRemove;
  FStartNrVon := SnrNeu;
  SortAdd;
end;

//------------------------------------------------------------------------------
procedure TSGrpObj.SetWettkampf(WkNeu: TWettkObj);
//------------------------------------------------------------------------------
begin
  SortRemove;
  FWettkampf := WkNeu;
  SortAdd;
end;

//------------------------------------------------------------------------------
procedure TSGrpObj.SetStartModus(const Abs:TWkAbschnitt; const ModeNeu:TStartMode);
//------------------------------------------------------------------------------
begin
  FStartModeArr[Abs] := ModeNeu;
end;

//------------------------------------------------------------------------------
function TSGrpObj.GetStartModus(const Abs:TWkAbschnitt): TStartMode;
//------------------------------------------------------------------------------
begin
  with FWettkampf do
  begin
    if WettkArt = waMschStaffel then
      if MschGroesse[cnSexBeide] >= Integer(Abs) then Result := FStartModeArr[Abs]
      else if Abs=wkAbs1 then Result := stMassenStart
                         else Result := stOhnePause
    else
      if AbSchnZahl >= Integer(Abs) then Result := FStartModeArr[Abs]
      else if Abs=wkAbs1 then Result := stMassenStart
                         else Result := stOhnePause;
    // kein Einzelstart bei MannschWettk
    if (Abs=wkAbs1) and (Result=stOhnePause) and MschWettk then
      Result := stMassenStart;
  end;
end;

//------------------------------------------------------------------------------
function TSGrpObj.GetErstZeit(const Abs:TWkAbschnitt): Integer;
//------------------------------------------------------------------------------
begin
  Result := FErstZeitArr[Abs];
end;

//------------------------------------------------------------------------------
procedure TSGrpObj.SetErstZeit(const Abs:TWkAbschnitt; const ZeitNeu:Integer);
//------------------------------------------------------------------------------
// geht nur nachdem TlnColl geladen wurde
// wird beim Ergberechnen gesetzt
begin
  FErstZeitArr[Abs] := ZeitNeu;
end;

// public Methoden

//==============================================================================
constructor TSGrpObj.Create(Veranst:Pointer;Coll:TTriaObjColl;Add:TOrtAdd);
//==============================================================================
var AbsCnt: TWkAbschnitt;
begin
  inherited Create(Veranst,Coll,Add);
  FName        := '';
  FWettkampf   := WettkAlleDummy;
  FWkOrtIndex  := TVeranstObj(FVPtr).OrtIndex;
  FStartnrVon  := 0;
  FStartnrBis  := 0;
  FStart1Delta := 0;
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    FStartZeitArr[AbsCnt] := -1;
    if AbsCnt=wkAbs1 then FStartModeArr[AbsCnt] := stMassenStart
                     else FStartModeArr[AbsCnt] := stOhnePause;
    FErstZeitArr[AbsCnt] := 0;
  end;
end;

//==============================================================================
procedure TSGrpObj.Init(NameNeu:String; WettkampfNeu:TWettkObj);
//==============================================================================
var AbsCnt   : TWkAbschnitt;
    StrtMode : TStartMode;
begin
  SetName(NameNeu);
  SetWettkampf(WettkampfNeu);
  SetStartnrVon(0);
  FStartnrBis := 0;
  SetStart1Delta(0);
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    SetStartZeit(AbsCnt,-1);
    if (FCollection<>nil) and
       TSGrpColl(FCollection).StartModeVorgegeben(Self,AbsCnt,StrtMode) then
      FStartModeArr[AbsCnt] := StrtMode // Mode der 1. Grp gilt
    else
      if AbsCnt=wkAbs1 then FStartModeArr[AbsCnt] := stMassenStart
                       else FStartModeArr[AbsCnt] := stOhnePause;
    FErstZeitArr[AbsCnt] := 0;
  end;
end;

//==============================================================================
procedure TSGrpObj.Init(NameNeu:String; WettkampfNeu:TWettkObj;
                        StartnrVonNeu,StartnrBisNeu: Integer);
//==============================================================================
var AbsCnt: TWkAbschnitt;
    StrtMode : TStartMode;
begin
  SetName(NameNeu);
  SetWettkampf(WettkampfNeu);
  SetStartnrVon(StartnrVonNeu);
  FStartnrBis := StartnrBisNeu;
  SetStart1Delta(0);
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    SetStartZeit(AbsCnt,-1);
    if (FCollection<>nil) and
       TSGrpColl(FCollection).StartModeVorgegeben(Self,AbsCnt,StrtMode) then
      FStartModeArr[AbsCnt] := StrtMode // Mode der 1. Grp gilt
    else
      if AbsCnt=wkAbs1 then FStartModeArr[AbsCnt] := stMassenStart
                       else FStartModeArr[AbsCnt] := stOhnePause;
    FErstZeitArr[AbsCnt] := 0;
  end;
end;

//==============================================================================
procedure TSGrpObj.Init(NameNeu: String; WettkampfNeu:TWettkObj;
                        Start1DeltaNeu: Integer;
                        StartZeitNeuArr: TAbsZeitArr; StartModusNeuArr: TStartModeArr;
                        StartnrVonNeu,StartnrBisNeu: Integer);
//==============================================================================
var AbsCnt: TWkAbschnitt;
    StrtMode : TStartMode;
begin
  SetName(NameNeu);
  SetWettkampf(WettkampfNeu);
  SetStartnrVon(StartnrVonNeu);
  FStartnrBis := StartnrBisNeu;
  SetStart1Delta(Start1DeltaNeu);
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    SetStartZeit(AbsCnt,StartZeitNeuArr[AbsCnt]);
    if (FCollection<>nil) and
       TSGrpColl(FCollection).StartModeVorgegeben(Self,AbsCnt,StrtMode) then
      FStartModeArr[AbsCnt] := StrtMode // Mode der 1. Grp gilt
    else
      FStartModeArr[AbsCnt] := StartModusNeuArr[AbsCnt];
    FErstZeitArr[AbsCnt] := 0;
  end;
end;

//==============================================================================
function TSGrpObj.Load: Boolean;
//==============================================================================
var SBuff  : SmallInt;
    WBuff  : Word;
    LBuff  : LongInt;
    AbsCnt : TWkAbschnitt;
    StrtModeBuff: TStartMode;
//..............................................................................
function ReadAbsZeiten(Abs:TWkAbschnitt): Boolean;
// ErstZeiten nicht gespeichert, werden nach Load neu berechnet
begin
  Result := false;
  with TriaStream do
  try
    ReadBuffer(FStartZeitArr[Abs], cnSizeOfLongInt);
    if (FStartZeitArr[Abs] < 0) or(FStartZeitArr[Abs] >= cnZeit24_00) then
      FStartZeitArr[Abs] := -1;
    ReadBuffer(SBuff, cnSizeOfSmallInt);
    if TSGrpColl(FCollection).StartModeVorgegeben(Self,Abs,StrtModeBuff) then
      FStartModeArr[Abs] := StrtModeBuff // Mode der 1. Grp gilt f�r Wettk
    else
      case SBuff of
        1:   FStartModeArr[Abs] := stMassenStart;
        2:   FStartModeArr[Abs] := stJagdStart;
        else
          if (Abs = wkAbs1) and // kein Einzelstart f�r MschWettk
             ((FWettkampf = WettkAlleDummy) or FWettkampf.MschWettk) then
            FStartModeArr[Abs] := stMassenStart
          else
            FStartModeArr[Abs] := stOhnePause;
      end;

  except
    Exit;
  end;
    Result := true;
end;

//..............................................................................
begin
  Result := false;

  try
    if FVPtr <> EinlVeranst then Exit;
    if not inherited Load then Exit;

    with TriaStream do
    if TriDatei.Version.Jahr >= '2009' then
    begin
      ReadStr(FName);
      ReadBuffer(SBuff, cnSizeOfSmallInt);
      if SBuff=-1 then FWettkampf := WettkAlleDummy
                  else FWettkampf := TVeranstObj(FVPtr).WettkColl[SBuff];
      ReadBuffer(SBuff, cnSizeOfSmallInt);
      FWkOrtIndex := SBuff; // in Integer umwandeln
      ReadBuffer(FStart1Delta, cnSizeOfLongInt);
      if (FStart1Delta<0) or (FStart1Delta>=cnZeit_1Std) then FStart1Delta := 0;
      for AbsCnt:=wkAbs1 to wkAbs8 do
        if not ReadAbsZeiten(AbsCnt) then Exit;
      ReadBuffer(WBuff, cnSizeOfWord);
      FStartnrVon := WBuff; // in Integer umwandeln
      ReadBuffer(WBuff, cnSizeOfWord);
      FStartnrBis := WBuff; // in Integer umwandeln
    end

    // altes Dateiformat, vor 2009
    else
    begin
      ReadBuffer(FStartZeitArr[wkAbs1], cnSizeOfLongInt);
      ReadBuffer(LBuff, cnSizeOfLongInt);
      if LBuff >= 0 then FStart1Delta := LBuff
                    else FStart1Delta := 0;
      ReadBuffer(WBuff, cnSizeOfWord);
      FStartnrVon := WBuff;
      ReadBuffer(WBuff, cnSizeOfWord);
      FStartnrBis := WBuff;
      ReadBuffer(WBuff, cnSizeOfWord); //Dummy f�r FStarterMax
      ReadBuffer(SBuff, cnSizeOfSmallInt);
      if SBuff=-1 then FWettkampf := WettkAlleDummy
                  else FWettkampf := TVeranstObj(FVPtr).WettkColl[SBuff];
      ReadBuffer(SBuff, cnSizeOfSmallInt);
      FWkOrtIndex := SBuff;
      ReadBuffer(FStartZeitArr[wkAbs2], cnSizeOfLongInt);
      if FStartZeitArr[wkAbs2] < 0 then FStartZeitArr[wkAbs2] := -1;
      ReadBuffer(FStartZeitArr[wkAbs3], cnSizeOfLongInt);
      if FStartZeitArr[wkAbs3] < 0 then FStartZeitArr[wkAbs3] := -1;
      ReadBuffer(SBuff, cnSizeOfSmallInt);
      if TSGrpColl(FCollection).StartModeVorgegeben(Self,wkAbs1,StrtModeBuff) then
        FStartModeArr[wkAbs1] := StrtModeBuff // Mode der 1. Grp gilt f�r Wettk
      else
        case SBuff of
          2: FStartModeArr[wkAbs1]   := stJagdStart;
          else FStartModeArr[wkAbs1] := stMassenStart; // kein Einzelstart
        end;
      ReadBuffer(SBuff, cnSizeOfSmallInt);
      if TSGrpColl(FCollection).StartModeVorgegeben(Self,wkAbs2,StrtModeBuff) then
        FStartModeArr[wkAbs2] := StrtModeBuff // Mode der 1. Grp gilt f�r Wettk
      else
        case SBuff of
          1: FStartModeArr[wkAbs2]   := stMassenStart;
          2: FStartModeArr[wkAbs2]   := stJagdStart;
          else FStartModeArr[wkAbs2] := stOhnePause;
        end;
      ReadBuffer(SBuff, cnSizeOfSmallInt);
      if TSGrpColl(FCollection).StartModeVorgegeben(Self,wkAbs3,StrtModeBuff) then
        FStartModeArr[wkAbs3] := StrtModeBuff // Mode der 1. Grp gilt f�r Wettk
      else
        case SBuff of
          1: FStartModeArr[wkAbs3]   := stMassenStart;
          2: FStartModeArr[wkAbs3]   := stJagdStart;
          else FStartModeArr[wkAbs3] := stOhnePause;
        end;
      ReadBuffer(LBuff, cnSizeOfLongInt);// Dummy f�r FErstZeit1
      ReadBuffer(LBuff, cnSizeOfLongInt);// Dummy f�r FErstZeit2

      //ab 2008-2.0 (in 1/100) in SGrpObj, vorher in Veranst.Obj
      if (TriDatei.Version.Jahr>'2008') or
         (TriDatei.Version.Jahr='2008')and(TriDatei.Version.Nr>='2.0') then
      begin
        ReadBuffer(FStartZeitArr[wkAbs4], cnSizeOfLongInt);
        if (FStartZeitArr[wkAbs4] < 0) or(FStartZeitArr[wkAbs4] >= cnZeit24_00) then FStartZeitArr[wkAbs4] := -1;
        ReadBuffer(SBuff, cnSizeOfSmallInt);
        if TSGrpColl(FCollection).StartModeVorgegeben(Self,wkAbs4,StrtModeBuff) then
          FStartModeArr[wkAbs4] := StrtModeBuff // Mode der 1. Grp gilt f�r Wettk
        else
          case SBuff of
            1: FStartModeArr[wkAbs4]   := stMassenStart;
            2: FStartModeArr[wkAbs4]   := stJagdStart;
            else FStartModeArr[wkAbs4] := stOhnePause;
          end;
        ReadBuffer(Lbuff, cnSizeOfLongInt); // dummy f�r FErstZeit3
      end;

      // in 1/100 Sek umrechnen
      if (TriDatei.Version.Jahr<'2006')or
         (TriDatei.Version.Jahr='2006')and(TriDatei.Version.Nr<'0.3') then
        LBuff := 100 // Sek ==> 1/100
      else
      if (TriDatei.Version.Jahr<'2008')or
         (TriDatei.Version.Jahr='2008')and(TriDatei.Version.Nr<'2.0') then
        LBuff := 10 // 1/10 ==> 1/100
      else LBuff := 1;
      if LBuff > 1 then
      begin
        if FStartZeitArr[wkAbs1] > 0            then FStartZeitArr[wkAbs1] := FStartZeitArr[wkAbs1] * LBuff;
        if FStart1Delta > 0                     then FStart1Delta          := FStart1Delta * LBuff;
        if FStart1Delta >= cnZeit_1Std          then FStart1Delta          := 0;
        if FStartZeitArr[wkAbs2] > 0            then FStartZeitArr[wkAbs2] := FStartZeitArr[wkAbs2] * LBuff;
        if FStartZeitArr[wkAbs2] >= cnZeit24_00 then FStartZeitArr[wkAbs2] := -1;
        if FStartZeitArr[wkAbs3] > 0            then FStartZeitArr[wkAbs3] := FStartZeitArr[wkAbs3] * LBuff;
        if FStartZeitArr[wkAbs3] >= cnZeit24_00 then FStartZeitArr[wkAbs3] := -1;
        if FErstZeitArr[wkAbs1]  > 0            then FErstZeitArr[wkAbs1]  := FErstZeitArr[wkAbs1] * LBuff;
        if FErstZeitArr[wkAbs2]  > 0            then FErstZeitArr[wkAbs2]  := FErstZeitArr[wkAbs2] * LBuff;
      end;

    end;

  except
    Result := false;
    Exit;
  end;

  Result := true;
end;

//==============================================================================
function TSGrpObj.Store: Boolean;
//==============================================================================
var SBuff  : SmallInt;
    WBuff  : Word;
    AbsCnt : TWkAbschnitt;
//..............................................................................
function WriteAbsZeiten(Abs:TWkAbschnitt): Boolean;
// ErstZeiten nicht gespeichert, werden nach Load neu berechnet
begin
  Result := false;
  with TriaStream do
  try
    WriteBuffer(FStartZeitArr[Abs],cnSizeOfLongInt);
    case FStartModeArr[Abs] of
      stOhnePause   : SBuff := 0;
      stMassenStart : SBuff := 1;
      stJagdStart   : SBuff := 2;
    end;
    WriteBuffer(SBuff, cnSizeOfSmallInt);
  except
    Exit;
  end;
  Result := true;
end;
//..............................................................................
begin
  Result := false;
  if not inherited Store then Exit;

  with TriaStream do
  try
    WriteStr(FName);
    if Assigned(FWettkampf) then SBuff := FWettkampf.CollectionIndex
                            else SBuff := -1;
    WriteBuffer(SBuff, cnSizeOfSmallInt);
    SBuff := FWkOrtIndex; // umwandlung 16 bit
    WriteBuffer(SBuff, cnSizeOfSmallInt);
    WriteBuffer(FStart1Delta, cnSizeOfLongInt);

    for AbsCnt:=wkAbs1 to wkAbs8 do
      if not WriteAbsZeiten(AbsCnt) then Exit;

    WBuff := FStartnrVon;
    WriteBuffer(WBuff, cnSizeOfWord);
    WBuff := FStartnrBis;
    WriteBuffer(WBuff, cnSizeOfWord);

  except
    Result := false;
    Exit;
  end;
  Result := true;

end;

//==============================================================================
procedure TSGrpObj.OrtCollAdd;
//==============================================================================
begin
  // keine Funktion
end;

//==============================================================================
procedure TSGrpObj.OrtCollClear(Indx:Integer);
//==============================================================================
begin
  // keine Funktion
end;

//==============================================================================
procedure TSGrpObj.OrtCollExch(Idx1,Idx2:Integer);
//==============================================================================
begin
  // keine Funktion
end;

//==============================================================================
function TSGrpObj.JagdStartEinzel(Abs:TWkAbschnitt): Boolean;
//==============================================================================
begin
  if (FWkOrtIndex = TVeranstObj(FVPtr).OrtIndex) and not FWettkampf.MschWettk then
    Result := GetStartModus(Abs) = stJagdStart
  else Result := false;
end;

//==============================================================================
function TSGrpObj.JagdStartMannsch(Abs:TWkAbschnitt): Boolean;
//==============================================================================
begin
  if (FWkOrtIndex = TVeranstObj(FVPtr).OrtIndex) and FWettkampf.MschWettk then
    Result := GetStartModus(Abs) = stJagdStart
  else Result := false;
end;

//==============================================================================
procedure TSGrpObj.ZeitenRunden;
//==============================================================================
var AbsCnt : TWkAbschnitt;
begin
  for AbsCnt:=wkAbs1 to wkAbs8 do
    StartZeit[AbsCnt] := UhrZeitRunden(StartZeit[AbsCnt]);
end;

//==============================================================================
function TSGrpObj.ObjSize: Integer;
//==============================================================================
begin
  Result := 9*cnSizeOfInteger + 2*SizeOf(TStartMode) + cnSizeOfPointer;
end;

//==============================================================================
function TSGrpObj.InitValue: Boolean;
//==============================================================================
//..............................................................................
function AbsInitValue: Boolean;
var AbsCnt : TWkAbschnitt;
begin
  Result := false;
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    if FStartZeitArr[AbsCnt] <> -1 then Exit;
    if (AbsCnt=wkAbs1)and (FStartModeArr[AbsCnt] <> stMassenStart) or
       (AbsCnt>wkAbs1)and (FStartModeArr[AbsCnt] <> stOhnePause) then Exit;
    if FErstZeitArr[AbsCnt] <> 0 then Exit;
  end;
  Result := true;
end;

//..............................................................................
begin
  Result := (FWettkampf = WettkAlleDummy) and
            (FWkOrtIndex = TVeranstObj(FVPtr).OrtIndex) and
            (FName = '') and
            (FStartnrVon = 0) and
            (FStartnrBis = 0) and
            (FStart1Delta= 0) and
            AbsInitValue;
end;


(******************************************************************************)
(* Methoden von TSGrpColl                                                     *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
function TSGrpColl.GetBPObjType: Word;
//------------------------------------------------------------------------------
(* Object Types aus Version 7.4 Stream Registration Records *)
begin
  Result := rrSGrpColl;
end;

//------------------------------------------------------------------------------
function TSGrpColl.GetPItem(Indx:Integer): TSGrpObj;
//------------------------------------------------------------------------------
begin
  Result := TSGrpObj(inherited GetPItem(Indx));
end;

//------------------------------------------------------------------------------
procedure TSGrpColl.SetPItem(Indx:Integer; Item:TSGrpObj);
//------------------------------------------------------------------------------
begin
  inherited SetPItem(Indx,Item);
end;

//------------------------------------------------------------------------------
function TSGrpColl.GetSortItem(Indx:Integer): TSGrpObj;
//------------------------------------------------------------------------------
begin
  Result := TSGrpObj(inherited GetSortItem(Indx));
end;

// public Methoden

//==============================================================================
Constructor TSGrpColl.Create(Veranst:Pointer;ItemClass:TTriaObjClass);
//==============================================================================
begin
  // Veranst und WettkColl vorher initialisiert
  inherited Create(Veranst,ItemClass);
  FStepProgressBar := true;
  //FStepMeldung := true;
  FSortItems.Duplicates := true; (* gleiche Eintr�ge erlaubt, sollte aber nicht*)
  FSortMode := smSortiert; // Dummy, fester SortMode
  FSortOrtIndex := TVeranstObj(FVPtr).OrtIndex;  (* aktueller Ort *)
  FSortWettk := WettkAlleDummy; (* alle Wettk�mpfe *)
end;

//==============================================================================
function TSGrpColl.SortString(Item:Pointer): String;
//==============================================================================
// nach Startzeit sortiert, wenn vorhanden
begin
  with TSGrpObj(Item) do
    if InitValue then // SGrpNeu muss als erste in Liste
      Result := Format('A %4u  %s  %s  %u',
                       [StartnrVon,Name,Wettkampf.Name,WkOrtIndex])
    else
    if StartZeit[wkAbs1] < 0 then // auch wenn stOhnePause/Einzelstart
      Result := Format('B %4u  %s  %s  %u',
                       [StartnrVon,Name,Wettkampf.Name,WkOrtIndex])
    else
      Result := Format('C %7d %4u  %s  %s  %u',
                       [StartZeit[wkAbs1],StartnrVon,Name,Wettkampf.Name,WkOrtIndex]);
end;

//==============================================================================
procedure TSGrpColl.OrtCollAdd;
//==============================================================================
begin
  // keine Aktion
end;

//==============================================================================
procedure TSGrpColl.OrtCollClear(Indx:Integer);
//==============================================================================
var i : Integer;
begin
  // FVptr <> nil und WettkColl <> nil
  for i:=Count-1 downto 0 do with GetPItem(i) do
    if FWkOrtIndex > Indx then Dec(FWkOrtIndex)
    else if FWkOrtIndex = Indx then ClearIndex(i);
end;

//==============================================================================
procedure TSGrpColl.OrtCollExch(Idx1,Idx2:Integer);
//==============================================================================
var i : Integer;
begin
  for i:=0 to Count-1 do with GetPItem(i) do
    if FWkOrtIndex = Idx1 then FWkOrtIndex := Idx2
    else if FWkOrtIndex = Idx2 then FWkOrtIndex := Idx1;
end;

//==============================================================================
function TSGrpColl.AddSortItem(Item: Pointer): Integer;
//==============================================================================
begin
  with TSGrpObj(Item) do
    if (FWkOrtIndex = FSortOrtIndex) and
       ((FWettkampf=FSortWettk)or(FSortWettk=WettkAlleDummy)) then
      Result := inherited AddSortItem(Item)
    else Result := -1;
end;

//==============================================================================
function TSGrpColl.SGrpMitSnr(Wk:TWettkObj; Snr: Integer):TSGrpObj;
//==============================================================================
// erste passende SGrp in Wk, nach Name sortiert
var i    : Integer;
    SGrp : TSGrpObj;
begin
  Result := nil;
  for i:=0 to SortCount-1 do
    begin
      SGrp := GetSortItem(i);
      if (SGrp.WkOrtIndex = Veranstaltung.OrtIndex) and
         ((SGrp.Wettkampf = Wk)or(Wk=WettkAlleDummy)) and
         (Snr >= SGrp.StartnrVon) and (Snr <= SGrp.StartnrBis) then
      begin
        Result := SGrp;
        Exit;
      end;
    end;
end;

//==============================================================================
function TSGrpColl.SnrUeberlap(Wk:TWettkObj; NrVon,NrBis: Integer): Boolean;
//==============================================================================
// pr�fen auf �berlapping in allen Wettk, ausgenommen Wk
var i : Integer;
begin
  Result := false;
  for i:=0 to Count-1 do with GetPItem(i) do
    if (Wettkampf <> Wk) and (WkOrtIndex = Veranstaltung.OrtIndex) and
       (NrBis >= StartnrVon) and (NrVon <= StartnrBis) then
    begin
      Result := true;
      Exit;
    end;
end;

//==============================================================================
function TSGrpColl.FreierSnrBereich(var SnrVon:Integer; var SnrBis: Integer): Boolean;
//==============================================================================
var SGrpBuf : TSGrpObj;
    i       : Integer;
begin
  SnrVon  := 1;
  SnrBis  := cnTlnMax;
  SGrpBuf := SGrpMitSnr(WettkAlleDummy,SnrVon);
  while SGrpBuf <> nil do
  begin
    SnrVon := SGrpBuf.StartNrBis+1;
    SGrpBuf := SGrpMitSnr(WettkAlleDummy,SnrVon);
  end;
  if SnrVon <= cnTlnMax then
  begin
    for i:=0 to Veranstaltung.SGrpColl.Count-1 do
    begin
      SGrpBuf := Veranstaltung.SGrpColl[i];
      if (SGrpBuf.WkOrtIndex = Veranstaltung.OrtIndex) and
         (SGrpBuf.StartnrVon > SnrVon) and
         (SGrpBuf.StartnrVon <= SnrBis) then SnrBis := SGrpBuf.StartnrVon-1;
    end;
    Result := true;
  end else
  begin
    (* kein freier Snr-Bereich mehr vorhanden *)
    SnrVon := 0;
    SnrBis := 0;
    Result := false;
  end;
end;

//==============================================================================
function TSGrpColl.TlnGestartet(Item: TSGrpObj): Boolean;
//==============================================================================
var i : Integer;
begin
  Result := false;
  for i:=0 to TVeranstObj(FVPtr).TlnColl.Count-1 do
    if (TVeranstObj(FVPtr).TlnColl[i].SGrp = Item) and
       (TVeranstObj(FVPtr).TlnColl[i].TlnInStatus(stAbs1Start)) then
    begin
      Result := true;
      Exit;
    end;
end;

//==============================================================================
procedure TSGrpColl.Sortieren(OrtIndexNeu:Integer; WettkNeu:TWettkObj);
//==============================================================================
begin
  // immer sortieren, unabh�ngig von Sortmode, etc.
  FSortOrtIndex := OrtIndexNeu;
  FSortWettk    := WettkNeu;
  inherited Sortieren(smSortiert); (* dummy Wert f�r SortMode *)
end;

//==============================================================================
function TSGrpColl.GetStartGruppe(NameNeu:String;
                                  WkOrtIndexNeu:Integer; WettkampfNeu:TWettkObj;
                                  Startzeit1Neu: Integer; StartnrVonNeu: Integer): TSGrpObj;
//==============================================================================
(* nur nach dieser Methode unterschiedliche Obj werden in Coll aufgenommen *)
(* bei Compare werden diese Kriterien immer benutzt *)
var i : Integer;
begin
  Result := nil;
  for i:=0 to Count-1 do with Items[i] do
    if (Trim(NameNeu)    = Name)      and
       (WkOrtIndexNeu    = FWkOrtIndex)and
       (WettkampfNeu     = Wettkampf)  and
       (Startzeit1Neu    = StartZeit[wkAbs1]) and
       (StartnrVonNeu    = StartnrVon) then
    begin
      Result := Items[i];
      Exit;
    end;
end;

//==============================================================================
function TSGrpColl.SGrpZahl(Wettk:TWettkObj): Integer;
//==============================================================================
var i : Integer;
begin
  Result := 0;
  if Count>0 then for i:=0 to Count-1 do with Items[i] do
    if ((Wettk=WettkAlleDummy)or(Wettk=Wettkampf)) and
       (WkOrtIndex=TVeranstObj(FVPtr).OrtIndex) then Inc(Result);
end;

//==============================================================================
function TSGrpColl.Definiert: Boolean;
//==============================================================================
// definiert wenn mindestens eine SGrp definiert wurde
var i : Integer;
begin
  Result := true;
  for i:=0 to Veranstaltung.WettkColl.Count-1 do
    if SGrpZahl(Veranstaltung.WettkColl[i]) > 0 then Exit;
  Result := true;
end;

//==============================================================================
procedure TSGrpColl.SGrpLoeschen(Wk:TWettkObj);
//==============================================================================
var i : Integer;
begin
  if Count=0 then Exit;
  for i:=0 to Veranstaltung.TlnColl.Count-1 do
    with Veranstaltung.TlnColl[i] do
      if Wettk=Wk then EinteilungLoeschen;

  for i:=0 to Veranstaltung.MannschColl.Count-1 do
    with Veranstaltung.MannschColl[i] do
      if Wettk=Wk then OrtErgebnisseLoeschen(Veranstaltung.OrtIndex);

  i := 0;
  while (Count>0) and (i<Count) do
    if (Items[i].FWettkampf = Wk) and
       (Items[i].FWkOrtIndex = TVeranstObj(FVPtr).OrtIndex)
      then ClearItem(GetPItem(i))
      else Inc(i);
end;

//==============================================================================
function TSGrpColl.JagdStartEinzel(Abschnitt:TWkAbschnitt): Boolean;
//==============================================================================
var i : Integer;
begin
  Result := false;
  for i:=0 to Count-1 do
    if Items[i].JagdStartEinzel(Abschnitt) then
    begin
      Result := true;
      Exit;
    end;
end;

//==============================================================================
function TSGrpColl.JagdStartMannsch(Abschnitt:TWkAbschnitt): Boolean;
//==============================================================================
var i : Integer;
begin
  Result := false;
  for i:=0 to Count-1 do
    if Items[i].JagdStartMannsch(Abschnitt) then
    begin
      Result := true;
      Exit;
    end;
end;

//==============================================================================
function TSGrpColl.WettkJagdStartEinzel(Wk:TWettkObj;Abschnitt:TWkAbschnitt):Boolean;
//==============================================================================
var i    : Integer;
    SGrp : TSGrpObj;
begin
  if Wk=WettkAlleDummy then
    Result := JagdStartEinzel(Abschnitt)
  else
  begin
    Result := false;
    for i:=0 to FItems.Count-1 do
    begin
      SGrp := GetPItem(i);
      if (SGrp.FWettkampf = Wk) and SGrp.JagdStartEinzel(Abschnitt) then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;
end;

//==============================================================================
function TSGrpColl.WettkJagdStartMannsch(Wk:TWettkObj;Abschnitt:TWkAbschnitt):Boolean;
//==============================================================================
var i    : Integer;
    SGrp : TSGrpObj;
begin
  if Wk=WettkAlleDummy then
    Result := JagdStartMannsch(Abschnitt)
  else
  begin
    Result:= false;
    for i:=0 to FItems.Count-1 do
    begin
      SGrp := GetPItem(i);
      if (SGrp.FWettkampf = Wk) and SGrp.JagdStartMannsch(Abschnitt) then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;
end;

//==============================================================================
function TSGrpColl.WettkStartModus(Wk:TWettkObj; Abs:TWkAbschnitt): TStartMode;
//==============================================================================
var i : Integer;
begin
  if Abs = wkAbs1 then Result := stMassenStart
                  else Result := stOhnePause;
  for i:=0 to Count-1 do
    if (Items[i].FWkOrtIndex = TVeranstObj(FVPtr).OrtIndex) and
       (Items[i].Wettkampf = Wk) or
       (Wk = WettkAlleDummy) then // Aufruf mit WkAlle nur wenn alle SGrp gleich
    begin
      Result := Items[i].StartModus[Abs]; // Mode der 1.SGrp gilt f�r alle
      Exit;
    end;
end;

//==============================================================================
function TSGrpColl.StartModeVorgegeben(SG:TSGrpObj; Abs:TWkAbschnitt; var StrtMode:TStartMode): Boolean;
//==============================================================================
// stOhnePause,stMassenStart,stJagdStart
// StartMode gleich f�r alle SGrp in Wettk, Wert 1. SGrp gilt
var i : Integer;
begin
  Result := false;
  //if Wk = WettkAlleDummy then Exit;
  for i:=0 to Count-1 do
    if Items[i] = SG then Exit // SG ist 1.SGrp in Wk
    else
    if (Items[i].FWkOrtIndex = SG.FWkOrtIndex ) and
       (Items[i].Wettkampf = SG.Wettkampf) then
    begin
      StrtMode := Items[i].StartModus[Abs];
      Result := true;
      Exit;
    end;
end;

//==============================================================================
procedure TSGrpColl.ZeitenRunden;
//==============================================================================
var i : Integer;
begin
  for i:=0 to Count-1 do
    Items[i].ZeitenRunden;
end;


end.
