﻿unit AusgDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, Math, ExcelXP{Excel2000}, OleServer,
  StrUtils, CheckLst, ExtCtrls,Printers,
  RpDevice,RpDefine,RpSystem, // Rave
  AllgConst,AllgObj,AllgComp,AkObj,WettkObj;

procedure ListAusgabe(Mode:TReportMode);
procedure ReportVorschauSchliessen;

type
  TAusgDialog = class(TForm)

  published
    PrintDialog: TPrintDialog;
    ExcelApplication: TExcelApplication;
    ExcelWorkBook: TExcelWorkbook;
    ExcelWorkSheet: TExcelWorksheet;

    DruckerLabel: TLabel;
    DruckerCB: TComboBox;
    WettkLabel: TLabel;
    WettkCLB: TCheckListBox;
    KlassenLabel: TLabel;
    KlassenCLB: TCheckListBox;
    AlleKlassenCB: TCheckBox;
    LayoutGB: TGroupBox;
      WkNewPageCB: TCheckBox;
      AkNewPageCB: TCheckBox;
      OptTlnSpalteCB: TCheckBox;
    DrBereichGB: TGroupBox;
      PgAlleRB: TRadioButton;
      PgVonBisRB: TRadioButton;
      PgVonEdit: TTriaMaskEdit;
      PgVonUpDown: TTriaUpDown;
      PgBisLabel: TLabel;
      PgBisEdit: TTriaMaskEdit;
      PgBisUpDown: TTriaUpDown;
    ExemplareGB: TGroupBox;
      AnzahlLabel: TLabel;
      AnzahlEdit: TTriaMaskEdit;
      AnzahlUpDown: TTriaUpDown;
      SortierCB: TCheckBox;
    RngBereichGB: TGroupBox;
      RngBisLabel: TLabel;
      RngAlleRB: TRadioButton;
      RngVonBisRB: TRadioButton;
      RngVonEdit: TTriaMaskEdit;
      RngBisEdit: TTriaMaskEdit;
      RngVonUpDown: TTriaUpDown;
      RngBisUpDown: TTriaUpDown;
    AnzeigeGB: TGroupBox;
      AnzeigeCB: TCheckBox;
    SerienDrGB: TGroupBox;
      TextAnzeigenCB: TCheckBox;
      TextDateiRB: TRadioButton;
      WordRB: TRadioButton;

    Panel1: TPanel;
    DruckerBtn: TButton;
    VorschauButton: TButton;
    OkButton: TButton;
    HilfeButton: TButton;
    CancelButton: TButton;

    procedure WettkLabelClick(Sender: TObject);
    procedure WettkCLBClick(Sender: TObject);
    procedure WettkCLBClickCheck(Sender: TObject);
    procedure KlassenLabelClick(Sender: TObject);
    procedure KlassenCLBClick(Sender: TObject);
    procedure KlassenCLBClickCheck(Sender: TObject);
    procedure AlleKlassenCBClick(Sender: TObject);
    procedure WkNewPageCBClick(Sender: TObject);
    procedure AkNewPageCBClick(Sender: TObject);
    procedure DruckerLabelClick(Sender: TObject);
    procedure PgAlleRBClick(Sender: TObject);
    procedure PgEditClick(Sender: TObject);
    procedure PgVonBisRBClick(Sender: TObject);
    procedure PgVonBisRBEnter(Sender: TObject);
    procedure PgBisLabelClick(Sender: TObject);
    procedure RngAlleRBClick(Sender: TObject);
    procedure RngVonBisRBClick(Sender: TObject);
    procedure RngVonBisRBEnter(Sender: TObject);
    procedure RngEditClick(Sender: TObject);
    procedure RngBisLabelClick(Sender: TObject);
    procedure TextDateiRBClick(Sender: TObject);
    procedure WordRBClick(Sender: TObject);
    procedure AnzahlEditChange(Sender: TObject);
    procedure DruckerBtnClick(Sender: TObject);
    procedure VorschauButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure HilfeButtonClick(Sender: TObject);

  private
    HelpFensterAlt     : TWinControl;
    Updating           : Boolean;
    DisableButtons     : Boolean;
    NewPageMoeglich    : Boolean;
    WkNewPageStatus    : Boolean; // Status festhalten, wenn disabled
    AkNewPageStatus    : Boolean; // Status festhalten, wenn disabled
    TopNext            : Integer; // für DialogLayout

    function  WettkZahl : Integer;
    function  WettkChecked : Integer;
    procedure InitWkDaten;
    procedure UpdateWkDaten;
    //function  SpalteLandDefiniert: Boolean;
    procedure InitKlassenCLB;
    function  KlassenAnZahlChecked: Integer;
    procedure InitLayoutGB;
    procedure UpdateLayoutGB;
    //procedure UpdateAkNewPageCB;
    procedure InitDrBereichGB;
    procedure InitExemplareGB;
    procedure InitRngBereichGB;
    procedure UpdateRngBereichGB;
    procedure InitAnzeigeGB;
    function  EingabeOK: Boolean;
    procedure DatenUebernehmen;
    //function  GetDefaultDrucker: String;
    function  DruckerAktualisieren: Boolean;

  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  AusgDialog: TAusgDialog;
  PgBisInitTxt : String;

implementation

uses RaveUnit, TriaMain, AllgFunc, DateiDlg, CmdProc, VeranObj,
     ListFmt,DatExp,VistaFix,SerienDr,UrkundeDlg;

{$R *.dfm}

procedure ReportDrucken; forward;
function  ReportPDFDatei: Boolean; forward;

//******************************************************************************
procedure ListAusgabe(Mode:TReportMode);
//******************************************************************************
begin
  ReportMode := Mode;

  if ReportMode = rmPrevPDFDatei then
  begin
    // Datei wie Vorschau erstellen, kein AusgabeDlg
    // NDRDatei vorher erstellt, RvReportType definiert
    ReportPDFDatei;
    Exit;
  end;

  if ReportMode = rmPrevDrucken then
  begin
    PgBisInitTxt := IntToStr(HauptFenster.PrevFrame.PrevUpDown.Max);
    ReportVorschauSchliessen;
  end else
    PgBisInitTxt := '1';

  ExportProgGestartet := false;
  ExportDateiAnsehen  := false;
  SerDrDateiAnsehen   := false;
  case ReportMode of
    rmTextDatei,
    rmSerDrEtiketten,
    rmSerDrUrk        : ExportDatFormat := ftText;
    rmExcelDatei      : ExportDatFormat := ftExcel;
    rmHTMLDatei       : ExportDatFormat := ftHTML;
    else                ExportDatFormat := ftKein;
  end;

  if ReportMode = rmSerDrEtiketten then
  begin
    if SerDrDateiErstellen and
       (TriaMessage('Die Seriendruckdatei für Etiketten wurde erfolgreich erstellt.'+#13+
                    'Möchten Sie die Datei anzeigen?',
                    mtConfirmation,[mbYes,mbNo]) = mrYes) then
      ExportDateiAnzeigen;
    Exit;
  end;

  AusgDialog := TAusgDialog.Create(HauptFenster);
  with AusgDialog do
  try
    if (ReportMode = rmExcelDatei) and not ExcelStart then Exit;
    case ReportMode of
      rmTextDatei,rmExcelDatei,rmHTMLDatei: ExportProgGestartet := true;
    end;
    if ShowModal <> mrOk then ExportDateiAnsehen  := false;
    HauptFenster.Refresh;
  finally
    if (ReportMode = rmExcelDatei) and ExportProgGestartet then
      ExcelStop; // muss vor ExportDialog.Free (Excel-Componenten)
    FreeAndNil(AusgDialog);
    // HauptFenster.Refresh;  leere Fläche lassen, damit deutlich ist, dass
    // noch was passiert 
  end;

  if ExportDateiAnsehen then ExportDateiAnzeigen; // nicht für Excel
end;

(******************************************************************************)
procedure ReportVorschauSchliessen;
(******************************************************************************)
begin
  RaveForm.ClearNDRDatei;
  HauptFenster.PrevFrame.Schliessen; // Daten bleiben vorhanden
  RaveForm.Close;
end;

