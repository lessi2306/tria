﻿unit TlnDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, Mask, ComCtrls, Math, Buttons,
  AllgComp,AllgConst,AllgFunc,AllgObj,AkObj,WettkObj,TlnObj,TlnErg,
  SMldObj,VeranObj,SGrpObj,MannsObj,LstFrm,DateiDlg, ToolWin,StrUtils;

procedure TlnAnmelden(SMld:TSMldObj);
procedure TlnBearbeiten(SMld: TSMldObj);
procedure TlnEntfernen;
procedure TlnDisqualifizieren;

type

  TTlnDialog = class(TForm)

  published
    NameLabel: TLabel;
    NameEdit: TTriaEdit;
    VNameLabel: TLabel;
    VNameEdit: TTriaEdit;
    SexLabel: TLabel;
    SexCB: TComboBox;
    JgLabel: TLabel;
    JgEdit: TTriaMaskEdit;
    JgUpDown: TTriaUpDown;
    AlterLabel: TLabel;
    AlterEdit: TTriaEdit;
    WettkLabel: TLabel;
    WettkCB: TComboBox;
    VereinLabel: TLabel;
    VereinLookUpEdit: TTriaLookUpEdit;
    VereinLookUpBtn: TTriaLookUpBtn;
    VereinLookUpGrid: TTriaLookUpGrid;
    MannschLabel: TLabel;
    MannschLookUpEdit: TTriaLookUpEdit;
    MannschLookUpBtn: TTriaLookUpBtn;
    MannschLookUpGrid: TTriaLookUpGrid;
    KlasseGB: TGroupBox;
      AkLabel: TLabel;
      AkEdit: TTriaEdit;
      SondAkLabel: TLabel;
      SondAkEdit: TTriaEdit;

    TlnPageControl: TPageControl;
      AnmeldungTS: TTabSheet;
        AdresseGB: TGroupBox;
          StrasseLabel: TLabel;
          StrasseEdit: TTriaEdit;
          HausNrEdit: TTriaEdit;
          HausNrLabel: TLabel;
          PLZLabel: TLabel;
          PLZEdit: TTriaEdit;
          OrtEdit: TTriaEdit;
          OrtLabel: TLabel;
          EMailLabel: TLabel;
          EMailEdit: TTriaEdit;
        SMldLabel: TLabel;
        SMldCB: TComboBox;
        AllgemeinGB: TGroupBox;
          MldZeitLabel: TLabel;
          MldZeitEdit: TStundenZeitEdit;
          MldZeitLabel2: TLabel;
          LandLabel: TLabel;
          LandEdit: TTriaEdit;
          StartgeldLabel: TLabel;
          StartgeldEdit: TTriaMaskEdit;
          StartgeldLabel2: TLabel;
          RfidCodeLabel: TLabel;
          RfidCodeEdit: TTriaEdit;
          KommentLabel: TLabel;
          KommentEdit: TTriaEdit;
      OptionenTS: TTabSheet;
        WrtgGB: TGroupBox;
          MschWrtgCB: TCheckBox;
          MixMschCB: TCheckBox;
          SerWrtgCB: TCheckBox;
          SondWrtgCB: TCheckBox;
        AusKonkGB: TGroupBox;
          AusKonkAllgCB: TCheckBox;
          AusKonkAltKlCB: TCheckBox;
          AusKonkSondKlCB: TCheckBox;
        AllgOptionGB: TGroupBox;
          UrkDruckCB: TCheckBox;
      StaffelTS: TTabSheet;
        Text1Label: TLabel;
        Text2Label: TLabel;
        StTlnNameLabel: TLabel;
        StTlnVNameLabel: TLabel;
        Tln1NameLabel: TLabel;
        Tln1NameEdit: TTriaEdit;
        Tln1VNameLabel: TLabel;
        Tln1VNameEdit: TTriaEdit;
        Tln2NameLabel: TLabel;
        Tln2NameEdit: TTriaEdit;
        Tln2VNameLabel: TLabel;
        Tln2VNameEdit: TTriaEdit;
        Tln3NameLabel: TLabel;
        Tln3NameEdit: TTriaEdit;
        Tln3VNameLabel: TLabel;
        Tln3VNameEdit: TTriaEdit;
        Tln4NameLabel: TLabel;
        Tln4NameEdit: TTriaEdit;
        Tln4VNameLabel: TLabel;
        Tln4VNameEdit: TTriaEdit;
        Tln5NameLabel: TLabel;
        Tln5NameEdit: TTriaEdit;
        Tln5VNameLabel: TLabel;
        Tln5VNameEdit: TTriaEdit;
        Tln6NameLabel: TLabel;
        Tln6NameEdit: TTriaEdit;
        Tln6VNameLabel: TLabel;
        Tln6VNameEdit: TTriaEdit;
        Tln7NameLabel: TLabel;
        Tln7NameEdit: TTriaEdit;
        Tln7VNameLabel: TLabel;
        Tln7VNameEdit: TTriaEdit;
        Tln8NameLabel: TLabel;
        Tln8NameEdit: TTriaEdit;
        Tln8VNameLabel: TLabel;
        Tln8VNameEdit: TTriaEdit;
      EinteilungTS: TTabSheet;
        SGrpGridLabel: TLabel;
        SGrpGrid: TTriaGrid;
        SBhnLabel: TLabel;
        SBhnGrid: TStringGrid;
        SnrLabel: TLabel;
        SnrEdit: TTriaMaskEdit;
        SnrGrid: TStringGrid;
      Zeitnahme1TS: TTabSheet;
        StartZeit1Label: TLabel;
        Zeitnahme1Label: TLabel;
        Runden1Label: TLabel;
        Ergebnis1Label: TLabel;
        Zeit1Label: TLabel;
        Abs1Label: TLabel;
        Abs1StZeitEdit: TUhrZeitEdit;
        Abs1ZeitEdit: TUhrZeitEdit;
        Abs1Grid: TTriaGrid;
        Abs1Btn: TBitBtn;
        Abs1RndEdit: TTriaEdit;
        Abs1ErgEdit: TTriaEdit;
        Abs2Label: TLabel;
        Abs2StZeitEdit: TUhrZeitEdit;
        Abs2ZeitEdit: TUhrZeitEdit;
        Abs2Grid: TTriaGrid;
        Abs2Btn: TBitBtn;
        Abs2RndEdit: TTriaEdit;
        Abs2ErgEdit: TTriaEdit;
        Abs3Label: TLabel;
        Abs3StZeitEdit: TUhrZeitEdit;
        Abs3ZeitEdit: TUhrZeitEdit;
        Abs3Grid: TTriaGrid;
        Abs3Btn: TBitBtn;
        Abs3RndEdit: TTriaEdit;
        Abs3ErgEdit: TTriaEdit;
        Abs4Label: TLabel;
        Abs4StZeitEdit: TUhrZeitEdit;
        Abs4ZeitEdit: TUhrZeitEdit;
        Abs4Grid: TTriaGrid;
        Abs4Btn: TBitBtn;
        Abs4RndEdit: TTriaEdit;
        Abs4ErgEdit: TTriaEdit;
        Gutschrift1Label: TLabel;
        Gutschrift1Edit: TTriaEdit;
        StrafZeit1Label: TLabel;
        StrafZeit1Edit: TTriaEdit;
        EndZeit1Label: TLabel;
        EndZeit1Edit: TTriaEdit;
        DisqStatus1Label: TLabel;
        Loesch1Label1: TLabel;
        Loesch1Label2: TLabel;
      Zeitnahme2TS: TTabSheet;
        StartZeit2Label: TLabel;
        Zeitnahme2Label: TLabel;
        Runden2Label: TLabel;
        Ergebnis2Label: TLabel;
        Zeit2Label: TLabel;
        Abs5Label: TLabel;
        Abs5StZeitEdit: TUhrZeitEdit;
        Abs5ZeitEdit: TUhrZeitEdit;
        Abs5Grid: TTriaGrid;
        Abs5Btn: TBitBtn;
        Abs5RndEdit: TTriaEdit;
        Abs5ErgEdit: TTriaEdit;
        Abs6Label: TLabel;
        Abs6StZeitEdit: TUhrZeitEdit;
        Abs6ZeitEdit: TUhrZeitEdit;
        Abs6Grid: TTriaGrid;
        Abs6Btn: TBitBtn;
        Abs6RndEdit: TTriaEdit;
        Abs6ErgEdit: TTriaEdit;
        Abs7Label: TLabel;
        Abs7StZeitEdit: TUhrZeitEdit;
        Abs7ZeitEdit: TUhrZeitEdit;
        Abs7Btn: TBitBtn;
        Abs7Grid: TTriaGrid;
        Abs7RndEdit: TTriaEdit;
        Abs7ErgEdit: TTriaEdit;
        Abs8Label: TLabel;
        Abs8StZeitEdit: TUhrZeitEdit;
        Abs8ZeitEdit: TUhrZeitEdit;
        Abs8Btn: TBitBtn;
        Abs8Grid: TTriaGrid;
        Abs8RndEdit: TTriaEdit;
        Abs8ErgEdit: TTriaEdit;
        Gutschrift2Label: TLabel;
        Gutschrift2Edit: TTriaEdit;
        StrafZeit2Label: TLabel;
        StrafZeit2Edit: TTriaEdit;
        EndZeit2Label: TLabel;
        DisqStatus2Label: TLabel;
        EndZeit2Edit: TTriaEdit;
        Loesch2Label1: TLabel;
        Loesch2Label2: TLabel;
      StrafenTS: TTabSheet;
        ZeitGutschrGB: TGroupBox;
          ZeitGutschrLabel: TLabel;
          ZeitGutschrEdit: TMinZeitEdit;
          ZeitGutschrLabel2: TLabel;
        ZeitStrafeGB: TGroupBox;
          ZeitStrafeCB: TCheckBox;
          ZeitStrafeLabel: TLabel;
          ZeitStrafeEdit: TMinZeitEdit;
        DisqGB: TGroupBox;
          DisqCheckBox: TCheckBox;
          DisqGrundEdit: TEdit;
          DisqNameLabel: TLabel;
          DisqNameEdit: TEdit;
        ReststreckeGB: TGroupBox;
          ReststreckeLabel2: TLabel;
          ReststreckeLabel1: TLabel;
          ReststreckeEdit: TTriaMaskEdit;
      WertgTS: TTabSheet;
        TagesRngGB: TGroupBox;
          EndRngLabel: TLabel;
          Abs1RngLabel: TLabel;
          Abs2RngLabel: TLabel;
          Abs3RngLabel: TLabel;
          Abs4RngLabel: TLabel;
          Abs5RngLabel: TLabel;
          Abs6RngLabel: TLabel;
          Abs7RngLabel: TLabel;
          Abs8RngLabel: TLabel;
          AlleRngLabel: TLabel;
          AlleEndRngEdit: TTriaEdit;
          AlleAbs1RngEdit: TTriaEdit;
          AlleAbs2RngEdit: TTriaEdit;
          AlleAbs3RngEdit: TTriaEdit;
          AlleAbs4RngEdit: TTriaEdit;
          AlleAbs5RngEdit: TTriaEdit;
          AlleAbs6RngEdit: TTriaEdit;
          AlleAbs7RngEdit: TTriaEdit;
          AlleAbs8RngEdit: TTriaEdit;
          SexRngLabel: TLabel;
          SexEndRngEdit: TTriaEdit;
          SexAbs1RngEdit: TTriaEdit;
          SexAbs2RngEdit: TTriaEdit;
          SexAbs3RngEdit: TTriaEdit;
          SexAbs4RngEdit: TTriaEdit;
          SexAbs5RngEdit: TTriaEdit;
          SexAbs6RngEdit: TTriaEdit;
          SexAbs7RngEdit: TTriaEdit;
          SexAbs8RngEdit: TTriaEdit;
          AkRngLabel: TLabel;
          AkEndRngEdit: TTriaEdit;
          AkAbs1RngEdit: TTriaEdit;
          AkAbs2RngEdit: TTriaEdit;
          AkAbs3RngEdit: TTriaEdit;
          AkAbs4RngEdit: TTriaEdit;
          AkAbs5RngEdit: TTriaEdit;
          AkAbs6RngEdit: TTriaEdit;
          AkAbs7RngEdit: TTriaEdit;
          AkAbs8RngEdit: TTriaEdit;
          SondRngLabel: TLabel;
          SondEndRngEdit: TTriaEdit;
          SondAbs1RngEdit: TTriaEdit;
          SondAbs2RngEdit: TTriaEdit;
          SondAbs3RngEdit: TTriaEdit;
          SondAbs4RngEdit: TTriaEdit;
          SondAbs5RngEdit: TTriaEdit;
          SondAbs6RngEdit: TTriaEdit;
          SondAbs7RngEdit: TTriaEdit;
          SondAbs8RngEdit: TTriaEdit;
      SondWertgTS: TTabSheet;
        TagesRngSWGB: TGroupBox;
          EndRngSWLabel: TLabel;
          Abs1RngSWLabel: TLabel;
          Abs2RngSWLabel: TLabel;
          Abs3RngSWLabel: TLabel;
          Abs4RngSWLabel: TLabel;
          AlleRngSWLabel: TLabel;
          Abs5RngSWLabel: TLabel;
          Abs6RngSWLabel: TLabel;
          Abs7RngSWLabel: TLabel;
          Abs8RngSWLabel: TLabel;
          AlleEndRngSWEdit: TTriaEdit;
          AlleAbs1RngSWEdit: TTriaEdit;
          AlleAbs2RngSWEdit: TTriaEdit;
          AlleAbs3RngSWEdit: TTriaEdit;
          AlleAbs4RngSWEdit: TTriaEdit;
          AlleAbs5RngSWEdit: TTriaEdit;
          AlleAbs6RngSWEdit: TTriaEdit;
          AlleAbs7RngSWEdit: TTriaEdit;
          AlleAbs8RngSWEdit: TTriaEdit;
          SexRngSWLabel: TLabel;
          SexEndRngSWEdit: TTriaEdit;
          SexAbs1RngSWEdit: TTriaEdit;
          SexAbs2RngSWEdit: TTriaEdit;
          SexAbs3RngSWEdit: TTriaEdit;
          SexAbs4RngSWEdit: TTriaEdit;
          SexAbs5RngSWEdit: TTriaEdit;
          SexAbs6RngSWEdit: TTriaEdit;
          SexAbs7RngSWEdit: TTriaEdit;
          SexAbs8RngSWEdit: TTriaEdit;
          AkRngSWLabel: TLabel;
          AkEndRngSWEdit: TTriaEdit;
          AkAbs1RngSWEdit: TTriaEdit;
          AkAbs2RngSWEdit: TTriaEdit;
          AkAbs3RngSWEdit: TTriaEdit;
          AkAbs4RngSWEdit: TTriaEdit;
          AkAbs5RngSWEdit: TTriaEdit;
          AkAbs6RngSWEdit: TTriaEdit;
          AkAbs7RngSWEdit: TTriaEdit;
          AkAbs8RngSWEdit: TTriaEdit;
          SondRngSWLabel: TLabel;
          SondEndRngSWEdit: TTriaEdit;
          SondAbs1RngSWEdit: TTriaEdit;
          SondAbs2RngSWEdit: TTriaEdit;
          SondAbs3RngSWEdit: TTriaEdit;
          SondAbs4RngSWEdit: TTriaEdit;
          SondAbs5RngSWEdit: TTriaEdit;
          SondAbs6RngSWEdit: TTriaEdit;
          SondAbs7RngSWEdit: TTriaEdit;
          SondAbs8RngSWEdit: TTriaEdit;
      SerWertgTS: TTabSheet;
        TagesSerRngGB: TGroupBox;
          EndRngSerLabel: TLabel;
          AlleRngSerTgLabel: TLabel;
          AlleRngSerTgEdit: TTriaEdit;
          AllePktSerTgEdit: TEdit;
          SexRngSerTgLabel: TLabel;
          SexRngSerTgEdit: TTriaEdit;
          SexPktSerTgEdit: TEdit;
          AkRngSerTgLabel: TLabel;
          AkRngSerTgEdit: TTriaEdit;
          AkPktSerTgEdit: TEdit;
          SondRngSerTgLabel: TLabel;
          SondRngSerTgEdit: TTriaEdit;
          SondPktSerTgEdit: TEdit;
          EndPktSerLabel: TLabel;
        SerRngGB: TGroupBox;
          SeriePktLabel: TLabel;
          SerieRngLabel: TLabel;
          SerieAlleLabel: TLabel;
          SerieRngAlleEdit: TEdit;
          SeriePktAlleEdit: TEdit;
          SerieSexLabel: TLabel;
          SerieRngSexEdit: TEdit;
          SeriePktSexEdit: TEdit;
          SerieAkLabel: TLabel;
          SerieRngAkEdit: TEdit;
          SeriePktAkEdit: TEdit;
          SerieSkLabel: TLabel;
          SerieRngSkEdit: TEdit;
          SeriePktSkEdit: TEdit;

    TlnFirstBtn: TBitBtn;
    TlnBackBtn: TBitBtn;
    TlnNextBtn: TBitBtn;
    TlnlastBtn: TBitBtn;
    NextAnmButton: TButton;
    AendButton: TButton;
    CancelButton: TButton;
    OkButton: TButton;
    HilfeButton: TButton;

  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

  protected
    HelpFensterAlt   : TWinControl;
    TlnBuffer        : TTlnObj;
    AnmeldungDlg     : Boolean;
    TlnNeu           : Boolean;
    Updating         : Boolean;
    DisableButtons   : Boolean;
    PageAktuell      : TTabSheet;
    ControlAktuell   : TWinControl;
    KeinSexAkzeptiert: Boolean;
    KeinJgAkzeptiert : Boolean;
    AkAkzeptiert     : Boolean;
    SnrAkzeptiert    : Boolean;
    SBhnNullAkzeptiert : Boolean;
    KeinStaffelAkzeptiert : Boolean;
    SGrpNichtEingeteilt : TSGrpObj;
    SGrpCount        : array[0..cnSGrpMax] of Integer;
    SnrBelegtArr     : array[1..cnTlnMax] of Boolean; // kostet zeit,vorher berechnen
    //StrtZeitAlt      : Integer;
    AbsRndZeitAltArr : array [wkAbs1..wkAbs8] of TIntegerCollection;
    GutschriftAlt    : Integer;
    StrafZeitAlt     : Integer;
    RestStreckeAlt   : Integer;
    SexAlt           : TSex;
    JgAlt            : Integer;
    WettkAlt         : TWettkObj;
    SGrpAlt          : TSGrpObj;
    SBhnAlt          : Integer;
    SnrAlt           : Integer;
    RfidAlt          : String;
    SGrpVoreinstellen,
    SGrpVoreingestellt,
    SnrVoreingestellt : Boolean;

    // TlnStaffel
    TlnNameLabel  : array [wkAbs1..wkAbs8] of TLabel;
    TlnNameEdit   : array [wkAbs1..wkAbs8] of TTriaEdit;
    TlnVNameLabel : array [wkAbs1..wkAbs8] of TLabel;
    TlnVNameEdit  : array [wkAbs1..wkAbs8] of TTriaEdit;

    AbsLabel      : array [wkAbs1..wkAbs8] of TLabel;
    AbsStartEdit  : array [wkAbs1..wkAbs8] of TUhrZeitEdit;
    AbsZeitEdit   : array [wkAbs1..wkAbs8] of TUhrZeitEdit;
    AbsGrid       : array [wkAbs1..wkAbs8] of TTriaGrid;
    AbsBtn        : array [wkAbs1..wkAbs8] of TBitBtn;
    AbsRndEdit    : array [wkAbs1..wkAbs8] of TTriaEdit;
    AbsErgEdit    : array [wkAbs1..wkAbs8] of TTriaEdit;

    AbsRngLabel   : array [wkAbs0..wkAbs8] of TLabel;
    AbsRngEdit    : array [kwAlle..kwSondKl, wkAbs0..wkAbs8] of TTriaEdit;
    RngLabel      : array [kwAlle..kwSondKl] of TLabel;

    AbsRngSWLabel : array [wkAbs0..wkAbs8] of TLabel;
    AbsRngSWEdit  : array [kwAlle..kwSondKl, wkAbs0..wkAbs8] of TTriaEdit;
    RngSWLabel    : array [kwAlle..kwSondKl] of TLabel;

    RngSerTgLabel : array [kwAlle..kwSondKl] of TLabel;
    RngSerTgEdit  : array [kwAlle..kwSondKl] of TTriaEdit;
    PktSerTgEdit  : array [kwAlle..kwSondKl] of TEdit;
    SerieLabel    : array [kwAlle..kwSondKl] of TLabel;
    SerieRngEdit  : array [kwAlle..kwSondKl] of TEdit;
    SeriePktEdit  : array [kwAlle..kwSondKl] of TEdit;

    GutschriftLabel : array[1..2] of TLabel;
    GutschriftEdit  : array[1..2] of TTriaEdit;
    StrafZeitLabel  : array[1..2] of TLabel;
    StrafZeitEdit   : array[1..2] of TTriaEdit;
    EndZeitLabel    : array[1..2] of TLabel;
    EndZeitEdit     : array[1..2] of TTriaEdit;
    DisqStatusLabel : array[1..2] of TLabel;
    MannschListe    : TStringList;
    VereinListe     : TStringList;

    procedure InitTlnBuffer(Tln:TTlnObj);
    procedure InitData;
    procedure InitDialog;
    procedure UpdateSex(Sender: TObject);
    procedure UpdateJg(Sender: TObject);
    procedure UpdateKlasse;
    //procedure UpdateVereinLabel;
    procedure UpdateMannschLabel;
    procedure UpdateAdresse;
    procedure UpdateRfidCode;
    procedure UpdateStaffelTln;
    procedure UpdateMschWrtg;
    procedure UpdateMixWrtg;
    procedure UpdateVereinListe;
    procedure UpdateMannschListe;
    procedure UpdateSondWrtg;
    procedure UpdateSerWrtg;
    procedure UpdateAusKonk;
    procedure UpdateTlnTxt;
    procedure UpdateStartgeld;
    procedure UpdateSGrpListe;
    procedure UpdateSBhnListe;
    procedure UpdateSnr;
    procedure UpdateSnrListe;
    procedure UpdateZeiten;
    function  AbsGridHide(Abs:TWkAbschnitt): Boolean; overload;
    function  AbsGridHide: Boolean; overload;
    procedure UpdateZeitStrafe;
    procedure UpdateZeitGutschrift;
    procedure UpdateDisqGrund;
    procedure UpdateReststrecke;
    procedure InitZeitnahmeTS;
    procedure InitWertgTS;
    procedure InitSondWertgTS;
    procedure InitSerWertgTS;
    procedure UpdatePageControl;
    function  GetSex: TSex;
    function  GetWettk: TWettkObj;
    function  GetVerein: String;
    function  GetMannschName: String;
    function  GetSMld: TSMldObj;
    function  GetSGrp: TSGrpObj;
    function  GetSBhn: Integer;
    procedure SetPage(Page:TTabSheet);
    procedure SetButtons;
    function  ZeitGeaendert(Abs:TWkAbschnitt): Boolean; overload;
    function  ZeitGeaendert: Boolean; overload;
    function  StaffelTlnGeaendert: Boolean;
    function  TlnGeaendert: Boolean;
    function  TabGeaendert: Boolean;
    function  TlnDoppel: Boolean;
    function  SnrDoppel: Boolean;
    function  RfidDoppel: Boolean;
    function  EingabeOK(Tab:TTabSheet): Boolean;
    //procedure VereinNeu;
    procedure MannschNeu;
    function  TlnAendern: Boolean;
    procedure TlnFirst;
    procedure TlnLast;
    procedure TlnNext;
    procedure TlnBack;
    function  GetJg: Integer;

  published
    // Event Handler Allgemein
    procedure FormShow(Sender: TObject);
    procedure EingabeChange(Sender: TObject);
    procedure NameLabelClick(Sender: TObject);
    procedure VNameLabelClick(Sender: TObject);
    procedure SexLabelClick(Sender: TObject);
    procedure JgLabelClick(Sender: TObject);
    procedure JgUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure LandLabelClick(Sender: TObject);
    procedure WettkLabelClick(Sender: TObject);
    procedure VereinLabelClick(Sender: TObject);
    procedure MannschLabelClick(Sender: TObject);
    procedure VereinLookUpGridGetRowText(Sender:TTriaLookUpGrid;Indx:Integer;var Value:string);
    procedure MannschLookUpGridGetRowText(Sender: TTriaLookUpGrid;Indx:Integer;var Value:String);
    procedure TlnPageControlChange(Sender: TObject);
    procedure TlnPageControlChanging(Sender: TObject; var AllowChange: Boolean);
    procedure EingabeEnter(Sender: TObject);
    // Event Handler Anmeldung
    procedure SMldLabelClick(Sender: TObject);
    procedure StrasseLabelClick(Sender: TObject);
    procedure HausNrLabelClick(Sender: TObject);
    procedure PLZLabelClick(Sender: TObject);
    procedure OrtLabelClick(Sender: TObject);
    procedure EMailLabelClick(Sender: TObject);
    procedure MldZeitLabelClick(Sender: TObject);
    procedure StartgeldLabelClick(Sender: TObject);
    procedure RfidCodeLabelClick(Sender: TObject);
    procedure KommentLabelClick(Sender: TObject);
    // Event Handler Einteilung
    procedure SGrpGridLabelClick(Sender: TObject);
    procedure SGrpGridDrawCell(Sender: TObject; ACol, ARow: Integer;
                               Rect: TRect; State: TGridDrawState);
    procedure SBhnLabelClick(Sender: TObject);
    procedure SnrLabelClick(Sender: TObject);
    // Event Handler Zusatz
    procedure ZeitGutschrLabelClick(Sender: TObject);
    procedure DisqNameLabelClick(Sender: TObject);
    procedure ReststreckeLabelClick(Sender: TObject);
    // Event Handler Zeitnahme
    procedure AbsLabelClick(Sender: TObject);
    procedure ZeitnahmeLabelClick(Sender: TObject);
    procedure AbsZeitEditClick(Sender: TObject);
    procedure AbsGridClick(Sender: TObject);
    procedure AbsBtnClick(Sender: TObject);
    procedure AbsGridDrawCell(Sender: TObject; ACol, ARow: Integer;
                              Rect: TRect; State: TGridDrawState);
    // Event Handler Buttons
    procedure NextAnmButtonClick(Sender: TObject);
    procedure AendButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure TlnFirstBtnClick(Sender: TObject);
    procedure TlnBackBtnClick(Sender: TObject);
    procedure TlnNextBtnClick(Sender: TObject);
    procedure TlnLastBtnClick(Sender: TObject);
    procedure NavKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HilfeButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  TlnDialog          : TTlnDialog;
  SammelMelder       : TSMldObj;
  TlnAktuell         : TTlnObj;
  WettkAktuell       : TWettkObj;
  //MschNamePtrAktuell : PString;

