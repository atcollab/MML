function dbname = tango_get_dbname(varargin)
%TANGO_GET_DBNAME - Returns tango database name
%
%  OUPUTS
%  1. dbname - Static database server name
%
%  NOTES
%  1. Try to have a redondancy on tango static database

%
%% Written By Laurent S. Nadolski


dbname = 'sys/database/dbds1';
tango_ping(dbname);

if tango_error
    dbname = 'sys/database/dbds';
end
