function [SQSFincr, SQSDincr] = set_etaywave_nux1618_nuy925_20skews_skewFF(scale);
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

% skew_fit = [
%     0.0055
%     0.0094
%    -0.0519
%          0
%          0
%    -0.0694
%     0.0108
%     0.0060
%     0.0079
%     0.0017
%     0.0010
%    -0.0432
%    -0.0050
%    -0.0206
%     0.0033
%          0
%          0
%    -0.0002
%    -0.0006
%    -0.0003
%    -0.0440
%    -0.0139
%    -0.0251
%     0.0279];

% skew_fit =[
%    0.011551931510401
%    0.008718270429684
%   -0.064609652656248
%    0
%    0
%   -0.086146588789963
%    0.013892430443615
%    0.007175231213095
%   -0.004604402038791
%   -0.000322128883462
%   -0.000074961907761
%   -0.047893045953468
%    0.000000568684695
%   -0.027097287733884
%    0.005038477844366
%    0
%    0
%   -0.000868037332710
%   -0.000480472074811
%    0.000041377168213
%   -0.041750020228686
%   -0.013195011491547
%   -0.029716831057025
%    0.034081658859358];

% noew we have 16 SQSF and 16 SQSD
skew_fit = [
   0.011551931510401
                   0
   0.008718270429684
  -0.064609652656248
                   0
                   0
                   0
  -0.086146588789963
   0.013892430443615
   0.007175231213095
  -0.004604402038791
                   0
  -0.000322128883462
                   0
  -0.000074961907761
                   0
                   0
  -0.047893045953468
   0.000000568684695
  -0.027097287733884
   0.005038477844366
                   0
                   0
  -0.000868037332710
  -0.000480472074811
   0.000041377168213
  -0.041750020228686
  -0.013195011491547
                   0
  -0.029716831057025
                   0
   0.034081658859358];

SQSFincr = scale*skew_fit(1:16);
SQSDincr = scale*skew_fit(17:end);

