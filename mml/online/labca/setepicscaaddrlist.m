function setepicscaaddrlist(AddrList)
%SETEPICSCAADDRLIST - Sets the environmental varible EPICS_CA_ADDR_LIST
%  setepicscaaddrlist(AddrList)
%
%  NOTE
%  1. This function is worthless because you have the set the 
%     EPICS_CA_ADDR_LIST environmental variable before starting Matlab
%
%  See also getepicscaaddrlist

%  Written by Greg Portmann


if nargin == 0
    if strcmpi(getfamilydata('Machine'), 'ALS')
        ButtonName = questdlg('Only use EPICS server?','ALS','Yes','No','No');
        switch ButtonName
            case 'Yes'
                % EPICS server (no setpoint control)
                AddrList = '131.243.90.255'; 
            case 'No',
                % No EPICS server
                AddrList = '131.243.87.255 131.243.84.255 131.243.73.255 131.243.89.255';
        end
    else
        error('One input needed');
    end
end

setenv('EPICS_CA_ADDR_LIST', AddrList);

fprintf(2, 'setepicscaaddrlist is worthless because you have the set the EPICS_CA_ADDR_LIST env before starting Matlab.\n');
