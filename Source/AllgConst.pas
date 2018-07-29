unit AllgConst;

interface

uses Classes,Controls,Forms,Windows,SysUtils;


type
  TReportMode   = (rmDrucken,rmVorschau,rmPDFDatei,rmTextDatei,rmExcelDatei,
                   rmHTMLDatei,rmPrevDrucken,rmPrevPDFDatei,
                   rmWordUrk,rmSerDrUrk,rmSerDrEtiketten);
  TReportWkMode = (rmWkEinzel,rmWkAlle);
  TSerDrMode    = (sdText,sdWord);

  TListMode     = (lmSchirm,lmReport,lmExport,lmImport);
  // Rave Reporttypen
  TListType = (ltFehler,

               ltMldLstTlnSchirm,
               {ltMldLstTln,ltMldLstTlnSml,ltMldLstTlnSer,ltMldLstTlnSerSml,
               ltMldLstTlnLnd,ltMldLstTlnSmlLnd,ltMldLstTlnSerLnd,ltMldLstTlnSerSmlLnd,}

               ltMldLstTlnExp,ltTlnImport,

               ltStLstTlnA,ltStLstTlnABn,ltStLstTlnAT,ltStLstTlnATBn,
               ltStLstTlnAS,ltStLstTlnASBn,ltStLstTlnATS,ltStLstTlnATSBn,
               ltStLstTlnALnd,ltStLstTlnABnLnd,ltStLstTlnATLnd,ltStLstTlnATBnLnd,
               ltStLstTlnASLnd,ltStLstTlnASBnLnd,ltStLstTlnATSLnd,ltStLstTlnATSBnLnd,

               ltStLstMsch,ltStLstMschZt,{ltStLstMschWk,ltStLstMschZtWk,}
               {ltStLstMschBn,ltStLstMschSer,ltStLstMschSerBn,}

               ltStLstMschTln,ltStLstMschTlnZt,

               ltStLstStaffelTln2,ltStLstStaffelTln3,ltStLstStaffelTln4, // Reihenfolge fest
               ltStLstStaffelTln5,ltStLstStaffelTln6,ltStLstStaffelTln7,ltStLstStaffelTln8,
               {ltStLstMschTlnBn,ltStLstMschTlnSer,ltStLstMschTlnSerBn,}
               //ltStLstMschSnr,ltStLstMschSerSnr,ltStLstMschSnrBn,ltStLstMschSerSnrBn,

               ltErgLstTlnAbs1,ltErgLstTlnAbs2,ltErgLstTlnAbs3,ltErgLstTlnAbs4,
               ltErgLstTlnAbs5,ltErgLstTlnAbs6,ltErgLstTlnAbs7,ltErgLstTlnAbs8,

               ltErgLstTlnAbs1Lnd,ltErgLstTlnAbs2Lnd,ltErgLstTlnAbs3Lnd,ltErgLstTlnAbs4Lnd,
               ltErgLstTlnAbs5Lnd,ltErgLstTlnAbs6Lnd,ltErgLstTlnAbs7Lnd,ltErgLstTlnAbs8Lnd,

               ltErgLstTlnAbs1Ak,ltErgLstTlnAbs2Ak,ltErgLstTlnAbs3Ak,ltErgLstTlnAbs4Ak,
               ltErgLstTlnAbs5Ak,ltErgLstTlnAbs6Ak,ltErgLstTlnAbs7Ak,ltErgLstTlnAbs8Ak,
               ltErgLstTlnAbs1LAk,

               ltErgLstTlnAbs1AkLnd,ltErgLstTlnAbs2AkLnd,ltErgLstTlnAbs3AkLnd,ltErgLstTlnAbs4AkLnd,
               ltErgLstTlnAbs5AkLnd,ltErgLstTlnAbs6AkLnd,ltErgLstTlnAbs7AkLnd,ltErgLstTlnAbs8AkLnd,
               ltErgLstTlnAbs1LAkLnd,

               ltErgLstMschTln, ltErgLstMschTln2,ltErgLstMschTln3,ltErgLstMschTln4,
               ltErgLstMschTln5,ltErgLstMschTln6,ltErgLstMschTln7,ltErgLstMschTln8,
               ltErgLstMschTlnRnd,ltErgLstMschTlnRndL,//ltErgLstMschTlnStnd,ltErgLstMschTlnStndL,
               //ltErgLstMschTlnStnd2,ltErgLstMschTlnStnd3,ltErgLstMschTlnStnd4,
               //ltErgLstMschTlnStnd5,ltErgLstMschTlnStnd6,ltErgLstMschTlnStnd7,ltErgLstMschTlnStnd8,

               ltErgLstStaffelTln2,ltErgLstStaffelTln3,ltErgLstStaffelTln4,
               ltErgLstStaffelTln5,ltErgLstStaffelTln6,ltErgLstStaffelTln7,ltErgLstStaffelTln8,

               ltErgLstTlnRndAkLnd,ltErgLstTlnRndAk,ltErgLstTlnRndLnd,ltErgLstTlnRnd,
               ltErgLstTlnRndLAkLnd,ltErgLstTlnRndLAk,

               ltKtLstUhrZeit1,ltKtLstUhrZeit2,ltKtLstUhrZeit3,ltKtLstUhrZeit4,
               ltKtLstUhrZeit5,ltKtLstUhrZeit6,ltKtLstUhrZeit7,ltKtLstUhrZeit8,

               ltKtLstRunden, // 2008-2.0

               ltSerWertTln2,ltSerWertTln3,ltSerWertTln4,
               ltSerWertTln5,ltSerWertTln6,ltSerWertTln7,ltSerWertTln8,
               ltSerWertTln9,ltSerWertTln10,ltSerWertTln11,ltSerWertTln12,
               ltSerWertTln13,ltSerWertTln14,ltSerWertTln15,ltSerWertTln16,
               ltSerWertTln17,ltSerWertTln18,ltSerWertTln19,ltSerWertTln20,

               ltSerWertTlnAk2,ltSerWertTlnAk3,ltSerWertTlnAk4,
               ltSerWertTlnAk5,ltSerWertTlnAk6,ltSerWertTlnAk7,ltSerWertTlnAk8,
               ltSerWertTlnAk9,ltSerWertTlnAk10,ltSerWertTlnAk11,ltSerWertTlnAk12,
               ltSerWertTlnAk13,ltSerWertTlnAk14,ltSerWertTlnAk15,ltSerWertTlnAk16,
               ltSerWertTlnAk17,ltSerWertTlnAk18,ltSerWertTlnAk19,ltSerWertTlnAk20,

               {ltSerWertTln2Lnd,ltSerWertTln3Lnd,ltSerWertTln4Lnd,
               ltSerWertTln5Lnd,ltSerWertTln6Lnd,ltSerWertTln7Lnd,ltSerWertTln8Lnd,
               ltSerWertTlnAk2Lnd,ltSerWertTlnAk3Lnd,ltSerWertTlnAk4Lnd,
               ltSerWertTlnAk5Lnd,ltSerWertTlnAk6Lnd,ltSerWertTlnAk7Lnd,ltSerWertTlnAk8Lnd,}

               ltSerWertMsch2,ltSerWertMsch3,ltSerWertMsch4,
               ltSerWertMsch5,ltSerWertMsch6,ltSerWertMsch7,ltSerWertMsch8,
               ltSerWertMsch9,ltSerWertMsch10,ltSerWertMsch11,ltSerWertMsch12,
               ltSerWertMsch13,ltSerWertMsch14,ltSerWertMsch15,ltSerWertMsch16,
               ltSerWertMsch17,ltSerWertMsch18,ltSerWertMsch19,ltSerWertMsch20,

               ltChkLstSchwBhn );

  // Ansichten HauptFenster
  TAnsicht = (anKein,anAnmEinzel,anAnmSammel,
              anTlnStart,anTlnErg,anTlnErgSerie,anTlnUhrZeit,
              anTlnRndKntrl, // 2008-2.0
              anMschStart,anMschErgDetail,anMschErgKompakt,
              anMschErgSerie,
              anTlnSchwDist);//muss an letzter Position wegen LstFrm/ColBreite

  // Spalten TlnListe
  TColType = (spLeer, spGeAendert, 
              spSnr, spNameVname, spVerein, spVereinGr, spMannsch, spMschGroesse,
              spJg, spWettk, spStZeit, {spSGrpStZeit,}
              spStBahn, spMeldeZeit,spLand,spStartgeld,spRfid,spKomment,
              spMschWrtg,spMschMixWrtg,spSondWrtg,spSerWrtg,spUrkDr,
              spAusKonkAllg,spAusKonkAltKl,spAusKonkSondKl,
              //spSammelMelder, spSMldName, spSMldVerein,
              spRng,spAk,spAkRng,spRestStrecke,

              spAbs1Zeit,spAbs2Zeit,spAbs3Zeit,spAbs4Zeit,
              spAbs5Zeit,spAbs6Zeit,spAbs7Zeit,spAbs8Zeit,
              spAbs1Rng,spAbs2Rng,spAbs3Rng,spAbs4Rng,
              spAbs5Rng,spAbs6Rng,spAbs7Rng,spAbs8Rng,
              spAbs1UhrZeit,spAbs2UhrZeit,spAbs3UhrZeit,spAbs4UhrZeit,
              spAbs5UhrZeit,spAbs6UhrZeit,spAbs7UhrZeit,spAbs8UhrZeit,
              spAbs1StopZeit,spAbs2StopZeit,spAbs3StopZeit,spAbs4StopZeit,  // 2008-2.0
              spAbs5StopZeit,spAbs6StopZeit,spAbs7StopZeit,spAbs8StopZeit,
              spAbs1Runden,spAbs2Runden,spAbs3Runden,spAbs4Runden,          // 2008-2.0
              spAbs5Runden,spAbs6Runden,spAbs7Runden,spAbs8Runden,          
              spAbs1EffZeit,spAbs2EffZeit,spAbs3EffZeit,spAbs4EffZeit,      // 2008-2.0
              spAbs5EffZeit,spAbs6EffZeit,spAbs7EffZeit,spAbs8EffZeit,
              spAbs1StrtZeit,spAbs2StrtZeit,spAbs3StrtZeit,spAbs4StrtZeit,
              spAbs5StrtZeit,spAbs6StrtZeit,spAbs7StrtZeit,spAbs8StrtZeit,
              spAbs1MinZeit,spAbs2MinZeit,spAbs3MinZeit,spAbs4MinZeit,
              spAbs5MinZeit,spAbs6MinZeit,spAbs7MinZeit,spAbs8MinZeit,
              spAbs1MaxZeit,spAbs2MaxZeit,spAbs3MaxZeit,spAbs4MaxZeit,
              spAbs5MaxZeit,spAbs6MaxZeit,spAbs7MaxZeit,spAbs8MaxZeit,
              //spMschAbs1Zeit,spMschAbs2Zeit,
              spTlnEndZeit,spTlnZeitNetto,spTlnStrafZeit,spTlnEndStrecke,
              spGutschrift,spStatus,spRngSer,spSumSer,spAkRngSer,
              spOrt1,spOrt2,spOrt3,spOrt4,spOrt5,spOrt6,spOrt7,spOrt8,
              spOrt9,spOrt10,spOrt11,spOrt12,spOrt13,spOrt14,spOrt15,spOrt16,
              spOrt17,spOrt18,spOrt19,spOrt20,
              spMschName,spMschKlasse,spMschWettk,spMschStZeit,
              spMschRngGes,spMschEndzeit,spMschRunden,spMschStrecke,spMschPunkte,
              spMschStrafzeit,spMschGutschrift,                             // 2008-2.0
              spMschRngSer,spMschSumSer,
              spMschTlnEndZeit,spMschTlnRunden,spMschTlnStrecke,spMschTlnPunkte,
              spMschTln0,spMschTln1,spMschTln2,spMschTln3,
              spMschTln4,spMschTln5,spMschTln6,spMschTln7,
              spMschTlnZt0,spMschTlnZt1,spMschTlnZt2,spMschTlnZt3,
              spMschTlnZt4,spMschTlnZt5,spMschTlnZt6,spMschTlnZt7,

              //nur f�r ltMldLstTlnExp:
              spSex,spStrasse,spHausNr,spPLZ,spOrt,spEMail,
              spStaffelName2,spStaffelName3,spStaffelName4,
              spStaffelName5,spStaffelName6,spStaffelName7,spStaffelName8,
              spStaffelVName2,spStaffelVName3,spStaffelVName4,
              spStaffelVName5,spStaffelVName6,spStaffelVName7,spStaffelVName8,

              spDisqGrund,spDisqName,

              //nur f�r Suchen, ltMldLstTlnExp
              spName,spVName);
              // spLeer  = erste Spalte f�r ColBreite Array
              // spVName = letzte Spalte f�r ColBreite Array,

  // Spalten TztGrid
  TTztSpalte = (tsNr,tsSnr,tsZeit,tsName,tsZahl);

  // Sortiermodi
  TSortMode = (smTlnErstellt,smTlnBearbeitet,
               smTlnName, smTlnSnr,smTlnSBhn,smTlnAk,smTlnSnrAk,smTlnMschName,smTlnMschGroesse,
               smTlnSMld,smTlnMldZeit,smTlnStartgeld,smTlnRfid,
               smTlnAlter,smTlnSnrAlter,smTlnErgAlter,smTlnSerErgAlter,
               smTlnAbs1Zeit,smTlnAbs2Zeit,smTlnAbs3Zeit,smTlnAbs4Zeit, //Abs-Reihenfolge einhalten
               smTlnAbs5Zeit,smTlnAbs6Zeit,smTlnAbs7Zeit,smTlnAbs8Zeit,
               smTlnEndZeit, // nur f�r Berechnen verwenden, Sortierung erzwungen
               smTlnErg,smTlnErgMschName,smTlnErgAk,smTlnMschSerErg,
               smTlnAbs1StartZeit,smTlnAbs2StartZeit,smTlnAbs3StartZeit,smTlnAbs4StartZeit,
               smTlnAbs5StartZeit,smTlnAbs6StartZeit,smTlnAbs7StartZeit,smTlnAbs8StartZeit,
               smTlnAbs1UhrZeit,smTlnAbs2UhrZeit,smTlnAbs3UhrZeit,smTlnAbs4UhrZeit,
               smTlnAbs5UhrZeit,smTlnAbs6UhrZeit,smTlnAbs7UhrZeit,smTlnAbs8UhrZeit,
               smRelAbs1UhrZeit,smRelAbs2UhrZeit,smRelAbs3UhrZeit,smRelAbs4UhrZeit, // MschWettk
               smRelAbs5UhrZeit,smRelAbs6UhrZeit,smRelAbs7UhrZeit,smRelAbs8UhrZeit,
               smTlnAbsRnd,smTlnAbsRndStZeit,smTlnStoppZeit,smTlnAbsRndEffZeit, // Rundenkontrolle, 2008-2.0
               smTlnMinRndZeit,smTlnMaxRndZeit,
               smTlnSerErg,smTlnSerErgAk,smTlnSerErgMschName,

               smSMldName,smSMldMschName, // nur f�r SMldFrm

               smMschName,smMschTlnSnr,smMschTlnStartZeit,smMschStUhrZeit,
               smMschTlnZeit,smMschTlnPlatz,smMschSchultour,
               smMschErg,smMschErgMschName,smMschSerErg,{smMschSerPkt,Liga-Jagdstart}
               smMschAbs1StartZeit,smMschAbs2StartZeit,smMschAbs3StartZeit,smMschAbs4StartZeit,
               smMschAbs5StartZeit,smMschAbs6StartZeit,smMschAbs7StartZeit,smMschAbs8StartZeit,
               // Wettk.Sortmode
               smWkErstellt,smWkName,smWkAk,
               smWkEingegeben, smWkPlusAlle, smWkNurAlle,
               // Sex SortModi
               smSxBeide,smSxBeideMF,
               smIncr,smDecr, // Seriewertung - StreichErgebnisse
               // TZEColl
               smZEZeit,smZESnr,
               // TriaZeit
               smTztSnrAuf,smTztSnrAb,smTztZeitAuf,smTztZeitAb,
               smAlles,smUntersch,smFehler, // Snr-Abgleich
               // Allgemein
               smNichtSortiert, smSortiert, smFestSortiert);

               //0=cnMaennlich,1=cnWeiblich,2=cnMixed fest in MannsObj.MschEinlesen
  TSex      = (cnMaennlich,cnWeiblich,cnMixed,cnSexBeide,cnKeinSex);

  TStatus   = (stGemeldet,stSerGemeldet,
               stEingeteilt,     //
               stZeitVorhanden,  // mindestens eine g�ltige Zeit vorhanden (SBhn egal)
               stAbs1Zeit,stAbs2Zeit,stAbs3Zeit,stAbs4Zeit,// mindestens eine g�ltige Zeit vorhanden (SBhn egal)
               stAbs5Zeit,stAbs6Zeit,stAbs7Zeit,stAbs8Zeit,// Reihenfolge beibehalten f�r Abs-Berechnung
               stAbs1Start,stAbs2Start,stAbs3Start,stAbs4Start,//mindestens 1 g�ltige Abs-Zeit (SBhn g�ltig)
               stAbs5Start,stAbs6Start,stAbs7Start,stAbs8Start,
               stAbs1Ziel,stAbs2Ziel,stAbs3Ziel,stAbs4Ziel,//g�ltige Abschn-Zeit
               stAbs5Ziel,stAbs6Ziel,stAbs7Ziel, //stAbs8Ziel=stImZiel
               stAbs1UhrZeit,stAbs2UhrZeit,stAbs3UhrZeit,stAbs4UhrZeit,// g�ltige StoppZeit vorhanden (SBhn egal)
               stAbs5UhrZeit,stAbs6UhrZeit,stAbs7UhrZeit,stAbs8UhrZeit,
               stDisqualifiziert,//
               stImZiel,         // g�ltige Endzeit
               stGewertet,       // g�ltige Endzeit, ohne disq.Tln
               stGewertetDisq,   // g�ltige Endzeit, mit allen disq.Tln
               stSerWertung,     // in mindestens 1 Ort gewertet
               stSerEndWertung,  // mit m�gliche EndWertung
               stBahn1,stBahn2,stBahn3,stBahn4,stBahn5,
               stBahn6,stBahn7,stBahn8,stBahn9,stBahn10,
               stBahn11,stBahn12,stBahn13,stBahn14,stBahn15,stBahn16,
               stKein);          //

  TWertungMode      = (wgStandWrtg,wgSondWrtg,wgSerWrtg,wgMschPktWrtg);//Reihenfolge in TlnErg fest
  TKlassenWertung   = (kwAlle,kwSex,kwAltKl,kwSondKl,kwKein);//Reihenfolge in TlnErg fest, kwSex auch MixedMsch
  TDefaultAkListe   = (alTria,alDTU,alDLV);
  TMschWertung      = (mwKein,mwEinzel,mwMulti);
  TMschWrtgMode     = (wmTlnZeit,wmTlnPlatz,wmSchultour);
  TStartMode        = (stOhnePause,stMassenStart,stJagdStart);
  TWettkArt         = (waEinzel,waMschStaffel,waMschTeam,
                       waInt3, // Dummy: fr�her waMschSchopfheim,waMschSigmaringen
                       waInt4, // Dummy: fr�her waMschSigmaringen
                       waTlnStaffel,waRndRennen,waStndRennen,waTlnTeam); // als Integer gespeichert
  TPflichtWkMode    = (pw0,pw1,pw1v2,pw2);
  TSerWrtgMode      = (swRngUpPkt,swRngUpEqPkt,swRngDwnPkt,swRngDwnEqPkt,swFlexPkt,swZeit);
  TWkAbschnitt      = (wkAbs0,wkAbs1,wkAbs2,wkAbs3,wkAbs4, // wkAbs0 f�r eins zu eins Integer-Umwandlung
                       wkAbs5,wkAbs6,wkAbs7,wkAbs8);       // und GesamtWrtg
  //TZeichenSatz      = (cnASCII,cnANSI,cnHTML);
  TImpTlnMode       = (imTlnNeu,imTlnWahl);
  TImpOption        = (ioTrue,ioFalse,ioFehler);
  TTriDateiFormat   = (ftTria,ftText,ftHTML,ftExcel,ftPDF,ftKein);
  TImpDateiFormat   = (ifTria,ifText,ifExcel,ifKein);
  TTrzDateiFormat   = (fzTriaZeit,fzTCBacknang,fzZerf,
                       fzGis,fzSportronic,fzDAG,fzMandigo,
                       fzSonstig);
  TZEFehler         =  // Reihenfolge beim sortieren beachten
                      (zeKeinFehler,zeZeitEingelesen,zeItemLeer,zeZeitFehlt,zeSnrFehlt,
                       zeTlnUnbekannt,zeSGrpUnbekannt,zeNichtInWettk,
                       zeRundenUeberlauf,zeItemDoppelt,zeZeitFilter);
  TZeitFormat       = (zfSek,zfZehntel,zfHundertstel); // 2008-2.0
  TMschSortWertung  = (swMschAlle,swMschGewertet);
  TMannschSortmode  = (smOhneTlnColl,smMitTlnColl);
  TTlnTxtSpalte     = (tsOhneTlnTxtSpalte,tsMitTlnTxtSpalte);
  TOrtAdd           = (oaNoAdd,oaAdd);
  TTimerModus       = (zmStop,zmStart,zmRun,zmUhrZeit); // TriaZeit

  TStepProgressBar  = (pbMitStepping,pbOhneStepping);

  TUpdateModus      = (umManuell,umAuto);

  TLookUpGridMode   = (lmShowAll, lmShowEdit, lmFocusEdit);
  TTlnMsch          = (tmTln,tmMsch);
  TEinteilungMode   = (emEinteilen,emLoeschen);
  TSuchErsetzModus  = (seSuchen,seErsetzen);
  TSuchModus        = (smSuchen,smErsetzen,smAlleErsetzen);
  TZeitGleich       = (zgGleichOk,zgGleichNok); // TriaZeit
  TSMldLoeschen     = (smEinzel,smAlle);
  TZahlFormat       = (zfKein,zfDez,zfHex);

