function idx = elem_find(a,name)
% idx = elem_find(a,name)
% Search the "name" in the element-list "a" and return the index "idx".
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Terminology and Category: OOP in MATLAB
%--------------------------------------------------------------------------
n = length(a);
idx = 0;
for i = 1:n
    yn = strmatch(name,a(i).FamName,'exact');
    if ~isempty(yn)
        idx = i;
        return
    end
end