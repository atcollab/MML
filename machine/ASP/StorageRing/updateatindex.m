function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)


global THERING


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

% Sort by family first (findcells is linear and slow)
Indices = atindex(THERING);

AO = getao;

AOelements = fieldnames(AO);

for aoElement = AOelements'
    aoElement = aoElement{1};
    switch aoElement
        case {'BPMx' 'FTx' 'FTsum'}
            ATType  = 'X';
            ATIndex = [Indices.BPM(:); 1];
        case {'BPMy' 'FTy'}
            ATType  = 'Y';
            ATIndex = [Indices.BPM(:); 1];
            % test swap of the BPMs to see if its obvious eugene 29/08/2007
%             ttt = ATIndex(4);
%             ATIndex(4) = ATIndex(3);
%             ATIndex(3) = ttt;
        case 'HCM'
            ATType  = 'HCM';
%             ATIndex = Indices.HCM(:);%union(Indices.SFA, Indices.SFB);
            ATIndex = union(Indices.SFA, Indices.SFB);
        case 'VCM'
            ATType  = 'VCM';
%             ATIndex = Indices.VCM(:);%union(Indices.SDA, Indices.SDB);
            ATIndex = union(Indices.SDA, Indices.SDB);
        case 'HFC'
            ATType  = 'HCM';
            ATIndex = union(Indices.SDA, Indices.SDB(1:2:end)); % Only the first SDB is wired in every arc as a HFC
        case 'VFC'
            ATType  = 'VCM';
            ATIndex = union(Indices.SFA, Indices.SFB);
        case 'QFA'
            ATType  = 'QUAD';
            ATIndex = Indices.(aoElement)(:);
        case 'QFB'
            ATType  = 'QUAD';
            ATIndex = Indices.(aoElement)(:);
        case 'QDA'
            ATType  = 'QUAD';
            ATIndex = Indices.(aoElement)(:);
        case 'SFA'
            ATType  = 'SEXT';
            ATIndex = Indices.(aoElement)(:);
        case 'SFB'
            ATType  = 'SEXT';
            ATIndex = Indices.(aoElement)(:);
        case 'SDA'
            ATType  = 'SEXT';
            ATIndex = Indices.(aoElement)(:);
        case 'SDB'
            ATType  = 'SEXT';
            ATIndex = Indices.(aoElement)(:);
        case 'RF'
            ATType  = 'RF';
            if isfield(Indices,'RF')
                ATIndex = Indices.(aoElement)(:);
            else
                ATIndex = [];
            end
        case 'SKQ'
            ATType  = 'SkewQuad';
            ATIndex = Indices.SDA(:);
        case {'KICK' 'Kicker'}
            ATType  = 'Kicker';
            if isfield(Indices,'KICK')
                ATIndex = Indices.(aoElement)([3 4 1 2]);
            elseif isfield(Indices,'KICK1')
                ATIndex = [Indices.KICK1 Indices.KICK2 Indices.KICK3 Indices.KICK4];
            else
                ATIndex = [];
            end
        case 'BEND'
            if isfield(Indices,'BEND')
                ATType  = 'BEND';
                ATIndex = Indices.(aoElement)(:);
            elseif isfield(Indices,'b_left01')
                ATType = 'BEND';
                tempmat = [];
                i=1;
                while isfield(Indices,sprintf('b_left%02d',i))
                    tempmat = [tempmat Indices.(sprintf('b_left%02d',i))(:)];
                    i = i + 1;
                end
                i=1;
                while isfield(Indices,sprintf('b_centre%02d',i))
                    tempmat = [tempmat Indices.(sprintf('b_centre%02d',i))(:)];
                    i = i + 1;
                end
                i=1;
                while isfield(Indices,sprintf('b_right%02d',i))
                    tempmat = [tempmat Indices.(sprintf('b_right%02d',i))(:)];
                    i = i + 1;
                end
                ATIndex = tempmat';
            end
        otherwise
            ATType = '';
    end
    
    if ~isempty(ATType) && ~isempty(ATIndex)
        AO.(aoElement).AT.ATType  = ATType;
        AO.(aoElement).AT.ATIndex = buildatindex(AO.(aoElement).FamilyName, ATIndex);
    end
end


% SEPTUM
% AO.Septum.AT.ATType  = 'Septum';
% AO.Septum.AT.ATIndex = Indices.SEPTUM(:);
% AO.Septum.Position   = s(AO.Septum.AT.ATIndex);


setao(AO);
