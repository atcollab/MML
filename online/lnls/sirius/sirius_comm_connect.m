function sirius_comm_connect(varargin)
% sirius_comm_connect: conecta ao servidor de estado do anel UVX do LNLS.



import java.net.Socket;
import java.io.*;

default_ip_address = '10.0.5.11';
default_ip_port =  '53131';

ip_address = default_ip_address;
ip_port = default_ip_port;
AD = getad;
if isfield(AD, 'PVServer')
    if isfield(AD.PVServer, 'server') && isfield(AD.PVServer.server, 'ip_address'), ip_address = AD.PVServer.server.ip_address; end
    if isfield(AD.PVServer, 'server') && isfield(AD.PVServer.server, 'ip_port'), ip_port = AD.PVServer.server.ip_port; end
    if isfield(AD.PVServer, 'link'), sirius_comm_disconnect; end
end
    
if nargin > 0, ip_address = varargin(1); end
if nargin > 1, ip_port = varargin(2); end

AD.PVServer.server.ip_address = ip_address;
AD.PVServer.server.ip_port = ip_port;

% checks whether machine state server is local. If it is, checks whether it is up. If it is not, runs it.
if (strcmp(AD.PVServer.server.ip_address,'127.0.0.1'))
    disp('sirius_comm_connect: verificando servidor local de estado do anel...');
    dir_init = pwd;
    exe_path = 'C:\Arq\MatlabMiddleLayer\Release\links\siriuslink\cmd_findwindow\';
    cd(exe_path);
    cmd = ['dos(''' 'cmd_findwindow' ' ' 'TFProgFAC' ' ' 'FProgFAC' ''')'];
    [hwnd r] = evalc(cmd);
    if (str2double(hwnd) == 0)
        dos('C:\Arq\Controle\projetos\ProgFAC\ProgFAC.exe &');
    end;
    cd(dir_init);
end

% establishes connection with server
skt = java.net.Socket(AD.PVServer.server.ip_address, str2num(AD.PVServer.server.ip_port));
AD.PVServer.link.socket = skt;
AD.PVServer.link.in = BufferedReader(InputStreamReader(skt.getInputStream()));
AD.PVServer.link.out = PrintWriter(skt.getOutputStream(), true);
AD.PVServer.link.locked = 0;

setad(AD);
