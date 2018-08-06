function [BPMFamilyOutput, BPMDevOutput, DeltaSpos, PhaseAdvanceX, PhaseAdvanceY] = quad2bpm(QUADFamily, QUADDev, LocationFlag)
%QUAD2BPM - Returns the nearest BPM to the specified quadrupole
%  [BPMFamily, BPMDeviceList, DeltaSpos, PhaseAdvanceX, PhaseAdvanceY] = quad2bpm(QUADFamily, QUADDev, LocationFlag)
%
%  INPUTS
%  1. QUADFamily - Quadrupole family (1 family only (row string))
%  2. QUADDeviceList - Quadrupole device list
%  3. LocationFlag - Only search BPM positions that are 'UpStream' or 'DownStream' {Default for transport lines} 
%                    of the quadrupole.  Else no location preference is used {Default for rings}.
%
%  OUTPUTS
%  1. BPMFamily
%  2. BPMDeviceList
%  3. DeltaSpos - Distance from the Quad to the BPM   
%  4. PhaseAdvanceX - Horizontal phase advance from the quadrupole to the BPM (using the model) [radians]
%  5. PhaseAdvanceY - Vertical   phase advance from the quadrupole to the BPM (using the model) [radians]
%
%  Also see bpm2quad

%  Written by Gregory J. Portmann
%  Modified by Laurent S. Nadolski


if nargin < 1
    QUADFamily = '';
end
if isempty(QUADFamily)
    QUADFamily = findmemberof('QUAD');
    QUADFamily = QUADFamily{1};
end

if nargin < 2
    QUADDev = [];
end
if isempty(QUADDev)
    QUADDev = family2dev(QUADFamily);
    QUADDev = QUADDev(1,:);
end

if nargin < 3
    LocationFlag = '';
end

if isempty(LocationFlag)
    %if any(strcmpi(getfamilydata('MachineType'), {'Transport','Transportline','Linac'}))
    %    LocationFlag = 'DownStream';
    %else
        LocationFlag = 'Any';
    %end
end


% Get all the BPM families
%BPMFamilyList = getfamilylist;
%[tmp, i] = ismemberof(BPMFamilyList, 'BPM');
%if ~isempty(i)
%    BPMFamilyList = BPMFamilyList(i,:);
%else
    BPMFamilyList = [gethbpmfamily; getvbpmfamily];
%end


% Find the BPM next to the Quad
BPMFamilyOutput = [];
for k = 1:size(QUADDev,1)
    QUADspos  = getspos(QUADFamily, QUADDev(k,:));
    
    if nargout >= 4
        ATIndex = family2atindex(QUADFamily, QUADDev(k,:));
        [PhiQx,  PhiQy] = modeltwiss('Phase', 'All');
        i = findrowindex(ATIndex, (1:length(PhiQx))');
        PhiQx = (PhiQx(i) + PhiQx(i+1))/2;
    end

    
    Del = inf;
    for j = 1:size(BPMFamilyList,1)
        Family = deblank(BPMFamilyList(j,:));
        BPMDevList = family2dev(Family);
        BPMspos    = getspos(Family);
        
        if strcmpi(LocationFlag, 'DownStream')
            i = find(abs(BPMspos-QUADspos)==min(abs(BPMspos-QUADspos)) & BPMspos>QUADspos);
        elseif strcmpi(LocationFlag, 'UpStream')
            i = find(abs(BPMspos-QUADspos)==min(abs(BPMspos-QUADspos)) & BPMspos<QUADspos);
        else
            i = find(abs(BPMspos-QUADspos)==min(abs(BPMspos-QUADspos)));
        end

        BPMDev{j} = BPMDevList(i,:);
        
        if abs(BPMspos(i)-QUADspos) < Del
            BPMFamilyMin = Family;
            BPMDevMin = BPMDev{j};        
            Del = abs(BPMspos(i)-QUADspos);
            DelwithSign = BPMspos(i)-QUADspos;
        end
    end
    
    BPMFamilyOutput = strvcat(BPMFamilyOutput, BPMFamilyMin);
    BPMDevOutput(k,:) = BPMDevMin;        
    DeltaSpos(k,1) = DelwithSign;
    
    
    % Get the phase advance between the BPM and Quad in the model
    if nargout >= 4
        [PhiX,   PhiY]  = modeltwiss('Phase', BPMFamilyOutput, BPMDevOutput(k,:));
        PhaseAdvanceX = PhiX - PhiQx;
    end
    if nargout >= 5
        PhaseAdvanceY = PhiY - PhiQy;
    end
end



