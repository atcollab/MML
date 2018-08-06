function [N, T] = getbpmaverages
%GETBPMAVERAGES - Gets the BPM averages
%  [N, T] = getbpmaverages
%  N = Number of averages
%  T = Sampling period after averaging [seconds]
%
%  In Simlutor mode, N = 1 and T = 0


Mode = getfamilydata('BPMx','Monitor','Mode');
if strcmpi(Mode,'Simulator')
    
    N = 1;
    T = 0;
    
else
    
    Scan1 = getpv('116-BPM:orbit.SCAN');
    Scan2 = getpv('132-BPM:orbit.SCAN');
    
    if Scan1 ~= Scan2
        fprintf('   WARNING:  BPM sampling period in Don East (%f) does not equal Don West (%f)!\n', Scan1, Scan2);
    end  
    
    switch max(Scan1, Scan2)
        case 9
            T = .1;
        case 8
            T = .2;
        case 7
            T = .5;
        case 6
            T = 1;
        case 5
            T = 2;
        case 4
            T = 5;
        case 3
            T = 10;
        otherwise
            error('Unknown input (see help setbpmaverages)');
    end        
    N = T * 4000;
end
