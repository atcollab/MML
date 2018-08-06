function anaphase2bpm

    DirectoryName = getfamilydata('Directory','BPMData');
    Filename = uigetfile(DirectoryName);
 
    
    if  isequal(FileName,0)
       disp('User pressed cancel')
       return;
    else
        a = load(fullfile(DirectoryName, Filename));
        AM = getfield(a, 'AM');
        bpmlist = dev2elem('BPMx',AM.DeviceList);
    end
 
%%
  i1=50;
  i2=200;
  
 x1 = AM.Data.X(1,i1:i2);
 x2 = AM.Data.X(2,i1:i2);
 
 x = x1;

 phi1 = modelphase('BPMx',[12 1]);
 phi2 = modelphase('BPMx',[14 1]);
 psi = -(phi2 - phi1); 
 beta1 = modelbeta('BPMx',[12 1]);
 beta2 = modelbeta('BPMx',[14 1]);
 alpha1 = modeltwiss('alpha','BPMx',[12 1]);
 
 xp = x2/sin(psi)/sqrt(beta1*beta2) - (alpha1 + cot(psi))/beta1*x1;
 plot(x,xp,'.')
 grid on
 