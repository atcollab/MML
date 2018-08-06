function [BPMFamilyOutput, BPMDevOutput, DeltaSpos] = sext2bpm(SEXTFamily, SEXTDev)
%SEXT2BPM - Returns the nearest BPM to the specified sextupole
%  [BPMFamily, BPMDeviceList, DeltaSpos] = sext2bpm(SEXTFamily, SEXTDev)
%
%  INPUTS
%  1. SEXTFamily - Quadrupole family (1 family only (row string))
%  2. SEXTDeviceList - Quadrupole device list
%
%  OUTPUTS
%  1. BPMFamily
%  2. BPMDeviceList
%  3. DeltaSpos - Distance from the Quad to the BPM   

%  Written by Greg Portmann


if nargin < 1
    SEXTFamily = 'SF';
end
if nargin < 2
    SEXTDev = family2dev(SEXTFamily);
end



% Get all the BPM families
BPMFamilyList = getfamilylist;
[tmp, i] = ismemberof(BPMFamilyList, 'BPM');
if ~isempty(i)
    BPMFamilyList = BPMFamilyList(i,:);
else
    BPMFamilyList = ['BPMx','BPMy'];
end


% Find the BPM next to the Quad
BPMFamilyOutput = [];
for k = 1:size(SEXTDev,1)
    SEXTspos  = getspos(SEXTFamily, SEXTDev(k,:));
    
    Del = inf;
    for j = 1:size(BPMFamilyList,1)
        Family = deblank(BPMFamilyList(j,:));
        BPMDevList = getlist(Family);
        BPMspos    = getspos(Family);
        
        i = find(abs(BPMspos-SEXTspos)==min(abs(BPMspos-SEXTspos)));
        BPMDev{j} = BPMDevList(i,:);
        
        if abs(BPMspos(i)-SEXTspos) < Del
            BPMFamilyMin = Family;
            BPMDevMin = BPMDev{j};        
            Del = abs(BPMspos(i)-SEXTspos);
            DelwithSign = BPMspos(i)-SEXTspos;
        end
    end
    
    BPMFamilyOutput = strvcat(BPMFamilyOutput, BPMFamilyMin);
    BPMDevOutput(k,:) = BPMDevMin;        
    DeltaSpos(k,1) = DelwithSign;
end