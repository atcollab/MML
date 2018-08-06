function [AM, tout, DataTime, ErrorFlag] = getpv(varargin)
%GETPV - Returns a variable from the online system or the model
%
%  FamilyName/DeviceList Method
%  [AM, tout, DataTime] = getpv(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%
%  Data Structure
%  [AM, tout, DataTime] = getpv(DataStructure, t, FreshDataFlag, TimeOutPeriod)
%
%  ChannelName Method
%  [AM, tout, DataTime] = getpv(ChannelName, t, FreshDataFlag, TimeOutPeriod)
%
%  CommonName Method (Family can be '' to search all families, Field is optional)
%  [AM, tout, DataTime] = getpv(CommonName, Field, t, FreshDataFlag, TimeOutPeriod)
%  [AM, tout, DataTime] = getpv(Family, Field, CommonName, t, FreshDataFlag, TimeOutPeriod)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Channel Name or matrix of Channel Names
%              Accelerator Object (only the family name is used)
%              For CommonNames, Family=[] searches all families
%              (or Cell Array of inputs)
%
%  2. Field - Subfield name of an accelerator family ('Monitor', 'Setpoint', etc)  
%             {Default: 'Monitor' or '' or ChannelName method}
%             (For non-Family subfields, Field is added as .Field, see Note #8 below for more information.)
%
%  3. DeviceList - [Sector Device #] or [element #] list {Default or empty list: Entire family}
%                  Note: if input 1 is a cell array then DeviceList must be a cell array
%     CommonName - Common name can replace a DeviceList (scalar or vector outputs)
%
%  4. t - Time vector of when to start taking data (t can not be a cell) {Default: 0}
%
%  5. FreshDataFlag -  0   -> Return after first measurement {Default}
%                     else -> Return after FreshDataFlag number of new measurements have been read
%                     Ie, getpv('BPMx',[1 1],0,2) measures the orbit then continues to read the orbit
%                         until 2 new orbits have been measured and returns the last measurement.
%                     Note: 1. t can only be a scalar when using the FreshDataFlag.
%                           2. FreshDataFlag cannot be used with 'Matrix' data types. 
%
%  6. TimeOutPeriod - Time-out period when waiting for fresh data {Default: 10 seconds}
%
%  7. 'Struct'  - Return a data structure {Default for data structure inputs}
%     'Numeric' - Return numeric outputs  {Default for non-data structure inputs}
%     'Object'  - Return a accelerator object (AccObj)
%
%  8. Units flag overrides
%     'Physics'  - Use physics  units
%     'Hardware' - Use hardware units
%
%  9. Mode flag overrides
%     'Online' - Get data online 
%     'Model'  - get data on the model
%     'Manual' - Get data manually
%
%  10. 'Double' - The output will be a double {Default}
%      'String' - The output will be a string
%
%
%  OUTPUTS
%  1. AM   - Monitor values (Column vector or matrix where each column is a data point in time)
%
%  2. tout - Time when measurement was completed according to the computer time (Matlab time) (row vector)
%            tout-t is the time it took to make the measurement.  diff(t) can be arbitarily small, but tout will 
%            report the actual completion time.  
%
%  3. DataTime - Time when the data was measured (as report by the hardware)
%                Time since 00:00:00, Jan 1, 1970 in days (in the present time zone)
%                Units are in Matlab "serial day number" format (days) to be compatible with 
%                timing functions like datevec, datenum, datetick, etc.  
%                For exmple, [d, tout, datatime] = getpv('BPMx', 'Monitor', [], 0:.5:10);
%                            plot(datatime, d); datetick x
%                When using the model, the datatime is the same a the computer time (Matlab time).
%
%  NOTES
%  1. The output will be a data structure if the word 'struct' appears somewhere on the input line 
%     or if the input is a data structure and 'numeric' is not on the input line.
%
%  2. For data structure inputs:
%     Family     - DataStructure.FamilyName (This field must exist)
%     Field      - DataStructure.Field      (Field can be overridden on the input line)
%     DeviceList - DataStructure.DeviceList (DeviceList can be overridden on the input line)
%     Units      - DataStructure.Units      (Units can be overridden on the input line)
%     (The Mode field is ignored!)
%
%  3. For data structure outputs:
%     TimeStamp  - Time (Matlab clock) at the start of the function
%     tout       - Delta time vector at the end of each measurement (relative to TimeStamp)
%
%  4. diff(t) should not be too small.  If the desired time to collect the data is too 
%     short then the data collecting will not be able to keep up.  Always check tout. 
%     (t - tout) is the time it took to collect the data on each iteration.   
% 
%  5. An easy way to averaged 10 monitors is:
%     PVmean = mean(getpv(Family,DeviceList,0:.5:4.5)')';   % .5 second between measurements
%
%  6. Channel name method is always Online!
%
%  7. It is often useful to measure the update rate of a set of channel by using a very
%     small time between measurements.
%     For exmple, [d, tout] = getpv('BPMx', 'Monitor', [], 0:eps:100*eps);
%                 plot(tout(1:end-1), 1./diff(tout),'.-'); % Point-wise data rate
%                 If the update rate of the hardware is slower then the control system, then
%                 hardware data rate can be visually inspected by plotting,
%                 plot(tout, d,'.-'); 
%
%  8. For cell array inputs:
%     a. Input 1 defines the size of all cells
%     b. All of the cell array inputs must be the same size
%     c. Field does not have to be a cell array but DeviceList does (if they exist)
%     d. t, FreshDataFlag, TimeOutPeriod can not be cell arrays
%     e. Waveforms do not work with cell arrays.
%
%  8. The Field input can be used for getting the "dot" EPICS field.  For instance, at the ALS
%     getpv('BPMx','SCAN',[1 2],'String') will return SR01S___IBPM2X_AM02.SCAN as a string.
%     (Note: at Spear ':' is used instead of '.')
%
%  10. Error flaga are not used at the moment since all errors cause a Matlab error.
%      Use try;catch statements to catch errors.
%
%  12. If say Golden is a software field in the MML structure in the BPMx family, then 
%      getpv('BPMx','Golden', DeviceList) will return the data in that field.
%
%  See also getam, getsp, setpv, steppv
%
%  Written by Greg Portmann


% Starting time
t0 = clock;


% Defaults
FieldDefault = 'Monitor';
Field = FieldDefault;
DeviceList = [];
t = 0;
FreshDataFlag = 0;
TimeOutPeriod = 10;
ErrorFlag = 0;

StructOutputFlag = 0;
NumericOutputFlag = 0;
ObjectOutputFlag = 0;
ModeFlag = '';
UnitsFlag = '';
OutputDataType = 'Double';


% Look if 'struct' or 'numeric' in on the input line
InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif isnumeric(varargin{i})
        % Ignor numeric
    elseif isa(varargin{i},'AccObj')
        AccObj1 = struct(varargin{i});
        Families = fieldnames(AccObj1);
        j = 0;
        for k = 1:length(Families)
            if ~isempty(AccObj1.(Families{k}))
                j = j + 1;
                tmpcell{j} = AccObj1.(Families{k});
            end
        end
        if length(tmpcell) == 1
            varargin{i} = tmpcell{1};
        else
            varargin{i} = tmpcell;
        end
        if ~NumericOutputFlag
            ObjectOutputFlag = 1;
            StructOutputFlag = 1;
        end
    elseif ischar(varargin{i}) && size(varargin{i},1)==1
        if strcmpi(varargin{i},'struct')
            StructOutputFlag = 1;
            ObjectOutputFlag = 0;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'numeric')
            NumericOutputFlag = 1;
            StructOutputFlag = 0;
            ObjectOutputFlag = 0;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
            ModeFlag = 'SIMULATOR';
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Online')
            ModeFlag = 'Online';
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Manual')
            ModeFlag = 'Manual';
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Special')
            ModeFlag = 'Special';
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'physics')
            UnitsFlag = 'Physics';
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'hardware')
            UnitsFlag = 'Hardware';
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'archive')
            % Just remove
            varargin(i) = [];
        elseif strcmpi(varargin{i},'noarchive')
            % Just remove
            varargin(i) = [];
        elseif strcmpi(varargin{i},'String') || strcmpi(varargin{i},'Char')
            OutputDataType = 'String';
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Double')
            OutputDataType = 'Double';
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'WaveForm') || strcmpi(varargin{i},'Matrix')
            OutputDataType = varargin{i};  %'Matrix';
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Object')
            ObjectOutputFlag = 1;
            StructOutputFlag = 1;
            varargin(i) = [];
        end
    end
