
%loadlibrary('N:\matlab\als\linkwin32\gplink32\Debug\gplink.dll', 'N:\matlab\als\linkwin32\gplink32\gplink.h', 'includepath','z:\include\controls\');
%loadlibrary('Y:\opstat\BIN32\linkbvdd.dll', 'z:\include\controls\llinkc.h', 'includepath','z:\include\controls\');


if ~libisloaded('gplink32')
    loadlibrary('gplink32.dll', '\\Als-filer\physbase\matlab\als\linkwin32\gplink32\gplink.h', 'includepath','z:\include\controls\');
    libfunctions gplink32
end

%Err = libpointer('cstring','');

%Err = libpointer('int');
%calllib('gplink32', 'gpLogon', Err)
calllib('gplink32', 'gpLogon', '')

Err = libpointer('cstring','');
ILCindex = calllib('gplink32', 'gpFindName', 'SR07U___GDS1PS_AM00', Err)


% 
% if ~libisloaded('linkbvdd')
%     loadlibrary('linkbvdd.dll', 'z:\include\controls\llinkc.h', 'includepath','z:\include\controls\');
% end
% 
% libfunctions linkbvdd
% 
% 
% Err = libpointer('uint8',0);
% ILC = libpointer('uint8',0);
% ILCArray = libpointer('uint8', zeros(1,32));
% PassWord = libpointer('uint8',0);
% 
% 
% calllib('linkbvdd', 'Logon', Err, ILC, ILCArray, PassWord)


