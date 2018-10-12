close all
% 0 = both planes; 1 = x-plane; 2 = y-plane
plane = 2;


% Sector number for BPM
for i=3
    % BPM number within the sector
    for j=3
        
        BPMDev = [i  j];

%         if getfamilydata('BPMx','Status',BPMDev) == 0
%             continue;
%         end
        
        switch BPMDev(2)
            case 1
                quadfam = 'SFA';
                quaddev = [BPMDev(1) 1];
            case 2
                quadfam = 'SDA';
                quaddev = [BPMDev(1) 1];
            case 3
                quadfam = 'SDB';
                quaddev = [BPMDev(1) 1];
            case 4
                quadfam = 'SFB';
                quaddev = [BPMDev(1) 1];
            case 5
                quadfam = 'SDB';
                quaddev = [BPMDev(1) 2];
            case 6
                quadfam = 'SDA';
                quaddev = [BPMDev(1) 2];
            case 7
                quadfam = 'SFA';
                quaddev = [BPMDev(1) 2];
        end
        
        quadcenter(quadfam,quaddev,plane,BPMDev);
    end
end

beep
return
