%
return;
dbserver = 'sys/database/2';
res = tango_command_list_query(dbserver)

DbAddDevice
DbAddServer
DbDeleteAttributeAlias
DbDeleteClassAttribute
DbDeleteClassAttributeProperty
DbDeleteClassProperty
DbDeleteDevice
DbDeleteDeviceAlias
DbDeleteDeviceAttribute
DbDeleteDeviceAttributeProperty
DbDeleteDeviceProperty
DbDeleteProperty
DbDeleteServer
DbDeleteServerInfo
DbExportDevice
DbExportEvent
DbGetAliasDevice
DbGetAttributeAlias
DbGetAttributeAliasList
DbGetClassAttributeList
DbGetClassAttributeProperty
DbGetClassList
DbGetClassProperty
DbGetClassPropertyList
DbGetDeviceAliasList
DbGetDeviceAttributeList
DbGetDeviceAttributeProperty
DbGetDeviceClassList
DbGetDeviceDomainList
DbGetDeviceExportedList
DbGetDeviceFamilyList
DbGetDeviceList
DbGetDeviceMemberList
DbGetDeviceProperty
DbGetDevicePropertyList
DbGetDeviceServerClassList
DbGetHostList
DbGetHostServerList
DbGetHostServersInfo
DbGetInstanceNameList
DbGetObjectList
DbGetProperty
DbGetPropertyList
DbGetServerInfo
DbGetServerList
DbGetServerNameList
DbImportDevice
DbImportEvent
DbInfo
DbPutAttributeAlias
DbPutClassAttributeProperty
DbPutClassProperty
DbPutDeviceAlias
DbPutDeviceAttributeProperty
DbPutDeviceProperty
DbPutProperty
DbPutServerInfo
DbUnExportDevice
DbUnExportEvent
DbUnExportServer
Init
State
Status

res = tango_command_inout(dbserver,'DbGetDeviceFamilyList','*')
res = tango_command_inout(dbserver,'DbInfo')
res = tango_command_inout(dbserver,'Status')

%% Ajout d'un device
% Argument minimum: serveur device Class

tango_command_inout(dbserver,'DbAddDevice',{'ds_bpm/bpm1','ANS/DGsim/BPM000','Bpm'})

for k=1:5
    Device = strcat('ANS/DGsim/BPM00',num2str(k))
    tango_command_inout(dbserver,'DbAddDevice',{'ds_bpm/bpm1',Device,'Bpm'})
end

%% Effacer une device de la Database statique
for k=1:5
    Device = strcat('ANS/DGsim/BPM00',num2str(k))
    tango_command_inout(dbserver,'DbDeleteDevice',Device)
end

% Ajouter un device serveur et les devices associes
className='TangoParser';
deviceName='LT1/VI/COMP.3';
serverName='tangoparser/LT1';

argin = {serverName,deviceName,className};
tango_command_inout(dbserver,'DbAddDevice',argin)

% efface
%tango_command_inout(dbserver,'DbDeleteDevice',deviceName)

% Lire une propriete d'un device
tango_command_inout2(dbserver,'DbGetDeviceProperty',{deviceName, propertyName});

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
tango_command_inout2(dbserver,'DbPutDeviceProperty',{deviceName, '1', propertyName, '1', 'diff '});

%% 2 commands required
% init
%tango_command_inout2(deviceName,'Init');

% set expression
stringExpression = [];
for k=1:nb,
    if k ~= nb && k ~= 1
        stringExpression = [stringExpression 'x' num2str(k) '+'];
    elseif k == 1
        stringExpression = ['(' stringExpression 'x' num2str(k) '+'];
    elseif k == nb
        stringExpression = [stringExpression 'x' num2str(k) ') + 54/' num2str(nb)];
    end
end

tango_command_inout2(deviceName,'SetExpression',{'sum', stringExpression});

% tango_command_inout2(deviceName,'GetExpression','meanPressure');

% unexport un device
%tango_command_inout2(dbserver,'DbUnExportDevice','tango/tangoparser/1')

%% Nomenclature vide LT2

%% vide

liste = {
'LT2/VI/PI40.1',
'LT2/VI/PI55.2',
'LT2/VI/PI55.3',
'LT2/VI/PI55.4',
'LT2/VI/PI55.5',
'LT2/VI/PI55.6',
'LT2/VI/PI150.7',
'LT2/VI/PI55.8',
'LT2/VI/PI55.9',
'LT2/VI/PI55.10',
'LT2/VI/PI55.11',
'LT2/VI/PI55.12',
'LT2/VI/PI55.13',
'LT2/VI/PI55.14',
'LT2/VI/PI40.15'
}

serverName = 'ionpump/PI4LT2';
className = 'IonPump';
for k=1:length(liste),
    deviceName = liste{k};
    tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end

serverName = 'penninggauge/JPEN4LT2';
className = 'PenningGauge';
for k=1:3,
    deviceName = ['LT2/VI/JPEN.' num2str(k)];
     tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end


serverName = 'piranigauge/JPIR4LT2';
className = 'PiraniGauge';

for k=1:3,
    deviceName = ['LT2/VI/JPIR.' num2str(k)];
     tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end


liste = {
'LT2/VI/VS40.1',
'LT2/VI/VS63.2',
'LT2/VI/VS40.3'};

serverName = 'vacuumvalve/VS4LT2';
className = 'VacuumValve';
for k=1:length(liste),
    deviceName = liste{k};
    tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end