implementation

uses TriaMain,CmdProc,VistaFix;

{$R *.DFM}

//******************************************************************************
procedure TlnAnmelden(SMld: TSMldObj);
//******************************************************************************
begin
  TlnAktuell := nil;    (* Neue Teilnehmer Anmelden *)
  SammelMelder := SMld; (* nil bei Einzelmeldung *)
  {if SammelMelder<>nil then
  begin
    if SammelMelder.MannschName<>nil then
      MschNamePtrAktuell := SammelMelder.MannschName;
    //LandAktuell := SammelMelder.Land;
  end else
  begin
    MschNameptrAktuell := nil;
    //LandAktuell := '';
  end;}
  if HauptFenster.SortWettk = WettkAlleDummy then
    WettkAktuell := Veranstaltung.WettkColl.Items[0]
  else WettkAktuell := HauptFenster.SortWettk; (* Voreinstellung *)
  TlnDialog := TTlnDialog.Create(HauptFenster);
  try
    TlnDialog.ShowModal;
  finally
    FreeAndNil(TlnDialog);
  end;
  HauptFenster.RefreshAnsicht;
end;

//******************************************************************************
procedure TlnBearbeiten(SMld: TSMldObj);
//******************************************************************************
begin
  if HauptFenster.LstFrame.TriaGrid.ItemCount = 0 then
  begin
    TriaMessage('Liste enthält keine Teilnehmer.',mtInformation,[mbOk]);
    Exit;
  end;
  TlnAktuell := TTlnObj(HauptFenster.LstFrame.TriaGrid.FocusedItem);
  if (TlnAktuell=nil) or (TlnAktuell.Name=cnDummyName) then Exit; (* DummyTln *)
  SammelMelder := SMld; (* nil bei Einzelmeldung *)

  TlnDialog := TTlnDialog.Create(HauptFenster);
  try
    TlnDialog.ShowModal;
  finally
    FreeAndNil(TlnDialog);
  end;
  HauptFenster.RefreshAnsicht;
end;

//******************************************************************************
procedure TlnEntfernen;
//******************************************************************************
var i,Idx : Integer;
begin
  TlnAktuell := TTlnObj(HauptFenster.LstFrame.TriaGrid.FocusedItem);
  if (TlnAktuell=nil) or (TlnAktuell.Name=cnDummyName) then Exit; (* DummyTln *)
  Idx := HauptFenster.LstFrame.TriaGrid.ItemIndex;

  case TriaMessage('Teilnehmer  "' + TlnAktuell.NameVName + '"  entfernen?',
                   mtConfirmation,[mbYes,mbNo,mbYesToAll]) of
    mrYes:
    begin
      HauptFenster.LstFrame.TriaGrid.StopPaint := true;
      try
        // MschTln löschen bevor Tln gelöscht wird, weil dabei MannschPtr:=nil gesetzt wird
        Veranstaltung.MannschColl.MschTlnLoeschen(TlnAktuell);
        Veranstaltung.TlnColl.ClearItem(TlnAktuell); // Tln in SMld.TlnListe gelöscht
        TriDatei.Modified := true;
        (* Wettk.ErgModified und .MschModified werden in ClearItem gesetzt *)
      finally
        HauptFenster.CommandDataUpdate;
        // FocusZeile soll gleich bleiben, nach UpdateAnsicht in CommandDataUpdate
        with HauptFenster.LstFrame.TriaGrid do
        begin
          if Idx < ItemCount then
            ItemIndex := Idx
          else
            ItemIndex := ItemCount - 1;
          HauptFenster.FocusedTln := FocusedItem;
          StopPaint := false;
        end;
      end;
    end;
    mrYesToAll: // zur Sicherheit nochmals abfragen
      if TriaMessage('Wirklich alle gelisteten Teilnehmer entfernen?',
                     mtConfirmation,[mbYes,mbNo]) = mrYes then
      begin
        HauptFenster.LstFrame.TriaGrid.StopPaint := true;
        try
          for i:=HauptFenster.LstFrame.TriaGrid.ItemCount-1 downto 0 do
          begin
            TlnAktuell := TTlnObj(HauptFenster.LstFrame.TriaGrid[i]);
            if (TlnAktuell=nil) or (TlnAktuell.Name=cnDummyName) then Continue; (* DummyTln *)
            Veranstaltung.MannschColl.MschTlnLoeschen(TlnAktuell);
            Veranstaltung.TlnColl.ClearItem(TlnAktuell);
            TriDatei.Modified := true;
         end;
        finally
          HauptFenster.CommandDataUpdate;
          HauptFenster.LstFrame.TriaGrid.StopPaint := false;
        end;
    end;
  end;
end;

//******************************************************************************
procedure TlnDisqualifizieren;
//******************************************************************************
var Idx : Integer;
begin
  TlnAktuell := TTlnObj(HauptFenster.LstFrame.TriaGrid.FocusedItem);
  if (TlnAktuell=nil) or (TlnAktuell.Name=cnDummyName) or
     (not TlnAktuell.TlnInStatus(stEingeteilt)) then Exit; (* DummyTln *)
  Idx := HauptFenster.LstFrame.TriaGrid.ItemIndex;

  if TlnAktuell.DisqGrund <> '' then // StrGleich nicht benutzen, weil cnDisqGrundDummy = ' '
  begin
    if TriaMessage('Teilnehmer  "' + TlnAktuell.NameVName + '"  wurde bereits disqualifiziert.'+#13+
                   'Disqualifikation aufheben?',
                    mtConfirmation,[mbYes,mbNo]) = mrYes then
    begin
      HauptFenster.LstFrame.TriaGrid.StopPaint := true;
      try
        TlnAktuell.DisqGrund := '';
        TlnAktuell.DisqName  := '';//Wettk.DisqTxt;
        TriDatei.Modified := true; // Wettk.ErgModified wird in SetDisqGrund gesetzt
      finally
        HauptFenster.CommandDataUpdate;
        with HauptFenster.LstFrame.TriaGrid do
        begin
          if GetIndex(TlnAktuell) < 0 then
            if Idx < ItemCount then // ursprünglicher Index von TlnAktuell
              ItemIndex := Idx
            else
             ItemIndex := ItemCount - 1;
          HauptFenster.FocusedTln := TlnAktuell; // bleibt unverändert
          StopPaint := false;
        end;
      end;
    end;
  end else
    if TriaMessage('Teilnehmer  "' + TlnAktuell.NameVName + '"  disqualifizieren?',
                   mtConfirmation,[mbYes,mbNo]) = mrYes then
    begin
      HauptFenster.LstFrame.TriaGrid.StopPaint := true;
      try
        if Veranstaltung.DisqGrundColl.Count >= cnDisqGrundMax then
        begin
          TriaMessage('Maximale Zahl von Disqualifikationen erreicht.',
                       mtInformation,[mbOk]);
          Exit;
        end else
        begin
          TlnAktuell.DisqGrund := cnDisqGrundDummy;
          // DisqName unverändert
          TriDatei.Modified := true; // Wettk.ErgModified wird in SetDisqGrund gesetzt
        end;
      finally
        HauptFenster.CommandDataUpdate;
        with HauptFenster.LstFrame.TriaGrid do
        begin
          if GetIndex(TlnAktuell) < 0 then
            if Idx < ItemCount then // ursprünglicher Index von TlnAktuell
              ItemIndex := Idx
            else
             ItemIndex := ItemCount - 1;
          HauptFenster.FocusedTln := TlnAktuell; // bleibt unverändert
          StopPaint := false;
        end;
      end;
    end;
end;


// public Methoden

//==============================================================================
constructor TTlnDialog.Create(AOwner: TComponent);
//==============================================================================
var i : Integer;
    AbsCnt : TWkAbschnitt;
//------------------------------------------------------------------------------
function SMldStr(SMld:TSmldObj):String;
begin
  if SMld <> nil then
    Result := SMld.VNameName + ', ' + SMld.MannschName
  else Result := '';
end;

//------------------------------------------------------------------------------
procedure CreateAbsGrid(Abs:TWkAbschnitt);
begin
  with AbsGrid[Abs] do
  begin
    BringToFront;
    Hide;
    FixedCols := 0;
    FixedRows := 1;
    Canvas.Font := Font;
    DefaultRowHeight := 17;
    TopAbstand := (DefaultRowHeight - Canvas.TextHeight('Tg')) DIV 2; // =2
    ColCount := 3;
    ColWidths[0] := Canvas.TextWidth(' Runde ');
    ColWidths[1] := 84;
    ColWidths[2] := Canvas.TextWidth(' Rundezeit  ');
    ClientWidth:= ColWidths[0]+ColWidths[1]+ColWidths[2] + 2;
    Left := AbsZeitEdit[Abs].Left - Colwidths[0] - 2;
  end;
end;

//------------------------------------------------------------------------------
procedure InitAbsArr;
begin
  // kwAlle
  // kwSex
  // kwAltKl
  // kwSondKl

  // Abs0
  //WertgTS
  RngLabel[kwAlle]              := AlleRngLabel;
  RngLabel[kwSex]               := SexRngLabel;
  RngLabel[kwAltKl]             := AkRngLabel;
  AbsRngLabel[wkAbs0]           := EndRngLabel;
  RngLabel[kwSondKl]            := SondRngLabel;
  AbsRngEdit[kwAlle,wkAbs0]     := AlleEndRngEdit;
  AbsRngEdit[kwSex,wkAbs0]      := SexEndRngEdit;
  AbsRngEdit[kwAltKl,wkAbs0]    := AkEndRngEdit;
  AbsRngEdit[kwSondKl,wkAbs0]   := SondEndRngEdit;
  //SondWertgTS
  RngSWLabel[kwAlle]            := AlleRngSWLabel;
  RngSWLabel[kwSex]             := SexRngSWLabel;
  RngSWLabel[kwAltKl]           := AkRngSWLabel;
  RngSWLabel[kwSondKl]          := SondRngSWLabel;
  AbsRngSWLabel[wkAbs0]         := EndRngSWLabel;
  AbsRngSWEdit[kwAlle,wkAbs0]   := AlleEndRngSWEdit;
  AbsRngSWEdit[kwSex,wkAbs0]    := SexEndRngSWEdit;
  AbsRngSWEdit[kwAltKl,wkAbs0]  := AkEndRngSWEdit;
  AbsRngSWEdit[kwSondKl,wkAbs0] := SondEndRngSWEdit;
  //SerWertgTS
  // EndRngSerLabel: kein Array
  RngSerTgLabel[kwAlle]         := AlleRngSerTgLabel;
  RngSerTgLabel[kwSex]          := SexRngSerTgLabel;
  RngSerTgLabel[kwAltKl]        := AkRngSerTgLabel;
  RngSerTgLabel[kwSondKl]       := SondRngSerTgLabel;
  RngSerTgEdit[kwAlle]          := AlleRngSerTgEdit;
  RngSerTgEdit[kwSex]           := SexRngSerTgEdit;
  RngSerTgEdit[kwAltKl]         := AkRngSerTgEdit;
  RngSerTgEdit[kwSondKl]        := SondRngSerTgEdit;
  PktSerTgEdit[kwAlle]          := AllePktSerTgEdit;
  PktSerTgEdit[kwSex]           := SexPktSerTgEdit;
  PktSerTgEdit[kwAltKl]         := AkPktSerTgEdit;
  PktSerTgEdit[kwSondKl]        := SondPktSerTgEdit;
  // SerieRngLabel: kein Array
  // SeriePktLabel: kein Array
  SerieLabel[kwAlle]            := SerieAlleLabel;
  SerieLabel[kwSex]             := SerieSexLabel;
  SerieLabel[kwAltKl]           := SerieAkLabel;
  SerieLabel[kwSondKl]          := SerieSkLabel;
  SerieRngEdit[kwAlle]          := SerieRngAlleEdit;
  SerieRngEdit[kwSex]           := SerieRngSexEdit;
  SerieRngEdit[kwAltKl]         := SerieRngAkEdit;
  SerieRngEdit[kwSondKl]        := SerieRngSkEdit;
  SeriePktEdit[kwAlle]          := SeriePktAlleEdit;
  SeriePktEdit[kwSex]           := SeriePktSexEdit;
  SeriePktEdit[kwAltKl]         := SeriePktAkEdit;
  SeriePktEdit[kwSondKl]        := SeriePktSkEdit;

  // Abs1
  TlnNameLabel[wkAbs1]  := Tln1NameLabel;
  TlnNameEdit[wkAbs1]   := Tln1NameEdit;
  TlnVNameLabel[wkAbs1] := Tln1VNameLabel;
  TlnVNameEdit[wkAbs1]  := Tln1VNameEdit;
  AbsLabel[wkAbs1]      := Abs1Label;
  AbsStartEdit[wkAbs1]  := Abs1StZeitEdit;
  AbsZeitEdit[wkAbs1]   := Abs1ZeitEdit;
  AbsGrid[wkAbs1]       := Abs1Grid;
  AbsBtn[wkAbs1]        := Abs1Btn;
  AbsRndEdit[wkAbs1]    := Abs1RndEdit;
  AbsErgEdit[wkAbs1]    := Abs1ErgEdit;
  AbsRngLabel[wkAbs1]           := Abs1RngLabel;
  AbsRngEdit[kwAlle,wkAbs1]     := AlleAbs1RngEdit;
  AbsRngEdit[kwSex,wkAbs1]      := SexAbs1RngEdit;
  AbsRngEdit[kwAltKl,wkAbs1]    := AkAbs1RngEdit;
  AbsRngEdit[kwSondKl,wkAbs1]   := SondAbs1RngEdit;
  AbsRngSWLabel[wkAbs1]         := Abs1RngSWLabel;
  AbsRngSWEdit[kwAlle,wkAbs1]   := AlleAbs1RngSWEdit;
  AbsRngSWEdit[kwSex,wkAbs1]    := SexAbs1RngSWEdit;
  AbsRngSWEdit[kwAltKl,wkAbs1]  := AkAbs1RngSWEdit;
  AbsRngSWEdit[kwSondKl,wkAbs1] := SondAbs1RngSWEdit;

  // Abs2
  TlnNameLabel[wkAbs2]  := Tln2NameLabel;
  TlnNameEdit[wkAbs2]   := Tln2NameEdit;
  TlnVNameLabel[wkAbs2] := Tln2VNameLabel;
  TlnVNameEdit[wkAbs2]  := Tln2VNameEdit;
  AbsLabel[wkAbs2]      := Abs2Label;
  AbsStartEdit[wkAbs2]  := Abs2StZeitEdit;
  AbsZeitEdit[wkAbs2]   := Abs2ZeitEdit;
  AbsGrid[wkAbs2]       := Abs2Grid;
  AbsBtn[wkAbs2]        := Abs2Btn;
  AbsRndEdit[wkAbs2]    := Abs2RndEdit;
  AbsErgEdit[wkAbs2]    := Abs2ErgEdit;
  AbsRngLabel[wkAbs2]           := Abs2RngLabel;
  AbsRngEdit[kwAlle,wkAbs2]     := AlleAbs2RngEdit;
  AbsRngEdit[kwSex,wkAbs2]      := SexAbs2RngEdit;
  AbsRngEdit[kwAltKl,wkAbs2]    := AkAbs2RngEdit;
  AbsRngEdit[kwSondKl,wkAbs2]   := SondAbs2RngEdit;
  AbsRngSWLabel[wkAbs2]         := Abs2RngSWLabel;
  AbsRngSWEdit[kwAlle,wkAbs2]   := AlleAbs2RngSWEdit;
  AbsRngSWEdit[kwSex,wkAbs2]    := SexAbs2RngSWEdit;
  AbsRngSWEdit[kwAltKl,wkAbs2]  := AkAbs2RngSWEdit;
  AbsRngSWEdit[kwSondKl,wkAbs2] := SondAbs2RngSWEdit;

  // Abs3
  TlnNameLabel[wkAbs3]  := Tln3NameLabel;
  TlnNameEdit[wkAbs3]   := Tln3NameEdit;
  TlnVNameLabel[wkAbs3] := Tln3VNameLabel;
  TlnVNameEdit[wkAbs3]  := Tln3VNameEdit;
  AbsLabel[wkAbs3]      := Abs3Label;
  AbsStartEdit[wkAbs3]  := Abs3StZeitEdit;
  AbsZeitEdit[wkAbs3]   := Abs3ZeitEdit;
  AbsGrid[wkAbs3]       := Abs3Grid;
  AbsBtn[wkAbs3]        := Abs3Btn;
  AbsRndEdit[wkAbs3]    := Abs3RndEdit;
  AbsErgEdit[wkAbs3]    := Abs3ErgEdit;
  AbsRngLabel[wkAbs3]           := Abs3RngLabel;
  AbsRngEdit[kwAlle,wkAbs3]     := AlleAbs3RngEdit;
  AbsRngEdit[kwSex,wkAbs3]      := SexAbs3RngEdit;
  AbsRngEdit[kwAltKl,wkAbs3]    := AkAbs3RngEdit;
  AbsRngEdit[kwSondKl,wkAbs3]   := SondAbs3RngEdit;
  AbsRngSWLabel[wkAbs3]         := Abs3RngSWLabel;
  AbsRngSWEdit[kwAlle,wkAbs3]   := AlleAbs3RngSWEdit;
  AbsRngSWEdit[kwSex,wkAbs3]    := SexAbs3RngSWEdit;
  AbsRngSWEdit[kwAltKl,wkAbs3]  := AkAbs3RngSWEdit;
  AbsRngSWEdit[kwSondKl,wkAbs3] := SondAbs3RngSWEdit;

  // Abs4
  TlnNameLabel[wkAbs4]  := Tln4NameLabel;
  TlnNameEdit[wkAbs4]   := Tln4NameEdit;
  TlnVNameLabel[wkAbs4] := Tln4VNameLabel;
  TlnVNameEdit[wkAbs4]  := Tln4VNameEdit;
  AbsLabel[wkAbs4]      := Abs4Label;
  AbsStartEdit[wkAbs4]  := Abs4StZeitEdit;
  AbsZeitEdit[wkAbs4]   := Abs4ZeitEdit;
  AbsGrid[wkAbs4]       := Abs4Grid;
  AbsBtn[wkAbs4]        := Abs4Btn;
  AbsRndEdit[wkAbs4]    := Abs4RndEdit;
  AbsErgEdit[wkAbs4]    := Abs4ErgEdit;
  AbsRngLabel[wkAbs4]           := Abs4RngLabel;
  AbsRngEdit[kwAlle,wkAbs4]     := AlleAbs4RngEdit;
  AbsRngEdit[kwSex,wkAbs4]      := SexAbs4RngEdit;
  AbsRngEdit[kwAltKl,wkAbs4]    := AkAbs4RngEdit;
  AbsRngEdit[kwSondKl,wkAbs4]   := SondAbs4RngEdit;
  AbsRngSWLabel[wkAbs4]         := Abs4RngSWLabel;
  AbsRngSWEdit[kwAlle,wkAbs4]   := AlleAbs4RngSWEdit;
  AbsRngSWEdit[kwSex,wkAbs4]    := SexAbs4RngSWEdit;
  AbsRngSWEdit[kwAltKl,wkAbs4]  := AkAbs4RngSWEdit;
  AbsRngSWEdit[kwSondKl,wkAbs4] := SondAbs4RngSWEdit;

  // Abs5
  TlnNameLabel[wkAbs5]  := Tln5NameLabel;
  TlnNameEdit[wkAbs5]   := Tln5NameEdit;
  TlnVNameLabel[wkAbs5] := Tln5VNameLabel;
  TlnVNameEdit[wkAbs5]  := Tln5VNameEdit;
  AbsLabel[wkAbs5]      := Abs5Label;
  AbsStartEdit[wkAbs5]  := Abs5StZeitEdit;
  AbsZeitEdit[wkAbs5]   := Abs5ZeitEdit;
  AbsGrid[wkAbs5]       := Abs5Grid;
  AbsBtn[wkAbs5]        := Abs5Btn;
  AbsRndEdit[wkAbs5]    := Abs5RndEdit;
  AbsErgEdit[wkAbs5]    := Abs5ErgEdit;
  AbsRngLabel[wkAbs5]           := Abs5RngLabel;
  AbsRngEdit[kwAlle,wkAbs5]     := AlleAbs5RngEdit;
  AbsRngEdit[kwSex,wkAbs5]      := SexAbs5RngEdit;
  AbsRngEdit[kwAltKl,wkAbs5]    := AkAbs5RngEdit;
  AbsRngEdit[kwSondKl,wkAbs5]   := SondAbs5RngEdit;
  AbsRngSWLabel[wkAbs5]         := Abs5RngSWLabel;
  AbsRngSWEdit[kwAlle,wkAbs5]   := AlleAbs5RngSWEdit;
  AbsRngSWEdit[kwSex,wkAbs5]    := SexAbs5RngSWEdit;
  AbsRngSWEdit[kwAltKl,wkAbs5]  := AkAbs5RngSWEdit;
  AbsRngSWEdit[kwSondKl,wkAbs5] := SondAbs5RngSWEdit;

  // Abs6
  TlnNameLabel[wkAbs6]  := Tln6NameLabel;
  TlnNameEdit[wkAbs6]   := Tln6NameEdit;
  TlnVNameLabel[wkAbs6] := Tln6VNameLabel;
  TlnVNameEdit[wkAbs6]  := Tln6VNameEdit;
  AbsLabel[wkAbs6]      := Abs6Label;
  AbsStartEdit[wkAbs6]  := Abs6StZeitEdit;
  AbsZeitEdit[wkAbs6]   := Abs6ZeitEdit;
  AbsGrid[wkAbs6]       := Abs6Grid;
  AbsBtn[wkAbs6]        := Abs6Btn;
  AbsRndEdit[wkAbs6]    := Abs6RndEdit;
  AbsErgEdit[wkAbs6]    := Abs6ErgEdit;
  AbsRngLabel[wkAbs6]           := Abs6RngLabel;
  AbsRngEdit[kwAlle,wkAbs6]     := AlleAbs6RngEdit;
  AbsRngEdit[kwSex,wkAbs6]      := SexAbs6RngEdit;
  AbsRngEdit[kwAltKl,wkAbs6]    := AkAbs6RngEdit;
  AbsRngEdit[kwSondKl,wkAbs6]   := SondAbs6RngEdit;
  AbsRngSWLabel[wkAbs6]         := Abs6RngSWLabel;
  AbsRngSWEdit[kwAlle,wkAbs6]   := AlleAbs6RngSWEdit;
  AbsRngSWEdit[kwSex,wkAbs6]    := SexAbs6RngSWEdit;
  AbsRngSWEdit[kwAltKl,wkAbs6]  := AkAbs6RngSWEdit;
  AbsRngSWEdit[kwSondKl,wkAbs6] := SondAbs6RngSWEdit;

  // Abs7
  TlnNameLabel[wkAbs7]  := Tln7NameLabel;
  TlnNameEdit[wkAbs7]   := Tln7NameEdit;
  TlnVNameLabel[wkAbs7] := Tln7VNameLabel;
  TlnVNameEdit[wkAbs7]  := Tln7VNameEdit;
  AbsLabel[wkAbs7]      := Abs7Label;
  AbsStartEdit[wkAbs7]  := Abs7StZeitEdit;
  AbsZeitEdit[wkAbs7]   := Abs7ZeitEdit;
  AbsBtn[wkAbs7]        := Abs7Btn;
  AbsGrid[wkAbs7]       := Abs7Grid;
  AbsRndEdit[wkAbs7]    := Abs7RndEdit;
  AbsErgEdit[wkAbs7]    := Abs7ErgEdit;
  AbsRngLabel[wkAbs7]           := Abs7RngLabel;
  AbsRngEdit[kwAlle,wkAbs7]     := AlleAbs7RngEdit;
  AbsRngEdit[kwSex,wkAbs7]      := SexAbs7RngEdit;
  AbsRngEdit[kwAltKl,wkAbs7]    := AkAbs7RngEdit;
  AbsRngEdit[kwSondKl,wkAbs7]   := SondAbs7RngEdit;
  AbsRngSWLabel[wkAbs7]         := Abs7RngSWLabel;
  AbsRngSWEdit[kwAlle,wkAbs7]   := AlleAbs7RngSWEdit;
  AbsRngSWEdit[kwSex,wkAbs7]    := SexAbs7RngSWEdit;
  AbsRngSWEdit[kwAltKl,wkAbs7]  := AkAbs7RngSWEdit;
  AbsRngSWEdit[kwSondKl,wkAbs7] := SondAbs7RngSWEdit;

  // Abs8
  TlnNameLabel[wkAbs8]  := Tln8NameLabel;
  TlnNameEdit[wkAbs8]   := Tln8NameEdit;
  TlnVNameLabel[wkAbs8] := Tln8VNameLabel;
  TlnVNameEdit[wkAbs8]  := Tln8VNameEdit;
  AbsLabel[wkAbs8]      := Abs8Label;
  AbsStartEdit[wkAbs8]  := Abs8StZeitEdit;
  AbsZeitEdit[wkAbs8]   := Abs8ZeitEdit;
  AbsBtn[wkAbs8]        := Abs8Btn;
  AbsGrid[wkAbs8]       := Abs8Grid;
  AbsRndEdit[wkAbs8]    := Abs8RndEdit;
  AbsErgEdit[wkAbs8]    := Abs8ErgEdit;
  AbsRngLabel[wkAbs8]           := Abs8RngLabel;
  AbsRngEdit[kwAlle,wkAbs8]     := AlleAbs8RngEdit;
  AbsRngEdit[kwSex,wkAbs8]      := SexAbs8RngEdit;
  AbsRngEdit[kwAltKl,wkAbs8]    := AkAbs8RngEdit;
  AbsRngEdit[kwSondKl,wkAbs8]   := SondAbs8RngEdit;
  AbsRngSWLabel[wkAbs8]         := Abs8RngSWLabel;
  AbsRngSWEdit[kwAlle,wkAbs8]   := AlleAbs8RngSWEdit;
  AbsRngSWEdit[kwSex,wkAbs8]    := SexAbs8RngSWEdit;
  AbsRngSWEdit[kwAltKl,wkAbs8]  := AkAbs8RngSWEdit;
  AbsRngSWEdit[kwSondKl,wkAbs8] := SondAbs8RngSWEdit;

  // Zeitnahme-Arrays
  GutschriftLabel[1] := Gutschrift1Label;
  GutschriftEdit[1]  := Gutschrift1Edit;
  StrafZeitLabel[1]  := StrafZeit1Label;
  StrafZeitEdit[1]   := StrafZeit1Edit;
  EndZeitLabel[1]    := EndZeit1Label;
  EndZeitEdit[1]     := EndZeit1Edit;
  DisqStatusLabel[1] := DisqStatus1Label;
  GutschriftLabel[2] := Gutschrift2Label;
  GutschriftEdit[2]  := Gutschrift2Edit;
  StrafZeitLabel[2]  := StrafZeit2Label;
  StrafZeitEdit[2]   := StrafZeit2Edit;
  EndZeitLabel[2]    := EndZeit2Label;
  EndZeitEdit[2]     := EndZeit2Edit;
  DisqStatusLabel[2] := DisqStatus2Label;