(******************** Konstanten **********************************************)

const
  cnDateiNeu             = 'Neu.tri';
  cnEnvDateiName         = 'Tria.env';
  cnKein                 = '<kein>';
  cnDummyName            = '   ';
  cnWettkAlleName        = 'Alle Wettk�mpfe';

  // Zeiten in 32 bit LongInt, Integer: MAX = 2.147.483.647 (10 Stellen)
  // Max Zeiten in 1/100:
  // Endzeit Tln:  8x24x360000 + 59x6000+5900 = 69.479.900 (8 Stellen) = 193:nn:nn.dd
  // Endzeit Msch: 16 x Tln-Max = 1.111.678.400 (10 Stellen) = 3.087:nn:nn.dd  1/100 sek
  // SerWrtg Tln:  20 x Tln-Max = 1.389.598.000 (10 Stellen) = 3.859:nn:nn.dd  1/100 sek
  //                               13.895.980   (8 Stellen) in Sek
  // SerWrtg Msch: 16 x Tln-SerWrtg-Max = 22.233.568.000 (11 Stellen) ==> Integer-�berlauf ==> Int64
  //                                      222.335.680  (9 Stellen) in Sek
  // bei Berechnung und Sortierung �berlauf vermeiden, nur Anzeige beschr�nken
  //cnZeitMaxInt           = 2000000000; // Max Einzel-Zeit f�r Integer-Sortieren
  cnZeitStrUeberlauf     = 360000000;  // 1.000:00:00.00 => max 3 Stunden-Zeichen anzeigen (9 Stellen)
  cnTlnSerOrtZeitMax     = 69480000;   // 193:00:00.00 > 69.479.900, in 1/100 Sek
  cnMschSerOrtZeitMax    = 1200000000; // > 1.111.678.400 in 1/100 Sek
  cnZeit24_00            = 8640000;    //  24:00:00.00  = max Tln-Abschn-Zeit, max Uhrzeit + 1  in 1/100
  cnZeit_1Std            = 360000;     //  1:00:00.00   = 1 Stunde in 1/100
  cnZeit_1Min            = 6000;       //  0:01:00.00   = 1 Min in 1/100
  cnZeitNullStr          = '       -';
  cnZeitFehlerStr        = 'xx:xx:xx';
  cnGiSDoppelZeit        = 6000; // 60 Sek Sperre gegen Doppel-Eintr�ge (14 Sek max gesehen)
                                 // DoppelZeiten von 2 Tln k�nnen gemischt vorkommen
  cnReportFieldLengthMax = 25;
  cnUrkMax               = 99;
  cnKopienMax            = 999;
  cnSeiteMax             = 999;
  cnDisqGrundMax         = 9999;
  cnDisqGrundDummy       = ' '; // Disqualifiziert ohne Grund
  cnDisqNameDefault      = 'disq';

  cnAlterMax             = 99;
  cnAlterMin             = 01;
  cnJahrMin              = 2000; //G�ltigkeitsbereich f�r Wettk.Datum
  cnJahrMax              = 2099; //G�ltigkeitsbereich f�r Wettk.Datum

  cnStrtBahnMax          = 16;
  cnSchwDistMax          = 30;
  cnRundenMax            = 9999; // 2008-2.0. > 1000 f�r 24h-Lauf
  cnRundLaengeMin        = 1;
  cnRundLaengeMax        = 99999; // 100km-1
  cnRundLaengeDefault    = 400; // 400 m
  cnStreckeMax           = 999999; // 1000km-1
  cnTlnMax               = 9999;
  cnMschMax              = cnTlnMax;
  cnMschGrDefault        = 3;
  cnMschGrMin            = 2;
  cnMschGrMax            = 16;
  cnMschGrMaxKompakt     = 8;
  cnMschGrMaxStart       = 32; // f�r Seriendruckfelder MschStartListe
  cnMschPktMax           = cnTlnMax;
  cnWettkMax             = 16;
  cnSGrpMax              = cnTlnMax; (* erh�ht f�r Team-Tria *)
  cnSMldMax              = cnTlnMax;
  cnMinCollSize          = 8;
  cnAbsZahlMax           = Integer(wkAbs8);

  // Tln-Options allgemein (als Bit in einem 16-bit SmallInt gespeichert)
  opSex              = 1;  // ab 2008-1.5: als Integer gespeichert(cnKeinSex erlaubt)
  opSerienWrtg       = 2;
  //opAusserKonkAllg   = 4;
  opMschWrtg         = 8;
  //opAusserKonkAltKl  = 16;
  //opAusserKonkSondKl = 32;
  opMschMixWrtg       = 64;
  // Tln-Options pro Ort (als Bit in einem SmallInt gespeichert)
  opSondWrtg         = 1;
  opUrkDruck         = 2;
  opAusKonkAllg      = 4;  // ab 2008-2.0 pro Ort, Wert beibehalten f�r Load
  opAusKonkAltKl     = 16; // ab 2008-2.0 pro Ort, Wert beibehalten f�r Load
  opAusKonkSondKl    = 32; // ab 2008-2.0 pro Ort, Wert beibehalten f�r Load

  // Serie
  seOrtMax          = 20;
  seOrtMin          = 2;
  seSerPktMax       = (cnTlnMax+1)*seOrtMax + 1; //200.001 (6-stellig), f�r Sortieren bei Serienwertung
  seTlnMaxRngDef    = 999; // f�r DefaultListe in SerWrtgDlg
  seMschMaxRngDef   = 99;

  
  cnSizeOfByte     = 1;
  cnSizeOfSmallInt = 2;
  cnSizeOfLongInt  = 4;
  cnSizeOfWord     = 2;
  cnSizeOfInteger  = 4;
  cnSizeOfBoolean  = 1;
  cnSizeOfPointer  = 4;
  cnSizeOfString   = 256;

  // Registry
  //rgRootKey = 'HKEY_CURRENT_USER';
  //rgKey     = '\Software\Tria\';
  //rgPath    = '\Software\Tria\'+cnProgName+' '+cnVersionsJahr;

  // Ini Datei
  iiLayout          = 'Layout';
  iiState           = 'WindowState';
  iiTop             = 'Top';
  iiLeft            = 'Left';
  iiHeight          = 'Height';
  iiWidth           = 'Width';
  iiOptions         = 'Options';
  iiAutoUpdate      = 'AutoUpdate';
  iiUpdateDatum     = 'UpdateDatum';
  iiMruDateiOeffnen = 'MruDatei oeffnen';
  iiAutoSpeichern   = 'AutoSpeichern';
  iiBackupErstellen = 'Backup erstellen';
  iiAutoBerechnen   = 'Automatisch berechnen';
  iiSofortRechnen   = 'Sofort berechnen';
  iiDefaultSex      = 'Default Geschlecht';
  iiZeitFormat      = 'ZeitFormat';
  iiZeitGleich      = 'ZeitGleich';  // triaZeit
  iiZeitFilter      = 'ZeitErfassungsfilter';
  iiRfidModus       = 'RFID-Modus';
  iiRfidTrennung    = 'RFID-Trennung';
  iiRfidZeichen     = 'RFID-Nr';
  iiRfidHex         = 'RFID-Hex';
  iiRfidDat         = 'RFID-Import';
  iiRfidDatName     = 'RFID-Datei';
  iiRfidDatExt      = 'RFID-DatExt';
  iiRfidDatFilter   = 'RFIDDat-Filter';
  iiRfidDatHeader   = 'RFIDDat-Header';
  iiRfidDatLoeschen = 'RFIDDat-Loeschen';
  iiRfidDatTrennung = 'RFIDDat-Trennung';
  iiRfidDatSnrPos   = 'RFIDDat-SnrPos';
  iiRfidDatRfidPos  = 'RFIDDat-RfidPos';
  iiDecTrennzeichen = 'Trennzeichen';
  iiMruListe        = 'MRU DateiListe';
  iiZtErfDatListe   = 'Zeiten-Dateiliste';
  iiUrkDokListe     = 'Urkunde-Dateiliste';
  iiWordUrkunde     = 'Word-Urkunde';
  iiWordUrkAkIndx   = 'UrkKlasse';
  iiSuchDialog      = 'SuchDialog';
  iiGrossKlein      = 'GrossKlein';
  iiGanz            = 'Ganz';
  iiStartStr        = 'StartStr';
  iiBestaetigen     = 'Bestaetigen';
  iiSuchListe       = 'Suchliste';
  iiErsatzListe     = 'Ersatzliste';
  iiSuchSpalte      = 'SuchSpalte';
  iiDrucker         = 'Drucker';
  iiDruckerName     = 'Druckername';
  //iiDuplexMode      = 'DuplexMode';
  //iiDruckerMode     = 'Druckermode';
  iiImpFeldListe    = 'MRU Importfeldnamen';
  iiSnrUeberlapp    = 'Snr�berlapp zulassen';
  iiSortierung      = 'Sortierung';
  iiStoppUhr        = 'Stoppuhr'; // nur zur �bernahme aus alter Ini-Datei
  iiTimermodus      = 'Timermodus';
  iiStartzeit       = 'Startzeit';
  iiSerie           = 'Serie';
  iiOrtIndex        = 'OrtIndex';
  iiZtErf           = 'ZeitErfassung';
  iiZtErfDatFormat  = 'DateiFormat';
  iiTriaZeit        = 'TriaZeit';
  iiTCBacknang      = 'TCBacknang';
  iiZerf            = 'Zerf';
  iiGis             = 'Gis';
  iiSportronic      = 'Sportronic';
  iiDAG             = 'DAG-System';
  iiMandigo         = 'Mandigo';
  iiSonstig         = 'Sonstige';
  iiBeepSignal      = 'BeepSignal';
  iiSpalteZahl      = 'SpalteZahl';
  iiRndCheckZahl    = 'RndCheckZahl';
  iiSpalteTln       = 'SpalteTln';
  iiKopierDatei     = 'KopierDatei';
  iiStartlisteDatei = 'StartlisteDatei';
  iiZeitenBehalten  = 'ZeitenBehalten';
  iiZtErfHeader     = 'ZtErfHeader';
  iiZtErfSnrPos     = 'ZtErfSnrStart';
  iiZtErfZeitPos    = 'ZtErfZeitStart';
  iiZtErfFormat     = 'ZtErfFormat';
  iiZtErfTrennung   = 'ZtErfTrennung';
  iiZtErfZeitTrenn  = 'ZtErfZeitTrenn';

  // Optionen
  opMruDateiOeffnenTri  = true;
  opMruDateiOeffnenTrz  = false;
  opBackupErstellenTri  = true;
  opBackupErstellenTrz  = false;
  opAutoSpeichernTri    = 0; // Disabled
  cnAutoSpeichernTriInitWert = 10; // 10 Min
  cnAutoSpeichernTriMax      = 99; // 99 Min
  opAutoSpeichernTrz    = 1;       // 1 Sek.
  cnAutoSpeichernTrzMax = 99;      // 99 Sek
  opSofortRechnen       = true;
  opDefaultSex          = false;
  opSexMaennlich        = 'm�nnlich';
  opSexWeiblich         = 'weiblich';
  opZeitSek             = 'Sekunden';
  opZeitZehntel         = 'Zehntel';
  opZeitHundertstel     = 'Hundertstel';
  opZeitGleichOk        = 'ZeitGleichOk';
  opZeitGleichNok       = 'ZeitGleichNok';
  opDecTrennZeichen     = ',';
  opStoppUhr            = false; // nur zur �bernahme aus alter Ini-Datei
  opDefaultZeitFilter   = -1; //6000; // 1 Min.
  cnRfidZeichenMin      = 1;
  cnRfidZeichenMax      = 24;
  cnRfidZeichenDefault  = 24;
  cnRfidHexDefault      = false;
  opAutoUpdate          = true;
  opUpdateDatum         = '';
  opSnrUeberlapp        = false;
  opBeepSignal          = false;
  opStop                = 'Stopp';
  opStart               = 'Start';
  opRun                 = 'Run';
  opUhrZeit             = 'Uhrzeit';
  opStartzeit           = '';

  // Auswahl-Listen Limits
  cnMruMaxCount         = 8;
  cnZtErfDatListeMax    = 8;
  cnUrkDokListeMax      = 8; // mit cnNeu am Anfang
  cnSuchListeMax        = 8;

  // Exportdateien
  cnExportExtraSpalten = 3;

  // Import
  cnPflichtFelder = 2;   // die ersten 2 Datenfelder: Name und Vorname
  cnTextFelderMax = 100; // maximum sollte nie erreicht werden
  cnKopfzeilenMax = 10;  // f�r Import Excel- und Textdateien

  // ProgName
  cnTriProg = 'Tria'; // auch f�r Ini-Datei - Directory
  cnTrzProg = 'TriaZeit';

  // Pad-File
  cnHomePage    = 'http://www.selten.de'; // immer ohne SSL, wird auf Website umgeleitet auf https://
  cnTriPadDatei = 'pad_file.xml';
  cnTrzPadDatei = 'trz_pad.xml';

  // ProgressBar
  cnProgressBarMax  = 100; // Max, Steps 1%

  // Timer
  cnTrzTimerInterval   = 5;   // Zeitinterval in mSek (2x pro 10 mSek)
  cnTriTimerInterval   = 200; // 0,2 Sek
  cnLiveZtErfInterval  = 800; // 0,8 Sek
  cnLiveZtErfFehlerMax = 3;
  // TriaZeit: Snr abgleichen
  cnZeitFenster = 6000; // 60 Sek in 1/100

  // Tln einteilen
  cnTlnProBahnDefault = 6;

  // BPObjTypes (DOS-Version: Stream Registration Records)
  rrVersion            = 150;
  rrAkObj              = 151;
  rrAkColl             = 152;
  rrIntSortCollection  = 160; //2008-2.0
  rrZeitSortColl       = 161; //2008-2.0
  rrRndZeitColl        = 162; //2008-2.0
  rrZeitErfColl        = 163; //2008-2.0
  rrWettkObj           = 177;
  rrWettkColl          = 178;
  rrSGrpColl           = 179;
  rrTlnObj             = 180;
  rrTlnColl            = 181;
  rrSMldObj            = 182;
  rrSMldColl           = 183;
  rrTextCollection     = 184;
  rrTriaPointerColl    = 185;
  rrSmallIntCollection = 185; // identisch
  rrWordCollection     = 186;
  rrBoolCollection     = 187;
  rrSGrpObj            = 188;
  rrIntegerCollection  = 189;
  rrMannschNameColl    = 190;
  rrMannschTlnListe    = 191;
  rrMannschObj         = 192;
  rrMannschColl        = 193;
  rrVeranstObj         = 194;
  rrOrtObj             = 195;
  rrOrtColl            = 196;
  rrCupWrtgColl        = 197;

  
