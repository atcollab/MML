function [AM, SP] = libera(Port, BPMName, TriggerFlag)
%LIBERA - Gets data from all the different ports for the Libera BPM
%  [Monitors, Setpoints] = libera(Port, BPMName, TriggerFlag)
%
%  INPUTS
%  1. Port - ADC, DD1, DD2, DD3, DD4, ENV, FA, PM, SA
%  2. BPMName - First field in the EPICS BPM name
%  3. Keyword inputs 
%
%  OUTPUTS
%  1. Monitors  - All the monitor  channels for the port
%  2. Setpoints - All the setpoint channels for the port
%
%  NOTES
%  1. For ADC, DD1-DD4 port, the following are set:
%         ENV:ENV_DSC_SP      = 0
%         ENV:ENV_SWITCHES_SP = 0
%         ENV:ENV_AGC_SP      = 0
%
%  2. Example sampling numbers
%
%     ALS Storage Ring has an RF frequency of 499.642 MHz
%     ADC:   Runs at the oscillator rate (117.2940 MHz or 8.525585 nsec/sample) (1024 waveform)
%     DD1-4: Decimation =   77 from ADC  (  1.5233 MHz or 656.4700 nsec/sample) (1k, 10k, 30k, 400k waveforms)
%     FA:    Decimation =  150 from DD   ( 10.1553 kHz or .0984705 msec/sample) (8192 waveform)
%     SA:    Decimation = 1024 from FA   (  9.9173  Hz or .1008338  sec/sample)
%
%  3. If no outputs exists, the data will be plotted to a figure.  
%
% See also liberainit, getlibera


%  Written by Greg Portmann


% To-do
% 1. Input strings:
%    'Trigger' or 'NoTrigger'
%    'DSC', 'On'
%    'Switching', ...
%    Instead of the forced changes


FINISHED_MONITOR_TIMEOUT = 6;  % seconds



% % Look for keywords
% for i = length(varargin):-1:1
%    if isstruct(varargin{i})
%        % Ignor structures
%    elseif iscell(varargin{i})
%        % Ignor cells
%    elseif ischar(varargin{i})
%        if strcmpi(varargin{i},'AGC')
%            varargin(i) = [];
%            if length(varargin) >= i
%                AGC = varargin{i};
%                varargin(i) = [];
%            end
%        elseif strcmpi(varargin{i},'DSC')
%            varargin(i) = [];
%            if length(varargin) >= i
%                DSC = varargin{i};
%                varargin(i) = [];
%            end
%        elseif strcmpi(varargin{i},'Switches')
%            varargin(i) = [];
%            if length(varargin) >= i
%                Switches = varargin{i};
%                varargin(i) = [];
%            end
%        end
%    end
%    end
% end



if nargin < 1 || isempty(Port)
    FieldCell = {'ADC','DD1','DD2','DD3','DD4','ENV','FA','PM','SA'};
    [ModeNumber, OKFlag] = listdlg('Name','Libera Fields','PromptString','Libera Fields:', 'SelectionMode','single', 'ListString', FieldCell, 'ListSize', [120 150]);
    if OKFlag
        Port = FieldCell{ModeNumber};
    else
        return;
    end
end

if nargin < 2 || isempty(BPMName)
    BPMName = input('   Enter the first field in the EPICS BPM name: ', 's');
    if isempty(BPMName)
        return;
    end
end

if nargin < 3
    if any(strcmpi(Port, {'ADC','PM','DD1','DD2','DD3'}))
        % Typically triggered
        TriggerFlag = 1;
    else
        % Typically trigger ignored
        TriggerFlag = 0;
    end
end


% More than 1 libera
if size(BPMName,1) > 1
    for i = 1:size(BPMName,1)
        if strcmpi(Port, 'SA')
            % Setpoint field is empty for an SA port
            [AM(i,1), SP]      = libera(Port, BPMName(i,:), TriggerFlag);
        else
            [AM(i,1), SP(i,1)] = libera(Port, BPMName(i,:), TriggerFlag);
        end
    end
    return
end


AM = [];
SP = [];


