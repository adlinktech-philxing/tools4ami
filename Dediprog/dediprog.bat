@echo off
setlocal
Path="C:\Program Files (x86)\DediProg\SF Programmer";%PATH%
UsbRelayCh340 COM4 NO
TIMEOUT /T 3
dpcmd.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
UsbRelayCh340 COM4 NC
endlocal
echo on
