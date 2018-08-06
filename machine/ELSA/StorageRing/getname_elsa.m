function ChanName = getname_elsa(Family, Field, DeviceList)
%GETNAME_ELSA - Return the channel names for a family
%  ChanName = getname_elsa(Family, Field, DeviceList)


ChanName = '';

if nargin < 1
    error('Family name input needed.');
end
if nargin < 2
    Field = '';
end
if isempty(Field)
    Field = 'Monitor';
end

BPMNewFlag = 1;

if strcmpi(Family,'BPMx')
    if BPMNewFlag
        ChanName = [];
    else
        ChanName = [];
    end

elseif strcmpi(Family,'BPMy')
    if BPMNewFlag
        ChanName = [];
    else
        ChanName = [];
    end

elseif strcmpi(Family,'HCM') && strcmpi(Field,'Monitor')
    ChanName = [];

elseif strcmpi(Family,'HCM') && strcmpi(Field,'Setpoint')
    ChanName = [];

elseif strcmpi(Family,'VCM') && strcmpi(Field,'Monitor')
    ChanName = [];

elseif strcmpi(Family,'VCM') && strcmpi(Field,'Setpoint')
    ChanName = [];

elseif strcmpi(Family,'QF') && strcmpi(Field,'Monitor')
    ChanName = [];

elseif strcmpi(Family,'QF') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'QD') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'QD') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'QFA') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'QFA') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'QDA') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'QDA') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'SF') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'SF') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'SD') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'SD') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'BEND') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'BEND') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'RF') && strcmpi(Field,'Monitor')
    ChanName = '';

elseif strcmpi(Family,'RF') && strcmpi(Field,'Setpoint')
    ChanName = '';

elseif strcmpi(Family,'DCCT') && strcmpi(Field,'Monitor')
    ChanName = '';

else
    ChanName = strvcat(ChanName, ' ');
end