//******************************************************************************
procedure ReportDrucken;
//******************************************************************************
// NDRDatei vorher erstellt, Parameter in DatenUebernehmen gesetzt
// RvNDRWriter benutzt RpDev-Eigenschaften (Drucker-Einstellungen,z.B. DuplexMode)
// ErstelleNDRDatei immer vor Ausgabe ausführen, damit alle Par. aktualisiert werden
begin
  HauptFenster.ProgressBarInit('Liste wird gedruckt',100);
  HauptFenster.ProgressBarStep(80);

  try
    with RaveForm.RvRenderPrinter do
    begin
      IgnoreFileSettings := false;  // default, Daten von RvNDRWriter übernehmen
      NDRStream := TriaNDRStream;
      Render;
    end;
  finally
    HauptFenster.StatusBarClear;
  end;
end;

//******************************************************************************
function ReportPDFDatei: Boolean;
//******************************************************************************
// von THauptFenster.PrevPdfDateiExecute und DruckAuswahl
var DateiBuf : String;
begin
  Result := false;
  DateiBuf := SysUtils.ChangeFileExt(TriDatei.Path,'.pdf');
  if SaveFileDialog('pdf',
                    'Adobe Acrobat Dokument (*.pdf)|*.pdf|Alle Dateien (*.*)|*.*',
                    SysUtils.ExtractFileDir(TriDatei.Path),
                    'PDF-Datei erstellen',
                    DateiBuf) then
  begin
    HauptFenster.ProgressBarInit('PDF Datei wird erstellt',100);
    HauptFenster.RefreshAnsicht;
    try
      if SysUtils.FileExists(DateiBuf) and not SysUtils.DeleteFile(DateiBuf) then
      begin
        TriaMessage('Vorhandene Datei  "'+ExtractFileName(DateiBuf)+
                    '"  kann nicht gelöscht werden.',
                     mtInformation,[mbOk]);
        Exit;
      end else Result := true;
      HauptFenster.ProgressBarStep(80);
      RaveForm.RvRenderPDF.PrintRender(TriaNDRStream,DateiBuf);
    finally
      HauptFenster.StatusBarClear;
    end;
  end;
end;

(******************************************************************************)
(*  Methoden TAusgDialog                                                      *)
(******************************************************************************)

// public Methoden

(*============================================================================*)
constructor TAusgDialog.Create(AOwner: TComponent);
(*============================================================================*)
var i,j   : Integer;
    RepWk : TReportWkObj;

begin
  inherited Create(AOwner);
  if not HelpDateiVerfuegbar then
  begin
    BorderIcons := [biSystemMenu];
    HilfeButton.Enabled := false;
  end;

  Updating       := false;
  DisableButtons := false;

  // Dialog-Layout abhängig von Ansicht und ReportMode:

  // ReportMode:   |Drucken|Prev|PrevDr|PDF|Exp|Urk
  // --------------|-------|----|------|---|---|---------------------------------
  // OptTlnSpalte  |   +   | +  |  -   | + | + | -
  // DrBereichGB   |   +   | -  |  +   | - | - | -
  // ExemplareGB   |   +   | -  |  +   | - | - | -
  // RngBereichGB  |   +   | +  |  -   | + | - | +
  // AnzeigeGB     |   -   | -  |  -   | - | + | -
  // DruckerBtn    |   +   | -  |  +   | - | - | -
  // SerienDrGB    |   -   | -  |  -   | - | - | +

  case ReportMode of
    rmDrucken,
    rmPrevDrucken: Caption := 'Drucken';
    rmVorschau:    Caption := 'Seitenansicht';
    rmPDFDatei:    Caption := 'PDF-Datei';
    rmTextDatei:   Caption := 'Textdatei';
    rmExcelDatei:  Caption := 'Excel-Datei';
    rmHTMLDatei:   Caption := 'HTML-Datei';
    rmSerDrUrk:    Caption := 'Seriendruck Urkunden';
    else // rmPrevPDFDatei,rmEtiketten: kein Dialog
  end;
  if ReportMode <> rmSerDrUrk then
    Caption := Caption + '  -  '+GetListName
  else
    if Veranstaltung.Serie then
      if HauptFenster.TlnAnsicht then
        if HauptFenster.Ansicht = anTlnErgSerie then
          Caption := Caption + '  -  Teilnehmer-Serienwertung '
        else
          Caption := Caption + '  -  Teilnehmer-Tageswertung '
      else
        if HauptFenster.Ansicht = anMschErgSerie then
          Caption := Caption + '  -  Mannschaften-Serienwertung '
        else
          Caption := Caption + '  -  Mannschaften-Tageswertung '
    else
      if HauptFenster.TlnAnsicht then
        Caption := Caption + '  -  Teilnehmer'
      else
        Caption := Caption + '  -  Mannschaften';

  // Init WettkCLB, alle Wettk Ansichtleiste incl. Sonderwertung
  with HauptFenster do
  begin
    WettkCLB.Items.Clear;
    with LstFrame.AnsFrame.WettkampfCB do
      for i:=0 to Items.Count-1 do
      begin
        RepWk := TReportWkObj(Items.Objects[i]);
        if (ReportMode <> rmSerDrUrk) or (RepWk.Wettk <> WettkAlleDummy) then
          WettkCLB.Items.AddObject(RepWk.Name,RepWk);
      end;
  end;
  with WettkCLB do
    if Items.Count > 1 then
    begin
      Enabled := true;
      if ReportMode = rmPrevDrucken then
      begin
        ItemIndex := -1;
        // Checkboxen vom Vorschau übernehmen
        for i:=0 to Items.Count-1 do
          for j:=0 to ReportWkListe.Count-1 do
            if (TReportWkObj(Items.Objects[i]).Wettk = TReportWkObj(ReportWkListe[j]).Wettk) and
               (TReportWkObj(Items.Objects[i]).Wrtg = TReportWkObj(ReportWkListe[j]).Wrtg) then
            begin
              Checked[i] := true;
              Break;
            end;
      end else
      begin
        if (ReportMode <> rmSerDrUrk) or
           (TReportWkObj(HauptFenster.LstFrame.AnsFrame.WettkampfCB.Items.Objects[0]).Wettk <> WettkAlleDummy) then
          ItemIndex := HauptFenster.LstFrame.AnsFrame.WettkampfCB.ItemIndex
        else
          ItemIndex := Max(HauptFenster.LstFrame.AnsFrame.WettkampfCB.ItemIndex-1,0); // WettkAlle nicht in Liste
        if (ItemIndex>=0)and(ItemIndex<Items.Count) then Checked[ItemIndex] := true;
      end
    end else
    begin
      Enabled := false;
      ItemIndex := -1;
      if Items.Count = 1 then Checked[0] := true;
    end;

  //if (HauptFenster.Ansicht = anTlnErgSerie) or
  //   (HauptFenster.Ansicht = anMschErgSerie) then WrtgAktuell := wgSerWrtg
  //else WrtgAktuell := HauptFenster.SortWrtg; // wgStandWrtg, wgSondWrtg
  InitWkDaten;

  if ReportMode = rmSerDrUrk then
  begin
    SerienDrGB.Visible := true;
    WordRB.Checked := true;
  end else
    SerienDrGB.Visible := false;

  case ReportMode of
    rmDrucken, rmPrevDrucken :
    begin
      DruckerLabel.Visible := true;
      DruckerCB.Visible    := true;
      DruckerBtn.Visible   := true;
      DruckerAktualisieren; // DefaultDrucker, Liste setzen
    end;
    else
    begin
      DruckerLabel.Visible := false;
      DruckerCB.Visible    := false;
      DruckerBtn.Visible   := false;
    end;
  end;

  case ReportMode of
    rmDrucken, rmPrevDrucken, rmPDFDatei :
      VorschauButton.Visible := true;
    else VorschauButton.Visible := false;
  end;

  // Dialog-Layout
  if not DruckerLabel.Visible then
    WettkLabel.Top := DruckerLabel.Top;

  WettkCLB.Top := WettkLabel.Top + 16;
  KlassenLabel.Top := WettkCLB.Top + WettkCLB.Height + 16;
  KlassenCLB.Top := KlassenLabel.Top + 16;

  TopNext := KlassenCLB.Top - 4;
  if LayoutGB.Visible then
  begin
    LayoutGB.Top := TopNext;
    TopNext := TopNext + LayoutGB.Height + 16;
  end;
  if RngBereichGB.Visible then
  begin
    RngBereichGB.Top := TopNext;
    TopNext := TopNext + RngBereichGB.Height + 16;
  end;
  if AnzeigeGB.Visible then
  begin
    AnzeigeGB.Top := TopNext;
    TopNext := TopNext + AnzeigeGB.Height + 16;
  end;
  if SerienDrGB.Visible then
  begin
    SerienDrGB.Top := TopNext;
    TopNext := TopNext + SerienDrGB.Height + 16;
  end;
  i := WettkCLB.Top - 16;
  AlleKlassenCB.Top  := Max(273+i,TopNext - 16 - AlleKlassenCB.Height);
  KlassenCLB.Height  := AlleKlassenCB.Top - 8 - KlassenCLB.Top;
  Panel1.Top         := AlleKlassenCB.Top + AlleKlassenCB.Height + 16;
  VorschauButton.Top := Panel1.Top + Panel1.Height + 12;
  OkButton.Top       := VorschauButton.Top;
  CancelButton.Top   := VorschauButton.Top;
  HilfeButton.Top    := VorschauButton.Top;
  ClientHeight       := VorschauButton.Top + VorschauButton.Height + 12;

  OkButton.Default := true;
  HelpFensterAlt := HelpFenster;
  HelpFenster := Self;
  SetzeFonts(Font);
  if ReportMode = rmPrevDrucken then ReportMode := rmDrucken;
