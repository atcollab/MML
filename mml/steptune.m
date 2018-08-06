function [DelQuad, ActuatorFamily] = steptune(varargin)
%STEPTUNE - Step the tune
%  [DelQuad, QuadFamily] = steptune(DeltaTune, TuneResponseMatrix, ActuatorFamily)
%
%  Step change in storage ring tune using the default tune correctors (findmemberof('Tune Corrector'))

%  INPUTS
%  1.             | Change in Horizontal Tune |
%     DeltaTune = |                           |
%                 | Change in Vertical Tune   |
%  2. TuneResponseMatrix - Tune response matrix {Default: findmemberof('Tune Corrector')}
%  3. ActuatorFamily -  Quadrupole to vary, ex {'Q7', 'Q9'} {Default: findmemberof('Tune Corrector')}
%  4. Optional override of the units:
%     'Physics'  - Use physics  units
%     'Hardware' - Use hardware units
%  5. Optional override of the mode:
%     'Online'    - Set/Get data online  
%     'Model'     - Set/Get data on the simulated accelerator using AT
%     'Simulator' - Set/Get data on the simulated accelerator using AT
%     'Manual'    - Set/Get data manually
%
%  OUTPUTS
%  1. DelQuad
%  2. QuadFamily - Families used (cell array)
%
%  ALGORITHM  
%  SVD method
%  DelQuad = inv(TuneResponseMatrix) * DeltaTune
%  
%  See also settune, meastuneresp

%  Written by Gregory J. Portmann
%  Modified by Laurent S. Nadolski
%   06/01/06 - Introduction of ActuatorFamily as a input


% Initialize
UnitsFlag = {}; 
ModeFlag = {};
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'physics')
        UnitsFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Simulator') || strcmpi(varargin{i},'Model')
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
    DeltaTune = varargin{1};
else
    DeltaTune = [];    
end
if isempty(DeltaTune)
    answer = inputdlg({'Change the horizontal tune by', 'Change the vertical tune by'},'STEPTUNE',1,{'0','0'});
    if isempty(answer)
        return
    end
    DeltaTune(1,1) = str2num(answer{1});
    DeltaTune(2,1) = str2num(answer{2});
end

DeltaTune = DeltaTune(:);
if size(DeltaTune,1) ~= 2
	error('Input must be a 2x1 column vector.');
end
if DeltaTune(1)==0 && DeltaTune(2)==0
    return
end

if length(varargin) >= 2
    TuneResponseMatrix = varargin{2};
else
    TuneResponseMatrix = [];    
end
if isempty(TuneResponseMatrix)
    TuneResponseMatrix = gettuneresp(UnitsFlag{:});
end
if isempty(TuneResponseMatrix)
    error('The tune response matrix must be an input or available in one of the default response matrix files.');
end

% User ActuatorFamily
if length(varargin) >= 3
    ActuatorFamily = varargin{3};
else
    ActuatorFamily = findmemberof('Tune Corrector')';
    if isempty(ActuatorFamily)
        error('MemberOf ''Tune Corrector'' was not found');
    end
end

% It's probably wise to check the .Units fields

% 1. SVD Tune Correction
% Decompose the tune response matrix:
[U, S, V] = svd(TuneResponseMatrix, 'econ');
% TuneResponseMatrix = U*S*V'
%
% The V matrix columns are the singular vectors in the quadrupole magnet space
% The U matrix columns are the singular vectors in the TUNE space
% U'*U=I and V*V'=I
%
% TUNECoef is the projection onto the columns of TuneResponseMatrix*V(:,Ivec) (same space as spanned by U)
% Sometimes it's interesting to look at the size of these coefficients with singular value number.
TUNECoef = diag(diag(S).^(-1)) * U' * DeltaTune;
%
% Convert the vector TUNECoef back to coefficents of TuneResponseMatrix
DelQuad = V * TUNECoef;


% 2. Square matrix solution
% DelQuad = inv(TuneResponseMatrix) * DeltaTune;


% 3. Least squares solution
% DelQuad = inv(TuneResponseMatrix'*TuneResponseMatrix)*TuneResponseMatrix' * DeltaTune;
%
% see Matlab help for "Matrices and Linear Algebra" to see what this does
% If overdetermined, then "\" is least squares
%
% If underdetermined (like more than 2 quadrupole families), then only the 
% columns with the 2 biggest norms will be keep.  The rest of the quadupole 
% families with have zero effect.  Hence, constraints would have to be added for 
% this method to work.
% DelQuad = TuneResponseMatrix \ DeltaTune;



% Make the setpoint change
SP = getsp(ActuatorFamily, UnitsFlag{:}, ModeFlag{:});

if iscell(SP)
    for i = 1:length(SP)
        SP{i} = SP{i} + DelQuad(i);
    end
else
    SP = SP + DelQuad;
end

setsp(ActuatorFamily, SP, UnitsFlag{:}, ModeFlag{:});

