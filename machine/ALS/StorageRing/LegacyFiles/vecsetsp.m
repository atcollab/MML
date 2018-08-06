% [AM, T] = vecsetsp(Family, NewSP, Sector, Device #, WaitFlag {1});    
% 
%          AM = analog monitor value (column vector)
%           T = time to make setpoint [sec]
%      Family = BPMx, BPMy, HCM, VCM, QF, QD, SF, SD, QFA, BEND
%      Sector = sector number [1,12]  (column vector)
%    Device # = magnet number         (column vector equal in size to Sector)
%       NewSP = new set point [AMPS]  (column vector equal in size to Sector, Scalar)
%    WaitFlag = 0-return immediately, 1-return when ramp is done
%