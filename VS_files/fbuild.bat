@echo off
setlocal
set FSP_TIME_START=%time%

@REM echo === swtich to FSP build ==========
python switchToken.py 1
@REM echo === start FSP build
call xbuild.bat %1 r
@REM echo === update FSP.fd ================
copy /Y  Intel\CannonLakeFspBinPkg\AmiFspBin\Release\Fsp.fd AdlinkModulePkg\Project\cPCI-3520\Addons\FSP\Release\Fsp_7_00_20_52.fd
@REM echo === swtich to BIOS build =========
python switchToken.py 0
@REM echo === start BIOS build =============
call xbuild.bat %1 r

if not exist %ADL_TOOLS_DIR%\Duration.exe goto end_duration
for /f %%i in ('%ADL_TOOLS_DIR%\Duration %FSP_TIME_START%') do set DURATION=%%i
echo FSP build duration = %DURATION%
:end_duration
endlocal
echo on