switch upper(Port)
    case 'ADC'
        AMNames = {
            'ADC_A_MONITOR'
            'ADC_B_MONITOR'
            'ADC_C_MONITOR'
            'ADC_D_MONITOR'
            'ADC_MONITOR'
            'ADC_FINISHED_MONITOR'
            };
    case 'PM'
        AMNames = {
            'PM_X_MONITOR'
            'PM_Y_MONITOR'
            'PM_Q_MONITOR'
            'PM_SUM_MONITOR'
            'PM_VA_MONITOR'
            'PM_VB_MONITOR'
            'PM_VC_MONITOR'
            'PM_VD_MONITOR'
            'PM_MONITOR'
            'PM_FINISHED_MONITOR'
            'PM_MT_MONITOR'
            'PM_ST_MONITOR'
            };
    case 'FA'
        AMNames = {
            'FA_MEM_MONITOR'
            };
    case 'SA'
        AMNames = {
            'SA_X_MONITOR'
            'SA_Y_MONITOR'
            'SA_Q_MONITOR'
            'SA_SUM_MONITOR'
            'SA_A_MONITOR'
            'SA_B_MONITOR'
            'SA_C_MONITOR'
            'SA_D_MONITOR'
            'SA_CX_MONITOR'
            'SA_CY_MONITOR'
            'SA_MONITOR'
            'SA_FINISHED_MONITOR'
            'SA_ARRAY_MONITOR'
            };
    case 'DD2'
        AMNames = {
            'DD_IA_MONITOR'
            'DD_IB_MONITOR'
            'DD_IC_MONITOR'
            'DD_ID_MONITOR'
            'DD_QA_MONITOR'
            'DD_QB_MONITOR'
            'DD_QC_MONITOR'
            'DD_QD_MONITOR'
            'DD_MONITOR'
            'DD_FINISHED_MONITOR'
            'DD_MT_MONITOR'
            'DD_ST_MONITOR'
            };
    case {'DD1','DD3','DD4'}
        AMNames = {
            'DD_X_MONITOR'
            'DD_Y_MONITOR'
            'DD_Q_MONITOR'
            'DD_SUM_MONITOR'
            'DD_VA_MONITOR'
            'DD_VB_MONITOR'
            'DD_VC_MONITOR'
            'DD_VD_MONITOR'
            'DD_MONITOR'
            'DD_FINISHED_MONITOR'
            'DD_MT_MONITOR'
            'DD_ST_MONITOR'
            };
    case {'ENV'}
        AMNames = {
            'ENV_AGC_MONITOR'
            'ENV_DSC_MONITOR'
            'ENV_SWITCHES_MONITOR'
            'ENV_GAIN_MONITOR'
            'ENV_KX_MONITOR'  % nm/unit, so 10000000 is 10 mm
            'ENV_KY_MONITOR'
            'ENV_Q_OFFSET_MONITOR'
            'ENV_X_OFFSET_MONITOR'
            'ENV_Y_OFFSET_MONITOR'
            'ENV_MC_PLL_MONITOR'
            'ENV_SC_PLL_MONITOR'
            'ENV_ERROR_MONITOR'
            'ENV_BACK_VENT_ACT_MONITOR'
            'ENV_BACK_VENT_CONF_MONITOR'
            'ENV_FRONT_VENT_ACT_MONITOR'
            'ENV_FRONT_VENT_CONF_MONITOR'
            'ENV_TEMP_MONITOR'
            'ENV_TEMP_MAX_MONITOR'
            'ENV_TEMP_MIN_MONITOR'
            'ENV_VOLTAGE0_MONITOR'
            'ENV_VOLTAGE1_MONITOR'
            'ENV_VOLTAGE2_MONITOR'
            'ENV_VOLTAGE3_MONITOR'
            'ENV_VOLTAGE4_MONITOR'
            'ENV_VOLTAGE5_MONITOR'
            'ENV_VOLTAGE6_MONITOR'
            'ENV_VOLTAGE7_MONITOR'
            'ENV_DDFPGA_ERR_MONITOR'
            'ENV_SADRV_ERR_MONITOR'
            'ENV_SAFPGA_ERR_MONITOR'
            'ENV_INTERLOCK_MONITOR'
            'ENV_ILK_GAIN_LIMIT_MONITOR'
            'ENV_ILK_OF_DUR_MONITOR'
            'ENV_ILK_OF_LIMIT_MONITOR'
            'ENV_ILK_X_HIGH_MONITOR'
            'ENV_ILK_X_LOW_MONITOR'
            'ENV_ILK_Y_HIGH_MONITOR'
            'ENV_ILK_Y_LOW_MONITOR'
            'ENV_ILK_MODE_MONITOR'
            };
    otherwise
        error('Channel type unknown');
