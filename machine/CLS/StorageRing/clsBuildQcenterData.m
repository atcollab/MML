function clsBuildQuadCenterData
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsBuildQcenterData.m 1.2 2007/03/02 09:03:03CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%get all of the quadcenter filenames
%this needs to be made more interactive, after I get it working
% ----------------------------------------------------------------------------------------------

cd 'L:\Sandbox\MatlabApplications\acceleratorcontrol\clsdata\User\QMS\2004-08-30';

%get the ao in order to load them directly in from here instead of the
%clsinit file
ao = getao;
%ao.BPMx.DeviceList

%build the quad names
Xindex = 1;
Yindex = 1;
QnamesX = {};
QnamesY = {};
S=[];

for i = 1:12
   QnamesX{Xindex}.qname = sprintf('s%dQFA1h1*.mat', i);Xindex = Xindex + 1;  
   QnamesY{Yindex}.qname = sprintf('s%dQFA1v1*.mat', i);Yindex = Yindex + 1;    
   QnamesX{Xindex}.qname = sprintf('s%dQFC1h1*.mat', i);Xindex = Xindex + 1;    
   QnamesY{Yindex}.qname = sprintf('s%dQFC1v1*.mat', i);Yindex = Yindex + 1;    
           
   QnamesX{Xindex}.qname = sprintf('s%dQFC2h1*.mat', i);Xindex = Xindex + 1;    
   QnamesY{Yindex}.qname = sprintf('s%dQFC2v1*.mat', i);Yindex = Yindex + 1;        
   QnamesX{Xindex}.qname = sprintf('s%dQFA2h1*.mat', i);Xindex = Xindex + 1;        
   QnamesY{Yindex}.qname = sprintf('s%dQFA2v1*.mat', i);Yindex = Yindex + 1;        
end

%horizontal first
for i=1:48
    f=dir(QnamesX{i}.qname);
    S=load(f.name);
    ao.BPMx.Offset(i) = S.QMS.Center;
end

%horizontal first
for i=1:48
    f=dir(QnamesY{i}.qname);
    S=load(f.name);
    ao.BPMy.Offset(i) = S.QMS.Center;
end

fprintf('Quad centers loaded into the AO (Accelerator Object)\n');
fprintf('Quad data taken from files in %s \n',curdir);

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsBuildQcenterData.m  $
% Revision 1.2 2007/03/02 09:03:03CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
