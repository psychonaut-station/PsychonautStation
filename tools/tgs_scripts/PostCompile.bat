@echo on
setlocal

7z a -tzip "C:\Program Files (x86)\tgstation-server\websites\cdn\tg\tgstation.zip" "%~1\tgstation.rsc" -mx9 -mmt2

set "INPUT_FILE=%~1\icons\ui\achievements\achievements.dmi"
set "OUTPUT_DIR=C:\Program Files (x86)\tgstation-server\websites\cdn\tg\achievements"

set "CACHE_DIR=%~dp0achievements"

if exist "%CACHE_DIR%" (
    rmdir /S /Q "%CACHE_DIR%"
)

call "%~1\tools\bootstrap\python.bat" -m dmi.prepare_achievements "%INPUT_FILE%" "%CACHE_DIR%"

if exist "%OUTPUT_DIR%" rmdir /S /Q "%OUTPUT_DIR%"

mkdir "%OUTPUT_DIR%"

move "%CACHE_DIR%\*" "%OUTPUT_DIR%\"

rmdir /S /Q "%CACHE_DIR%"
