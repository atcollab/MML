function bpm_trigger(Action, Prefix, varargin)
%BPM_TRIGGER - This function trigger the ring BPMs


if nargin < 1
     Action = 'Software';
end
if nargin < 2 || isempty(Prefix)
    Prefix = getfamilydata('BPM','BaseName');
end
if ischar(Prefix)
    if size(Prefix,1) > 1
        for i = 1:size(Prefix,1)
            bpm_trigger(Action, deblank(Prefix(i,:)));
        end
        return
    else
        tmp = Prefix;
        clear Prefix
        Prefix{1} = tmp(1,:);
    end
elseif iscell(Prefix)

else
    % DeviceList input
    DeviceList = Prefix(1,:);
    Prefix =  getfamilydata('BPM','BaseName', DeviceList);
    for i = 1:length(Prefix)
        bpm_trigger(Action, Prefix{i});
    end
    return
end


Npre  = 0;
Npost = 0;
for i = 1:length(Prefix)    
    % Max FA length
    NN = getpvonline([Prefix{i},':wfr:FA:pretrigCount']);
    if NN > Npre
        Npre = NN;
    end
    NN = getpvonline([Prefix{i},':wfr:FA:acqCount']) - getpvonline([Prefix{i},':wfr:FA:pretrigCount']);
    if NN > Npost
        Npost = NN;
    end
end

        
DCCT0 = getdcct;
switch lower(Action)
    case {'arm'}
        % Arm only        
        for i = 1:length(Prefix)
            setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
            setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
            setpvonline([Prefix{i},':wfr:FA:arm'],  1);
        end
        
    case {'extraction', 'armextraction'}
        % DisArm
        for i = 1:length(Prefix)
            setpvonline([Prefix{i},':wfr:ADC:arm'], 0);
            setpvonline([Prefix{i},':wfr:TBT:arm'], 0);
            setpvonline([Prefix{i},':wfr:FA:arm'],  0);
        end
        
        for i = 1:length(Prefix)
            % Trigger mask
            setpvonline([Prefix{i},':wfr:ADC:triggerMask'], hex2dec('20'));
            setpvonline([Prefix{i},':wfr:TBT:triggerMask'], hex2dec('20'));
            setpvonline([Prefix{i},':wfr:FA:triggerMask'],  hex2dec('20'));
            
            % Event triggers
            setpvonline([Prefix{i},':EVR:event11trig'],  bin2dec('00000000'));
            setpvonline([Prefix{i},':EVR:event12trig'],  bin2dec('00000000'));
            setpvonline([Prefix{i},':EVR:event13trig'],  bin2dec('00000000'));
            setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00000000'));
        end
        
        % Arm
        for i = 1:length(Prefix)
            setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
            setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
            setpvonline([Prefix{i},':wfr:FA:arm'],  1);
        end

        % It seems the delay must be greater than the pretrigger buffer fill time
        pause(Npre/10000 + .2);

        % Trigger mask
        for i = 1:length(Prefix)            
            % Event triggers
            setpvonline([Prefix{i},':EVR:event11trig'],  bin2dec('00000000'));
            setpvonline([Prefix{i},':EVR:event12trig'],  bin2dec('00100000'));
            setpvonline([Prefix{i},':EVR:event13trig'],  bin2dec('00000000'));
            setpvonline([Prefix{i},':EVR:event122trig'], bin2dec('00000000'));
        end
        
        pause(1.4);
        
    case {'software', 'soft'}
        % Arm + Software Trigger
        for i = 1:length(Prefix)
            % Arm
            setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
            setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
            setpvonline([Prefix{i},':wfr:FA:arm'],  1);
        end
        
        % It seems the delay must be greater than the pretrigger buffer fill time
        pause(Npre/10000 + .2);
        
        % Software trigger
        for i = 1:length(Prefix)
            setpvonline([Prefix{i},':wfr:softTrigger'], 1);
        end
          
end
DCCT1 = getdcct;


% Wait for data should depend on buffer and buffer size?
pause(Npost/10000 + .25);
%pause(5.5);  % Max is 5 seconds

fprintf('   DCCT  Start=%.2f  END = %.2f\n', DCCT0, DCCT1);





% for i = 1:length(Prefix)
%     % Unarm
%     setpvonline([Prefix{i},':wfr:ADC:arm'], 0);
%     setpvonline([Prefix{i},':wfr:TBT:arm'], 0);
%     setpvonline([Prefix{i},':wfr:FA:arm'],  0);
% end
% 
% for i = 1:length(Prefix)
%     % Default trigger mask
%     setpvonline([Prefix{i},':wfr:ADC:triggerMask'], hex2dec('3'));
%     setpvonline([Prefix{i},':wfr:TBT:triggerMask'], hex2dec('3'));
%     setpvonline([Prefix{i},':wfr:FA:triggerMask'],  hex2dec('3'));
% end
