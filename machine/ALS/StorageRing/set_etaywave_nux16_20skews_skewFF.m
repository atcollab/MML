function [SQSFincr, SQSDincr] = set_etaywave_nux16_20skews_skewFF(scale);
% function [SQSFincr, SQSDincr] = set_etaywave_nux16_20skews_skewFF(scale);
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
    % First 11 entries are SQSF, last 13 are SQSD

skew_fit = [
    0.0055
    0.0094
   -0.0519
         0
         0
   -0.0694
    0.0108
    0.0060
    0.0079
    0.0017
    0.0010
   -0.0432
   -0.0050
   -0.0206
    0.0033
         0
         0
   -0.0002
   -0.0006
   -0.0003
   -0.0440
   -0.0139
   -0.0251
    0.0279];

SQSFincr = scale*skew_fit(1:11);
SQSDincr = scale*skew_fit(12:end);

