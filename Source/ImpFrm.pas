unit ImpFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons,ToolWin, ActnMan, ActnCtrls, Mask, Math,
  AllgConst,AllgFunc,AllgObj,AllgComp,WettkObj,AkObj,TlnObj,MannsObj,SMldObj;

procedure DatenImportieren;

type
  TImpFrame = class(TFrame)
    ImpFrmPanel: TPanel;
    ImpHeaderPanel: TPanel;
      ImpHeaderLabel: TLabel;
    BtnPanel: TPanel;
      biHelpBtn: TBitBtn;
      biSystemBtn: TBitBtn;
    ImpQuelleGB: TGroupBox;
      ImpDateiLabel: TLabel;
      ImpDateiEdit: TTriaEdit;
      ImpVeranstLabel: TLabel;
      ImpVeranstEdit: TTriaEdit;
      ImpOrtLabel: TLabel;
      ImpOrtCB: TComboBox;
      ImpWettkLabel: TLabel;
      ImpWettkCB: TComboBox;
    TlnStatusRG: TRadioGroup;
    ImpTlnGB: TGroupBox;
      ImpTlnNameLabel: TLabel;
      NameEdit: TTriaEdit;
      ImpTlnVNameLabel: TLabel;
      VNameEdit: TTriaEdit;
      ImpTlnSexLabel: TLabel;
      SexCB: TComboBox;
      ImpTlnJgLabel: TLabel;
      JgEdit: TTriaMaskEdit;
      ImpTlnLandLabel: TLabel;
      LandEdit: TTriaEdit;
      ImpTlnVereinLabel: TLabel;
      VereinCB: TComboBox;
      ImpTlnMschLabel: TLabel;
      MschCB: TComboBox;
    ImpModusGB: TGroupBox;
      TlnNeuRB: TRadioButton;
      TlnwahlRB: TRadioButton;

    ImpStartButton: TButton;
    ImpCloseButton: TBitBtn;
    HilfeButton: TButton;
    WeiterButton: TButton;

    procedure ImpStartButtonClick(Sender: TObject);
    procedure ImpCloseButtonClick(Sender: TObject);
    procedure ImpDatenCBCloseUp(Sender: TObject);
    procedure HilfeButtonClick(Sender: TObject);
    procedure biHelpBtnClick(Sender: TObject);
    procedure ImpTlnChange(Sender: TObject);
    procedure ImpTlnCloseUp(Sender: TObject);
    procedure SexCBDropDown(Sender: TObject);
    procedure VereinCBDropDown(Sender: TObject);
    procedure MschCBDropDown(Sender: TObject);
    //procedure SMldCBDropDown(Sender: TObject);
    procedure WeiterButtonClick(Sender: TObject);

  protected
    HelpFensterAlt   : TWinControl;
    ClientHeightMax  : Integer;
    ClientHeightMin  : Integer;
    QuellTln         : TTlnObj;
    LeereDatei       : Boolean;
    SGrpUebernehmen  : Boolean;
    ImportierteTln   : Integer; // Summe Hinzugef�gt + Ersetzt
    HinzugefuegteTln : Integer;
    WettkUebernehmen : Boolean;
    ImpTlnIndex      : Integer;
    LetzteTln        : TTlnObj;  //der letzte gefundene Tln in Veranstaltung.Tlncoll

    procedure SetImpDatenGB;
    procedure SetImpTlnGB;
    procedure ClearImpDatenGB;
    procedure ClearImpTlnGB;
    function  GetImpWettk: TWettkObj;
    function  GetImpTlnMode: TImpTlnMode;
    function  GetZielMschPtr(AkWrtg:TKlassenWertung): TMannschObj;
    //function  GetImpSMld: TSMldObj;
    procedure ImpTlnExit;
    procedure SetImpEnable(Bool:Boolean);
    procedure SetImpTlnEnable(Bool:Boolean);
    function  GetImpTlnStatus: TStatus;
    procedure CustomAlignPosition(Control: TControl;

    var NewLeft,NewTop,NewWidth,NewHeight: Integer;
    var AlignRect:TRect; AlignInfo:TAlignInfo); override;

  public
    Updating      : Boolean;
    ZielTln       : TTlnObj;
    ImpTlnEnabled : Boolean;
    ImpTlnVisible : Boolean;
    ImpZeitFormat : TZeitFormat;
    constructor Create(AOwner: TComponent); override;
    procedure Oeffnen;
    procedure Schliessen;
    procedure SetImpTlnFontStyle;
    function  Importieren: Boolean;
    function  ImportiereTln(var Tln:TTlnObj): Boolean;
    function  InpTlnVisible: Boolean;
  end;

var ImportDatei : String;
    QuellWettk  : TWettkObj;

implementation

uses TriaMain,VeranObj,DateiDlg,CmdProc,SGrpObj,ImpDlg, ImpFmtDlg,
     WkWahlDlg, TlnErg,VistaFix;

{$R *.dfm}

//******************************************************************************
procedure DatenImportieren;
//******************************************************************************
var Dir: String;
    FilterIndx: Integer;
//..............................................................................
function GetImportFormat: TImpDateiFormat;
var Ext : String;
begin
  Ext := SysUtils.ExtractFileExt(ImportDatei);
  Result := ImpDateiFormat(Ext);
  if Result = ifKein then
  begin
    ImpFmtDialog := TImpFmtDialog.Create(HauptFenster);
    try
      ImpFmtDialog.DateiEdit.Text := ImportDatei;
      ImpFmtDialog.DateiRG.ItemIndex := 0;
      if ImpFmtDialog.ShowModal = mrOk then
        case ImpFmtDialog.DateiRG.ItemIndex of
          0: Result := ifTria;
          1: Result := ifText;
          2: Result := ifExcel;
          else Result := ifKein;
        end
      else Result := ifKein;
    finally
      FreeAndNil(ImpFmtDialog);
    end;
  end;
end;
//..............................................................................
begin
  // ZielWettk (=Hauptfenster.Sortwettk) f�r Import definieren
  if (HauptFenster.SortWettk = WettkAlleDummy) or
     (HauptFenster.SortWrtg=wgSondWrtg)and(Veranstaltung.WettkColl.Count>1) then
  begin
    WkWahlDialog := TWkWahlDialog.Create(HauptFenster);
    try
      if (WkWahlDialog.ShowModal = mrOk) and
         (WkWahlDialog.WettkSelected <> nil) then
        HauptFenster.InitAnsicht(Veranstaltung.Ort,anAnmEinzel,smTlnName,
                                 WkWahlDialog.WettkSelected,
                                 wgStandWrtg,cnSexBeide,AkAlle,stGemeldet)
      else Exit;
    finally
      FreeAndNil(WkWahlDialog);
    end;
  end;

  ImportDatei := '';
  if ImportDir <> '' then Dir := ImportDir
                     else Dir := SysUtils.ExtractFileDir(TriDatei.Path);
  FilterIndx := 1;
  if OpenFileDialog('*', // ohne Punkt
                    'Alle Dateien (*.*)|*.*|'+
                    'Tria Dateien ('+ImpExtFilter(ifTria)+')|'+ImpExtfilter(ifTria)+'|'+
                    'Textdateien ('+ImpExtFilter(ifText)+')|'+ImpExtFilter(ifText)+'|'+
                    'Excel Dateien ('+ImpExtFilter(ifExcel)+')|'+ImpExtFilter(ifExcel),
                    Dir,
                    FilterIndx, // Type Alle Dateien
                    'Importdatei �ffnen',
                    ImportDatei) then
  begin
    HauptFenster.Refresh;
    ImportDir := SysUtils.ExtractFileDir(ImportDatei);
    case GetImportFormat of
      ifTria  : HauptFenster.ImpFrame.Oeffnen;
      ifText  : ImportiereDatei(ifText);
      ifExcel : ImportiereDatei(ifExcel);
      else HauptFenster.Refresh;  // ftKein
    end;
  end else HauptFenster.Refresh;
end;

// public methoden

//==============================================================================
constructor TImpFrame.Create(AOwner: TComponent);
//==============================================================================
// Create wird von HauptFenster.Create automatisch aufgerufen
begin
  inherited Create(AOwner);

  Align := alTop;
  ImpFrmPanel.Align := alClient;
  Visible := false;
  ImpTlnEnabled := false;
  ClearImpDatenGB;
  ClearImpTlnGB;
  //Updating := false;
  // 1.4.05: nach Create wird ImpTlnChange ausgel�st und f�hrt
  //         zum Abst�rz. Wieso fr�her nie gesehen ????
  //         und nachher auch nicht mehr ????
  //         hat Hide vielleicht das Event ausgel�st? Deshalb visible=false
  Updating := true; // deshalb wird Updating true gesetzt nach ClearImpTlnGB
  ClientHeightMax := ClientHeight;
  ClientHeightMin := ImpTlnGB.Top;
  ImpTlnVisible   := false;
  ImpZeitFormat   := zfSek;
  SetzeFonts(ImpHeaderLabel.Font);
  SetzeFonts(NameEdit.Font);
  SetzeFonts(VNameEdit.Font);
  SetzeFonts(SexCB.Font);
  SetzeFonts(JgEdit.Font);
  SetzeFonts(LandEdit.Font);
  SetzeFonts(VereinCB.Font);
  SetzeFonts(MschCB.Font);
  //SetzeFonts(SMldCB.Font);
  //Hide;
end;

