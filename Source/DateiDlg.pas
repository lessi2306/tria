unit DateiDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ShlObj,
  AllgConst,AllgObj;

procedure TriDatNeu(const Pfad:String);
procedure TriDatOeffnen;
function  TriDatLaden(Pfad:String): Boolean;
function  TriDatSpeichern(Steps:Integer): Boolean;
function  TriDatSpeichernUnter(Steps:Integer): Boolean;
//function  DateiSichern(Steps:Integer): Boolean;
procedure TriDatAutoSpeichern;
procedure TriDatSchliessen(Steps:Integer);
function  OpenFileDialog(const ADefExt, AFilter, AInitialDir: String;
                         var AFilterIndx:Integer; ATitle: String;
                         var AFileName: String): Boolean;
function  SaveFileDialog(const ADefExt, AFilter, AInitialDir, ATitle: String;
                         var AFileName: String): Boolean;

type
  TDateiDialog = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    FileOpenDialog1: TFileOpenDialog;
    FileSaveDialog1: TFileSaveDialog;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  DateiDialog : TDateiDialog;

implementation

uses AllgFunc,AkObj,TriaMain,CmdProc,VeranObj,WettkObj,TlnErg,LstFrm,History,
     ZtEinlDlg,VistaFix;

{$R *.DFM}

function DateiSpeichern(Steps:Integer): Boolean; forward;


//******************************************************************************
procedure TriDatNeu(const Pfad:String);
//******************************************************************************
var DirAlt : String;
    i : Integer;
begin
  //kein flackern durch Hauptfenster.Init/Update
  HauptFenster.ProgressBarStehenLassen := true;
  DirAlt := '';
  if TriDatei.Geladen then
  begin
    DirAlt := SysUtils.ExtractFileDir(TriDatei.Path);
    if Veranstaltung <> nil then
      SerieOrtIndex := Veranstaltung.OrtIndex; // letzter Index beibehalten
    {if DateiSichern(10) then
    begin
      TriDatSchliessen(10);
      HauptFenster.Init; // leeres Fenster bevor Laden begint
      //HauptFenster.StatusBarClear; stehen lassen, wird am Ende geschlossen
    end else
    begin
      HauptFenster.ProgressBarStehenLassen := false;
      Exit; (* KEIN ABBRUCH, sondern weiter machen ohne speichern!!!!*)
    end;}
    if TriDatei.Modified then
      case TriaMessage('�nderungen in Datei  "'+TriDatei.Path+'"  speichern?',
                        mtConfirmation, [mbYes, mbNo, mbCancel]) of
        mrYes: if not TriDatSpeichern(10) then Exit;
        mrNo:  ;
        else Exit;
      end;
    TriDatSchliessen(10);
    HauptFenster.Init; // leeres Fenster bevor Laden begint
  end;
  // TriaGrid ist leer, Veranstaltung = nil, EinlVeranst = nil
  TriDatei.Path := '';
  HauptFenster.UpdateCaption; // zuerst Dateiname in Caption l�schen
  HauptFenster.LstFrame.TriaGrid.StopPaint := true;
  try
    if (Pfad<>'') and SysUtils.FileExists(Pfad) then
    begin
      // Datei laden
      TriDatei.Path := Pfad;
      if TriDatLaden(TriDatei.Path) then // Statusbar initialisiert
      begin
        TriDatei.Geladen := true; // nur wenn das Laden gut ging
        HauptFenster.UpdateCaption;
        // Veranstaltung definieren
        Veranstaltung := EinlVeranst;
        EinlVeranst   := nil;
        WettkAlleDummy.VPtr := Veranstaltung;
        ZEColl.VPtr         := Veranstaltung;
        ZECollOk.VPtr       := Veranstaltung;
        ZECollNOk.VPtr      := Veranstaltung;
        HauptFenster.SortWettk := WettkAlleDummy; //f�r Loadkorr
        Veranstaltung.LoadKorrektur; // Anpassung von alten Versionen
        // Teilnehmerliste vor Berechnen anzeigen
        HauptFenster.Init; //incl.CommandTrailer,Coll nicht neu sortiert,StopPaint:= false
        // dann grunds�tzlich Mannschaften neu einlesen und alles neu berechnen
        for i:=0 to Veranstaltung.WettkColl.Count-1 do
          Veranstaltung.WettkColl[i].KlassenModified := true; // auch MschModified,ErgModified: alles neu berechnen
        BerechneRangAlleWettk; // TriDatei.Geladen muss vorher gesetzt sein
      end;
    end;
  finally
    // auch bei Exception in TriDatLaden oder beim Schliessen
    HauptFenster.LstFrame.TriaGrid.StopPaint := false;
    if not Application.Terminated then
    begin
      if not TriDatei.Geladen then
      begin
        if Pfad <> '' then
          with HauptFenster.MruListe do EntferneDatei(PfadIndex(Pfad));
        if DirAlt = '' then // vorher war keine Datei geladen
          DirAlt := GetSpecialFolder(CSIDL_DESKTOPDIRECTORY); // Desktop als default
        TriDatei.Path := DirAlt+'\'+cnDateiNeu;
        TriDatei.Version.Jahr := ProgVersion.Jahr;
        TriDatei.Version.Nr   := ProgVersion.Nr;
        TriDatei.Geladen := true;
        HauptFenster.UpdateCaption;
        // Veranstaltung definieren
        Veranstaltung := TVeranstObj.Create;
        EinlVeranst   := nil;
        WettkAlleDummy.VPtr := Veranstaltung;
        ZEColl.VPtr         := Veranstaltung;
        ZECollOk.VPtr       := Veranstaltung;
        ZECollNOk.VPtr      := Veranstaltung;
        HauptFenster.Init; // CommandTrailer enthalten
      end;
      SysUtils.SetCurrentDir(SysUtils.ExtractFileDir(TriDatei.Path));
      KeinSexAkzeptiertAll := false;
      KeinJgAkzeptiertAll  := false;
      HauptFenster.ProgressBarStehenLassen := false;
      HauptFenster.StatusBarClear;
    end;
  end;
