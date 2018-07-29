object UrkundeDialog: TUrkundeDialog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Urkunde mit MS-Word erstellen'
  ClientHeight = 530
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 15
  object UrkDokLabel: TLabel
    Left = 18
    Top = 16
    Width = 138
    Height = 15
    Caption = 'Urkunde-Hauptdokument'
    OnClick = UrkDokLabelClick
  end
  object UrkDokCB: TComboBox
    Left = 16
    Top = 32
    Width = 318
    Height = 23
    HelpContext = 2753
    AutoComplete = False
    AutoCloseUp = True
    Style = csDropDownList
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 0
    OnChange = UrkDokCBChange
  end
  object UrkDateiBtn: TBitBtn
    Left = 342
    Top = 31
    Width = 25
    Height = 25
    HelpContext = 2753
    Glyph.Data = {
      42020000424D4202000000000000420000002800000010000000100000000100
      1000030000000002000000000000000000000000000000000000007C0000E003
      00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C000000000000000000000000000000000000000000001F7C1F7C
      1F7C1F7C1F7C0000000000420042004200420042004200420042004200001F7C
      1F7C1F7C1F7C0000E07F00000042004200420042004200420042004200420000
      1F7C1F7C1F7C0000FF7FE07F0000004200420042004200420042004200420042
      00001F7C1F7C0000E07FFF7FE07F000000420042004200420042004200420042
      004200001F7C0000FF7FE07FFF7FE07F00000000000000000000000000000000
      0000000000000000E07FFF7FE07FFF7FE07FFF7FE07FFF7FE07F00001F7C1F7C
      1F7C1F7C1F7C0000FF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7F00001F7C1F7C
      1F7C1F7C1F7C0000E07FFF7FE07F00000000000000000000000000001F7C1F7C
      1F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000
      000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C0000
      1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000001F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C}
    TabOrder = 1
    OnClick = UrkDateiBtnClick
  end
  object OkButton: TButton
    Left = 122
    Top = 489
    Width = 75
    Height = 25
    HelpContext = 2756
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = OkButtonClick
  end
  object CancelButton: TButton
    Left = 207
    Top = 489
    Width = 75
    Height = 25
    HelpContext = 2755
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 5
  end
  object HilfeButton: TButton
    Left = 292
    Top = 489
    Width = 75
    Height = 25
    HelpContext = 101
    Caption = '&Hilfe'
    TabOrder = 6
    OnClick = HilfeButtonClick
  end
  object DruckenGB: TGroupBox
    Left = 16
    Top = 349
    Width = 351
    Height = 125
    HelpContext = 2761
    Caption = 'Urkunde erstellen'
    Color = clBtnFace
    ParentBackground = False
    ParentColor = False
    TabOrder = 3
    object AnzahlLabel: TLabel
      Left = 82
      Top = 61
      Width = 93
      Height = 15
      HelpContext = 2506
      Caption = 'Anzahl Exemplare'
    end
    object UrkDrRB: TRadioButton
      Left = 16
      Top = 31
      Width = 66
      Height = 17
      HelpContext = 2761
      Caption = 'Drucken'
      TabOrder = 0
      TabStop = True
      OnClick = UrkundeGBClick
    end
    object UrkWordRB: TRadioButton
      Left = 16
      Top = 95
      Width = 173
      Height = 17
      HelpContext = 2761
      Caption = 'In Word bearbeiten'
      TabOrder = 1
      TabStop = True
      OnClick = UrkundeGBClick
    end
    object DruckerCB: TComboBox
      Left = 80
      Top = 28
      Width = 255
      Height = 23
      AutoComplete = False
      AutoCloseUp = True
      Sorted = True
      TabOrder = 2
    end
    object DruckerBtn: TButton
      Left = 244
      Top = 57
      Width = 91
      Height = 25
      Caption = 'Einstellungen...'
      TabOrder = 5
      OnClick = DruckerBtnClick
    end
    object AnzahlEdit: TTriaMaskEdit
      Left = 178
      Top = 58
      Width = 24
      Height = 22
      HelpContext = 2506
      EditMask = '09;0; '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      MaxLength = 2
      ParentFont = False
      TabOrder = 3
      Text = '0'
      UpDown = AnzahlUpDown
    end
    object AnzahlUpDown: TTriaUpDown
      Left = 202
      Top = 57
      Width = 17
      Height = 24
      HelpContext = 2506
      Min = 1
      Max = 99
      Position = 88
      TabOrder = 4
      Edit = AnzahlEdit
    end
  end
  object DatenPanel: TPanel
    Left = 16
    Top = 78
    Width = 351
    Height = 251
    BevelKind = bkFlat
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    object TitelLabel: TLabel
      Left = 2
      Top = 12
      Width = 343
      Height = 24
      Alignment = taCenter
      AutoSize = False
      Caption = 'Urkunde Teilnehmer-Tageswertung'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object WettkLabel: TLabel
      Left = 14
      Top = 59
      Width = 59
      Height = 15
      Caption = 'Wettkampf'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object KlasseLabel: TLabel
      Left = 14
      Top = 105
      Width = 32
      Height = 15
      Caption = 'Klasse'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object NameLabel: TLabel
      Left = 14
      Top = 150
      Width = 42
      Height = 20
      HelpContext = 2702
      Caption = 'Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RngLabel: TLabel
      Left = 14
      Top = 200
      Width = 34
      Height = 20
      Caption = 'Platz'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SnrLabel: TLabel
      Left = 230
      Top = 204
      Width = 52
      Height = 20
      HelpContext = 2703
      Caption = 'Startnr.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object WettkEdit: TTriaEdit
      Left = 78
      Top = 56
      Width = 255
      Height = 21
      HelpContext = 2751
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'Wettkampfname'
    end
    object KlasseCB: TComboBox
      Left = 78
      Top = 101
      Width = 255
      Height = 23
      HelpContext = 2752
      AutoComplete = False
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemIndex = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'Altersklasse'
      OnChange = KlasseCBChange
      Items.Strings = (
        'Alle'
        'Geschlecht'
        'Altersklasse'
        'Sonderklasse')
    end
    object NameEdit: TTriaEdit
      Left = 78
      Top = 147
      Width = 255
      Height = 26
      HelpContext = 2758
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = 'Teilnehmer-Name'
    end
    object RngEdit: TTriaEdit
      Left = 78
      Top = 201
      Width = 46
      Height = 21
      HelpContext = 2760
      TabStop = False
      BiDiMode = bdLeftToRight
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentBiDiMode = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      Text = '1'
    end
    object SnrEdit: TTriaEdit
      Left = 287
      Top = 205
      Width = 46
      Height = 21
      HelpContext = 2759
      TabStop = False
      BiDiMode = bdLeftToRight
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentBiDiMode = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = '9999'
    end
  end
  object PrintDialog: TPrintDialog
    Left = 32
    Top = 478
  end
end
