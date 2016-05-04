@echo off

rem filename: en_windows_server_2008_r2_with_sp1_x64_dvd_617601.iso
rem      md5: 8dcde01d0da526100869e2457aafb7ca
rem     sha1: d3fd7bf85ee1d5bdd72de5b2c69a7b470733cd0a

rem Details for image : install.wim

rem Index : 1
rem Name : Windows Server 2008 R2 SERVERSTANDARD
rem Description : Windows Server 2008 R2 SERVERSTANDARD
rem Size : 10,510,503,883 bytes

rem Index : 2
rem Name : Windows Server 2008 R2 SERVERSTANDARDCORE
rem Description : Windows Server 2008 R2 SERVERSTANDARDCORE
rem Size : 3,563,695,852 bytes

rem Index : 3
rem Name : Windows Server 2008 R2 SERVERENTERPRISE
rem Description : Windows Server 2008 R2 SERVERENTERPRISE
rem Size : 10,510,896,523 bytes

rem Index : 4
rem Name : Windows Server 2008 R2 SERVERENTERPRISECORE
rem Description : Windows Server 2008 R2 SERVERENTERPRISECORE
rem Size : 3,563,933,834 bytes

rem Index : 5
rem Name : Windows Server 2008 R2 SERVERDATACENTER
rem Description : Windows Server 2008 R2 SERVERDATACENTER
rem Size : 10,511,007,858 bytes

rem Index : 6
rem Name : Windows Server 2008 R2 SERVERDATACENTERCORE
rem Description : Windows Server 2008 R2 SERVERDATACENTERCORE
rem Size : 3,563,973,571 bytes

rem Index : 7
rem Name : Windows Server 2008 R2 SERVERWEB
rem Description : Windows Server 2008 R2 SERVERWEB
rem Size : 10,520,044,398 bytes

rem Index : 8
rem Name : Windows Server 2008 R2 SERVERWEBCORE
rem Description : Windows Server 2008 R2 SERVERWEBCORE
rem Size : 3,562,571,246 bytes

rem keys from:
rem https://technet.microsoft.com/en-us/library/jj612867.aspx

rem Windows Server 2008 R2 Web
rem 6TPJF-RBVHG-WBW2R-86QPH-6RTM4

rem Windows Server 2008 R2 HPC edition
rem TT8MH-CG224-D3D7Q-498W2-9QCTX

rem Windows Server 2008 R2 Standard
rem YC6KT-GKW9T-YTKYR-T4X34-R7VHC

rem Windows Server 2008 R2 Enterprise
rem 489J6-VHDMP-X63PK-3K798-CPX3Y

rem Windows Server 2008 R2 Datacenter
rem 74YFP-3QFB3-KQT8W-PMXWJ-7M648

rem Windows Server 2008 R2 for Itanium-based Systems
rem GT63C-RJFQ3-4GMB6-BRFB9-CB83V

cls
setlocal EnableDelayedExpansion
set path=%path%;%~dp0

for /f "tokens=*" %%d in ('time /t') do echo Slipstream started at: %%d
echo.

set v=Win2k8R2
echo Label for DVD will be: %v%
echo.

set u=%~dp0u2k8r2
echo Looking for updates in directory:
echo %u%
echo.

set i=%~dp0en_windows_server_2008_r2_with_sp1_x64_dvd_617601.iso
echo Name for ISO file:
echo %i%
echo.

set r=%~dp0w2k8r2
echo Additional files (like autounattend.xml) will be overwrited from:
echo %r%
echo.

set w=%temp%
echo Working directory is:
echo %w%
echo.

set d=%1
echo Destination output for new ISO is:
echo %d%
echo.

for /f "tokens=*" %%d in ('"%~dp0date.exe" +%%Y-%%m-%%d') do set yyyymmdd=%%d

set l=%d%\%v%-%yyyymmdd%.iso.log
if exist "%l%" del "%l%" /Q /F
echo Existing errors will be writed on:
echo %l%
echo.

for /f "tokens=*" %%d in ('dir /b "%u%" ^| sed -n "$="') do echo Total number of updates to slipstream: %%d
echo.

set m=5
echo Updates will be slipstreamed into install.wim index(es): %m%
echo.

echo Extracting iso..
if exist "%w%\iso" rd "%w%\iso" /Q /S
7z x "%i%" -o"%w%\iso" > nul 2>&1

cd "C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
if not exist "%w%\mount" md "%w%\mount"
for %%a in (%m%) do (
echo mounting install.wim index %%a..
dism /mount-wim /wimfile:"%w%\iso\sources\install.wim" /index:%%a /mountdir:"%w%\mount" > nul 2>&1
echo integrating .NET 2.0, 3.0 and 3.5..
dism /image:"%w%\mount" /enable-feature /featurename:NetFx3
rem echo integrating drivers..
rem dism /image:"%w%\mount" /add-driver /driver:"%~dp0x64drivers" /recurse
for /f "tokens=*" %%i in ('dir /b "%u%" ^| sed "s/^.*(KB//g;s/).*$//g" ^| gnusort -n') do (
for /f "tokens=*" %%d in ('dir /b "%u%" ^| grep "%%i"') do (
echo slipstreaming KB%%i
for /f "tokens=*" %%z in ('dir /b "%u%\%%d\*.msu" "%u%\%%d\*.cab"') do (
dism /image:"%w%\mount" /add-package /packagepath:"%u%\%%d\%%z" | grep "The operation completed successfully" > nul 2>&1
if not !errorlevel!==0 (
echo %%z not OK
echo %%z not OK >> "%l%"
)
)
)
)
dism /image:"%w%\mount" /Set-Syslocale:lv-LV
dism /image:"%w%\mount" /Set-UserLocale:lv-LV
dism /image:"%w%\mount" /Set-TimeZone:"FLE Standard Time"
dism /image:"%w%\mount" /Get-Intl
dism /unmount-wim /mountdir:"%w%\mount" /commit
)
if exist "%w%\mount" rd "%w%\mount" /Q /S
echo.
echo Adding autounattend.xml or something..
xcopy "%r%" "%w%\iso" /Y /S /F /Q
"C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\amd64\DISM\dism.exe" /Export-Image /SourceImageFile:%w%\iso\sources\install.wim /SourceIndex:%m% /DestinationImageFile:%d%\%v%-%yyyymmdd%.wim /Compress:max
xcopy "%d%\%v%-%yyyymmdd%.wim" "%w%\iso\sources\install.wim" /Y
"C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe" -b"%w%\iso\boot\etfsboot.com" -h -u2 -m -l%v% "%w%\iso" "%d%\%v%-%yyyymmdd%.iso"
if exist "%w%\iso" rd "%w%\iso" /Q /S
endlocal
echo.
echo This is it!
time /t
