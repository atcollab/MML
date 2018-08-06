function sirius_set_delays(Mode)

AD = getad;

if strcmpi(Mode, 'AT') || strcmpi(Mode, 'Simulator') || strcmpi(Mode, 'Model') 
    AD.TuneDelay = 0;
    AD.SIRIUSParams.control_system_update_period = 0;
    AD.SIRIUSParams.bpm_nr_points_average = 1;    
elseif strcmpi(Mode, 'VA') || strcmpi(Mode, 'VACA')
    AD.TuneDelay = 2;
    AD.SIRIUSParams.control_system_update_period = 1;
    AD.SIRIUSParams.bpm_nr_points_average = 1;
end

setad(AD);

end