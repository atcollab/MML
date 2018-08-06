function [SQSFincr, SQSDincr] = set_etaywave_nuy9_20skews_skewFF(scale);
% function [SQSFincr, SQSDincr] = set_etaywave_nuy9_20skews_skewFF(scale);
%
% This routine returns the increments for 20 individual skew quadrupoles
% (no skews in SR05 because of fs bump) in order to
% create a vertical dispersion wave (without exciting
% the linear coupling resonance).
%
% The input parameter scale allows to control the size of the
% dispersion wave (a factor of 1 roughly increases the
% vertical emittance by 0.12 nm at 1.9 GeV). The dispersion is
% linear relative to the scaling factor, i.e. the emittance
% has an approximately quadratic dependence.
%
% Christoph Steier, 2005-05-13
%
% Modified for use in orbit feedback code to do skew FF for IVID (and other devices later)
% Tom Scarvie, 2007-05-07

% Theoretical k values [m^-2] for the skews as determined with a fit using
%the accelerator toolbox.

    % First 11 entries are SQSF, last 13 are SQSD
    skew_fit = [
        0.01049061974609
        0.01140933697991
        -0.04030875696656
        0
        0
        -0.05502813334686
        0.01542076460695
        -0.01619516668507
        0.00789235914796
        0.00131257163789
        0.00103749322207
        -0.03848844279225
        -0.01638239892977
        -0.01260762847070
        -0.01719182683414
        0
        0
        -0.00012424401083
        -0.00830469993127
        -0.00037523106600
        -0.03827790708473
        -0.02139034673185
        -0.01107856244175
        0.02111710213345];

SQSFincr = scale*skew_fit(1:11);
SQSDincr = scale*skew_fit(12:end);

