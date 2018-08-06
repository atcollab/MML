function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)
%
% Eugene Tan 2006-08-16: Added option of LTB and BTS for the booster.

global THERING

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

% Sort by family first (findcells is linear and slow)
booster_indices = atindex(THERING);

AO = getao;

AOelements = fieldnames(AO);

for aoElement = AOelements'
    aoElement = aoElement{1};
    switch aoElement          
        case 'BPMx'
            ATType  = 'X';
            ATIndex = booster_indices.BPM(:);
        case 'BPMy'
            ATType  = 'Y';
            ATIndex = booster_indices.BPM(:);
        case 'HCM'
            ATType  = 'HCM';
            ATIndex = booster_indices.HCM(:);
        case 'VCM'
            ATType  = 'VCM';
            ATIndex = booster_indices.VCM(:);
        case 'QF'
            ATType  = 'QUAD';
            ATIndex = booster_indices.(aoElement)(:);
        case 'QD'
            ATType  = 'QUAD';
            ATIndex = booster_indices.(aoElement)(:);
        case 'SF'
            ATType  = 'SEXT';
            ATIndex = booster_indices.(aoElement)(:);
        case 'SD'
            ATType  = 'SEXT';
            ATIndex = booster_indices.(aoElement)(:);
        case 'RF'
            ATType  = 'RF';
            ATIndex = booster_indices.(aoElement)(:);
        case 'BEND'
            ATType  = 'BEND';
            ATIndex = [booster_indices.BF(:); booster_indices.BD([1:3 20:32])'; booster_indices.BD([4:19])'];
        otherwise
            ATType = '';
    end
    
    if ~isempty(ATType)
        AO.(aoElement).AT.ATType  = ATType;
        AO.(aoElement).AT.ATIndex = buildatindex(AO.(aoElement).FamilyName, ATIndex);
    end
end

AO
% SEPTUM
% AO.Septum.AT.ATType  = 'Septum';
% AO.Septum.AT.ATIndex = booster_indices.SEPTUM(:);
% AO.Septum.Position   = s(AO.Septum.AT.ATIndex);


setao(AO);