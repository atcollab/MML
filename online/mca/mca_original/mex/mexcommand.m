%MEXCOMMAND Make mcamain.dll from mcamain.cpp
% All options are enecessary to compile properly

% Using local CA dll's
%  mex mcamain.cpp D:\Epics\base\lib\Win32\Com.lib...
%      D:\Epics\base\lib\Win32\ca.lib -DDB_TEXT_GLBLSOURCE ...
%      -D_WIN32 -DEPICS_DLL_NO ...     
%      -ID:\Epics\base\include...
%      -ID:\Epics\base\include\os\WIN32 ...
%      -v

%Using CA libraries on the network drive Q:
mex mcamain.cpp Q:\Groups\Accel\Controls\EPICS\R3.14.4\base\lib\win32-x86\Com.lib ...
    Q:\Groups\Accel\Controls\EPICS\R3.14.4\base\lib\win32-x86\ca.lib -DDB_TEXT_GLBLSOURCE ...
    -D_WIN32 -DEPICS_DLL_NO ...     
    -IQ:\Groups\Accel\Controls\EPICS\R3.14.4\base\include...
    -IQ:\Groups\Accel\Controls\EPICS\R3.14.4\base\include\os\WIN32...
    -v


