function  AO = getao(FileName)
%GETAO - returns the AcceleratorObject (AO)
%  AO = getao(FileName)
%
%  If FileName = 'Archive', then the AO and AD are saved to the 
%                default directory under the data root
%  If FileName = a string beside 'Archive', then the AO and AD are saved  
%                to that string name

AO = getappdata(0, 'AcceleratorObjects');

% if isempty(AO)
%     warning('AcceleratorObject not initialized');
%     return;
% end


% Archive data structure
if nargin >= 1
    if strcmpi(FileName,'archive')
        AD = getad;
        DirStart = pwd;
        FileName = appendtimestamp('AO', clock);
        DirectoryName = fullfile(getfamilydata('Directory','DataRoot'),'AO',filesep);
        [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
        save(FileName, 'AO', 'AD');
        cd(DirStart);
    else
        save(FileName, 'AO', 'AD');
    end
end