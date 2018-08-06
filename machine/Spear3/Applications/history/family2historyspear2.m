function [HistoryName, Table, ErrorFlag] = family2history(Family, Field, DeviceList)
%FAMILY2HISTORY - Converts family name to history buffer name (spear2)
%  [HistoryName, Table, ErrorFlag] = family2history(Family, Field, DeviceList)
%
%  INPUTS
%  1. Family = Family Name 
%              Cell Array of Family Names
%  2. Field = Accelerator Object field name ('Monitor', 'Setpoint', etc) {'Monitor'}
%  3. DeviceList ([Sector Device #] or [element #]) (default: whole family)
%
%  OUTPUTS
%  1. HistoryName = Database history names corresponding to the Family and DeviceList
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
            [HistoryName{i}, Table{i}, ErrorFlag{i}] = family2history(Family{i});
        elseif nargin == 2            
            if iscell(Field)
                [HistoryName{i}, Table{i}, ErrorFlag{i}] = family2history(Family{i}, Field{i});
            else
                [HistoryName{i}, Table{i}, ErrorFlag{i}] = family2history(Family{i}, Field);
            end
        else              
            if iscell(Field)      
                if iscell(DeviceList)       
                    [HistoryName{i}, Table{i}, ErrorFlag{i}] = family2history(Family{i}, Field{i}, DeviceList{i});
                else
                    [HistoryName{i}, Table{i}, ErrorFlag{i}] = family2history(Family{i}, Field{i}, DeviceList);
                end
            else
                if iscell(DeviceList)       
                    [HistoryName{i}, Table{i}, ErrorFlag{i}] = family2history(Family{i}, Field, DeviceList{i});
                else
                    [HistoryName{i}, Table{i}, ErrorFlag{i}] = family2history(Family{i}, Field, DeviceList);
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
    HistoryName=[]; Table=[];
    for i = 1:size(Family,1)  
        if nargin == 1
            [HistoryName1, Table1, ErrorFlag(i,1)] = family2history(Family(i,:));
        elseif nargin == 2
            if size(Field,1) > 1
                [HistoryName1, Table1, ErrorFlag(i,1)] = family2history(Family(i,:), Field(i,:));
            else
                [HistoryName1, Table1, ErrorFlag(i,1)] = family2history(Family(i,:), Field);
            end
        else
            if size(Field,1) > 1
                [HistoryName1, Table1, ErrorFlag(i,1)] = family2history(Family(i,:), Field(i,:), DeviceList(i,:));
            else
                [HistoryName1, Table1, ErrorFlag(i,1)] = family2history(Family(i,:), Field, DeviceList(i,:));
            end
        end
        HistoryName = strvcat(HistoryName, HistoryName1);
        Table = strvcat(Table, Table1);
    end
    return
end
% End multiple row Family inputs


% Initialize
HistoryName = [];
Table = [];
ErrorFlag = 0;

if nargin < 2
    Field = 'Monitor';
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
NameList = [];
if strcmp(Family,'BPMx') | strcmp(Family,'BPMy')
    for j = 1:size(DeviceList,1)
        Name = family2common(Family, DeviceList(j,:));
        Name = upper(deblank(Name));
        
        % Remove -
        Name = strrep(Name,'-','');

        if strcmp(Family,'BPMx')
            Name = sprintf('BPM_%s$X',Name);
        else
            Name = sprintf('BPM_%s$Y',Name);
        end
        HistoryName = strvcat(HistoryName, Name);
        Table = strvcat(Table, 'SPEAR_BPM');
    end
    
elseif strcmp(Family,'HCM') | strcmp(Family,'VCM')
    for j = 1:size(DeviceList,1)
        Name = family2channel(Family, Field, DeviceList(j,:));
        if isempty(Name)
            error(sprintf('Channel name was not found for %s(%d,%d).', Family, DeviceList(j,:)));
        end
        Name = deblank(upper(Name));
        i=findstr('SPR:',Name);
        if ~isempty(i)
            Name(i:i+3) = [];
        end
        
        % Replace / with $
        Name = strrep(Name,'/','$');
        
        if all(DeviceList(j,:) == [6 1]) & strcmp(lower(Field),'monitor') & strcmp(Family,'HCM')
            % No "1' on HCM(6,1)
            Name = sprintf('%s',Name);
        else
            Name = sprintf('%s1',Name);
        end
        
        HistoryName = strvcat(HistoryName, Name);
        
        if strcmp(lower(Field),'monitor')
            Table = strvcat(Table, 'TRIMS');
        else
            Table = strvcat(Table, 'TRIMS_AC');
        end
    end
    
elseif strcmp(upper(Family),'DCCT') | strcmp(upper(Family),'BEAMCURRENT')
    HistoryName = 's02O1$dv1';
    Table = 'spear';
elseif strcmp(Family,'BENDFEILD')
    % BEND FIELD                                   
    HistoryName = 'M02Q1$AM1';
    Table = 'MAINS';
elseif strcmp(Family,'BEND') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q1$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'BEND') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q1$AC1';
    Table = 'MAINS';
elseif strcmp(Family,'QFB') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q10$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'QFB') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q10$AC1';
    Table = 'MAINS';
elseif strcmp(Family,'Q1') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q11$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'Q1') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q11$AC1';
    Table = 'MAINS';
elseif strcmp(Family,'Q2') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q13$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'Q2') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q13$AC1';
    Table = 'MAINS';
elseif strcmp(Family,'QF') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q2$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'QF') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q2$AC1';
    Table = 'MAINS';
elseif strcmp(Family,'QFA') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q4$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'QFA') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q4$AC1';
    Table = 'MAINS';
elseif strcmp(Family,'SDB') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q5$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'SDB') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q5$AC1';
    Table = 'MAINS';
elseif strcmp(Family,'SDA') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q8$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'SDA') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q8$AC1';
    Table = 'MAINS';
elseif strcmp(Family,'SF') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q7$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'SF') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q7$AC1';
    Table = 'MAINS';
elseif strcmp(Family,'QDA') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q6$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'QDA') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q6$AC1';
    Table = 'MAINS';
elseif strcmp(Family,'QD') & strcmp(lower(Field),'monitor')
    HistoryName = 'M02Q9$DV1';
    Table = 'MAINS';
elseif strcmp(Family,'QD') & strcmp(lower(Field),'setpoint')
    HistoryName = 'M02Q9$AC1';
    Table = 'MAINS';
else
    HistoryName = Family;
    Table = Field;
    ErrorFlag = -1;
    %error(sprintf('No history name infomation for %s',Family));
end