end;

//------------------------------------------------------------------------------
begin
  inherited Create(AOwner);
  if not HelpDateiVerfuegbar then
  begin
    BorderIcons := [biSystemMenu];
    HilfeButton.Enabled := false;
  end;

  Updating       := false;
  DisableButtons := false;
  TlnBuffer      := nil;
  if TlnAktuell = nil then AnMeldungDlg := true
                      else AnMeldungDlg := false;
  if AnmeldungDlg then Caption := 'Neuer Teilnehmer anmelden'
                  else Caption := 'Teilnehmer bearbeiten';
  if Veranstaltung.Serie then
    Caption := Caption + '  -  ' + Veranstaltung.OrtName;

  InitAbsArr;

  SexCB.Items.Clear;
  SexCB.Items.Add(' ');
  SexCB.Items.Add('Männlich');
  SexCB.Items.Add('Weiblich');

  JgEdit.EditText := '9999;0; ';
  JgEdit.UpDown := nil;
  JgUpDown.Min  := 0;
  JgUpDown.Max  := 9999;
  //JgUpDown.Edit := JgEdit;

  RestStreckeEdit.EditMask := '09999;0; ';
  //RestStreckeUpDown.Min := 0;
  //RestStreckeUpDown.Max := 99999; max. 32767 (SmallInt) erlaubt

  with Veranstaltung.WettkColl do
    for i:=0 to Count-1 do WettkCB.Items.Append(Items[i].Name);

  VereinListe := TStringList.Create;
  VereinListe.Sorted := false;
  VereinListe.CaseSensitive := true;
  // VereinListe in FormShow.InitData.InitDialog initialisiert,
  // weil sich die Liste ändern kann bei Änderung von Verein
  with VereinLookupGrid do
  begin
    DefaultColWidth := Width;
    Canvas.Font     := Font;
    Liste           := VereinListe;
    MaxRows         := 20;
    Btn             := VereinLookUpBtn;
    Edit            := VereinLookUpEdit;
    Options         := [goThumbTracking];
    Hide;
  end;
  VereinLookUpEdit.Grid := VereinLookupGrid;
  VereinLookUpBtn.Edit  := VereinLookUpEdit;

  MannschListe := TStringList.Create;
  MannschListe.Sorted := false;
  MannschListe.CaseSensitive := true;
  // MannschListe in FormShow.InitData.InitDialog initialisiert,
  // weil sich die Liste ändern kann bei Änderung von MannschName
  with MannschLookupGrid do
  begin
    DefaultColWidth := Width;
    Canvas.Font     := Font;
    Liste           := MannschListe;
    MaxRows         := 20;
    Btn             := MannschLookUpBtn;
    Edit            := MannschLookUpEdit;
    Options         := [goThumbTracking];
    Hide;
  end;
  MannschLookUpEdit.Grid := MannschLookupGrid;
  MannschLookUpBtn.Edit  := MannschLookUpEdit;

  // Anmeldung

  if SammelMelder=nil then
  begin
    SMldLabel.Enabled := true;
    SMldCB.Enabled := true;
  end else
  begin
    SMldLabel.Enabled := false;
    SMldCB.Enabled := false;
  end;

  with Veranstaltung.SMldColl do
  begin
    // bei Sammelmeldung nur SMld in Liste
    // SMldColl nicht sortieren wegen Konflikt mit SMldDlg
    if SammelMelder=nil then
    begin
      Sortieren(smSMldName,smOhneTlnColl);
      SMldCB.Items.Append(cnKein);
      for i:=0 to SortCount-1 do SMldCB.Items.Append(SMldStr(SortItems[i]))
    end else
      SMldCB.Items.Append(SMldStr(SammelMelder));
  end;
  //Anm_SMldCB.ItemIndex := 0;

  // Einteilung

  SnrEdit.UpDown := nil; // kein UpDown vorhanden
  SGrpNichtEingeteilt := TSGrpObj.Create(Veranstaltung,Veranstaltung.SGrpColl,oaAdd);
  SGrpNichtEingeteilt.Init('',WettkAlleDummy);
  Veranstaltung.SGrpColl.AddItem(SGrpNichtEingeteilt);
  with SGrpGrid do
  begin
    FixedCols := 0;
    FixedRows := 1;
    Canvas.Font := Font;
    DefaultRowHeight := 17; //SgrpGrid.Canvas.TextHeight('Tg')+1;
    TopAbstand := (DefaultRowHeight - Canvas.TextHeight('Tg')) DIV 2; // =2
    ColCount := 5;
    //ColWidths[0] := Canvas.TextWidth(' SGrp-Name ');
    ColWidths[1] := Canvas.TextWidth('  00:00:00.00  ');
    ColWidths[2] := 45;
    ColWidths[3] := 45;
    ColWidths[4] := 45;
    ColWidths[0] := ClientWidth-ColWidths[1]-ColWidths[2]-ColWidths[3]-ColWidths[4]-4;
    Init(Veranstaltung.SGrpColl,smSortiert,ssVertical,nil);
  end;

  with SBhnGrid do
  begin
    FixedCols := 0;
    FixedRows := 1;
    Canvas.Font := Font;
    DefaultRowHeight := 17;  //SBhnGrid.Canvas.TextHeight('Tg')+1;
    ScrollBars := ssNone;
    ColCount := 2;
    ColWidths[0] := 45;
    ColWidths[1] := ClientWidth - ColWidths[0] - 1;
    ScrollBars := ssVertical;
  end;

  with SnrGrid do
  begin
    FixedCols := 0;
    FixedRows := 0;
    Canvas.Font := Font;
    DefaultRowHeight := 17;  //SnrGrid.Canvas.TextHeight('Tg')+1;
  end;

  // SnrBelegtArr Initwert = false
  for i:=0 to Veranstaltung.TlnColl.Count-1 do
    with Veranstaltung.TlnColl[i] do
      if Snr <> 0 then SnrBelegtArr[Snr] := true;

  // Rundenzeiten
  for AbsCnt:=wkAbs1 to wkAbs8 do
  begin
    CreateAbsGrid(AbsCnt);
    AbsRndZeitAltArr[AbsCnt] := TIntegerCollection.Create(Veranstaltung);
  end;

  PageAktuell := nil;
  //TlnPageControl.ActivePage := PageAktuell;
  ControlAktuell := nil;
  NextAnmButton.Left := TlnFirstBtn.Left;
  HelpFensterAlt := HelpFenster;
  HelpFenster := Self;

  if AnmeldungDlg then
  begin
    TlnFirstBtn.Visible := false;
    TlnBackBtn.Visible  := false;
    TlnNextBtn.Visible  := false;
    TlnLastBtn.Visible  := false;
  end else
  begin
    NextAnmButton.Visible := false;
  end;
  SetzeFonts(Font);
  SetzeFonts(Loesch1Label1.Font);
  SetzeFonts(Loesch1Label2.Font);
  SetzeFonts(Loesch2Label1.Font);
  SetzeFonts(Loesch2Label2.Font);

end;

//==============================================================================
destructor TTlnDialog.Destroy;
//==============================================================================
var AbsCnt : TWkAbschnitt;
begin
  Veranstaltung.SGrpColl.ClearItem(SGrpNichtEingeteilt);
  for AbsCnt:=wkAbs1 to wkAbs8 do
    AbsRndZeitAltArr[AbsCnt].Free;
  TlnBuffer.Free;
  VereinListe.Free;
  MannschListe.Free;

  HelpFenster := HelpFensterAlt;
  inherited Destroy;
end;


// protected Methoden

//------------------------------------------------------------------------------
procedure TTlnDialog.InitTlnBuffer(Tln:TTlnObj);
//------------------------------------------------------------------------------
var i : Integer;
    AbsCnt : TWkAbschnitt;
begin
  if TlnBuffer <> nil then
  with TlnBuffer do
  begin
    if Tln = nil then
    begin
      LoadPtr := TlnBuffer;
      case DefaultSex of // cnMixed nur für TlnStaffel, nie als Default
        cnMaennlich :  Sex := cnMaennlich;
        cnWeiblich:    Sex := cnWeiblich;
        else           Sex := cnKeinSex;
      end;
      SMld           := SammelMelder;
      Wettk          := WettkAktuell;
      Startgeld      := Wettk.Startgeld; // Wettk-Startgeld voreinstellen
      DisqGrund      := '';
      DisqName       := '';
      SGrpNichtEingeteilt.Wettkampf := Wettk;
      Veranstaltung.SGrpColl.Sortieren(Veranstaltung.OrtIndex,Wettk);
      {// wenn nur 1 SGrp für Wettk definiert dann diese voreinstellen,
      // sonst nil
      if Veranstaltung.SGrpColl.SortCount = 2 then
        SGrp := Veranstaltung.SGrpColl.SortItems[1]
      else SGrp := nil;}
      SGrp := nil;
      if SammelMelder <> nil then
      begin
        VereinPtr      := SammelMelder.MannschNamePtr;
        MannschNamePtr := SammelMelder.MannschNamePtr;
      end else
      begin
        VereinPtr      := nil;
        MannschNamePtr := nil;
      end;
      //MannschNamePtr := MschNamePtrAktuell;
      //Land           := LandAktuell;
    end else
    begin
      LoadPtr := Tln; // für berechnen der Startzeit erforderlich
      CopyAllgemeinDaten(Tln);
      CopyErgebnisDaten(Tln); // alle Zeiten übernommen
      CopyRngDaten(Tln);
    end;

    // Anfangswerte von TlnBuffer festhalten für TlnGeaendert, weil diese Werte
    // bei jeder Änderung im Dialog sofort in TlnBuffer übernommen werden
    //StrtZeitAlt := StrtZeit(wkAbs1);
    for AbsCnt:=wkAbs1 to wkAbs8 do
    begin
      AbsRndZeitAltArr[AbsCnt].Clear;
      with GetZeitRecColl(AbsCnt) do
        for i:=0 to Count-1 do // alle Items, inkl. Startzeit übernehmen
          AbsRndZeitAltArr[AbsCnt].Add(Items[i].AufrundZeit);
    end;
    GutschriftAlt  := Gutschrift;
    StrafZeitAlt   := StrafZeit;
    ReststreckeAlt := Reststrecke;
    SexAlt         := Sex;
    JgAlt          := Jg;
    WettkAlt       := Wettk;
    SGrpAlt        := SGrp;
    SBhnAlt        := SBhn;
    SnrAlt         := Snr;
    RfidAlt        := RfidCode;
  end;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.InitData;
//------------------------------------------------------------------------------
// wird nicht in Create aufgerufen, sondern in FormCreate
// und wenn Ok gedruckt wird bei Anmeldung oder Bearbeiten
// aktuelle Daten für Dlg werden in TlnBuffer zwischengespeichert und erst am
// Schluss in TlnAktuell und TlnColl übernommen

begin
  Updating := true;
  KeinSexAkzeptiert     := false;
  KeinJgAkzeptiert      := false;
  AkAkzeptiert          := false;
  SnrAkzeptiert         := false;
  SBhnNullAkzeptiert    := false;
  KeinStaffelAkzeptiert := false;
  SGrpVoreinstellen     := true;  // löschen wenn Voreinstellung rückgängig gemacht
  SGrpVoreingestellt    := false; // erst beim Selekt EinteilungTS voreinstellen
  SnrVoreingestellt     := false; // erst beim Selekt EinteilungTS voreinstellen
  TlnBuffer.Free;
  TlnBuffer := TTlnObj.Create(Veranstaltung,Veranstaltung.TlnColl,oaAdd);
  with TlnBuffer do
  begin
    if AnMeldungDlg then
    // Neuer Teilnehmer Anmelden
    begin
      TlnNeu := true; // wird in TlnAendern zurückgesetzt
      HauptFenster.LstFrame.TriaGrid.ItemIndex := 0; // immer Anfang der Liste fokussieren
      HauptFenster.FocusedTln := HauptFenster.LstFrame.TriaGrid.FocusedItem;
      InitTlnBuffer(nil);
      ControlAktuell := nil; // immer NameEdit selektieren
    end else
    // Teilnehmer bearbeiten
    begin
      TlnNeu := false;
      InitTlnBuffer(TlnAktuell);
    end;
  end;
  InitDialog;
  Updating := false;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.InitDialog;
//------------------------------------------------------------------------------
begin
  Updating := true;
  with TlnBuffer do
  begin
    // Dialog Initialisieren
    NameEdit.Text := Trim(Name);
    VNameEdit.Text := Trim(VName);
    if (Wettk<>nil) and (Wettk<>WettkAlleDummy) then
      WettkCB.ItemIndex := Veranstaltung.WettkColl.IndexOf(Wettk);

    UpdateSex(nil); // nach Wettk
    if Jg=0 then JgEdit.Text := ''
            else JgEdit.Text := IntToStr(Jg);
    UpdateJg(nil);
    UpdateKlasse;

    //UpdateVereinLabel;
    VereinListe.Clear; // Clear, damit Liste unsichtbar bleibt
    VereinLookUpEdit.Text := Verein;
    UpdateVereinliste;
    UpdateMannschLabel;
    MannschListe.Clear; // Clear, damit Liste unsichtbar bleibt
    MannschLookUpEdit.Text := MannschName;
    UpdateMannschliste;

    // Init AnmeldungTS
    if SammelMelder = nil then
      if SMld=nil then SMldCB.ItemIndex := 0
      else SMldCB.ItemIndex:=Veranstaltung.SMldColl.SortIndexOf(SMld)+1
    else SMldCB.ItemIndex := 0;
    UpdateAdresse;
    UpdateTlnTxt;
    StartgeldEdit.Text := IntToStr(Startgeld); // Wettk-Startgeld in TlnBuffer voreingestellt
    MldZeitEdit.Text   := UhrZeitStrODec(MldZeit);    // keine Zehntel
    UpdateRfidCode;
    KommentEdit.Text   := Komment;

    // Init OptionenTS
    AusKonkAllgCB.Checked := AusKonkAllg;
    UpdateAusKonk;
    UpdateSerWrtg;
    UpdateSondWrtg;
    UpdateMschWrtg;
    UpdateMixWrtg;
    UrkDruckCB.Checked := UrkDruck;

    // Init StaffelTS
    UpdateStaffelTln;

    // Init EinteilungTS
    UpdateSGrpListe;
    UpdateSBhnListe;
    UpdateSnrListe;
    UpdateSnr;

    // Init ZeitnahmeTS
    // Uhrzeiten werden von TlnBuffer abgeleitet und in ...ZeitAlt festgehalten
    // UhrZeiten werden in UpdateZeiten bei jeder Änderung in TlnBuffer geändert
    // um abgeleitete Zeiten zu berechnen
    InitZeitnahmeTS;
    // Init StrafenTS - Gutschrift
    ZeitGutschrEdit.InitEditMask;
    UpdateZeitGutschrift;
    // Init StrafenTS - Strafzeit
    ZeitStrafeEdit.InitEditMask;
    if StrafZeit < 0 then ZeitStrafeCB.Checked := false
                     else ZeitStrafeCB.Checked := true; // OnClick Event
    UpdateZeitStrafe;
    // Init StrafenTS - Disqualifikation
    if TlnInStatus(stDisqualifiziert) then DisqCheckBox.Checked := true
                                      else DisqCheckBox.Checked := false;
    UpdateDisqGrund;
    UpdateReststrecke;
    UpdateZeiten; // nach InitZeitnahmeTS und InitStrafenTS (Gutschrift,Strafzeit)
    InitWertgTS;
    InitSondWertgTS;
    InitSerWertgTS;
    UpdatePageControl;
  end;

  if (PageAktuell=nil) or not PageAktuell.TabVisible then
    if (TlnPageBuf >= 0) and (TlnPageBuf < TlnPageControl.PageCount) and
       TlnPageControl.Pages[TlnPageBuf].TabVisible then
      SetPage(TlnPageControl.Pages[TlnPageBuf]) // TlnPageBuf bei Close gesetzt
    else
      SetPage(AnmeldungTS)
  else SetPage(PageAktuell);

  if (ControlAktuell <> nil) and ControlAktuell.TabStop then
    if ControlAktuell.CanFocus then ControlAktuell.SetFocus
    else
      if NameEdit.CanFocus then NameEdit.SetFocus
      else
  else if NameEdit.CanFocus then NameEdit.SetFocus;
  ControlAktuell := ActiveControl;

  SetButtons;
  Updating := false;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateSex(Sender: TObject);
