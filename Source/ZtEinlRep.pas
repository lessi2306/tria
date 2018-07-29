unit ZtEinlRep;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, ComCtrls,Math,StrUtils,
  AllgConst,AllgFunc,AllgObj,ZtEinlDlg, AllgComp;

type
  TZtEinlReport = class(TForm)
    AktionsLabel: TLabel;
    OKGridLabel: TLabel;
    NOkGridLabel: TLabel;
    OkButton: TButton;
    OkGrid: TTriaGrid;
    NOkGrid: TTriaGrid;
    SpeichernButton: TButton;
    SortGB: TGroupBox;
    ZeitSortRB: TRadioButton;
    SnrSortRB: TRadioButton;
    Panel2: TPanel;
    ZeitformatLabel: TLabel;
    WettkLabel1: TLabel;
    AbschnLabel1: TLabel;
    WettkLabel2: TLabel;
    AbschnLabel2: TLabel;
    procedure SpeichernButtonClick(Sender: TObject);
    procedure OkGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure NOkGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SortRGClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  ZtEinlReport: TZtEinlReport;

implementation

uses VeranObj,SGrpObj,DateiDlg,TriaMain,VistaFix;

{$R *.dfm}

var RepDatei : Text;

(*============================================================================*)
constructor TZtEinlReport.Create(AOwner: TComponent);
(*============================================================================*)
var i,Summe : Integer;
    S : String;
begin
  inherited Create(AOwner);
  Caption := 'Einlesen beendet';

  if Zeitfilter < 0 then Summe := ZECollOk.Count+ZECollNOk.Count
                    else Summe := ZECollOk.Count+ZECollNOk.Count + DoppelEintraege;

  WettkLabel2.Caption  := ZtErfWettkampf.Name;
  AbschnLabel2.Caption := ZtErfAbschnString;
  if ContainsStr(AbschnLabel2.Caption,',') then
    AbschnLabel1.Caption := 'Abschnitte:'
  else
    AbschnLabel1.Caption := 'Abschnitt:';
  AktionsLabel.Caption := 'Es wurden insgesamt  '+IntToStr(Summe)+'  Zeiten eingelesen';
  if Zeitfilter < 0 then
    AktionsLabel.Caption := AktionsLabel.Caption + '.'
  else
    AktionsLabel.Caption := AktionsLabel.Caption +
                            ', davon wurden  '+IntToStr(Doppeleintraege)+'  Doppeleinträge ausgefiltert.';
  ZeitFormatLabel.Caption := 'Eingelesen in ' + FormatStr(ZtErfFormat) +
                             ', übernommen in ' + FormatStr(ZeitFormat);

  OkGridLabel.Caption := 'Übernommen:  '+IntToStr(ZECollOk.Count);
  NOkGridLabel.Caption := 'Nicht übernommen:  '+IntToStr(ZECollNOk.Count);

  with OkGrid do
  begin
    FixedCols := 0;
    FixedRows := 1;
    Canvas.Font := Font;
    DefaultRowHeight := Canvas.TextHeight('Tg')+1;
    if RfidModus then
    begin
      S := '    ';
      for i:=1 to RfidZeichen do S := S + '0';
      ColWidths[0] := Canvas.TextWidth(S);
      if ZEColl.Count > 0 then
      begin
        S := ZEColl[0].RfidCode+' ' ;
        ColWidths[0] := Max(ColWidths[0],Canvas.TextWidth(S));
      end;
    end
    else
      ColWidths[0] := Canvas.TextWidth('  0000  ');
    ColWidths[1] := Canvas.TextWidth('  00:00:00.00  ');
    ColWidths[2] := Canvas.TextWidth('  00:00:00.00  ');
    ColWidths[3] := Canvas.TextWidth('  Abschn. ');
    ColWidths[4] := Canvas.TextWidth('  Runde  ');
    ClientWidth  := ColWidths[0] + ColWidths[1] + ColWidths[2] + ColWidths[3] +
                    ColWidths[4] + 4;
    Init(ZECollOk,smSortiert,ssVertical,nil);
    //RowCount  := 8;
    //OkGridLabel.Enabled := false;
    //Enabled := false;
  end;
  with NOkGrid do
  begin
    Left := 24 + OkGrid.Width;
    NOkGridLabel.Left := Left + 3;
    FixedCols := 0;
    FixedRows := 1;
    Canvas.Font := Font;
    DefaultRowHeight := Canvas.TextHeight('Tg')+1;
    Init(ZECollNOk,smSortiert,ssVertical,nil);
    //RowCount  := 8;
    //NotOkGridLabel.Enabled := false;
    //Enabled := false;
    ColWidths[0] := OkGrid.ColWidths[0];
    ColWidths[1] := Canvas.TextWidth('  00:00:00.00  ');
    ColWidths[2] := Canvas.TextWidth('  Max. Anzahl Zeiten überschritten  ');
    ClientWidth  := ColWidths[0] + ColWidths[1] + ColWidths[2] + 2;
  end;

  if RfidModus then
    SnrSortRB.Caption := 'nach RFID-Code sortieren'
  else
    SnrSortRB.Caption := 'nach Startnummer sortieren';
  ZeitSortRB.Checked := true;
  ClientWidth := NokGrid.Left + NokGrid.Width + 12;
  OkButton.Left := ClientWidth - OkButton.Width - 12;
  SortGB.Left := (ClientWidth - SortGB.Width + SpeichernButton.Width - OkButton.Width) DIV 2;


  SetzeFonts(Font);
