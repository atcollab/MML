if ArchiveFlag
    
    DirStart = pwd;
    DirectoryName = getfamilydata('Directory', 'GoldenConfigFiles');
    cd(DirectoryName);

    [FileName, PathName] = uiputfile('*.mat','Enter File Name [SPEAR3 Operator Archive]');
    if ischar(FileName)
        FileName = [appendtimestamp(FileName(1:end-4)),'.mat'];
        save(FileName, 'ConfigMonitor', 'ConfigSetpoint');
        disp([sprintf('%s', datestr(clock,31)) ' Golden Configuration [ ' FileName ' ]']);
        disp([' backed up to directory ' DirectoryName]);
    else
        AD=getad;
        FileName=[appendtimestamp(['GoldenConfig_' AD.ModeName]),'.mat'];
        save(FileName, 'ConfigMonitor', 'ConfigSetpoint');
        disp([sprintf('%s', datestr(clock,31)) ' Golden Configuration [ ' FileName ' ]']);
        disp(['     backed up to directory ' DirectoryName]);
    end

    cd(DirStart);
end
