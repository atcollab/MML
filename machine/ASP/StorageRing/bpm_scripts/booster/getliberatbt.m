function varargout = getliberatbt(varargin)
%
% data = getliberatbt(STREAM, [DEVICELIST, TRIG_ACQUIRE, NUMSAMPLES])
%
% STREAM       = libera stream e.g. 'DD1' 'DD3'. (default = 'DD3')
%                      * DD1 - data decimated at 64 bit. ie. collect every 64th turn
%                      * DD2 - amplitude and phase data
%                      * DD3 - data for 10,000 turns - can be used for high repetition
%                      * DD4 - data for 100,000 turns - resource intensive, long measurements 
% DEVICELIST   = devicelist, [] will use all devices returned by
%                getlist('BPMx'). (default = [])
% TRIG_ACQUIRE = this will get the liberas to acquire fresh data. Currently
%                defaults to on trigger with whatever offsets loaded into
%                the libera. '0' to not acquire fresh data while '1' will
%                refresh the data. (default = 1) 
% NUMSAMPLES   = number of samples to return. If NUMSAMPLES > number of
%                available data then getliberatbt will only return as many
%                data points as there are in the PV.
%
% Eugene
% 10-04-2007
% 14-06-2011 Small update to the way it triggers using new BPM Event.

if nargin > 0 && ischar(varargin{1})
    stream = varargin{1};
else
    stream = 'DD3';
end

if nargin > 1 && ~isempty(varargin{2})
    % User specified device list
    devicelist = varargin{2};
else
    % Use default bpms
    devicelist = getlist('BPMx');
end

if nargin > 2 && isnumeric(varargin{3})
    trigger = varargin{3};
else
    trigger = 1;
end

if nargin > 3 && isnumeric(varargin{4})
    nelem = varargin{4};
else
    nelem = 0;
end

if trigger
    % Disable the BPM trigger event from the EVG. 0: disable, 1:
    % continuous, 3: single shot.
%     setpv('TS01EVG01:EVENT_02_MODE_CMD',0);
%     pause(0.1);
    
    % read current counter then arm for a single acquisition
    finished_num = getlibera([stream '_FINISHED_MONITOR'], devicelist);
