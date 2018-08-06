function [D] = measdispresp(CMfamily, CMlist);
%  MEASDISPRESP - Measures Amman TERMs in response matrix
%  Dmat = measdispresp(CMfamily, CMlist);
% 
%  INPUTS
%  1. CMfamily - Magnet corrector family
%  2. CMlist - List of magnet corrector
%
%  OUTPUTS
%  1. D Energy part of the bpm response matrix
%
%  Seems to measure Amman TERMs in response matrix

%  Written by Jeff Corbett
%  Modified by Laurent S. Nadolski


% Initialize
MMmax = 6;      % to set corrector strength magnitude
Navg=6;
DeltaMO = 1;
Delay1 = 2;
Delay2 = 2;

if CMfamily == getvcmfamily
    Dim = 2;
elseif CMfamily == gethcmfamily
    Dim = 1;
else
    error('Dim set problem');
end


% Save corrector magnet starting points
CM0 = getsp(CMfamily, CMlist);
MO0 = getmo;
DCCT0 = getdcct;

for i=1:max(size(CMlist,1))
    fprintf('%s Sector %d Magnet #%d\n',CMfamily, CMlist(i,1), CMlist(i,2)); drawnow;
    
    % Get change in amps
    DeltaAmps = mm2amps(CMfamily, MMmax, CMlist(i,:))
        
    % plus CM
    CMam=setsp(CMfamily, CM0(i)+DeltaAmps, CMlist(i,:));
    setmo(MO0+DeltaMO);
    sleep(Delay1);
    BPMp = getbpm(Dim, Navg);
    RFp= getrf;
    
    setmo(MO0-DeltaMO);
    sleep(Delay2);
    BPMm = getbpm(Dim, Navg);
    RFm= getrf;
    
    Dp = (BPMp-BPMm)/(RFp-RFm);
        
    % minus CM
    CMam=setsp(CMfamily, CM0(i)-DeltaAmps, CMlist(i,:));
    setmo(MO0+DeltaMO);
    sleep(Delay1);
    BPMp = getbpm(Dim, Navg);
    RFp= getrf;
    
    setmo(MO0-DeltaMO);
    sleep(Delay2);
    BPMm = getbpm(Dim, Navg);
    RFm= getrf;
    
    Dm = (BPMp-BPMm)/(RFp-RFm);
   
    % Reset corrector magnet and MO
    CMam=setsp(CMfamily, CM0(i), CMlist(i,:));
    setmo(MO0);
     
    D(:,i) = (Dp-Dm)/(2*DeltaAmps);
    
    if (abs(DCCT0-getdcct) > 10)
        disp('Beam current dropped 10 milliamps.');
        disp('Refill then hit return.'); pause;
        DCCT0 = getdcct;
    end;
end