end

if isempty(varargin)
    error('Must have at least one input (Family, Data structure, or Channel Name).');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CELL OR CELL ARRAY INPUT %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if iscell(varargin{1})
    %if strcmpi(ModeFlag, 'Online') | (isempty(ModeFlag) & strcmpi(getmode(varargin{1}{1}), 'Online'))
    %     % Unfortunately the following code using channelnames is not much of a speed improvement over 
    %     % interating over cell arrays (which is needed for simulator mode)
    %
    %     % Online cell arrays
    %     %
    %     % Online cell arrays are treated differently because to the desired for speed.
    %     % By loading all the channel names into one array then sending to the c-function
    %     % with the t-vector, the total time is greatly sped up.  However, using channel names
    %     % only works in online mode.  The one problem is all output have to scalars.
    %
    %
    %     % Count the number of inputs which are cells (Family or DeviceList) or strings (possibly Field)
    %     NCellOrString = 1;
    %     for i = 2:length(varargin)
    %         if ~iscell(varargin{i})
    %             if ~ischar(varargin{i})
    %                 break;
    %             else
    %                 NCellOrString = NCellOrString + 1;
    %             end
    %         else
    %             NCellOrString = NCellOrString + 1;
    %             %if length(varargin{1})~=length(varargin{NCellOrString}) | length(varargin{NCellOrString})==1
    %             %    error('When using cell, all the cells must be the same size as input 1 or be length one.');
    %             %end
    %         end
    %     end
    %
    %     % t (if it exists) should be the next input
    %     if length(varargin) >= NCellOrString+1
    %         if iscell(varargin{NCellOrString+1})
    %             error(sprintf('Expecting input #%d to be a time vector not a cell', NCellOrString+1));
    %         end
    %         if ischar(varargin{NCellOrString+1})
    %             error(sprintf('Expecting input #%d to be a time vector not a string', NCellOrString+1));
    %         end
    %         t = varargin{NCellOrString+1};
    %         varargin{NCellOrString+1} = [];
    %         if isempty(t)
    %             t = 0;
    %         end
    %     end
    %
    %     % FreshDataFlag (if it exists) should be the next input
    %     if length(varargin) >= NCellOrString+1
    %         if iscell(varargin{NCellOrString+1})
    %             error(sprintf('Expecting input #%d to be FreshDataFlag not a cell', NCellOrString+2));
    %         end
    %         if ischar(varargin{NCellOrString+1})
    %             error(sprintf('Expecting input #%d to be FreshDataFlag not a string', NCellOrString+2));
    %         end
    %         FreshDataFlag = varargin{NCellOrString+1};
    %         varargin{NCellOrString+1} = [];
    %     end
    %
    %     % TimeOutPeriod (if it exists) should be the next input
    %     if length(varargin) >= NCellOrString+1
    %         if iscell(varargin{NCellOrString+1})
    %             error(sprintf('Expecting input #%d to be TimeOutPeriod not a cell', NCellOrString+2));
    %         end
    %         if ischar(varargin{NCellOrString+1})
    %             error(sprintf('Expecting input #%d to be TimeOutPeriod not a string', NCellOrString+2));
    %         end
    %         TimeOutPeriod = varargin{NCellOrString+1};
    %         varargin{NCellOrString+1} = [];
    %     end
    %
    %     % Build the channel name matrix
    %     ChannelNames = [];
    %     for i = 1:size(varargin{1},1)
    %         for j = 1:size(varargin{1},2)
    %             if NCellOrString == 1
    %                 NewNames = family2channel(varargin{1}{i,j});
    %             elseif NCellOrString == 2
    %                 if iscell(varargin{2})
    %                     NewNames = family2channel(varargin{1}{i,j}, varargin{2}{i,j});
    %                 else
    %                     NewNames = family2channel(varargin{1}{i,j}, varargin{2});
    %                 end
    %             elseif NCellOrString == 3
    %                 if iscell(varargin{2})
    %                     NewNames = family2channel(varargin{1}{i,j}, varargin{2}{i,j}, varargin{3}{i,j});
    %                 else
    %                     NewNames = family2channel(varargin{1}{i,j}, varargin{2}, varargin{3}{i,j});
    %                 end
    %             end
    %             ChannelNames = strvcat(ChannelNames, NewNames);
    %             NameSize(i,j) = size(NewNames,1);
    %         end
    %     end
    %
    %     ExtraTimeDelay = etime(clock, t0);
    %
    %     %if nargout >= 3
    %     [AMtmp, tout, DataTimetmp, ErrorFlag] = local_getbyname(ChannelNames, 'Double', 1, t-ExtraTimeDelay, FreshDataFlag, TimeOutPeriod);
    %     %else
    %     %    [AMtmp, tout] = local_getbyname(ChannelNames, 'Double', 1, t-ExtraTimeDelay, FreshDataFlag, TimeOutPeriod)
    %     %end
    %
    %     %if StructOutputFlag | nargout >= 3
    %     % .DataTime is the time on computer taking the data but
    %     % reference it w.r.t. the time zone where Matlab is running
    %     DateNumber1970 = 719529;  %datenum('1-Jan-1970');
    %     days = datenum(t0(1:3)) - DateNumber1970;
    %     t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
    %     TimeZoneDiff = round((t0_sec - real(DataTimetmp(1,1)))/60/60);
    %     DataTimetmp = (real(DataTimetmp)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTimetmp)/(1e9 * 60 * 60 * 24);
    %
    %     % No time zone adjustment (UTC 00:00:00 Jan 1, 1970)
    %     %DataTime = real(DataTime)/60/60/24 + imag(DataTime)/(1e9 * 60 * 60 * 24);
    %     %end
    %
    %     for i = 1:size(varargin{1},1)
    %         for j = 1:size(varargin{1},2)
    %             AM{i,j} = AMtmp(1:NameSize(i,j),:);
    %             AMtmp(1:NameSize(i,j),:) = [];
    %             %if nargout >= 3
    %             DataTime{i,j} = DataTimetmp(1:NameSize(i,j),:);
    %             DataTimetmp(1:NameSize(i,j),:) = [];
    %             %end
    %
    %             % If input is a data structure, only change StructOutputFlag if 'numeric' is not on the input line
    %             StructOutputFlagStart = StructOutputFlag;
    %             if isstruct(varargin{1}{i,j})
    %                 if isfield(varargin{1}{i,j},'Field')
    %                     if ~NumericOutputFlag
    %                         StructOutputFlag = 1;
    %                     end
    %                 end
    %             end
    %
    %             if StructOutputFlag
    %                 Datatmp = AM{i,j};
    %                 DataTimetmp = DataTime{i,j};
    %                 if NCellOrString == 1
    %                     if isempty(UnitsFlag)
    %                         AM{i,j} = family2datastruct(varargin{1}{i,j});
    %                     else
    %                         AM{i,j} = family2datastruct(varargin{1}{i,j}, UnitsFlag);
    %                     end
    %                 elseif NCellOrString == 2
    %                     if iscell(varargin{2})
    %                         if isempty(UnitsFlag)
    %                             AM{i,j} = family2datastruct(varargin{1}{i,j}, varargin{2}{i,j});
    %                         else
    %                             AM{i,j} = family2datastruct(varargin{1}{i,j}, varargin{2}{i,j}, UnitsFlag);
    %                         end
    %                     else
    %                         if isempty(UnitsFlag)
    %                             AM{i,j} = family2datastruct(varargin{1}{i,j}, varargin{2});
    %                         else
    %                             AM{i,j} = family2datastruct(varargin{1}{i,j}, varargin{2}, UnitsFlag);
    %                         end
    %                     end
    %                 elseif NCellOrString == 3
    %                     if iscell(varargin{2})
    %                         if isempty(UnitsFlag)
    %                             AM{i,j} = family2datastruct(varargin{1}{i,j}, varargin{2}{i,j}, varargin{3}{i,j});
    %                         else
    %                             AM{i,j} = family2datastruct(varargin{1}{i,j}, varargin{2}{i,j}, varargin{3}{i,j}, UnitsFlag);
    %                         end
    %                     else
    %                         if isempty(UnitsFlag)
    %                             AM{i,j} = family2datastruct(varargin{1}{i,j}, varargin{2}, varargin{3}{i,j});
    %                         else
    %                             AM{i,j} = family2datastruct(varargin{1}{i,j}, varargin{2}, varargin{3}{i,j}, UnitsFlag);
    %                         end
    %                     end
    %                 end
    %                 AM{i,j}.Data = Datatmp;
    %                 AM{i,j}.t = t;
    %                 AM{i,j}.tout = tout;
    %                 AM{i,j}.DataTime = DataTimetmp;
    %                 AM{i,j}.Mode = 'Online';
    %                 AM{i,j}.CreatedBy = 'getpv';
    %             end
    %             StructOutputFlag = StructOutputFlagStart;
    %         end
    %     end
    %
    %     return
    %
    %else

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CELL OR CELL ARRAY INPUT %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Iterate on each cell with special attention to the t vector input

    % For an empty input, return empty
    if isempty(varargin{1})
        AM =[]; tout = []; DataTime = []; ErrorFlag = 0;
        return
    end

    % If input is a data structure, only change StructOutputFlag if 'numeric' is not on the input line
    if isstruct(varargin{1}{1}) && isfield(varargin{1}{1},'Field')
        if ~NumericOutputFlag
            StructOutputFlag = 1;
        end
    end

    
    % Count the number of inputs which are cells (Family or DeviceList) or strings (possibly Field)
    NCellOrString = 1;
    for i = 2:length(varargin)
        if ~iscell(varargin{i})
            if ~ischar(varargin{i})
                break;
            else
                NCellOrString = NCellOrString + 1;
            end
        else
            NCellOrString = NCellOrString + 1;
            %if length(varargin{1})~=length(varargin{NCellOrString}) | length(varargin{NCellOrString})==1
            %    error('When using cell, all the cells must be the same size as input 1 or be length one.');
            %end
        end
    end

    % t (if it exists) should be the next input.  Save it then zero it in varargin
    if length(varargin) >= NCellOrString+1
        if iscell(varargin{NCellOrString+1})
            error(sprintf('Expecting input #%d to be a time vector not a cell', NCellOrString+1));
        end
        if ischar(varargin{NCellOrString+1})
            error(sprintf('Expecting input #%d to be a time vector not a string', NCellOrString+1));
        end
        t = varargin{NCellOrString+1};
        varargin{NCellOrString+1} = 0;
    end


    ExtraTimeDelay = etime(clock, t0);
    t = t - ExtraTimeDelay;

    % Loop according to t
    for itime = 1:length(t)
        T = t(itime)-etime(clock, t0);
        if T > 0
            pause(T);
        end

        for i = 1:size(varargin{1},1)
            for j = 1:size(varargin{1},2)

                % Build the input line
                for k = 1:length(varargin)
                    if ~iscell(varargin{k})
                        Inputs1{1,k} = varargin{k};
                    elseif length(varargin{k}) == 1
                        Inputs1{1,k} = varargin{k}{1};
                    elseif (size(varargin{k},1) == size(varargin{1},1)) && (size(varargin{k},2) == size(varargin{1},2))
                        Inputs1{1,k} = varargin{k}{i,j};
                    else
                        error('When using cells, all the cells must be the same size or length 1 (repeated).');
                    end
                end

                if StructOutputFlag
                    if itime == 1
                        % Form the structure on the first time
                        [AM{i,j}, tout(1,itime), DataTime{i,j}, ErrorFlagNew] = getpv(Inputs1{:}, 'Struct', InputFlags{:});
                    else
                        % Add to the Data and time fields
                        [AM{i,j}.Data(:,itime), tmp, AM{i,j}.DataTime(:,itime), ErrorFlagNew] = getpv(Inputs1{:}, 'Numeric', InputFlags{:});
                        AM{i,j}.t(1,itime) = t(itime);
                        AM{i,j}.tout(1,itime) = etime(clock, t0);
                        DataTime{i,j}(:,itime) = AM{i,j}.DataTime(:,itime);
                    end
                else
                    [AM{i,j}(:,itime), tmp, DataTime{i,j}(:,itime), ErrorFlagNew] = getpv(Inputs1{:}, 'Numeric', InputFlags{:});
                end
                ErrorFlag = ErrorFlag | any(ErrorFlagNew);
            end
            tout(itime) = etime(clock, t0);
        end
    end

    % Make the output an AccObj object
    if ObjectOutputFlag
        AM = AccObj(AM);
    end

    return
