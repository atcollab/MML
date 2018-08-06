function Test = istransport
%ISTRANSPORT - Is this a transport line or linac?
%
%  See also isstoragering, isbooster, ismachine


MachineType = getfamilydata('MachineType');

Test = any(strcmpi(MachineType, {'Transport','TransportLine','Transport Line','Linac'}));
