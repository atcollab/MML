function get_deta()

disp_dir = '/mnts/datafiles/pfiles/xraymodel/xray/xraydata/user/Dispersion'

eta0 = getdisp([disp_dir '/Disp_Model_2005-02-02_15-38-39.mat'])
subplot(3, 1, 1); plot(eta0)
eta1 = getdisp([disp_dir '/Disp_2005-02-01_17-53-14.mat'])
subplot(3, 1, 2); plot(eta1)
deta = eta1 - eta0
subplot(3, 1, 3); plot(deta)