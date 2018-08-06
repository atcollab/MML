function Alpha = modelmcf
%MODELMCF - Momentum compaction factor (MCF) of the model
%  Alpha = modelmcf
%   
% OUTPUTS
% 1. Alpha - Momentum compaction factor 
%           Calls the AT function:  mcf(THERING)
%
%  See also getmcf, mcf

%  Written by Greg Portmann

global THERING
if ~isempty(THERING)
    % Get from the model
    Alpha = mcf(THERING);
else
    error('Momentum compaction factor not available from the model');
end