end;

(*============================================================================*)
destructor TAusgDialog.Destroy;
(*============================================================================*)
begin
  HelpFenster := HelpFensterAlt;
  inherited Destroy;
end;

(*----------------------------------------------------------------------------*)
function TAusgDialog.WettkZahl : Integer;
(*----------------------------------------------------------------------------*)
// Sonderwertung nicht mitzählen, weil gleiche Alters- u. sonderklassen
var i : Integer;
begin
  Result := 0;
  with WettkCLB do
    for i:=0 to Items.Count - 1 do
      if Checked[i] then
        if (TReportWkObj(Items.Objects[i]).Wrtg = wgStandWrtg) or
           ((i>0) and not Checked[i-1]) then // SondWrtg nicht doppelt zählen
          Inc(Result);
end;

(*----------------------------------------------------------------------------*)
function TAusgDialog.WettkChecked : Integer;
(*----------------------------------------------------------------------------*)
// Sonderwertung mitzählen
var i : Integer;
begin
  Result := 0;
  with WettkCLB do
    for i:=0 to Items.Count - 1 do
      if Checked[i] then Inc(Result);
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.InitWkDaten;
//------------------------------------------------------------------------------
// nur in Create benutzt
begin
  //if WettkZahl = 0 then Exit;
  Updating := true;
  try
    InitKlassenCLB;
    InitLayoutGB;
    InitDrBereichGB;
    InitExemplareGB;
    InitRngBereichGB;
    InitAnzeigeGB;
  finally
    Updating := false;
  end;
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.UpdateWkDaten;
//------------------------------------------------------------------------------
// bei Wettk-Change
begin
  //if WettkZahl = 0 then Exit;
  Updating := true;
  try
    InitKlassenCLB;
    UpdateLayoutGB;
    UpdateRngBereichGB;
    //InitAnzeigeGB; kein Impact
  finally
    Updating := false;
  end;
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.InitKlassenCLB;
//------------------------------------------------------------------------------
// in Create (InitWkDaten) und bei Wettk-Änderung (UpdateWkDaten)
var i,j  : Integer;
    MName,WName : String;
    WkErst : TWettkObj;
    StaffelWk : Boolean;
//------------------------------------------------------------------------------
function KeinWkMitSexBeide: Boolean;
var i : Integer;
begin
  Result := false;
  for i:=0 to WettkCLB.Items.Count-1 do
    if WettkCLB.Checked[i] and
       (TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.SexSortMode = smSxBeide) then
      Exit;
  Result := true;
end;

//------------------------------------------------------------------------------
begin
  with KlassenCLB do with HauptFenster do //with WkAktuell do
  begin

    Items.BeginUpdate;
    Items.Clear;
    //AlleKlassenCB.Checked := false;

    Items.Add('Gesamtwertung');
    Header[0] := true;
    Items.AddObject(AkAlle.Name,AkAlle); // immer vorhanden

    // Männer/Frauen nur wenn wählbar in Ansichtsleiste
    // wichtig für Urkundendatei bei Erg. Listen
    // SexCB unabhängig vom WettkCB
    MName := ''; WName := ''; WkErst := nil; StaffelWk := false;
    if (WettkZahl > 0) and      // mindestens einen Wettk selektiert
       KeinWkMitSexBeide then   // und kein Wettk mit smSexBeide
      // Gesamtklassen Männer/Frauen
      if TlnAnsicht then
      begin
        for i:=0 to WettkCLB.Items.Count-1 do
        begin
          if WettkCLB.Checked[i] then
          begin
            if (TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.WettkArt = waTlnStaffel) or
               (TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.WettkArt = waTlnTeam) then
              StaffelWk := true;
            if WkErst = nil then
            begin
              WkErst := TReportWkObj(WettkCLB.Items.Objects[i]).Wettk;
              MName  := WkErst.MaennerKlasse[tmTln].Name;
              WName  := WkErst.FrauenKlasse[tmTln].Name;
            end else
            begin
              if not ContainsStr(MName,TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.MaennerKlasse[tmTln].Name) then
                MName := MName+'/'+TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.MaennerKlasse[tmTln].Name;
              if not ContainsStr(WName,TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.FrauenKlasse[tmTln].Name) then
                WName := WName+'/'+TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.FrauenKlasse[tmTln].Name;
            end;
          end;
        end;
        if WkErst<>nil then with WkErst do
        begin
          Items.AddObject(MName,MaennerKlasse[tmTln]);
          Items.AddObject(WName,FrauenKlasse[tmTln]);
          if StaffelWk then
            Items.AddObject(AkMixed.Name,AkMixed);
          // AltersKlassen/Sonderklassen wenn nur einen Wettkampf selektiert
          if WettkZahl = 1 then
          begin
            if AltMKlasseColl[tmTln].Count > 0 then
            begin
              Items.Add('Altersklassen Männlich');
              Header[Items.Count-1] := true;
              for i:=0 to AltMKlasseColl[tmTln].SortCount-1 do
                Items.AddObject(AltMKlasseColl[tmTln].SortItems[i].Name,
                                                AltMKlasseColl[tmTln].SortItems[i]);
            end;
            if AltWKlasseColl[tmTln].Count > 0 then
            begin
              Items.Add('Altersklassen Weiblich');
              Header[Items.Count-1] := true;
              for i:=0 to AltWKlasseColl[tmTln].SortCount-1 do
                Items.AddObject(AltWKlasseColl[tmTln].SortItems[i].Name,
                                                AltWKlasseColl[tmTln].SortItems[i]);
            end;
            if EinzelWettk and (SondMKlasseColl.Count > 0) then
            begin
              Items.Add('Sonderklassen Männlich');
              Header[Items.Count-1] := true;
              for i:=0 to SondMKlasseColl.SortCount-1 do
                Items.AddObject(SondMKlasseColl.SortItems[i].Name,
                                               SondMKlasseColl.SortItems[i]);
            end;
            if EinzelWettk and (SondWKlasseColl.Count>0) then
            begin
              Items.Add('Sonderklassen Weiblich');
              Header[Items.Count-1] := true;
              for i:=0 to SondWKlasseColl.SortCount-1 do
                Items.AddObject(SondWKlasseColl.SortItems[i].Name,
                                               SondWKlasseColl.SortItems[i]);
            end;
          end;
        end;
      end else // MschAnsicht
      begin
        for i:=0 to WettkCLB.Items.Count-1 do
        begin
          if WettkCLB.Checked[i] and
            (TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.SexSortMode <> smSxBeide) then
          begin
            if WkErst = nil then
            begin
              WkErst := TReportWkObj(WettkCLB.Items.Objects[i]).Wettk;
              MName := WkErst.MaennerKlasse[tmMsch].Name;
              WName := WkErst.FrauenKlasse[tmMsch].Name;
            end else
            begin
              if not ContainsStr(MName,TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.MaennerKlasse[tmMsch].Name) then
                MName := MName+'/'+TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.MaennerKlasse[tmMsch].Name;
              if not ContainsStr(WName,TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.FrauenKlasse[tmMsch].Name) then
                WName := WName+'/'+TReportWkObj(WettkCLB.Items.Objects[i]).Wettk.FrauenKlasse[tmMsch].Name;
            end;
          end;
        end;
        if WkErst<>nil then with WkErst do
        begin
          Items.AddObject(MName,MaennerKlasse[tmMsch]);
          Items.AddObject(WName,FrauenKlasse[tmMsch]);
          Items.AddObject(AkMixed.Name,AkMixed);
          // AltersKlassen wenn nur einen Wettkampf selektiert
          if WettkZahl = 1 then
          begin
            if AltMKlasseColl[tmMsch].Count > 0 then
            begin
              Items.Add('Altersklassen Männlich');
              Header[Items.Count-1] := true;
              for i:=0 to AltMKlasseColl[tmMsch].SortCount-1 do
                Items.AddObject(AltMKlasseColl[tmMsch].SortItems[i].Name,
                                              AltMKlasseColl[tmMsch].Sortitems[i]);
            end;
            if AltWKlasseColl[tmMsch].Count > 0 then
            begin
              Items.Add('Altersklassen Weiblich');
              Header[Items.Count-1] := true;
              for i:=0 to AltWKlasseColl[tmMsch].SortCount-1 do
                Items.AddObject(AltWKlasseColl[tmMsch].SortItems[i].Name,
                                              AltWKlasseColl[tmMsch].SortItems[i]);
            end;
          end;
        end;
      end;

    // alles zurücksetzen
    for i:=0 to Items.Count-1 do Checked[i] := false;
    AlleKlassenCB.Checked := false;

    if WettkZahl > 0 then // mindestens einen Wettk selektiert
    begin
      if ReportMode = rmPrevDrucken then
      begin
        AlleKlassenCB.Checked := ReportAlleKlassen;
        ItemIndex := -1;
        // Checkboxen vom Vorschau übernehmen
        for i:=0 to Items.Count-1 do
          if not Header[i] then
            for j:=0 to ReportAkListe.Count-1 do
              if (TAkObj(Items.Objects[i]).Sex = TAkObj(ReportAkListe[j]).Sex) and
                 (TAkObj(Items.Objects[i]).Wertung = TAkObj(ReportAkListe[j]).Wertung) and
                 (TAkObj(Items.Objects[i]).AlterVon = TAkObj(ReportAkListe[j]).AlterVon) and
                 (TAkObj(Items.Objects[i]).AlterBis = TAkObj(ReportAkListe[j]).AlterBis) then
              begin
                Checked[i] := true;
                Break;
              end;
      end else
      begin
        ItemIndex := Items.IndexOfObject(SortKlasse);
        if ItemIndex < 0 then ItemIndex := 1; // Alle
        if (ItemIndex >= 0) and not Header[ItemIndex] then
          Checked[ItemIndex] := true
        else Checked[1] := true; // Alle
      end;
      if Items.Count = 2 then // nur Alle
      begin
        ItemIndex := -1;
        KlassenCLB.Enabled := false;
        AlleKlassenCB.Enabled := false;
        AlleKlassenCB.Checked := false;
      end else
      begin
        if AlleKlassenCB.Checked then KlassenCLB.Enabled := false
                                 else KlassenCLB.Enabled := true;
        AlleKlassenCB.Enabled := true;
      end;
    end else
    begin
      KlassenCLB.Enabled := false;
      AlleKlassenCB.Enabled := false;
    end;

    Items.EndUpdate; // reenable repaints
  end;
