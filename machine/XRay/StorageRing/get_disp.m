function get_disp()

f0 = 52.886250e6; df = 500.0; alpha = 0.00345;

sub_dir = '/mnts/datafiles/pfiles/xraymodel/xray/xraydata/user';

x1 = load([sub_dir '/BPMx_BPMy_2004-10-19_11-55-21'])
x2 = load([sub_dir '/BPMx_BPMy_2004-10-19_11-56-29'])
x3 = load([sub_dir '/BPMx_BPMy_2004-10-19_11-57-09']);
eta_x = -1e-3*(x2.Data1.Data-x3.Data1.Data)*alpha*f0/df;
eta_y = -1e-3*(x2.Data2.Data-x3.Data2.Data)*alpha*f0/df;

clf reset;
subplot(2,1,1); plot(eta_x); grid;
title('Dispersion'); xlabel('BPM No'); ylabel('\eta_x [m]');

subplot(2,1,2); plot(eta_y); grid;
xlabel('BPM No'); ylabel('\eta_y [m]');