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

% Revision History: Christoph Steier 2012-11-14
%   added optimized dispersion wave to improve beamline 6.0 S/N


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
        % Remove and ignore
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
        '2. Optimized dispersion wave for 6.0 S/N improvement', ...
        '    (Typically the production lattice)', ...
        '3. Low emittance lattice (nux=16.25)', ...
        '    (New production lattice)', ...
        '4. Pseudo-Single Bunch lattice (16.18,9.25)', ...
        '    (After the low emittance upgrade)', ...
        ' ', ...
        'Which Lattice?'}, ...
        sprintf('Mode: %s',getfamilydata('OperationalMode')), ...
        'Distributed Dispersion','Low Emittance','PSB (16.18,9.25)','Distributed Dispersion');
       %'Distributed Dispersion','6.0 S/N','Low Emittance','Distributed Dispersion');  
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


if strcmpi(LatticeFlag,'Distributed Dispersion') | strcmpi(LatticeFlag,'6.0 S/N') | strcmpi(LatticeFlag,'Low Emittance') | strcmpi(LatticeFlag,'PSB (16.18,9.25)')
    if length(varargin) >= 2
        Factor_Bump = varargin{2};
    else
        prompt = {'Enter the factor for local Eta-y bump'};
        def = {'0.0'};
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
Wave(3) = family2datastruct('SQSHF', 'Setpoint', 'Physics');
Bump = Wave;



%%%%%%%%%%%%%%%%%%%%%%%%%
% Local Dispersion Bump %
%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmpi(LatticeFlag,'Low Emittance')
%     %%%% set the skew quad for sector 5 and 6 - solution from Changchun Sun
%     sk_sd1 = 1.209352e-01;
%     sk_sf1 = -2.916228e-01;
%     sk_sf2 = -3.071000e-01;
%     sk_sd2 = -1.459784e-01;
%     
%     %%% Detuned to make it closed for new baseline lattice
%     sk_shf1 = -4.640486e-02*0.6;
%     sk_shf2 = -4.146509e-02*0.6;
%     
%     DispersionBump_K_SQSF = [sk_sf1;sk_sf2;sk_sf2;sk_sf1];
%     DispersionBump_K_SQSD = [sk_sd1;sk_sd2;sk_sd2;sk_sd1];
%     DispersionBump_K_SQSHF = [sk_shf1;sk_shf2;sk_shf2;sk_shf1];
%     
%     List = [5 1; 5 2; 6 1; 6 2];

%%%%%%%%%%%%%%%%% Second iteration of dispersion bump - asymmetric,
%%%%%%%%%%%%%%%%% spanning 3 sectors, using more skews

sk_sd51 = -1.864525e-01;
sk_sf51 = 4.401994e-01;
sk_sf52 = 1.604359e-01;
sk_sd52 = 4.045212e-01;

sk_sd61 =1.572891e-01;
sk_sf61 = 4.401853e-01;
sk_sf62 = 6.767811e-02;
sk_sd62 = -4.536689e-03;

sk_sd71 = -1.573000e-01;
sk_sf71 = 3.070903e-01;
sk_sf72 = -1.848534e-02;

sk_shf51 = 1.100894e-01;
sk_shf52 =3.572487e-02;
sk_shf61 = 5.226307e-02;
sk_shf62 = 2.430147e-02;
sk_shf71 = -2.537396e-02;


    DispersionBump_K_SQSF = [sk_sf51;sk_sf52;sk_sf61;sk_sf62;sk_sf71;sk_sf72];
    DispersionBump_K_SQSD = [sk_sd51;sk_sd52;sk_sd61;sk_sd62;sk_sd71;0];
    DispersionBump_K_SQSHF = [sk_shf51;sk_shf52;sk_shf61;sk_shf62;sk_shf71;0];
    
    List = [5 1; 5 2; 6 1; 6 2; 7 1; 7 2];

    [i, j] = findrowindex(List, Wave(1).DeviceList);
    if ~isempty(j)
        error('SQSF is in the dispersion bump that is not in the present lattice');
    else
        Bump(1).Data = zeros(length(Bump(1).Data),1);
        Bump(1).Data(i) = DispersionBump_K_SQSF;
    end

    [i, j] = findrowindex(List, Wave(2).DeviceList);
    if ~isempty(j)
        error('SQSD is in the dispersion bump that is not in the present lattice');
    else
        Bump(2).Data = zeros(length(Bump(2).Data),1);
        Bump(2).Data(i) = DispersionBump_K_SQSD;
    end

    [i, j] = findrowindex(List, Wave(3).DeviceList);
    if ~isempty(j)
        error('SQSHF is in the dispersion bump that is not in the present lattice');
    else
        Bump(3).Data = zeros(length(Bump(3).Data),1);
        Bump(3).Data(i) = DispersionBump_K_SQSHF;
    end
    