end;

//------------------------------------------------------------------------------
function TAusgDialog.KlassenAnzahlChecked: Integer;
//------------------------------------------------------------------------------
var i : Integer;
begin
  Result := 0;
  with KlassenCLB do
    for i:=0 to Items.Count-1 do
      if not Header[i] and Checked[i] then Inc(Result);
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.InitLayoutGB;
//------------------------------------------------------------------------------
// nur in Create aufgerufen
//------------------------------------------------------------------------------
function SpalteLandDefiniert: Boolean;
// unabhängig von WettkCLB Checked-Status
var i : Integer;
begin
  Result := false;
  if (HauptFenster.Ansicht<>anTlnStart) and (HauptFenster.Ansicht<>anTlnErg) or
     (WettkZahl = 0) then Exit;
  with WettkCLB do
    for i:=0 to Items.Count - 1 do
      if not StrGleich(TReportWkObj(Items.Objects[i]).Wettk.TlnTxt,'') then
      begin
        Result := true;
        Exit;
      end;
end;
//------------------------------------------------------------------------------
begin
  NewPageMoeglich := false;
  WkNewPageStatus := true;  // default gesetzt
  AkNewPageStatus := false; // default nicht gesetzt

  case ReportMode of
    rmDrucken,rmVorschau,rmPDFDatei,rmPrevDrucken:
      if HauptFenster.Ansicht = anTlnSchwDist then
        LayoutGB.Visible := false
      else
      begin
        LayoutGB.Visible := true;
        NewPageMoeglich  := true;
      end;

    rmTextDatei,rmExcelDatei,rmHTMLDatei:
      if (HauptFenster.Ansicht = anTlnSchwDist) or not SpalteLandDefiniert then
        LayoutGB.Visible := false
      else
      begin
        LayoutGB.Visible := true;
        NewPageMoeglich  := false;
      end;

    else LayoutGB.Visible := false;
  end;

  if LayoutGB.Visible then UpdateLayoutGB;
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.UpdateLayoutGB;
//------------------------------------------------------------------------------
// bei UpdateWkDaten und Klassen-Änderung aufgerufen
var i    : Integer;
    S    : String;
    UpdatingAlt : Boolean;

//------------------------------------------------------------------------------
function SpalteLandDefiniert: Boolean;
// abhängig von WettkCLB Checked-Status
var i : Integer;
begin
  Result := false;
  if (HauptFenster.Ansicht<>anTlnStart) and (HauptFenster.Ansicht<>anTlnErg) or
     (WettkZahl = 0) then Exit;
  with WettkCLB do
    for i:=0 to Items.Count - 1 do
      if Checked[i] and not StrGleich(TReportWkObj(Items.Objects[i]).Wettk.TlnTxt,'') then
      begin
        Result := true;
        Exit;
      end;
end;

//------------------------------------------------------------------------------
function GleichesWkAkListenFormat(var LT: TListType; RepWk:TReportWkObj): Boolean;
// ListTypen müssen für alle Klassen innerhalb Wettk gleich sein (MschErgCompact)
// oder keine gültige ListType
var i : Integer;
    RepTypeAlt,RepTypeNeu : TListType;
begin
  Result     := true;
  LT         := ltFehler;
  RepTypeNeu := ltFehler;
  RepTypeAlt := ltFehler;
  with RepWk do
    for i:=0 to KlassenCLB.Items.Count-1 do
      if KlassenCLB.Checked[i] then
      begin
        RepTypeNeu := GetListType(lmReport,Wettk,Wrtg,Wettk.MschGroesse[TAkObj(KlassenCLB.Items.Objects[i]).Sex]);
        if RepTypeAlt = ltFehler then // 1. Ak aus Liste
          RepTypeAlt := RepTypeNeu
        else
          if RepTypeNeu <> RepTypeAlt then
          begin
            Result := false; // ungleich
            Exit;
          end;
      end;
  LT := RepTypeNeu; // gleich für alle Klassen
end;

//------------------------------------------------------------------------------
function GleichesWkListenFormat: Boolean;
var i : Integer;
    RepTypeneu,RepTypeAlt : TListType;
    WkMschWrtgMode : TMschWrtgMode;
    Schultour : Boolean;