type
  TAbsZeitArr  = array [wkAbs1..wkAbs8] of Integer;

(********************* Variabelen Deklarationen *****************************)

var TlnGeladen            : Word;
    CursorAlt             : TCursor;

    // Reports
    ReportMode            : TReportMode;
    ListeFormat           : string[132];
    ReportSeiteVon        : Integer;
    ReportSeiteBis        : Integer;
    ReportAnzahlKopien    : Integer;
    ReportKopienSortieren : Boolean;
    ReportWkListe         : TList;
    ReportNewWkPage       : Boolean;
    ReportAkListe         : TList;
    ReportAlleKlassen     : Boolean;
    ReportNewAkPage       : Boolean;
    ReportRngVon          : Integer;
    ReportRngBis          : Integer;
    //ReportSnrVon          : Integer;
    //ReportSnrBis          : Integer;
    ReportTlnSpalte       : TTlnTxtSpalte;
    ExportDatFormat       : TTriDateiFormat;
    ExportDateiName       : String;
    ExportDateiAnsehen    : Boolean;
    ExportProgGestartet   : Boolean;
    SerDrDateiAnsehen     : Boolean;
    TZ                    : Char; // TrennZeichen
    DefaultDrucker,
    ReportDrucker         : String;

    // Ergebnisse Berechnen
    Rechnen               : Boolean;

    // AutoSpeichern
    AutoSpeichernRequest  : Boolean;
    ZeitAktuell,
    ZeitDatGespeichert, 
    ZtErfDatAktZeit,
    ZtErfDatGelesen       : DWord; // Zeit in mSek. ab Systemstart
    LiveZtErfRequest      : Boolean;
    LiveZtErfFehler       : Integer = 0;
    MenueCommandActive    : Boolean;

    // Optionen
    AutoUpdate            : Boolean;
    UpdateDatum           : String;
    MruDateiOeffnen       : Boolean;
    BackupErstellen       : Boolean;
    SofortRechnen         : Boolean;
    DefaultSex            : TSex;
    ZeitFormat            : TZeitFormat;
    ZeitGleich            : TZeitGleich; // TriaZeit
    DecTrennZeichen       : String;
    TimerModus            : TTimerModus; // TriaZeit
    ZeitFilter            : Integer;
    RfidModus             : Boolean;
    RfidZeichen           : Integer;
    RfidHex               : Boolean = true;
    RfidDatName           : String;
    RfidDatExt            : String = '.txt';
    RfidDatFilter         : Integer;
    RfidDatHeader         : Boolean = false;
    RfidDatTrennung       : String = ';';
    RfidDatLoeschen       : Boolean = false;
    RfidDatSnrPos         : Integer = 1;
    RfidDatRfidPos        : Integer = 2;
    SnrUeberlapp          : Boolean;
    BeepSignal            : Boolean;
    SpalteZahl            : Boolean;
    RndCheckZahl          : Integer;
    SpalteTln             : Boolean;

    ZtEinlReport_Index    : Integer = 1;
    //ZtEinlDir             : String = '';
    ImportDir             : String = '';
    SetupGestartet        : Boolean;
    ImpTextErkZeichen     : String = cnKein;

    SerieOrtIndex         : Integer;  // in Ini-Datei speichern statt in Datei
    ZtErfDateiFormat      : TTrzDateiFormat; // ab 2008-1.6 in Ini-Datei
    ZtErfHeader           : Boolean = false;
    ZtErfFormat           : TZeitFormat = zfSek; // (zfSek,zfZehntel,zfHundertstel)
    ZtErfSnrPos           : Integer = 1;
    ZtErfZeitPos          : Integer = 6;
    ZtErfTrennung         : String = ';';
    ZtErfZeitTrenn        : String = ':';
    ZeitErfDateiListe     : TStringList;
    SuchSpalteBuf         : String = 'Name';

    UrkDokListe           : TStringList;
    WordUrkAkIndx         : Integer;

    ZeitenBehalten        : Boolean;
    //UrkDokDir             : String = '';

    TlnPageBuf            : Integer = -1;
    KeinSexAkzeptiertAll  : Boolean = false; // auch in TriDatNeu false setzen
    KeinJgAkzeptiertAll   : Boolean = false; // auch in TriDatNeu false setzen

    HelpDateiVerfuegbar   : Boolean;

