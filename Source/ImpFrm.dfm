object ImpFrame: TImpFrame
  Left = 0
  Top = 0
  Width = 778
  Height = 278
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  TabStop = True
  object ImpFrmPanel: TPanel
    Left = 0
    Top = 0
    Width = 778
    Height = 278
    Align = alClient
    BevelWidth = 2
    ParentColor = True
    TabOrder = 8
  end
  object ImpHeaderPanel: TPanel
    Left = 2
    Top = 2
    Width = 700
    Height = 21
    Align = alCustom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Color = 13003057
    ParentBackground = False
    TabOrder = 9
    object ImpHeaderLabel: TLabel
      Left = 6
      Top = 3
      Width = 115
      Height = 15
      AutoSize = False
      Caption = 'Daten importieren'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object ImpQuelleGB: TGroupBox
    Left = 12
    Top = 33
    Width = 453
    Height = 120
    Caption = 'Importdaten'
    TabOrder = 0
    object ImpVeranstLabel: TLabel
      Left = 8
      Top = 45
      Width = 72
      Height = 15
      HelpContext = 3002
      Caption = 'Veranstaltung'
    end
    object ImpWettkLabel: TLabel
      Left = 8
      Top = 95
      Width = 59
      Height = 15
      HelpContext = 3004
      Caption = 'Wettkampf'
    end
    object ImpOrtLabel: TLabel
      Left = 8
      Top = 70
      Width = 17
      Height = 15
      HelpContext = 3003
      Caption = 'Ort'
    end
    object ImpDateiLabel: TLabel
      Left = 8
      Top = 20
      Width = 57
      Height = 15
      HelpContext = 3001
      Caption = 'Dateiname'
    end
    object ImpVeranstEdit: TTriaEdit
      Left = 84
      Top = 41
      Width = 360
      Height = 21
      HelpContext = 3002
      TabStop = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object ImpWettkCB: TComboBox
      Left = 84
      Top = 91
      Width = 360
      Height = 23
      HelpContext = 3004
      AutoComplete = False
      Style = csDropDownList
      TabOrder = 3
    end
    object ImpOrtCB: TComboBox
      Left = 84
      Top = 66
      Width = 360
      Height = 23
      HelpContext = 3003
      AutoComplete = False
      Style = csDropDownList
      TabOrder = 2
    end
    object ImpDateiEdit: TTriaEdit
      Left = 84
      Top = 16
      Width = 360
      Height = 21
      HelpContext = 3001
      TabStop = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
  end
  object TlnStatusRG: TRadioGroup
    Left = 478
    Top = 33
    Width = 200
    Height = 120
    HelpContext = 3005
    Caption = 'Teilnehmerdaten'
    Items.Strings = (
      'ohne Teilnehmer'
      'mit Teilnehmer-Meldedaten'
      'mit Teilnehmer-Einteilung'
      'mit Teilnehmer-Ergebnissen')
    TabOrder = 1
  end
  object ImpStartButton: TButton
    Left = 692
    Top = 38
    Width = 75
    Height = 25
    HelpContext = 3006
    Caption = '&Importieren'
    TabOrder = 4
    TabStop = False
    OnClick = ImpStartButtonClick
  end
  object HilfeButton: TButton
    Left = 692
    Top = 124
    Width = 75
    Height = 25
    HelpContext = 101
    Caption = '&Hilfe'
    TabOrder = 6
    TabStop = False
    OnClick = HilfeButtonClick
  end
  object BtnPanel: TPanel
    Left = 736
    Top = 2
    Width = 42
    Height = 21
    Align = alCustom
    BevelOuter = bvNone
    Color = 13003057
    ParentBackground = False
    TabOrder = 10
    object biHelpBtn: TBitBtn
      Left = 2
      Top = 2
      Width = 18
      Height = 17
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Glyph.Data = {
        BA040000424DBA0400000000000036040000280000000C0000000B0000000100
        08000000000084000000C40E0000C40E00000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A400000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0010FFFFFF
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFF1000FFFF0000FFFFFFFFFFFF0000FF
        FF0000FFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      ParentFont = False
      TabOrder = 0
      TabStop = False
      OnClick = biHelpBtnClick
    end
    object biSystemBtn: TBitBtn
      Left = 22
      Top = 2
      Width = 18
      Height = 17
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Glyph.Data = {
        BA040000424DBA0400000000000036040000280000000C0000000B0000000100
        08000000000084000000130B0000130B00000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600FFFFFF00FCFCFC00F9F9F900F9F9F800F8F9F800F8F8F900F9F8F800F8F8
        F800F7F7F700F6F6F600F5F5F500F4F4F400F3F3F300F2F2F200F2F2EF00F0F0
        F000F3F4E600EFEFEF00EEEEEE00F1EFE800EDEDED00ECECEC00F4F3DB00EBEB
        EA00EAEAEA00E9E9E900E8E8E800F0EDD700E7E6E700E5E5E500CBEDDE00E4E4
        E400F7F2C000E2E2E200EDEACE00E6E6D800E1E1E200EBE8CF00E0E0E000DFDF
        DF00DEDEDE00EAEDB900DDDCDF00E6E3CA00E7DCD600DBDBDB00E0DED300DADA
        DA00E2DCD000D9D9D900D5D3E500DCDDCE00E1DBCF00D8D8D800E0DBCF00E1DB
        CE00F4EBA700EBE8B000E0DACE00D7D7D700E1D7D200DFD9CD00D6D6D600DFD9
        CB00DED8CD00D5D5D500DED8CA00CCCAEC00DCD9C800DEE2B500D4D4D400DED7
        C900D3D3D300F2E99B00D7D4CD00DCD5C600D1D1D100D0D0D000D8D3C700E3E0
        A900EEE59B00C5C4EA00B6DDBD00CFCFCF00DAD3C300CECECE00D9D2C100D3CF
        C700CCCCCC00E7E19700D4CEC300CBCBCB00D3D0BE00D7CFBE00DFDF9A00D5D9
        A900CACACA00BCBAED00D6D2B300D5D7A900C9C9C800E9DF9100E1DF9300C8C8
        C800D1CBBE00D4CCB900DADF9100C7C7C700D3CBB800C6C6C600D0CDB300C5C5
        C500CDC9B900D3C1C600D0CDAF00C4C4C400C3C4C400D0C8B700C4C3C400C3C3
        C300D1C8B400DADC8800C2C2C200CFC6B100CEC5B000CEC5AB00CBC3AF00CDC3
        AE00C5C0B500BDBDBD00DDBEAE00D4D28800AAA9E700CBC1AB00D0CB9400CAC0
        AB00CAC0A900C8BFAA00C9BFA800C5BFA900C4C3A000C9BEA700BEBAB100C8BD
        A600C4BCA600C7BCA400C6BBA200C9C78900C1B9A700B5B5B300C4B9A000C4B9
        9F00C0BC9900C1B79F00C0B6A000B7B3A900CCABB000AFAFAF009A9BDE00B5B0
        9F00ADACA800B6B29200AEA99F00C1B87A00B1AB97009092CD00BFB67100A7A4
        9D00B8B07E008588DD00AEAE7F00A6A195009F9E9C00B8B06B00A79F8D009997
        94009D988B00A8A273007D7DC6009F99820093929200AAA4640090909000A1A1
        5F0095908400A89C62006C70C800A19D5B009BA05700A2985E00928D77008988
        8400A0925B00938C5E0084807900565CCD0094895500837E6800595DB6003E45
        D70074716000454BB4006A69660076714F00474BA9002C35DD006C685B00383D
        A800645F54003B3FA1002A32BF001D26D9003A3F9D00625D4B002E34A000111B
        D0001720BD00514D46000B15BD00151EA50045402D003837330035332E002826
        2200131312000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000A0A0A0A0A0A
        0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A00000A0A0A0A00000A0A0A0A
        0A00000A0A00000A0A0A0A0A0A0A000000000A0A0A0A0A0A0A0A0A00000A0A0A
        0A0A0A0A0A0A000000000A0A0A0A0A0A0A00000A0A00000A0A0A0A0A00000A0A
        0A0A00000A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A}
      ParentFont = False
      TabOrder = 1
      TabStop = False
      OnClick = ImpCloseButtonClick
    end
  end
  object ImpTlnGB: TGroupBox
    Left = 12
    Top = 163
    Width = 453
    Height = 104
    Caption = 'Import-Teilnehmer'
    TabOrder = 2
    object ImpTlnNameLabel: TLabel
      Left = 12
      Top = 17
      Width = 32
      Height = 15
      HelpContext = 3007
      Caption = 'Name'
      FocusControl = NameEdit
    end
    object ImpTlnVNameLabel: TLabel
      Left = 161
      Top = 17
      Width = 47
      Height = 15
      HelpContext = 3008
      Caption = 'Vorname'
      FocusControl = VNameEdit
    end
    object ImpTlnJgLabel: TLabel
      Left = 365
      Top = 17
      Width = 31
      Height = 15
      HelpContext = 3010
      Caption = 'Jahrg.'
      FocusControl = JgEdit
    end
    object ImpTlnMschLabel: TLabel
      Left = 239
      Top = 59
      Width = 63
      Height = 15
      HelpContext = 3012
      Caption = 'Mannschaft'
    end
    object ImpTlnSexLabel: TLabel
      Left = 278
      Top = 17
      Width = 58
      Height = 15
      HelpContext = 3009
      Caption = 'Geschlecht'
      FocusControl = SexCB
    end
    object ImpTlnLandLabel: TLabel
      Left = 408
      Top = 17
      Width = 26
      Height = 15
      HelpContext = 3011
      Caption = 'Land'
      FocusControl = LandEdit
    end
    object ImpTlnVereinLabel: TLabel
      Left = 12
      Top = 60
      Width = 32
      Height = 15
      HelpContext = 3012
      Caption = 'Verein'
    end
    object VNameEdit: TTriaEdit
      Left = 157
      Top = 32
      Width = 113
      Height = 21
      HelpContext = 3008
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '012345678901234'
      OnChange = ImpTlnChange
    end
    object MschCB: TComboBox
      Left = 235
      Top = 74
      Width = 209
      Height = 23
      HelpContext = 3012
      AutoComplete = False
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnCloseUp = ImpTlnCloseUp
      OnDropDown = MschCBDropDown
    end
    object LandEdit: TTriaEdit
      Left = 404
      Top = 32
      Width = 40
      Height = 21
      HelpContext = 3011
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      TabOrder = 4
      Text = 'WWW'
      OnChange = ImpTlnChange
    end
    object SexCB: TComboBox
      Left = 274
      Top = 32
      Width = 83
      Height = 23
      HelpContext = 3009
      AutoComplete = False
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnCloseUp = ImpTlnCloseUp
      OnDropDown = SexCBDropDown
    end
    object NameEdit: TTriaEdit
      Left = 8
      Top = 32
      Width = 145
      Height = 21
      HelpContext = 3007
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '012345678901234'
      OnChange = ImpTlnChange
    end
    object JgEdit: TTriaMaskEdit
      Left = 361
      Top = 32
      Width = 39
      Height = 21
      HelpContext = 3010
      EditMask = '9999;0; '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 4
      ParentFont = False
      TabOrder = 3
      Text = '0'
      OnChange = ImpTlnChange
    end
    object VereinCB: TComboBox
      Left = 8
      Top = 74
      Width = 219
      Height = 23
      HelpContext = 3012
      AutoComplete = False
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnCloseUp = ImpTlnCloseUp
      OnDropDown = VereinCBDropDown
    end
  end
  object WeiterButton: TButton
    Left = 692
    Top = 202
    Width = 75
    Height = 25
    HelpContext = 3015
    Caption = '&Weiter'
    TabOrder = 7
    TabStop = False
    OnClick = WeiterButtonClick
  end
  object ImpCloseButton: TBitBtn
    Left = 692
    Top = 91
    Width = 75
    Height = 25
    HelpContext = 3016
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    NumGlyphs = 2
    TabOrder = 5
    TabStop = False
    OnClick = ImpCloseButtonClick
  end
  object ImpModusGB: TGroupBox
    Left = 478
    Top = 163
    Width = 200
    Height = 104
    HelpContext = 3014
    Caption = 'Importmodus'
    TabOrder = 3
    object TlnNeuRB: TRadioButton
      Left = 8
      Top = 35
      Width = 186
      Height = 17
      Caption = 'Import-Teilnehmer hinzuf'#252'gen'
      TabOrder = 0
      TabStop = True
    end
    object TlnwahlRB: TRadioButton
      Left = 8
      Top = 69
      Width = 186
      Height = 17
      Caption = 'Gew'#228'hlter Teilnehmer ersetzen'
      TabOrder = 1
      TabStop = True
    end
  end
end
