function [N, T] = getbpmaverages
%GETBPMAVERAGES - Gets the BPM averages
% [N, T] = getbpmaverages
%  N = Number of averages
%  T = Sampling period after averaging [seconds]
%
%  In Simlutor mode, N = 1 and T = 0

    N = 1;
    T = 0;
    return

Mode = getfamilydata('BPMx','Monitor','Mode');
if strcmpi(Mode,'Simulator')
    
    N = 1;
    T = 0;
    
else
    
    Scan1 = getpv('116-BPM:orbit.SCAN');
    Scan2 = getpv('132-BPM:orbit.SCAN');
    
    if iscell(Scan1)
        Scan1 = Scan1{1};
    end
    if iscell(Scan2)
        Scan2 = Scan2{1};
    end
    
    if ischar(Scan1)
        if ~strcmpi(Scan1,Scan2)
            fprintf('   WARNING:  BPM sampling period in Don East (%f) does not equal Don West (%f)!\n', Scan1, Scan2);
        end  
        
        switch Scan1
            case '.1 second'
                T = .1;
            case '.2 second'
                T = .2;
            case '.5 second'
                T = .5;
            case '1 second'
                T = 1;
            case '2 second'
                T = 2;
            case '5 second'
                T = 5;
            case '10 second'
                T = 10;
            otherwise
                error('Unknown input (see help setbpmaverages)');
        end        
        N = T * 4000;
        
    else
        
        if Scan1 ~= Scan2
            fprintf('   WARNING:  BPM sampling period in Don East (%f) does not equal Don West (%f)!\n', Scan1, Scan2);
        end  
        
        switch Scan1
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
end
