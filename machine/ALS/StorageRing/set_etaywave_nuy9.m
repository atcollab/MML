function set_etaywave_nuy9(scale)
% function set_etaywave_nuy9(scale)
%
% This routine increments 24 individual skew quadrupoles
% in order to create a vertical dispersion wave (without exciting
% the linear coupling resonance).
%
% The input parameter scale allows to control the size of the
% dispersion wave (a factor of 1 roughly increases the
% vertical emittance by 0.15 nm at 1.9 GeV). The dispersion is
% linear relative to the scaling factor, i.e. the emittance
% has an approximately quadratic dependence.
%
% Important: This routine works incrementally, i.e. it does
% not set absolute skew currents. In addition, all skew quadrupoles
% of course have to be switched on.
%
% Written by Christoph Steier, 2005-05-13

%energy = getam('cmm:sr_energy');
energy = getenergy;


if energy<0.7
    error('cannot read the storage ring energy! exiting ...');
end

% scaling factors [A/m^-2] (based on magnetic measurements of skew quadrupoles)
% SQSF at 1.9 GeV are weaker because the higher sextupole strength causes pole
% saturation.

if energy > 1.7
    SQSFfac = 20.0/0.11*energy/1.894;
    HCSFfac = 6.1/0.11*energy/1.894;
    HCSDfac = 4.6/0.11*energy/1.894;
else
    SQSFfac = 14.0/0.11*energy/1.894;
    HCSFfac = 6.1/0.11*energy/1.894;    % probably not correct; put saturation unknow so far
    HCSDfac = 4.6/0.11*energy/1.894;    % probably not correct; put saturation unknow so far
end

SQSDfac = 14.0/0.11*energy/1.894;



% Index of magnets to use
SQSFindex = [1 1; 3 1; 3 2; 5 1; 5 2;6 1; 6 2; 7 1; 7 2; 9 1; 11 1];
SQSFind   = [1 2 3 4 5 6 7 8 9 10 11];
SQSDindex = [2 1; 3 1; 3 2; 4 1; 5 1; 5 2; 6 1; 6 2; 7 1; 7 2; 8 1; 10 1; 12 1];
SQSDind   = [12 13 14 15 16 17 18 19 20 21 22 23 24];


% Theoretical k values [m^-2] for the skews as determined with a fit using the accelerator toolbox.

% First 11 entries are SQSF, last 13 are SQSD
SQSF_fit = [
     0.01727216697979
     0.01184557173045
    -0.02017846221196
    -0.00612197974464
    -0.02069568699941
    -0.06329253170868
     0.00715842780350
    -0.01070896407445
     0.00550406225844
     0.00449906206811
     0.00047090892735];
 
SQSD_fit = [
    -0.02375885314324
    -0.01211135612168
    -0.00952587083407
    -0.01543990455777
    -0.02518634499051
     0.02204474741020
     0.00132303391277
    -0.00709686901179
    -0.00046797176215
    -0.03617151751389
    -0.01559864156483
    -0.00545221139740
     0.01903059229621
    ];


SQSFold = getsp('SQSF');
SQSDold = getsp('SQSD');


SQSFincr = scale * SQSFfac * SQSF_fit;
SQSDincr = scale * SQSDfac * SQSD_fit;



if any(abs(SQSFincr+SQSFold)>maxsp('SQSF'))
    error('At least one of the SQSF would go beyond it''s limit ... aborting');
end

if any(abs(SQSDincr+SQSDold)>maxsp('SQSD'))
    error('At least one of the SQSD would go beyond it''s limit ... aborting');
end


stepsp('SQSF', SQSFincr, [], 0);
stepsp('SQSD', SQSDincr, [], 0);

pause(0.5);

SQSFnew = getsp('SQSF');
SQSDnew = getsp('SQSD');

setsp('SQSF', SQSFnew, SQSFindex, -2);
setsp('SQSD', SQSDnew, SQSDindex, -2);

fprintf('\n   Vertical dispersion wave incremented by %.2f (times approx 0.15 nm at 1.9 GeV)\n\n', scale);

