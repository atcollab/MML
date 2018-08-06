function sirius_comm_read(read_fields)
% sirius_comm_read(read_fields): lê os parâmetros do estado do anel definidos na estrutura 'read_fields'.

AD = getad;
if ~isfield(AD, 'PVServer') || ~isfield(AD.PVServer, 'link')
    error('MML is not connected to any sirius PV Server!');
end

msg = ',READ,';

fields = fieldnames(read_fields);
for i=1:length(fields)
    msg = [msg upper(fields{i}) ','];
end

sirius_comm_sendrecv_store_state(msg);
