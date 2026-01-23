@echo off
call "%~dp0\..\bootstrap\javascript.bat" "%~dp0\main.js" %*
call "%~dp0\..\bootstrap\javascript.bat" "%~dp0\sort.js" %*
pause
