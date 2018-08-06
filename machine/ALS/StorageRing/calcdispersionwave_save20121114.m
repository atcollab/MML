function [Total, Wave, Bump, Factor_Wave, Factor_Bump, LatticeFlag] = calcdispersionwave(varargin)
%CALCDISPERSIONWAVE - Calculates the dispersion wave and bump
%  [Total, Wave, Bump, Factor_Wave, Factor_Bump, LatticeFlag] = calcdispersionwave(Factor_Wave, Factor_Bump, LatticeFlag)
%
%  INPUTS
%  1. Factor_Wave - Scale factor on the dispersion wave
%  2. Factor_Bump - Scale factor on the dispersion bump
%                   Presently, bumps can only be added to the 'Distributed Dispersion' lattice
%  3. LatticeFlag - Lattice flag for the dispersion wave
%                   'Distributed Dispersion' - 6 cm horizontal dispersion in the straights
%                   'Zero Dispersion' - Zero horizontal dispersion in the straights
%  4. 'Hardware' {Default} or 'Physics' units
%  NOTE: it does not matter where the string inputs (3 & 4) appear in the input order.
%
%  OUTPUTS
%  1. Total - Combined dispersion wave & bump
%  2. Wave  - Dispersion wave
%  3. Bump  - Dispersion bump
%  NOTE: All outputs are structure arrays: (1)-SQSF, (2)-SQSD
%


% Input checking
LatticeFlag = ''; Total=[]; Wave=[]; Bump=[]; LatticeFlag=[]; Factor_Wave=[]; Factor_Bump=[];
NumericOutputFlag = 0;  % Not implemented yet
UnitsFlag = 'Hardware';
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Ignor flag
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        NumericOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model') || strcmpi(varargin{i},'Online') || strcmpi(varargin{i},'Manual')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlag = 'Physics';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = 'Hardware';
        varargin(i) = [];
    elseif ischar(varargin{i})
        % Lattice flag input
        LatticeFlag = varargin{i};
        varargin(i) = [];
    end
end


if isempty(LatticeFlag)
    LatticeFlag =  questdlg({...
        'The vertical dispersion wave depends on the lattice:', ...
        '1. Distributed  Dispersion (6 cm horizontal in straights)', ...
        '    (Typically the production lattice)', ...
        '2. Zero Dispersion (horizontal in straights)', ...
        '    (Typically the injection lattice)', ...
        ' ', ...
        'Which Lattice?'}, ...
        sprintf('Mode: %s',getfamilydata('OperationalMode')), ...
        'Distributed Dispersion','Zero Dispersion','Distributed Dispersion');
end


if length(varargin) >= 1
    Factor_Wave = varargin{1};
else
    prompt={'Enter the scale factor for global Eta-y wave'};
    def={'0.8'};
    dlgTitle='Selection whether to correct to small emittance, or user settings';
    lineNo=1;
    answernum=inputdlg(prompt,dlgTitle,lineNo,def);
    if ~isempty(answernum)
        Factor_Wave = str2double(answernum{1});
    else
        disp('   calcdispersionwave cancelled');
        return;
    end
end


if strcmpi(LatticeFlag,'Distributed Dispersion')
    if length(varargin) >= 2
        Factor_Bump = varargin{2};
    else
        prompt = {'Enter the factor for local Eta-y bump'};
        def = {'1.0'};
        dlgTitle = 'Selection of dispersion bump size';
        lineNo = 1;
        answernum = inputdlg(prompt,dlgTitle,lineNo,def);
        if ~isempty(answernum)
            Factor_Bump = str2double(answernum{1});
        else
            disp('   calcdispersionwave cancelled');
            return;
        end
    end
else
    if length(varargin) >= 2 && (~isempty(varargin{2}) || varargin{2} ~= 0)
        fprintf('   Dispersion bump will be ignored for Zero Dispersion lattice.\n');
    end
    Factor_Bump = 0;
end


% Create data structure arrays
Wave    = family2datastruct('SQSF', 'Setpoint', 'Physics');
Wave(2) = family2datastruct('SQSD', 'Setpoint', 'Physics');
Bump = Wave;



