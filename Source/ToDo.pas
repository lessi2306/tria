unit ToDo;

interface

implementation

{

################################################################################
################################################################################
#                                                                              #
#                                                                              #
#                             ToDo Liste:                                      #
#                                                                              #
#                                                                              #
################################################################################
################################################################################

sortieren nach Vereinsgr��e. Auch vollst�ndiges Geburtsdatum optional?

tria h�ngt beim schliessen nach dem alle Tln gel�scht wurden

Bei Summe Mannsch z�hlen mehr teilnehmer als Msch-Gr��e   ??

Graustreifen in Liste zu hell

Farbige Badekappen

Editfelder ohne Maske, wie TriaZeit?

Skoff:
Ich m�chte Sie fragen ob es beim Programm eine M�glichkeit gibt das der Vereinsnamen
und der Mannschaftsname verschieden sind.
Wir haben Z.B. einen Tourenschilauf wo verschiedene Teilnehmer von versch.
Vereinen sich zu einen Mannschaft entschlie�en.
F�r die Einzelwertung sollte der Vereinsnamen ausgedruckt werden und bei der
Mannschaftswertung dessen Name.

UrkDokCB:
1x Problem mit falschen Index gesehen beim Anklicken - Ursache unbekannt

Checkliste f�r Schwimmbad: Farbige Hintergrund oder Schrift f�r Bahnen definieren
entsprechen Badekappen

anMschErgKompakt: bei Rundenrennen wird nur Endzeit, keine Runden angezeigt
==> so lassen, zu aufwendig

================================================================================
Serienwertung
================================================================================
Streich:
3.
Die Startnummern k�nnen nicht f�r die gesamte Serie zugewiesen werden. W�re auch
eine sinnvolle Verbesserung. Ich werde in den n�chsten Monate ein Update bereitstellen.
Die Details sind noch nicht festgelegt.
==> nicht vorsehen, es m�ssten sonst auch die Startgruppen angelegt werden

................................................................................
Pf�lzer Berglaufpokal und weitere: (Bernd Morbach [berglauf@tus-tholey.de])

P = 550 � 250 t/ts (t = Laufzeit; ts = Siegerzeit).
F�r den Sieger (t = ts) ergibt sich die Punktzahl 300.

Tageswertung:
Pl. Name Verein JG Zeit Klas. Rg. Stnr. Punkte
1 Lehmann Jonas TUS Heltersberg 1989 0:31:45 M20 1 443 300,00
2 Uebel Steffen LAZ Birkenfeld 1987 0:33:16 M20 2 344 288,06

Serienwertung:
Pl. Name Verein JG Kl. Donn. Landst. Rockh. Edenk. D�W Punkte Anz.
1 Lehmann Jonas TuS Heltersberg 1989 MHK 300,00 300,00 300,00 300,00 1200,00 4
2 Heuer Tom TuS Heltersberg 1970 M40 272,16 283,16 286,09 284,98 1126,39 4

Kontakt:
http://www.pfaelzer-berglaufpokal.de/
Henning Schneehage
Telefon: 06353/2960
E-Mail: henning.schneehage[at]t-online[dot]de

................................................................................
kl�ren ob in Serienveranst. nur Daten von Serienveranstaltungen importiert werden k�nnen


================================================================================
Pulter:

Leider ist es so, dass die Vereinsmeldeliste nicht immer von einer Person als
Vereinsmelder �berreicht wird, sondern sich aus unterschiedlichen, auch zeitlich
versetzten Quellen speist.
(Excelliste vom Vereinsvertreter, Onlinemeldungen in ein Anmeldeformular �ber die
Homepage und Nachmeldungen am Veranstaltungstag)
Bei der Excelliste ist die Zuordnung zum Vereinsmelder ja noch einfach, aber bei
einzelnen separat eingegebenen Meldungen �ber das Meldeformular der Homepage wird
es schon schwieriger)
Trotzdem habe ich beim Einlesen der externen Meldedaten momentan noch nicht die
M�glichkeit diese unter der Vereinsmeldeansicht einzulesen oder?

