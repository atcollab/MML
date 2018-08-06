function [RFam, RFac] = getrf_hp(varargin)
% [RFam, RFac] = getrf2
%
%   RFac = RF frequency FM modulation voltage on the user synthesizer
%   RFam = RF frequency as measured by the HP counter [MHz]
%
%   EG_HQMOFM is the voltage that modulates the user synthesizer frequency (which is set by hand)
%   The scaling factor is 10V = 4.988 kHz, and the range is -10<->10 V (with a 10/1 voltage 
%   divider in between the DAC and the synthesizer)
%
%   Note:  The RF must be connected to the user synthesizer for outputs to be correct
%          

% Changed scaling factor (actually only used in help at the top) because of voltage divider addition
% 2010-09-16 Christoph Steier

if nargout == 0
    fprintf('\n  RF Frequency Information:\n');
    fprintf('  CR   Counter = %.7f MHz\n', getpv('MOCounter:FREQUENCY')/1e6);
    fprintf('  LI11 Counter = %.7f MHz\n', getpv('SR01C___FREQB__AM00'));
    fprintf('  EG_HQMOFM    = %.6f V\n\n', getpv('EG______HQMOFM_AC01'));
end
if nargout >= 1
    %AM = getpv('MOCounter:FREQUENCY');
    %AM = AM / 1e6;
    RFam  = getpv('SR01C___FREQB__AM00');
end
if nargout >= 2
    RFac  = getpv('EG______HQMOFM_AC01');
end