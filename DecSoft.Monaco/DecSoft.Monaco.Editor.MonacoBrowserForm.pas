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

unit DecSoft.Monaco.Editor.MonacoBrowserForm;

interface

uses
  // Delphi
  Vcl.Forms,
  Vcl.ExtCtrls,
  System.Classes,
  Vcl.Controls,
  Winapi.Messages,

  // WebView4Delphi
  uWVLoader,
  uWVBrowser,
  uWVWinControl,
  uWVTypeLibrary,
  uWVBrowserBase,
  uWVWindowParent;

type
  TMonacoBrowserForm = class(TForm)
    Browser: TWVBrowser;
    BrowserTimer: TTimer;
    BrowserWindow: TWVWindowParent;
    procedure BrowserAfterCreated(Sender: TObject);
    procedure BrowserWebMessageReceived(Sender: TObject; const aWebView: ICoreWebView2; const aArgs: ICoreWebView2WebMessageReceivedEventArgs);
    procedure BrowserNewWindowRequested(Sender: TObject; const aWebView: ICoreWebView2; const aArgs: ICoreWebView2NewWindowRequestedEventArgs);
    procedure BrowserNavigationCompleted(Sender: TObject; const aWebView: ICoreWebView2; const aArgs: ICoreWebView2NavigationCompletedEventArgs);
    procedure BrowserPermissionRequested(Sender: TObject; const aWebView: ICoreWebView2; const aArgs: ICoreWebView2PermissionRequestedEventArgs);
    procedure FormDestroy(Sender: TObject);
  private
    FEditor: TObject;
    FStartPageURL: string;
    FEditorCreated: Boolean;
    FBrowserLoaded: Boolean;
    // https://github.com/salvadordf/WebView4Delphi/issues/13#issuecomment-1009469854
    FTemporalForm: TForm;
    FRestoreHandle: Boolean;
  private
    procedure ChangeParent();
    procedure RestoreParent();
    procedure AddScriptOnDocument();
    procedure PrepareLocaleLanguage();
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
  public
    constructor Create(Editor: TObject); reintroduce; overload;
  public
    procedure InitializeBrowser();
  public
    property EditorCreated: Boolean read FEditorCreated;
    property BrowserLoaded: Boolean read FBrowserLoaded;
    property StartPageURL: string read FStartPageURL write FStartPageURL;
  end;

implementation

{$R *.dfm}

uses
  // Delphi
  System.JSON,
  Vcl.Dialogs,
  System.SysUtils,

  // DecSoft
  DecSoft.Monaco.Editor,
  DecSoft.Monaco.Editor.Constants,
  DecSoft.Monaco.Editor.UTF8NBEncoding;

constructor TMonacoBrowserForm.Create(Editor: TObject);
begin
  inherited Create(nil);

  FEditor := Editor;
  FEditorCreated := False;
  FBrowserLoaded := False;

  // So we do not forget to set this at design time
  Self.BrowserWindow.Browser := Self.Browser;

  // So we do not forget to set this at design time
  Self.Browser.DefaultURL := TMonacoEditorConstants.EditorVirtualHostDefaultUrl;

  FTemporalForm := nil;
  FRestoreHandle := False;
end;

procedure TMonacoBrowserForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FTemporalForm) then
    FreeAndNil(FTemporalForm);
end;

procedure TMonacoBrowserForm.InitializeBrowser();
begin
  if GlobalWebView2Loader.InitializationError then
    ShowMessage(GlobalWebView2Loader.ErrorMessage)
  else
    if GlobalWebView2Loader.Initialized then
      Browser.CreateBrowser(BrowserWindow.Handle)
    else
      BrowserTimer.Enabled := True;
end;

procedure TMonacoBrowserForm.WMMove(var aMessage: TWMMove);
begin
  inherited;

  if (Browser <> nil) then
    Browser.NotifyParentWindowPositionChanged;
end;

procedure TMonacoBrowserForm.WMMoving(var aMessage: TMessage);
begin
  inherited;

  if (Browser <> nil) then
    Browser.NotifyParentWindowPositionChanged;
end;

