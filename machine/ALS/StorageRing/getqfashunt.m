function Shunt = getqfashunt(ShuntNumber, DeviceList, ChanType)
% Shunt = getqfashunt(ShuntNumber, DeviceList, ChanType)
%
%  Shunt = 0 off
%          1 on
%  ShuntNumber = 1 or 2
%  DeviceList ([Sector Device #] or [element #]) (default: whole family)
%  ChanType = 0 -> BM (On/off (1/0) Monitor)
%             1 -> BC (On/Off (1/0) Control)
%
%  See also setqfashunt

if nargin < 1
   error('Must have a shunt number [1 or 2]');
end
if isempty(ShuntNumber)
   error('Input #1 empty.');
end

if nargin < 2
   DeviceList = getlist('QF');
end
if isempty(DeviceList)
   DeviceList = getlist('QF');
end
if (size(DeviceList,2) == 1) 
   DeviceList = elem2dev('QF', DeviceList);
end

if nargin < 3
   ChanType = 0;
end
if isempty(ChanType)
   ChanType = 0;
end

if ChanType == 0
   for i = 1:size(DeviceList,1)
      if DeviceList(i,2) == 1
         if ShuntNumber == 1
            Shunt(i,1)= getpv(sprintf('SR%02dC___QFA1S1_BM23', DeviceList(i,1)));
         elseif ShuntNumber == 2
            Shunt(i,1)= getpv(sprintf('SR%02dC___QFA1S2_BM22', DeviceList(i,1)));         
         else
            error('ShuntNumber must be 1 or 2.')
         end
      elseif DeviceList(i,2) == 2
         if ShuntNumber == 1
            Shunt(i,1)= getpv(sprintf('SR%02dC___QFA2S1_BM21', DeviceList(i,1)));
         elseif ShuntNumber == 2
            Shunt(i,1)= getpv(sprintf('SR%02dC___QFA2S2_BM20', DeviceList(i,1)));         
         else
            error('ShuntNumber must be 1 or 2.')
         end
      else
         error('DeviceList column #2 must be 1 or 2.')
      end
   end
elseif ChanType == 1
   for i = 1:size(DeviceList,1)
      if DeviceList(i,2) == 1
         if ShuntNumber == 1
            Shunt(i,1)= getpv(sprintf('SR%02dC___QFA1S1_BC19', DeviceList(i,1)));
         elseif ShuntNumber == 2
            Shunt(i,1)= getpv(sprintf('SR%02dC___QFA1S2_BC18', DeviceList(i,1)));         
         else
            error('ShuntNumber must be 1 or 2.')
         end
      elseif DeviceList(i,2) == 2
         if ShuntNumber == 1
            Shunt(i,1)= getpv(sprintf('SR%02dC___QFA2S1_BC17', DeviceList(i,1)));
         elseif ShuntNumber == 2
            Shunt(i,1)= getpv(sprintf('SR%02dC___QFA2S2_BC16', DeviceList(i,1)));         
         else
            error('ShuntNumber must be 1 or 2.')
         end
      else
         error('DeviceList column #2 must be 1 or 2.')
      end
   end
else
   error('ChanType must be 0 or 1');
end
