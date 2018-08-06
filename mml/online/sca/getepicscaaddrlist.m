function [AddrList, Port] = getepicscaaddrlist
%GETEPICSCAADDRLIST - Returns the environmental varible EPICS_CA_ADDR_LIST
%  [AddrList, Port] = getepicscaaddrlist
%
%  See also setepicscaaddrlist

%  Written by Greg Portmann

AddrList = getenv('EPICS_CA_ADDR_LIST');

if nargout > 1
    Port = getenv('EPICS_CA_SERVER_PORT');
end