procedure TMonacoBrowserForm.WndProc(var Message: TMessage);
begin
  inherited;

  if csDestroying in Self.ComponentState then
    Exit;

  if (csRecreating in ControlState) then
    Self.ChangeParent()
  else if FRestoreHandle then
    Self.RestoreParent();
end;

procedure TMonacoBrowserForm.ChangeParent();
begin
  if csDestroying in Self.ComponentState then
    Exit;

  if (Browser <> nil) and (Browser.Initialized) then
  begin
    if not Assigned(FTemporalForm) then
    begin
      FTemporalForm := TForm.Create(nil);
    end;
    if FTemporalForm.Handle <> Browser.ParentWindow then
      Browser.ParentWindow := FTemporalForm.Handle;
    FRestoreHandle := True;
  end;
end;

procedure TMonacoBrowserForm.RestoreParent();
begin
  if csDestroying in Self.ComponentState then
    Exit;

  if (Browser <> nil ) and FRestoreHandle and Browser.Initialized then
  begin
    if Browser.ParentWindow <> BrowserWindow.Handle then
    begin
      Browser.ParentWindow := BrowserWindow.Handle;
      Browser.NotifyParentWindowPositionChanged;
      BrowserWindow.UpdateSize;
    end;
    FRestoreHandle := False;
    if Assigned(FTemporalForm) then
      FreeAndNil(FTemporalForm);
  end;
end;

procedure TMonacoBrowserForm.BrowserAfterCreated(Sender: TObject);
begin
  BrowserWindow.UpdateSize();

  Self.AddScriptOnDocument();

  if (TMonacoEditor(FEditor).LocaleLanguage <>
   TMonacoEditorConstants.EditorDefaultLocaleLanguage) then
  begin
    Self.PrepareLocaleLanguage();
  end;

  if BrowserWindow.CanFocus() then
    BrowserWindow.SetFocus;

  // Probably we can use options to set this values
  Browser.CoreWebView2Settings.IsScriptEnabled := True;
  Browser.CoreWebView2Settings.IsWebMessageEnabled := True;
  Browser.CoreWebView2Settings.AreDevToolsEnabled := False;
  Browser.CoreWebView2Settings.IsPinchZoomEnabled := False;
  Browser.CoreWebView2Settings.IsStatusBarEnabled := False;
  Browser.CoreWebView2Settings.IsZoomControlEnabled := False;
  Browser.CoreWebView2Settings.IsBuiltInErrorPageEnabled := True;
  Browser.CoreWebView2Settings.IsSwipeNavigationEnabled := False;
  Browser.CoreWebView2Settings.IsGeneralAutofillEnabled := False;
  Browser.CoreWebView2Settings.IsPasswordAutosaveEnabled := False;
  Browser.CoreWebView2Settings.IsReputationCheckingRequired := False;
  Browser.CoreWebView2Settings.AreDefaultScriptDialogsEnabled := True;
  Browser.CoreWebView2Settings.AreDefaultContextMenusEnabled := False;
  Browser.CoreWebView2Settings.AreBrowserAcceleratorKeysEnabled := False;
  Browser.CoreWebView2Settings.HiddenPdfToolbarItems := COREWEBVIEW2_PDF_TOOLBAR_ITEMS_NONE;

  // Do the magic
  Browser.SetVirtualHostNameToFolderMapping(
   TMonacoEditorConstants.EditorVirtualHostName,
    ExtractFileDir(FStartPageURL),
     COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND_ALLOW);
end;

procedure TMonacoBrowserForm.BrowserNavigationCompleted(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2NavigationCompletedEventArgs);
begin
  // Start the HTML / JavaScript editor
  Browser.ExecuteScript(Format(
    TMonacoEditorConstants.EditorStartLocalFunction,
    [TMonacoEditor(FEditor).Options.ToJSONString]));

  FBrowserLoaded := True;
end;

procedure TMonacoBrowserForm.PrepareLocaleLanguage();
var
  LocaleFileContents: TStrings;
  JSCode, LocaleFilePath: string;
