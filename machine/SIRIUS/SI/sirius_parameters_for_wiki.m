function sirius_parameters_for_wiki

global THERING;

coupling = 0.01;

ad = getad;
si_lattice_version = ad.OperationalMode(1:3);
si_optics_mode     = ad.OperationalMode(5:7);

mia = findcells(THERING, 'FamName', 'mia');
mib = findcells(THERING, 'FamName', 'mib');
mc  = findcells(THERING, 'FamName', 'mc');
twiss = calctwiss;
twiss.gammax = (1 + twiss.alphax.^2)./twiss.betax;
twiss.gammay = (1 + twiss.alphay.^2)./twiss.betay;
ats = atsummary;
si_horizontal_betatron_tune = twiss.mux(end)/2/pi;
si_vertical_betatron_tune = twiss.muy(end)/2/pi;
sexts = findmemberof('sext');
the_ring = THERING;
for i=1:length(sexts)
    idx = findcells(the_ring, 'FamName', sexts{i});
    the_ring = setcellstruct(the_ring, 'PolynomB', idx, 0, 1, 3);
end
twiss2 = calctwiss(the_ring);

si_horizontal_beam_size_at_center_long_straight_sections = mean(1e6 * sqrt(ats.naturalEmittance * twiss.betax(mia) + (ats.naturalEnergySpread * twiss.etax(mia)).^2));
si_horizontal_beam_size_at_center_short_straight_sections = mean(1e6 * sqrt(ats.naturalEmittance * twiss.betax(mib) + (ats.naturalEnergySpread * twiss.etax(mib)).^2));
si_horizontal_beam_size_at_center_bc_dipoles = mean(1e6 * sqrt(ats.naturalEmittance * twiss.betax(mc) + (ats.naturalEnergySpread * twiss.etax(mc)).^2));
si_vertical_beam_size_at_center_long_straight_sections = mean(1e6 * sqrt(coupling * ats.naturalEmittance * twiss.betay(mia) + (ats.naturalEnergySpread * twiss.etay(mia)).^2));
si_vertical_beam_size_at_center_short_straight_sections = mean(1e6 * sqrt(coupling * ats.naturalEmittance * twiss.betay(mib) + (ats.naturalEnergySpread * twiss.etay(mib)).^2));
si_vertical_beam_size_at_center_bc_dipoles = mean(1e6 * sqrt(coupling * ats.naturalEmittance * twiss.betay(mc) + (ats.naturalEnergySpread * twiss.etay(mc)).^2));

si_horizontal_beam_divergence_at_center_long_straight_sections = mean(1e6 * sqrt(ats.naturalEmittance * twiss.gammax(mia) + (ats.naturalEnergySpread * twiss.etaxl(mia)).^2));
si_horizontal_beam_divergence_at_center_short_straight_sections = mean(1e6 * sqrt(ats.naturalEmittance * twiss.gammax(mib) + (ats.naturalEnergySpread * twiss.etaxl(mib)).^2));
si_horizontal_beam_divergence_at_center_bc_dipoles = mean(1e6 * sqrt(ats.naturalEmittance * twiss.gammax(mc) + (ats.naturalEnergySpread * twiss.etaxl(mc)).^2));
si_vertical_beam_divergence_at_center_long_straight_sections = mean(1e6 * sqrt(coupling * ats.naturalEmittance * twiss.gammay(mia) + (ats.naturalEnergySpread * twiss.etayl(mia)).^2));
si_vertical_beam_divergence_at_center_short_straight_sections = mean(1e6 * sqrt(coupling * ats.naturalEmittance * twiss.gammay(mib) + (ats.naturalEnergySpread * twiss.etayl(mib)).^2));
si_vertical_beam_divergence_at_center_bc_dipoles = mean(1e6 * sqrt(coupling * ats.naturalEmittance * twiss.gammay(mc) + (ats.naturalEnergySpread * twiss.etayl(mc)).^2));

si_horizontal_chromaticity = twiss.CHromx;
si_vertical_chromaticity   = twiss.CHromy;
si_horizontal_natural_chromaticity = twiss2.CHromx;
si_vertical_natural_chromaticity   = twiss2.CHromy;

si_radiation_integral_I1_from_dipoles =  ats.integrals(1);
si_radiation_integral_I2_from_dipoles =  ats.integrals(2);
si_radiation_integral_I3_from_dipoles =  ats.integrals(3);
si_radiation_integral_I4_from_dipoles =  ats.integrals(4);
si_radiation_integral_I5_from_dipoles =  ats.integrals(5);
si_radiation_integral_I6_from_dipoles =  ats.integrals(6);

si_synchrotron_tune_from_dipoles = ats.synctune;
si_synchrotron_tune              = ats.synctune;
 
