function Err = setepu(DeviceList, Offset, OffsetA, OffsetB, NewVel, WaitFlag, VelocityProfile, InfoFlag);
% Error = setepu(DeviceList, Offset, OffsetA, OffsetB, New Velocity, WaitFlag, VelocityProfile, InfoFlag);
%
%   DeviceList - DeviceList list {Default: all devices}
%   Offset  = hoizontal offset between upper and lower magnets [mm] {default: no change}
%   OffsetA = hoizontal offset A from "zero" [mm] {default: no change}
%   OffsetB = hoizontal offset B from "zero" [mm] {default: no change}
%   Velocity = Insertion device velocity [mm/sec] {default: no change}
%   WaitFlag = 0    -> return immediately
%              else -> return when ramp is done {default: 1}
%   VelocityProfile = 0    -> profile off
%                     else -> profile on {default: no change}
%   InfoFlag = 0    -> do not print status information {default: 0}, 
%              else -> print status information
%
%   NOTE:  The wait is only done on the Offset, not OffsetA or OffsetB 
%

Err = 0;
SleepExtra = 1.1;

if nargin < 1
   DeviceList = [];
end
if isempty(DeviceList)
   DeviceList = family2dev('EPU');
end
if size(DeviceList,2) == 1
    %DeviceList = elem2dev('EPU', DeviceList);
    DeviceList = [DeviceList ones(size(DeviceList))];
end

if nargin < 2
   for i = 1:size(DeviceList,1)
      Offset(i,1) = getepu(DeviceList(i,:), 1);
   end
end
if isempty(Offset)
   for i = 1:size(DeviceList,1)
      Offset(i,1) = getepu(DeviceList(i,:), 1);
   end
end

if nargin < 3
   for i = 1:size(DeviceList,1)
      [tmp, OffsetA(i,1)] = getepu(DeviceList(i,:), 1);
   end
end
if isempty(Offset)
   for i = 1:size(DeviceList,1)
      [tmp, OffsetA(i,1)] = getepu(DeviceList(i,:), 1);
   end
end

if nargin < 4
   for i = 1:size(DeviceList,1)
      [tmp1, tmp2, OffsetB(i,1)] = getepu(DeviceList(i,:), 1);
   end
end
if isempty(Offset)
   for i = 1:size(DeviceList,1)
      [tmp1, tmp2, OffsetB(i,1)] = getepu(DeviceList(i,:), 1);
   end
end

if nargin < 5
   for i = 1:size(DeviceList,1)
      [tmp1, tmp2, tmp3, NewVel(i,1)] = getepu(DeviceList(i,:), 1);
   end
end
if isempty(NewVel)
   for i = 1:size(DeviceList,1)
      [tmp1, tmp2, tmp3, NewVel(i,1)] = getepu(DeviceList(i,:), 1);
   end
end

if nargin < 6
   WaitFlag = 1;
end
if isempty(WaitFlag)
   WaitFlag = 1;
end

if nargin < 8
   InfoFlag = 0;
end
if isempty(InfoFlag)
   InfoFlag = 1;
end

% For now velocity profile is the same channel as the vertical drive
if nargin >= 7
   if ~isempty(VelocityProfile)
      for i = 1:size(DeviceList,1)
         if DeviceList(i,1) == 5
            ChanName = sprintf('SR%02dW___GDS%1dE__BC02', DeviceList(i,1), DeviceList(i,2));
         else
            ChanName = sprintf('SR%02dU___GDS%1dE__BC02', DeviceList(i,1), DeviceList(i,2));
         end
         scaput(ChanName, VelocityProfile);
      end
   end
end


if size(Offset) == [1 1]
   Offset = Offset*ones(size(DeviceList,1),1);
elseif size(Offset) == [size(DeviceList,1) 1]
   % input OK 
else
   error('Size of Offset must be equal to the Sector or a scalar!');
end	

if size(NewVel) == [1 1]
   NewVel = NewVel*ones(size(DeviceList,1),1);
elseif size(NewVel) == [size(DeviceList,1) 1]
   % input OK 
else
   error('Size of NewVel must be equal to the Sector or a scalar!');
end	


% Print to screen
if InfoFlag
   fprintf('           ');
   for i = 1:size(DeviceList,1)
      fprintf('    EPU%d-%d       ', DeviceList(i,1), DeviceList(i,2));
   end
   fprintf('\n');
   
   fprintf('  Old SP: ');
   for i = 1:size(DeviceList,1)
      fprintf('  %7.3f mm  ', getepu(DeviceList(i,:),1));
   end
   fprintf('\n');
   
   fprintf('  New SP: ');
   for i = 1:size(DeviceList,1)
      fprintf('  %7.3f mm  ', Offset(i));
   end
   fprintf('\n');
end

% Set the velocity then get the horizontal gaps moving
for i = 1:size(DeviceList,1)
   scaput(sprintf('SR%02dU___ODS%1dV__AC01', DeviceList(i,1), DeviceList(i,2)), NewVel(i));
   scasleep(.2);
end
for i = 1:size(DeviceList,1)
   scaput(sprintf('SR%02dU___ODA%1dPS_AC02', DeviceList(i,1), DeviceList(i,2)), OffsetA(i));
   scaput(sprintf('SR%02dU___ODB%1dPS_AC03', DeviceList(i,1), DeviceList(i,2)), OffsetB(i));
   scaput(sprintf('SR%02dU___ODS%1dPS_AC00', DeviceList(i,1), DeviceList(i,2)), Offset(i));
end

% Warn if there is an error
[Offset_AM, OffsetA_AM, OffsetB_AM, OffsetVel_AM, GapRunFlag] = getepu(DeviceList, 0);
if any(GapRunFlag < 0)
   Err = -1;
   error('EPU error');
end

if WaitFlag
   [Offset_AM, OffsetA_AM, OffsetB_AM, OffsetVel_AM, GapRunFlag] = getepu(DeviceList, 0);
   Offset0 = Offset_AM;
   t0 = gettime;
   while any(abs(Offset_AM-Offset) > .050)
      [Offset_AM, OffsetA_AM, OffsetB_AM, OffsetVel_AM, GapRunFlag] = getepu(DeviceList, 0);
      
      if any(GapRunFlag < 0)
         Err = -1;
         error(sprintf('EPU error (RunFlag = %d)', GapRunFlag));
      end
      
      if InfoFlag
         fprintf('  New AM: ');
         for i = 1:size(DeviceList,1)
            fprintf('  %7.3f mm  ', Offset_AM(i));
         end
         fprintf('\r');
         pause(0);
         scasleep(1);
      end
      
      % If all the gaps have not changed for 10 seconds break
      if t0+10 < gettime
         if any([abs(Offset_AM-Offset0)<.050 & abs(Offset_AM-Offset)>.050]) 
            % There is a problem
            disp('WARNING:  The EPU is not moving.');
            Err = -2;
            fprintf('EPU:  SP=%.4f,  AM=%.4f,  RunFlag=%d\n', getepu(DeviceList, 1), getepu(DeviceList, 0), GapRunFlag);
            error('EPU:  SP-AM error');
         end
         t0 = gettime;
         Offset0 = getepu(DeviceList, 0);
         scasleep(.05);
      end
   end
   
   % Extra delay
   scasleep(SleepExtra);   
   
   if InfoFlag
      Offset_AM = getepu(DeviceList, 0);
      fprintf('  New AM: ');
      for i = 1:size(DeviceList,1)
         fprintf('  %7.3f mm  ', Offset_AM(i));
      end
      fprintf('\r');
      pause(0);
   end
   
else
   % Return immediately
end

if InfoFlag
   fprintf('\n');
end

