function [N, T] = getbpmaverages
%GETBPMAVERAGES - Gets the BPM averages
% [N, T] = getbpmaverages
%  N = Number of averages
%  T = Sampling period after averaging [seconds]

%
%  In Simlutor mode, N = 1 and T = 0
%  Modified by Laurent s. Nadolski
%  TODO Parametre TANGO a definir pour les moyennes

Mode = getfamilydata('BPMx','Monitor','Mode');
if strcmpi(Mode,'Simulator')    
    N = 1;
    T = 0;    
elseif strcmpi(Mode,'Special')
    N = 1;
    T = 0;
else
    N = 1;
    T = 0;
end
