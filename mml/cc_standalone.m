function cc_standalone(ApplicationName)
%CC_STANDALONE - Compile a standalone MML/AT application 


% History
% 2012-01-30 - to speed up the ALS launch, changed aoinit to load GoldenMMLSetup.mat instead of running alsinit and setoperationalmode (GJP)


if nargin == 0
    ApplicationName = 'plotfamily';
end

fprintf('   Compiling:  %s\n', ApplicationName);

try
    % Sometimes I see an error at the very end of the compile when trying to create the output file.
    % Best to delete it first.  Of course this commits you to creating a new one. 
    if ispc
        FN = [ApplicationName,'.exe'];
    else
        FN = ApplicationName;
    end
    if exist(FN,'file')
        delete(FN);
    end
    
    %delete('mccExcludedFiles.log');
catch
end


if strcmpi(getmachinename, 'ALS')
    % Saving the MML setup will make for a faster launch
    MMLFileName = savemml('Golden');
    fprintf('   Saving the MML and AT setup  %s\n', MMLFileName);

    % Add files in StorageRing (*.txt), AT, MML (wave files)
    % -a GoldenOrbit_43NewBPMs.mat ???
    eval(['mcc -mv -a ', MMLFileName,'.mat -a PseudoSingleBunchKickerData.mat -a Tada.wav -a Chord.wav -a UtopiaQuestion.wav -a UtopiaError.wav -a rampmastup.txt -a rampmastdown.txt -a beamisoff.txt -a SOFBwarningmessageHCM.txt -a SOFBwarningmessageVCM.txt -a SOFBstoppedmessage.txt -a SOFBstaleRFmessage.txt -a AperturePass -a BndMPoleSymplectic4Pass -a BndMPoleSymplectic4RadPass -a CavityPass -a CorrectorPass -a DriftPass -a EAperturePass -a IdentityPass -a Matrix66Pass -a QuadLinearPass -a SolenoidLinearPass -a StrMPoleSymplectic4Pass -a StrMPoleSymplectic4RadPass -a ThinMPolePass -a findmpoleraddiffmatrix ',ApplicationName]);
elseif strcmpi(getmachinename, 'APEX')
    % Add files in AT, MML wave files, apex images
    eval(['mcc -mv -a APEX_Layout_PhaseI.png -a Tada.wav -a Chord.wav -a UtopiaQuestion.wav -a UtopiaError.wav -a AperturePass -a BndMPoleSymplectic4Pass -a BndMPoleSymplectic4RadPass -a CavityPass -a CorrectorPass -a DriftPass -a EAperturePass -a IdentityPass -a Matrix66Pass -a QuadLinearPass -a SolenoidLinearPass -a StrMPoleSymplectic4Pass -a StrMPoleSymplectic4RadPass -a ThinMPolePass -a findmpoleraddiffmatrix ',ApplicationName]);
else
    eval(['mcc -mv -a Tada.wav -a Chord.wav -a UtopiaQuestion.wav -a UtopiaError.wav -a AperturePass -a BndMPoleSymplectic4Pass -a BndMPoleSymplectic4RadPass -a CavityPass -a CorrectorPass -a DriftPass -a EAperturePass -a IdentityPass -a Matrix66Pass -a QuadLinearPass -a SolenoidLinearPass -a StrMPoleSymplectic4Pass -a StrMPoleSymplectic4RadPass -a ThinMPolePass -a findmpoleraddiffmatrix ',ApplicationName]);
end

try
    %delete([ApplicationName,'_main.c']);
    %delete([ApplicationName,'_mcc_component_data.c']);
    %delete('mccExcludedFiles.log');
catch
end



% change group permission
%!ls -l
system(sprintf('chmod 774 %s',        ApplicationName));
system(sprintf('chmod 774 run_%s.sh', ApplicationName));
%!ls -l

fprintf('\n   %s compile complete.\n\n\n\n\n', ApplicationName);



% Add files in AT directories
%eval(['mcc -mv -a AperturePass -a BndMPoleSymplectic4Pass -a BndMPoleSymplectic4RadPass -a CavityPass -a CorrectorPass -a DriftPass -a EAperturePass -a IdentityPass -a Matrix66Pass -a QuadLinearPass -a SolenoidLinearPass -a StrMPoleSymplectic4Pass -a StrMPoleSymplectic4RadPass -a ThinMPolePass -a findmpoleraddiffmatrix ',ApplicationName]);


% % Make sure labca is above sca
% [DirectoryName, FileName, ExtentionName] = fileparts(which('getpvonline'));
% if findstr('sca', DirectoryName)
%     fprintf('\n   Switching to LabCA since the compiled version seems to have trouble in SCAIII\n\n');
%     setpathals labca
% end



% switch computer
% 
% case 'SOL2'
%    %PLATFORMOPTION = ['LDFLAGS=''-shared -W1,-M/home/als/alsbase/matlab_runtime/compile/mexFunctionSOL2.map''',' '];
%     PLATFORMOPTION = ['LDFLAGS=''-shared -M/home/als/alsbase/matlab_runtime/compile/mexFunctionSOL2.map''',' '];
% 
% case 'GLNX86'
% 
%     PLATFORMOPTION = ['LDFLAGS=''-pthread -shared -m32 -Wl,--version-script,/home/als/alsbase/matlab_runtime/compile/mexFunctionGLNX86.map''',' '];
%     
% end
% 
% 
% %eval(['mcc -mv /home/als/alsbase/matlab_runtime/compile/mexFunctionSOL2.map -a AperturePass -a BndMPoleSymplectic4Pass -a BndMPoleSymplectic4RadPass -a CavityPass -a CorrectorPass -a DriftPass -a EAperturePass -a IdentityPass -a Matrix66Pass -a QuadLinearPass -a SolenoidLinearPass -a StrMPoleSymplectic4Pass -a StrMPoleSymplectic4RadPass -a ThinMPolePass -a findmpoleraddiffmatrix ',ApplicationName]);
% 
% eval(['mcc -mv LDFLAGS=''-shared -M/home/als/alsbase/matlab_runtime/compile/mexFunctionSOL2.map'' -a AperturePass -a BndMPoleSymplectic4Pass -a BndMPoleSymplectic4RadPass -a CavityPass -a CorrectorPass -a DriftPass -a EAperturePass -a IdentityPass -a Matrix66Pass -a QuadLinearPass -a SolenoidLinearPass -a StrMPoleSymplectic4Pass -a StrMPoleSymplectic4RadPass -a ThinMPolePass -a findmpoleraddiffmatrix ',ApplicationName]);




% To compile stand alone with graphics
%mcc -mv -B sgl plotfamily

% To compile stand alone with graphics, online only (no AT funcitons)
%mcc -mv -B sgl -I /home/als/alsbase/matlab_runtime/compile/ModelOffFunctions plotfamily
