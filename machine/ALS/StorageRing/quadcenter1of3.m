%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Quadrupole Center Measurement                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  I.  Start with a typical machine setup to the default mode and user latice
%      >> hwinit
%      Cycle, etc.
%      However, only fill to 60 mA.
%      Turn the fast storage ring injector magnets off
%      The first fill to 60mA, initialize the BPM system,
%         >> bpminit
%         >> cellcontrollerinit
%
%  II. Quadrupole centering experiment
%      1. Start Matlab
%         Use apps2 or apps3 (Linux machine on the table next to the instrumentation racks), 
%              but a Windows machine should be fine too. 
%         >> setpathals
%         Or click the "Accelerator Section?" icon on the Matlab toolbar. 
%         Choose the "Storage Ring"
%         This puts the Matlab session in default user mode.
%
%      2. In Matlab: 
%         a. >> quadcenter1of3;
%         b. Cycle the lattice
%            Fill to 60 mA
%         c. >> quadcenter2of3;
%         d. Cycle the lattice
%            Fill to 60 mA
%         e. >> quadcenter3of3;
%         f. Cycle the lattice
%            Fill to 60 mA
%
%         NOTES
%         1. When the beam current drops below 40 mA, the program will 
%            prompt for a refill.  If there is only 1 or 2 magnets left
%            to do, then just hit <return> without a refilling.  
%         2. Sometimes it is unclear when Matlab is working or is done with 
%            the program.  Hitting return in the command will return a prompt
%            when done or show a "busy" by the start menu at the bottom-left. 
%         3. It takes very roughly 2 hours to do 4 sectors
%         



%%%%%%%%%%%%%%%%%%%%%
% Make the BPM list %
%%%%%%%%%%%%%%%%%%%%%
BPMFamily = 'BPMx';

RemoveDeviceList = [];

% BPMDevList = getlist(BPMFamily);
BPMDevList = [
    1     2
    1     3
    1     8
    1     9
   %2     2  moved to LFB/TFB
    2     3
    2     8
    2     9
    3     2
    3     3
    3     8
    3     9
    4     2  % was low gain
    4     3
    4     5
    4     6
    4     8
    4     9
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
        
        q = quadcenter(QUADFamily, QUADDev, 0);
        
        DCCT = getdcct;    
        if DCCT < 2
            % Redo magnet if the beam dumped
            sound(cos(1:10000));
            fprintf('   Current too low.  Refill to 60 and hit return.\n');
            pause;
            fprintf(' \n');
            q = quadcenter(QUADFamily, QUADDev, 0);
            
        elseif DCCT < 40 && i<size(BPMDevList,1)-1
            sound(cos(1:10000));
            fprintf('   Current too low.  Refill to 60 and hit return.\n');
            pause;
            fprintf(' \n');
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Move data to new directory by date %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DirStart = pwd;
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
sound(cos(1:10000));





%    Tune and tune difference for the 1st points in the merit function (QMS.Tune1): 
%     0.23285    0.24973    0.25402  Horizontal
%     0.18826    0.20632    0.21367  Vertical
%    ===================================================
%    -0.04459   -0.04341   -0.04035  Difference 
% 
%    Tune and tune difference for the 2nd points in the merit function (QMS.Tune2): 
%     0.23193    0.24859    0.25248  Horizontal
%     0.19574    0.21312    0.21981  Vertical
%    ===================================================
%    -0.03619   -0.03547   -0.03267  Difference
%    
%    
% 
%     0.24930    0.24947    0.24961    0.24971    0.24978  Horizontal
%     0.20668    0.20689    0.20708    0.20725    0.20739  Vertical
%    ===================================================
%    -0.04262   -0.04258   -0.04253   -0.04246   -0.04239  Difference 
% 
%    Tune and tune difference for the 2nd points in the merit function (QMS.Tune2): 
%     0.25179    0.25199    0.25215    0.25226    0.25233  Horizontal
%     0.19117    0.19143    0.19166    0.19185    0.19200  Vertical
%    ===================================================
%    -0.06061   -0.06056   -0.06049   -0.06041   -0.06033  Difference
   
   



%
%  I.  Machine and Matlab Setup (only needs to be done once)
%      1. Start Matlab on new Vista workstation or crconm12, crconm22, crconm14
%         >> setpathals
%         Or click the "Accelerator Section?" icon on the Matlab toolbar. 
%         Choose the "Storage Ring"
%         This puts the Matlab session in default user mode.
%
%         For the zero vertical dispersion lattice:
%         >> setoperationalnmode
%         Choose Greg
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
%      2. Set the gun bias to get a slow filling rate.
%         Gun Bias = 45 is a good starting point.
%      3. Fill pattern: 276 bunches  
%      4. Fill to 45 mAmps.
%      5. In Matlab (srcontrol): 
%         a. "Setup for Users"
%         b. "Correct the Global Orbit" 
%            (But do not turn orbit feedback on!)
%      6. Calibrate the BPMs  
%         Note: 1. Only calibrate the BPMs once for the entire shift!
%               2. 31 BPMs failing to calibrate is normal! 
%
%  III. Experiment
%      1. Fill the accelerator and correct the orbit as in Step II.
%      2. In Matlab: 
%         a. >> quadcenter1of3;
%         b. >> quadcenter2of3;
%         c. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV w/ SB (so the beam stays in the machine)
%            Fill if less than 30 mA (see Note #1)
%         d. >> quadcenter3of3;
%         e. Do a mini-cycle of the from 1.9-to-1.5-to-1.9 GeV w/ SB (so the beam stays in the machine)
%            Fill if less than 30 mA (see Note #1)
%         f. >> quadcenterqfa1of2;
%         g. >> quadcenterqfa2of2;
%
%         NOTES
%         1. When the beam current drops below 30 mA, the program will 
%            prompt for a refill.  If there is only 1 or 2 magnets left
%            to do, then just hit <return> without a refilling.  
%            To refill:
%            a. Dump the remaining beam (required to get an even fill)
%            b. Fill the accelerator and correct the orbit as in Step II.
%               (Using the TopOff operational mode)
%         2. Sometimes it is unclear when Matlab is working or is done with 
%            the program.  Hitting return in the command will return a prompt
%            when done or show a "busy" by the start menu at the bottom-left. 
%         
%  IV. Mini-cycle the magnets to return the accelerator to normal operating 
%      conditons (see Note #3)




