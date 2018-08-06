function result = sirius_meas_orbit_acquisition_timing
% sirius_meas_orbit_acquisition_timing: calcula o intervalo de espera para que o servidor possa atualizar a leitura dos bpms.

fprintf('sirius_meas_orbit_acquisition_timing: measuring orbit acquistion time interval between two valid consecutive readings...\n');

sirius_comm_connect_inputdlg;
nr_readings = 5;

delay = 0;
flag = 0;
while (flag == 0)
    flag = 1;
    for i=1:nr_readings
        orbit1 = sirius_meas_read_orbit; 
        pause(delay);
        orbit2 = sirius_meas_read_orbit;
        delta  = orbit2(:) - orbit1(:);
        flag   = flag * sum(delta.^2);
    end;
    if (flag == 0)
        delay = delay + 0.1;
    end;
end;
    
result = delay;