function write_goldenorbit_ffb2(plane,goldenorbit,IDBPMlist)
% function write_goldenorbit_ffb2(plane,goldenorbit,IDBPMlist)
%
% This routine writes the BPM setpoints, which are used
% by the fast feedback system.
%
% Christoph Steier, August 2002


if nargin ~= 3
   error('write_goldenorbit_ffb2 needs 3 input arguments');
end


if plane == 1
   for loop=1:size(IDBPMlist,1)
      paramname=getname('IDBPMx',IDBPMlist(loop,:));
      changeindex=findstr(paramname,'X_AM');
      paramname(changeindex:(changeindex+3))='X_AC';
      scaput(paramname,goldenorbit(loop));
   end
elseif plane == 2
   for loop=1:size(IDBPMlist,1)
      paramname=getname('IDBPMy',IDBPMlist(loop,:));
      changeindex=findstr(paramname,'Y_AM');
      paramname(changeindex:(changeindex+3))='Y_AC';
      scaput(paramname,goldenorbit(loop));
   end
end

