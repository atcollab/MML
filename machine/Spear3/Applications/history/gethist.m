function [data, t, ColumnNames] = gethist(StartTime, EndTime, Family, varargin) 
%GETHIST - Mines data from the Oracle-RDB database
%
%  Family name method
%  [Data, t, ColumnNames] = gethist(StartTime, EndTime, Family, Field, DeviceList)
%
%  Channel name method
%  [Data, t, ColumnNames] = gethist(StartTime, EndTime, ChannelName)
%
%  History database name and table method:
%  [Data, t, ColumnNames] = gethist(StartTime, EndTime, HistoryBufferName, TableName)
%
%  INPUTS
%  1-2. StartTime and EndTime can be a string in the Oracle format,
%              yyyy-mm-dd hh:mm:ss.ss like 2002-06-18 16:56:00.00
%              or something that datastr recognized, like a date serial 
%              number (see help datenum) or a vector with [y m d h m s] format.
%  3-4. Family - Family name
%                or a cell array of family names
%       Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {'Monitor'}
%  3.   ChannelName - ChannelName name
%                or a cell array of channel names
%  3-4. HistoryBufferName and Table can be used instead of Family and Field.
%       These are the Oracle database and table names (or use getrdbdata directly).
%
%  OUTPUTS
%  1. Data is a matrix of history data where each column is a different point in time. 
%  2. t is in Matlab's serial date format.  Convert to other formats using
%     datestr or datevec.  datetick converts a plot axis to more reasonable text.
%  3. ColumnNames is a matrix of strings where each row is the database column name. 
%
%  NOTES
%  1. If Family is a cell array, then Data and ColumnNames outputs are cell arrays.
%  2. If Family is a cell array, then Field and DeviceList do not have to be cell array 
%  3. The input time can not be a cell array 
%  4. If no data is found, empty matrices are returned.
%  5. In order for the history commands to work:
%     a.  The database toolbox must on the path
%     b.  The classpath.txt file in the local directory of Matlab
%         must have the full path to classes111.zip added to it.  For instance,
%         R:\Controls\matlab\applications\history\classes111.zip
%     c.  The user must have access to the VMS oracle database
% 
%     Database names for Spear3 can be found on the web at:
%     SSRL ->  Commissioning
%          ->  EPICS
%          ->  PV RDB Database 
%
%  EXAMPLES
%  1. Get and plot one hour and six minutes of HCM monitor data on January 18, 2004
%     [d,t,col] = gethist('2004-01-18 16:50:00.00', '2004-01-18 17:56:00.00', 'HCM', 'Monitor');
%                   or
%     [d,t,col] = gethist([2004 1 18 16 50 00], [2004 1 18 17 56 00], 'HCM', 'Monitor');
%     plot(t,d); datetick x
%
%  Written by Greg Portmann using Jim Sebek's Oracle (rdb) to Matlab database connection method


% To do:
% 1. Test time for cell arrays and possibily change to combine calls
% 2. Add a time decimation input


% Input checking
if nargin < 3
    error('At least 3 inputs required.');
end
if iscell(StartTime) | iscell(EndTime)
    error('The start and end times cannot be cell arrays.');
end


fprintf('   Looking up history and  table names: %s', datestr(now,14)); tic;
if isfamily(Family) | iscell(Family)
    % Family or cell input
    [HistoryName, TableName] = family2history(Family, varargin{:});
else
    % HistoryName input
    HistoryName = Family;
    if length(varargin) < 1
        % Assume a pv is input
        [HistoryName, TableName] = family2history(Family);
    else
        % Assume the input is already a history buffer Name/Table
        TableName = varargin{1};
    end
end
fprintf(' /%s (%.1f seconds)\n', datestr(now,14), toc);


% Get data from rdb database
[data, t, ColumnNames] = getrdbdata(StartTime, EndTime, HistoryName, TableName);





% % For cell inputs 
% if iscell(Family)
%     if nargin >= 4
%         if iscell(varargin{1})
%             if length(Family) ~= length(varargin{1})
%                 error('Field/TableName must be the same size cell array as Family/HistoryBufferName');
%             end
%         else
%             error('Field/TableName must be the same size cell array as Family/HistoryBufferName');
%         end
%     end
%     if nargin >= 5
%         if iscell(varargin{2})
%             if length(Family) ~= length(varargin{2})
%             error('DeviceList must be the same size cell array as Family');
%             end
%         end
%     end
%     
%     for i = 1:length(Family)
%         if nargin == 1
%             [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i});
%         elseif nargin == 2            
%             if iscell(Field)
%                 [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field{i});
%             else
%                 [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field);
%             end
%         else              
%             if iscell(Field)      
%                 if iscell(DeviceList)       
%                     [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field{i}, DeviceList{i});
%                 else
%                     [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field{i}, DeviceList);
%                 end
%             else
%                 if iscell(DeviceList)       
%                     [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field, DeviceList{i});
%                 else
%                     [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field, DeviceList);
%                 end
%             end
%         end
%     end
% else
%     if nargin >= 4
%         if iscell(varargin{1})
%             error('If Field is a cell, than Family must be a cell.');
%         end
%     end
%     if nargin >= 5
%         if iscell(varargin{2})
%             error('If DeviceList is a cell, than Family must be a cell.');
%         end
%     end
% end
% % End cell inputs