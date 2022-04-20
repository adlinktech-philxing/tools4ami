@echo off
setlocal

set WORK_DIR=%cd%
call :UpdateCif %WORK_DIR%\AdlinkPkg\CoreOverride
call :UpdateCif %WORK_DIR%\AdlinkModulePkg\Baseboard\BoardOverride
set PRJ=%~n1
if "%PRJ%"=="" goto update_all_project
call :UpdateCif %WORK_DIR%\AdlinkModulePkg\Project\%PRJ%\ProjectOverride
goto finish_update

:update_all_project
echo Update All Override CIFs of all Projects...
for %%i in (*.veb) do (
  if exist %WORK_DIR%\AdlinkModulePkg\Project\%%~ni\ProjectOverride (
    call :UpdateCif %WORK_DIR%\AdlinkModulePkg\Project\%%~ni\ProjectOverride
  )
)

:finish_update
@echo -------------------------
@echo -   Update Override CIFs End -
@echo -------------------------
@goto end

:no_project_path_error
@echo ------------------------------
@echo -   Not found project path   -
@echo ------------------------------

:end
endlocal
echo on
exit /b

:UpdateCif
set OVERRIDE_FILE_LIST=%WORK_DIR%\OverrideFileList.txt
set OVERRIDE_FILE_LIST_CODE=%WORK_DIR%\OverrideFileListCode.txt
set OVERRIDE_FILE_LIST_ALL=%WORK_DIR%\OverrideFileListAll.txt
set _strFind=[files]
cd %1
echo %1
set CurrDirName=%~nx1
cd ..
setlocal EnableDelayedExpansion
for /L %%n in (1 1 500) do if "!__cd__:~%%n,1!" neq "" set /a "len=%%n+1"
if "%CurrDirName%" == "ProjectOverride" goto _project_override


set CIF_FILE=%CurrDirName%.cif
echo    %CIF_FILE%
if not exist %CIF_FILE% goto end
set OUTPUT_FILE=%CIF_FILE%.new

:list override files
cd %CurrDirName%
>"%OVERRIDE_FILE_LIST%" (
    for /r . %%g in (*.*) do (
        set "absPath=%%g"
        set "relPath=!absPath:~%len%!"
        if "%%~xg" neq ".cif" (
            echo("!relPath!"
        )
    )
)
cd ..
:Replace
>"%OUTPUT_FILE%" (
    for /f "usebackq delims=" %%A in ("%CIF_FILE%") do (
        if "%%A" equ "%_strFind%" (goto :inser_exist_files) else (echo %%A)
    )
)
:inser_exist_files    
>>"%OUTPUT_FILE%" (
    echo %_strFind%
    for /f "usebackq delims=" %%A in ("%OVERRIDE_FILE_LIST%") do echo %%A
    echo ^<endComponent^>
)
del %CIF_FILE%
ren %OUTPUT_FILE% %CIF_FILE%
goto end



:_project_override
@REM ===================================================
@REM  SetupFileList
@REM ===================================================
@REM :list override files
set CIF_FILE=SetupFileList.cif
echo    %CIF_FILE%
if not exist %CIF_FILE% goto end
set OUTPUT_FILE=%CIF_FILE%.new
cd %CurrDirName%
>"%OVERRIDE_FILE_LIST%" (
    for /r . %%g in (*.vfr *.hfr *.sd *.uni) do (
        set "absPath=%%g"
        set "relPath=!absPath:~%len%!"
        if "%%~xg" neq ".cif" (
            echo("!relPath!"
        )
    )
)
cd ..
@REM :Replace
>"%OUTPUT_FILE%" (
    for /f "usebackq delims=" %%A in ("%CIF_FILE%") do (
        if "%%A" equ "%_strFind%" (goto :inser_exist_files_SetupFileList) else (echo %%A)
    )
)
:inser_exist_files_SetupFileList
>>"%OUTPUT_FILE%" (
    echo %_strFind%
    for /f "usebackq delims=" %%A in ("%OVERRIDE_FILE_LIST%") do echo %%A
    echo ^<endComponent^>
)
del %CIF_FILE%
ren %OUTPUT_FILE% %CIF_FILE%



@REM ===================================================
@REM  CodeFileList
@REM ===================================================
set CIF_FILE=CodeFileList.cif
echo  %CIF_FILE%
if not exist %CIF_FILE% goto end
set OUTPUT_FILE=%CIF_FILE%.new
cd %CurrDirName%
>"%OVERRIDE_FILE_LIST_ALL%" (
    for /r . %%g in (*.*) do (
        set "absPath=%%g"
        set "relPath=!absPath:~%len%!"
        if "%%~xg" neq ".cif" (
            echo("!relPath!"
        )
    )
)
@REM remove files in SetupFileList.cif
type %OVERRIDE_FILE_LIST_ALL% | findstr /b /e /v /i /l /g:%OVERRIDE_FILE_LIST% > %OVERRIDE_FILE_LIST_CODE%
cd ..
@REM :Replace
>"%OUTPUT_FILE%" (
    for /f "usebackq delims=" %%A in ("%CIF_FILE%") do (
        if "%%A" equ "%_strFind%" (goto :inser_exist_files_CodeFileList) else (echo %%A)
    )
)
:inser_exist_files_CodeFileList
>>"%OUTPUT_FILE%" (
    echo %_strFind%
    for /f "usebackq delims=" %%A in ("%OVERRIDE_FILE_LIST_CODE%") do echo %%A
    echo ^<endComponent^>
)
del %CIF_FILE%
ren %OUTPUT_FILE% %CIF_FILE%



:end
if exist %OVERRIDE_FILE_LIST% del %OVERRIDE_FILE_LIST%
if exist %OVERRIDE_FILE_LIST_ALL% del %OVERRIDE_FILE_LIST_ALL%
if exist %OVERRIDE_FILE_LIST_CODE% del %OVERRIDE_FILE_LIST_CODE%
exit /b
