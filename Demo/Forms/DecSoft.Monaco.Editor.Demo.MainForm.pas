unit DecSoft.Monaco.Editor.Demo.MainForm;

interface

uses
  // Delphi
  Vcl.Forms,
  Vcl.ToolWin,
  Vcl.ActnMan,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.StdActns,
  Vcl.ActnList,
  Vcl.Controls,
  Vcl.ActnCtrls,
  Vcl.ActnMenus,
  System.Classes,
  System.Actions,
  System.SysUtils,
  Vcl.PlatformDefaultStyleActnCtrls,

  // DecSoft
  DecSoft.Monaco.Editor;

type
  TMainForm = class(TForm)
    EventsMemo: TMemo;
    ThemeLabel: TLabel;
    EventsPanel: TPanel;
    EventsLabel: TLabel;
    OptionsPanel: TPanel;
    StatusBar: TStatusBar;
    LanguageLabel: TLabel;
    SearchButton: TButton;
    PlaceholderEdit: TEdit;
    SearchQueryEdit: TEdit;
    EditorValueMemo: TMemo;
    SetValueButton: TButton;
    GetValueButton: TButton;
    ThemeComboBox: TComboBox;
    InsertTextButton: TButton;
    SaveAsAction: TFileSaveAs;
    OpenFileAction: TFileOpen;
    StartSearchButton: TButton;
    StartReplaceButton: TButton;
    LanguageComboBox: TComboBox;
    ReadOnlyCheckBox: TCheckBox;
    WordWrapCheckBox: TCheckBox;
    ActionManager: TActionManager;
    OpenDevConsoleAction: TAction;
    LineNumbersCheckBox: TCheckBox;
    ContextMenuCheckBox: TCheckBox;
    SearchDialogCheckBox: TCheckBox;
    SearchRegExpCheckBox: TCheckBox;
    AllowDropFilesCheckBox: TCheckBox;
    SearchMatchCaseCheckBox: TCheckBox;
    SearchWholeWordsCheckBox: TCheckBox;
    HandleNewWindowsCheckBox: TCheckBox;
    ActionMainMenuBar: TActionMainMenuBar;
    procedure FormCreate(Sender: TObject);
    procedure EventsMemoChange(Sender: TObject);
    procedure SearchButtonClick(Sender: TObject);
    procedure SaveAsActionAccept(Sender: TObject);
    procedure GetValueButtonClick(Sender: TObject);
    procedure ThemeComboBoxChange(Sender: TObject);
    procedure SetValueButtonClick(Sender: TObject);
    procedure OpenFileActionAccept(Sender: TObject);
    procedure WordWrapCheckBoxClick(Sender: TObject);
    procedure PlaceholderEditChange(Sender: TObject);
    procedure ReadOnlyCheckBoxClick(Sender: TObject);
    procedure InsertTextButtonClick(Sender: TObject);
    procedure StartSearchButtonClick(Sender: TObject);
    procedure LanguageComboBoxChange(Sender: TObject);
    procedure StartReplaceButtonClick(Sender: TObject);
    procedure ContextMenuCheckBoxClick(Sender: TObject);
    procedure LineNumbersCheckBoxClick(Sender: TObject);
    procedure OpenDevConsoleActionExecute(Sender: TObject);
    procedure AllowDropFilesCheckBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FMonacoEditor: TMonacoEditor;
  private
    procedure EditorCreated(Sender: TObject);
    procedure EditorKeyUp(Sender: TObject; const EventJSON: string);
    procedure EditorKeyDown(Sender: TObject; const EventJSON: string);
    procedure EditorDropFile(Sender: TObject; const FileName: TFileName);
    procedure EditorNewWindow(Sender: TObject; const URI: string; var Handled: Boolean);
    procedure EditorOpenedFile(Sender: TObject; const FileName: TFileName; const Language: string);
  private
    function GetMonacoEditorDirPath(): string;
  end;

var
  MainForm: TMainForm;

implementation

