function [Tune, ErrorFlag] = gettunes_vuv(varargin)
%GETTUNES_VUV - VUV Ring Tune Measurement Program
%
% | Higher Fractional Tune, usually Horizontal |
% |                                            | = gettune_vuv
% |  Lower Fractional Tune, usually Vertical   |
%


[Tune, tout, DataTime, ErrorFlag] = getpv('TUNE');