begin
  Result         := false;
  RepTypeNeu     := ltFehler;
  RepTypeAlt     := ltFehler;
  WkMschWrtgMode := wmTlnZeit; // default
  Schultour      := false;

  with WettkCLB do
    for i:=0 to Items.Count-1 do
      if Checked[i] then
        with TReportWkObj(Items.Objects[i]) do
        begin
          if not GleichesWkAkListenFormat(RepTypeNeu,TReportWkObj(Items.Objects[i])) then
            Exit;
          if RepTypeAlt = ltFehler then // 1. Wk aus Liste
          begin
            RepTypeAlt := RepTypeNeu;
            WkMschWrtgMode := Wettk.MschWrtgMode;
            Schultour := WkMschWrtgMode = wmSchultour;
          end else
            if RepTypeNeu <> RepTypeAlt then Exit
            else
            begin
              // bei MschErgListen muss MschWrtgMode für alle Wettk gleich sein
              case RepTypeNeu of
                ltErgLstMschTln,ltErgLstMschTlnRnd,ltErgLstMschTlnRndL,
                ltErgLstMschTln2,ltErgLstMschTln3,ltErgLstMschTln4,ltErgLstMschTln5,
                ltErgLstMschTln6,ltErgLstMschTln7,ltErgLstMschTln8:
                  if WkMschWrtgMode <> Wettk.MschWrtgMode then Exit;
              end;
              // entweder alle Schultour oder keine Schultour wegen Spaltenüberschrift Mannschaften
              if Wettk.MschWrtgMode = wmSchultour <> Schultour then Exit;
            end;
        end;
  Result := true;
end;

//------------------------------------------------------------------------------
function GleichesAkListenFormat : Boolean;
// für alle Wk gleiche ListType innerhalb Wk
var i : Integer;
    RepTypeDummy : TListType;
begin
  Result := false;
  with WettkCLB do
    for i:=0 to Items.Count-1 do
      if Checked[i] then
        if not GleichesWkAkListenFormat(RepTypeDummy,TReportWkObj(Items.Objects[i])) then
          Exit;
  Result := true;
end;

//------------------------------------------------------------------------------
begin
  UpdatingAlt := Updating;
  Updating    := true;

  if LayoutGB.Visible then
  begin
    // WkNewPageCB
    if NewPageMoeglich and (WettkChecked > 1) then
      if GleichesWkListenFormat then // alle ListTypen gleich, gemeinsame Liste erlauben
      begin
        WkNewPageCB.Enabled := true;
        if ReportMode<>rmPrevDrucken then
          WkNewPageCB.Checked := WkNewPageStatus
        else
          WkNewPageCB.Checked := ReportNewWkPage;
      end else // Ungleich, Listen getrennt pro Wettk
      begin
        WkNewPageCB.Enabled := false;
        WkNewPageCB.Checked := true;
      end
    else // gemeinsame Liste
    begin
      WkNewPageCB.Enabled := false;
      WkNewPageCB.Checked := false;
    end;

    // AkNewPageCB
    if NewPageMoeglich and (KlassenAnzahlChecked > 1) and
       ((WettkChecked = 1) or WkNewPageCB.Checked) then
      if GleichesAkListenFormat then // gemeinsame Liste pro Wettk erlauben
      begin
        AkNewPageCB.Enabled := true;
        if ReportMode<>rmPrevDrucken then
          AkNewPageCB.Checked := AkNewPageStatus
        else
          AkNewPageCB.Checked := ReportNewAkPage;
      end else // Ungleich, Listen getrennt pro Wettk
      begin
        AkNewPageCB.Enabled := false;
        AkNewPageCB.Checked := true;
      end
    else // gemeinsame Liste
    begin
      AkNewPageCB.Enabled := false;
      AkNewPageCB.Checked := false;
    end;

    // OptTlnSpalte
    OptTlnSpalteCB.Enabled := SpalteLandDefiniert;
    if ReportMode<>rmPrevDrucken then
      OptTlnSpalteCB.Checked := OptTlnSpalteCB.Enabled
    else
      OptTlnSpalteCB.Checked := ReportTlnSpalte = tsMitTlnTxtSpalte;

    // OptTlnSpalte-Text
    S := '';
    if SpalteLandDefiniert then with WettkCLB do
    begin
      for i:=0 to Items.Count-1 do
      begin
        if Checked[i] then
          if S = '' then S:= TReportWkObj(Items.Objects[i]).Wettk.TlnTxt
          else if (TReportWkObj(Items.Objects[i]).Wettk.TlnTxt <> '')and
                  (TReportWkObj(Items.Objects[i]).Wettk.TlnTxt <> S) then
          begin
            S := ''; // Text Blank bei unterschiedlichen Definitionen
            Break;
          end;
      end;
    end;
    if S <> '' then S := '"'+S+'"';
    OptTlnSpalteCB.Caption := 'Optionale Spalte '+S+' einfügen';

  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.InitDrBereichGB;
//------------------------------------------------------------------------------
begin
  case ReportMode of
    rmDrucken,rmPrevDrucken: DrBereichGB.Visible := true;
    else DrBereichGB.Visible := false;
  end;

  if DrBereichGB.Visible then
  begin
    PgVonEdit.EditMask := '099;0; ';
    PgBisEdit.EditMask := '099;0; ';
    PgVonUpDown.Min := 1;
    PgBisUpDown.Min := 1;
    PgVonEdit.Text  := '1';
    PgVonUpDown.Max := cnSeiteMax; // auch nach Preview, weil änderbar
    PgBisUpDown.Max := cnSeiteMax;
    PgBisEdit.Text  := PgBisInitTxt; // bei Preview Wert von PrevFrm, sonst 1
    PgAlleRB.Checked := true; // nach Setzen der Edit-Felder
    PgVonEdit.Enabled := false;
    PgBisEdit.Enabled := false;
    PgVonUpDown.Enabled := false;
    PgBisUpDown.Enabled := false;
    PgBisLabel.Enabled := false;
  end;
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.InitExemplareGB;
//------------------------------------------------------------------------------
begin
  case ReportMode of
    rmDrucken,rmPrevDrucken: ExemplareGB.Visible := true;
    else ExemplareGB.Visible := false;
  end;

  if ExemplareGB.Visible then
  begin
    AnzahlEdit.EditMask := '099;0; ';
    AnzahlUpDown.Min := 1;
    AnzahlUpDown.Max := cnKopienMax;
    AnzahlEdit.Text  := '1';
    SortierCB.Enabled := false;
    SortierCB.Checked := false;
  end;
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.InitRngBereichGB;
//------------------------------------------------------------------------------
// nur in Create benutzt (in InitWkDaten)
//..............................................................................
procedure SetzeRngBereich;
begin
  RngBereichGB.Visible := true;
  if (ReportMode=rmPrevDrucken) and
     (ReportRngVon>0) and (ReportRngBis<cnTlnMax) then
  begin
    RngVonEdit.EditMask := '0999;0; ';
    RngBisEdit.EditMask := '0999;0; ';
    RngVonBisRB.Checked := true;
    RngVonEdit.Text := IntToStr(ReportRngVon);
    RngBisEdit.Text := IntToStr(ReportRngBis);
  end
  else RngAlleRB.Checked := true;
  UpdateRngBereichGB;
end;
//..............................................................................
begin
  RngVonUpDown.Min := 0;
  RngVonUpDown.Max := cnTlnMax;
  RngBisUpDown.Min := 0;
  RngBisUpDown.Max := cnTlnMax;
  RngBereichGB.Visible := false;

  case ReportMode of
    rmDrucken,rmVorschau,rmPDFDatei,rmTextDatei,rmExcelDatei,rmPrevDrucken:
      case HauptFenster.Ansicht of
        anTlnErg,anTlnErgSerie,anMschErgDetail,anMschErgKompakt,anMschErgSerie:
          SetzeRngBereich;
      end;
    rmSerDrUrk:
      case HauptFenster.Ansicht of
        anTlnErg,anTlnErgSerie,anMschErgDetail,anMschErgKompakt,anMschErgSerie,
        anAnmEinzel,anAnmSammel,anTlnStart,anMschStart:
          SetzeRngBereich;
      end;
  end;
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.UpdateRngBereichGB;
//------------------------------------------------------------------------------
// in InitRngBereichGB (Create), Wettk-Änderung (UpdateWkDaten), Klassen-Änderung
// ...
// RadioButtons vorher gesetzt, hier nicht ändern
var i,j,RngMax : Integer;
    RepWk : TReportWkObj;
    UpdatingAlt : Boolean;
