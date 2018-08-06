function [y w r] = wanted_word(str,word_char_set,leading_char)
% [y w r] = wanted_word(str,word_char_set)
% Check the first word in the given wor_char_set.
% If it is, y = 1, otherwise y = 0.
% Return y, the word (w) and the remainder string (r). r = strtrim(str) - the leading word.

r = strtrim(str);
y = 0;
w = '';
s = r;
m = length(s);
z = 0;
skip = 1;
if isempty(word_char_set)
    word_char_set = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789';
    leading_char = 52;
end
k = length(word_char_set);
if (leading_char < 1) || (leading_char > k)
    leading_char = k;
end

for i = 1:m
    c = s(i);
    % character must in the interval [33,126] those are not control characters or white-space
    if (c > 32) && (c < 127)
        skip = 0;
        idx = strfind(word_char_set,s(i));
        if ~isempty(idx)
            if y == 0
                if idx <= leading_char
                    y = 1;
                    z = 1;
                    w(z) = s(i);
                else
                    r = s(i:m);
                    return
                end
            else % y == 1;
                z = z+1;
                w(z) = s(i);
            end
        else % A word is terminated.
            r = s(i:m);
            return
        end
    else
        if skip == 1
            continue
        else % skip == 0
            r = s(i:m);
            return
        end
    end
end

if y == 1
    r = '';
end