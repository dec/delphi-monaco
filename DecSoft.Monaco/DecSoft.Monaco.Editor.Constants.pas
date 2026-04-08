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

unit DecSoft.Monaco.Editor.Constants;

interface

type
  TMonacoEditorConstants = class
  const

    // Events related
    EditorOnCreatedEventMsgId = 10001;
    EditorOnKeyUpEventMsgId = 10002;
    EditorOnKeyDownEventMsgId = 10003;
    EditorOnDropFileEventMsgId = 10004;

    // Files related
    EditorFolderName = 'editor';
    EditorFileName = 'editor.html';

    // Editor related
    EditorDefaultLocaleLanguage = 'en';

    // Editor virtual host related
    EditorVirtualHostName = 'decsoft.monaco.editor';
    EditorVirtualHostDefaultUrl = 'https://decsoft.monaco.editor/editor.html';

    // Method signatures related
    EditorSearchFunction = 'window.editor.search(%s)';
    EditorGetValueFunction = 'window.editor.getValue();';
    EditorSetValueFunction = 'window.editor.setValue(%s)';
    EditorStartLocalFunction = 'window.editor.start(%s);';
    EditorInsertTextFunction = 'window.editor.insertText(%s)';
    EditorExecActionFunction = 'window.editor.execAction(%s);';
    EditorGetLanguagesFunction = 'window.editor.getLanguages();';
    EditorUpdateOptionsFunction = 'window.editor.updateOptions(%s);';
    EditorSetJSExtraLibsFunction = 'window.editor.setJSExtraLibs(%s);';
    EditorRegisterCompletionsFunction = 'window.editor.registerCompletions("%s", %s)';

    // Editor actions related
    EditorFindActionID = 'actions.find';
    EditorQuickCommandActionID = 'editor.action.quickCommand';
    EditorStartFindReplaceActionID = 'editor.action.startFindReplaceAction';
  end;

implementation

end.
