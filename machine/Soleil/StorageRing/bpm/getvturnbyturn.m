function [AM, tout, DataTime, ErrorFlag] = getvturnbyturn(varargin)

tout = 0;
DataTime = 0;
ErrorFlag =1;

[AM0 AM] = anabpmfirstturn([],varargin,'NoDisplay');


