function [Gain, Offset] = calcgainoffset
%CALCGAINOFFSET - Calculate the gain and offset of the analog monitors




%[SP1, AM1] = getinjectionlattice;


% Family = {'BEND', 'QFA'};
%Family = {'HCM', 'VCM'};
Family = {'QF', 'QD', 'QDA'};
%Family = {'SF', 'SD'};
%Family = {'SQSF', 'SQSD'};

MonmagsFlag = 0;

for i = 1:length(Family)

    if MonmagsFlag
        DirectoryName = getfamilydata('Directory','DataRoot');
        DirectoryName = [DirectoryName, 'Magnets', filesep];
        load([DirectoryName, 'magnetdata_2007-06-14_Production.mat']);
    else
        [MagnetSetpoints, MagnetMonitors] = getproductionlattice;
    end

    SP2 = MagnetSetpoints.(Family{i}).Setpoint.Data;
    AM2 = mean(MagnetMonitors.(Family{i}).Monitor.Data, 2);


    if MonmagsFlag
        DirectoryName = getfamilydata('Directory','DataRoot');
        DirectoryName = [DirectoryName, 'Magnets', filesep];
        load([DirectoryName, 'magnetdata_2007-06-12_Injection.mat']);
        %load([DirectoryName, 'magnetdata_2007-06-14_Injection.mat']);
        SP1 = MagnetSetpoints.(Family{i}).Setpoint.Data;
        AM1 = mean(MagnetMonitors.(Family{i}).Monitor.Data, 2);
    else
        [MagnetSetpoints, MagnetMonitors] = getinjectionlattice;
    end

    SP1 = MagnetSetpoints.(Family{i}).Setpoint.Data;
    AM1 = mean(MagnetMonitors.(Family{i}).Monitor.Data, 2);


    figure(MonmagsFlag+1);
    subplot(length(Family),1,i);
    plot(1:length(SP2), SP2-AM2, '.-b', 1:length(SP1), SP1-AM1, '.-r');
    ylabel(sprintf('%s  SP-AM [Amps]',Family{i}));
    
    
    figure(MonmagsFlag+1+2);
    subplot(length(Family),1,i);
    plot(1:length(SP2), SP2./AM2, '.-b', 1:length(SP1), SP1./AM1, '.-r');
    ylabel(sprintf('%s  AM Gain [Amps]',Family{i}));

    % Gain or Offset (not Gain/Offset!)
    Gain{i}   = mean([SP2./AM2 SP1./AM1],2);
    Offset{i} = mean([SP2-AM2 SP1-AM1],2);

end




figure(MonmagsFlag+1);
subplot(length(Family),1,1);
if MonmagsFlag
    title('Setpoint - Monitor Offset at the Production and Injection Lattices (monmags)');
else
    title('Setpoint - Monitor Offset at the Production and Injection Lattices');
end

subplot(length(Family),1,length(Family));
xlabel('Magnet Number');
orient tall


figure(MonmagsFlag+1+2);
subplot(length(Family),1,1);
if MonmagsFlag
    title('AM  Gain:  Setpoint = Gain * Monitor (monmags)');
else
    title('AM  Gain:  Setpoint = Gain * Monitor');
end

subplot(length(Family),1,length(Family));
xlabel('Magnet Number');
orient tall




