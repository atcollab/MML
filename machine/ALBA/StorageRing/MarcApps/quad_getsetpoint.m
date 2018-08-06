function [name, val] = quad_getsetpoint()
quadlist = findmemberof('QUAD');
imax=size(quadlist,1);
[data] = getsp(quadlist);
for i=1:imax,
    tmp=data{i};
    name(i)=quadlist(i);
    val(i) = tmp(1);
end
val=num2cell(val);
