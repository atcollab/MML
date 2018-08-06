function result = sirius_meas_read_orbit
% sirius_meas_read_orbit: lê órbita nos monitores de posição.

AO = getad;
bpm_names = AO.BPMx.CommonNames;

read_msg = struct; 
for i=1:length(bpm_names(:,1))
    read_msg.([bpm_names(i,:) '_H']) = 0;
    read_msg.([bpm_names(i,:) '_V']) = 0;
end

sirius_comm_read(read_msg);

m = zeros(2,size(1,bpm_names));
for i=1:length(bpm_names)
    m(1,i) = sirius.ring.state.([bpm_names(i,:) '_H']);
    m(2,i) = sirius.ring.state.([bpm_names(i,:) '_V']);
end
result = m;