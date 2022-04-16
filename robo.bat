@echo off
setlocal

set BUILD_TOOL_DIR=C:\AptioV_Tools_ADL_Mod
Set ROBOVEB_DIR=%BUILD_TOOL_DIR%\VisualeBios
@REM set BUILD_TOOL_DIR=C:\BIOS\AMI_Build_Tool\BuildTools
@REM Set ROBOVEB_DIR=C:\BIOS\AMI_Build_Tool\VisualeBios

Set TargetVeb=%~n1.veb
Set WinDDKPath=C:\WINDDK\7600.16385.1
Set EWDK_DIR=C:\EWDK_1703

Set TOOLS_DIR=%BUILD_TOOL_DIR%\AllTools
Set path=%TOOLS_DIR%;%WinDDKPath%\bin\x86;%path%;
Set IA32_TOOLS_DIR=%WinDDKPath%\bin\x86\x86
Set X64_TOOLS_DIR=%WinDDKPath%\bin\x86\amd64
Set CCX86DIR=%IA32_TOOLS_DIR%
Set CCX64DIR=%X64_TOOLS_DIR%
set PYTHON_COMMAND=C:\Python\Python38\python.exe
set ZIP7_DIR=C:\Program Files\7-Zip
@REM pause
@REM @echo off
::Build Target BIOS
%ROBOVEB_DIR%\RoboVeB.exe -v %TargetVeb% -d %CD% -i -b all -s -consoleLog -noExit

endlocal
echo on
