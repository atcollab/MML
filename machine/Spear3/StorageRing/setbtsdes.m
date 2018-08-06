function setbtsdes
% BTS configuration
% SETBTSDES set CurrSetpt values stored in a file to CurrSetptDes 
% filed for standardizing

BTSCONFIGDIRECTORY = getfamilydata('Directory','BTS');

if nargin==0
BTSCONFIGFILENAME = uigetfile(BTSCONFIGDIRECTORY);
end

if BTSCONFIGFILENAME ==0
    disp('   No BTS configuration loaded')
    return
end

load(fullfile(BTSCONFIGDIRECTORY,BTSCONFIGFILENAME));

Handles.B7H = mcacheckopen('BTS-B7H:CurrSetptDes');
mcaput(Handles.B7H, BTSConfig.Values.B7H);

Handles.B8V = mcacheckopen('BTS-B8V:CurrSetptDes');
mcaput(Handles.B8V,BTSConfig.Values.B8V);

Handles.C8H = mcacheckopen('BTS-C8H:CurrSetptDes');
mcaput(Handles.C8H,BTSConfig.Values.C8H);

Handles.B9V = mcacheckopen('BTS-B9V:CurrSetptDes');
BTSConfig.Values.B9V = mcaput(Handles.B9V,BTSConfig.Values.B9V);

Handles.Q8 = mcacheckopen('BTS-Q8:CurrSetptDes');
mcaput(Handles.Q8, BTSConfig.Values.Q8);

Handles.Q9 = mcacheckopen('BTS-Q9:CurrSetptDes');
mcaput(Handles.Q9,BTSConfig.Values.Q9);

