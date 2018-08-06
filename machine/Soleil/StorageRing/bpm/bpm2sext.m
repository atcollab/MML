function [SEXTFamilyOutput, SEXTDevOutput, DeltaSpos] = bpm2sext(BPMFamily, BPMDev)
%BPM2SEXT - Returns the nearest sextupole to the specified BPM
%  [SEXTFamily, SEXTDeviceList, DeltaSpos] = bpm2sext(BPMFamily, BPMDeviceList)
%
%  INPUTS
%  1. BPMFamily - BPM family (1 family only (row string))
%  2. BPMDeviceList - BPM device list
%
%  OUTPUTS
%  1. SEXTFamily
%  2. SEXTDeviceList
%  3. DeltaSpos - Distance from the BPM to the Quad  
%
%  Written by Greg Portmann


if nargin < 1
    BPMFamily = [];
end
if isempty(BPMFamily)
    BPMFamily = gethbpmfamily;
end
if nargin < 2
    BPMDev = [];
end
if isempty(BPMFamily)
    BPMDev = [1 1];  %family2dev(BPMFamily);
end


% Get all the sext families
SEXTFamilyList = getfamilylist;
[tmp, i] = ismemberof(SEXTFamilyList, 'SEXT');
if ~isempty(i)
    SEXTFamilyList = SEXTFamilyList(i,:);
else
    SEXTFamilyList = ['SF','SD'];
end


% Find the Quad next to the BPM
SEXTFamilyOutput = [];
for k = 1:size(BPMDev,1)
    BPMspos  = getspos(BPMFamily, BPMDev(k,:));
    
    Del = inf;
    for j = 1:size(SEXTFamilyList,1)
        Family = deblank(SEXTFamilyList(j,:));
        SEXTDevList = getlist(Family);
        SEXTspos  = getspos(Family);
        
        i = find(abs(SEXTspos-BPMspos)==min(abs(SEXTspos-BPMspos)));
        SEXTDev{j} = SEXTDevList(i,:);
        
        if abs(SEXTspos(i)-BPMspos) < Del
            SEXTFamilyMin = Family;
            SEXTDevMin = SEXTDev{j};        
            Del = abs(SEXTspos(i)-BPMspos);
            DelwithSign = SEXTspos(i)-BPMspos;
        end
    end
    
    SEXTFamilyOutput = strvcat(SEXTFamilyOutput, SEXTFamilyMin);
    SEXTDevOutput(k,:) = SEXTDevMin;        
    DeltaSpos(k,1) = DelwithSign;
end

