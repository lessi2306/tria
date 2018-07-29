unit ImpDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls, StrUtils, Math,
  ExcelXP{Excel2000}, OleServer,
  AllgComp,AllgConst,AllgFunc,AllgObj,SGrpObj,WettkObj, ExtCtrls;

procedure ImportiereDatei(Format:TImpDateiFormat);

// Allgemein

type

  TImpFeldRec = record
    FeldType : TColType;
    Runde    : Integer;
    Spalte   : Integer;
  end;

  TImportDialog = class(TForm)
    ExcelApplication: TExcelApplication;
    ExcelWorkSheet: TExcelWorksheet;
    ExcelWorkbook: TExcelWorkbook;
    FeldValueListEditor: TValueListEditor;
    FeldLabel: TLabel;
    PflichtfeldLabel: TLabel;
    VorschauGrid: TStringGrid;
    VorschauLabel: TLabel;
    PruefButton: TButton;
    ImportButton: TButton;
    CancelButton: TButton;
    HilfeButton: TButton;
    ExcelSheetCB: TComboBox;
    ImpDateiEdit: TTriaEdit;
    ImpDateiLabel: TLabel;
    ExcelSheetLabel: TLabel;
    TextErkZeichenCB: TComboBox;
    TextErkZeichenLabel: TLabel;
    TrennzeichenRG: TRadioGroup;
    SonstEdit: TTriaEdit;
    procedure ExcelSheetCBChange(Sender: TObject);
    procedure TextErkZeichenCBChange(Sender: TObject);
    procedure FeldValueListEditorStringsChange(Sender: TObject);
    procedure FeldValueListEditorClick(Sender: TObject);
    procedure VorschauGridClick(Sender: TObject);
    procedure PruefButtonClick(Sender: TObject);
    procedure ImportButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure HilfeButtonClick(Sender: TObject);
    procedure TrennzeichenRGClick(Sender: TObject);
  private
    HelpFensterAlt    : TWinControl;
    Updating          : Boolean;
    TextDatei         : Textfile; // zu importierende TextDatei
    TextZeilenColl    : TStrings; // eingelesen Zeilen (komplett)
    TrennZeichen      : Char;     // Trennzeichen in Textdatei
    TlnUeberschreiben : Boolean;
    TlnAlleUeberschreiben : Boolean;
    procedure ClearOptionStrings;
    procedure SetzeTrennZeichen;
    procedure TxtInitDatenArray(Step:Boolean);
    procedure InitFeldValueListEditor;
    function  GetDatenArrayIndex(ImpFeldIndex:Integer): Integer;
    procedure UpdateVorschau(Step:Boolean);
    function  GetSGrp(Snr:Integer): TSGrpObj;
    function  SnrDoppel(Snr,Zeile,Spalte:Integer): Boolean;
    function  TlnDoppel(Name,VName,Verein,MannschName:String; Zeile:Integer):Boolean;
    function  GetOption(Feld:TColType; S:String): TImpOption;
    function  GetSexOption(S:String): TSex;
    function  PruefeDaten: Integer;
    function  ImportiereDaten: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    TextDateiLaden: Boolean;
    procedure   OpenExcel;
    procedure   CloseExcel;
    function    ExcelDateiLaden: Boolean;
    function    ExcelSheetLaden: Boolean;
    function    GetFeldNameLang(Feld:TColType): String; overload;
    function    GetFeldNameLang(Feld:TColType;Rnd:Integer): String; overload;
    function    GetFeldNameLang(Feld:TImpFeldRec): String; overload;
    function    GetFeldNameKey(Feld:TColType): String; overload;
    function    GetFeldNameKey(Feld:TColType;Rnd:Integer): String; overload;
    function    GetImpSpalte(Feld:TColType): Integer; overload;
    function    GetImpSpalte(Feld:TColType;Rnd:Integer): Integer; overload;
    function    GetFeldStr(Feld:TColType; ImpOption:TImpOption):String;
    procedure   SetFeldStr(Feld:TColType; ImpOption:TImpOption; S:String);
    function    GetFeldStrValid(Feld:TColType; ImpOption:TImpOption):Boolean;
    procedure   SetFeldStrValid(Feld:TColType; ImpOption:TImpOption; B:Boolean);
    function    DefaultFeldStr(Feld:TColType; ImpOption:TImpOption; S:String):Boolean;
    function    GetSexStr(Sx:TSex):String;
    procedure   SetSexStr(Sx:TSex; S:String);
    function    GetSexStrValid(Sx:TSex):Boolean;
    procedure   SetSexStrValid(Sx:TSex; B:Boolean);
    function    DefaultSexStr(Sx:TSex; S:String):Boolean;
  end;

var ImportDialog: TImportDialog;
    ImpFeldArr : array of TImpFeldRec;//alle in Tria Imp-/Exportierbaren Feldnamen

procedure InitImpFeldArr(RepWk:TWettkObj; Mode:TListMode; MaxRnd:Integer);
function  GetFeldNameKurz(Feld:TColType): String; overload;
function  GetFeldNameKurz(Feld:TColType;Rnd:Integer): String; overload;
function  GetMruFeldName(Feld:TColType;Rnd:Integer): String;


implementation

uses TriaMain,VeranObj,AkObj,TlnObj,ImpFrm,ImpFeldDlg,TlnErg,ListFmt,DateiDlg,
     VistaFix,ImpSexDlg;

{$R *.dfm}

var
  ImportFormat : TImpDateiFormat;
  DatenArray   : array of array of String;//1.Index=Zeile,2.Index=Feld/Spalte
  DatenOk      : Boolean;

  SexMStr,SexWStr,SexXStr,SexKStr,
  MschWrtgTStr,MschWrtgFStr,
  MschMixWrtgTStr,MschMixWrtgFStr,
  SondWrtgTStr,SondWrtgFStr,
  SerWrtgTStr,SerWrtgFStr,
  UrkTStr,UrkFStr,
  AuKonkAllgTStr,AuKonkAllgFStr,
  AuKonkAltKlTStr,AuKonkAltKlFStr,
  AuKonkSondKlTStr,AuKonkSondKlFStr : String;

  SexMStrValid,SexWStrValid,SexXStrValid,SexKStrValid,
  MschWrtgTStrValid,MschWrtgFStrValid,
  MschMixWrtgTStrValid,MschMixWrtgFStrValid,
  SondWrtgTStrValid,SondWrtgFStrValid,
  SerWrtgTStrValid,SerWrtgFStrValid,
  UrkTStrValid,UrkFStrValid,
  AuKonkAllgTStrValid,AuKonkAllgFStrValid,
  AuKonkAltKlTStrValid,AuKonkAltKlFStrValid,
  AuKonkSondKlTStrValid,AuKonkSondKlFStrValid : Boolean;

  ExcelGestartet : Boolean;
  FLCID          : Integer;

(******************************************************************************)
procedure ImportiereDatei(Format:TImpDateiFormat);
(******************************************************************************)
begin
  case Format of
    ifText,ifExcel: ImportFormat := Format;
    else Exit;
  end;
  ExcelGestartet := false;
  HauptFenster.InitAnsicht(Veranstaltung.Ort,anAnmEinzel,smTlnName,
                           HauptFenster.SortWettk,wgStandWrtg,cnSexBeide,AkAlle,
                           stGemeldet);
  ImportDialog := TImportDialog.Create(HauptFenster);
  try
    with ImportDialog do
    begin
      // Datei in DatenArray laden
      case ImportFormat of
        ifText  : if not TextDateiLaden then Exit;
        ifExcel : if not ExcelDateiLaden then Exit;
      end;
      // nach Laden Progressbar zu 2/3 voll
      // Progressbar.Max anpassen f�r nachfolgende Aktionen (1 step pro Datenfeld)
      HauptFenster.ProgressBarMaxUpdate(FeldValueListEditor.Strings.Count);
      // Dialog initialisieren
      // Trennzeichen in TextDateiLaden ermittelt
      Updating := true;
      case Trennzeichen of
        Char(VK_TAB) : TrennzeichenRG.ItemIndex := 1;
        ','          : TrennzeichenRG.ItemIndex := 2;
        ' '          : TrennzeichenRG.ItemIndex := 3;
        else {;}       TrennzeichenRG.ItemIndex := 0;
      end;
      InitFeldValueListEditor; // kein Stepping
      UpdateVorschau(true); // Step ProgressBar pro Datenfeld
      HauptFenster.StatusBarClear;
      Updating := false;
      // Dialog �ffnen
      ShowModal;
    end;
  finally
    if ExcelGestartet then ImportDialog.CloseExcel;
    FreeAndNil(ImportDialog);
    ImpFeldArr := nil;
    DatenArray := nil;
    HauptFenster.StatusBarClear;
    if Rechnen then BerechneRangAlleWettk;
  end;
end;

(******************************************************************************)
procedure InitImpFeldArr(RepWk:TWettkObj; Mode:TListMode; MaxRnd:Integer);
(******************************************************************************)
// nur f�r Wettk definierte Felder benutzen, gemeinsam f�r Import und Export
// nur f�r WettkAlleDummy alle Felder einf�gen (WettkAlleDummy nur bei Export)
// bei Import nach Laden der Datei, damit Spalten�berschriften bekannt sind
// MaxRnd nur f�r Import RundenWettk
var j,k,Rnd,C: Integer;
    Col : TColType;
//..............................................................................
function StaffelNameGueltig: Boolean;
var AbsCnt : TWkAbschnitt;
begin
  for AbsCnt:=wkAbs2 to wkAbs8 do
    if ((Col=TColType(Integer(spStaffelName2)+Integer(AbsCnt)-2)) or
        (Col=TColType(Integer(spStaffelVName2)+Integer(AbsCnt)-2))) and
       ((RepWk.WettkArt<>waTlnStaffel)or(RepWk.AbschnZahl<Integer(AbsCnt))) and
       ((RepWk.WettkArt<>waTlnTeam)or(RepWk.MschGroesseMax<Integer(AbsCnt))) then
    begin
      Result := false;
      Exit;
    end;
  Result := true;
end;
//..............................................................................
function AbsZahlGueltig: Boolean;
var AbsCnt : TWkAbschnitt;
begin
  for AbsCnt:=wkAbs2 to wkAbs8 do
    if (Col = TColType(Integer(spAbs2UhrZeit)+Integer(AbsCnt)-2)) and
       (RepWk.AbschnZahl < Integer(AbsCnt)) then
    begin
      Result := false;
      Exit;
    end;
  Result := true;
end;
//..............................................................................
function ColGueltig: Boolean;
begin
  Result :=
    (RepWk=WettkAlleDummy) or
    ((Col<>spLand) or (RepWk.TlnTxt<>''))                     and
    ((Col<>spRfid) or RfidModus)                              and
    ((Col<>spMschWrtg) or (RepWk.MschWertg<>mwKein))          and
    ((Col<>spMschMixWrtg) or (RepWk.MschWertg<>mwKein))       and
    ((Col<>spSerWrtg) or Veranstaltung.Serie)                 and
    ((Col<>spStZeit) or (Mode=lmExport) or RepWk.EinzelStart) and // Import nur bei Einzelstart
    StaffelNameGueltig                                        and
    AbsZahlGueltig                                            and
    ((Col<>spRestStrecke) or (RepWk.WettkArt=waStndRennen));
end;

//..............................................................................
begin
  j := -1;
  C :=  0;
  repeat
    case Mode of
      lmImport : Col := GetColType(ltTlnImport,WettkAlleDummy,C,lmImport);
      lmExport : Col := GetColType(ltMldLstTlnExp,WettkAlleDummy,C,lmExport);
      else Exit; // kommt nicht vor
    end;
    if (Col <> spLeer) and ColGueltig then
    begin
      Rnd := 1;
      if Col in [spAbs1UhrZeit..spAbs8UhrZeit] then
      begin
        if not RepWk.RundenWettk then
          Rnd := Max(1,RepWk.AbsMaxRunden[TWkAbschnitt(Integer(Col)-Integer(spAbs1UhrZeit)+1)])
        else
        case Mode of
          lmImport: // Max begrenzen auf Anzahl Spalten�berschriften in Importdatei
            Rnd := Max(1,MaxRnd);
          lmExport: // tats�chliche Rundenzahl
            Rnd := Max(1,Veranstaltung.TlnColl.RundenZahlMax(RepWk,TWkAbschnitt(Integer(Col)-Integer(spAbs1UhrZeit)+1)));
        end;
      end;
      for k:=1 to Rnd do
      begin
        Inc(j);
        SetLength(ImpFeldArr,j+1);
        with ImpFeldArr[j] do
        begin
          FeldType := Col;
          if Rnd > 1 then Runde := k
                     else Runde := 0; // Name ohne Rundenangabe
          Spalte := -1;
        end;
      end;
    end;
    Inc(C);
  until Col = spLeer;
end;

//******************************************************************************
function GetFeldNameKurz (Feld:TColType):String;
//******************************************************************************
begin
  Result := GetFeldNameKurz(Feld,0);
end;

//******************************************************************************
function GetFeldNameKurz(Feld:TColType;Rnd:Integer):String;
//******************************************************************************
// Runde nur f�r ifAbs1,2,3,4UhrZeit
// Anzeige in Result wenn Rnd >= 1
// wenn keine Runden definiert sind (Rundenzahl=1, dann Runde=0 angeben,
// damit Abschn-Name keine Rundenzahl enth�lt
begin
  case Feld of
    spName          : Result := 'Name';
    spVName         : Result := 'Vorname';
    spSex           : Result := 'Geschl.';
    spJg            : Result := 'Jahrg.';
    spVerein        : Result := 'Verein/Ort';
    spMannsch       : Result := 'Mannschaft';
    spStrasse       : Result := 'Stra�e';
    spEMail         : Result := 'E-Mail';
    spHausNr        : Result := 'Nr.';
    spPLZ           : Result := 'PLZ';
    spOrt           : Result := 'Ort';
    spLand          : if (HauptFenster.SortWettk <> nil) and (HauptFenster.SortWettk <> WettkAlleDummy) and
                         (HauptFenster.SortWettk.TlnTxt <> '') then
                        Result := HauptFenster.SortWettk.TlnTxt
                      else Result := 'Land';
    spMeldeZeit     : Result := 'MeldeZt';
    spStartgeld     : Result := 'StGeld';
    spRfid          : Result := 'RFID';
    spKomment       : Result := 'Kommentar';
    spMschWrtg      : Result := 'MaWg.';
    spMschMixWrtg   : Result := 'MxMa.';
    spSondWrtg      : Result := 'SoWg.';
    spSerWrtg       : Result := 'SeWg.';
    spUrkDr         : Result := 'Urk.';
    spAusKonkAllg   : Result := 'a.K.';
    spAusKonkAltKl  : Result := 'a.K.-AK';
    spAusKonkSondKl : Result := 'a.K.-SK';
    spStaffelName2..spStaffelName8:
      Result := 'Tln'+IntToStr(Integer(Feld)-Integer(spStaffelName2)+2)+'-Name';
    spStaffelVName2..spStaffelVName8:
      Result := 'Tln'+IntToStr(Integer(Feld)-Integer(spStaffelVName2)+2)+'-Vorname';
    spSnr           : Result := 'Startnr.';
    spRestStrecke   : Result := 'RestMtr';
    spStZeit        : Result := 'StZeit';
    spStBahn        : Result := 'Bahn';
    spAbs1UhrZeit..spAbs8UhrZeit:
      if Rnd > 0 then Result := 'Abschn.'+IntToStr(Integer(Feld)-Integer(spAbs1UhrZeit)+1)+'-'+IntToStr(Rnd)
                 else Result := 'Abschn.'+IntToStr(Integer(Feld)-Integer(spAbs1UhrZeit)+1);
    spTlnStrafZeit  : Result := 'Strafe';
    spGutschrift    : Result := 'Gutschr.';
    spDisqGrund     : Result := 'DisqGr.';
    spDisqName      : Result := 'DisqBez.';
    spWettk         : Result := 'Wettkampf';
    else Result := '';
  end;