liste = {
'LT2/AE/D.1',
'LT2/AE/Q.1',
'LT2/AE/Q.2',
'LT2/AE/Q.3',
'LT2/AE/Q.4',
'LT2/AE/Q.5',
'LT2/AE/Q.6',
'LT2/AE/Q.7',
'LT2/AE/CV.1',
'LT2/AE/CV.2',
'LT2/AE/CV.3',
'LT2/AE/CV.4',
'LT2/AE/CV.5',
'LT2/AE/CH.1',
'LT2/AE/CH.2',
'LT2/AE/CH.3'};

serverName = 'ds_magnetsim/magnet4LT2';
className = 'MagnetAlimSim';
for k=1:length(liste),
    deviceName = liste{k};
    tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end

liste = {
'BOO-Binj/VI/PI55.1',
'BOO-Binj/VI/PI55.2',
'BOO-Binj/VI/PI300.3',
'BOO-Binj/VI/PI55.4',
'BOO-Binj/VI/PI55.5',
'BOO-Binj/VI/PI55.6',
'BOO-Binj/VI/PI500.7', 
'BOO-B1/VI/PI55.1',
'BOO-B1/VI/PI55.2',
'BOO-B1/VI/PI55.3',
'BOO-B1/VI/PI55.4',
'BOO-B1/VI/PI55.5',
'BOO-B1/VI/PI55.6',
'BOO-B1/VI/PI55.7',
'BOO-B1/VI/PI55.8',
'BOO-B1/VI/PI55.9',
'BOO-B2/VI/PI55.1',
'BOO-B2/VI/PI55.2',
'BOO-B2/VI/PI55.3',
'BOO-B2/VI/PI55.4',
'BOO-B2/VI/PI55.5',
'BOO-B2/VI/PI55.6',
'BOO-B2/VI/PI55.7',
'BOO-Bext/VI/PI55.1',
'BOO-Bext/VI/PI55.2',
'BOO-Bext/VI/PI300.3',
'BOO-Bext/VI/PI55.4',
'BOO-Bext/VI/PI55.5',
'BOO-Bext/VI/PI55.6',
'BOO-B3/VI/PI55.1',
'BOO-B3/VI/PI55.2',
'BOO-B3/VI/PI55.3',
'BOO-B3/VI/PI55.4',
'BOO-B3/VI/PI55.5',
'BOO-B3/VI/PI55.6',
'BOO-B3/VI/PI55.7',
'BOO-B3/VI/PI55.8',
'BOO-B4/VI/PI55.1',
'BOO-B4/VI/PI55.2',
'BOO-B4/VI/PI55.3',
'BOO-B4/VI/PI55.4',
'BOO-B4/VI/PI55.5',
'BOO-B4/VI/PI55.6',
'BOO-B4/VI/PI55.7'};

serverName = 'ionpump/PI4BOOSTER';
className = 'IonPump';
for k=1:length(liste),
    deviceName = liste{k};
    tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end


liste = {
'BOO-Binj/VI/VS63.1',
'BOO-Binj/VI/VS100.2',
'BOO-B1/VI/VS100.1',
'BOO-B2/VI/VS63.1',
'BOO-Bext/VI/VS63.1',
'BOO-B3/VI/VS63.1',
'BOO-B4/VI/VS63.1'};

serverName = 'vacuumvalve/VS4BOOSTER';
className = 'VacuumValve';
for k=1:length(liste),
    deviceName = liste{k};
    tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end

liste = {
'BOO-B1/VI/JPEN.1',
'BOO-B1/VI/JPEN.2',
'BOO-Binj/VI/JPEN.1',
'BOO-Binj/VI/JPEN.2',
'BOO-B2/VI/JPEN.1',
'BOO-B2/VI/JPEN.2',
'BOO-B2/VI/JPEN.3',
'BOO-Bext/VI/JPEN.1',
'BOO-Bext/VI/JPEN.2',
'BOO-B3/VI/JPEN.1',
'BOO-B3/VI/JPEN.2',
'BOO-B4/VI/JPEN.1',
'BOO-B4/VI/JPEN.2',
'BOO-B4/VI/JPEN.3'};

serverName = 'penninggauge/JPEN4BOOSTER';
className = 'PenningGauge';
for k=1:length(liste),
    deviceName = liste{k};
     tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end

liste = {
'BOO-B1/VI/JPIR.1',
'BOO-Binj/VI/JPIR.1',
'BOO-Binj/VI/JPIR.2',
'BOO-B2/VI/JPIR.1',
'BOO-Bext/VI/JPIR.1',
'BOO-B3/VI/JPIR.1',
'BOO-B4/VI/JPIR.1'};

serverName = 'piranigauge/JPIR4BOOSTER';
className = 'PiraniGauge';
for k=1:length(liste),
    deviceName = liste{k};
     tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end

liste = {
'BOO-B1/VI/VS100.1',
'BOO-Binj/VI/VS63.1',
'BOO-Binj/VI/VS100.2',
'BOO-B2/VI/VS63.1',
'BOO-Bext/VI/VS63.1',
'BOO-B3/VI/VS63.1',
'BOO-B4/VI/VS63.1'};

serverName = 'vacuumvalve/VS4BOOSTER';
className = 'VacuumValve';
for k=1:length(liste),
    deviceName = liste{k};
    tango_command_inout2(dbserver,'DbAddDevice',{serverName,deviceName,className})
%     tango_command_inout(dbserver,'DbDeleteDevice',deviceName);
end

