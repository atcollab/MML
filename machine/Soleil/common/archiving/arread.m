function Data = arread(varargin)
%ARREAD - Read data from archiving database
%
%  INPUTS
%  1. FAMILY attribute name or family name
%      If family, device list can be given, else [] (All) is assumed
%  2. starting date {now - 2 hours}
%  3. ending date {now}
%  4. {'HDB'} or 'TDB' : select database
%
%  OUPUTS
%  1. Data - output structure
%
%  EXAMPLES
%  1. arread('CH',1);
%  2. arread('CH');
%  3. arread('LT1/AE/CH.1/current')
%  4. arread('LT1/VI/PI55.1/pressure', '02-07-2005 03:21:02', '02-07-2005 20:21:00')
%  5. For all PI
%     arread('PI', [], '02-07-2005 03:21:02', '02-07-2005 20:21:00')
% 
%  See Also arplot

%
% Written by Laurent S. Nadolski

% Default parameters

AverageFlag = 0;

% Look for hdbextractor name in Tango Static DB
extractor = cell2mat(tango_get_db_property('archivage','hdbextractor'));
database  = 'HDB';

Field = 'Monitor';

% WARNING this is the new format for date
strformat = 'dd-mm-yyyy HH:MM:SS'; 

date1 = datestr(now - 0.0417*12, strformat); % now - 1 hours
date2 = datestr(now, strformat); 

% Look if 'struct' or 'numeric' in on the input line
InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignore structures
    elseif iscell(varargin{i})
        % Ignore cells
    elseif strcmpi(varargin{i},'HDB')
        extractor = cell2mat(tango_get_db_property('archivage','hdbextractor'));
        database = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'TDB')
        extractor = cell2mat(tango_get_db_property('archivage','tdbextractor'));
        database = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Average')
        AverageFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoAverage')
        AverageFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Monitor')
        Field = 'Monitor';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Setpoint')
        Field = 'Setpoint';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        UnitsFlag = 'Physics';
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = 'Hardware';
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    end
end

%%%%%%%%%%%%%%
% INPUT PARSER
%%%%%%%%%%%%%%

Family = varargin{1};   
%% check if family is valid and return it in AO
[FamilyIndex, AO] = isfamily(Family);

if FamilyIndex
    %%%%%%%%%%%%%%%%
    % FAMILY INPUT %
    %%%%%%%%%%%%%%%%
    
    % DeviceList
    if length(varargin) > 1
        DeviceList = varargin{2};
    else
        DeviceList = family2dev(Family);     % Default behavior comes from family2dev
    end

    %Convertion to TANGO name
    Family = family2tango(Family,Field,DeviceList);

    if length(varargin) > 2
        % starting date
        date1 = varargin{3};
        if length(varargin) > 2
            %ending date
            date2 = varargin{4};
        end
    end

elseif isattribute(Family)
    %%%%%%%%%%%%%%%%%%%%%%
    % TANGO NAME INPUT %
    %%%%%%%%%%%%%%%%%%%%%%
    if length(varargin) > 1
        % starting date
        date1 = varargin{2};
        if length(varargin) > 2
            %ending date
            date2 = varargin{3};
        end
    end
else
    error('%s is not a valid name\n',Family);
end

%% For Bug in archiving
%attr_name = strcat('//ganymede.synchrotron-soleil.fr:20000/', Family);
attr_name = Family;

if ~iscell(attr_name)
    attr_name = {attr_name};
end


% dvalue : valeur
% svalue : date en format type 2004-12-05 16:08:07.969
% Import toutes les valeurs archivees entre deux dates
if ~AverageFlag
    %cmdName = 'GetAttDataBetweenDates';
    cmdName = 'GetAttDataBetweenDatesSampling';
    OPTION = 'ALL';
else
    cmdName = 'GetAttDataBetweenDatesSampling';
    OPTION = 'HOUR';
end

for ik = 1:length(attr_name)
    argin = {attr_name{ik}, date1, date2, OPTION};
    % get data for one attribute
    %Data.ardata(ik) = tango_command_inout2(extractor,'GetAttDataBetweenDates',argin);   
    rep{ik} = tango_command_inout2(extractor,cmdName, argin);
end

% Refresh attribute list on extractor
tango_close_device(extractor);
tango_open_device(extractor);
tango_set_timeout(extractor,30000);

for ik = 1:length(attr_name)
    if rep{ik}.lvalue ~= 0
        %sdata = tango_attribute_history(extractor,rep{ik}.svalue{1,:},double(rep{ik}.lvalue));
        if ~iscell(rep{ik}.svalue{1}), rep{ik}.svalue{1} = {rep{ik}.svalue{1}}; end
        sdata = tango_attribute_history(extractor,rep{ik}.svalue{1}{:},double(rep{ik}.lvalue));
        if tango_error == -1
            tango_print_error_stack;
        end
        if sdata(1).value.dim_x == 1
            for kk = 1:rep{ik}.lvalue,
                Data.ardata(ik).dvalue(kk) = sdata(kk).value.value;
                Data.ardata(ik).svalue(kk) = sdata(kk).value.time;
            end
        else % for vectors
            for kk = 1:rep{ik}.lvalue,
                Data.ardata(ik).dvalue(kk,:) = sdata(kk).value.value;
                Data.ardata(ik).svalue(kk,:) = sdata(kk).value.time;
            end
        end            
       Data.ardata(ik).svalue = tango_shift_time(Data.ardata(ik).svalue);
       tango_command_inout2(extractor,'RemoveDynamicAttribute',rep{ik}.svalue{1}{:});
    else
        disp([mfilename ': No Data for ' attr_name{ik}]);
    end
    
    %tango_command_inout2(extractor,'RemoveDynamicAttribute',rep{ik}.svalue{2});
    % If R/W attribute, ardata.dvalue = [readvalue setvalue]
    % first shot : just keep readback data
%     len = length(Data.ardata(ik).svalue);
%     if len ~= length(Data.ardata(ik).dvalue)
%         Data.ardata(ik).dvalue = Data.ardata(ik).dvalue(1:len);
%     end
end

Data.TangoNames = attr_name;
Data.start = date1;
Data.end   = date2;
Data.database = database;

if  ~isfield(Data,'ardata') ||  (~isstruct(Data.ardata) && Data == -1) || isempty(Data.ardata(1).dvalue)
    disp([mfilename 'No data available']);
    Data = -1;
    return;
end
