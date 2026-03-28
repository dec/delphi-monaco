(*
 Delphi library for Monaco Editor

 Copyright (c) DecSoft Utils

 https://www.decsoftutils.com/

 MIT license

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*)

unit DecSoft.Monaco.Editor;

interface

uses
  // Delphi
  Vcl.Controls,
  System.SysUtils,

  // DecSoft
  DecSoft.Monaco.Editor.Types,
  DecSoft.Monaco.Editor.Events,
  DecSoft.Monaco.Editor.Options,
  DecSoft.Monaco.Editor.MonacoBrowserForm;

type
  TMonacoEditor = class(TObject)
  private
    FStarted: Boolean;
    FParent: TWinControl;
    FEditorDirPath: string;
    FLocaleLanguage: string;
    FInDropFileEvent: Boolean;
    FOptions: TMonacoEditorOptions;
    FLanguagesCache: TArray<string>;
    FBrowserForm: TMonacoBrowserForm;
  private
    FOnKeyUp: TMonacoEditorKeyEvent;
    FOnKeyDown: TMonacoEditorKeyEvent;
    FOnCreated: TMonacoEditorCreatedEvent;
    FOnDropFile: TMonacoEditorDropFileEvent;
    FOnNewWindow: TMonacoEditorNewWindowEvent;
    FOnOpenedFile: TMonacoEditorOpenedFileEvent;
  private
    procedure DoExecAction(const ActionID: string);
    procedure SetEditorDirPath(const EditorDirPath: string);
    procedure DoSetValue(const Value: string; SetValueProc: TMonacoEditorSetValueProc);
  public
    constructor Create(Parent: TWinControl);
    destructor Destroy(); override;
  public
    procedure NotifyDropFileEvent();
    procedure NotityNewWindowEvent(const URI: string);
  public
    procedure Start();
    procedure SetFocus();
    procedure UpdateOptions();
    procedure OpenDevConsole();
    procedure ExecStartFindAction();
    procedure ExecQuickCommandAction();
    procedure ExecStartFindReplaceAction();
    procedure ExecAction(const ActionID: string);
    procedure SetJSExtraLibs(const Content: string);
    procedure GetValue(GetValueProc: TMonacoEditorGetValueProc);
    procedure GetLanguages(GetLanguagesProc: TMonacoEditorGetLanguagesProc);
    procedure SetValue(const Value: string; SetValueProc: TMonacoEditorSetValueProc);
    procedure InsertText(const Text: string; InsertTextProc: TMonacoEditorInsertTextProc);
    procedure SaveToFile(const FileName: TFileName; SavedFileProc: TMonacoEditorSavedFileProc);
    procedure LoadFromFile(const FileName: TFileName; OpenedFileProc: TMonacoEditorOpenedFileProc);
    procedure Search(const Query: string; const ShowDialog, IsRegExp, MatchCase, WholeWords: Boolean; SearchProc: TMonacoEditorSearchProc);
    procedure RegisterCompletions(const Language: string; CompletionsJSON: string; RegisterCompletions: TMonacoEditorRegisterCompletionsProc);
  public
    property OnKeyUp: TMonacoEditorKeyEvent read FOnKeyUp write FOnKeyUp;
    property OnKeyDown: TMonacoEditorKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnCreated: TMonacoEditorCreatedEvent read FOnCreated write FOnCreated;
    property OnDropFile: TMonacoEditorDropFileEvent read FOnDropFile write FOnDropFile;
    property OnNewWindow: TMonacoEditorNewWindowEvent read FOnNewWindow write FOnNewWindow;
    property OnOpenedFile: TMonacoEditorOpenedFileEvent read FOnOpenedFile write FOnOpenedFile;
  public
    property Parent: TWinControl read FParent;
    property Browser: TMonacoBrowserForm read FBrowserForm;
    property Options: TMonacoEditorOptions read FOptions write FOptions;
    property EditorDirPath: string read FEditorDirPath write SetEditorDirPath;
    property LocaleLanguage: string read FLocaleLanguage write FLocaleLanguage;
  end;

