% [AM, tout] = vecgetam(Family, Sector, Device #, NumberOfAverages {1}, t {0});
%
%               AM = analog monitor value (Matrix: 1 column at each time)
%             tout = time when measurement was taken (row vector)
%
%           Family = BPMx, BPMy, HCM, VCM, QF, QD, SF, SD, QFA, BEND
%           Sector = sector number [1,12] (column vector)
%         Device # = magnet number (column vector equal in size to Sector)
% NumberOfAverages = number of averages of each channel (assuming 10 Hz data rate) 
%                t = time vector (row vector)
%