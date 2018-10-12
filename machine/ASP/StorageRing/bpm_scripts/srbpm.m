classdef srbpm
    % SRBPM is an object that contains functions related to the SR BPM
    % system. Below is a summary of the current functions. See help
    % srbpm.(method) to get more detail on how to use the function.
    %
    %  getfield:  a function to make it easier to access a particular PV on
    %             all the BPMs. Retrieves any PV where {BPM}:field
    %  setfield:  a function to make it easier to set a particular PV on all
    %             the BPMs. Sets the PV where {BPM}:field
    %
    %  setdefaultconfig: re-sets all the default configuration parameters
    %                    for the SR bpms.
    %
    %  getmaxadc: gets the maximum ADC count (across the 4 channels) from
    %             each of the BPMs
    %  getagc:    get the current state of the Auto Gain Control (AGC)
    %  setagc:    sets the state of the the Auto Gain Control (AGC).
    %
    %  getswitches: gets the state of the switches which is AND of two PVs.
    %               SWITCHING_ENABLE_CMD & DSC_COEFF_ADJUST_CMD
    %  setswitches: sets the default state of the switches. This is
    %               actually a combination of parameters that has been set
    %               and defined as "on" and "off".
    %
    %  ============== TIMING related methods ==================
    %  gettriggerevent: returns the general trigger event (T2) codes that
    %                   are used by the Libera EVR.
    %  settriggerevent: sets the general trigger event (T2) codes.
    %  setevrxmode: sets the default EVR mode for MC, T1 and T2 to 'RTC' or
    %               'External'
    %  trigger: manually sets the SR BPM event trigger on the EVG to a
    %           single trigger, continuous or stop.
    %
    %  getsyncstate: gets the syncronisation state of the BPMs.
    %  getmclock: returns the state of the machine clock (MC) lock.
    %  reset_pll_status: function to reset the latched PLL status monitor
    %  synchronise: function to synchronise all the active libera
    %               brilliance units using the SR BPM event code (7).
    %
    %  ============== POST MORTEM related methods ==================
    %  getpmevent: returns the Post Mortem Trigger Event (T1) codes that
    %              are used by the Libera EVR.
    %  setpmevent: sets the Post Mortem Trigger Event (T1) codes
    %  collectpmdata: script gets data from the post mortem buffer and
    %                 archives it to /asp/usr/data/bpmpmdata/
    %
    %  ============== ORBIT related methods ==================
    %  setoffset:          sets the offsets on the BPMs
    %  getoffset:          returns the offsets from the BPMs
    %  setarchivedoffsets: saves bpm offsets into an archive (.mat file)
    %  getarchivedoffsets: returns the arvhived bpm offsets
    %  getreferenceorbit: returns the reference orbit used by the orbit
    %                     feedback system.
    %  setreferenceorbit: sets the reference orbit used by the orbit
    %                     feedback system.
    %  stepreferenceorbit: step changes the reference orbit used by the
    %                      orbit feedback system.
    % 
    %  ============== PLOTTING related methods ==================
    %  plotadcsynchronisation: plots the synchronisation of the internal
    %                          acquistion clocks for fine tuning
    %                          TBT_PHASE_OFFSET.
    %  plotadc: plots the raw ADC data from the 4 RF channels to see if
    %           there are problems with the cable or RF input.
    %  plotfillpattern: plot the fill pattern using ADC data
    %  plotbetafunctions: uses TBT data to try and extract the beta
    %                     functions.
    % 
    %  printraftemps: returns and prints out a table of the internal sensor
    %                 temperaturs for all the bpms.
    % 
    %  
    %  Examples:
    %   >> help srbpm.settriggerevent
    %   >> srbpm.plotadc([12, 1])
    %   >> state = srbpm.getfield('TBT_SR_TBT_ENABLE_STATUS');
    %   >> srbpm.settriggerevent([7 5])
    %
    %
    % See Also: plotpmdata, getliberadata, getliberafadata
   
    properties (Access=public)
        sumoffset
        ks
        bpmgain
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
        
        %% Get Methods
        function varargout = getfield(field,varargin)
            % [data,tout,datatime,errorflag] = getfield(field,[DeviceList,...])
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
                    [data, tout, DataTime, ErrorFlag] = getpv( 'BPMx', field , varargin{:});
                catch
                    warning('Problem using getpv. Are the BPMs online?');
                    varargout{1} = nan;
                    varargout{2} = nan;
                    return
                end
                
                % Put PVs back
                setfamilydata(origpvnames,'BPMx','Monitor','ChannelNames');
            else
                try
                    [data, tout, DataTime, ErrorFlag] = getpv( 'BPMx', field , varargin{:});
                catch
                    warning('Problem using getpv. Are the BPMs online?');
                    varargout{1} = nan;
                    varargout{2} = nan;
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
            if nargout > 3
                varargout{4} = ErrorFlag;
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
            % Return the synchronisation state of all the BPMs (PV:
            % SYNC_ST_M_STATUS).
            %   0:NoSync, 1:tracking, 2:synchronised
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
            eventcode = srbpm.getfield('EVRX_RTC_T2_IN_FUNCTION_MONITOR', varargin{1:end});
        end
        
        function eventcode = getpmevent(varargin)
            % eventcode = getpmevent
            %
            % Get the current T1 (post mortem trigger) event codes
            eventcode = srbpm.getfield('EVRX_RTC_T1_IN_FUNCTION_MONITOR', varargin{1:end});
        end
        
        function status = getmclock(varargin)
            % mclockstate = getmclock([DeviceList]);
            %
            % Returns the state of the MC lock (EVRX_PLL_LOCKED)
            status = srbpm.getfield('EVRX_PLL_LOCKED_STATUS', varargin{1:end});
        end
        
        function status = getswitches(varargin)
            % switchstate = getswitches([DeviceList])
            %
            % Returns the state of the switches which is the state of 
            %   SWITCHING_ENABLE_CMD & DSC_COEFF_ADJUST_CMD
            
            sw  = logical(local_getPV('BPMx','SWITCHING_ENABLE_CMD',varargin{1:end}));
            dsc = logical(local_getPV('BPMx','DSC_COEFF_ADJUST_CMD',varargin{1:end}));
            
            status = double(sw & dsc);
        end
        
        
        %% Set Methods
        function setagc(varargin)
            % getagc(['on'/1,'off'/0],[DeviceList])
            %
            % Set the state of the Auto Gain Control (AGC)
            if nargin > 0
                switch varargin{1}
                    case {'on',  1}
                        local_setPV('BPMx','AGC_ENABLED_CMD',1,varargin{2:end});
                    case {'off', 0}
                        local_setPV('BPMx','AGC_ENABLED_CMD',0,varargin{2:end});
                end
            end
        end
         
        function setswitches(varargin)
            % setswitches(['on'/1,'off/0],[DeviceList])
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
                        local_setPV('BPMx','SWITCHING_ENABLE_CMD',1,varargin{2:end});
                        local_setPV('BPMx','DSC_COEFF_ADJUST_CMD',1,varargin{2:end});
                        local_setPV('BPMx','DSC_COEFF_TYPE_CMD',1,varargin{2:end});
                    case {'off', 0}
                        local_setPV('BPMx','SWITCHING_ENABLE_CMD',0,varargin{2:end});
                        local_setPV('BPMx','DSC_COEFF_ADJUST_CMD',0,varargin{2:end});
                        local_setPV('BPMx','DSC_COEFF_TYPE_CMD',1,varargin{2:end});
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
                        
            srbpm.setfield('EVRX_RTC_T2_IN_FUNCTION_SP', eventcodearr);
            srbpm.setfield('EVRX_RTC_T2_IN_MASK_SP',     eventmaskarr);
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
                        
            srbpm.setfield('EVRX_RTC_T1_IN_FUNCTION', eventcodearr);
            srbpm.setfield('EVRX_RTC_T1_IN_MASK',     eventmaskarr);
        end
        
        function setevrxmode(mode,varargin)
            % setevrxmode(mode,[DeviceList])
            % Set EVRx mode for MC, T1 and T2 to 'RTC' or 'External'.
            switch mode
                case 'RTC'
                    srbpm.setfield('EVRX_TRIGGERS_MC_SOURCE' , 5, varargin{:});
                    srbpm.setfield('EVRX_TRIGGERS_T0_SOURCE' , 0, varargin{:});
                    srbpm.setfield('EVRX_TRIGGERS_T1_SOURCE' , 5, varargin{:});
                    srbpm.setfield('EVRX_TRIGGERS_T2_SOURCE' , 5, varargin{:});
                case 'External'
                    srbpm.setfield('EVRX_TRIGGERS_MC_SOURCE' , 1, varargin{:});
                    srbpm.setfield('EVRX_TRIGGERS_T0_SOURCE' , 0, varargin{:});
                    srbpm.setfield('EVRX_TRIGGERS_T1_SOURCE' , 1, varargin{:});
                    srbpm.setfield('EVRX_TRIGGERS_T2_SOURCE' , 1, varargin{:});
                otherwise
                    disp('Nothing done');
            end
        end
        
        
        %% File I/O
        function varargout = getoffset(varargin)
            % [AM, tout, DataTime, ErrorFlag] = srbpm.getoffset - Returns horizontal or
            % vertical offsets in the liberas.
            %
            %  offset = srbpm.getoffset(Plane, [DeviceList])
            %
            % Plane: 'x' or 'y'
            % DeviceList: standard MML definition
            
            if nargin > 0 && ischar(varargin{1})
                switch lower(varargin{1})
                    case 'x'
                        %          [varargout{1} varargout{2} varargout{3} varargout{4}] = getlibera('ENV_X_OFFSET_MONITOR',varargin{2:end}); % AM, tout, DataTime
                        [varargout{1}, varargout{2}, varargout{3}, varargout{4}] = srbpm.getfield('OFF_X_SP',varargin{2:end}); % AM, tout, DataTime
                    case 'y'
                        %          [varargout{1} varargout{2} varargout{3} varargout{4}] = getlibera('ENV_Y_OFFSET_MONITOR',varargin{2:end}); % AM, tout, DataTime
                        [varargout{1}, varargout{2}, varargout{3}, varargout{4}] = srbpm.getfield('OFF_Y_SP',varargin{2:end}); % AM, tout, DataTime
                end
            else
                error('Error using srbpm.getoffset')
            end
        end
        
        function varargout = setoffset(varargin)
            % [AM, tout, DataTime, ErrorFlag] = srbpm.setoffset - Set horizontal or
            % vertical offsets in the liberas.
            %
            %  srbpm.setoffset(Plane, Vals, DeviceList)
            %
            % where Plane: 'x' or 'y' and DeviceList is the standard MML definition.
            % In the second option with no parameters at all it will print a list of
            % the archived offsets and ask the user which set to load.
            if nargin > 1 && ischar(varargin{1}) && isnumeric(varargin{2})
                switch lower(varargin{1})
                    case 'x'
                        status = srbpm.setfield('OFF_X_SP',varargin{2:end}); % AM, tout, DataTime
                    case 'y'
                        status = srbpm.setfield('OFF_Y_SP',varargin{2:end}); % AM, tout, DataTime
                    otherwise
                        error('Unknown plane: %s', varargin{1});
                end
            elseif nargin == 0
                printarchivedoffsets;
                id = str2num(input('Which set of offsets to load? ID number: ','s'));
                
                if ~isempty(id) && isnumeric(id) && isfinite(id)
                    [xoff yoff] = getarchivedliberaoffsets(id);
                    
                    ind = dev2elem('BPMx',getlist('BPMx'));
                    status = srbpm.setfield('OFF_X_SP',xoff(ind),getlist('BPMx'));
                    status = status | srbpm.setfield('OFF_Y_SP',yoff(ind),getlist('BPMx'));
                else
                    disp('Nothing applied');
                end
                
            else
                error('Error using srbpm.setoffset')
            end
            
            if nargout > 0
                varargout{1} = status;
            end
        end
        
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
            %
            % !!!!!!!!!! NOTE !!!!!!!
            %   offsets are ALWAYs archived in units of METERS.
            %   For the future I should just save the units of the values
            %   so as to avoid confusion. This came about when changing
            %   between units in MML where HW is in units of nm while
            %   Physics units are meters.
           
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
            srbpm.setfield('SYNC_CMD.PROC',1,varargin{:});
            
            fprintf('Waiting to get into tracking mode: ');
            while any( srbpm.getfield('SYNC_ST_M_STATUS') ~= 1 )
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
            pm = getliberadata('PM_DDC_SYNTH_SIGNAL');
            fprintf(' done\n');
            
            fprintf('Collecting Interlock Status and Offset... ');
            pm.ilkxstatus = srbpm.getfield('ILK_STATUS_X_STATUS');
            pm.ilkystatus = srbpm.getfield('ILK_STATUS_Y_STATUS');
            pm.ilk_mode_status = srbpm.getfield('ILK_ENABLED_STATUS');
            pm.offset = srbpm.getfield('PM_OFFSET_SP');
            fprintf(' done\n');
            
            fprintf('Acknowledging interlock status and resetting PM on the Libera...');
            srbpm.setfield('ILK_STATUS_RESET_CMD',0);
            srbpm.setfield('PM_CAPTURE_CMD',1);
            fprintf(' done\n');
            
            fprintf('Reseting the PM triggering system...');
            setpv('TS01EVR11:TTL03_ENABLE_CMD',1);
            pause(0.2);
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
            
            mysrbpm = srbpm;
            
            % =======================================================================
            % EVRX related PVs
            fprintf('Setting TRIGGER event 5 (extraction with gun) and 7 (SR BPM trigger)\n');
            mysrbpm.settriggerevent([5 7]);
            
            % We do not normally change the following and will only do this
            % if we know the timing settings have changed.
            
            % Make sure the decoder is turned on
%             mysrbpm.setfield('EVRX_RTC_DECODER_SWITCH_CMD' , 1, varargin{:});
%             % MC to trigger on SROC with a hex value of 0x0200
%             mysrbpm.setfield('EVRX_RTC_MC_IN_MASK_SP' ,     hex2dec('0210'), varargin{:});
%             mysrbpm.setfield('EVRX_RTC_MC_IN_FUNCTION_SP' , hex2dec('0210'), varargin{:});
%             
%             % Post mortem event is locked in as event code 10 (Beam Dump
%             % Event)
%             mysrbpm.setfield('EVRX_RTC_T1_IN_MASK_SP' ,     hex2dec('00ff'), varargin{:});
%             mysrbpm.setfield('EVRX_RTC_T1_IN_FUNCTION_SP' , 10             , varargin{:});
%             
%             % Trigger event is defaulted to event code 5 (ext with gun) and 7 (SR BPM Event)
%             mysrbpm.setfield('EVRX_RTC_T2_IN_MASK_SP' ,     hex2dec('00ff'), varargin{:});
%             
%             
%             % PLL offset tuning
%             fprintf('Setting PLL offset tune to 0 units (0 kHz) and no compensation: \n');
%             mysrbpm.setfield('EVRX_PLL_VCXO_OFFSET_MONITOR' ,0,varargin{:});
%             mysrbpm.setfield('EVRX_PLL_COMPENSATE_OFFSET_STATUS' ,0,varargin{:});


            % =======================================================================
            
            
            % AGC
            fprintf('Settting AGC to 1 (ENABLED)\n');
            if isnan(local_setPV('BPMx','AGC_ENABLED_CMD',1,varargin{:}))
               fprintf("Failed to set PV");
               return;
            end
            
            % Switches
            fprintf('Setting SWITCHES to 1 (ENABLED)\n');
            local_setPV('BPMx','SWITCHING_ENABLE_CMD',1,varargin{:});
            local_setPV('BPMx','SWITCHING_SOURCE_CMD',1,varargin{:});
            local_setPV('BPMx','SWITCHING_DELAY_SP',0,varargin{:});
            
            % Digital signal conditioning
            fprintf('Turning _ON_ DSC\n');
            local_setPV('BPMx','DSC_COEFF_ADJUST_CMD',1,varargin{:});
            local_setPV('BPMx','DSC_COEFF_TYPE_CMD',2,varargin{:});   %0-PHASE, 1-AMPLITUDE, 2-ADJUST
            local_setPV('BPMx','DSC_COEFF_ATT_DEPENDENT_CMD',0,varargin{:});
            
            % Gain
            fprintf('Setting GAINS \n');
            local_setPV('BPMx','KX_SP',14.8e6,varargin{:});
            local_setPV('BPMx','KY_SP',15.1e6,varargin{:});
            % local_setPV('BPMx','KS_SP',67108864,varargin{:});
            local_setPV('BPMx','KS_SP',mysrbpm.ks(el),varargin{:});
            
            % Libera Offsets
            [libera_offset_x, libera_offset_y] = mysrbpm.getarchivedoffsets('last');
            fprintf('Setting Libera Offsets \n');
            local_setPV('BPMx','OFF_X_SP',libera_offset_x(el),varargin{:});
            local_setPV('BPMx','OFF_Y_SP',libera_offset_y(el),varargin{:});
            local_setPV('BPMx','OFF_S_SP',mysrbpm.sumoffset(el),varargin{:});
            
            % Interlock
            fprintf('Setting INTERLOCKS \n');
%             gain_threshold = [...
%                 -23 -22 -23 -21 -21 -23 -23, ... %
%                 -23 -22 -29 -27 -28 -27 -27, ... %
%                 -29 -29 -31 -30 -31 -31 -31, ... %
%                 -25 -26 -26 -26 -26 -22 -22, ... %
%                 -23 -24 -25 -24 -23 -22 -21, ... %
%                 -30 -30 -32 -31 -31 -27 -26, ... %
%                 -33 -33 -34 -34 -33 -29 -29, ... %
%                 -28 -28 -29 -29 -28 -26 -24, ... %
%                 -26 -25 -27 -26 -27 -26 -23, ... %
%                 -26 -28 -29 -29 -29 -26 -26, ... %
%                 -26 -26 -27 -27 -27 -28 -26, ... %
%                 -28 -28 -29 -30 -30 -30 -30, ... %
%                 -24 -25 -25 -23 -23 -22 -23, ... %
%                 -24 -23 -24 -25 -25 -26 -25, ... %
%                 ]' + 3 ; gain_threshold(gain_threshold<-32) = -32;
            % For the new Brilliance+ the gain table is quite coarse and
            % our 10dB singal range due to cable lengths means that we have
            % to have a lower threshold 
            gain_threshold = repmat(-32,size(libera_offset_y)); 
            local_setPV('BPMx','ILK_LIMITS_MIN_X_SP',-1e6,deviceList);
            local_setPV('BPMx','ILK_LIMITS_MIN_Y_SP',-1e6,deviceList);
            local_setPV('BPMx','ILK_LIMITS_MAX_X_SP',+1e6,deviceList);
            local_setPV('BPMx','ILK_LIMITS_MAX_Y_SP',+1e6,deviceList);
            local_setPV('BPMx','ILK_GAIN_DEPENDENT_THRESHOLD_SP',gain_threshold(el),deviceList);
            
            % Index into deviceList for those that need to be interlocked
            % and those that don't need to
            ii_ikl = sort([find(deviceList(:,2) == 1 | deviceList(:,2) == 7); findrowindex([2 2; 2 3],getlist('BPMx'))]);
            ii_noilk = setxor(ii_ikl,1:size(deviceList,1));
            
            % ILK_GAIN_DEPENDENT_ENABLED_CMD must come first before
            % ILK_ENABLED_CMD otherwise you risk dumping beam!!
            local_setPV('BPMx','ILK_GAIN_DEPENDENT_ENABLED_CMD',1,deviceList(ii_ikl,:));
            local_setPV('BPMx','ILK_ENABLED_CMD',1,deviceList(ii_ikl,:));
            
            % Disable the interlocks for those that we do not need.
            local_setPV('BPMx','ILK_ENABLED_CMD',0,deviceList(ii_noilk,:));
            local_setPV('BPMx','ILK_GAIN_DEPENDENT_ENABLED_CMD',0,deviceList(ii_noilk,:));
            
            local_setPV('BPMx','ILK_STATUS_RESET_CMD',0,deviceList);
            
            delay=[
                29   102   188   288   356   461   514   545   479   421   354   299   204   134
                25   101   189   290   358   462   517   545   479   421   355   300   206   133
                27   115   193   294   361   465   518   549   484   424   358   302   203   138
                26   113   192   292   360   465   520   550   482   423   358   303   204   137
                4    89   169   271   337   447   491   527   459   401   334   282   181   113
                7    89   172   261   333   436   494   519   457   396   337   284   180   116
                7    90   171   263   333   438   495   521   455   395   339   284   178   117];
            
            % Commands to easily adjust the libera parameters
%             setpv('BPMx','TRIG_DELAY_SP',delay(:));
%             setpv('BPMx','TBT_PHASE_OFFSET_SP',40);
            
            local_setPV('BPMx','TRIG_DELAY_SP',delay(el),deviceList); % Send default
            % SR02BPM01:TBT_TBT_WINDOW.ChannelA --> set offset so that data 1 to 86 is
            % used for turn 1, 87 to 172 for turn 2, etc.
            % With an offset of 20, we make sure that injecting in bucket 1
            % is always within the "turn" integration window.
            local_setPV('BPMx','TBT_PHASE_OFFSET_SP',20,varargin{:});
            
            
            % Setting whether to use DDC (0) or TDP (1) tbt data for decimated data
            local_setPV('BPMx','TBT_DATA_TYPE_CMD',0,varargin{:});
            
            % After setting the mask it this result can be seen on the TBT_TBT_WINDOW
            % !!!!!!! Below does not work yet !!!!!!!!!!!!!!!!
            % setpv('BPMx','TBT_ADC_MASK',ones(98,86));  % zero or one to mask the ADC samples to use to calculate TBT data
            % setpv('BPMx','TBT_ADC_MASK',repmat([zeros(43,1); ones(43,1)],1,98)');
            
            % Post mortem
            %info PM signal arrives ~78.5 SROC after event (6752 ADC Clocks)
            fprintf('Setting PM \n');
            local_setPV('BPMx','PM_CAPTURE_CMD',1,varargin{:}); %Enable PM Capture
            local_setPV('BPMx','PM_SOURCE_SELECT_CMD',0,varargin{:}); %Select external Trigger
            % Collects data from -20000 turns to trigger point. Therefore
            % an offset of 2000 means that it collects data from -18000 to
            % +2000 where 0 is when the trigger occured.
            local_setPV('BPMx','PM_OFFSET_SP',10000,varargin{:});
            
            % Disable Spike removal for now ET 5/9/2017
            % to re-enable we will have to also do a BBA with them enabled.
            % There is something to be gained by enabling the FA spike
            % removal as this should further drop the noise floor for the
            % FA data. HOWEVER we will need to do a BBA or re-calibrate the
            % offsets immediately after enabling this feature. We can do
            % this by doing a orbit before and orbit after to calculate the
            % necessary changes to the offsets.
            % the spike removal from TBT data however is questionable as
            % it adds unwanted features in the spectrum when you do an FFT.
            fprintf('Setting spike removal DISABLE\n');
            local_setPV('BPMx','TBT_SR_TBT_ENABLE_CMD',0,varargin{:});
            local_setPV('BPMx','TBT_SR_FA_ENABLE_CMD',0,varargin{:});
            
            % Set the libera IDs (careful as this will affect the FOFB)
            fprintf('Setting data BPM unique IDs\n');
            ids = dev2elem('BPMx',varargin{:});
            local_setPV('BPMx','ID_SP',ids,varargin{:});
            
            % configure the statistics gathering
            fprintf('Settingg the parameters for STATISTICS\n');
            local_setPV('BPMx','STAT_SA_STEP_SP',10,varargin{:});
            local_setPV('BPMx','STAT_SA_WINDOW_SP',100,varargin{:});
            local_setPV('BPMx','STAT_TBT_PERIOD_SP',5,varargin{:});
            local_setPV('BPMx','STAT_TBT_WINDOW_SP',1000,varargin{:});
            local_setPV('BPMx','STAT_TBT_MODE_CMD',1,varargin{:});

            
            fprintf('Setting data on demand PVs\n');
            % ACQM: now (1), Event (2), Stream (3) only for FA and SA
            % SCAN: passive (0), Event (1-unused), i/O interupt (2), periodic (3-9)
            % If SCAN==0 then sequence is .PROC --> [trigger] --> caget
            %
            % 29/01/2018:tane: as of now you have to set the scan to
            % passive (0) first before changing the acquisition mode then
            % resetting the scan mode to your desired scan.
            fprintf('  - ADC_SIGNAL');
            local_setPV('BPMx','ADC_SIGNAL.SCAN',0 ,varargin{:});
            local_setPV('BPMx','ADC_SIGNAL.ACQM',2,varargin{:});
            local_setPV('BPMx','ADC_SIGNAL.SCAN',2,varargin{:});
%             local_setPV('BPMx','ADC_SIGNAL.SCAN',2,varargin{:});
            
            fprintf(',TBT_TBT_WINDOW_SIGNAL');
            % The acqm must be now(1) and scan set to passive(0).
            local_setPV('BPMx','TBT_TBT_WINDOW_SIGNAL.SCAN',0,varargin{:});
            local_setPV('BPMx','TBT_TBT_WINDOW_SIGNAL.ACQM',1,varargin{:});
            local_setPV('BPMx','TBT_TBT_WINDOW_SIGNAL.PROC',0,varargin{:});
            
            fprintf(',DDC_RAW_SIGNAL');
            local_setPV('BPMx','DDC_RAW_SIGNAL.SCAN',0,varargin{:});
            local_setPV('BPMx','DDC_RAW_SIGNAL.ACQM',1,varargin{:});
            local_setPV('BPMx','DDC_RAW_SIGNAL.OFFS',23198,varargin{:});  % Offset relative to extraction trigger
            
            fprintf(',DDC_SYNTH_SIGNAL');
            local_setPV('BPMx','DDC_SYNTH_SIGNAL.SCAN',0,varargin{:});
            local_setPV('BPMx','DDC_SYNTH_SIGNAL.ACQM',2,varargin{:});
            local_setPV('BPMx','DDC_SYNTH_SIGNAL.SCAN',2,varargin{:});
            local_setPV('BPMx','DDC_SYNTH_SIGNAL.OFFS',23198,varargin{:}); % Offset relative to extraction trigger
            
                        
            fprintf(',TDP_SYNTH_SIGNAL');
            local_setPV('BPMx','TDP_SYNTH_SIGNAL.SCAN',0,varargin{:});
            local_setPV('BPMx','TDP_SYNTH_SIGNAL.ACQM',2,varargin{:});
            local_setPV('BPMx','TDP_SYNTH_SIGNAL.SCAN',2,varargin{:});
            local_setPV('BPMx','TDP_SYNTH_SIGNAL.OFFS',23198,varargin{:}); % Offset relative to extraction trigger
            
            fprintf(',PM_DDC_SYNTH_SIGNAL');
            local_setPV('BPMx','PM_DDC_SYNTH_SIGNAL.SCAN',0,varargin{:});
            local_setPV('BPMx','PM_DDC_SYNTH_SIGNAL.ACQM',2,varargin{:});
            local_setPV('BPMx','PM_DDC_SYNTH_SIGNAL.SCAN',2,varargin{:});
            local_setPV('BPMx','PM_DDC_SYNTH_SIGNAL.OFFS',0,varargin{:});
            
            fprintf(',PM_DDC_RAW_SIGNAL');
            local_setPV('BPMx','PM_DDC_RAW_SIGNAL.SCAN',0,varargin{:});
            local_setPV('BPMx','PM_DDC_RAW_SIGNAL.ACQM',2,varargin{:});
            local_setPV('BPMx','PM_DDC_RAW_SIGNAL.SCAN',2,varargin{:});
            local_setPV('BPMx','PM_DDC_RAW_SIGNAL.OFFS',0,varargin{:});
            
            % the proc pv doesn't appear to have a ca_put_callback. By
            % default setpv in Matlab waits for a callback before returning
            % therefore this part of the code will hang.
%             local_setPV('BPMx','PM_DDC_SYNTH_MONITOR.PROC',0,varargin{:});

            fprintf(' done.\n');
            
            fprintf('Resetting MC PLL status monitor\n');
            mysrbpm.reset_pll_status;
            
        end
        
        %% Misc Functions
        
        function plotadcsynchronisation(varargin)
            % plotadcsynchronisation
            %
            % function to plot the adc channels to see if the TRIG_DELAY
            % and TBT_PHASE_OFFSET are set correctly.
            fprintf('Collecting ADC data... ');
            adc = getliberadata('ADC_SIGNAL');
            fprintf('TBT_TBT_WINDOW data... ');
            tbtw = getliberadata('TBT_TBT_WINDOW_SIGNAL');
            fprintf('done.\n');

            ii = 1:200;
            
            h = figure(301);
            set(h,'Position',[1794   44 1147 1124]);
            clf;
            subplot(1,2,1);
            surface(ii,[1:98]/7+1,adc.a(:,ii) + adc.b(:,ii) + adc.c(:,ii) + adc.d(:,ii));
            shading flat;
            ylabel('BPM number');
            xlabel('Time (ADC samples)');
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
        
        function plotadc(DeviceList)
            % Function to plot the ADC values for a particular BPM
            %  srbpm.plotadc(DeviceList)
            if nargin < 1
                error('%s.plotadc: requires a device list or element number as an input parameter',mfilename);
            end
            adc = getliberadata('ADC_SIGNAL',DeviceList);
            
            for i=1:size(adc.a,1)
                h = figure(301);
                clf;
                ax(1) = subplot(2,2,1);
                plot(adc.a(i,:));
                title('A'); xlabel('samples'); ylabel('counts'); grid on;
                ax(2) = subplot(2,2,2);
                plot(adc.b(i,:));
                title('B'); xlabel('samples'); ylabel('counts'); grid on;
                ax(3) = subplot(2,2,3);
                plot(adc.c(i,:));
                title('C'); xlabel('samples'); ylabel('counts'); grid on;
                ax(4) = subplot(2,2,4);
                plot(adc.d(i,:));
                title('D'); xlabel('samples'); ylabel('counts'); grid on;
                
                linkaxes(ax,'x');
                
                % Create textbox
                annotation(h,'textbox',...
                    [0.380853983415142 0.946275307747930 0.265826498520414 0.030100333883345],...
                    'String',{sprintf('BPM [%02d, %02d]',adc.DeviceList(i,:))},...
                    'HorizontalAlignment','Center','FontSize',11);
                
                if size(adc.a,1) > 1
                    fprintf('Plotting for BPM [%02d, %02d]. Press any key to plot the next BPM...\n', adc.DeviceList(i,:));
                    pause;
                end
            end
        end
        
        function plotfillpattern
            % Use the ADC data from the Libera B+ to extract the fill
            % pattern. Data will only refresh when there is a trigger.
            adc = getliberadata('ADC_SIGNAL');
            
            inter_freq = 360/86 - 4;   % expected intermediate freq
            N2 = length(adc.a)/2;
            ii = [1:(N2-1*256*2.25), (N2+1*256*2.25):(N2*2)];
            
            % Quadrature mixing at the IF 
            br = cos(2*pi*inter_freq*(0:length(adc.a)-1));
            bi = sin(2*pi*inter_freq*(0:length(adc.a)-1));
            
            mixa = abs(adc.a .* complex(br,bi));
            % a low pass filter
            ffta = fftshift(fft(mixa,[],2));
            ffta(:,ii) = 0;
            newa = ifft( ifftshift(ffta) ,[],2);

            mixb = abs(adc.b .* complex(br,bi));
            % a low pass filter
            fftb = fftshift(fft(mixb,[],2));
            fftb(:,ii) = 0;
            newb = ifft( ifftshift(fftb) ,[],2);
            
            mixc = abs(adc.c .* complex(br,bi));
            % a low pass filter
            fftc = fftshift(fft(mixc,[],2));
            fftc(:,ii) = 0;
            newc = ifft( ifftshift(fftc) ,[],2);

            mixd = abs(adc.d .* complex(br,bi));
            % a low pass filter
            fftd = fftshift(fft(mixd,[],2));
            fftd(:,ii) = 0;
            newd = ifft( ifftshift(fftd) ,[],2);
            
            
            
            dt = 8.377502778920296e-09;
            t = (0:(N2*2-1))*dt * 1e6;
            figure(8); clf;
            plot(t,abs(real(newa(3,:)+newb(3,:)+newc(3,:)+newd(3,:))),'.-');
            hold on;
            % Average over multiple revolutions and plot only one fill
            % pattern.
%             [newt,newtind]=sort(mod(t,0.72046520));
%             plot(newt, abs(real(newa(3,newtind)+newb(3,newtind)+newc(3,newtind)+newd(3,newtind))),'.-');
%             plot(t,abs(real(newb(3,:))),'.-');
            fpmdata = getfpm * 1.07 * max(ylim);
            t = (0:359)*0.002 + 0.26;
            plot(t, fpmdata);
            xlim([0 1.5]);
            grid on;
            xlabel('Time (us)');
            ylabel('Amplitude (arb)');
            legend('Channel A+B+C+D','FPM');
            title('BPM 1-3');
        end

        function plotbetafunctions(varargin)
            % Function that uses the TBT data during injection to extract
            % the beta function. The caveat is that it looks for an
            % injection event using the horizontal position. Makes the
            % following analysis
            %   1. remove DC component, takes the last 100 samples as the
            %      reference/DC component
            %   2. find first sample where the horizontal orbit exceeds 500
            %      um. 
            %   3. skips the first 10 samples as we assume this contains
            %      the kicker pulse. We only want the residual oscillations
            %   4. use 200 samples and extract the fundamental spatial
            %      modes using SVD. Plot the amplitude function of the two
            %      modes sqrt( mode1^2 + mode2^2 );
            
            mysrbpm = srbpm;
            
            data = getliberadata('TDP_SYNTH_SIGNAL');
            
            x = data.x - mean(data.x(:,end-100:end),2);
            y = data.y - mean(data.y(:,end-100:end),2);
            
            ix = find( abs(x(1,:)) > 500000 , 1, 'first') + 200;
            iy = find( abs(x(1,:)) > 500000 , 1, 'first') + 30;
            
            if isempty(ix)
                fprintf('No TBT betatron oscillations detected. Cannot plot beta functions.\n');
                return
            end
            
            [ux,sx,vx]=svd(x(:,ix:ix+100)); 
            sx = diag(sx);
            [uy,sy,vy]=svd(y(:,iy:iy+100)); 
            sy = diag(sy);
            
            mach = machine_at;
            bpmind = family2atindex('BPMx');
            
            figure(121);
            clf;
            subplot(2,1,1);
            measbetax = mysrbpm.bpmgain(:,1).*( (ux(:,1) * sx(1)).^2  + (ux(:,2) * sx(2)).^2 );
            plot( mach.spos(bpmind), mach.betax(bpmind)/sum(mach.betax(bpmind)) * sum(measbetax) ,'--','LineWidth',2);
            hold on;
            plot( getspos('BPMx'), measbetax, '.-');
            xlabel('S (m)');
            ylabel('\beta_x (arb)');
            grid on;
            xlim([0 216]);
            
            
            subplot(2,1,2);
            measbetay = mysrbpm.bpmgain(:,2).*( (uy(:,1) * sy(1)).^2 + (uy(:,2)* sy(2)).^2  );
            plot( mach.spos(bpmind), mach.betay(bpmind)/sum(mach.betay(bpmind)) * sum(measbetay) ,'--','LineWidth',2);
            hold on;
            plot( getspos('BPMx'), measbetay, '.-');
            xlabel('S (m)');
            ylabel('\beta_y (arb)');
            grid on;
            xlim([0 216]);
            
            plotelementsat;
            
            subplot(2,1,2);
            legend('Model (Normalised)','Extracted from TBT','Location','northoutside','Orientation','Horizontal');
        end
        
        function reset_pll_status(varargin)
            % Function to reset the latched PLL status monitor
            %  srbpm.reset_pll_status([DeviceList])
            %
            srbpm.setfield('EVRX_PLL_MAX_ERR_RESET_CMD',0,varargin{:});
            srbpm.setfield('EVRX_PLL_OS_UNLOCK_TIME_RESET_CMD',0,varargin{:});
            
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
        
        function varargout = getreferenceorbit(varargin)
            % function to return the x and y reference orbits
            %   [xref, yref] = getreferenceorbit([DeviceList])
            % where xref and yref are the reference orbits that the orbit
            % feedback system uses to stabilise the orbit. DeviceList
            % defaults to all BPMs.
            if nargin > 0 && isnumeric(varargin{1})
                deviceList = varargin{1};
            else
                deviceList = getlist('BPMx');
            end
            el = dev2elem('BPMx',deviceList);
            
            xref = getpv('SR00:X_REFERENCE_ORBIT_SP');
            yref = getpv('SR00:Y_REFERENCE_ORBIT_SP');
            
            varargout{1} = xref(el);
            if nargout > 1
                varargout{2} = yref(el);
            end
            
        end
        
        function setreferenceorbit(xref, yref, varargin)
            % function to set the x and y reference orbits
            %   setreferenceorbit(xref, yref, [DeviceList])
            % where xref and yref are the reference orbits that the orbit
            % feedback system uses to stabilise the orbit. DeviceList
            % defaults to all BPMs.
            if nargin > 2 && isnumeric(varargin{1})
                deviceList = varargin{1};
            else
                deviceList = getlist('BPMx');
            end
            el = dev2elem('BPMx',deviceList);
            
            xref0 = getpv('SR00:X_REFERENCE_ORBIT_SP');
            yref0 = getpv('SR00:Y_REFERENCE_ORBIT_SP');
            
            xref0(el) = xref;
            yref0(el) = yref;
            
            setpv('SR00:X_REFERENCE_ORBIT_SP',xref0);
            setpv('SR00:Y_REFERENCE_ORBIT_SP',yref0);
            % Necessary to ensure that the FOFB updated with the new
            % reference orbit
            setpv('SR00FPGA01:X_REF_ORBIT_SP',xref0);
            setpv('SR00FPGA01:Y_REF_ORBIT_SP',yref0);
        end
        
        function stepreferenceorbit(dxref, dyref, varargin)
            % function to set the x and y reference orbits
            %   stepreferenceorbit(dxref, dyref, [DeviceList])
            % where dxref and dyref are the incremental change in the 
            % reference orbits that the orbit feedback system uses to
            % stabilise the orbit. DeviceList defaults to all BPMs.
            if nargin > 2 && isnumeric(varargin{1})
                deviceList = varargin{1};
            else
                deviceList = getlist('BPMx');
            end
            el = dev2elem('BPMx',deviceList);
            
            xref0 = getpv('SR00:X_REFERENCE_ORBIT_SP');
            yref0 = getpv('SR00:Y_REFERENCE_ORBIT_SP');
            
            xref0(el) = xref0(el) + dxref;
            yref0(el) = yref0(el) + dyref;
            
            % Necessary to ensure that the FOFB updated with the new
            % reference orbit
            setpv('SR00FPGA01:X_REF_ORBIT_SP',xref0);
            setpv('SR00FPGA01:Y_REF_ORBIT_SP',yref0);
            
            setpv('SR00:X_REFERENCE_ORBIT_SP',xref0);
            setpv('SR00:Y_REFERENCE_ORBIT_SP',yref0);
            
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
            obj.ks = [
                8.853144058638271
                8.553306227504132
                8.709132643088015
                8.477664456962398
                8.233688939144534
                8.895346739566085
                8.721513375075650
                9.103217124052739
                8.999880217452990
                6.606422763758233
                6.407833139336645
                5.562751575849251
                5.413825461056707
                5.053280276363035
                6.991592129366940
                7.481833719548828
                8.281085417262730
                7.925489448484424
                7.914870034764797
                8.162522846617552
                8.171564386392882
                3.660878471680461
                3.413765681521329
                5.036065454589901
                4.815456587262468
                4.604935339579755
                8.371365821865076
                8.651566704317215
                9.125604474249256
                9.239282285827398
                2.671642243071018
                9.698171364999478
                9.570043697681594
                8.242264363336110
                8.375851661989921
                7.543909697039786
                7.629795359470272
                8.440516983045685
                8.332406374729588
                7.791323076737103
                4.655329538099621
                4.603700490577416
                5.372786227190657
                5.585528578962895
                6.540146185660331
                6.553028466806546
                5.904565380688806
                9.355732822203581
                9.367068332590062
                6.039076724951013
                5.877083820690847
                7.119030158217719
                6.749281256413786
                6.334805091123380
                3.236166925518648
                3.703253650372533
                4.325761779448408
                4.211005860626395
                5.628944846571070
                5.373084728836499
                4.910786478512518
                2.811053706835495
                9.803054080498494
                5.867845405424647
                5.615183042150490
                6.708891187270635
                6.786661275722777
                6.142381584574993
                3.965525957698259
                4.006345295554352
                4.234393567820267
                4.181619441099762
                5.118671561855333
                5.006864741800872
                4.842279664109178
                5.409323329157485
                6.026071865507837
                6.955325231431114
                6.613194868350434
                7.687788776692916
                7.507718094764419
                7.105881640403740
                7.640416058346170
                7.660964783297761
                9.790246546623754
                3.019178964094080
                2.603690545016278
                9.559704405793719
                9.343961628044473
                8.939288350455401
                8.865611882508913
                9.798036611388095
                9.445557552438173
                3.343369796160038
                9.789639106597445
                9.769521857642903
                3.144556886316249
                3.376069939210053]*1e7;
            obj.sumoffset = [
                -37794968
                -33713000
                -35837667
                -32686512
                -29364150
                -38373965
                -36006511
                -41202651
                -39796127
                -7211087
                -4507444
                6995619
                9025526
                13940586
                -12486410
                -19157585
                -30027606
                -25184305
                -25047272
                -28423461
                -28529769
                32896940
                36260764
                14181087
                17185244
                20042584
                -31235587
                -35047966
                -41513719
                -43063319
                46354078
                -49311153
                -47570392
                -29491103
                -31301076
                -19963944
                -21134002
                -32171762
                -30700330
                -23335674
                19364488
                20070222
                9599938
                6704088
                -6294716
                -6470263
                2353816
                -44638423
                -44790333
                513376
                2716546
                -14186651
                -9155438
                -3527839
                38646868
                -56088284
                23886219
                25445830
                6129850
                9612204
                15898680
                44488253
                -50722387
                2846162
                6284323
                -8604653
                -9660656
                -880406
                28761466
                28214592
                25066359
                25794402
                13047079
                14572006
                16795486
                9084446
                694647
                -11958341
                -7299881
                -21931451
                -19483184
                -14015294
                -21294123
                -21564190
                -50551628
                41638356
                47290127
                -47417794
                -44470947
                -38961451
                -37959938
                -50661637
                -45861868
                37215126
                -50549385
                -50266332
                39943356
                -54711490
                ];
            obj.bpmgain = [
                1.019790109888349   0.949249236697061
                1.024345702167348   0.944567780180548
                1.028407517410135   0.949971969517302
                1.020991304026051   0.949754897634992
                1.021849017694516   0.949577106063936
                1.025037670416168   0.947907821687370
                1.017501470167591   0.947592777966483
                1.024632857704001   0.944949791219086
                1.022079367144060   0.944685038931816
                1.028511008951802   0.950372296240851
                1.030136333826651   0.950350485323705
                1.020682111166259   0.948336665697476
                1.031556858365583   0.944907524436659
                1.009291932163525   0.948464064620007
                1.001278289551558   0.953965386019827
                1.023103845670566   0.946160238296460
                1.030402019475276   0.951593430397251
                1.024146312673317   0.953414683578349
                1.020729066883117   0.949077046775849
                1.023846696209035   0.945414799066340
                1.018143559950577   0.944143527629333
                1.017925418129258   0.944617884435187
                1.023412423446008   0.943081823899102
                1.031924980084887   0.949018137851589
                1.026382021997893   0.949941703778988
                1.022458007452477   0.948457253608398
                1.027280512177995   0.949214139867137
                1.021997143239133   0.944288603523116
                1.021074628188609   0.945520163985390
                1.021691607862558   0.945829924189481
                1.029941389181460   0.951970829792339
                1.024481714154421   0.948857280999855
                1.017871754557471   0.948878478965569
                1.032758752996909   0.944015928733466
                1.024448402969096   0.941102863729423
                1.029698260057182   0.940474056955320
                1.022693771154018   0.945973422540821
                1.030544121758183   0.950547633996902
                1.026212659683978   0.950647145431741
                1.021407530136615   0.944867450035861
                1.031619838497942   0.949141416218957
                1.021382522307063   0.945342040171411
                1.021057527546628   0.943223842692008
                1.023746796550166   0.944275805748237
                1.027538119417079   0.951558042146971
                1.029456301004033   0.948490243940171
                1.018177972100218   0.950573185796091
                1.034452259395351   0.946740254185632
                1.024147881810003   0.942881200945415
                1.038325846809106   0.936561741800745
                1.022572791412994   0.943006647874190
                1.027122655196820   0.958706283595653
                1.025506825923074   0.952733083899000
                1.016215347893387   0.954396898514942
                1.029273031839981   0.949011613738053
                1.007064310784053   0.952589983950634
                1.016318457809970   0.944735626524407
                1.019237109964916   0.943936810762869
                1.030792749899852   0.949791147416936
                1.026964606033962   0.952633795347244
                1.018846527268870   0.949914297621846
                1.023960828093981   0.947513016431224
                1.020223576489132   0.945300297769261
                1.006519198340487   0.950645913942196
                1.021513235834946   0.944912992629821
                1.031792920092355   0.950142626826064
                1.027376776130119   0.950682774407246
                1.020884936363761   0.947392195057050
                1.028636597037438   0.948004087742045
                1.019025182396520   0.943955259689677
                1.020545204425863   0.945517066632875
                1.022885700217636   0.945411996357065
                1.029142102233283   0.953451620100816
                1.030005772502432   0.952283871955482
                1.017581952880327   0.949416416849636
                1.028470983014986   0.947735052660074
                1.013344871828959   0.948743169882161
                1.013532090189818   0.950370439122627
                1.022328613980134   0.946130470255584
                1.029026841823260   0.951594758454078
                1.026216978697642   0.951406205219404
                1.020289851575935   0.953767887022197
                1.031488922711221   0.948220981231094
                1.020132484357270   0.947084079353503
                1.017546520163332   0.944178949835829
                1.018594771147928   0.942441745340540
                1.028679136500693   0.947776610642991
                1.028410765350595   0.951171327672612
                1.022751556141560   0.949473473570070
                1.035406953996921   0.948267624382191
                1.018176205632190   0.947973893186085
                1.029789721519192   0.940961615137810
                1.025537211988558   0.943228906137280
                1.028086681301332   0.950763553589283
                1.026763830522217   0.951615684296115
                1.020705832577648   0.951536321031235
                1.031131510436517   0.949371115034835
                1.029865390300549   0.944310705084420];
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
%     try
       output = setpv(varargin{:});
%     catch
%        warning('Problem using setpv. Are the BPMs online?');
%        output = nan;
%     end
end

        

        
        

