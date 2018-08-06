function t = tangotime2matlab(sec,shift)
%TANGOTIME2MATLAB - Convert unix time to matlab time
%
%  INPUTS
%  1. sec - Seconds since 1/1/1970
%  2. shift - hour shift from GMT
%
%  OUTPUTS
%  1. t = time as datastring
%
%  See also datestr


% Written by Laurent S. Nadolski
% TODO 2 hour shift is Okey only half the year

if nargin == 1
    shift = 2;
end

% For Matlab time is in days since 0/0/0000
t= datestr((sec+shift*3600)/86400 + 719529);
% t= (sec+shift*3600)/86400 + 719529;