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

unit DecSoft.Monaco.Editor.UTF8NBEncoding;

interface

uses
  // Delphi
  System.SysUtils;

type
  TMonacoEditorUTF8NBEncoding = class(TUTF8Encoding)
  private
    class var FInstance: TEncoding;
    class function GetInstance(): TEncoding; static;
  public
    class destructor Destroy;
    function Clone(): TEncoding; override;
    function GetPreamble(): TBytes; override;
  public
    class property Instance: TEncoding read GetInstance;
  end;

implementation

uses
  // Delphi
  System.SyncObjs;

function TMonacoEditorUTF8NBEncoding.Clone(): TEncoding;
begin
  Result := TMonacoEditorUTF8NBEncoding.Create();
end;

class destructor TMonacoEditorUTF8NBEncoding.Destroy();
begin
  FreeAndNil(FInstance);
end;

class function TMonacoEditorUTF8NBEncoding.GetInstance(): TEncoding;
var
  LEncoding: TEncoding;
begin
  if FInstance = nil then
  begin
    LEncoding := TMonacoEditorUTF8NBEncoding.Create();

    if TInterlocked.CompareExchange(Pointer(FInstance),
     Pointer(LEncoding), nil) <> nil then
    begin
      LEncoding.Free();
    end;
  end;

  Result := FInstance;
end;

function TMonacoEditorUTF8NBEncoding.GetPreamble(): TBytes;
begin
  Result := nil;
end;

end.

