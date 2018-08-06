function [HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit(MethodName)
%OCSINIT - Corrector and BPM
% [HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit(MethodName)
%
%  INPUTS
%  1. MethodName = 'TopOfFill'
%                  'SOFB'
%                  'FOFB'
%                  'Injection_TopOfFill'
%                  'Offset Orbit'
%
%  NOTE
%  1. This is a user operational file
%
%  See also setorbit, setorbitgui, setorbitsetup


if nargin == 0
    MethodName = 'TopOfFill';
end

switch(MethodName)
    
    case 'TopOfFill'
        
        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%
        
        % Bad BPM list
        RemoveHBPMDeviceList = [
            1  5;   % removed because BPM will be used for NSLS-II BPM tests - 1-25-11, T.Scarvie
            1  7;   % BPM seems fine - modified golden orbit and put back in 12-22-10, T.Scarvie % this BPM had large offset due to physics2hw gain error in MatlabML but hat was fixed 6-5-08 - now has strange orbit reading so leaving it out to track a bit - T.Scarvie
            %2  1;  %returned to service 4-3-17, A and C swapped, T.Scarvie % BPM cables are miswired - 2017-3-12, C. Steier
            %1 10;  % noisy in 2-bunch - 2008-08-07
            %2  5;  % changed golden orbit to remove large offset, 4-20-15, T.Scarvie
            %2  7;  % noisy in 2-bunch - 2008-08-07
            % 2   9;
            3   7; % removed to match SOFB correction: including this BPM increases the photon beam energy shift when switching circular polarization for beamline 4.0.2 - check with C. Steier before including %added back 1-10-15 based on 12-23-14 comments in the OLOG from Christoph % very noisy (two bunch), large offset (always), removed 2012-04-02, C. Steier
            %4  5;  %SR04 EEBI chassis repaired ________, T.Scarvie  %SR04 EEBI chassis bypassed and removed 7-6-17, and these BPMs go through it, so they are disconnected, T.Scarvie&G.Portmann, 7-7-17
            %4  6;  %SR04 EEBI chassis repaired ________, T.Scarvie  %SR04 EEBI chassis bypassed and removed 7-6-17, and these BPMs go through it, so they are disconnected, T.Scarvie&G.Portmann, 7-7-17
            %5  1;  %this BPM (or a neighboring flexband?) appears to be broken - 50micron jumps observed 3-5-15 - removed from correction and SOFB and FOFB 3-5-15, C.Steier, T.Scarvie
            5  4;  %broken again 1-8-16, T.Scarvie  % card swapped 1-10-15, T.Scarvie % jumping wildly, C. Steier 2014-12-23
            %8  7;  % changed Bergoz card 1-31-10 and BPM seems better now - T.Scarvie
            %5 10;  % this BPM seems to be shifting enough to distorting SR05/06 orbit substantially from correction to correction - 2010-05-09 - T.Scarvie
            6  5;   % noisy (occasionally), big offset (always), removed 2012-04-02, C. Steier
            %6 11;  %new BPMs no golden orbit defined yet - 9/3/13 - T.Scarvie, C.Steier
            %6 12;  %repaired May 24,2017, returned to service May 30,2017, T.Scarvie % gains and coupling are messed up - 2017-3-12, C. Steier
            %7  1;   %occasional ~200micron jumps since the spring 2013 shutdown
            %7  6;  % been noisy in the several micron level lately - 2/2/14, T.Scarvie
            %9  1;   %occasional ~100micron jumps since the spring 2013 shutdown
            9  5;  % this BPM seems to be behaving itself - took back in 11-06-10, T.Scarvie % may have made a huge change on 6/20/2009, took it out to observe it (GJP)
            %10 1; %new goldenorbit defined, BPM back in 8-12-14, T.Scarvie  %golden orbit is wrong after flexband replacement 7-6-14, T.Scarvie   % Large jumps (100 microns) started after shutdown (2012-04-04)
            %10  5; % changed golden orbit to remove large offset, 4-20-15, T.Scarvie
            %10 11;
            %11 1;  % Bergoz card replaced 5-7-13 and BPM works now  % BPM suddenly has big x offset and large coupling 3/23/2013, C. Steier
            %11 7;  % Bergoz card replaced 9-16-13 and works now - T.Scarvie  % BPM seems to have broken - 3-22-11, T.Scarvie
            %12 1;  %BPM(12,1) has seemed healthy since a card swap just before the 9-11 2-bunch run - T.Scarvie  % BPM noisy horizontally - 8-10-11, T.S. % Seems to be still jumping (another flexband?) - Tom asked to take it out, CAS, 2010-03-30   % BPM fairly well behaved for several months after flexband replacement - took back into loops 20100308 - T.Scarvie % saw big drifts and BPM driving SR12_VCM4 too high 10-13-09 %older: observed large dirfts and jumps during startup 6-10-09 - T.Scarvie; seemed fine on 6-29-09 so Christoph and I took it back in
            12 4;  %BPM found to have -150um V and +200um offset from golden orbit as of 1/12/16 - C.Steier&T.Scarvie
            % 12 9;
            ];
        
        RemoveVBPMDeviceList = RemoveHBPMDeviceList;
        
%          HBPMList = getlist('BPMx'); 
%          VBPMList = getlist('BPMy'); 
         HBPMList = getbpmlist('Bergoz');
         VBPMList = getbpmlist('Bergoz');
        
        i = findrowindex(RemoveHBPMDeviceList, HBPMList);
        if ~isempty(i)
            HBPMList(i,:) = [];
        end
        
        i = findrowindex(RemoveVBPMDeviceList, VBPMList);
        if ~isempty(i)
            VBPMList(i,:) = [];
        end
        
        
        %%%%%%%%%%%%%%%%%%%
        % Corrector Setup %
        %%%%%%%%%%%%%%%%%%%
        
        % Bad corrector list
        RemoveHCMDeviceList = [
            3 10
            5 5
            5 10
            6 10    %BPM6,12 broken but 6,11 works, 4-17-2017, T.Scarvie   
            7 2
            9 2
            10 2
            10 10
            11 2
            ];
        
        RemoveVCMDeviceList = [
            % 3 10
            % 6 10    %BPM6,12 broken but 6,11 works, 4-17-2017, T.Scarvie
            % 10 10
            ];
        
        HCMList = getcmlist('HCM', '1 4 5 8 10');
        HCMList = [1 2; HCMList; 12 7];  % Replacement for missing magnets in sectors 1 & 12
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        HCMList = [HCMList; 5 3];  % Swapped 5,3 in for 5,5 9-20-13 T.Scarvie %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        VCMList = getcmlist('VCM', '1 4 5 8 10');
        VCMList = [1 2; VCMList; 12 7];  % Replacement for missing magnets in sectors 1 & 12
        
        i = findrowindex(RemoveHCMDeviceList, HCMList);
        if ~isempty(i)
            HCMList(i,:) = [];
        end
        
        i = findrowindex(RemoveVCMDeviceList, VCMList);
        if ~isempty(i)
            VCMList(i,:) = [];
        end
        
        
        % Structure setup
        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);
        
        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);
        
        
        % SVD orbit correction
        HSV = min([size(HCMList,1) size(HBPMList,1)])-1;
        VSV = min([size(VCMList,1) size(VBPMList,1)])-1;
        
        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            VSV = VSV-3;
        end
        
        
    case 'SOFB'
        
        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%
        
        % Bad BPM list
        RemoveHBPMDeviceList = [
            % after replacing Bergoz crate PS sector 1 BPMs worked again (generally) - 2008-1-11
            % 1 2;
            % 1 4;
            1 5;   % removed because BPM will be used for NSLS-II BPM tests - 1-25-11, T.Scarvie
            %1 6;
            1 7;   % BPM seems fine - modified golden orbit and put back in 12-22-10, T.Scarvie % this BPM had large offset due to physics2hw gain error in MatlabML but hat was fixed 6-5-08 - now has strange orbit reading so leaving it out to track a bit - T.Scarvie
            % 1 10; % cable just fixed 10-30-07 - returned to OC service 11-27-07, started jumping again 12-4-07 - T.Scarvie
            %2 1;  %returned to service 4-3-17, A and C swapped, T.Scarvie  % Cables seem to be mis-wried - 2017-3-12, C. Steier
            % 2  5;  % changed golden orbit to remove large offset, 4-20-15, T.Scarvie
            2 6;  % noisy BPM observed 5-15-16, T.Scarvie
            % 2  9;
            % 3  4; % Christoph observed big noise on this BPM prior to 9-29-11 so removed them from SOFB loop (they were already out of FOFB loop) - 10-2-11, T.Scarvie
            3 7;    % including this BPM increases the photon beam energy shift when switching circular polarization for beamline 4.0.2 - check with C. Steier before including 
            % 3 11; % observed for one week and it works  % failed during 10-11-10 power outage - replaced card 10-14-10, watching for week to make sure it works - T.Scarvie
            % 3 12; % this BPM went bad after 2/24/08 single bunch kicker / 2-bunch setup tests - T.Scarvie
            %4  5;  %SR04 EEBI chassis repaired ________, T.Scarvie  %SR04 EEBI chassis bypassed and removed 7-6-17, and these BPMs go through it, so they are disconnected, T.Scarvie&G.Portmann, 7-7-17
            %4  6;  %SR04 EEBI chassis repaired ________, T.Scarvie  %SR04 EEBI chassis bypassed and removed 7-6-17, and these BPMs go through it, so they are disconnected, T.Scarvie&G.Portmann, 7-7-17
            %5 1;    % this BPM (or a neighboring flexband?) appears to be broken - 50micron jumps observed 3-5-15 - removed from correction and SOFB and FOFB 3-5-15, C.Steier, T.Scarvie
            5 4;    % still noisy 3-6-15, T.Scarvie % Still jumping, C. Steier 2015-1-10 % card swapped 1-10-15, T.Scarvie % jumping wildly, C. Steier 2014-12-23
            % 5 10; % flexband fixed here - should be okay - July2011  % this BPM seems to be shifting enough to distorting SR05/06 orbit substantially from correction to correction - 2010-05-09 - T.Scarvie
            % 6 5;  % BPM showed larger (1 mum rms with FFB on) noise than other ones 7/16/2007
            6 5;    % card swapped 1-27-14, tried it again but still noisy, T.Scarvie % noise observed 1-24-14 on the several micron level, so still out, T.Scarvie % no noise seen after July2011 shutdown  %swapped BPM(6,5) and (6,6) cables (Bergoz cards in same slots) to test (6,6) noise problems - 3/06/11 - T,Scarvie  % BPM still undergoing troubleshooting - 2011-02-08, T.Scarvie
            % 6 6;  % increased noise seen June28,2012, so removed from loop to see about other BPMs in that crate - T.Scarvie
            % 6 11; % new BPMs no golden orbit defined yet - 9/3/13 - T.Scarvie, C.Steier
            % 6 12; %repaired May 24,2017, returned to service May 30,2017, T.Scarvie   % gain and coupling of this BPM seem bad - 2017-3-17, C. Steier 
            % 7 1;  % occasional ~200micron jumps since the spring 2013 shutdown
            7 6;    % noisy again, C. Steier 2015-1-10 % been noisy in the several micron level lately - 2/2/14, T.Scarvie
            % 8 6;  % new card fixed this BPM, back in FB 11-06-10, T.Scarvie  % this BPM was noisy after Aug2010 2-bunch - T.Scarvie
            % 9 1;  % occasional ~100micron jumps since the spring 2013 shutdown
            9 5;    % this BPM seems to be behaving itself - took back in 11-06-10, T.Scarvie % show a lot of drift during 10-26-09 setup - removed from FOFB and replaced with (9,6)
            % 10 1; % new goldenorbit defined, BPM back in 8-12-14, T.Scarvie   %golden orbit is wrong after flexband replacement 7-6-14, T.Scarvie   % jumps by large margins again - 2014-07-09, C. Steier - flexband is known to be bad
            % 10 5; %card replaced 9-29-15, old card found to be sensitive to wiggling in crate, T.Scarvie  %noisy and jumping (I think) - removed 5-22-15, T.Scarvie % changed golden orbit to remove large offset, 4-20-15, T.Scarvie
            % 10 11;%recent data looks fine 2014-10-23, T.Scarvie % observed jumping 9-16-10, T.Scarvie, C.Steier
            % 11 1; % Bergoz card replaced 5-7-13 and BPM works now     % BPM suddenly has big x offset and large coupling 3/23/2013, C. Steier
            % 11 7; % Bergoz card replaced 9-16-13 and works now - T.Scarvie   % BPM seems to have broken - 3-22-11, T.Scarvie
            % 12 1; % BPM(12,1) has seemed healthy since a card swap just before the 9-11 2-bunch run - T.Scarvie % BPM noisy horizontally - 8-10-11, T.S. % Seems to be still jumping (another flexband?) - Tom asked to take it out, CAS, 2010-03-30 %BPM fairly well behaved for several months after flexband replacement - took back into loops 20100308 - T.Scarvie % saw big drifts and BPM driving SR12_VCM4 too high 10-13-09 %older: observed large dirfts and jumps during startup 6-10-09 - T.Scarvie; seemed fine on 6-29-09 so Christoph and I took it back in
            12 4;  %BPM found to have -150um V and +200um offset from golden orbit as of 1/12/16 - C.Steier&T.Scarvie
            % 12 9;
            ];
        
        % Remove Bergoz BPMs in SR01 and SR03 for 2-bunch (noisy at low currents) and drop singular values
        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            RemoveHBPMDeviceList = [RemoveHBPMDeviceList;
                % 1 2;  % in top-off, no problem with current dependence and noise at low beam current
                % 2 1;
                2 6; % very noisy during two bunch operations 2012-03-14, C. Steier
                % 2 7;
                % 2 9; % in top-off, no problem with current dependence and noise at low beam current
                % 3 2; % in top-off, no problem with current dependence and noise at low beam current
                % 6 6;
                %6 12; %seemds to have worked again since 9/8/14, added back 2-23-15, T.Scarvie  %big offsets right now...? 8-6-14, T.Scarvie   
                % 8 10; % not sure why this was out before, but it appears to have broken 8-15-15 at 2:00pm, T.Scarvie
                9 5;   % may have made a huge change on 6/20/2008, took it out to observe it (GJP)
                % 12 9; % in top-off, no problem with current dependence and noise at low beam current
                ];
        end
        
        RemoveVBPMDeviceList = RemoveHBPMDeviceList;
        
        
        % HBPMList = getbpmlist('Bergoz', '1 2 5 6 9 10 11 12');  % Don't use new Bergoz for now
        % VBPMList = getbpmlist('Bergoz', '1 2 5 6 9 10 11 12');  % Don't use new Bergoz for now

