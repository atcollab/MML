function sum = ALBAsummary(print)
% ATSUMMARY will print out the paramters of the lattice currently loaded
% in AT. The parameters that come after the Synchrotron Integrals are
% parameters that depend on the Integrals themselves. The equations to
% calculate them were taken from [1].
%
% [1] Alexander Wu Chao and Maury Tigner, Handbook of Accelerator Physics
% and Engineering (World Scientific, Singapore, 1998), pp. 183-187. (or
% 187-190 in ed. 2)
%
% Written by Eugene Tan 

if nargin == 0 
    print = true ;
end
global THERING GLOBVAL 

% if exist('sum','var')
%     clear global sum;
%     global sum;
% end

% Structure to store info
sum.e0 = GLOBVAL.E0*1e-9;
sum.circumference = findspos(THERING, length(THERING)+1);
sum.revTime = sum.circumference / 2.99792458e8;
sum.revFreq = 2.99792458e8 / sum.circumference;
sum.gamma = sum.e0 / 0.51099906e-3;
sum.beta = sqrt(1 - 1/sum.gamma);
[TD sum.tunes sum.chromaticity] = twissring(THERING, 0, 1:length(THERING)+1, 'chrom', 1e-8);
sum.compactionFactor = mcf(THERING);

% For calculating the synchrotron interals
temp = cat(2,TD.Dispersion);
D_x = temp(1,:)';
D_x_= temp(2,:)';
beta = cat(1, TD.beta);
alpha = cat(1, TD.alpha);
gamma = (1 + alpha.^2) ./ beta;
circ = TD(length(THERING)+1).SPos;

sum.integrals = [0.0 0.0 0.0 0.0 0.0 0.0];
for i=1:length(THERING)
    if isfield(THERING{i}, 'BendingAngle')
        rho = THERING{i}.Length/THERING{i}.BendingAngle;
        dispersion = 0.5*(D_x(i)+D_x(i+1));
        sum.integrals(2) = sum.integrals(2) + THERING{i}.Length/(rho^2);
         % For general wedge magnets
        sum.integrals(4) = sum.integrals(4) + ...
            D_x(i)*tan(THERING{i}.EntranceAngle)/rho^2 + ...
            (1 + 2*rho^2*THERING{i}.PolynomB(2))*(D_x(i)+D_x(i+1))*THERING{i}.Length/(2*rho^3) + ...
            D_x(i+1)*tan(THERING{i}.ExitAngle)/rho^2;
        %         sum.integrals(4) = sum.integrals(4) + 2*0.5*(D_x(i)+D_x(i+1))*THERING{i}.Length/rho^3;
        H1 = beta(i,1)*D_x_(i)*D_x_(i)+2*alpha(i)*D_x(i)*D_x_(i)+gamma(i)*D_x(i)*D_x(i);
        H0 = beta(i+1,1)*D_x_(i+1)*D_x_(i+1)+2*alpha(i+1)*D_x(i+1)*D_x_(i+1)+gamma(i+1)*D_x(i+1)*D_x(i+1);
        sum.integrals(5) = sum.integrals(5) + THERING{i}.Length*(H1+H0)*0.5/(rho^3);
        
    end
end

sum.damping(1) = 1 - sum.integrals(4)/sum.integrals(2);
sum.naturalEmittance = 3.8319e-13*(sum.e0*1e3/0.510999).^2*sum.integrals(5)/(sum.damping(1)*sum.integrals(2));