fprintf(['si_optics_mode = "', si_optics_mode, '"\n']);
fprintf(['si_horizontal_betatron_tune = ', num2str(si_horizontal_betatron_tune, '%.15E'), '\n']);
fprintf(['si_vertical_betatron_tune   = ', num2str(si_vertical_betatron_tune, '%.15E'), '\n']);
fprintf(['si_synchrotron_tune_from_dipoles = ', num2str(si_synchrotron_tune_from_dipoles, '%.15E'), '\n']);
fprintf(['si_synchrotron_tune              = ', num2str(si_synchrotron_tune, '%.15E'), '\n']);
    
fprintf(['si_horizontal_chromaticity         = ', num2str(si_horizontal_chromaticity, '%+.15E'), '\n']);
fprintf(['si_vertical_chromaticity           = ', num2str(si_vertical_chromaticity, '%+.15E'), '\n']);
fprintf(['si_horizontal_natural_chromaticity = ', num2str(si_horizontal_natural_chromaticity, '%+.15E'), '\n']);
fprintf(['si_vertical_natural_chromaticity   = ', num2str(si_vertical_natural_chromaticity, '%+.15E'), '\n']);

fprintf(['si_horizontal_beam_size_at_center_long_straight_sections  = ', num2str(si_horizontal_beam_size_at_center_long_straight_sections,  '%.15E'), ' #[um]\n']);
fprintf(['si_horizontal_beam_size_at_center_short_straight_sections = ', num2str(si_horizontal_beam_size_at_center_short_straight_sections, '%.15E'), ' #[um]\n']);
fprintf(['si_horizontal_beam_size_at_center_bc_dipoles              = ', num2str(si_horizontal_beam_size_at_center_bc_dipoles,              '%.15E'), ' #[um]\n']);

fprintf(['si_vertical_beam_size_at_center_long_straight_sections    = ', num2str(si_vertical_beam_size_at_center_long_straight_sections,    '%.15E'), ' #[um]\n']);
fprintf(['si_vertical_beam_size_at_center_short_straight_sections   = ', num2str(si_vertical_beam_size_at_center_short_straight_sections,   '%.15E'), ' #[um]\n']);
fprintf(['si_vertical_beam_size_at_center_bc_dipoles                = ', num2str(si_vertical_beam_size_at_center_bc_dipoles,                '%.15E'), ' #[um]\n']);

fprintf(['si_horizontal_beam_divergence_at_center_long_straight_sections  = ', num2str(si_horizontal_beam_divergence_at_center_long_straight_sections,  '%.15E'), ' #[urad]\n']);
fprintf(['si_horizontal_beam_divergence_at_center_short_straight_sections = ', num2str(si_horizontal_beam_divergence_at_center_short_straight_sections, '%.15E'), ' #[urad]\n']);
fprintf(['si_horizontal_beam_divergence_at_center_bc_dipoles              = ', num2str(si_horizontal_beam_divergence_at_center_bc_dipoles,              '%.15E'), ' #[urad]\n']);

fprintf(['si_vertical_beam_divergence_at_center_long_straight_sections    = ', num2str(si_vertical_beam_divergence_at_center_long_straight_sections,    '%.15E'), ' #[urad]\n']);
fprintf(['si_vertical_beam_divergence_at_center_short_straight_sections   = ', num2str(si_vertical_beam_divergence_at_center_short_straight_sections,   '%.15E'), ' #[urad]\n']);
fprintf(['si_vertical_beam_divergence_at_center_bc_dipoles                = ', num2str(si_vertical_beam_divergence_at_center_bc_dipoles,                '%.15E'), ' #[urad]\n']);


fprintf(['si_radiation_integral_I1_from_dipoles = ', num2str(si_radiation_integral_I1_from_dipoles, '%+.15E'), ' #[m]\n']);
fprintf(['si_radiation_integral_I2_from_dipoles = ', num2str(si_radiation_integral_I2_from_dipoles, '%+.15E'), ' #[1/m]\n']);
fprintf(['si_radiation_integral_I3_from_dipoles = ', num2str(si_radiation_integral_I3_from_dipoles, '%+.15E'), ' #[1/m^2]\n']);
fprintf(['si_radiation_integral_I4_from_dipoles = ', num2str(si_radiation_integral_I4_from_dipoles, '%+.15E'), ' #[1/m]\n']);
fprintf(['si_radiation_integral_I5_from_dipoles = ', num2str(si_radiation_integral_I5_from_dipoles, '%+.15E'), ' #[1/m]\n']);
fprintf(['si_radiation_integral_I6_from_dipoles = ', num2str(si_radiation_integral_I6_from_dipoles, '%+.15E'), ' #[1/m]\n']);