//------------------------------------------------------------------------------
// WettkCB vorher gesetzt, nach WettkCB.Change
var UpdatingAlt: Boolean;
begin
  if GetWettk = nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;

  with TlnBuffer do
  begin
    Wettk := GetWettk;

    if Sender = SexCB then // Geschlecht Updaten
      Sex := GetSex
    else // SexCB setzen
    begin
      if (Wettk.WettkArt=waTlnStaffel)or(Wettk.WettkArt=waTlnTeam) then
        if SexCB.Items.Count = 3 then SexCB.Items.Add('Mixed')
        else
      else
        if SexCB.Items.Count = 4 then SexCB.Items.Delete(3);

      case Sex of
        cnMaennlich : SexCB.ItemIndex := 1;
        cnWeiblich  : SexCB.ItemIndex := 2;
        cnMixed     : if (Wettk.WettkArt=waTlnStaffel)or(Wettk.WettkArt=waTlnTeam) then
                        SexCB.ItemIndex := 3
                      else SexCB.ItemIndex := 0;
        else SexCB.ItemIndex := 0; //cnKeinSex
      end;
    end;
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateJg(Sender: TObject);
//------------------------------------------------------------------------------
// setzt TlnBuffer.Jg und UpDown Limits
var UpdatingAlt: Boolean;
begin
  UpdatingAlt := Updating;
  if GetWettk <> nil then
  begin
    Updating := true;
    // TlnBuffer.Jg nur setzen wenn JgEdit geändert wurde, weil
    // JgEdit:='' bei TlnStaffel
    if Sender = JgEdit then
      TlnBuffer.Jg := GetJg //Alter in UpdateKlasse aktualisiert
    else // (Sender=WettkCB) Text während JgEdit-Change nicht ändern
      if TlnBuffer.Jg=0 then JgEdit.Text := ''
                        else JgEdit.Text := IntToStr(TlnBuffer.Jg);
    JgUpDown.Position := TlnBuffer.Jg;
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateKlasse;
//------------------------------------------------------------------------------
// TlnBuffer.Wettk(in UpdateSex),Sx,Jg vorher gesetzt
var UpdatingAlt : Boolean;
begin
  if GetWettk = nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;

  with TlnBuffer do
  begin
    // Alter updaten
    AlterLabel.Enabled := true;
    AlterEdit.Enabled := true;
    if GetAlter > 0 then AlterEdit.Text := ' '+Strng(GetAlter,2)
                    else AlterEdit.Text := '   ';
    // Altersklassen
    if (Sex = cnMaennlich)and (Wettk.AltMKlasseColl[tmTln].Count > 0) or
       (Sex = cnWeiblich) and (Wettk.AltWKlasseColl[tmTln].Count > 0) then
    begin
      AkLabel.Enabled := true;
      AkEdit.Enabled  := true;
      if WertungsKlasse(kwAltKl,tmTln).Wertung = kwKein then
        AkEdit.Text := '<kein>'
      else AkEdit.Text := WertungsKlasse(kwAltKl,tmTln).Name;
    end else
    begin
      AkLabel.Enabled := false;
      AkEdit.Enabled  := false;
      AkEdit.Text     := '';
    end;
    // Sonderklassen
    if (Sex = cnMaennlich)and (Wettk.SondMKlasseColl.Count > 0) or
       (Sex = cnWeiblich) and (Wettk.SondWKlasseColl.Count > 0) then
    begin
      SondAkLabel.Enabled := true;
      SondAkEdit.Enabled  := true;
      if WertungsKlasse(kwSondKl,tmTln).Wertung = kwKein then
        SondAkEdit.Text := '<kein>'
      else SondAkEdit.Text := WertungsKlasse(kwSondKl,tmTln).Name;
    end else
    begin
      SondAkLabel.Enabled := false;
      SondAkEdit.Enabled  := false;
      SondAkEdit.Text     := '';
    end;

  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateMannschLabel;
//------------------------------------------------------------------------------
begin
  {if GetWettk <> nil then
    VereinLabel.Caption := Veranstaltung.TlnMschSpalteUeberschrift(GetWettk)
  else
    VereinLabel.Caption := Veranstaltung.TlnMschSpalteUeberschrift(WettkAlleDummy);}
  if (GetWettk <> nil) and (GetWettk.MschWrtgMode = wmSchultour) then
    MannschLabel.Caption := 'Schulklasse'
  else
    MannschLabel.Caption := 'Mannschaft';
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateAdresse;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
begin
  UpdatingAlt := Updating;
  Updating := true;
  if GetSMld=nil then
  begin
    StrasseLabel.Enabled := true;
    StrasseEdit.Enabled  := true;
    HausNrLabel.Enabled  := true;
    HausNrEdit.Enabled   := true;
    PLZLabel.Enabled     := true;
    PLZEdit.Enabled      := true;
    OrtLabel.Enabled     := true;
    OrtEdit.Enabled      := true;
    EMailLabel.Enabled   := true;
    EMailEdit.Enabled    := true;
  end else
  begin
    StrasseLabel.Enabled := false;
    StrasseEdit.Enabled  := false;
    HausNrLabel.Enabled  := false;
    HausNREdit.Enabled   := false;
    PLZLabel.Enabled     := false;
    PLZEdit.Enabled      := false;
    OrtLabel.Enabled     := false;
    OrtEdit.Enabled      := false;
    EMailLabel.Enabled   := false;
    EMailEdit.Enabled    := false;
  end;

  StrasseEdit.Text     := TlnBuffer.Strasse;
  HausNrEdit.Text      := TlnBuffer.HausNr;
  PLZEdit.Text         := TlnBuffer.PLZ;
  OrtEdit.Text         := TlnBuffer.Ort;
  EMailEdit.Text       := TlnBuffer.EMail;

  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateRfidCode;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
begin
  UpdatingAlt := Updating;
  Updating := true;

  if RfidModus then
  begin
    if RfidHex then
      RfidCodeLabel.Caption := 'RFID-Code ('+IntToStr(RfidZeichen)+' Hex-Zeichen)'
    else
      RfidCodeLabel.Caption := 'RFID-Code ('+IntToStr(RfidZeichen)+' Zeichen)';
    RfidCodeLabel.Enabled := true;
    RfidCodeEdit.Text := TlnBuffer.RfidCode;
    RfidCodeEdit.Enabled := true;
  end else
  begin
    RfidCodeLabel.Enabled := false;
    RfidCodeLabel.Caption := 'RFID-Code';
    RfidCodeEdit.Enabled := false;
    RfidCodeEdit.Text := '';
  end;

  Updating := UpdatingAlt;
end;



//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateStaffelTln;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
    AbsCnt : TWkAbschnitt;
    MaxCnt : Integer;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;

  if GetWettk.WettkArt = waTlnStaffel then
  begin
    Text1Label.Caption := 'Ein Staffel-Teilnehmer pro';
    Text2Label.Caption := 'Wettkampf-Abschnittt';
  end else
  begin
    Text1Label.Caption := 'Bis zu '+IntToStr(GetWettk.MschGroesse[GetSex])+ ' Teilnehmer pro Team';
    Text2Label.Caption := '';
  end;

  // setze default für 1 Abschn.
  for AbsCnt:=wkAbs1 to wkAbs8 do
    if AbsCnt=wkAbs1 then
    begin
      TlnNameEdit[AbsCnt].Text  := Trim(NameEdit.Text);
      TlnVNameEdit[AbsCnt].Text := Trim(VNameEdit.Text);
    end else
    begin
      TlnNameLabel[AbsCnt].Enabled  := false;
      TlnNameEdit[AbsCnt].Enabled   := false;
      TlnNameEdit[AbsCnt].Text      := '';
      TlnVNameLabel[AbsCnt].Enabled := false;
      TlnVNameEdit[AbsCnt].Enabled  := false;
      TlnVNameEdit[AbsCnt].Text     := '';
    end;

  MaxCnt := 0;
  if GetWettk.WettkArt = waTlnStaffel then
    MaxCnt := GetWettk.AbschnZahl
  else
  if GetWettk.WettkArt = waTlnTeam then
    MaxCnt := GetWettk.MschGroesse[GetSex];
  if MaxCnt > 0 then
    for AbsCnt:=wkAbs2 to wkAbs8 do
      if MaxCnt >= Integer(AbsCnt) then
      begin
        TlnNameLabel[AbsCnt].Enabled  := true;
        TlnNameEdit[AbsCnt].Enabled   := true;
        TlnNameEdit[AbsCnt].Text      := Trim(TlnBuffer.StaffelName[AbsCnt]);
        TlnVNameLabel[AbsCnt].Enabled := true;
        TlnVNameEdit[AbsCnt].Enabled  := true;
        TlnVNameEdit[AbsCnt].Text     := Trim(TlnBuffer.StaffelVName[AbsCnt]);
      end;

  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateMixWrtg;
//------------------------------------------------------------------------------
// nach UpdateMschWrtg
var UpdatingAlt : Boolean;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;

  if MschWrtgCB.Checked then
  begin
    MixMschCB.Enabled := true;
    MixMschCB.Checked := TlnBuffer.MschMixWrtg
  end else
  begin
    MixMschCB.Enabled := false;
    MixMschCB.Checked := false;
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateMschWrtg;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;
  if (GetWettk.MschWertg = mwKein) or (GetMannschName = '') or
     (Veranstaltung.Serie and not SerWrtgCB.Checked) then
  begin
    MschWrtgCB.Enabled := false;
    MschWrtgCB.Checked := false;
  end else
  begin
    if not MschWrtgCB.Enabled then // MschWrtgCB setzen wenn vorher disabled
      MschWrtgCB.Checked := true
    else
      MschWrtgCB.Checked := TlnBuffer.MschWrtg;
    MschWrtgCB.Enabled := true;
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateVereinListe;
//------------------------------------------------------------------------------
var i : Integer;
begin
  Vereinliste.Clear;
  //VereinListe.Add(''); // keine Mannschaft am Anfang der Liste
  with Veranstaltung.VereinColl do
    for i:=0 to SortCount-1 do
      VereinListe.Add(SortItems[i]^);
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateMannschListe;
//------------------------------------------------------------------------------
var i : Integer;
begin
  Mannschliste.Clear;
  //VereinListe.Add(''); // keine Mannschaft am Anfang der Liste
  with Veranstaltung.MannschNameColl do
    for i:=0 to SortCount-1 do
      MannschListe.Add(SortItems[i]^);
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateSondWrtg;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;
  if not GetWettk.SondWrtg {or AusserKonkAllgCB.Checked} then
  begin
    SondWrtgCB.Enabled := false;
    SondWrtgCB.Checked := false;
  end else
  begin
    SondWrtgCB.Enabled := true;
    SondWrtgCB.Checked := TlnBuffer.SondWrtg;
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateSerWrtg;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
begin
  UpdatingAlt := Updating;
  Updating := true;
  if Veranstaltung.Serie then
  begin
    SerWrtgCB.Enabled := true;
    SerWrtgCB.Checked := TlnBuffer.SerienWrtg;
  end else
  begin
    SerWrtgCB.Enabled := false;
    SerWrtgCB.Checked := false;
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateAusKonk;
//------------------------------------------------------------------------------
// AusKonkCB vorher gesetzt
begin
  if GetWettk=nil then Exit;
  if AusKonkAllgCB.Checked then
  begin
    AusKonkAltKlCB.Enabled  := false;
    AusKonkAltKlCB.Checked  := true;
    AusKonkSondKlCB.Enabled := false;
    AusKonkSondKlCB.Checked := true;
  end else
  begin
    AusKonkAltKlCB.Enabled  := true;
    AusKonkAltKlCB.Checked  := TlnBuffer.AusKonkAltKl;
    AusKonkSondKlCB.Enabled := true;
    AusKonkSondKlCB.Checked := TlnBuffer.AusKonkSondKl;
  end;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateTlnTxt;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;
  if TlnBuffer.Wettk.TlnTxt = '' then
  begin
    LandLabel.Caption := 'Land';
    LandEdit.Text     := '';
    LandEdit.Enabled  := false;
    LandLabel.Enabled := false;
  end else
  begin
    LandLabel.Caption := TlnBuffer.Wettk.TlnTxt;
    LandEdit.Text     := TlnBuffer.Land;
    LandEdit.Enabled  := true;
    LandLabel.Enabled := true;
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateStartgeld;
//------------------------------------------------------------------------------
// bei Wettk-Wechsel
var UpdatingAlt : Boolean;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;
  // wenn alter Wert unverändert, dann Wettk-Startgeld erneut voreinstellen
  if AnmeldungDlg and
     (StrToIntDef(StartgeldEdit.Text,0) = TlnBuffer.Wettk.Startgeld) then
    StartgeldEdit.Text := IntToStr(GetWettk.Startgeld);
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateSGrpListe;
//------------------------------------------------------------------------------
var i  : Integer;
    Wk : TWettkObj;
    UpdatingAlt : Boolean;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;
  Wk := GetWettk;
  SGrpNichtEingeteilt.Wettkampf := Wk;
  Veranstaltung.SGrpColl.Sortieren(Veranstaltung.OrtIndex,Wk);
  SGrpGrid.CollectionUpdate;
  SGrpGrid.Refresh;
  SGrpCount[0] := Veranstaltung.TlnColl.SGrpTlnZahl(nil); //SGrpNichtEingeteilt
  //for i:=1 to cnSGrpMax do SGrpCount[i] := 0; // automatisch = 0
  for i:=1 to SGrpGrid.ItemCount-1 do
    SGrpCount[i] := Veranstaltung.TlnColl.SGrpTlnZahl(TSGrpObj(SGrpGrid[i]));
  SGrpGrid.Refresh;
  // wenn SGrp vorhanden, diese einstellen
  if (TlnBuffer.SGrp <> nil) and (SGrpGrid.Collection <> nil) and
     (SGrpGrid.Collection.SortIndexOf(TlnBuffer.SGrp) >= 0) then
    SGrpGrid.FocusedItem := TlnBuffer.SGrp
  else // wenn Snr vorhanden, passende SGrp einstellen
  if (TlnBuffer.Snr > 0) and (SGrpGrid.Collection <> nil) and
     (Veranstaltung.SGrpColl.SGrpMitSnr(Wk,TlnBuffer.Snr) <> nil) and
     (SGrpGrid.Collection.SortIndexOf(Veranstaltung.SGrpColl.SGrpMitSnr(Wk,TlnBuffer.Snr)) >= 0) then
    SGrpGrid.FocusedItem := Veranstaltung.SGrpColl.SGrpMitSnr(Wk,TlnBuffer.Snr)
  else //wenn nur 1 SGrp vorhanden, wird diese 1x voreingestellt wenn EinteilungTS selektiert
  if SGrpVoreinstellen and (SGrpGrid.ItemCount = 2) and
    (SGrpVoreingestellt or (PageAktuell = EinteilungTS)) then
    // erst beim Einteilen einstellen, damit TlnGeAendert zunächst false bleibt
  begin
    SGrpVoreingestellt := true;
    SGrpGrid.ItemIndex := 1;
    SetButtons; // SGrp geändert
  end
  else SGrpGrid.ItemIndex := 0;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateSBhnListe;
//------------------------------------------------------------------------------
var i     : Integer;
    StGrp : TSGrpObj;
    UpdatingAlt : Boolean;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;
  StGrp := GetSGrp;
  with SBhnGrid do
  begin
    //DefaultDrawing := true;
    if (StGrp<>nil) and (GetWettk.StartBahnen > 0) then
    begin
      Font.Color := clWindowText;
      RowCount := GetWettk.StartBahnen + 2;
      Cells[0,0] := 'Bahn';
      Cells[1,0] := 'Teiln.';
      Cells[0,1] := cnKein;
      Cells[1,1] := ' '+Strng(Veranstaltung.TlnColl.SBhnTlnZahl(StGrp,0),4);
      for i:=2 to RowCount-1 do
      begin
        Cells[0,i] := ' '+Strng(i-1,2);
        Cells[1,i] := ' '+Strng(Veranstaltung.TlnColl.SBhnTlnZahl(StGrp,i-1),4);
      end;
      Row := TlnBuffer.SBhn + 1;
      SBhnLabel.Enabled := true;
      Enabled := true;
    end else
    begin
      Font.Color := clGrayText;
      RowCount := 2;
      Cells[0,0] := 'Bahn'; // nach RowCount-Änderung, weil dabei gelöscht wird
      Cells[1,0] := 'Teiln.';
      Cells[0,1] := '';
      Cells[1,1] := '';
      Row := 1;
      //DefaultDrawing := false; geht hier nicht, weil dann auch header blank wird
      //RowCount := 2;
      SBhnLabel.Enabled := false;
      Enabled := false;
    end;
    Refresh;
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateSnrListe;
//------------------------------------------------------------------------------
// aufgerufen von: InitDialog, WettkCBChange, SGrpGridChange
// keine SGrp selektiert: Snr := '',
// bei neu-Einteilung (SnrAlt=0): immer erste freie Snr voreinstellen
// nur freie Snr aus SGrp in Liste

var UpdatingAlt : Boolean;
    StGrp : TSGrpObj;
    i,Cnt : Integer;

begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;
  StGrp := GetSGrp;
  with SnrGrid do
  begin
    DefaultDrawing := true;
    if StGrp <> nil then
    begin
      Font.Color := clWindowText;
      Enabled := true;
      Screen.Cursor := crHourGlass;    { Cursor als Sanduhr }
      // Liste Clearen
      RowCount := cnTlnMax; // vorläufiger Wert, wird nachher korrigiert
      Cells[0,0] := cnKein; // Row 0
      Row := 0;
      UpdateSnr;
      TlnDialog.Refresh;
      SnrGrid.Refresh;
      Cnt := 0;
      // neue Liste
      for i:=Max(1,StGrp.StartnrVon) to StGrp.StartnrBis do
      begin
        if not SnrBelegtArr[i] or (i = TlnBuffer.Snr) then
        begin
          Inc(Cnt);
          Cells[0,Cnt] := ' ' + Strng(i,4);
          if i = TlnBuffer.Snr then Row := Cnt; //Focus nur wenn in SGrp-Bereich
        end;
      end;
      RowCount := Cnt+1; // RowCount nicht in Schleife ändern, weil zu langsam
      // Snr voreinstellen, wenn Neu-Einteilung (SnrAlt=0) und
      // TlnBuffer.Snr nicht in SGrp-Bereich (Row=0)
      if (SnrAlt=0) and (RowCount>1) and (Row=0) and
         (SnrVoreingestellt or (PageAktuell = EinteilungTS)) then
      begin
        SnrVoreingestellt := true;
        Row := 1;
      end;
      Screen.Cursor := CursorAlt;    { Alter Cursor wieder herstellen }
    end else
    begin
      Font.Color := clGrayText;
      RowCount := 2;
      Row := 1;  // Focus ausserhalb, wird bei RowCount=1 nicht dargestellt
      Cells[0,0] := '';
      Refresh;
      DefaultDrawing := false;
      RowCount := 1;
      Enabled := false;
    end;
    Refresh;
  end;
  Updating := UpdatingAlt;

end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateSnr;
//------------------------------------------------------------------------------
// aufgerufen von: InitDialog, WettkCBChange, SGrpGridChange, SnrGridChange
// keine SGrp selektiert: Snr := '',

var UpdatingAlt : Boolean;
    StGrp : TSGrpObj;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;
  StGrp := GetSGrp;
  if StGrp <> nil then
  begin
    SnrLabel.Enabled := true;
    SnrEdit.Enabled := true;
    with SnrGrid do
      if Row > 0 then SnrEdit.Text := Trim(Cells[0,Row])
      else // Row=0, keine Snr
      if SnrAlt <> 0 then // Text auch wenn ausserhalb StNr-Bereich
        SnrEdit.Text := IntToStr(SnrAlt)
      else SnrEdit.Text := ''; // nach Enable
  end else
  begin
    SnrLabel.Enabled := false;
    SnrEdit.Enabled := false;
    SnrEdit.Text := '';
  end;
  SetButtons; // Snr geändert
  // if SnrEdit.CanFocus then SnrEdit.SetFocus;  // Focus nicht ändern, Problem in SetPage
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateZeiten;
//------------------------------------------------------------------------------
// TlnBuffer updaten um abgeleitete Zeiten neu zu berechnen: Start- und ErgebnisZeiten
var UpdatingAlt : Boolean;
    L,Rnd : integer;
    AbsCnt : TWkAbschnitt;
    TSIndx : Integer;
    AbsMax : TWkAbschnitt;

//..............................................................................
procedure UpdateAbsGrid(Abs:TWkAbschnitt);
var Buff,MaxVisibleRowCount : Integer;

//..............................................................................
function ExtraLeerZeile: Integer;
begin
  with TlnBuffer.GetZeitRecColl(Abs) do
    if (SortCount>1) and (PZeitRec(SortList.Last)^.AufrundZeit < 0) then
      Result := 1
    else Result := 0; // auch wenn nur 1 Leerzeile
end;

//..............................................................................
begin
  with AbsGrid[Abs] do
  begin
    // geänderte Zeit in TlnBuffer übernehmen, wenn gültig
    if AbsZeitEdit[Abs].Validate(AbsZeitEdit[Abs].EditText,Buff) and
       (AbsZeitEdit[Abs].Wert <> TlnBuffer.AbsRundeStoppZeit(Abs,ItemIndex+1)) then
    with TZeitRecColl(Collection) do
    begin
      Buff := IndexOf(PSortItems[ItemIndex]);
      if AbsZeitEdit[Abs].Wert >= 0 then
        ItemIndex := SetzeZeitRec(Buff,-1,AbsZeitEdit[Abs].Wert) // Runden werden neu sortiert
      else
      begin
        SetzeZeitRec(Buff,-1,-1); //löschen, ItemIndex unverändert
        ItemIndex := Max(0,ItemIndex-1);    //exception beim letzten löschen
        AbsZeitEdit[Abs].Text := UhrZeitStr(PZeitRec(FocusedItem).AufrundZeit);
      end;
      CollectionUpdate;
      MaxVisibleRowCount := Min(6,RowCount);
      ClientHeight := DefaultRowHeight * MaxVisibleRowCount + RowCount {- 1 reserve};
      if Row < TopRow then TopRow := Row
      else
      if Row > TopRow + MaxVisibleRowCount - 2 - ExtraLeerZeile then
        TopRow := Max(1,Row - MaxVisibleRowCount + 2 + ExtraLeerZeile);
    end;

    if Visible then Refresh;
    //Edit bei geänderter Sortierung anpassen
    if (not Visible) and (FocusedItem <> nil) and (ItemCount > 1) then
      AbsZeitEdit[Abs].Text := UhrZeitStr(PZeitRec(FocusedItem).AufrundZeit);
  end;
end;

