function cc_topoff
% CC_TOPOFF - "Compiles" the storage ring topoff injection application to run standalone

DirStart = pwd;
gotocompile('StorageRing');

if ispc
    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
        fprintf('   Compile topoff for 1.9 GeV, Two-Bunch\n');
        cd topoff_injection_twobunch
        % cc_standalone('n:\matlab\chris\commands\inj_interlock\topoff_injection');
        % cc_standalone('n:\matlab\chris\commands\inj_interlock\topoff_injection_dualcam');
        cc_standalone('n:\matlab\chris\commands\inj_interlock\topoff_injection_newtimingsystem');
        cd ..
    else
        % cc_standalone('n:\matlab\chris\commands\inj_interlock\topoff_injection');
        % cc_standalone('n:\matlab\chris\commands\inj_interlock\topoff_injection_dualcam');
        cc_standalone('n:\matlab\chris\commands\inj_interlock\topoff_injection_newtimingsystem');
        %!copy n:\matlab\chris\commands\inj_interlock\topoff_injection.prj   N:\machine\ALS\Common\Compile\StandAloneRelease\win32\SR
    end
else
    % cc_standalone('/home/als/physbase/matlab/chris/commands/inj_interlock/topoff_injection_dualcam');
    cc_standalone('/home/als/physbase/matlab/chris/commands/inj_interlock/topoff_injection_newtimingsystem');
end
cd(DirStart);

