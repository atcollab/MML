function [S, Error] = gettol(varargin)
%GETTOL - Returns the tolerance between the setpoint and monitor 
%         (Just an alias to family2tol)
%
%  See also family2tol

[S, Error] = family2tol(varargin{:});


