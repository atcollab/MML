function Boostersetup
%BoosterSETUP - GUI for doing Booster setup

%
% Written by Laurent S. Nadolski

AD = getad;

if isempty(AD) 
    boosterinit;
elseif ~strcmpi(AD.SubMachine,'Booster')
    Boosterinit;
end

orbfig = findobj(allchild(0),'tag','Boostersetup'); 

if ~isempty(orbfig), delete(orbfig); end
orbfig = findobj(allchild(0),'tag','Boostersetup'); 


kmax = 8; % button number

height = 10 + kmax*30 + 30; %670;
a = figure('Color',[0.8 0.8 0.8], ...
    'Interruptible', 'on', ...   
    'HandleVisibility','off', ...
    'MenuBar','none', ...
    'Name', 'Booster Command Launcher', ...
    'NumberTitle','off', ...
    'Units','pixels', ...
    'Position',[5 70 210*3 height], ...
    'Resize','off', ...
    'Tag','Boostersetup');

height = height - 35;

for k = 1:kmax,
    b1(k) = uicontrol('Parent',a, ...
        'Position',[3 height-(k-1)*30 204 27], ...
        'Interruptible', 'off', ...
        'Tag','button22');
end

for k = 1:kmax,
    b2(k) = uicontrol('Parent',a, ...
        'Position',[3 + 210 height-(k-1)*30 204 27], ...
        'Interruptible', 'off', ...
        'Tag','button22');
end

for k = 1:kmax,
    b3(k) = uicontrol('Parent',a, ...
        'Position',[3 + 210*2 height-(k-1)*30 204 27], ...
        'Interruptible', 'off', ...
        'Tag','button22');
end

set(b1(1), 'Callback','disp([''   Boosterinit;'']); cd(getenv(''MLROOT'')); setpathsoleil(''Booster'');', 'String','Boosterinit');
set(b1(2), 'Callback','disp([''   Fichiers de Consignes;'']); configgui;;', 'String','Fichiers de Consignes');
set(b1(3), 'Callback','disp([''   Timing;'']); synchro_injecteur7;', 'String','Synchronisation définitive');
set(b1(4), 'Callback','save_boo', 'String','Fichier de consigne');
set(b1(5), 'Callback','NombreOnde_AL_DCCT', 'String','Nombres d'' onde');
set(b1(6), 'Callback','tune1', 'String','Réglage injection');
set(b1(7), 'Callback','tango_archiving_config', 'String','Archivage');
set(b1(8), 'Callback','qart_inject', 'String','injection par quart');
set(b2(1), 'Callback','bpmconfigurator;', 'String','Configuration BPM');
set(b2(2), 'Callback','disp([''   orbitX_AT;'']); orbitX_AT;', 'String','orbitX');
set(b2(3), 'Callback','disp([''   orbitZ_AT;'']); orbitZ_AT;', 'String','orbitZ');
set(b2(4), 'Callback','anabpmfirstturn([],''NoDisplay'');', 'String','Orbite premier tour');
set(b2(5), 'Callback','getbpmBN(''Injection'');', 'String','Orbite injection');
set(b2(6), 'Callback','getbpmBN(''Extraction'');', 'String','Orbite extraction');
set(b2(7), 'Callback','ACenergie1;', 'String','AC energie');
set(b2(8), 'Callback','ACtune;', 'String','AC tune');

set(b3(1), 'Callback','plotfamily', 'String','Plotfamily');
