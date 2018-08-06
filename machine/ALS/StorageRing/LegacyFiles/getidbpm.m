function [BPM1,BPM2]=getidbpm(Dim, NumberOfAverages, newBPMlist);   
%              BPM   = getidbpm(Dimension, NumberOfAverages, IDBPMlist);
%   [IDBPMx, IDBPMy] = getidbpm(Dimension, NumberOfAverages, IDBPMlist);
%
%   Inputs:  Dimension: 1, 'x', 'h' - First Output Horizontal, Second Vertical
%                       2, 'y', 'v' - First Output Vertical,   Second Horizontal
%                       else - defaults to Dimension=1
%            Number of averages (10 Hz data rate) (default: 1)
%            IDBPMlist ([Sector Device #] or [element #]) (default: all BPMs)
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
   newBPMlist = getlist('IDBPMx');
elseif nargin == 1;
   NumberOfAverages = 1;	
   newBPMlist = getlist('IDBPMx');
elseif nargin == 2
   newBPMlist = getlist('IDBPMx');		
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
   %error('GETIDBPM: IDBPMlist is an empty list');
   BPM1 = [];
   BPM2 = [];
   return
end


if (size(newBPMlist,2) == 1) 
   newBPMlist = elem2dev('IDBPMx', newBPMlist);
end                   


if (Dim == 2)
   BPM1 = getam('IDBPMy', newBPMlist, NumberOfAverages);    
else
   BPM1 = getam('IDBPMx', newBPMlist, NumberOfAverages);    
end 


if nargout >= 2,
   if (Dim == 2)
      BPM2 = getam('IDBPMx', newBPMlist, NumberOfAverages);    
   else
      BPM2 = getam('IDBPMy', newBPMlist, NumberOfAverages);    
   end 
end	








