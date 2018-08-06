function AddrList = getepicscaaddrlist
%GETEPICSCAADDRLIST - Returns the environmental varible EPICS_CA_ADDR_LIST
%  AddrList = getepicscaaddrlist
%
%  See also setepicscaaddrlist
%
%  Written by Greg Portmann

AddrList = getenv('EPICS_CA_ADDR_LIST');
