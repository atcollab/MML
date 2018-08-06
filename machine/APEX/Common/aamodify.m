function [Status, Result] = aamodify(Action)
%AAMODIFY
%    aamodify('startall')  -> Add all the PVs to the archiver
%    aamodify('rmall')     -> Remove all the PVs from the archiver 
%    ... more coming
% 

% Written by Greg Portmann


if nargin < 1
    error('Need an action input.');
   %Action = 'All';
   %Action = '';
end
DirStart = pwd;                                               % Save the starting directory
cd /remote/apex/hlc/matlab/applications/ArchiverAppliance/py  % Goto the archiver PV directory


if strcmpi(Action, 'startall')    
    
    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/addPVsFromFile.py -v -m MONITOR -s apex2.als.lbl.gov -t 30 APEX_Archiver_BI_1.txt');
    [Status, Result{1}] = unix(CommandStr);
    
    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/addPVsFromFile.py -v -m MONITOR -s apex2.als.lbl.gov -t 30 APEX_Archiver_BI_2.txt');
    [Status, Result{1}] = unix(CommandStr);
    
    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/addPVsFromFile.py -v -m MONITOR -s apex2.als.lbl.gov -t 30 APEX_Archiver_BO_1.txt');
    [Status, Result] = unix(CommandStr)
    
    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/addPVsFromFile.py -v -m MONITOR -s apex2.als.lbl.gov -t 30 APEX_Archiver_BO_2.txt');
    [Status, Result] = unix(CommandStr)
    
    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/addPVsFromFile.py -v -m MONITOR -s apex2.als.lbl.gov -t 30 APEX_Archiver_MBBI.txt');
    [Status, Result] = unix(CommandStr)
    
    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/addPVsFromFile.py -v -m MONITOR -s apex2.als.lbl.gov -t 30 APEX_Archiver_MBBO.txt');
    [Status, Result] = unix(CommandStr)
     
    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/addPVsFromFile.py -v -m SCAN -s apex2.als.lbl.gov -t 30 APEX_Archiver_AI_1.txt');
    [Status, Result] = unix(CommandStr)
    
    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/addPVsFromFile.py -v -m MONITOR -s apex2.als.lbl.gov -t 30 APEX_Archiver_AO_1.txt');
    [Status, Result] = unix(CommandStr)
    
    % CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/addPVsFromFile.py -v -m SCAN -s apex2.als.lbl.gov -t 600 APEX_Archiver_Waveforms.txt');
    % [Status, Result] = unix(CommandStr)
    
    % importNewPVs.py didn't work for me
    %CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/importNewPVs.py -v -s apex2.als.lbl.gov -t 30 Sol1:CurrentRBV');
    %CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/importNewPVs.py -v -s apex2.als.lbl.gov -t 30 APEX_Archiver_AMs.txt');

elseif strcmpi(Action, 'rm')
    
    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/deletePVsFromFile.py pvstoabort.txt');
    [Status, Result] = unix(CommandStr);

elseif strcmpi(Action, 'rmall')    
    
    % Valid PVs, but don't archive - PV name length?
    %Gun:RF:Cav_1_3_4_Anode_2_Outlet_Temp_Intlk
    %Gun:RF:Cav_2_5_Anode_1_Outlet_Temp_Intlk
    %Gun:RF:RF_Window_Coupler_Outlet_Temp_Intlk

    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/deletePVsFromFile.py APEX_Archiver_BI_1.txt');
    [Status, Result{1}] = unix(CommandStr);

    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/deletePVsFromFile.py APEX_Archiver_BI_2.txt');
    [Status, Result{1}] = unix(CommandStr);

    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/deletePVsFromFile.py APEX_Archiver_BO_1.txt');
    [Status, Result] = unix(CommandStr)

    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/deletePVsFromFile.py APEX_Archiver_BO_2.txt');
    [Status, Result] = unix(CommandStr)

    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/deletePVsFromFile.py APEX_Archiver_MBBI.txt');
    [Status(2), Result{2}] = unix(CommandStr)

    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/deletePVsFromFile.py APEX_Archiver_MBBO.txt');
    [Status(2), Result{2}] = unix(CommandStr)

    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/deletePVsFromFile.py APEX_Archiver_AI_1.txt');
    [Status, Result] = unix(CommandStr)

    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/deletePVsFromFile.py APEX_Archiver_AO_1.txt');
    [Status, Result] = unix(CommandStr)
    
    
elseif strcmpi(Action, 'clearNeverConnectedPVs')
    % 39 char PV Name length ????
    
    % Write to file
    
    aa = ArchAppliance;
    %   m{1}{1}
    %     requestTime: 'May/12/2014 18:46:23 PDT'
    %          pvName: 'Sol1Quad2:ShuntTemp'
    m = aa.getNeverConnectedPVs;
    
    StartDir = pwd;
    cd /remote/apex/hlc/matlab/applications/ArchiverAppliance/py
    fid = fopen('NeverConnectedPVs.txt','w');
    for i = 1:length(m{1})
        fprintf(fid, '%s\n', m{1}{i}.pvName);
    end
    fclose(fid);
    cd(StartDir);
         
    CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/deletePVsFromFile.py NeverConnectedPVs.txt');
    [Status, Result] = unix(CommandStr)
         
elseif ischar(Action)
%     % FileName of PVs
%     if isempty(Action)
%         DirectoryName = '.';
%         [FileName, DirectoryName] = uigetfile('*.txt', 'PV file to ...', DirectoryName);
%         if FileName == 0
%             disp('   No changes made to the archiver (addtoarchiver).')
%             return
%         end
%     else 
%         [DirectoryName, FileName, EXT] = fileparts(Action);
%     end
%     cd(DirectoryName);
% 
%     % 30 seconds scans
%     % Add 30 monitors, etc. ???
%     CommandStr = sprintf('python /remote/apex/hlc/matlab/applications/ArchiverAppliance/py/addPVsFromFile.py -v -m MONITOR -s apex2.als.lbl.gov -t 30 %s', FileName);
%     
%     [Status, Result] = unix(CommandStr)
    
else
    Status = 0;
    Result = {};
    disp('   Unknown action (aamodify).')
end

cd(DirStart);            % Goto the starting directory


% Notes from Bob Gunion
% It’s pretty simple; for adding pvs do:
% python importNewPVs.py -—help
% python addPVsFromFile.py -—help
% to get usage.  I’m using python 2.7.  The input file is one pv name per line.  
% You could hack away at it to read the interval, method, etc. from the file; 
% currently they’re command-line arguments so are applied to all pvs in the file.
