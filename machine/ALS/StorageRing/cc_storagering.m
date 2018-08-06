function cc_storagering
% CC_STORAGERING - "Compiles" all the storage ring applications to run standalone

if strcmpi(getfamilydata('SubMachine'), 'StorageRing')
    
    % Starting directory
    DirStart = pwd;
    
    
    % Compile scripts
    cc_srcontrol;  % cc_standalone('srcontrol');
    cc_topoff;
    %cc_graphit;
    
    
    % Do the rest
    gotocompile('StorageRing');
    cc_standalone('bcmdisplay');
    cc_standalone('machineconfig');
    cc_standalone('plotfamily');
    cc_standalone('srbpmcontrol');
    cc_standalone('viewfamily');
    cc_standalone('bpm_psd_plot');
    cc_standalone('plot_injection_data_newbpm');
    if isunix
        cc_standalone('epbitest2');
        %cc_standalone('epbitest3');
    end
    
    % cc_standalone('SD_CurrentFeedback');
    % cc_standalone('archive_sr');
    % cc_standalone('mysqldatalogger');
    % cc_standalone('alslaunchpad');
    % cc_standalone('locogui');
    
    %cc_beamviewer;
    %cc_bl31image;
    gotocompile('Common');
    cc_standalone('imageviewer');
    cc_standalone('beamviewer');
    cc_standalone('bl31image');
    
    
    cd(DirStart);
    
else
    fprintf('   Please run cc_storagering with the MML configured to StorageRing (setpathals(''SR'')).\n');
end
