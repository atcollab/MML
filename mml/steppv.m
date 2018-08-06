function ErrorFlag = steppv(varargin)
%STEPPV - Incremental setpoint change of a process variable or simulated value
%  ErrorFlag = steppv(FamilyName, Field, DeltaSP, DeviceList, WaitFlag)
%  ErrorFlag = steppv(DataStructure, WaitFlag)
%  ErrorFlag = steppv('ChannelName', DeltaSP)
%
%  See >> help setpv for details on each input/output with
%         NewSP replaced with DeltaSP and an 'Inc' input
%         flag is used for incremental change in the setpoint.
%
%  See also getam, getsp, getpv, setpv, stepsp

%  Written by Greg Portmann


ErrorFlag = setpv('Inc', varargin{:});

