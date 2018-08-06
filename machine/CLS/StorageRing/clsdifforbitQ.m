function [Xresponse,Yresponse] = clsdifforbitQ(family, quad, percentKick)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsdifforbitQ.m 1.2 2007/03/02 09:03:27CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

%  [Xresponse,Yresponse] = clsdifforbitQ(family, quad, percentKick)
%       INPUTS:
%               FAMILY: this specifies the quad family. ex: 'QFA' or 'QFB'
%                       or 'QFC'
%               QUAD:   this is in the device list format ex: [2 3]       
%                       would specify the 3rd quad in the 2 cell
%
%               PERCENTKICK:
%                       this is the percentage of kick to add to the
%                       current quad setting
%
%   This function kicks the beam using the specified quad and measures the
%   orbit, an average orbit is taken and is used to measure a difference to
%   the kicked orbit, teh difference orbit is returned in XRESPONSE,
%   YRESPONSE repectively
% ----------------------------------------------------------------------------------------------

Xtemp = [1:48]';
Xtemp(:) = 0;
Ytemp = [1:48]';
Ytemp(:) = 0;

fprintf('Taking intial orbit: ');
%take the initial orbit, avg 3 samples
for i=1:3
    fprintf('.');
    Xtemp = Xtemp + getx;
    Ytemp = Ytemp + gety;
    pause(1);    
end
Xinitial = Xtemp / 3;
Yinitial = Ytemp / 3;
fprintf('\n');

% get the current Q value
Qinitial = getsp(family, quad);
newQ = Qinitial + (Qinitial * (percentKick * 0.01));
%kick the beam
fprintf('Kicking the beam %d \n', newQ);
setpv(family,'Setpoint',newQ,quad);
%wait to 
pause(3);

%get the kicked orbit
Xtkick = [1:48]';
Xtkick(:) = 0;
Ytkick = [1:48]';
Ytkick(:) = 0;

fprintf('Measuring orbit');
%take the initial orbit, avg 3 samples
for i=1:3
    fprintf('.');
    Xtkick = Xtkick + getx;
    Ytkick = Ytkick + gety;
    pause(1);
end
Xkicked = Xtkick / 3;
Ykicked = Ytkick / 3;
fprintf('\n');

%restore the quad setting
fprintf('\nRestoring quad: \n');
setpv(family,'Setpoint',Qinitial,quad);
pause(3);

%get the kicked orbit
Xtemp = [1:48]';
Xtemp(:) = 0;
Ytemp = [1:48]';
Ytemp(:) = 0;

fprintf('Measuring final orbit:');
%take the initial orbit, avg 3 samples
for i=1:3
    fprintf('.');
    Xtemp = Xtemp + getx;
    Ytemp = Ytemp + gety;    
    pause(1);    
end
Xfinal = Xtemp / 3;
Yfinal = Ytemp / 3;

fprintf('\n');
%find the average
Xavg = (Xfinal + Xinitial) / 2;
Yavg = (Yfinal + Yinitial) / 2;

XRESP = [1:96]';
XRESP(:) = 0;
YRESP = [1:96]';
YRESP(:) = 0;


if(quad(1) > 1)
    shift = (quad(1)-1) * 4;
else 
    shift = 0; 
end    
%pump out the difference
absShift = 48 - shift;
XRESP(absShift:(absShift+47)) = Xkicked - Xavg;
YRESP(absShift:(absShift+47)) = Ykicked - Yavg;
Xresponse = XRESP;
Yresponse = YRESP;

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsdifforbitQ.m  $
% Revision 1.2 2007/03/02 09:03:27CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------




