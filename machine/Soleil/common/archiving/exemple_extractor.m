dev='archivage/tdbextractor/1'
tango_ping(dev)

tango_command_inout(dev,'GetHost')
attr_name = '//ganymede.synchrotron-soleil.fr:20000/LT1/AEsim/CH.3/current';
tango_command_inout2(dev,'GetArchivingMode',attr_name)

% Rappel: les commandes sont sensible a  la casse
tango_command_inout2(dev,'IsArchived',attr_name)

%Proprietes d'un attribut (NON utile)
tango_command_inout(dev,'GetAttPropertiesData',attr_name)

% Liste des attributs archives
tango_command_inout(dev,'GetCurrentArchivedAtt')


% Import toutes les valeurs archivees
Data = tango_command_inout2(dev,'GetAttScalarData',attr_name)

% Option une structure composee de 2 champs
% dvalue : valeur
% svalue : date en format type 2004-12-05 16:08:07.969

% Import toutes les valeurs archivees entre deux dates
date1 = '2004-12-05 14:00:00';
date2 = '2004-12-05 14:03:00';
argin = {attr_name, date1, date2};

Data = tango_command_inout(dev,'GetAttScalarDataBeetweenDates',argin)


% Import toutes les valeurs archivees entre 2 dates plus grande que valeur x
date1 = '2004-12-05 16:00:00';
date2 = '2004-12-05 16:20:00';
valinf= '2';
argin = {attr_name, valinf, date1, date2};

Data = tango_command_inout2(dev,'GetAttScalarDataSupThanBeetweenDates',argin)


% Import toutes les valeurs archivees entre 2 dates plus grande que valeur x
date1 = '2004-12-05 16:00:00';
date2 = '2004-12-05 16:30:00';
valinf= '0';
valsup= '5';
argin = {attr_name, valinf, valsup, date1, date2};

Data = tango_command_inout2(dev,'GetAttScalarDataSupAndInfThanBeetweenDates',argin)

Data = tango_command_inout2(dev,'GetAttScalarDataSupThanBeetweenDates',argin)
% Renvoi
- ERROR 1
        |-reason.....API_CorbaException
        |-desc.......UNKNOWN CORBA system exception
        |-origin.....Connection::command_inout()
        |-severity...Error (1)
- ERROR 2
        |-reason.....API_CommunicationFailed
        |-desc.......Failed to execute command_inout on device archivage/hdbextractor/1, command GetAttScalarDataSupThanBeetweenDates
        |-origin.....Connection::command_inout()
        |-severity...Error (1)
- ERROR 3
        |-reason.....command_inout failed
        |-desc.......failed to execute command_inout on archivage/hdbextractor/1
        |-origin.....TangoBinding::command_inout
        |-severity...Error (1)

Alors qu'il faudrait un diagnostic disant que le nombre d'argument n'est pas
bon.

Semble vrai pour les autres commandes


% Import toutes les valeurs archivees entre 2 dates plus grande que valsup et
% plus petite que valinf

date1 = '2004-12-05 16:00:00';
date2 = '2004-12-05 16:30:00';
valinf= '5';
valsup= '0';
argin = {attr_name, valinf, valsup, date1, date2};

Data = tango_command_inout2(dev,'GetAttScalarDataInfOrSupThanBeetweenDates',argin)


% Import toutes les valeurs archivees entre 2 dates plus  petite que valinf

date1 = '2004-12-05 16:00:00';
date2 = '2004-12-05 16:30:00';
valinf= '4';
argin = {attr_name, valinf, date1, date2};

Data = tango_command_inout2(dev,'GetAttScalarDataInfThanBeetweenDates',argin)

% Import toutes les n dernieres valeurs archivees 

valn = '10';
argin = {attr_name, valn};

Data = tango_command_inout2(dev,'GetAttScalarDataLastN',argin)


% Import toutes les valeurs archivees plus  petites que valinf

valinf= '4';
argin = {attr_name, valinf};

Data = tango_command_inout2(dev,'GetAttScalarDataInfThan',argin)

% Import toutes les valeurs archivees plus grandes que valsup

valsup= '4';
argin = {attr_name, valsup};

Data = tango_command_inout2(dev,'GetAttScalarDataSupThan',argin)


% Import toutes les valeurs archivees plus grandes que valsup

valinf= '2';
valsup= '5';
argin = {attr_name, valinf, valsup};

Data = tango_command_inout2(dev,'GetAttScalarDataSupAndInfThan',argin)

% Import la plus grande valeur archivee

argin = attr_name;

Data = tango_command_inout2(dev,'GetAttScalarDataMax',argin)

% Import la plus grande valeur moyenne

argin = attr_name;

Data = tango_command_inout2(dev,'GetAttScalarDataAvg',argin)

% Import la plus petite valeur archivee

argin = attr_name;

Data = tango_command_inout2(dev,'GetAttScalarDataMin',argin)

%Idem entre dates

date1 = '2004-12-05 16:00:00';
date2 = '2004-12-05 16:30:00';
argin = {attr_name, date1, date2};

Data = tango_command_inout2(dev,'GetAttScalarDataAvgBetweenDates',argin)
Data = tango_command_inout2(dev,'GetAttScalarDataMinBetweenDates',argin)
Data = tango_command_inout2(dev,'GetAttScalarDataMaxBetweenDates',argin)


%Nombre des donnees archivees
Data = tango_command_inout2(dev,'GetAttScalarDataCount',attr_name)

%Nombre des donnees archivees entre deux dates
date1 = '2004-12-05 16:00:00';
date2 = '2004-12-05 16:30:00';
argin = {attr_name, date1, date2};
Data = tango_command_inout2(dev,'GetAttScalarDataBetweenDatesCount',argin)


%Nombre des donnees archivees entre deux dates Sup a  x
date1 = '2004-12-05 16:00:00';
date2 = '2004-12-05 16:30:00';
valinf = '4';
valsup = '6';

argin = {attr_name, valinf, date1, date2};
Data = tango_command_inout2(dev,'GetAttScalarDataSupThanBetweenDatesCount',argin)

argin = {attr_name, valinf, valsup, date1, date2};
Data = tango_command_inout2(dev,'GetAttScalarDataInfOrSupThanBetweenDatesCount',argin)

argin = {attr_name, valinf, valsup, date1, date2};
Data = tango_command_inout2(dev,'GetAttScalarDataSupAndInfThanBetweenDatesCount',argin)

argin = {attr_name, valsup, date1, date2};
Data = tango_command_inout2(dev,'GetAttScalarDataInfThanBetweenDatesCount',argin)

%% Il faut se debarasser des millisecondes (PAS BESOIN !!!)
% et utiliser la commande de conversion en format numerique
datenum('2004-05-12 12:45:23','yyyy-mm-dd HH:MM:SS')
datenum(Data.svalue,'yyyy-mm-dd HH:MM:SS');

