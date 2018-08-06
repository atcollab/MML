function [LinData, varargout] = linopt2(RING,DP,varargin)
%LINOPT2 - Performs linear analysis of the coupled lattice
%   [1] D.Edwars,L.Teng IEEE Trans.Nucl.Sci. NS-20, No.3, p.885-888, 1973
%   [2] E.Courant, H.Snyder
%   [3] D.Sagan, D.Rubin Phys.Rev.Spec.Top.-Accelerators and beams, vol.2 (1999)
%   Notation is the same as in [3]
%
% LinData = LINOPT(THERING,DP,REFPTS) is a MATLAB structure array with fields
%       .RingPos   - ordinal position in the RING 
%       .SPos      - longitudinal position [m]
%       .COPos     - closed orbit column vector with 
%                    components x, px, y, py (momentum, NOT angles)						
%       .DOpos     - dispersion orbit position vector with 
%                    components eta_x, eta_prime_x, eta_y, eta_prime_y
%                    calculated with respect to the closed orbit with 
%                    momentum deviation DP
%       .M44       - 4x4 one-turn transfer matrix M at each element for specified DP [2]
%       .A         - 2x2 matrix A in [3]
%       .B         - 2x2 matrix B in [3]
%       .C         - 2x2 matrix C in [3]			
%       .gamma     - gamma parameter of the transformation to eigenmodes 
%   ???    .nu        - [ phasex, phasey] vector
%       .beta      - [betax, betay] vector
%       .alfa      - [alfax, alfay] vector
%       .phi       - [phix, phiy] vector
%
% NOTE: All values are specified at the entrance of each element indexed in REFPTS array. 
%       REFPTS is an array of increasing indexes in the range 1 to length(LINE)+1. 
%       For further explanation of REFPTS use >> help FINDSPOS 
%
% Calling options
% [LinData,NU] = LINOPT() returns a vector of linear tunes
%       [nu_u , nu_v] for two normal modes of linear motion [1] 
%
% [LinData,NU, KSI] = LINOPT() returns a vector of normalized chromaticities
%       [ksi_u , ksi_v] - derivatives of [nu_u , nu_v] w.r.t. momentum
%
%  future: include dispersion calculation
%          include chromaticity calculation
%          linear stability check of Tr(M44)
%===============================================================================
%Twiss calculation from one-turn transfer matrix at location 's' (AIP 184 p. 50)
%                  M(s) =      (M11 M12)
%                              (M21 M22)
%  M = A (horizontal) or B (vertical)
%  M11: cos(2*pi*nu) + alfa*sin(2*pi*nu)
%  M12: beta*sin(2*pi*nu)
%  M21: -(1+alfa^2)*sin(2*pi*nu)/beta
%  M22: cos(2*pi*nu)-alfa*sin(2*pi*nu)
%  beta=M12/sin(2*pi*nu);
%  alfa=(M11-M22)/(2*sin(2*pi*nu));
%  gamma=-M21/sin(2*pi*nu);

if(nargin==2)                  %...ring and momentum deviation (no REFPTS)
   REFPTS= 1;
else
   REFPTS=varargin{1};
end

NR = length(REFPTS);
spos = findspos(RING,REFPTS);

%M44=one-turn 4x4 matrix at each element
%MS =4x4 transfer matrix from start to each element
%orb=6-d closed orbit (findorbit4)
[M44, MS, orb] = findm44(RING,DP,REFPTS);

LinData = struct('RingPos',num2cell(REFPTS),'SPos',num2cell(spos),...
    'COPos',num2cell(orb,1),'M44',squeeze(num2cell(MS,[1 2]))');

% Calculate A,B,C, gamma at the first element
M = M44(1:2,1:2);
N = M44(3:4,3:4);
m = M44(1:2,3:4);
n = M44(3:4,1:2);

% 2-by-2 symplectic matrix
S = [0 1; -1 0];
H = m + S*n'*S';
t = trace(M-N);

g = sqrt(1 + sqrt(t*t/(t*t+4*det(H))))/sqrt(2);
G = diag([g g]);
C = -H*sign(t)/(g*sqrt(t*t+4*det(H)));
A = G*G*M  -  G*(m*S*C'*S' + C*n) + C*N*S*C'*S';
B = G*G*N  +  G*(S*C'*S'*m + n*C) + S*C'*S'*M*C;

%compute A,B,C,g,beta,alfa at first element
if REFPTS(1)==1 && NR>1
    START = 2;
    LinData(1).A=A;
    LinData(1).B=B;
    LinData(1).C=C;
    LinData(1).gamma=g;
    LinData(1).beta(1) = A(1,2)/sin(acos(trace(A/2)));
    LinData(1).beta(2) = B(1,2)/sin(acos(trace(B/2)));
    LinData(1).alfa(1) = (A(1,1)-A(2,2))/(2*sin(acos(trace(A/2))));
    LinData(1).alfa(2) = (B(1,1)-B(2,2))/(2*sin(acos(trace(B/2))));
else
    START = 1;
end

%compute matrixes in all elements indexed by REFPTS
for i=START:NR
    M12 =LinData(i).M44(1:2,1:2);    %...one turn maps
    N12 =LinData(i).M44(3:4,3:4);
    m12 =LinData(i).M44(1:2,3:4);
    n12 =LinData(i).M44(3:4,1:2);
   
    g2 = sqrt(det(n12*C+G*N12));     %...coupling matrices
    E12 = (G*M12-m12*S*C'*S')/g2;
    F12 = (n12*C+G*N12)/g2;
    LinData(i).gamma=g2;
    LinData(i).C=(M12*C+G*m12)*S*F12'*S';
    
    LinData(i).A=E12*A*S*E12'*S';    %...coupled transfer matrices
    LinData(i).B=F12*B*S*F12'*S';
    
                                     %...Twiss parameters
    LinData(i).beta(1) = LinData(i).A(1,2)/sin(acos(trace(A/2)));
    LinData(i).beta(2) = LinData(i).B(1,2)/sin(acos(trace(B/2)));
    LinData(i).alfa(1) = (LinData(i).A(1,1)-LinData(i).A(2,2))/(2*sin(acos(trace(A/2))));
    LinData(i).alfa(2) = (LinData(i).B(1,1)-LinData(i).B(2,2))/(2*sin(acos(trace(B/2))));
                                     %...Phase
end

if nargout > 1            %...output tunes
   varargout{1} = acos([trace(A/2); trace(B/2)])/(2*pi);
end

if nargout == 3           %...output chromaticity
    global NUMDIFPARAMS

    if isfield(NUMDIFPARAMS,'DPStep')
        dDP = NUMDIFPARAMS.DPStep';
    else
        dDP =  1e-9;
    end
    % Calculate tunes for DP+dDP
    [LD, TUNES] = linopt2(RING,DP+dDP,1);
    varargout{2} = (TUNES - varargout{1}) ./ (varargout{1})/dDP;
end