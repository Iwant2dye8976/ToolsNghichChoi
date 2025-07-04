@echo off
:: Lấy đường dẫn tuyệt đối của Remove.bat
set "scriptPath=%~dp0Remove.bat"

::Lấy tên user
set "userName=%USERNAME%"

:: Tạo tệp XML tạm thời
set "tempXml=%~dp0%Unlock.xml"
copy "Unlock.xml" "%tempXml%" > nul

:: Cập nhật đường dẫn tuyệt đối trong tệp XML tạm thời
powershell -Command "(Get-Content -path '%tempXml%') -replace 'C:\\path\\to\\Remove.bat', '%scriptPath%' | Set-Content -path '%tempXml%'"

:: Thông báo bắt đầu tạo task
echo Creating scheduled task "Unlock Minecraft for Windows" from XML...

:: Tạo task từ tệp XML tạm thời
schtasks /create /tn "Unlock Minecraft for Windows" /xml "%tempXml%" /ru "SYSTEM" /F

:: Kiểm tra kết quả của lệnh schtasks
if %errorlevel% equ 0 (
    echo Task "Unlock Minecraft for Windows" has been successfully created.
) else (
    echo Failed to create the task "Unlock Minecraft for Windows".
)

exit