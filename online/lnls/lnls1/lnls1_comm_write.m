function lnls1_comm_write(write_fields)
% lnls1_comm_write(write_fields): envia comando de ajuste dos parâmetros definidos na estrutua 'write_fields'.

PVServer = getappdata(0, 'PVServer');
if isempty(PVServer) || ~isfield(PVServer, 'link')
    error('MML is not connected to any LNLS1 PV Server!');
end    

msg = ',WRITE,';
fields = fieldnames(write_fields);
for i=1:length(fields)
    msg = [msg upper(fields{i}) ',' sprintf('%.16g',write_fields.(fields{i})) ','];
end

lnls1_comm_sendrecv_store_state(msg);

