:: epics1355make.cmd
::   setup for make of epics 13.5.5 with VS Community 15
::
:: set environment variables
set EPICS_HOST_ARCH=windows-x64
set epicsInstall=C:\epics\base
set perl=C:\Strawberry
:: set path for windows
set PATH=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0;
:: add path for perl/gmake
set PATH=%PATH%%perl%\c\bin;%perl%\perl\site\bin;%perl%\perl\bin;
:: add path for epics installation
set PATH=%PATH%%epicsInstall%\bin\%EPICS_HOST_ARCH%
:: navigate to base directory (does not work after call to vcvarsall)
cd /D %epicsInstall%
:: set ms visual studio 2015 community environment
::   note that comspec finds the command line prompt
::   /k tells the command prompt to stay open upon completion of command
%comspec% /k ""C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"" amd64
:: gmake clean, gmake to build epics