implementation

uses
  // Delphi
  System.JSON,
  System.Classes,

  // WebView4Delphi
  uWVTypeLibrary,

  // DecSoft
  DecSoft.Monaco.Editor.SysUtils,
  DecSoft.Monaco.Editor.Constants,
  DecSoft.Monaco.Editor.UTF8NBEncoding;

{ TMonacoEditor }

constructor TMonacoEditor.Create(Parent: TWinControl);
begin
  inherited Create();

  FStarted := False;
  FLanguagesCache := [];
  FInDropFileEvent := False;

  FParent := Parent;
  FLocaleLanguage := TMonacoEditorConstants.EditorDefaultLocaleLanguage;

  FEditorDirPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) +
   TMonacoEditorConstants.EditorFolderName);

  FOptions := TMonacoEditorOptions.Create();
  FBrowserForm := TMonacoBrowserForm.Create(Self);
  FBrowserForm.Parent := Parent;
  FBrowserForm.Visible := True;
end;

destructor TMonacoEditor.Destroy();
begin
  FOptions.Free();
  FBrowserForm.Free();

  inherited Destroy();
end;

procedure TMonacoEditor.NotifyDropFileEvent();
begin
  FInDropFileEvent := True;
end;

procedure TMonacoEditor.NotityNewWindowEvent(const URI: string);
var
  Handled: Boolean;
  FileName: TFileName;
