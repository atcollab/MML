function Output = scaget(varargin)
%SCAGET - An alias to getpvonline 
%  [Output, tout, DataTime, ErrorFlag] = scaget(ChannelNames, DataType, N, t)
%
%  See also getpvonline, setpvonline, getpv, setpv

Output = getpvonline(varargin{:}, 'double');
