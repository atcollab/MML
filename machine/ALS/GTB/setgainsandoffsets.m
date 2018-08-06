function setgainsandoffsets

DisplayFlag = 0;

AO = getao;

if 0
    if 0
        % Base on the injection lattice
        [MagnetSetpoints, MagnetMonitors] = getinjectionlattice;

        % Fields to correct (All => fieldnames(MagnetSetpoints);)
        Fields = {
            %'HCM'
            %'VCM'
            'Q'
            'BEND'
            };
    else
        % Basic on a monmags file
        load([getfamilydata('Directory','OpsData'),'MagnetData.mat']);

        % Fields to correct (All => fieldnames(MagnetSetpoints);)
        Fields = {
            % 'HCM'
            % 'VCM'
            'Q'
            'BEND'
            };
    end


    % Set the monitors gain to match the MagnetSetpoints at the lattice values
    for i = 1:length(Fields)

        Gain = MagnetSetpoints.(Fields{i}).Setpoint.Data ./ mean(MagnetMonitors.(Fields{i}).Monitor.Data,2);

        % Gain (look for magnets that have been removed)
        AO.(Fields{i}).Monitor.Gain = ones(size(AO.(Fields{i}).DeviceList,1),1);
        j = findrowindex(MagnetSetpoints.(Fields{i}).Setpoint.DeviceList, AO.(Fields{i}).DeviceList);
        AO.(Fields{i}).Monitor.Gain(j) = Gain;

        % Offset is zero (for now)
        AO.(Fields{i}).Monitor.Offset = zeros(size(AO.(Fields{i}).DeviceList,1),1);
    end
else
    % Use linearity files
    Families = {'HCM','VCM','Q','BEND'};

    for j = 1:length(Families)
        Family = Families{j};
        load([Family,'_Linearity']);
        
        % Add the injection lattice
        [SPinj, AMinj] = getinjectionlattice;
        AMnew  = [];
        SPnew  = [];
        for i = 1:length(SPinj.(Family).Setpoint.Data)
            
            % Once new AM & SP matrices are measured, then include the DeviceList!!!!!!!!
            
            a = AMinj.(Family).Monitor.Data(i);
            b = SPinj.(Family).Setpoint.Data(i);
            k = max(find(b > SP(i,:)));
            AMnew(i,:) = [AM(i,1:k) a AM(i,k+1:end)];
            SPnew(i,:) = [SP(i,1:k) b SP(i,k+1:end)];
            
            % Row elements can't be the same for raw2real/real2raw to work properly
            k = find(diff(AMnew(i,:))==0);
            AMnew(i,k+1) = AMnew(i,k+1) + k*1e-12;
            
            k = find(diff(SPnew(i,:))==0);
            SPnew(i,k+1) = SPnew(i,k+1) + k*1e-12;
        end
        
        AM = AMnew;
        SP = SPnew;
        N = N + 1;
        
        % Add the whole SP-AM matrix to be used in getrunflag_gtb
        AO.(Family).Setpoint.SP_Table = SP;
        AO.(Family).Setpoint.AM_Table = AM;
        
        if DisplayFlag
            SPplot = SP;
            AMplot = AM;
        end

        if 1
            % Remove the first and last point (the min/max)
            SP = SP(:,2:end-1);
            AM = AM(:,2:end-1);
            N = N - 2;
        end

        for i = 1:length(SPinj.(Family).Setpoint.Data)
            A = [ones(N,1) SP(i,:)'];
            b = A \ AM(i,:)';
            AO.(Family).Monitor.Offset(i,1) = b(1);
            if abs(b(2)) < 1e-6
                % Gain is very small
                %AO.(Family).Monitor.Offset(i,1) = 0;
                AO.(Family).Monitor.Gain(i,1) = 1;
            else
                AO.(Family).Monitor.Gain(i,1) = 1/b(2);
            end

            % Display
            if DisplayFlag
                AMcal = AO.(Family).Monitor.Gain(i,1) * AMplot(i,:) - AO.(Family).Monitor.Offset(i,1);
                subplot(2,1,1);
                SPvec = linspace(SPplot(i,1), SPplot(i,end), 100);
                plot(SPvec, SPvec, 'g');
                title(family2common(Family, AO.(Family).DeviceList(i,:)), 'interpret','none');
                hold on;
                plot(SPplot(i,:), AMcal,'.b')
                plot(SPplot(i,:), AMplot(i,:),'.r')
                hold off;
                subplot(2,1,2);
                plot(SPplot(i,:), SPplot(i,:)-AMcal,'.b');
                ylabel('Error');
                pause;
            end
        end
    end
end

setao(AO);