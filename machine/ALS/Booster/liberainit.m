function liberainit(DevList)
%LIBERAINIT - Initialization program for the booster ring Libera BPMs

if nargin < 1 || isempty(DevList)
    DevList = getbpmlist('Libera');
end

% More than 1 libera
if size(DevList,1) > 1
    for i = 1:size(DevList,1)
        liberainit(DevList(i,:));
    end
    return
end


if ischar(DevList)
    % Input can be BPMName directly
    BPMName = DevList;
else
    % BPMName is a DeviceList
    BPMName = 'LIBERA_0A7E';     % 0-d0-50-31-a-7e.dhcp.lbl.gov
end



%%%%%%%%%%%%%%%%%%%%%%%%
% Environmental Fields %
%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    % Slow data
    fprintf('   Initializing the libera BPM %s for slow data.\n', BPMName);
    
    % Switches: 255=AUTO, 15=DIRECT(fixed switches, automatically turns DSC OFF)
    setpvonline([BPMName, ':ENV:ENV_SWITCHES_SP'], 255);

    % DSC: 0=OFF, 1=UNITY, 2=AUTO (automatically turns switching on), 3=SAVE_LASTGOOD
    setpvonline([BPMName, ':ENV:ENV_DSC_SP'], 2);

    % AGC: 0=MANUAL, 1=AUTO
    setpvonline([BPMName, ':ENV:ENV_AGC_SP'], 1);
    
else
    % Turn by tune data
    fprintf('   Initializing the libera BPM %s for TbT data.\n', BPMName);
    
    % Switches: 255=AUTO, 15=DIRECT(fixed switches, automatically turns DSC OFF)
    setpvonline([BPMName, ':ENV:ENV_SWITCHES_SP'], 15);

    % DSC: 0=OFF, 1=UNITY, 2=AUTO (automatically turns switching on), 3=SAVE_LASTGOOD
    setpvonline([BPMName, ':ENV:ENV_DSC_SP'], 0);
    
    % AGC: 0=MANUAL, 1=AUTO
    setpvonline([BPMName, ':ENV:ENV_AGC_SP'], 0);
    pause(.1);

    % Single bunch ???
    Gain = getpv([BPMName, ':ENV:ENV_GAIN_SP']);
    setpv([BPMName, ':ENV:ENV_GAIN_SP'], -33);   % -33 dBms is 0 attenuation  (~20,000 counts on the ADC is recommended by IT)
    fprintf('   %s gain was %f now %f\n', BPMName, Gain, getpv([BPMName, ':ENV:ENV_GAIN_SP']));
end


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
setpvonline([BPMName, ':PM:PM_IGNORE_TRIG_SP'],   1, 'double', 1);



% Calibration constants
% kx, ky in nm

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

