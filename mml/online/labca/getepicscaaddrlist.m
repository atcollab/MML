function [AddrList, Port, MAX_ARRAY_BYTES] = getepicscaaddrlist
%GETEPICSCAADDRLIST - Returns the environmental varible EPICS_CA_ADDR_LIST
%  [AddrList, Port, MAX_ARRAY_BYTES] = getepicscaaddrlist
%
%  See also setepicscaaddrlist

%  Written by Greg Portmann

AddrList = getenv('EPICS_CA_ADDR_LIST');

if nargout > 1
    Port = getenv('EPICS_CA_SERVER_PORT');
end
if nargout > 2
    MAX_ARRAY_BYTES = getenv('EPICS_CA_MAX_ARRAY_BYTES');
end