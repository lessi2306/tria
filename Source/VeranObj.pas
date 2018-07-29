unit VeranObj;

interface

uses
  Classes,SysUtils,Dialogs,Math,DateUtils,Windows,
  AllgConst,AllgObj,AkObj,MannsObj,WettkObj,SGrpObj,SMldObj,TlnObj,OrtObj;

type

  TVeranstObj = class(TTriaPersistent)
  protected
    FName     : String;
    //FArt      : TVeranstArt;
    FSerie    : Boolean;
    FOrtIndex : Integer;
    function    GetBPObjType: Word; override;
    procedure   SetOrtIndex(OrtIndexNeu: Integer);
    function    GetOrt: TOrtObj;
  public
    OrtColl         : TOrtCollection;
    DisqGrundColl   : TTextCollection;
    DisqNameColl    : TTextCollection;
    MannschNameColl : TMannschNameColl;
    VereinColl      : TMannschNameColl;
    WettkColl       : TWettkColl;
    SGrpColl        : TSGrpColl;
    SMldColl        : TSMldColl;
    TlnColl         : TTlnColl;
    MannschColl     : TMannschColl;
    constructor Create;
    destructor  Destroy; override;
    function    Load: Boolean; override;
    procedure   LoadKorrektur;
    function    Store: Boolean; override;
    function    OrtZahl: Integer;
    function    OrtName: String;
    function    NameDefiniert: Boolean;
    function    Definiert: Boolean;
    //function    Serie: Boolean;
    function    MschSpalteUeberschrift(Wk:TWettkObj): String;
    function    TlnMschSpalteUeberschrift(Wk:TWettkObj): String;
    function    VereinSpalteUeberschrift(Wk:TWettkObj): String;
    function    TlnMschGroesseBezeichnung(Wk:TWettkObj): String;
    function    MschSpalteName(Wk:TWettkObj): String; // �berschrift Ohne '/'
    function    ObjSize: Integer;
    property Name: String read FName write FName;
    //property Art: TVeranstArt read FArt write FArt;
    property Serie: Boolean read FSerie write FSerie;
    property OrtIndex: Integer read FOrtIndex write SetOrtIndex;
    property Ort: TOrtObj read GetOrt;
  end;

var Veranstaltung : TVeranstObj;
    EinlVeranst   : TVeranstObj;

implementation

uses AllgFunc,DateiDlg,TriaMain,TlnErg,CmdProc,History,ZtEinlDlg;


(******************************************************************************)
(*  Methoden von TVeranstObj                                                  *)
(******************************************************************************)

// protected Methoden

//------------------------------------------------------------------------------
function TVeranstObj.GetBPObjType: Word;
//------------------------------------------------------------------------------
// Object Types aus Version 7.4 Stream Registration Records
begin
  Result := rrVeranstObj;
end;

//------------------------------------------------------------------------------
procedure TVeranstObj.SetOrtIndex(OrtIndexNeu:Integer);
//------------------------------------------------------------------------------
begin
  if OrtIndexNeu <> FOrtIndex then
    if OrtIndexNeu < 0 then FOrtIndex := 0 (* mindestens 1 Eintrag vorhanden *)
    else if OrtIndexNeu >= OrtColl.Count then FOrtIndex := OrtColl.Count-1
    else FOrtIndex := OrtIndexNeu;
end;

//------------------------------------------------------------------------------
function TVeranstObj.GetOrt: TOrtObj;
//------------------------------------------------------------------------------
begin
  if (FOrtIndex>=0) and (FOrtIndex<OrtColl.Count)
    then Result := OrtColl[FOrtIndex]
    else Result := nil;
end;

// public Methoden