end
%%%%%%%%%%%%%%%%%%
% End cell input %
%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMMONNAME - Commonname input with no family input %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(varargin{1})
    if length(varargin) >= 2
        if ischar(varargin{2})
            Field = varargin{2};
            varargin(2) = [];
        end
    else
        % For an empty input, return empty
        if isempty(varargin{1})
            AM =[]; tout = []; DataTime = []; ErrorFlag = 0;
            return
        end
    end
    if isempty(Field)
        Field = FieldDefault;
    end
    if length(varargin) >= 2
        CommonNames = varargin{2};
    else
        error('Common names not found on the input line.');
    end
    if length(varargin) >= 3
        t = varargin{3};
    end
    if length(varargin) >= 4
        FreshDataFlag = varargin{4};
    end
    if length(varargin) >= 5
        TimeOutPeriod = varargin{5};
    end


    % Common names with no family name
    if ~ischar(CommonNames)
        error('If Family=[], then DeviceList must be a string of common names.')
    end
    [AM, tout, DataTime, DeviceList, ErrorFlag] = getbycommonname(CommonNames, Field, t, t0, FreshDataFlag, TimeOutPeriod, InputFlags{:});
    if ErrorFlag
        return;
    end

    if StructOutputFlag || nargout >= 3
        if ~isempty(ModeFlag) && strcmpi(ModeFlag, 'SIMULATOR')
            DataTime = modeltime2datenum(DataTime);
        else
            DataTime = linktime2datenum(DataTime);
            
            % .DataTime is the time on computer taking the data but
            % reference it w.r.t. the time zone where Matlab is running
            %DateNumber1970 = 719529;  %datenum('1-Jan-1970');
            %days = datenum(t0(1:3)) - DateNumber1970;
            %t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
            %TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
            %DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);
        end
    end

    % Structure output
    if StructOutputFlag
        AM = struct('Data', AM);
        AM.FamilyName = CommonNames;
        AM.Field = Field;
        AM.DeviceList = DeviceList;
        AM.Status = [];
        AM.t = t;
        AM.tout = tout;
        AM.DataTime = DataTime;
        AM.TimeStamp = t0;
        [DeviceList1, Family1] = common2dev(CommonNames(1,:));
        AM.Mode = getmode(Family1);                      % Base on just the first common name
        [AM.Units, AM.UnitsString] = getunits(Family1);  % Base on just the first common name
        AM.DataDescriptor = 'Get by Common Name';
        AM.CreatedBy = 'getpv';

        % Make the output an AccObj object
        if ObjectOutputFlag
            AM = AccObj(AM);
        end
    end

    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End CommonName input with no family input %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parce inputs depending on Data structure, AO structure, Family, ChannelName method %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(varargin{1})
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % STRUCTURE INPUTS - Data structure or AO structure %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isfield(varargin{1},'FamilyName') && isfield(varargin{1},'Field')
        % Data structure - select FamilyName, DeviceList, Units  from the structure (.Mode flag???)
        % [AM, tout, DataTime, ErrorFlag] = getpv(DataStruct, Field {opt}, t, FreshDataFlag, TimeOutPeriod)

        % Only change StructOutputFlag if 'numeric' is not on the input line
        if ~NumericOutputFlag
            StructOutputFlag = 1;
        end

        Family = varargin{1}.FamilyName;

        Field = varargin{1}.Field;
        if length(varargin) >= 2
            if ischar(varargin{2})
                Field = varargin{2};
                varargin(2) = [];
            end
        end

        DeviceList = varargin{1}.DeviceList;

        if length(varargin) >= 2
            % If the input exists use it
            t = varargin{2};
        else
            % Else, get it from the structure if the field exists
            if isfield(varargin{1},'t')
                t = varargin{1}.t;
            end
        end
        if length(varargin) >= 3
            FreshDataFlag = varargin{3};
        end
        if length(varargin) >= 4
            TimeOutPeriod = varargin{4};
        end

        [FamilyIndex, AO] = isfamily(Family);

        % Change Units to the data structure units
        if isfield(AO, Field)
            AO.(Field).Units = varargin{1}.Units;
        end

    elseif isfield(varargin{1},'FamilyName')
        % AO structure - use the AO structure directly
        %  [AM, tout, DataTime, ErrorFlag] = getpv(AO, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
        FamilyIndex = 1;
        AO = varargin{1};
        Family = varargin{1}.FamilyName;

        Field = '';
        if length(varargin) >= 2
            if ischar(varargin{2})
                Field = varargin{2};
                varargin(2) = [];
            end
        end
        if length(varargin) >= 2
            DeviceList = varargin{2};
        else
            DeviceList = AO.DeviceList;
            iStatus = find(varargin{1}.Status == 0);
            DeviceList(iStatus,:) = [];
        end
        if length(varargin) >= 3
            t = varargin{3};
        end
        if length(varargin) >= 4
            FreshDataFlag = varargin{4};
        end
        if length(varargin) >= 5
            TimeOutPeriod = varargin{5};
        end
    else
        error('Input #1 of unknown type');
    end
    
else

    % Family, ChannelName, or Common name are still left
    [FamilyIndex, AO] = isfamily(varargin{1});

    if FamilyIndex

        %%%%%%%%%%%%%%%%
        % FAMILY INPUT %
        %%%%%%%%%%%%%%%%
        %  [AM, tout, DataTime, ErrorFlag] = getpv(Family, Field {opt}, DeviceList, t, FreshDataFlag, TimeOutPeriod)
        Family = varargin{1};
        if length(varargin) >= 2
            if ischar(varargin{2})
                Field = varargin{2};
                varargin(2) = [];
            end
        end
        if isempty(Field)
            Field = FieldDefault;
        end
        if length(varargin) >= 2
            DeviceList = varargin{2};
        end
        if length(varargin) >= 3
            t = varargin{3};
        end
        if length(varargin) >= 4
            FreshDataFlag = varargin{4};
        end
        if length(varargin) >= 5
            TimeOutPeriod = varargin{5};
        end
        
    else
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANNEL NAME OR COMMON NAME INPUT %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Just do input parsing here
        Family = varargin{1};
        
        % Default field is '' for channel names or it would be added as ChannelName.Field
        % But for common names it needs to be 'Monitor'
        Field = '';
        if length(varargin) >= 2
            if ~isnumeric(varargin{2})
                Field = varargin{2};
                varargin(2) = [];
            end
        end
        if length(varargin) >= 2
            t = varargin{2};
        end
        if length(varargin) >= 3
            FreshDataFlag = varargin{3};
        end
        if length(varargin) >= 4
            TimeOutPeriod = varargin{4};
        end 
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End selection of inputs depending on Family, Data Structure, AO structure, or ChannelName method %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AO, ChannelName, or CommonName %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(t)
    t = 0;
end
if FamilyIndex 
    %%%%%%%%%%%%%%%%% 
    % FAMILY INPUTS %
    %%%%%%%%%%%%%%%%%

    % All ready done
    %if isempty(Field)
    %    Field = 'Monitor';
    %end

    if isempty(DeviceList)
        DeviceList = family2dev(Family, Field);      % Default behavior comes from family2dev
        %DeviceList = family2dev(Family, Field, 1);  % Good status only
        %DeviceList = AO.(Field?).DeviceList;        % All devices
    end
    if ischar(DeviceList)
        % Convert common name to a DeviceList
        DeviceList = common2dev(DeviceList, AO);
    end
    if (size(DeviceList,2) == 1) 
        DeviceList = elem2dev(Family, Field, DeviceList);
    end


    % Look for command-line over-rides
    if isfield(AO, Field)
        if ~isempty(UnitsFlag)
            AO.(Field).Units = UnitsFlag;
        end
        if ~isempty(ModeFlag)
            if strcmpi(ModeFlag, 'Online') && strcmpi(AO.(Field).Mode, 'Special')
                % For Online over-rides, look for Special mode first
                AO.(Field).Mode = 'Special';
            else
                AO.(Field).Mode = ModeFlag;
            end
        end
    end

    
    % Get data
    ExtraTimeDelay = etime(clock, t0);
    if StructOutputFlag || nargout >= 3
        [AM, tout, DataTime, ErrorFlag, DeviceIndex] = local_getpv(AO, Field, DeviceList, OutputDataType, t-ExtraTimeDelay, FreshDataFlag, TimeOutPeriod);
    else
        [AM, tout] = local_getpv(AO, Field, DeviceList, OutputDataType, t-ExtraTimeDelay, FreshDataFlag, TimeOutPeriod);
    end
    tout = tout + ExtraTimeDelay;

    
    if StructOutputFlag
        % Structure output
        AM = struct('Data', AM);
        %AM.Data = AM;
        AM.FamilyName = Family;
        AM.Field = Field;
        AM.DeviceList = DeviceList;
        if length(AO.Status) == 1
            AM.Status = AO.Status * ones(size(DeviceIndex));
        else
            %AM.Status = family2status(Family, AM.DeviceList);
            AM.Status = AO.Status(DeviceIndex);
        end
        if isfield(AO, Field)
            AM.Mode = AO.(Field).Mode;
            AM.Units = AO.(Field).Units;
            if strcmpi(AM.Units,'hardware')
                AM.UnitsString = AO.(Field).HWUnits;
            else
                AM.UnitsString = AO.(Field).PhysicsUnits;
            end
            AM.DataDescriptor = 'Get by FamilyName'; 
        else
            AM.Mode = 'Online';
            AM.Units = '';
            AM.UnitsString = '';
            AM.DataDescriptor = 'Get by Channel Name';
        end
        AM.CreatedBy = 'getpv';
    end

else

    % Look to see if it's a channel name or a common name
    % Just check the first name so it's a faster test
    [DeviceListTest, FamilyTest] = common2dev(deblank(Family(1,:)));
    %FamilyTest = '';
    if ~isempty(FamilyTest)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Family input is a common name list %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Field default will come from getbycommonname via another getpv call
        % The DeviceList should not exist (and should not be used)

        CommonNames = Family;
        [AM, tout, DataTime, DeviceList, ErrorFlag] = getbycommonname(CommonNames, Field, t, t0, FreshDataFlag, TimeOutPeriod, InputFlags{:});
        if ErrorFlag
            return;
        end

        % Structure output
        if StructOutputFlag
            AM = struct('Data', AM);
            AM.FamilyName = CommonNames;
            AM.Field = Field;
            AM.DeviceList = DeviceList;
            AM.Status = [];
            AM.Mode = getmode(FamilyTest(1,:));                      % Base on just the first common name
            [AM.Units, AM.UnitsString] = getunits(FamilyTest(1,:));  % Base on just the first common name
            AM.DataDescriptor = 'Get by Common Name';
            AM.CreatedBy = 'getpv';
        end

    else

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANNEL NAME - Online Only %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Can't use overrides with channel name method
        if ~isempty(UnitsFlag)
            error('You cannot change the units when using channel names.')
        end
        if ~(isempty(ModeFlag) || strcmpi(ModeFlag, 'Online'))
            error('Channel names only have an ''Online'' Mode.')
        end
        
        % There can be multiple channel names due to "ganged" power supplies or redundent user input
        [Family, i, j] = unique(Family, 'rows');

        % Remove ' ' and fill with NaN latter (' ' should always be the first row)
        if isempty(deblank(Family(1,:)))
            iblank = 1;
            Family(1,:) = [];
        else
            iblank = [];
        end

        % Add Field to Family.Field
        FamilyOld = Family;
        if ~isempty(Field)
            Family = strcat(Family, ['.',Field]);
        end

        ExtraTimeDelay = etime(clock, t0);
        if strcmpi(OutputDataType,'String')
            % Get data with strings output
            if StructOutputFlag || nargout >= 3
                [AM, tout, DataTime, ErrorFlag] = getpvonline(Family, 'String', 0, t-ExtraTimeDelay);
            else
                [AM, tout] = getpvonline(Family, 'String', 0, t-ExtraTimeDelay);
            end
        else
            % Get data at every point in time vector, t
            if StructOutputFlag || nargout >= 3
                [AM, tout, DataTime, ErrorFlag] = local_getbyname(Family, OutputDataType, 0, t-ExtraTimeDelay, FreshDataFlag, TimeOutPeriod);
            else
                [AM, tout] = local_getbyname(Family, OutputDataType, 0, t-ExtraTimeDelay, FreshDataFlag, TimeOutPeriod);
            end
        end
        tout = tout + ExtraTimeDelay;
        
        
        % Expand the blank channel names
        if ~isempty(iblank)
            AM = [NaN*ones(1,size(AM,2)); AM(iblank:end,:)];
            if nargout >= 3
                DataTime = [(NaN+NaN*sqrt(-1))*ones(1,size(DataTime,2)); DataTime(iblank:end,:)];
            end
        end
        
        
        % Expand multiple channelnames back to multiple devices
        if length(j)>1 && ~isempty(AM)
            AM = AM(j,:);
            if nargout >= 3
                DataTime = DataTime(j,:);
            end
        end

        % Structure output for channel name method
        if StructOutputFlag
            AM = struct('Data', AM);
            %AM.Data = AM;
            AM.FamilyName = FamilyOld;
            AM.Field = Field;
            AM.DeviceList = [];
            AM.Status = [];
            AM.Mode = 'Online';
            AM.Units = '';
            AM.UnitsString = '';
            AM.DataDescriptor = 'Get by Channel Name';
            AM.CreatedBy = 'getpv';
        end
    end
end


if StructOutputFlag || nargout >= 3
    % .DataTime is the time on computer taking the data but
    % reference it w.r.t. the time zone where Matlab is running
    
    if ~isempty(ModeFlag) && strcmpi(ModeFlag, 'SIMULATOR')
        DataTime = modeltime2datenum(DataTime);
    else
        DataTime = linktime2datenum(DataTime);
        
        %DateNumber1970 = 719529;  %datenum('1-Jan-1970');
        %days = datenum(t0(1:3)) - DateNumber1970;
        %t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
        %TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
        %DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);
    end
    
    
    % No time zone adjustment (UTC 00:00:00 Jan 1, 1970)
    %DataTime = real(DataTime)/60/60/24 + imag(DataTime)/(1e9 * 60 * 60 * 24);
