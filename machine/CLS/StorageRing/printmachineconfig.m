function printConfig
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/printmachineconfig.m 1.2 2007/03/02 09:02:57CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

%get the current setpoints
[ConfigSetpoint, ConfigMonitor] = getmachineconfig;

%loop through and print out the ConfigSetPoint structure
bend = isfield(ConfigSetpoint,'BEND');
qfa = isfield(ConfigSetpoint,'QFA');
qfb = isfield(ConfigSetpoint,'QFB');
qfc = isfield(ConfigSetpoint,'QFC');
hcm = isfield(ConfigSetpoint,'HCM');
vcm = isfield(ConfigSetpoint,'VCM');
sd = isfield(ConfigSetpoint,'SD');
sf = isfield(ConfigSetpoint,'SF');


if(~bend) fprintf('Unable to retrieve BEND data ...skipping\n'); end     
if(~qfa) fprintf('Unable to retrieve QFA data ...skipping\n'); end     
if(~qfb) fprintf('Unable to retrieve QFB data ...skipping\n'); end     
if(~qfc) fprintf('Unable to retrieve QFC data ...skipping\n'); end     
if(~sd) fprintf('Unable to retrieve SD data ...skipping\n'); end     
if(~sf) fprintf('Unable to retrieve SF data ...skipping\n'); end     
if(~hcm) fprintf('Unable to retrieve HCM data ...skipping\n'); end     
if(~vcm) fprintf('Unable to retrieve VCM data ...skipping\n'); end     




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

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/printmachineconfig.m  $
% Revision 1.2 2007/03/02 09:02:57CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
