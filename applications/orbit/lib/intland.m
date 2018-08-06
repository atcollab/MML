function [n1,v1]=intland(v1,v2)
%find the intersection of two integer arrays
if isempty(v1) | isempty(v2) 
    n1=0;
    v1=[];
    return
end

%for each entry in v1, check if contained in v2
for ind=1:length(v1)
if isempty(find(v2==v1(ind)))
v1(ind)=0;
end
end

v1=sort(v1(find(v1)));
n1=length(v1);
