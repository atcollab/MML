function varargout = ltbtwiss(TDinit,varargin)
% TDout = LTBTWISS(TDinit) - returns the Twiss parameters at the end of the
% LTB for the given initial twiss parameters where:
%
%         TDinit - a 6-vector column [betax alphax betay alphay etax etay]'
%         TDout - struct containing the optical parameters.
%
%   Example:
%      TD = ltbtwiss([4.5 0 3.5 0 0 0]');
% 
% Copied from BTSTWISS
%
% Eugene 21-08-2006: Modification to use global variable LTB as well as
%                    using machine_at which returns the data in a more
%                    usable format.

% Change the THERING to the BTS
getam('LTB_BEND','Model');

global THERING
TDin = getpvmodel('TwissData');

% Parse input
if exist('TDinit','var') && ~isempty(TDinit)
    TDin.beta  = [TDinit(1) TDinit(3)];
    TDin.alpha = [TDinit(2) TDinit(4)];
    TDin.Dispersion = [TDinit(5) 0 TDinit(6) 0]';
end

% calculate the Twiss parameters and return
if nargout == 1
    varargout{1} = machine_at(THERING,TDin,'line');
end
