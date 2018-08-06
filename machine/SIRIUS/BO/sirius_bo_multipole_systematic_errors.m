function the_ring = sirius_bo_multipole_systematic_errors(the_ring)

% multipole order convention: n=0(dipole), n=1(quadrupole), and so on. 
   
fam_data = sirius_bo_family_data(the_ring);


% DIPOLES
% =======
% Already applied while building AT lattice with segmented dipole model.


% QUADRUPOLES
% ===========
% Already applied while building AT lattice with segmented quadrupole models.

% SEXTUPOLES
% ==========
% Already applied while building AT lattice with segmented sextupole models.

% SEXTUPOLES
% ==========
% updated in 2016-04-05 from BS004, BS005 and BS006 rotating coil measurements
r0            = 17.5/1000;
monoms        = [ 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14];
% avg values of multipoles for E = 3 GeV (~149A excitation current)
Bn_normal     = [-4.0e-03,+2.2e-03,+0.0e+00,+1.3e-04,-1.9e-03,+2.7e-05,-2.8e-04,+1.3e-06,-2.2e-02,+1.0e-04,+2.2e-04,+1.1e-04,+3.4e-05,-3.6e-04,-1.7e-02];
Bn_skew       = [-1.5e-03,-3.4e-03,-8.6e-04,-1.2e-03,+4.1e-05,-7.4e-05,-3.6e-05,+3.8e-04,-4.6e-05,-2.9e-06,-8.2e-05,-4.8e-05,-7.6e-05,+4.3e-04,-1.0e-05];
% avg values of multipoles for E = 0.15 GeV (~6A excitation current)
%Bn_normal     = [-1.4e-03,+1.3e-03,+1.0e+00,+7.0e-04,+9.4e-04,-1.2e-04,-5.5e-04,-1.3e-04,-2.2e-02,-3.9e-05,-1.5e-04,-8.5e-05,-2.9e-04,-5.0e-04,-1.7e-02];
%Bn_skew       = [-1.1e-02,-1.6e-03,+2.8e-03,-2.3e-03,+8.8e-05,-3.4e-04,-5.4e-05,+4.7e-04,-5.0e-05,+5.9e-05,-1.0e-05,+8.0e-05,-8.8e-06,+4.3e-04,+4.8e-05];
main_monom = {2, 'normal'}; 
fams       = {'sd','sf'};
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);



% % QF QUADRUPOLES
% % ==============
% % values based on rotating coil measurements of QF prototypes
% r0         = 17.5/1000;
% monoms     = [   5,   9,   13];
% Bn_normal  = [-1.0, 1.1, 0.08]*1e-3;
% Bn_skew    = [ 0.0, 0.0, 0.00];
% main_monom = {1, 'normal'}; 
% fams       = {'qf'};
% the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);
% 
% % QD QUADRUPOLES
% % ==============
% % updated values in 2015-09-03 for model1 of QD quads with 85 mm physical length (XRR) (@ 3GeV excitation)
% r0         = 17.5/1000;
% monoms     = [   5,   9,   13];
% Bn_normal  = [-4.7, 1.2, 1.2]*1e-3;
% Bn_skew    = [ 0.0, 0.0, 0.00];
% main_monom = {1, 'normal'}; 
% fams       = {'qd'};
% the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% % SEXTUPOLES
% % ==========
% % updated in 2015-09-03 for model1 of SD/SF with 100 mm physical length (XRR)
% r0         = 17.5/1000;
% monoms     = [   8,   14];
% Bn_normal  = [-2.5, -1.5]*1e-2;    
% Bn_skew    = [ 0.0,  0.0];
% main_monom = {2, 'normal'}; 
% fams       = {'sd','sf'};
% the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% CORRECTOR CH
% ============
% updated in 2015-09-14 for model1 with 112-mm physical length (XRR)
r0         = 17.5/1000;
monoms     = [      1,       2,       3,       4        5,       6];
Bn_normal  = [-3.0e-4, +3.0e-3, +1.3e-4, -3.3e-3, +6.2e-4, -3.2e-3];
Bn_skew    = [    0.0,     0.0,     0.0,     0.0,     0.0,     0.0];
main_monom = {0, 'normal'}; 
fams       = {'ch'};
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);

% CORRECTOR CV
% ============
% updated in 2015-09-14 for model1 with 112-mm physical length (XRR)
r0         = 17.5/1000;
monoms     = [      1,       2,       3,       4        5,       6];
Bn_normal  = [-3.1e-4,     0.0, +3.7e-4,     0.0, +4.6e-4,     0.0];
Bn_skew    = [    0.0, -3.1e-3,     0.0, -1.1e-3,     0.0, +2.8e-3];
main_monom = {0, 'skew'}; 
fams       = {'cv'};
the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0, fam_data);



function the_ring = insert_multipoles(the_ring, fams, monoms, Bn_normal, Bn_skew, main_monom, r0,fam_data)

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


