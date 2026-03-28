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

unit DecSoft.Monaco.Editor.Options;

interface

type
  TMonacoEditorOptions = class(TObject)
  private
    FTheme: string;
    FLanguage: string;
    FReadOnly: Boolean;
    FWordWrap: Boolean;
    FPlaceholder: string;
    FLineNumbers: Boolean;
    FContextMenu: Boolean;
    // Internal, not used in the HTML / JavaScript editor
    FAllowDropFiles: Boolean;
  public
    constructor Create();
    destructor Destroy(); override;
  public
    function ToJSONString(): string;
  public
    property Theme: string read FTheme write FTheme;
    property Language: string read FLanguage write FLanguage;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property WordWrap: Boolean read FWordWrap write FWordWrap;
    property Placeholder: string read FPlaceholder write FPlaceholder;
    property LineNumbers: Boolean read FLineNumbers write FLineNumbers;
    property ContextMenu: Boolean read FContextMenu write FContextMenu;
    property AllowDropFiles: Boolean read FAllowDropFiles write FAllowDropFiles;
  end;

implementation

uses
  // Delphi
  System.JSON;

{ TMonacoEditorOptions }

constructor TMonacoEditorOptions.Create();
begin
  inherited Create();

  FTheme := 'vs';
  FLanguage := '';
  FPlaceholder := '';
  FReadOnly := False;
  FWordWrap := False;
  FLineNumbers := True;
  FContextMenu := True;
  FAllowDropFiles := False;
end;

destructor TMonacoEditorOptions.Destroy();
begin

  inherited Destroy();
end;

function TMonacoEditorOptions.ToJSONString(): string;
var
  JSON: TJSONObject;
  JSONObject: TJSONObject;
begin
  JSON := TJSONObject.Create();
  try
    JSON.AddPair('theme', FTheme);

    if FLanguage <> '' then
      JSON.AddPair('language', FLanguage)
    else
      JSON.AddPair('language', TJSONNull.Create());

    JSON.AddPair('placeholder', FPlaceholder);
    JSON.AddPair('readOnly', TJSONBool.Create(FReadOnly));
    JSON.AddPair('lineNumbers', TJSONBool.Create(FLineNumbers));
    JSON.AddPair('contextmenu', TJSONBool.Create(FContextMenu));

    if FWordWrap then
      JSON.AddPair('wordWrap', 'on')
    else
      JSON.AddPair('wordWrap', 'off');

    // Internally established
    JSON.AddPair('showDeprecated', TJSONBool.Create(False));
    JSON.AddPair('automaticLayout', TJSONBool.Create(True));
    JSONObject := TJSONObject.Create();
    JSONObject.AddPair('enabled', TJSONBool.Create(True));
    JSONObject.AddPair('showDropSelector', 'never');
    JSON.AddPair('dropIntoEditor', JSONObject);

    Result := JSON.ToString();
  finally
    JSON.Free();
  end;
end;

end.
