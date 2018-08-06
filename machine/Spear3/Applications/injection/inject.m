%=============================================================
%program inject
%=============================================================
%inject  sets up the gui interface for injection bump simulation and control program
%subsidiary files are:
%1. inject_maingui.m - contains graphics code
%2. simgui.m - contains trajectory simulation code 

spear3inj;            %AT model with kicker magnets

%Clear previous ORBIT figure
injectfig = findobj(0,'tag','injectfig');
if ~isempty(injectfig) delete(injectfig); end

% *** draw main figure
injectgui('InjectFig');  

injectgui('InjectAxes');
injectgui('UIControls');
injectgui('PlotIcons');
simgui('plotsim_init');                %initialize trajectory plot