begin
  if not RngBereichGB.Visible then Exit;
  UpdatingAlt := Updating;
  Updating    := true;

  RngMax := 0;

  case ReportMode of
    rmDrucken,rmVorschau,rmPDFDatei,rmTextDatei,rmExcelDatei,rmSerDrUrk,rmPrevDrucken:
      with WettkCLB do
      begin
        for i:=0 to Items.Count-1 do
        begin
          if Checked[i] then
          begin
            RepWk := TReportWkObj(Items.Objects[i]);
            case HauptFenster.Ansicht of
              anTlnErg,anAnmEinzel,anAnmSammel,anTlnStart: // letzte 3 nur für rmSerDrUrk
                for j:=0 to KlassenCLB.Items.Count-1 do
                  if not KlassenCLB.Header[j] and KlassenCLB.Checked[j] then
                    RngMax := Max(RngMax,Veranstaltung.TlnColl.TagesRngMax(RepWk.Wettk,RepWk.Wrtg,
                                                          TAkObj(KlassenCLB.Items.Objects[j])));
              anTlnErgSerie:
                for j:=0 to KlassenCLB.Items.Count-1 do
                  if not KlassenCLB.Header[j] and KlassenCLB.Checked[j] then
                    RngMax := Max(RngMax,Veranstaltung.TlnColl.SerieRngMax(RepWk.Wettk,
                                                         TAkObj(KlassenCLB.Items.Objects[j])));
              anMschErgDetail,anMschErgKompakt,anMschStart:
                for j:=0 to KlassenCLB.Items.Count-1 do
                  if not KlassenCLB.Header[j] and KlassenCLB.Checked[j] then
                    RngMax := Max(RngMax,Veranstaltung.MannschColl.TagesRngMax(RepWk.Wettk,
                                                         TAkObj(KlassenCLB.Items.Objects[j])));
              anMschErgSerie:
                for j:=0 to KlassenCLB.Items.Count-1 do
                  if not KlassenCLB.Header[j] and KlassenCLB.Checked[j] then
                    RngMax := Max(RngMax,Veranstaltung.MannschColl.SerieRngMax(RepWk.Wettk,
                                                         TAkObj(KlassenCLB.Items.Objects[j])));
            end;
          end;
        end;

        RngVonUpDown.Max := RngMax;
        RngBisUpDown.Max := RngMax;
        if RngAlleRB.Checked then
        begin
          RngVonEdit.Enabled := false;
          RngBisEdit.Enabled := false;
          RngBisLabel.Enabled := false;
          RngVonUpDown.Enabled := false;
          RngBisUpDown.Enabled := false;
          RngVonUpDown.Min := 0;
          RngBisUpDown.Min := 0;
          RngVonEdit.Text  := '0';
          RngBisEdit.Text  := IntToStr(RngMax);
        end else
        begin
          RngVonEdit.Enabled := true;
          RngBisEdit.Enabled := true;
          RngVonUpDown.Enabled := true;
          RngBisLabel.Enabled := true;
          RngBisUpDown.Enabled := true;
          RngVonUpDown.Min := Min(RngMax,1);
          RngBisUpDown.Min := RngVonUpDown.Min;
          // Text an Limits anpassen
          if StrToIntDef(RngVonEdit.Text,0) < RngVonUpDown.Min then
            RngVonEdit.Text := IntToStr(RngVonUpDown.Min);
          if StrToIntDef(RngVonEdit.Text,0) > RngVonUpDown.Max then
            RngVonEdit.Text := IntToStr(RngVonUpDown.Max);
          if StrToIntDef(RngBisEdit.Text,0) < RngBisUpDown.Min then
            RngBisEdit.Text := IntToStr(RngBisUpDown.Min);
          if StrToIntDef(RngBisEdit.Text,0) > RngBisUpDown.Max then
            RngBisEdit.Text := IntToStr(RngBisUpDown.Max);
        end;
      end;
    else // RngBereichGB not visible
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.InitAnzeigeGB;
//------------------------------------------------------------------------------
begin
  case ReportMode of
    rmTextDatei:
    begin
      AnzeigeGB.Visible := true;
      Caption := 'Liste in Textdatei speichern';
      AnzeigeGB.Caption := 'Texteditor';
    end;
    rmExcelDatei:
    begin
      AnzeigeGB.Visible := true;
      Caption := 'Liste in Excel-Datei speichern';
      AnzeigeGB.Caption := 'Microsoft Excel';
    end;
    rmHTMLDatei:
    begin
      AnzeigeGB.Visible := true;
      Caption := 'Liste in HTML-Datei speichern';
      AnzeigeGB.Caption := 'Internet Browser';
    end
    else AnzeigeGB.Visible := false;
  end;
  if AnzeigeGB.Visible then AnzeigeCB.Checked := true;
end;


//------------------------------------------------------------------------------
function TAusgDialog.EingabeOk: Boolean;
//------------------------------------------------------------------------------
  // Eingaben prüfen
begin
  Result := false;

  // ReportDrucker prüfen
  with DruckerCB do
  if Visible then
    if ItemIndex < 0 then
    begin
      TriaMessage(Self,'Es wurde kein Drucker ausgewählt.',mtInformation,[mbOk]);
      Exit;
    end else
    if not RpDev.SelectPrinter(Items[ItemIndex],true) then
    begin
      TriaMessage(Self,'Auf Drucker "'+Items[ItemIndex]+'" kann nicht zugegriffen werden.',
                   mtInformation,[mbOk]);
      DruckerAktualisieren;
      Exit;
    end;

  if ExemplareGB.Visible then
    if not AnzahlEdit.ValidateEdit then Exit;

  if PgVonBisRB.Checked then
  begin
    if not PgVonEdit.ValidateEdit then Exit;
    if not PgBisEdit.ValidateEdit then Exit;
    if StrToIntDef(PgVonEdit.Text,0) > StrToIntDef(PgBisEdit.Text,0) then
    begin
      TriaMessage(Self,'Der Druckbereich ist ungültig.',mtInformation,[mbOk]);
      if PgVonEdit.CanFocus then PgVonEdit.SetFocus;
      Exit;
    end;
  end;
  
  if WettkChecked = 0 then
  begin
    TriaMessage(Self,'Es muss mindestens einen Wettkampf gewählt werden.',mtInformation,[mbOk]);
    Exit;
  end;

  if KlassenAnzahlChecked = 0 then
  begin
    TriaMessage(Self,'Es muss mindestens eine Klasse gewählt werden.',mtInformation,[mbOk]);
    Exit;
  end;

  if RngVonBisRB.Checked then
  begin
    if (StrToIntDef(RngVonEdit.Text,0) < RngVonEdit.UpDown.Min) or
       (StrToIntDef(RngVonEdit.Text,0) > RngVonEdit.UpDown.Max)then
    begin
      TriaMessage(Self,'Der eingegebene Wert ist ungültig. Erlaubt sind Werte von ' +
                  IntToStr(RngVonEdit.UpDown.Min)+' bis '+IntToStr(RngVonEdit.UpDown.Max)+'.',
                  mtInformation,[mbOk]);
      if RngVonEdit.CanFocus then RngVonEdit.SetFocus;
      Exit;
    end;
    if (StrToIntDef(RngBisEdit.Text,0) < RngBisEdit.UpDown.Min) or
       (StrToIntDef(RngBisEdit.Text,0) > RngBisEdit.UpDown.Max) then
    begin
      TriaMessage(Self,'Der eingegebene Wert ist ungültig. Erlaubt sind Werte von ' +
                  IntToStr(RngBisEdit.UpDown.Min)+' bis '+IntToStr(RngBisEdit.UpDown.Max)+'.',
                  mtInformation,[mbOk]);
      if RngBisEdit.CanFocus then RngBisEdit.SetFocus;
      Exit;
    end;
    if (StrToIntDef(RngVonEdit.Text,0) > StrToIntDef(RngBisEdit.Text,0)) then
    begin
      TriaMessage(Self,'Bereich der Platzierungen ist ungültig.',mtInformation,[mbOk]);
      if RngVonEdit.CanFocus then RngVonEdit.SetFocus;
     Exit;
    end;
  end;

  Result := true;
end;