//==============================================================================
Constructor TVeranstObj.Create;
//==============================================================================
begin
  inherited Create(Self);
  FName               := '';
  //FArt                := vaEinzel;
  FSerie              := false;
  FOrtIndex           := 0; //in Load, bei Serie von Ini-Datei �bernehmen (SerieOrtIndex)
  //InitAllgAk(Self);  in FormCreate
  OrtColl             := TOrtCollection.Create(Self);
  DisqGrundColl       := TTextCollection.Create(Self);
  DisqNameColl        := TTextCollection.Create(Self);
  MannschNameColl     := TMannschNameColl.Create(Self);
  VereinColl          := TMannschNameColl.Create(Self);
  WettkColl           := TWettkColl.Create(Self,TWettkObj);//vor SGrpColl
  SGrpColl            := TSGrpColl.Create(Self,TSGrpObj);
  SMldColl            := TSMldColl.Create(Self,TSMldObj);
  TlnColl             := TTlnColl.Create(Self,TTlnObj,pbMitStepping,tmTln);
  MannschColl         := TMannschColl.Create(Self,TMannschObj);
  MschGrListe         := TIntegerCollection.Create(Self);
end;

//==============================================================================
destructor TVeranstObj.Destroy;
//==============================================================================
begin
  // bei exception in Create wird destroy automatisch aufgerufen
  // Collections m�ssen dann noch nicht initialisiert sein
  // Meldung.Max muss auf ObjSize gesetzt sein
  // Veranstaltung vorher = nil gesetzt
  FreeAndNil(MschGrListe);
  FreeAndNil(MannschColl);
  FreeAndNil(TlnColl);
  FreeAndNil(SMldColl);
  FreeAndNil(SGrpColl);
  FreeAndNil(WettkColl);
  if MannschNameColl<>nil then
    HauptFenster.ProgressBarStep(MannschNameColl.CollSize);
  FreeAndNil(MannschNameColl); // kein Stepping
  if VereinColl<>nil then
    HauptFenster.ProgressBarStep(VereinColl.CollSize);
  FreeAndNil(VereinColl); // kein Stepping
  if DisqGrundColl<>nil then
    HauptFenster.ProgressBarStep(DisqGrundColl.CollSize);
  FreeAndNil(DisqGrundColl);  //kein Stepping
  if DisqNameColl<>nil then
    HauptFenster.ProgressBarStep(DisqNameColl.CollSize);
  FreeAndNil(DisqNameColl);  //kein Stepping
  FreeAndNil(OrtColl);
  //ClearAllgAk;   in FormDestroy
  inherited Destroy;
end;

//==============================================================================
function TVeranstObj.Load: Boolean;
//==============================================================================
// ProgressBar vorher initialisiert
var i,j    : Integer;
    StrBuf : String;
    Buf    : SmallInt;
    LBuf   : LongInt;
    StreamPosAlt : Int64;
//..............................................................................
function AkKuerzelLaden(Wk:TWettkObj): Boolean;
var i:Integer;
    S : String;
begin
  Result := false;
  with TriaStream do with Wk do
  try
    for i:=0 to AltMKlasseColl[tmTln].Count-1 do with AltMKlasseColl[tmTln][i] do
    begin
      ReadStr(S);
      Kuerzel := S;
    end;
    for i:=0 to AltWKlasseColl[tmTln].Count-1 do with AltWKlasseColl[tmTln][i] do
    begin
      ReadStr(S);
      Kuerzel := S;
    end;
    for i:=0 to AltMKlasseColl[tmMsch].Count-1 do with AltMKlasseColl[tmMsch][i] do
    begin
      ReadStr(S);
      Kuerzel := S;
    end;
    for i:=0 to AltWKlasseColl[tmMsch].Count-1 do with AltWKlasseColl[tmMsch][i] do
    begin
      ReadStr(S);
      Kuerzel := S;
    end;
  except
    Exit;
  end;
  Result := true;
