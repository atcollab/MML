function ErrorFlag = setrf_als(varargin)
%  ErrorFlag = setrf_als(Family, Field, RFnew, DeviceList, WaitFlag, RampFlag);
%  ErrorFlag = setrf_als(Family, RFnew, DeviceList, WaitFlag, RampFlag);
%  ErrorFlag = setrf_als(RFnew, DeviceList, WaitFlag, RampFlag);
%
%  aliase to setrf_hp


setrf_hp(varargin{:});
ErrorFlag = 0;

