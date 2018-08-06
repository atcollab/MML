function [QUADFamilyOutput, QUADDevOutput, DeltaSpos, PhaseAdvance] = bpm2quad(BPMFamily, BPMDev, LocationFlag)
%BPM2QUAD - Returns the nearest quadrupole to the specified BPM
%  [QUADFamily, QUADDeviceList, DeltaSpos, PhaseAdvance] = bpm2quad(BPMFamily, BPMDeviceList, LocationFlag)
%
%  INPUTS
%  1. BPMFamily - BPM family (1 family only (row string))
%  2. BPMDeviceList - BPM device list
%  3. LocationFlag - Only search quadrupole positions that are 'UpStream' or 'DownStream' {Default for transport lines} 
%                    of the BPM.  Else no location preference is used {Default for rings}.
%
%  OUTPUTS
%  1. QUADFamily
%  2. QUADDeviceList
%  3. DeltaSpos - Distance from the BPM to the Quad  
%  4. PhaseAdvance - Phase advance from the BPM to the quadrupole (using the model) [radians]
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
    BPMDev = family2dev(BPMFamily);
    BPMDev = BPMDev(1,:);
end

if nargin < 3
    LocationFlag = '';
end
if isempty(LocationFlag)
    if any(strcmpi(getfamilydata('MachineType'), {'Transport','Transportline','Linac'}))
        LocationFlag = 'UpStream';
    else
        LocationFlag = 'Any';
    end
end


% Get all the quad families
QUADFamilyList = getfamilylist;
[tmp, i] = ismemberof(QUADFamilyList, 'QUAD');
if ~isempty(i)
    QUADFamilyList = QUADFamilyList(i,:);
else
    QUADFamilyList = ['QF','QD'];
end


% Find the Quad next to the BPM
QUADFamilyOutput = [];
for k = 1:size(BPMDev,1)
    BPMspos  = getspos(BPMFamily, BPMDev(k,:));

    if nargout >= 4
        [PhiX,   PhiY]  = modeltwiss('Phase', BPMFamily, BPMDev(k,:));
    end

    Del = inf;
    for j = 1:size(QUADFamilyList,1)
        Family = deblank(QUADFamilyList(j,:));
        QUADDevList = family2dev(Family);
        QUADspos  = getspos(Family);

        if strcmpi(LocationFlag, 'DownStream')
            i = find(abs(QUADspos-BPMspos)==min(abs(QUADspos-BPMspos)) & BPMspos<QUADspos);
        elseif strcmpi(LocationFlag, 'UpStream')
            i = find(abs(QUADspos-BPMspos)==min(abs(QUADspos-BPMspos)) & BPMspos>QUADspos);

        else
            i = find(abs(QUADspos-BPMspos)==min(abs(QUADspos-BPMspos)));
        end

        QUADDev{j} = QUADDevList(i,:);

        if abs(QUADspos(i)-BPMspos) < Del
            QUADFamilyMin = Family;
            QUADDevMin = QUADDev{j};        
            Del = abs(QUADspos(i)-BPMspos);
            DelwithSign = QUADspos(i)-BPMspos;
        end
    end
    
    QUADFamilyOutput = strvcat(QUADFamilyOutput, QUADFamilyMin);
    QUADDevOutput(k,:) = QUADDevMin;        
    DeltaSpos(k,1) = DelwithSign;

    
    % Get the phase advance between the BPM and Quad in the model
    if nargout >= 4
        ATIndex = family2atindex(QUADFamilyOutput, QUADDevOutput(k,:));
        [PhiQx,  PhiQy] = modeltwiss('Phase', 'All');
        i = findrowindex(ATIndex, (1:length(PhiQx))');
        PhiQx = (PhiQx(i) + PhiQx(i+1))/2;

        PhaseAdvance = PhiQx - PhiX;
    end
end

