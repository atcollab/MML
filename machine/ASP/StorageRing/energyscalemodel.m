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

lowda = 78;
lowfa = 138;
lowfb = 119.5;

highda = 81;
highfa = 139;
highfb = 120.5;

tda = 5;
tfa = 5;
tfb = 5;

incda = (highda-lowda)/tda;
incfa = (highfa-lowfa)/tfa;
incfb = (highfb-lowfb)/tfb;

array = ones(tda,tfa,tfb);

da=lowda;
fa=lowfa;
fb=lowfb;

countda=1;
countfa=1;
countfb=1;

Rmeas = getbpmresp('numeric');

while(countda<=tda)    
    setsp('QDA',da,'model','Hardware'); %80.55
    countda = countda +1;
    da = lowda +countda*incda;
    disp('***RUNNING***');
    disp(((tda*tfa*tfb)-((countda-2)*(tfa*tfb)))*2);
    disp('seconds remaining');
    countfa = 1;
    while(countfa<=tfa)
        setsp('QFA',fa,'model','Hardware'); %138.63
        countfa = countfa +1;
        fa = lowfa +countfa*incfa;
        countfb=1;
        while(countfb<=tfb)
            setsp('QFA',fb,'model','Hardware'); %120.43
            countfb = countfb +1;
            fb = lowfb +countfb*incfb;
            
            Rmod = measbpmresp('model','numeric');
            avedif = mean(mean(abs(Rmod-Rmeas)));
            array(countda-1,countfa-1,countfb-1) = avedif;
        end
    end
end


[Y1 I1] = min(array);          
[Y2 I2] = min(Y1);
[Y3 I3] = min(Y2);

disp('min')
array(I1(I2(I3)),I2(I3),I3)
disp('at')

I1(I2(I3))
I2(I3)
I3  
   



 

