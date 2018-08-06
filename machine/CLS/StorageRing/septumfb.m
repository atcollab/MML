
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/septumfb.m 1.2 2007/03/02 09:18:07CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

Hdac = mcaisopen('PS2401-06:0:dac');
if Hdac == 0
    Hdac = mcaopen('PS2401-06:0:dac');
    if Hdac == 0
        error('Error opening PS2401-06:0:dac');
    end
end
Hadc = mcaisopen('PS2401-06:0:adc');
if Hadc == 0
    Hadc = mcaopen('PS2401-06:0:adc');
    if Hadc == 0
        error('Error opening PS2401-06:0:adc');
    end
end


ADCGoal = 8665;
ADC_DAC_Ratio = .01874;
N = 20;

for i = 1:500
    ADCavg = 0;
    for j = 1:N
        ADCavg = ADCavg + mcaget(Hadc)/N;
        pause(.25);
    end
    %ADCavg 
    DAC = mcaget(Hdac);
    (ADCGoal-ADCavg)/ADC_DAC_Ratio
    DACnew = DAC + .3*(ADCGoal-ADCavg)/ADC_DAC_Ratio;
    mcaput(Hdac,DACnew);
    pause(1);
end
    
% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/septumfb.m  $
% Revision 1.2 2007/03/02 09:18:07CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
  
