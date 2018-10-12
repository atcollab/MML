function varargout = getliberadata(varargin)
%
% data = getliberadata(STREAM, [DEVICELIST, TRIG_ACQUIRE, NUMSAMPLES])
%
% STREAM       = libera stream e.g. 'DD1' 'DD3'. (default = 'DD3')
%                      * ADC_SIGNAL - RAW ADC acquired data
%                      * TBT_TBT_WINDOW_SIGNAL - ADC points used to compute TBT data
%                      * DDC_RAW_SIGNAL - amplitude and phase data
%                      * DDC_SYNTH_SIGNAL - down converted x and y data
%                      * TDP_SYNTH_SIGNAL - time domain converted x and y data 
%                      * PM_DDC_SYNTH_SIGNAL - post mortem data
% DEVICELIST   = devicelist, [] will use all devices returned by
%                getlist('BPMx'). (default = [])
% TRIG_ACQUIRE = this will get the liberas to acquire fresh data. Currently
%                defaults to on trigger with whatever offsets loaded into
%                the libera. '0' to not acquire fresh data while '1' will
%                refresh the data. (default = 0) 
% NUMSAMPLES   = number of samples to return. If NUMSAMPLES > number of
%                available data then getliberabtbt will only return as many
%                data points as there are in the PV.
%
% Examples
% 
% >> d = getliberadata('TDP_SYNTH');
% >> d = getliberadata('TDP_SYNTH',[],1);  % Collect from all bpms and apply trigger (SR BPM trigger)
%
% Eugene
% 10-04-2007
% 14-06-2011 Small update to the way it triggers using new BPM Event.
% 06-09-2017 ET updated for libera Brilliance
%




if nargin > 0 && ischar(varargin{1})
    stream = [varargin{1}];
else
    stream = 'TDP_SYNTH_SIGNAL';
end

if nargin > 1 && ~isempty(varargin{2})
    % User specified device list
    devicelist = varargin{2};
else
    % Use default bpms
    devicelist = getlist('BPMx');
end
if size(devicelist,2) == 1
    % assume user has used element number instead
    devicelist = elem2dev('BPMx',devicelist);
end

if nargin > 2 && isnumeric(varargin{3})
    trigger = varargin{3};
else
    trigger = 0;
end

if nargin > 3 && isnumeric(varargin{4})
    nelem = varargin{4};
else
    nelem = 0;
end


% No need for trigger for PM data
if trigger && ~(strcmpi(stream,'PM_DDC_SYNTH_SIGNAL') || strcmpi(stream,'PM_DDC_RAW_SIGNAL'))
    % We will assume here that there is no trigger being sent to the bpm.
    % Also assume the first in the devicelist as a representative of the
    % rest that it is receiving the trigger and updating data.
    if strncmp(stream,'ADC_SIGNAL',3)
        timestampfield = [stream '.LMT'];
    else
        timestampfield = [stream '.MT' ];
    end
    mt0 = srbpm.getfield(timestampfield,devicelist(1,:));
    pause(0.1); 
    
    % TBT_TBT_WINDOW needs to be proc'ed however there is no valid MT data
    % to compare to see if there is fresh data.
    if ~strcmpi(stream,'TBT_TBT_WINDOW_SIGNAL')
        % Get the EVR to send a trigger signal to the Liberas. Triggers at the
        % AS are slaved to the 1Hz master clock. To ensure that the data is
        % refreshed we
        srbpm.trigger;
        while mt0 == srbpm.getfield(timestampfield,devicelist(1,:))
            pause(0.1);
        end
    end
end

% Convert the nm units that is Hardware into meters (physics) or nm (hardware).
if strcmpi(getunits('BPMx'),'Physics')
    units_conversion = 1e-9; % in meters
    unitsstr = 'm';
else
    units_conversion = 1; % hardware in nm
    unitsstr = 'nm';
end


if strcmpi(stream,'ADC_SIGNAL') || strcmpi(stream,'TBT_TBT_WINDOW_SIGNAL')
    etime = zeros(1,4);
    datatime = zeros(size(devicelist,1),4);
    
    [data.a   etime(:,1) datatime(:,1)] = srbpm.getfield([stream '.ChannelA'],devicelist,'Waveform',nelem);
    [data.b   etime(:,2) datatime(:,2)] = srbpm.getfield([stream '.ChannelB'],devicelist,'Waveform',nelem);
    [data.c   etime(:,3) datatime(:,3)] = srbpm.getfield([stream '.ChannelC'],devicelist,'Waveform',nelem);
    [data.d   etime(:,4) datatime(:,4)] = srbpm.getfield([stream '.ChannelD'],devicelist,'Waveform',nelem);
    [data.LMT etime(:,5) datatime(:,5)] = srbpm.getfield([stream '.LMT'],devicelist);
