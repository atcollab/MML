function ErrorFlag = setrf_sps(Family, Field, RF, DeviceList, WaitFlag)
%  ErrorFlag = setrf_sps(Family, Field, RF, DeviceList, WaitFlag)


% Hardware units are MHz
% Control system units are in .1 hz
RF = RF * 1e6;  % Hz
RF = 10 * RF;   % 10*Hz

ChannelName = family2channel(Family, Field, DeviceList);
ErrorFlag = setpv(ChannelName, RF, WaitFlag);