end;
//..............................................................................
begin
  // Meldung.Max muss auf TriaStream.Size gesetzt sein
  Result := false;

  try

    StreamPosAlt := TriaStream.Position;
    //BarPosAlt    := HauptFenster.ProgressBarPosition;
    if not inherited Load then Exit;
    with TriaStream do
    begin
      ReadStr(FName);
      //ReadBuffer(FArt, cnSizeOfWord); ==> ersetz durch FSerie
      ReadBuffer(Buf, cnSizeOfSmallInt); // cnSizeOfWord=cnSizeOfSmallInt=2
      // ab 2011-2.4 Serie als Boolean gespeichert, vorher als
      // TVeranstArt = (vaEinzel,vaCup,vaLiga)
      if (TriDatei.Version.Jahr<'2011')or
         (TriDatei.Version.Jahr='2011')and(TriDatei.Version.Nr<'2.4') then
        if Buf=2 then Buf := 1;
      if Buf=1 then FSerie := true
               else FSerie := false;
      ReadStr(StrBuf); // Dummy, FJahr nicht mehr benutzt
      ReadBuffer(Buf, cnSizeOfSmallInt); // Dummy, FOrtIndex aus Ini-datei - 2008
    end;
    HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
    if not OrtColl.Load then Exit; // mit Stepping
    if FSerie and
       (SerieOrtIndex > 0) and (SerieOrtIndex < OrtColl.Count) then
      FOrtIndex := SerieOrtIndex //bei Neustart aus Ini-Datei sonst letzter Index
    else FOrtIndex := 0; // default=0
    // SortOrtIndex setzen, damit beim Laden richtig sortiert wird
    SGrpColl.SortOrtIndex    := FOrtIndex;
    TlnColl.SortOrtIndex     := FOrtIndex;
    MannschColl.SortOrtIndex := FOrtIndex;

    StreamPosAlt := TriaStream.Position;
    if not DisqGrundColl.Load then Exit; // kein Stepping
    HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);

    with TriDatei.Version do
    begin
      // ab 2008-2.0 DisqName pro Tln gespeichert
      if (Jahr>'2008')or(Jahr='2008')and(Nr>='2.0') then
      begin
        StreamPosAlt := TriaStream.Position;
        if not DisqNameColl.Load then Exit; // kein Stepping
        HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
      end;
      StreamPosAlt := TriaStream.Position;
      if not MannschNameColl.Load then Exit; // kein Stepping
      HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);

      // ab 11.5.9 Verein und Mannschaft separat, muss vor TlnColl
      if (Jahr>'2011')or((Jahr='2011')and(Nr>='5.9')) then
      begin
        StreamPosAlt := TriaStream.Position;
        if not VereinColl.Load then Exit; // kein Stepping
        HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
      end else
      begin
        for i:=0 to MannschNameColl.Count-1 do
          VereinColl.InsertName(MannschNameColl[i]^);
      end;

      if not WettkColl.Load then Exit; // mit Stepping
      if not SGrpColl.Load then Exit;  // mit Stepping
      if not SMldColl.Load then Exit;  // mit Stepping
      if not TlnColl.Load then Exit;   // mit Stepping

      // ab 2004-1.1 neues DateiFormat
      if (Jahr='2003')or((Jahr='2004')and(Nr<'1.1')) then
      begin
        StreamPosAlt := TriaStream.Position;
        if not MannschColl.Load then Exit;
        HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
        (*......................................................................*)
        (* Datei-Erweiterungen f�r 2003-1.6                                     *)
        (*......................................................................*)
        // Erweiterung wird von �lteren TRIA-Versionen einfach ignoriert
        // TlnColl - 2003-1.6
        // FRngAktWkColl, FRngAktAlleWkColl in 1.5 eingef�hrt aber nicht gespeichert,
        // deshalb nach dem Laden neu berechnen wenn Tln im Ziel
        // Als Erweiterung gespeichert ab 2003-1.6
        if (Jahr>'2003')or(Nr>='1.6') then
        begin
          // Load �berspringen f�r: FRngAktWkColl/RngAktAlleWkColl
          StreamPosAlt := TriaStream.Position;
          TriaStream.Position := TriaStream.Position + 2 * TlnColl.Count *
                                 (cnSizeOfWord + 3 * cnSizeOfSmallInt +
                                  OrtColl.Count * cnSizeOfWord);
          HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
        end;

        // MannschColl - 2003-1.6
        // StartZeitColl eingef�hrt f�r MannschObj
        // MannschColl muss deshalb geladen werden, obwohl nachher neu definiert
        if (Jahr>'2003')or(Nr>='1.6') then
        begin
          StreamPosAlt := TriaStream.Position;
          for i:=0 to MannschColl.Count-1 do
            with MannschColl[i] do
            begin
              if not AbsStZeitColl[wkAbs1].Load then Exit;  //in Sek, aber nicht benutzt
              if not AbsZeitColl[wkAbs1].Load then Exit;
              if not AbsStZeitColl[wkAbs2].Load then Exit;
              if not AbsZeitColl[wkAbs2].Load then Exit;
              if not AbsStZeitColl[wkAbs3].Load then Exit;
            end;
          HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
        end;

        // WettkObj.OrtWertg in 2003-1.9 eingef�hrt
        if (Jahr>'2003')or(Nr>='1.9') then
        begin
          StreamPosAlt := TriaStream.Position;
          for i:=0 to WettkColl.Count-1 do with TriaStream do
          begin
            ReadBuffer(Buf,cnSizeOfSmallInt);
            WettkColl[i].PunktGleichOrtIndx[tmTln] := Buf;
            WettkColl[i].PunktGleichOrtIndx[tmMsch] := Buf;
          end;
          HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
        end;

        // StrafZeit in 2003-2.0 eingef�hrt
        if (Jahr>'2003')or(Nr>='2.0') then
        begin
          StreamPosAlt := TriaStream.Position;
          for i:=0 to TlnColl.Count-1 do
          begin
            if not TlnColl[i].StrafZeitColl.Load then Exit; // in Sek
            for j:=0 to TlnColl[i].StrafZeitColl.Count-1 do
              TlnColl[i].StrafZeitColl[j] := TlnColl[i].StrafZeitColl[j] * 100; // in 1/100
          end;

          HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
        end;

        MannschColl.Clear; //Msch mit Wettk=nil werden beim Einlesen nicht gel�scht

        // Optionales Teilnehmer-Textfeld in 2004-1.1 eingef�hrt
        for i:=0 to WettkColl.Count-1 do
          if not TlnColl.LandDefiniert(WettkColl[i],wgStandWrtg) then
            WettkColl[i].TlnTxt := '';
      end;

      // AkObj erweitert mit Kuerzel, am Ende der datei gespeichert, damit auch
      // von �lteren Versionen lesbar,
      // ab 2008-2.0 in AkObj.Load
      if ((Jahr>'2005')or(Jahr='2005')and(Nr>='0.3')) and
         ((Jahr<'2008')or(Jahr='2008')and(Nr<'2.0')) then
      begin
        StreamPosAlt := TriaStream.Position;
        //if not AkKuerzelLaden(WettkAlleDummy) then Exit;
        for i:=0 to WettkColl.Count-1 do
        begin
          if i=0 then if not AkKuerzelLaden(WettkColl[i]) then Exit; // statt WettkAlleDummy
          if not AkKuerzelLaden(WettkColl[i]) then Exit;
        end;
        HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
      end;

      if ((Jahr>'2005')or(Jahr='2005')and(Nr>='0.4')) and
         ((Jahr<'2008')or(Jahr='2008')and(Nr<'2.0')) then //ab 2008-2.0 in SMldObj
      begin
        StreamPosAlt := TriaStream.Position;
        for i:=0 to SMldColl.Count-1 do with SMldColl[i] do
        with TriaStream do
        begin
          //if not ReadStr(StrBuf) then Exit;
          ReadStr(StrBuf);
          HausNr := StrBuf;
          //if not ReadStr(StrBuf) then Exit;
          ReadStr(StrBuf);
          PLZ := StrBuf;
        end;
        HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
      end;

      if ((Jahr>'2005')or(Jahr='2005')and(Nr>='1.1')) and
         ((Jahr<'2008')or(Jahr='2008')and(Nr<'2.0')) then //ab 2008-2.0 in SGrpObj
      begin
        StreamPosAlt := TriaStream.Position;
        for i:=0 to SGrpColl.Count-1 do with SGrpColl[i] do
        with TriaStream do
        begin
          ReadBuffer(LBuf, cnSizeOfLongInt);
          if (Jahr<'2006')or(Jahr='2006')and(Nr<'0.3') then
            StartZeit[wkAbs4] := LBuf * 100  // Sek ==> 1/100
          else
            StartZeit[wkAbs4] := LBuf * 10;  // 1/10 ==> 1/100
          if (StartZeit[wkAbs4]<0) or(StartZeit[wkAbs4] >= cnZeit24_00) then StartZeit[wkAbs4] := -1;
          ReadBuffer(Buf, cnSizeOfSmallInt);
          case Buf of
            1: StartModus[wkAbs4]   := stMassenStart;
            2: StartModus[wkAbs4]   := stJagdStart;
            else StartModus[wkAbs4] := stOhnePause;
          end;
          ReadBuffer(LBuf, cnSizeOfLongInt);
          if (Jahr<'2006')or(Jahr='2006')and(Nr<'0.3') then
            ErstZeit[wkAbs3] := LBuf * 100  // Sek ==> 1/100
          else
            ErstZeit[wkAbs3] := LBuf * 10;  // 1/10 ==> 1/100
          if ErstZeit[wkAbs3]<0 then ErstZeit[wkAbs3] := 0;
        end;
        HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
      end;

      // Option ZeitFormat in Datei setzen, ab 2008-2.0 auch 1/100
      if (Jahr>'2006')or(Jahr='2006')and(Nr>='1.0') then
      begin
        StreamPosAlt := TriaStream.Position;
        TriaStream.ReadBuffer(Buf, cnSizeOfSmallInt);
        if Veranstaltung = nil then// Zeitformat nur beim Laden, nicht beim Import setzen
          case Buf of
            1    : ZeitFormat := zfZehntel;
            2    : ZeitFormat := zfHundertstel; // erst ab 2008-2.0
            else   ZeitFormat := zfSek;
          end
        else  // Import
          case Buf of
            1    : HauptFenster.ImpFrame.ImpZeitFormat := zfZehntel;
            2    : HauptFenster.ImpFrame.ImpZeitFormat := zfHundertstel;
            else   HauptFenster.ImpFrame.ImpZeitFormat := zfSek;
          end;
        HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
      end
      else
        if Veranstaltung = nil then// Zeitformat nur beim Laden, nicht beim Import setzen
          ZeitFormat := zfSek;

    end;

  except
    Result := false;
    Exit; // Exception afangen, hier keine Meldung
  end;

  //UpdateProgressBar; // nur zur Sicherheit, eigentlich nicht n�tig
  Result := true;
