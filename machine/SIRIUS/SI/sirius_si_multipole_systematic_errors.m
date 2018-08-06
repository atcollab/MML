function the_ring = sirius_si_multipole_systematic_errors(the_ring,fam_data)

% multipole order convention: n=0(dipole), n=1(quadrupole), and so on. 
   
% ---- current model of sextupoles ---

% SEXTUPOLES COILS
% ================
fams = {'SN'};
r0         = 12/1000;
% systematic multipoles from '2017-02-24_SI_Sextupole_Model07_Sim_X=-14_14mm_Z=-500_500mm_Imc=158.48A.txt'
monoms     =   [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
Bn_normal  = 1*[+0.0000e+00, +0.0000e+00, +0.0000e+00, +3.4158e-04, -1.0027e-03, +0.0000e+00, -9.3432e-04, +0.0000e+00, +0.0000e+00, +0.0000e+00, +1.2183e-03];
Bn_skew    = 1*[+4.6270e-15, -2.0551e-11, -8.4837e-18, +1.2044e-10, -2.8535e-10, +6.0499e-17, +2.9350e-10, -1.3801e-16, -1.0909e-10, +9.6090e-17, +0.0000e+00];
main_monom = {2, 'normal'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% % SEXTUPOLES COILS
% % ================
% fams = {'SN'};
% r0         = 12/1000;
% % systematic multipoles from '2016-01-29 Sextupolo_Anel_S_Modelo 5_-14_14mm_-500_500mm.txt'
% monoms     =   [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
% Bn_normal  = 1*[+0.0000e+00, +0.0000e+00, +0.0000e+00, +2.1375e-04, -5.8657e-04, +0.0000e+00, -2.1622e-03, +0.0000e+00, +0.0000e+00, +0.0000e+00, +0.0000e+00];
% Bn_skew    = 1*[-2.7682e-11, -4.2157e-07, +9.1876e-11, +2.4706e-06, -5.8532e-06, -2.3938e-10, +6.0205e-06, +2.0654e-10, -2.2377e-06, -3.1102e-11, +0.0000e+00];
% main_monom = {2, 'normal'}; 
% the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% CH COILS IN SEXTUPOLES
% ======================
fams = {'CH'};
r0         = 12/1000;
% systematic multipoles from '2017-02-24_SI_Sextupole_Model07_Sim_CH_CV_X=-14_14mm_Z=-500_500mm_Imc=158.48A_Ich=10A_Icv=0A.txt'
monoms     =   [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];

Bn_normal  = 1*[-0.0000e+00, -3.6793e-03, -0.0000e+00, +2.9995e-01, +5.9684e-02, -0.0000e+00, -3.0608e-02, -0.0000e+00, -0.0000e+00, -0.0000e+00, -2.7950e-04];
Bn_skew    = 1*[+3.4558e-06, +1.3483e-06, -2.3873e-05, +5.3101e-04, -2.5285e-03, +5.2026e-04, +3.7764e-03, -7.3910e-04, -1.8045e-03, +2.3698e-04, -0.0000e+00];
main_monom = {0, 'normal'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% % CH COILS IN SEXTUPOLES
% % ======================
% fams = {'CH'};
% r0         = 12/1000;
% % systematic multipoles from '2016-02-01 Sextupolo_Anel_S_CH_Modelo 5_-14_14mm_-500_500mm.txt'
% monoms     =   [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
% Bn_normal  = 1*[-0.0000e+00, +2.7095e-03, -0.0000e+00, +2.9399e-01, +7.5225e-02, -0.0000e+00, -4.4112e-02, -0.0000e+00, -0.0000e+00, -0.0000e+00, +3.1510e-03];
% Bn_skew    = 1*[+4.1723e-05, -1.2690e-03, -2.3411e-04, +7.4254e-03, -1.7352e-02, +1.4442e-03, +1.7496e-02, -1.7058e-03, -6.4012e-03, +5.0200e-04, -0.0000e+00];
% main_monom = {0, 'normal'}; 
% the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% CV COILS IN SEXTUPOLES
% ======================
%fams = {'CV'}; % this should be changed to 'CVs' (CVs in sextupoles) XRR 2017-02-01 !!!
fams = {'CVS'}; 
r0         = 12/1000;
% systematic multipoles from '2016-02-01 Sextupolo_Anel_S_CV_Modelo 5_-14_14mm_-500_500mm.txt'
monoms     =   [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
Bn_normal  = 1*[-0.0000e+00, -1.3421e-02, -0.0000e+00, -5.1419e-03, +4.7509e-03, -0.0000e+00, -4.3355e-03, -0.0000e+00, -0.0000e+00, -0.0000e+00, +6.2623e-04];
Bn_skew    = 1*[+7.2532e-06, -2.0050e-04, -4.4058e-05, -3.0087e-01, +2.7313e-02, +4.7845e-04, +2.1257e-02, -6.4706e-04, +3.0857e-03, +1.9919e-04, -0.0000e+00];
main_monom = {0, 'skew'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% % CV COILS IN SEXTUPOLES
% % ======================
% %fams = {'CV'}; % this should be changed to 'CVs' (CVs in sextupoles) XRR 2017-02-01 !!!
% fams = {'CVS'}; 
% r0         = 12/1000;
% % systematic multipoles from '2016-02-01 Sextupolo_Anel_S_CV_Modelo 5_-14_14mm_-500_500mm.txt'
% monoms     =   [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
% Bn_normal  = 1*[-0.0000e+00, +8.9809e-04, -0.0000e+00, -3.7395e-03, +1.1069e-02, -0.0000e+00, -1.1097e-02, -0.0000e+00, -0.0000e+00, -0.0000e+00, +3.3551e-03];
% Bn_skew    = 1*[+3.8618e-05, -1.4830e-03, -2.2187e-04, -2.9344e-01, +1.2617e-02, +1.3048e-03, +3.3651e-02, -1.4938e-03, -5.7924e-04, +4.1594e-04, -0.0000e+00];
% main_monom = {0, 'skew'}; 
% the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% QS COILS IN SEXTUPOLES
% ======================
%fams = {'qs'}; % this should be changed to 'qss' (QSs in sextupoles) XRR 2017-02-01 !!!
fams = {'QSS'};
r0         = 12/1000;
% systematic multipoles from '2015-02-01 Sextupolo_Anel_S_QS_Modelo 5_-14_14mm_-500_500mm.txt'
monoms    = [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
Bn_normal = [+0.0000e+00, +9.6040e-03, +0.0000e+00, +2.7784e-03, -1.2997e-02, +0.0000e+00, +1.1019e-02, +0.0000e+00, +0.0000e+00, +0.0000e+00, -8.7129e-04];
Bn_skew   = [+0.0000e+00, -3.9197e-05, -5.7731e-01, -1.2158e-03, +6.1467e-03, +2.1070e-02, -9.4908e-03, +1.9441e-02, +4.6655e-03, -3.2033e-03, +0.0000e+00];
main_monom = {1, 'skew'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% % QS COILS IN SEXTUPOLES
% % ======================
% %fams = {'qs'}; % this should be changed to 'qss' (QSs in sextupoles) XRR 2017-02-01 !!!
% fams = {'QSS'};
% r0         = 12/1000;
% % systematic multipoles from '2015-02-01 Sextupolo_Anel_S_QS_Modelo 5_-14_14mm_-500_500mm.txt'
% monoms    = [ 1,           2,           3,           4,           6,           7,           8,           9,           10,          13,          14];
% Bn_normal = [-0.0000e+00, +1.9374e-03, -0.0000e+00, -1.0388e-02, +2.8264e-02, -0.0000e+00, -2.5529e-02, -0.0000e+00, -0.0000e+00, -0.0000e+00, +6.8507e-03];
% Bn_skew   = [-0.0000e+00, -2.1055e-03, -5.7765e-01, +1.2248e-02, -2.8575e-02, +2.5363e-02, +2.8797e-02, +1.3401e-02, -1.0545e-02, -1.1152e-03, -0.0000e+00];
% main_monom = {1, 'skew'}; 
% the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);


% FAST CORRECTORS - CH
% ====================
fams = {'FCH'};
r0         = 12/1000;
% systematic multipoles from '2017-03-29_SI_FC_Model03_Sim_X=-12_12mm_Z=-250_250mm_Ich=1A.txt'
monoms    = [ 0,           2,           8];
Bn_normal = [-0.0000e+00, -4.4634e-01, -4.2255e-02];
Bn_skew   = [-0.0000e+00, -0.0000e+00, -0.0000e+00];
main_monom = {0, 'normal'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% FAST CORRECTORS - CV
% ====================
fams = {'FCV'};
r0         = 12/1000;
% systematic multipoles from '2017-03-29_SI_FC_Model03_Sim_X=-12_12mm_Z=-250_250mm_Icv=1A.txt'
monoms    = [ 0,           2,           8];
Bn_normal = [-0.0000e+00, -0.0000e+00, -0.0000e+00];
Bn_skew   = [-0.0000e+00, +4.6629e-01, +4.4270e-02];
main_monom = {0, 'skew'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% QS COIILS IN FAST CORRECTORS
% ============================
fams = {'FCQ'};
r0         = 12/1000;
% systematic multipoles from '2017-03-29_SI_FC_Model03_Sim_X=-12_12mm_Z=-250_250mm_Iqs=3A.txt'
monoms    = [ 1,           5,           9            13];
Bn_normal = [-0.0000e+00, -0.0000e+00, -0.0000e+00, -0.0000e+00];
Bn_skew   = [-0.0000e+00, +6.6709e-02, -3.0999e-02, +1.8553e-02];
main_monom = {1, 'skew'}; 
the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);


function the_ring = add_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0,fam_data)

% expands lists of multipoles
new_monomials = monoms+1;    % converts to tracy convention of multipole order
new_Bn_normal = zeros(max(new_monomials),1);
new_Bn_skew   = zeros(max(new_monomials),1);
new_Bn_normal(new_monomials,1) = Bn_normal;
new_Bn_skew(new_monomials,1)   = Bn_skew;
if strcmpi(main_monom{2}, 'normal')
    new_main_monomial = main_monom{1} + 1;
else
    new_main_monomial = -(main_monom{1} + 1);
end

% adds multipoles
for i=1:length(fams)
    family  = fams{i};
    idx     = fam_data.(family).ATIndex';
    idx     = idx(:);
    the_ring = lnls_add_multipoles(the_ring, new_Bn_normal, new_Bn_skew, new_main_monomial, r0, idx);
end


