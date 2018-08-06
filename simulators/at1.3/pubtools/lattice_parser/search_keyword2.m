function f = search_keyword2(keyword,list)
% f = search_keyword2(keyword,list)
% search the keywork in the given two-layer list.
% return [i-layer1 j-layer2] => list{i}{j}

f = [0 0];
% "list" dependent translation of the keyword to the upper/lower characters
%K = upper(keyword);
k = lower(keyword);
n = length(list);
for i = 1:n
%   L = upper(list{i});
	l = lower(list{i});
    id = strmatch(k,l,'exact');
    if length(id) ~= 0
        f = [i id];
        break;
    end
end