elseif strcmpi(LatticeFlag,'PSB (16.18,9.25)')
%%%%%%%%%%%%%%%%% Second iteration of dispersion bump - asymmetric,
sk_sd51 = -2.515286e-01;
sk_sf51 =  4.401999e-01;
sk_sf52 = 3.070997e-01;
sk_sd52 =  2.161785e-01;

sk_sd61 =3.250935e-02;
sk_sf61 = 4.401996e-01;
sk_sf62 = 1.100999e-01;
sk_sd62 =  -1.181560e-01;

sk_sd71 = -1.572753e-01;
sk_sf71 = 3.070999e-01;
sk_sf72 = -3.308054e-02;

sk_shf51 = 3.902696e-02;
sk_shf52 =-3.124526e-02;
sk_shf61 = -4.340558e-02;
sk_shf62 = -5.773069e-02;
sk_shf71 = -4.328255e-02;

    DispersionBump_K_SQSF = [sk_sf51;sk_sf52;sk_sf61;sk_sf62;sk_sf71;sk_sf72];
    DispersionBump_K_SQSD = [sk_sd51;sk_sd52;sk_sd61;sk_sd62;sk_sd71;0];
    DispersionBump_K_SQSHF = [sk_shf51;sk_shf52;sk_shf61;sk_shf62;sk_shf71;0];
    
    List = [5 1; 5 2; 6 1; 6 2; 7 1; 7 2];

    [i, j] = findrowindex(List, Wave(1).DeviceList);
    if ~isempty(j)
        error('SQSF is in the dispersion bump that is not in the present lattice');
    else
        Bump(1).Data = zeros(length(Bump(1).Data),1);
        Bump(1).Data(i) = DispersionBump_K_SQSF;
    end

    [i, j] = findrowindex(List, Wave(2).DeviceList);
    if ~isempty(j)
        error('SQSD is in the dispersion bump that is not in the present lattice');
    else
        Bump(2).Data = zeros(length(Bump(2).Data),1);
        Bump(2).Data(i) = DispersionBump_K_SQSD;
    end

    [i, j] = findrowindex(List, Wave(3).DeviceList);
    if ~isempty(j)
        error('SQSHF is in the dispersion bump that is not in the present lattice');
    else
        Bump(3).Data = zeros(length(Bump(3).Data),1);
        Bump(3).Data(i) = DispersionBump_K_SQSHF;
    end

else
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
        error('SQSF is in the dispersion bump that is not in the present lattice');
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
    Bump(3).Data = zeros(length(Bump(3).Data),1);    
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% Local Dispersion Wave %
%%%%%%%%%%%%%%%%%%%%%%%%%

% Theoretical k values [m^-2] for the skews as determined with a fit using the accelerator toolbox
if strcmpi(LatticeFlag,'Distributed Dispersion')
    disp('   Distributed dispersion - 6 cm in horizontal straight')
    sqsfwave = [
        +0.01049061974609; 0.01140933697991;-0.04030875696656; ...
        +0.00000000000000; 0.00000000000000;-0.05502813334686; ...
        +0.01542076460695;-0.01619516668507; 0.00789235914796; ...
        +0.00131257163789; 0.00103749322207;];
    sqsdwave = [
        -0.03848844279225;-0.01638239892977;-0.01260762847070; ...
        -0.01719182683414; 0.00000000000000; 0.00000000000000; ...
        -0.00012424401083;-0.00830469993127;-0.00037523106600; ...
        -0.03827790708473;-0.02139034673185;-0.01107856244175; ...
        +0.02111710213345];
