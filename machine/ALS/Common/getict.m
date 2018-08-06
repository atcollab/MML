function [ICT, tout, DataTime, ErrorFlag, ChannelNames] = getict(t)
%GETICT - Beam current as measured by the ICTs
%  [ICT, tout, DataTime, ErrorFlag] = getict(t)
%
%  INPUTS
%  1. t - Time vector {Default: 0, see getpv}
%
%  OUTPUTS
%  1. ICT - Beam current vector [LTB; BR BTS1 BTS2]
%  2-4. tout, DataTime, ErrorFlag - typical getpv outputs

%  Written by Greg Portmann


ChannelNames = [
    'LTB_____ICT01__AM02';
   %'BR2_____ICT01__AM03'
    'BTS_____ICT01__AM00'
    'BTS_____ICT02__AM01'
    'LTB:ICT1           '
    'BTS:ICT1           '
    'BTS:ICT2           '    
    ];


if nargin < 1
    t = 0;
    
elseif  ischar(t)
    if strcmpi(t, 'Archive')
        FileName = 'ICT_Archive';
        DirStart = pwd;
        DirectoryName = fullfile(getfamilydata('Directory','DataRoot'),'ICT');
        [DirectoryName, DirErrorFlag] = gotodirectory(DirectoryName);
        if DirErrorFlag
            fprintf('   Warning: %s was not the desired directory for ICT data.\n', DirectoryName);
        end
        
        if exist('ICT_Archive.mat','file')
            tmp = load(FileName, 'ICT_Archive');
            ICT_Archive = tmp.ICT_Archive;
        else
            ICT_Archive = [];
        end
        
        [ICT, tout, DataTime, ErrorFlag] = getpv(ChannelNames);

        tmp = [DataTime'; ICT'];
        
        ICT_Archive = [
            ICT_Archive
            tmp(:)'
            ];
        
        save(FileName, 'ICT_Archive','ChannelNames');
        %fprintf('   BPM data saved to %s.mat\n', [DirectoryName FileName]);
        FileName = [DirectoryName FileName];
        cd(DirStart);
        
        return;
    else
        error('Archive is the only char input I know what to do with.');
    end
end


[ICT, tout, DataTime, ErrorFlag] = getpv(ChannelNames, t);

