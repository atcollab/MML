% This script is designed to run BBA on all BPMs. For manual measurements
% of BPMs please use QUADCENTER_MANUAL
%
% Eugene Tan 09-10-2007
% Eugene Tan 15-01-2008: Modified to check the DCCT instead of just 
 
% Ensure the following are done before carrying out BBA.
% - Inject to 200 mA with cavities at full voltage
% - Injection system turned off (minimise noise)
% - No SOFB program running.
% Will assume for now that AGC will not have an adverse effect since we are
% keeping the beam current to 185 mA and above.
dcctvalue = 200;   % current initally injected to
tol = 15;           % allowable current drop before having to reinject

switch questdlg({'Have the following been done?';...
        sprintf('1. Inject to %3d mA with cavities at full voltage',dcctvalue);...
        '2. Injection system turned off (minimise noise)';...
        '3. No OFB program running';...
        '4. Run "setliberaconfig" to initialise the BPMs';...
        '5. Ramped down the SCW';...
        '6. IDs set correctly';},...
        'Checklist before starting measuring offsets',...
        'Yes','No','No');
    case 'No'
        disp('Bye bye');
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

%Commented for Brilliance+ testing, check with Eugene if it is needed for
%BBA (08/09/2017)
%fprintf('Turning AGC off on the Liberas before continuing...');
%setlibera('ENV_AGC_SP',0); pause(1);
%setlibera('ENV_SET_INTERLOCK_PARAM_CMD',1);
%fprintf('done!\n');

% disp('    The following measurements will be done in 3 parts as follows:');
% disp('        Sectors 1-4, sectors 5-9 followed by 10-14');

% problem BPMs
prob_dev = [];

% Sector number for BPM
for i=1:14
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
                quaddev = [BPMDev(1) 2];
            case 5
                quadfam = 'QDA';
                quaddev = [BPMDev(1) 2];
            case {6 7}
                quadfam = 'QFA';
                quaddev = [BPMDev(1) 2];
        end
        
        try
            % Store corrector magnet setpoints incase an error is
            % encountered which stops quadcenter() from reloading these
            % setpoints.
            HCM0 = getsp('HCM');
            VCM0 = getsp('VCM');
            QFA0 = getsp('QFA');
            QDA0 = getsp('QDA');
            quadcenter(quadfam,quaddev,plane,BPMDev);
        catch
            % quadcenter() encountered an error, reload the magnet
            % setpoints and log which BPMs the error occured for.
            setsp('HCM',HCM0);
            setsp('VCM',VCM0);
            setsp('QFA',QFA0);
            setsp('QDA',QDA0);            
            prob_dev(end+1,1:2) = BPMDev;
        end
        
        %Added to stop window spam (RH - 08/09/17)
        close all;
    end
    
