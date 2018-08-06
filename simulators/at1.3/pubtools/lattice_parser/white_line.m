function [y c r] = white_line(str)
% [y c r] = white_line(str)
% Check the input is a white-line or not.
% If it is, y = 1, otherwise y = 0.
% Return y, the leading character (c) and the remainder string (r). r = strtrim(str) - the leading character.

y = 1;
c = '';
r = '';
s = strtrim(str);
n = length(s);
for i = 1:n
    % character must in the interval [33,126] those are not control characters or white-space
    if (s(i) > 32) && (s(i) < 127)
        y = 0;     
        c = s(i);
        r = s(i+1:n);
        return
    end
end