function liberainit(DevList, SlowModeFlag)
%LIBERAINIT(DevList, SlowModeFlag) - Initialization program for the storage ring Libera BPMs
%
% See also libera, getlibera


if nargin < 1 || isempty(DevList)
    DevList = getbpmlist('Libera');
end

% More than 1 libera
if size(DevList,1) > 1
    for i = 1:size(DevList,1)
        if nargin < 2
            liberainit(DevList(i,:));
        else
            liberainit(DevList(i,:),SlowModeFlag);
        end
    end
    return
end

if nargin < 2 || isempty(SlowModeFlag)
    SlowModeFlag = 1;
end


if ischar(DevList)
    % Input can be BPMName directly
    BPMName = DevList;
else
    % BPMName is a DeviceList
    if all(DevList == [3 5])
        BPMName = 'LIBERA_0AB3';  % Sector 03
    elseif all(DevList == [6 5])
        BPMName = 'LIBERA_0AAD';  % Sector 06
    elseif all(DevList == [9 5])
        BPMName = 'LIBERA_0AAC';  % Sector 09
    elseif all(DevList == [12 5])
        BPMName = 'LIBERA_0AB2';  % Sector 12
    else
        error('Device not installed.');
    end
end


% Clear UDF fields
%setpvonline([BPMName, ':ADC:ADC_FINISHED_MONITOR.UDF'], 1);
%setpvonline([BPMName, ':ENV:ENV_GAIN_SP.UDF'], 1);


