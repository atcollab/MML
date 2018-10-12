% close all
% 0 = both planes; 1 = x-plane; 2 = y-plane
plane = 0;


sector = [8]; % sector number eg 1:14 or 5
BPM_num = [1:7]; % BPM number eg 1:7

% Turn on to furn BBA with paired quadrupoles
paired = 0;

% Sector number for BPM
for i=sector
    % BPM number within the sector
    for j=BPM_num
    
%             if (i == 5 && j == 3) || (i == 11 && j == 5) % Measure BPM's 
               
            %elseif  i == 14 && j == 5 % Omit any BPM's that are not working
                 
            
                BPMDev = [i  j];

        %         if getfamilydata('BPMx','Status',BPMDev) == 0
        %             continue;
        %         end

                switch BPMDev(2)
                    case {1 2}
                        quadfam = 'QFA';
                        if ~paired
                            quaddev = [BPMDev(1) 1];
                        else
                            if BPMDev(1) == 1
                                quaddev = [14 2; BPMDev(1) 1];
                            else
                                quaddev = [BPMDev(1)-1 2; BPMDev(1) 1];
                            end
                        end
                    case 3
                        quadfam = 'QDA';
                        quaddev = [BPMDev(1) 1];
                    case 4
                        quadfam = 'QFB';
                        if ~paired
                            quaddev = [BPMDev(1) 2];
                        else
                            quaddev = [BPMDev(1) 1; BPMDev(1) 2];
                        end
                    case 5
                        quadfam = 'QDA';
                        quaddev = [BPMDev(1) 2];
                    case {6 7}
                        quadfam = 'QFA';
                        if ~paired
                            quaddev = [BPMDev(1) 2];
                        else
                            if BPMDev(1) == 14
                                quaddev = [BPMDev(1) 2; 1 1];
                            else
                                quaddev = [BPMDev(1) 2; BPMDev(1)+1 1];
                            end
                        end
                end

                if ~paired
                    quadcenter(quadfam,quaddev,plane,BPMDev);
                else
                    quadcenter_eugene(quadfam,quaddev,plane,BPMDev);
                end
                
    end
end


for i = 1:4
    beep
    pause(1)
end