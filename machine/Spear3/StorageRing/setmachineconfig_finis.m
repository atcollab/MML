%  setmachineconfig_finis
%  additional instructions after setmachineconfig
%  NOTE: this program is a script (not a function) to inherit variables
%  from setmachineconfig
%
%
%  update setpoints on correctors used for SPEAR 3 beamline feed forward system 
%  Setpoint = ConfigSetpoint.HCMCurrReference.Setpoint + delta(CurrReference)
%    where delta(CurrReference) = CurrReference(now) – CurrReference(config)
%
%   CurrReference(now) are the present CurrReference values in the ioc's
%   CurrReference(config) are the CurrReference values stored in ConfigMonitor
%
%   for further documentation see /machine/spear3/docs/setconfig_feedforward_code.doc
%
%   J. Corbett   May 17, 2006


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%        Update Setpoints for CurrReference            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('   Begin setmachineconfig_finis...')
ao=getao;
if ~exist('ConfigMonitor','var')
    disp('   Warning: ConfigMonitor not input to setmachineconfig_finis, CurrReference values not set')
    %note ConfigMonitor is loaded in setmachineconfig ~line 153    load([DirectoryName FileName]);
    return
end

if isfield(ao,'HCMCurrReference') & isfield(ao,'VCMCurrReference')& isfield(ConfigMonitor,'HCMCurrReference')& isfield(ConfigMonitor,'VCMCurrReference') 
disp('   Setting Horizontal and Vertical Corrector CurrReference values...')
% HCM's
% acquire HCM setpoint values
HCMSPData=getsp('HCM',getlist('HCMCurrReference'));
% acquire present CurrReference values (note: AO.HCMCurrReference.Monitor.ChannelNames contains Setpoint pv's)
HCMCRData_now=getam('HCMCurrReference');
% extract CurrReference values from configuration file
HCMCRData_cnf=ConfigMonitor.HCMCurrReference.Monitor.Data;
% calculate new HCM setpoint
Setpoint(:,1)=HCMSPData + HCMCRData_now - HCMCRData_cnf;

% VCM's
% acquire VCM setpoint values
VCMSPData=getsp('VCM',getlist('VCMCurrReference'));
% acquire present CurrReference values (note: AO.VCMCurrReference.Monitor.ChannelNames contains Setpoint pv's)
VCMCRData_now=getam('VCMCurrReference');
% extract CurrReference values from configuration file
VCMCRData_cnf=ConfigMonitor.VCMCurrReference.Monitor.Data;
% calculate new HCM setpoint
Setpoint(:,2)=VCMSPData + VCMCRData_now - VCMCRData_cnf;

%update correctors for CurrReference values
familynames={'HCM' 'VCM'};
devlistnames={'HCMCurrReference' 'VCMCurrReference'};

% Make the setpoint change w/o a WaitFlag
for k = 1:size(familynames,2)
    try
        if DisplayFlag 
            Time = clock;
            %fprintf('   Setting family %s (%s %d:%d:%.2f)\n', familynames{k}, datestr(clock,1), Time(4), Time(5), Time(6));
            fprintf('   %s %d:%d:%.2f Setting family %s.%s\n', datestr(clock,1), Time(4), Time(5), Time(6), familynames{k}, 'Setpoint');
            drawnow;
        end
        disp('   Updating corrector values to compensate CurrReference without wait flag')
        setpv(familynames{k},'Setpoint', Setpoint(:,k), getlist(devlistnames{k}), 0, InputFlags{:});
    catch
        fprintf('%s\n', lasterr)
        fprintf('Trouble with setpv(''%s'',''%s''), hence ignored (setmachineconfig_currref)\n', familynames{k}, 'Setpoint');
    end
end


% Make the setpoint change with a WaitFlag
if WaitFlag ~= 0 
    try
        if DisplayFlag 
            fprintf('   Waiting for Setpoint-Monitor to be within tolerance\n');
            drawnow;
        end
        for k = 1:2
            try
                disp('   Updating corrector values for CurrReference with wait flag')
                setpv(familynames{k},'Setpoint',Setpoint(:,k),getlist(devlistnames{k}), WaitFlag, InputFlags{:});
            end
        end
        if DisplayFlag 
            Time = clock;
            fprintf('   %s %d:%d:%.2f CurrReference update complete (setmachineconfig_finis)\n\n', datestr(clock,1), Time(4), Time(5), Time(6));
            drawnow;
        end
    catch
        fprintf('%s\n', lasterr)
        fprintf('Error occurred waiting for Setpoint-Monitor comparison in setmachineconfig_finis.\n');
        fprintf('Lattice is in an unknown state! (setmachineconfig_finis)\n\n');
    end
end

end  %end condition CurrReference Families exist in AO and in configuration


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              IDTrims               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%replace IDTrim setpoints with value in found in CurrReference
%NOTE: IDTrim setpoints are
if isfield(ao,'IDTrim') && isfield(ConfigMonitor,'IDTrim')
    disp('   Setting IDTrim values...')
    try
        IDTrimCurrRef=getpv('IDTrim','CurrRef');
        setpv('IDTrim','SetpointName',IDTrimCurrRef);
    catch
        fprintf('%s\n', lasterr)
        fprintf('Error occurred trying to update ID Trims in setmachineconfig_currref.\n');
        fprintf('Lattice is in an unknown state! (setmachineconfig_currref)\n\n');
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         Load Setpoint into Des Fields             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Make the setpoint change w/o a WaitFlag
if ~isempty(strfind(FileName,'GoldenConfig'))
    disp('   *** GoldenConfig: Desired fields will be updated to Setpoint values...')
    for k = 1:length(SPcell)
        if isfield(ao.(SPcell{k}.FamilyName),'Desired')   %look to see if family has 'Desired' field
            SPcell{k}.Field='Desired';                    %make 'Desired' the field to set. Don't need to update channelnames
            try
                if DisplayFlag
                    Time = clock;
                    %fprintf('   Setting family %s (%s %d:%d:%.2f)\n', SPcell{k}.FamilyName, datestr(clock,1), Time(4), Time(5), Time(6));
                    fprintf('   %s %d:%d:%.2f Setting family %s.%s\n', datestr(clock,1), Time(4), Time(5), Time(6), SPcell{k}.FamilyName, SPcell{k}.Field);
                    drawnow;
                end
                setpv(SPcell{k}, 0, InputFlags{:});
            catch
                fprintf('%s\n', lasterr)
                fprintf('Trouble with setpv(''%s'',''%s''), hence ignored (setmachineconfig)\n', SPcell{k}.FamilyName, SPcell{k}.Field);
            end
        end  %end condition on Desired in AO Family
    end   %end for loop
end %end GoldenConfig condition


