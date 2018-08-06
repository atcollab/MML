function srcycle(DisplayFlag)
%SRCYCLE - Cycle storage ring magnet to the golden lattice
%
%  srcycle(0) to cycle without varifying {Default}
%  srcycle(1) to cycle with a varification dialog box

error('srcycle needs to be written');


if nargin < 1
    DisplayFlag = 0;
end


% Query to begin measurement
if DisplayFlag
    tmp = questdlg('Begin storage ring cycle?','SRCYCLE','Yes','No','No');
    if strcmpi(tmp,'No')
        fprintf('   Cycle cancelled\n');
        return
    end
end


