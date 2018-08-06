function bts_trajectory_feedback(varargin)
% bts_trajectory_feedback
%
% Uses all BTS BPMs (the last one of which is unfortunately located before
% HCM/VCM 8+9) to correct the trajectory in the BTS line. It uses least
% square matrix inversion (not SVD) and uses BR2 SEN, SEK, BTS B1-B4 in the
% horizontal plane and VCM 1, 3, 6 in the vertical plane.
%
% It uses a never ending loop and monitors the BTS BPM readings and
% executes a feedback step, whenever they update (i.e. every 1.4 s when
% filling from scratch, or every top-off injection shot when in to-off
% mode). The gain of the feedback currently is set to 0.1, i.e. after a big
% change, it will take at least 10 injection shots to correct things back
% to normal. However, this reduces the sensitivity to the shot to shot
% jitter and is definitely fast enough to correct for long term drifts.
%
% Christoph Steier, August 2016

% The following files contain the data of the trajectory response matrix
% measurements, as well as the definition of which actuators (SEN, SEK,
% B1-B4, VCM1,2,3,9) were used to measure it.

if ~strcmp(getfamilydata('SubMachine'),'BTS')
    setpathals('BTS');
end
    
if ispc
    load('\\Als-filer\physdata\matlab\BTSData\19INJ\BPM\bts_transfer_matrix_tmp_20160807T092557.mat');
else
    load('/home/als/physdata/matlab/BTSData/19INJ/BPM/bts_transfer_matrix_tmp_20160807T092557.mat');
end

% Save BTS machine configuration at the start of the trajectory feedback to
% allow easy restoration of that state in case there is a problem with the
% feedback.

getmachineconfig('Archive');

% Set BPMs to correct attenuation

if strcmp(getpvonline('SR_mode'),'1.9 GeV, Two-Bunch')
    setpv('BPM','Attn',1);
else
    setpv('BPM','Attn',18);
end

% User can select, whether to read the tajectory data of the last hour from
% the archiver and use the average of that as the golden orbit the feedback
% corrects to, or whether to use a predefined golden orbit (hard coded in
% this routine), which was used at the time this routine was commissioned.

DataFlag = []; %Removed archiver choice since it causes problems, T.Scarvie, 2018-01-26
% DataFlag = questdlg({'BTS golden orbit selection!',' ','Do you want to use a preset golden orbit or recent archiver data?'},'Archiver','Archiver','Golden','Golden');

disp('   ');
disp('   Correcting to the golden BTS trajectory.');
disp('   ');

if strcmp(DataFlag,'Archiver')
    lendat=30;
    BTSBPMxNames = ['BTS:BPM1:SA:X';'BTS:BPM2:SA:X';'BTS:BPM3:SA:X'; ...
        'BTS:BPM4:SA:X';'BTS:BPM5:SA:X';'BTS:BPM6:SA:X'];
    BTSBPMyNames = ['BTS:BPM1:SA:Y';'BTS:BPM2:SA:Y';'BTS:BPM3:SA:Y'; ...
        'BTS:BPM4:SA:Y';'BTS:BPM5:SA:Y';'BTS:BPM6:SA:Y'];
    
    nowstr=datestr(now,30);nowstr=nowstr(1:8);
    try
        arread(nowstr);
    catch
        nowstr=datestr(now-1,30);nowstr=nowstr(1:8);
        arread(nowstr);
    end
    
    BTSBPMx = arselect(BTSBPMxNames);
    BTSBPMy = arselect(BTSBPMyNames);
    
    if length(BTSBPMx)<lendat
        nowstr=datestr(now-1,30);nowstr=nowstr(1:8);
        arread(nowstr);
        
        BTSBPMx = [arselect(BTSBPMxNames) BTSBPMx];
        BTSBPMy = [arselect(BTSBPMyNames) BTSBPMy];
    end
    
    figure;
    subplot(2,1,1)
    plot((1:length(BTSBPMx))/20,BTSBPMx);
    hold on
    plot(((length(BTSBPMx)+1-lendat):length(BTSBPMx))/20,BTSBPMx(:,end+1-lendat:end),'o');
    xlabel('t [h]');
    ylabel('BTS BPM x [mm]');
    title('History of BTS BPMs');
    
    subplot(2,1,2)
    plot((1:length(BTSBPMy))/20,BTSBPMy);
    hold on
    plot(((length(BTSBPMy)+1-lendat):length(BTSBPMy))/20,BTSBPMy(:,end+1-lendat:end),'o');
    xlabel('t [h]');
    ylabel('BTS BPM y [mm]');
    
    % take average of the last 30 points, i.e. 1.5 hours
    bpmxgolden = mean(BTSBPMx(:,end+1-lendat:end),2)';
    bpmygolden = mean(BTSBPMy(:,end+1-lendat:end),2)';
    
