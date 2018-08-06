function IDBPMNumAverages = getidbpmavg(list)
% IDBPMNumAverages = getidbpmavg(IDBPMlist)
%
%   This function gets the number of averages for the IDBPMs in IDBPMlist
%   Note: IDBPM(9,4) and IDBPM(9,5) exist but are not in the default IDBPMlist
%


error('This function needs to be repaired to work with the new middle layer software.');


if nargin < 1
   list = getlist('IDBPMx');
end
if size(list,2) == 1
   list = elem2dev('IDBPMx', list);
end


% Set the IDBPM averaging
for i=1:size(list,1)
   if list(i,1) == 9 & list(i,2) > 2
      Name = sprintf('SR%02dC___BPM%dAT_AC%d', list(i,1), list(i,2), 94+list(i,2));
   elseif list(i,1) == 4 & list(i,2) > 2
      Name = sprintf('SR%02dS___IBPM%dA_AC%d', list(i,1), list(i,2), 95+list(i,2));
   else
      Name = sprintf('SR%02dS___IBPM%dA_AC%d', list(i,1), list(i,2), 97+list(i,2));
   end
   %fprintf('%s\n',Name);
   IDBPMNumAverages(i,1) = scaget(Name);
end


% Other IDBPMs
%scaget('SR04S___IBPM3A_AC98');
%scaget('SR04S___IBPM4A_AC99');
%scaget('SR09C___BPM4AT_AC98');
%scaget('SR09C___BPM5AT_AC99');