end


% Structure output
if StructOutputFlag
    % Add time to structure
    AM.t = t;
    AM.tout = tout;
    AM.DataTime = DataTime;
    AM.TimeStamp = t0;

    % Make the output an AccObj object
    if ObjectOutputFlag
        AM = AccObj(AM);
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Main Function for Getting Data Using Common Names  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [AM, tout, DataTime, DeviceList, ErrorFlag] = getbycommonname(CommonNames, Field, t, t0, FreshDataFlag, TimeOutPeriod, varargin)

% Convert all the common names to Family and Device lists
[DeviceList, Family, ErrorFlag] = common2dev(CommonNames);

if ErrorFlag
    AM=[]; tout=[]; DataTime=[];
    return;
else

    if size(Family, 1) == 1
        % 1 Family, Multiple devices are ok
        [AM, tout, DataTime, ErrorFlag] = getpv(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod, 'Numeric', varargin{:});
    else
        % Multiple families (loop)
        % It has to be in a loop for the simulator and to pickup special functions

        if FreshDataFlag >= 1
            error('The FreshDataFlag is not programmed yet when when getting common names from multiple families (GJP).');
        end

        % Loop on the time vector (t0 has already been started)
        for itime = 1:length(t)
            T = t(itime)-etime(clock, t0);
            if T > 0
                pause(T);
            end
            for i = 1:size(Family,1)
                [AM(i,itime), tmp, DataTime(i,itime), ErrorFlag1] = getpv(Family(i,:), Field, DeviceList(i,:), 'Numeric', varargin{:});
                tout(1,itime) = etime(clock, t0);
                ErrorFlag = ErrorFlag | ErrorFlag1;
            end
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Main Function for Getting Data using the Channel Names  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [AM, tout, DataTime, ErrorFlag] = local_getbyname(ChannelName, OutputDataType, N, t, FreshDataFlag, TimeOutPeriod)

