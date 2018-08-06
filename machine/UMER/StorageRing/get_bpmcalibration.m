function [slopeX,interceptX,slopeY,interceptY] = get_bpmcalibration(bpmidx)
% Returns the bpm calibration factors for a specific bpm
%
%   EXAMPLE:
%   [mx,mb] = getbpmcalibration(1)
%   x_position = ((left-right)/(left+right))*mx + mb
%
% INPUTS
%   1. bpmidx - the bpm index
%
% OUTPUTS
%   1. slopeX/slopeY - slopes for fitting current to position
%   2. interceptX/interceptY - inercepts for fitting current to position
%
%
% Written by Levon D
% July 2017
%

switch bpmidx
    case 0
        slopeX = 1/0.0804;
        interceptX = -0.0223;
        slopeY = 1/0.0796;
        interceptY = -0.0503;        
    case 1
        slopeX = 1/0.0838;
        interceptX = 0.0305;
        slopeY = 1/0.0751;
        interceptY = 0.1314;
    case 2
        slopeX = 1/0.0839;
        interceptX = -0.002;
        slopeY = 1/0.0787;
        interceptY = 0.0305;
    case 3
        slopeX = 1/0.0784;
        interceptX = 0.1336;
        slopeY = 1/0.0802;
        interceptY = -0.0185;        
    case 5
        slopeX = 1/0.0774;
        interceptX = -0.0677;
        slopeY = 1/0.0779;
        interceptY = 0.0195;        
    case 6
        slopeX = 1/0.0802;
        interceptX = 0.045;
        slopeY = 1/0.0813;
        interceptY = 0.0404;        
    case 7
        slopeX = 1/0.0793;
        interceptX = 0.0102;
        slopeY = 1/0.0785;
        interceptY = 0.0195;        
    case 8
        slopeX = 1/0.0793;
        interceptX = 0.0102;
        slopeY = 1/0.0785;
        interceptY = 0.0195;        
    case 9
        slopeX = 1/0.0794;
        interceptX = -0.0521;
        slopeY = 1/0.0795;
        interceptY = 0.0222;        
    case 11
        slopeX = 1/0.0768;
        interceptX = 0.0328;
        slopeY = 1/0.0761;
        interceptY = 0.018;        
    case 12
        slopeX = 1/0.0780;
        interceptX = 0.0084;
        slopeY = 1/0.0782;
        interceptY = -0.0149;        
    case 13
        slopeX = 1/0.0772;
        interceptX = 0.058;
        slopeY = 1/0.0752;
        interceptY = 0;        
    case 14
        slopeX = 1/0.0768;
        interceptX = 0.0067;
        slopeY = 1/0.0771;
        interceptY = -0.0141;        
    case 15
        slopeX = 1/0.0815;
        interceptX = -0.0322;
        slopeY = 1/0.0793;
        interceptY = 0.0204;        
    case 17
        slopeX = 1/0.0767;
        interceptX = -0.0063;
        slopeY = 1/0.0827;
        interceptY = 0.0689;        
end
end