function [Tune, ErrorFlag] = gettune_elsa(varargin)
%GETTUNE_ELSA - ELSA Ring Tune Measurement Program
%
% | Higher Fractional Tune, usually Horizontal |
% |                                            | = gettune_elsa
% |  Lower Fractional Tune, usually Vertical   |
%


[Tune, tout, DataTime, ErrorFlag] = getpv('TUNE');