function  NEWAO = aokeep(KEEPLIST,varargin)
%AOKEEP - Removes families from the Accelerator Families except those included in KEEPLIST
%  AOKEEP(KEEPLIST)
%  KEEPLIST is a cell array of strings of family names to keep.
%  The families are reordered according to their position in KEEPLIST
%  AOKEEP({'FAM1','FAM2',...})

%  Written by Jeff Corbett

ACCELERATOR_FAMILIES = getao;

if isempty(ACCELERATOR_FAMILIES)
    error('ACCELERATOR_FAMILIES does not exist.  Initialization is needed.');
end

if ischar(KEEPLIST)
    KEEPLIST = cellstr(KEEPLIST);
elseif ~iscellstr(KEEPLIST)
    error('KEEFAMILIES must be a char array or a cell array of strings');
end

% Remove multiple ocurrances but keep the order
[TEMP,INDEX] = unique(KEEPLIST);
KEEPLIST = KEEPLIST(sort(INDEX));


AO1 = cell(size(KEEPLIST));

AOLIST = getfamilylist;
if ischar(AOLIST)
    AOLIST = cellstr(AOLIST);
end

for k = 1:length(KEEPLIST)
    
    MATCH = find(strcmp(AOLIST,KEEPLIST{k}));
    if length(MATCH)>1
     warning(['Duplicate family name found in ACCELERATOR FAMILIES:', ACCELERATOR_FAMILIES.(KEEPLIST{k}).FamilyName]);
    end
    
    if length(MATCH)>=1
        AO1{k}=ACCELERATOR_FAMILIES.(KEEPLIST{k});
    else
        warning(['Family ', KEEPLIST{k}, ' not found in ACCELERATOR FAMILIES']);
    end
    
end


NEWAO={};
for k = 1:length(AO1)
    if ~isempty(AO1{k})
        NEWAO{end+1}=AO1{k};
    end
end

setao(NEWAO);
