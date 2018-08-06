function [num,indx]=nam2indx(baselist,names)
%[num,indx]=nam2indx(baselist,names)
% baselist=baseline list of names to check against
% names=names to check against baseline list
% num,indx=indices of 'names' as found in 'baselist'
%NOTE: names string must be same number of characters as baselist (excluding blanks)
%NOTE: if you call nam2indx with the same parameter
% in the 'num' field as in the 'indx' field - kk stops at 32

% if ~(length(baselist(1,:))==length(names(1,:)))
% disp('WARNING: string lengths differ in nam2indx');
% return
% end

s=size(names);      nmax=s(1);
s=size(baselist);   nbase=s(1);

num=0;
indx=zeros(1,nmax);
for jj=1:nmax
  for kk=1:nbase
      if strcmp(deblank(baselist(kk,:)),deblank(names(jj,:)))==1;
      num=num+1;
      indx(num)=kk;
      break;
      end
  end
end
      
if ~(num==nmax)
disp('WARNING: not all names found in nam2indx');
end

if(num>1) 
  [i,j,indx] = find(indx);
  indx=sort(indx(:)); 
end