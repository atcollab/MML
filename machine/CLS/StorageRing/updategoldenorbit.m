function updategoldenorbit
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/updategoldenorbit.m 1.2 2007/03/02 09:17:38CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% load golden orbit as per restore orbit
% write out
% ----------------------------------------------------------------------------------------------

ad=getad;
load([ad.Directory.OpsData ad.OpsData.BPMGoldenFile '.mat']);
t.BPMxData=BPMxData;
t.BPMyData=BPMyData;

R = input('Enter Plane to Edit (x/y) : ','s');
if strcmpi(R,'x')
    family='BPMx';
else
    family='BPMy';
end

name=getfamilydata(family,'Monitor','ChannelNames',t.([family 'Data']).DeviceList);
elem=dev2elem('BPMx',BPMxData.DeviceList);
value= t.([family 'Data']).Data;

disp(['Initial golden orbit values in ' upper(R) ' plane']);
disp('BPM number   BPM PV Name            BPM Value (micron)')
for ii=1:length(t.([family 'Data']).Status)   
    disp([num2str(elem(ii)) '            ' name(ii,:) '     ' num2str(value(ii)*1e6) ]);
end
disp(' ')
indx = input('Enter BPM number: ');
val= input('Enter new BPM value (IN MICRONS): ');
t.([family 'Data']).Data(indx)=val*1e-6;
value= t.([family 'Data']).Data;

disp(' ')
disp(['New golden orbit values in ' upper(R) ' plane (if you choose to save to disk)']);
disp('BPM number   BPM PV Name           BPM Value (micron)')
for ii=1:length(t.([family 'Data']).Status)
    disp([num2str(elem(ii)) '            ' name(ii,:) '      ' num2str(value(ii)*1e6) ]);
end
disp(' ')
disp('Proposed New golden orbit values listed above...')
disp(' ')

ans = input('Save new Golden Orbit? (y/n):', 's');
if strcmpi(ans,'n')
    return
else
    BPMxData.Data=t.BPMxData.Data;
    BPMyData.Data=t.BPMyData.Data;
    here=pwd;
    cd(ad.Directory.OpsData);
    save 'GoldenBPMOrbit' BPMxData BPMyData
    cd(here)
    disp([' New Golden orbit saved to file ' datestr(clock,'dd-mmm-yyyy HH:MM:SS')])
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/updategoldenorbit.m  $
% Revision 1.2 2007/03/02 09:17:38CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------

