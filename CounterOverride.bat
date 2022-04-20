@echo off
setlocal EnableExtensions EnableDelayedExpansion
@cls
rem --------------------------
if "%1"=="" goto no_project_path_error
if "%2"=="" goto no_CRB_path_error
set CRB_PATH=%2
if not exist %CRB_PATH% goto no_CRB_path_error

set Count=0
set OverrideCount=0

set "OVERRIDE_FILE_LIST=OverrideFileList.txt"
set "OVERRIDE_NOT_LIST=OverrideNotList.txt"
if exist %OVERRIDE_NOT_LIST% del %OVERRIDE_NOT_LIST%

call :OverrideDir AdlinkPkg\CoreOverride
call :OverrideDir AdlinkModulePkg\Baseboard\BoardOverride
call :OverrideDir AdlinkModulePkg\Project\%1\ProjectOverride
@goto end

:no_project_path_error
@echo ------------------------------
@echo -   Not found project path   -
@echo ------------------------------
@goto end

:no_CRB_path_error
@echo ------------------------------
@echo -   Not found CRB path       -
@echo ------------------------------
@goto end

:end
echo ==== Total override     : %Count% ====
echo ==== Total source found : %OverrideCount% ====
if %Count% neq %OverrideCount% (
    @echo ------------------------------
    echo missing source files:
    @echo ------------------------------
    type %OVERRIDE_NOT_LIST%
)
endlocal
echo on
exit /b

:OverrideDir
set "OVERRIDE_PATH=%1"
set "OVERRIDE_PATH_FULL=%cd%\%OVERRIDE_PATH%"
dir /s /b /a:-d %cd%\%OVERRIDE_PATH% > %OVERRIDE_FILE_LIST%

if exist %2\%OVERRIDE_PATH% (del /q %2\%OVERRIDE_PATH%\*.*) else (mkdir %2\%OVERRIDE_PATH%)

for /f "usebackq delims=" %%A in ("%OVERRIDE_FILE_LIST%") do (
    set OVR=%%A
    set SRC=!OVR:%OVERRIDE_PATH_FULL%=%CRB_PATH%!
    set DST=!OVR:%cd%=%CRB_PATH%!
    @REM echo source  : !SRC!  
    @REM echo override: !DST!
    set /a Count+=1
    if exist !SRC! (
        echo F|xcopy /Y !SRC! !DST!
        set /a OverrideCount+=1
    )
    if not exist !SRC! (
        echo !SRC! >> %OVERRIDE_NOT_LIST%
    )
)
if exist %OVERRIDE_FILE_LIST% del %OVERRIDE_FILE_LIST%

exit /b
