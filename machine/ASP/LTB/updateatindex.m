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
ltb_indices = atindex(THERING);

AO = getao;

AOelements = fieldnames(AO);

for aoElement = AOelements'
    aoElement = aoElement{1};
    switch aoElement
        case 'LTB_BEND'
            ATType  = 'BEND';
            ATIndex = [ltb_indices.b1(:); ltb_indices.b3(:)];
        case 'LTB_Q'
            ATType = 'QUAD';
            ATIndex = [ltb_indices.q11; ltb_indices.q12; ltb_indices.q13;...
                       ltb_indices.q2;...
                       ltb_indices.q31; ltb_indices.q32; ltb_indices.q33; ltb_indices.q34;...
                       ltb_indices.q41; ltb_indices.q42; ltb_indices.q43];
        case 'LTB_HCOR'
            ATType  = 'HCM';
            ATIndex = ltb_indices.hcor(:);
        case 'LTB_VCOR'
            ATType  = 'VCM';
            ATIndex = ltb_indices.vcor(:);
        case 'LTB_SEPI'
            ATType  = 'BEND';
            ATIndex = ltb_indices.bsep(:);
        case 'LTB_KI'
            ATType  = 'BEND';
            ATIndex = ltb_indices.bkick(:);
        otherwise
            ATType = '';
    end
    
    if ~isempty(ATType)
        AO.(aoElement).AT.ATType  = ATType;
        AO.(aoElement).AT.ATIndex = buildatindex(AO.(aoElement).FamilyName, ATIndex);
    end
end


% SEPTUM
% AO.Septum.AT.ATType  = 'Septum';
% AO.Septum.AT.ATIndex = booster_indices.SEPTUM(:);
% AO.Septum.Position   = s(AO.Septum.AT.ATIndex);


setao(AO);