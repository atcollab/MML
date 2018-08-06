function [y c r] = wanted_char(str,char_list)
% [y c r] = wanted_char(str,char_list)
% Check the first character, which is not white-space or control character, in the given char_list.
% If it is, y = the index of character apperred in the char_list, otherwise y = 0.
% Return y, the character (c) and the remainder string (r). r = strtrim(str) - the leading character.

r = strtrim(str);
y = 0;
c = '';
s = r;
n = length(s);
for i = 1:n
    % character must in the interval [33,126] those are not control characters or white-space
    if (s(i) > 32) && (s(i) < 127)
        idx = strfind(char_list,s(i));
        if ~isempty(idx)
            y = idx;
        end
        c = s(i);
        r = s(i+1:n);
        return
    end
end