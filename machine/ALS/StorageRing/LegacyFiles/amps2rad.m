function [theta] = amps2rad(CMfamily, varargin);
% function [Theta [radians]] = amps2rad(CMfamily, Amps, CMlist, GeV);
%
%   Inputs:  CMfamily must be a string of capitols (ex. 'HCM', 'VCM').
%            Amps is the change corrector magnet strength [amps].
%            CMlist is the corrector magnet list (default: entire list).
%            GeV is the energy in GeV (default: global variable GeV).
%
%   Algorithm:    Ideal Model,
%                 Theta = (BLeff/Amp) * I / Brho    [radians]
%                             or
%                     I = Theta*Brho/(BLeff/Amp)   [amps]
%
%                 where,  BLeff/Amp  [Tesla*meters/Amps]
%                         I  [amps]
%                         Brho = 5 at 1.5 GeV
%
%                 The actual corrector magnet gain come from empirical data.
%
%  Note #1:  The sign of the VCSF correctors have been reversed to maintain the 
%            convention that positive amps corresponds to "up" and "out".
%
%  Note #2:  Amps must match the size of CMlist, or be a scalar.  If a scalar,
%            the number of Amps will assumed to be equal for all magnets.
%
%  This old function has been mapped to hw2physics.

theta = hw2physics(CMfamily, 'Setpoint', varargin{:});


% load alsgains
% % HCMGain = getgain('HCM');
% % VCMGain = getgain('VCM');
% 
% % Input checking
% if nargin < 2
%    error('AMPS2RAD: Must have at least two inputs (''Family'' & Amps)');
% elseif nargin == 2
%    CMlist = getlist(CMfamily);
%    GeVin = getenergy;
% elseif nargin == 3
%    GeVin = getenergy;
% end                    
% 
% 
% if isempty(CMlist)
%    error('AMPS2RAD: CMlist is empty');
% elseif (size(CMlist,2) == 1) 
%    CMelem = CMlist;
% elseif (size(CMlist,2) == 2)
%    CMelem = dev2elem(CMfamily, CMlist);
% else
%    error('AMPS2RAD: CMlist must be 1 or 2 columns only');
% end
% 
% 
% if isempty(Amps)
%    error('AMPS2RAD: Amps is empty');
% elseif size(Amps) == [1 1]
%    Amps = Amps*ones(size(CMelem));
% elseif size(Amps) == size(CMelem)
%    % input OK 
% else
%    error('AMPS2RAD: Rows of Amps must be equal to the rows of CMlist or a scalar!');
% end
% 
% 
% % Gain are for 1.5 GeV
% if strcmp(CMfamily,'HCM')
%    theta = Amps .* HCMGain(CMelem) * 1.5 / GeVin;
% elseif strcmp(CMfamily,'VCM')
%    theta = Amps .* VCMGain(CMelem) * 1.5 / GeVin;
% else
%    error('AMPS2RAD: family must be a  horizontal or vertical corrector.');
% end
% 


