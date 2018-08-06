function r_list = reverse_list(list)
% r_list = reverse_list(list)
% list: list of ap_element(s)
% Return the "r_list" which is the inverse array of the list.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Terminology and Category: init_lattice
%--------------------------------------------------------------------------
r_list = [];
n = length(list);
for i = 1:n
     r_list = [list(i) r_list];
end                                        
return