end;

//==============================================================================
procedure TVeranstObj.LoadKorrektur;
//==============================================================================
// Korrekturen nach Laden von �lteren Datei-Versionen
var i,j  : Integer;
    PStr : PString;
    TS   : TTimeStamp;
    ST   : TSystemTime;
    DT   : TDateTime;
    Bool : Boolean;
begin
  with TriDatei.Version do
  begin
    if (Jahr<'2005') or
       (Jahr='2005')and(Nr<'1.1') then // auch bis 2005-1.0 Gro�/Klein unterschieden
    //auf doppelte Tln pr�fen - gab es in �lteren Datein, durch Importfehler
    // 2. Tln l�schen
    for i:=TlnColl.Count-1 downto 1 do
      with TlnColl[i] do
        if TlnColl.SucheTln(TlnColl[i],
                            Name,VName,Verein,MannschName,Wettk) <> nil then
        // letzte identische Tln in TlnColl l�schen
        begin
          //ShowMessage(Name+', '+VName+', '+MannschName+'; '+Wettk.Name);
          TlnColl.ClearIndex(i);
        end;

    if (Jahr='2003')and(Nr<'2.0') then
    begin
      SofortRechnen   := true;
      BackupErstellen := true;
    end;

    if Jahr<'2005' then
    // auf doppelte MannschName pr�fen - Gro�/Kleinschreibung nicht unterscheiden
    // 2. Name l�schen
    for i:=MannschNameColl.Count-1 downto 1 do
      if MannschNameColl[i] <> nil then
      begin
        PStr:=MannschNameColl.SucheNamePtr(MannschNameColl[i],MannschNameColl[i]^);
        if PStr<> nil then
        begin
          // MannschName in MannschColl,TlnColl,SMldColl korrigieren
          for j:=0 to MannschColl.Count-1 do with MannschColl[j] do
            if Name = MannschNameColl[j]^ then
            begin
              if Wettk <> nil then Wettk.MschModified := true;
              MannschColl.ClearIndex(j);
            end;
          for j:=0 to TlnColl.Count-1 do with TlnColl[j] do
            if MannschNamePtr = MannschNameColl[i] then MannschNamePtr := PStr;
          for j:=0 to SMldColl.Count-1 do with SMldColl[j] do
            if MannschNamePtr = MannschNameColl[i] then MannschNamePtr := PStr;
          MannschNameColl.ClearIndex(i);
        end;
      end;

    if (Jahr='2006')and(Nr<'1.2') then  // FBearbeitet wurde falsch eingelesen
    begin
      Bool := false;
      for i:=0 to TlnColl.Count-1 do with TlnColl[i] do
        try
          DT := TimeStampToDateTime(Bearbeitet);
          if YearOf(DT) <> 2006 then // nur 2006 akzeptieren
          begin
            Bool := true;
            Break;
          end
        except
          Bool := true;
          Break;
        end;

      if Bool then // unsinniges Datum, generell auf aktuelles datum/Zeit setzen
      begin
        GetLocalTime(ST);
        DT := SystemTimeToDateTime(ST);
        TS := DateTimeToTimeStamp(DT);
        for i:=0 to TlnColl.Count-1 do
          TlnColl[i].Bearbeitet := TS;
      end;
    end;

    if Jahr<'2007' then  // es gibt einzelne Dateien mit Snr=0: illegal
      for i:=SGrpColl.Count-1 downto 0 do
        with SGrpColl[i] do
          if (StartnrVon = 0) or (StartnrBis =0 ) then
          begin
            for j:=0 to TlnColl.Count-1 do
              with TlnColl[j] do if SGrp=SGrpColl[i] then EinteilungLoeschen;
            SGrpColl.ClearIndex(i);
          end;

    if (Jahr<'2011')or                 // Leichen in MannschNameColl l�schen
       (Jahr='2011')and(Nr<'4.3') then
      for i:=MannschNameColl.Count-1 downto 0 do
        if (MannschNameColl[i] = nil) or
           not TlnColl.MannschNameVorhanden(MannschNameColl[i]) and
           not SMldColl.MannschNameVorhanden(MannschNameColl[i]) then
          MannschNameColl.ClearIndex(i);

  end;
