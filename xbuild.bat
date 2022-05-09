@REM ---------------------------------------
@REM 1. Copy this ACTION file to folde in your PATH environment varialbe, e.g.: C:\BATCH, C:\ADL_TOOL,...
@REM 2. change following environmant variables of toolchain to your own
@REM 3. run this ACTION file in Widnows Command Box under the project folder
@REM Usage: xbuild [veb] [rebuild]
@REM    veb: file name of .veb file to build, following format are all accepted
@REM       **\Express-TL.*
@REM       Express-TL.*
@REM    rebuild: non-empty string instruct to rebuild
@REM ---------------------------------------
@REM set toolchain environment, a copy of VeB envrionment variable
@REM ---------------------------------------
@echo off
setlocal
set TIME_START=%time%
@cls
@REM ---------------------------------------
@REM get action command line in VEB
@REM ---------------------------------------
set VEB=%~n1
set ACTION=Build
if "%2" == "r" set ACTION=BuildAll
if "%2" == "z" set ACTION=Execute
if "%2" == "c" set ACTION=CleanCmd
if not exist %VEB%.veb (goto no_veb)
for /f tokens^=1-2^ delims^=^" %%i in ('findstr /C:%ACTION% %VEB%.veb') do (
    set vebActionLine=%%j
    goto end_parse_buildline
    )
:end_parse_buildline    

@REM ---------------------------------------
@REM set tool path from VeB setting file and run the Action to build BIOS
@REM ---------------------------------------
call %~dp0AmiVebEnv.bat %VEB% %3
if NOT "%2" == "z" if NOT "%2" == "z" (
    call %vebActionLine%
    goto end
)
%vebActionLine%
goto end
:no_veb
echo Please specific a VEB file:
echo ------------------------------
dir /s /b /a:-d *.veb
echo ------------------------------
:end
for /f %%i in ('%~dp0Duration.exe %TIME_START%') do set DURATION=%%i
echo build duration = %DURATION%
endlocal
echo on