uses
  // Delphi
  System.JSON,
  System.IOUtils,
  System.UITypes,
  WinApi.Windows,
  Winapi.Messages;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin

  // Create the editor in this private variable.
  FMonacoEditor := TMonacoEditor.Create(Self);

  // Attach various events to the editor.
  FMonacoEditor.OnKeyUp := EditorKeyUp;
  FMonacoEditor.OnKeyDown := EditorKeyDown;
  FMonacoEditor.OnCreated := EditorCreated;
  FMonacoEditor.OnDropFile := EditorDropFile;
  FMonacoEditor.OnNewWindow := EditorNewWindow;
  FMonacoEditor.OnOpenedFile := EditorOpenedFile;

  (*
    The Monaco Editor HTML and JavaScript is by default expected to be
    in an "editor" folder aside the executable, but, it's possible to
    specify any desired path to it.
  *)
  FMonacoEditor.EditorDirPath := Self.GetMonacoEditorDirPath();

  (*
    It's possiblbe to start Monaco Editor without specifying a language,
    but, it's also possible to start it with a language, as we do here.

    Below in this demo we use also the "GetLanguages" method of TMonacoEditor,
    in order to get all the available languages.
  *)
  FMonacoEditor.Options.Language := 'javascript';

  // Set another options of the editor.
  FMonacoEditor.Options.Theme := ThemeComboBox.Text;
  FMonacoEditor.Options.Placeholder := PlaceholderEdit.Text;
  FMonacoEditor.Options.ReadOnly := ReadOnlyCheckBox.Checked;
  FMonacoEditor.Options.WordWrap := WordWrapCheckBox.Checked;
  FMonacoEditor.Options.LineNumbers := LineNumbersCheckBox.Checked;
  FMonacoEditor.Options.ContextMenu := ContextMenuCheckBox.Checked;
  FMonacoEditor.Options.AllowDropFiles := AllowDropFilesCheckBox.Checked;

  (*
    The language of the editor interface cannot be changed after the editor
    is started. The available languages are:

    en = English (By default)
    es = Spanish
    cs = Czech
    de = German
    fr = French
    it = Italian
    ja = Japanese
    ko = Korean
    pl = Portuguese
    pl = Polish
    pt-br = Brazilian Portuguese
    ru = Russian
    zh-cn = Chinese
    zh-tw = Chinese (Taiwan)
  *)
  FMonacoEditor.LocaleLanguage := 'es';

  // Start the editor with the above settings and options.
  FMonacoEditor.Start();
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMonacoEditor.Free();
end;

procedure TMainForm.OpenDevConsoleActionExecute(Sender: TObject);
begin
  // Just do it!
  FMonacoEditor.OpenDevConsole();
end;

procedure TMainForm.OpenFileActionAccept(Sender: TObject);
begin
  (*
    It's not implemented here, but, if we plain or neeed to open files,
    probably can be good to extract the language based on the file extension:
    so we can open the file, change the language and update the options.

    I am not sure if will implement something in the library for this.
  *)
  FMonacoEditor.LoadFromFile(
    (Sender as TFileOpen).Dialog.FileName,
    procedure (Sender: TObject)
    begin
      ShowMessage('File opened!');
    end);
end;

procedure TMainForm.PlaceholderEditChange(Sender: TObject);
begin
  FMonacoEditor.Options.Placeholder := PlaceholderEdit.Text;
  FMonacoEditor.UpdateOptions();
end;

procedure TMainForm.ReadOnlyCheckBoxClick(Sender: TObject);
begin
  FMonacoEditor.Options.ReadOnly := ReadOnlyCheckBox.Checked;
  FMonacoEditor.UpdateOptions();
end;

procedure TMainForm.AllowDropFilesCheckBoxClick(Sender: TObject);
begin
  FMonacoEditor.Options.AllowDropFiles := AllowDropFilesCheckBox.Checked;
  // No need to update the options: this option is handled internally
end;

procedure TMainForm.SetValueButtonClick(Sender: TObject);
begin
  FMonacoEditor.SetValue(EditorValueMemo.Text,
   procedure (Sender: TObject)
   begin
     FMonacoEditor.SetFocus();
   end);
