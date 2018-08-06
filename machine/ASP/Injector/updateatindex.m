function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)
%
% Eugene Tan 2006-08-16: Added option of LTB and BTS for the booster.

global THERING THERINGCELL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

% Sort by family first (findcells is linear and slow)
ltb_indices     = atindex(THERINGCELL{1});
booster_indices = atindex(THERINGCELL{2});
bts_indices     = atindex(THERINGCELL{3});

AO = getao;

AOelements = fieldnames(AO);

for aoElement = AOelements'
    aoElement = aoElement{1};
    switch aoElement
        case 'LTB_BEND'
            ATType  = 'BEND';
            ATIndex = [ltb_indices.b1(:); ltb_indices.b3(:)];
            ATModel = 1;
        case 'LTB_Q'
            ATType = 'QUAD';
            ATIndex = [ltb_indices.q11; ltb_indices.q12; ltb_indices.q13;...
                       ltb_indices.q2;...
                       ltb_indices.q31; ltb_indices.q32; ltb_indices.q33; ltb_indices.q34;...
                       ltb_indices.q41; ltb_indices.q42; ltb_indices.q43];
            ATModel = 1;
        case 'LTB_HCOR'
            ATType  = 'HCM';
            ATIndex = ltb_indices.hcor(:);
            ATModel = 1;
        case 'LTB_VCOR'
            ATType  = 'VCM';
            ATIndex = ltb_indices.vcor(:);
            ATModel = 1;
        case 'LTB_SEPI'
            ATType  = 'BEND';
            ATIndex = ltb_indices.bsep(:);
            ATModel = 1;
        case 'LTB_KI'
            ATType  = 'BEND';
            ATIndex = ltb_indices.bkick(:);
            ATModel = 1;
% ===========================================            
        case 'BPMx'
            ATType  = 'X';
            ATIndex = booster_indices.BPM(:);
            ATModel = 2;
        case 'BPMy'
            ATType  = 'Y';
            ATIndex = booster_indices.BPM(:);
            ATModel = 2;
        case 'HCM'
            ATType  = 'HCM';
            ATIndex = booster_indices.HCM(:);
            ATModel = 2;
        case 'VCM'
            ATType  = 'VCM';
            ATIndex = booster_indices.VCM(:);
            ATModel = 2;
        case 'QF'
            ATType  = 'QUAD';
            ATIndex = booster_indices.(aoElement)(:);
            ATModel = 2;
        case 'QD'
            ATType  = 'QUAD';
            ATIndex = booster_indices.(aoElement)(:);
            ATModel = 2;
        case 'SF'
            ATType  = 'SEXT';
            ATIndex = booster_indices.(aoElement)(:);
            ATModel = 2;
        case 'SD'
            ATType  = 'SEXT';
            ATIndex = booster_indices.(aoElement)(:);
            ATModel = 2;
        case 'RF'
            ATType  = 'RF';
            ATIndex = booster_indices.(aoElement)(:);
            ATModel = 2;
        case 'BEND'
            ATType  = 'BEND';
            ATIndex = [booster_indices.BF(:); booster_indices.BD([1:3 20:32])'; booster_indices.BD([4:19])'];
            ATModel = 2;
% ===========================================
        case 'BTS_SEE'
            ATType  = 'BEND';
            ATIndex = [bts_indices.extrseptum(:)];
            ATModel = 3;
        case 'BTS_BEND'
            ATType  = 'BEND';
            ATIndex = [ bts_indices.extrmagnet(:); bts_indices.b1(:); bts_indices.injmagnet(:)];
            ATModel = 3;
        case 'BTS_Q'
            ATType  = 'QUAD';
            % In the model there may be Q11 and Q12 but they should be zero
            % or are set as drifts. In original design but taken out.
            ATIndex = [bts_indices.q21; bts_indices.q22;...
                       bts_indices.q31; bts_indices.q32; bts_indices.q33;...
                       bts_indices.q41; bts_indices.q42; bts_indices.q43; bts_indices.q44;...
                       bts_indices.q51; bts_indices.q52; bts_indices.q53];
            ATModel = 3;
        case 'BTS_VCOR'
            % Currently not in model
            ATType  = '';
            ATIndex = [];
            ATModel = 3;
        case 'BTS_SEI'
            ATType  = 'BEND';
            ATIndex = [bts_indices.pre_septum(:); bts_indices.injseptum(:)];
            ATModel = 3;
        otherwise
            ATType = '';
    end
    
    if ~isempty(ATType)
        AO.(aoElement).AT.ATType  = ATType;
        AO.(aoElement).AT.ATIndex = buildatindex(AO.(aoElement).FamilyName, ATIndex);
        AO.(aoElement).AT.ATModel = ATModel;
    end
