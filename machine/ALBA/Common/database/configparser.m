return;
disp('A NE PAS EXECUTER');
error('Laurent Nadolski');

dbserver = 'sys/database/2';

%% VIDE LT1 

%% declaration TANGO - A faire une seule fois
% Ajouter un device serveur et les devices associes
className='TangoParser';
deviceName='LT1/VI/CALC-PI.1';
serverName='tangoparser/LT1';

argin = {serverName,deviceName,className};
tango_command_inout(dbserver,'DbAddDevice',argin)

% efface
%tango_command_inout(dbserver,'DbDeleteDevice',deviceName)

% Lire une propriete d'un device
%tango_command_inout2(dbserver,'DbGetDeviceProperty',{deviceName, propertyName});

% cree une propriete de device
% valeur somme pour les pressions
propertyName = 'AttributeNames';
tangoNames= family2tango('PI');
%%
nb = length(tangoNames);

% build list of the type
% x1, attribute1
% x2, attribute2
% ...
% xn, attributen

for k = 1:nb,
    mapping{k} = ['x', num2str(k) ',' tangoNames{k}]
end

argin = {deviceName, '1', propertyName, num2str(nb), mapping{:}};
tango_command_inout2(dbserver,'DbPutDeviceProperty',argin);

propertyName = 'OutputNames';
nameValue = 'meanPressure';
tango_command_inout2(dbserver,'DbPutDeviceProperty',{deviceName, '1', propertyName, '1', nameValue});

%% 2 commands required
% init : fait bugger tout !!!!
%tango_command_inout2(deviceName,'Init');

%% configuration expression
stringExpression = configparser_fn('Mean',nb);
tango_command_inout2(deviceName,'SetExpression',{nameValue, stringExpression});


%% LT1 correcteurs
%% declaration TANGO - A faire une seule fois
% Ajouter un device serveur et les devices associes
className='TangoParser';
deviceName='LT1/AE/CALC-CV.1';
serverName='tangoparser/LT1';

argin = {serverName,deviceName,className};
tango_command_inout(dbserver,'DbAddDevice',argin)

% efface
%tango_command_inout(dbserver,'DbDeleteDevice',deviceName)

% Lire une propriete d'un device
%tango_command_inout2(dbserver,'DbGetDeviceProperty',{deviceName, propertyName});

% cree une propriete de device
% valeur somme pour les pressions
propertyName = 'AttributeNames';
tangoNames= family2tango('CV');
%%
nb = length(tangoNames);

% build list of the type
% x1, attribute1
% x2, attribute2
% ...
% xn, attributen

mapping=[];
for k = 1:nb,
    mapping{k} = ['x', num2str(k) ',' tangoNames{k}]
end

argin = {deviceName, '1', propertyName, num2str(nb), mapping{:}};
tango_command_inout2(dbserver,'DbPutDeviceProperty',argin);

propertyName = 'OutputNames';
nameValue = {'meanCurrent','rmsCurrent'};
tango_command_inout2(dbserver,'DbPutDeviceProperty',{deviceName, '1', propertyName, '2', nameValue{:}});

%% 2 commands required
% init : fait bugger tout !!!!
%tango_command_inout2(deviceName,'Init');

%% configuration expression
stringExpression = configparser_fn('Mean',nb);
tango_command_inout2(deviceName,'SetExpression',{nameValue{1}, stringExpression});
stringExpression = configparser_fn('Rms',nb);
tango_command_inout2(deviceName,'SetExpression',{nameValue{2}, stringExpression});


%% Reconfigure TOUT : bug sir tangoparser arréter

deviceName='LT1/VI/CALC-PI.1';
nameValue = 'meanPressure'; nb = 9;
stringExpression = configparser_fn('Mean',nb);
tango_command_inout2(deviceName,'SetExpression',{nameValue, stringExpression});

 

deviceName='LT1/AE/CALC-CH.1';
nameValue = {'meanCurrent','rmsCurrent'}; nb = 3;
stringExpression = configparser_fn('Mean',nb);
tango_command_inout2(deviceName,'SetExpression',{nameValue{1}, stringExpression});
stringExpression = configparser_fn('Rms',nb);
tango_command_inout2(deviceName,'SetExpression',{nameValue{2}, stringExpression});


deviceName='LT1/AE/CALC-CV.1';
nameValue = {'meanCurrent','rmsCurrent'}; nb = 3;
stringExpression = configparser_fn('Mean',nb);
tango_command_inout2(deviceName,'SetExpression',{nameValue{1}, stringExpression});
stringExpression = configparser_fn('Rms',nb);
tango_command_inout2(deviceName,'SetExpression',{nameValue{2}, stringExpression});