end;

procedure TMainForm.SaveAsActionAccept(Sender: TObject);
begin
  FMonacoEditor.SaveToFile(
   (Sender as TFileSaveAs).Dialog.FileName,
   procedure (Sender: TObject)
   begin
     ShowMessage('The file has been saved!');
   end);
end;

procedure TMainForm.SearchButtonClick(Sender: TObject);
begin
  if Trim(SearchQueryEdit.Text) = '' then
  begin
    SearchQueryEdit.SetFocus();
    Exit;
  end;

  FMonacoEditor.Search(
   SearchQueryEdit.Text,
   SearchDialogCheckBox.Checked,
   SearchRegExpCheckBox.Checked,
   SearchMatchCaseCheckBox.Checked,
   SearchWholeWordsCheckBox.Checked,
   procedure (Sender: TObject; const Found: Boolean)
   begin
     if not Found then
       ShowMessage('No results found');

     FMonacoEditor.SetFocus();
   end);
end;

procedure TMainForm.StartReplaceButtonClick(Sender: TObject);
begin
  FMonacoEditor.ExecStartFindReplaceAction();
end;

procedure TMainForm.StartSearchButtonClick(Sender: TObject);
begin
  FMonacoEditor.ExecStartFindAction();
end;

procedure TMainForm.ContextMenuCheckBoxClick(Sender: TObject);
begin
  FMonacoEditor.Options.ContextMenu := ContextMenuCheckBox.Checked;
  FMonacoEditor.UpdateOptions();
end;

procedure TMainForm.EditorKeyDown(Sender: TObject;
  const EventJSON: string);
begin
  EventsMemo.Lines.Add(Format('OnKeyDown - %s', [EventJSON]));
end;

procedure TMainForm.EditorKeyUp(Sender: TObject;
 const EventJSON: string);
begin
  EventsMemo.Lines.Add(Format('OnKeyUp - %s', [EventJSON]));
end;

procedure TMainForm.EditorCreated(Sender: TObject);
var
  LanguageIndex: Integer;
  Completions: TJSONArray;
  CompletionItem: TJSONObject;
  CompletionsFile: TStrings;
  CompletionsJSON: string;
  DeclarationsFile: TStrings;
begin
  EventsMemo.Lines.Add('OnCreated');

  FMonacoEditor.GetLanguages(
   procedure (Sender: TObject; const Languages: TArray<string>)
   var
     Language: string;
   begin
     for Language in Languages do
       LanguageComboBox.Items.Add(Language);

     LanguageIndex := LanguageComboBox.Items.IndexOf(
      FMonacoEditor.Options.Language);

     if LanguageIndex <> -1 then
     begin
       LanguageComboBox.ItemIndex := LanguageIndex;
     end;
   end);

  (*
    Register declarations for a language can only be done one time: it's our
    duty to prepare all the declarations that we needed for that language.
    You can call to the register method more than one time, but, the latest
    call overwrite previosly registered declarations (if any).
  *)
  DeclarationsFile := TStringList.Create();
  try
    DeclarationsFile.LoadFromFile(TDirectory.GetParent(
     TDirectory.GetParent(ParamStr(0))) + '\JS\declarations.d.ts');

    FMonacoEditor.SetJSExtraLibs(
     DeclarationsFile.Text
    );

  finally
    DeclarationsFile.Free();
  end;

  (*
    Register completions for a language can only be done one time: it's our
    duty to prepare all the completions that you need for that language.
    We can call to the register method more than one time, but, the latest
    call overwrite previosly registered completions (if any).

    On the other hand, work with JSON in Delphi can be painful. For this
    reason the Monaco Editor Delphi library deal directly with JSON as string
    so you can choose any Delphi JSON library to deal with it and finally
    provide the JSON string that the editor expected.
  *)
  CompletionsFile := TStringList.Create();
  try
    CompletionsFile.LoadFromFile(TDirectory.GetParent(
     TDirectory.GetParent(ParamStr(0))) + '\JS\completions.json');

    CompletionsJSON := CompletionsFile.Text;
  finally
    CompletionsFile.Free();
  end;

  CompletionItem := TJSONObject.Create();
  Completions := TJSONObject.ParseJSONValue(CompletionsJSON) as TJSONArray;

  // Add a completion item "manually" (not from a file)
  CompletionItem.AddPair('label', 'alertExFromItem');
  CompletionItem.AddPair('detail', 'function alertExFromItem(message: string): void');
  CompletionItem.AddPair('documentation', 'This is a new alert function for JavaScript');
  CompletionItem.AddPair('insertText', 'alertExFromItem("${1:message}");');
  CompletionItem.AddPair('kind', 'Method');

  Completions.Add(CompletionItem);

  FMonacoEditor.RegisterCompletions(
    'javascript',
    Completions.ToJSON(),
    procedure (Sender: TObject)
    begin
      Completions.Free();
    end);

  FMonacoEditor.OpenDevConsole();
