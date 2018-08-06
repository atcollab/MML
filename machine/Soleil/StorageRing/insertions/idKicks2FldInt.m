function [i1, i2] = idKicks2FldInt(vKicks, x_or_z_pos, idLen, idKickOfst, elecEn_GeV)

m = 9.10953447E-31; % Mass of electron in kg
e = 1.602189246E-19; % Charge of electron in Coulomb
c = 2.99792458E+08; % Speed of light in m/s

gam = elecEn_GeV/(0.511e-03);

cf = 10000.*m*c*gam/e; % To obtain results in [G*m], [G*m^2]
if strcmp(x_or_z_pos, 'z') ~= 0
    cf = -cf;
end

i1 = cf*(vKicks(1) + vKicks(2));

distBwKicks = idLen - 2*idKickOfst;
i2 = 0.5*cf*((idLen + distBwKicks)*vKicks(1) + (idLen - distBwKicks)*vKicks(2));