elseif strcmpi(LatticeFlag,'Zero Dispersion')
    disp('   Zero dispersion in straights');
    sqsfwave = [
        +0.01157297379474;+0.01119306834886;-0.03365503399306; ...
        -0.00000000000000;+0.00000000000000;-0.04751476955472; ...
        +0.01514092010687;-0.01597486848438;+0.01029755374564; ...
        +0.00138907222726;+0.00107982276350;];
    sqsdwave = [
        -0.03612300082450;-0.01532848704077;-0.01198859969586; ...
        -0.01717691979496;-0.00000000000000;-0.00000000000000; ...
        -0.00012471625950;-0.00945953402402;-0.00032774806922; ...
        -0.03708187010264;-0.02488363394460;-0.01066978009210; ...
        +0.01884052079746];
elseif strcmpi(LatticeFlag,'6.0 S/N')
    disp('   Optimized dispersion wave for higher S/N at 6.0');
    sqsfwave = [
        0.000206956181664;-0.000013093252107;-0.000002557035491; ...
        -0.00000000000000;+0.00000000000000;-0.000285560239814; ...
        -0.000005276527381;-0.001158216296879;-0.000580040783882; ...
        -0.000189833628892;-0.000634886198740];
    sqsdwave = [
        0.028320901627202;-0.071068484610672;-0.000304562720632; ...
        -0.072945784901059;-0.00000000000000;-0.00000000000000; ...
        -0.000699968238554;0.035979090261692;0.000045930605911; ...
        -0.005886519299456;0.031049389577672;-0.000915655150939; ...
        -0.001368206609667];
elseif strcmpi(LatticeFlag,'Low Emittance')
    disp('   Low Emittance Lattice (nux=16.25)');
    sqsfwave = [
         0.0055;0.0094;-0.0519;...
         0;0;-0.0694; ...
         0.0108;0.0060;0.0079;...
         0.0017;0.0010];
    sqsdwave = [
           -0.0432;-0.0050;-0.0206; ...
           0.0033;0;0; ...
           -0.0002;-0.0006;-0.0003; ...
           -0.0440;-0.0139;-0.0251;
           0.0279];

elseif strcmpi(LatticeFlag,'PSB (16.18,9.25)')
    disp('    Pseudo-Single Bunch lattice (16.18,9.25)');
    sqsfwave = [
         0.011551931510401;0.008718270429684;-0.064609652656248;...
         0.000000000000000;0.000000000000000;-0.086146588789963; ...
         0.013892430443615;0.007175231213095;-0.004604402038791;...
        -0.000322128883462;-0.000074961907761];
    sqsdwave = [
        -0.047893045953468;0.000000568684695;-0.027097287733884;
         0.005038477844366;0.000000000000000;0.0000000000000000; ...
        -0.000868037332710;-0.000480472074811;0.000041377168213;...
        -0.041750020228686;-0.013195011491547;-0.029716831057025;...
         0.034081658859358];
       
   
else
    error('Lattice for the dispersion wave unknown (Flag=%s)', LatticeFlag);
end

    SQSFList = [1 1; 3 1; 3 2; 5 1; 5 2; 6 1; 6 2; 7 1; 7 2; 9 1; 11 1];
    SQSDList = [2 1; 3 1; 3 2; 4 1; 5 1; 5 2; 6 1; 6 2; 7 1; 7 2; 8 1; 10 1; 12 1];

    [i, j] = findrowindex(SQSFList, Wave(1).DeviceList);
    if ~isempty(j)
        error('SQSF is in the dispersion wave but is not in the present lattice');
    else
        Wave(1).Data = zeros(length(Wave(1).Data),1);
        Wave(1).Data(i) = sqsfwave;
    end

    [i, j] = findrowindex(SQSDList, Wave(2).DeviceList);
    if ~isempty(j)
        error('SQSD is in the dispersion wave but is not in the present lattice');
    else
        Wave(2).Data = zeros(length(Wave(2).Data),1);
        Wave(2).Data(i) = sqsdwave;
    end

    Wave(3).Data=zeros(length(Wave(3).Data),1);

Total = Wave;  % Just for fields

for i = 1:3
    Wave(i).Data = -1 * Factor_Wave * Wave(i).Data;
    Bump(i).Data = -1 * Factor_Bump * Bump(i).Data;
    Total(i).Data = Wave(i).Data + Bump(i).Data;
end

if strcmpi(UnitsFlag, 'Hardware')
    Wave  = physics2hw(Wave);
    Bump  = physics2hw(Bump);
    Total = physics2hw(Total);
end