end


% SEPTUM
% AO.Septum.AT.ATType  = 'Septum';
% AO.Septum.AT.ATIndex = booster_indices.SEPTUM(:);
% AO.Septum.Position   = s(AO.Septum.AT.ATIndex);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get S-positions [meters] %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using ...ATIndex(:,1) will accomodata for split elements where the first
% of a group of elements is put in the first column ie, if SF is split in
% two then ATIndex will look like [2 3; 11 12; ...] where each row is a
% magnet and column represents each split.
global THERINGCELL
AO.LTB_BEND.Position = findspos(THERINGCELL{1}, AO.LTB_BEND.AT.ATIndex(:,1))';
AO.LTB_Q.Position    = findspos(THERINGCELL{1}, AO.LTB_Q.AT.ATIndex(:,1))';
AO.LTB_HCOR.Position = findspos(THERINGCELL{1}, AO.LTB_HCOR.AT.ATIndex(:,1))';
AO.LTB_VCOR.Position = findspos(THERINGCELL{1}, AO.LTB_VCOR.AT.ATIndex(:,1))';
AO.LTB_SEPI.Position = findspos(THERINGCELL{1}, AO.LTB_SEPI.AT.ATIndex(:,1))';
AO.LTB_KI.Position   = findspos(THERINGCELL{1}, AO.LTB_KI.AT.ATIndex(:,1))';

AO.BPMx.Position = findspos(THERINGCELL{2}, AO.BPMx.AT.ATIndex(:,1))';
AO.BPMy.Position = findspos(THERINGCELL{2}, AO.BPMy.AT.ATIndex(:,1))';
AO.HCM.Position  = findspos(THERINGCELL{2}, AO.HCM.AT.ATIndex(:,1))';
AO.VCM.Position  = findspos(THERINGCELL{2}, AO.VCM.AT.ATIndex(:,1))';
AO.QF.Position   = findspos(THERINGCELL{2}, AO.QF.AT.ATIndex(:,1))';
AO.QD.Position   = findspos(THERINGCELL{2}, AO.QD.AT.ATIndex(:,1))';
AO.SF.Position   = findspos(THERINGCELL{2}, AO.SF.AT.ATIndex(:,1))';
AO.SD.Position   = findspos(THERINGCELL{2}, AO.SD.AT.ATIndex(:,1))';
AO.BEND.Position = findspos(THERINGCELL{2}, AO.BEND.AT.ATIndex(:,1))';
AO.RF.Position   = findspos(THERINGCELL{2}, AO.RF.AT.ATIndex(:,1))';
AO.DCCT.Position = 0;
AO.TUNE.Position = 0;

AO.BTS_SEE.Position  = findspos(THERINGCELL{3}, AO.BTS_SEE.AT.ATIndex(:,1))';
AO.BTS_BEND.Position = findspos(THERINGCELL{3}, AO.BTS_BEND.AT.ATIndex(:,1))';
AO.BTS_Q.Position    = findspos(THERINGCELL{3}, AO.BTS_Q.AT.ATIndex(:,1))';
% Not in model yet
% AO.BTS_VCOR.Position = findspos(THERINGCELL{3}, AO.BTS_VCOR.AT.ATIndex(:,1))';
AO.BTS_SEI.Position  = findspos(THERINGCELL{3}, AO.BTS_SEI.AT.ATIndex(:,1))';



% Leave the booster in THERING
THERING = THERINGCELL{2};



setao(AO);