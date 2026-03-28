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

unit DecSoft.Monaco.Editor.SysUtils;

interface

type
  TMonacoEditorSysUtils = class(TObject)
  public
    class function ShellOpen(FilePath: string): Boolean;
    class function WebView2IsInstalled(const WebView2LoaderDllPath: string): Boolean;
  end;

implementation

uses
  // Delphi
  WinApi.Windows,
  System.SysUtils,
  Winapi.ShellApi;

class function TMonacoEditorSysUtils.ShellOpen(FilePath: string): Boolean;
begin
  Result := ShellExecute(GetActiveWindow(),
   'open', PChar(FilePath), nil, nil, SW_NORMAL) > 32;
end;

class function TMonacoEditorSysUtils.WebView2IsInstalled(
  const WebView2LoaderDllPath: string): Boolean;
type
  TGetAvailableCoreWebView2BrowserVersionString =
   function (browserExecutableFolder: PWideChar;
    versioninfo: PPWideChar): HRESULT; stdcall;
var
  VersionInfo: PWideChar;
  WebView2LibHandle: THandle;
  GetAvailableCoreWebView2BrowserVersionString: TGetAvailableCoreWebView2BrowserVersionString;
begin
  Result := False;

  if not FileExists(WebView2LoaderDllPath) then
    Exit;

  WebView2LibHandle := LoadLibrary(PWideChar(WebView2LoaderDllPath));

  if WebView2LibHandle <> 0 then
  begin
    @GetAvailableCoreWebView2BrowserVersionString := GetProcAddress(
     WebView2LibHandle, 'GetAvailableCoreWebView2BrowserVersionString');
    GetAvailableCoreWebView2BrowserVersionString(nil, @VersionInfo);
    Result := VersionInfo <> '';
    FreeLibrary(WebView2LibHandle);
  end;
end;

end.