%     fid = fopen('/scratch/mhave/announce/TimeToCorrect5.del','w'); fprintf(fid,'test'); fclose(fid);
%     questdlg('Please correct the orbit.','Orbit correction','Done','Done');      
    
    if getdcct < dcctvalue-tol
        % if the current drops below the tolerance
        
        % ---- File name changed
        %fid = fopen('/scratch/mhave/announce/5mins_to_injection.del','w'); fprintf(fid,'test'); fclose(fid);
        switch questdlg(sprintf('Please refill to %3d mA and correct the orbit before continuing.',dcctvalue),'Refill ring','Done','Cancel','Done');
            case 'Cancel'
                if ~isempty(prob_dev)
                    fprintf('\nSOME PROBLEMS WITH THE FOLLOWING BPMs when doing BBA:\n');
                    fprintf(' %02d %1d\n',prob_dev');
                end
                disp('Leaving BBA. Those that have been done have been saved. Bye bye');
                return
        end
    end

end


if ~isempty(prob_dev)
    fprintf('\nSOME PROBLEMS WITH THE FOLLOWING BPMs when doing BBA:\n');
    fprintf(' %02d %1d\n',prob_dev');
end


return
%% OLD PROGRAM

% % Beam based alignment needs to be done in 3 sections to minimise the beam
% % current dependance and get more accurate results.
% switch questdlg('Please correct the orbit before continuing.','BBA Sectors 1-4','Done','Cancel','Done');
%     case 'Cancel'
%         disp('Leaving BBA. Bye bye');
%         return
% end
% % Sector number for BPM
% for i=1:4
%     % BPM number within the sector
%     for j=1:7
%         
%         BPMDev = [i  j];
%         if getfamilydata('BPMx','Status',BPMDev) == 0
%             continue;
%         end
%         
%         switch BPMDev(2)
%             case {1 2}
%                 quadfam = 'QFA';
%                 quaddev = [BPMDev(1) 1];
%             case 3
%                 quadfam = 'QDA';
%                 quaddev = [BPMDev(1) 1];
%             case 4
%                 quadfam = 'QFB';
%                 quaddev = [BPMDev(1) 2];
%             case 5
%                 quadfam = 'QDA';
%                 quaddev = [BPMDev(1) 2];
%             case {6 7}
%                 quadfam = 'QFA';
%                 quaddev = [BPMDev(1) 2];
%         end
%         
%         try
%             quadcenter(quadfam,quaddev,plane,BPMDev);
%         catch
%             prob_dev(end+1,1:2) = BPMDev;
%         end
%     end
% end
% 
% % Now do sectors 5-9
% % Beam based alignment needs to be done in 3 sections to minimise the beam
% % current dependance and get more accurate results.
% switch questdlg('Inject to 200 mA and correct the orbit before continuing.','BBA Sectors 5-9','Done','Cancel','Done');
%     case 'Cancel'
%         disp('Leaving BBA. Bye bye');
%         return
% end
% % Sector number for BPM
% for i=5:9
%     % BPM number within the sector
%     for j=1:7
%         
%         BPMDev = [i  j];
%         if getfamilydata('BPMx','Status',BPMDev) == 0
%             continue;
%         end
%         
%         switch BPMDev(2)
%             case {1 2}
%                 quadfam = 'QFA';
%                 quaddev = [BPMDev(1) 1];
%             case 3
%                 quadfam = 'QDA';
%                 quaddev = [BPMDev(1) 1];
%             case 4
%                 quadfam = 'QFB';
%                 quaddev = [BPMDev(1) 2];
%             case 5
%                 quadfam = 'QDA';
%                 quaddev = [BPMDev(1) 2];
%             case {6 7}
%                 quadfam = 'QFA';
%                 quaddev = [BPMDev(1) 2];
%         end
%         
%         try
%             quadcenter(quadfam,quaddev,plane,BPMDev);
%         catch
%             prob_dev(end+1,1:2) = BPMDev;
%         end
%     end
% end
% 
% % Now do sectors 10-14
% % Beam based alignment needs to be done in 3 sections to minimise the beam
% % current dependance and get more accurate results.
% switch questdlg('Inject to 200 mA and correct the orbit before continuing.','BBA Sectors 10-14','Done','Cancel','Done');
%     case 'Cancel'
%         disp('Leaving BBA. Bye bye');
%         return
% end
% % Sector number for BPM
% for i=10:14
%     % BPM number within the sector
%     for j=1:7
%         
%         BPMDev = [i  j];
%         if getfamilydata('BPMx','Status',BPMDev) == 0
%             continue;
%         end
%         
%         switch BPMDev(2)
%             case {1 2}
%                 quadfam = 'QFA';
%                 quaddev = [BPMDev(1) 1];
%             case 3
%                 quadfam = 'QDA';
%                 quaddev = [BPMDev(1) 1];
%             case 4
%                 quadfam = 'QFB';
%                 quaddev = [BPMDev(1) 2];
%             case 5
%                 quadfam = 'QDA';
%                 quaddev = [BPMDev(1) 2];
%             case {6 7}
%                 quadfam = 'QFA';
%                 quaddev = [BPMDev(1) 2];
%         end
%         
%         try
%             quadcenter(quadfam,quaddev,plane,BPMDev);
%         catch
%             prob_dev(end+1,1:2) = BPMDev;
%         end
%     end
% end
% 
% if ~isempty(prob_dev)
%     fprintf('\nSOME PROBLEMS WITH THE FOLLOWING BPMs when doing BBA:\n');
%     fprintf(' %02d %1d\n',prob_dev');
% end
% 
% 
% return
% 
% close all
% % 0 = both planes; 1 = x-plane; 2 = y-plane
% plane = 0;
% 
% 
% % Sector number for BPM
% for i=4
%     % BPM number within the sector
%     for j=3
%         
%         BPMDev = [i  j];
% 
%         if getfamilydata('BPMx','Status',BPMDev) == 0
%             continue;
%         end
%         
%         switch BPMDev(2)
%             case {1 2}
%                 quadfam = 'QFA';
%                 quaddev = [BPMDev(1) 1];
%             case 3
%                 quadfam = 'QDA';
%                 quaddev = [BPMDev(1) 1];
%             case 4
%                 quadfam = 'QFB';
%                 quaddev = [BPMDev(1) 1];
%             case 5
%                 quadfam = 'QDA';
%                 quaddev = [BPMDev(1) 2];
%             case {6 7}
%                 quadfam = 'QFA';
%                 quaddev = [BPMDev(1) 2];
%         end
%         
%         quadcenter(quadfam,quaddev,plane,BPMDev);
%     end
% end
% 
% 
% return




% % Possible method but maybe not as reliable
% plane = 2;
% 
% quadstruct(1).quadfam = 'QFA';
% quadstruct(1).quaddev = [];
% quadstruct(1).bpmdev = [];
% quadstruct(1).bpmelemind = [];
% quadstruct(2).quadfam = 'QDA';
% quadstruct(2).quaddev = [];
% quadstruct(2).bpmdev = [];
% quadstruct(2).bpmelemind = [];
% quadstruct(3).quadfam = 'QFB';
% quadstruct(3).quaddev = [];
% quadstruct(3).bpmdev = [];
% quadstruct(3).bpmelemind = [];
% % Sector number
% for i=13:13
%     % BPM number within the sector
%     for j=1:5
%         
%         BPMDev = [i j];
% 
%         switch BPMDev(2)
%             case {1 2}
%                 quadstruct(1).quadfam = 'QFA';
%                 quadstruct(1).quaddev(end+1,:) = [BPMDev(1) 1];
%                 quadstruct(1).bpmdev(end+1,:) = BPMDev;
%                 quadstruct(1).bpmelemind(end+1) = dev2elem('BPMx',BPMDev);
%             case 3
%                 quadstruct(2).quadfam = 'QDA';
%                 quadstruct(2).quaddev(end+1,:) = [BPMDev(1) 1];
%                 quadstruct(2).bpmdev(end+1,:) = BPMDev;
%                 quadstruct(2).bpmelemind(end+1) = dev2elem('BPMx',BPMDev);
%             case 4
%                 quadstruct(3).quadfam = 'QFB';
%                 quadstruct(3).quaddev(end+1,:) = [BPMDev(1) 2];
%                 quadstruct(3).bpmdev(end+1,:) = BPMDev;
%                 quadstruct(3).bpmelemind(end+1) = dev2elem('BPMx',BPMDev);
%             case 5
%                 quadstruct(2).quadfam = 'QDA';
%                 quadstruct(2).quaddev(end+1,:) = [BPMDev(1) 2];
%                 quadstruct(2).bpmdev(end+1,:) = BPMDev;
%                 quadstruct(2).bpmelemind(end+1) = dev2elem('BPMx',BPMDev);
%             case {6 7}
%                 quadstruct(1).quadfam = 'QFA';
%                 quadstruct(1).quaddev(end+1,:) = [BPMDev(1) 2];
%                 quadstruct(1).bpmdev(end+1,:) = BPMDev;
%                 quadstruct(1).bpmelemind(end+1) = dev2elem('BPMx',BPMDev);
%         end
%     end
% end
%     [qms1 qms2] = quadcenter(quadstruct(i).quadfam,quadstruct(i).quaddev,plane,quadstruct(i).bpmdev);
%     
%     switch plane
%         case 1
%             if isstruct(qms1)
%                 hoffsets(quadstruct(i).bpmelemind) = qms1.Center;
%             else
%                 hoffsets(quadstruct(i).bpmelemind) = qms1;
%             end
%         case 2
%             if isstruct(qms1)
%                 voffsets(quadstruct(i).bpmelemind) = qms1.Center;
%             else
%                 voffsets(quadstruct(i).bpmelemind) = qms1;
%             end
%         case 0
%             if isstruct(qms1)c
%                 hoffsets(quadstruct(i).bpmelemind) = qms1.Center;
%                 voffsets(quadstruct(i).bpmelemind) = qms2.Center;
%             else
%                 hoffsets(quadstruct(i).bpmelemind) = qms1;
%                 voffsets(quadstruct(i).bpmelemind) = qms2;
%             end
%     end
% end
% hoffsets = ones(98,1)*NaN;
% voffsets = ones(98,1)*NaN;
% 
% 
% for i=1:length(quadstruct)
%     [qms1 qms2] = quadcenter(quadstruct(i).quadfam,quadstruct(i).quaddev,plane,quadstruct(i).bpmdev);
%     
%     switch plane
%         case 1
%             if isstruct(qms1)
%                 hoffsets(quadstruct(i).bpmelemind) = qms1.Center;
%             else
%                 hoffsets(quadstruct(i).bpmelemind) = qms1;
%             end
%         case 2
%             if isstruct(qms1)
%                 voffsets(quadstruct(i).bpmelemind) = qms1.Center;
%             else
%                 voffsets(quadstruct(i).bpmelemind) = qms1;
%             end
%         case 0
%             if isstruct(qms1)c
%                 hoffsets(quadstruct(i).bpmelemind) = qms1.Center;
%                 voffsets(quadstruct(i).bpmelemind) = qms2.Center;
%             else
%                 hoffsets(quadstruct(i).bpmelemind) = qms1;
%                 voffsets(quadstruct(i).bpmelemind) = qms2;
%             end
%     end
% end