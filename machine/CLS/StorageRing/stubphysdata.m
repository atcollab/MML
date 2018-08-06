% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/stubphysdata.m 1.2 2007/03/02 09:17:50CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
  load('clsphysdata');
  PhysData.BPMx.Gain=getam('BPMx','struct');
  PhysData.BPMx.Gain.Data=ones(48,1);

  PhysData.BPMy.Gain=getam('BPMy','struct');
  PhysData.BPMy.Gain.Data=ones(48,1);

  PhysData.BPMx.Offset=getam('BPMx','struct');
  PhysData.BPMx.Offset.Data=zeros(48,1);

  PhysData.BPMy.Offset=getam('BPMy','struct');
  PhysData.BPMy.Offset.Data=zeros(48,1);
 
  PhysData.BPMx.Golden=getam('BPMx','struct');
  PhysData.BPMx.Golden.Data=zeros(48,1);

  PhysData.BPMy.Golden=getam('BPMy','struct');
  PhysData.BPMy.Golden.Data=zeros(48,1);
 
 
 save 'clsphysdata' PhysData

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/stubphysdata.m  $
% Revision 1.2 2007/03/02 09:17:50CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
