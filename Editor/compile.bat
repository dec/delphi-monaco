@ECHO off
CLS

REM Set this directory as the current one
CD %~dp0

RMDIR /S /Q .\dist\
RMDIR /S /Q .\node_modules\

CALL .\_build.bat

CALL .\_run.bat

COPY .\app\editor.html .\dist\ /Y 
COPY .\app\favicon.ico .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.cs.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.de.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.es.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.fr.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.it.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.ja.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.ko.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.pl.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.pt-br.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.ru.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.tr.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.zh-cn.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\nls.messages.zh-tw.js .\dist\ /Y

DEL .\package-lock.json

RMDIR /S /Q .\node_modules\

