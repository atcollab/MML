function [SRcurrent]=clsMonitorSrCurrent(seconds)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsMonitorSrCurrent.m 1.2 2007/03/02 09:03:16CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

SRcurrent=[];
figure;

if ~exist('seconds')
    seconds = 3600;
end    
%[FileName, DirectoryName] = uigetfile('*.dat', 'Select a filename to save current monitor vals', DirectoryName);
FileName = 'DAT';
DirectoryName = getfamilydata('Directory','OpsData');
FileName = appendtimestamp(FileName, clock);
[FileName, DirectoryName] = uiputfile('*.dat','Save Data File', [DirectoryName FileName]);
%monitor for an hour
fprintf('Acquiring SR current data for %d seconds\n',seconds);
fprintf('Each # equals 5 seconds:>\n>');

minutes = 1;
for i=1:seconds
    SRcurrent(i)=getSRCurrent;
    if(mod(i,5) == 0)
        fprintf('#');
    end    
        
    if(mod(i,60) == 0)
        fprintf('> minute %d\n>',minutes);
        minutes = minutes + 1;
    end    
    plot(SRcurrent);
    title('STORAGE RING CURRENT');
    XLABEL('Seconds');
    YLABEL('milliamps');
    pause(1.0);
end
fprintf('DONE!!\n\nSR Current Measurement Complete\n');    
%save current to disk
%save SRcurrent;
% Save to file
DirStart = pwd;
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);            
save(FileName, 'SRcurrent');
cd(DirStart);
fprintf('   Check %s for your data\n', DirectoryName);


function [srcrnt]=getSRCurrent
% To measure the baseline, set baseline to zero and measure the current
baseline = 2.0618;

klystron_pv = mcagethandle('CRYOSTAT:KFP');
rfload_pv = mcagethandle('CRYOSTAT:RFLFP');

while klystron_pv(1) == 0
    disp('Opening PV : CRYOSTAT:KFP')
    klystron_pv = mcaopen('CRYOSTAT:KFP');
    pause(0.3);
end

while rfload_pv(1) == 0
    disp('Opening PV : CRYOSTAT:RFLFP')
    rfload_pv = mcaopen('CRYOSTAT:RFLFP');
    pause(0.3);
end

srcrnt=(mcaget(klystron_pv(1))-mcaget(rfload_pv(1)))/0.876 - baseline;

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsMonitorSrCurrent.m  $
% Revision 1.2 2007/03/02 09:03:16CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
