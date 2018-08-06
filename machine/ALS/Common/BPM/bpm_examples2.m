%function bpm_testtiming

%BeamDumpDir  = '/home/physdata/BeamDump/';

%%
%Prefix = getfamilydata('BPM','BaseName');
%ADC = bpm_getadc([], 6160, 0);
%TBT = bpm_gettbt([], 80, 0);
%FA  = bpm_getfa( [], 20000, 0);
%ENV = bpm_getenv([]);

%for i = 1:length(TBT)
%    Ts(i,1) = TBT{i}.Ts(1);
%    fprintf('%s %s\n', TBT{i}.PVPrefix, TBT{i}.TsStr(1,:));
%end
% Warning on not all time stamps equal???

% FileName = fullfile(BeamDumpDir, 'BeamBump');
% FileName = appendtimestamp(FileName, ADC{1}.Ts(1,1));
% 
% save(FileName, 'ADC', 'TBT', 'FA', 'ENV', 'Prefix');
% 




%%
%Prefix = getfamilydata('BPM','BaseName');
%ADC2 = bpm_getadc([], [], 0);
%TBT2 = bpm_gettbt([], [], 0);
%FA2  = bpm_getfa( [], [], 0);
%ENV2 = bpm_getenv([]);


%for i = 1:length(TBT2)
%    Ts(i,1) = TBT2{i}.Ts(1);
%    fprintf('%s %s %s\n', TBT2{i}.PVPrefix, ADC2{i}.TsStr(1,:), TBT2{i}.TsStr(1,:));
%end





%% Levon data collection script
% Collects tbt data during injection from all nonbergouz BPMs
% Everything is saved to /home/als/physdata/BPM/AFE6 as 'TBT_Injection_Setx.mat'
if 0
    while 1
        d0 = getdcct % grab current
        bpm_arm('TBT','Wait'); % arm BPMs
        d1 = getdcct % grab current
        if d1 - d0 > 0.015 % if injection occured break
            break
        end
    end
    
    sleep(1);
    TBT = bpm_gettbt; % collect data
end


%% Levon data collection script 2
%
% purpose:  grabbing TBT data from athe BPMs during stable beam.
%           then calculating an std of the TBT data before and after
%           performing an SVD noise reduction algorithm
%
turns = 1000; % Grab only the first 1000 turns (to keep computation time low)
SVDzero = 39; % # of singular values to set to 0
bpm = 27; % random BPM to use for analysis

if 1
    while 1
        d0 = getdcct % grab current
        bpm_arm('TBT','Wait'); % arm BPMs
        d1 = getdcct % grab current
        
        if d1 - d0 < 0  % if no injection occured 
            
            % grab TBT data
            TBT = bpm_gettbt;
            
            % Only need data from a single random BPM
            xPre = TBT{bpm}.X(1:turns);
            yPre = TBT{bpm}.Y(1:turns);
            
            % Inialize arrays
            BPMxPre = zeros(turns,length(TBT));
            BPMyPre = zeros(turns,length(TBT));
            
            % Put BPM data into a BPM matrix P x M (turns x bpm#)
            for i = 1:turns
                for j = 1:length(TBT)
                    BPMxPre(i,j) = TBT{j}.X(i);
                    BPMyPre(i,j) = TBT{j}.Y(i);
                end
            end
            
            % Compute SVD
            [Ux,Sx,Vx] = svd(BPMxPre);
            [Uy,Sy,Vy] = svd(BPMyPre);
            
            % perform singular value noise reduction
            lngx = size(Sx,2);
            lngy = size(Sy,2);
            for i = 1:SVDzero
                Sx(lngx+1-i,lngx+1-i) = 0;
                Sy(lngy+1-i,lngy+1-i) = 0;
            end
            
            % Recompute BPM matrix 
            BPMxPost = Ux*Sx*Vx;
            BPMyPost = Uy*Sy*Vy;
            
            % Grab post analysis BPM data for our random BPM
            xPost = BPMxPost(:,bpm);
            yPost = BPMyPost(:,bpm);
            
            % Grab std measurements
            xPreSTD = std(xPre);
            yPreSTD = std(yPre);
            xPostSTD = std(xPost);
            yPostSTD = std(yPost);
            
            % Save std data into a txt file
            fid = fopen('/home/als1/acct/levondov/public/std_data.txt', 'at');
            fprintf(fid,'%d %d %d %d \n',xPreSTD,yPreSTD,xPostSTD,yPostSTD);
            fclose(fid);
            
            % sleep for 1 minute and repeat
            sleep(60)
        end
    end
end
%%
%cd /home/physdata/BPM/AFE6
%load TBT_Injection_Set1
%clf reset;
%for i = 1:43;
%    hold on;
%    plot(TBT{i}.S-TBT{i}.S(1),'Color',nxtcolor);
%end