else
    % empirical golden orbit, used during commissioning of this routine 
    % (user ops data from 2016-08-07), for a BPM attenuation setting of 
    % 15 and 4 gun bunches.
    bpmxgolden = [2.12;-2.24;1.59;4.66;0.01;4.77]';
    bpmygolden = [0.51;1.69;0.48;1.70;1.67;1.56]';
end

% calculate response matrix based on trajectory data in data file
respxmat = bpmx-ones(10,1)*bpmx0;
respymat = bpmy-ones(10,1)*bpmy0;
respmat = [respxmat,respymat];

% exclude VCM2 from response matrix, since it is somewhat degenerate with
% VCM1/3 and the least square matrix inversion could lead to build up of
% fake corrector strength.
respmat(8,:) = [];
deltasp(8) = [];
channames(8) = [];
chanindex(8,:)=[];

% record starting setpoints of actuators being used in order to protect
% later against changing them by too much
startSP = zeros(length(channames),1);
currentSP = zeros(length(channames),1);

for loop = 1:length(channames)
    startSP(loop) = getsp(channames{loop},chanindex(loop,:));
end

% empirical limits of setpoint changes at which the feedback disables
% itself (continues to run, just does not change the setpoints anymore).
% 200 V for SEN, 100 V for SEK, 10 A for BTS B1-B4 and 2 A for the VCMs.

deltalimit = [200 100 10 10 10 10 2 2 2];

% bpmx/y_old is being used to check for updated BPM data, soi that this
% routine only executes a feedback step, if a booster shot passed through
% the BTS line.

bpmx_old=getpv('BPMx');
bpmy_old=getpv('BPMy');

while 1
    bpmx_new=getpv('BPMx');
    bpmy_new=getpv('BPMy');
    bpm_sum=getpv('BPMx','Sum');
    
    % only run if a new booster shot has passed through the BTS line
    if any(bpmx_new~=bpmx_old) || any(bpmy_new~=bpmy_old)    
        
        % step in SP, as a fraction of the step used to measure the respone
        % matrix.
        deltanew = respmat' \ [bpmx_new'-bpmxgolden,bpmy_new'-bpmygolden]';
        
        for loop = 1:length(channames)
            currentSP(loop) = getsp(channames{loop},chanindex(loop,:));
        end

        % only implement correction if all BPM sum signals are large
        % enough, the BPM x+y readings are within range and no actuator
        % setpoints would fall outside previously defined limits.
        
        if (min(bpm_sum)>20000) && (max(abs(bpmx_new))<10) && (max(abs(bpmy_new))<10) && ...
                ~any(abs(startSP-(currentSP-0.1.*deltanew.*deltasp))>deltalimit')
            
            % Implement correction
            for loop = 1:length(channames)
                stepsp(channames{loop},-0.1*deltanew(loop)*deltasp(loop),chanindex(loop,:));
            end
            fprintf('%s: Stepping BR SEK+SEN; BTS B1-B4, BTS VCM 1,3,6 for BTS trajectory correction\n',datestr(now,30));
        else
            disp('Skipping feedback step, either BPM sum signal is too small, BPMx/BPMy are outside expected range, or setpoint change is too large');
            fprintf('min BPM sum = %g, max BPMx = %g mm, max BPMy = %g mm\n',min(bpm_sum),max(abs(bpmx_new)),max(abs(bpmy_new)));
        end
        
        bpmx_old=bpmx_new;bpmy_old=bpmy_new;
    end        
    pause(1.4);
end


   
