function printConfig
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/printConfig.m 1.2 2007/03/02 09:03:21CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

%get the current setpoints
[ConfigSetpoint, ConfigMonitor] = getclsconfig;

%loop through and print out the ConfigSetPoint structure
bend = isfield(ConfigSetpoint,'BEND');
qfa = isfield(ConfigSetpoint,'QFA');
qfb = isfield(ConfigSetpoint,'QFB');
qfc = isfield(ConfigSetpoint,'QFC');
hcm = isfield(ConfigSetpoint,'HCM');
vcm = isfield(ConfigSetpoint,'VCM');
sd = isfield(ConfigSetpoint,'SD');
sf = isfield(ConfigSetpoint,'SF');
btsbend = isfield(ConfigSetpoint,'BTSBEND');
btskick = isfield(ConfigSetpoint,'BTSKICK');
btsquads = isfield(ConfigSetpoint,'BTSQUADS');
btsscrape = isfield(ConfigSetpoint,'BTSSCRAPE');
btssept = isfield(ConfigSetpoint,'BTSSEPT');
btssteer = isfield(ConfigSetpoint,'BTSSTEER');


if(~bend) fprintf('Unable to retrieve BEND data ...skipping\n'); end     
if(~qfa) fprintf('Unable to retrieve QFA data ...skipping\n'); end     
if(~qfb) fprintf('Unable to retrieve QFB data ...skipping\n'); end     
if(~qfc) fprintf('Unable to retrieve QFC data ...skipping\n'); end     
if(~sd) fprintf('Unable to retrieve SD data ...skipping\n'); end     
if(~sf) fprintf('Unable to retrieve SF data ...skipping\n'); end     
if(~hcm) fprintf('Unable to retrieve HCM data ...skipping\n'); end     
if(~vcm) fprintf('Unable to retrieve VCM data ...skipping\n'); end     

if(~btsbend) fprintf('Unable to retrieve BTSBEND data ...skipping\n'); end   
if(~btskick) fprintf('Unable to retrieve BTSKICK data ...skipping\n'); end   
if(~btsquads) fprintf('Unable to retrieve BTSQUADS data ...skipping\n'); end   
if(~btsscrape) fprintf('Unable to retrieve BTSSCRAPE data ...skipping\n'); end   
if(~btssept) fprintf('Unable to retrieve BTSSEPT data ...skipping\n'); end   
if(~btssteer) fprintf('Unable to retrieve BTSSTEER data ...skipping\n'); end   



for i=1:24
    if(bend) 
        fprintf('BEND[%d] = %10.10f\n',i,ConfigSetpoint.BEND.Data(i))
    end 
end    

fprintf('\n')


for i=1:48
            if(hcm)
                fprintf('HCM[%d] = %10.10f \n',i,ConfigSetpoint.HCM.Data(i)) 
            end
end
fprintf('\n')


for i=1:48
            if(vcm) 
                fprintf('VCM[%d] = %10.10f\n',i,ConfigSetpoint.VCM.Data(i)) 
            end
end
fprintf('\n')




for i=1:24
        if(qfa) 
            fprintf('QFA[%d] = %10.10f\n',i,ConfigSetpoint.QFA.Data(i))
        end    
        if(qfb)
            fprintf('QFB[%d] = %10.10f\n',i,ConfigSetpoint.QFB.Data(i))
        end
        if(qfc)
            fprintf('QFC[%d] = %10.10f\n',i,ConfigSetpoint.QFC.Data(i))
        end
end
fprintf('\n')

for i=1:12
   if(sd)
       fprintf('SD[%d] = %10.10f\n',i,ConfigSetpoint.SD.Data(i))  
   end    
   if(sf)
       fprintf('SF[%d] = %10.10f\n',i,ConfigSetpoint.SF.Data(i))   
   end

end

fprintf('\n')

i = 1;
if(btsbend)
       fprintf('BTSBEND[%d] = %10.10f\n',i,ConfigSetpoint.BTSBEND.Data(i))  
end    
     
fprintf('\n')
for i=0:3
   if(btskick)
       fprintf('BTSKICK[%d]HV = %10.10f\n',i,ConfigSetpoint.BTSKICK.Data(i*4 + 1))  
       fprintf('BTSKICK[%d]:delay:ns = %10.10f\n',i,ConfigSetpoint.BTSKICK.Data(i*4 + 2))  
       fprintf('BTSKICK[%d]:onoff = %10.10f\n',i,ConfigSetpoint.BTSKICK.Data(i* 4 + 3))  
       fprintf('BTSKICK[%d]:thyratron = %10.10f\n',i,ConfigSetpoint.BTSKICK.Data(i*4 + 4))  
   end    
end 
fprintf('\n')
for i=1:5
   if(btsquads)
       fprintf('BTSQUADS D[%d] = %10.10f\n',i,ConfigSetpoint.BTSQUADS.Data(i))  
   end    
end 

fprintf('\n')

for i=6:10
   if(btsquads)
       fprintf('BTSQUADS F[%d] = %10.10f\n',i,ConfigSetpoint.BTSQUADS.Data(i))  
   end    
end 
fprintf('\n')

for i=1:4
   if(btssteer)
       fprintf('BTSSTEER V[%d] = %10.10f\n',i,ConfigSetpoint.BTSSTEER.Data(i))  
   end    
end

fprintf('\n')
for i=5:8
   if(btssteer)
       fprintf('BTSSTEER H[%d] = %10.10f\n',i,ConfigSetpoint.BTSSTEER.Data(i))  
   end    
end
fprintf('\n')

if(btssept)
       fprintf('BTSSEPT 1400[%d] = %10.10f\n',1,ConfigSetpoint.BTSSEPT.Data(1))  
       fprintf('BTSSEPT 1400[%d]:delay:ns = %10.10f\n',2,ConfigSetpoint.BTSSEPT.Data(2))  
       fprintf('BTSSEPT 1401[%d] = %10.10f\n',3,ConfigSetpoint.BTSSEPT.Data(3))  
       
end    
   

fprintf('\n')
for i=1:3
   if(btsscrape)
       fprintf('BTSSCRAPE[%d] = %10.10f\n',i,ConfigSetpoint.BTSSCRAPE.Data(i))  
   end    
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/printConfig.m  $
% Revision 1.2 2007/03/02 09:03:21CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
