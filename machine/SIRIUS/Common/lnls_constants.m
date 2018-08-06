function r = lnls_constants(varargin)

% speed of light
r.c_label = 'speed of light';
r.c             = 299792458;
r.c_uncertainty = 0;
r.c_units = 'm/s';

% electron rest energy
r.E0_label = 'electron rest energy';
r.E0             = 0.51099892811;
r.E0_uncertainty = 0.00000000011;
r.E0_units = 'MeV';

% electron charge
r.q0_label = 'electron charge';
r.q0             = -1.60217656535e-19;
r.q0_uncertainty =  0.00000000035e-19;
r.q0_units = 'C';

% fine-structure constant
r.alpha_label = 'fine-structure constant';
r.alpha             = 7.297352569824e-3;
r.alpha_uncertainty = 0.000000000024e-3;
r.alpha_units = 'unitless';

% planck constant
r.planck_label = 'planck constant';
r.planck = 4.13566751691e-15;
r.planck_units = 'eV.s';