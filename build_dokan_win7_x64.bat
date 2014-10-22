set DOKAN_SRC_PATH=%cd%
call C:\WinDDK\7600.16385.1\bin\setenv.bat C:\WinDDK\7600.16385.1\ chk x64 WIN7
cd %DOKAN_SRC_PATH%
cd sys
build /wcbg