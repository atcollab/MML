function [Amps] = rad2amps(CMfamily, varargin);
% function [Amps] = rad2amps(CMfamily, Theta, CMlist, GeV);
%
%   Inputs:  CMfamily must be a string of capitols (ex. 'HCM', 'VCM').
%            Theta is the change in angle at the corrector magnet  [radians].
%            CMlist is the corrector magnet list (default: entire list).
%            GeV is the energy in GeV (default: global variable GeV).
%
%   Output:  Amps is the change in corrector magnet strength that will 
%            produce a change in angle of theta at the corrector 
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
%  Note #2:  Theta must match the size of CMlist, or be a scalar.  If a scalar,
%            The size of Theta will assumed to be equal for all magnets.
%
%  This old function has been mapped to physics2hw.


Amps = physics2hw(CMfamily, 'Setpoint', varargin{:});



% GeV = getenergy;
% 
% HCMGain = getgain('HCM');
% VCMGain = getgain('VCM');
% 
% % Input checking
% if nargin < 2
%    error('RAD2AMPS: Must have at least two inputs (''Family'' & Amps)');
% elseif nargin == 2
%    CMlist = getlist(CMfamily);
%    GeVin = GeV;
% elseif nargin == 3
%    GeVin = GeV;
% end                    
% 
% 
% if isempty(CMlist)
%    error('RAD2AMPS: CMlist is empty');
% elseif (size(CMlist,2) == 1) 
%    CMelem = CMlist;
% elseif (size(CMlist,2) == 2)
%    CMelem = dev2elem(CMfamily, CMlist);
% else
%    error('RAD2AMPS: CMlist must be 1 or 2 columns only');
% end
% 
% if isempty(theta)
%    error('RAD2AMPS: Theta is empty');
% elseif size(theta) == [1 1]
%    theta = theta*ones(size(CMelem));
% elseif size(theta) == size(CMelem)
%    % input OK 
% else
%    error('RAD2AMPS: Rows of Theta must be equal to the rows of CMlist or a scalar!');
% end
% 
% 
% % Gain are for 1.5 GeV
% if strcmp(CMfamily,'HCM')
%    Amps = theta .* GeVin ./ (HCMGain(CMelem) * 1.5);
% elseif strcmp(CMfamily,'VCM')
%    Amps = theta .* GeVin ./ (VCMGain(CMelem) * 1.5);
% else
%    error('RAD2AMPS: family must be a  horizontal or vertical corrector.');
% end
% 
% 
