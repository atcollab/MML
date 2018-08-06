function Units = switchunits(varargin)
%SWITCHUNITS - Change the units field  for all families in the MML
%  Units = switchunits(Command)
%
%  INPUTS
%  1. Command - 'Hardware' or 'Physics'
%
%  See also switchmode, switch2hw, switch2physics

%  Written by Greg Portmann

if length(varargin) == 0
    ButtonName = questdlg('Matlab MiddleLayer Units?',getfamilydata('OperationalMode'),'Hardware', 'Physics', 'Hardware');
    switch ButtonName,
        case 'Hardware'
            switch2hw;
            Units = 'Hardware';
        case 'Physics'
            Units = 'Physics';
            switch2physics;
    end
else
    if strcmpi(varargin{1},'hardware') | strcmpi(varargin{1},'hw')
        switch2hw;
        Units = 'Hardware';
    elseif strcmpi(varargin{1},'physics')
        switch2physics;
        Units = 'Physics';
    else
        error('Units type unknown.');
    end
end