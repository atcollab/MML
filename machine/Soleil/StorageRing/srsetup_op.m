function srsetup_op
%SRSETUP - GUI for doing storage ring setup
% GUI for doing storage ring setup
%
% Written by Laurent S. Nadolski

checkforao;

%Clear previous ORBIT figure
orbfig = findobj(allchild(0),'tag','srsetup'); 

if ~isempty(orbfig), delete(orbfig); end

kmax = 6; % button number

height = 10 + kmax*30 + 30; %670;
a = figure('Color',[0.8 0.8 0.8], ...
    'Interruptible', 'on', ...   
    'HandleVisibility','off', ...
    'MenuBar','none', ...
    'Name', 'Menu ANNEAU SYNCHROTRON SOLEIL', ...
    'NumberTitle','off', ...
    'Units','pixels', ...
    'Position',[5 70 210*3 height], ...
    'Resize','off', ...
    'Tag','srsetup');

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

bn = uicontrol('Parent',a, ...
        'Position',[3 + 210 height-(kmax)*30+5 204 27/2], ...
        'Interruptible', 'off', ...
        'Style','text', 'String', 'En rouge : Action sur le faisceau', 'ForegroundColor', 'r');

set(b1(1), 'Callback','setpathsoleil(''StorageRing'');', 'String','Soleilinit','BackgroundColor','g');
set(b1(2), 'Callback','disp([''   Fichiers de Consignes;'']); configgui;;', 'String','Fichiers de Consignes');
set(b1(3), 'Callback','disp([''   Ringcycling;'']);Ringcycling', 'String','Cyclage');
set(b1(4), 'Callback','bpmconfigurator;', 'String','Configuration BPM');
set(b1(5), 'Callback','synchro_injecteur7;', 'String','Synchronisation');
set(b1(6), 'Callback','plotfamily', 'String','Afficher orbite');

set(b2(1), 'Callback','orbitcontrol', 'String','SOFB (Correction automatique orbite)','ForegroundColor','r');
set(b2(2), 'Callback','solorbit', 'String','Interface experte Correction Orbite','ForegroundColor','r');
set(b2(3), 'Callback','setorbitbumpgui', 'String','Orbit bumps','ForegroundColor','r');
set(b2(4), 'Callback','disp([''   gettune;'']); gettune(''Display'');', 'String','Mesurer nombres d''onde');
set(b2(5), 'Callback','disp([''   steptune;'']); steptune;', 'String','Changer nombres d''onde','ForegroundColor','r');
set(b2(6), 'Callback','disp([''   settune;'']); settune;', 'String','Nombres d''onde Golden','ForegroundColor','r');

set(b3(1), 'Callback','figure; disp([''   lifetime;'']); measlifetime(30,''Display'');', 'String','Mesurer durée de vie');
set(b3(3), 'Callback','figure; disp([''   measdisp;'']); measdisp(''Physics'');', 'String','Mesurer dispersion','ForegroundColor','r');
set(b3(4), 'Callback','figure; disp([''   measchro;'']); measchro(''Physics'');', 'String','Mesurer chromaticités','ForegroundColor','r');
set(b3(5), 'Callback','disp([''   stepchro;'']); stepchro(''Physics'');', 'String','Changer chromaticités','ForegroundColor','r');
set(b3(6), 'Callback','disp([''   setchro;'']); setchro(''Physics'');', 'String','Chromaticités Golden','ForegroundColor','r');
