function [eR,eT] = testSymplecticity(R,T)
%[eR,eT] = testSymplecticity(R,T)
%test the symplecticity of a transfer matrix and/or a second order Taylor map
%[eR] = testSymplecticity(R22)
%[eR] = testSymplecticity(R44)
%[eR] = testSymplecticity(R66)
%[eR,eT] = testSymplecticity(R66,T)
%Input:
%   R, 6x6 transfer matrix, can be 4x4 or 2x2 matrix if T is absent
%   T, second order transport map, eg, T(1,:,:) is 6x6 matrix describing
%   second order effect on x by the canonical variables.
%Author: Xiaobiao Huang
%created 2009



S = zeros(6,6);
S(1,2)=-1; S(2,1)=1;
S(3,4)=-1; S(4,3)=1;
S(5,6)=-1; S(6,5)=1;
S2=S(1:2,1:2);
S4=S(1:4,1:4);

if nargin<2
   eT=0;
   if size(R,1)==4
      eR = R'*S4*R-S4; 
   elseif size(R,1)==2
      eR = R'*S2*R-S2; 
   else
       eR = R'*S*R-S; 
   end
   return;
end

eR = R'*S*R-S;
eT = zeros(size(T));
for a=1:size(eT,1)
    for b=1:size(eT,2)
        for n=1:size(eT,3)
            tmp = squeeze(R(:,b)'*S*T(:,a,n)) - R(:,a)'*S*squeeze(T(:,b,n));
            eT(a,b,n)=tmp;
            if tmp>1
               disp([a b n]) 
            end
        end
    end
end

fprintf('max diff(R)=%e\n',max(max(abs(eR))))
for ii=1:6
    fprintf('max diff(T(%d,:,:))=%e\n',ii, max(max(squeeze(abs(eT(ii,:,:))))))
end