//------------------------------------------------------------------------------
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;

  with TlnBuffer do
  begin
    // relevante Werte von anderen Tabsheets in TlnBuffer übernehmen
    SGrp      := GetSGrp; // Impact auf Startzeit
    if SBhnGrid.Enabled then
      SBhn := GetSBhn;
    if SnrEdit.Enabled then // Snr bleibt unverändert, wenn SGrp gelöscht wird
      Snr  := StrToIntDef(SnrEdit.Text,0);
    Gutschrift  := ZeitGutschrEdit.Wert;
    StrafZeit   := ZeitStrafeEdit.Wert;
    Reststrecke := StrToIntDef(ReststreckeEdit.Text,0);

    case ZeitFormat of
      zfSek     : L := 8;
      zfZehntel : L := 10;
      else        L := 11; //zfHundertstel
    end;

    //if ZeitNahme2TS.Visible then // 5..8 Abschn.
    if GetWettk.AbschnZahl > 4 then // PageControl noch nicht gesetzt
    begin
      TSIndx := 2;
      AbsMax := wkAbs8;
    end else // 1..4 Abschn.
    begin
      TSIndx := 1;
      AbsMax := wkAbs4;
    end;

    for AbsCnt:=wkAbs1 to AbsMax do
      if GetWettk.AbschnZahl >= Integer(AbsCnt) then
      begin
        if AbsCnt = wkAbs1 then
          if Abs1StZeitEdit.Enabled and // stOhnePause
             Abs1StZeitEdit.Validate(Abs1StZeitEdit.EditText,L) and
             (Abs1StZeitEdit.Wert <> TlnBuffer.StrtZeit(wkAbs1)) then
            SetZeitRec(wkAbs1,0,-1,Abs1StZeitEdit.Wert)
          else
        else
        begin
          InitStrtZeit(AbsCnt);
          AbsStartEdit[AbsCnt].Text := UhrZeitStr(StrtZeit(AbsCnt));
        end;
        UpdateAbsGrid(AbsCnt);
        Rnd := RundenZahl(AbsCnt);
        if Rnd > 0 then // AbsZeit nur wenn Runden vollständig, ausgen. RundenWettk
        begin
          AbsRndEdit[AbsCnt].Text := IntToStr(RundenZahl(AbsCnt));
          if GetWettk.RundenWettk then
            AbsErgEdit[AbsCnt].Text := Format('%'+IntToStr(L)+'s',[EffZeitStr(AbsRundenZeit(AbsCnt,Rnd))])
          else
            AbsErgEdit[AbsCnt].Text := Format('%'+IntToStr(L)+'s',[EffZeitStr(AbsZeit(AbsCnt))]);
        end else
        begin
          AbsRndEdit[AbsCnt].Text := '-';
          AbsErgEdit[AbsCnt].Text := Format('%'+IntToStr(L)+'s',[EffZeitStr(0)]);
        end;
      end;

    if TSIndx=1 then
    begin
      Gutschrift1Label.Visible := true;
      Gutschrift1Edit.Visible  := true;
      StrafZeit1Label.Visible  := true;
      StrafZeit1Edit.Visible   := true;
      EndZeit1Label.Visible    := true;
      EndZeit1Edit.Visible     := true;
      //DisqStatus1Label.Visible := true;  vorher in UpdateDisqGrund gesetzt
    end else
    begin
      Gutschrift1Label.Visible := false;
      Gutschrift1Edit.Visible  := false;
      StrafZeit1Label.Visible  := false;
      StrafZeit1Edit.Visible   := false;
      EndZeit1Label.Visible    := false;
      EndZeit1Edit.Visible     := false;
      DisqStatus1Label.Visible := false;
    end;

    if Gutschrift <= 0 then
    begin
      GutschriftEdit[TSIndx].Text := '';
      GutschriftLabel[TSIndx].Enabled := false;
    end else
    begin
      GutschriftEdit[TSIndx].Text := Format('%'+IntToStr(L)+'s',[EffZeitStr(Gutschrift)]);
      GutschriftLabel[TSIndx].Enabled := true;
    end;
    if StrafZeit < 0 then
    begin
      StrafZeitEdit[TSIndx].Text := '';
      StrafZeitLabel[TSIndx].Enabled := false;
    end else
    if StrafZeit = 0 then // '0' anzeigen statt '-' mit EffZeitStr
    begin
      case ZeitFormat of
        zfSek         : StrafZeitEdit[TSIndx].Text := Format('%'+IntToStr(L)+'s',['0']);
        zfZehntel     : StrafZeitEdit[TSIndx].Text := Format('%'+IntToStr(L)+'s',['0'+DecTrennZeichen+'0']);
        zfHundertstel : StrafZeitEdit[TSIndx].Text := Format('%'+IntToStr(L)+'s',['0'+DecTrennZeichen+'00']);
      end;
      StrafZeit1Label.Enabled := true;
    end else
    begin
      StrafZeitEdit[TSIndx].Text := Format('%'+IntToStr(L)+'s',[EffZeitStr(StrafZeit)]);
      StrafZeitLabel[TSIndx].Enabled := true;
    end;

    EndZeitEdit[TSIndx].Text := Format('%'+IntToStr(L)+'s',[EffZeitStr(EndZeit)]);

  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
function TTlnDialog.AbsGridHide(Abs:TWkAbschnitt): Boolean;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
    MaxVisibleRowCount: Integer;
//..............................................................................
function ExtraLeerZeile: Integer;
begin
  with TlnBuffer.GetZeitRecColl(Abs) do
    if (SortCount>1) and (PZeitrec(SortList.Last)^.AufrundZeit < 0) then
      Result := 1
    else Result := 0; // auch wenn nur 1 Leerzeile
end;
//..............................................................................
begin
  Result := false;
  with AbsGrid[Abs] do
    if Visible then
    begin
      if Abs <= wkAbs4 then // 1..4
        if not EingabeOk(Zeitnahme1TS) then Exit
        else
      else // 5..8
        if not EingabeOk(Zeitnahme2TS) then Exit;
      UpdatingAlt := Updating;
      Updating := true;
      ItemIndex := Max(0,TlnBuffer.RundenZahl(Abs)-1); //letzte gestoppte Runde fokussieren
      MaxVisibleRowCount := Min(6,RowCount);
      // Letzte Runde immer sichtbar
      if Row < TopRow then TopRow := Row
      else
      if Row > TopRow + MaxVisibleRowCount - 2 - ExtraLeerZeile then
        TopRow := Max(1,Row - MaxVisibleRowCount + 2 + ExtraLeerZeile);

      AbsZeitEdit[Abs].Text := UhrZeitStr(PZeitRec(FocusedItem).AufrundZeit);
      UpdateZeiten;
      SetButtons;
      Result := true;
      Hide;
      Updating := UpdatingAlt;
    end else
      Result := true;
end;

//------------------------------------------------------------------------------
function TTlnDialog.AbsGridHide: Boolean;
//------------------------------------------------------------------------------
var AbsCnt : TWkAbschnitt;
begin
  Result := false;
  for AbsCnt:=wkAbs1 to wkAbs8 do
    if AbsGrid[AbsCnt].Visible and (not AbsGridHide(AbsCnt)) then Exit;
  Result := true;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateZeitGutschrift;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
begin
  UpdatingAlt := Updating;
  Updating := true;
  ZeitGutschrEdit.Text := MinZeitStr(TlnBuffer.Gutschrift);
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateZeitStrafe;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
begin
  UpdatingAlt := Updating;
  Updating := true;
  if ZeitStrafeCB.Checked then
  begin
    ZeitStrafeEdit.InitEditMask;
    ZeitStrafeEdit.Text := MinZeitStr(Max(0,TlnBuffer.StrafZeit));
    ZeitStrafeEdit.Enabled := true;
    ZeitStrafeLabel.Enabled := true;
  end else
  begin
    ZeitStrafeEdit.EditMask := '';
    ZeitStrafeEdit.Text := '';  // default = -1
    ZeitStrafeEdit.Enabled := false;
    ZeitStrafeLabel.Enabled := false;
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateDisqGrund;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;
  if DisqCheckBox.Checked then
  begin
    DisqGrundEdit.Text      := Trim(TlnBuffer.DisqGrund);
    DisqGrundEdit.Enabled   := true;
    DisqNameEdit.Text := TlnBuffer.DisqName;
    DisqNameEdit.Enabled := true;
    if GetWettk.AbschnZahl <= 4 then // PageControl noch nicht gesetzt
      DisqStatus1Label.Visible := true
    else DisqStatus2Label.Visible := true;
  end else
  begin
    DisqGrundEdit.Text      := '';
    DisqGrundEdit.Enabled   := false;
    DisqNameEdit.Text       := '';//GetWettk.DisqTxt;
    DisqNameEdit.Enabled    := false;
    if GetWettk.AbschnZahl <= 4 then // PageControl noch nicht gesetzt
      DisqStatus1Label.Visible := false
    else DisqStatus2Label.Visible := false;
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdateReststrecke;
//------------------------------------------------------------------------------
// bei Wettk-Wechsel
var UpdatingAlt : Boolean;
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;
  if GetWettk.WettkArt = waStndRennen then
  begin
    ReststreckeEdit.Text      := IntToStr(TlnBuffer.Reststrecke);
    ReststreckeLabel1.Enabled := true;
    ReststreckeLabel2.Enabled := true;
    ReststreckeEdit.Enabled   := true;
    //ReststreckeUpDown.Enabled := true;
  end else
  begin
    ReststreckeLabel1.Enabled := false;
    ReststreckeLabel2.Enabled := false;
    ReststreckeEdit.Enabled   := false;
    //ReststreckeUpDown.Enabled := false;
    ReststreckeEdit.Text      := '';
  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.InitZeitnahmeTS;
//------------------------------------------------------------------------------
// bei Wettk-Änderung: Felder abhängig von Wettk.AbschnZahl
// InitEditMask geht nur nach Create;
// Maske setzen, damit leeres feld gesetzt wird beim disabeln (Text := '')
// Variable Zeiten in UpdateZeiten berechnen
// bei Wettk-Change wird TlBuffer.Wettk vorher in UpdateSex gesetzt
var UpdatingAlt : Boolean;
    AbsCnt : TWkAbschnitt;
    Rnd : Integer;
//------------------------------------------------------------------------------
procedure InitAbsGrid(Abs:TWkAbschnitt);
var MaxVisibleRowCount : Integer;
//..............................................................................
function ExtraLeerZeile: Integer;
begin
  with TlnBuffer.GetZeitRecColl(Abs) do
    if (SortCount>1) and (PZeitrec(SortList.Last)^.AufrundZeit < 0) then
      Result := 1
    else Result := 0; // auch wenn nur 1 Leerzeile
end;
//..............................................................................
begin
  with AbsGrid[Abs] do
  begin
    with TlnBuffer do
      Init(GetZeitRecColl(Abs),smSortiert,ssVertical,
           GetZeitRecColl(Abs).SortList[Max(0,RundenZahl(Abs)-1)]); // Focus letzte gestoppte Runde
    MaxVisibleRowCount := Min(6,RowCount);
    ClientHeight := DefaultRowHeight * MaxVisibleRowCount + RowCount {- 1 reserve};
    // Aktuelle Runde immer sichtbar
    if Row < TopRow then TopRow := Row
    else
    if Row > TopRow + MaxVisibleRowCount - 2 - ExtraLeerZeile then
      TopRow := Max(1,Row - MaxVisibleRowCount + 2 + ExtraLeerZeile);
  end;
end;

//------------------------------------------------------------------------------
begin
  UpdatingAlt := Updating;
  Updating := true;

  for AbsCnt:=wkAbs1 to wkAbs8 do
  with TlnBuffer do
    if Wettk.AbSchnZahl >= Integer(AbsCnt) then
    begin
      AbsLabel[AbsCnt].Enabled := true;
      if (AbsCnt=wkAbs1) and (Wettk.AbSchnZahl = 1) then // kein Abs-Name
        AbsLabel[AbsCnt].Caption := 'Abschn. 1'
      else AbsLabel[AbsCnt].Caption := Wettk.AbschnName[AbsCnt];
      AbsStartEdit[AbsCnt].InitEditMask;
      AbsStartEdit[AbsCnt].Text := UhrZeitStr(StrtZeit(AbsCnt));
      if AbsCnt=wkAbs1 then
        with Abs1StZeitEdit do
        if (SGrp<>nil) and (SGrp.StartModus[wkAbs1] = stOhnePause) then // EinzelStart
        begin
          ReadOnly := false;
          Color    := clWindow;
          TabStop  := true;
          Loesch1Label1.Caption :=
            '*)  Start- und Stoppzeiten werden grundsätzlich als Uhrzeiten betrachtet. Sie können mit';
        end else
        begin
          ReadOnly := true;
          Color    := clBtnFace;
          TabStop  := false;
          Loesch1Label1.Caption :=
            '*)  Start- und Stoppzeiten werden grundsätzlich als Uhrzeiten betrachtet. Die Stoppzeit kann mit'
        end;
      AbsZeitEdit[AbsCnt].InitEditMask;
      Rnd := RundenZahl(AbsCnt);
      if Rnd > 0 then
        AbsZeitEdit[AbsCnt].Text := UhrZeitStr(AbsRundeStoppZeit(AbsCnt,Rnd))
      else AbsZeitEdit[AbsCnt].Text := UhrZeitStr(-1);
      InitAbsGrid(AbsCnt);
      if Wettk.AbsMaxRunden[AbsCnt] > 1 then
        AbsBtn[AbsCnt].Enabled := true
      else AbsBtn[AbsCnt].Enabled := false;
      AbsZeitEdit[AbsCnt].ReadOnly := false;
      AbsZeitEdit[AbsCnt].Color    := clWindow;
    end else
    begin // kommt bei wkAbs1 nicht vor
      AbsLabel[AbsCnt].Enabled      := false;
      AbsLabel[AbsCnt].Caption      := 'Abschn. '+IntToStr(Integer(AbsCnt));
      AbsStartEdit[AbsCnt].EditMask := '';
      AbsStartEdit[AbsCnt].Text     := '';
      AbsZeitEdit[AbsCnt].EditMask  := '';
      AbsZeitEdit[AbsCnt].Text      := '';
      AbsBtn[AbsCnt].Enabled        := false;
      AbsZeitEdit[AbsCnt].ReadOnly  := true;
      AbsZeitEdit[AbsCnt].Color     := clBtnFace;
      AbsRndEdit[AbsCnt].Text       := '';
      AbsErgEdit[AbsCnt].Text       := '';
    end;

  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.InitWertgTS;
//------------------------------------------------------------------------------
// abhängig von Wettk.AbschnZahl
var UpdatingAlt : Boolean;
    AbsCnt : TWkAbschnitt;
    KwCnt  : TKlassenWertung;

//..............................................................................
function KlasseGueltig(AkWrtg:TKlassenWertung): Boolean;
begin
  with TlnBuffer do
    case AkWrtg of
      kwAlle:
        Result := WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt;
      kwSex:
        Result := (WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt) and
                  ((Sex = cnMaennlich) and (WertungsKlasse(AkWrtg,tmTln) <> AkMannUnbek) or
                   (Sex = cnWeiblich)  and (WertungsKlasse(AkWrtg,tmTln) <> AkFrauUnbek) or
                   (Sex = cnMixed));
      kwAltKl:
        Result := (WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt) and
                  ((Sex = cnMaennlich)and(WertungsKlasse(AkWrtg,tmTln) <> AkMannUnbek) and
                   (Wettk.AltMKlasseColl[tmTln].Count > 0) or
                   (Sex = cnWeiblich)  and (WertungsKlasse(AkWrtg,tmTln) <> AkFrauUnbek)and
                   (Wettk.AltWKlasseColl[tmTln].Count > 0));
      kwSondKl:
        Result := (WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt) and
                  ((Sex = cnMaennlich)and(WertungsKlasse(AkWrtg,tmTln) <> AkMannUnbek) and
                   (Wettk.SondMKlasseColl.Count > 0) or
                   (Sex = cnWeiblich)  and (WertungsKlasse(AkWrtg,tmTln) <> AkFrauUnbek)and
                   (Wettk.SondWKlasseColl.Count > 0));
      else Result := false;
    end;
end;

//..............................................................................
function DefaultKlasseName(AkWrtg:TKlassenWertung): String;
begin
  case AkWrtg of
    kwAlle   : Result := 'Alle Teilnehmer';
    kwSex    : Result := 'Pro Geschlecht';
    kwAltKl  : Result := 'Altersklasse';
    kwSondKl : Result := 'Sonderklasse';
    else       Result := '';
  end;
end;

//..............................................................................
procedure LabelCut(L:TLabel);
var S : String;
begin
  while L.Canvas.TextWidth(L.Caption) > L.Width do
  begin
    S := L.Caption;
    Delete(S,Length(S),1);
    L.Caption := S;
  end;
end;

//..............................................................................
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;

  with TlnBuffer do
  begin
    for AbsCnt:=wkAbs0 to wkAbs8 do
      for KwCnt:=kwAlle to kwSondKl do
      begin
        // Labels
        if AbsCnt=wkAbs0 then
        begin
          // allgemeine labels
          if KlasseGueltig(kwCnt) then
          begin
            RngLabel[kwCnt].Caption := WertungsKlasse(kwCnt,tmTln).Name;
            RngLabel[kwCnt].Enabled := true;
          end else
          begin
            RngLabel[KwCnt].Enabled := false;
            RngLabel[KwCnt].Caption := DefaultKlasseName(KwCnt);
          end;
          // Rang
          if RngLabel[KwCnt].Enabled then
            AbsRngEdit[KwCnt,AbsCnt].Text := Format('%4s',[TagesEndRngStr(AbsCnt,KwCnt,wgStandWrtg)])
          else AbsRngEdit[KwCnt,AbsCnt].Text := '';
        end else // Abs-Labels, Cnt > wkAbs0
        begin
          if GetWettk.AbschnZahl >= Max(2,Integer(AbsCnt)) then //für Abs1 erst ab 2 Abs. anzeigen
          begin
            AbsRngLabel[AbsCnt].Enabled := true;
            AbsRngLabel[AbsCnt].Caption := Wettk.AbschnName[AbsCnt];
            LabelCut(AbsRngLabel[AbsCnt]);
          end else
          begin
            AbsRngLabel[AbsCnt].Enabled := false;
            AbsRngLabel[AbsCnt].Caption := 'Abs. '+IntToStr(Integer(AbsCnt));
          end;
          // Rang
          if RngLabel[KwCnt].Enabled and AbsRngLabel[AbsCnt].Enabled then
            AbsRngEdit[KwCnt,AbsCnt].Text := Format('%4s',[TagesZwRngStr(AbsCnt,KwCnt,wgStandWrtg)])
          else AbsRngEdit[KwCnt,AbsCnt].Text := '';
        end;
      end;

  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.InitSondWertgTS;
//------------------------------------------------------------------------------
// abhängig von Wettk.AbschnZahl
var UpdatingAlt : Boolean;
    AbsCnt : TWkAbschnitt;
    KwCnt  : TKlassenWertung;

//..............................................................................
function KlasseGueltig(AkWrtg:TKlassenWertung): Boolean;
begin
  with TlnBuffer do
    case AkWrtg of
      kwAlle:
        Result := WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt;
      kwSex:
        Result := (WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt) and
                  ((Sex = cnMaennlich) and (WertungsKlasse(AkWrtg,tmTln) <> AkMannUnbek) or
                   (Sex = cnWeiblich)  and (WertungsKlasse(AkWrtg,tmTln) <> AkFrauUnbek) or
                   (Sex = cnMixed));
      kwAltKl:
        Result := (WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt) and
                  ((Sex = cnMaennlich)and(WertungsKlasse(AkWrtg,tmTln) <> AkMannUnbek) and
                   (Wettk.AltMKlasseColl[tmTln].Count > 0) or
                   (Sex = cnWeiblich)  and (WertungsKlasse(AkWrtg,tmTln) <> AkFrauUnbek)and
                   (Wettk.AltWKlasseColl[tmTln].Count > 0));
      kwSondKl:
        Result := (WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt) and
                  ((Sex = cnMaennlich)and(WertungsKlasse(AkWrtg,tmTln) <> AkMannUnbek) and
                   (Wettk.SondMKlasseColl.Count > 0) or
                   (Sex = cnWeiblich)  and (WertungsKlasse(AkWrtg,tmTln) <> AkFrauUnbek)and
                   (Wettk.SondWKlasseColl.Count > 0));
      else Result := false;
    end;
end;

//..............................................................................
function DefaultKlasseName(AkWrtg:TKlassenWertung): String;
begin
  case AkWrtg of
    kwAlle   : Result := 'Alle Teilnehmer';
    kwSex    : Result := 'Pro Geschlecht';
    kwAltKl  : Result := 'Altersklasse';
    kwSondKl : Result := 'Sonderklasse';
    else       Result := '';
  end;
end;

//..............................................................................
procedure LabelCut(L:TLabel);
var S : String;
begin
  while L.Canvas.TextWidth(L.Caption) > L.Width do
  begin
    S := L.Caption;
    Delete(S,Length(S),1);
    L.Caption := S;
  end;
end;

//..............................................................................
begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;

  with TlnBuffer do
  begin
    for AbsCnt:=wkAbs0 to wkAbs8 do
      for KwCnt:=kwAlle to kwSondKl do
      begin
        // Labels
        if AbsCnt=wkAbs0 then
        begin
          // allgemeine labels
          if KlasseGueltig(kwCnt) then
          begin
            RngSWLabel[kwCnt].Caption := WertungsKlasse(kwCnt,tmTln).Name;
            RngSWLabel[kwCnt].Enabled := true;
          end else
          begin
            RngSWLabel[KwCnt].Enabled := false;
            RngSWLabel[KwCnt].Caption := DefaultKlasseName(KwCnt);
          end;
          // Rang
          if RngSWLabel[KwCnt].Enabled then
            AbsRngSWEdit[KwCnt,AbsCnt].Text := Format('%4s',[TagesEndRngStr(AbsCnt,KwCnt,wgSondWrtg)])
          else AbsRngSWEdit[KwCnt,AbsCnt].Text := '';
        end else // Abs-Labels, Cnt > wkAbs0
        begin
          if GetWettk.AbschnZahl >= Max(2,Integer(AbsCnt)) then //für Abs1 erst ab 2 Abs. anzeigen
          begin
            AbsRngSWLabel[AbsCnt].Enabled := true;
            AbsRngSWLabel[AbsCnt].Caption := Wettk.AbschnName[AbsCnt];
            LabelCut(AbsRngSWLabel[AbsCnt]);
          end else
          begin
            AbsRngSWLabel[AbsCnt].Enabled := false;
            AbsRngSWLabel[AbsCnt].Caption := 'Abs. '+IntToStr(Integer(AbsCnt));
          end;
          // Rang
          if RngSWLabel[KwCnt].Enabled and AbsRngSWLabel[AbsCnt].Enabled then
            AbsRngSWEdit[KwCnt,AbsCnt].Text := Format('%4s',[TagesZwRngStr(AbsCnt,KwCnt,wgSondWrtg)])
          else AbsRngSWEdit[KwCnt,AbsCnt].Text := '';
        end;
      end;

  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.InitSerWertgTS;
//------------------------------------------------------------------------------
// abhängig von Wettk.AbschnZahl, nur sichtbar bei Serie
var UpdatingAlt : Boolean;
    KwCnt  : TKlassenWertung;

//..............................................................................
function KlasseGueltig(AkWrtg:TKlassenWertung): Boolean;
begin
  with TlnBuffer do
    case AkWrtg of
      kwAlle:
        Result := WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt;
      kwSex:
        Result := (WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt) and // cnMixed/TlnStaffel nicht in Serie
                  ((Sex = cnMaennlich) and (WertungsKlasse(AkWrtg,tmTln) <> AkMannUnbek) or
                   (Sex = cnWeiblich)  and (WertungsKlasse(AkWrtg,tmTln) <> AkFrauUnbek));
      kwAltKl:
        Result := (WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt) and
                  ((Sex = cnMaennlich)and(WertungsKlasse(AkWrtg,tmTln) <> AkMannUnbek) and
                   (Wettk.AltMKlasseColl[tmTln].Count > 0) or
                   (Sex = cnWeiblich)  and (WertungsKlasse(AkWrtg,tmTln) <> AkFrauUnbek)and
                   (Wettk.AltWKlasseColl[tmTln].Count > 0));
      kwSondKl:
        Result := (WertungsKlasse(AkWrtg,tmTln) <> AkUnbekannt) and
                  ((Sex = cnMaennlich)and(WertungsKlasse(AkWrtg,tmTln) <> AkMannUnbek) and
                   (Wettk.SondMKlasseColl.Count > 0) or
                   (Sex = cnWeiblich)  and (WertungsKlasse(AkWrtg,tmTln) <> AkFrauUnbek)and
                   (Wettk.SondWKlasseColl.Count > 0));
      else Result := false;
    end;
end;

//..............................................................................
function DefaultKlasseName(AkWrtg:TKlassenWertung): String;
begin
  case AkWrtg of
    kwAlle   : Result := 'Alle Teilnehmer';
    kwSex    : Result := 'Pro Geschlecht';
    kwAltKl  : Result := 'Altersklasse';
    kwSondKl : Result := 'Sonderklasse';
    else       Result := '';
  end;
