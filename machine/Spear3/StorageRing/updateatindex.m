function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Since changing the model (above) could change the AT indexes, etc,
% It's best to regenerate all the model parameters 
disp('   Initializing Accelerator Toolbox information');


AO = getao;    

global THERING
ATindx = atindex(THERING);     %structure with fields containing indices
s = findspos(THERING,1:length(THERING)+1)';


%BPMS
AO.BPMx.AT.ATType  = 'BPMx';
AO.BPMx.AT.ATIndex = ATindx.BPM(:);
AO.BPMx.Position   = s(AO.BPMx.AT.ATIndex(:,1));

AO.BPMy.AT.ATType  = 'BPMy';
AO.BPMy.AT.ATIndex = ATindx.BPM(:);
AO.BPMy.Position   = s(AO.BPMy.AT.ATIndex(:,1));  %for SPEAR 3 horizontal and vertical bpms at same s-position


%CORRECTORS
AO.HCM.AT.ATType  = 'HCM';
AO.HCM.AT.ATIndex = ATindx.COR(:);                % I'm assuming that correctors are never split
AO.HCM.Position = s(AO.HCM.AT.ATIndex(:,1));

AO.VCM.AT.ATType  = 'VCM';
AO.VCM.AT.ATIndex = ATindx.COR(:);                % I'm assuming that correctors are never split
AO.VCM.Position   = s(AO.VCM.AT.ATIndex(:,1));


%SKEW QUADS
AO.SkewQuad.AT.ATType  = 'SkewQuad';
%AO.SkewQuad.AT.ATIndex = sort([ATindx.SF(:); ATindx.SD(:); ATindx.SFM(:); ATindx.SDM(:);]);
AO.SkewQuad.AT.ATIndex = buildatindex('SkewQuad', sort([ATindx.SF(:); ATindx.SD(:); ATindx.SFM(:); ATindx.SDM(:);]));   % Deals with split magnets (GP)
AO.SkewQuad.Position=s(AO.SkewQuad.AT.ATIndex(:,1));


%FULL BENDS
AO.BEND.AT.ATType  = 'BEND';
%AO.BEND.AT.ATIndex = sort([ATindx.BEND(:); ATindx.BDM(:)]);   %both 145D and 109D dipoles on main string
AO.BEND.AT.ATIndex = buildatindex('BEND', sort([ATindx.BEND(:); ATindx.BDM(:)]));   % Deals with split magnets (GP)
AO.BEND.Position=s(AO.BEND.AT.ATIndex);
%AO.BEND.Position = (s(AO.BEND.AT.ATIndex)+s(AO.BEND.AT.ATIndex+1))/2;
% for i = 1:length(AO.BEND.AT.ATIndex);
% ParameterGroupCell{i} = mkparamgroup(THERING,AO.BEND.AT.ATIndex(i),'K');
% end
% AO.BEND.AT.ATParameterGroup = ParameterGroupCell;

%3/4 BENDS
AO.BDM.AT.ATType  = 'BEND';
%AO.BDM.AT.ATIndex = ATindx.BDM(:);
AO.BDM.AT.ATIndex = buildatindex('BDM', ATindx.BDM(:));   % Deals with split magnets (GP)
AO.BDM.Position=s(AO.BDM.AT.ATIndex);


%CD Chicane BENDS  (split magnets)
try
AO.CD.AT.ATType  = 'BEND';
%AO.CD.AT.ATIndex = ATindx.CD(:);
AO.CD.AT.ATIndex = buildatindex('CD', ATindx.CD(:));   % Deals with split magnets (GP)
AO.CD.Position = s(AO.CD.AT.ATIndex(:,1));
catch
end

