function sirius_comm_write(write_fields)
% sirius_comm_write(write_fields): envia comando de ajuste dos parâmetros definidos na estrutua 'write_fields'.

AD = getad;
if ~isfield(AD, 'PVServer') || ~isfield(AD.PVServer, 'link')
    error('MML is not connected to any sirius PV Server!');
end

msg = ',WRITE,';
fields = fieldnames(write_fields);
for i=1:length(fields)
    msg = [msg upper(fields{i}) ',' sprintf('%.16g',write_fields.(fields{i})) ','];
end

sirius_comm_sendrecv_store_state(msg);