-Im Volkslauf ist das Verh�ltnis Voranmeldungen zu Nachmeldungen am Wettkampftag
bei uns ca. � zu � der Teilnehmer. Aber auch hier w�re eine Auswertung der
vorangemeldeten Teilnehmer eines Vereins wichtig, da gerade bei den Kinderwettk�mpfen
die Startnummern von einem Vereinsvertreter abgeholt werden, der auch das Startgeld
komplett zahlt.
Deshalb w�re eine Liste aller Starter eines Vereins ggf. selektierbar
nach Wettk�mpfen mit den Feldinhalten der allgemeinen Startliste und zus�tzlich der
Ausgabe des Startgelds pro Teilnehmer und der Gesamtsumme sehr sch�n.

===>  Startgeldliste?? getrennt f�r teilnehmer und Vereine??

--------------------------------------------------------------------------------
Sch�fer:
Die Eingabe der Streckenl�nge stand schon auf meiner Liste und damit auch die
zus�tzliche Spalte in der Ergebnisliste (nur bei Wettk�mpfen mit einem Abschnitt).
Auch eine optionale Spalte f�r Strafrunden werde ich vorsehen.
Eine Wertung �ber mehrere Jahre und Wettk�mpfe ist aber zu speziell und werde
ich deshalb nicht vorsehen.

................................................................................
Streckenl�nge eingeben f�r Berechnung Durchschnittsgeschwindigkeit (km/h),
Stundenmittel (min/km) (O/ min), zus�tzliche Spalte in ergListe (1 Abs.)
Zus�tzliche Spalte f�r Strafrunden (Bike-Biathlon)
Spalte f�r Abstand / R�ckstand (zur�ck) zum 1. Platz

================================================================================


Online Anmeldeformular

--------------------------------------------------------------------------------
ZtEinlDlg:
- dBaseDateiLaden: function BlockRead wird benutzt, Warnung in Delphi Hilfe
  BlockWrite funktioniert mit Delphi XE nicht mehr in TriaZeit, deshalb
  ersetzt.
  BlockRead funktioniert noch richtig, aber bei neuen Releases pr�fen. F�r dBase
  nichts �ndern, wenn nicht erforderlich

--------------------------------------------------------------------------------
Schneider-Holbach:
 Rundenzeiten (ohne Wertung) optional in Ergebnisliste f�r  >= 10 Runden.

--------------------------------------------------------------------------------
Zeidler:
mehr Sonderwertungen integrieren

--------------------------------------------------------------------------------

Sortierung f�r Urkunden erweitern - R�hrig
z.B. Platz von 3 bis 1 erlauben

----------------------------------------------------------------------------------
Oskar Schneider:
Beim Urkunden-Druck bin ich auf ein weiteres Problem gestossen:
Die Ergebnis-Zeiten werden in der Form 12:34 in der Textdatei gespeichert.
OpenOffice und Excel behandeln so ein Feld als Zeitangabe in der Form hh:mm, und
da ist bei 23:59 Schluss. Selbst bei nachtr�glicher Umformatierung des Feldes
als MM:SS oder Text ist der Inhalt dann falsch. Einzige M�glichkeit war, das
direkt beim Import als Textfeld zu kennzeichnen.
Ich habe dazu in der Textdatei die Felder in Anf�hrungszeichen ""
gesetzt. Das k�nnte man vielleicht schon direkt beim Erzeugen der Textdatei?

================================================================================
Zeitnahme:
================================================================================

Stoppuhr-Modus als Option mit fester Startzeit=0, unabh�ngig von Startgr.-Startzeit

................................................................................
Allgemeines Textformat f�r Zeiten einlesen (Nagel)
 Wettkampfart;Ort;Startnr;Zeit;
 Vielfachstarts;Start;1;0.00
 Vielfachstarts;Start;2;42.33
 Vielfachstarts;Start;3;92.29
 Vielfachstarts;Ziel;1;65.51,
 Vielfachstarts;Ziel;2;96.35,
 Vielfachstarts;Ziel;3;100.19,

................................................................................
Status "Am Start" einlesen
Rost 19.3.2009 Anmelde-Zeiterfassung:
Mehrere Veranstalter m�chten gern bereits vorm Start eine Teilnehmererfassung per
Transponder haben, um festzustellen, wer von den gemeldeten nun wirklich am
Start ist. Siehst du hier eventuell noch die M�glichkeit, dass eine "Nullzeit",
die beispielsweise ab eine Stunde vorm Start bis 1 min vorm Start eine Erfassung
vornimmt und die Starter dann "nur" als gestartet gekennzeichnet sind? Dies ist
beispielsweise bei gr��eren Schwimm- und Triathlonveranstaltungen notwendig, wo
keine Echtzeitmessung erfolgen kann.


