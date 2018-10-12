classdef srbpm_v2
    properties (Access=private)
        fullDeviceList
        bpmpvnames
        iocpvnames
    end
    
    methods (Static)
        %% Version and Help functions
        
        function version(varargin)
           fprintf("srbpm\n");
           fprintf("Version 2.1\n");
           fprintf("Updated to use the new PV's with the updated EPICS base\n\n");
        end
        
        function help(varargin)
           fprintf("Help Menu\n"); 
           fprintf("(WIP)\n\n");
        end
        
        %% Get Methods
        
        function varargout = getfield(field,varargin)
            % Wrap the internal function as a method
            varargout = getfield(field,varargin{:});
        end
        
        function status = getagc(varargin)
            % agcstate = getagc([DeviceList]);
            %
            % Returns the state of the AGC
            status = local_getPV('BPMx','AGC_ENABLED_STATUS',varargin{1:end});
            if isnan(status)
                fprintf("Failed to get AGC status\n");
                return;
            end
        end
        
        function maxadc = getmaxadc(varargin)
            % maxadc = getmaxadc([DeviceList]);
            %
            % Returns the MAXADC values
            maxadc = local_getPV('BPMx','MAXADC_MONITOR',varargin{1:end});
            if isnan(maxadc)
                fprintf("Failed to get max adc values\n");
                return;
            end
        end
        
        function status = getsyncstate(varargin)
            % Return the synchronisation state of all the BPMs
            % 0:NoSync, 1:tracking, 2:synchronised
            status = local_getPV('BPMx','SYNC_ST_M_STATUS',varargin{:});
            if isnan(status)
                fprintf("Failed to get synchronisation state\n");
                return;
            end
        end
        
        function eventcode = gettriggerevent(varargin)
            % eventcode = gettriggerevent
            %
            % Get the current T2 (general trigger) event codes
            eventcode = getfield('EVRX_RTC_T2_IN_FUNCTION_MONITOR', varargin{1:end});
        end
        
        function eventcode = getpmevent(varargin)
            % eventcode = getpmevent
            %
            % Get the current T1 (post mortem trigger) event codes
            eventcode = getfield('EVRX_RTC_T1_IN_FUNCTION_MONITOR', varargin{1:end});
        end
        
        function status = getmclock(varargin)
            % mclockstate = getmclock([DeviceList]);
            %
            % Returns the state of the MC lock (EVRX_PLL_LOCKED)
            status = getfield('EVRX_PLL_LOCKED_STATUS', varargin{1:end});
        end
        
        
        %% Set Methods
        
        function status = setfield(field,value,varargin)
            % Wrap the internal function as a method
            status = setfield(field,value,varargin{:});
        end
        
        function setagc(varargin)
            % getagc(['on'/1,'off'/0],[DeviceList])
            %
            % Set the state of the Auto Gain Control (AGC)
            if nargin > 0
                switch varargin{1}
                    case {'on',  1}
                        local_setPV('BPMx','AGC_ENABLED',1,varargin{2:end});
                    case {'off', 0}
                        local_setPV('BPMx','AGC_ENABLED',0,varargin{2:end});
                end
            end
        end
         
        function setswitches(varargin)
            % setswitches(['on'/1,'off/0],[DeviceList])col
            %
            % Set the state of the crossbar switches on the Brilliance+
            % units in conjunction with the digital signal conditioning.
            if nargin > 0
                if ischar(varargin{1}); varargin{1} = lower(varargin{1}); end
                if getpv('SR00OFB01:MODE_STATUS') == 2
                    warning('Changing switching status while orbit feedback is RUNNING is not recommended.');
                end
                switch varargin{1}
                    case {'on',  1}
                        local_setPV('BPMx','SWITCHING_ENABLE',1,varargin{2:end});
                        local_setPV('BPMx','DSC_COEFF_ADJUST',1,varargin{2:end});
                        local_setPV('BPMx','DSC_COEFF_TYPE',1,varargin{2:end});
                    case {'off', 0}
                        local_setPV('BPMx','SWITCHING_ENABLE',0,varargin{2:end});
                        local_setPV('BPMx','DSC_COEFF_ADJUST',0,varargin{2:end});
                        local_setPV('BPMx','DSC_COEFF_TYPE',1,varargin{2:end});
                end
            end
        end
        
        function settriggerevent(eventcode, varargin) 
            % settriggerevent(eventcode, [DeviceList])
            % Set the current T2 (general trigger) event codes
            %
            %      0 = nullevent
            %      1 = master
            %      2 = injection
            %      3 = gun
            %      4 = extraction without gun
            %      5 = extraction with gun
            %      6 = User Event_ bunch by bunch
            %      7 = User Event_ SR BPM
            %      8 = User Event_ General purpose (default)
            %      9 = User Event_ topup warning
            %     10 = User Event_ beam dump
            %     11 = User Event_ FFM timing reset
            %     16 = User Event_ SR Injection
            %     20 = SROC/N1
            %     21 = SROC/N2
            %     22 = SROC/N3
            % 
            % you can set multiple events to trigger on. Example:
            %
            % >> srbpm.settriggerevent([7 8])
            % >> srbpm.settriggerevent([7 5])
            if nargin > 1 && isnumeric(varargin{1})
                deviceList = varargin{1};
            else
                deviceList = getlist('BPMx');
            end
            eventmaskarr = [repmat(hex2dec('00ff'),length(deviceList),length(eventcode)), repmat(65535,length(deviceList),16-length(eventcode))];
            eventcodearr = [repmat(eventcode      ,length(deviceList),1),                 repmat(65535,length(deviceList),16-length(eventcode))];
                        
            setfield('EVRX_RTC_T2_IN_FUNCTION', eventcodearr);
            setfield('EVRX_RTC_T2_IN_MASK',     eventmaskarr);
        end
        
        function setpmevent(eventcode, varargin) 
            % setpmevent(eventcode, [DeviceList])
            % Set the current T1 (Post Mortem trigger) see SETTRIGGEREVENTS
            % for the event codes. You can set multiple events to trigger
            % on. Example:
            %
            % >> srbpm.setpmevent([10 7])
            % >> srbpm.setpmevent([10])
            if nargin > 1 && isnumeric(varargin{1})
                deviceList = varargin{1};
            else
                deviceList = getlist('BPMx');
            end
            eventmaskarr = [repmat(hex2dec('00ff'),length(deviceList),length(eventcode)), repmat(65535,length(deviceList),16-length(eventcode))];
            eventcodearr = [repmat(eventcode      ,length(deviceList),1),                 repmat(65535,length(deviceList),16-length(eventcode))];
                        
            setfield('EVRX_RTC_T1_IN_FUNCTION', eventcodearr);
            setfield('EVRX_RTC_T1_IN_MASK',     eventmaskarr);
        end
        
        function setevrxmode(mode,varargin)
            % setevrxmode(mode,[DeviceList])
            % Set EVRx mode for MC, T1 and T2 to 'RTC' or 'External'.
            switch mode
                case 'RTC'
                    setfield('EVRX_TRIGGERS_MC_SOURCE' , 5, varargin{:});
                    setfield('EVRX_TRIGGERS_T0_SOURCE' , 0, varargin{:});
                    setfield('EVRX_TRIGGERS_T1_SOURCE' , 5, varargin{:});
                    setfield('EVRX_TRIGGERS_T2_SOURCE' , 5, varargin{:});
                case 'External'
                    setfield('EVRX_TRIGGERS_MC_SOURCE' , 1, varargin{:});
                    setfield('EVRX_TRIGGERS_T0_SOURCE' , 0, varargin{:});
                    setfield('EVRX_TRIGGERS_T1_SOURCE' , 1, varargin{:});
                    setfield('EVRX_TRIGGERS_T2_SOURCE' , 1, varargin{:});
                otherwise
                    disp('Nothing done');
            end
        end
        
        
        %% File I/O
        
        function [xoff, yoff] = getarchivedoffsets(varargin)
            % [xoff yoff] = getarchivedoffsets([number],['quiet'])
            %
            % will search and extract the offsets from:
            % ../bpm_scripts/archivedoffsets/archivedoffsets_[num]_[date].mat
            % Default without a number will return the last set of offsets.
            % The option of 'quiet' will stop all printout.
            %
            
            archivedir = fileparts(mfilename('fullpath'));
            archivedir = [archivedir filesep 'archivedoffsets'];
            
            files = dir([archivedir filesep 'archivedoffsets_*.mat']);
            
            if nargin > 0 && isnumeric(varargin{1})
                % user specified a specific offset to retrieve
                filename = files(varargin{1}).name;
            else
                % assume that you want the last one if you don't have any
                % input
                filename = files(end).name;
            end
            
            load(fullfile(archivedir,filename));
            if ~any(strcmpi(varargin,'quiet'))
                fprintf('Loading: %s\n',filename);
                fprintf('  Datestr: %s\n',offsetdata.datatime);
                fprintf('  Comments: %s\n',offsetdata.comment);
            end
            
            % The archived offsets are in meters
            if strcmpi(getunits('BPMx'),'hardware')
                scale = 1e9;
            else
                scale = 1;
            end
            
            if nargout > 0
                xoff = offsetdata.xoffsets*scale;
            end
            if nargout > 1
                yoff = offsetdata.yoffsets*scale;
            end
        end
   
        function setarchivedoffsets(xoff,xdev,yoff,ydev)
            % setarchivedoffsets(xoff,xdev,yoff,ydev)
            %
            % save the offsets into the archive.
            archivedir = fileparts(mfilename('fullpath'));
            archivedir = [archivedir filesep 'archivedoffsets'];
            files = dir([archivedir filesep 'archivedoffsets_*.mat']);
            i = sscanf(files(end).name,'archivedoffsets_%d_%*s.mat');
            
            % Grab previous list
            [xoff0, yoff0] = srbpm.getarchivedoffsets('quiet');
            % Updated with new
            ind = dev2elem('BPMx',xdev);
            xoff0(ind) = xoff;
            ind = dev2elem('BPMx',ydev);
            yoff0(ind) = yoff;
            
            % Prompt user to input data
            prompt = {'Date','Comments'};
            dlg_title = 'Archive Offsets to file';
            t = now;
            def = {datestr(t) ''};
            answer = inputdlg(prompt, dlg_title,1,def);
            if isempty(answer)
                disp('No offsets saved');
                return
            end
            
            offsetdata.xoffsets = xoff0;
            offsetdata.yoffsets = yoff0;
            offsetdata.comment = answer{2};
            offsetdata.datatime = answer{1};
            
            % Increment the index of the archived datafiles and resave
            prefix = sprintf('archivedoffsets_%04d',i+1);
            fname = appendtimestamp(prefix,datevec(t));
            save(fullfile(archivedir,fname),'offsetdata');
            
        end
        
        %% Utilities
        
        function trigger(varargin)
            % trigger([triggertype])
            %
            % Gets the event generator to transmit a SR BPM event, where
            %   triggertype=0/'stop'
            %   triggertype=1/'single'   (default)
            %   triggertype=2/'continuous'/'cont'
            %
            if nargin == 0
                varargin{1} = 1;
            end
            switch varargin{1}
                case {0,'stop'}
                    % set the BPM trigger event on the EVG for a single event.
                    setpv('TS01EVG01:EVENT_02_MODE_CMD',0); % stop
                case {1,'single'}
                    % set the BPM trigger event on the EVG for a single event.
                    setpv('TS01EVG01:EVENT_02_MODE_CMD',3); % single shot
                case {2,'continuous','cont'}
                    % set the BPM trigger event on the EVG for a continuous event.
                    setpv('TS01EVG01:EVENT_02_MODE_CMD',1); % continuous shot
            end
        end
           
        function synchronise(varargin)
            % Synchronise *ALL ACTIVE* Libera Brillinace+ units. Assumes
            % that Trigger event code is 7 (SR BPM Event).
            
            % Disable Sync Event
            % Stop SR BPM trigger: 0=Disabled, 1:Continuous, 2:Active/Single, 3:Armed
            setpv('TS01EVG01:EVENT_02_MODE_CMD',0);
            pause(1);
            % Arm the Liberas to Synchronise
            % Wait before sending the trigger
            setfield('SYNC_CMD.PROC',1,varargin{:});
            
            fprintf('Waiting to get into tracking mode: ');
            while any( getfield('SYNC_ST_M_STATUS') ~= 1 )
                fprintf('.');
                pause(0.5);
            end
            fprintf('\n');
            pause(0.5);

            
            % Send Single Trigger to Synchronise
            % Wait for system to synchronise
            setpv('TS01EVG01:EVENT_02_MODE_CMD',3);
        end

        function varargout = collectpmdata(varargin)
            % this script will collect the PM data, collect the interlock statuses,
            % reset the interlock statuse on the liberas and reset the PM triggering
            % system.
            %
            % All data will be archived to /asp/usr/data/bpmpmdata/
            
            datenow = datevec(now);
            if isunix
                dirname = sprintf('/asp/usr/data/bpmpmdata/');
            elseif ispc
                dirname = sprintf('u:\\data\\bpmpmdata\\');
            end
            if exist(dirname,'dir') ~= 7
                mkdir(dirname);
            end
            
            fprintf('Collecting PM data...');
            pm = getliberadata('PM_DDC_SYNTH');
            fprintf(' done\n');
            
            fprintf('Collecting Interlock Status... ');
            pm.ilkxstatus = getfield('ILK_STATUS_X');
            pm.ilkystatus = getfield('ILK_STATUS_Y');
            fprintf(' done\n');
            
            fprintf('Acknowledging interlock status and resetting PM on the Libera...');
            setfield('ILK_STATUS_RESET',0);
            setfield('PM_CAPTURE',1);
            fprintf(' done\n');
            
            fprintf('Reseting the PM triggering system...');
            setpv('TS01EVR11:TTL03_ENABLE_CMD',1);
            pause(1);
            setpv('TS01EVR11:TTL03_ENABLE_CMD',0);
            fprintf(' done\n');
            
            fname = appendtimestamp([dirname 'pmdata']);
            fprintf('Saving to file: %s.mat\n',fname);
            save(fname,'pm')
            if nargout > 0
                varargout{1} = pm;
            end
        end
        
        function setdefaultconfig(varargin)
            % setdefaultconfig([DeviceList])
            %
            % This function sets the default configuration for the Liberas Brillinace+
            % in the storage ring. Optional parameters:
            %
            % DeviceList    A vector of nx2 specifying which devices to configure
            %
            % If no parameters are set, the configuration will be applied to all the
            % liberas that are enabled in middleLayer ("aspinit").
            %
            % e.g. >> setliberabconfig
            %      >> setliberabconfig([1 2; 1 3; 1 4; 1 5;])
            
            if nargin > 0 && isnumeric(varargin{1})
                deviceList = varargin{1};
            else
                deviceList = getlist('BPMx');
            end
            el = dev2elem('BPMx',deviceList);
            
            
            % =======================================================================
            % EVRX related PVs
%             fprintf('Setting TIMING to RTC\n');
%             % Make sure the decoder is turned on
%             setfield('EVRX_RTC_DECODER_SWITCH' , 1, varargin{:});
%             % MC to trigger on SROC with a hex value of 0x0200
%             setfield('EVRX_RTC_MC_IN_MASK' ,     hex2dec('0200'), varargin{:});
%             setfield('EVRX_RTC_MC_IN_FUNCTION' , hex2dec('0200'), varargin{:});
%             
%             % Post mortem event is locked in as event code 10 (Beam Dump
%             % Event)
%             setfield('EVRX_RTC_T1_IN_MASK' ,     hex2dec('00ff'), varargin{:});
%             setfield('EVRX_RTC_T1_IN_FUNCTION' , 10             , varargin{:});
%             
%             % Trigger event is defaulted to event code 7 (SR BPM Event)
%             setfield('EVRX_RTC_T2_IN_MASK' ,     hex2dec('00ff'), varargin{:});
%             setfield('EVRX_RTC_T2_IN_FUNCTION' , 7              , varargin{:});
%             
%             % PLL offset tuning
%             fprintf('Setting PLL offset tune to 0 units (0 kHz) and no compensation: \n');
%             setfield('EVRX_PLL_VCXO_OFFSET' ,0,varargin{:});
%             setfield('EVRX_PLL_COMPENSATE_OFFSET' ,0,varargin{:});

            % =======================================================================
            
            
            % AGC
            fprintf('Settting AGC to 1 (ENABLED)\n');
            if (local_setPV('BPMx','AGC_ENABLED',1,varargin{:}) == 0)
               fprintf("Failed to set PV");
               return;
            end
            
            % Switches
            fprintf('Setting SWITCHES to 1 (ENABLED)\n');
            local_setPV('BPMx','SWITCHING_ENABLE',1,varargin{:});
            local_setPV('BPMx','SWITCHING_SOURCE',1,varargin{:});
            local_setPV('BPMx','SWITCHING_DELAY',0,varargin{:});
            
            % Digital signal conditioning
            fprintf('Turning _ON_ DSC\n');
            local_setPV('BPMx','DSC_COEFF_ADJUST',1,varargin{:});
            local_setPV('BPMx','DSC_COEFF_TYPE',2,varargin{:});   %0-PHASE, 1-AMPLITUDE, 2-ADJUST
            local_setPV('BPMx','DSC_COEFF_ATT_DEPENDENT',0,varargin{:});
            
            % Gain
            fprintf('Setting GAINS \n');
            local_setPV('BPMx','KX',14.8e6,varargin{:});
            local_setPV('BPMx','KY',15.1e6,varargin{:});
            local_setPV('BPMx','KS',67108864,varargin{:});
            
            % Libera Offsets
            [libera_offset_x, libera_offset_y] = srbpm.getarchivedoffsets('last');
            fprintf('Setting Libera Offsets \n');
            local_setPV('BPMx','OFF_X',libera_offset_x(el),varargin{:});
            local_setPV('BPMx','OFF_Y',libera_offset_y(el),varargin{:});
            
            % Interlock
            fprintf('Setting INTERLOCKS \n');
            gain_threshold = [...
                -23 -22 -23 -21 -21 -23 -23, ... %
                -23 -22 -29 -27 -28 -27 -27, ... %
                -29 -29 -31 -30 -31 -31 -31, ... %
                -25 -26 -26 -26 -26 -22 -22, ... %
                -23 -24 -25 -24 -23 -22 -21, ... %
                -30 -30 -32 -31 -31 -27 -26, ... %
                -33 -33 -34 -34 -33 -29 -29, ... %
                -28 -28 -29 -29 -28 -26 -24, ... %
                -26 -25 -27 -26 -27 -26 -23, ... %
                -26 -28 -29 -29 -29 -26 -26, ... %
                -26 -26 -27 -27 -27 -28 -26, ... %
                -28 -28 -29 -30 -30 -30 -30, ... %
                -24 -25 -25 -23 -23 -22 -23, ... %
                -24 -23 -24 -25 -25 -26 -25, ... %
                ] + 3 ; gain_threshold(gain_threshold<-32) = -32;
            local_setPV('BPMx','ILK_LIMITS_MIN_X',-1e6,deviceList);
            local_setPV('BPMx','ILK_LIMITS_MIN_Y',-1e6,deviceList);
            local_setPV('BPMx','ILK_LIMITS_MAX_X',+1e6,deviceList);
            local_setPV('BPMx','ILK_LIMITS_MAX_Y',+1e6,deviceList);
            local_setPV('BPMx','ILK_GAIN_DEPENDENT_THRESHOLD',gain_threshold(el)',deviceList);
            local_setPV('BPMx','ILK_ENABLED',0,deviceList);
            local_setPV('BPMx','ILK_GAIN_DEPENDENT_ENABLED',0,deviceList);
            ii = [find(deviceList(:,2) == 1 | deviceList(:,2) == 7); findrowindex([2 2; 2 3],getlist('BPMx'))];
            local_setPV('BPMx','ILK_ENABLED',1,deviceList(ii,:));
            local_setPV('BPMx','ILK_GAIN_DEPENDENT_ENABLED',1,deviceList(ii,:));
            local_setPV('BPMx','ILK_STATUS_RESET',0,deviceList);
            
%             delay=[
%                 22    94   180   282   350   506   483   538   475   416   349   297   198   129
%                 21    92   184   284   354   504   487   538   475   414   350   298   200   125
%                 20   109   188   286   354   513   490   540   477   419   355   297   200   132
%                 19   110   184   289   356   512   487   543   478   419   352   301   198   132
%                 0    86   164   264   330   441   464   520   454   396   331   278   173   109
%                 0    83   166   254   325   433   457   510   452   392   336   277   172   109
%                 3    87   166   259   326   430   455   512   450   395   335   277   173   113];
            delay=[
                29   102   188   288   356   514   491   545   479   421   354   299   204   134
                25   101   189   290   358   517   492   545   479   421   355   300   206   133
                27   115   193   294   361   518   495   549   484   424   358   302   203   138
                26   113   192   292   360   520   495   550   482   423   358   303   204   137
                4    89   169   271   337   447   471   527   459   401   334   282   181   113
                7    89   172   261   333   436   464   519   457   396   337   284   180   116
                7    90   171   263   333   438   465   521   455   395   339   284   178   117];
            local_setPV('BPMx','TRIG_DELAY',delay(el),deviceList); % Send default
            % SR02BPM01:TBT_TBT_WINDOW.ChannelA --> set offset so that data 1 to 86 is
            % used for turn 1, 87 to 172 for turn 2, etc.
            local_setPV('BPMx','TBT_PHASE_OFFSET',10,varargin{:});
            
            
            % Setting whether to use DDC (0) or TDP (1) tbt data for decimated data
            local_setPV('BPMx','TBT_DATA_TYPE',0,varargin{:});
            
            % After setting the mask it this result can be seen on the TBT_TBT_WINDOW
            % !!!!!!! Below does not work yet !!!!!!!!!!!!!!!!
            % setpv('BPMx','TBT_ADC_MASK',ones(98,86));  % zero or one to mask the ADC samples to use to calculate TBT data
            % setpv('BPMx','TBT_ADC_MASK',repmat([zeros(43,1); ones(43,1)],1,98)');
            
            % Post mortem
            %info PM signal arrives ~78.5 SROC after event (6752 ADC Clocks)
            fprintf('Setting PM \n');
            local_setPV('BPMx','PM_CAPTURE',1,varargin{:}); %Enable PM Capture
            local_setPV('BPMx','PM_SOURCE_SELECT',0,varargin{:}); %Select external Trigger
            local_setPV('BPMx','PM_OFFSET',-15000,varargin{:});
            
            % Disable Spike removal for now ET 5/9/2017
            fprintf('Setting spike removal DISABLE\n');
            local_setPV('BPMx','TBT_SR_TBT_ENABLE',0,varargin{:});
            local_setPV('BPMx','TBT_SR_FA_ENABLE',0,varargin{:});
            
            % Set the libera IDs (careful as this will affect the FOFB)
            fprintf('Setting data BPM unique IDs\n');
            ids = dev2elem('BPMx',varargin{:});
            local_setPV('BPMx','ID',ids,varargin{:});
            
            fprintf('Setting data on demand PVs\n');
            % ACQM: now (1), Event (2), Stream (3) only for FA and SA
            % SCAN: passive (0), Event (1-unused), i/O interupt (2), periodic (3-9)
            % If SCAN==0 then sequence is .PROC --> [trigger] --> caget
            local_setPV('BPMx','ADC.ACQM',2,varargin{:});
            local_setPV('BPMx','ADC.SCAN',2,varargin{:});
            
            local_setPV('BPMx','TBT_TBT_WINDOW.ACQM',1,varargin{:});
            local_setPV('BPMx','TBT_TBT_WINDOW.SCAN',0,varargin{:});
            local_setPV('BPMx','TBT_TBT_WINDOW.PROC',0,varargin{:});
            
            local_setPV('BPMx','DDC_RAW.ACQM',2,varargin{:});
            local_setPV('BPMx','DDC_RAW.SCAN',0,varargin{:});
            local_setPV('BPMx','DDC_RAW.OFFS',23298,varargin{:});  % Offset relative to extraction trigger
            
            local_setPV('BPMx','DDC_SYNTH.ACQM',2,varargin{:});
            local_setPV('BPMx','DDC_SYNTH.SCAN',0,varargin{:});
            local_setPV('BPMx','DDC_SYNTH.OFFS',23298,varargin{:}); % Offset relative to extraction trigger
            
            local_setPV('BPMx','TDP_SYNTH.ACQM',2,varargin{:});
            local_setPV('BPMx','TDP_SYNTH.SCAN',2,varargin{:});
            local_setPV('BPMx','TDP_SYNTH.OFFS',23298,varargin{:}); % Offset relative to extraction trigger
            
            local_setPV('BPMx','PM_DDC_SYNTH.ACQM',2,varargin{:});
            local_setPV('BPMx','PM_DDC_SYNTH.SCAN',2,varargin{:});
            local_setPV('BPMx','PM_DDC_SYNTH.PROC',0,varargin{:});
            
            
            fprintf('Resetting MC PLL status monitor\n');
            srbpm.reset_pll_status;
            
        end
        
        %% Misc Functions
        
        function plotadcsynchronisation(varargin)
            % plotadcsynchronisation
            %
            % function to plot the adc channels to see if the TRIG_DELAY
            % and TBT_PHASE_OFFSET are set correctly.
            fprintf('Collecting ADC data... ');
            adc = getliberadata('ADC');
            fprintf('TBT_TBT_WINDOW data... ');
            tbtw = getliberadata('TBT_TBT_WINDOW');
            fprintf('done.\n');

            ii = 1:200;
            
            h = figure(301);
            set(h,'Position',[1794   44 1147 1124]);
            clf;
            subplot(1,2,1);
            surface(adc.a(:,ii) + adc.b(:,ii) + adc.c(:,ii) + adc.d(:,ii));
            shading flat;
            xlabel('BPM number');
            ylabel('Time (ADC samples)');
            title({'Sum ADC values';'Set TRIG_DELAY to align ADCs'},'Interpreter','None');
            axis tight;
            
            subplot(2,2,2);
            plot(adc.a(1,ii),'.-');
            hold on;
            plot(tbtw.a(1,ii),'r.-','LineWidth',1.5);
            a = axis;
            plot([86 86],[-16000 16000],'r--','LineWidth',1.5);
            axis(a);
            title({'BPM 1-1';'Set TBT_PHASE_OFFSET to put';'bunch train (red) within first 86 samples'}','Interpreter','None');
            legend('ADC','TBT TBT WINDOW');
            grid on;
            xlabel('Time (ADC samples)');
            ylabel('Amplitude (Counts)');
            
            subplot(2,2,4);
            plot(adc.a(3,ii),'.-');
            hold on;
            plot(tbtw.a(3,ii),'r.-','LineWidth',1.5);
            a = axis;
            plot([86 86],[-16000 16000],'r--','LineWidth',1.5);
            axis(a);
            title('BPM 1-3');
            grid on;
            xlabel('Time (ADC samples)');
            ylabel('Amplitude (Counts)');
        end
        
        function reset_pll_status(varargin)
            % Function to reset the PLL latched status monitor
            %  srbpm.reset_pll_status([DeviceList])
            %
            setfield('EVRX_PLL_MAX_ERR_RESET_CMD',0,varargin{:});
            setfield('EVRX_PLL_OS_UNLOCK_TIME_RESET_CMD',0,varargin{:});
            
        end
        
        function varargout = printraftemps(varargin)
            % table plots and/or returns the temperatures for all the BPMs
            %   temptable = printraftemps([DeviceList])
            if nargin > 0 && isnumeric(varargin{1})
                deviceList = varargin{1};
            else
                deviceList = getlist('BPMx');
            end
            for i=1:7
                raftemps{i} = local_getPV('BPMx', sprintf('ID_%d_VALUE',i), deviceList);
                temp = char(local_getPV('BPMx',sprintf('ID_%d_NAME',i),deviceList));
                temp = strrep(temp,'-','_');
                temp = strrep(temp,'.','_');
                raftempnames{i} = ['Temp_', temp];
            end
            rafrownames = strrep(cellstr(family2channel('BPMx',deviceList)),':SA_X_MONITOR','');
            
            t = table(raftemps{:},'VariableNames',raftempnames,'RowNames',rafrownames);
            if nargout > 0
                varargout{1} = t;
            end
            
        end
        
    end
    
    %% Other Methods
    methods
        function obj = srbpm
            obj.fullDeviceList =  family2dev('BPMx','',0);
            obj.bpmpvnames = cellstr(family2channel('BPMx',obj.fullDeviceList));
            obj.bpmpvnames = regexprep(obj.bpmpvnames,'SA_X_MONITOR','MYCOMMAND');
            obj.iocpvnames = regexprep(obj.bpmpvnames,'BPM0[1,2,3,4]','IOC41');
            obj.iocpvnames = regexprep(obj.iocpvnames,'BPM0[5,6,7,8]','IOC42');
        end
    end
end

%% Utility Functions

function output = local_getPV(varargin)
% Wrapper for getpv to try add some error handling.
    try
        output = getpv(varargin{:});
    catch
        warning('Problem using getpv. Are the BPMs online?');
        output = nan;
    end
end

function output = local_setPV(varargin)
% Wrapper for setpv to try add some error handling.
    try
       output = setpv(varargin{:});
    catch
       warning('Problem using setpv. Are the BPMs online?');
       output = nan;
    end
end

function varargout = getfield(field,varargin)
    % data = getfield(field,[DeviceList,...])
    %
    % Function to return an arbitrary field and is a wrapper for
    % getpv('BPMx',field,[DeviceList,...])
    if strncmpi(field,'evrx',4) || strncmpi(field,'gdx',4) || strncmpi(field,'box_status',4) || (strncmpi(field,'sync',4) && ~strncmpi(field,'sync_st_m',6))
        % Change the original SR01BPM01 channel names to SR01IOC41
        % temporarily then reset the channel names. 
        origpvnames = getfamilydata('BPMx','Monitor','ChannelNames');
        newpvnames = char(regexprep( regexprep(cellstr(origpvnames),'BPM0[1,2,3,4]','IOC41'), 'BPM0[5,6,7,8]','IOC42'));
        setfamilydata(newpvnames,'BPMx','Monitor','ChannelNames');

        try
            [data, tout, DataTime] = getpv( 'BPMx', field , varargin{:});
        catch
            warning('Problem using getpv. Are the BPMs online?');
            varargout = nan;
            return
        end
        
        % Put PVs back
        setfamilydata(origpvnames,'BPMx','Monitor','ChannelNames');
    else
        try
            [data, tout, DataTime] = getpv( 'BPMx', field , varargin{:});
        catch
            warning('Problem using getpv. Are the BPMs online?');
            varargout = nan;
            return
        end
    end
    
    varargout{1} = data;
    if nargout > 1
        varargout{2} = tout;
    end
    if nargout > 2
        varargout{3} = DataTime;
    end
end
        
function status = setfield(field,value,varargin)
    % data = setfield(field,value,[DeviceList,...])
    %
    % Function to return an arbitrary field and is a wrapper for
    % setpv('BPMx',field,value,[DeviceList,...])
    if strncmpi(field,'evrx',4) || strncmpi(field,'gdx',4) || strncmpi(field,'box_status',4) || (strncmpi(field,'sync',4) && ~strncmpi(field,'sync_st_m',6))
        % Change the original SR01BPM01 channel names to SR01IOC41
        % temporarily then reset the channel names. 
        origpvnames = getfamilydata('BPMx','Monitor','ChannelNames');
        newpvnames = char(regexprep( regexprep(cellstr(origpvnames),'BPM0[1,2,3,4]','IOC41'), 'BPM0[5,6,7,8]','IOC42'));
        setfamilydata(newpvnames,'BPMx','Monitor','ChannelNames');

        status = local_setPV( 'BPMx', field , value, varargin{:});
        % Put PVs back
        setfamilydata(origpvnames,'BPMx','Monitor','ChannelNames');
    else
        status = local_setPV( 'BPMx', field , value, varargin{:});
    end
end
        
        

