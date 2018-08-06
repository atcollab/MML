function [AM, tout, DataTime, ErrorFlag] = gethturnbyturn(varargin)

tout = 0;
DataTime = 0;
ErrorFlag =1;

AM = anabpmfirstturn([],varargin,'NoDisplay');


