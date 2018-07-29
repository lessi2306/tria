unit ListFmt;

interface

uses SysUtils,Math,
     AllgConst,AllgFunc,TriaMain,VeranObj,WettkObj,TlnObj,MannsObj,AkObj;

function GetListName: String;
function GetListType(ListMode:TListMode;RepWk:TWettkObj;RepWrtg:TWertungMode;RepMschGr:Integer): TListType;
//function GetListType(ListMode:TListMode;RepWk:TReportWkObj;RepAk:TAkObj): TListType; overload
//function GetTitel2: String; overload;
function GetTitel2(RepWk:TWettkObj;RepWrtg:TWertungMode): String; //overload;
function GetTitel3(ListType:TListType;RepWk:TWettkObj; Ak:TAkObj): String;
function GetColType(ListType:TListType; RepWk:TWettkObj; C:Integer; ListMode:TListMode):TColType;
function GetColHeader(C:TColType;RepWk:TWettkObj):String;
function GetColData(RepWk:TWettkObj;RepWrtg:TWertungMode;RepAk:TAkObj;Tln:TTlnObj;
                    C:TColType;var TrennLinie:Boolean;ListMode:TListMode;Rnd:Integer):String; overload;
function GetColData(RepWk:TWettkObj;RepWrtg:TWertungMode;RepAk:TAkObj;Tln:TTlnObj;
                    C:TColType;var TrennLinie:Boolean;ListMode:TListMode):String; overload;

implementation

uses AnsFrm,ImpDlg;

(******************************************************************************)
function GetListName: String;
(******************************************************************************)
begin
  Result := anString(HauptFenster.Ansicht);
end;

{(******************************************************************************)
function GetListType(ListMode:TListMode;RepWk:TReportWkObj;RepAk:TAkObj): TListType;
(******************************************************************************)
begin
  Result := GetListType(ListMode,RepWk.Wettk,RepWk.Wrtg,RepWk.Wettk.MschGroesse[RepAk.Sex]);
end;}

(******************************************************************************)
function GetListType(ListMode:TListMode;RepWk:TWettkObj;RepWrtg:TWertungMode;RepMschGr:Integer):TListType;
(******************************************************************************)
// sowohl f�r Bildschirm als f�r Reports
// Veranstaltung kann nil sein
// ListMode: lmSchirm, lmReport(Rave,HTML), lmExport/lmImport (Excel,Text)
// RepMschGr nur f�r anMschErgKompakt
//------------------------------------------------------------------------------
function SpalteAk: Boolean;
// f�r Tln-ErgListen: anTlnErg, anTlnErgSerie
var i : Integer;
//..............................................................................
function AkVorhanden(Ak:TAkObj): Boolean;
begin
  Result := false;
  with RepWk do
    if HauptFenster.TlnAnsicht then
      case Ak.Sex of
        cnSexBeide,
        cnMixed     : Result := (AltMKlasseColl[tmTln].Count > 0) or
                                (AltWKlasseColl[tmTln].Count > 0);
        cnMaennlich : Result :=  AltMKlasseColl[tmTln].Count > 0;
        cnWeiblich  : Result :=  AltWKlasseColl[tmTln].Count > 0;
      end;
end;
//.............................................................................
begin
  if ListMode = lmSchirm then
    Result :=  (HauptFenster.SortKlasse.Wertung <> kwAltKl) and
                AkVorhanden(HauptFenster.SortKlasse)
  else // lmReport,lmExport
  begin
    Result := false;
    for i:=0 to ReportAkListe.Count-1 do
      if (TAkObj(ReportAkListe[i]).Wertung <> kwAltKl) and
          AkVorhanden(TAkObj(ReportAkListe[i])) then
      begin
        Result := true;
        Exit;
      end;
  end;
end;

//------------------------------------------------------------------------------
function SpalteTlnTxt: Boolean;
begin
  if ListMode = lmSchirm then
    Result := not StrGleich(RepWk.TlnTxt,'')
  else // lmReport,lmExport
    Result := ReportTlnSpalte = tsMitTlnTxtSpalte;
end;

//------------------------------------------------------------------------------
function SpalteAusKonk: Boolean;
// f�r Startliste Tln: Spalte nur wenn mindestens 1 Tln in Liste a.K.
var i : Integer;
begin
  with HauptFenster do
  if ListMode = lmSchirm then
    Result := Veranstaltung.TlnColl.TlnAusserTagWrtg(RepWk,RepWrtg,SortKlasse,SortStatus)
  else // lmReport,lmExport
  begin
    Result := false;
    for i:=0 to ReportAkListe.Count-1 do
      if Veranstaltung.TlnColl.TlnAusserTagWrtg(RepWk,RepWrtg,
                                    TAkObj(ReportAkListe[i]),SortStatus) then
      begin
        Result := true;
        Exit;
      end;
  end;
end;

//------------------------------------------------------------------------------
function SpalteSerieWrtg: Boolean;
// Spalte nur wenn mindestens 1 Tln in Liste ohne Serienwertung
var i : Integer;
begin
  with HauptFenster do
  if not Veranstaltung.Serie then Result := false
  else
  if ListMode = lmSchirm then
    Result := Veranstaltung.TlnColl.TlnAusserSerWrtg(RepWk,SortKlasse,SortStatus)
  else // lmReport,lmExport
  begin
    Result := false;
    for i:=0 to ReportAkListe.Count-1 do
      if Veranstaltung.TlnColl.TlnAusserSerWrtg(RepWk,
                                       TAkObj(ReportAkListe[i]),SortStatus) then
      begin
        Result := true;
        Exit;
      end;
  end;
end;

