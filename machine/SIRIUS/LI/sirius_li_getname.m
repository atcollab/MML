function  [ChannelName, ErrorFlag] = sirius_tb_getname(Family, Field, DeviceList)
% ChannelName = getname_tb_sirius(Family, Field, DeviceList)
%
%   INPUTS
%   1. Family name
%   2. Field
%   3. DeviceList ([Sector Device #] or [element #])
%
%   OUTPUTS
%   1. ChannelName = IOC channel name corresponding to the family and DeviceList



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  OUT OF DATE %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
    error('Must have at least one input (''Family'')!');
end
if nargin < 2
    Field = 'Monitor';
end
if nargin < 3
    DeviceList = [];
end

ChannelName = [];

switch lower(Family)

    case {'bpmx', 'bpmy'}
        if (strcmpi(Field, 'Monitor') || strcmpi(Field, 'CommonNames'))
            ChannelName = [
                'LIDI-BPM-02-A'; 'LIDI-BPM-02-B';  'LIDI-BPM-03-A';
                'LIDI-BPM-03-B'; 'LIDI-BPM-04  '; 'LIDI-BPM-05  '];

            if strcmpi(Family, 'bpmx')
                ChannelName = strcat(ChannelName, '-X');
            else
                ChannelName = strcat(ChannelName, '-Y');
            end
        else
            error('Don''t know how to make the channel name for family %s', Family);
        end

    case 'spect'
        ChannelName = 'LIPS-BEND-01';

    case 'qf3'
        ChannelName = 'LIPS-Q1C-01';

    case 'qd1'
        ChannelName = 'LIPS-QD-02';

    case 'qf1'
        ChannelName = 'LIPS-QF-02';

    case 'qd2'
        ChannelName = 'LIPS-QD-03-A';

    case 'qf2'
        ChannelName = 'LIPS-QF-03-A';

    case {'hcm', 'ch'}
        ChannelName = [
            'LIPS-CH-02-A'; 'LIPS-CH-02-B';
            'LIPS-CH-03-A'; 'LIPS-CH-03-B'; 'LIPS-CH-04  '];

    case {'vcm', 'cv'}
        ChannelName = [
            'LIPS-CV-02-A'; 'LIPS-CV-02-B'; 'LIPS-CV-03-A';
            'LIPS-CV-03-B'; 'LIPS-CV-05-A'; 'LIPS-CV-05-B'];

    otherwise
        error('Don''t know how to make the channel name for family %s', Family);

end

if any(strcmpi(Family, {'bpmx', 'bpmy'}))

else
    if strcmpi(Field, 'Monitor')
        ChannelName = strcat(ChannelName, '-RB');
    elseif strcmpi(Field, 'Setpoint')
        ChannelName = strcat(ChannelName, '-SP');
    end
end


end
