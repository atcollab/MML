function hwinit(varargin)
%HWINIT - Hardware initialization script


DisplayFlag = 1;
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end


% Increase drive high limit
%setpv('Slit1:M1:PCMD.DRVH', 150);
%setpv('Slit1:M2:PCMD.DRVH', 150);


% SpecBend1 EDM fix
setpv('SpecBend1:SupplyOn.ZSV',2);


% Solenoid Motors
% Sol1  4.0, 3.2, 6.3, 4.4, 3.3 
% So12  4.5, 5.5, 6.0, 4.1, 4.7


% Families ={
%     'HCM'
%     'VCM'
%     'EMHCM'
%     'EMVCM'
%     'Sol'
%     'Sol1Quad'
%     'Sol2Quad'
%     'Sol1SQuad'
%     'Sol2SQuad'
%     'Quad'
%     };
% 
% for i = 1:length(Families)
%     Dev   = family2dev(Families{i}, 1);
%     Names = family2channel(Families{i}, 'On', Dev);
%     for j = 1:length(Names)
%         setpvonline([Names{j}, '.ZSV'], 0);
%         setpvonline([Names{j}, '.OSV'], 0);
%     end
%     
%     Names = family2channel(Families{i}, 'BulkOn', Dev);
%     for j = 1:length(Names)
%        setpvonline([Names{j}, '.ZSV'], 2);
%        setpvonline([Names{j}, '.OSV'], 0);
%     end
%     
%     Names = family2channel(Families{i}, 'BulkOn', Dev);
%     for j = 1:length(Names)
%        setpvonline([Names{j}, '.ZSV'], 2);
%        setpvonline([Names{j}, '.OSV'], 0);
%     end
% 
%     Names = family2channel(Families{i}, 'BulkControl', Dev);
%     for j = 1:length(Names)
%         setpvonline([Names{j}, '.ZNAM'], 'Off');
%         setpvonline([Names{j}, '.ONAM'], 'On');
%     end
% end


%  ???
% try
% setpvonline('VVR1:Open.ONAM',   'Open');
% setpvonline('VVR1:Closed.ZNAM', 'Open');
% 
% setpvonline('VVR1:Open.ZNAM',   'Closed');
% setpvonline('VVR1:Closed.ONAM', 'Closed');
% 
% setpvonline('VVR2:Open.ONAM',   'Open');
% setpvonline('VVR2:Closed.ZNAM', 'Open');
% 
% setpvonline('VVR2:Open.ZNAM',   'Closed');
% setpvonline('VVR2:Closed.ONAM', 'Closed');
%  
% setpvonline('LaserShutter:Open.ONAM',   'Open');
% setpvonline('LaserShutter:Closed.ZNAM', 'Open');
% 
% setpvonline('LaserShutter:Open.ZNAM',   'Closed');
% setpvonline('LaserShutter:Closed.ONAM', 'Closed');
% 
% setpvonline('BeamDump:InPosition.ONAM',  'In');
% setpvonline('BeamDump:OutPosition.ZNAM', 'In');
% 
% setpvonline('BeamDump:InPosition.ZNAM',  'Out');
% setpvonline('BeamDump:OutPosition.ONAM', 'Out');
% 
% setpvonline('IFC:InPosition.ONAM',  'In');
% setpvonline('IFC:OutPosition.ZNAM', 'In');
% 
% setpvonline('IFC:InPosition.ZNAM',  'Out');
% setpvonline('IFC:OutPosition.ONAM', 'Out');
% catch
%     fprintf('   Error setting EPS .Fields\n');
% end


%zeroallpowersupplies;



% % Set LOPR correctly
% setpv('MPSol1:Setpoint.LOPR', -20);
% setpv('MPSol2:Setpoint.LOPR', -20);
% 
% setpv('HCM1:Setpoint.LOPR', -5);
% setpv('HCM2:Setpoint.LOPR', -5);
% setpv('HCM3:Setpoint.LOPR', -5);
% setpv('HCM4:Setpoint.LOPR', -5);
% 
% setpv('VCM1:Setpoint.LOPR', -5);
% setpv('VCM2:Setpoint.LOPR', -5);
% setpv('VCM3:Setpoint.LOPR', -5);
% setpv('VCM4:Setpoint.LOPR', -5);
% 
% setpv('Sol1:Setpoint.LOPR', -10);
% setpv('Sol2:Setpoint.LOPR', -10);
% %setpv('Sol3:Setpoint.LOPR', -10);
% 
% setpv('Sol1Quad1:Setpoint.LOPR', -2);
% setpv('Sol1Quad2:Setpoint.LOPR', -2);
% setpv('Sol2Quad1:Setpoint.LOPR', -2);
% %setpv('Sol2Quad2:Setpoint.LOPR', -2);
% 
% setpv('Sol1SQuad1:Setpoint.LOPR', -2);
% setpv('Sol1SQuad2:Setpoint.LOPR', -2);
% setpv('Sol2SQuad1:Setpoint.LOPR', -2);
% %setpv('Sol2SQuad2:Setpoint.LOPR', -2);
% 
% 
% % Set DRVH / DRVL correctly
% setpv('Sol1:Setpoint.DRVL', -10);
% setpv('Sol2:Setpoint.DRVL', -10);
% %setpv('Sol3:Setpoint.DRVL', -10);
% setpv('Sol1:Setpoint.DRVH', 10);
% setpv('Sol2:Setpoint.DRVH', 10);
% %setpv('Sol3:Setpoint.DRVH', 10);



function zeroallpowersupplies

% Set LOPR correctly
%setpv('MPSol1:Setpoint', 0);
%setpv('MPSol2:Setpoint', 0);

% EMHCM
% setpv('EMHCM1:Setpoint', 0);
% setpv('EMHCM2:Setpoint', 0);
% setpv('EMVCM1:Setpoint', 0);
% setpv('EMVCM2:Setpoint', 0);

setpv('HCM1:Setpoint', 0);
setpv('HCM2:Setpoint', 0);
setpv('HCM3:Setpoint', 0);
setpv('HCM4:Setpoint', 0);

setpv('VCM1:Setpoint', 0);
setpv('VCM2:Setpoint', 0);
setpv('VCM3:Setpoint', 0);
setpv('VCM4:Setpoint', 0);

setpv('Sol1:Setpoint', 0);
setpv('Sol2:Setpoint', 0);
%setpv('Sol3:Setpoint', 0);

setpv('Sol1Quad1:Setpoint', 0);
setpv('Sol1Quad2:Setpoint', 0);
setpv('Sol2Quad1:Setpoint', 0);
%setpv('Sol2Quad2:Setpoint', 0);

setpv('Sol1SQuad1:Setpoint', 0);
setpv('Sol1SQuad2:Setpoint', 0);
setpv('Sol2SQuad1:Setpoint', 0);
%setpv('Sol2SQuad2:Setpoint', 0);


