@ECHO off
CLS

REM Set this directory as the current one
CD %~dp0

npm run build
