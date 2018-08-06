function lnls1_comm_lock
% Trava conexão
%
% lnls1_comm_lock: trava conexão
%
% Histórico
%
% 2011-04-27: dados de conexão são registrados em estruitura PVServer independente do MML (X.R.R.)
% 2010-09-16: comentários iniciais ao código.

PVServer = getappdata(0, 'PVServer');
if ~isempty(PVServer) && isfield(PVServer, 'link')
    PVServer.link.locked = 1;
end
setappdata(0, 'PVServer', PVServer);