================================================================================
Import/Export:
================================================================================

15.9.2012:
Wettkampfdaten �bernehmen erm�glichen. Jetzt bei Import ohne Teilnehmer wird alles
oder nichts �bernommen, z.B. auch Wettkampfname. In gleicher Datei ist z.B. Name bereits
vorhanden und �bernahme der Daten geht nicht. z.B. Altersklassendefinition
vom anderen, vorjahresWettkampf �bernehmen.

--------------------------------------------------------------------------------
Wir haben alle Wettk�mpfe in einer csv-Datei, die man vor dem Import erst
umst�ndlich in Excel importieren und dann wieder in separate Excel-Files
aufsplitten und speichern mu�. Somit w�re w�nschenswert:
Import mehrerer Wettk�mpfe aus einer Tabelle, z.B. �ber den Inhalt eines Feldes
 (LAUF = '0' -> Wettkampf1, LAUF = 1 -> Wettkampf2, ..) oder �ber verschiedene
 Felder (HAUPTLAUF = 'J' -> Wettkampf1, HOBBY = 'J' -> Wettkampf2, ..
Eine gro�e Vereinfachung w�re auch, wenn man wie bisher jeden Wettkampf einzeln
importieren mu�, aber mit einer Filterfunktion
D.h. ich kann einen Wettkampf nach dem anderen aus der gleichen csv-Datei importieren,
und mu� nur jedesmal einen anderen Filter angeben (Import f�r Wettkampf1 :
Filterbedingung : HAUPTLAUF = 'J')

................................................................................
Flexiblere Importfunktion - Cierpinsky - 12. Oktober 2007
Zum Erfassen:
Vorbedingungen:
- Wir haben Voranmeldungen per Internet erfasst.
- Wir hatten 3 Laptops am Wettkampftag (Laptop A, B, C).
- 2 Disziplinen (Staffel und 10-km-Lauf).

Vorgehen:
- Ich habe auf einem Laptop die Stammdaten Veranstaltung, Wettk�mpfe, Optionen
zu den Wettk�mpfen erfasst.
- Dann wurde diese Datei auf allen Laptops verteilt.
- Auf Laptop A (f�hrendes System) wurden die bereits erfassten Meldungen des
10-km-Laufes eingespielt. Nur hier konnte die Bezahlung f�r die 10 Kilometer und
die Startnummer zugeordnet werden.
- Auf Laptop B wurden die bereits erfassten Meldungen der Staffel eingespielt.
Nur hier konnte die Bezahlung und die Startnummer f�r die Staffeln zugeordnet
werden (Nachmeldungen und Zuordnung der Startnummern).
- Auf Laptop C konnten nur Nachmeldungen f�r die 10 Kilometer erfasst werden.
- Auf Laptop A wurden nach Abschluss alle Daten von Laptop B und C importiert.

Nun zu den Problemen:
Problem 1:
W�ren auf Laptop C bereits Daten des 10-km-Laufes vorhanden, w�re der Import
abgebrochen bzw. h�tte die bereits auf Laptop A zugeordnete Startnummer gel�scht,
da der Import immer der "f�hrende" Datensatz zu sein scheint.
Problem 2:
Auf Laptop C konnte keine Recherche betrieben werden. So mussten sichergestellt
sein, dass sich die Sportler an die richtige Schlange anstellen (Nachmelder oder
bereits bezahlt, aber keine Startnummer).
Problem 3:
Laptops wurden nicht effektiv genutzt (Laptop B waren deutlich weniger belastet).
Problem 4:
Eine nachtr�gliche �nderung der AKs und Optionen (hatte etwas vergessen), wurde
beim Importieren ignoriert.

M�gliche L�sungsans�tze:
Zu Problem 1:
-	Datensatz mit �Startnummer zugeordnet� bleibt bestehen, der importierte
Datensatz mit Status �Eingegeben� wird ignoriert. Es ist davon auszugehen, dass
ein Sportler nicht zweimal an ein (unterschiedliches) Terminal geht und an einem
seine Startnummer abholg und an einem anderen z. B. seine Stra�e korrigiert.
Zu Problem 2:
-	Siehe Problem 1: Wenn der Datensatz beim Import mit einer h�heren Einstufung
(�Startnummer vergeben� statt �Erfasst�) bestehen bleibt, k�nnen an mehreren
Stationen die bereits erfassten Sportler bedient werden und Ihnen Startnummern
zugeordnet werden.
Zu Problem 3:
-	W�rde sich auch mit dem Problem 1 l�sen lassen. Es k�nnen auf allen Laptops die
gleichen vorangemeldeten Sportler eingetragen sein. So ist jedes Terminal f�r
jede Aufgabe ger�stet (Nachmeldung bzw. Zuordnung der Startnummer zur Voranmeldung
f�r jede Disziplin).
Zu Problem 4:
-	Vielleicht k�nnte mal die Abweichungen darstellen, um die �nderungen an den
Veranstaltungsdaten auch auf den anderen Rechnern nachziehen zu k�nnen.
-	Alternativ w�re auch das separate Ausspielen der Veranstaltungsdaten und der
Import auf andere Stationen m�glich.

Ich hoffe, Sie konnten meine Situation ein wenig nachvollziehen.
Ich danke Ihnen schon jetzt daf�r, dass Sie sich mit der Problematik besch�ftigen
und w�nsche viel Erfolg!

Mit freundlichen Gr��en

Andr� Cierpinski

................................................................................
Wettk�mpfe und Startgruppen beim Import automatisch erstellen
Nur bei Tria-Import?


================================================================================

================================================================================
Tln Dialog
................................................................................
Eingabe in allen Textfelder mit Dropdownliste erweitern:
f�r alle Textfelder: z.B. TlnDlg: Name, Vorname, Verein, etc.

Bei Wahlfelder wie Wettk. auch Auswahl �ber Buchstaben, Text sofort erweitern,
wie Schriftart bei Word.

Verhalten wie Internet Explorer: bei jede Buchstabe werden alle vorhandene Texte
aufgelistet und k�nnen mit Pfeil oder Tab selektiert werden.
Erst bei Selektion wird eingegebene Text erweitert und bei Exit festgehalten.
Oder wie bei Schriftart, Word sofort erweitern

Wenn im Feld Namen jetzt automatisch nach der Eingabe vom M  z.B.:
�	Meier, Peter
�	Mustermann, Anne
�	Mustermann, Paul
�	Mustermann, Paula
�	M�ller, Karl
auftauchen habe ich Paul gefunden, sogar wenn Musterman_ hei�t.
================================================================================

================================================================================
Schneider - 23.7.2009
�	 Vereinfachte AK-Liste umschaltbar (M30 = 30..39, M40 = 40..49, ...)
�	 konfigurierbare Filter f�r Vereinsnennung : Viele geben bei Verein "kein",
"ohne", "---" ein. Wenn das dann auf der Urkunde erscheint, ist nicht sch�n.
Die manuelle Nachbearbeitung macht halt immer Arbeit
Ein Feature, das wahrscheinlich schwer zu realisieren ist, w�ren konfigurierbare
Zusatzfelder. Bei uns haben wir z.B. als Sponsor eine Bank, und bei der Anmeldung
kann man verschiedene Bankfilialen f�r die Urkundenabholung bzw. auch den Postweg
angeben. Hier w�re dann eben z.B. eine Combobox mit den verschiedenen Optionen
'keine Urkunde', 'Urkunde per Post', 'Abholung Filiale 1', usw. w�nschenswert.

Ein Thema ist nat�rlich auch das Arbeiten im Netzwerk an einer gemeinsamen Datenbasis,
z.B. dass mehrere PC's die Nachmeldungen parallel erfassen. Hier sehe ich momentan
nur die M�glichkeit, dass jeder Nachmeldeplatz sein eigenes Startnummernkontigent
erh�lt, und dann die einzelnen tria-Files in den Rechner mit den Voranmeldungen
importiert.

Viele Gr��e
Oskar Schneider

================================================================================
Rost 7.6.09:

Dlg schliessen mit ESC. und Abfrage wenn was ge�ndert wurde ==> nicht konsequent

bei MschWettk, alle Tln in gleiche SGrp  - pr�fen

SGrpDlg und weitere?
wenn SnrVon Initwert = 0, dann keine Fehlermeldung bei OK (Min = 1) ,
Dialog wird nicht geschlossen
==> 0 kann nur im fehlerfall entstanden sein, nomal nicht m�glich

Berchnung MschStZeiten und MschZeiten pr�fen  (24:00:00-Grenze)

================================================================================

================================================================================

================================================================================
Rost 4.5.2009 - Plausibilit�tspr�fung
F�r eine sp�tere Option k�nnte ich mir eine "Plausibilit�tspr�fung"  
vorstellen. So k�nnten Wertungen markiert werden, die nicht in den Sektor passen
(z.B. wenn 10 km gelaufen werden, sollten alle Ergebnisse unter 28 min und �ber
1:20 h markiert werden). Dies k�nnte auch bei Rundenrennen interessant sein,
wenn die Runden nur zwischen 10 und 20 min absolviert werden k�nnen.
================================================================================

================================================================================

================================================================================
Hansen
--------------------------------------------------------------------------------

     Da ich ein "Schussel" bin und sowieso keine Anleitungen lese, aber erwarte,
     das alles auch ohne Lekt�re funktioniert (was mich entweder w�tend macht
     oder den "Hacker" in mir wachr�ttelt) hier vielleicht
     die Anregung sowas wie einen Assistenten (f�r Dumm-User) einzubauen:
     "Definieren Sie zuerst eine Veranstaltung", definieren sie jetzt Wettk�mpfe
     daf�r, Definierren sie Startnummen-kreise usw. weil ich nicht wirklich mit
     TRIA arbeite muss ich mir das auf meine Weise immer wieder herlei(d)ten.
     Ist aber nur meine Sicht. Man kann nat�rlich auch Deine gute Anleitung lesen..
     ===> Gute Idee, die ich auch irgendwann aufgreifen werde. Ist aber aufwendig
     und wird deshalb noch etwas dauern.


================================================================================
Staffelwertungsklassen??
--------------------------------------------------------------------------------
Ausschreibung
Landesschwimmverband Brandenburg e.V.
Berliner Schwimm-Verband e.V.
SV Wasserfreunde Brandenburg e.V.
Landesmeisterschaften
Berlin - Brandenburg 2007 der Masters "kurze Strecke 
Staffelwertungsklassen der WK 1, 10, 11, 12, 13, 18, 19, 28 und 29
a)    80 bis 99 Jahre b) 100 bis 119 Jahre c) 120 bis 159 Jahre
d) 160 bis 199 Jahre  e) 200 bis 239 Jahre  f) 240 bis 279 Jahre 
g) 280 bis 319 Jahre  h) 320 bis 359 Jahre  i) 360 Jahre und �lter  
Es gilt das tats�chliche Gesamtalter (nur Jahre) der Staffelteilnehmer mit
Stichtag 31.12.2007.
Bei Mixed - Staffeln starten je die H�lfte weibliche Starterinnen bzw. m�nnliche
Starter.
Jede Schwimmerinnen bzw. jeder Schwimmer kann in einem Staffelwettbewerb nur
einmal starten.
================================================================================

