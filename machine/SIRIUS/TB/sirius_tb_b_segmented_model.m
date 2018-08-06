function [model, model_length] = sirius_tb_b_segmented_model(energy, famname, passmethod, sign)

types = {};
b      = 1; types{end+1} = struct('fam_name', famname, 'passmethod', passmethod);
b_edge = 2; types{end+1} = struct('fam_name', 'edgeB', 'passmethod', 'IdentityPass');
b_pb   = 3; types{end+1} = struct('fam_name', 'physB', 'passmethod', 'IdentityPass');

% FIELDMAP
% trajectory centered in good-field region. init_rx is set to +9.045 mm
% *** interpolation of fields is now cubic ***
% *** dipole angles were normalized to better close 360 degrees ***
% *** more refined segmented model.
% *** dipole angle is now in units of degrees
%--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m],[T] for polynom_b ---
monomials = [0,1,2,3,4,5,6];


% dipole model 2017-08-25 (150MeV)
% ================================
% filename: 2017-08-25_TB_Dipole_Model02_Sim_X=-85_85mm_Z=-500_500mm.txt
segmodel = [ ...
 %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
 %type   len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
 b,      0.0800 ,  +3.97053 ,  +0.00e+00 ,  -1.38e-04 ,  +8.83e-03 ,  -1.75e-01 ,  +5.64e+01 ,  +5.21e+03 ,  -8.50e+05 ; 
 b,      0.0200 ,  +0.99101 ,  +0.00e+00 ,  -2.06e-02 ,  -1.98e-01 ,  -2.13e+00 ,  -6.78e+00 ,  +2.46e+04 ,  -1.64e+06 ; 
 b,      0.0200 ,  +0.94099 ,  +0.00e+00 ,  -6.34e-01 ,  -4.53e+00 ,  -5.76e+00 ,  -1.49e+03 ,  +2.90e+04 ,  -1.26e+06 ; 
 b,      0.0200 ,  +0.64345 ,  +0.00e+00 ,  -1.56e+00 ,  -7.53e+00 ,  +1.22e+02 ,  -6.92e+03 ,  +9.34e+04 ,  -2.64e+06 ; 
 b_edge, 0,0,0,0,0,0,0,0,0
 b,      0.0200 ,  +0.37798 ,  +0.00e+00 ,  -6.24e-01 ,  -1.60e+01 ,  +2.07e+02 ,  -6.87e+03 ,  +5.18e+04 ,  -6.33e+05 ; 
 b,      0.0200 ,  +0.23850 ,  +0.00e+00 ,  -2.17e-01 ,  -1.62e+01 ,  +1.43e+02 ,  -2.70e+03 ,  -3.65e+03 ,  +3.69e+05 ; 
 b,      0.0300 ,  +0.19919 ,  +0.00e+00 ,  -9.09e-02 ,  -1.04e+01 ,  +6.57e+01 ,  -6.03e+02 ,  -5.99e+03 ,  +1.53e+05 ; 
 b,      0.0300 ,  +0.13835 ,  -3.06e-04 ,  -5.07e-02 ,  -7.02e+00 ,  +3.11e+01 ,  -4.04e+01 ,  -2.97e+03 ,  +4.56e+04 ; 
 b_pb,   0,0,0,0,0,0,0,0,0
];

% converts deflection angle from degress to radians and sets correct positive or negative sign
segmodel(:,3) = sign * segmodel(:,3) * (pi/180.0);

% inverts odd-order polynomB, if sign=-1 (for the negative dipole)
if sign ~= 1
    for i=1:length(monomials)
        segmodel(:,3+i) = segmodel(:,3+i) * sign ^ monomials(i);
    end
end

% turns deflection angle error off (convenient for having a nominal model with zero 4d closed orbit)
segmodel(:,4) = 0;

% builds half of the magnet model
b = zeros(1,size(segmodel,1));
maxorder = 1+max(monomials);
for i=1:size(segmodel,1)
    type = types{segmodel(i,1)};
    if strcmpi(type.passmethod, 'IdentityPass')
        b(i) = marker(type.fam_name, 'IdentityPass');
    else
        PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
        PolyB(monomials+1) = segmodel(i,4:end);
        b(i) = rbend_sirius(type.fam_name, segmodel(i,2), segmodel(i,3), 0, 0, 0, 0, 0, PolyA, PolyB, passmethod);
    end
end

% builds entire magnet model, inserting additional markers
model_length = 2*sum(segmodel(:,2));
mb = marker('mB', 'IdentityPass');
model = [fliplr(b), mb, b];
