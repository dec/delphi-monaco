import * as monaco from 'monaco-editor';

self.MonacoEnvironment = {
	getWorkerUrl: function (moduleId, label) {
		if (label === 'json') {
			return './json.worker.bundle.js';
		}
		if (label === 'css' || label === 'scss' || label === 'less') {
			return './css.worker.bundle.js';
		}
		if (label === 'html' || label === 'handlebars' || label === 'razor') {
			return './html.worker.bundle.js';
		}
		if (label === 'typescript' || label === 'javascript') {
			return './ts.worker.bundle.js';
		}
		return './editor.worker.bundle.js';
	}
};

   // From Monaco Editor v0.53 (maybe only on this version?) sometimes,
			// erratically, we get an error while initialize the editor: here we
			// catch that error and inform the host that the browser view must
			// be initialized again.
   window.addEventListener('error', (event) => {
				 console.error('error');
			  window.chrome.webview.postMessage('editor-error');
			});

   window.editor = {

     instance: null,
     started: false,
     completionsProviders: [],

   		start (language, options) {

   			 if (this.started)
         return;

       monaco.languages.typescript.javascriptDefaults.setCompilerOptions({
   	     allowNonTsExtensions: true,
   	     target: monaco.languages.typescript.ScriptTarget.ES2015
       });

       monaco.languages.typescript.javascriptDefaults.setDiagnosticsOptions({
   	     noSyntaxValidation: false,
   	     noSemanticValidation: true
       });

       monaco.editor.onDidCreateEditor(editor => {
   				  this._callHost(this.editorOnLoadedEventMsgId);
       });

       this.instance = monaco.editor.create(
   					document.getElementById('editor'), options);

   				this.instance.onKeyUp((event) => {
   				  this._callHost(this.editorOnKeyUpEventMsgId,
									 {event: this._compactKeyEvent(event)});
   				});

   				this.instance.onKeyDown((event) => {
   				  this._callHost(this.editorOnKeyDownEventMsgId,
									 {event: this._compactKeyEvent(event)});
   				});

       this.instance.onDropIntoEditor(() => {
         this._callHost(this.editorOnDropFileEventMsgId);
       });

       this.instance.focus();
   				this.started = true;
   		},

   		getValue () {

   			 return this.instance.getValue();
   		},

   		setValue (value) {

   			 this.instance.setValue(value.value);
   		},

   		insertText (text) {

       this.instance.executeEdits('', [{
   				 	range: this.instance.getSelection(), text: text.text
   				}]);
   		},

					execAction (action) {

						 this.instance.focus();
 						this.instance.getAction(action.id).run();
					},

   		search (options) {

       const model = this.instance.getModel();
   				const ranges = model.findMatches(options.query, false,
   					 options.is_regex, options.match_case, options.whole_words);

   				if (ranges.length === 0) {
   						return false;
   				}

       this.instance.setSelection(ranges[0].range);
							this.instance.revealRangeInCenter(ranges[0].range, monaco.editor.ScrollType.Immediate);

   				if (options.show_dialog) {
         this.instance.getAction('actions.find').run();
   				}

   				return true;
   		},

   		updateOptions (options) {

   			 this._setLanguage(options.language);
   	   this.instance.updateOptions(options);
   		},

   		setJSExtraLibs (content) {

       monaco.languages.typescript.javascriptDefaults.setExtraLibs([{ content: content.value }]);
   		},

   		getLanguages () {

   			 let
   				  result = [],
   				  languages = monaco.languages.getLanguages();

       for (let i in languages) {
   				  result.push(languages[i].id);
   			 }

       return result;
   		},

   		registerCompletions (language, completions) {

   			 if (this.completionsProviders[language] !== undefined) {
         this.completionsProviders[language].dispose();
   						this.completionsProviders[language] = undefined;
   				}

   			 let self = this;

       function createDependencyProposals (range) {

   	  		 for (let i in completions) {

           /**
   									* Since the completion provider is called more than one time, the first time
   								 * the kind is a string (the one that we set), but, the second time it's already
   								 * the appropiate kind ID (a number), so, to fix annoying errors we check this.
   									*/
   							 if (typeof completions[i].kind === 'string') {
   									 completions[i].kind = self._getCompletionKindFromString(completions[i].kind)
   								}

           /**
   									* Similar to the kind, we use the original string to be used "as markdown", and,
   									* in next calls, the "documentation" is already the expected object.
   									*/
   								if (typeof completions[i].documentation === 'string') {

     								completions[i].documentation = {
   		  							 isTrusted: true,
               supportHtml: true,
               supportThemeIcons: true,
   								  	 value: completions[i].documentation
   								  };
   								}

   							 completions[i].range = range;
           completions[i].kind = completions[i].kind;
   			  			completions[i].insertTextRules = monaco.languages.CompletionItemInsertTextRule.InsertAsSnippet;
   				  }

         	return completions;
       }

       this.completionsProviders[language] = monaco.languages.registerCompletionItemProvider(
   					 language,
   						{
   	       provideCompletionItems: (model, position) => {

   		        let
   										  word = model.getWordUntilPosition(position);

   		        let
   										  range = {
   			           startLineNumber: position.lineNumber,
   			           endLineNumber: position.lineNumber,
   			           startColumn: word.startColumn,
   			           endColumn: word.endColumn
   										  };

   		        return {
   			         suggestions: createDependencyProposals(range)
   		        };
   	       }
         });
   		},

   		_getLanguageFromFileUrl (fileUrl) {

   		  let
   				  languages = monaco.languages.getLanguages(),
   				  fileExt = `.${fileUrl.split('.').pop()}`.toLowerCase();

   				for (let i in languages) {

   				  let
   						  langExtensions = languages[i].extensions;

   						for (let j in langExtensions) {

    							if (langExtensions[j] === fileExt) {

   	 							 return languages[i].id
   			 				}
   						}
   				}

   				return null;
   		},

   		_setLanguage (language) {

       monaco.editor.setModelLanguage(
   					this.instance.getModel(), language);
   		},

					_compactKeyEvent (event) {

					  let
							  result = {};

							result.code = event.code;
							result.altKey = event.altKey;
							result.ctrlKey = event.ctrlKey;
							result.keyCode = event.keyCode;
							result.metaKey = event.metaKey;
							result.shiftKey = event.shiftKey;
							result.altGraphKey = event.altGraphKey;

							return result;
					},

     _callHost (funcID, args = {}) {

       function uuidv4 () {

         // https://stackoverflow.com/a/2117523
         return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
           let r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
           return v.toString(16);
         });
       }

       let uuid = uuidv4();

       return new Promise((resolve, reject) => {

         function exec (message) {

           if (message.data.uuid === uuid) {

             window.chrome.webview.removeEventListener('message', exec);

   		        if (message.data.success) {
   		          resolve(message.data.result);
   		        } else {
   		          reject(message.data.result);
   		        }
           }
         }

         window.chrome.webview.addEventListener('message', exec);
         window.chrome.webview.postMessage({id: funcID, uuid: uuid, data: args});
       });
     },

   		 /**
   				* More information:
   				*
   				* https://microsoft.github.io/monaco-editor/docs.html#enums/languages.CompletionItemKind.html
   				*
   				*/
   		_getCompletionKindFromString (kind) {

      switch (kind) {
   					case 'Class':
          return monaco.languages.CompletionItemKind.Class;
   					case 'Constant':
          return monaco.languages.CompletionItemKind.Constant;
   					case 'Customcolor':
          return monaco.languages.CompletionItemKind.Customcolor;
   					case 'EnumMember':
          return monaco.languages.CompletionItemKind.EnumMember;
   					case 'Field':
          return monaco.languages.CompletionItemKind.Field;
   					case 'Interface':
          return monaco.languages.CompletionItemKind.Interface;
   					case 'Keyword':
          return monaco.languages.CompletionItemKind.Keyword;
   					case 'Module':
          return monaco.languages.CompletionItemKind.Module;
   					case 'Property':
          return monaco.languages.CompletionItemKind.Property;
   					case 'Snippet':
          return monaco.languages.CompletionItemKind.Snippet;
   					case 'Text':
          return monaco.languages.CompletionItemKind.Text;
   					case 'Unit':
          return monaco.languages.CompletionItemKind.Unit;
   					case 'Value':
          return monaco.languages.CompletionItemKind.Value;
   					case 'Color':
          return monaco.languages.CompletionItemKind.Color;
   					case 'Constructor':
          return monaco.languages.CompletionItemKind.Constructor;
   					case 'Enum':
          return monaco.languages.CompletionItemKind.Enum;
   					case 'Event':
          return monaco.languages.CompletionItemKind.Event;
   					case 'File':
          return monaco.languages.CompletionItemKind.File;
   					case 'Function':
          return monaco.languages.CompletionItemKind.Function;
   					case 'Issue':
          return monaco.languages.CompletionItemKind.Issue;
   					case 'Method':
          return monaco.languages.CompletionItemKind.Method;
   					case 'Operator':
          return monaco.languages.CompletionItemKind.Operator;
   					case 'Reference':
          return monaco.languages.CompletionItemKind.Reference;
   					case 'Struct':
          return monaco.languages.CompletionItemKind.Struct;
   					case 'TypeParameter':
          return monaco.languages.CompletionItemKind.TypeParameter;
   					case 'User':
          return monaco.languages.CompletionItemKind.User;
   					case 'Variable':
          return monaco.languages.CompletionItemKind.Variable;
        default:
   							return monaco.languages.CompletionItemKind.Text;
   			 }
   		},

   		editorOnLoadedEventMsgId: 10001,
   		editorOnKeyUpEventMsgId: 10002,
   		editorOnKeyDownEventMsgId: 10003,
   		editorOnDropFileEventMsgId: 10004
   };