================================================================================
Drucker:
- Drucker-Einstellungen in Tria.ini speichern?
================================================================================

================================================================================
Altersklassen:
Bei Startliste gibt es immer eine Spalte Ak, auch wenn (k)eine Ak vorhanden ist,
sowohl bei Teilnehmer als auch Mannschaften
================================================================================

================================================================================
Wettkampf+Daten aus alte Datei �bernehmen. Jetzt muss erst einen Wettkampf
definiert werden, bevor Daten importiert werden k�nnen.
================================================================================

================================================================================
Netzwerkf�higkeit:
================================================================================
bei Volksl�ufe werden Teilnehmer an mehreren Rechnern
parallel eingegeben, auch wenn der wettkampf schon l�uft.
Startnummern/Teilnehmernamen d�rfen nicht doppelt vergeben werden.

================================================================================
Startgruppe / Startnummer:
================================================================================
Starnr.-vergabe nach dem Zufallsprinzip
Startmodus f�r individuell einlesbare Startzeiten (Rolf Call- WALK)/ Rost

Startnummern f�r alle SGrp pro Wettk und f�r alle Wettk (Volkslauf)
- gemeinsamer Block �ber alle Wettk�mpfe
- Bl�cke getrennt pro Wettkampf aber gemeinsam f�r alle Startgruppen des Wettkampfes
- Bl�cke getrennt pro Startgruppe (wie heute)
Startnummern-vergabe automatisieren, z.B. pro Mannschaft oder nach Alphabet.
- Entsprechend Sortierung, z.B. auch nach Meldezeit
- vergebene Snr beibehalten oder �berschreiben

