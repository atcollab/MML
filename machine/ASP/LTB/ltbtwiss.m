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

% Parse input
if ~exist('TDinit','var') || isempty(TDinit)
    % These are the defauls for the ASP LTB lattice.
    TDinit = [10 0 10 0 0 0]';
end

if isstruct(TDinit)
    % Assume user provided the input structure rather than just the
    % 6-vector.
    TDin = TDinit;
elseif isnumeric(TDinit) && any(size(TDinit) ~= [6 1])
    error('input must be 6x1 culumn vector [betax alphax betay alphay etax etay]''')
elseif isnumeric(TDinit)
    % create input Twiss parameter structure( see > help twissline)
    TDin.ElemIndex = 1;
    TDin.SPos = 0;
    TDin.ClosedOrbit= zeros(4,1);   % Inital guess and only applies for RING
    TDin.M44 = zeros(4,4);          % Inital transfer matrix
    betax0 = TDinit(1);
    betay0 = TDinit(3);
    TDin.beta = [betax0 betay0];
    alphax0 = TDinit(2);
    alphay0 = TDinit(4);
    TDin.alpha = [alphax0 alphay0];
    TDin.mu = [0 0];                % Initial phase
    TDin.Dispersion = [TDinit(5) 0 TDinit(6) 0]';
end

global LTB
if isempty(LTB)
    error('global variable LTB not loaded. Please run asboosterinit again');
end

% calculate the Twiss parameters and return
if nargout == 1
    varargout{1} = machine_at(LTB,TDin,'line');
end
