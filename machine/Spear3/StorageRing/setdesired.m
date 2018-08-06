function setdesired(Input1, FamilyName)
%  setdesired(Input, FamilyName)
%
%  Set the desired setpoint field to the golden lattice value
%  so that the machine will be cycled to these values.
%
%  Input - 'Golden' for the golden lattice {Default}
%           ConfigSetpoint structure
%           Filename 
%           [] - empty to browse
%  FamilyName - Family or cell array families to set {Default: all families}
%
%  Written by Greg Portmann


if nargin < 1
    Input1 = 'Golden';
end
if nargin < 2
    FamilyName = [];
end


% Get input lattice structure
if isstruct(Input1)
    ConfigSetpoint = Input1;
elseif isempty(Input1)
    % Default file
    %DirectoryName = getfamilydata('Directory', 'ConfigData');
    DirectoryName = getfamilydata('Directory', 'GoldenConfigFiles');   %wjc 1/15/07
    [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load to LATVALS', DirectoryName);
    if FileName == 0
        fprintf('   SETDESIRED cancelled\n');
        return
    end
    load([DirectoryName FileName]);
    ad=getad;
    ad.ConfigName=FileName;
    setad(ad);
elseif strcmpi(Input1, 'Golden')
    FileName = getfamilydata('OpsData', 'LatticeFile');
    DirectoryName = getfamilydata('Directory', 'OpsData');
    load([DirectoryName FileName]);
    FileName = [DirectoryName FileName];
    ad=getad;
    ad.ConfigName=FileName;
    setad(ad);
elseif strcmpi(Input1, 'Injection')
    FileName = getfamilydata('OpsData', 'InjectionFile');
    DirectoryName = getfamilydata('Directory', 'OpsData');
    load([DirectoryName FileName]);
    FileName = [DirectoryName FileName];
else
    % Input file name
    load(Input1);
    ad=getad;
    ad.ConfigName=Input1;
    setad(ad);

end


if isempty(FamilyName)
    FieldNameCell = fieldnames(ConfigSetpoint);
elseif iscell(FamilyName)
    FieldNameCell = FamilyName;
elseif size(FamilyName,1) > 1
    for i = 1:size(FamilyName,1)
        FieldNameCell{i} = FamilyName(i,:);
    end
else
    FieldNameCell = {FamilyName};
end


% % Build the cell array
% j = 0;
% for i = 1:length(FieldNameCell)
%     if isfield(ConfigSetpoint, deblank(FieldNameCell{i}))
%         j = j + 1;
%         SPcell{j} = ConfigSetpoint.(deblank(FieldNameCell{i}));
%     else
%         fprintf('   Field does not exist for family %s, hence ignored (setdesired)\n', deblank(FieldNameCell{i}));
%     end
% end


% Build the cell array
j = 0;
for i = 1:length(FieldNameCell)
    FieldNameCell{i} = deblank(FieldNameCell{i});
    if isfield(ConfigSetpoint, FieldNameCell{i})
        if isfield(ConfigSetpoint.(FieldNameCell{i}),'Data') & isfield(ConfigSetpoint.(FieldNameCell{i}),'FamilyName')
            j = j + 1;
            SPcell{j} = ConfigSetpoint.(FieldNameCell{i});
        else
            % Find all the subfields that are data structures
            SubFieldNameCell = fieldnames(ConfigSetpoint.(FieldNameCell{i}));
            for ii = 1:length(SubFieldNameCell)
                if isfield(ConfigSetpoint.(FieldNameCell{i}).(SubFieldNameCell{ii}),'Data') & isfield(ConfigSetpoint.(FieldNameCell{i}).(SubFieldNameCell{ii}),'FamilyName')
                    j = j + 1;
                    SPcell{j} = ConfigSetpoint.(FieldNameCell{i}).(SubFieldNameCell{ii});
                end
            end
        end
    else
        fprintf('   %s field does not exist for family, hence ignored (setdesired)\n', deblank(FieldNameCell{i}));
    end
end


% Make the setpoint change(s)
for k = 1:length(SPcell)
    [i, ao] = isfamily(SPcell{k}.FamilyName);
    if isfield(ao,'Desired')
        try
            setpv(SPcell{k}.FamilyName, 'Desired', SPcell{k}.Data, [], 0);
        catch
            fprintf('   Trouble with setsp(%s), hence ignored (setdesired)\n', SPcell{k}.FamilyName);
            %lasterr
        end
    end
end


%wjc May 3, 2007
ad=getad;
setpv('SPEAR:ConfigMode',ad.OperationalMode)
setpv('SPEAR:ConfigName',ad.ConfigName)
setpv('SPEAR:ConfigTimeStamp',datestr(clock,31))