end;


(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TZtEinlReport.OkGridDrawCell(Sender: TObject; ACol,ARow: Integer;
                                       Rect: TRect; State: TGridDrawState);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
var Text : String;
    ZEObj : TZEObj;
    Ausrichtung: TAlignment;
begin
  {if (ACol=0) and (ARow=WettkGrid.Row) then ZeigeWettkText;}
  Text := '';
  Ausrichtung := taCenter;
  with OkGrid do
  begin
    if ARow=0 then (* Überschrift *)
    begin
      case ACol of
        0:  if RfidModus then Text := 'RFID'
                         else Text := 'Snr';
        1:  Text := 'Eingel. Zeit';
        2:  Text := 'Übern. Zeit';
        3:  Text := 'Abschn.';
        4:  Text := 'Runde';
      end;
    end
    else if ARow < ItemCount  + 1 then (* FixedRows = 1 *)
    begin
      ZEObj := ZECollOk.SortItems[ARow-1];
      if ARow>0 then
        case ACol of
          0: begin
               if RfidModus then Text := ZEObj.RfidCode+' '
                            else Text := IntToStr(ZEObj.Snr)+' ';
               Ausrichtung := taRightJustify;
             end;
          1: begin
               Text := UhrZeitStr(ZtErfFormat,ZEObj.EinleseZeit)+' ';
               Ausrichtung := taRightJustify;
             end;
          2: begin
               Text := UhrZeitStr(ZeitFormat,ZEObj.UebernZeit)+' ';
               Ausrichtung := taRightJustify;
             end;
          3: begin
               if ZEObj.Abschn = wkAbs0 then Text := 'Start'
               else Text := IntToStr(Integer(ZEObj.Abschn));
               Ausrichtung := taCenter;
             end;
          4: begin
               if ZEObj.Abschn = wkAbs0 then Text := '-    '
               else Text := IntToStr(ZEObj.Runde)+'    ';
               Ausrichtung := taRightJustify;
             end;
        end;
    end else Text := ''; // Dummy Leerzeile bei ItemCount = 0
    DrawCellText(Rect,Text,Ausrichtung);
  end;

end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TZtEinlReport.NOkGridDrawCell(Sender: TObject; ACol,ARow: Integer;
                                          Rect: TRect; State: TGridDrawState);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
var Text : String;
    ZEObj : TZEObj;
    Ausrichtung: TAlignment;
begin
  {if (ACol=0) and (ARow=WettkGrid.Row) then ZeigeWettkText;}
  Text := '';
  Ausrichtung := taCenter;
  with NOkGrid do
  begin
    if ARow=0 then (* Überschrift *)
    begin
      case ACol of
        0:  if RfidModus then Text := 'RFID'
                         else Text := 'Snr';
        1:  Text := 'Eingel. Zeit';
        2:  Text := 'Bemerkung';
      end;
    end
    else if ARow < ItemCount  + 1 then (* FixedRows = 1 *)
    begin
      ZEObj := ZECollNOk.SortItems[ARow-1];
      if ARow>0 then
        case ACol of
          0: begin
               if RfidModus then Text := ZEObj.RfidCode+' '
                            else Text := IntToStr(ZEObj.Snr)+' ';
               Ausrichtung := taRightJustify;
             end;
          1: begin
               Text := UhrZeitStr(ZtErfFormat,ZEObj.EinleseZeit)+' ';
               Ausrichtung := taRightJustify;
             end;
          2: begin
               case ZEObj.ZEFehler of
                 zeSnrFehlt         : Text := ' Startnummer fehlt';
                 zeTlnUnbekannt     : if RfidModus then
                                        Text := ' RFID-Code unbekannt'
                                      else
                                        Text := ' Startnummer unbekannt';
                 zeZeitFehlt        : Text := ' Zeit fehlt';
                 zeItemDoppelt      : Text := ' Doppelter Eintrag';
                 zeSGrpUnbekannt    : Text := ' Startgruppe unbekannt';
                 zeNichtInWettk     : Text := ' Anderer Wettkampf';
                 zeZeitEingelesen   : Text := ' Gleiche Zeit bereits eingelesen';
                 zeRundenUeberlauf  : Text := ' Max. Anzahl Zeiten überschritten';
                 else                 Text := ''; //zeKeinfehler
               end;
               Ausrichtung := taLeftJustify;
             end;
        end;
    end else Text := ''; // Dummy Leerzeile bei ItemCount = 0
    DrawCellText(Rect,Text,Ausrichtung);
  end;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TZtEinlReport.SortRGClick(Sender: TObject);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
begin
  // nur Aktion wenn Index geändert
  if ZeitSortRB.Checked and (ZECollOk.SortMode<>smZEZeit) or
     SnrSortRB.Checked and (ZECollOk.SortMode<>smZESnr) then
  begin
    if ZeitSortRB.Checked then
    begin
      ZECollOk.Sortieren(smZEZeit);
      ZECollNOk.Sortieren(smZEZeit);
    end else
    begin
      ZECollOk.Sortieren(smZESnr);
      ZECollNOk.Sortieren(smZESnr);
    end;
    OkGrid.CollectionUpdate;
    NOkGrid.CollectionUpdate;
    OkGrid.Refresh;
    NOkGrid.Refresh;
    OkGrid.ItemIndex := 0;
    NOkGrid.ItemIndex := 0;
  end;
end;

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
procedure TZtEinlReport.SpeichernButtonClick(Sender: TObject);
(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
var i            : Integer;
    RepDateiName : String; 
    S            : String;
    IOFehler     : Boolean;
begin
  RepDateiName := TriDatei.Path;
  RemoveExtension(RepDateiName);
  RepDateiName :=  RepDateiName + '_Report_'+IntToStr(ZtEinlReport_Index)+'.txt';
  IoFehler := true;
  if SaveFileDialog('txt',
                    'Textdatei (*.txt)|*.txt|Alle Dateien (*.*)|*.*',
                    SysUtils.ExtractFileDir(TriDatei.Path),
                    'Reportdatei erstellen',
                    RepDateiName) then
  begin
    if SysUtils.FileExists(RepDateiName) and not SysUtils.DeleteFile(RepDateiName) then
    begin
      TriaMessage(Self,'Vorhandene Datei  "'+ExtractFileName(RepDateiName)+
                  '"  kann nicht gelöscht werden.',
                   mtInformation,[mbOk]);
      Exit;
    end;

    i := ZECollOk.SortCount + ZECollNOk.SortCount;
    HauptFenster.ProgressBarInit('Reportdatei wird erstellt',i);
    try
      {$I-}
      AssignFile(RepDatei,RepDateiName);
      if IoResult <> 0 then Exit;
      Rewrite(RepDatei);
      if IoResult <> 0 then Exit;

      // Überschrift
      S := 'TRIA REPORT - erstellt am '+ SystemDatum + ' - ' + SystemZeit;
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;
      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;


      S := 'Zeiten eingelesen';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      S := '=================';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;

      // Veranstaltung - Ort
      S := 'Veranstaltung:   ' + Veranstaltung.Name;
      if Veranstaltung.Serie then S := S + ' - ' + Veranstaltung.OrtName;
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      {WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;}

      S := 'Wettkampf:       ' + ZtErfWettkampf.Name;
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      {WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;}

      S := 'Abschnitt:       ' + ZtErfAbschnString;
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;

      S := 'Aus Datei:       ' + ZtErfDateiName;
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      {WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;}

      S := 'In Datei:        ' + TriDatei.Path;
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;
      {WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;}

      S := 'Einträge:        ' + IntToStr(i)+ ' eingelesen, davon ' +
              IntToStr(ZECollOk.SortCount) + ' übernommen und ' +
              IntToStr(ZECollNOk.SortCount) + ' nicht übernommen' ;
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;

      S := 'Zeitformat:      eingelesen in ' + FormatStr(ZtErfFormat);
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;

      S := '                 übernommen in ' + FormatStr(ZeitFormat);
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;

      if RfidModus then
        S := 'Einlese-Modus:   RFID-Code'
      else
        S := 'Einlese-Modus:   Startnummer';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;

      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;
      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;
      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;

      S := 'Übernommene Zeiten:';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;

      S := '';
      if RfidModus then
        for i:=1 to RfidZeichen do
          S := S + '-'
      else
        S := '----';
      S :=  S + '---' + '----------------' + '---' + '----------------' + '---' + '-------' + '---' + '-------';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;

      if RfidModus then
      begin
        S := 'RFID';
        for i:=5 to RfidZeichen do
          S := S + ' ';
      end else
        S := ' Snr';
      S := S + '   ' + 'Eingelesene Zeit' + '   ' + 'Übernommene Zeit' + '   ' + 'Abschn.' + '   ' + 'Runde';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;

      S := '';
      if RfidModus then
        for i:=1 to RfidZeichen do
          S := S + '-'
      else
        S := '----';
      S :=  S + '---' + '----------------' + '---' + '----------------' + '---' + '-------' + '---' + '-------';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;

      for i:=0 to ZECollOk.SortCount - 1 do
        with ZECollOk.SortItems[i] do
        begin
          if RfidModus then
            S := RfidCode
          else
            S := Strng(Snr,4);
          S := S + '   ' + Format('%14s',[UhrZeitStr(ZtErfFormat,EinleseZeit)]) + '  ' +
                   '   ' + Format('%14s',[UhrZeitStr(ZeitFormat,UebernZeit)]) + '  ';
          if Abschn=wkAbs0 then
            S := S + '   Start  ' + '   -   '
          else S := S +
                    '   ' + Strng(Integer(Abschn),4) + '   ' +
                    '   ' + Strng(Runde,4);
          WriteLn(RepDatei,S);
          if IoResult <> 0 then Exit;
          HauptFenster.ProgressBarStep(1);
        end;

      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;
      WriteLn(RepDatei,'');
      if IoResult <> 0 then Exit;

      S := 'Nicht Übernommene Zeiten:';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;
      S := '';
      if RfidModus then
        for i:=1 to RfidZeichen do
          S := S + '-'
      else
        S := '----';
      S := S + '---' + '----------------' + '-----------------------------------';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;

      if RfidModus then
      begin
        S := 'RFID';
        for i:=5 to RfidZeichen do
          S := S + ' ';
      end else
        S := ' Snr';
      S := S + '   ' + 'Eingelesene Zeit' + '   Bemerkung';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;

      S := '';
      if RfidModus then
        for i:=1 to RfidZeichen do
          S := S + '-'
      else
        S := '----';
      S := S + '---' + '----------------' + '-----------------------------------';
      WriteLn(RepDatei,S);
      if IoResult <> 0 then Exit;

      for i:=0 to ZECollNOk.SortCount - 1 do
        with ZECollNOk.SortItems[i] do
        begin
          if RfidModus then
            S := RfidCode
          else
            S := Strng(Snr,4);
          S := S + '   ' + Format('%14s',[UhrZeitStr(ZtErfFormat,EinleseZeit)]) + '  ';
          case ZEFehler of
            zeSnrFehlt         : S := S + '   Startnummer fehlt';
            zeTlnUnbekannt     : if RfidModus then
                                   S := S + '   RFID-Code unbekannt'
                                     else
                                   S := S + '   Startnummer unbekannt';
            zeZeitFehlt        : S := S + '   Zeit fehlt';
            zeItemDoppelt      : S := S + '   Doppelter Eintrag';
            zeSGrpUnbekannt    : S := S + '   Startgruppe unbekannt';
            zeNichtInWettk     : S := S + '   Anderer Wettkampf';
            zeZeitEingelesen   : S := S + '   Gleiche Zeit bereits eingelesen';
            zeRundenUeberlauf  : S := S + '   Max. Anzahl Zeiten überschritten';
            else                 S := '';     //zeKeinfehler
          end;
          WriteLn(RepDatei,S);
          if IoResult <> 0 then Exit;
          HauptFenster.ProgressBarStep(1);
        end;
      IoFehler := false;
      Inc(ZtEinlReport_Index);

    finally
      CloseFile(RepDatei);
      IoResult;    (*Löschen Fehlerspeicher*)
      {$I+}
      if IOFehler then
        TriaMessage(Self,'Fehler beim Erstellen der Datei  "'+RepDateiName+'".',
                     mtInformation,[mbOk]);
      HauptFenster.StatusBarClear;
    end;
  end;
end;

end.