end;

(******************************************************************************)
procedure TriDatOeffnen;
(******************************************************************************)
var S,Pfad: String;
    FilterIndx: Integer;
begin
  Pfad := '';
  FilterIndx := 1;
  if TriDatei.Geladen then S := SysUtils.ExtractFileDir(TriDatei.Path)
                      else S := 'C:'; // default
  if OpenFileDialog('tri', //const DefExt: String
                    'Tria Dateien (*.tri)|*.tri|Alle Dateien (*.*)|*.*',//Filter: String
                    S, //InitialDir: String
                    FilterIndx, // Type Tria Dateien
                    '�ffnen',//Title: String
                    Pfad) then //var FileName: String
  begin
    HauptFenster.Refresh;
    TriDatNeu(Pfad);
    if TriDatei.Path=Pfad then // Laden erfolgreich
      HauptFenster.MruListe.AddiereDatei(TriDatei.Path);
  end else HauptFenster.Refresh;
end;

(******************************************************************************)
function DateiSpeichern(Steps:Integer): Boolean;
(******************************************************************************)
var BackupName : String;
begin
  Result     := false;
  HauptFenster.Refresh;

  if BackupErstellen and SysUtils.FileExists(TriDatei.Path) then
    if SysUtils.ExtractFileExt(TriDatei.Path) = '.~tri' then
      TriaMessage('Bei Datei-Extension *.~tri wird keine Sicherungsdatei erstellt.',
                   mtWarning,[mbOk])
    else
    begin
      // Backup erstellen
      BackupName := SysUtils.ChangeFileExt(TriDatei.Path, '.~tri');
      // Backup l�schen falls schon vorhanden, sonst Fehler bei Rename
      if SysUtils.FileExists(BackupName) and not SysUtils.DeleteFile(BackupName) then
        TriaMessage('Fr�here Sicherungsdatei  "'+ExtractFileName(BackupName)+
                    '"  kann nicht gel�scht werden.',
                     mtWarning,[mbOk])
      else // Backup existiert nicht oder wurde gel�scht
        if not SysUtils.RenameFile(TriDatei.Path, BackupName) then
          //raise Exception.Create('Backup Datei '+BackupName+' kann nicht erstellt werden.');
          TriaMessage('Sicherungsdatei  "'+ExtractFileName(BackupName)+
                      '"  kann nicht erstellt werden.',
                       mtWarning,[mbOk]);
    end;

  with HauptFenster do
    if ProgressBarStehenLassen then
      if ProgressBar.Visible then
      begin
        ProgressBarText('Datei  "'+TriDatei.Path+'"  wird gespeichert');
        if Steps > 0 then
          ProgressBarMaxUpdate((100 DIV Steps) * Veranstaltung.ObjSize);
      end else
        if Steps > 0 then
          ProgressBarinit('Datei  "'+TriDatei.Path+'"  wird gespeichert',
                          (100 DIV Steps) * Veranstaltung.ObjSize)
        else
          ProgressBarInit('Datei  "'+TriDatei.Path+'"  wird gespeichert',
                          Veranstaltung.ObjSize)
    else //not StehenLassen
      ProgressBarInit('Datei  "'+TriDatei.Path+'"  wird gespeichert',
                      Veranstaltung.ObjSize);
  try
    TriaStream := TTriaStream.Create(TriDatei.Path,fmCreate or fmShareDenyNone);
    if ProgVersion.Store and Veranstaltung.Store then
    begin
      Result := true;
      TriDatei.Modified := false;
      // Version der gespeichert Datei updaten
      TriDatei.Version.Jahr := ProgVersion.Jahr;
      TriDatei.Version.Nr   := ProgVersion.Nr;
    end else
      // Fehler, aber kein IO Exception
      TriaMessage('Datei '+TriDatei.Path+' kann nicht gespeichert werden.',
                   mtInformation,[mbOk]);
  finally
    // EInOutError Exception landet hier.
    // Standard Fehlermeldung wird nach Ende ausgegeben
    FreeAndNil(TriaStream);
    with HauptFenster do
      if not ProgressBarStehenLassen then StatusBarClear
      else // Zwischenstand sichtbar machen
      begin
        ProgressBar.Position := ProgressBar.Position-1;
        ProgressBar.Position := ProgressBar.Position+1;
      end;
    ZeitDatGespeichert := GetTickCount;//ZeitAktuell; // in mSek
  end;
