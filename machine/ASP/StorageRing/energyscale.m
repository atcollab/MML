
% 17/07/06 Tall fuzzy blobs (3 of them)
% scale = 0.9817;
% scaleQFB = 1.0059;
% scaleQFA = 0.9905;
% scaleQDA = 0.9741;
% 
% setsp('BEND',3*scale,[1,1],'Physics');
% setsp('QDA',79.8008*scaleQDA,'Hardware');
% setsp('QFA',138.8823*scaleQFA,'Hardware');
% setsp('QFB',120.3467*scaleQFB,'Hardware');

% 18/07/06 Clear 9 balls on x-ray and linear stacking till 10mA.
% scale = 0.9864;
% scaleQFB = 1.0064;
% scaleQFA = 0.993;
% scaleQDA = 0.9742;
% 
% setsp('BEND',622.9*scale,[1,1],'Hardware');
% setsp('QDA',78.883*scaleQDA,'Hardware');
% setsp('QFA',137.257*scaleQFA,'Hardware');
% setsp('QFB',119.083*scaleQFB,'Hardware');

% 18/07/06 Good settings for evening shift
% scale = 1;
% scaleQFB = 0.9965;
% scaleQFA = 1.0037;
% scaleQDA = 0.996;
% 
% setsp('BEND',614.4286*scale,[1,1],'Hardware');
% setsp('QDA',76.8478*scaleQDA,'Hardware');
% setsp('QFA',136.2962*scaleQFA,'Hardware');
% setsp('QFB',119.8451*scaleQFB,'Hardware');

% % 20/07/06
% scale = 0.9993;
% scaleQFB = 0.9994;
% scaleQFA = 1.002;
% scaleQDA = 1.000;
% 
% setsp('BEND',616.8000*scale,[1,1],'Hardware');
% setsp('QDA',76.5404*scaleQDA,'Hardware');
% setsp('QFA',136.8005*scaleQFA,'Hardware');
% setsp('QFB',119.4256*scaleQFB,'Hardware');

% 21/07/06
% scale = 1;
% scaleQFB = 1;
% scaleQFA = 1;
% scaleQDA = 1;
% 
% setsp('BEND',612.1000*scale,[1,1],'Hardware');
% setsp('QDA',76.8478*scaleQDA,'Hardware');
% setsp('QFA',136.3032*scaleQFA,'Hardware');
% setsp('QFB',119.8451*scaleQFB,'Hardware');

% scale = 1;
% dipscale = 1;
% scaleQFB = 1;
% scaleQFA = 1;
% scaleQDA = 1;

%setsp('BEND',613.3*scale,'Hardware');
%setsp('QDA',80.8725*scale*scaleQDA,'Hardware');
%setsp('QFA',135.7422*scale*scaleQFA,'Hardware');
%setsp('QFB',118.7201*scale*scaleQFB,'Hardware');



% 
% qfasp = getsp('QFA');
% qdasp = getsp('QDA');
% qfbsp = getsp('QFB');
% sfasp = getsp('SFA');
% sdasp = getsp('SDA');
% sfbsp = getsp('SFB');
% sdbsp = getsp('SDB');
% bendsp = getsp('BEND');

dipscale = 1.00;
scaleQFB = 1.00;
scaleQFA = 1.00;
scaleQDA = 1.00;
scaleSFA = 1;
scaleSDA = 1;
scaleSFB = 1;
scaleSDB = 1;

% scale = 614.968/611.3;
scale = 0.999;

setsp('BEND',bendsp*scale*dipscale);
setsp('QDA',qdasp*scale*scaleQDA,'Hardware');
setsp('QFA',qfasp*scale*scaleQFA,'Hardware');
setsp('QFB',qfbsp*scale*scaleQFB,'Hardware');
setsp('SFA',sfasp*scale*scaleSFA,'Hardware');
setsp('SDA',sdasp*scale*scaleSDA,'Hardware');
setsp('SFB',sfbsp*scale*scaleSFB,'Hardware');
setsp('SDB',sdbsp*scale*scaleSDB,'Hardware');

temp= getsp('BEND','physics');
disp(temp(1))

