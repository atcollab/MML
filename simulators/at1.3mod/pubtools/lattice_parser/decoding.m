function dc = decoding(mode,line,string,str_head,number,num_head,separators,comments)
%DECODING: decode the given "line" into the "string", "number", "separator" and "comment".
% dc = decoding(mode,line,string,str_head,number,num_head,seperaters,comments)
% mode == 0, then decoding the given "string" to the end-of-string.
% mode == 1, one of the "word", "number", "separator" and "comment" is decoded.
% The line may be "[!][label field][: = ,][keyword data][= ( , field=data ; &... !...]"
% Return dc.n dc.type(dc.n) = [1-4] dc.data(dc.n) dc.r = rest-string of line.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science Park, Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Terminology and Category: Lattice I/O
%--------------------------------------------------------------------------
global Lattice_DB

if isempty(string) == 1
    string = Lattice_DB.WordCharSet;
    str_head = Lattice_DB.WordHead;
end
if isempty(number) == 1
    number = Lattice_DB.NumCharSet;
    num_head = Lattice_DB.NumHead;
end
if isempty(separators)
    separators = '{}():,;={}';
end
if isempty(comments)
    comments = '!&';
end

dc.n = 0;
dc.r = line;
dc.type = [];
dc.data = [];
is_string = 0; % is_field
is_number = 0; % is_data
z = 0;
str = '';
idx = cell(4,1);
% all leading and trailing white-space characters removed.
s = strtrim(line);
n = length(s);
for i = 1:n
    c = s(i);
     % character must in the interval [33,126] those are not control characters or white-space
    if (c > 32) && (c < 127)
        idx{1} = strfind(string,s(i));
        idx{2} = strfind(number,s(i));
        idx{3} = strfind(separators,s(i));
        idx{4} = strfind(comments,s(i));
        for j = 1:4
            id(j) = length(idx{j});
        end
        if (id(3) == 1) || (id(4) == 1)
            if is_string == 1 % end-of-a-word
                dc.n = dc.n+1;
                dc.data{dc.n} = lower(str);
                dc.type(dc.n) = 1;
                if mode == 1
                    dc.r = s(i:n);
                    return;
                end
                % reset flag, str-counter, and str
                is_string = 0;
                z = 0;
                str = '';
            end
            if is_number == 1 % end-of-a-number
                dc.n = dc.n+1;
                dc.data{dc.n} = str2num(str);
                dc.type(dc.n) = 2;
                if mode == 1
                    dc.r = s(i:n);
                    return;
                end
                % reset flag, str-counter, and str
                is_number = 0;
                z = 0;
                str = '';
            end
            if id(4) == 1 % comment character
                dc.n = dc.n+1;
                dc.type(dc.n) = 4;
                dc.data{dc.n} = s(i:n);
                % No matter what mode is, the decoding process is finished.
                dc.r = '';
                return
            end
            if id(3) == 1 % separator
                dc.n = dc.n+1;
                dc.type(dc.n) = 3;
                dc.data{dc.n} = s(i);
                if mode == 1 % handle the rest-line and return it
                    if i < n
                        dc.r = s(i+1:n);
                    else
                        dc.r = '';
                    end
                    return
                end
            end
        elseif (id(1) == 1) && (id(2) == 1) % [0123456789dDeE]
            if (is_string == 0) && (is_number == 0)
                if idx{1} <= str_head % [dDeE]
                    is_string = 1;
                    str = '';
                    z = 1;
                    str(z) = s(i);
                elseif idx{2} <= num_head % [0123456789]
                    is_number = 1;
                    str = '';
                    z = 1;
                    str(z) = s(i);
                end
            else % (is_string == 1) || (is_number == 1)
                z = z+1;
                str(z) = s(i);
            end
        elseif (id(1) == 1) && (id(2) == 0)
            if is_string == 0 % [a-Z A-Z]
                if is_number == 1
                    display(['ERROR: ' line ' @' num2str(i) ' is ' line(i)]);
                    error('??? decoding ???');
                else % is_number == 0
                    if (idx{1} <= str_head) % leading character
                        is_string = 1;
                        str = '';
                        z = 1;
                        str(z) = s(i);
                    else % non-leading character
                        display(['ERROR: ' line ' @' num2str(i) ' is ' line(i)]);
                        error('??? decoding ???');
                    end
                end
            else % is_string == 1
                z = z+1;
                str(z) = s(i);    
            end
        elseif (id(1) == 0) && (id(2) == 1)
            if is_number == 0 % [+-.]
                if is_string == 1
                    display(['ERROR: ' line ' @' num2str(i) ' is ' line(i)]);
                    error('??? decoding ???');
                else % is_string == 0
                    if (idx{2} <= num_head) % leading character
                        is_number = 1;
                        str = '';
                        z = 1;
                        str(z) = s(i);
                    else % non-leading character
                        display(['ERROR: ' line ' @' num2str(i) ' is ' line(i)]);
                        error('??? decoding ???');
                    end
                end
            else % is_number == 1
                z = z+1;
                str(z) = s(i);
            end
        else
            display(['ERROR: ' line ' @' num2str(i) ' is ' line(i)]);
            error('??? decoding ???');
        end
    else % control character or white-space
        if is_string == 1 % end-of-a-word
            dc.n = dc.n+1;
            dc.data{dc.n} = lower(str);
            dc.type(dc.n) = 1;
            if mode == 1
                dc.r = s(i:n);
                return;
            end
            % reset flag, str-counter, and str
            is_string = 0;
            z = 0;
            str = '';
        end
        if is_number == 1 % end-of-a-number
            dc.n = dc.n+1;
            dc.data{dc.n} = str2num(str);
            dc.type(dc.n) = 2;
            if mode == 1
                dc.r = s(i:n);
                return;
            end
            % reset flag, str-counter, and str
            is_number = 0;
            z = 0;
            str = '';
        end
    end
end
% check the last word/number before end-of-string
if is_string == 1 % end-of-a-word
    dc.n = dc.n+1;
    dc.data{dc.n} = lower(str);
    dc.type(dc.n) = 1;
end
if is_number == 1 % end-of-a-number
    dc.n = dc.n+1;
    dc.data{dc.n} = str2num(str);
    dc.type(dc.n) = 2;
end
dc.r = '';