//==============================================================================
procedure TImpFrame.Oeffnen;
//==============================================================================
// Start von fmTria-ImportFunktion aus TriaMain via Proc. DatenImportieren
// Funktion immer �ber Schliessen beenden
var S1,S2: String;
begin
  ImportierteTln := 0; // Summe Hinzugef�gt + Ersetzt
  HinzugefuegteTln := 0;
  FreeAndNil(EinlVeranst);

  // Datei in EinlVeranst einlesen
  // es kann auch die eigene Datei selektiert werden
  TriDatLaden(ImportDatei);
  HauptFenster.StatusBarClear;
  if not Assigned(EinlVeranst) then Exit;
  // TriDatLaden = true
  if Veranstaltung.Serie and not EinlVeranst.Serie then
  begin
    TriaMessage('Es k�nnen nur Daten von Serienveranstaltungen '+
                'importiert werden.',mtInformation,[mbOk]);
    Schliessen;
    Exit;
  end;
  if ImpZeitFormat > ZeitFormat then
  begin
    case ImpZeitFormat of
      zfZehntel     : S1 := 'Zehntel-Sekunden';
      zfHundertstel : S1 := 'Hundertstel-Sekunden';
      else            S1 := 'Sekunden';
    end;
    case ZeitFormat of
      zfZehntel     : S2 := 'Zehntel-Sekunden';
      zfHundertstel : S2 := 'Hundertstel-Sekunden';
      else            S2 := 'Sekunden';
    end;
    if TriaMessage('Die Zeiten in der Importdatei sind in '+S1+' definiert.' +#13+
                   'Diese werden als '+S2+' importiert.',
                   mtConfirmation,[mbOk,mbCancel]) <> mrOk then
    begin
      Schliessen;
      Exit;
    end;
  end;

  // Frame �ffnen und ggf. Daten Importieren
  ImpTlnIndex  := -1;
  QuellTln := nil;
  ZielTln := nil;
  HauptFenster.ActionToolBar.Visible := false;
  Visible := true; // Visible vor ClientHeight-�nderung, sonst stimmt Bild nicht
  ClientHeight := ClientHeightMin;
  //HauptFenster.ImpDateiButton.Enabled := true;
  //HauptFenster.ImpDateiButton.SetFocus;
  //HauptFenster.TlnStatusRG.ItemIndex := -1;
  HauptFenster.InitAnsicht(Veranstaltung.Ort,anAnmEinzel,smTlnName,
                           HauptFenster.SortWettk,wgStandWrtg,cnSexBeide,AkAlle,
                           stGemeldet); // incl. SetzeCommands
  ImpCloseButton.Enabled := true;
  ImpDateiEdit.Text := ImportDatei;
  SetImpEnable(true);
  SetImpTlnEnable(false);
  SetImpDatenGB;
  HelpFensterAlt := HelpFenster;
  HelpFenster := Self;
  //HauptFenster.ImpDateiButton.Enabled := false;
end;

//==============================================================================
procedure TImpFrame.Schliessen;
//==============================================================================
// beendet Import-Funktion
begin
  HauptFenster.ProgressBarStehenLassen := false;
  HauptFenster.StatusBarClear;
  if Assigned(EinlVeranst) then
  begin
    HauptFenster.ProgressBarInit('Datei  "'+ImportDatei+'"  wird geschlossen',
                  EinlVeranst.ObjSize);
    EinlVeranst.Free;
    EinlVeranst := nil;
    HauptFenster.StatusBarClear;
  end;
  ClearImpDatenGB;
  ClearImpTlnGB;
  HauptFenster.ActionToolBar.Visible := true;
  Visible := false;
  //HauptFenster.ImpTlnFrame.Visible := false;
  HauptFenster.RefreshAnsicht;
  HauptFenster.LstFrame.TriaGrid.ItemIndex := 0;
  HauptFenster.FocusedTln := HauptFenster.LstFrame.TriaGrid.FocusedItem;
  SetImpTlnEnable(false);
  SetzeCommands;
  HelpFenster := HelpFensterAlt;
  if Rechnen then BerechneRangAlleWettk;
  MenueCommandActive := false;
end;

//==============================================================================
function TImpFrame.Importieren: Boolean;
//==============================================================================
// wird zuerst von ExecuteImportCmd (ImpCmdButton) aufgerufen
// unterbrochen wenn Tln nicht gefunden: ImpTlnToolBar ge�ffnet
// bis Tln-Suche �ber ImpTlnButton/ExcuteImpTlnCmd abgeschlossen
// beide TlnColl gleich sortiert
var TlnNeu    : TTlnObj;
//------------------------------------------------------------------------------
function SucheQuellTln: Boolean;
//------------------------------------------------------------------------------
// f�r Serie
// true wenn gefunden, ZielTln ist gefundene oder n�chster Tln
// Vergleichen von Name, VName, Jg,Sex, Verein, MschName  //,SMldName,-VName,-Verein
// Suchen ab ZielIndex, damit doppelte Namen mit unterschiedlichen Verein oder MschNamen  ??????
// nicht als Unterschied gemeldet werden.
var i,X,StartIdx : Integer;
    NameGefunden : Boolean;
//..............................................................................
function SexStr(Tln:TTlnObj): String;
begin
  case Tln.Sex of
    cnMaennlich : Result := 'M';
    cnWeiblich  : Result := 'W';
    else Result := '-';
  end;
end;
//..............................................................................
function TlnString(Tln:TTlnObj): String;
begin
  with Tln do
    {if SMld = nil then
      Result := VName+GetJgStr2+SexStr(Tln)+Land+MannschName+' '
    else Result := VName+GetJgStr2+SexStr(Tln)+Land+MannschName+
                                 SMld.Name+SMld.VName+SMld.MannschName;}
    Result := VName+GetJgStr2+SexStr(Tln)+Land+Verein+MannschName;
end;
//..............................................................................
begin
  Result := false;
  NameGefunden := false;
  if LetzteTln <> nil then
    StartIdx := Veranstaltung.TlnColl.SortIndexOf(LetzteTln) +1
  else StartIdx := 0;
  with Veranstaltung.TlnColl do
  begin
    for i:=StartIdx to SortCount-1 do
    begin
      // Tln mit AnsiCompareStr sortiert, andere Reihenfolge bei CompareStr
      // deshalb CompareStr nur f�r exakter Vergleich benutzen
      X := AnsiCompareStr(SortItems[i].Name,QuellTln.Name);
      if X < 0 then Continue; // n�chste Tln vergleichen
      if X > 0 then // Tln nicht gefunden
      begin
        // wenn Name bereits vorher gefunden wurde, bleibt ZielTln unver�ndert
        if not NameGefunden then ZielTln := SortItems[i];
        Exit;
      end;
      // X = 0  ==> Name = gleich, aber Unterschied ss/� ignoriert
      X := CompareStr(SortItems[i].Name,QuellTln.Name);
      if X < 0 then Continue;
      if X > 0 then // Tln nicht gefunden
      begin
        // wenn Name bereits vorher gefunden wurde, bleibt ZielTln unver�ndert
        if not NameGefunden then ZielTln := SortItems[i];
        Exit;
      end;
      // X = 0  ==>  Name exakt gleich, restliche Daten vergleichen
      NameGefunden := true;
      ZielTln := SortItems[i];
      X := AnsiCompareStr(TlnString(SortItems[i]),TlnString(QuellTln));
      if X < 0 then Continue; // n�chste Tln vergleichen
      if X > 0 then Exit; // Tln nicht vorhanden
      // X = 0  ==>  Tln gefunden, aber Unterschied ss/� ignoriert
      X := CompareStr(TlnString(SortItems[i]),TlnString(QuellTln));
      if X < 0 then Continue;
      if X > 0 then Exit; // Tln nicht vorhanden
      // X = 0  ==>  exakt gleich
      Result := true;
      LetzteTln := ZielTln;
      Exit;
    end;
    // letzte Tln nicht gefunden
    ZielTln := SortItems[SortCount-1];
  end;
