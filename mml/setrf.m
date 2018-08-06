function setrf(RF, varargin)
%SETRF - Sets the RF frequency
%  setrf(RF, WaitFlag)
%
%  INPUTS
%  1. RF - RF frequency
%  2. WaitFlag = 0    -> return immediately {Default}
%                > 0  -> wait until ramping is done then adds an extra delay equal to WaitFlag 
%                = -1 -> wait until ramping is done
%                = -2 -> wait until ramping is done then adds an extra delay for fresh data 
%                        from the BPMs
%                = -3 -> wait until ramping is done then adds an extra delay for fresh data 
%                        from the tune measurement system
%                = -4 -> wait until ramping is done then wait for a carriage return
%  3. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%     The actual physics or hardware strings can also be used.  
%     For example, if the physics and hardware modes corresponds 
%     to Hz and MHz then strings 'Hz' or 'MHz' can be used to specify units.
%  4. 'Online' - Set data online (optional override of the mode)
%     'Model'  - Set data on the model (optional override of the mode)
%     'Manual' - Set data manually (optional override of the mode)
%
%  setrf converts a string input to a number, hence, setrf 476.3 is the same as setrf(476.3)
%
%  EXAMPES
%  1. setrf(476, 'MHz')  or  setrf 476 MHz  => sets the RF frequency 476 KHz
%  2. setrf 476000000 Hz                    => sets the RF frequency 476 KHz
%
%  NOTES
%  1. 'Hardware', 'Physics', 'MHz', 'Hz', 'Numeric', and 'Struct' are not case sensitive
%  2. The length(RFam) will equal the number of cavities in the ring
%
% See also getrf, steprf

%  Written by Greg Portmann


if nargin < 1
    error('No RF frequency input')
end
if ischar(RF)
    RF = str2num(RF);
end

WaitFlag = [];


% Allow actual units for conversions
HWUnits      = getfamilydata('RF','Setpoint','HWUnits');
PhysicsUnits = getfamilydata('RF','Setpoint','PhysicsUnits');


% Input line search
for i = length(varargin):-1:1
    if strcmpi(varargin{i}, 'Struct')
        % Pass input thru to setpv
    elseif strcmpi(varargin{i}, 'Numeric')
        % Pass input thru to setpv
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        % Pass input thru to setpv
    elseif strcmpi(varargin{i},'online')
        % Pass input thru to setpv
    elseif strcmpi(varargin{i},'manual')
        % Pass input thru to setpv
    elseif strcmpi(varargin{i},'Inc') || strcmpi(varargin{i},'Incremental')
        % Pass input thru to setpv
        IncrementalFlag = 1;
    elseif strcmpi(varargin{i}, 'Physics') || strcmpi(varargin{i}, PhysicsUnits)
        varargin{i} = 'Physics';
    elseif strcmpi(varargin{i}, 'Hardware') || strcmpi(varargin{i}, HWUnits)
        varargin{i} = 'Hardware';
    elseif isnumeric(varargin{i})
        WaitFlag = varargin{i};
        varargin(i) = [];
    else
        if ~isempty(varargin{i})
            if ischar(varargin{i})
                fprintf('   Input ''%s'' ignored', varargin{i});
            else
                fprintf('   Input ''%f'' ignored', varargin{i});
            end
        end
        varargin(i) = [];
    end
end


% Set RF
if isstruct(RF)
    setpv(RF, WaitFlag, varargin{:});
else
    setpv('RF', 'Setpoint', RF, [], WaitFlag, varargin{:});
end





% % Used for conversions
% Units        = getfamilydata('RF','Setpoint','Units');
% HWUnits      = getfamilydata('RF','Setpoint','HWUnits');
% PhysicsUnits = getfamilydata('RF','Setpoint','PhysicsUnits');
% 
% 
% % Input line search (if not a data structure)
% if isstruct(RF)
%     UnitsInput = RF.Units;
%     UnitsString = RF.UnitsString;
%     RF = RF.Data;
% else
%     UnitsInput = '';
%     for i = length(varargin):-1:1
%         if strcmpi(varargin{i}, 'Physics') | strcmpi(varargin{i}, PhysicsUnits)
%             UnitsInput = 'Physics';
%         elseif strcmpi(varargin{i}, 'Hardware') | strcmpi(varargin{i}, HWUnits)
%             UnitsInput = 'Hardware';
%         else
%             if ~isempty(varargin{i})
%                 if ischar(varargin{i})
%                     fprintf('   Input %s ignored', varargin{i});
%                 else
%                     fprintf('   Input %f ignored', varargin{i});
%                 end
%             end
%         end
%         varargin(i) = [];
%     end
% end
% 
% % Convert units if necessary
% if ~isempty(UnitsInput)
%     % 'Physics', 'Hardware', 'Hz', or 'Mz' was input
%     if strcmpi(UnitsInput, 'Physics') & strcmpi(Units, 'Hardware')
%         RF = physics2hw('RF', 'Setpoint', RF);
%     elseif strcmpi(UnitsInput, 'Physics') & strcmpi(Units, 'Physics')
%         % OK as is
%     elseif strcmpi(UnitsInput, 'Hardware') & strcmpi(Units, 'Physics')
%         RF = hw2physics('RF', 'Setpoint', RF);
%     elseif strcmpi(UnitsInput, 'Hardware') & strcmpi(Units, 'Hardware')
%         % OK as is
%     else
%         error(sprintf('"%s" units are an unknown type, hence no change to the RF frequency', UnitsInput));
%     end
% end
% 
% 
% setsp('RF', RF);