end;

//******************************************************************************
function GetMruFeldName(Feld:TColType;Rnd:Integer): String;
//******************************************************************************
var i : Integer;
begin
  for i:=0 to Length(MruImpFeldArr) - 1 do
    with MruImpFeldArr[i] do
      if (FeldType = Feld) and (Runde=Rnd) then
      begin
        Result := FeldName;
        Exit;
      end;
  Result := cnKein;
end;


// public Methoden TImportDialog

(*============================================================================*)
constructor TImportDialog.Create(AOwner: TComponent);
(*============================================================================*)
begin
  inherited Create(AOwner);
  if not HelpDateiVerfuegbar then
  begin
    BorderIcons := [biSystemMenu];
    HilfeButton.Enabled := false;
  end;

  Updating := true;
  TlnUeberschreiben := false;
  TlnAlleUeberschreiben := false;
  TrennZeichen := ';';
  case ImportFormat of
    ifExcel:
    begin
      Caption := 'Import aus Excel-Datei';
      TrennZeichenRG.Visible := false;
      SonstEdit.Visible := false;
      TextErkZeichenCB.Visible := false;
      TextErkZeichenLabel.Visible := false;
      ExcelSheetLabel.Visible := true;
      ExcelSheetCB.Visible := true;
      ExcelSheetLabel.Top := ImpDateiLabel.Top;
      ExcelSheetCB.Top := ImpDateiEdit.Top;
    end;
    ifText:
    begin
      Caption := 'Import aus Textdatei';
      TrennZeichenRG.Visible := true;
      SonstEdit.Visible := true;
      TextErkZeichenCB.Visible := true;
      TextErkZeichenLabel.Visible := true;
      ExcelSheetLabel.Visible := false;
      ExcelSheetCB.Visible := false;
      TextZeilenColl := TStringList.Create;
      SonstEdit.MaxLength := 1;
    end;
    else ;
  end;
  ImpDateiEdit.Text := ExtractFileName(ImportDatei);

  with FeldValueListEditor do
  begin
    Canvas.Font := Font;
    DefaultRowHeight := 17;
    ColWidths[0] := Canvas.TextWidth(' Mannschaftswertung ');
    ColWidths[1] := ClientWidth - ColWidths[0] - 1;
  end;

  with VorschauGrid do
  begin
    Canvas.Font := Font;
    DefaultRowHeight := 17;
    Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
      goColSizing, goDrawFocusSelected, goThumbTracking];
  end;

  ClearOptionStrings;

  Updating := false;
  HelpFensterAlt := HelpFenster;
  HelpFenster := Self;
  SetzeFonts(Font);
  SetzeFonts(PflichtFeldLabel.Font);
end;

(*============================================================================*)
destructor TImportDialog.Destroy;
(*============================================================================*)
begin
  Updating := true; // wegen  StringsChange-Event
  FeldValueListEditor.Strings.Clear; // wegen Delphi 7 Bug
  if ImportFormat=ifText then TextZeilenColl.Free;
  HelpFenster := HelpFensterAlt;
  inherited Destroy;
end;

(*============================================================================*)
function TImportDialog.TextDateiLaden: Boolean;
(*============================================================================*)
var TextZeile : String;
    ZeichenFehler, MaxZahl,Leer : Boolean;
    FilePosAlt : Integer;

