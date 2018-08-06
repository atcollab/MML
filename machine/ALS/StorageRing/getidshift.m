function [Shift] = getid(Sector)
% Shift = getid(Sector)
%   Sector = Sector Number
%   Shift  = Shift parameter 0 - parallel mode 
%                            1 - anti-parallel mode
%

if nargin < 1
	Sector = 4;
end
if isempty(Sector)
	Sector = 4;
end


for i = 1:length(Sector)
   Shift(i,1) = scaget(sprintf('SR%02dU___ODS1M__DC00', Sector(i)));
end