end;

(******************************************************************************)
function TriDatSpeichern(Steps:Integer): Boolean;
(******************************************************************************)
begin
  if TriDatei.Neu then
    if TriDatSpeichernUnter(Steps) then Result := true
                                   else Result := false
  else if DateiSpeichern(Steps) then Result := true
                                else Result := false;
end;

(******************************************************************************)
function TriDatSpeichernunter(Steps:Integer): Boolean;
(******************************************************************************)
var Pfad,PfadAlt : String;
begin
  Result := false;
  Pfad := TriDatei.Path;
  PfadAlt := Pfad;
  if SaveFileDialog('tri',
                    'Tria-Datei (*.tri)|*.tri|Alle Dateien (*.*)|*.*',
                    SysUtils.ExtractFileDir(TriDatei.Path),
                    'Speichern unter',
                    Pfad) then
  begin
    TriDatei.Path := Pfad;
    HauptFenster.UpdateCaption;
    HauptFenster.Refresh;
    try
      if DateiSpeichern(Steps) then
      begin
        Result := true;
        HauptFenster.MruListe.AddiereDatei(TriDatei.Path);
      end;
    finally
      // auch bei Exception in Dateispeichern
      if not Result then
      begin
        TriDatei.Path := PfadAlt;
        HauptFenster.UpdateCaption;
      end;
    end;
  end else HauptFenster.Refresh;
end;

