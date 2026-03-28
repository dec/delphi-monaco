object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Delphi library for Monaco Editor - Demo'
  ClientHeight = 717
  ClientWidth = 1029
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ActionMainMenuBar: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1029
    Height = 25
    UseSystemFont = False
    ActionManager = ActionManager
    Caption = 'ActionMainMenuBar'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 10461087
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 698
    Width = 1029
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object OptionsPanel: TPanel
    Left = 718
    Top = 25
    Width = 311
    Height = 523
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      311
      523)
    object ThemeLabel: TLabel
      Left = 16
      Top = 6
      Width = 32
      Height = 13
      Caption = 'Theme'
    end
    object LanguageLabel: TLabel
      Left = 128
      Top = 6
      Width = 47
      Height = 13
      Caption = 'Language'
    end
    object LineNumbersCheckBox: TCheckBox
      Left = 16
      Top = 197
      Width = 113
      Height = 17
      Caption = 'Show line numbers'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = LineNumbersCheckBoxClick
    end
    object ThemeComboBox: TComboBox
      Left = 16
      Top = 25
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'vs'
      OnChange = ThemeComboBoxChange
      Items.Strings = (
        'vs'
        'vs-dark')
    end
    object LanguageComboBox: TComboBox
      Left = 128
      Top = 25
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'Without language'
      OnChange = LanguageComboBoxChange
      Items.Strings = (
        'Without language')
    end
    object ReadOnlyCheckBox: TCheckBox
      Left = 16
      Top = 105
      Width = 81
      Height = 17
      Caption = 'Read only'
      TabOrder = 3
      OnClick = ReadOnlyCheckBoxClick
    end
    object ContextMenuCheckBox: TCheckBox
      Left = 16
      Top = 220
      Width = 97
      Height = 17
      Caption = 'Context menu'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = ContextMenuCheckBoxClick
    end
    object AllowDropFilesCheckBox: TCheckBox
      Left = 16
      Top = 151
      Width = 105
      Height = 17
      Caption = 'Allow drop files'
      TabOrder = 5
      OnClick = AllowDropFilesCheckBoxClick
    end
    object HandleNewWindowsCheckBox: TCheckBox
      Left = 16
      Top = 174
      Width = 129
      Height = 17
      Caption = 'Handle new windows'
      TabOrder = 6
      OnClick = AllowDropFilesCheckBoxClick
    end
    object WordWrapCheckBox: TCheckBox
      Left = 16
      Top = 128
      Width = 81
      Height = 17
      Caption = 'Wordwrap'
      TabOrder = 7
      OnClick = WordWrapCheckBoxClick
    end
    object PlaceholderEdit: TEdit
      Left = 16
      Top = 64
      Width = 233
      Height = 21
      TabOrder = 8
      Text = 'Happy coding!'
      TextHint = 'Editor placeholder'
      OnChange = PlaceholderEditChange
    end
    object SearchQueryEdit: TEdit
      Left = 16
      Top = 256
      Width = 146
      Height = 21
      TabOrder = 9
      TextHint = 'Type to search'
    end
    object SearchButton: TButton
      Left = 168
      Top = 254
      Width = 75
      Height = 25
      Caption = 'Search'
      TabOrder = 10
      OnClick = SearchButtonClick
    end
    object SearchDialogCheckBox: TCheckBox
      Left = 16
      Top = 352
      Width = 121
      Height = 17
      Caption = 'Show search dialog'
      Checked = True
      State = cbChecked
      TabOrder = 11
      OnClick = ContextMenuCheckBoxClick
    end
    object SearchRegExpCheckBox: TCheckBox
      Left = 16
      Top = 283
      Width = 146
      Height = 17
      Caption = 'Is regular expression'
      TabOrder = 12
      OnClick = ContextMenuCheckBoxClick
    end
    object SearchMatchCaseCheckBox: TCheckBox
      Left = 16
      Top = 306
      Width = 146
      Height = 17
      Caption = 'Match case'
      TabOrder = 13
      OnClick = ContextMenuCheckBoxClick
    end
    object SearchWholeWordsCheckBox: TCheckBox
      Left = 16
      Top = 329
      Width = 146
      Height = 17
      Caption = 'Whole words'
      TabOrder = 14
      OnClick = ContextMenuCheckBoxClick
    end
    object StartSearchButton: TButton
      Left = 16
      Top = 383
      Width = 81
      Height = 25
      Caption = 'Start search'
      TabOrder = 15
      OnClick = StartSearchButtonClick
    end
    object StartReplaceButton: TButton
      Left = 103
      Top = 383
      Width = 81
      Height = 25
      Caption = 'Start replace'
      TabOrder = 16
      OnClick = StartReplaceButtonClick
    end
    object EditorValueMemo: TMemo
      Left = 13
      Top = 433
      Width = 198
      Height = 113
      Anchors = [akTop, akRight]
      Lines.Strings = (
        ''
        'function foo () {'
        '  alert('#39'foo'#39');'
        '}')
      ScrollBars = ssVertical
      TabOrder = 17
    end
    object SetValueButton: TButton
      Left = 217
      Top = 431
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Set value'
      TabOrder = 18
      OnClick = SetValueButtonClick
    end
    object InsertTextButton: TButton
      Left = 217
      Top = 462
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Insert text'
      TabOrder = 19
      OnClick = InsertTextButtonClick
    end
    object GetValueButton: TButton
      Left = 217
      Top = 493
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Get value'
      TabOrder = 20
      OnClick = GetValueButtonClick
    end
  end
  object EventsPanel: TPanel
    Left = 0
    Top = 548
    Width = 1029
    Height = 150
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      1029
      150)
    object EventsLabel: TLabel
      Left = 8
      Top = 5
      Width = 33
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Events'
      ExplicitTop = 109
    end
    object EventsMemo: TMemo
      Left = 8
      Top = 24
      Width = 1002
      Height = 113
      Anchors = [akLeft, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = EventsMemoChange
    end
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = OpenFileAction
                Caption = '&Open file...'
                ImageIndex = 7
              end
              item
                Action = SaveAsAction
                Caption = '&Save file...'
                ImageIndex = 30
              end>
            Caption = '&File'
          end
          item
            Items = <
              item
                Action = OpenDevConsoleAction
                Caption = '&Open developer console'
              end>
            Caption = '&Debug'
          end>
        ActionBar = ActionMainMenuBar
      end>
    Left = 352
    Top = 144
    StyleName = 'Platform Default'
    object OpenDevConsoleAction: TAction
      Category = 'Debug'
      Caption = 'Open developer console'
      OnExecute = OpenDevConsoleActionExecute
    end
    object SaveAsAction: TFileSaveAs
      Category = 'File'
      Caption = 'Save file...'
      Hint = 'Save As|Saves the active file with a new name'
      ImageIndex = 30
      OnAccept = SaveAsActionAccept
    end
    object OpenFileAction: TFileOpen
      Category = 'File'
      Caption = 'Open file...'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      OnAccept = OpenFileActionAccept
    end
  end
end
