function mcaclearmon(varargin)
%MCACLEARMON  - uninstall monitors, previously installed with MCAMON
% 
% MCACLEARMON(H1,H2,...,HN)
%    H1,H2..,HN - integer channel handles 
%
% Note: Monitors can be installed with MCAMON and cleared with 
%    MCACLEARMON any number of times.
%
% See also MCAMON, MCAMONTIMER, MCACACHE

if nargin <1
    error('Must specify channel handles to close');
else
    for i=1:nargin
        mca(200,varargin{i})
    end
end