end


switch upper(Port)
    case 'ADC'
        SPNames = {
            'ADC_IGNORE_TRIG_SP'
            'ADC_ON_NEXT_TRIG_CMD'
            };
    case 'PM'
        SPNames = {
            'PM_IGNORE_TRIG_SP'
            'PM_ON_NEXT_TRIG_CMD'
            'PM_REQUEST_CMD'
            };
    case 'FA'
        SPNames = {
            'FA_MEM_READ_CMD'
            'FA_MEM_WRITE_CMD'
            'FA_LENGTH_SP'
            'FA_OFFSET_SP'
            'FA_MEM_SP'
            };
    case 'SA'
        SPNames = {
            };
    case {'DD1','DD2','DD3','DD4'}
        SPNames = {
            'DD_IGNORE_TRIG_SP'
            'DD_ON_NEXT_TRIG_CMD'
            'DD_REQUEST_CMD'
            'DD_SEEK_POINT_SP'
            'DD_MT_OFFSET_SP'
            'DD_ST_OFFSET_SP'
            };
    case 'ENV'
        SPNames = {
            'ENV_AGC_SP'
            'ENV_DSC_SP'
            'ENV_SWITCHES_SP'
            'ENV_GAIN_SP'
            'ENV_KX_SP'
            'ENV_KY_SP'
            'ENV_Q_OFFSET_SP'
            'ENV_X_OFFSET_SP'
            'ENV_Y_OFFSET_SP'
            'ENV_COMMIT_MTST_CMD'
            'ENV_COMMIT_MT_CMD'
            'ENV_COMMIT_ST_CMD'
            'ENV_SETMTPHASE_SP'
            'ENV_SETMT_SP'
            'ENV_SETST_SP'
            'ENV_INTERLOCK_CLEAR_CMD'
            'ENV_SET_INTERLOCK_PARAM_CMD'
            'ENV_ILK_GAIN_LIMIT_SP'
            'ENV_ILK_OF_DUR_SP'
            'ENV_ILK_OF_LIMIT_SP'
            'ENV_ILK_X_HIGH_SP'
            'ENV_ILK_X_LOW_SP'
            'ENV_ILK_Y_HIGH_SP'
            'ENV_ILK_Y_LOW_SP'
            'ENV_ILK_MODE_SP'
            };
    otherwise
end



