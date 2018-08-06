function sirius_comm_sendrecv_store_state(msg, varargin)
% sirius_comm_sendrecv_store_state(msg, varargin): rotina que envia comando, recebe resposta e registra estatísticas de conexão.

AD = getad;

% checks semaphore and proceeds only when .locked field is clear
% (can OS semaphores be used from within MATLAB ?!)
if AD.PVServer.link.locked, printf('sirius_comm_sendrecv_store_state: waiting semaphore to open...'); end 
while AD.PVServer.link.locked
end
AD.PVServer.link.locked = 1;
setad(AD);

AD.PVServer.link.msg_out = msg;
AD.PVServer.link.out.print(msg);
AD.PVServer.link.out.write(0);
AD.PVServer.link.out.flush();

nr_trials = 1;
while (AD.PVServer.link.in.ready() == 0) 
    nr_trials = nr_trials + 1;
end;
AD.PVServer.link.nr_trials = nr_trials;
AD.PVServer.link.msg_in = char(AD.PVServer.link.in.readLine());


comma_pos = findstr(AD.PVServer.link.msg_in, ',');
for i=1:length(comma_pos)-1
    fields{i} = AD.PVServer.link.msg_in(comma_pos(i)+1:comma_pos(i+1)-1);
end

if isempty(varargin)
    for i=1:(length(fields)-1)/2
        AD.PVServer.state.(fields{2*i-1+1}) = str2double(fields{2*i+1});
    end
else
    % if second argument is defines this routine does not try to convert every other field into double type
    % (usefull for the sirius_READ_OBS command, for example)
    for i=1:(length(fields)-1)/2
        AD.PVServer.state.(fields{2*i-1+1}) = fields{2*i+1};
    end
end;

AD.PVServer.link.locked = 0;
setad(AD);