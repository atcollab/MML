function [BPM1,BPM2]=getbbpm(Dim, NumberOfAverages, newBPMlist);   
%              BPM   = getbbpm(Dimension, NumberOfAverages, BBPMlist);
%   [BBPMx, BBPMy] = getbbpm(Dimension, NumberOfAverages, BBPMlist);
%
%   Inputs:  Dimension: 1, 'x', 'h' - First Output Horizontal, Second Vertical
%                       2, 'y', 'v' - First Output Vertical,   Second Horizontal
%                       else - defaults to Dimension=1
%            Number of averages (10 Hz data rate) (default: 1)
%            BBPMlist ([Sector Device #] or [element #]) (default: all BPMs)
%
%   Outputs: Beam position [mm]
%
%   Note: There are new IDBPMs in sector 9 arc 
%         SR09C___BPM4XT_AM00
%         SR09C___BPM4YT_AM01
%         SR09C___BPM4AT_AM98
%
%         SR09C___BPM5XT_AM02
%         SR09C___BPM5YT_AM03
%         SR09C___BPM5AT_AM99
%

if nargin == 0,
   Dim = 0;
   NumberOfAverages = 1;
   newBPMlist = getlist('BBPMx');
elseif nargin == 1;
   NumberOfAverages = 1;	
   newBPMlist = getlist('BBPMx');
elseif nargin == 2
   newBPMlist = getlist('BBPMx');		
end 

if isstr(Dim)
   if strcmp(upper(Dim),'X')
      Dim = 1;
   elseif strcmp(upper(Dim),'Y')
      Dim = 2;
   elseif strcmp(upper(Dim),'H')
      Dim = 1;
   elseif strcmp(upper(Dim),'V')
      Dim = 2;
   else
      Dim = 1;
   end
end


if isempty(newBPMlist)
   %error('GETBBPM: BBPMlist is an empty list');
   BPM1 = [];
   BPM2 = [];
   return
end


if (size(newBPMlist,2) == 1) 
   newBPMlist = elem2dev('BBPMx', newBPMlist);
end                   


if (Dim == 2)
   BPM1 = getam('BBPMy', newBPMlist, NumberOfAverages);    
else
   BPM1 = getam('BBPMx', newBPMlist, NumberOfAverages);    
end 


if nargout >= 2,
   if (Dim == 2)
      BPM2 = getam('BBPMx', newBPMlist, NumberOfAverages);    
   else
      BPM2 = getam('BBPMy', newBPMlist, NumberOfAverages);    
   end 
end	








