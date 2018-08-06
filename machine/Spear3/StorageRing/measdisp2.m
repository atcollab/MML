drf=4;
DeltaRF=[-16:4:16]*1e-3;

%measure initial orbit
DispStruct.xref=getam('BPMx','struct');
DispStruct.yref=getam('BPMy','struct');

%measure initial rf
RF0=getrf;
DispStruct.rfref=RF0;

rfmode=1;

for k=1:length(deltaRF)
    
disp(['   Measuring orbit ' num2str(k) ' of ' num2str(length(deltaRF))])
%step rf frequency
        if rfmode
          fprintf('   Set RF frequency to %f MHz.    Step size is  %f MHz\n', RF0 + DeltaRF(k),drf);
          pause
        else
          %setrf(RF0 + DeltaRF(i), UnitsFlag, ModeFlag);
        end
        

%record rf frequency
DispStruct.rf(k)=getrf;

%record orbit
DispStruct.x(:,k)=getx;
DispStruct.y(:,k)=gety;
end
