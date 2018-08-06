function [RFsp, RFam, DataTime, ErrorFlag] = getrf(varargin)
%GETRF - Gets the RF frequency
%  [RFsp, RFam, DataTime] = getrf
%
%  INPUTS
%  1. 'Struct' will return a data structure
%     'Numeric' will return scalar outputs {default}
%  2. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%     The actual physics or hardware strings can also be used.  
%     For example, if the physics and hardware modes corresponds 
%     to Hz and MHz then strings 'Hz' or 'MHz' can be used to specify units.
%  3. 'Online' - Get data online (optional override of the mode)
%     'Model'  - Get data from the model (optional override of the mode)
%     'Manual' - Get data manually (optional override of the mode)
%
%  OUTPUTS
%  1. RFsp is the RF setpoint
%  2. RFam is the RF monitor (if one exists, if not RFam = RFsp)
%  3. DataTime - Time when the data was measured (as report by the hardware, see getpv)
%
%  EXAMPES
%  1. setrf 476 MHz                => sets the RF frequency 476 MHz
%     getrf Hz   or  getrf('Hz')   => returns 476000000
%     getrf MHz  or  getrf('MHz')  => returns 476
%
%  NOTES
%  1. 'Hardware', 'Physics', 'MHz', 'Hz', 'Numeric', and 'Struct' are not case sensitive
%  2. All inputs are optional
%  3. The length(RFam) will equal the number of cavities in the ring

%  Written by Greg Portmann


% Allow actual units for conversions
HWUnits      = getfamilydata('RF','Setpoint','HWUnits');
PhysicsUnits = getfamilydata('RF','Setpoint','PhysicsUnits');


% Input line search
for i = length(varargin):-1:1
    if strcmpi(varargin{i}, 'Struct')
        % Pass input thru to getpv
    elseif strcmpi(varargin{i}, 'Numeric')
        % Pass input thru to getpv
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        % Pass input thru to getpv
    elseif strcmpi(varargin{i},'online')
        % Pass input thru to getpv
    elseif strcmpi(varargin{i},'manual')
        % Pass input thru to getpv
    elseif strcmpi(varargin{i}, 'Physics') || strcmpi(varargin{i}, PhysicsUnits)
        varargin{i} = 'Physics';
    elseif strcmpi(varargin{i}, 'Hardware') || strcmpi(varargin{i}, HWUnits)
        varargin{i} = 'Hardware';
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


% Get data
if strcmpi(getfamilydata('MachineType'), 'Transport')
    % No RF
    RFsp = [];
    RFam =[];
    DataTime = [];
    ErrorFlag=0;

else
    [RFsp, tout, DataTime, ErrorFlag] = getpv('RF', 'Setpoint', varargin{:});

    if isstruct(RFsp)
        RFsp.CreatedBy = 'getrf';
        RFsp.DataDescriptor = 'RF Frequency';
    end

    % Check for seconds output
    if nargout >= 2
        RFam = getpv('RF', 'Monitor', varargin{:});
        if isstruct(RFam)
            RFam.CreatedBy = 'getrf';
            RFam.DataDescriptor = 'RF Frequency';
        end
    end
end



% %Units        = getfamilydata('RF','Setpoint','Units');
% 
% % Allow for units conversion
% if ~isempty(UnitsInput)
%     % 'Physics', 'Hardware', 'Hz', or 'Mz' was input
%     if strcmpi(UnitsInput, 'Physics') & strcmpi(Units, 'Hardware')
%         RFam = hw2physics('RF', 'Setpoint', RFam);
%         if nargout > 1
%             if StructOutputFlag
%                 RFsp.Data = hw2physics('RF', 'Setpoint', RFsp.Data);
%                 RFsp.Units = 'Physics';
%                 RFsp.UnitsString = PhysicsUnits;
%             else
%                 RFsp = hw2physics('RF', 'Setpoint', RFsp);
%             end
%         end
%         RFStruct.Units = 'Physics';
%         RFStruct.UnitsString = PhysicsUnits;
%     elseif strcmpi(UnitsInput, 'Physics') & strcmpi(Units, 'Physics')
%         % OK as is
%     elseif strcmpi(UnitsInput, 'Hardware') & strcmpi(Units, 'Physics')
%         RFam = physics2hw('RF', 'Setpoint', RFam);
%         if StructOutputFlag
%             RFsp.Data = physics2hw('RF', 'Setpoint', RFsp.Data);
%             RFsp.Units = 'Hardware';
%             RFsp.UnitsString = HWUnits;
%         else
%             RFsp = physics2hw('RF', 'Setpoint', RFsp);
%         end
%         RFStruct.Units = 'Hardware';
%         RFStruct.UnitsString = HWUnits;
%     elseif strcmpi(UnitsInput, 'Hardware') & strcmpi(Units, 'Hardware')
%         % OK as is
%     else
%         error(sprintf('"%s" units are an unknown type', UnitsInput));
%     end    
% end
% 
% if StructOutputFlag
%     RFStruct.Data = RFam;
%     RFStruct.CreatedBy = 'getrf';
%     RFStruct.DataDescriptor = 'RF Frequency';
%     
%     RFam = RFStruct;
% end


