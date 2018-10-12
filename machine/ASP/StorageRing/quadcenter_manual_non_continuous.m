close all
% 0 = both planes; 1 = x-plane; 2 = y-plane
plane = 0;

sector = [4 4 5]; % sector number
BPM_num = [6 7 1]; % BPM number eg 1:7

% Sector number for BPM
for h=1:length(sector)
    i=sector(h);
    % BPM number within the sector
    %for j=BPM_num
    j=BPM_num(h);
            if i == 10 && j == 5
                continue;
            else
                BPMDev = [i  j];

        %         if getfamilydata('BPMx','Status',BPMDev) == 0
        %             continue;
        %         end

                switch BPMDev(2)
                    case {1 2}
                        quadfam = 'QFA';
                        quaddev = [BPMDev(1) 1];
                    case 3
                        quadfam = 'QDA';
                        quaddev = [BPMDev(1) 1];
                    case 4
                        quadfam = 'QFB';
                        quaddev = [BPMDev(1) 2];
                    case 5
                        quadfam = 'QDA';
                        quaddev = [BPMDev(1) 2];
                    case {6 7}
                        quadfam = 'QFA';
                        quaddev = [BPMDev(1) 2];
                end


                quadcenter(quadfam,quaddev,plane,BPMDev);
            end
    %end
end

beep
return