end;

//==============================================================================
function TVeranstObj.Store: Boolean;
//==============================================================================
var Buf : SmallInt;

begin
  // ProgressBar.Max muss auf ObjSize gesetzt sein
  Result := false;

  try
    if not inherited Store then Exit;
    // MannschColl wird nicht mehr gespeichert
    HauptFenster.ProgressBarStep(MannschColl.CollSize);
    with TriaStream do
    begin
      WriteStr(FName);
      if FSerie then Buf := 1
                else Buf := 0;
      WriteBuffer(Buf, cnSizeOfSmallInt); // Dummy f�r FOrtIndex
      WriteStr(IntToStr(0));              // Dummy f�r FJahr
      Buf := 0;
      WriteBuffer(Buf, cnSizeOfSmallInt); // Dummy f�r FOrtIndex
    end;
    if not OrtColl.Store then Exit;
    HauptFenster.ProgressBarStep(DisqGrundColl.CollSize);
    if not DisqGrundColl.Store then Exit;
    // ab 2008-2.0 DisqName pro Tln
    HauptFenster.ProgressBarStep(DisqNameColl.CollSize);
    if not DisqNameColl.Store then Exit;
    HauptFenster.ProgressBarStep(MannschNameColl.CollSize);
    if not MannschNameColl.Store then Exit;
    // ab 11.5.9 Verein und Mannschaft separat
    if (TriDatei.Version.Jahr>'2011')or
       ((TriDatei.Version.Jahr='2011')and(TriDatei.Version.Nr>='5.9')) then
      if not VereinColl.Store then Exit;
    if not WettkColl.Store then Exit;
    if not SGrpColl.Store then Exit;
    if not SMldColl.Store then Exit;
    if not TlnColl.Store then Exit;
    {HauptFenster.ProgressBarStep(DisqGrundColl.CollSize);
    if not DisqGrundColl.Store then Exit;
    HauptFenster.ProgressBarStep(MannschNameColl.CollSize); }

    // ab 2006-1.0 Option DecZeiten in Datei speichern, ab 2008-2.0 ZeitFormat
    case ZeitFormat of
      zfZehntel     : Buf := 1;
      zfHundertstel : Buf := 2;
      else            Buf := 0;
    end;
    TriaStream.WriteBuffer(Buf, cnSizeOfSmallInt);


  except
    Exit;
  end;

  Result := true;