begin
  Handled := False;

  if FInDropFileEvent then
  begin
    FInDropFileEvent := False;

    FileName := StringReplace(URI, 'file:///', '', []);
    FileName := StringReplace(FileName, '/', '\', [rfReplaceAll]);

    if FOptions.AllowDropFiles and Assigned(FOnDropFile) then
      FOnDropFile(Self, FileName);

    Exit;
  end;

  if Assigned(FOnNewWindow) then
    FOnNewWindow(Self, URI, Handled);

  if not Handled then
    TMonacoEditorSysUtils.ShellOpen(URI);
end;

procedure TMonacoEditor.Start();
begin
  if not FStarted then
  begin
    FStarted := True;

    FBrowserForm.StartPageURL := FEditorDirPath +
     TMonacoEditorConstants.EditorFileName;

    FBrowserForm.InitializeBrowser();
  end;
end;

procedure TMonacoEditor.UpdateOptions();
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  FBrowserForm.Browser.ExecuteScript(Format(
   TMonacoEditorConstants.EditorUpdateOptionsFunction,
    [FOptions.ToJSONString]));
end;

procedure TMonacoEditor.GetValue(GetValueProc: TMonacoEditorGetValueProc);
begin
  if not FBrowserForm.EditorCreated or not Assigned(GetValueProc) then
    Exit;

  FBrowserForm.Browser.CoreWebView2.BaseIntf.ExecuteScript(
    PWideChar(TMonacoEditorConstants.EditorGetValueFunction),
    ICoreWebView2ExecuteScriptCompletedHandler(
      function (errorCode: HResult; resultObjectAsJson: PWideChar): HResult stdcall
      var
        JSON: TJSONValue;
      begin
        Result := S_OK;
        JSON := TJSONObject.ParseJSONValue(ResultObjectAsJson);
        try
          GetValueProc(Self, JSON.Value);
        finally
          JSON.Free();
        end;
      end));
end;

procedure TMonacoEditor.InsertText(const Text: string;
  InsertTextProc: TMonacoEditorInsertTextProc);
var
  JSONObject: TJSONObject;
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  JSONObject := TJSONObject.Create();
  try
    JSONObject.AddPair('text', Text);

    FBrowserForm.Browser.CoreWebView2.BaseIntf.ExecuteScript(
      PWideChar(Format(TMonacoEditorConstants.EditorInsertTextFunction, [JSONObject.ToString()])),
      ICoreWebView2ExecuteScriptCompletedHandler(
        function (errorCode: HResult; resultObjectAsJson: PWideChar): HResult stdcall
        begin
         Result := S_OK;

         if Assigned(InsertTextProc) then
           InsertTextProc(Self);
        end));

  finally
    JSONObject.Free();
  end;
end;

procedure TMonacoEditor.GetLanguages(GetLanguagesProc:
 TMonacoEditorGetLanguagesProc);
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  if Length(FLanguagesCache) > 0 then
  begin
    if Assigned(GetLanguagesProc) then
      GetLanguagesProc(Self, FLanguagesCache);
    Exit;
  end;

  FBrowserForm.Browser.CoreWebView2.BaseIntf.ExecuteScript(
    PWideChar(TMonacoEditorConstants.EditorGetLanguagesFunction),
    ICoreWebView2ExecuteScriptCompletedHandler(
      function (errorCode: HResult; resultObjectAsJson: PWideChar): HResult stdcall
      var
        JSONArray: TJSONArray;
        ArrayItem: TJSONValue;
      begin
        Result := S_OK;

       JSONArray := TJSONObject.ParseJSONValue(ResultObjectAsJson) as TJSONArray;
       try
         for ArrayItem in JSONArray do
           FLanguagesCache := FLanguagesCache + [ArrayItem.Value];

         if Assigned(GetLanguagesProc) then
           GetLanguagesProc(Self, FLanguagesCache);

       finally
         JSONArray.Free();
       end;
      end));
end;

procedure TMonacoEditor.SaveToFile(const FileName: TFileName;
 SavedFileProc: TMonacoEditorSavedFileProc);
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  Self.GetValue(
    procedure (Sender: TObject; const Value: string)
    var
      FileContents: TStrings;
    begin
      FileContents := TStringList.Create();
      try
        FileContents.Text := Value;
        FileContents.SaveToFile(FileName, MonacoEditorUTF8NBEncoding);

        if Assigned(SavedFileProc) then
          SavedFileProc(Self);

      finally
        FileContents.Free();
      end;
    end);
end;

procedure TMonacoEditor.ExecAction(const ActionID: string);
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  Self.DoExecAction(ActionID);
end;

procedure TMonacoEditor.DoExecAction(const ActionID: string);
var
  JSONObject: TJSONObject;
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  JSONObject := TJSONObject.Create();
  try
    JSONObject.AddPair('id', ActionID);

    FBrowserForm.Browser.ExecuteScript(Format(
     TMonacoEditorConstants.EditorExecActionFunction,
      [JSONObject.ToString()]));

  finally
    JSONObject.Free();
  end;
end;

procedure TMonacoEditor.DoSetValue(const Value: string;
  SetValueProc: TMonacoEditorSetValueProc);
var
  JSONObject: TJSONObject;
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  JSONObject := TJSONObject.Create();
  try
    JSONObject.AddPair('value', Value);

    FBrowserForm.Browser.CoreWebView2.BaseIntf.ExecuteScript(
      PWideChar(Format(TMonacoEditorConstants.EditorSetValueFunction, [JSONObject.ToString()])),
      ICoreWebView2ExecuteScriptCompletedHandler(
        function (errorCode: HResult; resultObjectAsJson: PWideChar): HResult stdcall
        begin
          Result := S_OK;

          if Assigned(SetValueProc) then
            SetValueProc(Self);
        end));

  finally
    JSONObject.Free();
  end;
end;

procedure TMonacoEditor.Search(const Query: string; const ShowDialog, IsRegExp,
 MatchCase, WholeWords: Boolean; SearchProc: TMonacoEditorSearchProc);
var
  JSONObject: TJSONObject;
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  JSONObject := TJSONObject.Create();
  try
    JSONObject.AddPair('query', Query);
    JSONObject.AddPair('is_regex', TJSONBool.Create(IsRegExp));
    JSONObject.AddPair('match_case', TJSONBool.Create(MatchCase));
    JSONObject.AddPair('whole_words', TJSONBool.Create(WholeWords));
    JSONObject.AddPair('show_dialog', TJSONBool.Create(ShowDialog));

    FBrowserForm.Browser.CoreWebView2.BaseIntf.ExecuteScript(
      PWideChar(Format(TMonacoEditorConstants.EditorSearchFunction, [JSONObject.ToString()])),
      ICoreWebView2ExecuteScriptCompletedHandler(
        function (errorCode: HResult; resultObjectAsJson: PWideChar): HResult stdcall
        begin
          Result := S_OK;

          if Assigned(SearchProc) then
            SearchProc(Self, ResultObjectAsJson = 'true');
        end));

  finally
    JSONObject.Free();
  end;
end;

procedure TMonacoEditor.SetEditorDirPath(const EditorDirPath: string);
begin
  if FEditorDirPath <> EditorDirPath then
    FEditorDirPath := IncludeTrailingPathDelimiter(EditorDirPath);
end;

procedure TMonacoEditor.SetFocus();
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  if FBrowserForm.BrowserWindow.CanFocus() then
    FBrowserForm.BrowserWindow.SetFocus();
end;

procedure TMonacoEditor.SetValue(const Value: string;
 SetValueProc: TMonacoEditorSetValueProc);
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  Self.DoSetValue(Value, SetValueProc);
end;

procedure TMonacoEditor.ExecStartFindAction();
begin
  Self.DoExecAction(TMonacoEditorConstants.EditorFindActionID);
end;

procedure TMonacoEditor.ExecQuickCommandAction();
begin
  Self.DoExecAction(TMonacoEditorConstants.EditorQuickCommandActionID);
end;

procedure TMonacoEditor.ExecStartFindReplaceAction();
begin
  Self.DoExecAction(TMonacoEditorConstants.EditorStartFindReplaceActionID);
end;

procedure TMonacoEditor.LoadFromFile(const FileName: TFileName;
 OpenedFileProc: TMonacoEditorOpenedFileProc);
var
  FileContents: TStrings;
begin
  if not FBrowserForm.EditorCreated or not FileExists(FileName) then
    Exit;

  FileContents := TStringList.Create();
  try

    FileContents.LoadFromFile(FileName);

    Self.DoSetValue(
      FileContents.Text,
      procedure (Sender: TObject)
      begin
        if Assigned(OpenedFileProc) then
          OpenedFileProc(Self);
      end);

  finally
    FileContents.Free();
  end;
end;

procedure TMonacoEditor.SetJSExtraLibs(const Content: string);
var
  JSONObject: TJSONObject;
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  JSONObject := TJSONObject.Create();
  try
    JSONObject.AddPair('value', Content);

    FBrowserForm.Browser.ExecuteScript(Format(
     TMonacoEditorConstants.EditorSetJSExtraLibsFunction,
      [JSONObject.ToString()]));

  finally
    JSONObject.Free();
  end;
end;

procedure TMonacoEditor.OpenDevConsole();
begin
  if FBrowserForm.BrowserLoaded then
    FBrowserForm.Browser.OpenDevToolsWindow();
end;

procedure TMonacoEditor.RegisterCompletions(const Language: string;
 CompletionsJSON: string; RegisterCompletions:
  TMonacoEditorRegisterCompletionsProc);
begin
  if not FBrowserForm.EditorCreated then
    Exit;

  FBrowserForm.Browser.CoreWebView2.BaseIntf.ExecuteScript(
    PWideChar(Format(TMonacoEditorConstants.EditorRegisterCompletionsFunction, [Language, CompletionsJSON])),
    ICoreWebView2ExecuteScriptCompletedHandler(
      function (errorCode: HResult; resultObjectAsJson: PWideChar): HResult stdcall
      begin
        Result := S_OK;

        if Assigned(RegisterCompletions) then
          RegisterCompletions(Self);
      end));
end;

end.
