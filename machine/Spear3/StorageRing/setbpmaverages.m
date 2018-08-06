function setbpmaverages(N)
%SETBPMAVERAGES - Sets the BPM sampling period [second]
%  setbpmaverages(T)
%  T can be .1 .2 .5 1 2 5 10
%  4000 averages / second
%
%  The standard 'SCAN' menu enums (any record's SCAN field)  
% 
%  Entry Number     corresponding string value 
%      0              "Passive" 
%      1              "Event" 
%      2              "I/O Intr" 
%      3              "10 second" 
%      4              "5 second" 
%      5              "2 second" 
%      6              "1 second" 
%      7              ".5 second" 
%      8              ".2 second" 
%      9              ".1 second" 
%
%  In Simlutor mode, nothing is set


Mode = getfamilydata('BPMx','Monitor','Mode');
if ~strcmpi(Mode,'Simulator')
    %T = N / 4000;
    
    switch N
        case .1
            T = 9;
        case .2
            T = 8;
        case .5
            T = 7;
        case 1
            T = 6;
        case 2
            T = 5;
        case 5
            T = 4;
        case 10
            T = 3;
        otherwise
            error('Unknown input (see help setbpmaverages)');
    end        
    
    setpv('116-BPM:orbit.SCAN', T);
    setpv('132-BPM:orbit.SCAN', T);
    setfamilydata(2.2*N, 'BPMDelay');
end