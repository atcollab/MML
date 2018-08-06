function [model, model_length] = sirius_si_q14_segmented_model(fam_name, strength, passmethod)

types = {};
quad   = 1; types{end+1} = struct('fam_name', fam_name, 'passmethod', passmethod);

% Q14 model
% =========
% this (half) model is based on fieldmap
% '2017-02-24_Q14_Model04_Sim_X=-14_14mm_Z=-500_500mm_Imc=146.6A_Itc=10A.txt'
monomials = [1,5,9,13];
segmodel = [ ...
%type  len[m]   angle[deg]  PolyB(n=1)   PolyB(n=5)   PolyB(n=9)   PolyB(n=13)  
quad,  0.0700 , +0.00000 ,  -4.06e+00 ,  +6.38e+04 ,  -1.45e+13 ,  +2.90e+20 ;
];

% % Q14 model 2016-01-04
% % ====================
% % this (half) model is based on fieldmap
% % /home/fac_files/data/sirius/si/magnet_modelling/si-Q14/model3/
% % '11-05-2015 Quadrupolo_Anel_Q14_Modelo 3_-14_14mm_-500_500mm.txt'
% monomials = [1,5,9,13];
% segmodel = [ ...
% %type  len[m]   angle[deg]  PolyB(n=1)   PolyB(n=5)   PolyB(n=9)   PolyB(n=13)  
% quad, 0.070  ,  +0.00000 ,  -4.09e+00 ,  +5.37e+04 ,  -1.47e+13 ,  +2.91e+20 ;
% ];

% hardedge quadrupole strength of the fieldmap
seg_lens = segmodel(:,2);
model_length = 2*sum(seg_lens);
hedge_strength = sum(2*segmodel(:,4) .* seg_lens) / model_length;
rescale_current = strength / hedge_strength; % rescaling current because fieldmap is usually generated with maximum current, not nominal value.

% builds the magnet model (supposing 1 segment model - current
% lattice_error scripts cannot deal with segmented quadrupole models)
i = 1;
maxorder = 1+max(monomials);
PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
PolyB(monomials+1) = segmodel(i,4:end) * rescale_current; 
type = types{segmodel(i,1)};
model = quadrupole_sirius(type.fam_name, 2*segmodel(i,2), PolyA, PolyB, passmethod);