//..............................................................................
function PruefeZeichen(Zeile:String): Boolean;
// Textzeile pr�fen auf Steuerzeichen (ohne TAB) und ZeichenFehler setzen
var i : Integer;
begin
  Result := true;
  for i:=1 to Length(Zeile) do
    if (Zeile[i] < ' ') and (Zeile[i] <> #9) then
    begin
      ZeichenFehler := true;
      Result := false;
      Exit;
    end;
end;

//..............................................................................
begin
  Result := false;
  ZeichenFehler := false;
  MaxZahl       := false;
  Leer          := false;

  try
    // Textdatei in TextZeilenColl einlesen
    {$I-}
    AssignFile(TextDatei,ImportDatei);
    SetLineBreakStyle(TextDatei,tlbsCRLF); // nur beim Schreiben von Bedeutung
    Reset(TextDatei);
    if IoResult<>0 then Exit;

    if Eof(TextDatei) then
    begin
      Leer := true;
      Exit;
    end;

    // Progressbar nach Laden zu 1/3 voll
    HauptFenster.ProgressBarInit('Daten aus Textdatei  "'+ImportDatei+
                                 '"  werden eingelesen',FileSize(TextDatei)*3);
    FilePosAlt := 0;

    // Zeilen unver�ndert in TextZeilenColl einlesen, Leerzeilen ignorieren
    while not Eof(TextDatei) do
    begin
      if TextZeilenColl.Count >= cnTlnMax+1-Veranstaltung.TlnColl.Count then
      begin
        MaxZahl := true;
        Exit;
      end;
      ReadLn(TextDatei,TextZeile);
      if IoResult<>0 then Exit;
      if not PruefeZeichen(TextZeile) then Exit; // Zeichenfehler gesetzt
      if Length(TextZeile)>0 then TextZeilenColl.Add(TextZeile);
      HauptFenster.ProgressBarStep(FilePos(TextDatei) - FilePosAlt);
      FilePosAlt := FilePos(TextDatei);
    end;

    if TextZeilenColl.Count < 2 then Exit;
    SetzeTrennZeichen;

    // Progressbar bereits zu 1/3 voll, nach Init 2/3
    HauptFenster.ProgressBarMaxUpdate(TextZeilenColl.Count * 2);

    TxtInitDatenArray(true); // Step ProgressBar pro Zeile
    // Progressbar zu 2/3 voll

    Result := true;

  finally
    CloseFile(TextDatei);
    IoResult;
    {$I+}
    if not Result then
      if ZeichenFehler then
        TriaMessage(Self,'Die Datei  "'+ExtractFileName(ImportDatei)+
                    '"  ist keine g�ltige Textdatei.',
                     mtInformation,[mbOk])
      else
      if MaxZahl then
        TriaMessage(Self,'Beim Lesen der Textdatei  "'+ExtractFileName(ImportDatei)+
                    '"  wurde die maximale Teilnehmerzahl �berschritten.',
                     mtInformation,[mbOk])
      else
      if Leer then
        TriaMessage(Self,'Die Datei  "'+ExtractFileName(ImportDatei) + '"  enth�lt keine Daten.',
                    mtInformation,[mbOk])
      else
      if TextZeilenColl.Count = 0 then
        TriaMessage(Self,'Die Datei  "'+ExtractFileName(ImportDatei)+'"  enth�lt keine g�ltige Daten.',
                     mtInformation,[mbOk])
      else
      if TextZeilenColl.Count = 1 then
        TriaMessage(Self,'Die Datei  "'+ExtractFileName(ImportDatei)+'"  enth�lt nur eine Zeile mit Daten.',
                     mtInformation,[mbOk])
  end;
end;

//==============================================================================
procedure TImportDialog.OpenExcel;
//==============================================================================
begin
  try
    FLCID := GetUserDefaultLCID;
    ExcelApplication.ConnectKind := ckNewInstance; // sonst manchmal Probleme wenn Excel bereit gestartet
    ExcelApplication.Connect;
    ExcelApplication.Visible[FLCID] := false; // alte nicht richtig closed appl k�nnte sichtbar sein
    ExcelApplication.UserControl := false;    // False wenn Excel unsichtbar sein soll
    ExcelApplication.DisplayAlerts[FLCID] := False;
    ExcelApplication.AskToUpdateLinks[FLCID] := False;
  except
    TriaMessage(Self,'Microsoft Excel konnte nicht gestartet werden.',
                 mtInformation,[mbOk]);
    Exit;
  end;
  ExcelGestartet := true;
end;

//==============================================================================
procedure TImportDialog.CloseExcel;
//==============================================================================
begin
  try
    ExcelWorksheet.Disconnect;
    ExcelWorkbook.Disconnect;
    ExcelApplication.Quit;
    ExcelApplication.Disconnect;
  except
    // Meldung unterdr�cken ShowMessage('Exception beim Close');
  end;
end;

(*============================================================================*)
function TImportDialog.ExcelDateiLaden: Boolean;
(*============================================================================*)
// keine Leerzeilen erlaubt
// jede Spalte ben�tigt Feldname in 1. Zeile
//******************************************************************************
// Test:
// Sehr hilfreich ist es, die Formel in EXCEL zu formulieren und dann mit Delphi zu lesen:
{procedure TForm1.Button1Click(Sender: TObject);
var st:String;
begin
  st:=Excel.ActiveSheet.Cells[1,1].Formula;
  MessageDlg(st,mtInformation,[mbOk],0);
  Excel.ActiveSheet.Cells[2,1].Formula:=st; // Test
end;}
// Damit siehst Du sofort, wie's Excel will.
//******************************************************************************

var
  i : Integer;
begin
  Result := false;

  HauptFenster.ProgressBarInit('Microsoft Excel wird gestartet',6);
  // Progressbar zu 1/6 voll
  HauptFenster.ProgressBarStep(1);
  try
    with ImportDialog do
    begin
      OpenExcel;
      if not ExcelGestartet then Exit; // Fehlermeldung in OpenExcel

      HauptFenster.ProgressBarText('Daten aus Excel-Datei  "'+ImportDatei+
                                   '"  werden eingelesen');
      // Progressbar zu 1/3 voll
      HauptFenster.ProgressBarStep(1);

      ExcelApplication.Workbooks.Open(ImportDatei, EmptyParam, EmptyParam,
                                      EmptyParam, EmptyParam, EmptyParam,
                                      EmptyParam, EmptyParam, EmptyParam,
                                      EmptyParam, EmptyParam, EmptyParam,
                                      EmptyParam, EmptyParam, EmptyParam, FLCID);

      //Excel97.pas, Excel2000.pas - WorkBooks
      //function Open(const Filename: WideString; UpdateLinks: OleVariant; ReadOnly: OleVariant;
      //              Format: OleVariant; Password: OleVariant; WriteResPassword: OleVariant;
      //              IgnoreReadOnlyRecommended: OleVariant; Origin: OleVariant; Delimiter: OleVariant;
      //              Editable: OleVariant; Notify: OleVariant; Converter: OleVariant;
      //              AddToMru: OleVariant; lcid: Integer): ExcelWorkbook; safecall;

      //ExcelXP.pas - workbooks : 2 zus�tzliche Parameter
      //function Open(const Filename: WideString; UpdateLinks: OleVariant; ReadOnly: OleVariant;
      //              Format: OleVariant; Password: OleVariant; WriteResPassword: OleVariant;
      //              IgnoreReadOnlyRecommended: OleVariant; Origin: OleVariant; Delimiter: OleVariant;
      //              Editable: OleVariant; Notify: OleVariant; Converter: OleVariant;
      //              AddToMru: OleVariant; Local: OleVariant; CorruptLoad: OleVariant; lcid: Integer): ExcelWorkbook; safecall;
      //                                    ------------------ ------------------------

      ExcelWorkbook.ConnectTo(ExcelApplication.ActiveWorkBook);

      if ExcelWorkbook.Sheets.Count = 0 then
      begin
        TriaMessage(Self,'Die Excel-Datei  "'+ExtractFileName(ImportDatei)+'"  ist leer.',
                     mtInformation,[mbOk]);
        Exit;
      end;
      for i:=0 to ExcelWorkbook.Sheets.Count-1 do
        ExcelSheetCB.Items.Add((ExcelWorkbook.Sheets[i+1] as _WorkSheet).Name);
      ExcelSheetCB.ItemIndex := 0;

      ExcelWorkSheet.ConnectTo(ExcelWorkbook.Sheets[1] as _Worksheet); // immer 1. Seite probieren

      // Progressbar zu 1/2 voll
      HauptFenster.ProgressBarStep(1);
      if not ExcelSheetLaden and (ExcelWorkbook.Sheets.Count = 1) then
        Exit; // Abbruch, Dialog nicht ge�ffnet

      // Progressbar zu 2/3 voll
      HauptFenster.ProgressBarStep(1);
      Result := true;
    end;

  except
    if ExcelGestartet then
      TriaMessage(Self,'Fehler beim Lesen der Excel-Datei  "'
                  +ExtractFileName(ImportDatei)+'".',
                   mtInformation,[mbOk]);
  end;
end;

(*============================================================================*)
function TImportDialog.ExcelSheetLaden: Boolean;
(*============================================================================*)
// 2006: Progressbar:  1 Step pro Row
var
  S : String;
  i, j, KopfZeilen, ColZahl, DatenSpalten, LeerSpalten: Integer;
  LeerZeile, FeldNameFehlt : Boolean;

begin
  Result := false;
  SetLength(DatenArray,0,0);  // zuerst alte Daten l�schen
  try
    with ImportDialog do
    begin
      // 1. Zeile mit mindestens 2 (cnPflichtFelder) DatenfeldNamen suchen
      // max cnKopfzeilenMax (10) Leerzeilen oder Zeilen mit zu wenig Spalten zulassen
      KopfZeilen := 0;
      ColZahl := 0;
      FeldNameFehlt := false;
      while (KopfZeilen < cnKopfzeilenMax) and (KopfZeilen < ExcelWorkSheet.Cells.Rows.Count) do
      begin
        LeerSpalten := 0;
        FeldNameFehlt := false;
        ColZahl := 0;
        for j:=0 to ExcelWorkSheet.Cells.Columns.Count-1 do
        begin
          S := ExcelWorkSheet.Cells.Item[KopfZeilen+1,j+1];
          if S <> '' then // nur gef�llte FeldNamen auslesen
          begin
            Inc(ColZahl);
            SetLength(DatenArray,1,ColZahl);
            DatenArray[0,ColZahl-1] := S;
            if LeerSpalten > 0 then
            begin
              FeldNameFehlt := true; // nur LeerSpalten vor ZeilenEnde
              LeerSpalten := 0;
            end;
          end else
          if LeerSpalten >= 2 then // bei der 3. Leerspalte abbrechen
            Break
          else Inc(LeerSpalten);
        end;
        if ColZahl < cnPflichtFelder then Inc(KopfZeilen)
                                     else Break;
      end;

      // mindestens Header- und Datenzeile
      if KopfZeilen >= ExcelWorkSheet.Cells.Rows.Count - 2 then
      begin
        TriaMessage(Self,'In Tabellenblatt  "' + ExcelWorkSheet.Name +
                    '"  wurden keine g�ltigen Daten gefunden.' +#13+#13+
                    'Die Daten k�nnen nicht importiert werden.',
                    mtInformation,[mbOk]);
        SetLength(DatenArray,0,0);
        Exit;
      end;

      if KopfZeilen >= cnKopfzeilenMax then // erste 10 Zeilen nicht korrekt
      begin
        TriaMessage(Self,'In den ersten 10 Zeilen des Tabellenblattes  "' + ExcelWorkSheet.Name +
                    '"  wurden keine g�ltigen Daten gefunden.' +#13+#13+
                    'Die Daten k�nnen nicht importiert werden.',
                    mtInformation,[mbOk]);
        SetLength(DatenArray,0,0);
        Exit;
      end;

      // HeaderZeile mit mindestens 2 (cnPflichtFelder) Feldnamen gefunden
      if FeldNameFehlt then
      begin
        TriaMessage(Self,'In der �berschriftenzeile (Zeile ' + IntToStr(Kopfzeilen+1) + ', Tabellenblatt "' +
                    ExcelWorkSheet.Name + '") sind leere Feldnamen vorhanden.' +#13+#13+
                    'Die Daten k�nnen nicht importiert werden.',
                    mtInformation,[mbOk]);
        SetLength(DatenArray,0,0);
        Exit;
      end;

      // 1. Datenzeile pr�fen, mindestens eine ist vorhanden
      DatenSpalten := 0;
      SetLength(DatenArray,2,ColZahl);
      for j:=0 to Min(ColZahl+1, ExcelWorkSheet.Cells.Columns.Count-1) do // 2 extra Spalten pr�fen
      begin
        S := ExcelWorkSheet.Cells.Item[KopfZeilen+2,j+1]; // 1. Datenzeile
        if S <> '' then
        begin
          Inc(DatenSpalten);
          if j < ColZahl then
            DatenArray[1,j] := S
          else
          begin
            TriaMessage(Self,'In der ersten Datenzeile (Zeile ' + IntToStr(Kopfzeilen+2) + ', Tabellenblatt "' +
                        ExcelWorkSheet.Name + '") sind mehr Spalten vorhanden als in der �berschriftenzeile.' +#13+#13+
                        'Die Daten k�nnen nicht importiert werden.',
                        mtInformation,[mbOk]);
            SetLength(DatenArray,0,0);
            Exit;
          end;
        end;
      end;
      if DatenSpalten < cnPflichtFelder then
      begin
        if DatenSpalten = 0 then S := 'sind keine Daten'
                            else S := 'ist nur eine Spalte mit Daten';
        TriaMessage(Self,'In der ersten Datenzeile (Zeile ' + IntToStr(Kopfzeilen+2) + ', Tabellenblatt "' +
                    ExcelWorkSheet.Name + '") '+S+' vorhanden.' +#13+#13+
                    'Die Daten k�nnen nicht importiert werden.',
                    mtInformation,[mbOk]);
        SetLength(DatenArray,0,0);
        Exit;
      end;

      // weitere Zeilen mit Dateninhalt lesen
      for i:=2 to ExcelWorkSheet.Cells.Rows.Count-1-KopfZeilen do
      begin
        LeerZeile := true;
        for j:=0 to ColZahl-1 do
        begin
          S := ExcelWorkSheet.Cells.Item[i+1+KopfZeilen,j+1];
          if S <> '' then
          begin
            if LeerZeile then // nur 1x pro Row pr�fen
            begin
              LeerZeile := false;
              SetLength(DatenArray,i+1,ColZahl);
            end;
            DatenArray[i,j] := S;
          end;
        end;
        if LeerZeile then Break; // Break bei 1. LeerZeile in Tabelle

        if Length(DatenArray) > cnTlnMax+1-Veranstaltung.TlnColl.Count then
        begin
          TriaMessage(Self,'Auf Tabellenblatt  "' + ExcelWorksheet.Name+
                      '"  wurde die maximale Teilnehmerzahl �berschritten.'+#13+#13+
                      'Es k�nnen nur '+IntToStr(cnTlnMax-Veranstaltung.TlnColl.Count) +' Teilnehmer importiert werden.',
                       mtInformation,[mbOk]);
          SetLength(DatenArray,cnTlnMax+1-Veranstaltung.TlnColl.Count);
          Exit;
        end;
      end;

      Result := true;
    end;
  except
    SetLength(DatenArray,0,0);
    TriaMessage(Self,'Fehler beim Lesen des Tabellenblattes  "' + ExcelWorksheet.Name+ '".'+#13+#13+
                'Die Daten k�nnen nicht importiert werden.',
                 mtInformation,[mbOk]);
  end;
end;


(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TImportDialog.ExcelSheetCBChange(Sender: TObject);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
begin
  if not Updating then
  begin
    Updating := true;
    // Progressbar zu 1/2 voll
    HauptFenster.ProgressBarInit('Vorschau wird vorbereitet',2);
    HauptFenster.ProgressBarStep(1);
    try
      try
        ExcelWorkSheet.ConnectTo(ExcelWorkbook.Sheets.Item[ExcelSheetCB.ItemIndex+1] as _Worksheet);
      except
        TriaMessage(Self,'Fehler beim Lesen des Tabellenblattes  "' + ExcelSheetCB.Items[ExcelSheetCB.ItemIndex] + '".'+#13+#13+
                    'Die Daten k�nnen nicht importiert werden.',
                     mtInformation,[mbOk]);
        SetLength(DatenArray,0,0);
        Exit;
      end;
      ExcelSheetLaden;
    finally
      InitFeldValueListEditor; // kein Stepping
      UpdateVorschau(true);
      // Progressbar.Max anpassen f�r nachfolgende Aktionen (1 step pro Row)
      HauptFenster.ProgressBarMaxUpdate(FeldValueListEditor.Strings.Count);
      HauptFenster.StatusBarClear;
      Updating := false;
    end;
  end;
end;

(*============================================================================*)
function TImportDialog.GetFeldNameLang(Feld:TColtype):String;
(*============================================================================*)
begin
  Result := GetFeldNameLang(Feld,0);
end;

(*============================================================================*)
function TImportDialog.GetFeldNameLang(Feld:TImpFeldRec): String; 
(*============================================================================*)
begin
  Result := GetFeldNameLang(Feld.FeldType,Feld.Runde);
end;

(*============================================================================*)
function TImportDialog.GetFeldNameLang(Feld:TColtype;Rnd:Integer):String;
(*============================================================================*)
begin
  case Feld of
    spName          : Result := 'Name';
    spVName         : Result := 'Vorname';
    spSex           : Result := 'Geschlecht';
    spJg            : Result := 'Jahrgang';
    spVerein        : Result := 'Verein/Ort';
    spMannsch       : Result := 'Mannschaft';
    spStrasse       : Result := 'Stra�e';
    spEMail         : Result := 'E-Mail';
    spHausNr        : Result := 'Hausnummer';
    spPLZ           : Result := 'PLZ';
    spOrt           : Result := 'Ort';
    spLand          : if (HauptFenster.SortWettk <> nil)and (HauptFenster.SortWettk <> nil) and
                         (HauptFenster.SortWettk.TlnTxt <> '') then
                        Result := HauptFenster.SortWettk.TlnTxt
                      else Result := 'Land';
    spMeldeZeit     : Result := 'Meldezeit';
    spStartgeld     : Result := 'Startgeld';
    spRfid          : Result := 'RFID-Code';
    spKomment       : Result := 'Kommentar';
    spMschWrtg      : Result := 'Mannschaftswertung';
    spMschMixWrtg   : Result := 'Mixed Mannschaft';
    spSondWrtg      : Result := 'Sonderwertung';
    spSerWrtg       : Result := 'Serienwertung';
    spUrkDr         : Result := 'Urkunde drucken';
    spAusKonkAllg   : Result := 'Au�er Konkurrenz';
    spAusKonkAltKl  : Result := 'a.K.-Altersklasse';
    spAusKonkSondKl : Result := 'a.K.-Sonderklasse';
    spStaffelName2..spStaffelName8:
      Result := 'Staffeltln.'+IntToStr(Integer(Feld)-Integer(spStaffelName2)+2)+'-Name';
    spStaffelVName2..spStaffelVName8:
      Result := 'Staffeltln.'+IntToStr(Integer(Feld)-Integer(spStaffelVName2)+2)+'-Vorname';
    spSnr           : Result := 'Startnummer';
    spRestStrecke   : Result := 'Reststrecke';
    spStZeit        : Result := 'Startzeit';
    spStBahn        : Result := 'Startbahn';
    spAbs1UhrZeit..spAbs8UhrZeit:
      if Rnd > 0 then Result := 'Abschn.'+IntToStr(Integer(Feld)-Integer(spAbs1UhrZeit)+1)+'-Runde '+IntToStr(Rnd)
                 else Result := 'Abschn.'+IntToStr(Integer(Feld)-Integer(spAbs1UhrZeit)+1)+'-Zeit';
    spTlnStrafZeit  : Result := 'Strafzeit';
    spGutschrift    : Result := 'Gutschrift';
    spDisqGrund     : Result := 'Disq.-Grund';
    spDisqName      : Result := 'Disq.-Bezeichn.';
    spWettk         : Result := 'Wettkampf';
    else Result := '';
  end;
end;

(*============================================================================*)
function TImportDialog.GetFeldNameKey(Feld:TColType):String;
(*============================================================================*)
begin
  Result := GetFeldNameKey(Feld,0);
end;

(*============================================================================*)
function TImportDialog.GetFeldNameKey(Feld:TColType;Rnd:Integer):String;
(*============================================================================*)
begin
  case Feld of
    spName,spVName:
      Result := GetFeldNameLang(Feld) + '*';  // Pflichtfelder
    else
      Result := GetFeldNameLang(Feld,Rnd);
  end;
end;

(*============================================================================*)
function TImportDialog.GetImpSpalte(Feld:TColType): Integer;
(*============================================================================*)
begin
  Result := GetImpSpalte(Feld,0);
end;

(*============================================================================*)
function TImportDialog.GetImpSpalte(Feld:TColType;Rnd:Integer): Integer;
(*============================================================================*)
begin
  Result :=
    ImpFeldArr[FeldValueListEditor.Strings.IndexOfName(GetFeldNameKey(Feld,Rnd))].Spalte;
end;

(*============================================================================*)
function TImportDialog.GetFeldStr(Feld:TColType; ImpOption:TImpOption):String;
(*============================================================================*)
begin
  Result := '';
  if ImpOption = ioFehler then Exit;
  case Feld of
    spMschWrtg      : if ImpOption=ioTrue then Result := MschWrtgTStr
                                          else Result := MschWrtgFStr;
    spMschMixWrtg   : if ImpOption=ioTrue then Result := MschMixWrtgTStr
                                          else Result := MschMixWrtgFStr;
    spSondWrtg      : if ImpOption=ioTrue then Result := SondWrtgTStr
                                          else Result := SondWrtgFStr;
    spSerWrtg       : if ImpOption=ioTrue then Result := SerWrtgTStr
                                          else Result := SerWrtgFStr;
    spUrkDr         : if ImpOption=ioTrue then Result := UrkTStr
                                          else Result := UrkFStr;
    spAusKonkAllg   : if ImpOption=ioTrue then Result := AuKonkAllgTStr
                                          else Result := AuKonkAllgFStr;
    spAusKonkAltKl  : if ImpOption=ioTrue then Result := AuKonkAltKlTStr
                                          else Result := AuKonkAltKlFStr;
    spAusKonkSondKl : if ImpOption=ioTrue then Result := AuKonkSondKlTStr
                                          else Result := AuKonkSondKlFStr;
    else ;
  end;
end;

(*============================================================================*)
procedure TImportDialog.SetFeldStr(Feld:TColType; ImpOption:TImpOption; S:String);
(*============================================================================*)
begin
  if ImpOption = ioFehler then Exit;
  case Feld of
    spMschWrtg      : if ImpOption=ioTrue then MschWrtgTStr := S
                                          else MschWrtgFStr := S;
    spMschMixWrtg   : if ImpOption=ioTrue then MschMixWrtgTStr := S
                                          else MschMixWrtgFStr := S;
    spSondWrtg      : if ImpOption=ioTrue then SondWrtgTStr := S
                                          else SondWrtgFStr := S;
    spSerWrtg       : if ImpOption=ioTrue then SerWrtgTStr := S
                                          else SerWrtgFStr := S;
    spUrkDr         : if ImpOption=ioTrue then UrkTStr := S
                                          else UrkFStr := S;
    spAusKonkAllg   : if ImpOption=ioTrue then AuKonkAllgTStr := S
                                          else AuKonkAllgFStr := S;
    spAusKonkAltKl  : if ImpOption=ioTrue then AuKonkAltKlTStr := S
                                          else AuKonkAltKlFStr := S;
    spAusKonkSondKl : if ImpOption=ioTrue then AuKonkSondKlTStr := S
                                          else AuKonkSondKlFStr := S;
    else ;
  end;
end;

(*============================================================================*)
function TImportDialog.GetFeldStrValid(Feld:TColType; ImpOption:TImpOption):Boolean;
(*============================================================================*)
begin
  Result := false;
  if ImpOption = ioFehler then Exit;
  case Feld of
    spMschWrtg      : if ImpOption=ioTrue then Result := MschWrtgTStrValid
                                          else Result := MschWrtgFStrValid;
    spMschMixWrtg   : if ImpOption=ioTrue then Result := MschMixWrtgTStrValid
                                          else Result := MschMixWrtgFStrValid;
    spSondWrtg      : if ImpOption=ioTrue then Result := SondWrtgTStrValid
                                          else Result := SondWrtgFStrValid;
    spSerWrtg       : if ImpOption=ioTrue then Result := SerWrtgTStrValid
                                          else Result := SerWrtgFStrValid;
    spUrkDr         : if ImpOption=ioTrue then Result := UrkTStrValid
                                          else Result := UrkFStrValid;
    spAusKonkAllg   : if ImpOption=ioTrue then Result := AuKonkAllgTStrValid
                                          else Result := AuKonkAllgFStrValid;
    spAusKonkAltKl  : if ImpOption=ioTrue then Result := AuKonkAltKlTStrValid
                                          else Result := AuKonkAltKlFStrValid;
    spAusKonkSondKl : if ImpOption=ioTrue then Result := AuKonkSondKlTStrValid
                                          else Result := AuKonkSondKlFStrValid;
    else ;
  end;
end;

(*============================================================================*)
procedure TImportDialog.SetFeldStrValid(Feld:TColType; ImpOption:TImpOption; B:Boolean);
(*============================================================================*)
begin
  if ImpOption = ioFehler then Exit;
  case Feld of
    spMschWrtg      : if ImpOption=ioTrue then MschWrtgTStrValid := B
                                          else MschWrtgFStrValid := B;
    spMschMixWrtg   : if ImpOption=ioTrue then MschMixWrtgTStrValid := B
                                          else MschMixWrtgFStrValid := B;
    spSondWrtg      : if ImpOption=ioTrue then SondWrtgTStrValid := B
                                          else SondWrtgFStrValid := B;
    spSerWrtg       : if ImpOption=ioTrue then SerWrtgTStrValid := B
                                          else SerWrtgFStrValid := B;
    spUrkDr         : if ImpOption=ioTrue then UrkTStrValid := B
                                          else UrkFStrValid := B;
    spAusKonkAllg   : if ImpOption=ioTrue then AuKonkAllgTStrValid := B
                                          else AuKonkAllgFStrValid := B;
    spAusKonkAltKl  : if ImpOption=ioTrue then AuKonkAltKlTStrValid := B
                                          else AuKonkAltKlFStrValid := B;
    spAusKonkSondKl : if ImpOption=ioTrue then AuKonkSondKlTStrValid := B
                                          else AuKonkSondKlFStrValid := B;
    else ;
  end;
end;

(*============================================================================*)
function TImportDialog.DefaultFeldStr(Feld:TColType; ImpOption:TImpOption; S:String):Boolean;
(*============================================================================*)
begin
  Result := false;
  if ImpOption = ioFehler then Exit;
  case Feld of
    spMschWrtg,
    spMschMixWrtg,
    spSondWrtg,
    spSerWrtg,
    spUrkDr,
    spAusKonkAllg,
    spAusKonkAltKl,
    spAusKonkSondKl: if ImpOption=ioTrue then Result := SameText('x',S) or
                                                        SameText('+',S)
                                         else Result := SameText('',S) or
                                                        SameText(' ',S) or
                                                        SameText('-',S);
    else ;
  end;
end;

//==============================================================================
function TImportDialog.GetSexStr(Sx:TSex):String;
//==============================================================================
begin
  case Sx of
    cnMaennlich: Result := SexMStr;
    cnWeiblich:  Result := SexWStr;
    cnMixed:     Result := SexXStr;
    cnKeinSex:   Result := SexKStr;
    cnSexBeide:  Result := '';
  end;
end;

//==============================================================================
procedure TImportDialog.SetSexStr(Sx:TSex; S:String);
//==============================================================================
begin
  case Sx of
    cnMaennlich: SexMStr := S;
    cnWeiblich:  SexWStr := S;
    cnMixed:     SexXStr := S;
    cnKeinSex:   SexKStr := S;
    cnSexBeide:  ;
  end;
end;

//==============================================================================
function TImportDialog.GetSexStrValid(Sx:TSex):Boolean;
//==============================================================================
begin
  case Sx of
    cnMaennlich: Result := SexMStrValid;
    cnWeiblich:  Result := SexWStrValid;
    cnMixed:     Result := SexXStrValid;
    cnKeinSex:   Result := SexKStrValid;
    else         Result := false;
  end;
end;

//==============================================================================
procedure TImportDialog.SetSexStrValid(Sx:TSex; B:Boolean);
//==============================================================================
begin
  case Sx of
    cnMaennlich: SexMStrValid := B;
    cnWeiblich:  SexWStrValid := B;
    cnMixed:     SexXStrValid := B;
    cnKeinSex:   SexKStrValid := B;
    else  ;
  end;
end;

//==============================================================================
function TImportDialog.DefaultSexStr(Sx:TSex; S:String):Boolean;
//==============================================================================
begin
  case Sx of
    cnMaennlich: Result := SameText('M',S) or
                           ContainsText(S,'maen') or
                           ContainsText(S,'mann') or
                           ContainsText(S,'m�nn') or
                           SameText('male',S) or
                           SameText('man',S);
    cnWeiblich:  Result := SameText('W',S) or
                           SameText('F',S) or
                           ContainsText(S,'weib') or
                           ContainsText(S,'frau') or
                           SameText('female',S) or
                           SameText('woman',S);
    cnMixed:     Result := SameText('Mx',S) or
                           SameText('X',S) or
                           ContainsText(S,'Mix');
    cnKeinSex:   Result := SameText('',S) or
                           SameText(' ',S) or
                           SameText('-',S);
    else         Result := false;
  end;
end;


// private Methoden TImportDialog

(*----------------------------------------------------------------------------*)
procedure TImportDialog.ClearOptionStrings;
(*----------------------------------------------------------------------------*)
begin
  SexMStr      := '';
  SexWStr      := '';
  SexXstr      := '';
  SexKStr      := '';
  MschWrtgTStr := '';
  MschWrtgFStr := '';
  MschMixWrtgTStr := '';
  MschMixWrtgFStr := '';
  SondWrtgTStr := '';
  SondWrtgFStr := '';
  SerWrtgTStr  := '';
  SerWrtgFStr  := '';
  UrkTStr      := '';
  UrkFStr      := '';
  AuKonkAllgTStr   := '';
  AuKonkAltKlTStr  := '';
  AuKonkSondKlTStr := '';
  AuKonkAllgFStr   := '';
  AuKonkAltKlFStr  := '';
  AuKonkSondKlFStr := '';

  SexMStrValid      := false;
  SexWStrValid      := false;
  SexXStrValid      := false;
  SexKStrValid      := false;
  MschWrtgTStrValid := false;
  MschWrtgFStrValid := false;
  MschMixWrtgTStrValid := false;
  MschMixWrtgFStrValid := false;
  SondWrtgTStrValid := false;
  SondWrtgFStrValid := false;
  SerWrtgTStrValid  := false;
  SerWrtgFStrValid  := false;
  UrkTStrValid      := false;
  UrkFStrValid      := false;
  AuKonkAllgTStrValid   := false;
  AuKonkAltKlTStrValid  := false;
  AuKonkSondKlTStrValid := false;
  AuKonkAllgFStrValid   := false;
  AuKonkAltKlFStrValid  := false;
  AuKonkSondKlFStrValid := false;
end;

(*----------------------------------------------------------------------------*)
procedure TImportDialog.SetzeTrennZeichen;
(*----------------------------------------------------------------------------*)
// TextDatei vorher in TextzeilenColl eingelesen
// Vorletzte Zeile, weil am Anfang Kopfzeilen sein k�nnen
// TextTrennzeichen ignorieren, nur eines der vordefinierten Zeichen w�hlen
// Benachbarte Blanks zusammenfassen zu 1 Blank
var i,SKZahl,TABZahl,KomZahl,LeerZahl : Integer;
    AltChar : Char;
    Zeile : String;

begin
  TrennZeichen := ';';
  if TextZeilenColl.Count < 2 then Exit;
  Zeile := TextZeilenColl[TextZeilenColl.Count-2];
  if Length(Zeile) > 3 then
  begin
    SKZahl := 0;
    for i:=2 to Length(Zeile)-1 do if Zeile[i] = ';' then Inc(SKZahl);
    TABZahl := 0;
    for i:=2 to Length(Zeile)-1 do if Word(Zeile[i]) = VK_TAB then Inc(TABZahl);
    KomZahl := 0;
    for i:=2 to Length(Zeile)-1 do if Zeile[i] = ',' then Inc(KomZahl);
    LeerZahl := 0;
    AltChar := #0;
    for i:=2 to Length(Zeile)-1 do
    begin
      if (Zeile[i] = ' ') and (AltChar <> ' ') then Inc(LeerZahl);
      AltChar := Zeile[i];
    end;
    // suche gr��te Zahl
    if SKZahl >= TABZahl then
      if SKZahl >= KomZahl then
        if SKZahl >= LeerZahl then
          if SKZahl > 0 then TrennZeichen := ';'
                        else
        else if LeerZahl > 0 then TrennZeichen := ' '
                             else
      else
        if KomZahl >= LeerZahl then
          if KomZahl > 0 then TrennZeichen := ','
                         else
        else if LeerZahl > 0 then TrennZeichen := ' '
                             else
    else
      if TABZahl >= KomZahl then
        if TABZahl >= LeerZahl then
          if TABZahl > 0 then TrennZeichen := Char(VK_TAB)
                         else
        else if LeerZahl > 0 then TrennZeichen := ' '
                             else
      else
        if KomZahl >= LeerZahl then
          if KomZahl > 0 then TrennZeichen := ','
                         else
        else if LeerZahl > 0 then TrennZeichen := ' '
                             else;
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TImportDialog.TxtInitDatenArray(Step:Boolean);
(*----------------------------------------------------------------------------*)
// nur f�r fmText, ausgef�hrt wenn Trennzeichen ge�ndert oder initialisiert wird
// Daten vorher unver�ndert mit texterkennungszeichen in TextzeilenColl eingelesen
// Leerzeilen nicht eingelesen und Inhalt vorher auf Steuerzeichen gepr�ft
// Split TextZeilenColl in TextDatenFeldArray:
//   -  1.Zeile: alle Feldnamen aus TextDatei, Leerfelder ignoriert
//   -  Rest:    alle DatenZeilen mit DatenFeld pro Feldname
// FeldValueListEditor.Strings:  Name = Value mit default Zuordnung
// Benachbarte Blanks l�schen, deshalb bei Leerzeichen als Trennung
// keine Leerfelder erlaubt

var i,j,Indx: Integer;
    TrennPos : Integer;
    Zeile,Feld : String;
    Spaltenzahl,Kopfzeilen, Zahl : Integer;


//..............................................................................
function TrenneSpalte(const Txt:String; var Feld:String): Integer;
// Txt bis Trennzeichen in Fld
// TextErkZeichen am Anfang und Ende entfernen
// bei doppelte TextErkZeichen dazwischen ein Zeichen entfernen
// Result zeigt n�chstes Trennzeichen in UrsprungsString oder 0 wenn kein Trennzeichen
// nach TextErkzeichen-Paar

var TrennPos,QuotePos, DoppelQuoteZahl : Integer;
    S,SBuf : String;
begin
  DoppelQuoteZahl := 0;

  // TextErkZeichen bearbeiten: Paar am Anfang und Ende l�schen
  // Doppelte Zeichen zwischen Zeichen-Paar durch ein Zeichen ersetzen
  // sonst TextErkZeichen unver�ndert belassen
  if (Length(Txt) > 1) and (ImpTextErkZeichen <> cnKein) and
     (Txt[1] = ImpTextErkZeichen) then // 1. Zeichen TextErk, mindestens 2 Zeichen
  begin
    S := Txt;
    Delete(S,1,1); // 1. TextErkzeichen vorab l�schen
    SBuf := S;
    repeat
      QuotePos := Pos(ImpTextErkZeichen,SBuf); // n�chstes Trennzeichen
      if QuotePos > 0 then
      begin
        if QuotePos = Length(SBuf) then // letztes Zeichen, Paar l�schen
        begin
          Delete(S,Length(S),1); // letztes ErkZeichen in S l�schen
          Feld := S;
          Result := 0; // kein weiteres Trennzeichen
          Exit;
        end
        else
        // QuotePos < Length(SBuf) // noch mindestens 1 Zeichen nach QuotePos
        if SBuf[QuotePos+1] = TrennZeichen then // weiteres Feld oder Leerfeld folgt nach Trennzeichen
        begin
          Feld := LeftStr(S,QuotePos+DoppelQuoteZahl-1);
          Result := QuotePos + DoppelQuoteZahl*2 + 2; // Trennzeichen in Txt
          Exit;
        end
        else
        if SBuf[QuotePos+1] = ImpTextErkZeichen then // doppeltes Quotezeichen
        begin
          Delete(SBuf,QuotePos,2); // beide Erkzeichen l�schen
          Delete(S,QuotePos+DoppelQuoteZahl,1); // erstes ErkZeichen l�schen
          Inc(DoppelQuoteZahl); // Index-Unterschied zwischen S und SBuf
        end // n�chstes ErkZeichen suchen
        else // ErkZeichen-Paar ung�ltig, Zeichen ignorieren und Trennzeichen ab Anfang suchen
          Break
      end;
    until (QuotePos = 0);
  end;

  TrennPos := Pos(TrennZeichen,Txt);
  if TrennPos > 0 then
  begin
    Feld := LeftStr(Txt,TrennPos-1);
    Result := TrennPos;
  end else
  begin
    Feld := Txt;
    Result := 0;
  end;

end;

//..............................................................................
function ZaehleSpalten(S: String): Integer;
var i : Integer;
    SpalteTxt : String;
begin
  S := TrimBlank(S);
  Result := 1;
  // Textfelder innerhalb Trennzeichen-Paar ignorieren
  repeat
    i := TrenneSpalte(S,SpalteTxt);
    if i > 0 then
    begin
      Inc(Result);
      Delete(S,1,i);
      S := TrimBlank(S);
    end;
  until (Length(S)=0)or(i=0)or(Result=cnTextFelderMax);
end;

//..............................................................................
begin
  if TextZeilenColl.Count < 2 then Exit; // mindestens Feldnamen + Daten

  with TextErkZeichenCB do
    if ItemIndex > 0 then
      ImpTextErkZeichen := Items[ItemIndex]
    else ImpTextErkZeichen := cnKein;

  Kopfzeilen  := 0;
  SpaltenZahl := 1;

  if (TextZeilenColl.Count > 2) and (TrennZeichen <> ' ') then
  begin
    // max cnKopfzeilenMax (10) Kopfzeilen ignorieren
    // Leerzeilen oder Zeilen nur einer Spalte, wenn mindestens 2 Spalten vorhanden

    // Pr�fen ob mindestens eine g�ltige Header- und Datenzeile vorhanden nach Max 10 Kopfzeilen:
    Zahl := ZaehleSpalten(TextZeilenColl[Min(cnKopfzeilenMax+1,TextZeilenColl.Count-1)]);
    if (Zahl >= cnPflichtFelder) and
       (Zahl = ZaehleSpalten(TextZeilenColl[Min(cnKopfzeilenMax,TextZeilenColl.Count-2)])) then
      SpaltenZahl := Zahl;

    if SpaltenZahl >= cnPflichtFelder then // Kopfzeilen z�hlen
      repeat
        Zahl := ZaehleSpalten(TextZeilenColl[KopfZeilen]);
        if Zahl < SpaltenZahl then // aktuelle Zeile ist Kopfzeile
          Inc(KopfZeilen);
      until (Zahl >= SpaltenZahl) or (KopfZeilen >= cnKopfzeilenMax);
  end;

  if Step then HauptFenster.ProgressBarStep(Kopfzeilen);

  // Init 1. Zeile nach Kopfzeilen mit TextFeldNamen
  if TextZeilenColl.Count > Kopfzeilen then
  begin
    Zeile := TrimBlank(TextZeilenColl[Kopfzeilen]);
    Indx := -1;
    repeat
      TrennPos := TrenneSpalte(Zeile,Feld);
      if TrennPos > 0 then
      begin
        if Length(Feld)>0 then  // Leerfelder ignorieren
        begin
          Inc(Indx);
          SetLength(DatenArray,1,Indx+1);
          DatenArray[0,Indx] := Feld;
        end;
        Delete(Zeile,1,TrennPos);
        Zeile := TrimBlank(Zeile);
      end else
      if Length(Zeile)>0 then // Leerfelder ignorieren
      begin
        Inc(Indx);
        SetLength(DatenArray,1,Indx+1);
        DatenArray[0,Indx] := Zeile;
      end;
    until (Length(Zeile)=0)or(TrennPos=0)or(Indx=cnTextFelderMax-1);
  end;

  if Step then HauptFenster.ProgressBarStep(1);

  // Init restliche Zeilen mit Datenfelder
  for i:=Kopfzeilen+1 to TextZeilenColl.Count-1 do
  begin
    // Speichere alle Textfelder zun�chst in Zeile
    Zeile := TrimBlank(TextZeilenColl[i]);
    SetLength(DatenArray,i+1-KopfZeilen,Length(DatenArray[0]));
    for j:=0 to Length(DatenArray[0])-1 do
    begin
      // Datenfeld pro Feldname, entsprechend 1. Zeile
      // Leerfelder und Blanks in Datenfelder zulassen
      // Ungleiche Spaltenzahl zulassen
      TrennPos := TrenneSpalte(Zeile,Feld);
      DatenArray[i-KopfZeilen,j] := Feld;
      if TrennPos > 0 then
      begin
        Delete(Zeile,1,TrennPos);
        Zeile := TrimBlank(Zeile);
      end else
        Zeile := '';
    end;
    if Step then HauptFenster.ProgressBarStep(1);
  end;

end;

(*----------------------------------------------------------------------------*)
procedure TImportDialog.InitFeldValueListEditor;
(*----------------------------------------------------------------------------*)
// immer nach TxtInitDatenArray ausf�hren, kein ProgressBar-Stepping
var i,j,RndMax : Integer;
  FeldBoolArr  : array of Boolean;//Buffer f�r Zuordung Feldname zu Spalte
  Col : TColType;
begin
  RndMax := 0;
  // max. Anzahl Importfelder f�r Rundenzeiten berechnen
  if HauptFenster.SortWettk.RundenWettk and (Length(DatenArray) > 0) then
  begin
    RndMax := Length(DatenArray[0]);
    SetLength(FeldBoolArr,Length(DatenArray[0]));
    for i:=0 to Length(FeldBoolArr)-1 do FeldBoolArr[i] := true;
    i := 0;
    repeat
      Col := GetColType(ltTlnImport,WettkAlleDummy,i,lmImport);
      if (Col <> spLeer) and not (Col in [spAbs1UhrZeit..spAbs8UhrZeit]) then
        for j:=0 to Length(DatenArray[0])-1 do // Spalten�berschriften
          if FeldBoolArr[j] and // Datenspalte noch nicht zugeordnet
             (DatenArray[0,j] = GetMruFeldName(Col,0)) or
             (DatenArray[0,j] = GetFeldNameLang(Col,0)) or
             (DatenArray[0,j] = GetFeldNameKurz(Col,0)) then
          begin
            FeldBoolArr[j] := false; // Spalte zugeordnet
            Dec(RndMax);
          end;
      Inc(i);
    until Col = spLeer;
  end;

  // Init ImpFeldArr und Feld-Zuordnung nach Laden der Datei, wegen RndMax
  InitImpFeldArr(HauptFenster.SortWettk,lmImport,RndMax);
  // Value <kein> voreinstellen
  FeldValueListEditor.Strings.Clear;
  for i:=0 to Length(ImpFeldArr) - 1 do
    FeldValueListEditor.Strings.Add(GetFeldNameKey(ImpFeldArr[i].FeldType,ImpFeldArr[i].Runde)+'='+cnKein);

  if Length(DatenArray) > 0 then
    SetLength(FeldBoolArr,Length(DatenArray[0]))
  else SetLength(FeldBoolArr,0);
  for i:=0 to Length(FeldBoolArr)-1 do FeldBoolArr[i] := true;

  // Datenspalten den Feldnamen zuordnen
  for i:=0 to Length(ImpFeldArr)-1 do // Feldnamen
    for j:=0 to Length(FeldBoolArr)-1 {=Length(DatenArray[0]-1} do // Spalten�berschriften
      if FeldBoolArr[j] and // Datenspalte noch nicht zugeordnet
         (DatenArray[0,j] = GetMruFeldName(ImpFeldArr[i].FeldType,ImpFeldArr[i].Runde)) or
         (DatenArray[0,j] = GetFeldNameLang(ImpFeldArr[i].FeldType,ImpFeldArr[i].Runde)) or
         (DatenArray[0,j] = GetFeldNameKurz(ImpFeldArr[i].FeldType,ImpFeldArr[i].Runde)) or
         (ImpFeldArr[i].FeldType=spName)and ContainsText(DatenArray[0,j],'nachn') or
         (ImpFeldArr[i].FeldType=spVName)and ContainsText(DatenArray[0,j],'vorn') or
         (ImpFeldArr[i].FeldType=spEMail)and ContainsText(DatenArray[0,j],'mail') or
         (ImpFeldArr[i].FeldType=spLand)and ContainsText(DatenArray[0,j],'land') or
         (ImpFeldArr[i].FeldType=spStartgeld)and ContainsText(DatenArray[0,j],'geld') or
         (ImpFeldArr[i].FeldType=spVerein)and ContainsText(DatenArray[0,j],'verein') or
         (ImpFeldArr[i].FeldType=spMannsch)and ContainsText(DatenArray[0,j],'mannsch') or
         (ImpFeldArr[i].FeldType=spTlnStrafzeit)and ContainsText(DatenArray[0,j],'straf') or
         (ImpFeldArr[i].FeldType=spGutschrift)and ContainsText(DatenArray[0,j],'gutschr') or
         (ImpFeldArr[i].FeldType=spDisqGrund)and ContainsText(DatenArray[0,j],'grund') or
         (ImpFeldArr[i].FeldType=spDisqName)and ContainsText(DatenArray[0,j],'bezeich') then
      begin
        ImpFeldArr[i].Spalte := j;
        FeldValueListEditor.Strings.ValueFromIndex[i] := DatenArray[0,j];
        FeldBoolArr[j] := false; // Spalte zugeordnet
        Break;
      end;

  // Pflichtfelder zuordnen, falls noch nicht geschehen
  for i:=0 to Min(cnPflichtFelder,Length(ImpFeldArr))-1 do
    if (ImpFeldArr[i].Spalte = -1) and (Length(FeldBoolArr){=Length(DatenArray[0]} > i) then
    begin
      ImpFeldArr[i].Spalte := i;
      FeldValueListEditor.Strings.ValueFromIndex[i] := DatenArray[0,i];
      FeldBoolArr[i] := false; // Spalte zugeordnet
    end;

  // Picklisten setzen
  for i:=0 to Length(ImpFeldArr)-1 do
  begin
    with FeldValueListEditor.ItemProps[i] do
    begin
      EditStyle := esPickList;
      ReadOnly := true;
      PickList.Clear;
      if (i >= cnPflichtFelder) or
         (FeldValueListEditor.Strings.ValueFromIndex[i] = cnKein) then
        PickList.Add(cnKein);
      for j:=0 to Length(FeldBoolArr)-1 {=Length(DatenArray[0]-1} do
        if DatenArray[0,j]<>'' then PickList.Add(DatenArray[0,j]);
    end;
    //FeldValueListEditor.DropDownRows := Integer(spKeinExp)-Integer(spNameExp)+2;
  end;
  j := 0;
  while GetColType(ltTlnImport,WettkAlleDummy,j,lmImport) <> spLeer do Inc(j);
  FeldValueListEditor.DropDownRows := j+2;

  FeldValueListEditor.Row := 1;
  FeldBoolArr  := nil;
end;

(*----------------------------------------------------------------------------*)
function TImportDialog.GetDatenArrayIndex(ImpFeldIndex:Integer): Integer;
(*----------------------------------------------------------------------------*)
var i,Start : Integer;
begin
  Result := -1;
  with FeldValueListEditor do
  begin
    if (ImpFeldIndex<0)or(ImpFeldIndex>=Strings.Count) then Exit;
    if ItemProps[ImpFeldIndex].PickList[0] = cnKein then Start := 1
                                                    else Start := 0;

    for i:=Start to ItemProps[ImpFeldIndex].PickList.Count-1 do
      if SameText(Strings.ValueFromIndex[ImpFeldIndex],ItemProps[ImpFeldIndex].PickList[i]) then
      begin
        Result := i - Start;
        Exit;
      end;

   { Result := ItemProps[ImpFeldIndex].PickList.IndexOf(
                                           Strings.ValueFromIndex[ImpFeldIndex]);
    if ItemProps[ImpFeldIndex].PickList[0] = cnKein then Dec(Result); }
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TImportDialog.UpdateVorschau(Step:Boolean);
(*----------------------------------------------------------------------------*)
// Cells[j,i]: 1.Index = Col, 2.Index=Row
// auch update von ImpFeldArr.Spalte
var i,j,Splt : Integer;
    UpdatingAlt : Boolean;
begin
  UpdatingAlt := Updating;
  Updating := true;
  DatenOk :=false;
  with VorschauGrid do
  begin
    // Zellen l�schen
    for i:=0 to RowCount-1 do
      for j:=0 to ColCount-1 do
        Cells[j,i] := '';
    RowCount := Max(2,Length(DatenArray)); // FixedRows = 1, 1.Zeile mit Feldnamen
    Splt := -1;
    if Length(DatenArray) > 0 then
      for j:=0 to Length(ImpFeldArr)-1 do
      begin
        ImpFeldArr[j].Spalte := GetDatenArrayIndex(j);
        if ImpFeldArr[j].Spalte >= 0 then
        begin
          Inc(Splt);
          ColCount := Splt+1;
          i:=0; // Row=0
          Cells[Splt,i] := GetFeldNameKurz(ImpFeldArr[j].FeldType,ImpFeldArr[j].Runde);
          ColWidths[Splt] :=
            Canvas.TextWidth(' '+GetFeldNameKurz(ImpFeldArr[j].FeldType,ImpFeldArr[j].Runde)+' ');
          if j = FeldValueListEditor.Row-1 then Col := Splt;
          for i:=1 to RowCount-1 do
          begin
            if i < Length(DatenArray) then
              Cells[Splt,i] := DatenArray[i,ImpFeldArr[j].Spalte]
            else Cells[Splt,i] := '';
            if Canvas.TextWidth(' '+Cells[Splt,i]+' ') > ColWidths[Splt] then
              ColWidths[Splt] := Min(Canvas.TextWidth(' '+Cells[Splt,i]+' '),
                                     Canvas.TextWidth(' XXXXXXXXxxxxxxxxxxx '));
          end;
          // MruImportFeldnamenListe aktualisieren
          SetLength(MruImpFeldArr,j+1);
          with MruImpFeldArr[j] do
          begin
            FeldType := ImpFeldArr[j].FeldType;
            Runde    := ImpFeldarr[j].Runde;
            FeldName := DatenArray[0,ImpFeldArr[j].Spalte];
          end;
        end;
        if Step then HauptFenster.ProgressBarStep(1);
      end;
  end;
  Updating := UpdatingAlt;
end;

(*----------------------------------------------------------------------------*)
function TImportDialog.GetSGrp(Snr:Integer): TSGrpObj;
(*----------------------------------------------------------------------------*)
// erste passende SGrp, nicht sortiert
var i : Integer;
begin
  Result := nil;
  for i:=0 to Veranstaltung.SGrpColl.Count-1 do
  with Veranstaltung.SGrpColl[i] do
    if (WkOrtIndex = Veranstaltung.OrtIndex) and
       (Wettkampf = HauptFenster.SortWettk) and
       (Snr >= StartnrVon) and (Snr <= StartnrBis) then
    begin
      Result := Veranstaltung.SGrpColl[i];
      Exit;
    end;
end;

(*----------------------------------------------------------------------------*)
function TImportDialog.SnrDoppel(Snr,Zeile,Spalte:Integer): Boolean;
(*----------------------------------------------------------------------------*)
// Snr <> 0
var i : Integer;
begin
  Result := false;
  for i:=Zeile+1 to Length(DatenArray)-1 do // Zeilen pr�fen
    if StrToIntDef(DatenArray[i,Spalte],0) = Snr then
    begin
      Result := true;
      Exit;
    end;
end;

(*----------------------------------------------------------------------------*)
function TImportDialog.TlnDoppel(Name,VName,Verein,MannschName:String;Zeile:Integer):Boolean;
(*----------------------------------------------------------------------------*)
// entspricht SucheTln
var i : Integer;
begin
  Result := false;
  if (GetImpSpalte(spName)<0) or (GetImpSpalte(spVName)<0) then Exit;
  for i:=Zeile+1 to Length(DatenArray)-1 do // restliche Zeilen pr�fen
    if TxtGleich(DatenArray[i,GetImpSpalte(spName)],Name) and
       TxtGleich(DatenArray[i,GetImpSpalte(spVName)],VName) and
       ((GetImpSpalte(spVerein) >= 0) and
        TxtGleich(DatenArray[i,GetImpSpalte(spVerein)],Verein) or
       (GetImpSpalte(spMannsch) >= 0) and
       TxtGleich(DatenArray[i,GetImpSpalte(spMannsch)],MannschName)) then
    begin
      Result := true;
      Exit;
    end;
end;

(*----------------------------------------------------------------------------*)
function TImportDialog.GetOption(Feld:TColType; S:String): TImpOption;
(*----------------------------------------------------------------------------*)
// TImpOption : ioTrue, ioFalse, ioFehler
var ValidTrue,ValidFalse: Boolean;
begin
  ValidTrue  := GetFeldStrValid(Feld,ioTrue);
  ValidFalse := GetFeldStrValid(Feld,ioFalse);
  if ValidTrue and SameText(S,GetFeldStr(Feld,ioTrue)) then Result := ioTrue
  else if ValidFalse and SameText(S,GetFeldStr(Feld,ioFalse)) then Result := ioFalse
  else if ValidTrue and ValidFalse then Result := ioFehler  // Fehler --> Abbruch
  else // neuer String
    if DefaultFeldStr(Feld,ioTrue,S) then
      if not ValidTrue then
      begin
        SetFeldStr(Feld,ioTrue,S);
        SetFeldStrValid(Feld,ioTrue,true);
        Result := ioTrue;
      end else Result := ioFehler  // Fehler --> Abbruch
    else if DefaultFeldStr(Feld,ioFalse,S) then
      if not ValidFalse then
      begin
        SetFeldStr(Feld,ioFalse,S);
        SetFeldStrValid(Feld,ioFalse,true);
        Result := ioFalse;
      end else Result := ioFehler  // Fehler --> Abbruch
    else // keine DefaultString ==> Zuordnung abfragen
    begin
      case GetOptionFeldType(S,Feld) of
        ioTrue:  begin
                   SetFeldStr(Feld,ioTrue,S);
                   SetFeldStrValid(Feld,ioTrue,true);
                   Result  := ioTrue;
                 end;
        ioFalse: begin
                   SetFeldStr(Feld,ioFalse,S);
                   SetFeldStrValid(Feld,ioFalse,true);
                   Result := ioFalse;
                 end;
        else  Result := ioFehler;  // CancelButton gedruckt: Abbruch
      end;
    end;
end;

(*----------------------------------------------------------------------------*)
function TImportDialog.GetSexOption(S:String): TSex;
(*----------------------------------------------------------------------------*)
// cnMaennlich, cnWeiblich, cnMixed, cnKeinSex, cnSexBeide = Fehler
// cnMixed nur f�r TlnStaffel
var ValidM,ValidW,ValidX,ValidK: Boolean;
begin
  ValidM := GetSexStrValid(cnMaennlich);
  ValidW := GetSexStrValid(cnWeiblich);
  ValidX := ((HauptFenster.SortWettk.WettkArt=waTlnStaffel)or(HauptFenster.SortWettk.WettkArt=waTlnTeam)) and
            GetSexStrValid(cnMixed);
  ValidK := GetSexStrValid(cnKeinSex);
  if ValidM and SameText(S,GetSexStr(cnMaennlich)) then Result := cnMaennlich
  else if ValidW and SameText(S,GetSexStr(cnWeiblich)) then Result := cnWeiblich
  else if ValidX and SameText(S,GetSexStr(cnMixed)) then Result := cnMixed
  else if ValidK and SameText(S,GetSexStr(cnKeinSex)) then Result := cnKeinSex
  else if ValidM and ValidW and ValidK then Result := cnSexBeide // Fehler --> Abbruch
  else // neuer String
    if DefaultSexStr(cnMaennlich,S) then
      if not ValidM then
      begin
        SetSexStr(cnMaennlich,S);
        SetSexStrValid(cnMaennlich,true);
        Result := cnMaennlich;
      end else Result := cnSexBeide  // Fehler --> Abbruch
    else
    if DefaultSexStr(cnWeiblich,S) then
      if not ValidW then
      begin
        SetSexStr(cnWeiblich,S);
        SetSexStrValid(cnWeiblich,true);
        Result := cnWeiblich;
      end else Result := cnSexBeide  // Fehler --> Abbruch
    else
    if ((HauptFenster.SortWettk.WettkArt=waTlnStaffel) or (HauptFenster.SortWettk.WettkArt=waTlnTeam)) and
       DefaultSexStr(cnMixed,S) then
      if not ValidX then
      begin
        SetSexStr(cnMixed,S);
        SetSexStrValid(cnMixed,true);
        Result := cnMixed;
      end else Result := cnSexBeide  // Fehler --> Abbruch
    else if DefaultSexStr(cnKeinSex,S) then
      if not ValidK then
      begin
        SetSexStr(cnKeinSex,S);
        SetSexStrValid(cnKeinSex,true);
        Result := cnKeinSex;
      end else Result := cnSexBeide  // Fehler --> Abbruch
    else // keine DefaultString ==> Zuordnung abfragen
    begin
      case GetSexType(S) of
        cnMaennlich:  begin
                        SetSexStr(cnMaennlich,S);
                        SetSexStrValid(cnMaennlich,true);
                        Result  := cnMaennlich;
                      end;
        cnWeiblich:   begin
                        SetSexStr(cnWeiblich,S);
                        SetSexStrValid(cnWeiblich,true);
                        Result  := cnWeiblich;
                      end;
        cnMixed:      begin
                        SetSexStr(cnMixed,S);
                        SetSexStrValid(cnMixed,true);
                        Result  := cnMixed;
                      end;
        cnKeinSex:    begin
                        SetSexStr(cnKeinSex,S);
                        SetSexStrValid(cnKeinSex,true);
                        Result  := cnKeinSex;
                      end;
        else Result := cnSexBeide;  // CancelButton gedruckt: Abbruch
      end;
    end;
end;

(*----------------------------------------------------------------------------*)
function TImportDialog.PruefeDaten: Integer;
(*----------------------------------------------------------------------------*)
// Result:  -1 = Abbruch, ohne weitere Fehlermeldung
//           0 = Pr�fung abgeschlossen mit Fehler
//           1 = Pr�fung abgeschlossen ohne Fehler
var i,j,VorschauSpalte,Zahl : Integer;
    Fehler : Boolean;
    SexOpt  : TSex;
    Opt     : TImpOption;
    NameBuff,VNameBuff,VereinBuff,MannschNameBuff : String;
    SnrBuff : Integer;
    TlnBuff : TTlnObj;
    S : String;

begin
  Result := -1;
  Fehler := false;
  TlnUeberschreiben := false;
  TlnAlleUeberschreiben := false;

  if Length(DatenArray)<=1 then
  begin
    TriaMessage(Self,'In der Importdatei sind keine Daten enthalten.'+#13+
                'Die Daten k�nnen nicht importiert werden.',
                 mtInformation,[mbOk]);
    Exit; // Abbruch ohne weitere Fehlermeldung
  end;

  if ImportDialog.VorschauGrid.ColCount < cnPflichtFelder then
  begin
    TriaMessage(Self,'In der Importdatei sind zu wenig Datenfelder vorhanden.'+#13+
                'Die Felder '+
                GetFeldNameLang(spName)+' und '+
                GetFeldNameLang(spVName)+' sind Pflichtfelder.'+#13+
                'Die Daten k�nnen nicht importiert werden.',
                mtInformation,[mbOk]);
    Exit; // Abbruch ohne weitere Fehlermeldung
  end;

  // Daten Feld nach Feld pr�fen
  VorschauSpalte := -1;
  ImportDialog.VorschauGrid.Row := 1;
  ImportDialog.VorschauGrid.Col := 0;
  for j:=0 to Length(ImpFeldArr)-1 do
  begin
    if ImpFeldArr[j].Spalte >= 0 then
    begin
      Inc(VorschauSpalte);
      for i:=1 to Length(DatenArray)-1 do // Zeilen pr�fen
      begin
        HauptFenster.ProgressBarStep(1);
        case ImpFeldArr[j].FeldType of
          spName,
          spVName:
            if Length(DatenArray[i,ImpFeldArr[j].Spalte]) = 0 then
            begin
              Fehler := true;
              if TriaMessage(Self,'Das Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                             '"  ist leer.'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel])<> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end;
          spSex:
          begin
            SexOpt := GetSexOption(DatenArray[i,ImpFeldArr[j].Spalte]);
            case SexOpt of
              cnSexBeide :
              begin
                Fehler := true;
                if TriaMessage(Self,'Der Inhalt im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                               '"  ist nicht korrekt.'+#13+
                               'Daten k�nnen nicht importiert werden.'+#13+#13+
                               'Pr�fung fortsetzen?',
                                mtConfirmation,[mbOk,mbCancel])<> mrOk then
                begin
                  ImportDialog.VorschauGrid.Row := i;
                  ImportDialog.VorschauGrid.Col := VorschauSpalte;
                  Exit; // Abbruch ohne weitere Fehlermeldung
                end;
              end;
              else ; // datenfeld Ok
            end;
          end;
          spJg:
          begin
            if Length(DatenArray[i,ImpFeldArr[j].Spalte]) = 0 then
            begin
              // Fehler := true; // nur  warnen
              if TriaMessage(Self,'Das Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                             '"  ist leer.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel])<> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end else
            if not TryDecStrToInt(DatenArray[i,ImpFeldArr[j].Spalte],Zahl) then
            begin
              Fehler := true;
              if TriaMessage(Self,'Der Wert im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                             '"  ist ung�ltig.'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel])<> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end else
            begin
              // Jg sowohl 2- wie 4-stellig erlaubt
              Zahl := HauptFenster.SortWettk.JgLang(DatenArray[i,ImpFeldArr[j].Spalte]);
              if Zahl < HauptFenster.SortWettk.Jahr-cnAlterMax then
              begin
                // Fehler := true;
                if TriaMessage(Self,'Der Wert im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                               '"  ist kleiner als '+IntToStr(HauptFenster.SortWettk.Jahr-cnAlterMax)+'.'+#13+#13+
                               'Pr�fung fortsetzen?',
                                mtConfirmation,[mbOk,mbCancel])<> mrOk then
                begin
                  ImportDialog.VorschauGrid.Row := i;
                  ImportDialog.VorschauGrid.Col := VorschauSpalte;
                  Exit; // Abbruch ohne weitere Fehlermeldung
                end;
              end else
              if Zahl > HauptFenster.SortWettk.Jahr-cnAlterMin then
              begin
                Fehler := true;
                if TriaMessage(Self,'Der Wert im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                               '"  ist gr��er als '+IntToStr(HauptFenster.SortWettk.Jahr-cnAlterMin)+'.'+#13+#13+
                               'Pr�fung fortsetzen?',
                                mtConfirmation,[mbOk,mbCancel])<> mrOk then
                begin
                  ImportDialog.VorschauGrid.Row := i;
                  ImportDialog.VorschauGrid.Col := VorschauSpalte;
                  Exit; // Abbruch ohne weitere Fehlermeldung
                end;
              end;
            end;
          end;
          //spMannschExp
          //spStrasseExp
          //spHausNrExp
          //spPLZExp
          //spOrtExp
          spLand:
            if Length(DatenArray[i,ImpFeldArr[j].Spalte]) > 4 then
            begin
              Fehler := true;
              if TriaMessage(Self,'Der Text im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                             '"  enth�lt mehr als 4 Zeichen.'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel]) <> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end;
          //spKommentExp
          spMeldeZeit:   // keine Zehntel
            if (Length(DatenArray[i,ImpFeldArr[j].Spalte]) > 0) and
               (UhrZeitWertSek(DatenArray[i,ImpFeldArr[j].Spalte]) < 0) then
            begin
              Fehler := true;
              if TriaMessage(Self,'Der Inhalt im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                             '"  entspricht nicht dem Format "hh:mm:ss".'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel]) <> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end;
          spStartgeld: // __0,00
            if (EuroWert(DatenArray[i,ImpFeldArr[j].Spalte]) < 0) then
            begin
              Fehler := true;
              if TriaMessage(Self,'Der Inhalt im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                             '"  ist nicht leer und entspricht nicht dem Format "--0,00".'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel]) <> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end;

          spRfid:
            if RfidModus and (DatenArray[i,ImpFeldArr[j].Spalte] <> '') then  // leere Felder zulassen
            begin
              if Length(DatenArray[i,ImpFeldArr[j].Spalte]) > cnRfidzeichenMax then
              begin
                Fehler := true;
                if TriaMessage(Self,'Der RFID-Code hat mehr als '+IntToStr(cnRfidzeichenMax)+ ' Zeichen.'+#13+
                               'Daten k�nnen nicht importiert werden.'+#13+#13+
                               'Pr�fung fortsetzen?',
                                mtConfirmation,[mbOk,mbCancel]) <> mrOk then
                begin
                  ImportDialog.VorschauGrid.Row := i;
                  ImportDialog.VorschauGrid.Col := VorschauSpalte;
                  Exit; // Abbruch ohne weitere Fehlermeldung
                end;
              end else
              if not RfidTrimValid(DatenArray[i,ImpFeldArr[j].Spalte]) then
              begin
                Fehler := true;
                if TriaMessage(Self,'Der RFID-Code hat Leerzeichen am Anfang und/oder Ende.'+#13+
                               'Daten k�nnen nicht importiert werden.'+#13+#13+
                               'Pr�fung fortsetzen?',
                                mtConfirmation,[mbOk,mbCancel]) <> mrOk then
                begin
                  ImportDialog.VorschauGrid.Row := i;
                  ImportDialog.VorschauGrid.Col := VorschauSpalte;
                 Exit; // Abbruch ohne weitere Fehlermeldung
                end;
              end else
              if not RfidLengthValid(DatenArray[i,ImpFeldArr[j].Spalte]) then
              begin
                if TriaMessage(Self,'Der RFID-Code hat '+ IntToStr(Length(DatenArray[i,ImpFeldArr[j].Spalte])) +
                               ' statt ' + IntToStr(RfidZeichen)+' Zeichen.'+#13+
                               'Die maximal zul�ssige Zeichenl�nge auf '+ IntToStr(Length(DatenArray[i,ImpFeldArr[j].Spalte]))+' erh�hen?',
                                mtConfirmation,[mbOk,mbCancel]) <> mrOk then
                begin
                  Fehler := true;
                  if TriaMessage(Self,'Daten k�nnen nicht importiert werden.'+#13+#13+
                                 'Pr�fung fortsetzen?',
                                  mtConfirmation,[mbOk,mbCancel]) <> mrOk then
                  begin
                    ImportDialog.VorschauGrid.Row := i;
                    ImportDialog.VorschauGrid.Col := VorschauSpalte;
                    Exit; // Abbruch ohne weitere Fehlermeldung
                  end;
                end else
                  RfidZeichen := Length(DatenArray[i,ImpFeldArr[j].Spalte])
              end else
              if RfidHex and not RfidHexValid(DatenArray[i,ImpFeldArr[j].Spalte]) then
              begin
                if TriaMessage(Self,'Der RFID-Code ist keine g�ltige Hexadezimale Zahl.'+#13+
                               'Nicht-hexadezimale Zeichen generell zulassen?',
                                mtConfirmation,[mbOk,mbCancel]) <> mrOk then
                begin
                  Fehler := true;
                  if TriaMessage(Self,'Daten k�nnen nicht importiert werden.'+#13+#13+
                                 'Pr�fung fortsetzen?',
                                  mtConfirmation,[mbOk,mbCancel]) <> mrOk then
                  begin
                    ImportDialog.VorschauGrid.Row := i;
                    ImportDialog.VorschauGrid.Col := VorschauSpalte;
                    Exit; // Abbruch ohne weitere Fehlermeldung
                  end;
                end else
                  RfidHex := false;
              end;
            end;

          spMschWrtg,
          spMschMixWrtg,
          spSondWrtg,
          spSerWrtg,
          spUrkDr,
          spAusKonkAllg,spAusKonkAltKl,spAusKonkSondKl:
          begin
            Opt := GetOption(ImpFeldArr[j].FeldType,DatenArray[i,ImpFeldArr[j].Spalte]);
            case Opt of
              ioFehler :
              begin
                Fehler := true;
                if TriaMessage(Self,'Das Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                               '"  ist nicht korrekt.'+#13+
                               'Daten k�nnen nicht importiert werden.'+#13+#13+
                               'Pr�fung fortsetzen?',
                                mtConfirmation,[mbOk,mbCancel]) <> mrOk then
                begin
                  ImportDialog.VorschauGrid.Row := i;
                  ImportDialog.VorschauGrid.Col := VorschauSpalte;
                  Exit; // Abbruch ohne weitere Fehlermeldung
                end;
              end;
              else ; // Datenfeld Ok
            end;
          end;
          spSnr: //2006: Zahl=0 und leeres Feld akzeptieren
          begin
            if Length(DatenArray[i,ImpFeldArr[j].Spalte]) = 0 then Zahl := 0
            else if not TryDecStrToInt(DatenArray[i,ImpFeldArr[j].Spalte],Zahl) then
            begin
              Fehler := true;
              if TriaMessage(Self,'Der Wert im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                             '"  ist ung�ltig.'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel])<> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end;
            // Zahl ist g�ltiger Integer
            if Zahl > 0 then
              if GetSGrp(Zahl)=nil then
              begin
                Fehler := true;
                if TriaMessage(Self,'Die Startnummer  "'+DatenArray[i,ImpFeldArr[j].Spalte]+
                               '"  ist f�r den Wettkampf nicht definiert.'+#13+
                               'Daten k�nnen nicht importiert werden.'+#13+#13+
                               'Pr�fung fortsetzen?',
                                mtConfirmation,[mbOk,mbCancel])<> mrOk then
                begin
                  ImportDialog.VorschauGrid.Row := i;
                  ImportDialog.VorschauGrid.Col := VorschauSpalte;
                  Exit; // Abbruch ohne weitere Fehlermeldung
                end;
              end else
              if SnrDoppel(Zahl,i,ImpFeldArr[j].Spalte) then // Snr > 0
              begin
                Fehler := true;
                if TriaMessage(Self,'Die Startnummer  "'+DatenArray[i,ImpFeldArr[j].Spalte]+
                               '"  ist in der Importdatei mehrfach vorhanden.'+#13+
                               'Daten k�nnen nicht importiert werden.'+#13+#13+
                               'Pr�fung fortsetzen?',
                                 mtConfirmation,[mbOk,mbCancel]) <> mrOk then
                begin
                  ImportDialog.VorschauGrid.Row := i;
                  ImportDialog.VorschauGrid.Col := VorschauSpalte;
                  Exit; // Abbruch ohne weitere Fehlermeldung
                end;
              end;
          end;
          spStBahn: //2006: Zahl=0 und leeres Feld akzeptieren
          begin
            if Length(DatenArray[i,ImpFeldArr[j].Spalte]) = 0 then Zahl := 0
            else if not TryDecStrToInt(DatenArray[i,ImpFeldArr[j].Spalte],Zahl) then
            begin
              Fehler := true;
              if TriaMessage(Self,'Der Wert im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                             '"  ist ung�ltig.'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel])<> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end;
            // Zahl ist g�ltiger Integer
            if Zahl > HauptFenster.SortWettk.StartBahnen then
            begin
              Fehler := true;
              if TriaMessage(Self,'Die Startbahn  "'+DatenArray[i,ImpFeldArr[j].Spalte]+
                             '"  ist f�r den Wettkampf nicht definiert.'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel])<> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end;
          end;
          spRestStrecke:
          begin
            if Length(DatenArray[i,ImpFeldArr[j].Spalte]) = 0 then Zahl := 0
            else
            if not TryDecStrToInt(DatenArray[i,ImpFeldArr[j].Spalte],Zahl) or
               (StrToInt(DatenArray[i,ImpFeldArr[j].Spalte]) > cnStreckeMax) then
            begin
              Fehler := true;
              if TriaMessage(Self,'Der Wert im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                             '"  ist ung�ltig.'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel])<> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end;
          end;

          spStZeit,
          spAbs1UhrZeit..spAbs8UhrZeit: // Leerzelle und Format entsprechend ZeitFormat erlaubt
            if (Length(DatenArray[i,ImpFeldArr[j].Spalte]) > 0) and
               (UhrzeitWert(DatenArray[i,ImpFeldArr[j].Spalte]) < 0) then
            begin
              Fehler := true;
              case ZeitFormat of
                zfSek     : S := 'hh:mm:ss';
                zfZehntel : S := 'hh:mm:ss' +  DecTrennZeichen + 'd';
                else        S := 'hh:mm:ss' +  DecTrennZeichen + 'dd'; //zfHundertstel:
              end;
              if TriaMessage(Self,'Der Inhalt im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                             '"  entspricht nicht dem Format  "' + S + '".'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel]) <> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end;
          spTlnStrafZeit,
          spGutschrift: // hh=0 erlaubt
            if Length(DatenArray[i,ImpFeldArr[j].Spalte]) > 0 then // Leerfelder erlauben
              if MinZeitWert(DatenArray[i,ImpFeldArr[j].Spalte]) < 0 then
              begin
                Fehler := true;
                if TriaMessage(Self,'Der Inhalt im Datenfeld  "'+GetFeldNameLang(ImpFeldArr[j])+
                               '"  entspricht nicht dem Format  "[00:]mm:ss".'+#13+
                               'Daten k�nnen nicht importiert werden.'+#13+#13+
                               'Pr�fung fortsetzen?',
                                mtConfirmation,[mbOk,mbCancel]) <> mrOk then
                begin
                  ImportDialog.VorschauGrid.Row := i;
                  ImportDialog.VorschauGrid.Col := VorschauSpalte;
                  Exit; // Abbruch ohne weitere Fehlermeldung
                end;
              end;
          spDisqName: // max. 4 Zeichen
            if Length(DatenArray[i,ImpFeldArr[j].Spalte]) > 4 then
            begin
              Fehler := true;
              if TriaMessage(Self,'Die Bezeichnung der Disqualifikation darf maximal 4 Zeichen beinhalten.'+#13+
                             'Daten k�nnen nicht importiert werden.'+#13+#13+
                             'Pr�fung fortsetzen?',
                              mtConfirmation,[mbOk,mbCancel]) <> mrOk then
              begin
                ImportDialog.VorschauGrid.Row := i;
                ImportDialog.VorschauGrid.Col := VorschauSpalte;
                Exit; // Abbruch ohne weitere Fehlermeldung
              end;
            end;

          else ;
        end;
      end; // i: Zeilen
    end else // keine Zuordnung
      case ImpFeldArr[j].FeldType of
        spName,spVName:
        begin
          TriaMessage(Self,'Das Pflichtfeld "'+ GetFeldNameLang(ImpFeldArr[j])+
                      '" ist nicht zugeordnet.'+#13+
                      'Die Daten k�nnen nicht importiert werden.',
                      mtInformation,[mbOk]);
          Exit; // Abbruch ohne weitere Fehlermeldung
        end;
        else HauptFenster.ProgressBarStep(Length(DatenArray)-1);
      end;
  end; // j: Feldnamen

  if (Length(DatenArray)>1) and (Length(DatenArray[0]) >= cnPflichtFelder) then
  begin
    // pr�fen ob Tln doppel in ImpDatei oder in TlnColl vorhanden sind
    // nur pr�fen, wenn alle Pflichtfelder vorhanden
    ImportDialog.VorschauGrid.Col := 0;
    for i:=1 to Length(DatenArray)-1 do // Zeilen pr�fen
    begin
      HauptFenster.ProgressBarStep(Length(DatenArray)-1);

      if GetImpSpalte(spName) >= 0 then
         NameBuff := DatenArray[i,GetImpSpalte(spName)]
      else NameBuff := '';
      if GetImpSpalte(spVName) >= 0 then
         VNameBuff := DatenArray[i,GetImpSpalte(spVName)]
      else VNameBuff := '';
      if GetImpSpalte(spVerein) >= 0 then
         VereinBuff := DatenArray[i,GetImpSpalte(spVerein)]
      else VereinBuff := '';
      if GetImpSpalte(spMannsch) >= 0 then
         MannschNameBuff := DatenArray[i,GetImpSpalte(spMannsch)]
      else MannschNameBuff := '';
      if GetImpSpalte(spSnr) >= 0 then
         SnrBuff := StrToIntDef(DatenArray[i,GetImpSpalte(spSnr)],0)
      else SnrBuff := 0;
      TlnBuff := Veranstaltung.TlnColl.SucheTln(nil,NameBuff,VNameBuff,VereinBuff,
                                                MannschNameBuff,HauptFenster.SortWettk);

      // pr�fen ob Tln doppelt in Importdatei vorhanden
      if TlnDoppel(NameBuff,VNameBuff,VereinBuff,MannschNameBuff,i) then
      begin
        Fehler := true;
        if TriaMessage(Self,NameBuff+', '+VNameBuff+', '+VereinBuff+', '+MannschNameBuff+#13+#13+
                       'Teilnehmer ist in Importdatei mehrfach vorhanden.'+#13+
                       'Daten k�nnen nicht importiert werden.'+#13+#13+
                       'Pr�fung fortsetzen?',
                        mtConfirmation,[mbOk,mbCancel]) <> mrOk then
        begin
          ImportDialog.VorschauGrid.Row := i;
          Exit; // Abbruch ohne weitere Fehlermeldung
        end;
      end;

      // pr�fen ob Snr vergeben ist
      if (SnrBuff>0) and (Veranstaltung.TlnColl.TlnMitSnr(SnrBuff)<>nil) and
         ((TlnBuff=nil) or (TlnBuff.Snr<>SnrBuff)) then
      begin
        Fehler := true;
        if TriaMessage(Self,'Die Startnummer  "'+DatenArray[i,GetImpSpalte(spSnr)]+
                       '"  ist bereits vergeben.'+#13+#13+
                       'Daten k�nnen nicht importiert werden.'+#13+
                       'Pr�fung fortsetzen?',
                       mtConfirmation,[mbOk,mbCancel]) <> mrOk then
        begin
          ImportDialog.VorschauGrid.Row := i;
          Exit; // Abbruch ohne weitere Fehlermeldung
        end;
      end;

    //  pr�fen ob RfidCode doppelt in ImportDatei vorhanden

    //  pr�fen ob RfidCode vergeben ist


      // pr�fen ob Tln bereits angemeldet
      if not TlnAlleUeberschreiben and (TlnBuff <> nil) then
        case TriaMessage(Self,NameBuff+', '+VNameBuff+', '+VereinBuff+', '+MannschNameBuff+#13+#13+
                         'Teilnehmer mit gleichem Namen, Vornamen und Verein oder Mannschaft '+#13+
                         'wurde bereits f�r den Wettkampf angemeldet.'+#13+#13+
                         'Teilnehmerdaten �berschreiben?',
                          mtConfirmation,[mbYesToAll,mbYes,mbCancel]) of
          mrYes: TlnUeberschreiben := true; // weiter Tln auf Gleichheit pr�fen
          mrYesToAll: TlnAlleUeberschreiben := true;
          else
          begin
            ImportDialog.VorschauGrid.Row := i;
            Exit; // Abbruch ohne weitere Fehlermeldung
          end;
        end;

    end;
  end;
  ImportDialog.VorschauGrid.Row := 1;
  ImportDialog.VorschauGrid.Col := 0;
  if Fehler then Result := 0
  else
  begin
    if TlnUeberschreiben then TlnAlleUeberschreiben := true;
    Result := 1;
    DatenOk := true;
  end;
end;

(*----------------------------------------------------------------------------*)
function TImportDialog.ImportiereDaten: Boolean;
(*----------------------------------------------------------------------------*)
// Pr�fung vorher erfolgreich abgeschlosen
var i,j,SnrBuff : Integer;
    TlnBuff : TTlnObj;
    NameBuff,VNameBuff,VereinBuff,MannschNameBuff,DisqGrundBuff,DisqNameBuff: String;
    ZeitRecCollArrBuff: TZeitRecCollArr;
    StrafZeitBuff,GutschriftBuff : Integer;
    AbsCnt : TWkAbschnitt;

//------------------------------------------------------------------------------
procedure AddiereAufrundZeit(Abs:TWkAbschnitt;Zeit:String);
// Runden in beliebiger Reihenfolge, werden automatisch richtig sortiert
// Zeit auf 1/100 umgerechnet, entsprechend ZeitFormat
begin
  ZeitRecCollArrBuff[Abs].AddZeitRec(-1,UhrzeitWert(Zeit));
end;

//------------------------------------------------------------------------------
procedure SetzeStrtZeit(Zeit:String);
begin
  ZeitRecCollArrBuff[wkAbs1].SetzeZeitRec(0,-1,UhrZeitWert(Zeit));
end;

//------------------------------------------------------------------------------
begin
  Result := false;
  HauptFenster.ProgressBarStep(1);

  Refresh;
  HauptFenster.LstFrame.TriaGrid.StopPaint := true;
  try

    if ImportFormat=ifText then
    begin
      ImportDialog.VorschauGrid.Row := 1;
      ImportDialog.VorschauGrid.Col := 0;
    end;
    for i:=1 to Length(DatenArray)-1 do
    begin

      if GetImpSpalte(spName) >= 0 then
         NameBuff := DatenArray[i,GetImpSpalte(spName)]
      else NameBuff := '';
      if GetImpSpalte(spVName) >= 0 then
         VNameBuff := DatenArray[i,GetImpSpalte(spVName)]
      else VNameBuff := '';
      if GetImpSpalte(spVerein) >= 0 then
         VereinBuff := DatenArray[i,GetImpSpalte(spVerein)]
      else VereinBuff := '';
      if GetImpSpalte(spMannsch) >= 0 then
         MannschNameBuff := DatenArray[i,GetImpSpalte(spMannsch)]
      else MannschNameBuff := '';

      if TlnAlleUeberschreiben then
        TlnBuff := Veranstaltung.TlnColl.SucheTln(nil,NameBuff,VNameBuff,VereinBuff,
                                              MannschNameBuff,HauptFenster.SortWettk)
      else TlnBuff := nil;

      if TlnBuff = nil then // neuer Teilnehmer
      begin
        TlnBuff := TTlnObj.Create(Veranstaltung,Veranstaltung.TlnColl,oaAdd);
        TlnBuff.Name  := NameBuff;
        TlnBuff.VName := VNameBuff;
        TlnBuff.Wettk := HauptFenster.SortWettk; // muss vor Add
        if Veranstaltung.TlnColl.AddItem(TlnBuff) < 0 then Exit;
      end else // vor �berschreiben Init alle Felder wie in Create
      begin
        //spNameExp      : ;
        //spVNameExp     : ;
        TlnBuff.Sex              := cnKeinSex;
        TlnBuff.Jg               := 0;
        //spMannschExp    : ;
        TlnBuff.Strasse          := '';
        TlnBuff.HausNr           := '';
        TlnBuff.PLZ              := '';
        TlnBuff.Ort              := '';
        TlnBuff.Land             := '';
        TlnBuff.Komment          := '';
        TlnBuff.MldZeit          := -1;
        TlnBuff.MschWrtg         := true;
        TlnBuff.MschMixWrtg      := false;
        TlnBuff.SondWrtg         := false;
        TlnBuff.SerienWrtg       := true;
        TlnBuff.UrkDruck         := true;
        TlnBuff.AusKonkAllg      := false;
        TlnBuff.AusKonkAltKl     := false;
        TlnBuff.AusKonkSondKl    := false;
        // TlnBuff.Snr           := 0;  wird sp�ter immer gesetzt
        TlnBuff.SBhn             := 0;
        for AbsCnt:=wkAbs2 to wkAbs8 do
        begin
          TlnBuff.StaffelName[AbsCnt]  := '';
          TlnBuff.StaffelVName[AbsCnt] := '';
        end;
      end;
      TlnBuff.SetzeBearbeitet;
      TriDatei.Modified := true;

      SnrBuff         := 0;
      GutschriftBuff  := 0;
      StrafZeitBuff   := -1;
      DisqGrundBuff   := '';
      DisqNameBuff    := '';
      for AbsCnt:=wkAbs1 to wkAbs8 do
        ZeitRecCollArrBuff[AbsCnt] := TZeitRecColl.Create(Veranstaltung,TlnBuff.Wettk.AbsMaxRunden[AbsCnt]);

      for j:=0 to Length(ImpFeldArr)-1 do
      begin
        if ImpFeldArr[j].Spalte >= 0 then
        begin
          case ImpFeldArr[j].FeldType of
            //spName        : TlnBuff.Name := DatenArray[i,ImpFeldArr[j].Spalte];
            //spVName       : TlnBuff.VName := DatenArray[i,ImpFeldArr[j].Spalte];
            spSex           : TlnBuff.Sex := GetSexOption(DatenArray[i,ImpFeldArr[j].Spalte]);
            spJg            : TlnBuff.Jg := HauptFenster.SortWettk.JgLang(DatenArray[i,ImpFeldArr[j].Spalte]);
            //spMannsch     : NameBuff := DatenArray[i,ImpFeldArr[j].Spalte];
            spStrasse       : TlnBuff.Strasse := DatenArray[i,ImpFeldArr[j].Spalte];
            spEMail         : TlnBuff.EMail := DatenArray[i,ImpFeldArr[j].Spalte];
            spHausNr        : TlnBuff.HausNr := DatenArray[i,ImpFeldArr[j].Spalte];
            spPLZ           : TlnBuff.PLZ := DatenArray[i,ImpFeldArr[j].Spalte];
            spOrt           : TlnBuff.Ort := DatenArray[i,ImpFeldArr[j].Spalte];
            spLand          : TlnBuff.Land := DatenArray[i,ImpFeldArr[j].Spalte];
            spRfid          : TlnBuff.RfidCode := DatenArray[i,ImpFeldArr[j].Spalte];
            spKomment       : TlnBuff.Komment := DatenArray[i,ImpFeldArr[j].Spalte];
            spMeldeZeit     : TlnBuff.MldZeit := UhrzeitWertSek(DatenArray[i,ImpFeldArr[j].Spalte]);
            spStartgeld     : TlnBuff.Startgeld := EuroWert(DatenArray[i,ImpFeldArr[j].Spalte]);
            spMschWrtg      : TlnBuff.MschWrtg := GetOption(spMschWrtg,DatenArray[i,ImpFeldArr[j].Spalte]) = ioTrue;
            spMschMixWrtg   : TlnBuff.MschMixWrtg := GetOption(spMschMixWrtg,DatenArray[i,ImpFeldArr[j].Spalte]) = ioTrue;
            spSondWrtg      : TlnBuff.SondWrtg := GetOption(spSondWrtg,DatenArray[i,ImpFeldArr[j].Spalte]) = ioTrue;
            spSerWrtg       : TlnBuff.SerienWrtg := GetOption(spSerWrtg,DatenArray[i,ImpFeldArr[j].Spalte]) = ioTrue;
            spUrkDr         : TlnBuff.UrkDruck := GetOption(spUrkDr,DatenArray[i,ImpFeldArr[j].Spalte]) = ioTrue;
            spAusKonkAllg   : TlnBuff.AusKonkAllg   := GetOption(spAusKonkAllg,DatenArray[i,ImpFeldArr[j].Spalte])=ioTrue;
            spAusKonkAltKl  : TlnBuff.AusKonkAltKl  := GetOption(spAusKonkAltKl,DatenArray[i,ImpFeldArr[j].Spalte])=ioTrue;
            spAusKonkSondKl : TlnBuff.AusKonkSondKl := GetOption(spAusKonkSondKl,DatenArray[i,ImpFeldArr[j].Spalte])=ioTrue;
            spSnr           : SnrBuff := StrToIntDef(DatenArray[i,ImpFeldArr[j].Spalte],0);
            spStBahn        : TlnBuff.SBhn := StrToIntDef(DatenArray[i,ImpFeldArr[j].Spalte],0);

            spStZeit        : SetzeStrtZeit(DatenArray[i,ImpFeldArr[j].Spalte]);

            spRestStrecke   : TlnBuff.RestStrecke := StrToIntDef(DatenArray[i,ImpFeldArr[j].Spalte],0);

            spStaffelName2..spStaffelName8 :
                              TlnBuff.StaffelName[TWkAbschnitt(Integer(ImpFeldArr[j].FeldType)-Integer(spStaffelName2)+2)] :=
                                DatenArray[i,ImpFeldArr[j].Spalte];

            spStaffelVName2..spStaffelVName8 :
                              TlnBuff.StaffelVName[TWkAbschnitt(Integer(ImpFeldArr[j].FeldType)-Integer(spStaffelVName2)+2)] :=
                                DatenArray[i,ImpFeldArr[j].Spalte];

            spAbs1UhrZeit..spAbs8UhrZeit : // Zeiten in ZeitCollArrBuff
                              AddiereAufrundZeit(TWkAbschnitt(Integer(ImpFeldArr[j].FeldType)-Integer(spAbs1UhrZeit)+1),
                                           DatenArray[i,ImpFeldArr[j].Spalte]);

            spGutschrift    : GutschriftBuff := Max(0,MinZeitWert(DatenArray[i,ImpFeldArr[j].Spalte]));
            spTlnStrafZeit  : StrafZeitBuff  := MinZeitWert(DatenArray[i,ImpFeldArr[j].Spalte]);
            spDisqGrund     : DisqGrundBuff  := DatenArray[i,ImpFeldArr[j].Spalte];
            spDisqName      : DisqNameBuff   := DatenArray[i,ImpFeldArr[j].Spalte];
          end;
        end;
      end;
      TlnBuff.Verein      := VereinBuff; //muss nach Wettk,Sex,Jg
      TlnBuff.MannschName := MannschNameBuff; //muss nach Wettk,Sex,Jg
      TlnBuff.SGrp        := GetSGrp(SnrBuff);  // SGrp g�ltig, wurde vorher gepr�ft
      TlnBuff.Snr         := SnrBuff;
      if TlnBuff.TlnInStatus(stEingeteilt) then //muss nach SGrp,Snr,SBhn
      begin
        TlnBuff.Gutschrift := GutschriftBuff;
        TlnBuff.StrafZeit  := StrafZeitBuff;
        TlnBuff.DisqGrund  := DisqGrundBuff;
        TlnBuff.DisqName   := DisqNameBuff;
        TlnBuff.SetZeitRecCollArr(ZeitRecCollArrBuff);
      end else
      begin
        TlnBuff.Gutschrift := 0;
        TlnBuff.StrafZeit := -1;
        TlnBuff.DisqGrund := '';
        TlnBuff.DisqName  := '';//TlnBuff.Wettk.DisqTxt;
        TlnBuff.ClearZeitRecCollArr;
      end;
      HauptFenster.ProgressBarStep(1);
    end;
    Result := true;

  finally
    for AbsCnt:=wkAbs1 to wkAbs8 do
      FreeAndNil(ZeitRecCollArrBuff[AbsCnt]);
    HauptFenster.CommandDataUpdate;
    HauptFenster.LstFrame.TriaGrid.StopPaint := false;
  end;
end;


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImportDialog.TrennzeichenRGClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Radiogroup statt Groupbox, weil sonst nach Show grunds�tzlich SemikolonRB gesetzt wurde
begin
  if not Updating then
  begin
    Updating := true;

    if Sender = TrennzeichenRG then
      case TrennzeichenRG.ItemIndex of
        0 : TrennZeichen := ';';
        1 : TrennZeichen := Char(VK_TAB);
        2 : TrennZeichen := ',';
        3 : TrennZeichen := ' ';
        else {4}
      end
    else
    if Sender = SonstEdit then
      if TrennzeichenRG.ItemIndex <> 4 then TrennzeichenRG.ItemIndex := 4
      else
    else TrennZeichen := #0;

    if TrennzeichenRG.ItemIndex = 4 then // Anderes
    begin
      if SonstEdit.CanFocus then SonstEdit.SetFocus;
      if Length(SonstEdit.Text) > 0 then TrennZeichen := SonstEdit.Text[1]
                                    else TrennZeichen := #0;
    end else
      SonstEdit.Text := '';

    HauptFenster.ProgressBarInit('Vorschau wird vorbereitet',
                                  TextZeilenColl.Count * 2);
    ClearOptionStrings;
    TxtInitDatenArray(true); // Step ProgressBar pro Zeile
    // Progressbar zu 1/2 voll
    // Progressbar.Max anpassen f�r nachfolgende Aktionen (1 step pro Datenfeld)
    HauptFenster.ProgressBarMaxUpdate(FeldValueListEditor.Strings.Count);
    //HauptFenster.ProgressBarMax := FeldValueListEditor.Strings.Count * 2;
    //HauptFenster.ProgressBarPosition := FeldValueListEditor.Strings.Count;
    InitFeldValueListEditor; // kein Stepping
    UpdateVorschau(true);
    HauptFenster.StatusBarClear;
    Updating := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImportDialog.TextErkZeichenCBChange(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating then
  begin
    Updating := true;

    HauptFenster.ProgressBarInit('Vorschau wird vorbereitet',
                                  TextZeilenColl.Count * 2);
    ClearOptionStrings;
    TxtInitDatenArray(true); // Step ProgressBar pro Zeile
    // Progressbar zu 1/2 voll
    // Progressbar.Max anpassen f�r nachfolgende Aktionen (1 step pro Datenfeld)
    HauptFenster.ProgressBarMaxUpdate(FeldValueListEditor.Strings.Count);
    //HauptFenster.ProgressBarMax := FeldValueListEditor.Strings.Count * 2;
    //HauptFenster.ProgressBarPosition := FeldValueListEditor.Strings.Count;
    InitFeldValueListEditor; // kein Stepping
    UpdateVorschau(true);
    HauptFenster.StatusBarClear;
    Updating := false;
  end;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TImportDialog.FeldValueListEditorStringsChange(Sender: TObject);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
var Indx : Integer;
begin
  if not Updating then
  begin
    Indx := FeldValueListEditor.Row-1;
    if Indx >= 0 then
    begin
      SetFeldStr(ImpFeldArr[Indx].FeldType,ioTrue,'');
      SetFeldStr(ImpFeldArr[Indx].FeldType,ioFalse,'');
      SetFeldStrValid(ImpFeldArr[Indx].FeldType,ioTrue,false);
      SetFeldStrValid(ImpFeldArr[Indx].FeldType,ioFalse,false);
    end;
    UpdateVorschau(false); // kein Stepping
  end;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TImportDialog.FeldValueListEditorClick(Sender: TObject);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
begin
  // damit Col ge�ndert wird
  if not Updating then UpdateVorschau(false); // kein Stepping
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TImportDialog.VorschauGridClick(Sender: TObject);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
var i,Indx : Integer;
begin
  if not Updating then
  begin
    Updating := true;
    Indx := -1;
    for i:=0 to FeldValueListEditor.Strings.Count-1 do
      if GetDatenArrayIndex(i) >= 0 then
      begin
        Inc(Indx);
        if Indx = VorschauGrid.Col then
          FeldValueListEditor.Row := Indx + 1; // 1 FixedRow
      end;
    Updating := false;
  end;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TImportDialog.PruefButtonClick(Sender: TObject);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
var Buf : Int64;
begin
  // Progressbar
  Buf := Length(ImpFeldArr)*(Length(DatenArray)-1);
  if (Length(DatenArray)>1) and (Length(DatenArray[0]) >= cnPflichtFelder) then
    Buf := Buf + (Length(DatenArray)-1)*(Length(DatenArray)-1);
  HauptFenster.ProgressBarInit('Daten aus der Importdatei werden gepr�ft',Buf);
  try
    case PruefeDaten of
      1: TriaMessage(Self,'Die Pr�fung ist abgeschlossen.'+#13+
                     'Die Daten k�nnen importiert werden.',
                       mtInformation,[mbOk]);
      0: TriaMessage(Self,'Die Pr�fung ist abgeschlossen.'+#13+
                     'Die Daten k�nnen nicht importiert werden.',
                      mtInformation,[mbOk]);
      else ; // bei Abbruch keine weitere Meldung
    end;
  finally
    HauptFenster.StatusBarClear;
  end;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TImportDialog.ImportButtonClick(Sender: TObject);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
// SortWettk <> WettkAlleDummy
begin
  if TriaMessage(Self,'Daten von Importdatei  "'+ExtractFileName(ImportDatei)+
                 '"  nach Wettkampf  "'+HauptFenster.SortWettk.Name+
                 '"  importieren?',
                   mtConfirmation,[mbOk,mbCancel]) = mrOk then
  try
    // Progressbar
    if not DatenOk then // zuerst pr�fen
    begin
      HauptFenster.ProgressBarInit('Daten aus Importdatei werden gepr�ft',
                                   (Length(ImpFeldArr)*(Length(DatenArray)-1)+
                                   (Length(DatenArray)-1)*(Length(DatenArray)-1))*2);
      case PruefeDaten of
        0:
        begin
          TriaMessage(Self,'Die Daten k�nnen nicht importiert werden.',
                       mtInformation,[mbOk]);
          Exit;
        end;
        1: ; //DatenOk
        else Exit;// -1: Abbruch
      end;
    end;

    // Daten sind Ok
    if HauptFenster.ProgressBar.Visible then // Pr�fung durchgef�hrt
    begin
      HauptFenster.ProgressBarText('Daten aus Datei  "'+
                                   ExtractFileName(ImportDatei)+
                                   '"  werden importiert');
      HauptFenster.ProgressBarMaxUpdate(Length(DatenArray)-1);
    end else
      HauptFenster.ProgressBarInit('Daten aus Datei  "'+
                                   ExtractFileName(ImportDatei)+
                                   '"  werden importiert',
                                   Length(DatenArray)-1);

    if ImportiereDaten then
    begin
      TriaMessage(Self,'Der Datenimport wurde erfogreich beendet.',
                   mtInformation,[mbOk]);
      // TriDatei.Modified := true; wird in ImportiereDaten gesetzt
      ModalResult := mrOk;
    end else
      TriaMessage(Self,'Fehler beim Datenimport.',mtInformation,[mbOk]);

  finally
    HauptFenster.StatusBarClear;
  end;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TImportDialog.CancelButtonClick(Sender: TObject);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
begin
  ModalResult := mrCancel; (* Pr�fung in FormCloseQuery *)
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TImportDialog.HilfeButtonClick(Sender: TObject);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
begin
  if ImportFormat=ifExcel then
    Application.HelpContext(3600)  // Excel-DateiImport
  else
  if ImportFormat=ifText then
    Application.HelpContext(3650);  // Text-DateiImport
end;

end.

