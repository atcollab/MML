function [DelQuad, ActuatorFamily] = settune(varargin)
%SETTUNE - Set the tune
%  [DelQuad, QuadFamily] = settune(NuDesired, InteractiveFlag, TuneResponseMatrix);
%
%  INPUTS
%  1. NuDesired - Desired tune   [NuX; NuY] (2x1) {Default: golden tunes}
%  2. InteractiveFlag - 0    -> No display information
%                       else -> display tune information before setting magnets {Default}
%  3. TuneResponseMatrix - Tune response matrix {Default: gettuneresp}
%  4. ActuatorFamily -  Quadrupole to vary, ex {'Q7', 'Q9'} {Default: gettuneresp}
%  5. Optional override of the units:
%     'Physics'  - Use physics  units
%     'Hardware' - Use hardware units
%  6. Optional override of the mode:
%     'Online'    - Set/Get data online  
%     'Model'     - Set/Get data on the simulated accelerator using AT
%     'Simulator' - Set/Get data on the simulated accelerator using AT
%     'Manual'    - Set/Get data manually
%
%  OUTPUTS
%  1. DelQuad
%  2. QuadFamily - Families used (cell array)
%
%  Algorithm:  
%     SVD method
%     DelQuad = inv(TuneResponseMatrix) * DeltaTune
%     instead of 
%     DelQuad = inv(TuneResponseMatrix) * (Nu-gettune)
%              DelQuad = [Q7; Q9]
%
%  NOTES
%  1. If gettune only uses the fractional tune then NuDesired should only have fractional tunes.
%  2. The tune measurement system must be running correctly for this routine to work properly.
%
%  EXAMPLES
%  1. use 2 defaults family if specified in 'Tune Corrector'
%     settune([18.23 10.3]
%  2. use 10 families
%     Qfam = findmemberof('QUAD');
%     RTune = meastuneresp(Qfam, 'Model')
%     [DK Fam] = settune([18.12 10.3],1,RTune,Qfam,'Model')
%
%  See also steptune, gettune

%  Written by Gregory J. Portmann
%  Modified by Laurent S. Nadolski
%    Adaptation for SOLEIL
%    Modification ALGO : use SVD as in steptune

% Case of 2 families or more
ActuatorFamily = findmemberof('Tune Corrector')';
if isempty(ActuatorFamily) % Default 2 families
    ActuatorFamily = {'QF','QD'};
end

% Input parser
UnitsFlag = {}; 
ModeFlag = {};
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
    Nu = varargin{1};
else
    Nu =[];
end

% Golden values
if isempty(Nu)
    Nu = getgolden('TUNE',[1 1;1 2]);
end

if isempty(Nu)
    error('Tune must be an input or the golden tunes must be available.');
end
Nu = Nu(:);
if ~all(size(Nu) == [2 1])
    error('Nu must be a 2x1 vector.');
end

if length(varargin) >= 2
    InteractiveFlag = varargin{2};
else
    InteractiveFlag = 1;
end

% Get tune response matrix
if length(varargin) >= 3
    TuneResponseMatrix = varargin{3};
else
    TuneResponseMatrix = [];
end

% Get ActuatorFamilies
if length(varargin) >= 4
    ActuatorFamily1 = varargin{4};
else
    ActuatorFamily1 = ActuatorFamily;
end

% Interactive part
if InteractiveFlag
    Flag = 1;
    if isempty(TuneResponseMatrix)
        TuneResponseMatrix = gettuneresp(UnitsFlag{:});
    end
    if isempty(TuneResponseMatrix)
        error('The tune response matrix must be an input or available in one of the default response matrix files.');
    end
    while Flag
        TuneOld = gettune;
        fprintf('\n');
        fprintf('  Present Tune:  Horizontal = %.4f   Vertical = %.4f\n', TuneOld(1), TuneOld(2));
        fprintf('     Goal Tune:  Horizontal = %.4f   Vertical = %.4f\n', Nu(1), Nu(2));

        DelNu = Nu - TuneOld;

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
        TUNECoef = diag(diag(S).^(-1)) * U' * DelNu;
        %
        % Convert the vector TUNECoef back to coefficents of TuneResponseMatrix
        DelQuad = V * TUNECoef;

        % 2. Square matrix solution
        % DelQuad = inv(TuneResponseMatrix) * DelNu; %  DelQuad = [Q7; Q9];


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
        % DelQuad = TuneResponseMatrix \ DelNu;

        for k = 1:length(ActuatorFamily1)
            [Units, UnitsString] = getunits(ActuatorFamily1{k});
            if k == 1
                fprintf('   Quad Change:  Delta %3s = %+f %s\n', ActuatorFamily1{k}, DelQuad(k), UnitsString);
            else
                fprintf('                 Delta %3s = %+f %s\n', ActuatorFamily1{k}, DelQuad(k), UnitsString);
            end
        end
        fprintf('\n')

        tmp = menu('Choose an option?','Step quadrupoles','Remeasure Tunes','Change goal tune','Exit');
        if tmp == 1
            Flag = 0;
        elseif tmp == 2
            Flag = 1;
        elseif tmp == 3
            Nu(1) = input('  Input new horizontal tune = ');
            Nu(2) = input('  Input new   vertical tune = ');
            % Nu(1) = rem(Nu(1),1);
            % Nu(2) = rem(Nu(2),1);
        else
            disp('  Tunes not changed.');
            return
        end
    end

    disp('  Changing quadrupoles...');

else
    % Non interactive part
    TuneOld = gettune;
end


% Set the tune
DeltaTune = Nu - TuneOld;
if size(DeltaTune,1) ~= 2
	error('Input must be a 2x1 column vector.');
end

% Step the tune
[DelQuad, ActuatorFamily] = steptune(DeltaTune, TuneResponseMatrix, UnitsFlag{:}, ModeFlag{:});


if InteractiveFlag
   disp('  Set tune complete.');
end

