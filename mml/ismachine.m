function Test = ismachine(MachineName)
%ISMACHINE - Test for accelerator location
% 
%  Test = ismachine(MachineName)
%
%  EXAMPLES
%  1. Test if the present machine is the ALS
%     >> ismachine als
%     

if strcmpi(getfamilydata('Machine'), MachineName)
    Test = 1;
else
    Test = 0;
end

