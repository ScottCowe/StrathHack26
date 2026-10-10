@echo off
setlocal EnableExtensions
cd /d "%~dp0"

powershell -NoProfile -Command "$p = Start-Process -FilePath 'dart' -ArgumentList 'run','bin/db_proxy.dart' -WorkingDirectory '%CD%' -WindowStyle Minimized -PassThru; Set-Content -Path $env:TEMP\strathclean-proxy.pid -Value $p.Id"
if errorlevel 1 (
  echo Database proxy failed to start.
  exit /b 1
)
set /p PROXY_PID=<"%TEMP%\strathclean-proxy.pid"

for /L %%i in (1,1,150) do (
  tasklist /FI "PID eq %PROXY_PID%" | find "%PROXY_PID%" >nul
  if errorlevel 1 (
    echo Database proxy exited before it was ready.
    exit /b 1
  )
  curl -sf "http://127.0.0.1:8081/health" >nul 2>&1
  if not errorlevel 1 goto :ready
  powershell -NoProfile -Command "Start-Sleep -Milliseconds 200"
)

echo Database proxy did not become ready.
call :cleanup
exit /b 1

:ready
flutter run -d web-server %*
set FLUTTER_EXIT=%ERRORLEVEL%
call :cleanup
exit /b %FLUTTER_EXIT%

:cleanup
taskkill /PID %PROXY_PID% /T /F >nul 2>&1
del "%TEMP%\strathclean-proxy.pid" >nul 2>&1
exit /b 0
