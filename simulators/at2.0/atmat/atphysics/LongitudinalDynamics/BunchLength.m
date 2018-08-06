function BL = BunchLength (Ib,Zn,Vrf,U0,E0,h,alpha,sigdelta,circ)

% bunch length due to the potential well effect
% the output is the zerocurrent bunch length x bunch lengthening
%
%   BL = BunchLength (Ib,Zn,Vrf,U0,E0,h,alpha,sigdelta,circ)
%
% Ib is the bunch current [A] (it may be a vector for multiple values)
% Zn is the longitudinal broadband impedance [Ohms]
% Vrf is the RF voltage [V] (it may be a vector for multiple values)
% U0 is the energy loss around the ring [eV]
% E0 is the beam energy [eV]
% h is the harmonic number
% alpha is the momentum compaction factor
% sigmadelta is the energy spread
% circ is the ring circumference
% 
%   see also: atBunchLength

blg = abs(blgrowth(Ib,Zn,Vrf,U0,E0,h,alpha,sigdelta));
phi=pi - asin(U0./Vrf);
nus= sqrt(-(Vrf/E0).*(h * alpha)/(2*pi) .* cos(phi));
zcBL = sigdelta.*(circ * alpha)./(2 * pi .* nus );
BL = zcBL .* blg;
end

function blg = blgrowth(Ib,Zn,Vrf,U0,E0,h,alpha,sigdelta)
% bunch lengthening factor due to the potential well effect

% Ib is the bunch current [A] (it may be a vector for multiple values)
% Zn is the longitudinal broadband impedance [Ohms]
% Vrf is the RF voltage [V] (it may be a vector for multiple values)
% U0 is the energy loss around the ring [eV]
% h is the harmonic number
% alpha is the momentum compaction factor
% sigmadelta is the energy spread

phi=pi - asin(U0./Vrf);
nus= sqrt(-(Vrf/E0).*(h * alpha)/(2*pi) .* cos(phi));

Delta = -(2*pi*Ib*Zn)./(Vrf*h.*cos(phi).*(alpha*sigdelta./nus).^3);
Q=Delta/(4*sqrt(pi));



blg = (2/3)^(1/3)./(9*Q + sqrt(3)*sqrt(-4+27*Q.^2)).^(1/3)...
    + (9*Q + sqrt(3)*sqrt(-4+27*Q.^2)).^(1/3)./(2^(1/3)*3^(2/3));
end

