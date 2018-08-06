function [model, model_length] = sirius_bo_b_segmented_model(famname, passmethod, strength)

types = {};
b      = 1; types{end+1} = struct('fam_name', famname, 'passmethod', passmethod);
b_edge = 2; types{end+1} = struct('fam_name', 'b_edge', 'passmethod', 'IdentityPass');
b_pb   = 3; types{end+1} = struct('fam_name', 'pb', 'passmethod', 'IdentityPass');

% dipole model 2016-02-11
% =======================
% this model is based on tentative model6 in which dipole was broken into 2
% segments.
%--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m],[T] for polynom_b ---
monomials = [0,1,2,3,4,5,6];
segmodel = [ ...
%type len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)   
 b,      0.005  ,  +0.01479 ,  +0.00e+00 ,  -4.60e-02 ,  -1.93e+00 ,  -3.63e+01 ,  -1.14e+03 ,  -7.72e+03 ,  -9.13e+04 ; 
 b,      0.010  ,  +0.03221 ,  +0.00e+00 ,  -5.63e-02 ,  -1.88e+00 ,  -3.49e+01 ,  -1.12e+03 ,  -1.16e+04 ,  -2.17e+05 ;
 b,      0.010  ,  +0.04110 ,  +0.00e+00 ,  -1.10e-01 ,  -1.91e+00 ,  -2.77e+01 ,  -9.29e+02 ,  -1.71e+04 ,  -4.86e+05 ;
 b,      0.010  ,  +0.05326 ,  +0.00e+00 ,  -2.07e-01 ,  -2.12e+00 ,  -1.46e+01 ,  -6.06e+02 ,  -2.26e+04 ,  -5.43e+05 ;
 b,      0.010  ,  +0.05898 ,  +0.00e+00 ,  -2.38e-01 ,  -2.13e+00 ,  -8.71e+00 ,  -4.19e+02 ,  -2.38e+04 ,  -7.26e+05 ;
 b,      0.151  ,  +0.90919 ,  +0.00e+00 ,  -2.32e-01 ,  -2.02e+00 ,  -6.42e+00 ,  -3.11e+02 ,  -2.06e+04 ,  -7.58e+05 ;
 b,      0.192  ,  +1.16505 ,  +0.00e+00 ,  -2.17e-01 ,  -1.97e+00 ,  -3.75e+00 ,  -1.32e+02 ,  -7.88e+03 ,  -4.83e+05 ;
 b,      0.182  ,  +1.11787 ,  +0.00e+00 ,  -1.91e-01 ,  -1.94e+00 ,  +6.04e-02 ,  -1.74e+02 ,  +3.01e+03 ,  -9.96e+04 ;
 b,      0.010  ,  +0.05251 ,  +0.00e+00 ,  -2.67e-01 ,  -1.78e+00 ,  +1.21e+01 ,  -1.47e+02 ,  +1.20e+04 ,  -1.36e+06 ;
 b_edge, 0,0,0,0,0,0,0,0,0
 b,      0.010  ,  +0.03789 ,  +0.00e+00 ,  -1.88e-01 ,  -1.16e+00 ,  +2.01e+01 ,  -7.30e+02 ,  +1.66e+04 ,  -9.00e+05 ;
 b,      0.013  ,  +0.03363 ,  +0.00e+00 ,  -6.96e-02 ,  -1.70e+00 ,  +2.60e+01 ,  -9.34e+02 ,  +1.13e+04 ,  -2.45e+05 ;
 b,      0.017  ,  +0.02979 ,  +0.00e+00 ,  -1.17e-02 ,  -2.04e+00 ,  +2.07e+01 ,  -5.69e+02 ,  +1.58e+03 ,  +1.21e+04 ;
 b,      0.020  ,  +0.02286 ,  +0.00e+00 ,  +8.60e-03 ,  -1.82e+00 ,  +1.01e+01 ,  -1.89e+02 ,  -1.45e+03 ,  +4.21e+04 ;
 b,      0.030  ,  +0.01869 ,  +0.00e+00 ,  +1.08e-02 ,  -1.20e+00 ,  +2.99e+00 ,  -1.59e+01 ,  -9.06e+02 ,  +1.35e+04 ;
 b,      0.050  ,  +0.01218 ,  +5.49e-04*0, +5.03e-03 ,  -4.53e-01 ,  +1.59e-01 ,  +1.70e+01 ,  -1.65e+02 ,  +7.19e+02 ; 
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
mb = marker('mb', 'IdentityPass');
model = [fliplr(b), mb, b];



