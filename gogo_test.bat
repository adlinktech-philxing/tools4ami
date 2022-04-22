@echo off
set Temp_Batch=tempgo.bat
set Release_Batch=AutoRelease.bat
set TOOLS_Veb=C:\aptiov_tools_adl_mod\VisualeBios
set TOOLS_DIR=C:\aptiov_tools_adl_mod\AllTools
set CCX86DIR=C:\WinDDK\7600.16385.1\bin\x86\x86
set CCX64DIR=C:\WinDDK\7600.16385.1\bin\x86\amd64
@REM set path=C:\EWDK_1703\Program Files\Windows Kits\10\bin\10.0.15063.0\x64;C:\Program Files\7-Zip;C:\WinDDK\7600.16385.1\bin\x86;%TOOLS_Veb%;%TOOLS_DIR%;%CCX86DIR%;%CCX64DIR%;%PATH%;

@REM local setting for test
set ZIP7_DIR=C:\Program Files\7-Zip
set DEDIPROG_DIR=C:\Program Files (x86)\DediProg\SF Programmer
set PATH=%TOOLS_DIR%;%ZIP7_DIR%;%DEDIPROG_DIR%;%PATH%;
@REM @REM ---------------------------------------
@REM set CCX86_ROOT_DIR=C:\WINDDK\7600.16385.1\bin\x86
@REM set CCX86DIR=%CCX86_ROOT_DIR%\x86
@REM set CCX86DIRTOOL=%CCX86DIR%\x86
@REM set CCX64DIR=%CCX86_ROOT_DIR%\amd64
set EWDK_DIR=C:\EWDK_1703
set PATH=%CCX86_ROOT_DIR%;%EWDK_DIR%;%PATH%
set PYTHON_COMMAND=C:\Python\Python38\python.exe

set VEB_BUILD_DIR=Build
set VEB=%1

if exist %Temp_Batch% del %Temp_Batch%
if exist %VEB%.veb (

@REM reset build tool to version indicated by .VEB file 
@REM python %~dp0\checkouttool.py %TOOLS_DIR% %VEB%

@REM pause
@REM gawk "{if (match($0,\"BuildAll\")) print $0}" %VEB%.veb | gawk -F= "{print \"call\", substr($2, index($2,\"AdlinkPkg\"), length($2)-index($2,\"AdlinkPkg\"))}" | gawk "{len=split($4,a,\" \");for(i=1;i<=len;i++) print \"git reset \"a[i]\" --hard\"}" > GitResetVersion.bat
@REM CD
@REM set WORK_DIR=%CD%
@REM echo %WORK_DIR%
@REM echo %VEB%
@REM set ResetTool="%CD%\GitResetVersion.bat"
@REM pause
@REM @REM pushd %~dp0
@REM cd %TOOLS_DIR%
@REM cd ..
@REM cd 
@REM pause
@REM echo ResetTool=%ResetTool%
@REM call %ResetTool%
@REM cd %WORK_DIR%
@REM goto exit_go
@REM @REM popd

@REM get the action indicated by .VEB file
gawk "{if (match($0,\"BuildAll\")) print $0}" %VEB%.veb | gawk -F= "{print \"call\", substr($2, index($2,\"AdlinkPkg\"), length($2)-index($2,\"AdlinkPkg\"))}" > %Temp_Batch%
call %Temp_Batch%
) else (
echo file %VEB%.veb is not exist!!
err 
)

@REM Set BuildError=%ERRORLEVEL%
@REM if %BuildError% NEQ 0 goto exit_go
@REM if exist Template.veb (
@REM gawk "{if (match($0,\"Execute\")) print $0}" Template.veb | gawk -F= "{print substr($2, 3 , length($2)-3)}" > %Release_Batch%
@REM call %Release_Batch%

@REM setlocal ENABLEDELAYEDEXPANSION
@REM net use z: \\mapsrdserver.adlinktech.com\home\www jenkins@01 /user:"jenkins.bios"
@REM gawk -f %BuildToolPath%\CollectProjectInfo.awk MatchString=PROJECT_NAME Build\Token.mak > %Temp_Batch%
@REM call %Temp_Batch%
@REM mkdir Z:\Jenkins\%gitlabSourceRepoName%\%gitlabTargetBranch%\%1\!PROJECT_NAME!\%BUILD_ID%\FactoryTools
@REM echo !PROJECT_NAME!
@REM xcopy Build\Token.mak Z:\Jenkins\%gitlabSourceRepoName%\%gitlabTargetBranch%\%1\!PROJECT_NAME!\%BUILD_ID%\ 
@REM xcopy /y /s .\..\!PROJECT_NAME!_Image\*.* Z:\Jenkins\%gitlabSourceRepoName%\%gitlabTargetBranch%\%1\!PROJECT_NAME!\%BUILD_ID%\ 
@REM echo %gitlabSourceRepoName% %gitlabTargetBranch% %1 !PROJECT_NAME! %BUILD_ID% %date% %time%>Z:\Jenkins\TemporaryValidationList.txt
@REM net use z: /delete
@REM rd /q /s .\..\!PROJECT_NAME!_Image
@REM )
endlocal

:exit_go
del %Temp_Batch% /f
del %Release_Batch% /f
if %BuildError% NEQ 0 err
