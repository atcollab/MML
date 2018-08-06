function the_ring = sirius_si_correct_tune_chrom(the_ring0)

tunes = [49.110128921637788, 14.165190071737401];
chrom = [2.4, 2.4];

the_ring = the_ring0;

%% Tune correction
fprintf('Tune correction\n')
[the_ring, conv, t2, t1] = lnls_correct_tunes(the_ring, tunes, {'QFA','QDA','QFB','QDB1','QDB2','QDP1','QFP','QDP2'},'svd', 'prop',10,1e-9); fprintf('%.15f %.15f -> %.15f %.15f\n', t1, t2);
[the_ring, conv, t2, t1] = lnls_correct_tunes(the_ring, tunes, {'QFA','QDA','QFB','QDB1','QDB2','QDP1','QFP','QDP2'},'svd', 'prop',10,1e-9); fprintf('%.15f %.15f -> %.15f %.15f\n', t1, t2);
[the_ring, conv, t2, t1] = lnls_correct_tunes(the_ring, tunes, {'QFA','QDA','QFB','QDB1','QDB2','QDP1','QFP','QDP2'},'svd', 'prop',10,1e-9); fprintf('%.15f %.15f -> %.15f %.15f\n', t1, t2);

%% Chrom correction
fprintf('Chrom correction\n')
ats1 = atsummary(the_ring);
the_ring = lnls_correct_chrom(the_ring, chrom, {'SDA1','SDA2','SDA3','SFA1','SFA2','SDB1','SDB2','SDB3','SFB1','SFB2','SDP1','SDP2','SDP3','SFP1','SFP2'});
the_ring = lnls_correct_chrom(the_ring, chrom, {'SDA1','SDA2','SDA3','SFA1','SFA2','SDB1','SDB2','SDB3','SFB1','SFB2','SDP1','SDP2','SDP3','SFP1','SFP2'});
the_ring = lnls_correct_chrom(the_ring, chrom, {'SDA1','SDA2','SDA3','SFA1','SFA2','SDB1','SDB2','SDB3','SFB1','SFB2','SDP1','SDP2','SDP3','SFP1','SFP2'});
ats2 = atsummary(the_ring);
fprintf('%.15f %.15f -> %.15f %.15f\n', ats1.chromaticity, ats2.chromaticity);
fprintf('\n');

%% Printout

fprintf('%% QUADRUPOLES\n');
fprintf('%% ===========\n');
f = 'QFA';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength  = %+.15f;\n'], values);
f = 'QFB';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength  = %+.15f;\n'], values);
f = 'QFP';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength  = %+.15f;\n'], values);
f = 'QDA';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength  = %+.15f;\n'], values);
f = 'QDB1'; idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'QDB2'; idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'QDP1'; idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'QDP2'; idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'Q1';   idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength   = %+.15f;\n'], values);
f = 'Q2';   idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength   = %+.15f;\n'], values);
f = 'Q3';   idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength   = %+.15f;\n'], values);
f = 'Q4';   idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 2)); fprintf([f, '_strength   = %+.15f;\n'], values);
fprintf('\n');

fprintf('%% SEXTUPOLES\n');
fprintf('%% ==========\n');
f = 'SDA0';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDB0';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDP0';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SFA0';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SFB0';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SFP0';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDA1';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDB1';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDP1';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDA2';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDB2';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDP2';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDA3';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDB3';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SDP3';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SFA1';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SFB1';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SFP1';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SFA2';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SFB2';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
f = 'SFP2';  idx = findcells(the_ring, 'FamName', f); values = unique(getcellstruct(the_ring, 'PolynomB', idx, 1, 3)); fprintf([f, '_strength = %+.15f;\n'], values);
fprintf('\n');


