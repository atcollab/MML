function Error = scaput(varargin)
%SCAPUT - An alias to setpvonline 
%  ErrorFlag = scaput(ChannelName, NewSP, DataType)
%
%  See also setpvonline, getpvonline, getpv, setpv

Error = setpvonline(varargin{:});