t0 = clock;
ErrorFlag = 0;


if nargout < 3
    [AM, tout] = getpvonline(ChannelName, OutputDataType, N, t);
else
    [AM, tout, DataTime, ErrorFlag] = getpvonline(ChannelName, OutputDataType, N, t);
end


% FreshDataFlag
if FreshDataFlag && length(t) == 1
    % Only use FreshDataFlag for scalar t
    FreshDataCounter = FreshDataFlag;
    AM0 = AM;
    while FreshDataCounter
        if nargout < 3
            [AM, tout] = getpvonline(ChannelName, OutputDataType, N);
        else
            [AM, tout, DataTime, ErrorFlag] = getpvonline(ChannelName, OutputDataType, N);
        end

        if ~any((AM-AM0)==0)
            FreshDataCounter = FreshDataCounter - 1;
            AM0 = AM;
        end

        if etime(clock, t0) > TimeOutPeriod
            k = find((AM-AM0)==0);
            for j = 1:length(k)
                fprintf('%s not changing.\n', deblank(ChannelName(k(j),:)));
            end
            error('Timed out waiting for fresh data.');
        end
    end
    tout = etime(clock, t0);
end

return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Main Function for Getting Data using the Accelerator Object  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [AM, tout, DataTime, ErrorFlag, DeviceIndex] = local_getpv(AO, Field, DeviceList, OutputDataType, t, FreshDataFlag, TimeOutPeriod)