%Quad
quadnames={'QF' 'QD' 'QFC' 'QDX' 'QFX' 'QDY' 'QFY' 'QDZ' 'QFZ'};
for ii=1:length(quadnames)
    if isfield(AO,quadnames{ii})
        AO.(quadnames{ii}).AT.ATType  = 'QUAD';
        %AO.(quadnames{ii}).AT.ATIndex = ATindx.(quadnames{ii})(:);
        AO.(quadnames{ii}).AT.ATIndex = buildatindex(quadnames{ii}, ATindx.(quadnames{ii})(:));   % Deals with split magnets (GP)
        AO.(quadnames{ii}).Position=s(AO.(quadnames{ii}).AT.ATIndex(:,1));
    end
end

try
AO.Q9S.AT.ATType  = 'QUAD';
%AO.Q9S.AT.ATIndex = ATindx.Q9S(:);
AO.Q9S.AT.ATIndex = buildatindex('Q9S', ATindx.Q9S(:));   % Deals with split magnets (GP)
AO.Q9S.Position = s(AO.Q9S.AT.ATIndex(:,1));
catch
end

%SEXTUPOLES
AO.SF.AT.ATType  = 'SEXT';
%AO.SF.AT.ATIndex = ATindx.SF(:);
AO.SF.AT.ATIndex = buildatindex('SF', ATindx.SF(:));   % Deals with split magnets (GP)
AO.SF.Position   =s(AO.SF.AT.ATIndex(:,1));

AO.SD.AT.ATType  = 'SEXT';
%AO.SD.AT.ATIndex = ATindx.SD(:);
AO.SD.AT.ATIndex = buildatindex('SD', ATindx.SD(:));   % Deals with split magnets (GP)
AO.SD.Position = s(AO.SD.AT.ATIndex(:,1));

AO.SFM.AT.ATType  = 'SEXT';
%AO.SFM.AT.ATIndex = ATindx.SFM(:);
AO.SFM.AT.ATIndex = buildatindex('SFM', ATindx.SFM(:));   % Deals with split magnets (GP)
AO.SFM.Position   =s(AO.SFM.AT.ATIndex(:,1));

AO.SDM.AT.ATType  = 'SEXT';
%AO.SDM.AT.ATIndex = ATindx.SDM(:);
AO.SDM.AT.ATIndex = buildatindex('SDM', ATindx.SDM(:));   % Deals with split magnets (GP)
AO.SDM.Position   =s(AO.SDM.AT.ATIndex(:,1));


%kickeramps
AO.KickerAmp.AT.ATType  = 'KickerAmp';
AO.KickerAmp.AT.ATIndex = ATindx.KICKER(:);
AO.KickerAmp.Position   = s(AO.KickerAmp.AT.ATIndex);

%kickerdelay
AO.KickerDelay.AT.ATType  = 'Kicker';
AO.KickerDelay.AT.ATIndex = ATindx.KICKER(:);
AO.KickerDelay.Position= s(AO.KickerDelay.AT.ATIndex);


%septum
AO.Septum.AT.ATType  = 'Septum';
AO.Septum.AT.ATIndex = ATindx.SEPTUM(:);
AO.Septum.Position   = s(AO.Septum.AT.ATIndex);


%RF Cavity
AO.RF.AT.ATType  = 'RF Cavity';
AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
AO.RF.Position   = s(AO.RF.AT.ATIndex);

%AO.HCMCurrReference
AO.HCMCurrReference.AT.ATType  = 'HCMCurrReference';
AO.HCMCurrReference.AT.ATIndex =ATindx.COR([53 54 55 57]);
AO.HCMCurrReference.Position   = s(AO.HCMCurrReference.AT.ATIndex);

%AO.VCMCurrReference
AO.VCMCurrReference.AT.ATType  = 'VCMCurrReference';
AO.VCMCurrReference.AT.ATIndex =ATindx.COR([52 54 55 56]);
AO.VCMCurrReference.Position   = s(AO.VCMCurrReference.AT.ATIndex);

setao(AO); 




% Set TwissData at the start of the storage ring
try   
    % BTS twiss parameters at the input 
    TwissData.alpha = [0 0]';
    TwissData.beta  = [5.2013 9.0985]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0.0202 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end