end;

//==============================================================================
function TVeranstObj.OrtZahl: Integer;
//==============================================================================
begin
  if OrtColl <> nil then Result := OrtColl.Count
                    else Result := 0;
end;

//==============================================================================
function TVeranstObj.NameDefiniert: Boolean;
//==============================================================================
begin
  Result := (Length(FName) > 0);
end;

//==============================================================================
function TVeranstObj.Definiert: Boolean;
//==============================================================================
begin
  Result := NameDefiniert and
            (WettkColl<>nil) and (WettkColl.Count>0) and
            ((not FSerie) or (OrtColl<>nil)and(OrtColl.Count>=seOrtMin));
end;

//==============================================================================
function TVeranstObj.OrtName: String;
//==============================================================================
begin
  if (FOrtIndex>=0) and (FOrtIndex<OrtColl.Count)
    then Result := OrtColl[FOrtIndex].Name
    else Result := '';
end;

//==============================================================================
function TVeranstObj.TlnMschSpalteUeberschrift(Wk:TWettkObj): String;
//==============================================================================
var i : Integer;
    S : String;
begin
  Result := 'Verein/Ort'; // default
  if WettkColl.Count =0 then Exit;

  if Wk = WettkAlleDummy then
  begin
    S := Result; // 'Verein/Ort'
    if WettkColl[0].MschWrtgMode = wmSchultour then S := 'Schulklasse'
    else
    if WettkColl[0].MschWettk or
       (WettkColl[0].WettkArt=waTlnTeam) or (WettkColl[0].WettkArt=waTlnStaffel) then
      S := 'Mannschaft'
    else Exit; // 'Verein/Ort'
    for i:=1 to WettkColl.Count-1 do
    begin
      if (S='Schulklasse') and (WettkColl[i].MschWrtgMode<>wmSchultour) then Exit;
      if (S='Mannschaft')  and not WettkColl[i].MschWettk and
                               (WettkColl[i].WettkArt<>waTlnTeam)and
                               (WettkColl[i].WettkArt<>waTlnStaffel) then Exit;
    end;
    Result := S; // alle Wk gleich
  end else
  if Wk.MschWrtgMode = wmSchultour then Result := 'Schulklasse'
  else
  if Wk.MschWettk or (Wk.WettkArt=waTlnTeam) or (Wk.WettkArt=waTlnStaffel) then
    Result := 'Mannschaft';
