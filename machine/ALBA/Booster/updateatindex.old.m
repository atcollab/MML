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

MachineName = getfamilydata('Machine');

switch MachineName
    case 'ALBA'
        
        try
            AO.BPMx.AT.ATType = 'X';
            AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
            AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

            AO.BPMy.AT.ATType = 'Y';
            AO.BPMy.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
            AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';
        catch
            fprintf('   BPM family not found in the model.\n');
        end

        try
            % Horizontal correctors
            AO.HCM.AT.ATType = 'HCM';
            AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.COR);
            AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex)';

            % Vertical correctors
            AO.VCM.AT.ATType = 'VCM';
            AO.VCM.AT.ATIndex = AO.HCM.AT.ATIndex;
            AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex)';
        catch
            fprintf('   COR family not found in the model.\n');
        end


        try
            AO.QF1.AT.ATType = 'QUAD';
            ATIndex = [Indices.QF1(:)];
            AO.QF1.AT.ATIndex  = sort(ATIndex);
            %AO.QF1.AT.ATIndex = buildatindex(AO.QF1.FamilyName, Indices.QF1);
            AO.QF1.Position = findspos(THERING, AO.QF1.AT.ATIndex)';
        catch
            fprintf('   QF1 family not found in the model.\n');
        end
        try
            AO.QF2.AT.ATType = 'QUAD';
            ATIndex = [Indices.QF2(:)];
            AO.QF2.AT.ATIndex  = sort(ATIndex);
            %AO.QF2.AT.ATIndex = buildatindex(AO.QF2.FamilyName, Indices.QF2);
            AO.QF2.Position = findspos(THERING, AO.QF2.AT.ATIndex)';
        catch
            fprintf('   QF2 family not found in the model.\n');
        end
        try
            AO.QF3.AT.ATType = 'QUAD';
            ATIndex = [Indices.QF3(:)];
            AO.QF3.AT.ATIndex  = sort(ATIndex);
            %AO.QF3.AT.ATIndex = buildatindex(AO.QF3.FamilyName, Indices.QF3);
            AO.QF3.Position = findspos(THERING, AO.QF3.AT.ATIndex)';
        catch
            fprintf('   QF3 family not found in the model.\n');
        end
        try
            AO.QF4.AT.ATType = 'QUAD';
            ATIndex = [Indices.QF4(:)];
            AO.QF4.AT.ATIndex  = sort(ATIndex);
            %AO.QF4.AT.ATIndex = buildatindex(AO.QF4.FamilyName, Indices.QF4);
            AO.QF4.Position = findspos(THERING, AO.QF4.AT.ATIndex)';
        catch
            fprintf('   QF4 family not found in the model.\n');
        end
        try
            AO.QF5.AT.ATType = 'QUAD';
            ATIndex = [Indices.QF5(:)];
            AO.QF5.AT.ATIndex  = sort(ATIndex);
            %AO.QF5.AT.ATIndex = buildatindex(AO.QF5.FamilyName, Indices.QF5);
            AO.QF5.Position = findspos(THERING, AO.QF5.AT.ATIndex)';
        catch
            fprintf('   QF5 family not found in the model.\n');
        end
        try
            AO.QF6.AT.ATType = 'QUAD';
            ATIndex = [Indices.QF6(:)];
            AO.QF6.AT.ATIndex  = sort(ATIndex);
            %AO.QF6.AT.ATIndex = buildatindex(AO.QF6.FamilyName, Indices.QF6);
            AO.QF6.Position = findspos(THERING, AO.QF6.AT.ATIndex)';
        catch
            fprintf('   QF6 family not found in the model.\n');
        end
        try
            AO.QF7.AT.ATType = 'QUAD';
            ATIndex = [Indices.QF7(:)];
            AO.QF7.AT.ATIndex  = sort(ATIndex);
            %AO.QF7.AT.ATIndex = buildatindex(AO.QF7.FamilyName, Indices.QF7);
            AO.QF7.Position = findspos(THERING, AO.QF7.AT.ATIndex)';
        catch
            fprintf('   QF7 family not found in the model.\n');
        end
        try
            AO.QF8.AT.ATType = 'QUAD';
            ATIndex = [Indices.QF8(:)];
            AO.QF8.AT.ATIndex  = sort(ATIndex);
            %AO.QF8.AT.ATIndex = buildatindex(AO.QF8.FamilyName, Indices.QF8);
            AO.QF8.Position = findspos(THERING, AO.QF8.AT.ATIndex)';
        catch
            fprintf('   QF8 family not found in the model.\n');
        end


        try
            AO.QD1.AT.ATType = 'QUAD';
            ATIndex = [Indices.QD1(:)];
            AO.QD1.AT.ATIndex  = sort(ATIndex);
            %AO.QD1.AT.ATIndex = buildatindex(AO.QD1.FamilyName, Indices.QD1);
            AO.QD1.Position = findspos(THERING, AO.QD1.AT.ATIndex)';
        catch
            fprintf('   QD1 family not found in the model.\n');
        end
        try
            AO.QD2.AT.ATType = 'QUAD';
            ATIndex = [Indices.QD2(:)];
            AO.QD2.AT.ATIndex  = sort(ATIndex);
            %AO.QD2.AT.ATIndex = buildatindex(AO.QD2.FamilyName, Indices.QD2);
            AO.QD2.Position = findspos(THERING, AO.QD2.AT.ATIndex)';
        catch
            fprintf('   QD2 family not found in the model.\n');
        end
        try
            AO.QD3.AT.ATType = 'QUAD';
            ATIndex = [Indices.QD3(:)];
            AO.QD3.AT.ATIndex  = sort(ATIndex);
            %AO.QD3.AT.ATIndex = buildatindex(AO.QD3.FamilyName, Indices.QD3);
            AO.QD3.Position = findspos(THERING, AO.QD3.AT.ATIndex)';
        catch
            fprintf('   QD3 family not found in the model.\n');
        end


        try
            AO.SF1.AT.ATType = 'SEXT';
            AO.SF1.AT.ATIndex = buildatindex(AO.SF1.FamilyName, Indices.SF1);
            AO.SF1.Position = findspos(THERING, AO.SF1.AT.ATIndex)';
        catch
            fprintf('   SF1 family not found in the model.\n');
        end
        try
            AO.SF2.AT.ATType = 'SEXT';
            AO.SF2.AT.ATIndex = buildatindex(AO.SF2.FamilyName, Indices.SF2);
            AO.SF2.Position = findspos(THERING, AO.SF2.AT.ATIndex)';
        catch
            fprintf('   SF2 family not found in the model.\n');
        end
        try
            AO.SF3.AT.ATType = 'SEXT';
            AO.SF3.AT.ATIndex = buildatindex(AO.SF3.FamilyName, Indices.SF3);
            AO.SF3.Position = findspos(THERING, AO.SF3.AT.ATIndex)';
        catch
            fprintf('   SF3 family not found in the model.\n');
        end
        try
            AO.SF4.AT.ATType = 'SEXT';
            AO.SF4.AT.ATIndex = buildatindex(AO.SF4.FamilyName, Indices.SF4);
            AO.SF4.Position = findspos(THERING, AO.SF4.AT.ATIndex)';
        catch
            fprintf('   SF4 family not found in the model.\n');
        end


        try
            AO.SD1.AT.ATType = 'SEXT';
            AO.SD1.AT.ATIndex = buildatindex(AO.SD1.FamilyName, Indices.SD1);
            AO.SD1.Position = findspos(THERING, AO.SD1.AT.ATIndex)';
        catch
            fprintf('   SD1 family not found in the model.\n');
        end
        try
            AO.SD2.AT.ATType = 'SEXT';
            AO.SD2.AT.ATIndex = buildatindex(AO.SD2.FamilyName, Indices.SD2);
            AO.SD2.Position = findspos(THERING, AO.SD2.AT.ATIndex)';
        catch
            fprintf('   SD2 family not found in the model.\n');
        end
        try
            AO.SD3.AT.ATType = 'SEXT';
            AO.SD3.AT.ATIndex = buildatindex(AO.SD3.FamilyName, Indices.SD3);
            AO.SD3.Position = findspos(THERING, AO.SD3.AT.ATIndex)';
        catch
            fprintf('   SD3 family not found in the model.\n');
        end
        try
            AO.SD4.AT.ATType = 'SEXT';
            AO.SD4.AT.ATIndex = buildatindex(AO.SD4.FamilyName, Indices.SD4);
            AO.SD4.Position = findspos(THERING, AO.SD4.AT.ATIndex)';
        catch
            fprintf('   SD4 family not found in the model.\n');
        end
        try
            AO.SD5.AT.ATType = 'SEXT';
            AO.SD5.AT.ATIndex = buildatindex(AO.SD5.FamilyName, Indices.SD5);
            AO.SD5.Position = findspos(THERING, AO.SD5.AT.ATIndex)';
        catch
            fprintf('   SD5 family not found in the model.\n');
        end


        try
            AO.BEND.AT.ATType = 'BEND';
            AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BEND);
            AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex)';
        catch
            fprintf('   BEND family not found in the model.\n');
        end

        try
            %RF Cavity
            AO.RF.AT.ATType = 'RF Cavity';
            AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
            AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex)';
        catch
            fprintf('   RF cavity not found in the model.\n');
        end
        try
            AO.QS.AT.ATType='SkewQuad';
            ATIndex = [Indices.QS(:)];
            AO.QS.AT.ATIndex  = sort(ATIndex);
            %AO.QD2.AT.ATIndex = buildatindex(AO.QD2.FamilyName, Indices.QD2);
            AO.QS.Position = findspos(THERING, AO.QS.AT.ATIndex)';
        catch
            fprintf('   QS family not found in the model.\n');
        end
        try
            AO.IK.AT.ATType='Kicker';
            ATIndex = [Indices.IK(:)];
            AO.IK.AT.ATIndex  = sort(ATIndex);
            %AO.QD2.AT.ATIndex = buildatindex(AO.QD2.FamilyName, Indices.QD2);
            AO.IK.Position = findspos(THERING, AO.IK.AT.ATIndex)';
        catch
            fprintf('   IK family not found in the model.\n');
        end

   case 'BOOSTER'

        try
            AO.BPMx.AT.ATType = 'X';
            AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
            AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

            AO.BPMy.AT.ATType = 'Y';
            AO.BPMy.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
            AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';
        catch
            fprintf('   BPM family not found in the model.\n');
        end

        try
            % Horizontal correctors
            AO.HCM.AT.ATType  = 'HCM';
            AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.HCM);
            