Siehe auch Excel mit Reihen-Definition

Startnummern f�r alle gelistete Tln l�schen

================================================================================
Startzeiten bei Jagdstart - Veigl 20.7.09
--------------------------------------------------------------------------------
Bei der Berechnung wird die 1. Startzeit f�r die 1. Startnr. der Startgruppe
genommen, unabh�ngig davon welche Startnr. tats�chlich zugeteilt wurden.

Ich denke aber, bei �berlappende Startnummernbl�cke ist es sinnvoller die
Berechnung so zu gestalten, wie Sie es auch erwartet haben. Ich werde dies also
noch mal �berdenken und in Zukunft eventuell �ndern.
================================================================================

================================================================================
Teilnehmer-datenbank - Rost
================================================================================
Ist es eigentlich auch m�glich, dass die Daten der einmal registrierten
Teilnehmer in einer Datenbank abgelegt werden k�nnen und dann das System
beim Neueintrag eventuell den Namen automatisch erg�nzen kann, falls
dieser bereits im System ist?
--------------------------------------------------------------------------------
eine Starterdatenbank zu haben, wo bei der Teilnehmererfassung bei Eingabe des
Nachnamens alle infrage kommenden Starter der Datenbank angezeigt w�rden, und
dann nur noch per Mausklick ausgew�hlt werden m�ssten. Dieses w�re eine enorme
zeitliche Ersparnis bei der Dateneingabe, vor allem bei gr��eren Teilnehmerfeldern.
Beim erstellen von �neuen Teilnehmern� k�nnten dann folgende Komponenten
automatisch in die Starterdatenbank aufgenommen werden: Nachname, Vorname,
Verein, Geburtsjahr