%%%%%%%%%%%%%%%%%%%%%%%%%
% Local Dispersion Bump %
%%%%%%%%%%%%%%%%%%%%%%%%%

% Theoretical k values [m^-2] for the skews by Walter Wittmer
List = [5 1; 5 2; 6 1; 6 2; 7 1; 7 2];
DispersionBump_K_SQSF = [
    -0.36984004      % [5 1]
    -0.22817710      % [5 2]
    -0.25978570      % [6 1]
    -0.10999989      % [6 2]
    -0.05744313      % [7 1]
    -0.09800899];    % [7 2]
[i, j] = findrowindex(List, Wave(1).DeviceList);
if ~isempty(j)
    error('SQSF is in the disperion bump that is not in the present lattice');
else
    Bump(1).Data = zeros(length(Bump(1).Data),1);
    Bump(1).Data(i) = DispersionBump_K_SQSF;
end

DispersionBump_K_SQSD = [
    +0.22515577      % [5 1]
    -0.03016227      % [5 2]
    -0.03330246      % [6 1]
    +0.03189800];    % [6 2]
List = [5 1; 5 2; 6 1; 6 2;];
[i, j] = findrowindex(List, Wave(2).DeviceList);
if ~isempty(j)
    error('SQSD is in the disperion bump that is not in the present lattice');
else
    Bump(2).Data = zeros(length(Bump(2).Data),1);
    Bump(2).Data(i) = DispersionBump_K_SQSD;
end


%%%%%%%%%%%%%%%%%%%%%%%%%
% Local Dispersion Wave %
%%%%%%%%%%%%%%%%%%%%%%%%%

% Theoretical k values [m^-2] for the skews as determined with a fit using the accelerator toolbox
if strcmpi(LatticeFlag,'Distributed Dispersion')
    disp('   Distributed dispersion - 6 cm in horizontal straight')
    Wave(1).Data = [
        +0.01049061974609; 0.01140933697991;-0.04030875696656; ...
        +0.00000000000000; 0.00000000000000;-0.05502813334686; ...
        +0.01542076460695;-0.01619516668507; 0.00789235914796; ...
        +0.00131257163789; 0.00103749322207;];
    Wave(2).Data = [
        -0.03848844279225;-0.01638239892977;-0.01260762847070; ...
        -0.01719182683414; 0.00000000000000; 0.00000000000000; ...
        -0.00012424401083;-0.00830469993127;-0.00037523106600; ...
        -0.03827790708473;-0.02139034673185;-0.01107856244175; ...
        +0.02111710213345];
elseif strcmpi(LatticeFlag,'Zero Dispersion')
    disp('   Zero dispersion in straights');
    Wave(1).Data = [
        +0.01157297379474;+0.01119306834886;-0.03365503399306; ...
        -0.00000000000000;+0.00000000000000;-0.04751476955472; ...
        +0.01514092010687;-0.01597486848438;+0.01029755374564; ...
        +0.00138907222726;+0.00107982276350;];
    Wave(2).Data = [
        -0.03612300082450;-0.01532848704077;-0.01198859969586; ...
        -0.01717691979496;-0.00000000000000;-0.00000000000000; ...
        -0.00012471625950;-0.00945953402402;-0.00032774806922; ...
        -0.03708187010264;-0.02488363394460;-0.01066978009210; ...
        +0.01884052079746];
else
    error('Lattice for the dispersion wave unknown (Flag=%s)', LatticeFlag);
end

Total = Wave;  % Just for fields

for i = 1:2
    Wave(i).Data = -1 * Factor_Wave * Wave(i).Data;
    Bump(i).Data = -1 * Factor_Bump * Bump(i).Data;
    Total(i).Data = Wave(i).Data + Bump(i).Data;
end

if strcmpi(UnitsFlag, 'Hardware')
    Wave  = physics2hw(Wave);
    Bump  = physics2hw(Bump);
    Total = physics2hw(Total);
end