t0 = clock;
ErrorFlag = 0;
N = 0;  % Output size


% Find the index for where the desired data is in the total device list
if isfield(AO.(Field), 'DeviceList')
    DeviceListTotal = AO.(Field).DeviceList;
else
    DeviceListTotal = AO.DeviceList;
end
[DeviceIndex, iNotFound] = findrowindex(DeviceList, DeviceListTotal);
if ~isempty(iNotFound)
    % Device not found
    for i = 1:length(iNotFound)
        fprintf('   No devices to get for Family %s(%d,%d)\n', AO.FamilyName, DeviceList(i,1), DeviceList(i,2));
    end
    error(sprintf('%d Devices not found', length(iNotFound)));
end

% Check the DeviceIndex
if isempty(DeviceIndex)
    DataTime = 0 + 0*sqrt(-1);
    tout = etime(clock, t0);
    AM = [];
    %fprintf('   WARNING:  No devices to get for Family %s (getpv)\n', AO.FamilyName);
    return;
end


% If Field is not found in the AO, it is unclear what to do next.
% I could error here, but it's convenient to try to get
% EPICS subfields or other simulator fields at this point.
if ~isfield(AO, Field);
    % Try to check it online or simulator
    if isfield(AO, 'Setpoint')
        Mode = getfamilydata(AO.FamilyName, 'Setpoint', 'Mode');
    elseif isfield(AO, 'Monitor')
        Mode = getfamilydata(AO.FamilyName, 'Monitor', 'Mode');
    else
        Mode = '';
    end
    if strcmpi(Mode,'Simulator') || strcmpi(Mode,'Model')
        ExtraTimeDelay = etime(clock, t0);
        [AM, tout, DataTime, ErrorFlag] = getpvmodel(AO.FamilyName, Field, DeviceList, t-ExtraTimeDelay, 'Physics', 'Numeric');
        tout = tout + ExtraTimeDelay;
        
        % Since physics2hw conversions are not known for fields that are not families, just return
        return
    end
    
    % Try changing the suffix of the Monitor or Setpoint field
    if isfield(AO, 'Setpoint')
        Channel = family2channel(AO, 'Setpoint', DeviceList);
    elseif isfield(AO, 'Monitor')
        Channel = family2channel(AO, 'Monitor', DeviceList);
    else
        error(sprintf('Field %s not found for Family %s', Field, AO.FamilyName));
    end
    if any(strcmpi(getfamilydata('Machine'),{'spear3','spear'}))
        % Spear likes to change the channel name after the ':'
        
        %i = findstr(Channel(1,:),':');
        %if ~isempty(i)
        %    Channel(:,i:end) = [];
        %end
        %Channel = strcat(Channel, [':',Field]);

        % Since the location of ":" can be different in each row, loop
        ChannelMat = [];
        for j = 1:size(Channel,1)
            i = findstr(Channel(j,:),':');
            if isempty(i)
                % I'm not sure what to do if ":" is missing, I'm just add a ":"
                ChannelMat = strvcat(ChannelMat, [Channel(j,1:i), ':', Field]);
            else
                ChannelMat = strvcat(ChannelMat, [Channel(j,1:i), Field]);
            end
        end
        Channel = ChannelMat;

    else
        % Add a .Field (EPICS) 
        Channel = strcat(Channel, ['.',Field]);
    end

    ExtraTimeDelay = etime(clock, t0);
    if nargout < 3
        [AM, tout] = getpvonline(Channel, OutputDataType, N, t-ExtraTimeDelay, FreshDataFlag, TimeOutPeriod);
    else
        [AM, tout, DataTime, ErrorFlag] = getpvonline(Channel, OutputDataType, N, t-ExtraTimeDelay, FreshDataFlag, TimeOutPeriod);
    end
    tout = tout + ExtraTimeDelay;
    return
end


AOField = AO.(Field);   % Should I replace this????

if isfield(AOField, 'Mode')
    Mode = AOField.Mode;
else
    Mode = 'Online';
end


% Check if Online should really be special
if strcmpi(Mode, 'Online')
   if isfield(AO.(Field), 'SpecialFunctionGet')
       Mode = 'Special';
   end
end


