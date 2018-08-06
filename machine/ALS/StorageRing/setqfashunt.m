function setqfashunt(ShuntNumber, Shunt, DeviceList, WaitFlag)
%SETQFASHUNT - Sets the QFA shunts
%  setqfashunt(ShuntNumber, Shunt, DeviceList, WaitFlag)
%
%  ShuntNumber = 1 or 2
%  Shunt = 0 or Off
%          1 or On
%  DeviceList ([Sector Device #] or [element #]) (default: whole family)
%  WaitFlag = 0, return immediately
%             else, add BPM delay (default), 
%             
%  Roughly speaking:  Shunt #1     -> 13 amps
%                     Shunt #1 & 2 -> 26 amps
%                     Shunt #2     -> 17 amps
%
%  See also setqfashunt


% Input checking
if nargin < 2
   error('Must have 2 inputs.');
end

if isempty(ShuntNumber)
   error('Input #1 empty.');
end

if isempty(Shunt)
   error('Input #2 empty.');
end
if ischar(Shunt)
   if strcmpi(Shunt,'on')
      Shunt = 1;
   elseif strcmpi(Shunt,'off')
      Shunt = 0;
   else
      error('Input #2, shunt, in question.');
   end
end

if nargin < 3
   DeviceList = [];
end
if isempty(DeviceList)
   DeviceList = getlist('QF');
end
if (size(DeviceList,2) == 1) 
   DeviceList = elem2dev('QF', DeviceList);
end

if all(size(Shunt) == [1 1])
   Shunt = Shunt*ones(size(DeviceList,1),1);
elseif all(size(Shunt) == [size(DeviceList,1) 1])
   % input OK 
else
   error('Size of input #2 (Shunt) must be equal to the size of input #3 (DeviceList) or a scalar!');
end


if nargin < 4
   WaitFlag = [];
end
if isempty(WaitFlag)
   WaitFlag = 1;
end


% Main loop
for i = 1:size(DeviceList,1)
   if DeviceList(i,2) == 1
      if ShuntNumber == 1
         setpv(sprintf('SR%02dC___QFA1S1_BC19', DeviceList(i,1)), Shunt(i,1));
      elseif ShuntNumber == 2
         setpv(sprintf('SR%02dC___QFA1S2_BC18', DeviceList(i,1)), Shunt(i,1));         
      else
         error('ShuntNumber must be 1 or 2.')
      end
   elseif DeviceList(i,2) == 2
      if ShuntNumber == 1
         setpv(sprintf('SR%02dC___QFA2S1_BC17', DeviceList(i,1)), Shunt(i,1));
      elseif ShuntNumber == 2
         setpv(sprintf('SR%02dC___QFA2S2_BC16', DeviceList(i,1)), Shunt(i,1));         
      else
         error('ShuntNumber must be 1 or 2.')
      end
   else
      error('DeviceList column #2 must be 1 or 2.')
   end
end


    
if WaitFlag
   t0 = gettime;
   BM = getqfashunt(ShuntNumber, DeviceList);
   while any(BM ~= Shunt)
       BM = getqfashunt(ShuntNumber, DeviceList);
   end

   % Extra delay for fresh BPM data
   if WaitFlag
       % Add a delay based on the WaitFlag
       if WaitFlag > 0
           sleep(WaitFlag);
       elseif WaitFlag == -2
           [N, BPMDelay] = getbpmaverages;
           BPMDelay = 2.2*BPMDelay;
           if ~isempty(BPMDelay)
               sleep(BPMDelay);
           end
       elseif WaitFlag == -3
           TUNEDelay = getfamilydata('TUNEDelay');
           if ~isempty(TUNEDelay)
               sleep(TUNEDelay);
           end
       elseif WaitFlag == -4
           tmp = input('   Setpoint changed.  Hit return ready. ');
       end
   end
end