%            AO.HCM.AT.ATIndex = Indices.HCM(:);
            AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex)';


%             % Vertical correctors
%             AO.VCM.AT.ATType = 'VCM';
%             AO.VCM.AT.ATIndex = AO.HCM.AT.ATIndex;
%             AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex)';
        catch
            fprintf('   HCOR family not found in the model.\n');
        end

        try
            % Vertical correctors
            AO.VCM.AT.ATType = 'VCM';
            AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.VCM);
            AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex)';
        catch
            fprintf('   VCOR family not found in the model.\n');
        end

        try
            AO.QF1.AT.ATType = 'QUAD';
            ATIndex = [Indices.QF1(:)];
            AO.QF1.AT.ATIndex  = sort(ATIndex);
            %AO.QF1.AT.ATIndex = buildatindex(AO.QF1.FamilyName, Indices.QF1);
            AO.QF1.Position = findspos(THERING, AO.QF1.AT.ATIndex)';
        catch
            fprintf('   QF1 family not found in the model.\n');
        end
        try
            AO.QF4.AT.ATType = 'QUAD';
            ATIndex = [Indices.QF4(:)];
            AO.QF4.AT.ATIndex  = sort(ATIndex);
            %AO.QF4.AT.ATIndex = buildatindex(AO.QF4.FamilyName, Indices.QF4);
            AO.QF4.Position = findspos(THERING, AO.QF4.AT.ATIndex)';
        catch
            fprintf('   QF4 family not found in the model.\n');
        end
        try
            AO.QD2.AT.ATType = 'QUAD';
            ATIndex = [Indices.QD2(:)];
            AO.QD2.AT.ATIndex  = sort(ATIndex);
            %AO.QD2.AT.ATIndex = buildatindex(AO.QD2.FamilyName, Indices.QD2);
            AO.QD2.Position = findspos(THERING, AO.QD2.AT.ATIndex)';
        catch
            fprintf('   QD2 family not found in the model.\n');
        end
        try
            AO.QD3.AT.ATType = 'QUAD';
            ATIndex = [Indices.QD3(:)];
            AO.QD3.AT.ATIndex  = sort(ATIndex);
            %AO.QD3.AT.ATIndex = buildatindex(AO.QD3.FamilyName, Indices.QD3);
            AO.QD3.Position = findspos(THERING, AO.QD3.AT.ATIndex)';
        catch
            fprintf('   QD3 family not found in the model.\n');
        end

        try
            AO.SF2.AT.ATType = 'SEXT';
            AO.SF2.AT.ATIndex = buildatindex(AO.SF2.FamilyName, Indices.SF2);
            AO.SF2.Position = findspos(THERING, AO.SF2.AT.ATIndex)';
        catch
            fprintf('   SF2 family not found in the model.\n');
        end
        try
            AO.SD1.AT.ATType = 'SEXT';
            AO.SD1.AT.ATIndex = buildatindex(AO.SD1.FamilyName, Indices.SD1);
            AO.SD1.Position = findspos(THERING, AO.SD1.AT.ATIndex)';
        catch
            fprintf('   SD1 family not found in the model.\n');
        end

        try
            AO.BEND.AT.ATType = 'BEND';
            AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BEND);
            AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex)';
        catch
            fprintf('   BENDS family not found in the model.\n');
        end
%         try
%             AO.BENDL.AT.ATType = 'BEND';
%             AO.BENDL.AT.ATIndex = buildatindex(AO.BENDL.FamilyName, Indices.BENDL);
%             AO.BENDL.Position = findspos(THERING, AO.BENDL.AT.ATIndex)';
%         catch
%             fprintf('   BENDL family not found in the model.\n');
%         end

        try
            %RF Cavity
            AO.RF.AT.ATType = 'RF Cavity';
            AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
            AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex)';
        catch
            fprintf('   RF cavity not found in the model.\n');
        end

end

setao(AO);
