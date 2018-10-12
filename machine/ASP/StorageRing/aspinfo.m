function alsinfo
%ASPINFO - Prints hypertext for useful websites and commands to the command window
%
%  Written by Greg Portmann

fprintf('\n   Useful Documents\n');

fprintf('   <a href="%s">Matlab Middle Layer (MML) Manual</a>   ',              [getmmlroot, 'mml',filesep,'docs',filesep,'MatlabMiddleLayerManual.htm']);
fprintf('   <a href="%s">Matlab Middle Layer (MML) Quick Reference</a>\n',     [getmmlroot, 'mml',filesep,'docs',filesep,'MiddleLayerQuickReference.htm']);

fprintf('   <a href="%s">Matlab Middle Layer (MML) Objects</a>  ',             [getmmlroot, 'mml',filesep,'docs',filesep,'MiddleLayerObjects.htm']);
fprintf('   <a href="%sindex.html">Matlab Middle Layer (MML) HTML Help</a>\n', [getmmlroot, 'mml',filesep,'doc_html',filesep]);
fprintf('   <a href="%sindex.html">Accelerator Toolbox (AT)  HTML Help</a>\n', [getmmlroot, 'at', filesep,'doc_html',filesep]);

%fprintf('\n   Useful Websites\n');
%fprintf('   <a href="http://www.asp.???">ASP Homepage</a>             ');


%fprintf('   <a href="http://controls.als.lbl.gov/dynamic_pages/incoming/portmann/archiver">ALS Week Performance Data</a>');
%fprintf('   <a href="http://als.lbl.gov/data_access.html">ALS Data Access Facilities</a>\n');

fprintf('\n   Useful Commands\n');
fprintf('   <a href="matlab: setpathmml;">setpathmml</a> - Sets the Matlab path for an accelerator (like <a href="matlab: setpathals;">ALS</a> or <a href="matlab: setpathspear3;">Spear3</a>)\n');

fprintf('                Possible ASP Middle Layers: <a href="matlab: setpathasp;">Storage Ring</a>, <a href="matlab: setpathasp booster;">Booster</a>, <a href="matlab: setpathasp BTS;">BTS</a>, or , <a href="matlab: setpathasp LTB;">LTB</a>\n' ');

fprintf('   <a href="matlab: setoperationalmode;">setoperationalmode</a> - Change the operational mode (like 1.5 GeV or 1.9 GeV).\n');
fprintf('   <a href="matlab: plotfamily;">plotfamily</a> - General purpose plotting and application launcher program\n');
fprintf('   <a href="matlab: mmlviewer;">mmlviewer</a> - View the MML setup variables as well as lattice files\n');
fprintf('   <a href="matlab: setorbitgui;">setorbitgui</a> - General SVD orbit correction application \n');
fprintf('   <a href="matlab: setorbitbumpgui;">setorbitbumpgui</a> - Orbit bump application\n');
fprintf('   <a href="matlab: plotorbit(''Golden'');">Plot the Orbit w.r.t. the Golden Orbit</a>   <a href="matlab: plotgoldenorbit;">Plot the Golden Orbit</a>\n');
fprintf('   <a href="matlab: plotorbit(''Offset'');">Plot the Orbit w.r.t. the Offset Orbit</a>   <a href="matlab: plotoffsetorbit;">Plot the Offset Orbit</a>\n');
fprintf('   <a href="matlab: plotbpmresp;">Plot the BPM Response Matrix</a>             <a href="matlab: plotorbitdata([getfamilydata(''Directory'',''OpsData''),getfamilydata(''OpsData'',''BPMSigmaFile'')]);">Plot the BPM Standard Deviations</a>\n');
fprintf('   <a href="matlab: plotcm;">Plot the Correctors</a>                      <a href="matlab: plotdisp(''physics'');">Plot the Measured Dispersion Function</a>\n');
fprintf('   <a href="matlab: switch2online;">Online Mode</a>                              <a href="matlab: switch2sim;">Simulation Mode</a>\n');
fprintf('   <a href="matlab: switch2allbpms(''Display'');">Use All BPMs</a>                             <a href="matlab: switch2bergoz(''Display'');">Bergoz Only BPMs</a>\n');
fprintf('   <a href="matlab: figure;">New Figure Window</a>                        <a href="matlab: close all">Close All Figure Windows</a>\n');
