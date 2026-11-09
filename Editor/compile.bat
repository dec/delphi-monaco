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
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\cs.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\de.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\es.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\fr.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\it.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\ja.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\ko.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\pl.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\pt-br.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\ru.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\tr.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\zh-cn.js .\dist\ /Y
COPY .\node_modules\monaco-editor\esm\vs\nls\lang\zh-tw.js .\dist\ /Y

DEL .\package-lock.json

RMDIR /S /Q .\node_modules\

PAUSE