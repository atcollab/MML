% Ensure the following are done before carrying out BBA.
% - Inject to 200 mA with cavities at full voltage
% - Injection system turned off (minimise noise)
% - No SOFB program running.
switch questdlg({'Have the following been done?';...
        '1. Inject to 200 mA with cavities at full voltage';...
        '2. Injection system turned off (minimise noise)';...
        '3. No SOFB program running'},...
        'Checklist before starting measuring offsets',...
        'Yes','No','No');
    case 'No'
        return;
end
fprintf('\nStarting BBA...\n');

% Choose which plane
switch questdlg('Which plane to measure?',...
        'Plane selection',...
        'Both','Horizontal','Vertical','Both');
    case 'Both'
        plane = 0;
    case 'Horizontal'
        plane = 1;
    case 'Vertical'
        plane = 2;
    otherwise
        disp('Unknown selection! Quitting');
        return
end
fprintf('Plane selected (0-both, 1-Horiz, 2-Vert): %d\n',plane);

% Beam based alignment needs to be done in 3 sections to minimise the beam
% current dependance and get more accurate results.
switch questdlg('You are about to perform Beam Based Alignment and can take up to 3 hours. Continue?',...
        'Final Check',...
        'Yes','No','No');
    case 'No'
        disp('Bye Bye');
        return;
end
disp('The following measurements will be done in 3 parts as follows:');
disp('        Sectors 1-4, sectors 5-9 followed by 10-14');

% problem BPMs
prob_dev = [];

% Beam based alignment needs to be done in 3 sections to minimise the beam
% current dependance and get more accurate results.
switch questdlg('Please correct the orbit before continuing.','BBA Sectors 1-4','Done','Cancel','Done');
    case 'Cancel'
        disp('Leaving BBA. Bye bye');
        return
end
% Sector number for BPM
for i=1:4
    % BPM number within the sector
    for j=1:7
        
        BPMDev = [i  j];
        if getfamilydata('BPMx','Status',BPMDev) == 0
            continue;
        end
        
        switch BPMDev(2)
            case {1 2}
                quadfam = 'QFA';
                quaddev = [BPMDev(1) 1];
            case 3
                quadfam = 'QDA';
                quaddev = [BPMDev(1) 1];
            case 4
                quadfam = 'QFB';
                quaddev = [BPMDev(1) 1];
            case 5
                quadfam = 'QDA';
                quaddev = [BPMDev(1) 2];
            case {6 7}
                quadfam = 'QFA';
                quaddev = [BPMDev(1) 2];
        end
        
        try
%             quadcenter(quadfam,quaddev,plane,BPMDev);
        catch
            prob_dev(end+1,1:2) = BPMDev;
        end
    end
end

% Now do sectors 5-9
% Beam based alignment needs to be done in 3 sections to minimise the beam
% current dependance and get more accurate results.
switch questdlg('Inject to 200 mA and correct the orbit before continuing.','BBA Sectors 5-9','Done','Cancel','Done');
    case 'Cancel'
        disp('Leaving BBA. Bye bye');
        return
end
% Sector number for BPM
for i=5:9
    % BPM number within the sector
    for j=1:7
        
        BPMDev = [i  j];
        if getfamilydata('BPMx','Status',BPMDev) == 0
            continue;
        end
        
        switch BPMDev(2)
            case {1 2}
                quadfam = 'QFA';
                quaddev = [BPMDev(1) 1];
            case 3
                quadfam = 'QDA';
                quaddev = [BPMDev(1) 1];
            case 4
                quadfam = 'QFB';
                quaddev = [BPMDev(1) 1];
            case 5
                quadfam = 'QDA';
                quaddev = [BPMDev(1) 2];
            case {6 7}
                quadfam = 'QFA';
                quaddev = [BPMDev(1) 2];
        end
        
        try
%             quadcenter(quadfam,quaddev,plane,BPMDev);
        catch
            prob_dev(end+1,1:2) = BPMDev;
        end
    end
end

% Now do sectors 10-14
% Beam based alignment needs to be done in 3 sections to minimise the beam
% current dependance and get more accurate results.
switch questdlg('Inject to 200 mA and correct the orbit before continuing.','BBA Sectors 10-14','Done','Cancel','Done');
    case 'Cancel'
        disp('Leaving BBA. Bye bye');
        return
end
% Sector number for BPM
for i=10:14
    % BPM number within the sector
    for j=1:7
        
        BPMDev = [i  j];
        if getfamilydata('BPMx','Status',BPMDev) == 0
            continue;
        end
        
        switch BPMDev(2)
            case {1 2}
                quadfam = 'QFA';
                quaddev = [BPMDev(1) 1];
            case 3
                quadfam = 'QDA';
                quaddev = [BPMDev(1) 1];
            case 4
                quadfam = 'QFB';
                quaddev = [BPMDev(1) 1];
            case 5
                quadfam = 'QDA';
                quaddev = [BPMDev(1) 2];
            case {6 7}
                quadfam = 'QFA';
                quaddev = [BPMDev(1) 2];
        end
        
        try
%             quadcenter(quadfam,quaddev,plane,BPMDev);
        catch
            prob_dev(end+1,1:2) = BPMDev;
        end
    end
end

if ~isempty(prob_dev)
    fprintf('\nSOME PROBLEMS WITH THE FOLLOWING BPMs when doing BBA:\n');
    fprintf(' %02d %1d\n',prob_dev');
end