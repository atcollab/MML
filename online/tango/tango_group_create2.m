function group_id = tango_group_create2(group_name)
%TANGO_GROUP_CREATE2 Creates a new TANGO group and delete old if already exists.
%
% See also TANGO_GROUP_KILL

%
%  Written by Laurent S. Nadolski

tango_group_id(group_name);
if (tango_error ~= -1)
    tango_group_kill(group_name)
end

group_id = tango_group_create(group_name);

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end