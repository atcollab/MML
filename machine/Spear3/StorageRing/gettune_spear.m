function [TUNE, tout, DataTime, ErrorFlag] = gettune_spear(FamilyName, Field, DeviceList, t, varargin)
%GETTUNE_SPEAR - Returns the tunes
%Measure betatron tunes from echotek (turn-by-turn BPM data), need
%(1) xyechotek.m, ipfaw.m in path
%(2) run echotekinit.m in the matlab session first
%(3) if the tune family is set to manual, set online with tune2online
%usage for tune measurement
%>> gettune
%>> getam('TUNE',[1;2;3;]); %getam('TUNE',[3]);
%>> measchro, %measchroresp, meastuneresp, etc.

ErrorFlag = 0;
t0 = clock;

if nargin < 3
    DeviceList = [1 1;1 2];
end


b0 = '116-ecdrt0';
[data] = spearacquireeightrxoneturn( b0 );
[nux,nuy,nus] = getechotektunes(data);
TUNE = [nux;nuy;nus];


i = findrowindex(DeviceList, [1 1;1 2;1 3]);
TUNE = TUNE(i);

t1 = clock;
tout = etime(t1, t0);
days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
DataTime = fix(tt) + rem(tt,1)*1e9*sqrt(-1);