//------------------------------------------------------------------------------
procedure TAusgDialog.DatenUebernehmen;
//------------------------------------------------------------------------------
// nach EingabeOk
var i  : Integer;
    Ak : TAkObj;
    RepWk : TReportWkObj;
begin

  // gewählte Wettkämpfe übernehmen (wgStandWrtg+wgSondWrtg in Liste)
  if ReportWkListe.Count > 0 then ReportWkListe.Clear;
  with WettkCLB do
    for i:=0 to Items.Count-1 do
      if Checked[i] then
      begin
        with TReportWkObj(Items.Objects[i]) do
          RepWk := TReportWkObj.Create(Wettk,Wrtg);
        ReportWkListe.Add(RepWk);
      end;

  // gewählte Klassen übernehmen
  if ReportAkListe.Count > 0 then ReportAkListe.Clear;
  with KlassenCLB do
    for i:=0 to Items.Count-1 do
      if not Header[i] and Checked[i] then
      begin
        Ak := TAkObj.Create(Veranstaltung,nil,oaNoAdd);
        with TAkObj(Items.Objects[i]) do
          Ak.Init(Name,Kuerzel,AlterVon,AlterBis,Sex,Wertung);
        ReportAkListe.Add(Ak);
      end;
  if AlleKlassenCB.Checked then ReportAlleKlassen := true
                           else ReportAlleKlassen := false;

  // LayoutGB
  if LayoutGB.Visible then
  begin
    if WkNewPageCB.Checked then ReportNewWkPage := true
                           else ReportNewWkPage := false;
    if AkNewPageCB.Checked then ReportNewAkPage := true
                           else ReportNewAkPage := false;
    if OptTlnSpalteCB.Checked then ReportTlnSpalte := tsMitTlnTxtSpalte
                              else ReportTlnSpalte := tsOhneTlnTxtSpalte;
  end;

  if HauptFenster.Ansicht = anTlnSchwDist then // LayoutGB nicht Visible
  begin
    if WettkChecked > 1 then ReportNewWkPage := true
                        else ReportNewWkPage := false;
    ReportNewAkPage := false; // nur einmal Execute, aber bei Titel3-Änderung
                              // (= Bahn- und Startzeit) immer neue Seite
  end;

  // DrBereichGB übernehmen (für RvNDRWriter in ErstelleNDRDatei)
  if DrBereichGB.Visible and not PgAlleRB.Checked then
  begin
    ReportSeiteVon := StrToIntDef(PgVonEdit.Text,0);
    ReportSeiteBis := StrToIntDef(PgBisEdit.Text,0);
  end else
  begin
    ReportSeiteVon := 1;
    ReportSeiteBis := cnSeiteMax;
  end;

  // ExemplareGB übernehmen (in RpDev für RvNDRWriter)
  // RpDev.Copies und Collate haben aber nur beim Drucken eine Funktion (RvRenderPrinter)
  // scheinen sonst nicht wirksam, trotzdem hier sicherheitshalber unterschiedlich gesetzt
  // müssen aber schon in RvNDRWriter gesetzt sein, funktioniert nicht bei RvRenderPrinter
  if ReportMode = rmDrucken then
  begin
    ReportAnzahlKopien := StrToIntDef(AnzahlEdit.Text,1);
    if SortierCB.Checked then ReportKopienSortieren := true
                         else ReportKopienSortieren := false;
    ReportDrucker := RpDev.Device;
  end else
  begin
    ReportAnzahlKopien    := 1;
    ReportKopienSortieren := false;
  end;

  // RngBereichGB
  if RngBereichGB.Visible and not RngAlleRB.Checked then
  // Msch bei Liga mit Rng=0 ausfiltern, sonst wird über SortStatus gefiltert
  begin
    ReportRngVon := StrToIntDef(RngVonEdit.Text,0);
    ReportRngBis := StrToIntDef(RngBisEdit.Text,0);
  end else
  begin
    ReportRngVon := 0;
    ReportRngBis := cnTlnMax;
  end;

  // AnzeigeGB
  if AnzeigeGB.Visible and AnzeigeCB.Checked then
    ExportDateiAnsehen := true
  else
    ExportDateiAnsehen := false;

  if SerienDrGB.Visible and TextDateiRB.Checked and TextAnzeigenCB.Checked then
    SerDrDateiAnsehen := true
  else
    SerDrDateiAnsehen := false;
end;


//------------------------------------------------------------------------------
function TAusgDialog.DruckerAktualisieren: Boolean;
//------------------------------------------------------------------------------
// ReportDrucker, DefaultDrucker und Liste aktualisiert
// ReportDrucker bleibt normalerweise unverändert, nicht wenn nicht mehr vorhanden
var i : Integer;
begin
  Result := false;
  DefaultDrucker := '';

  // Druckerliste aktualisieren
  // Liste der installierten Drucker kann sich nach Programmstart geändert haben
  Printer.Refresh;
  Printer.PrinterIndex := -1; // setze default printer
  RPDevice.RefreshDevice; // auch für Rave

  if RpDev.InvalidPrinter or (Printer.PrinterIndex < 0) then
  begin
    if Self.Visible then
      TriaMessage(Self,'Es wurde kein Drucker installiert.'+#13+
                  'Bitte installieren Sie einen Drucker in der Windows-Systemsteuerung.',
                  mtInformation,[mbOk])
    else // während Create
      TriaMessage('Es wurde kein Drucker installiert.'+#13+
                  'Bitte installieren Sie einen Drucker in der Windows-Systemsteuerung.',
                  mtInformation,[mbOk]);
    ReportDrucker := '';
    Exit;
  end;

  //DefaultDrucker := Printer.Printers[Printer.PrinterIndex]; // aktualisierter Windows DefaultPrinter
  DefaultDrucker := RpDev.Device; // Windows DefaultPrinter für Rave

  with DruckerCB do
  begin
    Items.Clear;
    for i:=0 to Printer.Printers.Count-1 do
      Items.Add(Printer.Printers[i]);
    //for i:=0 to RpDev.Printers.Count-1 do
    //  Items.Add(RpDev.Printers[i]);
    // ReportDrucker prüfen und aktualisieren
    if (ReportDrucker = '' ) or // nicht definiert
       (Printer.Printers.IndexOf(ReportDrucker) < 0) then // nicht vorhanden
      ReportDrucker := Printer.Printers[Printer.PrinterIndex];
    DruckerCB.ItemIndex := Items.IndexOf(ReportDrucker);
  end;
