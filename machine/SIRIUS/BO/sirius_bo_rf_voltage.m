function voltage = sirius_bo_rf_voltage(energy)

voltage_inj = 150e3;
voltage_eje = 950e3;
rho0  = 1.152*50/2/pi;
gamma = energy/511e3;
overvoltage = 1.525;
U0 = 88.5*(0.511e-3*gamma).^4/rho0*1e3;
voltage = min([overvoltage*U0 + voltage_inj, voltage_eje]);
