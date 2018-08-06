function  [DelSext, ActuatorFamily] = stepchro(varargin)
%STEPCHRO - Incremental change in the chromaticity (Delta Tune / Delta RF)
%  [DelSext, SextFamily] = stepchro(DeltaChromaticity, ChroResponseMatrix)
%
%  Step change in storage ring chromaticity using the default chromaticty correctors (findmemberof('Chromaticity Corrector'))
%
%  INPUTS
%  1.                     | Change in Horizontal Chromaticity |
%     DeltaChromaticity = |                                   | 
%                         | Change in Vertical Chromaticity   |
%  2. ChroResponseMatrix - Chromaticity response matrix {Default: getchroresp}
%  3. Optional override of the units:
%     'Physics'  - Use physics  units {Default}
%     'Hardware' - Use hardware units
%  4. Optional override of the mode:
%     'Online'    - Set/Get data online  
%     'Simulator' - Set/Get data on the simulated accelerator
%     'Model'     - (same as 'Simulator')
%     'Manual'    - Set/Get data manually
%
%  OUTPUTS
%  1. DelSext
%  2. SextFamily - Families used (cell array)
%
%  ALGORITHM  
%  DelSext = inv(CHROMATICITY_RESP_MATRIX) * DeltaChromaticity
%
%  NOTES
%  1. Beware of what units you are working in.  The default units for chromaticity
%     are physics units.  This is an exception to the normal middle layer convention.
%     Hardware units for "chromaticity" is in tune change per change in RF frequency.  
%     Since this is an unusual unit to work with, the default units for chromaticity
%     is physics units.  Note that goal chromaticity is also stored in physics units.
%  2. The actuator family comes from findmemberof('Chromaticity Corrector') or 'SF','SD' if empty
%  
%  See also getchro, setchro, measchroresp

%  Written by Greg Portmann


ActuatorFamily = findmemberof('Chromaticity Corrector')';
if isempty(ActuatorFamily)
    error('MemberOf ''Chromaticity Corrector'' was not found');
end

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


if length(varargin) >= 1
    DeltaChrom = varargin{1};
else
    DeltaChrom = [];    
end
if isempty(DeltaChrom)
    answer = inputdlg({'Change the horizontal chromaticity by', 'Change the vertical chromaticity by'},'STEPCHRO',1,{'0','0'});
    if isempty(answer)
        return
    end
    DeltaChrom(1,1) = str2num(answer{1});
    DeltaChrom(2,1) = str2num(answer{2});
end
DeltaChrom = DeltaChrom(:);
if size(DeltaChrom,1) ~= 2
    error('Input must be a 2x1 column vector.');
end
if DeltaChrom(1)==0 && DeltaChrom(2)==0
    return
end

if length(varargin) >= 2
    ChroResponseMatrix = varargin{2};
else
    ChroResponseMatrix = [];    
end
if isempty(ChroResponseMatrix)
    ChroResponseMatrix = getchroresp(UnitsFlag{:});
end
if isempty(ChroResponseMatrix)
    error('The chromaticity response matrix must be an input or available in one of the default response matrix files.');
end


% 1. SVD Tune Correction
% Decompose the chromaticity response matrix:
[U, S, V] = svd(ChroResponseMatrix, 'econ');
% ChroResponseMatrix = U*S*V'
%
% The V matrix columns are the singular vectors in the sextupole magnet space
% The U matrix columns are the singular vectors in the chromaticity space
% U'*U=I and V*V'=I
%
% CHROCoef is the projection onto the columns of ChroResponseMatrix*V(:,Ivec) (same space as spanned by U)
% Sometimes it's interesting to look at the size of these coefficients with singular value number.
CHROCoef = diag(diag(S).^(-1)) * U' * DeltaChrom;
%
% Convert the vector CHROCoef back to coefficents of ChroResponseMatrix
DelSext = V * CHROCoef;


% 2. Square matrix solution
%DelSext = inv(ChroResponseMatrix) * DeltaChrom;


SP = getsp(ActuatorFamily, UnitsFlag{:}, ModeFlag{:});

if iscell(SP)
    for i = 1:length(SP)
        SP{i} = SP{i} + DelSext(i);
    end
else
    SP = SP + DelSext;
end


setsp(ActuatorFamily, SP, UnitsFlag{:}, ModeFlag{:});

