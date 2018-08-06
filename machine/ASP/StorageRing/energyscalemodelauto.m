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
scaleQFB = 1;
scaleQFA = 1;
scaleQDA = 1;



Rmeas = getbpmresp('numeric');

setsp('QDA',79.55*scaleQFB,'model','Hardware'); %80.55
    
setsp('QFA',138.63*scaleQFA,'model','Hardware'); %138.63
        
setsp('QFA',120.43*scaleQDA,'model','Hardware'); %120.43
            
            
Rmod = measbpmresp('model','numeric');
avedif = mean(mean(abs(Rmod-Rmeas)))
array(countda-1,countfa-1,countfb-1) = avedif;
       

 

