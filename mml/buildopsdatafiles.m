function buildopsdatafiles
%BUILDOPSDATAFILES - Builds the files for the OpsData directory from the model
%  buildopsdatafiles


getmachineconfig('Golden');
%copyinjectionconfigfile(FileName);

getmachineconfig('Injection');
%copymachineconfigfile(FileName);

FileName = [getfamilydata('Directory', 'BPMResponse'), getfamilydata('Default', 'BPMRespFile'), '_Model'];
[Rmat, FileName] = measbpmresp('Model', 'Archive', FileName);
copybpmrespfile(FileName);

if isstoragering
    FileName = [getfamilydata('Directory', 'DispData'), getfamilydata('Default', 'DispArchiveFile'), '_Model'];
    [Dx, Dy, FileName] = measdisp('Model', 'Archive', FileName);
    copydispersionfile(FileName);
    
    FileName = [getfamilydata('Directory', 'TuneResponse'), getfamilydata('Default', 'TuneRespFile'), '_Model'];
    [Rmat, FileName] = meastuneresp('Model', 'Archive', FileName);
    copytunerespfile(FileName);
    
    FileName = [getfamilydata('Directory', 'ChroResponse'), getfamilydata('Default', 'ChroRespFile'), '_Model'];
    [Rmat, FileName] = measchroresp('Model', 'Archive', FileName);
    copychrorespfile(FileName);
end


