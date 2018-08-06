function [NaturalEmittance] = calcemittance
%CALCEMITTANCE - Calculates the natural emittance of the AT model
%  NaturalEmittance = calcemittance
%

global THERING

sum.e0 = getenergy('Model');
sum.circumference = findspos(THERING, length(THERING)+1);
sum.revTime = sum.circumference / 2.99792458e8;
sum.revFreq = 2.99792458e8 / sum.circumference;
sum.gamma = sum.e0 / 0.51099906e-3;
sum.beta = sqrt(1 - 1/sum.gamma);

[TD, sum.tunes, sum.chromaticity] = twissring(THERING, 0, 1:length(THERING)+1, 'chrom', 1e-8);

% For calculating the synchrotron integrals
temp  = cat(2,TD.Dispersion);
D_x   = temp(1,:)';
D_x_  = temp(2,:)';
beta  = cat(1, TD.beta);
alpha = cat(1, TD.alpha);
gamma = (1 + alpha.^2) ./ beta;
circ  = TD(length(THERING)+1).SPos;


% Synchrotron integral calculation
sum.integrals = [0.0 0.0 0.0 0.0 0.0 0.0];

for i = 1:length(THERING),
    if isfield(THERING{i}, 'BendingAngle') && isfield(THERING{i}, 'EntranceAngle')
        rho = THERING{i}.Length/THERING{i}.BendingAngle;
        dispersion = 0.5*(D_x(i)+D_x(i+1));
        sum.integrals(1) = sum.integrals(1) + dispersion*THERING{i}.Length/rho;
        sum.integrals(2) = sum.integrals(2) + THERING{i}.Length/(rho^2);
        sum.integrals(3) = sum.integrals(3) + THERING{i}.Length/(rho^3);
        % For general wedge magnets
        sum.integrals(4) = sum.integrals(4) + ...
            D_x(i)*tan(THERING{i}.EntranceAngle)/rho^2 + ...
            (1 + 2*rho^2*THERING{i}.PolynomB(2))*(D_x(i)+D_x(i+1))*THERING{i}.Length/(2*rho^3) + ...
            D_x(i+1)*tan(THERING{i}.ExitAngle)/rho^2;
        %         sum.integrals(4) = sum.integrals(4) + 2*0.5*(D_x(i)+D_x(i+1))*THERING{i}.Length/rho^3;
        H1 = beta(i,1)*D_x_(i)*D_x_(i)+2*alpha(i)*D_x(i)*D_x_(i)+gamma(i)*D_x(i)*D_x(i);
        H0 = beta(i+1,1)*D_x_(i+1)*D_x_(i+1)+2*alpha(i+1)*D_x(i+1)*D_x_(i+1)+gamma(i+1)*D_x(i+1)*D_x(i+1);
        sum.integrals(5) = sum.integrals(5) + THERING{i}.Length*(H1+H0)*0.5/(rho^3);
        %         if H1+H0 < 0
        %             fprintf('%f %i %s\n', H1+H0, i, THERING{i}.FamName)
        %         end
        sum.integrals(6) = sum.integrals(6) + THERING{i}.PolynomB(2)^2*dispersion^2*THERING{i}.Length;
    end
end

% Damping numbers
% Use Robinson's Theorem
sum.damping(1) = 1 - sum.integrals(4)/sum.integrals(2);
sum.damping(2) = 1;
sum.damping(3) = 2 + sum.integrals(4)/sum.integrals(2);

sum.radiation = 8.846e-5*sum.e0.^4*sum.integrals(2)/(2*pi);
sum.naturalEnergySpread = sqrt(3.8319e-13*sum.gamma.^2*sum.integrals(3)/(2*sum.integrals(2) + sum.integrals(4)));
sum.naturalEmittance = 3.8319e-13*(sum.e0*1e3/0.510999).^2*sum.integrals(5)/(sum.damping(1)*sum.integrals(2));

% Damping times
sum.radiationDamping(1) = 1/(2113.1*sum.e0.^3*sum.integrals(2)*sum.damping(1)/circ);
sum.radiationDamping(2) = 1/(2113.1*sum.e0.^3*sum.integrals(2)*sum.damping(2)/circ);
sum.radiationDamping(3) = 1/(2113.1*sum.e0.^3*sum.integrals(2)*sum.damping(3)/circ);


NaturalEmittance = sum.naturalEmittance;

