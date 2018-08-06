%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Quadrupole Center Measurement                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  I.  Machine and Matlab Setup 
%      (This step only needs to be done once, and it may have already been done)
%      1. Start Matlab on crconm12, crconm22, or crconm14
%         >> setpathals  
%         Or click the "SR Init" icon on the Matlab toolbar.  
%         This puts the Matlab session in default user mode.
%
%      2. In Matlab run 
%         >> hwinit
%         Or click the "HW Init" icon on the Matlab toolbar.
%         This sets a lot of parameter in the storage to their default values.
%         (Like BPM averaging and time constants).
%      3. Cycle
%      4. Longitudinal and transverse feedback off!
%
%  II. Fill Setup (Goal: even fill pattern)
%      1. If there is beam in the machine, scrape it and setup for injection.
%         If there was more than 100 mA in the machine, then wait
%         15 minutes to let everything cool down.
%      2. Use a high fill rate (ie, no change to the Gun Bias)!!!
%      3. Fill pattern: 276 bunches  
%      4. Fill to 45 mAmps.
%      5. In Matlab (srcontrol): 
%         a. "Setup for Users"
%         b. "Correct the Global Orbit" 
%            (But do not turn orbit feedback on!)
%      6. Calibrate the BPMs  
%         Note: 1. Only calibrate the BPMs once for the entire shift!
%               2. 30 BPMs failing to calibrate is normal! 
%
%  III. Experiment
%         Notes about the experiment:
%         1. When the beam current drops below 30 mA, the program will 
%            prompt for a refill.  If there is only 1 or 2 magnets left
%            to do, then just hit <return> without a refilling.  Each run of 
%            quadcentertest has 10 magnets 
%            To refill:
%            a. Dump the remaining beam (required to get an even fill)
%            b. Fill the accelerator and correct the orbit as in Step II.
%               (Using the TopOff operational mode)
%         2. Sometimes it is unclear when Matlab is working or is done with 
%            the program.  Hitting return in the command will return a prompt
%            when done or show a "busy" by the start menu at the bottom-left. 
%         3. Mini-Cycle 1.9-to-1.5-to-1.9 GeV
%            a.  The default TopOff mode does not presenly ramp.  So, change the 
%                Matlab session to the "1.9 GeV, High Tune" mode by running
%                >> setoperationalmode
%                And chose "1.9 GeV, High Tune"
%            b.  In srcontrol 
%                * "Setup for Injection" to ramp to 1.5 GeV
%                Then 
%                * "Setup for User" to ramp back to 1.9 GeV
%            c.  Change back to the TopOff mode and continue measuring the 
%                quadrupole centers:
%                >> setoperationalmode
%                And chose "1.9 GeV, TopOff"
%         4. If the experiment needs to be stopped then try to stop it after
%            finishing one of the a10 steps.
%
%
%      1. Scrape the beam to zero
%         Fill the accelerator and correct the orbit as in Step II.
%      2. In Matlab: 
%         a1. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a2. >> quadcentertest;
%
%         a3. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a4. >> quadcentertest;
%
%         a5. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a6. >> quadcentertest;
%
%         a7. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a8. >> quadcentertest;
%
%         a9. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a10. >> quadcentertest;
%
%      3. Scrape the beam to zero
%         Fill the accelerator and correct the orbit as in Step II.
%      4. In Matlab: 
%         a1. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a2. >> quadcentertest;
%
%         a3. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a4. >> quadcentertest;
%
%         a5. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a6. >> quadcentertest;
%
%         a7. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a8. >> quadcentertest;
%
%         a9. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a10. >> quadcentertest;
%
%      5. Scrape the beam to zero
%         Fill the accelerator and correct the orbit as in Step II.
%      6. In Matlab: 
%         a1. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a2. >> quadcentertest;
%
%         a3. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a4. >> quadcentertest;
%
%         a5. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a6. >> quadcentertest;
%
%         a7. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a8. >> quadcentertest;
%
%         a9. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a10. >> quadcentertest;
%
%      7. Scrape the beam to zero
%         Fill the accelerator and correct the orbit as in Step II.
%      8. In Matlab: 
%         a1. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a2. >> quadcentertest;
%
%         a3. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a4. >> quadcentertest;
%
%         a5. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a6. >> quadcentertest;
%
%         a7. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a8. >> quadcentertest;
%
%         a9. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a10. >> quadcentertest;
%
%      9. Scrape the beam to zero
%         Fill the accelerator and correct the orbit as in Step II.
%     10. In Matlab: 
%         a1. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a2. >> quadcentertest;
%
%         a3. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a4. >> quadcentertest;
%
%         a5. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a6. >> quadcentertest;
%
%         a7. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a8. >> quadcentertest;
%
%         a9. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV (see Note #3)
%             Fill if less than 30 mA (see Note #1)
%         a10. >> quadcentertest;
%
%         
%  IV. Mini-cycle the magnets to return the accelerator to normal operating 
%      conditons (see Note #3)








%%%%%%%%%%%%%%%%%%%%%
% Make the BPM list %
%%%%%%%%%%%%%%%%%%%%%
BPMFamily = 'BPMx';

RemoveDeviceList = [];

% BPMDevList = getlist(BPMFamily);
BPMDevList = [
    1     2
    4     2
    4     3
    4     4
    4     5
    4     6
    4     7
    4     8
    4     9
    12    9
    ];

i = findrowindex(RemoveDeviceList, BPMDevList);
BPMDevList(i,:) = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean out the data directory %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[QUADFamily, QUADDev] = bpm2quad(BPMFamily, BPMDevList(1,:));
q = quadcenterinit(QUADFamily, QUADDev, 1);
DirStart = pwd;
NewDir = 'old';
q.DataDirectory = gotodirectory(q.DataDirectory);
if ~exist(NewDir,'dir')
    mkdir(NewDir);
end
try
    movefile('*.mat', NewDir);
    movefile('quadcenter.log', NewDir);
catch
end
cd(DirStart);



%%%%%%%%%%%%%%%%%%%%%%%%
% Loop on all the BPMs %
%%%%%%%%%%%%%%%%%%%%%%%%
t0 = gettime;
for i = 1:size(BPMDevList,1)    
    [QUADFamily, QUADDev, DelSpos] = bpm2quad(BPMFamily, BPMDevList(i,:));
    
    % Check how close the BPM is to the quad (should base on phase but I didn't want to assume the AT desk was available)
    if abs(DelSpos) < 1
        fprintf('   %d of %d. BPM(%2d,%d)  %s(%2d,%d)  BPM-to-Quad Distance=%f meters\n', i, size(BPMDevList,1), BPMDevList(i,:), QUADFamily, QUADDev, DelSpos);
        
        if BPMDevList(i,2) == 4 || BPMDevList(i,2) == 7
            % QFA
            q = quadcenter(QUADFamily, QUADDev, 2);
        else
            q = quadcenter(QUADFamily, QUADDev, 0);
        end
        
        DCCT = getdcct;    
        if DCCT < 2
            % Redo magnet if the beam dumped
            sound(cos(1:10000));
            fprintf('   Current too low.  Refill and hit return.\n');
            pause;
            fprintf(' \n');
            if BPMDevList(i,2) == 4 || BPMDevList(i,2) == 7
                % QFA
                q = quadcenter(QUADFamily, QUADDev, 2);
            else
                q = quadcenter(QUADFamily, QUADDev, 0);
            end
            
        elseif DCCT < 30 && i<size(BPMDevList,1)-1
            sound(cos(1:10000));
            fprintf('   Current too low.  Refill and hit return.\n');
            pause;
            fprintf(' \n');
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Move data to new directory by date %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DirStart = pwd;
%c = clock;
%NewDir = sprintf('%4d-%02d-%02d', c(1:3));
NewDir = sprintf('%4d-%02d-%02d_%02d-%02d-%02.0f', clock);
cd(q.DataDirectory);
if ~exist(NewDir,'dir')
    try
        mkdir(NewDir);
    catch
    end
end
try
    movefile('*.mat', NewDir);
    fprintf('   Data moved to %s\n', [q.DataDirectory NewDir]);
    try
        movefile('quadcenter.log', NewDir);
    catch
        fprintf('   Error occurred when moving log files to %s\n', [q.DataDirectory NewDir]);
    end
catch
    fprintf('   Error occurred when moving data files to %s\n', [q.DataDirectory NewDir]);
end
cd(DirStart);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print time and wake-up call %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('   Data collection time %f minutes\n', (gettime-t0)/60);


