function savebtsdes
% BTS configuration
% SAVEBTSDES - save current desired setpoints to file
Handles.B7H = mcacheckopen('BTS-B7H:CurrSetptDes');
BTSDESConfig.Values.B7H = mcaget(Handles.B7H);

Handles.B8V = mcacheckopen('BTS-B8V:CurrSetptDes');
BTSDESConfig.Values.B8V = mcaget(Handles.B8V);

Handles.C8H = mcacheckopen('BTS-C8H:CurrSetptDes');
BTSDESConfig.Values.C8H = mcaget(Handles.C8H);
BTSDESConfig.Values.C8H = BTSDESConfig.Values.C8H(1);


Handles.B9V = mcacheckopen('BTS-B9V:CurrSetptDes');
BTSDESConfig.Values.B9V = mcaget(Handles.B9V);


Handles.Q8 = mcacheckopen('BTS-Q8:CurrSetptDes');
BTSDESConfig.Values.Q8 = mcaget(Handles.Q8);

Handles.Q9 = mcacheckopen('BTS-Q9:CurrSetptDes');
BTSDESConfig.Values.Q9 = mcaget(Handles.Q9);

BTSDESConfig.Time = datestr(now);
BTSDESConfig.Desc = 'Desired Setpoint';


dir0 = pwd;

BTSCONFIGDIRECTORY = getfamilydata('Directory','BTS');
cd(BTSCONFIGDIRECTORY);

filename = appendtimestamp('bts_des_config', clock);

[filename, pathname, filterindex] = uiputfile('*.mat', 'Select BTS *DES* save file name', filename);
save(filename,'BTSDESConfig');


cd(dir0)
