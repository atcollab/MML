function srsave(Flag)
%SRSAVE - Saves the storage ring setpoints and monitors to a file (same as getmachineconfig('Golden'))
%  
% see help getmachineconfig for details

if nargin < 1
    getmachineconfig('golden');
else
    getmachineconfig(Flag);
end