(******************************************************************************)
function TriDatLaden(Pfad:String): Boolean;
(******************************************************************************)
// Daten werden in EinlVeranst eingelesen
// wird in TriDatNeu(in: TriDatOeffnen,TriDatNeuActionExecute,
//                       MruActionExecute,LadeKonfiguration) und ImpDlg benutzt
var StreamPosAlt   : Int64;   // (Integer-Max = 2.147.483.647)
begin
  Result := false;
  FreeAndNil(TriaStream);
  FreeAndNil(EinlVeranst);
  TlnGeladen := 0;

  with HauptFenster do
    // ProgressBar: nur Text �ndern, nach TriaStream.Create Max �ndern
    if ProgressBarStehenLassen and ProgressBar.Visible then
      ProgressBarText('Datei  "'+Pfad+'"  wird ge�ffnet')
    else
      ProgressBarInit('Datei  "'+Pfad+'"  wird ge�ffnet',100);
  try
    TriaStream := TTriaStream.Create(Pfad,fmOpenRead or fmShareDenyNone);

    with HauptFenster do
      if ProgressBarStehenLassen then // mit Laden 20% auff�llen
        ProgressBarMaxUpdate(5*TriaStream.Size)
      else // 100% f�llen
        ProgressBarMaxUpdate(TriaStream.Size);

    StreamPosAlt := TriaStream.Position;
    if TriDatei.Version.Load then
    begin
      // Version.Jahr ist g�ltig
      if (TriDatei.Version.Jahr > cnVersionsJahr) or
         (TriDatei.Version.Jahr = cnVersionsJahr)and
         (TriDatei.Version.Nr   > cnVersionsNummer) then
        TriaMessage('Die Datei "'+Pfad+'"'+#13+
                    'wurde mit einer neueren Version von Tria erstellt.'+#13+
                    'Beim Laden k�nnen m�glicherweise Fehler auftreten.'+#13+#13+
                    'Sie finden die aktuelle Programmversion auf "www.selten.de".',
                     mtWarning,[mbOk]);
      HauptFenster.ProgressBarStep(TriaStream.Position - StreamPosAlt);
      EinlVeranst := TVeranstObj.Create;
      if EinlVeranst.Load then Result := true;
    end;
    if Result = false then
      // diese Meldung nicht bei IO Exception
      // weil Standardmeldung erzeugt wird nach Ende finally
      TriaMessage(Pfad+' ist keine g�ltige Tria-Datei.'+#13+
                  'Datei kann nicht eingelesen werden.',
                   mtInformation,[mbOk]);
  finally
    if Result = false then FreeAndNil(EinlVeranst);
    FreeAndNil(TriaStream);
    // HauptFenster.StatusBarClear; erst nach Hauptfenster.Init
  end;
end;

(******************************************************************************)
procedure TriDatSchliessen(Steps:Integer);
(******************************************************************************)
begin
  if EinlVeranst <> nil then // sollte nie der Fall sein
    FreeAndNil(EinlVeranst);

  if Veranstaltung <> nil then // sollte immer der Fall sein
  with HauptFenster do
  begin
    if ProgressBarStehenLassen then
      if ProgressBar.Visible then
      begin
        ProgressBarText('Datei  "'+TriDatei.Path+'"  wird geschlossen');
        if Steps>0 then
          ProgressBarMaxUpdate((100 DIV Steps) * Veranstaltung.ObjSize);
      end else
        if Steps>0 then
          ProgressBarInit('Datei  "'+TriDatei.Path+'"  wird geschlossen',
                          (100 DIV Steps) * Veranstaltung.ObjSize)
    else // not StehenLassen
      ProgressBarInit('Datei  "'+TriDatei.Path+'"  wird geschlossen',
                       Veranstaltung.ObjSize);
    LstFrame.TriaGrid.StopPaint := true;
    WettkAlleDummy.VPtr := nil;
    ZEColl.VPtr         := nil;
    ZECollOk.VPtr       := nil;
    ZECollNOk.VPtr      := nil;
    FreeAndNil(Veranstaltung);
    // StopPaint wird erst beim n�chsten HauptFenster.Init wieder aufgehoben
    // Liste und ProgressBar bleiben bis zuletzt stehen

    TriDatei.ClearPath;
    UpdateCaption;
    // ProgressBar Position sichtbar machen
    with HauptFenster do
    begin
      ProgressBar.Position := ProgressBar.Position-1;
      ProgressBar.Position := ProgressBar.Position+1;
      Application.ProcessMessages;
    end;
  end;
