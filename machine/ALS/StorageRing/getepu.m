function [Offset, OffsetA, OffsetB, Velocity, RunFlag, UserGap] = getepu(Sector, ChanType)
% [Offset, OffsetA, OffsetB, Velocity, RunFlag, UserGap] = getepu(Sector {4}, ChanType)
%   Offset  = hoizontal offset between upper and lower magnets [mm]
%   OffsetA = hoizontal offset A from "zero" [mm]
%   OffsetB = hoizontal offset B from "zero" [mm]
%   Velocity = Insertion device velocity [mm/sec]
%   RunFlag  = Run count number -> .5 if running
%                               -> negative if error occurred
%   UserGap  = Insertion device user requested offset [mm]  
%   Sector   = Sector Number
%               can either be vector or devicelist (to address
%               upstream/downstream EPUs)
%   ChanType = 0 -> monitor  for position and velocity {default}
%                -> setpoint for position and velocity

% 2005-02-18 T.Scarvie, added Device to handle 2 EPUs per sector
% 2005-02-23, C. Steier, modified to allow Sector to be devicelist


% if nargin < 1
%    DeviceList = [];
% end
% if isempty(DeviceList)
%    DeviceList = family2dev('EPU');
% end
% if size(DeviceList,2) == 1
%     %DeviceList = elem2dev('EPU', DeviceList);
%     DeviceList = [DeviceList ones(size(DeviceList))];
% end

if nargin < 1
    Dev = getlist('EPU');
	Sector = Dev(:,1);
    Device = Dev(:,2);
else 
    if size(Sector,2)==2
        Device = Sector(:,2);
        Sector = Sector(:,1);
    else
        Device = zeros(size(Sector));
        for loop = 1:length(Sector)
            if Sector(loop) == 11
                Device(loop,1) = 2;
            else
                Device(loop,1) = 1;
            end
        end
    end
end

if isempty(Sector)
   Sector = 4;
   Device = 1;
end

if nargin < 2
   ChanType = 0;
end
if isempty(ChanType)
   ChanType= 0;
end

if any(Device<1) || any(Device>2)
   error('  Device must be 1(upstream EPU) or 2(downstream EPU)!');
end

for i = 1:length(Sector)
   if (Sector(i) == 4) || ((Sector(i) == 6) && (Device(i) == 2)) || (Sector(i) == 7) || (Sector(i) == 11)
      if ChanType
         Offset(i,1)   = scaget(sprintf('SR%02dU___ODS%1iPS_AC00', Sector(i), Device(i)));
         OffsetA(i,1)  = scaget(sprintf('SR%02dU___ODA%1iPS_AC02', Sector(i), Device(i)));
         OffsetB(i,1)  = scaget(sprintf('SR%02dU___ODB%1iPS_AC03', Sector(i), Device(i)));
         Velocity(i,1) = scaget(sprintf('SR%02dU___ODS%1iV__AC01', Sector(i), Device(i)));
      else
         Offset(i,1)   = scaget(sprintf('SR%02dU___ODS%1iPS_AM00', Sector(i), Device(i)));
         OffsetA(i,1)  = scaget(sprintf('SR%02dU___ODA%1iPS_AM00', Sector(i), Device(i)));
         OffsetB(i,1)  = scaget(sprintf('SR%02dU___ODB%1iPS_AM01', Sector(i), Device(i)));
         Velocity(i,1) = scaget(sprintf('SR%02dU___ODS%1iV__AM01', Sector(i), Device(i)));
      end
      
      RunFlag(i,1) = scaget(sprintf('SR%02dU___ODS%1iE__AM02', Sector(i), Device(i)));
      
      UserGap(i,1) = NaN; %scaget(sprintf('cmm:ID%d_opr_grant', Sector(i)));
      
      if (RunFlag(i) < 0)
         if (Sector(i) == 4) || (Sector(i) == 6) || (Sector(i) == 11)
            switch RunFlag(i,1)
            case -1
               disp('WARNING: EPU timeout error.');
            case -2    
               disp('WARNING: EPU PMAC software error.');
            case -3    
               disp('WARNING: EPU PMAC program stopped.');
            case -4    
               disp('WARNING: EPU PMAC not initiallized.');
            case -5    
               disp('WARNING: EPU Amp disabled.');
            case -6
               disp('WARNING: EPU PMAC status bad.');
            otherwise
               disp('WARNING: Insertion device error.');
            end
         end
      end
   else
      Offset(i,1)   = 0;
      OffsetA(i,1)  = 0;
      OffsetB(i,1)  = 0;
      Velocity(i,1) = 0;
      RunFlag(i,1)  = 0;
      UserGap(i,1)  = NaN;
   end
end