if ~isstruct(AO.(Field))
    % If it's not a structure that just get the field
    % Hardward and physics get ignored
    t1 = clock;
    [AM, ErrorFlag] = getfamilydata(AO.FamilyName, Field, DeviceList);
    
    tout = etime(t1, t0);
    if nargout >= 3
        days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
        tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
        DataTime(1:size(AM,1),1:length(t)) = fix(tt) + rem(tt,1)*1e9*sqrt(-1);
    end
    
elseif strcmpi(Mode,'online')
    % Online
    if strcmpi(AOField.DataType,'Scalar')
        N = 1;  % Output size

        ExtraTimeDelay = etime(clock, t0);
        if nargout < 3
            [AM, tout] = getpvonline(AOField.ChannelNames(DeviceIndex,:), OutputDataType, N, t-ExtraTimeDelay);
        else
            [AM, tout, DataTime, ErrorFlag] = getpvonline(AOField.ChannelNames(DeviceIndex,:), OutputDataType, N, t-ExtraTimeDelay);
        end
        tout = tout + ExtraTimeDelay;

        % FreshDataFlag
        if FreshDataFlag && length(t) == 1
            % Only use FreshDataFlag for scalar t
            FreshDataCounter = FreshDataFlag;
            AM0 = AM;
            while FreshDataCounter
                if nargout < 3
                    [AM, tout] = getpvonline(AOField.ChannelNames(DeviceIndex,:), OutputDataType, N);
                else
                    [AM, tout, DataTime, ErrorFlag] = getpvonline(AOField.ChannelNames(DeviceIndex,:), OutputDataType, N);
                end

                if ~any((AM-AM0)==0)
                    FreshDataCounter = FreshDataCounter - 1;
                    AM0 = AM;
                end

                if etime(clock, t0) > TimeOutPeriod
                    k = find((AM-AM0)==0);
                    for j = 1:length(k)
                        fprintf('%s not changing.\n', deblank((AOField.ChannelNames(DeviceIndex(k(j)),:))));
                    end
                    error('Timed out waiting for fresh data.');
                end
            end
            tout = etime(clock, t0);
        end
        
    elseif strcmpi(AOField.DataType, 'Vector')

        % Output(DataTypeIndex) must be equal to the number of elements in the family
        
        % There can only be one channel name for DataType='Vector'
        ChannelNames = deblank(AOField.ChannelNames(1,:));


        % Get data at every point in time vector, t
        AM = [];
        ExtraTimeDelay = etime(clock, t0);
        t = t - ExtraTimeDelay;
        for itime = 1:length(t)
            T = t(itime)-etime(clock, t0);
            if T > 0
                pause(T);
            end

            % Get data
            if nargout >= 3
                [tmp, tout, DataTime(:,itime), ErrorFlag] = getpvonline(ChannelNames, 'Vector', N);
            else
                tmp = getpvonline(ChannelNames, 'Vector', N);
            end
            if isfield(AOField, 'DataTypeIndex')
                tmp = tmp(AOField.DataTypeIndex);
            end
            AM = [AM tmp(DeviceIndex,:)];

            tout(itime) = etime(clock, t0);
        end

        % FreshDataFlag
        if FreshDataFlag && length(t) == 1
            % Only use FreshDataFlag for scalar t
            FreshDataCounter = FreshDataFlag;
            AM0 = AM;
            while FreshDataCounter
                if nargout >= 3
                    [AM, tout, DataTime, ErrorFlag] = getpvonline(ChannelNames, 'Vector', N);
                else
                    AM = getpvonline(ChannelNames, 'Vector', N);
                end
                if isfield(AOField, 'DataTypeIndex')
                    AM = AM(AOField.DataTypeIndex);
                end
                AM = AM(DeviceIndex,:);

                if ~any((AM-AM0)==0)
                    FreshDataCounter = FreshDataCounter - 1;
                    AM0 = AM;
                end

                if etime(clock, t0) > TimeOutPeriod
                    k = find((AM-AM0)==0);
                    for j = 1:length(k)
                        fprintf('%s[%d,%d] not changing.\n', AO.FamilyName, DeviceList(k(j),1), DeviceList(k(j),2));
                    end
                    error('Timed out waiting for fresh data.');
                end
            end
            tout = etime(clock, t0);
        end

    elseif any(strcmpi(AOField.DataType, {'Matrix','Waveform'}))
        
        for iDev = 1:length(DeviceIndex)
            %AM(iDev,:) = rand(1,10); DataTime(iDev,:) = now; ErrorFlag(iDev,:)=0;
            [AM(iDev,:), tout, DataTime(iDev,:), ErrorFlag(iDev,1)] = getpvonline(AOField.ChannelNames(DeviceIndex(iDev),:), 'Matrix', N);
        end
        ErrorFlag = any(ErrorFlag);
        tout = etime(clock, t0);

    else
        %error(sprintf('Unknown DataType for family %s.', AO.FamilyName));
        
        % Unknown DataType but just pass it on like a scalar (needed for machines like TLS)
        N = 1;  % Output size

        ExtraTimeDelay = etime(clock, t0);
        if nargout < 3
            [AM, tout] = getpvonline(AOField.ChannelNames(DeviceIndex,:), OutputDataType, N, t-ExtraTimeDelay);
        else
            [AM, tout, DataTime, ErrorFlag] = getpvonline(AOField.ChannelNames(DeviceIndex,:), OutputDataType, N, t-ExtraTimeDelay);
        end
        tout = tout + ExtraTimeDelay;

        % FreshDataFlag
        if FreshDataFlag && length(t) == 1
            % Only use FreshDataFlag for scalar t
            FreshDataCounter = FreshDataFlag;
            AM0 = AM;
            while FreshDataCounter
                if nargout < 3
                    [AM, tout] = getpvonline(AOField.ChannelNames(DeviceIndex,:), OutputDataType, N);
                else
                    [AM, tout, DataTime, ErrorFlag] = getpvonline(AOField.ChannelNames(DeviceIndex,:), OutputDataType, N);
                end

                if ~any((AM-AM0)==0)
                    FreshDataCounter = FreshDataCounter - 1;
                    AM0 = AM;
                end

                if etime(clock, t0) > TimeOutPeriod
                    k = find((AM-AM0)==0);
                    for j = 1:length(k)
                        fprintf('%s not changing.\n', deblank((AOField.ChannelNames(DeviceIndex(k(j)),:))));
                    end
                    error('Timed out waiting for fresh data.');
                end
            end
            tout = etime(clock, t0);
        end
    end

    % Change to physics units if Units = 'physics'
    if strcmpi(AO.(Field).Units,'physics')
        % Change to physics units
        AM = hw2physics(AO.FamilyName, Field, AM, DeviceList);
    end