%           HBPMList = getlist('BPMx'); % getbpmlist('Bergoz');
%           VBPMList = getlist('BPMy'); % getbpmlist('Bergoz');
            
         HBPMList = getbpmlist('Bergoz');  % 2007-07-16 - start including new bergoz BPMs
         VBPMList = getbpmlist('Bergoz');  % looked overall fine on archiver data
                
        i = findrowindex(RemoveHBPMDeviceList, HBPMList);
        if ~isempty(i)
            HBPMList(i,:) = [];
        end
        
        i = findrowindex(RemoveVBPMDeviceList, VBPMList);
        if ~isempty(i)
            VBPMList(i,:) = [];
        end
        
        
        %%%%%%%%%%%%%%%%%%%
        % Corrector Setup %
        %%%%%%%%%%%%%%%%%%%
        
        % Bad corrector list
        RemoveHCMDeviceList = [
            % With sector 1 BPMs working again, no need to keep corrector magnets disabled 2008-1-11
            %  1 2;
            %  1 8;
            % 3 10;
            %  4  1; %took corrector back into loop (and took [4 2] out to match FOFB) on 4-27-10 - T.Scarvie
            % 6 10;    %BPM6,12 broken but 6,11 works, 4-17-2017, T.Scarvie   
            % 6 7;
            % 7 2; % with BPM removed, problems otherwise
            % 9 2; % with BPM removed, problems otherwise
            % 10 2; % with BPM removed, problems otherwise
            %  8  8; %took corrector back into loop (and took [8 7] out to match FOFB) on 4-27-10 - T.Scarvie
            % 10 10;
            % 11 2; % with BPM removed, problems otherwise
            ];
        
        RemoveVCMDeviceList = [
            1 5; % trying to avoid corrector build up that began when BPM(2,6) was removed, 5-20-16, T.Scarvie
            % 3  2; % Christoph observed big noise BPMs (3,4) and (3,7) so removed this corrector and reduced vertical SVs by one - 10-2-11, T.Scarvie
            % 3 10;
            5 4; %removed since BPMs (5,1) and (5,4) are both broken right now, 3-6-15, T.Scarvie 
            % 5  7;
            % 6 10;    %BPM6,12 broken but 6,11 works, 4-17-2017, T.Scarvie   
            % 7  2; % with BPM removed, problems otherwise
            % 9  2; % with BPM removed, problems otherwise
            % 10 2; % with BPM removed, problems otherwise
            % 10 10;
            % 11 2; % with BPM removed, problems otherwise
            % 12 2;
            12 4; % removed to prevent drift that appeared when BPM(2,6) was removed, T.Scarvie 
            ];
        
        HCMList = [
            1  2;
            1  8;
            2  1;
            2  8;
            3  1;
            %3  2;
            %3  7;
            3  8;
            3 10;
            4  1;
            %4  2;
            %4  7;
            4  8;
            5  1;
            %5  2;
            %5  7;
            5  8;
            5 10;
            6  1;
            %6  2;
            %6  7;
            6  8;
            6 10;
            7  1;
            %7  2;
            %7  7;
            7  8;
            8  1;
            %8  2;
            %8  7;
            8  8;
            9  1;
            %9  2;
            %9  7;
            9  8;
            10 1;
            %10 2;
            %10 7;
            10 8;
            10 10;
            11 1;
            %11 2;
            %11 7;
            11 8;
            12 1;
            %12 2;
            12 7];
        
        %HCMList = getcmlist('HCM', '1 8 10');
        %HCMList = [1 2; HCMList; 12 7];  % Replacement for missing magnets in sectors 1 & 12
        
        %VCMList = getcmlist('VCM', '1 8 10');
        %VCMList = [1 2; VCMList; 12 7];  % Replacement for missing magnets in sectors 1 & 12
        
        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
        HCMList = [
            1  2;
            1  8;
            2  1;
            2  8;
            3  1;
            %3  2;
            %3  7;
            3  8;
            3 10;
            4  1;
            %4  2;
            %4  7;
            4  8;
            5  1;
            %5  2;
            %5  7;
            5  8;
            5 10;
            6  1;
            %6  2;
            %6  7;
            6  8;
            6 10;
            7  1;
            %7  2;
            %7  7;
            7  8;
            8  1;
            %8  2;
            %8  7;
            8  8;
            9  1;
            %9  2;
            %9  7;
            9  8;
            10 1;
            %10 2;
            %10 7;
            10 8;
            10 10;
            11 1;
            %11 2;
            %11 7;
            11 8;
            12 1;
            %12 2;
            12 7];
            % below is 2-bunch SOFB VCM setup prior to August 2014 2-bunch run
