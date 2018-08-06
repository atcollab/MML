function alsinfo
%ALSINFO - Prints hypertext for useful websites and commands to the command window

%  Written by Greg Portmann

fprintf('\n   Useful Documents\n');

% % These may not work from with in the ALS control room
% fprintf('   <a href="matlab: web(''http://controls.als.lbl.gov/als_physics/portmann/MiddleLayer/Release/mml/docs/MatlabMiddleLayerManual.htm'');">Matlab Middle Layer (MML) Manual</a>\n');
% fprintf('   <a href="matlab: web(''http://controls.als.lbl.gov/als_physics/portmann/MiddleLayer/Release/mml/docs/MiddleLayerQuickReference.htm'');">Matlab Middle Layer (MML) Quick Reference</a>\n');
% fprintf('   <a href="matlab: web(''http://controls.als.lbl.gov/als_physics/portmann/MiddleLayer/Release/mml/docs/MiddleLayerObjects.htm'');">Matlab Middle Layer (MML) Objects</a>\n');
% fprintf('   <a href="matlab: web(''http://controls.als.lbl.gov/als_physics/portmann/MiddleLayer/Release/mml/doc_html/index.html'');">Matlab Middle Layer (MML) HTML Help</a>\n');
% fprintf('   <a href="matlab: web(''http://controls.als.lbl.gov/als_physics/portmann/MiddleLayer/Release/at/doc_html/index.html'');">Accelerator Toolbox (AT)  HTML Help</a>\n');
% fprintf('   <a href="matlab: web(''http://controls.als.lbl.gov/als_physics/portmann/MiddleLayer/Release/machine/ALS/doc_html/index.html'');">ALS Middle Layer HTML Help</a>\n');

fprintf('   <a href="%s">Matlab Middle Layer (MML) Manual</a>   ',             [getmmlroot, 'mml',filesep,'docs',filesep,'MatlabMiddleLayerManual.htm']);
fprintf('   <a href="%s">Matlab Middle Layer (MML) Quick Reference</a>\n',     [getmmlroot, 'mml',filesep,'docs',filesep,'MiddleLayerQuickReference.htm']);

fprintf('   <a href="%s">Matlab Middle Layer (MML) Objects</a>  ',             [getmmlroot, 'mml',filesep,'docs',filesep,'MiddleLayerObjects.htm']);
fprintf('   <a href="%sindex.html">Matlab Middle Layer (MML) HTML Help</a>\n', [getmmlroot, 'mml',filesep,'doc_html',filesep]);

fprintf('   <a href="%sindex.html">ALS Middle Layer HTML Help</a>         ',          [getmmlroot, 'machine',filesep,'ALS',filesep,'doc_html',filesep]);
fprintf('   <a href="%sindex.html">Accelerator Toolbox (AT)  HTML Help</a>\n', [getmmlroot, 'at', filesep,'doc_html',filesep]);

fprintf('\n   Useful Websites\n');
fprintf('   <a href="http://www.als.lbl.gov">ALS Homepage</a>             ');
fprintf('   <a href="http://http://alsintra.lbl.gov">ALS Intranet</a>             ');
fprintf('   <a href="http://www-als.lbl.gov/olog/olog.php">ALS Online Log</a>\n');

fprintf('   <a href="http://www-als.lbl.gov/als/schedules/current_ltsch.html">ALS Current Schedule</a>     ');
fprintf('   <a href="http://www-als.lbl.gov/als/schedules/next_ltsch.html">ALS Next Schedule</a>        ');
fprintf('   <a href="http://controls.als.lbl.gov/controls/control_room">ALS Control Room</a>\n');

fprintf('   <a href="http://als.lbl.gov/als_physics/website/">ALS Physics</a>              ');
fprintf('   <a href="http://lightsources.org/cms/">LightSources.Org</a>         ');
fprintf('   <a href="http://controls.als.lbl.gov/controls/">ALS Controls</a>\n');

fprintf('   <a href="http://controls.als.lbl.gov/als_physics/performance_reports/weekly">ALS Week Performance Data</a>');
fprintf('   <a href="http://als.lbl.gov/data_access.html">ALS Data Access Facilities</a>\n');

fprintf('\n   Experiment Recipes\n');
fprintf('   <a href="matlab: help quadcenter1of3;">Measuring Quadrupole Centers</a>\n');

fprintf('\n   Useful Commands\n');
fprintf('   <a href="matlab: setpathmml;">setpathmml</a> - Sets the Matlab path for an accelerator (like <a href="matlab: setpathals;">ALS</a> or <a href="matlab: setpathspear3;">Spear3</a>)\n');

fprintf('                Possible ALS Middle Layers: <a href="matlab: setpathals;">Storage Ring</a>, <a href="matlab: setpathals booster;">Booster</a>, or <a href="matlab: setpathals BTS;">BTS</a>\n');

fprintf('   <a href="matlab: setoperationalmode;">setoperationalmode</a> - Change the operational mode (like 1.9, 1.5, 1.23, ... GeV).\n');
fprintf('   <a href="matlab: hwinit;">hwinit</a> - Hardware Initialization\n');
fprintf('   <a href="matlab: srcontrol;">srcontrol</a> - Main ALS storage ring control program\n');
fprintf('   <a href="matlab: plotfamily;">plotfamily</a> - General purpose plotting and application launcher program\n');
fprintf('   <a href="matlab: mmlviewer;">mmlviewer</a> - View the MML setup variables as well as lattice files and online information\n');
fprintf('   <a href="matlab: setorbitgui;">setorbitgui</a> - General SVD orbit correction GUI which calls setorbit\n');
fprintf('   <a href="matlab: setorbitbumpgui;">setorbitbumpgui</a> - Orbit bump GUI which calls setorbitbump\n');
fprintf('   <a href="matlab: plotorbit(''Golden'');">Plot the Orbit w.r.t. the Golden Orbit</a>   <a href="matlab: plotgoldenorbit;">Plot the Golden Orbit</a>\n');
fprintf('   <a href="matlab: plotorbit(''Offset'');">Plot the Orbit w.r.t. the Offset Orbit</a>   <a href="matlab: plotoffsetorbit;">Plot the Offset Orbit</a>\n');
fprintf('   <a href="matlab: plotbpmresp;">Plot the BPM Response Matrix</a>             <a href="matlab: plotorbitdata([getfamilydata(''Directory'',''OpsData''),getfamilydata(''OpsData'',''BPMSigmaFile'')]);">Plot the BPM Standard Deviations</a>\n');
fprintf('   <a href="matlab: plotcm;">Plot the Correctors</a>                      <a href="matlab: plotdisp(''physics'');">Plot the Measured Dispersion Function</a>\n');
fprintf('   <a href="matlab: switch2online;">Online Mode</a>                              <a href="matlab: switch2sim;">Simulation Mode</a>\n');
fprintf('   <a href="matlab: switch2allbpms(''Display'');;">Use All BPMs</a>                             <a href="matlab: switch2bergoz(''Display'');">Bergoz Only BPMs</a>\n');
fprintf('   <a href="matlab: figure;">New Figure Window</a>                        <a href="matlab: close all">Close All Figure Windows</a>\n');

%fprintf('   <a href="matlab: plot(getspos(''BPMx''), getx)">plot the horizontal orbit</a>\n')


fprintf('\n');

