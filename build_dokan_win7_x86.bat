set DOKAN_SRC_PATH=%cd%
call C:\WinDDK\7600.16385.1\bin\setenv.bat C:\WinDDK\7600.16385.1\ chk x86 WIN7
cd %DOKAN_SRC_PATH%
cd dokan
build /wcbg
cd ..\dokan_control
build /wcbg
cd ..\dokan_mirror
build /wcbg
cd ..\dokan_mount
build /wcbg
cd ..\sys
build /wcbg