end;

procedure TMainForm.EditorDropFile(Sender: TObject; const FileName: TFileName);
begin
  EventsMemo.Lines.Add(Format('OnDropFile: %s', [FileName]));
end;

procedure TMainForm.EditorNewWindow(Sender: TObject; const URI: string;
  var Handled: Boolean);
begin
  EventsMemo.Lines.Add(Format('OnNewWindow: %s', [URI]));

  if HandleNewWindowsCheckBox.Checked then
  begin
    Handled := True;
    ShowMessageFmt('You handle new window URI: %s', [URI])
  end;

end;

procedure TMainForm.EditorOpenedFile(Sender: TObject; const FileName: TFileName;
  const Language: string);
begin
  if Language = '' then
    LanguageComboBox.ItemIndex := 0
  else
    LanguageComboBox.ItemIndex := LanguageComboBox.Items.IndexOf(Language);

  EventsMemo.Lines.Add(Format('OnOpenedFile: FileName: %s - Language: %s',
   [FileName, Language]));
end;

procedure TMainForm.EventsMemoChange(Sender: TObject);
begin
  SendMessage(EventsMemo.Handle, EM_LINESCROLL, 0, EventsMemo.Lines.Count);
end;

function TMainForm.GetMonacoEditorDirPath(): string;
begin
  Result := IncludeTrailingPathDelimiter(TDirectory.GetParent(
   TDirectory.GetParent(ExtractFileDir(ParamStr(0))))) +
    'DecSoft.Monaco\editor\';
end;

procedure TMainForm.GetValueButtonClick(Sender: TObject);
begin
  FMonacoEditor.GetValue(
   procedure (Sender: TObject; const Value: string)
   begin
     ShowMessage(Value);
   end);
end;

procedure TMainForm.InsertTextButtonClick(Sender: TObject);
begin
  FMonacoEditor.InsertText(EditorValueMemo.Text,
   procedure (Sender: TObject)
   begin
     FMonacoEditor.SetFocus();
   end);
end;

procedure TMainForm.LanguageComboBoxChange(Sender: TObject);
begin
  if LanguageComboBox.ItemIndex = 0 then
    FMonacoEditor.Options.Language := ''
  else
    FMonacoEditor.Options.Language := LanguageComboBox.Text;

  FMonacoEditor.UpdateOptions();
end;

procedure TMainForm.LineNumbersCheckBoxClick(Sender: TObject);
begin
  FMonacoEditor.Options.LineNumbers := LineNumbersCheckBox.Checked;
  FMonacoEditor.UpdateOptions();
end;

procedure TMainForm.ThemeComboBoxChange(Sender: TObject);
begin
  FMonacoEditor.Options.Theme := ThemeComboBox.Text;
  FMonacoEditor.UpdateOptions();
end;

procedure TMainForm.WordWrapCheckBoxClick(Sender: TObject);
begin
  FMonacoEditor.Options.WordWrap := WordWrapCheckBox.Checked;
  FMonacoEditor.UpdateOptions();
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