%%%%%%%%%%%%%%%%%%%%%%%%
% Environmental Fields %
%%%%%%%%%%%%%%%%%%%%%%%%
if SlowModeFlag
    % Slow data
    fprintf('   Initializing the libera BPM %s for slow data.\n', BPMName);
    
    % Switches: 255=AUTO, 15=DIRECT(fixed switches, automatically turns DSC OFF)
    setpvonline([BPMName, ':ENV:ENV_SWITCHES_SP'], 255);

    % DSC: 0=OFF (don't calculate new coefficients), 1=UNITY (coef. not used), 2=AUTO (automatically turns switching on), 3=SAVE_LASTGOOD
    setpvonline([BPMName, ':ENV:ENV_DSC_SP'], 2);

    % AGC: 0=MANUAL, 1=AUTO
    setpvonline([BPMName, ':ENV:ENV_AGC_SP'], 1);
    
else
    % Turn by turn data
    fprintf('   Initializing the libera BPM %s for TbT data.\n', BPMName);
    
    % Switches: 255=AUTO, 15=DIRECT (fixed switches, automatically turns DSC OFF) 0=also 
    setpvonline([BPMName, ':ENV:ENV_SWITCHES_SP'], 15);

    % DSC: 0=OFF, 1=UNITY, 2=AUTO (automatically turns switching on), 3=SAVE_LASTGOOD
    setpvonline([BPMName, ':ENV:ENV_DSC_SP'], 0);   
    %setpvonline([BPMName, ':ENV:ENV_DSC_SP'], 1);   
    %setpvonline([BPMName, ':ENV:ENV_DSC_SP'], 2);   
    
    % AGC: 0=MANUAL, 1=AUTO
    setpvonline([BPMName, ':ENV:ENV_AGC_SP'], 0);
    pause(.1);

    % Set the gain manually
    % ~20,000 counts on the ADC is recommended by IT
    % -33 dBms is 0 attenuation
    Gain = getpv([BPMName, ':ENV:ENV_GAIN_SP']);
    if all(DevList == [12 5])
        % With a splitter:
        % -20      -> 10k counts at 500 mA
        % -30 & 31 -> 17k counts at 500 mA        
        % -32      -> 18k counts at 500 mA
        % -33      -> some saturation at 500 mA        
        GainNew = -32; % -33 for single bunch;  -22
        
         % -33      -> Max gain, good for single bunch (~5k counts at 4.5 mA) 
        GainNew = -33; % -33 for single bunch;  -22;
        
        % MAF (never use!)
        %setpv('LIBERA_0AB2:ENV:ENV_PLL_OFFSETTUNE_SP', 0);
        %LIBERA_0AB2:ENV:ENV_PLL_OFFSETTUNE_MONITOR
        %LIBERA_0AB2:ENV:ENV_PLL_PHASEOFFS_SP
    else
        %GainNew = -11;
        GainNew = -33;
    end
    setpv([BPMName, ':ENV:ENV_GAIN_SP'], GainNew);
    fprintf('   %s gain was %f now %f\n', BPMName, Gain, getpv([BPMName, ':ENV:ENV_GAIN_SP']));
end


% Based on the old BPMs (nm)
% The gain factors on a curved section Bergoz card are X: 0.1613 V/% and Y: 0.1629 V/%
setpv([BPMName, ':ENV:ENV_KX_SP'], 16130000);
setpv([BPMName, ':ENV:ENV_KY_SP'], 16290000);

% Based on a quick [3 5] calibration based on the fast kicker magnet (nm)
%setpv([BPMName, ':ENV:ENV_KX_SP'], 1.4822 * 10000000);
%setpv([BPMName, ':ENV:ENV_KY_SP'], 1.4822 * 10000000);


% FA Port  ???
setpvonline([BPMName, ':FA:FA_LENGTH_SP'], 8192);
setpvonline([BPMName, ':FA:FA_OFFSET_SP'], 0);
%setpvonline([BPMName, ':FA:FA_MEM_READ_CMD'], 1);
%setpvonline([BPMName, ':FA:FA_MEM_WRITE_CMD'], 1);
%setpvonline([BPMName, ':FA:FA_MEM_SP'], 0);


% Disable port acquisitions
setpvonline([BPMName, ':DD1:DD_IGNORE_TRIG_SP'],  1, 'double', 1);
setpvonline([BPMName, ':DD2:DD_IGNORE_TRIG_SP'],  1, 'double', 1);
setpvonline([BPMName, ':DD3:DD_IGNORE_TRIG_SP'],  1, 'double', 1);
setpvonline([BPMName, ':DD4:DD_IGNORE_TRIG_SP'],  1, 'double', 1);
setpvonline([BPMName, ':ADC:ADC_IGNORE_TRIG_SP'], 1, 'double', 1);
% setpvonline([BPMName, ':PM:PM_IGNORE_TRIG_SP'],   1, 'double', 1);


%PV = [BPMName, 'ENV_DSC_SP'];
%fprintf('   %s = %s\n', PV, getpvonline(PV, 'char'));


% % 'ADC'
% 'ADC_IGNORE_TRIG_SP'
% 'ADC_ON_NEXT_TRIG_CMD'
% 
% % 'PM'
% 'PM_IGNORE_TRIG_SP'
% 'PM_ON_NEXT_TRIG_CMD'
% 'PM_REQUEST_CMD'
% 
% % 'FA'
% 'FA_MEM_READ_CMD'
% 'FA_MEM_WRITE_CMD'
% 'FA_LENGTH_SP'
% 'FA_OFFSET_SP'
% 'FA_MEM_SP'
% 
% 
% % {'DD1','DD2','DD3','DD4'}
% 'DD_IGNORE_TRIG_SP'
% 'DD_ON_NEXT_TRIG_CMD'
% 'DD_REQUEST_CMD'
% 'DD_SEEK_POINT_SP'
% 'DD_MT_OFFSET_SP'
% 'DD_ST_OFFSET_SP'
% 
% % 'ENV'
% 'ENV_AGC_SP'
% 'ENV_DSC_SP'
% 'ENV_GAIN_SP'
% 'ENV_KX_SP'
% 'ENV_KY_SP'
% 'ENV_Q_OFFSET_SP'
% 'ENV_X_OFFSET_SP'
% 'ENV_Y_OFFSET_SP'
% 'ENV_SWITCHES_SP'
% 'ENV_COMMIT_MTST_CMD'
% 'ENV_COMMIT_MT_CMD'
% 'ENV_COMMIT_ST_CMD'
% 'ENV_INTERLOCK_CLEAR_CMD'
% 'ENV_SET_INTERLOCK_PARAM_CMD'
% 'ENV_ILK_GAIN_LIMIT_SP'
% 'ENV_ILK_OF_DUR_SP'
% 'ENV_ILK_OF_LIMIT_SP'
% 'ENV_ILK_X_HIGH_SP'
% 'ENV_ILK_X_LOW_SP'
% 'ENV_ILK_Y_HIGH_SP'
% 'ENV_ILK_Y_LOW_SP'
% 'ENV_ILK_MODE_SP'
% 'ENV_SETMTPHASE_SP'
% 'ENV_SETMT_SP'
% 'ENV_SETST_SP'

