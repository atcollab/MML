function lnls1_comm_sendrecv_store_state(msg, varargin)
% Envia comandos ao servidor LNLS1LinkS
%
% lnls1_comm_sendrecv_store_state(msg, varargin): rotina que envia comando, recebe resposta e registra estatísticas de conexão.
%
% Histórico
%
% 2011-04-27: dados de conexão são registrados em estruitura PVServer independente do MML (X.R.R.)
% 2010-09-16: comentários iniciais ao código.


% waits until connection semaphore clears
lnls1_comm_wait_semaphore;

%AD = getad;
%if AD.PVServer.link.locked, fprintf('lnls1_comm_sendrecv_store_state: waiting semaphore to open...'); end 
%while AD.PVServer.link.locked
%end

% locks semaphore
lnls1_comm_lock;
%AD.PVServer.link.locked = 1; 
%setad(AD);

% sends command
PVServer = getappdata(0, 'PVServer');
PVServer.link.msg_out = msg;
PVServer.link.out.println(msg);
PVServer.link.out.flush();

% waits for repply
nr_trials = 1;
while (PVServer.link.in.ready() == 0) 
    nr_trials = nr_trials + 1;
end;

% gets message from server
PVServer.link.nr_trials = nr_trials;
PVServer.link.msg_in = char(PVServer.link.in.readLine());
msg = PVServer.link.msg_in;

% build output structure
comma_pos = findstr(PVServer.link.msg_in, ',');
for i=1:length(comma_pos)-1
    fields{i} = PVServer.link.msg_in(comma_pos(i)+1:comma_pos(i+1)-1);
end

if isempty(varargin)
    for i=1:(length(fields)-1)/2
        PVServer.state.(fields{2*i-1+1}) = str2double(fields{2*i+1});
    end
else
    % if second argument is defined this routine does not try to convert every other field into double type
    % (usefull for the lnls1_READ_OBS command, for example)
    for i=1:(length(fields)-1)/2
        PVServer.state.(fields{2*i-1+1}) = fields{2*i+1};
    end
end;
setappdata(0, 'PVServer', PVServer);

% unlocks semaphore
lnls1_comm_unlock;