//------------------------------------------------------------------------------
begin
  Result := ltFehler;
  if Veranstaltung = nil then Exit; // Grid bleibt leer bei Startup

  with HauptFenster do
  case Ansicht of

    anAnmEinzel,anAnmSammel: // kein RaveReport
      case ListMode of
        lmSchirm : Result := ltMldLstTlnSchirm;
        lmExport : Result := ltMldLstTlnExp;
        lmImport : Result := ltTlnImport;
        else       Result := ltFehler; // lmReport kommt nicht vor
      end;

    anTlnStart:
      if RepWk.WettkArt = waTlnStaffel then // Abschn: 2..8
        Result := TListType(Integer(ltStLstStaffelTln2) + RepWk.AbSchnZahl - 2)
      else
      if RepWk.WettkArt = waTlnTeam then // TeamGr��e: 2..8
        Result := TListType(Integer(ltStLstStaffelTln2) + RepMschGr - 2)
      else
      // Ak-Spalte bei Startliste immer, auch wenn nur eine Ak
      if SpalteSerieWrtg then
        if SpalteAusKonk then
          if (RepWk.Startbahnen=0) or
             (SortMode in [smTlnAbs2Startzeit..smTlnAbs8Startzeit]) then
            if SpalteTlnTxt then Result:=ltStLstTlnATSLnd
                            else Result:=ltStLstTlnATS
          else if SpalteTlnTxt then Result:=ltStLstTlnATSBnLnd
                               else Result:=ltStLstTlnATSBn
        else
          if (RepWk.Startbahnen=0) or
             (SortMode in [smTlnAbs2Startzeit..smTlnAbs8Startzeit]) then
            if SpalteTlnTxt then Result:=ltStLstTlnASLnd
                            else Result:=ltStLstTlnAS
          else if SpalteTlnTxt then Result:=ltStLstTlnASBnLnd
                               else Result:=ltStLstTlnASBn
      else
        if SpalteAusKonk then
          if (RepWk.Startbahnen=0) or
             (SortMode in [smTlnAbs2Startzeit..smTlnAbs8Startzeit]) then
            if SpalteTlnTxt then Result:=ltStLstTlnATLnd
                            else Result:=ltStLstTlnAT
          else if SpalteTlnTxt then Result:=ltStLstTlnATBnLnd
                               else Result:=ltStLstTlnATBn
        else
          if (RepWk.Startbahnen=0) or
             (SortMode in [smTlnAbs2Startzeit..smTlnAbs8Startzeit]) then
            if SpalteTlnTxt then Result:=ltStLstTlnALnd
                            else Result:=ltStLstTlnA
          else if SpalteTlnTxt then Result:=ltStLstTlnABnLnd
                               else Result:=ltStLstTlnABn;

    anMschStart:
      if SortStatus = stKein then // ohne Teilnehmer
        if SortMode in [smMschAbs1Startzeit..smMschAbs8Startzeit] then
          Result := ltStLstMschZt
        else Result := ltStLstMsch
      else // mit Teilnehner
        if SortMode in [smMschAbs1Startzeit..smMschAbs8Startzeit] then
          Result:=ltStLstMschTlnZt
        else Result:=ltStLstMschTln;

     anTlnErg:
      if RepWk.WettkArt = waTlnStaffel then 
        Result := TListType(Integer(ltErgLstStaffelTln2) + RepWk.AbSchnZahl - 2)
      else
      if RepWk.WettkArt = waTlnTeam then
      //if (RepMschGr>=cnMschGrMin) and (RepMschGr<=cnMschGrMaxKompakt) then
        Result := TListType(Integer(ltErgLstMschTln2) + RepMschGr - 2)
      else
      if RepWk.RundenWettk then // nur 1 Abschnitt
        if SpalteAk then
          if RepWk.LangeAkKuerzel then
            if SpalteTlnTxt then
              Result := ltErgLstTlnRndLAkLnd
            else
              Result := ltErgLstTlnRndLAk
          else
            if SpalteTlnTxt then
              Result := ltErgLstTlnRndAkLnd
            else
              Result := ltErgLstTlnRndAk
        else
          if SpalteTlnTxt then
            Result := ltErgLstTlnRndLnd
          else
            Result := ltErgLstTlnRnd
      else
        if SpalteAk then
          if RepWk.LangeAkKuerzel then // nur AbschnZahl = 1
            if SpalteTlnTxt then
              Result := ltErgLstTlnAbs1LAkLnd
            else
              Result := ltErgLstTlnAbs1LAk
          else
            if SpalteTlnTxt then
              Result := TListType(Integer(ltErgLstTlnAbs1AkLnd) + RepWk.AbSchnZahl - 1)
            else
              Result := TListType(Integer(ltErgLstTlnAbs1Ak) + RepWk.AbSchnZahl - 1)
        else
          if SpalteTlnTxt then
            Result := TListType(Integer(ltErgLstTlnAbs1Lnd) + RepWk.AbSchnZahl - 1)
          else
            Result := TListType(Integer(ltErgLstTlnAbs1) + RepWk.AbSchnZahl - 1);

    anTlnUhrZeit:
      Result := TListType(Integer(ltKtLstUhrZeit1) + RepWk.AbSchnZahl - 1);

    anTlnRndKntrl: // 2008-2.0
      Result := ltKtLstRunden;

    anTlnErgSerie:
      if SpalteAk and not RepWk.LangeAkKuerzel then // Ak-Spalte nur bei kurzer Ak
        Result := TListType(Integer(ltSerWertTlnAk2) + Veranstaltung.OrtZahl - 2)
      else
        Result := TListType(Integer(ltSerWertTln2) + Veranstaltung.OrtZahl - 2);

    anMschErgDetail:
      if (RepWk.WettkArt = waRndRennen) and  // nur 1 Abschnitt
         (RepWk.MschWrtgMode = wmTlnZeit) then
        if RepWk.LangeAkKuerzel then
          Result := ltErgLstMschTlnRndL // mit Spalte Rundenzahl, Ak-lang
        else
          Result := ltErgLstMschTlnRnd // mit Spalte Rundenzahl, Ak-kurz
      {else
      if (RepWk.WettkArt = waStndRennen) and  // nur 1 Abschnitt
         (RepWk.MschWrtgMode = wmTlnZeit) then
        if RepWk.LangeAkKuerzel then
          Result := ltErgLstMschTlnStndL // mit Spalte Rundenzahl, Ak-lang
        else
          Result := ltErgLstMschTlnStnd // mit Spalte Rundenzahl, Ak-kurz}
      else
        Result := ltErgLstMschTln; // immer Platz f�r lange Ak, auch waStndRennen

    anMschErgKompakt: // alle Tln auf gleicher Zeile
      if (RepMschGr>=cnMschGrMin) and (RepMschGr<=cnMschGrMaxKompakt) then
        Result := TListType(Integer(ltErgLstMschTln2) + RepMschGr - 2);

    anMschErgSerie:
      Result := TListType(Integer(ltSerWertMsch2) + Veranstaltung.OrtZahl - 2);

    anTlnSchwDist: Result := ltChkLstSchwBhn;
  end;
end;

{------------------------------------------------------------------------------}
//function GetTitel2: String;
{------------------------------------------------------------------------------}
{// Listen-Ausgabe nur f�r eingestellten Wettk.
begin
  with HauptFenster do
    if SortWrtg=wgStandWrtg then Result := SortWettk.StandTitel
                            else Result := SortWettk.SondTitel;
end;}

{------------------------------------------------------------------------------}
function GetTitel2(RepWk:TWettkObj;RepWrtg:TWertungMode): String;
{------------------------------------------------------------------------------}
begin
  if (HauptFenster.Ansicht = anTlnErgSerie) or
     (HauptFenster.Ansicht = anMschErgSerie) then
    Result := RepWk.Name  // Ortsunabh�ngig
  else
  if RepWrtg=wgStandWrtg then Result := RepWk.StandTitel
                         else Result := RepWk.SondTitel;
end;

{------------------------------------------------------------------------------}
function GetTitel3(ListType:TListType; RepWk:TWettkObj; Ak:TAkObj): String;
{------------------------------------------------------------------------------}
// Titel3 Text ohne Klasse
var MschListe : Boolean;
begin
  MschListe := false;
  case ListType of
    //ltMldLstTlnSchirm: Result := 'Meldeliste'; nicht f�r reports benutzt

    ltStLstTlnA,ltStLstTlnABn,ltStLstTlnAT,ltStLstTlnATBn,
    ltStLstTlnAS,ltStLstTlnASBn,ltStLstTlnATS,ltStLstTlnATSBn,
    ltStLstTlnALnd,ltStLstTlnABnLnd,ltStLstTlnATLnd,ltStLstTlnATBnLnd,
    ltStLstTlnASLnd,ltStLstTlnASBnLnd,ltStLstTlnATSLnd,ltStLstTlnATSBnLnd:
      if HauptFenster.SortMode in [smTlnAbs2Startzeit..smTlnAbs8Startzeit] then
        Result := 'Jagdstartliste - Abschn. ' +
                  IntToStr(Integer(HauptFenster.SortMode)-Integer(smTlnAbs2Startzeit)+2)
      else
        Result := 'Startliste';
    ltStLstStaffelTln2..ltStLstStaffelTln8:
      if HauptFenster.SortMode in [smTlnAbs2Startzeit..smTlnAbs8Startzeit] then
        Result := 'Jagdstartliste - Abschn. ' +
                  IntToStr(Integer(HauptFenster.SortMode)-Integer(smTlnAbs2Startzeit)+2)
      else
      if RepWk.WettkArt = waTlnTeam then
        Result := 'Startliste  Teams'
      else
        Result := 'Startliste  Staffel';
    ltStLstMsch,{ltStLstMschWk,}ltStLstMschTln,ltStLstMschTlnZt:
    begin
      MschListe := true;
      if RepWk.MschWrtgMode = wmSchultour then Result := 'Startliste  Schulklassen'
                                          else Result := 'Startliste  Mannschaften';
    end;
    ltStLstMschZt{,ltStLstMschZtWk}:
    begin
      MschListe := true;
      if HauptFenster.SortMode in [smMschAbs2Startzeit..smMschAbs8Startzeit] then
        Result := 'Jagdstartliste - Abschn. ' +
                  IntToStr(Integer(HauptFenster.SortMode)-Integer(smMschAbs2Startzeit)+2)
      else
      if RepWk.MschWrtgMode = wmSchultour then Result := 'Startliste  Schulklassen'
                                          else Result := 'Startliste  Mannschaften';
    end;
    ltErgLstTlnAbs1Ak..ltErgLstTlnAbs1LAk,
    ltErgLstTlnAbs1..ltErgLstTlnAbs8,
    ltErgLstTlnAbs1AkLnd..ltErgLstTlnAbs1LAkLnd,
    ltErgLstTlnAbs1Lnd..ltErgLstTlnAbs8Lnd,
    ltErgLstTlnRndAkLnd..ltErgLstTlnRndLAk:
      Result := 'Ergebnisliste';
    ltErgLstStaffelTln2..ltErgLstStaffelTln8:
      Result := 'Ergebnisliste  Staffel';
    ltKtLstUhrZeit1..ltKtLstUhrZeit8:
      Result := 'Kontrolle - Uhrzeiten';
    ltKtLstRunden:
      if HauptFenster.SortStatus in [stAbs1Zeit..stAbs8Zeit] then
        if (RepWk.AbschnZahl > 1) then
          Result := 'Rundenkontrolle - Abschn. ' +
                    IntToStr(Integer(HauptFenster.SortStatus)-Integer(stAbs1Zeit)+1)
        else Result := 'Rundenkontrolle';
    ltErgLstMschTln,
    ltErgLstMschTlnRnd,ltErgLstMschTlnRndL,
    ltErgLstMschTln2..ltErgLstMschTln8:
      if RepWk.WettkArt = waTlnTeam then // nur bei ltErgLstMschTln2..ltErgLstMschTln8
      begin
        MschListe := false;
        Result := 'Ergebnisliste  Teams';
      end else
      begin
        MschListe := true;
        if RepWk.MschWrtgMode = wmSchultour then Result := 'Klassenwertung'
                                            else Result := 'Mannschaftswertung';
      end;
    ltSerWertTln2..ltSerWertTln20,
    ltSerWertTlnAk2..ltSerWertTlnAk20:
      Result := 'Serienwertung';
    ltSerWertMsch2..ltSerWertMsch20:
    begin
      MschListe := true;
      Result := 'Serienwertung  Mannschaften';
    end;
    ltMldLstTlnExp:
      if HauptFenster.Ansicht = anAnmSammel then
        Result := 'Teilnehmer gemeldet von  ' + HauptFenster.SortSMld.VNameName
      else
        Result := 'Gemeldete Teilnehmer';
    else Result := '';
  end;
  // bei Ak = Alle teilnehmer, Klasse nicht hinzuf�gen
  // M�nner/Frauen mehrere Wk in einer Liste m�glich, definierter Name verwenden
  //if (Result <> '') and ((Ak.Sex = cnMaennlich) or (Ak.Sex = cnWeiblich)) then
  //  Result := Result + '  -  ' + Ak.Name;
  if Result <> '' then
    case Ak.Wertung of
      kwAlle : ; // Result ohne Klasse
      kwSex  :   // Name Wettk-abh�ngig
        case Ak.Sex of
          cnMaennlich: if MschListe then Result := Result + '  -  ' + RepWk.MaennerKlasse[tmMsch].Name
                                    else Result := Result + '  -  ' + RepWk.MaennerKlasse[tmTln].Name;
          cnWeiblich : if MschListe then Result := Result + '  -  ' + RepWk.FrauenKlasse[tmMsch].Name
                                    else Result := Result + '  -  ' + RepWk.FrauenKlasse[tmTln].Name;
          cnMixed    : Result := Result + '  -  ' + Ak.Name;
        end;
      else Result := Result + '  -  ' + Ak.Name;
    end;
end;

{------------------------------------------------------------------------------}
function GetColType(ListType:TListType;RepWk:TWettkObj;C:Integer;ListMode:TListMode):TColType;
{------------------------------------------------------------------------------}
// ReportListe: false f�r Desktop
//              true  f�r RaveReports und Export (HTML, Excel, Text)
// ListMode: lmSchirm, lmReport(Rave,HTML), lmExport (Excel,Text)
var i,j : integer;
//..............................................................................
function GetSpMschErgebnis: TColType;
begin
  if RepWk.MschWrtgMode = wmTlnZeit then  //wmTlnZeit,wmTlnPlatz,wmSchultour
    if RepWk.WettkArt=waStndRennen then
      Result := spMschStrecke
    else
      Result := spMschEndzeit
  else Result := spMschPunkte;
end;
//..............................................................................
function GetSpMschTlnErgebnis: TColType;
begin
  if RepWk.MschWrtgMode = wmTlnZeit then  //wmTlnZeit,wmTlnPlatz,wmSchultour
    if RepWk.WettkArt=waStndRennen then
      Result := spMschTlnStrecke
    else
      Result := spMschTlnEndzeit
  else Result := spMschTlnPunkte;
end;
//..............................................................................
function GetSpTlnRndErgebnis: TColType;
begin
  if RepWk.WettkArt = waStndRennen then
    Result := spTlnEndStrecke
  else Result := spTlnEndZeit;
end;
//..............................................................................
begin
  case ListType of

    ltMldLstTlnSchirm: // MeldeListe, nur ListMode = lmSchirm
    begin
      //i := C;
      if (C>=2) and (RepWk.Startbahnen=0) then // keine spStBahn
        Inc(C);
      if (C>=5) and (HauptFenster.SortMode<>smTlnMschGroesse) then // keine spMschGroesse
        Inc(C);
      if (C>=6) and StrGleich(RepWk.TlnTxt,'') then // keine spLand
        Inc(C);
      if (C>=9) and (RepWk <> WettkAlleDummy) then  // keine spWettk
        Inc(C);
      if (C>=10) and Assigned(Veranstaltung) and not Veranstaltung.TlnColl.MeldeZeitBenutzt(RepWk) then // keine spMeldeZeit
        Inc(C);
      if (C>=11) and Assigned(Veranstaltung) and not Veranstaltung.TlnColl.StartgeldBenutzt(RepWk) then // keine spStartGeld
        Inc(C);
      if (C>=12) and not RfidModus then // keine spRfid
        Inc(C);
      if (C>=16) and Assigned(Veranstaltung) and not Veranstaltung.Serie then // keine spSerWrtg
        Inc(C);
      if (C>=21) and Assigned(Veranstaltung) and not Veranstaltung.TlnColl.KommentBenutzt(RepWk) then // keine spKomment
        Inc(C);
      case C of
        0:Result:=spSnr; 1:Result:=spStZeit; 2:Result:=spStBahn;
        3:Result:=spNameVName; 4:Result:=spMannsch; 5:Result:=spMschGroesse;
        6:Result:= spLand;
        7:Result:=spJg; 8:Result:=spAk; 9:Result:=spWettk;
        10:Result:=spMeldeZeit;11:Result:=spStartgeld;
        12:Result:=spRfid;
        13:Result:=spMschWrtg;14:Result:=spMschMixWrtg;15:Result:=spSondWrtg;
        16:Result:=spSerWrtg;17:Result:=spUrkDr;18:Result:=spAusKonkAllg;
        19:Result:=spStatus;20:Result:=spGeAendert;21:Result:=spKomment;
        else Result := spLeer;
      end;
    end;

    ltMldLstTlnExp,ltTlnImport: // f�r Import und Export von Meldedaten
      // Spalten entsprechen Reihenfolge AllgConst-TColType ==> STIMMT NICHT!!
      // unabh�ngig vom Wettk
      case C of
        0  : Result:=spName;
        1  : Result:=spVName;
        2  : Result:=spSex;
        3  : Result:=spJg;
        4  : Result:=spMannsch;
        5  : Result:=spStrasse;
        6  : Result:=spHausNr;
        7  : Result:=spPLZ;
        8  : Result:=spOrt;
        9  : Result:=spEMail;
        10 : Result:=spLand;
        11 : Result:=spMeldeZeit;
        12 : Result:=spStartgeld;
        13 : Result:=spRfid;
        14 : Result:=spKomment;
        15 : Result:=spMschWrtg;
        16 : Result:=spMschMixWrtg;
        17 : Result:=spSondWrtg;
        18 : Result:=spSerWrtg;
        19 : Result:=spUrkDr;
        20 : Result:=spAusKonkAllg;
        21 : Result:=spAusKonkAltKl;
        22 : Result:=spAusKonkSondKl;
        23 : Result:=spStaffelName2;
        24 : Result:=spStaffelVName2;
        25 : Result:=spStaffelName3;
        26 : Result:=spStaffelVName3;
        27 : Result:=spStaffelName4;
        28 : Result:=spStaffelVName4;
        29 : Result:=spStaffelName5;
        30 : Result:=spStaffelVName5;
        31 : Result:=spStaffelName6;
        32 : Result:=spStaffelVName6;
        33 : Result:=spStaffelName7;
        34 : Result:=spStaffelVName7;
        35 : Result:=spStaffelName8;
        36 : Result:=spStaffelVName8;
        37 : Result:=spSnr;
        38 : Result:=spRestStrecke;
        39 : Result:=spStZeit;
        40 : Result:=spStBahn;
        41 : Result:=spAbs1UhrZeit;
        42 : Result:=spAbs2UhrZeit;
        43 : Result:=spAbs3UhrZeit;
        44 : Result:=spAbs4UhrZeit;
        45 : Result:=spAbs5UhrZeit;
        46 : Result:=spAbs6UhrZeit;
        47 : Result:=spAbs7UhrZeit;
        48 : Result:=spAbs8UhrZeit;
        49 : Result:=spGutschrift;
        50 : Result:=spTlnStrafZeit;
        51 : Result:=spDisqGrund;
        52 : Result:=spDisqName;
        else Result:=spLeer;
      end;

  (*  anTlnStartListe  ********************************************************)
    ltStLstTlnA:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch;
        3:Result:=spJg; 4:Result:=spAk; 5:Result:=spStZeit;
        else Result := spLeer;
      end;
    ltStLstTlnABn, ltChkLstSchwBhn:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch;
        3:Result:=spJg; 4:Result:=spAk; 5:Result:=spStZeit; 6:Result:=spStBahn;
        else Result := spLeer;
      end;
    ltStLstTlnAT:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch;
        3:Result:=spJg; 4:Result:=spAk; 5:Result:=spStZeit;
        6:Result:=spAusKonkAllg;
        else Result := spLeer;
      end;
    ltStLstTlnATBn:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch;
        3:Result:=spJg; 4:Result:=spAk; 5:Result:=spStZeit; 6:Result:=spStBahn;
        7:Result:=spAusKonkAllg;
        else Result := spLeer;
      end;
    ltStLstTlnAS:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch;
        3:Result:=spJg; 4:Result:=spAk; 5:Result:=spStZeit;
        6:Result:=spSerWrtg;
        else Result := spLeer;
      end;
    ltStLstTlnASBn:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch;
        3:Result:=spJg; 4:Result:=spAk; 5:Result:=spStZeit; 6:Result:=spStBahn;
        7:Result:=spSerWrtg;
        else Result := spLeer;
      end;
    ltStLstTlnATS:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch;
        3:Result:=spJg; 4:Result:=spAk; 5:Result:=spStZeit;
        6:Result:=spAusKonkAllg; 7:Result:=spSerWrtg;
        else Result := spLeer;
      end;
    ltStLstTlnATSBn:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch;
        3:Result:=spJg; 4:Result:=spAk; 5:Result:=spStZeit; 6:Result:=spStBahn;
        7:Result:=spAusKonkAllg; 8:Result:=spSerWrtg;
        else Result := spLeer;
      end;
    ltStLstTlnALnd:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch; 3:Result:=spLand;
        4:Result:=spJg; 5:Result:=spAk; 6:Result:=spStZeit;
        else Result := spLeer;
      end;
    ltStLstTlnABnLnd:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch; 3:Result:=spLand;
        4:Result:=spJg; 5:Result:=spAk; 6:Result:=spStZeit; 7:Result:=spStBahn;
        else Result := spLeer;
      end;
    ltStLstTlnATLnd:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch; 3:Result:=spLand;
        4:Result:=spJg; 5:Result:=spAk; 6:Result:=spStZeit;
        7:Result:=spAusKonkAllg;
        else Result := spLeer;
      end;
    ltStLstTlnATBnLnd:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch; 3:Result:=spLand;
        4:Result:=spJg; 5:Result:=spAk; 6:Result:=spStZeit; 7:Result:=spStBahn;
        8:Result:=spAusKonkAllg;
        else Result := spLeer;
      end;
    ltStLstTlnASLnd:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch; 3:Result:=spLand;
        4:Result:=spJg; 5:Result:=spAk; 6:Result:=spStZeit;
        7:Result:=spSerWrtg;
        else Result := spLeer;
      end;
    ltStLstTlnASBnLnd:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch; 3:Result:=spLand;
        4:Result:=spJg; 5:Result:=spAk; 6:Result:=spStZeit; 7:Result:=spStBahn;
        8:Result:=spSerWrtg;
        else Result := spLeer;
      end;
    ltStLstTlnATSLnd:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch; 3:Result:=spLand;
        4:Result:=spJg; 5:Result:=spAk; 6:Result:=spStZeit;
        7:Result:=spAusKonkAllg; 8:Result:=spSerWrtg;
        else Result := spLeer;
      end;
    ltStLstTlnATSBnLnd:
      case C of
        0:Result:=spSnr; 1:Result:=spNameVName; 2:Result:=spMannsch; 3:Result:=spLand;
        4:Result:=spJg; 5:Result:=spAk; 6:Result:=spStZeit; 7:Result:=spStBahn;
        8:Result:=spAusKonkAllg; 9:Result:=spSerWrtg;
        else Result := spLeer;
      end;
    ltStLstStaffelTln2:
      case C of
        0:Result:=spSnr;
        1:Result:=spMannsch;
        2:Result:=spMschTln0;
        3:Result:=spMschTln1;
        4:Result:=spStZeit;
        else Result := spLeer;
      end;
    ltStLstStaffelTln3:
      case C of
        0:Result:=spSnr;
        1:Result:=spMannsch;
        2:Result:=spMschTln0;
        3:Result:=spMschTln1;
        4:Result:=spMschTln2;
        5:Result:=spStZeit;
        else Result := spLeer;
      end;
    ltStLstStaffelTln4:
      case C of
        0:Result:=spSnr;
        1:Result:=spMannsch;
        2:Result:=spMschTln0;
        3:Result:=spMschTln1;
        4:Result:=spMschTln2;
        5:Result:=spMschTln3;
        6:Result:=spStZeit;
        else Result := spLeer;
      end;
    ltStLstStaffelTln5:
      case C of
        0:Result:=spSnr;
        1:Result:=spMannsch;
        2:Result:=spMschTln0;
        3:Result:=spMschTln1;
        4:Result:=spMschTln2;
        5:Result:=spMschTln3;
        6:Result:=spMschTln4;
        7:Result:=spStZeit;
        else Result := spLeer;
      end;
    ltStLstStaffelTln6:
      case C of
        0:Result:=spSnr;
        1:Result:=spMannsch;
        2:Result:=spMschTln0;
        3:Result:=spMschTln1;
        4:Result:=spMschTln2;
        5:Result:=spMschTln3;
        6:Result:=spMschTln4;
        7:Result:=spMschTln5;
        8:Result:=spStZeit;
        else Result := spLeer;
      end;
    ltStLstStaffelTln7:
      case C of
        0:Result:=spSnr;
        1:Result:=spMannsch;
        2:Result:=spMschTln0;
        3:Result:=spMschTln1;
        4:Result:=spMschTln2;
        5:Result:=spMschTln3;
        6:Result:=spMschTln4;
        7:Result:=spMschTln5;
        8:Result:=spMschTln6;
        9:Result:=spStZeit;
        else Result := spLeer;
      end;
    ltStLstStaffelTln8:
      case C of
        0:Result:=spSnr;
        1:Result:=spMannsch;
        2:Result:=spMschTln0;
        3:Result:=spMschTln1;
        4:Result:=spMschTln2;
        5:Result:=spMschTln3;
        6:Result:=spMschTln4;
        7:Result:=spMschTln5;
        8:Result:=spMschTln6;
        9:Result:=spMschTln7;
        10:Result:=spStZeit;
        else Result := spLeer;
      end;

  (*  anTlnTagesWertung  ******************************************************)
    ltErgLstTlnAbs1Ak,ltErgLstTlnAbs1LAk: {8}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAkRng;
        6:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAk;6:Result:=spAkRng; // Ak,AkRng getrennt
        7:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs2Ak: {12}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAkRng;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAk;6:Result:=spAkRng;
        7:Result:=spAbs1Zeit;8:Result:=spAbs1Rng;
        9:Result:=spAbs2Zeit;10:Result:=spAbs2Rng;
        11:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs3Ak:  {14}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAkRng;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAk;6:Result:=spAkRng;
        7:Result:=spAbs1Zeit;8:Result:=spAbs1Rng;
        9:Result:=spAbs2Zeit;10:Result:=spAbs2Rng;
        11:Result:=spAbs3Zeit;12:Result:=spAbs3Rng;
        13:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs4Ak:  {16}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAkRng;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spAbs4Rng;
        10:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAk;6:Result:=spAkRng;
        7:Result:=spAbs1Zeit;8:Result:=spAbs1Rng;
        9:Result:=spAbs2Zeit;10:Result:=spAbs2Rng;
        11:Result:=spAbs3Zeit;12:Result:=spAbs3Rng;
        13:Result:=spAbs4Zeit;14:Result:=spAbs4Rng;
        15:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs5Ak:  {18}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAkRng;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spAbs4Rng;
        10:Result:=spAbs5Rng;
        11:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAk;6:Result:=spAkRng;
        7:Result:=spAbs1Zeit;8:Result:=spAbs1Rng;
        9:Result:=spAbs2Zeit;10:Result:=spAbs2Rng;
        11:Result:=spAbs3Zeit;12:Result:=spAbs3Rng;
        13:Result:=spAbs4Zeit;14:Result:=spAbs4Rng;
        15:Result:=spAbs5Zeit;16:Result:=spAbs5Rng;
        17:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs6Ak:  {20}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAkRng;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spAbs4Rng;
        10:Result:=spAbs5Rng;
        11:Result:=spAbs6Rng;
        12:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAk;6:Result:=spAkRng;
        7:Result:=spAbs1Zeit;8:Result:=spAbs1Rng;
        9:Result:=spAbs2Zeit;10:Result:=spAbs2Rng;
        11:Result:=spAbs3Zeit;12:Result:=spAbs3Rng;
        13:Result:=spAbs4Zeit;14:Result:=spAbs4Rng;
        15:Result:=spAbs5Zeit;16:Result:=spAbs5Rng;
        17:Result:=spAbs6Zeit;18:Result:=spAbs6Rng;
        19:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs7Ak:  {22}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAkRng;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spAbs4Rng;
        10:Result:=spAbs5Rng;
        11:Result:=spAbs6Rng;
        12:Result:=spAbs7Rng;
        13:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAk;6:Result:=spAkRng;
        7:Result:=spAbs1Zeit;8:Result:=spAbs1Rng;
        9:Result:=spAbs2Zeit;10:Result:=spAbs2Rng;
        11:Result:=spAbs3Zeit;12:Result:=spAbs3Rng;
        13:Result:=spAbs4Zeit;14:Result:=spAbs4Rng;
        15:Result:=spAbs5Zeit;16:Result:=spAbs5Rng;
        17:Result:=spAbs6Zeit;18:Result:=spAbs6Rng;
        19:Result:=spAbs7Zeit;20:Result:=spAbs7Rng;
        21:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs8Ak:  {24}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAkRng;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spAbs4Rng;
        10:Result:=spAbs5Rng;
        11:Result:=spAbs6Rng;
        12:Result:=spAbs7Rng;
        13:Result:=spAbs8Rng;
        14:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAk;6:Result:=spAkRng;
        7:Result:=spAbs1Zeit;8:Result:=spAbs1Rng;
        9:Result:=spAbs2Zeit;10:Result:=spAbs2Rng;
        11:Result:=spAbs3Zeit;12:Result:=spAbs3Rng;
        13:Result:=spAbs4Zeit;14:Result:=spAbs4Rng;
        15:Result:=spAbs5Zeit;16:Result:=spAbs5Rng;
        17:Result:=spAbs6Zeit;18:Result:=spAbs6Rng;
        19:Result:=spAbs7Zeit;20:Result:=spAbs7Rng;
        21:Result:=spAbs8Zeit;22:Result:=spAbs8Rng;
        23:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs1: {6}
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs2: {10}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Rng;
        6:Result:=spAbs2Rng;
        7:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Zeit;6:Result:=spAbs1Rng;
        7:Result:=spAbs2Zeit;8:Result:=spAbs2Rng;
        9:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs3:  {12}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Rng;
        6:Result:=spAbs2Rng;
        7:Result:=spAbs3Rng;
        8:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Zeit;6:Result:=spAbs1Rng;
        7:Result:=spAbs2Zeit;8:Result:=spAbs2Rng;
        9:Result:=spAbs3Zeit;10:Result:=spAbs3Rng;
        11:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs4:  {14}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Rng;
        6:Result:=spAbs2Rng;
        7:Result:=spAbs3Rng;
        8:Result:=spAbs4Rng;
        9:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Zeit;6:Result:=spAbs1Rng;
        7:Result:=spAbs2Zeit;8:Result:=spAbs2Rng;
        9:Result:=spAbs3Zeit;10:Result:=spAbs3Rng;
        11:Result:=spAbs4Zeit;12:Result:=spAbs4Rng;
        13:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs5:  {16}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Rng;
        6:Result:=spAbs2Rng;
        7:Result:=spAbs3Rng;
        8:Result:=spAbs4Rng;
        9:Result:=spAbs5Rng;
        10:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Zeit;6:Result:=spAbs1Rng;
        7:Result:=spAbs2Zeit;8:Result:=spAbs2Rng;
        9:Result:=spAbs3Zeit;10:Result:=spAbs3Rng;
        11:Result:=spAbs4Zeit;12:Result:=spAbs4Rng;
        13:Result:=spAbs5Zeit;14:Result:=spAbs5Rng;
        15:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs6:  {18}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Rng;
        6:Result:=spAbs2Rng;
        7:Result:=spAbs3Rng;
        8:Result:=spAbs4Rng;
        9:Result:=spAbs5Rng;
        10:Result:=spAbs6Rng;
        11:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Zeit;6:Result:=spAbs1Rng;
        7:Result:=spAbs2Zeit;8:Result:=spAbs2Rng;
        9:Result:=spAbs3Zeit;10:Result:=spAbs3Rng;
        11:Result:=spAbs4Zeit;12:Result:=spAbs4Rng;
        13:Result:=spAbs5Zeit;14:Result:=spAbs5Rng;
        15:Result:=spAbs6Zeit;16:Result:=spAbs6Rng;
        17:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs7:  {20}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Rng;
        6:Result:=spAbs2Rng;
        7:Result:=spAbs3Rng;
        8:Result:=spAbs4Rng;
        9:Result:=spAbs5Rng;
        10:Result:=spAbs6Rng;
        11:Result:=spAbs7Rng;
        12:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Zeit;6:Result:=spAbs1Rng;
        7:Result:=spAbs2Zeit;8:Result:=spAbs2Rng;
        9:Result:=spAbs3Zeit;10:Result:=spAbs3Rng;
        11:Result:=spAbs4Zeit;12:Result:=spAbs4Rng;
        13:Result:=spAbs5Zeit;14:Result:=spAbs5Rng;
        15:Result:=spAbs6Zeit;16:Result:=spAbs6Rng;
        17:Result:=spAbs7Zeit;18:Result:=spAbs7Rng;
        19:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs8:  {22}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Rng;
        6:Result:=spAbs2Rng;
        7:Result:=spAbs3Rng;
        8:Result:=spAbs4Rng;
        9:Result:=spAbs5Rng;
        10:Result:=spAbs6Rng;
        11:Result:=spAbs7Rng;
        12:Result:=spAbs8Rng;
        13:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Zeit;6:Result:=spAbs1Rng;
        7:Result:=spAbs2Zeit;8:Result:=spAbs2Rng;
        9:Result:=spAbs3Zeit;10:Result:=spAbs3Rng;
        11:Result:=spAbs4Zeit;12:Result:=spAbs4Rng;
        13:Result:=spAbs5Zeit;14:Result:=spAbs5Rng;
        15:Result:=spAbs6Zeit;16:Result:=spAbs6Rng;
        17:Result:=spAbs7Zeit;18:Result:=spAbs7Rng;
        19:Result:=spAbs8Zeit;20:Result:=spAbs8Rng;
        21:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs1AkLnd,ltErgLstTlnAbs1LAkLnd: {9}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAkRng;
        7:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAk;7:Result:=spAkRng;
        8:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs2AkLnd: {13}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAkRng;
        7:Result:=spAbs1Rng;
        8:Result:=spAbs2Rng;
        9:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAk;7:Result:=spAkRng;
        8:Result:=spAbs1Zeit;9:Result:=spAbs1Rng;
        10:Result:=spAbs2Zeit;11:Result:=spAbs2Rng;
        12:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs3AkLnd:  {15}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAkRng;
        7:Result:=spAbs1Rng;
        8:Result:=spAbs2Rng;
        9:Result:=spAbs3Rng;
        10:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAk;7:Result:=spAkRng;
        8:Result:=spAbs1Zeit;9:Result:=spAbs1Rng;
        10:Result:=spAbs2Zeit;11:Result:=spAbs2Rng;
        12:Result:=spAbs3Zeit;13:Result:=spAbs3Rng;
        14:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs4AkLnd:  {17}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAkRng;
        7:Result:=spAbs1Rng;
        8:Result:=spAbs2Rng;
        9:Result:=spAbs3Rng;
        10:Result:=spAbs4Rng;
        11:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAk;7:Result:=spAkRng;
        8:Result:=spAbs1Zeit;9:Result:=spAbs1Rng;
        10:Result:=spAbs2Zeit;11:Result:=spAbs2Rng;
        12:Result:=spAbs3Zeit;13:Result:=spAbs3Rng;
        14:Result:=spAbs4Zeit;15:Result:=spAbs4Rng;
        16:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs5AkLnd:  {19}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAkRng;
        7:Result:=spAbs1Rng;
        8:Result:=spAbs2Rng;
        9:Result:=spAbs3Rng;
        10:Result:=spAbs4Rng;
        11:Result:=spAbs5Rng;
        12:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAk;7:Result:=spAkRng;
        8:Result:=spAbs1Zeit;9:Result:=spAbs1Rng;
        10:Result:=spAbs2Zeit;11:Result:=spAbs2Rng;
        12:Result:=spAbs3Zeit;13:Result:=spAbs3Rng;
        14:Result:=spAbs4Zeit;15:Result:=spAbs4Rng;
        16:Result:=spAbs5Zeit;17:Result:=spAbs5Rng;
        18:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs6AkLnd:  {21}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAkRng;
        7:Result:=spAbs1Rng;
        8:Result:=spAbs2Rng;
        9:Result:=spAbs3Rng;
        10:Result:=spAbs4Rng;
        11:Result:=spAbs5Rng;
        12:Result:=spAbs6Rng;
        13:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAk;7:Result:=spAkRng;
        8:Result:=spAbs1Zeit;9:Result:=spAbs1Rng;
        10:Result:=spAbs2Zeit;11:Result:=spAbs2Rng;
        12:Result:=spAbs3Zeit;13:Result:=spAbs3Rng;
        14:Result:=spAbs4Zeit;15:Result:=spAbs4Rng;
        16:Result:=spAbs5Zeit;17:Result:=spAbs5Rng;
        18:Result:=spAbs6Zeit;19:Result:=spAbs6Rng;
        20:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs7AkLnd:  {23}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAkRng;
        7:Result:=spAbs1Rng;
        8:Result:=spAbs2Rng;
        9:Result:=spAbs3Rng;
        10:Result:=spAbs4Rng;
        11:Result:=spAbs5Rng;
        12:Result:=spAbs6Rng;
        13:Result:=spAbs7Rng;
        14:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAk;7:Result:=spAkRng;
        8:Result:=spAbs1Zeit;9:Result:=spAbs1Rng;
        10:Result:=spAbs2Zeit;11:Result:=spAbs2Rng;
        12:Result:=spAbs3Zeit;13:Result:=spAbs3Rng;
        14:Result:=spAbs4Zeit;15:Result:=spAbs4Rng;
        16:Result:=spAbs5Zeit;17:Result:=spAbs5Rng;
        18:Result:=spAbs6Zeit;19:Result:=spAbs6Rng;
        20:Result:=spAbs7Zeit;21:Result:=spAbs7Rng;
        22:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs8AkLnd:  {25}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAkRng;
        7:Result:=spAbs1Rng;
        8:Result:=spAbs2Rng;
        9:Result:=spAbs3Rng;
        10:Result:=spAbs4Rng;
        11:Result:=spAbs5Rng;
        12:Result:=spAbs6Rng;
        13:Result:=spAbs7Rng;
        14:Result:=spAbs8Rng;
        15:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAk;7:Result:=spAkRng;
        8:Result:=spAbs1Zeit;9:Result:=spAbs1Rng;
        10:Result:=spAbs2Zeit;11:Result:=spAbs2Rng;
        12:Result:=spAbs3Zeit;13:Result:=spAbs3Rng;
        14:Result:=spAbs4Zeit;15:Result:=spAbs4Rng;
        16:Result:=spAbs5Zeit;17:Result:=spAbs5Rng;
        18:Result:=spAbs6Zeit;19:Result:=spAbs6Rng;
        20:Result:=spAbs7Zeit;21:Result:=spAbs7Rng;
        22:Result:=spAbs8Zeit;23:Result:=spAbs8Rng;
        24:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;

    ltErgLstTlnAbs1Lnd: {7}
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;5:Result:=spJg;
        6:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs2Lnd: {11}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;5:Result:=spJg;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;5:Result:=spJg;
        6:Result:=spAbs1Zeit;7:Result:=spAbs1Rng;
        8:Result:=spAbs2Zeit;9:Result:=spAbs2Rng;
        10:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs3Lnd:  {13}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Zeit;7:Result:=spAbs1Rng;
        8:Result:=spAbs2Zeit;9:Result:=spAbs2Rng;
        10:Result:=spAbs3Zeit;11:Result:=spAbs3Rng;
        12:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs4Lnd:  {15}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spAbs4Rng;
        10:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Zeit;7:Result:=spAbs1Rng;
        8:Result:=spAbs2Zeit;9:Result:=spAbs2Rng;
        10:Result:=spAbs3Zeit;11:Result:=spAbs3Rng;
        12:Result:=spAbs4Zeit;13:Result:=spAbs4Rng;
        14:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs5Lnd:  {17}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spAbs4Rng;
        10:Result:=spAbs5Rng;
        11:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Zeit;7:Result:=spAbs1Rng;
        8:Result:=spAbs2Zeit;9:Result:=spAbs2Rng;
        10:Result:=spAbs3Zeit;11:Result:=spAbs3Rng;
        12:Result:=spAbs4Zeit;13:Result:=spAbs4Rng;
        14:Result:=spAbs5Zeit;15:Result:=spAbs5Rng;
        16:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs6Lnd:  {19}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spAbs4Rng;
        10:Result:=spAbs5Rng;
        11:Result:=spAbs6Rng;
        12:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Zeit;7:Result:=spAbs1Rng;
        8:Result:=spAbs2Zeit;9:Result:=spAbs2Rng;
        10:Result:=spAbs3Zeit;11:Result:=spAbs3Rng;
        12:Result:=spAbs4Zeit;13:Result:=spAbs4Rng;
        14:Result:=spAbs5Zeit;15:Result:=spAbs5Rng;
        16:Result:=spAbs6Zeit;17:Result:=spAbs6Rng;
        18:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs7Lnd:  {21}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spAbs4Rng;
        10:Result:=spAbs5Rng;
        11:Result:=spAbs6Rng;
        12:Result:=spAbs7Rng;
        13:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Zeit;7:Result:=spAbs1Rng;
        8:Result:=spAbs2Zeit;9:Result:=spAbs2Rng;
        10:Result:=spAbs3Zeit;11:Result:=spAbs3Rng;
        12:Result:=spAbs4Zeit;13:Result:=spAbs4Rng;
        14:Result:=spAbs5Zeit;15:Result:=spAbs5Rng;
        16:Result:=spAbs6Zeit;17:Result:=spAbs6Rng;
        18:Result:=spAbs7Zeit;19:Result:=spAbs7Rng;
        20:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;
    ltErgLstTlnAbs8Lnd:  {23}
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Rng;
        7:Result:=spAbs2Rng;
        8:Result:=spAbs3Rng;
        9:Result:=spAbs4Rng;
        10:Result:=spAbs5Rng;
        11:Result:=spAbs6Rng;
        12:Result:=spAbs7Rng;
        13:Result:=spAbs8Rng;
        14:Result:=spTlnEndZeit;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result :=spLand;5:Result:=spJg;
        6:Result:=spAbs1Zeit;7:Result:=spAbs1Rng;
        8:Result:=spAbs2Zeit;9:Result:=spAbs2Rng;
        10:Result:=spAbs3Zeit;11:Result:=spAbs3Rng;
        12:Result:=spAbs4Zeit;13:Result:=spAbs4Rng;
        14:Result:=spAbs5Zeit;15:Result:=spAbs5Rng;
        16:Result:=spAbs6Zeit;17:Result:=spAbs6Rng;
        18:Result:=spAbs7Zeit;19:Result:=spAbs7Rng;
        20:Result:=spAbs8Zeit;21:Result:=spAbs8Rng;
        22:Result:=spTlnEndZeit;
        else Result := spLeer;
      end;

    ltErgLstStaffelTln2..ltErgLstStaffelTln8: // kein Unterschied f�r RaveReport
    begin
      i := (Integer(ListType)-Integer(ltErgLstStaffelTln2));
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spMannsch;
        else if C < 7+2*i then
        begin
          j := (C-3) DIV 2;
          if C MOD 2 = 1 then // 3,5,7,..
            Result:= TColType(Integer(spMschTln0)+j)
          else // 4,6,8,..
            Result:= TColType(Integer(spMschTlnZt0)+j)
        end else if C = 7+2*i then Result := spTlnEndZeit
        else Result := spLeer;
      end;
    end;

    ltErgLstTlnRndAkLnd,ltErgLstTlnRndLAkLnd: // waRndRennen, waStndRennen
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAkRng;
        7:Result:=spAbs1Runden;8:Result:=GetSpTlnRndErgebnis;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;
        5:Result:=spJg;6:Result:=spAk;7:Result:=spAkRng;
        8:Result:=spAbs1Runden;9:Result:=GetSpTlnRndErgebnis;
        else Result := spLeer;
      end;
    ltErgLstTlnRndAk,ltErgLstTlnRndLAk:
      if ListMode = lmSchirm then // Anzeige auf Schirm
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAkRng;
        6:Result:=spAbs1Runden;7:Result:=GetSpTlnRndErgebnis;
        else Result := spLeer;
      end else   // lmReport,lmExport
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;5:Result:=spAk;6:Result:=spAkRng; // Ak,AkRng getrennt
        7:Result:=spAbs1Runden;8:Result:=GetSpTlnRndErgebnis;
        else Result := spLeer;
      end;
    ltErgLstTlnRndLnd:
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spLand;5:Result:=spJg;
        6:Result:=spAbs1Runden;7:Result:=GetSpTlnRndErgebnis;
        else Result := spLeer;
      end;
    ltErgLstTlnRnd:
      case C of
        0:Result:=spRng;1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spMannsch;
        4:Result:=spJg;
        5:Result:=spAbs1Runden;6:Result:=GetSpTlnRndErgebnis;
        else Result := spLeer;
      end;

  (*  anTlnUhrZeiten  *********************************************************)
    ltKtLstUhrZeit1..ltKtLstUhrZeit8:
    begin
      i := (Integer(ListType)-Integer(ltKtLstUhrZeit1));
      if ListMode = lmSchirm then // Anzeige auf Schirm
        case C of
          0:Result:=spSnr;1:Result:=spNameVName;2:Result:=spMannsch;
          3:Result:=spStZeit;
          else if C < 5+i then Result:= TColType(Integer(spAbs1UhrZeit)+C-4)
          else Result := spLeer;
        end
      else   // lmReport,lmExport
        case C of
          0:Result:=spSnr;1:Result:=spNameVName;2:Result:=spMannsch;
          3:Result:=spJg;4:Result:=spAk;5:Result:=spWettk;6:Result:=spStZeit;
          else if C < 8+i then Result:= TColType(Integer(spAbs1UhrZeit)+C-7)
          else Result := spLeer;
        end;
    end;

  (*  anTlnRndKntrl  **********************************************************)
    ltKtLstRunden:
    begin
      i := Integer(HauptFenster.SortStatus)-Integer(stAbs1Zeit);// 0<=i<=7
      case C of
        0: Result:=spSnr;1:Result:=spNameVName;2:Result:=spMannsch;
        3: Result:= TColType(Integer(spAbs1Runden)+i);
        4: Result:= TColType(Integer(spAbs1StrtZeit)+i);
        5: Result:= TColType(Integer(spAbs1StopZeit)+i);
        6: Result:= TColType(Integer(spAbs1MinZeit)+i);
        7: Result:= TColType(Integer(spAbs1MaxZeit)+i);
        8: Result:= TColType(Integer(spAbs1EffZeit)+i);
        else Result := spLeer;
      end;
    end;

  (*  anTlnErgSerie  **********************************************************)
    ltSerWertTlnAk2..ltSerWertTlnAk20:
    begin
      i := Integer(ListType)-Integer(ltSerWertTlnAk2);
      if ListMode = lmSchirm then // Anzeige auf Schirm
        case C of
          0:Result:=spRngSer;1:Result:=spNameVName;2:Result:=spMannsch;
          3:Result:=spJg;4:Result:=spAkRngSer;
          else if C < 7+i then Result:= TColType(Integer(spOrt1)+C-5)
          else if C = 7+i then Result := spSumSer
          else Result := spLeer;
        end
      else   // lmReport,lmExport
        case C of
          0:Result:=spRngSer;1:Result:=spNameVName;2:Result:=spMannsch;
          3:Result:=spJg;4:Result:=spAk;5:Result:=spAkRngSer;
          else if C < 8+i then Result:= TColType(Integer(spOrt1)+C-6)
          else if C = 8+i then Result := spSumSer
          else Result := spLeer;
        end;
    end;
    ltSerWertTln2..ltSerWertTln20:
    begin
      i := Integer(ListType)-Integer(ltSerWertTln2);
      case C of
        0:Result:=spRngSer;1:Result:=spNameVName;2:Result:=spMannsch;
        3:Result:=spJg;
        else if C < 6+i then Result:= TColType(Integer(spOrt1)+C-4)
        else if C = 6+i then Result := spSumSer
        else Result := spLeer;
      end;
    end;
    //ltSerWertTlnAk2Lnd..ltSerWertTlnAk20Lnd:
    //ltSerWertTln2Lnd..ltSerWertTln20Lnd:

  (*  anMschStartListe  *******************************************************)
    ltStLstMsch:
      case C of
        0:Result:=spMschName;
        else Result := spLeer;
      end;
    ltStLstMschZt:
      case C of
        0:Result:=spMschName;1:Result:=spMschStZeit;
        else Result := spLeer;
      end;
    {ltStLstMschWk:
      case C of
        0:Result:=spMschName;1:Result:=spMschWettk;
        else Result := spLeer;
      end;
    ltStLstMschZtWk:
      case C of
        0:Result:=spMschName;1:Result:=spMschWettk;2:Result:=spMschStZeit;
        else Result := spLeer;
      end;}
    ltStLstMschTln:
      case C of
        0:Result:=spMschName;
        1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spJg;4:Result:=spAk;
        else Result := spLeer;
      end;
    ltStLstMschTlnZt:
      case C of
        0:Result:=spMschName;
        1:Result:=spSnr;2:Result:=spNameVName;3:Result:=spJg;4:Result:=spAk;
        5:Result:=spStZeit;
        else Result := spLeer;
      end;

  (*  anMschWertungDetail  ****************************************************)
    ltErgLstMschTln: // Zeile pro Tln, auch f�r waStndRennen
      case C of
        0:Result:=spMschRngGes;1:Result:=spMschName;2:Result:=GetSpMschErgebnis;
        3:Result:=spSnr;4:Result:=spNameVName;5:Result:=spJg;
        6:Result:=spAk;7:Result:=GetSpMschTlnErgebnis;
        else Result := spLeer;
      end;
    ltErgLstMschTlnRnd,ltErgLstMschTlnRndL: // waRndRennen
      case C of
        0:Result:=spMschRngGes;1:Result:=spMschName;
        2:Result:=spMschRunden;3:Result:=GetSpMschErgebnis;
        4:Result:=spSnr;5:Result:=spNameVName;6:Result:=spJg;
        7:Result:=spAk;8:Result:=spMschTlnRunden;9:Result:=GetSpMschTlnErgebnis;
        else Result := spLeer;
      end;

  (*  anMschErgKompakt  *******************************************************)
    ltErgLstMschTln2..ltErgLstMschTln8: // Zeile pro Mannsch, f�r alle WettkArt
    begin
      i := (Integer(ListType)-Integer(ltErgLstMschTln2));
      case C of
        0:Result:=spMschRngGes;1:Result:=spMschName;
        else if C < 4+i then Result:= TColType(Integer(spMschTln0)+C-2)
        else if C = 4+i then Result := GetSpMschErgebnis
        else Result := spLeer;
      end;
    end;

  (*  anMschSerienWertung  ****************************************************)
    ltSerWertMsch2..ltSerWertMsch20:
    begin
      i := Integer(ListType)-Integer(ltSerWertMsch2);
      case C of
        0:Result:=spMschRngSer;1:Result:=spMschName;
        else if C < 4+i then Result:= TColType(Integer(spOrt1)+C-2)
        else if C = 4+i then Result := spMschSumSer
        else Result := spLeer;
      end;
    end;

    else Result := spLeer;
  end;
end;

(******************************************************************************)
function GetColHeader(C:TColType;RepWk:TWettkObj):String;
(******************************************************************************)
// TlnColl oder SMld.TlnListe
// f�r ltMldLstTlnExp nicht benutzen, sondern GetFeldNameKurz(C,Runde);
begin
  Result := '';
  // muss auch bei Veranstaltung=nil funktionieren
  case C of
      spLeer          : Result := '';
      spGeAendert     : Result := 'Ge�ndert am';
      spSnr           : Result := 'Snr';
      spNameVName     : Result := 'Name, Vorname';
      spName          : Result := 'Name';    // f�r Suchen
      spVName         : Result := 'Vorname';
      spMannsch       : if Veranstaltung <> nil then
                          Result := Veranstaltung.TlnMschSpalteUeberschrift(RepWk)
                        else Result :='Verein/Ort';
      spMschGroesse   : Result := 'Gr';
      spLand          : Result := RepWk.TlnTxt;
      spJg            : Result := 'Jg';
      spAk            : Result := 'Ak';
      spWettk         : Result := 'Wettkampf';
      spStZeit        : Result := 'Startzeit';
      //spSGrpStZeit   : Result := 'Startzeit';
      spStBahn        : Result := 'Bn';
      spMeldeZeit     : Result := 'Meldezeit';
      spStartgeld     : Result := 'Startgeld';
      spMschWrtg      : Result := 'Msch';
      spMschMixWrtg   : Result := 'Mix';
      spSondWrtg      : Result := 'Sond';
      spSerWrtg       : Result := 'Ser';
      spUrkDr         : Result := 'Urk';
      spAusKonkAllg   : Result := 'a.K.';
      spAusKonkAltKl  : Result := 'a.K.-AK';
      spAusKonkSondKl : Result := 'a.K.-SK';
      spRfid          : Result := 'RFID-Code';
      spKomment       : Result := 'Kommentar';
      spTlnZeitNetto  : Result := 'Nettozeit';
      spTlnStrafZeit  : Result := 'Strafzeit';
      spGutschrift    : Result := 'Gutschrift';
      spMschStrafZeit : Result := 'MschStrafzt.';
      spMschGutschrift: Result := 'MschGutschr.';
      spRng           : Result := 'Rng';
      spAkRng,
      spAkRngSer      : Result := 'Ak'; // lmSchirm: Ak,AkRng kombiniert
      spAbs1Rng..spAbs8Rng:
        Result := RepWk.AbschnName[TWkAbschnitt(Integer(C)-Integer(spAbs1Rng)+1)];
      spAbs1Zeit..spAbs8Zeit:
        Result := RepWk.AbschnName[TWkAbschnitt(Integer(C)-Integer(spAbs1Zeit)+1)];
      spAbs1UhrZeit:
        if RepWk.AbSchnZahl > 1 then Result := RepWk.AbschnName[wkAbs1]
                                else Result := 'Endzeit';
      spAbs2UhrZeit..spAbs8UhrZeit:
        Result := RepWk.AbschnName[TWkAbschnitt(Integer(C)-Integer(spAbs2UhrZeit)+2)];
      spAbs1Runden..spAbs8Runden,
      spMschRunden,spMschTlnRunden:
        Result := 'Runden';
      spAbs1MinZeit..spAbs8MinZeit: Result := 'Min-Rnd';
      spAbs1MaxZeit..spAbs8MaxZeit: Result := 'Max-Rnd';
      spAbs1EffZeit:
        if RepWk.AbSchnZahl > 1 then Result := 'Abs.1-Zeit'
                                else Result := 'Endzeit';
      spAbs2EffZeit..spAbs8EffZeit:
        Result := 'Abs.'+IntToStr(Integer(C)-Integer(spAbs2EffZeit)+2)+'-Zeit';

      spAbs1StrtZeit..spAbs8StrtZeit : Result := 'Startzeit';
      spAbs1StopZeit..spAbs8StopZeit : Result := 'Stoppzeit';

      spTlnEndZeit     : Result := 'Endzeit';
      spMschTlnEndZeit : Result := 'Zeit';
      spMschTlnStrecke : Result := 'km';
      spMschTlnPunkte  : Result := 'Rng';
      spTlnEndStrecke  : Result := 'km';
      spRestStrecke    : Result := 'm';
      spStatus         : Result := 'Status';
      spRngSer         : Result := 'Rng';
      spSumSer         : Result := 'Summe';
      spOrt1..spOrt20  :
        if (Veranstaltung <> nil)and(Veranstaltung.OrtZahl>Integer(C)-Integer(spOrt1)) then
          Result := Veranstaltung.OrtColl[Integer(C)-Integer(spOrt1)].Name;
      spMschName       : if Veranstaltung <> nil then
                           Result := Veranstaltung.MschSpalteUeberschrift(HauptFenster.Sortwettk)
                         else
                           Result := 'Mannschaft';
      spMschKlasse     : Result := 'Ak';
      spMschWettk      : Result := 'Wettkampf';
      spMschStZeit     : Result := 'Startzeit';
      spMschRngGes     : Result := 'Rng';
      spMschEndzeit    : Result := 'Endzeit';
      spMschStrecke    : Result := 'km';
      spMschPunkte     : Result := 'Punkte';
      spMschRngSer     : Result := 'Rng';
      spMschSumSer     : Result := 'Summe';
      spMschTln0..spMschTln7:
        Result := 'Teilnehmer '+ IntToStr(Integer(C)-Integer(spMschTln0)+1);
      spMschTlnZt0..spMschTlnZt7:
        Result := RepWk.AbschnName[TWkAbschnitt(Integer(C)-Integer(spMschTlnZt0)+1)];

      else ;
  end;
end;

//******************************************************************************
function GetColData(RepWk:TWettkObj;RepWrtg:TWertungMode;RepAk:TAkObj;Tln:TTlnObj;
                    C:TColType;var TrennLinie:Boolean;ListMode:TListMode):String;
//******************************************************************************
begin
  Result := GetColData(RepWk,RepWrtg,RepAk,Tln,C,TrennLinie,ListMode,0);
end;

(******************************************************************************)
function GetColData(RepWk:TWettkObj;RepWrtg:TWertungMode;RepAk:TAkObj; Tln:TTlnObj;
                    C:TColType;var TrennLinie:Boolean;ListMode:TListMode;Rnd:Integer):String;
(******************************************************************************)
// ListMode: lmSchirm, lmReport(Rave,HTML), lmExport (Excel,Text)

var Msch : TMannschObj;
    Buf  : Integer;
// TlnColl oder SMld.TlnListe
//------------------------------------------------------------------------------
function SerStr(i:Integer): String;
begin
  with Tln do
    if Veranstaltung.OrtZahl > i then
      if HauptFenster.Ansicht = anTlnErgSerie then
        Result := GetOrtSerSumStr(i,RepAk.Wertung)
      else Result := Msch.GetOrtSerSumStr(i)
    else Result := '';
end;
//------------------------------------------------------------------------------
function AkRngStr(Ak,Rng:String): String;
var S1,S2:String;
begin
  S1 := Ak;
  S2 := Rng;
  with HauptFenster.LstFrame do
  begin
    while TriaGrid.Canvas.TextWidth(S2) < TriaGrid.Canvas.TextWidth('0000')-1 do
      S2 := ' ' + S2;
    Result := S1 + ' ' +S2;

    while TriaGrid.Canvas.TextWidth(Result) <
          AkColBreite(spAkRng) - TriaGrid.Canvas.TextWidth('  ') - 1 do
    begin
      S1 := S1 + ' ';
      Result := S1 + '  ' +S2;
    end;
  end;
end;
//------------------------------------------------------------------------------
begin
  Result := '';
  TrennLinie := false;

  if (Tln = nil) or (Veranstaltung=nil) then Exit; // Header f�r TriaGrid


  (* R > 0 *)
  with Tln do
  begin
    Msch := MannschPtr(RepAk.Wertung);
    // Mannschafts-Tlnlisten
    if HauptFenster.MschAnsicht and (Msch <> nil) then
    begin
      if Tln.Dummy or  // DummyTln f�r Msch-Zeile
         (Msch.TlnListe.SortIndexOf(Tln) = 0) then
      begin
        if (HauptFenster.Ansicht <> anMschErgKompakt) and
           (HauptFenster.Ansicht <> anMschErgSerie) and
           (HauptFenster.SortStatus <> stKein) then
          TrennLinie := true;
        // Spaltentext MschDaten definieren
        case C of
          spMschName      : begin
                              //Result := TMannschObj(MannschPtr).Name;
                              // Tln.MannschName benutzen, da diese auch
                              // Suchen/ersetzt werden kann
                              Result := MannschName;
                              if Msch.MschIndex > 1 then
                                Result := Result + '~' + IntToStr(Msch.MschIndex);
                            end;
          spMschKlasse    : Result := Msch.Klasse.Kuerzel;
          spMschWettk     : Result := Msch.Wettk.Name;

          spMschStZeit    : with Msch do
                              if (HauptFenster.SortMode in [smMschAbs2Startzeit..smMschAbs8Startzeit]) then
                                Result := UhrZeitStr(MschAbsStZeit[TWkAbschnitt(Integer(HauptFenster.SortMode)-
                                                                                Integer(smMschAbs2Startzeit)+2)])
                              else Result := UhrZeitStr(MschAbsStZeit[wkAbs1]);
          spMschRngGes    : Result := Msch.TagesRngStr;
          spMschRunden    : with Msch do
                              if Runden > 0 then Result := IntToStr(Runden)
                                            else Result := '-';
          spMschEndzeit   : if ListMode = lmExport then
                              Result := ExpZeitStr(Msch.MschEndZeit)
                            else // Strafzeit nur bei MschWettk
                            if Msch.Wettk.MschWettk and (Msch.GetStrafZeit >= 0) then
                              Result:=EffZeitStr(Msch.MschEndZeit)+'*'
                            else Result:=EffZeitStr(Msch.MschEndZeit)+' ';
          spMschStrecke   : if ListMode = lmExport then
                              Result := KmStr(Msch.Strecken)
                            else Result := KmStr(Msch.Strecken)+' ';
          spMschPunkte    : if ListMode = lmExport then
                              Result := IntToStr(Msch.Punkte)
                            else Result := IntToStr(Msch.Punkte)+' ';
          spMschStrafZeit : Result := UhrZeitStrODec(Msch.GetStrafZeit); // nur Export
          spMschGutschrift: if Msch.GetGutschrift > 0 then               // nur Export
                              Result := UhrZeitStrODec(Msch.GetGutschrift)
                            else Result := '';
          spMschRngSer    : Result := Msch.GetSerieRangStr;
          spMschSumSer    : Result := Msch.GetSerieSumStr(ListMode);

          spMschTln0..spMschTln7:
            if Msch.SortedTln[Integer(C)-Integer(spMschTln0)] <> nil then
              Result := Msch.SortedTln[Integer(C)-Integer(spMschTln0)].NameVNameKurz
            else Result := '   -';

         else Result := '';  // weiter bei TlnDaten
        end;
      end;
      //if TMannschObj(MannschPtr).TlnListe.SortIndexOf(Tln)=0 then TrennLinie := true;
    end;

    // TlnStaffel
    if RepWk.WettkArt = waTlnStaffel then
    begin
      if (HauptFenster.Ansicht = anTlnStart) or
         (HauptFenster.Ansicht = anTlnErg) then
        if C=spMschTln0 then Result := NameVNameKurz
        else if C in [spMschTln1..spMschTln7] then
          if StaffelName[TWkAbschnitt(Integer(C)-Integer(spMschTln1)+2)] <> '' then
            Result := StaffelNameVName(TWkAbschnitt(Integer(C)-Integer(spMschTln1)+2))
          else Result := '   -';
      if HauptFenster.Ansicht = anTlnErg then
        if C in [spMschTlnZt0..spMschTlnZt7] then
          if ListMode = lmExport then
            Result := ExpZeitStr(AbsZeit(TWkAbschnitt(Integer(C)-Integer(spMschTlnZt0)+1)))
          else
            if RepWk.AbschnZahl >= Integer(C)-Integer(spMschTlnZt0)+1 then
              Result := EffZeitStr(AbsZeit(TWkAbschnitt(Integer(C)-Integer(spMschTlnZt0)+1)))
            else Result := ' ';
    end;

    // TlnTeam
    if RepWk.WettkArt = waTlnTeam then
    begin
      if (HauptFenster.Ansicht = anTlnStart) or
         (HauptFenster.Ansicht = anTlnErg) then
        if C=spMschTln0 then Result := NameVNameKurz
        else if C in [spMschTln1..spMschTln7] then
          if StaffelName[TWkAbschnitt(Integer(C)-Integer(spMschTln1)+2)] <> '' then
            Result := StaffelNameVName(TWkAbschnitt(Integer(C)-Integer(spMschTln1)+2))
          else Result := '   -';
      if HauptFenster.Ansicht = anTlnErg then
        case C of
          spMschRngGes  : Result := TagesEndRngStr(wkAbs0,RepAk.Wertung,RepWrtg); // spRng
          spMschName    : Result := MannschName;  // spMannsch
          spMschEndzeit : if ListMode = lmExport then // spTlnEndZeit
                            Result := ExpZeitStr(EndZeit)
                          else
                            if StrafZeit < 0 then Result := EffZeitStr(EndZeit)+' '
                                             else Result := EffZeitStr(EndZeit)+'*';
        end;
    end;


    // Spaltentext definieren
    case C of
      // TlnDaten
      spLeer           : Result := '';
      spGeAendert      : Result := AenderungsZeit;
      spSnr            : if Snr>0 then Result := IntToStr(Snr)
                         else if ListMode = lmExport then Result := ''
                                                     else Result := '-';
      spNameVName      : if not Dummy then
                           Result := NameVName
                         else if ListMode = lmExport then Result := ''
                                                     else Result := '-';
      spName           : Result := Tln.Name; // f�r Suchen
      spVName          : Result := VName;
      spMannsch        : Result := MannschName;
      spMschGroesse    : if MannschNamePtr <> nil then
                         begin
                           Buf := Veranstaltung.MannschNameColl.IndexOf(MannschNamePtr);
                           if (Buf>=0) and (Buf<MschGrListe.Count) then
                             Result := IntToStr(MschGrListe[Buf])
                           else
                             Result := '-' // sollte nicht vorkommen
                         end else
                           Result := '';
      spLand           : Result := Land;
      spSex            : case Sex of
                           cnMaennlich : Result := 'M';
                           cnWeiblich  : Result := 'W';
                           cnMixed     : Result := 'X';
                           else Result := '';
                         end;
      spJg             : if ListMode = lmExport then
                           if (not Dummy) and (Jg>0) then
                             Result := IntToStr(Jg) // Export 4-Stellig
                           else Result := ''
                          else
                            if (not Dummy) and (Jg>0) then
                              Result := Copy(Strng(Jg,4),3,2)
                            else Result := ' -';
      spStrasse        : Result := Strasse;
      spHausNr         : Result := HausNr;
      spPLZ            : Result := PLZ;
      spOrt            : Result := Ort;
      spEMail          : Result := EMail;
      spAk             : Result := WertungsKlasse(kwAltKl,tmTln).Kuerzel;
      spAkRng          : begin
                           Result := TagesZwRngStr(wkAbs0,kwAltKl,RepWrtg);
                           if ListMode = lmSchirm then
                             Result := AkRngStr(WertungsKlasse(kwAltKl,tmTln).Kuerzel,Result);
                         end;
      spAkRngSer       : begin
                           Result := GetSerieRangStr(kwAltKl);
                           if ListMode = lmSchirm then
                             Result := AkRngStr(WertungsKlasse(kwAltKl,tmTln).Kuerzel,Result);
                         end;
      spWettk          : if Wettk = nil then Result := ''
                                        else Result := Wettk.Name;
      spRestStrecke    : if RestStrecke > 0 then Result := IntToStr(Reststrecke)
                         else Result := ''; // nur lmExport
      spStZeit         : if HauptFenster.SortMode in [smTlnAbs2Startzeit..smTlnAbs8Startzeit] then
                           Result := UhrZeitStr(StrtZeit(TWkAbschnitt(Integer(HauptFenster.SortMode)-Integer(smTlnAbs2Startzeit)+2)))
                         else Result := UhrZeitStr(StrtZeit(wkAbs1));
      spStBahn         : if SBhn = 0 then Result := ''
                                     else Result := IntToStr(SBhn);
      spMeldeZeit      : Result := UhrZeitStrODec(MldZeit);
      spStartgeld      : Result := EuroStr(Startgeld);
      spMschWrtg       : if MschWrtg then Result := 'x'
                                     else Result := '';
      spMschMixWrtg    : if MschMixWrtg then Result := 'x'
                                        else Result := '';
      spSondWrtg       : if SondWrtg then Result := 'x'
                                     else Result := '';
      spSerWrtg        : if SerienWrtg then Result := 'x'
                                       else Result := '';
      spUrkDr          : if UrkDruck then Result := 'x'
                                     else Result := '';
      spAusKonkAllg    : if AusKonkAllg then Result := 'x'
                                        else Result := '';
      spAusKonkAltKl   : if AusKonkAltKl then Result := 'x'
                                         else Result := '';
      spAusKonkSondKl  : if AusKonkSondKl then Result := 'x'
                                          else Result := '';
      spRfid           : Result := RfidCode;
      spKomment        : Result := Komment;
      spRng            : Result := TagesEndRngStr(wkAbs0,RepAk.Wertung,RepWrtg);
      spAbs1Zeit..spAbs8Zeit:
        if ListMode = lmExport then
          Result := ExpZeitStr(AbsZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1Zeit)+1)))
        else
          if RepWk.AbschnZahl >= Integer(C)-Integer(spAbs1Zeit)+1 then
            Result := EffZeitStr(AbsZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1Zeit)+1)))
          else Result := ' ';

      spAbs1Rng..spAbs8Rng:
      begin
        if RepWk.AbschnZahl >= Integer(C)-Integer(spAbs1Rng)+1 then
          Result := TagesZwRngStr(TWkAbschnitt(Integer(C)-Integer(spAbs1Rng)+1),RepAk.Wertung,RepWrtg)
        else Result := ' ';
        if ListMode = lmSchirm then
        begin
          with HauptFenster.LstFrame.TriaGrid.Canvas do
            while TextWidth(Result) < TextWidth('0000')-1
              do Result := ' '+Result;
            Result := EffZeitStr(AbsZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1Rng)+1))) + '  ' +Result;
        end;
      end;

      spAbs1MinZeit..spAbs8MinZeit:
        if ListMode = lmExport then
          Result := ExpZeitStr(AbsMinRundeZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1MinZeit)+1)))
        else
          Result := EffZeitStr(AbsMinRundeZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1MinZeit)+1)));

      spAbs1MaxZeit..spAbs8MaxZeit:
        if ListMode = lmExport then
          Result := ExpZeitStr(AbsMaxRundeZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1MaxZeit)+1)))
        else
          Result := EffZeitStr(AbsMaxRundeZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1MaxZeit)+1)));

      spAbs1EffZeit..spAbs8EffZeit:
        if ListMode = lmExport then
          Result := ExpZeitStr(AbsRundenZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1EffZeit)+1),
                                       RundenZahl(TWkAbschnitt(Integer(C)-Integer(spAbs1EffZeit)+1))))
        else
          Result := EffZeitStr(AbsRundenZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1EffZeit)+1),
                                       RundenZahl(TWkAbschnitt(Integer(C)-Integer(spAbs1EffZeit)+1))));

      spAbs1UhrZeit..spAbs8UhrZeit:
        if (ListMode = lmExport) and (Rnd > 0) then
          Result := UhrZeitStr(AbsRundeStoppZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1UhrZeit)+1),Rnd))
        else Result := UhrZeitStr(AbsStoppZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1UhrZeit)+1)));

      spAbs1StopZeit..spAbs8StopZeit:
        Result := UhrZeitStr(AbsStoppZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1StopZeit)+1)));

      spAbs1Runden..spAbs8Runden:
        if RundenZahl(TWkAbschnitt(Integer(C)-Integer(spAbs1Runden)+1)) > 0 then
          Result := IntToStr(RundenZahl(TWkAbschnitt(Integer(C)-Integer(spAbs1Runden)+1)))
        else Result := '';

      spAbs1StrtZeit..spAbs8StrtZeit:
        Result := UhrZeitStr(StrtZeit(TWkAbschnitt(Integer(C)-Integer(spAbs1StrtZeit)+1)));

      spTlnEndZeit     : if ListMode = lmExport then // kein * oder Blank bei Export
                           Result := ExpZeitStr(EndZeit)
                         else
                           if StrafZeit < 0 then Result := EffZeitStr(EndZeit)+' '
                                            else Result := EffZeitStr(EndZeit)+'*';
      spTlnEndStrecke  : if ListMode = lmExport then // kein * oder Blank bei Export
                           Result := KmStr(Rundenzahl(wkAbs1)*Wettk.RundLaenge + Reststrecke)
                         else Result := KmStr(Rundenzahl(wkAbs1)*Wettk.RundLaenge + Reststrecke)+' ';
      spTlnZeitNetto   : Result := ExpZeitStr(NettoEndZeit);  // nur lmExport
      spTlnStrafZeit   : Result := UhrZeitStrODec(StrafZeit); // nur Export
      spGutschrift     : if Gutschrift > 0 then               // nur Export
                           Result := UhrZeitStrODec(Gutschrift)
                         else Result := '';
      spDisqGrund      : Result := DisqGrund;
      spDisqName       : Result := DisqName;

      spMschTlnRunden: // waRndRennen
        if RundenZahl(wkAbs1) > 0 then Result := IntToStr(RundenZahl(wkAbs1))
                                  else Result := '';
      spMschTlnEndZeit : if TlnInStatus(stDisqualifiziert) then  Result := DisqName //'disq.'
                         else
                         if ListMode = lmExport then // kein Blank bei Export
                           Result := ExpZeitStr(EndZeit)
                         else
                           if StrafZeit < 0 then Result := EffZeitStr(EndZeit)+' '
                                            else Result := EffZeitStr(EndZeit)+'*';
      spMschTlnStrecke : if TlnInStatus(stDisqualifiziert) then  Result := DisqName //'disq.'
                         else
                         if ListMode = lmExport then // kein Blank bei Export
                           Result := KmStr(Rundenzahl(wkAbs1)*Wettk.RundLaenge + Reststrecke)
                         else
                           Result := KmStr(Rundenzahl(wkAbs1)*Wettk.RundLaenge + Reststrecke)+' ';
      spMschTlnPunkte  : if TlnInStatus(stDisqualifiziert) then  Result := DisqName //'disq.'
                         else // wmTlnPlatz, wmSchultour
                         if ListMode = lmExport then // kein Blank bei Export
                           if TagesRng(wkAbs0,RepAk.Wertung,wgMschPktWrtg) = 0 then Result := '-'
                           else Result := IntToStr(TagesRng(wkAbs0,RepAk.Wertung,wgMschPktWrtg))
                         else
                           if TagesRng(wkAbs0,RepAk.Wertung,wgMschPktWrtg) = 0 then Result := '- '
                           else Result := IntToStr(TagesRng(wkAbs0,RepAk.Wertung,wgMschPktWrtg))+' ';

      spStatus         : if TlnInStatus(stDisqualifiziert) then  Result := 'Disqualif.'
                         else if TlnInStatus(stGewertet)  then   Result := 'Gewertet'
                         else if TlnInStatus(stAbs8Start) then   Result := 'Abschn.8'
                         else if TlnInStatus(stAbs7Start) then   Result := 'Abschn.7'
                         else if TlnInStatus(stAbs6Start) then   Result := 'Abschn.6'
                         else if TlnInStatus(stAbs5Start) then   Result := 'Abschn.5'
                         else if TlnInStatus(stAbs4Start) then   Result := 'Abschn.4'
                         else if TlnInStatus(stAbs3Start) then   Result := 'Abschn.3'
                         else if TlnInStatus(stAbs2Start) then   Result := 'Abschn.2'
                         else if TlnInStatus(stAbs1Start) then
                           if Wettk.AbschnZahl > 1 then          Result := 'Abschn.1'
                           else                                  Result := 'Gestartet'
                         else if TlnInStatus(stEingeteilt) then  Result := 'Eingeteilt'
                         else                                    Result := '   -';
      spRngSer         : Result := GetSerieRangStr(RepAk.Wertung);
      spSumSer         : Result := GetSerieSumStr(ListMode,RepAk.Wertung);

      spOrt1..spOrt20:
        Result := SerStr(Integer(C)-Integer(spOrt1));

      spStaffelName2..spStaffelName8:
        Result := StaffelName[TWkAbschnitt(Integer(C)-Integer(spStaffelName2)+2)];
      spStaffelVName2..spStaffelVName8:
        Result := StaffelVName[TWkAbschnitt(Integer(C)-Integer(spStaffelVName2)+2)];

      // MschDaten + SMldDaten bereits vorher definiert
      spMschName,spMschKlasse,spMschWettk,spMschStZeit,
      spMschTln0..spMschTln7, spMschTlnZt0..spMschTlnZt7,
      spMschRngGes,spMschEndzeit,spMschRunden,spMschStrecke,spMschPunkte,
      spMschGutschrift,spMschStrafzeit,
      spMschRngSer, spMschSumSer: ;

      else Result := '';
    end;
  end;
end;


end.

