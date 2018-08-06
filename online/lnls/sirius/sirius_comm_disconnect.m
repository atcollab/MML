function sirius_comm_disconnect
% sirius_comm_disconnect: disconecta do servidor de estado do anel UVX do LNLS.

AD = getad;
if isfield(AD, 'PVServer')
    if isfield(AD.PVServer, 'link'), AD.PVServer.link.socket.close(); end
    AD.PVServer = rmfield(AD.PVServer, 'link');
end
setad(AD);


          