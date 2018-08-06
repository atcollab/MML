function  setao(AO)
%SETAO - Set the MML Accelerator Object (AO)
%  setao(AO)
%  setao(FileName)
%  setao('') to browse for a file
%
%  INPUTS
%  1. AO - Accelerator Object structure or a filename where one is stored
%
%  See also getao, setad

if nargin < 1
    AO = '';
end

% Browse for filename and directory if using default FileName
if ischar(AO)
    if isempty(AO)
        DirectoryName = getfamilydata('Directory','OpsData');
        [FileName, DirectoryName] = uigetfile('*.mat','Select the desired mode file:', DirectoryName);
        if FileName == 0
            fprintf('   AO not changed\n');
            return
        end
        
        FileName = [DirectoryName FileName];
    else
        FileName = AO;
    end
    
    try
        load(FileName);
    catch
        try
            feval(FileName);
        catch
            error(sprintf('Could not load or feval %s',FileName));
        end
    end
    
    if exist('AcceleratorObjects','var')
        AO = AcceleratorObjects;
    end
    if exist('AcceleratorData','var')
        AD = AcceleratorData;
    end
    
    if exist('AD','var')
        %tmp = questdlg('Do you want to make the AD variable in this file active as well?','Accelerator Data (AD)','YES','NO','YES');
        %if strcmp(tmp,'YES')
        setad(AD);
        %end
    end
    
    if ~exist('AO','var')
        fprintf('   AO or AcceleratorObjects variable does not exist in the file: %s\n', [DirectoryName FileName]);
        return
    end
end


if iscell(AO)
    AO = cell2field(AO);
end

setappdata(0, 'AcceleratorObjects', AO);