begin
  LocaleFilePath := TMonacoEditor(FEditor).EditorDirPath +
   Format('nls.messages.%s.js',
    [LowerCase(TMonacoEditor(FEditor).LocaleLanguage)]);

  if not FileExists(LocaleFilePath) then
    Exit;

  LocaleFileContents := TStringList.Create();
  try
    LocaleFileContents.LoadFromFile(LocaleFilePath, MonacoEditorUTF8NBEncoding);

    JSCode := 'const localeScript = document.createElement("script");';
    JSCode := JSCode + Format('localeScript.innerText = %s;', [LocaleFileContents.Text]);

    Browser.AddScriptToExecuteOnDocumentCreated(JSCode);

  finally
    LocaleFileContents.Free();
  end;
end;

procedure TMonacoBrowserForm.BrowserNewWindowRequested(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2NewWindowRequestedEventArgs);
var
  URI: PWideChar;
  Editor: TMonacoEditor;
begin
  URI := '';
  Editor := TMonacoEditor(FEditor);

  aArgs.Get_uri(URI);
  aArgs.Set_Handled(Integer(LongBool(True)));
  Editor.NotityNewWindowEvent(URI);
end;

procedure TMonacoBrowserForm.BrowserPermissionRequested(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2PermissionRequestedEventArgs);
begin
  var State: COREWEBVIEW2_PERMISSION_STATE;
  State := COREWEBVIEW2_PERMISSION_STATE_ALLOW;
  aArgs.Set_State(State);
end;

procedure TMonacoBrowserForm.BrowserWebMessageReceived(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2WebMessageReceivedEventArgs);
var
  UUID: string;
  Msg: PWideChar;
  MsgID: Integer;
  Editor: TMonacoEditor;
  OutputJSON: TJSONObject;
  InputJSON, Data: TJSONValue;
begin

  Msg := ''; // Very important!
  Editor := TMonacoEditor(FEditor);
  aArgs.TryGetWebMessageAsString(Msg);

  // From Monaco Editor v0.53 (maybe only on this version?) sometimes,
	// erratically, we get an error while initialize the editor: here we
	// catch that error and inform the host that the browser view must
	// be initialized again.
  if (Msg = 'editor-error') then
  begin
    // Self.InitializeBrowser(); This (at least alone) will not do the job...
    ShowMessage('An editor error occur!');
    Exit;
  end;

  if (Msg = 'editor-browser-clicked') then
  begin
    if Editor.Parent.CanFocus then
    begin
      Editor.Parent.SetFocus();
      Editor.SetFocus();
    end;
    Exit;
  end;

  aArgs.Get_webMessageAsJson(Msg);

  OutputJSON := TJSONObject.Create();
  InputJSON := TJSONObject.ParseJSONValue(Msg);
  try

    UUID := InputJSON.GetValue<string>('uuid');
    MsgID := InputJSON.GetValue<Integer>('id');
    Data := InputJSON.GetValue<TJSONObject>('data');

    case MsgID of
      TMonacoEditorConstants.EditorOnCreatedEventMsgId:
      begin
        FEditorCreated := True;
        if Assigned(Editor.OnCreated) then
          Editor.OnCreated(Editor);
      end;
      TMonacoEditorConstants.EditorOnKeyUpEventMsgId:
      begin
        if Assigned(Editor.OnKeyUp) then
          Editor.OnKeyUp(Editor, Data.GetValue<TJSONObject>('event').ToJSON());
      end;
      TMonacoEditorConstants.EditorOnKeyDownEventMsgId:
      begin
        if Assigned(Editor.OnKeyDown) then
          Editor.OnKeyDown(Editor, Data.GetValue<TJSONObject>('event').ToJSON());
      end;
      TMonacoEditorConstants.EditorOnDropFileEventMsgId:
      begin
        Editor.NotifyDropFileEvent();
      end;
    end;

  finally
    InputJSON.Free();
    OutputJSON.Free();
  end;
end;

procedure TMonacoBrowserForm.AddScriptOnDocument();
var
  JSCode: string;
begin
  // When the HTML window load...
  JSCode := 'window.addEventListener("load", function() { ';

  // Set the focus to the editor's parent and then the editor itself
  JSCode := JSCode + ' window.addEventListener("click", (e) => { window.chrome.webview.postMessage("editor-browser-clicked"); });';

  // Close the window load event
  JSCode := JSCode + ' });';

  Browser.AddScriptToExecuteOnDocumentCreated(JSCode);
end;

end.
