function savebts
%BTS configuration
% SAVEBTS - save current setpoint to a file
% see also SETBTS

Handles.B7H = mcacheckopen('BTS-B7H:CurrSetpt');
BTSConfig.Values.B7H = mcaget(Handles.B7H);

Handles.B8V = mcacheckopen('BTS-B8V:CurrSetpt');
BTSConfig.Values.B8V = mcaget(Handles.B8V);

Handles.C8H = mcacheckopen('BTS-C8H:CurrSetpt');
BTSConfig.Values.C8H = mcaget(Handles.C8H);
BTSConfig.Values.C8H = BTSConfig.Values.C8H(1);


Handles.B9V = mcacheckopen('BTS-B9V:CurrSetpt');
BTSConfig.Values.B9V = mcaget(Handles.B9V);


Handles.Q8 = mcacheckopen('BTS-Q8:CurrSetpt');
BTSConfig.Values.Q8 = mcaget(Handles.Q8);

Handles.Q9 = mcacheckopen('BTS-Q9:CurrSetpt');
BTSConfig.Values.Q9 = mcaget(Handles.Q9);

BtsConfig.Time = datestr(now);
BtsConfig.Desc = 'Desired Setpoint';

dir0 = pwd;

BTSCONFIGDIRECTORY = getfamilydata('Directory','BTS');
cd(BTSCONFIGDIRECTORY);

filename = appendtimestamp('btsconfig', clock);

[filename, pathname, filterindex] = uiputfile('*.mat', 'Select BTS save file name', filename);
save(filename,'BTSConfig');
disp(['   BTS Configuration file saved to ' pwd  ' with file name: ' filename]);
cd(dir0)