================================================================================
Excel Export sehr langsam
================================================================================


================================================================================
TlnObj.SucheTln: kl�ren ob Tln mit nur unterschiedliche Gro�/Kleinbuchstaben
in TlnColl aufgenommen werden sollten
================================================================================

================================================================================
Startliste Teamwertung
================================================================================
bei Teamwertung wird Startzeit nicht gelistet wenn f�r Tln. keine Mannschaft
definiert ist (es gibt daf�r auch keine fehlermeldung). Der teilnehmer wird auch
nicht gewertet. Einzelwertung hier erlauben???


================================================================================
Ausdruck von Listen :
================================================================================

Mehr Abschnitte mit A3-Format (kann vom Anwender auf A4 skaliert werden)

Rost - 23.7.2009:
Ist es eventuell m�glich in der Ergebnisilste meinetwegen beim Triathlon
Zwischenzeiten zusammenzufassen und auszuwerten? So k�nnte dann z.B. bei drei
Zwischenzeiten das Protokoll so aussehen, dass dann Schwimmen - Rad -
Schwimmen+Rad - Lauf - Endzeit in der Liste steht.
--------------------------------------------------------------------------------

Spalte Ort/Verein breiter - auch im AnmeldeDialog
--------------------------------------------------------------------------------

Spalten und Spaltenbreite flexibel definieren
--------------------------------------------------------------------------------

Flexible Listen mit Logos oben und unten (siehe liste Innsbruck/Hackenjos)
freie Fu�zeile in Listen (Rost)
--------------------------------------------------------------------------------

RaveUnit:
getrennte Reports pro Klasse, wenn Format unterschiedlich/Ak auf neue Seite ???
--------------------------------------------------------------------------------

Es w�re sicherlich f�r alle interessant, wenn z.B. unter der �berschrift der
Veranstaltung kurz die Wetterbedingungen
(Luft- und oder Wassertemperatur und Windst�rke und -richtung) stehen.
Das k�nnte dann bei der Einrichtung des Wettkampfes eingegeben und auch ausgew�hlt
werden welche Daten vorhanden sind.
--------------------------------------------------------------------------------

