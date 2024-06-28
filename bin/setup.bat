@ECHO off

REM set the current directory to the project root
cd %~dp0..\

echo PROJECT DIRECTORY: %cd%

call bundle install

REM curl https://webi.ms/sqlpkg | powershell
REM echo:
REM for /f "delims=" %%A in ('where sqlpkg') do set "SQLPKG_INSTALL_DIR=%%~dpA"

REM setx SQLPKG_INSTALL_DIR "%SQLPKG_INSTALL_DIR%"

REM echo SQLPKG DIRECTORY: %SQLPKG_INSTALL_DIR%

REM call bundle exec sqlpkg install

echo PREPARING DATABASE
call rails db:migrate:primary
call rails db:migrate:queue
call rails db:migrate:cache
call rails db:migrate:errors