end;

//==============================================================================
function TVeranstObj.VereinSpalteUeberschrift(Wk:TWettkObj): String;
//==============================================================================
var i : Integer;
    S : String;
begin
  Result := 'Verein/Ort'; // default
  if WettkColl.Count =0 then Exit;

  if Wk = WettkAlleDummy then
  begin
    S := Result; // 'Verein/Ort'
    if WettkColl[0].MschWrtgMode = wmSchultour then S := 'Schulklasse'
    else
    if WettkColl[0].MschWettk or
       (WettkColl[0].WettkArt=waTlnTeam) or (WettkColl[0].WettkArt=waTlnStaffel) then
      S := 'Mannschaft'
    else Exit; // 'Verein/Ort'
    for i:=1 to WettkColl.Count-1 do
    begin
      if (S='Schulklasse') and (WettkColl[i].MschWrtgMode<>wmSchultour) then Exit;
      if (S='Mannschaft')  and not WettkColl[i].MschWettk and
                               (WettkColl[i].WettkArt<>waTlnTeam)and
                               (WettkColl[i].WettkArt<>waTlnStaffel) then Exit;
    end;
    Result := S; // alle Wk gleich
  end else
  if Wk.MschWrtgMode = wmSchultour then Result := 'Schulklasse'
  else
  if Wk.MschWettk or (Wk.WettkArt=waTlnTeam) or (Wk.WettkArt=waTlnStaffel) then
    Result := 'Mannschaft';
