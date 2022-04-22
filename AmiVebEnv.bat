set CHECKSUM_FILE=
if "%2"=="AMI" goto ami_settings

@REM for ADLink framework
set BUILD_TOOL_DIR=C:\AptioV_Tools_ADL_Mod
set TOOLS_DIR=%BUILD_TOOL_DIR%\AllTools
set ADL_TOOLS_DIR=%BUILD_TOOL_DIR%\ADLTool
goto end_frame_work_choice 
:ami_settings
@REM for AMI CRB setting
set BUILD_TOOL_DIR=C:\BIOS\AMI_Build_Tool\BuildTools
set TOOLS_DIR=%BUILD_TOOL_DIR%
:end_frame_work_choice 

@REM for test
@REM goto no_Veb_Pref

set VEB_PREF_FILE=%BUILD_TOOL_DIR%\VisualeBios\configuration\.settings\com.ami.veb.ui.prefs
if not exist %VEB_PREF_FILE% goto no_Veb_Pref
python %~dp0setvebenv.py %VEB_PREF_FILE% %CD%\%1
call set_veb_env.bat
del set_veb_env.bat
goto end_Veb_env

@REM ---------------------------------------
@REM set tool path manually
@REM ---------------------------------------
:no_Veb_Pref
set ZIP7_DIR=C:\Program Files\7-Zip
set DEDIPROG_DIR=C:\Program Files (x86)\DediProg\SF Programmer
set PATH=%TOOLS_DIR%;%ZIP7_DIR%;%DEDIPROG_DIR%;%PATH%;
@REM ---------------------------------------
set CCX86_ROOT_DIR=C:\WINDDK\7600.16385.1\bin\x86
set CCX86DIR=%CCX86_ROOT_DIR%\x86
set CCX86DIRTOOL=%CCX86DIR%\x86
set CCX64DIR=%CCX86_ROOT_DIR%\amd64
set EWDK_DIR=C:\EWDK_1703
set PATH=%CCX86_ROOT_DIR%;%EWDK_DIR%;%PATH%

@REM set PYTHON_COMMAND=C:\Python\Python38\python.exe
set PYTHON_COMMAND=C:\Python\Python377rc1\python.exe
@REM ---------------------------------------
:end_Veb_env
python %~dp0\checkouttool.py %TOOLS_DIR% %1