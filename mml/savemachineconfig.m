function savemachineconfig(Flag)
%SAVEMACHINECONFIG - Saves the storage ring setpoints and monitors to a file 
%                    (same as getmachineconfig('Archive'))
%  
% Also see getmachineconfig

if nargin < 1
    getmachineconfig('archive');
else
    getmachineconfig(Flag);
end