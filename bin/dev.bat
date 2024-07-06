@ECHO off

REM set the current directory to the project root
cd %~dp0..\

echo PROJECT DIRECTORY: %cd%

call gem list --no-installed --exact --silent foreman
if %ERRORLEVEL% EQU 0 call gem install foreman

call foreman start -f Procfile-win.dev %*