elseif strcmpi(Mode,'Special')

    if isfield(AOField, 'SpecialFunctionGet')
        SpecialFunction = AOField.SpecialFunctionGet;
    elseif isfield(AOField, 'SpecialFunction')
        SpecialFunction = AOField.SpecialFunction;
    else
        error(sprintf('No special function specified for Family %s (getpv).', AO.FamilyName));
    end

    % Get data at every point in time vector, t
    ExtraTimeDelay = etime(clock, t0);
    t = t - ExtraTimeDelay;
    [AM, tout, DataTime, ErrorFlag] = feval(SpecialFunction, AO.FamilyName, Field, DeviceList, t);
    t1 = clock;
    if isempty(tout)
        tout = etime(t1, t0);
    end
    if nargout >= 3 && isempty(DataTime)
        days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
        tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
        DataTime(1:size(AM,1),1) = fix(tt) + rem(tt,1)*1e9*sqrt(-1);
    end
    if length(t) > length(tout)
        for itime = 2:length(t)
            T = t(itime)-etime(clock, t0);
            if T > 0
                pause(T);
            end

            % Get data
            [Tmp, toutTmp, DataTimeTmp, ErrorFlag] = feval(SpecialFunction, AO.FamilyName, Field, DeviceList, t);
            
            AM = [AM Tmp];
            DataTime = [DataTime DataTimeTmp];

            t1 = clock;
            tout(1,itime) = etime(t1, t0);
            if nargout >= 3 && isempty(DataTimeTmp)
                days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
                tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
                DataTime(1:size(AM,1),itime) = fix(tt) + rem(tt,1)*1e9*sqrt(-1);
            end
        end
    end

    % FreshDataFlag
    if FreshDataFlag && length(t) == 1
        % Only use FreshDataFlag for scalar t
        FreshDataCounter = FreshDataFlag;
        AM0 = AM;
        while FreshDataCounter
            % Get data
            [AM, tout, DataTime, ErrorFlag] = feval(SpecialFunction, AO.FamilyName, Field, DeviceList, t);

            if ~any((AM-AM0)==0)
                FreshDataCounter = FreshDataCounter - 1;
                AM0 = AM;
            end

            t1 = clock;
            if etime(t1, t0) > TimeOutPeriod
                k = find((AM-AM0)==0);
                for j = 1:length(k)
                    fprintf('%s[%d,%d] not changing.\n', AO.FamilyName, DeviceList(k(j),1), DeviceList(k(j),2));
                end
                error('Timed out waiting for fresh data.');
            end
        end
        tout = etime(t1, t0);

        if nargout >= 3 && isempty(DataTime)
            days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
            tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
            DataTime(1:size(AM,1),1) = fix(tt) + rem(tt,1)*1e9*sqrt(-1);
        end
    end

    % Change to physics units if Units = 'physics'
    if strcmpi(AO.(Field).Units,'physics')
        % Change to physics units
        AM = hw2physics(AO.FamilyName, Field, AM, DeviceList);
    end

elseif strcmpi(Mode,'manual')
    % Always return in hardware units (like connected to the IOC)
    % The conversion to physics in done at the end
    t = 0;
    if strcmpi(AO.FamilyName, 'TUNE')
        HarmNumber = [];
        RF = [];
        if find(DeviceIndex == 1)
            AM(1,1) = input(sprintf('   Input the horizontal tune (fraction or Hz) = '));
            if AM(1,1) > 1
                HarmNumber = getharmonicnumber;
                RF = getrf('Struct');
                if strcmpi(RF.UnitsString,'MHz')
                    FundFreq = 1e6*RF.Data / HarmNumber;
                elseif strcmpi(RF.UnitsString,'Hz')
                    FundFreq = RF.Data / HarmNumber;
                else
                    error('RF units in not known.');
                end
                %AM(1,1) = (AM(1,1)- RF) / FundFreq;
                AM(1,1) = AM(1,1) / FundFreq;
                fprintf('   Horizontal fraction tune computed to be %f\n\n', AM(1,1));
            end
        end
        if find(DeviceIndex == 2)
            AM(2,1) = input(sprintf('   Input the vertical   tune (fraction or Hz) = '));
            if AM(2,1) > 1
                if isempty(HarmNumber)
                    HarmNumber = getharmonicnumber;
                end
                if isempty(RF)
                    RF = getrf('Struct');
                end
                if strcmpi(RF.UnitsString,'MHz')
                    FundFreq = 1e6*RF.Data / HarmNumber;
                elseif strcmpi(RF.UnitsString,'Hz')
                    FundFreq = RF.Data / HarmNumber;
                else
                    error('RF units in not known.');
                end
                AM(2,1) = AM(2,1)/FundFreq;
                %AM(2,1) = (AM(2,1) - HarmNumber * FundFreq)/FundFreq;
                fprintf('   Vertical   fraction tune computed to be %f\n\n', AM(2,1));
            end
        end
        if find(DeviceIndex == 3)
            AM(2,1) = input('   Input the synchrotron tune = ');
        end
    elseif strcmpi(AO.FamilyName, 'RF')
        if strcmpi(AO.(Field).Units, 'Hardware')
            AM(1) = input(sprintf('   Input the RF frequency [%s] = ', AO.(Field).HWUnits));
        else
            AM(1) = input(sprintf('   Input the RF frequency [%s] = ', AO.(Field).PhysicsUnits));
            AM = physics2hw(AO.FamilyName, Field, AM, [1 1]);
        end
    else
        for i = 1:length(DeviceIndex)
            if strcmpi(AO.(Field).Units, 'Hardware')
                AM(i,:) = input(sprintf('   Manual input:  %s(%d,%d) [%s] = ', AO.FamilyName, AO.DeviceList(DeviceIndex(i),1), AO.DeviceList(DeviceIndex(i),2), AO.(Field).HWUnits));
            else
                AM(i,:) = input(sprintf('   Manual input:  %s(%d,%d) [%s] = ', AO.FamilyName, AO.DeviceList(DeviceIndex(i),1), AO.DeviceList(DeviceIndex(i),2), AO.(Field).PhysicsUnits));
                AM(i,:) = physics2hw(AO.FamilyName, Field, AM(i,:), AO.DeviceList(DeviceIndex(i),:));
            end
        end
    end
    
    t1 = clock;
    tout = etime(t1, t0);
    days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
    tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
    DataTime(1:size(AM,1),1) = fix(tt) + rem(tt,1)*1e9*sqrt(-1);

    % Change to physics units if Units = 'physics'
    if strcmpi(AO.(Field).Units,'physics')
        % Change to physics units
        AM = hw2physics(AO.FamilyName, Field, AM, DeviceList);
    end


elseif strcmpi(Mode,'Simulator') || strcmpi(Mode,'Model')

    ExtraTimeDelay = etime(clock, t0);
    %[AM, tout, DataTime, ErrorFlag] = getpvmodel(AO, Field, DeviceList, t-ExtraTimeDelay, 'Physics', 'Numeric');
    [AM, tout, DataTime, ErrorFlag] = getpvmodel(AO, Field, DeviceList, t-ExtraTimeDelay, AO.(Field).Units, 'Numeric');
    tout = tout + ExtraTimeDelay;

    if strcmpi(OutputDataType, 'String')
        AM = num2str(AM);
    end
        
    % Change to physics units if Units = 'physics'
    %if strcmpi(AO.(Field).Units,'Hardware')
    %    % Change to physics units
    %    AM = physics2hw(AO.FamilyName, Field, AM, DeviceList, getenergymodel);
    %end

else
    error(sprintf('Unknown mode for family %s.', AO.FamilyName));
end



