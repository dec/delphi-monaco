program DecSoft.Monaco.Editor.Demo;

uses
  FastMM5,
  uWVLoader,
  Vcl.Forms,
  Winapi.Windows,
  System.IOUtils,
  System.SysUtils,
  DecSoft.Monaco.Editor in '..\DecSoft.Monaco\DecSoft.Monaco.Editor.pas',
  DecSoft.Monaco.Editor.Types in '..\DecSoft.Monaco\DecSoft.Monaco.Editor.Types.pas',
  DecSoft.Monaco.Editor.Events in '..\DecSoft.Monaco\DecSoft.Monaco.Editor.Events.pas',
  DecSoft.Monaco.Editor.Options in '..\DecSoft.Monaco\DecSoft.Monaco.Editor.Options.pas',
  DecSoft.Monaco.Editor.SysUtils in '..\DecSoft.Monaco\DecSoft.Monaco.Editor.SysUtils.pas',
  DecSoft.Monaco.Editor.Constants in '..\DecSoft.Monaco\DecSoft.Monaco.Editor.Constants.pas',
  DecSoft.Monaco.Editor.Demo.MainForm in 'Forms\DecSoft.Monaco.Editor.Demo.MainForm.pas' {MainForm},
  DecSoft.Monaco.Editor.UTF8NBEncoding in '..\DecSoft.Monaco\DecSoft.Monaco.Editor.UTF8NBEncoding.pas',
  DecSoft.Monaco.Editor.MonacoBrowserForm in '..\DecSoft.Monaco\DecSoft.Monaco.Editor.MonacoBrowserForm.pas' {MonacoBrowserForm};

{$R *.res}

var
  WebView2LoaderPath: string;

begin

  // This demonstrates that we can place the Webview dll where we wanted...

  {$IFDEF WIN32}
    WebView2LoaderPath := TDirectory.GetParent(TDirectory.GetParent(ParamStr(0))) + '\Dlls\Win32\WebView2Loader.dll';
  {$ENDIF}
  {$IFDEF WIN64}
    WebView2LoaderPath := TDirectory.GetParent(TDirectory.GetParent(ParamStr(0))) + '\Dlls\Win64\WebView2Loader.dll';
  {$ENDIF}

  // ... how we can check if the WebView dll is certainly the expected...

  if not TMonacoEditorSysUtils.WebView2IsInstalled(WebView2LoaderPath) then
  begin
    MessageBox(GetActiveWindow(),
     'This Demo cannot continue because the WebView2Loader.dll is missing or not correct!',
      'Fatal error', MB_ICONERROR);
    Halt(0);
  end;

  // ... and even how we can customize other options, like the place to store
  // the folder for the WebView stuff.

  SetEnvironmentVariable('WEBVIEW2_USER_DATA_FOLDER',
   PWideChar(ExtractFilePath(ParamStr(0)) + 'WebView'));

  SetEnvironmentVariable('WEBVIEW2_ADDITIONAL_BROWSER_ARGUMENTS', '');
  SetEnvironmentVariable('WEBVIEW2_BROWSER_EXECUTABLE_FOLDER', nil);
  SetEnvironmentVariable('WEBVIEW2_RELEASE_CHANNEL_PREFERENCE', nil);

  GlobalWebView2Loader := TWVLoader.Create(nil);
  GlobalWebView2Loader.LoaderDllPath := WebView2LoaderPath;
  GlobalWebView2Loader.StartWebView2();

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

