function [HistoryName, TableName, ErrorFlag] = family2history(Family, Field, DeviceList)
%FAMILY2HISTORY - Converts family name to history buffer name
%  [HistoryName, TableName] = family2history(Family, Field, DeviceList)
%
%  INPUTS
%  1. Family - Family Name 
%              Cell Array of Family Names
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: 'Monitor'}
%  3. DeviceList ([Sector Device #] or [element #]) {Default: whole family}
%
%  OUTPUTS
%  1. HistoryName - Database history names corresponding to the Family and DeviceList
%  2. TableName - Table where the data can be found
%
%  NOTES
%  1. If Family is a cell array, then DeviceList must also be a cell array
% 
%  Written by Greg Portmann


if nargin == 0
    error('Must have at least one input.');
end


% For cell inputs
if iscell(Family)
    if nargin >= 2
        if iscell(Field)
            if length(Family) ~= length(Field)
                error('Field must be the same size cell array as Family or a string array.');
            end
        end
    end
    if nargin >= 3
        if iscell(DeviceList)
            if length(Family) ~= length(DeviceList)
                error('DeviceList must be the same size cell array as Family or a matrix.');
            end
        end
    end
    
    for i = 1:length(Family)
        if nargin == 1
            [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i});
        elseif nargin == 2            
            if iscell(Field)
                [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field{i});
            else
                [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field);
            end
        else              
            if iscell(Field)      
                if iscell(DeviceList)       
                    [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field{i}, DeviceList{i});
                else
                    [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field{i}, DeviceList);
                end
            else
                if iscell(DeviceList)       
                    [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field, DeviceList{i});
                else
                    [HistoryName{i}, TableName{i}, ErrorFlag{i}] = family2history(Family{i}, Field, DeviceList);
                end
            end
        end
    end
    return    
else
    if nargin >= 3
        if iscell(Field) | iscell(DeviceList)
            error('If Field or DeviceList is a cell, than Family must be a cell.');
        end
    end
end
% End cell inputs


% If Family is matrix of strings
if size(Family,1) > 1
    if nargin >= 2
        if size(Field,1) > 1
            if size(Field,1) ~= size(Family,1)
                error('Field can be a row vector or it must be the equal to the number of rows in Family.');
            end    
        end
    end
    HistoryName=[]; TableName=[];
    for i = 1:size(Family,1)  
        if nargin == 1
            [HistoryName1, TableName1, ErrorFlag(i,1)] = family2history(Family(i,:));
        elseif nargin == 2
            if size(Field,1) > 1
                [HistoryName1, TableName1, ErrorFlag(i,1)] = family2history(Family(i,:), Field(i,:));
            else
                [HistoryName1, TableName1, ErrorFlag(i,1)] = family2history(Family(i,:), Field);
            end
        else
            if size(Field,1) > 1
                [HistoryName1, TableName1, ErrorFlag(i,1)] = family2history(Family(i,:), Field(i,:), DeviceList(i,:));
            else
                [HistoryName1, TableName1, ErrorFlag(i,1)] = family2history(Family(i,:), Field, DeviceList(i,:));
            end
        end
        HistoryName = strvcat(HistoryName, HistoryName1);
        TableName = strvcat(TableName, TableName1);
    end
    return
end
% End multiple row Family inputs


% Initialize
HistoryName = [];
TableName = [];
ErrorFlag = 0;


% If it not a family just do the lookup
if ~isfamily(Family)
    [HistoryName, TableName] = getrdbtablename(Family);  
    return
end


if nargin < 2
    Field = [];
end
if isempty(Field)
    Field = 'Monitor';
end
if nargin < 3
    if isfamily(Family)
        DeviceList = getlist(Family);
    else
        DeviceList = [1 1];
    end
end
if isempty(DeviceList)
    if isfamily(Family)
        DeviceList = getlist(Family);
    else
        DeviceList = [1 1];
    end
end

% Family and Field should be row vectors at this point
Family = deblank(Family(1,:));
Field = deblank(Field(1,:));


% Main loop
if isfamily(Family)
    DeviceIndex = findrowindex(DeviceList, family2dev(Family,0));
    for j = 1:size(DeviceList,1)
        Name = family2channel(Family, Field, DeviceList(j,:));
        [Name, Table] = getrdbtablename(Name);
        
        HistoryName = strvcat(HistoryName, Name);
        TableName = strvcat(TableName, Table);
    end
    
%elseif strcmpi(Family,'Temperature') % & strcmpi(Field,'Tunnel')
    
    %[HistoryName, TableName] = getrdbtablename(Family);
    
    %DeviceList = DeviceList(:);  
    %for j = 1:size(DeviceList,1)
    %    HistoryName = strvcat(HistoryName, sprintf('TSPR$TG%02dR3C14$AM1', DeviceList(j,1)));
    %    TableName = strvcat(TableName, 'READBACK013');
    %end
    
else
    [HistoryName, TableName] = getrdbtablename(Family);
    %error(sprintf('No history name infomation for %s',Family));
end




% if strcmp(Family,'HCM') | strcmp(Family,'VCM')
%     Name = family2channel(Family, Field, DeviceList(j,:));
%     % Replace illegal characters '-', ':', '.', '=' with '$'
%     Name = strrep(Name,'-','_');
%     Name = strrep(Name,'.','$');
%     Name = strrep(Name,':','$');
%     Name = strrep(Name,'+','$');
%     Name = strrep(Name,'=','$');
%     Name = strrep(Name,'/','$');
%     
%     % Add 'T' to the beginning
%     Name = sprintf('T%s', Name);
%     
%     HistoryName = strvcat(HistoryName, Name);
%     TableName = strvcat(TableName, 'READBACK033');
% else


%% Replace illegal characters '-', ':', '.', '=' with '$'
%Name = strrep(Name,'-','_');
%Name = strrep(Name,'.','$');
%Name = strrep(Name,':','$');
%Name = strrep(Name,'+','$');
%Name = strrep(Name,'=','$');
%Name = strrep(Name,'/','$');
% 
%% Add 'T' to the beginning
%Name = sprintf('T%s', Name);


% Get table name
% if strcmp(Family,'BPMx') | strcmp(Family,'BPMy')
%     %if all(DeviceList==[1 1]) | all(DeviceList==[1 2])
%     TableName = strvcat(TableName, 'READBACK039');    
%     %end
% elseif strcmp(Family,'HCM') | strcmp(Family,'VCM')
%     TableName = strvcat(TableName, 'TRIMS_AC');    
% elseif strcmp(upper(Family),'DCCT') | strcmp(upper(Family),'BEAMCURRENT')
%     TableName = 'spear';
% elseif strcmp(Family,'BENDFEILD')
%     % BEND FIELD                                   
%     TableName = 'MAINS';
% elseif strcmp(Family,'BEND') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'BEND') & strcmp(lower(Field),'setpoint')
%     TableName = 'MAINS';
% elseif strcmp(Family,'QFB') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'QFB') & strcmp(lower(Field),'setpoint')
%     TableName = 'MAINS';
% elseif strcmp(Family,'Q1') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'Q1') & strcmp(lower(Field),'setpoint')
%     TableName = 'MAINS';
% elseif strcmp(Family,'Q2') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'QF') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'QF') & strcmp(lower(Field),'setpoint')
%     TableName = 'MAINS';
% elseif strcmp(Family,'QFA') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'QFA') & strcmp(lower(Field),'setpoint')
%     TableName = 'MAINS';
% elseif strcmp(Family,'SDB') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'SDB') & strcmp(lower(Field),'setpoint')
%     TableName = 'MAINS';
% elseif strcmp(Family,'SDA') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'SDA') & strcmp(lower(Field),'setpoint')
%     TableName = 'MAINS';
% elseif strcmp(Family,'SF') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'SF') & strcmp(lower(Field),'setpoint')
%     TableName = 'MAINS';
% elseif strcmp(Family,'QDA') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'QDA') & strcmp(lower(Field),'setpoint')
%     TableName = 'MAINS';
% elseif strcmp(Family,'QD') & strcmp(lower(Field),'monitor')
%     TableName = 'MAINS';
% elseif strcmp(Family,'QD') & strcmp(lower(Field),'setpoint')
%     TableName = 'MAINS';
% else
%     error(sprintf('No table infomation for %s',Family));
% end
