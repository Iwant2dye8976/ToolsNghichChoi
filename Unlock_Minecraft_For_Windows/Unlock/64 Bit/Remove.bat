@echo off
:: Kiểm tra nếu script không chạy với quyền admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo RESTARTING AS ADMINISTRATOR .....
    powershell -Command "Start-Process '%~f0' -Verb RunAs -Wait"
    exit /b
)

set "dll_file=Windows.ApplicationModel.Store.dll"
set "system32_path=C:\Windows\System32"
set "log_file=%~dp0operation.log"

:: Xóa file log nếu đã tồn tại
if exist "%log_file%" del "%log_file%"

:: Kiểm tra file DLL có tồn tại trong System32
if exist "%system32_path%\%dll_file%" (
    echo Taking ownership of %dll_file% >> "%log_file%" 2>&1
    takeown /f "%system32_path%\%dll_file%" >> "%log_file%" 2>&1
    echo Granting administrators full access to %dll_file% >> "%log_file%" 2>&1
    ICACLS "%system32_path%\%dll_file%" /grant administrators:F >> "%log_file%" 2>&1
    echo Deleting %dll_file% from %system32_path% >> "%log_file%" 2>&1
    del /f /q "%system32_path%\%dll_file%" >> "%log_file%" 2>&1
) else (
    echo WARNING: File %dll_file% not found in %system32_path% >> "%log_file%" 2>&1
)

:: Kiểm tra file DLL mới có tồn tại không trước khi sao chép
if exist "%~dp0%dll_file%" (
    echo Copying %dll_file% to %system32_path% >> "%log_file%" 2>&1
    copy /Y "%~dp0%dll_file%" "%system32_path%" >> "%log_file%" 2>&1
    echo %dll_file% replaced successfully in %system32_path%. >> "%log_file%" 2>&1
) else (
    echo ERROR: New DLL file not found in script directory! >> "%log_file%" 2>&1
    echo ERROR: %dll_file% not found in script directory!
    pause
    exit /b
)
:: Kiểm tra và chạy file PowerShell nếu tồn tại
if exist "%~dp0xml_update.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0xml_update.ps1"
) else (
    echo ERROR: xml_update.ps1 not found! >> "%log_file%" 2>&1
)

:: Kiểm tra và chạy file batch khác nếu tồn tại
if exist "%~dp0task-schedule.bat" (
    call "%~dp0task-schedule.bat"
) else (
    echo ERROR: task-schedule.bat not found! >> "%log_file%" 2>&1
)
pause