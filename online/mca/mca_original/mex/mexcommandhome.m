% Using local CA dll's
mex mcamain.cpp D:\Epics\base\lib\Win32\Com.lib...
    D:\Epics\base\lib\Win32\ca.lib -DDB_TEXT_GLBLSOURCE ...
    -D_WIN32 -DEPICS_DLL_NO ...     
    -ID:\Epics\base\include...
    -ID:\Epics\base\include\os\WIN32 ...
    -v

% Using CA libraries on Q:
mex mcamain.cpp Q:\Controls\EPICS\R3.13.4\base\lib\Win32\Com.lib...
    Q:\Controls\EPICS\R3.13.4\base\lib\Win32\ca.lib -DDB_TEXT_GLBLSOURCE ...
    -D_WIN32 -DEPICS_DLL_NO ...     
    -IQ:\Controls\EPICS\R3.13.4\base\include...
    -IQ:\Controls\EPICS\R3.13.4\base\include\os\WIN32 ...
    -v

