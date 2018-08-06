function clsTopUp(mAlowLimit, mAHiLimit, presLimit)

% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsTopUp.m 1.2 2007/03/02 09:02:28CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%   clsTopUp(mAlowLimit, mAHiLimit, presLimit)
%       mAlowLimit = lower limit of topup
%       mAHiLimit =  upper limit of topup
%       presLimit = limit of the vaccuum pressure on cells 2 and 12
%    EXAMPLE:
%    To keep the SR current between 94 and 95 mA AND keep below the VAC pressure 0.8e-7
%    you would type the following:
%
%    >>clsTopUp(94,95,.8e-7);
%
%
% ----------------------------------------------------------------------------------------------

[h numopen] = mcagethandle('TRG2400:enable:Gun');
if numopen == 0
     hGuntrig = mcaopen('TRG2400:enable:Gun');
     if hGuntrig == 0
         error(['Problem opening a channel to : TRG2400:enable:Gun']);
     end
 else
   hGuntrig = h(1);  
 end		

[h numopen] = mcagethandle('PCT1402-01:mA:fbk');
if numopen == 0
     hSrCrnt = mcaopen('PCT1402-01:mA:fbk');
     if hSrCrnt == 0
         error(['Problem opening a channel to : PCT1402-01:mA:fbk']);
     end
 else
     hSrCrnt = h(1);
 end		

[h numopen] = mcagethandle('CRYOSTAT:faultState');
if numopen == 0
     hCryoStatus = mcaopen('CRYOSTAT:faultState');
     if hCryoStatus == 0
         error(['Problem opening a channel to : CRYOSTAT:faultState']);
     end
 else
     hCryoStatus = h(1);
 end		

[h numopen] = mcagethandle('TRG2400:enable:Storage');
if numopen == 0
     hSrInjtrig = mcaopen('TRG2400:enable:Storage');
     if hSrInjtrig == 0
         error(['Problem opening a channel to : TRG2400:enable:Storage']);
     end
 else 
     hSrInjtrig = h(1);
 end		

[h numopen] = mcagethandle('CCG1402-01:vac:p');
if numopen == 0
     hSec02Pres = mcaopen('CCG1402-01:vac:p');
     if hSec02Pres == 0
         error(['Problem opening a channel to : CCG1402-01:vac:p']);
     end
 else 
     hSec02Pres = h(1);
 end		

[h numopen] = mcagethandle('CCG1412-01:vac:p');
if numopen == 0
     hSec12Pres = mcaopen('CCG1412-01:vac:p');
     if hSec12Pres == 0
         error(['Problem opening a channel to : CCG1412-01:vac:p']);
     end
 else 
     hSec12Pres = h(1);
 end		

 
 
 onmsgPrinted = 0;
 offmsgPrinted = 0;
 done = 0;
 while done < 1
     
     cryo=mcaget(hCryoStatus);
     
     
     if(cryo > 0 ) %fault
         %first turn off the gun
         mcaput(hGuntrig,0);
         pause(0.2);
         mcaput(hSrInjtrig,0);
    
         
         fprintf('SR RF Fault, shutting off injection\n');                  
         done = 1;
         break;
         
     else
         %system status good
         %check to see if already injecting
         gun=mcaget(hGuntrig);
         crnt = mcaget(hSrCrnt);
         s02Pressure = mcaget(hSec02Pres);
         s12Pressure = mcaget(hSec12Pres);
         %.5e-7
         if((crnt > mAHiLimit) | (s02Pressure > presLimit) | (s12Pressure > presLimit))
             %turn gun off 
             mcaput(hGuntrig,0);
             pause(0.05); %delay so that the first trig has time to complete before setting the srinj trig off
             mcaput(hSrInjtrig,0);
             
             if(offmsgPrinted < 1)
                 fprintf('Turning injection OFF\n');
                 offmsgPrinted = 1;
                 offmsgPrinted = 0;
             end  
             pause(3); 
         end    
         if(crnt < mAlowLimit + 1.)
             mcaput(hSrInjtrig,1);
             pause(1.0);
         end
         if(crnt < mAlowLimit)
             %turn gun on if not already
             if(gun < 1)
                 %turn gun on
                 if(onmsgPrinted < 1)
                     fprintf('Turning injection ON\n');                 
                     onmsgPrinted = 1;
                     offmsgPrinted = 0;
                 end    
                 mcaput(hGuntrig,1);
%                 pause(0.2);
%                 mcaput(hSrInjtrig,1);     
                
                 
             end
             %sleep on it for econd then check again
             
       end     
   end   
     fprintf('SrCurrent = %f, s02Pressure = %20.20f, s12Pressure = %20.20f\n',crnt,s02Pressure ,s12Pressure);
     pause(0.9);
 end %while     

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsTopUp.m  $
% Revision 1.2 2007/03/02 09:02:28CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