type

  TMruImpFeldRec = record
    FeldType : TColType;
    Runde    : Integer;  // 2008-2.0
    FeldName : String;
  end;

var MruImpFeldArr : array of TMruImpFeldRec; //2008-1.5: dynamisch, TMruImpFeldRec

function TriDateiExt(Format:TTriDateiFormat): String;
function TriExtFilter(Format:TTriDateiFormat): String;
function ImpExtFilter(Format:TImpDateiFormat): String;
function TriDateiFormat(Ext:String): TTriDateiFormat;
function ImpDateiFormat(Ext:String): TImpDateiFormat;
//function TrzDateiFormat(Ext:String): TTrzDateiFormat;
function TrzDateiExt(Format:TTrzDateiFormat): String;

implementation

//******************************************************************************
function TriDateiExt(Format:TTriDateiFormat): String;
//*****************************************************************************+
begin
  case Format of
    ftTria       : Result := '.tri';
    ftHTML       : Result := '.htm';
    ftExcel      : Result := '.xls';
    ftText       : Result := '.txt';
    else Result := '';
  end;
end;

//******************************************************************************
function TriExtFilter(Format:TTriDateiFormat): String;
//*****************************************************************************+
begin
  case Format of
    ftTria       : Result := '*.tri';
    ftHTML       : Result := '*.htm';
    ftExcel      : Result := '*.xls;*.xlsx';
    ftText       : Result := '*.txt';
    else Result := '';
  end;