if ~any(strcmpi(Port,{'SA','ENV','FA'}))
    
    if ~any(strcmpi(Port, {'PM','DD4'}))    % PM data already happened
        % DSC: 0=OFF, 1=UNITY, 2=AUTO, 3=SAVE_LASTGOOD
        lcaPut([BPMName, ':ENV:ENV_DSC_SP'], 0, 'double');

        % Switches: 255=AUTO, 15=DIRECT
        lcaPut([BPMName, ':ENV:ENV_SWITCHES_SP'], 0, 'double');

        % AGC: 0=MANUAL, 1=AUTO
        lcaPut([BPMName, ':ENV:ENV_AGC_SP'], 0, 'double');
    end
    
    % Disable the other port acquisitions
    lcaPut([BPMName, ':DD1:DD_IGNORE_TRIG_SP'],  1, 'double');
    lcaPut([BPMName, ':DD2:DD_IGNORE_TRIG_SP'],  1, 'double');
    lcaPut([BPMName, ':DD3:DD_IGNORE_TRIG_SP'],  1, 'double');
    lcaPut([BPMName, ':DD4:DD_IGNORE_TRIG_SP'],  1, 'double');
    lcaPut([BPMName, ':ADC:ADC_IGNORE_TRIG_SP'], 1, 'double');
    % lcaPut([BPMName, ':PM:PM_IGNORE_TRIG_SP'],   1, 'double');

    
    % Get the finished monitor starting count
    if strcmp(Port(1:2), 'DD')
        FINISHED_MONITOR_CHANNELNAME = sprintf('%s:%s:DD_FINISHED_MONITOR', BPMName, Port);
    else
        FINISHED_MONITOR_CHANNELNAME = sprintf('%s:%s:%s_FINISHED_MONITOR', BPMName, Port, Port);
    end
    [FINISHED_MONITOR_0, FINISHED_MONITOR_TIMESTAMP] = lcaGet(FINISHED_MONITOR_CHANNELNAME);
    FINISHED_MONITOR_TIMESTAMP = convertime_local(FINISHED_MONITOR_TIMESTAMP);
    FINISHED_MONITOR_1 = FINISHED_MONITOR_0;
    
    
    if strcmpi(Port, 'ADC')
        if TriggerFlag
            % Setup "acquire on trigger" then trigger
            % lcaPut([BPMName, ':ADC:ADC_IGNORE_TRIG_SP'], 0, 'double');
            % pause(.2);
            lcaPut([BPMName, ':ADC:ADC_ON_NEXT_TRIG_CMD'], 1, 'double');
        else
            error('The ADC port requires a trigger.');
        end
        pause(.5);
        
    elseif strcmpi(Port, 'PM')
        if TriggerFlag
            % Setup "acquire on trigger" then trigger
            % lcaPut([BPMName, ':', Port, ':', 'PM_IGNORE_TRIG_SP'], 0, 'double');
            % pause(.2);
            lcaPut([BPMName, ':', Port, ':', 'PM_ON_NEXT_TRIG_CMD'], 1, 'double');
        else
            % Get new data without a trigger
            lcaPut([BPMName, ':', Port, ':', 'PM_REQUEST_CMD'], 1, 'double');
        end
        pause(.5);
        
    else
        % DD ports
        if TriggerFlag
            % Setup "acquire on trigger" then trigger
            % lcaPut([BPMName, ':', Port, ':', 'DD_IGNORE_TRIG_SP'], 0, 'double');
            % pause(.2);
            lcaPut([BPMName, ':', Port, ':', 'DD_ON_NEXT_TRIG_CMD'], 1, 'double');
        else
            % Get new data without a trigger
            lcaPut([BPMName, ':', Port, ':', 'DD_REQUEST_CMD'], 1, 'double');
        end
        pause(2);
    end


    % Wait for new data
    t0 = clock; 
    while (FINISHED_MONITOR_1 == FINISHED_MONITOR_0) && (etime(clock, t0) < FINISHED_MONITOR_TIMEOUT)
        pause(0.05);
        [FINISHED_MONITOR_1, FINISHED_MONITOR_TIMESTAMP] = lcaGet(FINISHED_MONITOR_CHANNELNAME);
        FINISHED_MONITOR_TIMESTAMP = convertime_local(FINISHED_MONITOR_TIMESTAMP);
    end
    %fprintf('   Data trigger etime = %f  (time-out set to %f)\n', etime(clock,t0), FINISHED_MONITOR_TIMEOUT);
end



% Get data
BPMPrefix = [BPMName, ':', Port, ':'];
for i = 1:size(AMNames,1)
    tmp = lcaGet([BPMPrefix, AMNames{i}]);
    if iscell(tmp)
        AM.(AMNames{i}) = tmp{1};
    else
        AM.(AMNames{i}) = tmp;
    end
end
if nargout >= 2 || nargout == 0
    for i = 1:size(SPNames,1)
        tmp = lcaGet([BPMPrefix, SPNames{i}]);
        if iscell(tmp)
            SP.(SPNames{i}) = tmp{1};
        else
            SP.(SPNames{i}) = tmp;
        end
    end
end



% Final checks and changes
if any(strcmpi(Port,{'SA','ENV'}))
    
elseif strcmpi(Port, 'FA')
    fprintf('   Note: FA data is not available via EPICS.\n');
    