% %     setlibera(['DD4_ON_NEXT_TRIG_CMD'],1, devicelist);
    setlibera([stream '_ON_NEXT_TRIG_CMD'],1, devicelist);
    pause(1.5);

    % Get the EVR to send a trigger signal to the Liberas.
    setliberatrigger(1);

    ii = 0;
    temp = getlibera([stream '_FINISHED_MONITOR'],devicelist) == finished_num;
    while any(temp)
        pause(0.1);
        temp = getlibera([stream '_FINISHED_MONITOR'],devicelist) == finished_num;
        ii = ii + 1;
        if ii > 60
            disp('Trigger may not be enabled for the Liberas (please check)');
            disp('The data acquisition counter did not increment for the following BPMs:');
            fprintf('[%2d %d]\n',devicelist(temp,:)');
            if nargout > 0
                varargout{1} = [];
            end
            
            return
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

if strcmpi(stream,'ADC')
    etime = zeros(1,4);
    datatime = zeros(size(devicelist,1),4);
    
    [data.a etime(:,1) datatime(:,1)] = getlibera([stream '_A_MONITOR'],devicelist,0,nelem);
    [data.b etime(:,2) datatime(:,2)] = getlibera([stream '_B_MONITOR'],devicelist,0,nelem);
    [data.c etime(:,3) datatime(:,3)] = getlibera([stream '_C_MONITOR'],devicelist,0,nelem);
    [data.d etime(:,4) datatime(:,4)] = getlibera([stream '_D_MONITOR'],devicelist,0,nelem);
elseif strcmpi(stream,'DD2')
    etime = zeros(1,10);
    datatime = zeros(size(devicelist,1),10);
    % Try to avoid memory problems
    [data.ia etime(:,1) datatime(:,1)] = getlibera([stream '_IA_MONITOR'],devicelist,0,nelem);
    [data.qa etime(:,2) datatime(:,2)] = getlibera([stream '_QA_MONITOR'],devicelist,0,nelem);
    [data.ib etime(:,3) datatime(:,3)] = getlibera([stream '_IB_MONITOR'],devicelist,0,nelem);
    [data.qb etime(:,4) datatime(:,4)] = getlibera([stream '_QB_MONITOR'],devicelist,0,nelem);
    [data.ic etime(:,5) datatime(:,5)] = getlibera([stream '_IC_MONITOR'],devicelist,0,nelem);
    [data.qc etime(:,6) datatime(:,6)] = getlibera([stream '_QC_MONITOR'],devicelist,0,nelem);
    [data.id etime(:,7) datatime(:,7)] = getlibera([stream '_ID_MONITOR'],devicelist,0,nelem);
    [data.qd etime(:,8) datatime(:,8)] = getlibera([stream '_QD_MONITOR'],devicelist,0,nelem);
    [data.MT etime(:,9) datatime(:,9)] = getlibera([stream '_MT_MONITOR'],devicelist,0,nelem);
    [data.ST etime(:,10) datatime(:,10)] = getlibera([stream '_ST_MONITOR'],devicelist,0,nelem);
else
    etime = zeros(1,9);
    datatime = zeros(size(devicelist,1),9);
    % Try to avoid memory problems
    [data.tbtsum etime(:,1) datatime(:,1)] = getlibera([stream '_SUM_MONITOR'],devicelist,0,nelem);
    [data.tbtx etime(:,2) datatime(:,2)] = getlibera([stream '_X_MONITOR'],devicelist,0,nelem);
    data.tbtx = data.tbtx*units_conversion;
    [data.tbty etime(:,3) datatime(:,3)] = getlibera([stream '_Y_MONITOR'],devicelist,0,nelem);
    data.tbty = data.tbty*units_conversion;
    [data.VA etime(:,4) datatime(:,4)]  = getlibera([stream '_VA_MONITOR'],devicelist,0,nelem);
    [data.VB etime(:,5) datatime(:,5)] = getlibera([stream '_VB_MONITOR'],devicelist,0,nelem);
    [data.VC etime(:,6) datatime(:,6)] = getlibera([stream '_VC_MONITOR'],devicelist,0,nelem);
    [data.VD etime(:,7) datatime(:,7)] = getlibera([stream '_VD_MONITOR'],devicelist,0,nelem);
    [data.MT etime(:,8) datatime(:,8)] = getlibera([stream '_MT_MONITOR'],devicelist,0,nelem);
    [data.ST etime(:,9) datatime(:,9)] = getlibera([stream '_ST_MONITOR'],devicelist,0,nelem);
    
    % Turn offset to try to synchronise the turns
%     for i=1:size(devicelist,1)
%         switch devicelist(i,1)
%             case {6 7 8 9 10 11 13 14}
%                 data.tbtsum(i,:) = circshift(data.tbtsum(i,:),[0 -1]);
%                 data.tbtx(i,:) = circshift(data.tbtx(i,:),[0 -1]);
%                 data.tbty(i,:) = circshift(data.tbty(i,:),[0 -1]);
%                 data.VA(i,:) = circshift(data.VA(i,:),[0 -1]);
%                 data.VB(i,:) = circshift(data.VB(i,:),[0 -1]);
%                 data.VC(i,:) = circshift(data.VC(i,:),[0 -1]);
%                 data.VD(i,:) = circshift(data.VD(i,:),[0 -1]);
%             case 12
%                 data.tbtsum(i,:) = circshift(data.tbtsum(i,:),[0 -1]);
%                 data.tbtx(i,:) = circshift(data.tbtx(i,:),[0 -1]);
%                 data.VA(i,:) = circshift(data.VA(i,:),[0 -1]);
%                 data.VB(i,:) = circshift(data.VB(i,:),[0 -1]);
%                 data.VC(i,:) = circshift(data.VC(i,:),[0 -1]);
%                 data.VD(i,:) = circshift(data.VD(i,:),[0 -1]);
%         end
%     end
end
data.elapsed_time = sum(etime);  % elapsed time to download the PV the wait is longer to ensure all the Liberas have triggered.
data.mean_datatime = mean(datatime,2);  % mean data time that all the PVs have been updated, as a function of the devicelist.

% Log status of the Libera
if isnumeric(devicelist)
    % To differentiate the the booster BPMs that are currently not
    % version 2.06 and don't have some of these features.
    data.switches = getlibera('ENV_SWITCHES_MONITOR',devicelist,0,nelem);
    data.plloffset = getlibera('ENV_PLL_OFFSETTUNE_MONITOR',devicelist,0,nelem);
    data.pllcomptune = getlibera('ENV_PLL_COMPTUNE_MONITOR',devicelist,0,nelem);
end

data.deviceList = devicelist;
data.TimeStamp = clock;
data.CreatedBy = mfilename;
data.UnitsString = unitsstr;
data.Units = getunits('BPMx');
data.Mode = 'Online'; % By definition for now.

varargout{1} = data;