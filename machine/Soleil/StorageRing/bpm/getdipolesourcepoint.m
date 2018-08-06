function  [position angle T] = getdipolesourcepoint(varargin)
%GETDIPOLESOURCEPOINT - Computes beam position and angle at the entrance of a dipole
%                       knowing beam position in upstream and downstream BPMs
%
%  INPUTS
%  1. BeamLine - 'ODE', 'DIFFABS', 'SAMBA'
%  FLAGS
%  'Physics', 'Hardware'
%  'DISPLAY'
%
%  OUTPUTS
%  1. position - H and V beam position in mm {Default} at Dipole entrace
%  2. angle - H and V beam divergence in mrad {Default} at dipole entrace
%  3. T - matrix for computing position and angle
%
%  ALGORITHM
%  Use transfert matrix formalism
%  indices : 1 upstream BPM, 2 downstream BPM
%            (x,x') wanted quantities
%  x   = R11*x1 + R12*x1'
%  x'  = R21*x1 + R22*x1'
%  x2  = U11*x  + R12*x'
%  x2' = U21*x  + R22*x'
%
%
%  NOTES
%  1. Results depends on the corrector strength in between the BPMs and the dipole
%     Firsts existimation shows this can be neglected as a first guess
%  2. Results are expressed at the entrance of the dipole (as a reference) and not
%     at exactly the photon exit port.
%

%
%  Written by Laurent S. Nadolski

UnitsFlag = 'Hardware';
DisplayFlag = 0;
BeamLine = {};
TableFlag = 0;

if isempty(varargin)
    BeamLine = {'ODE', 'SAMBA', 'DIFFABS'}
end

for i = length(varargin):-1:1
    if iscell(varargin{i})
        BeamLine =  varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        UnitsFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Table')
        TableFlag = 1;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'ODE', 'DIFFABS', 'SAMBA'}))
        BeamLine =  [BeamLine, varargin{i}];
        varargin(i) = [];
    elseif strcmpi(varargin{i}, 'All')
        BeamLine =  {'ODE', 'SAMBA', 'DIFFABS'};
        varargin(i) = [];
    end
end

global THERING

%%
% ODE     second dipole of cell 01 exit port 1°
% SAMBA   second dipole of cell 09 exit port 1°
% DIFFABS second dipole of cell 13 exit port 1°

% Dipole
DipoleAtindex = family2atindex('BEND');