elseif strcmpi(Port, 'ADC')
    % ADC Port
    AM.ADC_FINISHED_MONITOR_TIMESTAMP = datestr(FINISHED_MONITOR_TIMESTAMP);
    if FINISHED_MONITOR_1 == FINISHED_MONITOR_0
        fprintf('\n   %s:%s:ADC_FINISHED_MONITOR = %d from %s\n', BPMName, Port, FINISHED_MONITOR_1, datestr(FINISHED_MONITOR_TIMESTAMP));
        fprintf('   Data is from an old trigger!!!\n\n');
    end

    % Ignore future trigger to reduce load
    lcaPut([BPMName, ':ADC:ADC_IGNORE_TRIG_SP'], 1, 'double');

elseif strcmpi(Port, 'PM')
    % PM Port
    AM.PM_FINISHED_MONITOR_TIMESTAMP = datestr(FINISHED_MONITOR_TIMESTAMP);
    if FINISHED_MONITOR_1 == FINISHED_MONITOR_0
        fprintf('\n   %s:%s:PM_FINISHED_MONITOR = %d from %s\n', BPMName, Port, FINISHED_MONITOR_1, datestr(FINISHED_MONITOR_TIMESTAMP));
        fprintf('   Data is from an old trigger!!!\n\n');
    end

    % Ignore future trigger to reduce load
    lcaPut([BPMName, ':', Port, ':', 'PM_IGNORE_TRIG_SP'], 1, 'double');

else
    % DD Ports
    AM.DD_FINISHED_MONITOR_TIMESTAMP = datestr(FINISHED_MONITOR_TIMESTAMP);
    if FINISHED_MONITOR_1 == FINISHED_MONITOR_0
        fprintf('\n   %s:%s:DD_FINISHED_MONITOR = %d from %s\n', BPMName, Port, FINISHED_MONITOR_1, datestr(FINISHED_MONITOR_TIMESTAMP));
        fprintf('   Data is from an old trigger!!!\n\n');
    end
    
    % Ignore future trigger to reduce load
    lcaPut([BPMName, ':', Port, ':', 'DD_IGNORE_TRIG_SP'], 1, 'double');
end





