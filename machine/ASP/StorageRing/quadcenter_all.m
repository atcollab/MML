close all
% 0 = both planes; 1 = x-plane; 2 = y-plane
plane = 0;

% Sector number for BPM
for i=1:14
    % BPM number within the sector
    for j=1:7
        
        BPMDev = [i j];

        if getfamilydata('BPMx','Status',BPMDev) == 0
            continue;
        end
        
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
        
        QMS = quadcenterinit(quadfam,quaddev,plane,BPMDev);
        quadcenter(QMS);
    end
end


return




% % Possible method but maybe not as reliable
% plane = 2;
% 
% quadstruct(1).quadfam = 'QFA';
% quadstruct(1).quaddev = [];
% quadstruct(1).bpmdev = [];
% quadstruct(1).bpmelemind = [];
% quadstruct(2).quadfam = 'QDA';
% quadstruct(2).quaddev = [];
% quadstruct(2).bpmdev = [];
% quadstruct(2).bpmelemind = [];
% quadstruct(3).quadfam = 'QFB';
% quadstruct(3).quaddev = [];
% quadstruct(3).bpmdev = [];
% quadstruct(3).bpmelemind = [];
% % Sector number
% for i=13:13
%     % BPM number within the sector
%     for j=1:5
%         
%         BPMDev = [i j];
% 
%         switch BPMDev(2)
%             case {1 2}
%                 quadstruct(1).quadfam = 'QFA';
%                 quadstruct(1).quaddev(end+1,:) = [BPMDev(1) 1];
%                 quadstruct(1).bpmdev(end+1,:) = BPMDev;
%                 quadstruct(1).bpmelemind(end+1) = dev2elem('BPMx',BPMDev);
%             case 3
%                 quadstruct(2).quadfam = 'QDA';
%                 quadstruct(2).quaddev(end+1,:) = [BPMDev(1) 1];
%                 quadstruct(2).bpmdev(end+1,:) = BPMDev;
%                 quadstruct(2).bpmelemind(end+1) = dev2elem('BPMx',BPMDev);
%             case 4
%                 quadstruct(3).quadfam = 'QFB';
%                 quadstruct(3).quaddev(end+1,:) = [BPMDev(1) 2];
%                 quadstruct(3).bpmdev(end+1,:) = BPMDev;
%                 quadstruct(3).bpmelemind(end+1) = dev2elem('BPMx',BPMDev);
%             case 5
%                 quadstruct(2).quadfam = 'QDA';
%                 quadstruct(2).quaddev(end+1,:) = [BPMDev(1) 2];
%                 quadstruct(2).bpmdev(end+1,:) = BPMDev;
%                 quadstruct(2).bpmelemind(end+1) = dev2elem('BPMx',BPMDev);
%             case {6 7}
%                 quadstruct(1).quadfam = 'QFA';
%                 quadstruct(1).quaddev(end+1,:) = [BPMDev(1) 2];
%                 quadstruct(1).bpmdev(end+1,:) = BPMDev;
%                 quadstruct(1).bpmelemind(end+1) = dev2elem('BPMx',BPMDev);
%         end
%     end
% end
%     [qms1 qms2] = quadcenter(quadstruct(i).quadfam,quadstruct(i).quaddev,plane,quadstruct(i).bpmdev);
%     
%     switch plane
%         case 1
%             if isstruct(qms1)
%                 hoffsets(quadstruct(i).bpmelemind) = qms1.Center;
%             else
%                 hoffsets(quadstruct(i).bpmelemind) = qms1;
%             end
%         case 2
%             if isstruct(qms1)
%                 voffsets(quadstruct(i).bpmelemind) = qms1.Center;
%             else
%                 voffsets(quadstruct(i).bpmelemind) = qms1;
%             end
%         case 0
%             if isstruct(qms1)c
%                 hoffsets(quadstruct(i).bpmelemind) = qms1.Center;
%                 voffsets(quadstruct(i).bpmelemind) = qms2.Center;
%             else
%                 hoffsets(quadstruct(i).bpmelemind) = qms1;
%                 voffsets(quadstruct(i).bpmelemind) = qms2;
%             end
%     end
% end
% hoffsets = ones(98,1)*NaN;
% voffsets = ones(98,1)*NaN;
% 
% 
% for i=1:length(quadstruct)
%     [qms1 qms2] = quadcenter(quadstruct(i).quadfam,quadstruct(i).quaddev,plane,quadstruct(i).bpmdev);
%     
%     switch plane
%         case 1
%             if isstruct(qms1)
%                 hoffsets(quadstruct(i).bpmelemind) = qms1.Center;
%             else
%                 hoffsets(quadstruct(i).bpmelemind) = qms1;
%             end
%         case 2
%             if isstruct(qms1)
%                 voffsets(quadstruct(i).bpmelemind) = qms1.Center;
%             else
%                 voffsets(quadstruct(i).bpmelemind) = qms1;
%             end
%         case 0
%             if isstruct(qms1)c
%                 hoffsets(quadstruct(i).bpmelemind) = qms1.Center;
%                 voffsets(quadstruct(i).bpmelemind) = qms2.Center;
%             else
%                 hoffsets(quadstruct(i).bpmelemind) = qms1;
%                 voffsets(quadstruct(i).bpmelemind) = qms2;
%             end
%     end
% end
