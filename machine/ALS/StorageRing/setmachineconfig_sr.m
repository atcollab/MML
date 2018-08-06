function setmachineconfig_sr(varargin)


% Online do this if running online
Mode = getmode('BEND');


ForceBuild = 0;
if ~isempty(varargin)
    if strcmpi(varargin{1}, 'Build')
        % Force a build
        ForceBuild = 1;
    end
end


if ForceBuild || strcmpi(Mode, 'Online')
    DirStart = pwd;
    
    if ispc
        cd \\Als-filer\physbase\hlc\SR
    else
        cd /home/als/physbase/hlc/SR
    end
    
    
    % Get the production lattice
    SP = getproductionlattice;
    
    % Compare file dates
    TimeStamp = SP.HCM.Setpoint.TimeStamp;
    Buildflag = 0;
    try
        LoadStruct = load('EDMBuildTimeStamp', 'TimeStamp');
        TimeStampFile = LoadStruct.TimeStamp;
        if abs(etime(TimeStampFile,TimeStamp)) > .1
            Buildflag = 1;
        else
            Buildflag = 0;
        end
    catch
        Buildflag = 1;
    end
    
    if ForceBuild || Buildflag
        Families = {'HCM', 'VCM', 'QF', 'QD', 'QFA', 'QDA', 'SF', 'SD', 'SHF', 'SHD', 'SQSF', 'SQSD', 'SQSHF', 'BEND', 'HCMCHICANE', 'HCMCHICANEM', 'TOPSCRAPER', 'BOTTOMSCRAPER', 'INSIDESCRAPER'};  %  'VCMCHICANE'
        
        try
            fprintf('   Building EDM script files.\n');
            for i = 1:length(Families)
                FileName = sprintf('%s_Setpoint_MachineSave.sh', Families{i});
                try
                    DataStruct = SP.(Families{i}).Setpoint;
                catch
                    fprintf('   %s family not found in the machine save.\n', Families{i});
                end
                FileName = mml2caput(DataStruct.FamilyName, DataStruct.Field, DataStruct.Data, DataStruct.DeviceList, FileName, 0);
            end
        catch
            fprintf('%s\n', lasterr);
            fprintf('   An error occurred writting the SR lattice save scripts for the EDM applications.\n');
            fprintf('   The Matlab save/restore is not affected by this, just the EDM applications.\n');
        end
        
        
        try
            fprintf('   Building EDM screens so that the Golden values are there.  If open, the EDM SR Magnet \n');
            fprintf('   Power Supply applications will need to be restarted before the change is visable.\n');
            
            mml2edm_mps;
            mml2edm_scrapers;
            
            % Save the time stamp file
            save('EDMBuildTimeStamp', 'TimeStamp');
            
        catch
            fprintf('%s\n', lasterr);
            fprintf('   An error occurred rebuilding EDM Magnet Power Supply application for the SR (mml2edm_mps).\n');
        end
    end
    
    cd(DirStart);
end