for k1 = 1: length(BeamLine),
    switch BeamLine{k1}
        case 'ODE'
            BPMDeviceList = [1 6; 1 7];
            PortIdx = DipoleAtindex(2);
        case 'SAMBA'
            BPMDeviceList = [9 6; 9 7];
            PortIdx = DipoleAtindex(18);
        case 'DIFFABS'
            BPMDeviceList = [13 6; 13 7];
            PortIdx = DipoleAtindex(26);
        otherwise
            error('Beamline not known')
    end

    BPMIdx = family2atindex('BPMx', BPMDeviceList);

    % save and zero corrector in the model
    hcm0 = getsp('HCOR', 'Model');
    vcm0 = getsp('VCOR', 'Model');

    setsp('HCOR', 0, 'Model');
    setsp('VCOR', 0, 'Model');

    % Computes Transfer matrix between first BPM and exit port
    M44full = eye(4);
    for k = BPMIdx(1):PortIdx-1,
        R = findelemm44(THERING{k},THERING{k}.PassMethod,[0 0 0 0 0 0]');
        M44full = R*M44full;
    end
    R = M44full;

    % Computes Transfer matrix between both BPMs
    M44full = eye(4);
    for k = BPMIdx(1):BPMIdx(2),
        U = findelemm44(THERING{k},THERING{k}.PassMethod,[0 0 0 0 0 0]');
        M44full = U*M44full;
    end
    U = M44full;


    % restore corrector in the model
    setsp('HCOR', hcm0, 'Model');
    setsp('VCOR', vcm0, 'Model');

    % Computes Matrix to get position and angle at exit port knowing Position at upstream and downstream BPMs
    T = eye(4);
    T(1,1) = (R(1,1) - R(1,2)*U(1,1)/U(1,2));
    T(3,3) = (R(3,3) - R(3,4)*U(3,3)/U(3,4));
    T(1,2) = R(1,2)/U(1,2);
    T(3,4) = R(3,4)/U(3,4);
    T(2,1) = (R(2,1) - R(2,2)*U(1,1)/U(1,2));
    T(4,3) = (R(4,3) - R(4,4)*U(3,3)/U(3,4));
    T(2,2) = R(2,2)/U(1,2);
    T(4,4) = R(4,4)/U(3,4);

    %
    PosAngle = T*[getam('BPMx', BPMDeviceList,'Physics'); getam('BPMz', BPMDeviceList,'Physics')];

    % convert back to Physics units per defaults
    if ~strcmpi(UnitsFlag,'Physics')
        position(k1, :) = physics2hw('BPMx', 'Monitor', PosAngle([1 3]), BPMDeviceList);
        angle(k1, :)    = physics2hw('BPMx', 'Monitor', PosAngle([2 4]), BPMDeviceList);
    end

    % Tables to put into TANGO
    if TableFlag
        fprintf('%s Tij  %s and %s \n', BeamLine{k1}, cell2mat(family2tango('BPMx',BPMDeviceList(1,:))), cell2mat(family2tango('BPMx',BPMDeviceList(2,:))));
        fprintf('T11 = % f T12 = % f\n',   T(1,1)*1e3, T(1,2)*1e3);
        fprintf('T21 = % f T22 = % f\n',   T(2,1)*1e3, T(2,2)*1e3);
        fprintf('%s Tij  %s and %s \n', BeamLine{k1}, cell2mat(family2tango('BPMz',BPMDeviceList(1,:))), cell2mat(family2tango('BPMz',BPMDeviceList(2,:))));
        fprintf('T33 = % f T34 = % f\n',   T(3,3)*1e3, T(3,4)*1e3);
        fprintf('T43 = % f T44 = % f\n\n', T(4,3)*1e3, T(4,4)*1e3);
    end

    if DisplayFlag
        Orbit1 = findorbit4(THERING, 0, BPMIdx(1));
        Orbit2 = findorbit4(THERING, 0, BPMIdx(2));

        PosAngle = T*[Orbit1(1);  Orbit2(1); Orbit1(3); Orbit2(3)]
        Orbit    = findorbit4(THERING, 0, PortIdx)
    end
end



end

function validate


BPMIdx = family2atindex('BPMx',[1 6; 1 7]);

% get transfer matrix, T, for a given element
% T = findelemm44(THERING{15},THERING{15}.PassMethod,[0 0 0 0 0 0]')

% from BPM to BPM
M44full = eye(4);

for k = BPMIdx(1):BPMIdx(2),
    T = findelemm44(THERING{k},THERING{k}.PassMethod,[0 0 0 0 0 0]');
    M44full = T*M44full;
end

%%
% analytique solution
[betx betz] = modelbeta('BPMx', [1 6; 1 7]);
[alpx alpz] = modeltwiss('alpha', 'BPMx', [1 6; 1 7]);
[phix phiz] = modelphase('BPMx', [1 6; 1 7]);

M44fullana = eye(4);

M44fullana(1,1) =  sqrt(betx(2)/betx(1))*(cos(phix(2)-phix(1)) + alpx(1)*sin(phix(2)-phix(1)));
M44fullana(1,2) =  sqrt(betx(2)*betx(1))*sin(phix(2)-phix(1));
M44fullana(2,1) =  -((1+alpx(1)*alpx(2)) * sin(phix(2)-phix(1)) + (alpx(2) - alpx(1))*cos(phix(2)-phix(1)))/sqrt(betx(2)*betx(1));
M44fullana(2,2) =  (cos(phix(2)-phix(1)) - alpx(2) * sin(phix(2)-phix(1)))/sqrt(betx(2)/betx(1));

M44fullana(3,3) =  sqrt(betz(2)/betz(1))*(cos(phiz(2)-phiz(1)) + alpz(1)*sin(phiz(2)-phiz(1)));
M44fullana(3,4) =  sqrt(betz(2)*betz(1))*sin(phiz(2)-phiz(1));
M44fullana(4,3) =  -((1+alpz(1)*alpz(2)) * sin(phiz(2)-phiz(1)) + (alpz(2) - alpz(1))*cos(phiz(2)-phiz(1)))/sqrt(betz(2)*betz(1));
M44fullana(4,4) =  (cos(phiz(2)-phiz(1)) - alpz(2) * sin(phiz(2)-phiz(1)))/sqrt(betz(2)/betz(1));

det(M44fullana)

%%

M44full
M44fullana

%%
Orbit = findorbit4(THERING, 0, PortIdx)

%%
Orbit = findorbit4(THERING, 0, BPMIdx(1));
R*Orbit(1:4)
Orbit = findorbit4(THERING, 0, PortIdx)

%%
Orbit = findorbit4(THERING, 0, PortIdx);
U*Orbit(1:4)
Orbit = findorbit4(THERING, 0, BPMIdx(2))

%%
Orbit = findorbit4(THERING, 0, BPMIdx(1));
U*R*Orbit(1:4)
Orbit = findorbit4(THERING, 0, BPMIdx(2))

%%
Orbit1 = findorbit4(THERING, 0, BPMIdx(1));
Orbit2 = findorbit4(THERING, 0, BPMIdx(2));
PosAngle = T*[Orbit1(1);  Orbit2(1); Orbit1(3); Orbit2(3)]
Orbit = findorbit4(THERING, 0, PortIdx)
end