end;

//******************************************************************************
function ImpExtFilter(Format:TImpDateiFormat): String;
//*****************************************************************************+
begin
  case Format of
    ifTria       : Result := '*.tri';
    ifExcel      : Result := '*.xls;*.xlsx';
    ifText       : Result := '*.txt;*.csv';
    else Result := '';
  end;
end;

//******************************************************************************
function TrzDateiExt(Format:TTrzDateiFormat): String;
//*****************************************************************************+
begin
  case Format of
    fzTriaZeit   : Result := '.trz';
    fzTCBacknang : Result := '.dbf';
    //fzMikaTiming : Result := '.ttx';
    fzZerf       : Result := '.zrf';
    fzGis        : Result := '.gtz';
    fzSportronic : Result := '.txt';
    fzDAG        : Result := '.dag';
    fzMandigo    : Result := '.txt';
    else Result := '';
  end;
end;

//******************************************************************************
function TriDateiFormat(Ext:String): TTriDateiFormat;
//*****************************************************************************+
// ohne PDF
// Vergleich ohne Ber�cksichtigung der Gro�-/Kleinschreibung
begin
  if SameText(Trim(Ext),'.tri') then Result := ftTria
  else if SameText(Trim(Ext),'.htm') then Result := ftHTML
  else if SameText(Trim(Ext),'.xls') or
          SameText(Trim(Ext),'.xlsx') then Result := ftExcel
  else if SameText(Trim(Ext),'.txt') then Result := ftText
  else Result := ftKein;
end;

//******************************************************************************
function ImpDateiFormat(Ext:String): TImpDateiFormat;
//*****************************************************************************+
// ohne PDF
begin
  if SameText(Trim(Ext),'.tri') then Result := ifTria
  else if SameText(Trim(Ext),'.xls') or
          SameText(Trim(Ext),'.xlsx') then Result := ifExcel
  else if SameText(Trim(Ext),'.txt') or
          SameText(Trim(Ext),'.csv') then Result := ifText
  else Result := ifKein;
end;

{//******************************************************************************
function TrzDateiFormat(Ext:String): TTrzDateiFormat;
//*****************************************************************************+
// fzTriaZeit,fzTCBacknang,fzZerf,fzGis,fzSportronic,fzDAG,fzMandigo,fzKein
// auch Gro�buchstaben zulassen
// fzMandigo wird zun�chst als fzSportronic erkannt, weil Ext gleich ist.
// Muss sp�ter unterschieden werden.
begin
  for Result:=fzTriaZeit to TTrzDateiFormat(Integer(fzKein)-1) do
    if SameText(Trim(Ext),TrzDateiExt(Result)) then Exit;
  Result := fzKein;
end;}


end.


