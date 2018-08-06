function [DelSext, ActuatorFamily] = setchro(varargin)
%SETCHRO - Measures then sets the chromaticity
%  [DelSext, SextFamily] = setchro(NewChromaticity, ChroResponseMatrix, DeltaRF)
%
%  INPUTS
%  1.                   | Horizontal Chromaticity |
%     NewChromaticity = |                         | 
%                       | Vertical Chromaticity   |
%  2. ChroResponseMatrix - Chromaticity response matrix {Default: getchroresp}
%  3. DeltaRF - measchro for an explaination of DeltaRF {Default comes from measchro}
%  4. Optional override of the units:
%     'Physics'  - Use physics  units {Default}
%     'Hardware' - Use hardware units
%  5. Optional override of the mode:
%     'Online'    - Set/Get data online  
%     'Simulator' - Set/Get data on the simulated accelerator (same commands as 'Online')
%     'Model'     - Set are the same as 'Simulator' / gets are directly from the model.
%     'Manual'    - Set/Get data manually
%
%  OUTPUTS
%  1. DelSext - Change in sextrupole strength (vector by family)
%  2. SextFamily - Families used (cell array)
%
%  ALGORITHM  
%     DelSext = inv(CHROMATICITY_RESP_MATRIX) * (NewChromaticity-getchro)
%
%  NOTES
%  1. Beware of what units you are working in.  The default units for chromaticity
%     are physics units.  This is an exception to the normal middle layer convention.
%     Hardware units for "chromaticity" is in tune change per change in RF frequency.  
%     Since this is an unusual unit to work with, the default units for chromaticity
%     is physics units.  Note that goal chromaticity is also stored in physics units.
%  2. The actuator family comes from findmemberof('Chromaticity Corrector') or 'SF','SD' if empty
%  
%  See also stepchro, measchro

%  Written by Greg Portmann


ActuatorFamily = {};
ModeFlag  = {};           % model, online, manual, or '' for default mode
UnitsFlag = {'Physics'};  % hardware, physics, or '' for default units

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'physics')
        UnitsFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        ModeFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'online')
        ModeFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'manual')
        ModeFlag = varargin(i);
        varargin(i) = [];
    end        
end


NewChro = [];
if length(varargin) >= 1
    NewChro = varargin{1};
end
if isempty(NewChro)
    if strcmpi(UnitsFlag{1}, 'Physics')
        NewChro = getgolden('Chromaticity');                        % Physics units
    elseif strcmpi(UnitsFlag{1}, 'Hardware')
        NewChro = -1 * getgolden('Chromaticity') / getrf / getmcf;  % Hardware units
    else
        error('Units unknown');
    end
    NewChro = NewChro(1:2);
    NewChro = NewChro(:);
end
if isempty(NewChro)
    error('Golden chromaticity not found');
end

if length(varargin) >= 2
    ChroResponseMatrix = varargin{2};
else
    ChroResponseMatrix = [];    
end

disp('   Begin initial chromaticity measurement...');
if length(varargin) < 3
    MeasuredChrom = measchro('Numeric', UnitsFlag{:}, ModeFlag{:});
else
    MeasuredChrom = measchro(varargin{3}, 'Numeric', UnitsFlag{:}, ModeFlag{:});
end

fprintf('   Measured Horizontal Chromaticity = %f (Goal is %f)\n', MeasuredChrom(1), NewChro(1));
fprintf('   Measured Vertical   Chromaticity = %f (Goal is %f)\n', MeasuredChrom(2), NewChro(2));

if strcmpi(questdlg('Do you want to change the chromaticity now?','Yes','No'), 'Yes')
    disp('   Begin chromaticity change ...');
    drawnow;
    [DelSext, ActuatorFamily] = stepchro([NewChro(1)-MeasuredChrom(1); NewChro(2)-MeasuredChrom(2)], ChroResponseMatrix, UnitsFlag{:}, ModeFlag{:});
    disp('   Finished chromaticity change');
else
    disp('   Chromaticity not changed');
    drawnow;
    DelSext = [0;0];  % I'm guessing that there are 2 chromaticity correction families
end