Lademann:
- Idee: Eine Art "Stylesheet-Funktion" f�r die Protokolle. Unser "Chef" h�tte
gerne die Sportler in 5er-Bl�cken. Und manchmal w�r das Einf�gen eines eigenen
Headers oder Footers schon schick.
- Idee: M�glichkeit zur Kommentierung von Ergebnissen, entweder durch Fu�noten
oder Zwischenzeilen. (bspw. "ist statt 20, 40km Rad gefahren")
--------------------------------------------------------------------------------

optionale Spalte mit Stundenmittel (Nagel-27.10.08)
--------------------------------------------------------------------------------

Zeitr�ckst�nde:
Gollon:
2. In der Ergebnisliste sollte die spalte Zeit R�ckstand anw�hlbar sein.
Beim ersten steht die Zeit beim zweiten und dritten usw die zeit zum ersten.
==>
Macht wahrscheinlich nur bei Laufveranstaltungen mit einem Abschnitt Sinn, da
die Reihenfolge der Zwischenzeiten nicht mit der Endzeit �bereinstimmen muss.
Ich nehme es in meiner Liste auf.
--------------------------------------------------------------------------------

Tr�ger:
Differenzzeiten
--------------------------------------------------------------------------------

Rost:
Bei dieser Gelegenheit f�llt mir noch gleich auf, dass bei einer
Staffelwertung keine Angabe des Rangs nach der Einzeldisziplin
eingeblendet wird. Hast du dies auf Grund des Platzes weggelassen oder ist
es ein Versehen? Ich w�rde mich �ber diese Angabe sehr freuen. Falls es
ein Platzproblem ist, kann man es eventuell beim Export z.B. in Excel
einbinden? ==> Export in 2008-0.2 erledigt
--------------------------------------------------------------------------------

Druckvorschau wird bei Resize nicht an ferstergr��e angepasst
--------------------------------------------------------------------------------



================================================================================

================================================================================
Bei Wechsel VeranstArt pr�fen: Liga-K�rzel, MschGr��e, Ortsnamen
================================================================================

================================================================================
ImportDlg:  Pr�fen ob Einschr�nkungen Liga/Liga, Cup ==> Cup n�tig sind
================================================================================

================================================================================
Checkliste Ziel, Streckenposten
================================================================================

================================================================================
ZeitErfassungsdatei bearbeitbar
================================================================================

================================================================================
Finanzielles
================================================================================
Gollon:
1. Eine Ansicht Startgeldquittung w�re supper.
Hier sind alle l�ufer von einem Verrein auf einer Seite Aufelistet. 
mit Startnummern und zu zahlenden gesammt betrag-Gesamtbetrag. 
(Das vereinfacht die Ausgabe der Startnummern und die Abrechnung)
==> 
steht schon auf meiner ToDo-Liste, habe aber noch keine Terminvorstellung
--------------------------------------------------------------------------------

Erstellen einer DTAUS-Datei und Aufnahme der Kontodaten pro Tln / SMld
--------------------------------------------------------------------------------

Orendorz-Kauserslautern:
Ich habe mir hierzu einen seperaten Reiter vorgestellt mit folgenden Feldern:
- Startgeld
- Tageslizenzgeb�hr
- Nachmeldegeb�hr
- Summe
- gezahlter Betrag
- Datum des Zahlungseingangs
- intern. Vermerk
- Kommentar

Hierbei wird die H�he des Startgeldes durch die Option Einzelstarter/Mannschaft
entschieden (vorher festzulegen). Die Tageslizenz soll nur m�glich sein, wenn es
sich um einen Enzelstarter Kurzdistanz handelt, sondern soll das Feld nicht
erscheinen, der Betrag 0 EUR erscheinen oder grau unterlegt sein (Betrag vorher
festzulegen). Die Nachmeldegeb�hr wird ab einem bestimmten Datum erhoben (z.B.
5 EUR ab dem 20.04.2007 - Daten ebenfalss vorher festzulegen). Eine automatische
Summierung der Einzelbetr�ge w�re w�nschenswert. Als intern. Vermerk w�rde ich
die Position der Buchung verwenden (Textfeld 15 Zeichen). Kommentar als Textfeld
z.B. f�r Erm��igungen wegen gro�er Gruppe (wird intern verrechnet, braucht also
nicht f�r Startgeld Einfluss zu haben).
--------------------------------------------------------------------------------


}


end.
