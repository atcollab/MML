function prop=tango_get_db_property(groupname,propertyname,dbserver)
%TANGO_GET_DG_PROPERTY - Queries for a Database property
%
%  [prop]=tango_get_db_Property(groupname,propertyname,dbserver)
%
% INPUTS
% 1. groupname -  name of the group in the property tree in Tango DB
% 2. propertyname - property requested in the groupname 
% 3. dbserver - TANGO database device serve  'sys/database/dbds' by default
%  
% OUTPUTS
%  1. prop cell array of strings with the system property 
%
% EXEMPLES
%  prop = tango_get_db_property('anneau','tracy_bpm_mapping')
%  
% See also tango_set_db_property

%
% Modified By Laurent S. Nadolski

if (nargin < 2)
	help tango_get_db_property
	return;
elseif nargin < 3
  dbserver = tango_get_dbname;
end

argin = {groupname,propertyname};
res = tango_command_inout(dbserver,'DbGetProperty',argin);

if (tango_error == -1)
  %- handle error 
   tango_print_error_stack;
   return
end

%% Overhead 4 lines
dim = 4;
nb = str2num(char(res(dim)));

%% return cell array of string
prop = res(dim+1:dim+nb);
