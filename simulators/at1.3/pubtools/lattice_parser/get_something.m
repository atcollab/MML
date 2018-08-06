function [answer dc] = get_something(line,string,str_head,number,num_head,separators,comments)
%GET_SOMETHING: use decoding function with mode = 1 to get something from the input line-string.
% dc = decoding(mode=1,line,string,str_head,number,num_head,seperaters,comments)
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
dc = decoding(1,line,string,str_head,number,num_head,separators,comments);
if dc.n == 0
%   disp('NOTE: function get_something gets nothing from input line-string')
    answer = 0;
elseif dc.n > 1
    error('ERROR: function get_something gets too much things!')
    answer = 0;
else
    answer = 1;
end