% Plot some numbers if no output exists
if nargout == 0
    if any(strcmp(Port,{'SA','ENV','FA'}))

    elseif strcmp(Port, 'ADC')
        % ADC Port
        s = AM.ADC_A_MONITOR+AM.ADC_B_MONITOR+AM.ADC_C_MONITOR+AM.ADC_D_MONITOR;

        t = 0:length(s)-1;

        figure(1);
        clf reset
        h = subplot(4,1,1);
        plot(t, AM.ADC_A_MONITOR);
        ylabel('A');
        title(sprintf('BPM(%d,%d)  %s  %s', DevList, Port, BPMName),'interpret','none');

        h(2) = subplot(4,1,2);
        plot(t, AM.ADC_B_MONITOR);
        ylabel('B');

        h(3) = subplot(4,1,3);
        plot(t, AM.ADC_C_MONITOR);
        ylabel('C');

        h(4) = subplot(4,1,4);
        plot(t, AM.ADC_D_MONITOR);
        ylabel('D');
        xlabel('Time [nanoseconds]');

        addlabel(0, 0, sprintf('Trace #%d',  AM.ADC_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.ADC_FINISHED_MONITOR_TIMESTAMP)));
        linkaxes(h, 'x');
        
    elseif strcmp(Port, 'PM')
        % PM Port
        t = 0:length(AM.PM_X_MONITOR)-1;

        figure(1);
        clf reset
        h = subplot(3,1,1);
        plot(t, AM.PM_X_MONITOR);
        ylabel('Horizontal');
        title(sprintf('%s Data for %s', Port, BPMName),'interpret','none');

        h(2) = subplot(3,1,2);
        plot(t, AM.PM_Y_MONITOR);
        ylabel('Vertical');

        h(3) = subplot(3,1,3);
        plot(t, AM.PM_SUM_MONITOR);
        ylabel('Sum');
        xlabel('Turn Number');

        addlabel(0, 0, sprintf('Trace #%d',  AM.PM_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.PM_FINISHED_MONITOR_TIMESTAMP)));

        
        figure(2);
        clf reset
        h(4) = subplot(4,1,1);
        plot(t, AM.PM_VA_MONITOR);
        ylabel('VA');
        title(sprintf('%s Data for %s', Port, BPMName),'interpret','none');

        h(5) = subplot(4,1,2);
        plot(t, AM.PM_VB_MONITOR);
        ylabel('VB');

        h(6) = subplot(4,1,3);
        plot(t, AM.PM_VC_MONITOR);
        ylabel('VC');
        
        h(7) = subplot(4,1,4);
        plot(t, AM.PM_VD_MONITOR);
        ylabel('VD'); 
        xlabel('Turn Number');

        addlabel(0, 0, sprintf('Trace #%d',  AM.PM_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.PM_FINISHED_MONITOR_TIMESTAMP)));
        linkaxes(h, 'x');
        
    elseif strcmp(Port, 'DD2')
        % DD2 Port
        t = 0:length(AM.DD_QA_MONITOR)-1;

        %figure(1);
        clf reset
        h = subplot(4,1,1);
        plot(t,[AM.DD_QA_MONITOR; AM.DD_IA_MONITOR]);
        ylabel('QA & IA');
        title(sprintf('%s Data for %s', Port, BPMName),'interpret','none');

        h(2) = subplot(4,1,2);
        plot(t,[AM.DD_QB_MONITOR; AM.DD_IB_MONITOR]);
        ylabel('QB & IB');

        h(3) = subplot(4,1,3);
        plot(t,[AM.DD_QC_MONITOR; AM.DD_IC_MONITOR]);
        ylabel('QC & IC');
        
        h(4) = subplot(4,1,4);
        plot(t,[AM.DD_QD_MONITOR; AM.DD_ID_MONITOR]);
        ylabel('QD & ID');
        xlabel('Turn Number');
        
        addlabel(0, 0, sprintf('Trace #%d',  AM.DD_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.DD_FINISHED_MONITOR_TIMESTAMP)));
        linkaxes(h, 'x');
        
    elseif any(strcmp(Port, {'DD1','DD3','DD4'}))
        % DD1, DD3, DD4 Ports
        t = 0:length(AM.DD_X_MONITOR)-1;

        figure(1);
        clf reset
        h = subplot(3,1,1);
        plot(t, AM.DD_X_MONITOR);
        ylabel('Horizontal');
        title(sprintf('%s Data for %s', Port, BPMName),'interpret','none');

        h(2) = subplot(3,1,2);
        plot(t, AM.DD_Y_MONITOR);
        ylabel('Vertical');

        h(3) = subplot(3,1,3);
        plot(t, AM.DD_SUM_MONITOR);
        ylabel('Sum');
        xlabel('Turn Number');

        addlabel(0, 0, sprintf('Trace #%d',  AM.DD_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.DD_FINISHED_MONITOR_TIMESTAMP)));

        
        figure(2);
        clf reset
        h(4) = subplot(4,1,1);
        plot(t, AM.DD_VA_MONITOR);
        ylabel('VA');
        title(sprintf('%s Data for %s', Port, BPMName),'interpret','none');

        h(5) = subplot(4,1,2);
        plot(t, AM.DD_VB_MONITOR);
        ylabel('VB');

        h(6) = subplot(4,1,3);
        plot(t, AM.DD_VC_MONITOR);
        ylabel('VC');
        
        h(7) = subplot(4,1,4);
        plot(t, AM.DD_VD_MONITOR);
        ylabel('VD'); 
        xlabel('Turn Number');

        addlabel(0, 0, sprintf('Trace #%d',  AM.DD_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.DD_FINISHED_MONITOR_TIMESTAMP)));
        linkaxes(h, 'x');
    end
end




function DataTime = convertime_local(DataTime)
% Input DataTime is the time on computer taking the data (EPICS) using LabCA complex formating
% Output is referenced w.r.t. the time zone where Matlab is running in Matlab's date number format
t0 = clock;
DateNumber1970 = 719529;  %datenum('1-Jan-1970');
days = datenum(t0(1:3)) - DateNumber1970;
t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);