%             HCMList = [
%                 1  2;
%                 1  8;
%                 2  1;
%                 2  8;
%                 3  1;
%                 3  8;
%                 3 10; %SR04U_HCM2 (chicane trim)
%                 4  1;
%                 4  2;
%                 4  8;
%                 5  1;
%                 5  2;
%                 5  7;
%                 5  8;
%                 5 10; %SR06U_HCM2 (chicane trim)
%                 6  1;
%                 6  2;
%                 6  7;
%                 6  8;
%                 6 10; %SR07U_HCM2 (chicane trim)
%                 7  1;
%                 7  2;
%                 7  7;
%                 7  8;
%                 8  1;
%                 8  2;
%                 8  8;
%                 9  1;
%                 9  2;
%                 9  7;
%                 9  8;
%                 10 1;
%                 10 2;
%                 10 7;
%                 10 8;
%                 10 10; %SR11U_HCM2 (chicane trim)
%                 11 1;
%                 11 2;
%                 11 7;
%                 11 8;
%                 12 1;
%                 12 2;
%                 12 7];
            
            VCMList = [
                1 2;
                1 4;
                1 5;
                1 8;
                2 1;
                2 4;
                2 5;
                2 8;
                3 1;
                3 4;
                3 5;
                3 8;
                3 10; %SR04U_VCM2 (chicane trim)
                4 1;
                4 4;
                4 5;
                4 8;
                5 1;
                5 4;
                5 5;
                5 8;
                5 10; %SR06U_VCM2 (chicane trim)
                6 1;
                6 4;
                6 5;
                6 8;
                6 10; %SR07U_VCM2 (chicane trim)
                7 1;
                7 4;
                7 5;
                7 8;
                8 1;
                8 4;
                8 5;
                8 8;
                9 1;
                9 4;
                9 5;
                9 8;
                10 1;
                10 4;
                10 5;
                10 8;
                10 10; %SR11U_VCM2 (chicane trim)
                11 1;
                11 4;
                11 5;
                11 8;
                12 1;
                12 4;
                12 5;
                12 7];
            % below is 2-bunch SOFB VCM setup prior to August 2014 2-bunch run
            %             VCMList = [
            %                 1 2;
            %                 1 8;
            %                 2 1;
            %                 2 8;
            %                 3 1;
            %                 3 8;
            %                 3 10; %SR04U_VCM2 (chicane trim)
            %                 4 1;
            %                 4 8;
            %                 5 1;
            %                 5 8;
            %                 5 10; %SR06U_VCM2 (chicane trim)
            %                 6 1;
            %                 6 8;
            %                 6 10; %SR07U_VCM2 (chicane trim)
            %                 7 1;
            %                 7 8;
            %                 8 1;
            %                 8 8;
            %                 9 1;
            %                 9 8;
            %                 10 1;
            %                 10 8;
            %                 10 10; %SR11U_VCM2 (chicane trim)
            %                 11 1;
            %                 11 8;
            %                 12 1;
            %                 12 7];
        else
            VCMList = [
                1 2;
                1 4;
                1 5;
                1 8;
                2 1;
                2 4;
                2 5;
                2 8;
                3 1;
                3 4;
                3 5;
                3 8;
                3 10; %SR04U_VCM2 (chicane trim)
                4 1;
                4 4;
                4 5;
                4 8;
                5 1;
                5 4;
                5 5;
                5 8;
                5 10; %SR06U_VCM2 (chicane trim)
                6 1;
                6 4;
                6 5;
                6 8;
                6 10; %SR07U_VCM2 (chicane trim)
                7 1;
                7 4;
                7 5;
                7 8;
                8 1;
                8 4;
                8 5;
                8 8;
                9 1;
                9 4;
                9 5;
                9 8;
                10 1;
                10 4;
                10 5;
                10 8;
                10 10; %SR11U_VCM2 (chicane trim)
                11 1;
                11 4;
                11 5;
                11 8;
                12 1;
                12 4;
                12 5;
                12 7];
        end
        
        
        % Select out the HCMs
        i = findrowindex(RemoveHCMDeviceList, HCMList);
        if ~isempty(i)
            HCMList(i,:) = [];
        end
        
        % Select out the VCMs
        i = findrowindex(RemoveVCMDeviceList, VCMList);
        if ~isempty(i)
            VCMList(i,:) = [];
        end
        
        
        
        HSV = min([size(HCMList,1) size(HBPMList,1)]);
        VSV = min([size(VCMList,1) size(VBPMList,1)]);
        
