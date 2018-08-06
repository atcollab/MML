function  [ChannelName, ErrorFlag] = sirius_ts_getname(Family, Field, DeviceList)
% ChannelName = getname_sirius(Family, Field, DeviceList)
%
%   INPUTS
%   1. Family name
%   2. Field
%   3. DeviceList ([Sector Device #] or [element #]) (default: whole family)
%
%   OUTPUTS
%   1. ChannelName = IOC channel name corresponding to the family and DeviceList


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
                'TSDI-BPM-01  '; 'TSDI-BPM-02  '; 'TSDI-BPM-03  ';
                'TSDI-BPM-04-A'; 'TSDI-BPM-04-B'];
      
    
            if strcmpi(Family, 'bpmx')
                ChannelName = strcat(ChannelName, '-X');
            else
                ChannelName = strcat(ChannelName, '-Y');                
            end
        else
            error('Don''t know how to make the channel name for family %s', Family);
        end
          
    case 'b'
        ChannelName = ['TSPS-BEND-01'; 'TSPS-BEND-02'; 'TSPS-BEND-03'];

    case 'septex'
        ChannelName = 'TSPU-SEPTUMEXT-01';
        
    case 'ejesf'
        ChannelName = 'TSPU-THINSEPTUMEJE';
    case 'ejesg'
        ChannelName = 'TSPU-THICKSEPTUMEJE';
    case 'injsg'
        ChannelName = 'TSPU-THICKSEPTUMINJ';
    case 'injsf'
        ChannelName = 'TSPU-THINSEPTUMINJ';
        
    case 'septin'
        ChannelName = 'TSPU-SEPTUMINJ-04';
    
    case 'qf1a'
        ChannelName = 'TSPS-QF-01-A';

    case 'qf1b'
        ChannelName = 'TSPS-QF-01-B';    

    case 'qd2'
        ChannelName = 'TSPS-QD-02';

    case 'qf2'
        ChannelName = 'TSPS-QF-02';        

    case 'qf3'
        ChannelName = 'TSPS-QF-03';     

    case 'qd4a'
        ChannelName = 'TSPS-QD-04-A';

    case 'qf4'
        ChannelName = 'TSPS-QF-04';   
        
    case 'qd4b'
        ChannelName = 'TSPS-QD-04-B';  
        
    case {'hcm', 'ch'}
        ChannelName = ['TSPS-CH-01'; 'TSPS-CH-02'; 'TSPS-CH-03'; 'TSPS-CH-04'];
        
    case {'vcm', 'cv'}
        ChannelName = ['TSPS-CV-01-A'; 'TSPS-CV-01-B'; 'TSPS-CV-02  '; 'TSPS-CV-03  '; 'TSPS-CV-04-A'; 'TSPS-CV-04-B'];
            
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


