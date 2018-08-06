function sirius_nominal_optics

global THERING;
ats = atsummary;

fprintf('--- tunes ---\n')
fprintf('tunex: %011.8f\n', ats.tunes(1));
fprintf('tuney: %011.8f\n', ats.tunes(2));

fprintf('--- chrom ---\n')
fprintf('chromx: %011.8f\n', ats.chromaticity(1));
fprintf('chromy: %011.8f\n', ats.chromaticity(2));


fprintf('--- quad intKL ---\n')
fams = findmemberof('quad');
for i=1:length(fams)
    q = fams{i};
    idx = getfamilydata(q,'AT','ATIndex');
    len = getcellstruct(THERING, 'Length', idx(1,:));
    k = getcellstruct(THERING, 'PolynomB', idx(1,:), 1, 2);
    kl = sum(len .* k);
    fprintf('%8s: %+020.16f\n', q, kl);
end
    
fprintf('--- sext intSL ---\n')
fams = findmemberof('sext');
for i=1:length(fams)
    q = fams{i};
    idx = getfamilydata(q,'AT','ATIndex');
    len = getcellstruct(THERING, 'Length', idx(1,:));
    k = getcellstruct(THERING, 'PolynomB', idx(1,:), 1, 3);
    kl = sum(len .* k);
    fprintf('%8s: %+020.16f\n', q, kl);
end
