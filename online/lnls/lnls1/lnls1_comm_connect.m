function lnls1_comm_connect(varargin)
% Estabelece conexão com servidor LNLS1LinkS
%
% lnls1_comm_connect 
% ------------------
% Script que estabelece conexão TCP/IP entre o MATLAB e o servidor de
% estado da fonte de luz síncrotron (LNLS1LinkS). Se chamado sem argumentos
% o script usa valores default para os parâmetros da conexão:
%
% server_type = 'REMOTE'
% ip_address  = ''
% ip_port     = '53131'
%
% Histórico
%
% 2011-04-27: dados de conexão são registrados em estruitura PVServer independente do MML (X.R.R.)
% 2010-09-16: comentários iniciais no código.

import java.net.Socket;
import java.io.*;

% default parameters
default_server_type = '';
default_ip_address = '10.0.5.11';
default_ip_port =  '53131';


ip_address = default_ip_address;
ip_port = default_ip_port;
server_type = default_server_type;

% loads connection parameter from appData variable PVServer (if it exists)
PVServer = getappdata(0, 'PVServer');
if ~isempty(PVServer)
    if isfield(PVServer, 'server') && isfield(PVServer.server, 'type'), server_type = PVServer.server.type; end
    if isfield(PVServer, 'server') && isfield(PVServer.server, 'ip_address'), ip_address = PVServer.server.ip_address; end
    if isfield(PVServer, 'server') && isfield(PVServer.server, 'ip_port'), ip_port = PVServer.server.ip_port; end
    if isfield(PVServer, 'link'), lnls1_comm_disconnect; end
end
    
% loads connection parameters from input arguments
if nargin > 0, ip_address = varargin(1); end
if nargin > 1, ip_port = varargin(2); end
if nargin > 2, server_type = varagin(3); end
    
% updates appData structure PVServer with current connection parameters
PVServer.server.type = server_type;
PVServer.server.ip_address = ip_address;
PVServer.server.ip_port = ip_port;

% checks whether machine state server is local. If it is, checks whether it is up. If it is not, runs it.
if (strcmp(PVServer.server.ip_address,'127.0.0.1') && strcmp(PVServer.server.type,'LNLS1Link'))
    disp('lnls1_comm_connect: verificando servidor local de estado do anel...');
    dir_init = pwd;
    exe_path = 'C:\Arq\MatlabMiddleLayer\Release\links\lnls_link\lnls1_link\cmd_findwindow\';
    cd(exe_path);
    cmd = ['dos(''' 'cmd_findwindow' ' ' 'TFLNLS1Link' ' ' 'FLNLS1Link' ''')'];
    [hwnd ~] = evalc(cmd);
    if (str2double(hwnd) == 0)
        dos('C:\Arq\Controle\projetos\LNLS1Link\LNLS1Link.exe &');
    end;
    cd(dir_init);
end

% establishes connection with server
if ~isempty(PVServer.server.ip_address)
    skt = java.net.Socket(PVServer.server.ip_address, str2double(PVServer.server.ip_port));
    PVServer.link.socket = skt;
    PVServer.link.in = BufferedReader(InputStreamReader(skt.getInputStream()));
    PVServer.link.out = PrintWriter(skt.getOutputStream(), true);
    PVServer.link.locked = 0;
    setappdata(0, 'PVServer', PVServer);
end
