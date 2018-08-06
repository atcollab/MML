dev='archivage/hdbextractor/1'
tango_ping(dev)

attr_name = '//ganymede.synchrotron-soleil.fr:20000/LT1/AEsim/CH.3/current';
% Option une structure composee de 2 champs
% dvalue : valeur
% svalue : date en format type 2004-12-05 16:08:07.969

% Import toutes les valeurs archivees entre deux dates
date1 = '2004-12-05 14:00:00';
date2 = datestr(now,'yyyy-mm-dd HH:MM:SS');
argin = {attr_name, date1, date2};

Data = tango_command_inout(dev,'GetAttScalarDataBeetweenDates',argin)

formatstr0 = 'yyyy-mm-dd HH:MM:SS';
formatstr = 'HH:MM';

datenum('2004-05-12 12:45:23', formatstr0);
val_date = datenum(Data.svalue, formatstr0);

plot(val_date,Data.dvalue,'.-');
legend(attr_name)
grid on
datetick('x',formatstr)

valN = val_date - datenum(date1, formatstr0);
plot(valN/60/60,Data.dvalue,'.-');

