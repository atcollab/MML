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
ATIndices = atindex(THERING);

AO = getao;

AOelements = fieldnames(AO);

for aoElement = AOelements'
    aoElement = aoElement{1};
    switch aoElement
        case 'BTS_SEE'
            ATType  = 'BEND';
            ATIndex = [ATIndices.extrseptum(:)];
        case 'BTS_BEND'
            ATType  = 'BEND';
            ATIndex = [ ATIndices.extrmagnet(:); ATIndices.b1(:); ATIndices.injmagnet(:)];
        case 'BTS_Q'
            ATType  = 'QUAD';
            % In the model there may be Q11 and Q12 but they should be zero
            % or are set as drifts. In original design but taken out.
            ATIndex = [ATIndices.q21; ATIndices.q22;...
                       ATIndices.q31; ATIndices.q32; ATIndices.q33;...
                       ATIndices.q41; ATIndices.q42; ATIndices.q43; ATIndices.q44;...
                       ATIndices.q51; ATIndices.q52; ATIndices.q53];
        case 'BTS_VCOR'
            % Currently not in model
            ATType  = '';
            ATIndex = [];
        case 'BTS_SEI'
            ATType  = 'BEND';
            ATIndex = [ATIndices.pre_septum(:); ATIndices.injseptum(:)];
        otherwise
            ATType = '';
    end
    
    if ~isempty(ATType)
        AO.(aoElement).AT.ATType  = ATType;
        AO.(aoElement).AT.ATIndex = buildatindex(AO.(aoElement).FamilyName, ATIndex);
    end
end


setao(AO);