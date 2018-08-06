function [s, ss] = checkcentermarker
%CHECKCENTERMARKER - Checks the marker location at the center of the straight section
%  [CenterPosition, IdealPosition] = checkcentermarker

%  Written by Greg Portmann

global THERING

c = getfamilydata('Circumference');  %196.805415;
ss = (1:12)*c/12;

for j = 1:11
    i=family2atindex(['SECT',num2str(j+1)]);
    s(j)=findspos(THERING, i);
end
s(12) = findspos(THERING, length(THERING)+1);

fprintf('   Sector    Model     Sector*Circumference/12    "Error" \n');
for i = 1:12
    fprintf('   %2d.    %10.6f         %10.6f         %10.6f  [meters]\n', i, s(i), ss(i), s(i)-ss(i));
end
fprintf('   Note: Super bend sectors are longer than normal sectors.\n');

s = s(:);
ss = ss(:);

%[(1:12)' s ss s-ss]