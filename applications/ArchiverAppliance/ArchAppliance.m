classdef ArchAppliance
    %ArchAppliance Interface to the SLAC Archiver Appliance
    %   The Archiver Appliance (http://epicsarchiverap.sourceforge.net)
    %   allows many operations via a REST-style HTTP interface.
    %   This class makes these operations simple from Matlab.
	%
	%   EXAMPLES
	%     aa = ArchAppliance(); % Create default instance
	%     data = aa.getData('mypv', '2013-10-14T08:00:00Z', '2013-10-15T08:00:00Z')
	%
	%   PROPERTY INITIALIZATION:
	%   The properties for this class may be set through an initialization
	%   file (pointed to by $ARCHAPPL_INIFILE), environment variables,
    %	and/or through arguments to the constructor.  
	%   The order of precedence follows this order, so parameters set
	%   in the initialization file are overridden by individual
	%   environment variables, and environment variables are overridden
	%   by arguments to the constructor.
	%
	%   The environment variables are:
	%   ARCHAPPL_INIFILE: path/filename to the initialization file.  The
	%   file format is name=value, one per line, where the allowable names
	%   are the remaining environment variables.
	%   ARCHAPPL_HOSTNAME: DNS name (or ip address) of the server where
	%   an archiver appliance can be contacted.  The data retrieval and
	%   management components must both be running on the host.
	%   ARCHAPPL_RETRIEVALPORT: Port number at which the retrieval
	%   component can be reached.  Default = 17668.
	%   ARCHAPPL_MGMTPORT: Port number at which the management
	%   component can be reached.  Default = 17665.
	%   ARCHAPPL_RETRIEVALPATH: Base path to the retrieval component.
	%   Default is "/retrieval/data/", and should not need to be changed.
	%   ARCHAPPL_MGMTPATH: Base path to the management component.
	%   Default is "/mgmt/bpl/", and should not need to be changed.
    %
	%   See also getAAData
	%
	%   Copyright (c) Lawrence Berkeley National Laboratory
    properties
        % The server name where the archiver appliance can be contacted
        hostname = 'arch02.als.lbl.gov';
        % The port on which the retrieval engine runs
        retrievalport = 17668;
        % The URL base path for the retrieval component.  This should never
        % need to be changed.
        retrievalpath = '/retrieval/data/';
        % The URL base path for the management component.  This should never
        % need to be changed.
        mgmtpath = '/mgmt/bpl/';
        % The port on which the management component runs
        mgmtport = 17665;
        
    end
    
    methods
        function AA = ArchAppliance(hostname, retrievalport, mgmtport, retrievalpath, mgmtpath)
            %Constructor all arguments are optional
			% If any arguments are specified, they will override the environment variables
            % Arguments:
            % hostname: string the appliance server name
            % retrievalpath: string the base of the retrieval URL path
			% mgmtpath: string the base of the management URL path
            % retrievalport: integer the port of the retrieval component
			% mgmtport: integer the port of the management component
            narginchk(0,5);
			AA = AA.initializeEnvironment();
            if nargin >= 1
                AA.hostname = hostname;
            end
            if nargin >= 2
                AA.retrievalport = retrievalport;
            end
            if nargin >= 3
				AA.mgmtport = mgmtport;
			end
			if nargin >= 4
                AA.retrievalpath = retrievalpath;
            end
			if nargin >= 5
                AA.mgmtpath = mgmtpath;
            end
        end
        
        function dat = getData(AA, pvname, from, to)
            %getData Retrieve data for a pv from the archiver appliance
            %Retrieves data for pvname over the time period from:to
            %pvname: the name of the pv
            %from: the start date/time in ISO 8601 format
            %to: the end date/time in ISO 8601 format
            %Note on time format: Use YYYY-MM-DDTHH:MM:SS.FFFZ.  The
            %timezone may replace Z, e.g. -08 for PST.
            %Returns a 1x1 struct containing subelements header and data.
            %These are each structs with the elements:
            % header:
            %   source (e.g. "Archiver appliance")
            %   pvName
            %   from = startdate in UTC
            %   to = enddate in UTC
            % data: (N = #samples retrieved)
            %   values = Nx1 double, or NxM double if pv is a waveform
            %   epochSeconds = Nx1 int64
            %   nanos = Nx1 int64
            %   isDST = Nx1 uint8

            url = strcat('http://', AA.hostname, ...
                    ':', int2str(AA.retrievalport), ...
                    AA.retrievalpath, ...
                    'getData.mat');
            urlwrite(url, 'AAtemp.mat', 'get', ...
                {'pv', pvname, ...
                'from', from, ...
                'to', to});
            dat = load('AAtemp.mat');
            delete('AAtemp.mat');
        end
        
        function lst = getPVs(AA, wildcard)
            %getPVs Retrieve the list of pv names
            %Retrieves a 1xN array of pv names, limited by an optional
            %wildcard.
            %Examples:
            %   lst = AA.getPVs()
            %       Returns all pv names in the archiver appliance.  Note
            %       that this can return millions of pvs.
            %   lst = AA.getPVs('cmm:*')
            %       Returns all pv names that start with "cmm:"
            url = strcat('http://', AA.hostname, ...
                ':', int2str(AA.mgmtport), ...
                AA.mgmtpath, ...
                'getAllPVs');
            if nargin == 1
                str = urlread(url);
            else
                str = urlread(url, 'get', {'pv', wildcard});
            end
            % Giving up some flexibility by not using parse_json here
            % because it is potentially very slow if lots of pvs are
            % returned.
            if str(1) == '['
                str2 = str(3:length(str)-3);
                lst = strsplit(str2, '","');
            else
                lst = [];
            end
        end
        
        function stats = getPVStatus(AA, pvnames)
            %getPVStatus Get the status of a PV
            %Retrieves the archiving status of one or more pvs.
            %param pvnames: the name(s)of the pv for which status
            %is to be determined. If a pv is not being archived, 
            %the returned status will be "Not being archived."
		    %You can also pass in GLOB wildcards here and multiple
			%PVs as vector.
            url = strcat('http://', AA.hostname, ...
                ':', int2str(AA.mgmtport), ...
                AA.mgmtpath, ...
                'getPVStatus');
            if isa(pvnames, 'char')
                result = urlread(url, 'get', {'pv', pvnames});
            else
                result = urlread(url, 'post', ...
                    {'pv', strjoin(pvnames, ',')});
            end
            stats = parse_json(result);
        end
        
        function info = getPVTypeInfo(AA, pvname)
            %getPVTypeInfo Get the type info for a given PV.
            %In the archiver appliance terminology, the PVTypeInfo
            %contains the various archiving parameters for a PV.
            url = strcat('http://', AA.hostname, ...
                ':', int2str(AA.mgmtport), ...
                AA.mgmtpath, ...
                'getPVTypeInfo');
            result = urlread(url, 'get', {'pv', pvname});
            info = parse_json(result);
        end
        
        function info = getNeverConnectedPVs(AA)
            %getNeverConnectedPVs Get a list of PVs that have never
            %connected.
            url = strcat('http://', AA.hostname, ...
                ':', int2str(AA.mgmtport), ...
                AA.mgmtpath, ...
                'getNeverConnectedPVs');
            result = urlread(url);
            info = parse_json(result);
        end
    
        function info = getCurrentlyDisconnectedPVs(AA)
            %getCurrentlyDisconnectedPVs Get a list of PVs that are
            %currently disconnected.
            url = strcat('http://', AA.hostname, ...
                ':', int2str(AA.mgmtport), ...
                AA.mgmtpath, ...
                'getCurrentlyDisconnectedPVs');
            result = urlread(url);
            info = parse_json(result);
        end
    end

	methods (Access = private)
		function AA = initializeEnvironment(AA)
			%initializeEnvironment Initializes AA from environment variables
			%If ARCHAPPL_INIFILE is set, attempts to read settings from it first.
			%Other environment variables will override settings from ARCHAPPL_INIFILE.
			%If arguments are provided to the AA constructor, they will override
			%all settings from environment variables.
			path = getenv('ARCHAPPL_INIFILE');
			if ~isempty(path)
				fid = fopen(path, 'r');
				if fid == -1
					exc = MException('ArchAppliance:InvalidPath', ...
						'ARCHAPPL_INIFILE env. variable points to a nonexistent path (%s)', path);
					throw(exc);
				end
				vars = textscan(fid, '%s %s', 'delimiter', '=', 'commentStyle', '#')
				AA = AA.setFromEnv(vars{1}, vars{2});
			end
		end

		function AA = setFromEnv(AA, name, value)
			for i = 1:length(name)
				n = char(name{i})
				v = char(value{i})
				switch(n)
					case 'ARCHAPPL_SERVER'
						AA.hostname = v;
					case 'ARCHAPPL_RETRIEVALPORT'
						AA.retrievalport = str2double(v);
					case 'ARCHAPPL_RETRIEVALPATH'
						AA.retrievalpath = v;
					case 'ARCHAPPL_MGMTPORT'
						AA.mgmtport = str2double(v);
					case 'ARCHAPPL_MGMTPATH'
						AA.mgmtpath = v;
					otherwise
						warning('Unexpected environment variable name %s, skipping', n);
				end
			end
		end
	end
    
end