end;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.WettkLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if WettkCLB.CanFocus then WettkCLB.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.WettkCLBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// bei Click auf ItemText und ItemCB durchgeführt
begin
  with WettkCLB do
    Checked[ItemIndex] := not Checked[ItemIndex];
  UpdateWkDaten;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.WettkCLBClickCheck(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// bei Click auf Checkbox (auch auf CB-Position in Items ohne CB!!) zuerst
// ausgeführt, danach WettkCLBClick
// bei Click auf Item-Text, nur WettkCLBClick
begin
  with WettkCLB do
    //CheckBox invertieren, wird nachher in KlassenCLB nochmals invertiert
    Checked[ItemIndex] := not Checked[ItemIndex];
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.KlassenLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if KlassenCLB.CanFocus then KlassenCLB.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.KlassenCLBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// bei Click auf ItemText und ItemCB durchgeführt
begin
  with KlassenCLB do
    if not Header[ItemIndex] then
    begin
      Checked[ItemIndex] := not Checked[ItemIndex];
      UpdateLayoutGB;
      //UpdateAkNewPageCB;
      UpdateRngBereichGB;
    end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.KlassenCLBClickCheck(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// bei Click auf Checkbox (auch auf CB-Position in Items ohne CB!!) zuerst
// ausgeführt, danach KlassenCLBClick
// bei Click auf Item-Text, nur KlassenCLBClick
begin
  with KlassenCLB do
    if not Header[ItemIndex] then
      //CheckBox invertieren, wird nachher in KlassenCLB nochmals invertiert
      Checked[ItemIndex] := not Checked[ItemIndex];
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.AlleKlassenCBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var i : Integer;
begin
  if not Updating then
  begin
    with KlassenCLB do
    begin
      if AlleKlassenCB.Checked then
      begin
        for i:=0 to Items.Count-1 do
          if not Header[i] then
          begin
            Checked[i] := true;
            ItemEnabled[i] := false;
          end;
        Enabled := false;
        ItemIndex := -1;
      end else
      begin
        for i:=0 to Items.Count-1 do
          if not Header[i] then
            ItemEnabled[i] := true;
        Enabled := true;
      end;
      Refresh;
    end;
    UpdateLayoutGB;
    //UpdateAkNewPageCB;
    UpdateRngBereichGB;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.WkNewPageCBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if WkNewPageCB.Enabled then WkNewPageStatus := WkNewPageCB.Checked;
  if not Updating then UpdateLayoutGB;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.AkNewPageCBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AkNewPageCB.Enabled then AkNewPageStatus := AkNewPageCB.Checked;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.DruckerLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if DruckerCB.CanFocus then DruckerCB.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.PgAlleRBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating then InitDrBereichGB;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.PgVonBisRBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating then
  begin
    Updating := true;
    PgVonBisRB.Checked := true;
    PgVonEdit.Enabled := true;
    PgBisEdit.Enabled := true;
    PgVonUpDown.Enabled := true;
    PgBisUpDown.Enabled := true;
    PgBisLabel.Enabled := true;
    if PgVonEdit.CanFocus then PgVonEdit.SetFocus;
    Updating := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.PgVonBisRBEnter(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating and PgVonEdit.CanFocus then PgVonEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.PgEditClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating then
  begin
    Updating := true;
    PgVonBisRB.Checked := true;
    Updating := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.PgBisLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating and PgBisEdit.CanFocus then PgBisEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.RngAlleRBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating then
  begin
    Updating := true;
    UpdateRngBereichGB;
    Updating := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.RngVonBisRBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating then
  begin
    Updating := true;
    UpdateRngBereichGB;
    if RngVonEdit.CanFocus then RngVonEdit.SetFocus;
    Updating := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.RngVonBisRBEnter(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating and RngVonEdit.CanFocus then RngVonEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.RngEditClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating then
    if not RngVonBisRB.Checked then
    begin
      Updating := true;
      RngVonBisRB.Checked := true;
      UpdateRngBereichGB;
      Updating := false;
    end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.RngBisLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating and RngBisEdit.CanFocus then RngBisEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.TextDateiRBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating and TextDateiRB.Checked then
    TextAnzeigenCB.Enabled := true;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.WordRBClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating and WordRB.Checked then
    TextAnzeigenCB.Enabled := false;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.AnzahlEditChange(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not Updating then
    if StrToIntDef(AnzahlEdit.Text,1) > 1 then
      if not SortierCB.Enabled then
      begin
        SortierCB.Checked := true;
        SortierCB.Enabled := true;
      end else // keine Änderung
    else
    begin
      SortierCB.Checked := false;
      SortierCB.Enabled := false;
    end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.DruckerBtnClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var Idx : Integer;
begin
  Printer.Refresh;
  Idx := DruckerCB.ItemIndex;
  if (Idx < 0) or
     (Printer.Printers.IndexOf(DruckerCB.Items[Idx]) < 0) then
  begin
    TriaMessage(Self,'Kein gültiger Drucker gewählt.',mtInformation,[mbOk]);
    Exit;
  end else
    Printer.PrinterIndex := Printer.Printers.IndexOf(DruckerCB.Items[Idx]);

  with PrintDialog do
  begin
    Options  := [poPageNums];// poPageNums, poSelection
    FromPage := StrToIntDef(PgVonEdit.Text,1);
    MinPage  := 1;
    ToPage   := StrToIntDef(PgBisEdit.Text,1);
    MaxPage  := cnSeiteMax;
    Copies   := StrToIntDef(AnzahlEdit.Text,1);
    Collate  := SortierCB.Checked; // Collate bleibt immer false
    if PgAlleRB.Checked then
      PrintRange := prAllPages // prAllPages, prSelection, prPageNums
    else
      PrintRange := prPageNums;

    if Execute then
    begin
      // Liste noch mal aktualisieren
      with DruckerCB do
      begin
        Items.Clear;
        for Idx:=0 to Printer.Printers.Count-1 do
          Items.Add(Printer.Printers[Idx]);
      end;
      Idx := Printer.PrinterIndex;
      if (Idx < 0) or
         (DruckerCB.Items.IndexOf(Printer.Printers[Idx]) < 0) then
      begin
        TriaMessage(Self,'Kein gültiger Drucker gewählt.',mtInformation,[mbOk]);
        Exit;
      end;
      DruckerCB.ItemIndex := DruckerCB.Items.IndexOf(Printer.Printers[Idx]);
      AnzahlEdit.Text     := IntToStr(Copies);
      SortierCB.Checked   := Collate; // Wert wird richtig übernommen
      PgVonEdit.Text      := IntToStr(FromPage);
      PgBisEdit.Text      := IntToStr(ToPage);
      if PrintRange = prAllPages then
        PgAlleRB.Checked := true
      else
        PgVonBisRB.Checked := true;
    end;
  end;
  //ActiveControl := OkButton;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.VorschauButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var ModeAlt : TReportMode;
begin
    ModeAlt := ReportMode;
  // verhindern, dass während Ausgabe ein 2. Mal Ok gedruckt wird
  if not DisableButtons then
  try
    DisableButtons := true;
    if not EingabeOk then Exit;
    ReportMode := rmVorschau;
    DatenUebernehmen;

    with RaveForm do
    begin
      if not ErstelleNDRDatei then Exit;
      HauptFenster.PrevFrame.Oeffnen(1,RvNDRWriter.JobPages);
      Self.ModalResult := mrOk; // sonst RaveForm.ModalResult
      // hier kein ClearNDRDatei: in ReportVorschauSchliessen weil für PDF unverndert benutzt
    end;

  finally
    DisableButtons := false;
    ReportMode := ModeAlt;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.OkButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  // verhindern, dass während Ausgabe ein 2. Mal Ok gedruckt wird
  if not DisableButtons then
  try
    DisableButtons := true;

    if not EingabeOk then Exit;
    DatenUebernehmen;

    // else Daten vorher übernommen, NDRDatei bereits erstellt
    case ReportMode of
      rmSerDrUrk: // Dialog nicht schliessen
        if WordRB.Checked then
          WordUrkunde(rmSerDrUrk) // UrkundeDialog aufrufen
        else
          if SerDrDateiErstellen and SerDrDateiAnsehen then
            ExportDateiAnzeigen;
      rmVorschau:
      with RaveForm do
      begin
        if not ErstelleNDRDatei then Exit;
        HauptFenster.PrevFrame.Oeffnen(1,RvNDRWriter.JobPages);
        Self.ModalResult := mrOk; // sonst RaveForm.ModalResult
        // hier kein ClearNDRDatei: in ReportVorschauSchliessen weil für PDF unverndert benutzt
      end;
      rmPDFDatei:
      with RaveForm do
      begin
        if not ErstelleNDRDatei then Exit;
        if ReportPDFDatei then Self.ModalResult := mrOk; // sonst RaveForm.ModalResult
        ClearNDRDatei;
      end;
      rmDrucken:  //rmPrevDrucken in Create in rmDrucken geändert
      with RaveForm do
      begin
        if not ErstelleNDRDatei then Exit;
        ReportDrucken;
        ClearNDRDatei;
        Self.ModalResult := mrOk; // sonst RaveForm.ModalResult
      end;
      rmTextDatei,rmExcelDatei,rmHTMLDatei:
        if ExportDateiSpeichern then ModalResult := mrOk
        else
          HauptFenster.Refresh;

      else
        // rmPrevPDFDatei ohne Dlg
        ModalResult := mrOk;
    end;

  finally
    DisableButtons := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TAusgDialog.HilfeButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  case ReportMode of
    rmDrucken,
    rmPrevDrucken,
    rmVorschau,
    rmPDFDatei:   Application.HelpContext(2600);// Liste drucken
    rmTextDatei,
    rmExcelDatei,
    rmHTMLDatei:  Application.HelpContext(3500);// Liste exportieren
    rmSerDrUrk:   Application.HelpContext(2700);// Seriendruck Urkunden
    else          Application.HelpContext(2500);// Ausgabe, rmPrevPDFDatei,rmEtiketten,: kein Dialog
  end;
end;


end.
