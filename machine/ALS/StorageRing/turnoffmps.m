function turnoffmps(Sector)
%TURNOFFMPS - Turn off all the storage ring magnet power supplies
%
%
%  See also turnonmps


% To do:
% 1. do one sector


% Get the BEND and SBEND energy, then srramp if Amps > 50
EnergyBEND  = bend2gev('BEND','Setpoint',getsp('BEND',[1 1]),[1 1]);
EnergySBEND = bend2gev('BEND','Setpoint',getsp('BEND',[4 2;8 2;12 2]),[4 2;8 2;12 2]);

if EnergyBEND < .1 && max(EnergySBEND)>.25
    % If the BEND is low and a superbend is high, srramp to zero will not work properly
    StartFlag = questdlg({sprintf('The normal BEND is at %.1f GeV and ',EnergyBEND),sprintf('Superbend is at %.1f GeV.  This w',EnergySBEND),' ','Turn off the SR magnet power supplies?'},'Turn Off','Yes','No','No');
    if strcmp(StartFlag,'No')
        fprintf('   Turning magnet power supplies off has been canceled.\n');
        return
    end
end

% Ramp to zero
if EnergyBEND > .1
    if max(getsp('BEND',[4 2;8 2;12 2])) == 0
        FailFlag = srramp(0, 'LinearByEnergy', 'NoSuperBend');
    else
        FailFlag = srramp(0, 'LinearByEnergy');
    end
    if FailFlag
        error('Ramping to zero failed, hence power supply turn off canceled.');
    end
end

% Get all magnet families
MPSFamilies = findmemberof('Magnet');

% Remove families
RemoveFamilyNames = {'HCMCHICANEM'};    % 'SQEPU','VCMCHICANE',
for i = 1:length(RemoveFamilyNames)
    j = find(strcmpi(RemoveFamilyNames{i}, MPSFamilies));
    MPSFamilies(j) = [];
end


% Turn off FF
setpv('ID', 'FFEnableControl', 0);
pause(.5);

% Zero the FF and Trim channels
setpv('HCM', 'Trim', 0);
setpv('VCM', 'Trim', 0);

setpv('HCM', 'FF1', 0);
setpv('HCM', 'FF2', 0);

setpv('VCM', 'FF1', 0);
setpv('VCM', 'FF2', 0);

setpv('QF', 'FF', 0);
setpv('QD', 'FF', 0);

setpv('SR04U___Q1FF___AC00', 0);
setpv('SR04U___Q2FF___AC00', 0);
setpv('SR04U___Q2M____AC00', 0);
setpv('SR11U___Q1FF___AC00', 0);
setpv('SR11U___Q2FF___AC00', 0);


% Double check that all magnets are at zero current
for i = 1:length(MPSFamilies)
    try
        setsp(MPSFamilies{i}, 0, [], 0);
    catch
    end
end
% Unfortunately the SP-AM comparison does not work well at zero current
% So test that the AM are not greater than ??? amps  (to be done!!!)
% for i = 1:length(MPSFamilies)
%     try
%         %setsp(MPSFamilies{i}, 0, [], -1);
%     catch
%     end
% end

% If not doing a WaitFlag=-1, then add some delay
% The correctors and chicanes are probably the only magnets stil ramping down
pause(10);

% Turn the magnet off
for i = 1:length(MPSFamilies)
    try    
        fprintf('   Turning off %s\n', MPSFamilies{i});
        setpv(MPSFamilies{i}, 'OnControl', 0);
    catch
        fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
        fprintf('   A problem occurred turning off %s!!!\n', MPSFamilies{i});
        fprintf('   %s\n', lasterr);
        fprintf('   Just moving on.  Operator attention required.\n');
        fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
    end
end



% if nargin < 1
%     FamilyNum = menu1('Which magnet family do you want to turn off?','HCM','VCM','QF','QD','QFA','SD','SF','BEND','Exit');
%     if FamilyNum == 1
%         Family = 'HCM';
%     elseif FamilyNum == 2
%         Family = 'VCM';
%     elseif FamilyNum == 3
%         Family = 'QF';
%     elseif FamilyNum == 4
%         Family = 'QD';
%     elseif FamilyNum == 5
%         Family = 'QFA';
%     elseif FamilyNum == 6
%         Family = 'SF';
%     elseif FamilyNum == 7
%         Family = 'SD';
%     elseif FamilyNum == 8
%         Family = 'BEND';
%     elseif FamilyNum == 9
%         return;
%     else
%         error([Family,' not defined.']);
%     end
% end

