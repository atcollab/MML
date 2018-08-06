function sirius_comm_connect_inputdlg
% sirius_comm_connect_inputdlg: estabelece comunicação com servidor de estado do anel usando GUI.


return % TEMPORARY

servers = {'(NO CONNECTION)', 'OPR11' , 'OPR1', 'Local Computer'};
[r ok] = listdlg('Name', 'sirius PV Server Connection', 'PromptString', 'Select PV Server:', 'ListSize', [200 60], 'SelectionMode', 'single', 'ListString', servers);

if (~ok || (r==0) || (r==1))
    return;
else
    AD = getad;
    if r==2
        AD.PVServer.server.ip_address = '10.0.5.11'; % READ ONLY
    elseif r==3
        AD.PVServer.server.ip_address = '10.0.5.2'; % READ AND WRITE
    elseif r==4
        AD.PVServer.server.ip_address = '127.0.0.1'; % READ ONLY
    end
end
AD.PVServer.server.ip_port    = '53131';
setad(AD);
sirius_comm_connect;