end;
//------------------------------------------------------------------------------
begin
  //Result := false;   Compiler-Warnung vermeiden
  if ImpTlnIndex = -1 then
  // erster Aufruf aus ExecuteImportCommand, keine spezielle Aktion
  begin
  end;

  HauptFenster.LstFrame.TriaGrid.StopPaint := true;
  try
    (* TlnColl einlesen *)
    while ImpTlnIndex < EinlVeranst.TlnColl.SortCount-1 do
    begin
      Inc(ImpTlnIndex);
      HauptFenster.ProgressBarStep(1);
      HauptFenster.StatusBarText('','Es wurden Daten von '+IntToStr(ImportierteTln) +
                                   ' Teilnehmer importiert, davon ' +
                                   IntToStr(HinzugefuegteTln) +
                                   ' Teilnehmer hinzugef�gt.');

      QuellTln := EinlVeranst.TlnColl.SortItems[ImpTlnIndex];

      if LeereDatei then
      begin
        (* noch keine Teilnehmer definiert, dann immer importieren *)
        // Create ImportTln als neuer Tln
        TlnNeu := TTlnObj.Create(Veranstaltung,Veranstaltung.TlnColl,oaAdd);
        Veranstaltung.TlnColl.AddItem(TlnNeu); // zuerst, wegen SMldNeu.TlnListe  ?????
        if not ImportiereTln(TlnNeu) then
        begin
          Veranstaltung.TlnColl.ClearItem(TlnNeu);
          Result := false;
          Exit;
        end;
        Inc(ImportierteTln); // Summe Hinzugef�gt + Ersetzt
        Inc(HinzugefuegteTln);
      end else
      if not Veranstaltung.Serie then
      begin
        (* bei non-Serie immer importieren, aber doppelte Tln vermeiden *)
        // pr�fen ob QuellTln bereits vorhanden ist
        ZielTln := Veranstaltung.TlnColl.SucheTln(nil,QuellTln.Name,QuellTln.VName,
                                                  QuellTln.Verein,QuellTln.MannschName,
                                                  HauptFenster.SortWettk);
        if ZielTln = nil then  // QuellTln nicht vorhanden
        begin
          // Create ImportTln als neuer Tln
          TlnNeu := TTlnObj.Create(Veranstaltung,Veranstaltung.TlnColl,oaAdd);
          Veranstaltung.TlnColl.AddItem(TlnNeu); // zuerst, wegen SMldNeu.TlnListe
          if not ImportiereTln(TlnNeu) then
          begin
            Veranstaltung.TlnColl.ClearItem(TlnNeu);
            Result := false;
            Exit;
          end;
          Inc(ImportierteTln);
          Inc(HinzugefuegteTln);
        end else // QuellTln bereits vorhanden, Anwender muss entscheiden
        begin
          HauptFenster.LstFrame.TriaGrid.CollectionUpdate;
          HauptFenster.LstFrame.TriaGrid.Refresh;
          SetImpTlnGB; // Unterbrechung: Warten auf manuelle Eingabe
          Result := true;
          Exit;
        end;
      end else  // Serie
        if not SucheQuellTln then
        // QuellTln in ZielDatei nicht gefunden, Anwender muss entscheiden
        begin
          // Tln kann trotzdem vorhanden sein, wenn Name,VName gleich sind
          HauptFenster.LstFrame.TriaGrid.CollectionUpdate;
          HauptFenster.LstFrame.TriaGrid.Refresh;
          SetImpTlnGB; // Unterbrechung: Warten auf manuelle Eingabe
          Result := true;
          Exit;
        end else (* Tln gefunden, Daten immer �bernemen *)
        begin
          if not ImportiereTln(ZielTln) then
          begin
            Result := false;
            Exit;
          end;
          Inc(ImportierteTln);
          HauptFenster.LstFrame.TriaGrid.Refresh;
        end;
    end;

    HauptFenster.StatusBarText('','Es wurden Daten von '+IntToStr(ImportierteTln) +
                                  ' Teilnehmer importiert, davon ' +
                                   IntToStr(HinzugefuegteTln) +
                                  ' Teilnehmer hinzugef�gt.');
    ImpTlnExit;  // Ende
    Result := true;
  finally
    HauptFenster.LstFrame.TriaGrid.StopPaint := false;
  end;
  // zur�ck nach ImportFrame
end;


//==============================================================================
function TImpFrame.ImportiereTln(var Tln:TTlnObj): Boolean;
//==============================================================================
var NameNeu  : String;
    VNameNeu : String;
    SMldNeu  : TSMldObj;
    VereinNeu : String;
    MschNeu  : String;
    JgNeu    : Integer;
    LandNeu  : String;
    SMldNeuCreated: Boolean;
    SGrpBuff : TSGrpObj;
    Abs      : TWkAbschnitt;
    i        : Integer;

//..............................................................................
function GetSexNeu: TSex;
begin
  if ImpTlnEnabled then
    case SexCB.ItemIndex of
      1: Result := cnMaennlich;
      2: Result := cnWeiblich;
      else Result := cnKeinSex;
    end
  else Result := QuellTln.Sex;
end;

//..............................................................................
function GetSMldNeu: TSMldObj;
//..............................................................................
function CreateSMld: TSMldObj;
begin
  Result := TSMldObj.Create(Veranstaltung,Veranstaltung.SMldColl,oaAdd);
  Veranstaltung.SMldColl.AddItem(Result);
  Result.Init(QuellTln.SMld.Name,QuellTln.SMld.VName,
              QuellTln.SMld.Strasse,QuellTln.SMld.HausNr,
              QuellTln.SMld.PLZ,QuellTln.SMld.Ort,
              QuellTln.SMld.MannschName,QuellTln.SMld.EMail);
  SMldNeuCreated := true;
