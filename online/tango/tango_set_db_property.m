function prop=tango_set_db_property(groupname,propertyname,prop,dbserver)
%TANGO_GET_DG_PROPERTY - Queries for a Database property
%
%  [prop]=tango_get_db_Property(groupname,propertyname,dbserver)
%
% INPUTS
% 1. groupname -  name of the group in the property tree in Tango DB
% 2. propertyname - property requested in the groupname
% 3. prop - property to write in static TANGO database
% 4. dbserver - TANGO database device serve  'sys/database/dbds' by default
%  
% OUTPUTS
%  1. prop cell array of strings with the system property 
%
% EXEMPLES
%  prop = tango_get_db_property('anneau','tracy_bpm_mapping')
%  tango_set_db_property('anneau','tracy_bpm_mapping',prop)
%
% See also tango_get_db_property

% TODO ne marche PAS ...

disp('Not working')
return;
%
% Modified By Laurent S. Nadolski

if (nargin < 3)
	help tango_get_db_property
	return;
elseif nargin < 4
  dbserver = 'sys/database/dbds';
end

argin = {groupname,propertyname,prop};
%argin = {'LT1','1','tracy_dipole_mapping','1','BEND1::LT1/AEsim/D.1'};
res = tango_command_inout2(dbserver,'DbPutProperty',argin);
