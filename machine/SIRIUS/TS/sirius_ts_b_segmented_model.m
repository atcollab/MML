function [model, model_length] = sirius_ts_b_segmented_model(energy, famname, passmethod)

types = {};
b      = 1; types{end+1} = struct('fam_name', famname, 'passmethod', passmethod);
b_edge = 2; types{end+1} = struct('fam_name', 'edgeB', 'passmethod', 'IdentityPass');
b_pb   = 3; types{end+1} = struct('fam_name', 'physB', 'passmethod', 'IdentityPass');


% dipole model 2017-08-31
% =======================
% filename: 2017-08-31_TS_Dipole_Model01_Sim_X=-85_85mm_Z=-1000_1000mm_Imc=680.1A.txt
monomials = [0,1,2,3,4,5,6];
segmodel = [ ...
 %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
 %type   len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
 b,      0.1960 ,  +0.80828 ,  +0.00e+00 ,  -1.51e-01 ,  -1.35e+00 ,  -2.92e+00 ,  -1.08e+02 ,  -7.71e+03 ,  -3.84e+05 ; 
 b,      0.1920 ,  +0.79616 ,  +0.00e+00 ,  -1.44e-01 ,  -1.33e+00 ,  -2.08e+00 ,  -6.62e+01 ,  -2.56e+03 ,  -2.65e+05 ; 
 b,      0.1820 ,  +0.76057 ,  +0.00e+00 ,  -1.32e-01 ,  -1.32e+00 ,  -3.07e-01 ,  -1.16e+02 ,  +1.88e+03 ,  -5.06e+04 ; 
 b,      0.0100 ,  +0.03538 ,  +0.00e+00 ,  -1.58e-01 ,  -1.14e+00 ,  +7.26e+00 ,  -3.87e+02 ,  +2.90e+03 ,  -7.20e+04 ; 
 b,      0.0100 ,  +0.02550 ,  +0.00e+00 ,  -9.99e-02 ,  -8.58e-01 ,  +1.05e+01 ,  -5.61e+02 ,  +7.09e+03 ,  -2.19e+05 ; 
 b_edge, 0,0,0,0,0,0,0,0,0
 b,      0.0130 ,  +0.02274 ,  +0.00e+00 ,  -3.60e-02 ,  -1.10e+00 ,  +1.26e+01 ,  -5.85e+02 ,  +5.36e+03 ,  -1.09e+05 ; 
 b,      0.0170 ,  +0.02020 ,  +0.00e+00 ,  -7.26e-03 ,  -1.24e+00 ,  +1.01e+01 ,  -3.70e+02 ,  +8.45e+02 ,  +4.57e+03 ; 
 b,      0.0200 ,  +0.01552 ,  +0.00e+00 ,  +1.59e-03 ,  -1.04e+00 ,  +5.18e+00 ,  -1.41e+02 ,  -4.95e+02 ,  +2.08e+04 ; 
 b,      0.0300 ,  +0.01276 ,  +0.00e+00 ,  +1.91e-03 ,  -6.16e-01 ,  +1.94e+00 ,  -3.42e+01 ,  -2.37e+02 ,  +6.99e+03 ; 
 b,      0.0500 ,  +0.00866 ,  +3.43e-05 ,  +1.04e-03 ,  -2.43e-01 ,  +3.98e-01 ,  -1.23e+00 ,  -5.04e+01 ,  +1.05e+03 ; 
 b_pb,   0,0,0,0,0,0,0,0,0
];

% converts deflection angle from degress to radians
segmodel(:,3) = segmodel(:,3) * (pi/180.0);

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