end;

//..............................................................................
procedure LabelCut(L:TLabel);
var S : String;
begin
  while L.Canvas.TextWidth(L.Caption) > L.Width do
  begin
    S := L.Caption;
    Delete(S,Length(S),1);
    L.Caption := S;
  end;
end;

//..............................................................................
begin
  if not Veranstaltung.Serie then Exit;
  UpdatingAlt := Updating;
  Updating := true;

  with TlnBuffer do
  begin
    if Wettk.SerWrtgMode[tmTln] = swZeit then
    begin
      EndPktSerLabel.Enabled  := false;
      SerRngGB.Width          := 264;
      SeriePktLabel.Left      := 190;
      SeriePktLabel.Caption   := 'Zeit';
      SeriePktAlleEdit.Width  := 88;
      SeriePktSexEdit.Width   := 88;
      SeriePktAkEdit.Width    := 88;
      SeriePktSkEdit.Width    := 88;
    end else
    begin
      EndPktSerLabel.Enabled  := true;
      SerRngGB.Width          := 224;
      SeriePktLabel.Left      := 164;
      SeriePktLabel.Caption   := 'Punkte';
      SeriePktAlleEdit.Width  := 48;
    end;

    for KwCnt:=kwAlle to kwSondKl do
    begin
      // TagesWertung
      if KlasseGueltig(kwCnt) and
        ((Wettk.WettkArt=waEinzel)or(Wettk.WettkArt=waRndRennen)) then // kein TlnStaffel bei Serie
      begin
        RngSerTgLabel[KwCnt].Caption := WertungsKlasse(KwCnt,tmTln).Name;
        RngSerTgLabel[KwCnt].Enabled := true;
      end else
      begin
        RngSerTgLabel[KwCnt].Enabled := false;
        if KlasseGueltig(kwCnt) then RngSerTgLabel[KwCnt].Caption := WertungsKlasse(KwCnt,tmTln).Name
                                else RngSerTgLabel[KwCnt].Caption := DefaultKlasseName(KwCnt);
      end;
      if RngSerTgLabel[KwCnt].Enabled then
      begin
        RngSerTgEdit[KwCnt].Text := Format('%4s',[TagesZwRngStr(wkAbs0,KwCnt,wgSerWrtg)]);
        if Wettk.SerWrtgMode[tmTln] <> swZeit then
          PktSerTgEdit[KwCnt].Text := Format('%4s',[GetOrtSerSumStr(Veranstaltung.OrtIndex,KwCnt)])
        else PktSerTgEdit[KwCnt].Text := '';
      end else
      begin
        RngSerTgEdit[KwCnt].Text := '';
        PktSerTgEdit[KwCnt].Text := '';
      end;
      // SerieWertung
      if KlasseGueltig(kwCnt) then
      begin
        SerieLabel[KwCnt].Enabled := true;
        SerieLabel[KwCnt].Caption := WertungsKlasse(KwCnt,tmTln).Name;
      end else
       begin
        SerieLabel[KwCnt].Enabled := false;
        SerieLabel[KwCnt].Caption := DefaultKlasseName(KwCnt);
      end;
      if SerieLabel[KwCnt].Enabled then
      begin
        SerieRngEdit[KwCnt].Text := Format('%4s',[GetSerieRangStr(KwCnt)]);
        if Wettk.SerWrtgMode[tmTln] <> swZeit then
          SeriePktEdit[KwCnt].Text := Format('%4s',[GetSerieSumStr(lmReport,KwCnt)])
        else
          SeriePktEdit[KwCnt].Text := Format('%9s',[GetSerieSumStr(lmReport,KwCnt)]);
      end else
      begin
        SerieRngEdit[KwCnt].Text := '';
        SeriePktEdit[KwCnt].Text := '';
      end;
    end;

  end;
  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.UpdatePageControl;
//------------------------------------------------------------------------------
var UpdatingAlt : Boolean;

begin
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;

  if (GetWettk.WettkArt = waTlnStaffel) or (GetWettk.WettkArt = waTlnTeam) then
  begin
    StaffelTS.TabVisible := true;
    if GetWettk.WettkArt = waTlnStaffel then
      StaffelTS.Caption := 'Staffel'
    else
      StaffelTS.Caption := 'Team';
  end
  else
  begin
    if PageAktuell=StaffelTS then SetPage(AnmeldungTS);
    StaffelTS.TabVisible := false;
  end;

  if (GetSGrp=nil) or (StrToIntDef(SnrEdit.Text,0)=0) or
     (GetWettk.StartBahnen>0) and (GetSBhn<=0) then
  // Invisible sofort bei Änderung
  begin
    if (PageAktuell=ZeitNahme1TS) or
       (PageAktuell=ZeitNahme2TS) or
       (PageAktuell=WertgTS) or
       (PageAktuell=SondWertgTS) or
       (PageAktuell=SerWertgTS) or
       (PageAktuell=StrafenTS) then SetPage(AnmeldungTS);
    ZeitNahme1TS.TabVisible := false;
    ZeitNahme2TS.TabVisible := false;
    StrafenTS.TabVisible := false;
    WertgTS.TabVisible := false;
    SondWertgTS.TabVisible := false;
    SerWertgTS.TabVisible := false;
  end else
  if (SGrpAlt<>nil) and (SnrAlt>0) and
     ((WettkAlt.StartBahnen=0)or(SBhnAlt>0)) then
  begin
    // Visible erst nachdem die Daten gespeichert wurden (WettkAlt)
    ZeitNahme1TS.TabVisible := true;
    if WettkAlt.AbschnZahl >= 5 then ZeitNahme2TS.TabVisible := true
                                else ZeitNahme2TS.TabVisible := false;
    StrafenTS.TabVisible := true;
    WertgTS.TabVisible := true;
    if WettkAlt.SondWrtg then SondWertgTS.TabVisible := true
                         else SondWertgTS.TabVisible := false;
    if Veranstaltung.Serie then SerWertgTS.TabVisible := true
                           else SerWertgTS.TabVisible := false;
  end;

  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
function TTlnDialog.GetWettk: TWettkObj;
//------------------------------------------------------------------------------
begin
  if (WettkCB.ItemIndex >= 0) and
     (WettkCB.ItemIndex < Veranstaltung.WettkColl.Count) then
    Result := Veranstaltung.WettkColl.Items[WettkCB.ItemIndex]
  else Result := nil;
end;

//------------------------------------------------------------------------------
function TTlnDialog.GetVerein: String;
//------------------------------------------------------------------------------
begin
  Result := Trim(VereinLookUpEdit.Text);
end;

//------------------------------------------------------------------------------
function TTlnDialog.GetMannschName: String;
//------------------------------------------------------------------------------
begin
  Result := Trim(MannschLookUpEdit.Text);
end;

//------------------------------------------------------------------------------
function TTlnDialog.GetSMld: TSMldObj;
//------------------------------------------------------------------------------
begin
  if SammelMelder = nil then
    if (SMldCB.ItemIndex > 0) and
       (SMldCB.ItemIndex < Veranstaltung.SMldColl.SortCount+1) then
      Result := Veranstaltung.SMldColl.SortItems[SMldCB.ItemIndex-1]
    else Result := nil
  else Result := SammelMelder;
end;

