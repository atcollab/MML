function buildapexarchiver(DeviceTypesToPrint)

ao = getao;
FamilyNames = fieldnames(ao);
%FamilyNames{1} = 'Sol1M'

if nargin < 1
    DeviceTypesToPrint = 'bi';
end

for i = 1:length(FamilyNames)
    % Find all the subfields that are data structures
    SubFieldNameCell = fieldnames(ao.(FamilyNames{i}));
    
    for ii = 1:length(SubFieldNameCell)
        if isfield(ao.(FamilyNames{i}).(SubFieldNameCell{ii}),'ChannelNames')
            Names = ao.(FamilyNames{i}).(SubFieldNameCell{ii}).ChannelNames;
            MemberOf = ao.(FamilyNames{i}).(SubFieldNameCell{ii}).MemberOf;
            
            if any(strcmpi('Boolean Monitor', MemberOf))
                DeviceType = 'bi';
            elseif any(strcmpi('Boolean Control', MemberOf))
                DeviceType = 'bo';
            elseif any(strcmpi('Monitor', MemberOf))
                DeviceType = 'ai';
            elseif any(strcmpi('Setpoint', MemberOf))
                DeviceType = 'ao';
            else
                DeviceType = 'NA';
            end
            
            if any(strcmpi(DeviceType, DeviceTypesToPrint))
                %fprintf('   %s.%s\n', ao.(FamilyNames{i}).FamilyName, SubFieldNameCell{ii});
                if iscell(Names)
                    for nn = 1:length(Names)
                        if ~isempty(Names{nn})
                            fprintf('%s\n', deblank(Names{nn}));
                            %fprintf('%s %s\n', deblank(Names{nn}), DeviceType);
                        end
                    end
                else
                    for nn = 1:size(Names,1)
                        if ~isempty(deblank(Names(nn,:)))
                            fprintf('%s %s\n', deblank(Names(nn,:)), DeviceType);
                        end
                    end
                end
            end
        end
    end
end