end;
//..............................................................................
begin
  {if ImpTlnEnabled then
    if (SMldCB.ItemIndex = 0) and
       (SMldCB.Items.Count = Veranstaltung.SMldColl.SortCount+1) or
       (SMldCB.ItemIndex = 1) and
       (SMldCB.Items.Count = Veranstaltung.SMldColl.SortCount+2) then
      Result := nil // kein SMld ausgew�hlt
    else if SMldCB.ItemIndex = 0 then
      Result := CreateSMld // QuellTln.SMld nicht vorhanden
    else // vorhandener SMld
      if SMldCB.Items.Count = Veranstaltung.SMldColl.SortCount+1 then
        Result := Veranstaltung.SMldColl.SortItems[SMldCB.ItemIndex-1]
      else Result := Veranstaltung.SMldColl.SortItems[SMldCB.ItemIndex-2]
  else // not ImpTlnToolBar.Enabled, kann aber Visible sein}
    if QuellTln.SMld <> nil then
    begin
      Result := Veranstaltung.SMldColl.GetSMld(QuellTln.SMld.Name,
                                               QuellTln.SMld.VName,
                                               QuellTln.SMld.MannschName);
      if Result = nil then Result := CreateSMld;
    end else Result := nil;
end;

//..............................................................................
begin
  Result := false;

  if HauptFenster.ImpFrame.ImpTlnEnabled and // Eingabe von ImpTlnToolBar
     not StrGleich(QuellTln.MannschName,'') and not StrGleich(MschCB.Text,cnKein) and
     not StrGleich(QuellTln.MannschName,MschCB.Text) and
     Veranstaltung.TlnColl.AlleMschNamenErsetzenErlaubt(
          QuellTln.MannschName,Trim(MschCB.Text),HauptFenster.SortWettk) then
    case TriaMessage('Mannschaft "'+QuellTln.MannschName+
                     '" f�r alle importierten Teilnehmer durch '+#13+
                     'Mannschaft "'+Trim(MschCB.Text)+'" ersetzen?',
                      mtConfirmation,[mbYes,mbNo,mbCancel]) of
      mrYes:
        EinlVeranst.TlnColl.AlleMschNamenErsetzen(QuellTln.MannschName,MschCB.Text,QuellWettk);
      mrNo: ;
      else Exit; // Result false
    end;

  SMldNeuCreated := false;
  SMldNeu := GetSMldNeu;
  {if ImpTlnEnabled and // Eingabe von ImpTlnToolBar
     (QuellTln.SMld <> nil) and (SMldNeu <> nil) and
     ((QuellTln.SMld.Name<>SMldNeu.Name)or
      (QuellTln.SMld.VName<>SMldNeu.VName)or
      (QuellTln.SMld.MannschName<>SMldNeu.MannschName)) then
    case TriaMessage('Sammelmelder "'+QuellTln.SMld.NameVName+
                     '" f�r alle importierten Teilnehmer durch '+#13+
                     'Sammelmelder "'+SMldNeu.NameVName+'" ersetzen?',
                      mtConfirmation,[mbYes,mbNo,mbCancel]) of
      mrYes:
        //Result := true; Compiler-Warnung vermeiden
        QuellTln.SMld.Init(SMldNeu.Name,SMldNeu.VName,
                          SMldNeu.Strasse,SMldNeu.HausNr,
                          SMldNeu.PLZ,SMldNeu.Ort,
                          SMldNeu.MannschName,SMldNeu.EMail);
      mrNo: ;
      else
      begin
        if SMldNeuCreated then Veranstaltung.SMldColl.ClearItem(SMldNeu);
        Exit; // Result false
      end;
    end;}

  Result := true;

  if ImpTlnEnabled then
  begin
    NameNeu   := Trim(NameEdit.Text);
    VNameNeu  := Trim(VNameEdit.Text);
    VereinNeu := Trim(VereinCB.Text);
    MschNeu   := Trim(MschCB.Text);
    JgNeu     := StrToIntDef(JgEdit.Text,0);
    LandNeu   := Trim(LandEdit.Text);
  end else
  begin
    NameNeu   := QuellTln.Name;
    VNameNeu  := QuellTln.VName;
    VereinNeu := QuellTln.Verein;
    MschNeu   := QuellTln.MannschName;
    JgNeu     := QuellTln.Jg;
    LandNeu   := QuellTln.Land;
  end;
  Tln.SetTlnAllgDaten(NameNeu,VNameNeu,
                      QuellTln.NameAbsArr,QuellTln.VNameAbsArr,
                      QuellTln.Strasse,QuellTln.HausNr,
                      QuellTln.PLZ,QuellTln.Ort,QuellTln.EMail,
                      GetSexNeu,JgNeu,LandNeu,VereinNeu,MschNeu,SMldNeu,
                      HauptFenster.SortWettk,
                      QuellTln.SerienWrtg,
                      QuellTln.MschWrtg,
                      QuellTln.MschMixWrtg);
  Tln.SetzeBearbeitet;
  // neuer MannschName wird in Veranstaltung.MannschNameColl aufgenommen !!
  case GetImpTlnStatus of
    stGemeldet   : Tln.CopyAnmeldungsDaten(QuellTln);
    stEingeteilt : Tln.CopyEinteilungsDaten(QuellTln);
    stAbs1Start  : Tln.CopyErgebnisDaten(QuellTln);
  end;

  if ImpZeitFormat > ZeitFormat then
    for Abs:=wkAbs1 to wkAbs8 do
      if Tln.Wettk.AbschnZahl >= Integer(Abs) then // Abs definiert
        with Tln.GetZeitRecColl(Abs) do
        for i:=0 to Count-1 do // auch Startzeit
          if Items[i].AufrundZeit > 0 then
            SetzeZeitRec(i,-1,UhrZeitRunden(Items[i].AufrundZeit));

  if QuellTln.SGrp <> nil then
    if (GetImpTlnStatus=stEingeteilt) or (GetImpTlnStatus=stAbs1Start) then
      if SGrpUebernehmen then
        Tln.SGrp:= QuellTln.SGrp.LoadPtr
      else
      begin
        SGrpBuff := Veranstaltung.SGrpColl.SGrpMitSnr(HauptFenster.SortWettk,QuellTln.Snr);
        if SGrpBuff <> nil then
          Tln.SGrp := SGrpBuff
        else //sollte nicht vorkommen,weil vorher gepr�ft - 2006:bei Snr=0
        begin
          Tln.SGrp := nil;
          Tln.Snr := 0;
        end;
      end;

  Tln.MannschAllePtr := GetZielMschPtr(kwAlle);
  Tln.MannschSexPtr  := GetZielMschPtr(kwSex);
  Tln.MannschAkPtr   := GetZielMschPtr(kwAltKl);

  //QuellTln.LoadPtr := Tln; (* Buffer f�r MannschColl *)
end;

//==============================================================================
procedure TImpFrame.SetImpTlnFontStyle;
//==============================================================================
var Foc : Boolean;
begin
  with HauptFenster do
  begin
    if StrGleich(ZielTln.Name,NameEdit.Text)and(NameEdit.Font.Style=[fsBold]) or
       not StrGleich(ZielTln.Name,NameEdit.Text)and(NameEdit.Font.Style=[]) then
       // IntToStr nicht benutzen, weil bei ung�ltige zahl exception
    begin
      if NameEdit.Focused then Foc := true else Foc := false;
      //NameEdit.Hide;  // damit Farbrand verschwindet
      if not StrGleich(ZielTln.Name,NameEdit.Text) then
      begin
        NameEdit.Font.Style := [fsBold];
        //NameEdit.Font.Color := clWhite;
      end else
      begin
        NameEdit.Font.Style := [];
        //NameEdit.Font.Color := clWindowText; //Black statt WindowText ??;
      end;
      //NameEdit.Show;
      if Foc then NameEdit.SetFocus;
    end;
    if StrGleich(ZielTln.VName,VNameEdit.Text)and(VNameEdit.Font.Style=[fsBold]) or
       not StrGleich(ZielTln.VName,VNameEdit.Text)and(VNameEdit.Font.Style=[]) then
    begin
      if VNameEdit.Focused then Foc := true else Foc := false;
      //VNameEdit.Hide;
      if not StrGleich(ZielTln.VName,VNameEdit.Text) then
      begin
        VNameEdit.Font.Style := [fsBold];
        //VNameEdit.Font.Color := clWhite;
      end else
      begin
        VNameEdit.Font.Style := [];
        //VNameEdit.Font.Color := clWindowText;
      end;
      //VNameEdit.Show;
      if Foc then VNameEdit.SetFocus;
    end;
    if (IntToStr(ZielTln.Jg)=JgEdit.Text)and(JgEdit.Font.Style=[fsBold]) or
       (IntToStr(ZielTln.Jg)<>JgEdit.Text)and(JgEdit.Font.Style=[]) then
    begin
      if JgEdit.Focused then Foc := true else Foc := false;
      //JgEdit.Hide;
      if IntToStr(ZielTln.Jg) <> JgEdit.Text then
      begin
        JgEdit.Font.Style := [fsBold];
        //JgEdit.Font.Color := clWhite;
      end else
      begin
        JgEdit.Font.Style := [];
        //JgEdit.Font.Color := clWindowText;
      end;
      //JgEdit.Show;
      if Foc then JgEdit.SetFocus;
    end;
    if (ZielTln.Sex = cnMaennlich) and (SexCB.ItemIndex <> 1) or
       (ZielTln.Sex = cnWeiblich) and (SexCB.ItemIndex <> 2) or
       (ZielTln.Sex = cnKeinSex) and (SexCB.ItemIndex <> 0) then
    begin
      SexCB.Font.Style := [fsBold];
      //SexCB.Font.Color := clWhite;
    end else
    begin
      SexCB.Font.Style := [];
      //SexCB.Font.Color := clWindowText;
    end;
    if StrGleich(ZielTln.Land,LandEdit.Text)and(LandEdit.Font.Style=[fsBold]) or
       not StrGleich(ZielTln.Land,LandEdit.Text)and(LandEdit.Font.Style=[]) then
    begin
      if LandEdit.Focused then Foc := true else Foc := false;
      //LandEdit.Hide;
      if not StrGleich(ZielTln.Land,LandEdit.Text) then
      begin
        LandEdit.Font.Style := [fsBold];
        //LandEdit.Font.Color := clWhite;
      end else
      begin
        LandEdit.Font.Style := [];
        //LandEdit.Font.Color := clWindowText;
      end;
      //LandEdit.Show;
      if Foc then LandEdit.SetFocus;
    end;
    if (VereinCB.ItemIndex=0)and not StrGleich(VereinCB.Text,cnKein) or//Verein nicht vorhanden
       StrGleich(ZielTln.Verein,'')and not StrGleich(VereinCB.Text,cnKein) or
       not StrGleich(ZielTln.Verein,'')and
       not StrGleich(ZielTln.Verein,VereinCB.Text) then
    begin
      VereinCB.Font.Style := [fsBold];
      //VereinCB.Font.Color := clWhite;
    end else
    begin
      VereinCB.Font.Style := [];
      //VereinCB.Font.Color := clWindowText;
    end;
    if (MschCB.ItemIndex=0)and not StrGleich(MschCB.Text,cnKein) or//Msch. nicht vorhanden
       StrGleich(ZielTln.MannschName,'')and not StrGleich(MschCB.Text,cnKein) or
       not StrGleich(ZielTln.MannschName,'')and
       not StrGleich(ZielTln.MannschName,MschCB.Text) then
    begin
      MschCB.Font.Style := [fsBold];
      //MschCB.Font.Color := clWhite;
    end else
    begin
      MschCB.Font.Style := [];
      //MschCB.Font.Color := clWindowText;
    end;
    {if ZielTln.SMld <> GetImpSMld then
    begin
      SMldCB.Font.Style := [fsBold];
      //MldCB.Font.Color := clWhite;
    end else
    begin
      SMldCB.Font.Style := [];
      //SMldCB.Font.Color := clWindowText;
    end; }
  end;
end;

//==============================================================================
function TImpFrame.InpTlnVisible: Boolean;
//==============================================================================
begin
  Result := ClientHeight > ClientHeightMin;
end;

// protected methoden

//------------------------------------------------------------------------------
procedure TImpFrame.SetImpEnable(Bool:Boolean);
//------------------------------------------------------------------------------
begin
  ImpQuelleGB.Enabled := Bool;
  ImpDateiLabel.Enabled := Bool;
  ImpDateiEdit.Enabled := Bool;
  ImpVeranstLabel.Enabled := Bool;
  ImpVeranstEdit.Enabled := Bool;
  //ImpJahrLabel.Enabled := Bool;
  //ImpJahrEdit.Enabled := Bool;
  ImpWettkLabel.Enabled := Bool;
  ImpWettkCB.Enabled := Bool;
  TlnStatusRG.Enabled := Bool;
  //ImpDateiButton.Enabled := Bool;
  ImpStartButton.Enabled := Bool;
  //ImpCloseButton.Enabled := Bool; // getrennt setzen
  if EinlVeranst{Veranstaltung}.Serie then
  begin
    ImpOrtLabel.Enabled := Bool;
    ImpOrtCB.Enabled := Bool;
  end else
  begin
    ImpOrtLabel.Enabled := false;
    ImpOrtCB.Enabled := false;
  end;
  if Bool then
    if EinlVeranst{Veranstaltung}.Serie then ImpOrtCB.SetFocus
                           else ImpWettkCB.SetFocus;
end;

//------------------------------------------------------------------------------
procedure TImpFrame.SetImpTlnEnable(Bool:Boolean);
//------------------------------------------------------------------------------
begin
  ImpTlnGB.Enabled := Bool;
  ImpTlnNameLabel.Enabled := Bool;
  NameEdit.Enabled := Bool;
  ImpTlnVNameLabel.Enabled := Bool;
  VNameEdit.Enabled := Bool;
  ImpTlnSexLabel.Enabled := Bool;
  SexCB.Enabled := Bool;
  ImpTlnJgLabel.Enabled := Bool;
  JgEdit.Enabled := Bool;
  ImpTlnLandLabel.Enabled := Bool;
  LandEdit.Enabled := Bool;
  ImpTlnVereinLabel.Enabled := Bool;
  VereinCB.Enabled := Bool;
  ImpTlnMschLabel.Enabled := Bool;
  MschCB.Enabled := Bool;
  //ImpTlnSMldLabel.Enabled := Bool;
  //SMldCB.Enabled := Bool;
  ImpModusGB.Enabled := Bool;
  TlnNeuRB.Enabled := Bool;
  TlnwahlRB.Enabled := Bool;
  WeiterButton.Enabled := Bool;
  //if Bool then ImpCloseButton.Enabled := true; // getrennt setzen
  ImpTlnEnabled := Bool;
end;

//------------------------------------------------------------------------------
function TImpFrame.GetImpTlnStatus: TStatus{Integer};
//------------------------------------------------------------------------------
begin
  case TlnStatusRG.ItemIndex of
    0 :  Result := stKein;
    1 :  Result := stGemeldet;
    2 :  Result := stEingeteilt;
    3 :  Result := stAbs1Start;
    else Result := stKein;
  end;
end;

//------------------------------------------------------------------------------
procedure TImpFrame.SetImpDatenGB;
//------------------------------------------------------------------------------
var i : Integer;
begin
  ImpVeranstEdit.Text := EinlVeranst.Name;
  //ImpJahrEdit.Text    := IntToStr(EinlVeranst.Jahr);
  with EinlVeranst.WettkColl do
  begin
    for i:=0 to Count-1 do
      if Veranstaltung.Serie then ImpWettkCB.Items.Append(Items[i].Name)
                             else ImpWettkCB.Items.Append(Items[i].StandTitel);
    ImpWettkCB.ItemIndex := 0;
  end;
  if EinlVeranst.Serie then with EinlVeranst.OrtColl do
  begin
    for i:=0 to Count-1 do ImpOrtCB.Items.Append(Items[i].Name);
    ImpOrtCB.ItemIndex := 0;
  end;
  TlnStatusRG.ItemIndex := 0;
end;

//------------------------------------------------------------------------------
procedure TImpFrame.SetImpTlnGB;
//------------------------------------------------------------------------------
// Daten von QuellTln eintragen
var i : Integer;
    //SMldNeu : TSMldObj;
    VereinNeuIndex,MschNeuIndex : Integer;
begin
  Updating := true;
  if Veranstaltung.Serie
    then ImpTlnGB.Caption := 'Import-Teilnehmer (nicht in Zieldatei gefunden)'
    else ImpTlnGB.Caption := 'Import-Teilnehmer (bereits in Zieldatei vorhanden)';
  NameEdit.Text  := QuellTln.Name;
  VNameEdit.Text := QuellTln.Vname;
  JgEdit.Text    := IntToStr(QuellTln.Jg);
  SexCB.Items.Add(' ');
  SexCB.Items.Append('m�nnlich');
  SexCB.Items.Append('weiblich');
  case QuellTln.Sex of
    cnMaennlich : SexCB.ItemIndex := 1;
    cnWeiblich  : SexCB.ItemIndex := 2;
    else SexCB.ItemIndex := 0;
  end;
  LandEdit.Text := QuellTln.Land;
  // Verein
  VereinCB.Items.Clear;
  with Veranstaltung.VereinColl do
  begin
    if QuellTln.Verein = '' then VereinNeuIndex := -1
    else VereinNeuIndex := GetNameIndex(QuellTln.Verein);
    //wenn Verein nicht vorhanden, dann QuellTln.Verein als erster in Liste
    if (QuellTln.Verein <> '') and (VereinNeuIndex<0) then
      VereinCB.Items.Append(QuellTln.Verein);
    VereinCB.Items.Append(cnKein);
    for i:=0 to SortCount-1 do VereinCB.Items.Append(SortItems[i]^);
    if (QuellTln.Verein = '') or (VereinNeuIndex<0) then VereinCB.ItemIndex := 0
    else VereinCB.ItemIndex := SortIndexOf(PItems[VereinNeuIndex])+1;
  end;
  // Mannschaft
  MschCB.Items.Clear;
  with Veranstaltung.MannschNameColl do
  begin
    if QuellTln.MannschName = '' then MschNeuIndex := -1
    else MschNeuIndex := GetNameIndex(QuellTln.MannschName);
    //wenn MschName nicht vorhanden, dann QuellTln.MannschName als erster in Liste
    if (QuellTln.MannschName <> '') and (MschNeuIndex<0) then
      MschCB.Items.Append(QuellTln.MannschName);
    MschCB.Items.Append(cnKein);
    for i:=0 to SortCount-1 do MschCB.Items.Append(SortItems[i]^);
    if (QuellTln.MannschName = '') or (MschNeuIndex<0) then MschCB.ItemIndex := 0
    else MschCB.ItemIndex := SortIndexOf(PItems[MschNeuIndex])+1;
  end;
  {// SammelMelder
  SMldCB.Items.Clear;
  with Veranstaltung.SMldColl do
  begin
    if QuellTln.SMld = nil then SMldNeu := nil
    else SMldNeu := GetSMld(QuellTln.SMld.Name,QuellTln.SMld.VName,QuellTln.SMld.MannschName);
    //wenn SMld nicht vorhanden, dann QuelSMld als erster in Liste
    if (QuellTln.SMld <> nil) and (SMldNeu = nil) then
      if QuellTln.SMld.MannschNamePtr <> nil then
        SMldCB.Items.AddObject(QuellTln.SMld.NameVName + ' --- ' +
                               QuellTln.SMld.MannschName,QuellTln.SMld)
      else SMldCB.Items.AddObject(QuellTln.SMld.NameVName,QuellTln.SMld);
    SMldCB.Items.AddObject(cnKein,nil);
    //SMldCB.Items.Append(cnKein);
    for i:=0 to SortCount-1 do
      if SortItems[i].MannschNamePtr <> nil then
        (*SMldCB.Items.Append(SortItems[i].NameVName + ' --- ' +
                                  SortItems[i].MannschName^)*)
        SMldCB.Items.AddObject(SortItems[i].NameVName + ' --- ' +
                               SortItems[i].MannschName,SortItems[i])
      //else SMldCB.Items.Append(SortItems[i].NameVName);
      else SMldCB.Items.AddObject(SortItems[i].NameVName,SortItems[i]);
    if (QuellTln.SMld=nil)or(SMldNeu=nil) then SMldCB.ItemIndex := 0
    else SMldCB.ItemIndex := SortIndexOf(SMldNeu)+1;
  end;}

  if StrGleich(ZielTln.Name,NameEdit.Text)
    then TlnWahlRB.Checked := true // Tln vorhanden
    else TlnNeuRB.Checked := true; // Tln nicht vorhanden
  //SetImpTlnModeGB;
  SetImpTlnFontStyle;
  //Visible := true; // hierbei wird FocusedItem ge�ndert
  SetImpTlnEnable(true);
  ClientHeight := ClientHeightMax; // vor SetzeCommands/UpdateAnsicht
  Screen.Cursor := CursorAlt; // vor SetzeCommands/UpdateAnsicht
  HauptFenster.UpdateAnsicht; // Einschl. SetzeCommands, FocusedItem ge�ndert
  ImpCloseButton.Enabled := true;
  with HauptFenster.LstFrame.TriaGrid do
  begin
    FocusedItem := ZielTln;
    HauptFenster.FocusedTln := FocusedItem;
    // Focus in der Mitte
    if ItemIndex >= 0 then
      TopRow := Max(FixedRows,Row - VisibleRowCount DIV 2);
  end;
  VereinCB.SelStart := -1; // damit Text nicht selektiert wird
  MschCB.SelStart := -1;
  //SMldCB.SelStart := -1; // damit Text nicht selektiert wird
  Updating := false; // jetz wird ImpTlnChange freigegeben
end;

//------------------------------------------------------------------------------
procedure TImpFrame.ClearImpDatenGB;
//------------------------------------------------------------------------------
begin
  ImpDateiEdit.Text := '';
  ImpVeranstEdit.Text := '';
  //ImpJahrEdit.Text    := '';
  ImpWettkCB.Items.Clear;
  ImpWettkCB.Text := '';
  ImpOrtCB.Items.Clear;
  ImpOrtCB.Text := '';
  TlnStatusRG.ItemIndex := 0;
end;

//------------------------------------------------------------------------------
procedure TImpFrame.ClearImpTlnGB;
//------------------------------------------------------------------------------
begin
  Updating := true;
  NameEdit.Font.Style := [];
  //NameEdit.Color := clWindow;
  //NameEdit.Font.Color := clWindowText;
  VNameEdit.Font.Style := [];
  //VNameEdit.Font.Color := clWindowText;
  JgEdit.Font.Style := [];
  //JgEdit.Font.Color := clWindowText;
  SexCB.Font.Style := [];
  //SexCB.Font.Color := clWindowText;
  LandEdit.Font.Style := [];
  //LandEdit.Font.Color := clWindowText;
  VereinCB.Font.Style := [];
  //VereinCB.Font.Color := clWindowText;
  MschCB.Font.Style := [];
  //MschCB.Font.Color := clWindowText;
  //SMldCB.Font.Style := [];
  //SMldCB.Font.Color := clWindowText;
  NameEdit.Text := '';
  VNameEdit.Text := '';
  SexCB.Items.Clear;
  SexCB.Text := '';
  JgEdit.Text := '';
  LandEdit.Text := '';
  VereinCB.Items.Clear;
  VereinCB.Text := '';
  MschCB.Items.Clear;
  MschCB.Text := '';
  //SMldCB.Items.Clear;
  //SMldCB.Text := '';
  TlnNeuRB.Checked := true;
  Updating := false;
end;

//------------------------------------------------------------------------------
function TImpFrame.GetImpWettk: TWettkObj;
//------------------------------------------------------------------------------
begin
  with EinlVeranst.WettkColl do
    if (ImpWettkCB.ItemIndex >= 0) and
       (ImpWettkCB.ItemIndex < Count) then Result := Items[ImpWettkCB.ItemIndex]
                                      else Result := nil;
end;

//------------------------------------------------------------------------------
function TImpFrame.GetImpTlnMode: TImpTlnMode;
//------------------------------------------------------------------------------
begin
  with HauptFenster do
    if TlnNeuRB.Checked then Result := imTlnNeu
    else Result := imTlnWahl;
end;

//------------------------------------------------------------------------------
function TImpFrame.GetZielMschPtr(AkWrtg:TKlassenWertung): TMannschObj;
//------------------------------------------------------------------------------
var i : Integer;
    MschName : String;
    MschKlasse : TAkObj;
begin
  Result := nil;
  if QuellTln.MannschPtr(AkWrtg) = nil then Exit;

  if ImpTlnEnabled then MschName := Trim(MschCB.Text)
                   else MschName := QuellTln.MannschName;

 // Klasse nicht von QuelMannschaft �bernehmen, sondern g�ltige Klasse f�r
 // ZielWettk definieren
  MschKlasse := HauptFenster.SortWettk.GetKlasse(tmMsch,AkWrtg,QuellTln.Sex,QuellTln.Jg);

  for i:=0 to Veranstaltung.MannschColl.Count-1 do
    with Veranstaltung.MannschColl[i] do
      if TxtGleich(Name,MschName)           and  // Gro�/Kleinschreibung ignorieren
         (Wettk  = HauptFenster.SortWettk)  and
         (Klasse = MschKlasse) then
      begin
        //SerienWrtg := TMannschobj(QuellTln.MannschPtr).SerienTln;
        //AusserKonkurrenz := TMannschObj(QuellTln.MannschPtr).AusserKonkurrenz;
        Result := Veranstaltung.MannschColl[i];
        Exit;
      end;
  // nicht gefunden
  if Veranstaltung.MannschColl.Count < cnMschMax then
  begin
    Result := TMannschObj.Create(Veranstaltung,Veranstaltung.MannschColl,oaAdd);
    Result.Init(MschName,HauptFenster.SortWettk,MschKlasse,
                {TMannschObj(QuellTln.MannschPtr).SerienTln,
                TMannschObj(QuellTln.MannschPtr).AusserKonkurrenz,}0);
    // nur die bereits in TlnColl vorhandene Tln werden in Tlnliste eingelesen
    // der Rest wird beim Berechnen neu eingelesen
    Veranstaltung.MannschColl.AddItem(Result);
  end else TriaMessage('Maximale Mannschaftszahl �berschritten.',
                        mtInformation,[mbOk]);
end;

{//------------------------------------------------------------------------------
function TImpFrame.GetImpSMld: TSMldObj;
//------------------------------------------------------------------------------
begin
  if SMldCB.ItemIndex >= 0 then
    Result := TSMldObj(SMldCB.Items.Objects[SMldCB.ItemIndex])
  else Result := nil;
end;}

//------------------------------------------------------------------------------
procedure TImpFrame.ImpTlnExit;
//------------------------------------------------------------------------------
begin
  HauptFenster.OrtCB.Enabled   := true;
  HauptFenster.LstFrame.AnsFrame.WettkampfCB.Enabled   := true;
  //Visible := false;
  SetImpTlnEnable(false);
  SetImpEnable(true);
  Clientheight := ClientHeightMin; // vor SetzeCommands/UpdateAnsicht
  HauptFenster.StatusBarClear; // vor SetzeCommands/UpdateAnsicht
  HauptFenster.UpdateAnsicht;
  ImpCloseButton.Enabled := true;
  HauptFenster.LstFrame.TriaGrid.ItemIndex := 0;
  HauptFenster.FocusedTln := HauptFenster.LstFrame.TriaGrid.FocusedItem;
  if HauptFenster.LstFrame.TriaGrid.CanFocus then
    HauptFenster.LstFrame.TriaGrid.SetFocus;
  //ImpDateiButton.Enabled := false;
  HauptFenster.StatusBarText('Der Daten-Import ist abgeschlossen.',
                             'Es wurden Daten von '+IntToStr(ImportierteTln) +
                             ' Teilnehmer importiert, davon ' +
                              IntToStr(HinzugefuegteTln) +
                             ' Teilnehmer hinzugef�gt.');
end;

// Protected Methoden

//------------------------------------------------------------------------------
procedure TImpFrame.CustomAlignPosition(Control: TControl;
                              var NewLeft,NewTop,NewWidth,NewHeight: Integer;
                              var AlignRect:TRect; AlignInfo:TAlignInfo);
//------------------------------------------------------------------------------
begin
  if Control = ImpHeaderPanel then
    NewWidth := ClientWidth - 4
  else if Control = BtnPanel then
    NewLeft := ClientWidth -BtnPanel.Width - 2;
end;

// published methoden

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.ImpStartButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var i,j,Sum : Integer;
    EinlSGrp,SGrpNeu,SGrpBuff : TSGrpObj;
    Txt : String;
//..............................................................................
function AbsNamenGleich: Boolean;
var AbsCnt : TWkAbschnitt;
begin
  for AbsCnt:=wkAbs1 to wkAbs8 do
    with QuellWettk do
      if HauptFenster.SortWettk.AbschnName[AbsCnt] <> AbschnName[AbsCnt] then
      begin
        Result := false;
        Exit;
      end;
  Result := true;
end;

//..............................................................................
begin
    // wird nur am Anfang aufgerufen
    QuellWettk := GetImpWettk;
    if QuellWettk = nil then Exit;

    with HauptFenster do
      if EinlVeranst.Serie and Veranstaltung.Serie then
        if TriaMessage('Daten von Wettkampf  "'+ImpWettkCB.Text+
                       '" in "'+ImpOrtCB.Text+'"'+#13+
                       '         nach Wettkampf  "'+LstFrame.AnsFrame.WettkampfCB.Text+
                       '" in "'+OrtCB.Text+ '"  importieren?',
                        mtConfirmation,[mbOk,mbCancel]) <> mrOk then Exit
                                                                else
      else if EinlVeranst.Serie then
        if TriaMessage('Daten von Wettkampf  "'+ImpWettkCB.Text+
                       '" in "'+ImpOrtCB.Text+'"'+#13+
                       '         nach Wettkampf  "'+LstFrame.AnsFrame.WettkampfCB.Text+
                       '"  importieren?',
                        mtConfirmation,[mbOk,mbCancel]) <> mrOk then Exit
                                                                else
      else
        if TriaMessage('Daten von Wettkampf  "'+ImpWettkCB.Text+
                       '"  nach Wettkampf  "'+LstFrame.AnsFrame.WettkampfCB.Text+
                       '"  importieren?',
                        mtConfirmation,[mbOk,mbCancel]) <> mrOk then Exit;

    (* zuerst pr�fen ob alle �nderungen akzeptiert werden *)

    if EinlVeranst.OrtColl.Count>1 then EinlVeranst.OrtIndex := ImpOrtCB.ItemIndex
                                   else EinlVeranst.OrtIndex := 0;

    (* pr�fen ob Daten �berschrieben werden sollen *)
    if Veranstaltung.WettkColl.Count > 0 then
    begin
      Txt := 'Vorhandene Wettkampf-Einstellungen �berschreiben?';
      if Veranstaltung.Serie then
        Txt := Txt + #13 +
              '(Nur Name, Altersklassen und Wertungen gelten f�r alle Austragungsorte.)';
      case TriaMessage(Txt,mtConfirmation,[mbYes,mbNo,mbCancel]) of
        mrYes: WettkUebernehmen := true;
        mrNo:  WettkUebernehmen := false;
        else Exit;
      end;
    end;

    if WettkUebernehmen then with QuellWettk do
      for i:=0 to Veranstaltung.WettkColl.Count-1 do
        if (Veranstaltung.WettkColl[i]<> HauptFenster.SortWettk) and
            StrGleich(Veranstaltung.WettkColl[i].Name,Name) then
        begin
          TriaMessage('Wettkampfname '+Name+' ist bereits vorhanden.'+#13+
                      'Die Daten k�nnen nicht importiert werden.',
                       mtInformation,[mbOk]);
          Exit;
        end;

    if EinlVeranst.SGrpColl.SGrpZahl(QuellWettk) > 0 then
      if Veranstaltung.SGrpColl.SGrpZahl(HauptFenster.SortWettk) > 0 then
        case TriaMessage('Vorhandene Startgruppen-Einstellungen �berschreiben?',
                          mtConfirmation,[mbYes,mbNo,mbCancel]) of
          mrYes: SGrpUebernehmen := true; // ZielWettk-Startgruppen werden gel�scht
          mrNo:  SGrpUebernehmen := false;
          else Exit;
        end
      else
      if Veranstaltung.SGrpColl.SGrpZahl(WettkAlleDummy) > 0 then
        case TriaMessage('Startgruppen-Einstellungen �bernehmen?',
                          mtConfirmation,[mbYes,mbNo,mbCancel]) of
          mrYes: SGrpUebernehmen := true;
          mrNo:  SGrpUebernehmen := false;
          else Exit;
        end
      else SGrpUebernehmen := true
    else SGrpUebernehmen := false;

    // Startnummern �berpr�fen
    case GetImpTlnStatus of
      stEingeteilt,stAbs1Start:
        for i:=0 to EinlVeranst.TlnColl.Count-1 do  //2006: nur f�r Snr>0
          if (EinlVeranst.TlnColl[i].Snr > 0) and
             (EinlVeranst.TlnColl[i].Wettk = QuellWettk) then
          begin
            // auf doppelte Tln-Startnummern in Importdatei pr�fen
            for j:=i+1 to EinlVeranst.TlnColl.Count-1 do
              if EinlVeranst.TlnColl[i].Snr = EinlVeranst.TlnColl[j].Snr then
              begin
                TriaMessage('Im Import-Wettkampf ist die Startnummer  "'+
                             IntToStr(EinlVeranst.TlnColl[i].Snr)+
                            '"  doppelt vorhanden.'+#13+
                            'Die Daten k�nnen nicht importiert werden.',
                             mtInformation,[mbOk]);
                Exit;
              end;
            // auf belegte Tln-Startnummern in Zieldatei pr�fen
            for j:=0 to Veranstaltung.TlnColl.Count-1 do
              if (EinlVeranst.TlnColl[i].Snr = Veranstaltung.TlnColl[j].Snr) and
                 (not SGrpUebernehmen or // Einteilung wird gel�scht
                  (Veranstaltung.TlnColl[j].Wettk <> HauptFenster.SortWettk)) then
              begin
                TriaMessage('Die Startnummer  "'+
                             IntToStr(EinlVeranst.TlnColl[i].Snr)+
                            '"  ist bereits vergeben.'+#13+
                            'Die Daten k�nnen nicht importiert werden.',
                             mtInformation,[mbOk]);
                Exit;
              end;
            // pr�fen ob Tln-Snr in eine SGrp definiert ist
            if not SGrpUebernehmen then
            begin
              SGrpBuff := Veranstaltung.SGrpColl.SGrpMitSnr(HauptFenster.SortWettk,EinlVeranst.TlnColl[i].Snr);
              if SGrpBuff = nil then
              begin
                TriaMessage('Die Startnummer  "'+
                             IntToStr(EinlVeranst.TlnColl[i].Snr)+
                            '"  ist in keiner Startgruppe des Zielwettkampfes definiert.'+#13+
                            'Die Daten k�nnen nicht importiert werden.',
                             mtInformation,[mbOk]);
                Exit;
              end;
            end;
          end;
      else ;
    end;

    if SGrpUebernehmen then
    begin
      // auf �berlappende Startnummern in SGrp der anderen Wettk. �berpr�fen
      // SGrp f�r HauptFenster.SortWettk nicht interessant, weil sowieso gel�scht
      if not SnrUeberlapp then
        for i:=0 to EinlVeranst.SGrpColl.Count-1 do
        with EinlVeranst.SGrpColl[i] do
          if (Wettkampf = QuellWettk) and (WkOrtIndex = EinlVeranst.OrtIndex) then
            if Veranstaltung.SGrpColl.SnrUeberlap(HauptFenster.SortWettk,
                                                  StartnrVon,StartNrBis) then
              if TriaMessage('Startnummernbereich von  '+
                             IntTostr(StartNrVon)+'  bis  '+IntToStr(StartNrBis)+
                             '  �berlappt'+#13+
                             'mit Bereichen aus anderen Wettk�mpfen.'+#13+#13+
                             '�berlappende Startnummernbereiche zulassen?',
                             mtConfirmation,[mbYes,mbNo]) <> mrYes then Exit
                                                                   else SnrUeberlapp := true;

      // Warnen f�r L�schung von Tln-Daten
      if Veranstaltung.TlnColl.TlnGewertet(HauptFenster.SortWettk) > 0 then
        if TriaMessage('F�r Wettkampf  "'+HauptFenster.SortWettk.Name+
                       '"  wurden bereits Teilnehmer gewertet.'+#13+
                       'Vorhandene Einteilung und Ergebnisse werden gel�scht.',
                        mtConfirmation,[mbOk,mbCancel]) <> mrOk then Exit
        else
      else
        if Veranstaltung.TlnColl.TlnEingeteilt(HauptFenster.SortWettk) > 0 then
          if TriaMessage('F�r Wettkampf  "'+HauptFenster.SortWettk.Name+
                         '"  wurden bereits Teilnehmer eingeteilt.'+#13+
                         'Vorhandene Einteilung wird gel�scht.',
                          mtConfirmation,[mbOk,mbCancel]) <> mrOk then Exit;
      // auf Max. SGrpZahl pr�fen
      Sum := EinlVeranst.SGrpColl.SGrpZahl(QuellWettk);
      for i:=0 to Veranstaltung.WettkColl.Count-1 do
        if Veranstaltung.WettkColl[i] <> HauptFenster.SortWettk then
          Sum := Sum + Veranstaltung.SGrpColl.SGrpZahl(Veranstaltung.WettkColl[i]);
      if Sum > cnSGrpMax then
      begin
        TriaMessage('Bei Import wird die maximale Anzahl Startgruppen �berschritten.'+#13+
                    'Die Daten k�nnen nicht importiert werden.',
                     mtInformation,[mbOk]);
        Exit;
      end;
    end;

    (* Daten �bernehmen *)
    TriDatei.Modified := true;
    //HauptFenster.SortWettk.MannschModified := true;

    (* Wettkampfeinstellung �bernehmen *)
    if WettkUebernehmen then with QuellWettk do
    begin
      HauptFenster.LstFrame.TriaGrid.StopPaint := true;
      try
        if Veranstaltung.Serie then
          HauptFenster.SortWettk.SetWettkAllgDaten(Name,
                                                   StreichErg[tmTln],StreichErg[tmMsch],
                                                   StreichOrt[tmTln],StreichOrt[tmMsch],
                                                   PflichtWkMode[tmTln],PflichtWkMode[tmMsch],
                                                   PflichtWkOrt1[tmTln],PflichtWkOrt1[tmMsch],
                                                   PflichtWkOrt2[tmTln],PflichtWkOrt2[tmMsch],
                                                   PunktGleichOrt[tmTln],PunktGleichOrt[tmMsch],
                                                   MschWertg,
                                                   SerWrtgJahr,
                                                   SerWrtgMode[tmTln],SerWrtgMode[tmMsch])
        else
          HauptFenster.SortWettk.SetWettkAllgDaten(StandTitel,
                                                   StreichErg[tmTln],StreichErg[tmMsch],
                                                   StreichOrt[tmTln],StreichOrt[tmMsch],
                                                   PflichtWkMode[tmTln],PflichtWkMode[tmMsch],
                                                   PflichtWkOrt1[tmTln],PflichtWkOrt1[tmMsch],
                                                   PflichtWkOrt2[tmTln],PflichtWkOrt2[tmMsch],
                                                   PunktGleichOrt[tmTln],PunktGleichOrt[tmMsch],
                                                   MschWertg,
                                                   SerWrtgJahr,
                                                   SerWrtgMode[tmTln],SerWrtgMode[tmMsch]);
        HauptFenster.SortWettk.SetWettkOrtDaten(StandTitel,
                                                SondTitel,
                                                Datum,
                                                WettkArt,
                                                AbschnZahl,
                                                AbsMaxRunden[wkAbs1],
                                                AbsMaxRunden[wkAbs2],
                                                AbsMaxRunden[wkAbs3],
                                                AbsMaxRunden[wkAbs4],
                                                AbsMaxRunden[wkAbs5],
                                                AbsMaxRunden[wkAbs6],
                                                AbsMaxRunden[wkAbs7],
                                                AbsMaxRunden[wkAbs8],
                                                AbschnName[wkAbs1],
                                                AbschnName[wkAbs2],
                                                AbschnName[wkAbs3],
                                                AbschnName[wkAbs4],
                                                AbschnName[wkAbs5],
                                                AbschnName[wkAbs6],
                                                AbschnName[wkAbs7],
                                                AbschnName[wkAbs8],
                                                TlnTxt,
                                                MschWrtgMode,
                                                MschGroesse[cnSexBeide],MschGroesse[cnMaennlich],
                                                MschGroesse[cnWeiblich],MschGroesse[cnMixed],
                                                SchwimmDistanz,
                                                StartBahnen,
                                                RundLaenge,
                                                Startgeld,
                                                DisqTxt);
        // Altersklassen �bernehmen
        HauptFenster.SortWettk.KlassenKopieren(QuellWettk);

      finally
        HauptFenster.LstFrame.TriaGrid.StopPaint := false;
        //HauptFenster.RefreshAnsicht; // update WettkampfCB, sp�ter UpdateAnsicht
      end;
    end;

    (* Startgruppen �bernehmen *)
    if SGrpUebernehmen then
    begin
      HauptFenster.LstFrame.TriaGrid.StopPaint := true;
      try
        // vorhandene werden immer gel�scht um Konflikte mit Snr zu vermeiden
        Veranstaltung.SGrpColl.SGrpLoeschen(HauptFenster.SortWettk);
        for i:=0 to EinlVeranst.SGrpColl.Count-1 do
        begin
          EinlSGrp := EinlVeranst.SGrpColl[i];
          if (EinlSGrp.Wettkampf = QuellWettk) and
             (EinlSGrp.WkOrtIndex = EinlVeranst.OrtIndex) then
          begin
            SGrpNeu := TSGrpObj.Create(Veranstaltung,Veranstaltung.SGrpColl,oaAdd);
            SGrpNeu.Init(EinlSGrp.Name, HauptFenster.SortWettk,
                         EinlSGrp.Start1Delta,
                         EinlSGrp.StartZeitArr, EinlSGrp.StartModeArr,
                         EinlSGrp.StartnrVon,EinlSGrp.StartnrBis);
            // setze EinlSGrp.LoadPtr als SGrp-Pointer f�r Tln.SGrp
            EinlSGrp.LoadPtr := SGrpNeu;
            if ImpZeitFormat > ZeitFormat then
              SGrpNeu.ZeitenRunden;  //ggf. an aktuellem Format anpassen
            Veranstaltung.SGrpColl.AddItem(SGrpNeu);
          end;
        end;
      finally
        HauptFenster.LstFrame.TriaGrid.StopPaint := false;
      end;
    end;

    if WettkUebernehmen or SGrpUebernehmen then HauptFenster.UpdateAnsicht;

    (* Teilnehmer-Daten (TlnColl+SMldColl+DisqColl) und MannschColl einlesen *)
    if GetImpTlnStatus <> stKein then
    begin
      (* nur mit Tln aus gew�hlten Wettk. vergleichen *)
      // gleiche Sortierung wie Veranstaltung.TlnColl
      EinlVeranst.TlnColl.Sortieren(EinlVeranst.OrtIndex,
                                    smTlnName,QuellWettk,wgStandWrtg,
                                    AkAlle,nil,stGemeldet);
      if Veranstaltung.TlnColl.SortCount=0 then LeereDatei := true
                                           else LeereDatei := false;
      if EinlVeranst.TlnColl.SortCount=0 then
      begin
        TriaMessage('In gew�hlter Wettkampf sind keine Teilnehmer gemeldet.',
                     mtInformation,[mbOk]);
        //ImportFrameSchliessen;
        Exit;
      end;
      HauptFenster.ProgressBarInit('Teilnehmer werden importiert',
                                    EinlVeranst.TlnColl.SortCount); //SetzeCommands

      Veranstaltung.SMldColl.Sortieren(smSMldName,smOhneTlnColl);

      {EinlVeranst.SMldColl.Sortieren(smAlphabetisch,smOhneTlnColl);
      Veranstaltung.SMldColl.Sortieren(smAlphabetisch,smOhneTlnColl);
      if Veranstaltung.SMldColl.SortCount=0 then SMldVergleichen := false
                                            else SMldVergleichen := true;
      if not Veranstaltung.Serie then SMldVergleichen := false;}

      (* einlesen *)
      // Meldung nochmals, falls SMldSortieren mit Meldung sein sollte
      HauptFenster.ProgressBarInit('Teilnehmer werden importiert',
                                    EinlVeranst.TlnColl.SortCount);
      HauptFenster.ProgressBarStehenLassen := true;

      (* SMldColl LoadPtr initialisieren *)
      {for i:=0 to EinlVeranst.SMldColl.Count-1 do
        EinlVeranst.SMldColl[i].LoadPtr := EinlVeranst.SMldColl[i];}
    end else
    begin
      //ImportFrameSchliessen;
      Exit;
    end;

    // Tln importieren
    ImpTlnIndex := -1;
    ImportierteTln := 0; // Summe Hinzugef�gt + Ersetzt
    HinzugefuegteTln := 0;
    HauptFenster.OrtCB.Enabled := false;
    HauptFenster.LstFrame.AnsFrame.WettkampfCB.Enabled := false;
    SetImpEnable(false);
    ImpCloseButton.Enabled := false;
    // erster Aufruf von Importieren,
    // weitere Aufrufen sp�ter in ExecuteImpTlnCommand nach Drucken von ImpTlnButton
    // Importieren wird beendet, wenn
    // 1. alle Tln importiert
    // 2. Tln nicht gefunden und InitImpTlnDialog Fehler: ImportTln=false
    // 3.                        InitImpTlnDialog normal: ImportTln=true
    LetzteTln := nil;
    if not Importieren then Schliessen;
end;


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.ImpCloseButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  Schliessen;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.ImpDatenCBCloseUp(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if HauptFenster.LstFrame.TriaGrid.CanFocus then
    HauptFenster.LstFrame.TriaGrid.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.HilfeButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  Application.HelpContext(3050);  // Daten-Import aus Tria-Datei
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.biHelpBtnClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  ImpHeaderPanel.SetFocus; // Focus weg von biHelpBtn
  // MausZeiger f�r Help Text Popup setzen
  DefWindowProc(handle, WM_SYSCOMMAND, SC_CONTEXTHELP, 0);
end;


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.ImpTlnChange(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  //SetImpTlnModeGB;
  if not Updating then SetImpTlnFontStyle; // wird damit erst nach Init enabled
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.ImpTlnCloseUp(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  //SetImpTlnModeGB;
  SetImpTlnFontStyle;
  if HauptFenster.LstFrame.TriaGrid.CanFocus then
    HauptFenster.LstFrame.TriaGrid.SetFocus;
  //HauptFenster.FocusControl(nil);
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.SexCBDropDown(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  SexCB.Font.Style := [];
  //SexCB.Font.Color := clWindowText;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.VereinCBDropDown(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  VereinCB.Font.Style := [];
  //VereinCB.Font.Color := clWindowText;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.MschCBDropDown(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  MschCB.Font.Style := [];
  //MschCB.Font.Color := clWindowText;
end;

{//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.SMldCBDropDown(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  SMldCB.Font.Style := [];
  //SMldCB.Font.Color := clWindowText;
end; }

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TImpFrame.WeiterButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var TlnNeu : TTlnObj;
    S : String;
begin
    // Validate wird nicht automatisch ausgef�hrt bei ENTER-Taste
    if not JgEdit.ValidateEdit then Exit;
    if StrToIntDef(JgEdit.Text,0) > 0 then
      if HauptFenster.SortWettk.Jahr - StrToIntDef(JgEdit.Text,0) > cnAlterMax then
      begin
        TriaMessage('Jahrgang muss gr��er sein als '+
                     IntToStr(HauptFenster.SortWettk.Jahr-cnAlterMax-1)+'.'+#13+
                    'Wert l�schen (Entf-Taste), wenn Jahrgang unbekannt ist.',
                     mtInformation,[mbOk]);
        if JgEdit.CanFocus then JgEdit.SetFocus;
        Exit;
      end else
      if HauptFenster.SortWettk.Jahr - StrToIntDef(JgEdit.Text,0) < cnAlterMin then
      begin
        TriaMessage('Jahrgang muss kleiner sein als '+
                     IntToStr(HauptFenster.SortWettk.Jahr-cnAlterMin+1)+'.'+#13+
                    'Wert l�schen (Entf-Taste), wenn Jahrgang unbekannt ist.',
                     mtInformation,[mbOk]);
        if JgEdit.CanFocus then JgEdit.SetFocus;
        Exit;
      end;

    // Daten k�nnen im Dialog beliebig ge�ndert werden, deshalb nochmals pr�fen ob
    // ImportTln schon in Zieldatei vorhanden ist
    case GetImpTlnMode of
      imTlnNeu: (* als neuen Tln importieren *)
      begin
        if Veranstaltung.TlnColl.Count >= cnTlnMax then
        begin
          TriaMessage('Maximale Teilnehmerzahl erreicht.',mtInformation,[mbOk]);
          Schliessen;
          Exit;
        end;
        S := Trim(MschCB.Text);
        if Veranstaltung.TlnColl.SucheTln(nil,
                                          Trim(NameEdit.Text),
                                          Trim(VNameEdit.Text),
                                          Trim(VereinCB.Text),
                                          Trim(MschCB.Text),
                                          HauptFenster.SortWettk) <> nil then
        begin
          TriaMessage('Teilnehmer mit gleichem Namen, Vornamen und Verein oder Mannschaft'+
                      ' wurde'+#13+
                      'bereits f�r Wettkampf "'+ HauptFenster.SortWettk.Name +
                      '" angemeldet.',
                       mtInformation,[mbOk]);
          if NameEdit.CanFocus then NameEdit.SetFocus;
          Exit;
        end;
        // Create ImportTln als neuer Tln
        TlnNeu := TTlnObj.Create(Veranstaltung,Veranstaltung.TlnColl,oaAdd);
        Veranstaltung.TlnColl.AddItem(TlnNeu);
        if not ImportiereTln(TlnNeu) then
        begin
          Veranstaltung.TlnColl.ClearItem(TlnNeu);
          Schliessen;
          Exit;
        end;
        Inc(ImportierteTln);
        Inc(HinzugefuegteTln);
      end;
      imTlnWahl: (* statt gew�hltem Tln importieren *)
      begin
        ZielTln := TTlnObj(HauptFenster.LstFrame.TriaGrid.FocusedItem);
        if Veranstaltung.TlnColl.SucheTln(ZielTln,
                                          Trim(NameEdit.Text),
                                          Trim(VNameEdit.Text),
                                          Trim(VereinCB.Text),
                                          Trim(MschCB.Text),
                                          HauptFenster.SortWettk) <> nil then
        begin
          TriaMessage('Teilnehmer ist bereits vorhanden.',mtInformation,[mbOk]);
          if NameEdit.CanFocus then NameEdit.SetFocus;
          Exit;
        end;
        if ZielTln <> nil then
        begin
          if not ImportiereTln(ZielTln) then
          begin
            Schliessen;
            Exit;
          end;
          Inc(ImportierteTln);
        end;
      end;
    end;
    HauptFenster.StatusBarText('','Die Daten von '+IntToStr(ImportierteTln) +
                                  ' Teilnehmer wurden importiert, davon ' +
                                   IntToStr(HinzugefuegteTln) +
                                  ' Teilnehmer hinzugef�gt.');
    // n�chster Tln importieren
    ClearImpTlnGB;
    SetImpTlnEnable(false);
    ImpCloseButton.Enabled := false;
    Screen.Cursor := crHourGlass;    { Cursor als Sanduhr }
    SetzeCommands;
    Importieren;

end;


end.