%        VSV = VSV -1;
        
        if strcmp(getfamilydata('OperationalMode'), '1.5 GeV, Inject at 1.23') %higher values driving chicane correctors crazy in 1.5
            HSV = 12; %this number gets boosted by one somewhere else - rf?
            VSV = 24;
        end
        
        % Remove Bergoz BPMs in SR01 and SR03 for 2-bunch (noisy at low currents) and drop singular values
        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            %     HBPMList = HBPMList(find(HBPMList(:,1)~=1),:);
            %     HBPMList = HBPMList(find(HBPMList(:,1)~=3),:);
            HSV = HSV - 3;
            %
            %     VBPMList = VBPMList(find(VBPMList(:,1)~=1),:);
            %     VBPMList = VBPMList(find(VBPMList(:,1)~=3),:);
            VSV = VSV - 16;
        end
        
        
        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);
        
        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);
        
        
    case 'FOFB'
        
        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%
        
        RemoveHBPMDeviceList = [
            6 5;   % BPM showed larger (1 mum rms with FFB on) noise than other ones 7/16/2007
            9 5;   % BPM showed stranged drift behavior on 7/15/2007
            %     also may have made a huge change on 6/20/2008 (GJP)
            ];
        %RemoveHBPMDeviceList = [
        %    3 6;   % this BPM has not been used in old ML OC for a while - suspect it's drifting
        %    3 12;  % this BPM broke during the 11/28-29 maintenance - there was maintenance on the motor chicane...
        %    ];
        RemoveVBPMDeviceList = RemoveHBPMDeviceList;
        
        
        HBPMList = getbpmlist('OldBergoz');
        VBPMList = getbpmlist('OldBergoz');
        
        i = findrowindex(RemoveHBPMDeviceList, HBPMList);
        if ~isempty(i)
            HBPMList(i,:) = [];
        end
        
        i = findrowindex(RemoveVBPMDeviceList, VBPMList);
        if ~isempty(i)
            VBPMList(i,:) = [];
        end
        
        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);
        
        
        %%%%%%%%%%%%%%%%%%%
        % Corrector Setup %
        %%%%%%%%%%%%%%%%%%%
        
        % Corrector magnets
        HCMList = [
            1 8;
            2 1;
            2 8;
            3 1;
            3 8;
            4 1;
            4 8;
            5 1;
            5 8;
            6 1;
            6 8;
            7 1;
            7 8;
            8 1;
            8 8;
            9 1;
            9 8;
            10 1;
            10 8;
            11 1;
            11 8;
            12 1];
        
        VCMList = [
            1 8;
            2 1;
            2 8;
            3 1;
            3 8;
            4 1;
            4 8;
            5 1;
            5 8;
            6 1;
            6 8;
            7 1;
            7 8;
            8 1;
            8 8;
            9 1;
            9 8;
            10 1;
            10 8;
            11 1;
            11 8;
            12 1];
        
        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);
        
        
        % SVD orbit correction
        HSV = 11;
        VSV = 12;
        
        
        % Remove Bergoz BPMs in SR01 and SR03 for 2-bunch (noisy at low currents) and drop singular values
        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            HBPMList = HBPMList(find(HBPMList(:,1)~=1),:);
            HBPMList = HBPMList(find(HBPMList(:,1)~=3),:);
            HSV = HSV - 4;
            
            VBPMList = VBPMList(find(VBPMList(:,1)~=1),:);
            VBPMList = VBPMList(find(VBPMList(:,1)~=3),:);
            VSV = VSV - 4;
        end
        
        
        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);
        
        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);
        
        
    case 'Measured Offsets'
        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%
        
        HBPMList = getbpmlist('HOffset');
        VBPMList = getbpmlist('VOffset');
        
        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);
        
        
        %%%%%%%%%%%%%%%%%%%
        % Corrector Setup %
        %%%%%%%%%%%%%%%%%%%
        HCMList = getcmlist('HCM','1 2 3 4 5 6 7 8');
        VCMList = getcmlist('VCM','1 2 3 4 5 6 7 8');
        
        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);
        
        
        % SVD orbit correction
        HSV = 24;
        VSV = 24;
        
        
    case 'Injection'
        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%
        
        % Remove BPMs inside chicane (except a few)
        RemoveHBPMDeviceList = [
            3 11;
            3 12;
            5 11;
            5 12;
            6  1;
            6 11;   %new BPMs no golden orbit defined yet - 9/3/13 - T.Scarvie, C.Steier
            6 12;   %new BPMs no golden orbit defined yet - 9/3/13 - T.Scarvie, C.Steier
            9  5;    % may have made a huge change on 6/20/2008, took it out to observe it (GJP)
            10 10;
            10 11;
            10 12;
            11  1;
            ];
        RemoveVBPMDeviceList = RemoveHBPMDeviceList;
        
        HBPMList = getbpmlist('BPMx');
        VBPMList = getbpmlist('BPMy');
        
        i = findrowindex(RemoveHBPMDeviceList, HBPMList);
        if ~isempty(i)
            HBPMList(i,:) = [];
        end
        
        i = findrowindex(RemoveVBPMDeviceList, VBPMList);
        if ~isempty(i)
            VBPMList(i,:) = [];
        end
        
        HBPM = family2datastruct('BPMx', 'Monitor', HBPMList);
        VBPM = family2datastruct('BPMy', 'Monitor', VBPMList);
        
        
        %%%%%%%%%%%%%%%%%%%
        % Corrector Setup %
        %%%%%%%%%%%%%%%%%%%
        HCMList = getcmlist('HCM','1 2 3 4 5 6 7 8');
        VCMList = getcmlist('VCM','1 2 3 4 5 6 7 8');
        
        HCM = family2datastruct('HCM', 'Setpoint', HCMList);
        VCM = family2datastruct('VCM', 'Setpoint', VCMList);
        
        % SVD orbit correction
        HSV = 24;
        VSV = 24;
        
        
    case 'Injection_TopOfFill'
        %%%%%%%%%%%%%%
        % BPM Setup  %
        %%%%%%%%%%%%%%
        
        % Remove BPMs inside chicane (except a few)
        RemoveHBPMDeviceList = [
            3 11;
            3 12;
            5 11;
            5 12;
            6 1;
            6 11;   %new BPMs no golden orbit defined yet - 9/3/13 - T.Scarvie, C.Steier
            6 12;   %new BPMs no golden orbit defined yet - 9/3/13 - T.Scarvie, C.Steier
            10 10;
            10 11;
            10 12;
            11  1;
            ];
        RemoveVBPMDeviceList = RemoveHBPMDeviceList;
        
        
        [HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit('TopOfFill');
        
        
        i = findrowindex(RemoveHBPMDeviceList, HBPM.DeviceList);
        if ~isempty(i)
            HBPM.Data(i,:) = [];
            HBPM.DeviceList(i,:) = [];
            HBPM.Status(i,:) = [];
        end
        
        i = findrowindex(RemoveVBPMDeviceList, VBPM.DeviceList);
        if ~isempty(i)
            VBPM.Data(i,:) = [];
            VBPM.DeviceList(i,:) = [];
            VBPM.Status(i,:) = [];
        end
        
        % SVD orbit correction
        HSV = HSV - 8;
        VSV = VSV - 8;
        
        
    otherwise
        fprintf('   Orbit correction set unknown.\n');
end








% HCMList = [];
% VCMList = [];
% for Sector = 1:12
%     if Sector == 1
%         VCMList = [VCMList;Sector 2;Sector 4;Sector 5;Sector 8];
%         HCMList = [HCMList;Sector 2;Sector 7];
%     elseif Sector == 3
%         VCMList = [VCMList;Sector 1;Sector 4;Sector 5;Sector 8;Sector 10];
%         HCMList = [HCMList;Sector 2;Sector 7;Sector 10];
%     elseif Sector == 5
%         VCMList = [VCMList;Sector 1;Sector 4;Sector 5;Sector 8;Sector 10];
%         HCMList = [HCMList;Sector 2;Sector 7;Sector 10];
%     elseif Sector == 10
%         VCMList = [VCMList;Sector 1;Sector 4;Sector 5;Sector 8;Sector 10];
%         HCMList = [HCMList;Sector 2;Sector 7;Sector 10];
%     elseif Sector == 12
%         VCMList = [VCMList;Sector 1;Sector 4;Sector 5;Sector 7];
%         HCMList = [HCMList;Sector 2;Sector 7];
%     else
%         VCMList = [VCMList;Sector 1;Sector 4;Sector 5;Sector 8];
%         HCMList = [HCMList;Sector 2;Sector 7];
%     end
% end
