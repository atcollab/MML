%% In Tracy or AT for rotation, the beam is rotated and not the element
% This is not equivalent to rotating elements
% For zero closed orbit, there is no effect on closed orbit of
% 1. rotation around s-axis
%   One way is just to rotate the element ie the component of the multipole
%   But special attention has to be watch for 2n poles
% 2. s-displacement --> in reality it is equivalent to a orbit kick

global THERING;

ATind = atindex(THERING);

% Dipoles 
sigmaDs = 500e-6; % meter
sigmaDx = 500e-6; % meter
sigmaDz = 000e-6; % meter
sigmaRs = 200e-6; % meter

Index = ATind.BEND;

sigmaDx = sigmaDx*randn(size(Index));
sigmaDz = sigmaDz*randn(size(Index));
sigmaDs = sigmaDs*randn(size(Index));
sigmaRs = sigmaRs*randn(size(Index));

mvelem(Index,sigmaDs);
setshift(Index, sigmaDx, sigmaDz);

%settilt(Index, sigmaRs);
% Rotation of the dipole fields
Theta = THERING{Index(1)}.BendingAngle*/getbrho;

% for ik = 1:length(Index)
%     THERING{Index(ik)}.PolynomeA(1) = sin(sigmaRs(ik))*
% end

% Quadrupoles

sigmaDx = 100e-6; % meter
sigmaDz = 100e-6; % meter

Index = [ATind.Q1, ATind.Q2, ATind.Q3, ATind.Q4, ATind.Q5 ...
         ATind.Q6, ATind.Q7, ATind.Q8, ATind.Q9, ATind.Q10];

sigmaDx = sigmaDx*randn(size(Index));
sigmaDz = sigmaDz*randn(size(Index));

      
setshift(Index, sigmaDx, sigmaDz);

% Sextupoles