end;

//==============================================================================
function TVeranstObj.TlnMschGroesseBezeichnung(Wk:TWettkObj): String;
//==============================================================================
var i : Integer;
    S : String;
begin
  Result := 'Vereinsgr��e'; // default
  if WettkColl.Count =0 then Exit;

  if Wk = WettkAlleDummy then
  begin
    S := Result; // 'Vereinsgr��e'
    if WettkColl[0].MschWrtgMode = wmSchultour then S := 'Klassengr��e'
    else
    if WettkColl[0].MschWettk or
       (WettkColl[0].WettkArt=waTlnTeam) or (WettkColl[0].WettkArt=waTlnStaffel) then
      S := 'Mannschaftsgr��e'
    else Exit; // 'Verein/Ort'
    for i:=1 to WettkColl.Count-1 do
    begin
      if (S='Klassengr��e') and (WettkColl[i].MschWrtgMode<>wmSchultour) then Exit;
      if (S='Mannschaftsgr��e')  and not WettkColl[i].MschWettk and
                               (WettkColl[i].WettkArt<>waTlnTeam)and
                               (WettkColl[i].WettkArt<>waTlnStaffel) then Exit;
    end;
    Result := S; // alle Wk gleich
  end else
  if Wk.MschWrtgMode = wmSchultour then Result := 'Klassengr��e'
  else
  if Wk.MschWettk or (Wk.WettkArt=waTlnTeam) or (Wk.WettkArt=waTlnStaffel) then
    Result := 'Mannschaftsgr��e';
end;
//==============================================================================
function TVeranstObj.MschSpalteUeberschrift(Wk:TWettkObj): String;
//==============================================================================
var i : Integer;
begin
  Result := 'Mannschaft'; // default
  if WettkColl.Count > 0 then
    if Wk = WettkAlleDummy then
    begin
      for i:=0 to WettkColl.Count-1 do
        if WettkColl[i].MschWrtgMode <> wmSchultour then Exit;
      Result := 'Schulklasse'; // alle Wk wmSchultour
    end else
    if Wk.MschWrtgMode = wmSchultour then Result := 'Schulklasse';
end;

//==============================================================================
function TVeranstObj.MschSpalteName(Wk:TWettkObj): String;
//==============================================================================
begin
  Result := TlnMschSpalteUeberschrift(Wk);
  if Result = 'Verein/Ort' then Result := 'VereinOrt';
end;

//==============================================================================
function TVeranstObj.ObjSize: Integer;
//==============================================================================
// nur Collections ber�cksichtigen
begin
  Result := OrtColl.CollSize +
            DisqGrundColl.CollSize +
            DisqNameColl.CollSize +
            MannschNameColl.CollSize +
            WettkColl.CollSize +
            SGrpColl.CollSize +
            SMldColl.CollSize +
            TlnColl.CollSize +
            MannschColl.CollSize;
end;


end.