end;

{(******************************************************************************)
function DateiSichern(Steps:Integer): Boolean;
(******************************************************************************)
begin
  if not TriDatei.Modified then Result := true
  else
    case TriaMessage('�nderungen in Datei  "'+TriDatei.Path+'"  speichern?',
                      mtConfirmation, [mbYes, mbNo, mbCancel]) of
      mrYes: Result := TriDatSpeichern(Steps);
      mrNo:  Result := true;
      else Result := false;
    end;
end;}

(******************************************************************************)
procedure TriDatAutoSpeichern;
(******************************************************************************)
begin
  if DateiSpeichern(100) then // Fehlermeldung wird ggf. generiert
    AutoSpeichernRequest := false
  else HauptFenster.AutoSpeichernInterval := 0;
end;

(******************************************************************************)
function OpenFileDialog(const ADefExt, AFilter, AInitialDir: String;
                        var AFilterIndx:Integer; ATitle: String;
                        var AFileName: String): Boolean;
(******************************************************************************)
// 'Tria Dateien (*.tri)|*.tri|Alle Dateien (*.*)|*.*',//Filter: String
begin
  Result := false;

  if IsWindowsVista then // Vista oder neuer
  with DateiDialog.FileOpenDialog1 do
  begin
    Title             := ATitle;
    FileName          := AFileName;
    DefaultExtension  := ADefExt;
    DefaultFolder     := AInitialDir;
    if not SetzeVistaFilter(FileTypes, AFilter) then
      with FileTypes do
      begin
        Clear;
        with Add do begin DisplayName := 'Alle Dateien'; FileMask := '*.*'; end;
      end;
    FileTypeIndex := AFilterIndx;
    Options := [fdoPathMustExist,fdoFileMustExist];

    if Execute then
    begin
      AFileName   := FileName;
      AFilterIndx := FileTypeIndex;
      Result      := true;
    end;
  end

  else // XP oder �lter
  with DateiDialog.OpenDialog do
  begin
    Title       := ATitle;
    FileName    := AFileName;
    DefaultExt  := ADefExt;
    InitialDir  := AInitialDir;
    Filter      := AFilter;
    FilterIndex := AFilterIndx;
    Options     := [ofHideReadOnly,ofPathMustExist,ofFileMustExist,
                    ofEnableSizing];

    if Execute then
    begin
      AFileName   := FileName;
      AFilterIndx := FilterIndex;
      Result      := true;
    end;
  end;
end;

(******************************************************************************)
function SaveFileDialog(const ADefExt, AFilter, AInitialDir, ATitle: String;
                        var AFileName: String): Boolean;
(******************************************************************************)
begin
  Result := false;

  if IsWindowsVista then // Vista oder neuer
  with DateiDialog.FileSaveDialog1 do
  begin
    Title       := ATitle;
    DefaultExtension  := ADefExt;
    DefaultFolder     := AInitialDir;
    FileName    := AFileName;
    DefaultExtension  := ADefExt;
    if not SetzeVistaFilter(FileTypes, AFilter) then
      with FileTypes do
      begin
        Clear;
        with Add do begin DisplayName := 'Alle Dateien'; FileMask := '*.*'; end;
      end;
    FileTypeIndex := 1;
    Options := [fdoOverWritePrompt,fdoPathMustExist (*, ofShareAware??*)];
    if Execute then
    begin
      AFileName := FileName;
      Result := true;
    end;
  end

  else // XP oder fr�her
  with DateiDialog.SaveDialog do
  begin
    Title       := ATitle;
    InitialDir  := AInitialDir;
    FileName    := AFileName;
    DefaultExt  := ADefExt;
    Filter      := AFilter;
    FilterIndex := 1;
    Options     := [ofHideReadOnly,ofPathMustExist,ofOverwritePrompt,
                    ofEnableSizing {,ofShareAware??}];
    if Execute then
    begin
      AFileName := FileName;
      Result := true;
    end;
  end;
end;


end.