elseif strcmpi(stream,'DDC_RAW_SIGNAL') || strcmpi(stream,'PM_DDC_RAW_SIGNAL')
    etime = zeros(1,9);
    datatime = zeros(size(devicelist,1),9);
    % Try to avoid memory problems
    [data.ia etime(:,1) datatime(:,1)] = srbpm.getfield([stream '.Ia'],devicelist,'Waveform',nelem);
    [data.qa etime(:,2) datatime(:,2)] = srbpm.getfield([stream '.Qa'],devicelist,'Waveform',nelem);
    [data.ib etime(:,3) datatime(:,3)] = srbpm.getfield([stream '.Ib'],devicelist,'Waveform',nelem);
    [data.qb etime(:,4) datatime(:,4)] = srbpm.getfield([stream '.Qb'],devicelist,'Waveform',nelem);
    [data.ic etime(:,5) datatime(:,5)] = srbpm.getfield([stream '.Ic'],devicelist,'Waveform',nelem);
    [data.qc etime(:,6) datatime(:,6)] = srbpm.getfield([stream '.Qc'],devicelist,'Waveform',nelem);
    [data.id etime(:,7) datatime(:,7)] = srbpm.getfield([stream '.Id'],devicelist,'Waveform',nelem);
    [data.qd etime(:,8) datatime(:,8)] = srbpm.getfield([stream '.Qd'],devicelist,'Waveform',nelem);
    [data.MT etime(:,9) datatime(:,9)] = srbpm.getfield([stream '.MT'],devicelist);
else
    etime = zeros(1,8);
    datatime = zeros(size(devicelist,1),8);
    % Try to avoid memory problems
    [data.sum etime(:,1) datatime(:,1)] = srbpm.getfield([stream '.Sum'],devicelist,'Waveform',nelem);
    [data.x etime(:,2) datatime(:,2)] = srbpm.getfield([stream '.X'],devicelist,'Waveform',nelem);
    data.x = data.x*units_conversion;
    [data.y etime(:,3) datatime(:,3)] = srbpm.getfield([stream '.Y'],devicelist,'Waveform',nelem);
    data.y = data.y*units_conversion;
    [data.VA etime(:,4) datatime(:,4)]  = srbpm.getfield([stream '.Va'],devicelist,'Waveform',nelem);
    [data.VB etime(:,5) datatime(:,5)] = srbpm.getfield([stream '.Vb'],devicelist,'Waveform',nelem);
    [data.VC etime(:,6) datatime(:,6)] = srbpm.getfield([stream '.Vc'],devicelist,'Waveform',nelem);
    [data.VD etime(:,7) datatime(:,7)] = srbpm.getfield([stream '.Vd'],devicelist,'Waveform',nelem);
    [data.MT etime(:,8) datatime(:,8)] = srbpm.getfield([stream '.MT'],devicelist);    
end
data.elapsed_time = sum(etime);  % elapsed time to download the PV the wait is longer to ensure all the Liberas have triggered.
data.mean_datatime = mean(datatime,2);  % mean data time that all the PVs have been updated, as a function of the devicelist.
data.datatime = datatime;


% Log status of the Libera
% if isnumeric(devicelist)
%     % To differentiate the the booster BPMs that are currently not
%     % version 2.06 and don't have some of these features.
%     data.switches = srbpm.getfield('ENV_SWITCHES_MONITOR',devicelist,'Waveform',nelem);
%     data.plloffset = srbpm.getfield('ENV_PLL_OFFSETTUNE_MONITOR',devicelist,'Waveform',nelem);
%     data.pllcomptune = srbpm.getfield('ENV_PLL_COMPTUNE_MONITOR',devicelist,'Waveform',nelem);
% end

data.DeviceList = devicelist;
data.TimeStamp = clock;
data.CreatedBy = mfilename;
data.UnitsString = unitsstr;
data.Units = getunits('BPMx');
data.Mode = 'Online'; % By definition for now.

varargout{1} = data;