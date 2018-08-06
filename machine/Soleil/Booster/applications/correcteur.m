%  charge correcteurs

Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);

% Correction 23 juillet
%load 'orbit_23-Apr-2006_cor_no_foucault.mat' 'Xm' 'Zm' 'Corr_X' 'Corr_Z';
%setsp('HCOR',Corr_X);setsp('VCOR',Corr_Z);

% % Correction 8 juillet
load 'orbit_2006_1.mat' 'Xm' 'Zm' 'Corr_X' 'Corr_Z';
%setsp('HCOR',Corr_X);setsp('VCOR',Corr_Z);

%load 'orbit_super.mat' 'Xm' 'Zm' 'Corr_X' 'Corr_Z';
%setsp('HCOR',Corr_X);setsp('VCOR',Corr_Z);

cd(pwdold);