//------------------------------------------------------------------------------
function TTlnDialog.GetSGrp: TSGrpObj;
//------------------------------------------------------------------------------
begin
  (* Startgruppe 0 ist in ListBox zusätzlich eingefügt, sonst
     nur die für den Wettkampf definierten SGrp'en *)
  if (SGrpGrid.ItemIndex <= 0) or (SGrpGrid.ItemCount = 0) then Result := nil
  else Result := TSGrpObj(SGrpGrid[SGrpGrid.ItemIndex]);
end;

//------------------------------------------------------------------------------
function TTlnDialog.GetSBhn: Integer;
//------------------------------------------------------------------------------
begin
  (* Startbahn 0 ist in ListBox zusätzlich eingefügt, sonst
     nur die für den Wettkampf definierten SBhn'en *)
  if GetSGrp=nil then Result := 0
                 else Result := SBhnGrid.Row-1;
end;

//------------------------------------------------------------------------------
function TTlnDialog.GetSex: TSex;
//------------------------------------------------------------------------------
begin
  case SexCB.ItemIndex of
    1: Result := cnMaennlich;
    2: Result := cnWeiblich;
    3: Result := cnMixed;
    else Result := cnKeinSex;
  end;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.SetButtons;
//------------------------------------------------------------------------------
begin
  if AnmeldungDlg then
  begin
    if not TlnGeAendert then
    begin
      AendButton.Enabled := false;
      AendButton.Default := false;
      // wenn noch keine Eingabe, dann keine Defaultbutton
      if TlnNeu then NextAnmButton.Default := false
                else NextAnmButton.Default := true;
    end else // geändert
    begin
      NextAnmButton.Default := false;
      AendButton.Enabled    := true;
      AendButton.Default    := true;
    end;
  end else // Tln Bearbeiten
  begin
    with HauptFenster.LstFrame.TriaGrid do
    begin
      if ItemIndex > 0 then
      begin
        TlnBackBtn.Enabled  := true;
        TlnFirstBtn.Enabled := true;
      end else
      begin
        TlnBackBtn.Enabled  := false;
        TlnFirstBtn.Enabled := false;
      end;
      if (ItemCount > 1) and (ItemIndex >=0) and
         (ItemIndex < ItemCount-1) then
      begin
        TlnNextBtn.Enabled := true;
        TlnLastBtn.Enabled := true;
      end else
      begin
        TlnNextBtn.Enabled := false;
        TlnLastBtn.Enabled := false;
      end;
    end;
    if not TlnGeAendert then
    begin
      AendButton.Enabled := false;
      AendButton.Default := false;
      TlnNextBtn.Default := true;
    end else
    begin
      TlnNextBtn.Default := false;
      AendButton.Enabled := true;
      AendButton.Default := true;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.SetPage(Page:TTabSheet);
//------------------------------------------------------------------------------
var UpdatingAlt: Boolean;
begin
  if (Page = PageAktuell) or not Page.TabVisible then Exit;  (* damit nicht Focussiert wird *)
  UpdatingAlt := Updating;
  Updating := true;
  PageAktuell := Page;
  TlnPageControl.ActivePage := PageAktuell;

  if PageAktuell = EinteilungTS then
  begin
    ControlAktuell := SGrpGrid;
    if SGrpVoreinstellen and not SGrpVoreingestellt then
    // SGrp voreinstellen, wenn noch keine definiert und nur 1 vorhanden
    begin
      UpdateSGrpListe;
      UpdateSBhnListe;
      UpdateSnrListe;
      UpdateSnr;
    end else
    if not SnrVoreingestellt then
    // Snr voreinstellen, wenn noch keine definiert und >= 1 vorhanden
    begin
      UpdateSnrListe;
      UpdateSnr;
    end;
    // ControlAktuell := ActiveControl;
    // entfernt, weil Exception wenn ActiveControl = nil
  end;

  // immer Name fokussieren, wenn noch nicht eingetragen
  if StrGleich(NameEdit.Text,'') then
    ControlAktuell := NameEdit
  else
  if StrGleich(VNameEdit.Text,'') then
    ControlAktuell := VNameEdit
  else
  if PageAktuell = EinteilungTS then // keine Aktion, vorher eingestellt
  else
  if PageAktuell = StaffelTS then
    ControlAktuell := Tln2NameEdit
  else
  if PageAktuell = StrafenTS then
    if GetWettk.WettkArt=waStndRennen then
      ControlAktuell := ReststreckeEdit
    else
      ControlAktuell := ZeitGutschrEdit
  else
  if PageAktuell = ZeitNahme1TS then
    if not Abs1StZeitEdit.ReadOnly then
      ControlAktuell := Abs1StZeitEdit
    else
      ControlAktuell := Abs1ZeitEdit
  else
  if PageAktuell = ZeitNahme2TS then
    ControlAktuell := Abs5ZeitEdit
  else
    ControlAktuell := NameEdit;

  if ControlAktuell.CanFocus then ControlAktuell.SetFocus; // ControlAktuell <> nil

  Updating := UpdatingAlt;
end;

//------------------------------------------------------------------------------
function TTlnDialog.ZeitGeaendert(Abs:TWkAbschnitt): Boolean;
//------------------------------------------------------------------------------
var i : Integer;
begin
  // TlnBuffer mit AbsRndZeitAltArr vergleichen, inkl. Startzeit
  Result := true;
  with TlnBuffer do
    if GetWettk.AbschnZahl >= Integer(Abs) then
    with GetZeitRecColl(Abs) do
    begin
      if AbsRndZeitAltArr[Abs].Count <> Count then Exit;
      for i:=0 to AbsRndZeitAltArr[Abs].Count-1 do
        if AbsRndZeitAltArr[Abs][i] <> Items[i].AufrundZeit then Exit;
    end;
  Result := false;
end;

//------------------------------------------------------------------------------
function TTlnDialog.ZeitGeaendert: Boolean;
//------------------------------------------------------------------------------
var AbsCnt : TWkAbschnitt;
begin
  // TlnBuffer mit AbsRndZeitAltArr vergleichen, ohne Startzeit
  Result := true;
  for AbsCnt:=wkAbs1 to wkAbs8 do
    if ZeitGeaendert(AbsCnt) then Exit;
  Result := false;
end;

//------------------------------------------------------------------------------
function TTlnDialog.StaffelTlnGeaendert: Boolean;
//------------------------------------------------------------------------------
var AbsCnt: TWkAbschnitt;
    MaxCnt : Integer;
begin
  Result := true;
  MaxCnt := 0;
  if GetWettk.WettkArt = waTlnStaffel then
    MaxCnt := GetWettk.AbschnZahl
  else
  if GetWettk.WettkArt = waTlnTeam then
  begin
    MaxCnt := GetWettk.MschGroesse[GetSex];
    if MaxCnt <> GetWettk.MschGroesse[SexAlt] then Exit;
  end;

  if MaxCnt > 0 then
    for AbsCnt:=wkAbs2 to wkAbs8 do
    with TlnBuffer do
      if (MaxCnt >= Integer(AbsCnt)) and
         ((not StrGleich(StaffelName[AbsCnt],TlnNameEdit[AbsCnt].Text)) or
          (not StrGleich(StaffelVName[AbsCnt],TlnVNameEdit[AbsCnt].Text))) then Exit;

  Result := false;
end;

//------------------------------------------------------------------------------
function TTlnDialog.TlnGeaendert: Boolean;
//------------------------------------------------------------------------------
begin
  Result := false;
  if GetWettk=nil then Exit;
  with TlnBuffer do
    Result := not StrGleich(Name,NameEdit.Text)                           or
              not StrGleich(VName,VNameEdit.Text)                         or
              (JgAlt <> GetJg)                                            or
              (SexAlt <> GetSex)                                          or
              not StrGleich(Land,LandEdit.Text)and LandEdit.Enabled       or
              (WettkAlt <> GetWettk)                                      or
              (Verein <> GetVerein)                                       or
              (MannschName <> GetMannschName)                             or
              (SMld <> GetSMld)                                           or
              not StrGleich(Strasse,StrasseEdit.Text)                     or
              not StrGleich(HausNr,HausNrEdit.Text)                       or
              not StrGleich(PLZ,PLZEdit.Text)                             or
              not StrGleich(Ort,OrtEdit.Text)                             or
              not StrGleich(EMail,EMailEdit.Text)                         or
              not MldZeitEdit.ZeitGleich(UhrZeitStrODec(MldZeit))         or
              (Startgeld <> StrToIntDef(StartgeldEdit.Text,0))            or
              not StrGleich(Komment,KommentEdit.Text)                     or
              not StrGleich(RfidAlt,RfidCodeEdit.Text) and
                RfidCodeEdit.Enabled                                      or
              StaffelTlnGeaendert                                         or
              (MschWrtg<>MschWrtgCB.Checked)and MschWrtgCB.Enabled        or
              (MschMixWrtg<>MixMschCB.Checked)and MixMschCB.Enabled       or
              (SondWrtg<>SondWrtgCB.Checked)and SondWrtgCB.Enabled        or
              (SerienWrtg<>SerWrtgCB.Checked)and SerWrtgCB.Enabled        or
              (UrkDruck <> UrkDruckCB.Checked)                            or
              (AusKonkAllg <> AusKonkAllgCB.Checked)                      or
              AusKonkAltKlCB.Enabled and
                (AusKonkAltKl <> AusKonkAltKlCB.Checked)                  or
              AusKonkSondKlCB.Enabled and
                (AusKonkSondKl <> AusKonkSondKlCB.Checked)                or

              (SGrpAlt <> GetSGrp)                                        or
              (SBhnAlt <> GetSBhn)                                        or
              (SnrAlt <>  StrToIntDef(SnrEdit.Text,0))                    or

              ZeitGeaendert                                               or

              not ZeitGutschrEdit.ZeitGleich(MinZeitStr(GutschriftAlt))   or
              not ZeitStrafeEdit.ZeitGleich(MinZeitStr(StrafZeitAlt))     or
              (StrToIntDef(ReststreckeEdit.Text,0) <> ReststreckeAlt)     or
              TlnInStatus(stDisqualifiziert)and
               (not DisqCheckBox.Checked or
                not StrGleich(DisqGrund,DisqGrundEdit.Text) or
                not StrGleich(DisqName,DisqNameEdit.Text))              or
              not TlnInStatus(stDisqualifiziert)and DisqCheckBox.Checked;
end;

//------------------------------------------------------------------------------
function TTlnDialog.TabGeaendert: Boolean;
//------------------------------------------------------------------------------
begin
  Result := false;
  if GetWettk=nil then Exit;

  with TlnBuffer do

  if TlnPageControl.ActivePage = AnmeldungTS then
    Result := not StrGleich(Strasse,StrasseEdit.Text)               or
              not StrGleich(HausNr,HausNrEdit.Text)                 or
              not StrGleich(PLZ,PLZEdit.Text)                       or
              not StrGleich(Ort,OrtEdit.Text)                       or
              not StrGleich(EMail,EMailEdit.Text)                   or
              (SMld <> GetSMld)                                     or
              not MldZeitEdit.ZeitGleich(UhrZeitStrODec(MldZeit))   or
              not StrGleich(Land,LandEdit.Text)and LandEdit.Enabled or
              (Startgeld <> StrToIntDef(StartgeldEdit.Text,0))      or
              not StrGleich(RfidAlt,RfidCodeEdit.Text) and
                RfidCodeEdit.Enabled                                or
              not StrGleich(Komment,KommentEdit.Text)
  else
  if TlnPageControl.ActivePage = OptionenTS then
    Result := (MschWrtg<>MschWrtgCB.Checked)and MschWrtgCB.Enabled  or
              (MschMixWrtg<>MixMschCB.Checked)and MixMschCB.Enabled or
              (SondWrtg<>SondWrtgCB.Checked)and SondWrtgCB.Enabled  or
              (SerienWrtg<>SerWrtgCB.Checked)and SerWrtgCB.Enabled  or
              (UrkDruck <> UrkDruckCB.Checked)                      or
              (AusKonkAllg <> AusKonkAllgCB.Checked)                or
              AusKonkAltKlCB.Enabled and
              (AusKonkAltKl <> AusKonkAltKlCB.Checked)              or
              AusKonkSondKlCB.Enabled and
              (AusKonkSondKl <> AusKonkSondKlCB.Checked)
  else
  if TlnPageControl.ActivePage = StaffelTS then
      Result := StaffelTlnGeaendert
  else
  if TlnPageControl.ActivePage = EinteilungTS then
    Result := (SGrpAlt <> GetSGrp) or (SBhnAlt <> GetSBhn) or
              (SnrAlt <>  StrToIntDef(SnrEdit.Text,0))
  else
  if TlnPageControl.ActivePage = StrafenTS then
    Result := not ZeitGutschrEdit.ZeitGleich(MinZeitStr(GutschriftAlt)) or
              not ZeitStrafeEdit.ZeitGleich(MinZeitStr(StrafZeitAlt))   or
              (StrToIntDef(ReststreckeEdit.Text,0) <> ReststreckeAlt)   or
              TlnInStatus(stDisqualifiziert)and
              (not DisqCheckBox.Checked or
               not StrGleich(DisqGrund,DisqGrundEdit.Text) or
               not StrGleich(DisqName,DisqNameEdit.Text))               or
              not TlnInStatus(stDisqualifiziert)and DisqCheckBox.Checked
  else
  if (TlnPageControl.ActivePage=Zeitnahme1TS)or(TlnPageControl.ActivePage=Zeitnahme2TS) then
    Result := ZeitGeaendert;
end;

//------------------------------------------------------------------------------
function TTlnDialog.TlnDoppel: Boolean;
//------------------------------------------------------------------------------
// prüfen ob Teilnehmer bereits vorhanden ist
begin
  Result := false;
  if GetWettk=nil then Exit;
  // nicht Groß/Kleinschreibung aber ss/ß werden bei SucheTln unterschieden
  if Veranstaltung.TlnColl.SucheTln(TlnBuffer.LoadPtr,NameEdit.Text,VNameEdit.Text,
                                    GetVerein,GetMannschName,GetWettk) <> nil then
  begin
    Result := true;
    TriaMessage(Self,'Teilnehmer mit gleichem Namen, Vornamen, Verein oder Mannschaft und'+#13+
                'Wettkampf wurde bereits angemeldet.',mtInformation,[mbOk]);
    TlnPageControl.ActivePage := AnmeldungTS;
    if NameEdit.CanFocus then NameEdit.SetFocus;
    Exit;
  end;
end;

//------------------------------------------------------------------------------
function TTlnDialog.SnrDoppel: Boolean;
//------------------------------------------------------------------------------
var Nr : Integer;
begin
  Nr := StrToIntDef(SnrEdit.Text,0);
  if (Nr > 0) and (SnrAlt <> Nr) and (Veranstaltung.TlnColl.TlnMitSnr(Nr) <> nil) then
  begin
    Result := true;
    TriaMessage(Self,'Startnummer wurde bereits vergeben.',mtInformation,[mbOk]);
    TlnPageControl.ActivePage := EinteilungTS;
    if SnrEdit.CanFocus then SnrEdit.SetFocus;
  end
  else Result := false;
end;

//------------------------------------------------------------------------------
function TTlnDialog.RfidDoppel: Boolean;
//------------------------------------------------------------------------------
// RfidModus und RfidCode vorher auf Richtigkeit geprüft
begin
  if not StrGleich(RfidAlt,RfidCodeEdit.Text) and
     (Veranstaltung.TlnColl.TlnMitRfid(RfidCodeEdit.Text) <> nil) then
  begin
    Result := true;
    TriaMessage(Self,'RFID-Code wurde bereits vergeben.',mtInformation,[mbOk]);
    TlnPageControl.ActivePage := AnmeldungTS;
    if RfidCodeEdit.CanFocus then RfidCodeEdit.SetFocus;
  end
  else Result := false;
end;

//------------------------------------------------------------------------------
function TTlnDialog.EingabeOK(Tab:TTabSheet): Boolean;
//------------------------------------------------------------------------------
// wenn Tab = nil alles prüfen, sonst nur Tab-Daten
var S : String;
    i : integer;
    UpdatingAlt : Boolean;
    AbsCnt : TWkAbschnitt;
    MaxCnt : Integer;
begin
  Result := false;
  if GetWettk=nil then Exit;
  UpdatingAlt := Updating;
  Updating := true;

  try  // am Ende Updating zurücksetzen

  // allgemein
  if Tab=nil then
  begin
    if StrGleich(NameEdit.Text,'') then
    begin
      TriaMessage(Self,'Nachname fehlt.'+#13+
                  'Vor- und Nachname sind Pflichtfelder.',
                  mtInformation,[mbOk]);
      if NameEdit.CanFocus then NameEdit.SetFocus;
      Exit;
    end;

    if StrGleich(VNameEdit.Text,'') then
    begin
      TriaMessage(Self,'Vorname fehlt.'+#13+
                  'Vor- und Nachname sind Pflichtfelder.',
                  mtInformation,[mbOk]);
      if VNameEdit.CanFocus then VNameEdit.SetFocus;
      Exit;
    end;

    if (GetSex = cnKeinSex) and
       (not KeinSexAkzeptiert) and (not KeinSexAkzeptiertAll) then // nur 1x fragen
      case TriaMessage(Self,'Geschlecht fehlt.'+#13+
                       'Teilnehmer ohne Geschlecht zulassen?',
                        mtConfirmation,[mbYes,mbNo,mbYesToAll]) of
        mrYes: KeinSexAkzeptiert := true; // nur für aktueller Tln
        mrYesToAll:
        begin
          KeinSexAkzeptiert    := true;
          KeinSexAkzeptiertAll := true; // für alle Tln
        end;
        mrNo:
        begin
          if SexCB.CanFocus then SexCB.SetFocus;
          Exit;
        end;
      end;

    if GetJg = 0 then
      if (not KeinJgAkzeptiert) and (not KeinJgAkzeptiertAll) then // nur 1x fragen
        case TriaMessage(Self,'Jahrgang fehlt.'+#13+
                         'Teilnehmer ohne Jahrgang zulassen?',
                          mtConfirmation,[mbYes,mbNo,mbYesToAll]) of
          mrYes:
            KeinJgAkzeptiert := true; // nur für aktueller Tln
          mrYesToAll:
          begin
            KeinJgAkzeptiert    := true;
            KeinJgAkzeptiertAll := true; // für alle Tln
          end;
          mrNo:
          begin
            if JgEdit.CanFocus then JgEdit.SetFocus;
            Exit;
          end;
        end
      else
    else // GetJg > 0
      begin
        if GetWettk.Jahr-GetJg > cnAlterMax then
        begin
          TriaMessage(Self,'Jahrgang muss größer sein als '+
                       IntToStr(GetWettk.Jahr-cnAlterMax-1)+'.'+#13+
                      'Wert löschen (Entf-Taste), wenn Jahrgang unbekannt ist.',
                       mtInformation,[mbOk]);
          if JgEdit.CanFocus then JgEdit.SetFocus;
          Exit;
        end else
        if GetWettk.Jahr-GetJg < cnAlterMin then
        begin
          TriaMessage(Self,'Jahrgang muss kleiner sein als '+
                       IntToStr(GetWettk.Jahr-cnAlterMin+1)+'.'+#13+
                      'Wert löschen (Entf-Taste), wenn Jahrgang unbekannt ist.',
                       mtInformation,[mbOk]);
          if JgEdit.CanFocus then JgEdit.SetFocus;
          Exit;
        end;
        if AkEdit.Enabled and (TlnBuffer.WertungsKlasse(kwAltKl,tmTln).Wertung = kwKein) then
          if not AkAkzeptiert and
            (TriaMessage(Self,'Alter liegt außerhalb des für den Wettkampf definierten Bereichs.'+#13+
                         'Es kann keine Altersklasse zugeordnet werden.'+#13+#13+
                         'Jahrgang beibehalten?',
                          mtConfirmation,[mbOk,mbCancel]) <> mrOk) then
          begin
            if JgEdit.CanFocus then JgEdit.SetFocus;
            Exit;
          end else AkAkzeptiert := true;
      end;

    if ContainsStr(MannschLookupEdit.Text,'~') then
    begin
      TriaMessage(Self,'Das Zeichen "~" darf im Mannschaftsnamen nicht verwendet werden.',
                   mtInformation,[mbOk]);
      if MannschLookupEdit.CanFocus then MannschLookupEdit.SetFocus;
      Exit;
    end;

    if TlnDoppel then Exit;
  end;

  // Anmeldung
  if (Tab = nil) or
     (Tab = AnmeldungTS)and(TlnPageControl.ActivePage = AnmeldungTS) then
  begin
    if not MldZeitEdit.ValidateEdit then Exit;
    if not StartgeldEdit.ValidateEdit then Exit;
    if RfidModus and (RfidCodeEdit.Text <> '') then // leeres Feld zulassen
    begin
      if Length(RfidCodeEdit.Text) > cnRfidzeichenMax then
      begin
        TriaMessage(Self,'Der RFID-Code hat mehr als '+IntToStr(cnRfidzeichenMax)+ ' Zeichen.',
                    mtInformation,[mbOk]);
        if RfidCodeEdit.CanFocus then RfidCodeEdit.SetFocus;
        Exit;
      end;
      if not RfidTrimValid(RfidCodeEdit.Text) then
      begin
        TriaMessage(Self,'Der RFID-Code hat Leerzeichen am Anfang und/oder Ende.',
                    mtInformation,[mbOk]);
        if RfidCodeEdit.CanFocus then RfidCodeEdit.SetFocus;
        Exit;
      end;
      if not RfidLengthValid(RfidCodeEdit.Text) then
        if TriaMessage(Self,'Der RFID-Code hat '+ IntToStr(Length(RfidCodeEdit.Text)) +
                       ' statt ' + IntToStr(RfidZeichen)+' Zeichen.'+#13+
                       'Die maximal zulässige Zeichenlänge auf '+ IntToStr(Length(RfidCodeEdit.Text))+' erhöhen?',
                       mtConfirmation,[mbOk,mbCancel]) <> mrOk then
        begin
          if RfidCodeEdit.CanFocus then RfidCodeEdit.SetFocus;
          Exit;
        end else
          RfidZeichen := Length(RfidCodeEdit.Text);
      if RfidHex and not RfidHexValid(RfidCodeEdit.Text) then
        if TriaMessage(Self,'Der RFID-Code ist keine gültige Hex-Zahl.'+#13+
                       'Nicht-hexadezimale Zeichen generell zulassen?',
                       mtConfirmation,[mbOk,mbCancel]) <> mrOk then
        begin
          if RfidCodeEdit.CanFocus then RfidCodeEdit.SetFocus;
          Exit;
        end else
          RfidHex := false;
      if RfidDoppel then Exit;
    end;
  end;

  // StaffelTln
  if (Tab = nil) or
     (Tab = StaffelTS)and(TlnPageControl.ActivePage = StaffelTS) then
  begin
    MaxCnt := 0;
    if GetWettk.WettkArt=waTlnStaffel then
    begin
      MaxCnt := GetWettk.AbschnZahl;
      S := 'Staffel';
    end else
    if GetWettk.WettkArt=waTlnTeam then
    begin
      MaxCnt := GetWettk.MschGroesse[GetSex];
      S := 'Team';
    end;
    if MaxCnt > 0 then
      for AbsCnt:=wkAbs2 to wkAbs8 do
        if (MaxCnt >= Integer(AbsCnt)) and
            StrGleich(TlnNameEdit[AbsCnt].Text,'') then
          if not KeinStaffelAkzeptiert and
             (TriaMessage(Self,'Name für '+S+'-Teilnehmer '+IntToStr(Integer(AbsCnt))+' fehlt.',
                           mtInformation,[mbOk,mbCancel]) <> mrOk) then
          begin
            if TlnNameEdit[AbsCnt].CanFocus then TlnNameEdit[AbsCnt].SetFocus;
            Exit;
          end else KeinStaffelAkzeptiert := true;
  end;

  // Einteilung
  if (Tab = nil) or
     (Tab = EinteilungTS)and(TlnPageControl.ActivePage = EinteilungTS) then
    if StrToIntDef(SnrEdit.Text,0) <> 0 then
    begin
      if not TryDecStrToInt(SnrEdit.Text,i) then
      begin
        TriaMessage(Self,'Die Startnummer ist ungültig.',
                     mtInformation,[mbOk]);
        if SnrEdit.CanFocus then SnrEdit.SetFocus;
        Exit;
      end;
      if SnrDoppel then Exit;
      if SGrpGrid.ItemIndex = 0 then
      begin
        TriaMessage(Self,'Startgruppe ist nicht definiert.'+#13+
                    'Startnummer kann nicht vergeben werden.',
                     mtInformation,[mbOk]);
        Exit;
      end;

      if not SnrAkzeptiert and
         ((StrToIntDef(SnrEdit.Text,0) < GetSGrp.StartnrVon) or
          (StrToIntDef(SnrEdit.Text,0) > GetSGrp.StartnrBis)) then
      begin
        if Veranstaltung.SGrpColl.SGrpMitSnr(GetWettk,StrToIntDef(SnrEdit.Text,0)) <> nil then
          S := 'Startnummer wurde für eine andere Startgruppe definiert.'
        else
        if Veranstaltung.SGrpColl.SGrpMitSnr(WettkAlleDummy,StrToIntDef(SnrEdit.Text,0)) <> nil then
          S := 'Startnummer wurde für einen anderen Wettkampf definiert.'
        else
          S := 'Startnummer wurde für keine Startgruppe definiert.';
        if TriaMessage(S + #13+#13 + 'Startnummer beibehalten?',
                       mtConfirmation,[mbOk,mbCancel]) <> mrOk then
        begin
          SetPage(EinteilungTS);
          if SnrEdit.CanFocus then SnrEdit.SetFocus;
          Exit;
        end else SnrAkzeptiert := true;
      end;

      if not SBhnNullAkzeptiert and
         (GetWettk.StartBahnen > 0) and (GetSBhn = 0) and
         (StrToIntDef(SnrEdit.Text,0) > 0) then
        if TriaMessage(Self,'Startbahn fehlt. Einteilung ist unvollständig.'+#13+
                       'Einteilung ohne Startbahn zulassen?',
                        mtConfirmation,[mbOk,mbCancel]) <> mrOk then
        begin
          SetPage(EinteilungTS);
          if SBhnGrid.CanFocus then SBhnGrid.SetFocus;
          Exit;
        end else SBhnNullAkzeptiert := true;
    end;

  // Zeitnahme (Validate wird bei Enter-Taste nicht aufgerufen, nur bei Exit-Comp)
  if (Tab = nil) or
     (Tab = Zeitnahme1TS)and(TlnPageControl.ActivePage = Zeitnahme1TS) then
  begin
    if not Abs1StZeitEdit.ValidateEdit then Exit;
    for AbsCnt:=wkAbs1 to wkAbs4 do
      if not AbsZeitEdit[AbsCnt].ValidateEdit then Exit;
  end;
  if (Tab = nil) or
     (Tab = Zeitnahme2TS)and(TlnPageControl.ActivePage = Zeitnahme2TS) then
    for AbsCnt:=wkAbs5 to wkAbs8 do
      if not AbsZeitEdit[AbsCnt].ValidateEdit then Exit;

  // Strafen
  if (Tab = nil) or
     (Tab = StrafenTS)and(TlnPageControl.ActivePage = StrafenTS) then
  begin
    if ZeitStrafeCB.Checked then
      if ZeitStrafeEdit.Wert < 0 then
      begin
        TriaMessage(Self,'Die Strafzeit fehlt.',mtInformation,[mbOk]);
        Exit;
      end;

    if DisqCheckBox.Checked then
    begin
      if Veranstaltung.DisqGrundColl.Count >= cnDisqGrundMax then
      begin
        TriaMessage(Self,'Maximale Zahl von Disqualifikationen erreicht.',
                     mtInformation,[mbOk]);
        Exit;
      end;
      if DisqNameEdit.Text = '' then
      begin
        TriaMessage(Self,'Bezeichnung der Disqualifikation fehlt.',mtInformation,[mbOk]);
        Exit;
      end;
    end;

    if not ZeitGutschrEdit.ValidateEdit then Exit;
    if not ZeitStrafeEdit.ValidateEdit then Exit;
    with ReststreckeEdit do
      if Enabled and not ValidateEdit then Exit;
  end;

  Result := true;

  finally
    Updating := UpdatingAlt;
  end;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.MannschNeu;
//------------------------------------------------------------------------------
(* Mannschaften für Tln wird erstellt, wenn noch nicht vorhanden *)
(* MannschNeu wird erst nach Änderung aller Daten in TlnAktuell aufgerufen,
   sowohl bei Anmeldung als Änderung *)
// nur für MschIndex=0, Rest später bei MschEinlesen
var MannschKlasse : TAkObj;
    Mannschaft    : TMannschObj;
//..............................................................................
procedure ErstelleMannsch(AkWrtg:TKlassenWertung);
begin
  MannschKlasse := TlnAktuell.Wettk.GetKlasse(tmMsch,AkWrtg,TlnAktuell.Sex,TlnAktuell.Jg);
  Mannschaft := Veranstaltung.MannschColl.SucheMannschaft
                (TlnAktuell.MannschNamePtr,TlnAktuell.Wettk,MannschKlasse,0);
  if Mannschaft <> nil then
  begin
    TlnAktuell.ClearStaffelVorg;
    Mannschaft.TlnListe.AddItem(TlnAktuell);
    // TlnGrAnm in TMannschColl.MschEinlesen prüfen
  end else
  begin
    Mannschaft := TMannschObj.Create(Veranstaltung,Veranstaltung.MannschColl,oaAdd);
    Mannschaft.Init(TlnAktuell.MannschName,TlnAktuell.Wettk,MannschKlasse,0);
    Veranstaltung.MannschColl.AddItem(Mannschaft);
  end;
end;
//..............................................................................
begin
  if (TlnAktuell=nil) or (TlnAktuell.MannschNamePtr=nil) then Exit;
  if Veranstaltung.Serie and not TlnAktuell.SerienWrtg then Exit;
  if TlnAktuell.Wettk.MschWertg = mwKein then Exit;
  ErstelleMannsch(kwAlle);
  ErstelleMannsch(kwSex);
  ErstelleMannsch(kwAltKl);
end;

//------------------------------------------------------------------------------
function TTlnDialog.TlnAendern: Boolean;
//------------------------------------------------------------------------------
// TlnAktuell in TlnColl ändern
var Idx : Integer;
    MannschGeaendert : Boolean;
    AbsCnt : TWkAbschnitt;
begin
  Result := false;
  if GetWettk=nil then Exit;
  if (TlnBuffer=nil) or not EingabeOK(nil) then Exit;
  // Index vor Änderung festhalten
  Idx := HauptFenster.LstFrame.TriaGrid.ItemIndex;
  MannschGeaendert := false;
  HauptFenster.LstFrame.TriaGrid.StopPaint := true;
  try
    if TlnNeu then
      TlnAktuell := TTlnObj.Create(Veranstaltung,Veranstaltung.TlnColl,oaAdd);

    if TlnAktuell<>nil then
    with TlnAktuell do // Daten in TlnAktuell ändern
    begin
      if not TlnNeu then
        // Tln in alte Mannschaft(en) löschen bevor Daten geändert werden
        // prüfen ob Mannschaft geändert wurde
        if (MannschName <> GetMannschName) or (Wettk <> GetWettk) or
           (Jg <> GetJg) or (Sex <> GetSex) then
        begin
          Veranstaltung.MannschColl.MschTlnLoeschen(TlnAktuell);
          MannschGeaendert := true;
        end;

      // Allgemeine Daten
      Name        := Trim(NameEdit.Text);
      VName       := Trim(VNameEdit.Text);
      Jg          := GetJg;
      Sex         := GetSex;
      Wettk       := GetWettk;
      MannschName := GetMannschName; (* muß nach Wettk,Sex,Jg *)

      // Staffelteilnehmer
      for AbsCnt:=wkAbs2 to wkAbs8 do
        if TlnNameEdit[AbsCnt].Enabled then
        begin
          StaffelName[AbsCnt]  := Trim(TlnNameEdit[AbsCnt].Text);
          StaffelVName[AbsCnt] := Trim(TlnVNameEdit[AbsCnt].Text);
        end else
        begin
          StaffelName[AbsCnt]  := '';
          StaffelVName[AbsCnt] := '';
        end;

      // TlnAktuell vor ändern der Uhrzeiten in TlnColl aufnehmen,
      // damit WettkErgModified gesetzt wird,
      // aber nachdem Wettk gesetzt ist, sonst Abstürz
      if TlnNeu then
      begin
        Veranstaltung.TlnColl.AddItem(TlnAktuell);
        HauptFenster.FocusedTln := TlnAktuell;
      end;

      // Anmeldung
      Strasse          := StrasseEdit.Text;
      HausNr           := HausNrEdit.Text;
      PLZ              := PLZEdit.Text;
      Ort              := OrtEdit.Text;
      EMail            := EMailEdit.Text;
      SMld             := GetSMld;
      Land             := LandEdit.Text;
      MldZeit          := MldZeitEdit.Wert;
      Startgeld        := StrToIntDef(StartgeldEdit.Text,0);
      RfidCode         := RfidCodeEdit.Text;
      Komment          := KommentEdit.Text;

      // Optionen
      MschWrtg         := MschWrtgCB.Checked;
      MschMixWrtg      := MixMschCB.Checked;
      SondWrtg         := SondWrtgCB.Checked;
      SerienWrtg       := SerWrtgCB.Checked;
      UrkDruck         := UrkDruckCB.Checked;
      AusKonkAllg      := AusKonkAllgCB.Checked;
      AusKonkAltKl     := AusKonkAltKlCB.Checked;
      AusKonkSondKl    := AusKonkSondKlCB.Checked;

      // Einteilung
      SGrp := GetSGrp;
      SBhn := GetSBhn;
      if Snr <> 0 then SnrBelegtArr[Snr] := false; // alter Wert löschen
      Snr  := StrToIntDef(SnrEdit.Text,0);
      if Snr <> 0 then SnrBelegtArr[Snr] := true; // neuer Wert einfügen

      // Zeiten aus TlnBuffer übernehmen
      for AbsCnt:=wkAbs1 to wkAbs8 do // ErfZeiten werden gelöscht wenn Abschn geändert
        if ZeitGeaendert(AbsCnt) then // inkl. StartZeit
        begin
          GetZeitRecColl(AbsCnt).CopyColl(TlnBuffer.GetZeitRecColl(AbsCnt));
          Wettk.ErgModified := true;
        end;

      // ZeitGutschrift
      Gutschrift := ZeitGutschrEdit.Wert;
      // ZeitStrafe
      StrafZeit := ZeitStrafeEdit.Wert;
      // Disqualifikation
      if DisqCheckBox.Checked then
      begin
        if Trim(DisqGrundEdit.Text) = '' then DisqGrund := cnDisqGrundDummy
                                         else DisqGrund := DisqGrundEdit.Text;
        DisqName := DisqNameEdit.Text;
      end else
      begin
        DisqGrund := '';
        DisqName  := '';//Wettk.DisqTxt;
      end;

      // Reststrecke
      if ReststreckeEdit.Enabled then
        Reststrecke := StrToIntDef(ReststreckeEdit.Text,0)
      else Reststrecke := 0;

      // neue Mannsch bei NeuAnmeldung oder nach Änderung Msch-Daten
      if TlnNeu or MannschGeaendert then MannschNeu;

      SetzeBearbeitet;
      TriDatei.Modified := true;

      // Voreinstellung für neue Tln
      if HauptFenster.SortWettk = WettkAlleDummy then
        WettkAktuell := Wettk
      else WettkAktuell := HauptFenster.SortWettk;
      //MschNamePtrAktuell := MannschNamePtr;

      TlnNeu := false;
      Result := true;
    end;

  finally
    HauptFenster.LstFrame.UpdateColWidths; // Cols spStartBahn anpassen
    HauptFenster.CommandDataUpdate;
    // TlnAktuell kann nach UpdateAnsicht aus Liste verschwinden oder Index sich ändern
    // geänderte Daten nach Berechnung in TlnBuffer übernehmen
    InitTlnBuffer(TlnAktuell);
    with HauptFenster.LstFrame.TriaGrid do
    begin
      if GetIndex(TlnAktuell) < 0 then
        if Idx < ItemCount then // ursprünglicher Index von TlnAktuell
          ItemIndex := Idx
        else
          ItemIndex := ItemCount - 1;
        HauptFenster.FocusedTln := TlnAktuell; // bleibt unverändert
    end;
    HauptFenster.LstFrame.TriaGrid.StopPaint := false;
  end;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.TlnFirst;
//------------------------------------------------------------------------------
var i : Integer;
begin
  if TlnGeAendert and not TlnAendern then Exit;

  with HauptFenster.LstFrame.TriaGrid do
  begin
    if ItemCount = 0 then Exit;
    i := 0;
    repeat
      if TTlnObj(Items[i]).Name=cnDummyName then Inc(i);
    until (i > ItemCount-1) or (TTlnObj(Items[i]).Name<>cnDummyName);

    if (i < ItemCount) and (TTlnObj(Items[i]).Name<>cnDummyname) then
    begin
      ItemIndex := i;
      HauptFenster.FocusedTln := FocusedItem;
      TlnAktuell := FocusedItem;
      InitData;
    end;
  end;
  HauptFenster.Refresh;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.TlnLast;
//------------------------------------------------------------------------------
var i : Integer;
begin
  if TlnGeAendert and not TlnAendern then Exit;

  with HauptFenster.LstFrame.TriaGrid do
  begin
    if ItemCount = 0 then Exit;
    i := ItemCount-1;
    repeat
      if TTlnObj(Items[i]).Name=cnDummyName then Dec(i);
    until (i < 0) or (TTlnObj(Items[i]).Name<>cnDummyName);

    if (i >= 0) and (TTlnObj(Items[i]).Name<>cnDummyName) then
    begin
      ItemIndex := i;
      HauptFenster.FocusedTln := FocusedItem;
      TlnAktuell := FocusedItem;
      InitData;
    end;
  end;
  HauptFenster.Refresh;
end;

//------------------------------------------------------------------------------
procedure TTlnDialog.TlnNext;
//------------------------------------------------------------------------------
var i : Integer;
    FocNeu : TTriaObj;
begin
  i := -1;
  with HauptFenster.LstFrame.TriaGrid do
  begin
    // neuer Tln vor TlnAendern ermitteln, damit neuer Focus
    // unabhängig von eventuell geänderter TlnAktuell-Index ist
    if (ItemCount > 0) and (ItemIndex < ItemCount-1) then
    begin
      i := ItemIndex + 1;
      repeat
        if TTlnObj(Items[i]).Name=cnDummyName then Inc(i);
      until (i > ItemCount-1) or (TTlnObj(Items[i]).Name<>cnDummyName);
    end;
    if (i>=0) and (i<ItemCount) and
       (TTlnObj(Items[i]).Name<>cnDummyName) then FocNeu := Items[i]
                                             else FocNeu := nil;

    if TlnGeAendert and not TlnAendern then Exit;

    if FocNeu <> nil then
    begin
      FocusedItem := FocNeu; // auch ItemIndex gesetzt
      HauptFenster.FocusedTln := FocusedItem;
      TlnAktuell := FocusedItem;
      // TlnNextButton kurz disabeln, damit Dlg für jeden Step initialsiert
      // wird, wenn Enter-Taste gedruckt gehalten wird
      // mit sichtbares flackern der Taste
      TlnNextBtn.Enabled := false;
      InitData;
    end;
  end;
  HauptFenster.Refresh;
end;


//------------------------------------------------------------------------------
procedure TTlnDialog.TlnBack;
//------------------------------------------------------------------------------
var i : Integer;
    FocNeu : TTriaObj;
begin
  i := -1;
  with HauptFenster.LstFrame.TriaGrid do
  begin
    // neuer Tln vor TlnAendern ermitteln, damit neuer Focus
    // unabhängig von eventuell geänderter TlnAktuell-Index ist
    if (ItemCount > 0) and (ItemIndex > 0) then
    begin
      i := ItemIndex-1;
      repeat
        if TTlnObj(Items[i]).Name=cnDummyName then Dec(i);
      until (i < 0) or (TTlnObj(Items[i]).Name<>cnDummyName);
    end;
    if (i>=0) and (TTlnObj(Items[i]).Name<>cnDummyName) then FocNeu := Items[i]
                                                        else FocNeu := nil;

    if TlnGeAendert and not TlnAendern then Exit;

    if FocNeu <> nil then
    begin
      FocusedItem := FocNeu;
      HauptFenster.FocusedTln := FocusedItem;
      TlnAktuell := FocusedItem;
      // TlnNextButton während Init disabeln, damit Dlg für jeden Step initialsiert
      // wird, wenn Enter-Taste gedruckt gehalten wird
      // mit sichtbares flakkern der Taste
      TlnBackBtn.Enabled := false;
      InitData;
    end;
  end;
  HauptFenster.Refresh;
end;

//------------------------------------------------------------------------------
function TTlnDialog.GetJg: Integer;
//------------------------------------------------------------------------------
// Text='0' wird als 2000 gewertet, Text='' als 0
begin
  if Trim(JgEdit.Text) <> '' then
    if GetWettk <> nil then
      // hochrechnen auf 1900/2000, WettkJahr: 2000-2099, Alter 1-99
      Result := GetWettk.JgLang(JgEdit.Text)
    else
      Result := StrToIntDef(JgEdit.Text,0)
  else Result := 0;
end;


// published Methoden

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Event Handler Allgemein
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.FormShow(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  InitData;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.EingabeChange(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var i,Idx: Integer;
    AbsCnt : TWkAbschnitt;
begin
  if not Updating then
  begin

    if (Sender = NameEdit) and AnMeldungDlg then // vorher Sortmode=smTlnName einstellen
    with HauptFenster.LstFrame.TriaGrid do
    begin
      Idx := ItemIndex; // Alter Index, wenn nichts gefunden
      if Trim(NameEdit.Text ) <> '' then // immer von Anfang an suchen,
        for i:=0 to ItemCount-1 do       // damit in beide Richtungen gesucht wird
          if StartsText(Trim(NameEdit.Text),TTlnObj(Items[i]).Name) then
        begin
          Idx := i;
          Break;
        end;
      if Idx <> ItemIndex then
      begin
        ItemIndex := Idx; // TopRow wird angepasst aber ItemIndex nicht mittig
        TopRow :=  Max(1, Idx - VisibleRowCount DIV 2); // FixedRows = 1
        HauptFenster.FocusedTln := FocusedItem;
      end;
    end;

    if Sender = JgEdit then
    begin
      UpdateJg(Sender);
      UpdateKlasse;
    end;

    if Sender = SexCB then
    begin
      UpdateSex(Sender);
      UpdateKlasse;
      UpdateStaffelTln;
    end;

    if Sender = MannschLookUpEdit then
    begin
      UpdateMschWrtg;
      UpdateMixWrtg;
    end;

    if Sender = WettkCB then
    begin
      if TlnBuffer.TlnInStatus(stEingeteilt) then
        if TriaMessage(Self,'Teilnehmer wurde bereits eingeteilt.'+#13+
                       'Bei Änderung des Wettkampfes werden diese Daten gelöscht.'+#13+#13+
                       'Wettkampf ändern?',
                        mtConfirmation,[mbOk,mbCancel]) <> mrOk then
        begin
          WettkCB.ItemIndex := Veranstaltung.WettkColl.IndexOf(TlnBuffer.Wettk);
          Exit;
        end else
          TlnBuffer.EinteilungLoeschen;
      UpdateMannschLabel;
      UpdateStartgeld; // vor UpdateSex, TlnBuffer.Wettk noch nicht geändert
      UpdateSex(Sender);
      UpdateJg(Sender);
      UpdateKlasse;
      UpdateSondWrtg;
      UpdateMschWrtg;
      UpdateMixWrtg;
      UpdateTlnTxt;
      UpdateReststrecke;
      UpdateStaffelTln;
      SGrpVoreinstellen := true;
      UpdateSGrpListe;
      UpdateSBhnListe;
      UpdateSnrListe;
      UpdateSnr;
      InitZeitnahmeTS;
      UpdateZeiten;
      InitWertgTS;
      InitSondWertgTS;
      InitSerWertgTS;
      UpdatePageControl;
    end;

    if Sender= AusKonkAllgCB then
    begin
      UpdateAusKonk;
      //UpdateSondWrtg;
      //UpdateSerWrtg;
      //UpdateMschWrtg; // abhängig von SerWrtg
    end;

    if Sender= MschWrtgCB then UpdateMixWrtg;

    if Sender= SerWrtgCB then
    begin
      UpdateMschWrtg;
      UpdateMixWrtg;
    end;

    if Sender = SMldCB then UpdateAdresse;

    if Sender = SGrpGrid then
    begin
      if (SGrpGrid.ItemCount = 2) and (SGrpGrid.ItemIndex <> 1) then
        SGrpVoreinstellen := false;
      UpdateSBhnListe;
      UpdateSnrListe;
      UpdateSnr;
      //InitZeitnahmeTS;  ??
      UpdateZeiten;
      InitWertgTS;
      InitSondWertgTS;
      InitSerWertgTS;
      UpdatePageControl;
    end;

    if Sender = SBhnGrid then
    begin
      UpdateZeiten;  // Startzeit berechnen
      UpdatePageControl;
    end;

    if Sender = SnrEdit then with SnrGrid do
    begin
      Updating := true;
      Row := 0;
      for i:=1 to RowCount-1 do
        if Trim(Cells[0,i]) = Trim(SnrEdit.Text) then Row := i;
      Updating := false;
      UpdateZeiten;
      InitWertgTS;
      InitSondWertgTS;
      InitSerWertgTS;
      UpdatePageControl;
    end;

    if Sender = SnrGrid then
    begin
      Updating := true;
      with SnrGrid do
        if Row > 0 then SnrEdit.Text := Trim(Cells[0,Row])
        else SnrEdit.Text := ''; // auch wenn TlnBuffer.Snr <> 0
      Updating := false;
      UpdateZeiten;
      InitWertgTS;
      InitSondWertgTS;
      InitSerWertgTS;
      UpdatePageControl;
    end;

    if Sender=Abs1StZeitEdit then
      UpdateZeiten;
      
    for AbsCnt:=wkAbs1 to wkAbs8 do
      if Sender = AbsZeitEdit[AbsCnt] then
      begin
      if not AbsGrid[AbsCnt].Visible and
         (AbsGrid[AbsCnt].ItemCount > 1) then AbsGrid[AbsCnt].Show;
      UpdateZeiten;
      Break;
    end;

    if Sender = ZeitGutschrEdit then
    begin
      if ZeitGutschrEdit.EditText = '__:__' then
        ZeitGutschrEdit.Text := MinZeitStr(0);
      UpdateZeiten;
    end;

    if Sender = ZeitStrafeEdit then
    begin
      if ZeitStrafeEdit.EditText = '__:__' then
        ZeitStrafeEdit.Text := MinZeitStr(0);
      UpdateZeiten;
    end;

    if Sender = ZeitStrafeCB then
    begin
      UpdateZeitStrafe;
      UpdateZeiten;
      if ZeitStrafeCB.Checked then
        if ZeitStrafeEdit.CanFocus then ZeitStrafeEdit.SetFocus;
    end;

    if Sender = DisqCheckBox then
    begin
      UpdateDisqGrund;
      if DisqCheckBox.Checked then
        if DisqGrundEdit.CanFocus then DisqGrundEdit.SetFocus;
    end;

    if Sender = ReststreckeEdit then
      UpdateZeiten;

    SetButtons;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.NameLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if NameEdit.CanFocus then NameEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.VNameLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if VNameEdit.CanFocus then VNameEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.SexLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if SexCB.CanFocus then SexCB.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.JgLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if JgEdit.CanFocus then JgEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.JgUpDownClick(Sender: TObject; Button: TUDBtnType);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var i : Integer;
begin
  if GetWettk <> nil then
    // hochrechnen auf 1900/2000, WettkJahr: 2000-2099, Alter 1-99
    i := GetWettk.JgLang(IntToStr(StrToIntDef(JgEdit.Text,0)))
  else
    i := StrToIntDef(JgEdit.Text,0);

  case Button of
    btNext : i := Min(i + 1,JgUpDown.Max);
    btPrev : i := Max(i - 1,JgUpDown.Min);
  end;

  JgUpDown.Position := i;
  JgEdit.Text := IntToStr(i);
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.LandLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if LandEdit.CanFocus then LandEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.WettkLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if WettkCB.CanFocus then WettkCB.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.VereinLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if VereinLookupEdit.CanFocus then VereinLookupEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.MannschLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if MannschLookupEdit.CanFocus then MannschLookupEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.VereinLookUpGridGetRowText(Sender: TTriaLookUpGrid;
                                                Indx: Integer; var Value: string);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  with VereinLookUpGrid do
    if (Indx >= 0) and (Indx < Liste.Count) then
      Value := Liste[Indx]
    else Value := '';
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.MannschLookUpGridGetRowText(Sender: TTriaLookUpGrid;
                                                 Indx: Integer; var Value: String);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  with MannschLookUpGrid do
    if (Indx >= 0) and (Indx < Liste.Count) then
      Value := Liste[Indx]
    else Value := '';
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.TlnPageControlChange(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// nach change ausgeführt
begin
  if AbsGridHide then
    SetPage(TlnPageControl.ActivePage);
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.TlnPageControlChanging(Sender: TObject;
                                            var AllowChange: Boolean);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// vor change ausgeführt
begin
  // nur Tab-Daten prüfen, restliche Daten erst beim Speichern prüfen
  if Updating or not TabGeAendert or
     EingabeOK(TlnPageControl.ActivePage) then AllowChange := true
                                          else AllowChange := false;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.EingabeEnter(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var AbsCnt : TWkAbschnitt;
label Ende;

begin
  if not Updating and (Sender is TWinControl) then
  begin
    if (Sender <> MannschLookUpEdit) and
       (Sender <> MannschLookUpGrid) then MannschLookUpGrid.Hide;

    if PageAktuell = Zeitnahme1TS then
    begin
      if not EingabeOk(PageAktuell) then Exit;
      for AbsCnt:=wkAbs1 to wkAbs4 do
        if Sender = AbsGrid[AbsCnt] then GoTo Ende;
      for AbsCnt:=wkAbs1 to wkAbs4 do
      begin
        if (Sender <> AbsZeitEdit[AbsCnt]) and not AbsGridHide(AbsCnt) then Exit;
        if (Sender = AbsZeitEdit[AbsCnt]) and (not AbsGrid[AbsCnt].Visible) and
           (AbsGrid[AbsCnt].ItemCount > 1) then AbsGrid[AbsCnt].Show;
      end;
    end else
    if PageAktuell = Zeitnahme2TS then
    begin
      if not EingabeOk(PageAktuell) then Exit;
      for AbsCnt:=wkAbs5 to wkAbs8 do
        if Sender = AbsGrid[AbsCnt] then GoTo Ende;
      for AbsCnt:=wkAbs5 to wkAbs8 do
      begin
        if (Sender <> AbsZeitEdit[AbsCnt]) and not AbsGridHide(AbsCnt) then Exit;
        if (Sender = AbsZeitEdit[AbsCnt]) and (not AbsGrid[AbsCnt].Visible) and
           (AbsGrid[AbsCnt].ItemCount > 1) then AbsGrid[AbsCnt].Show;
      end;
    end;

    Ende:
    if (Sender as TWinControl).TabStop then
      ControlAktuell := Sender as TWinControl;
  end;
end;


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Event Handler Anmeldung
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.SMldLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if SMldCB.CanFocus then SMldCB.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.StrasseLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if StrasseEdit.CanFocus then StrasseEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.HausNrLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if HausNrEdit.CanFocus then HausNrEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.PLZLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if PLZEdit.CanFocus then PLZEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.OrtLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if OrtEdit.CanFocus then OrtEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.EMailLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if EMailEdit.CanFocus then EMailEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.MldZeitLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if MldZeitEdit.CanFocus then MldZeitEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.StartgeldLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if StartgeldEdit.CanFocus then StartgeldEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.KommentLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    if KommentEdit.CanFocus then KommentEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Event Handler Einteilung
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.SGrpGridLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if SGrpGrid.CanFocus then SGrpGrid.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.SGrpGridDrawCell(Sender: TObject; ACol,
                             ARow: Integer; Rect: TRect; State: TGridDrawState);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var Text : String;
    SGrp : TSGrpObj;
begin
  with SGrpGrid do
  begin
    (* FixedRows = 1 *)
    if (Collection = nil) or
       (ARow > ItemCount) then Text := '' // dummy leerzeile bei Itemcount = 0
    else if ARow=0 then (* Überschrift *)
      case ACol of
        0:  Text := 'Name';
        1:  Text := ' Startzeit';
        2:  Text := 'SnrVon';
        3:  Text := 'SnrBis';
        4:  Text := 'Teiln.';
      end
    else if ARow=1 then (* nicht eingeteilt *)
      case ACol of
        0:  Text := cnKein;
        1:  Text := '        -';
        2:  Text := '     -';
        3:  Text := '     -';
        4:  Text := '  '+Strng(SGrpCount[0],4);
      end
    else // // eingeteilt
    begin
      SGrp := TSGrpObj(Collection.SortItems[ARow-1]);
      case ACol of
        0: Text := SGrp.Name;
        1: Text := ' '+UhrZeitStr(SGrp.StartZeit[wkAbs1]);
        2: Text := '  '+Strng(SGrp.StartNrVon,4);
        3: Text := '  '+Strng(SGrp.StartNrBis,4);
        4: Text := '  '+Strng(SGrpCount[ARow-1],4);
      end;
    end;
    DrawCellText(Rect,Text,taLeftJustify);
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.SBhnLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if SBhnGrid.CanFocus then SBhnGrid.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.SnrLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if SnrEdit.CanFocus then SnrEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.RfidCodeLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if RfidCodeEdit.CanFocus then RfidCodeEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{  Event Handler Zusatz                                                        }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.ZeitGutschrLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if ZeitGutschrEdit.CanFocus then ZeitGutschrEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.DisqNameLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if DisqNameEdit.CanFocus then DisqNameEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.ReststreckeLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if ReststreckeEdit.CanFocus then ReststreckeEdit.SetFocus;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Event Handler ZeitNahme
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.AbsLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var AbsCnt : TWkAbschnitt;
begin
  if AbsGridHide then
    for AbsCnt:=wkAbs1 to wkAbs8 do
      if Sender = AbsLabel[AbsCnt] then
      begin
        if AbsZeitEdit[AbsCnt].CanFocus then AbsZeitEdit[AbsCnt].SetFocus;
        Exit;
      end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.ZeitnahmeLabelClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  AbsGridHide;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.AbsZeitEditClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var AbsCnt : TWkAbschnitt;
begin
  if Updating then Exit;
    for AbsCnt:=wkAbs1 to wkAbs8 do
      if Sender = AbsZeitEdit[AbsCnt] then
      begin
        if not AbsGrid[AbsCnt].Visible and
          (AbsGrid[AbsCnt].ItemCount > 1) then AbsGrid[AbsCnt].Show;
        Exit;
      end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.AbsBtnClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var AbsCnt : TWkAbschnitt;
begin
  for AbsCnt:=wkAbs1 to wkAbs8 do
    if Sender = AbsBtn[AbsCnt] then
    begin
      if AbsGrid[AbsCnt].Visible then AbsGridHide
      else
      if AbsGridHide then
      begin
        AbsGrid[AbsCnt].Show;
        AbsGrid[AbsCnt].ItemIndex := Max(0,TlnBuffer.RundenZahl(AbsCnt)-1); //letzte gestoppte Runde
        AbsZeitEdit[AbsCnt].SetFocus;
      end;
      Exit;
    end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.AbsGridClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var AbsCnt : TWkAbschnitt;
begin
  if not Updating then
  for AbsCnt:=wkAbs1 to wkAbs8 do
    if Sender = AbsGrid[AbsCnt] then
    begin
      Updating := true;
      if AbsZeitEdit[AbsCnt].CanFocus then AbsZeitEdit[AbsCnt].SetFocus;
      AbsZeitEdit[AbsCnt].Text := UhrZeitStr(PZeitRec(AbsGrid[AbsCnt].FocusedItem).AufrundZeit);
      SetButtons;
      Updating := false;
      Exit;
    end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.AbsGridDrawCell(Sender: TObject; ACol, ARow: Integer;
                                     Rect: TRect; State: TGridDrawState);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var AbsCnt : TWkAbschnitt;
begin
  for AbsCnt:=wkAbs1 to wkAbs8 do
    if Sender = AbsGrid[AbsCnt] then
    with AbsGrid[AbsCnt] do
    begin
      (* FixedRows = 1 *)
      if (Collection = nil) or
         (ARow > ItemCount) then Text := '' // dummy leerzeile bei Itemcount = 0
      else if ARow=0 then (* Überschrift *)
        case ACol of
          0:  DrawCellText(Rect,'Runde',taCenter);
          1:  DrawCellText(Rect,'Stoppzeit',taCenter);
          2:  DrawCellText(Rect,'Rundezeit',taCenter);
        end
      else // Row>0, Zeiten
      with TlnBuffer do
        case ACol of
          0: DrawCellText(Rect,IntToStr(ARow),taCenter);
          1: DrawCellText(Rect,UhrZeitStr(AbsRundeStoppZeit(AbsCnt,ARow)),taCenter);
          2: DrawCellText(Rect,EffZeitStr(AbsEinzelRundeZeit(AbsCnt,ARow))+' ',taRightJustify);
        end;
      Exit;
    end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Event Handler Buttons
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.NextAnmButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  // verhindern, dass während Ausgabe ein 2. Mal Ok gedruckt wird
  if not DisableButtons then
  try
    DisableButtons := true;

    if MannschLookUpGrid.Visible then MannschLookUpGrid.Hide;

    if AbsGridHide then
    begin
      if TlnGeAendert and not TlnAendern then Exit;
      InitData;
      HauptFenster.Refresh;
    end;
  finally
    DisableButtons := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.AendButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Taste nur enabled nach Änderung
var TlnAlt : TTlnObj;
begin
  // verhindern, dass während Ausgabe ein 2. Mal Ok gedruckt wird
  if not DisableButtons then
  try
    DisableButtons := true;

    if MannschLookUpGrid.Visible then MannschLookUpGrid.Hide;

    if AbsGridHide then
    begin
      TlnAlt := TlnAktuell;
      if TlnGeAendert and not TlnAendern then Exit;
      if TlnAktuell <> TlnAlt then
      begin
        KeinSexAkzeptiert  := false;
        KeinJgAkzeptiert   := false;
        AkAkzeptiert       := false;
        SnrAkzeptiert      := false;
        SBhnNullAkzeptiert := false;
      end;
      InitDialog;
      HauptFenster.Refresh;
    end;
  finally
    DisableButtons := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.OkButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  // verhindern, dass während Ausgabe ein 2. Mal Ok gedruckt wird
  if not DisableButtons then
  try
    DisableButtons := true;

    if MannschLookUpGrid.Visible then MannschLookUpGrid.Hide;

    if AbsGridHide then
      if TlnGeAendert then
        if TlnAendern then ModalResult := mrOk
        else ModalResult := mrNone
      else
        if EingabeOK(nil) then ModalResult := mrOk // sollte nicht nötig sein
        else ModalResult := mrNone;
  finally
    DisableButtons := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.CancelButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if TlnNeu then  // immer Anfang der Liste fokussieren
  begin
    HauptFenster.LstFrame.TriaGrid.ItemIndex := 0;
    HauptFenster.FocusedTln := HauptFenster.LstFrame.TriaGrid.FocusedItem;
  end;
  ModalResult := mrCancel;  // Schliessen ohne weitere Prüfung
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.TlnFirstBtnClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  // verhindern, dass während Ausgabe ein 2. Mal Ok gedruckt wird
  if not DisableButtons then
  try
    DisableButtons := true;
    if MannschLookUpGrid.Visible then MannschLookUpGrid.Hide;
    if AbsGridHide then TlnFirst;
  finally
    DisableButtons := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.TlnBackBtnClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  // verhindern, dass während Ausgabe ein 2. Mal Ok gedruckt wird
  if not DisableButtons then
  try
    DisableButtons := true;
    if MannschLookUpGrid.Visible then MannschLookUpGrid.Hide;
    if AbsGridHide then TlnBack;
  finally
    DisableButtons := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.TlnNextBtnClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  // verhindern, dass während Ausgabe ein 2. Mal Ok gedruckt wird
  if not DisableButtons then
  try
    DisableButtons := true;
    if MannschLookUpGrid.Visible then MannschLookUpGrid.Hide;
    if AbsGridHide then TlnNext;
  finally
    DisableButtons := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.TlnLastBtnClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if not DisableButtons then
  try
    DisableButtons := true;
    if MannschLookUpGrid.Visible then MannschLookUpGrid.Hide;
    if AbsGridHide then TlnLast;
  finally
    DisableButtons := false;
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.NavKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Tasten für Tln-Navigation hier abfangen
// Methode für ALLE Felder mit OnKeyDown event
var i : Integer;
begin
  case Key of
    VK_PRIOR:     // Taste Bild auf
    begin
      if TlnBackBtn.Enabled then TlnBack;
      Key := 0;
    end;
    VK_NEXT:      // Taste Bild ab
    begin
      if TlnNextBtn.Enabled then TlnNext;
      Key := 0;
    end;
    VK_END	 :  //Taste Ende
    begin
      if TlnLastBtn.Enabled then TlnLast;
      Key := 0;
    end;
    VK_HOME	 :  //Taste Pos1
    begin
      if TlnFirstBtn.Enabled then TlnFirst;
      Key := 0;
    end;
    VK_UP    :	//Taste Auf, JgUpDown.Click simulieren
      if Sender=JgEdit then
      begin
        if GetWettk <> nil then
          // hochrechnen auf 1900/2000, WettkJahr: 2000-2099, Alter 1-99
          i := GetWettk.JgLang(IntToStr(StrToIntDef(JgEdit.Text,0)))
        else
          i := StrToIntDef(JgEdit.Text,0);
        i := Min(i + 1,JgUpDown.Max);
        JgUpDown.Position := i;
        JgEdit.Text := IntToStr(i);
      end else
      if Sender=SnrEdit then
        if SnrGrid.Row > 0 then
          SnrGrid.Row := SnrGrid.Row - 1;
    VK_DOWN  :  //Taste Ab, JgUpDown.Click simulieren
      if Sender=JgEdit then
      begin
        if GetWettk <> nil then
          // hochrechnen auf 1900/2000, WettkJahr: 2000-2099, Alter 1-99
          i := GetWettk.JgLang(IntToStr(StrToIntDef(JgEdit.Text,0)))
        else
          i := StrToIntDef(JgEdit.Text,0);
         i := Max(i - 1,JgUpDown.Min);
        JgUpDown.Position := i;
        JgEdit.Text := IntToStr(i);
      end else
      if Sender=SnrEdit then
        if SnrGrid.Row < SnrGrid.RowCount-1 then
          SnrGrid.Row := SnrGrid.Row + 1;
    VK_RIGHT : ; //Taste Rechts
    VK_LEFT	 : ; //Taste Links
    VK_TAB   : ; //Taste Tab
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.HilfeButtonClick(Sender: TObject);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  if AbsGridHide then
    Application.HelpContext(1400);  // Teilnehmer
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TTlnDialog.FormClose(Sender: TObject; var Action: TCloseAction);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
begin
  TlnPageBuf := TlnPageControl.ActivePage.PageIndex;
end;


end.

