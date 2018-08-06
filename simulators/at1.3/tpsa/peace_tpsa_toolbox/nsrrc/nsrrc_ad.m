function AD = nsrrc_ad
% AD = nsrrc_ad
% Return the Accelerator Data of NSRRC/TLS
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: Apr-30-2004
% Updated Date: 07-Jul-2004
% Source Files: TPSA/LieAlgebra/tps_variable.m
%-------------------------------------------------------------------------------
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%  Lie Algebra (LA)
%-------------------------------------------------------------------------------
% Description:
%  Accelerator Data (AD) of NSRRC/TLS
%------------------------------------------------------------------------------

%=====================================================
% load AcceleratorData (AD) structure
%=====================================================
%setad([]);       % clear AcceleratorData memory
%=====================================================
% Physics parameters
AD.pi               = 3.1415926535897932384626433;
AD.CLight           = 299792458; % speed of light [m/s]
AD.q_e              = 1.6021892e-19; % electron charge magnitude = 1.6021892(46)e-19 coulomb
AD.e_massMeV        = 0.5110034; % 0.5110034(14) MeV/c^2
AD.mass_e           = 9.109534e-31; % 9.109534(47)e-28 g
AD.p_massMeV        = 938.2796; % 938.2796(27) MeV/c^2
AD.mass_p           = 1.6726485e-21; % 1.6726485(86)e-24 g
AD.eV2erg           = 1.6021892e-12;
AD.GeV2joule        = 1.6021892e-10;
AD.GeV2TeslaMeter   = AD.GeV2joule;
AD.e_particle       = -1; % charge of electron
AD.p_particle       = 1;
% Machine Parameters
AD.bending_angle    = AD.pi/9.0; % bending angle of NSRRC/TLS storage bending magnets
AD.particle         = AD.e_particle; % electron
AD.Machine          = 'NSRRC';
AD.ATModel          = 'nsrrc2004';
AD.MCF              = 0.0063; % NSRRC
AD.InjEnergy        = 1.5;
AD.Energy           = 1.5; % (GeV) NSRRC
AD.BRho             = AD.particle*sqrt(AD.Energy^2-AD.e_massMeV^2*1.0e-6)*(AD.GeV2TeslaMeter/AD.CLight/AD.q_e);
AD.EnergyUpdateFlag = 0;
%s = findspos(THERING,1:length(THERING)+1)';
%AD.Circumference    = s(end); % spear3 (2.341440127200002e+2) nsrrc tls (1.2e+2)
%AD.TRev             = AD.Circumference/AD.CLight;
%AD.FRev             = 1/AD.TRev;
%AD.Emittance        = 18.6e-09;
%AD.Coupling         = 0.01;
%AD.Frequency        = 476.300;
%AD.EnergySpread     = 0.0097;
%AD.BetaxID          = 10.16;
%AD.BetayID          = 4.73;
%AD.BDipole          = 1.27;
%AD.RhoDipole        = 7.86;
%AD.ECrit            = 7.62e+03;
%AD.ELoss            = 912e+03;
%AD.RFVolts          = 3.2e+06;
%AD.DesignTune       = [14.19; 5.23; 0.008];    %Golden tune contained in 'TUNE' Family
%AD.PhiSynchDeg      = 163;
%AD.PhiSynchRad      = 163*pi/180;
AD.BPMDelay         = 0.25;  % use [N, BPMDelay]=getbpmsaverages (AD.BPMDelay will disappear)
AD.TuneDelay        = 0.0; % delay for Tune processor (sec)  ???
% Directories (system dependent)
AD.Directory.OpsData  = 'C:\MATLAB6p5\toolbox\accelerator\acceleratorcontrol\nsrrcopsdata\';
AD.Directory.DataRoot = 'C:\MATLAB6p5\toolbox\accelerator\acceleratorcontrol\nsrrcdata\';
% Data Archive Directories
AD.Directory.BPMData        = [AD.Directory.DataRoot 'BPM\'];
AD.Directory.TuneData       = [AD.Directory.DataRoot 'Tune\'];
AD.Directory.ChroData       = [AD.Directory.DataRoot 'Chromaticity\'];
AD.Directory.DispData       = [AD.Directory.DataRoot 'Dispersion\'];
AD.Directory.ConfigData     = [AD.Directory.DataRoot 'MachineConfig\'];
% Response Matrix Directories
AD.Directory.BPMResponse    = [AD.Directory.DataRoot 'Response\BPM\'];
AD.Directory.TuneResponse   = [AD.Directory.DataRoot 'Response\Tune\'];
AD.Directory.ChroResponse  =  [AD.Directory.DataRoot 'Response\Chromaticity\'];
AD.Directory.DispResponse   = [AD.Directory.DataRoot 'Response\Dispersion\'];
AD.Directory.SkewResponse   = [AD.Directory.DataRoot 'Response\Skew\'];
% Default Data File Prefix
AD.Default.BPMArchiveFile   = 'BPM';       % file in AD.Directory.BPM              orbit data
AD.Default.TuneArchiveFile  = 'Tune';      % file in AD.Directory.Tune             tune data
AD.Default.ChroArchiveFile  = 'Chro';      % file in AD.Directory.Chromaticity     chromaticity data
AD.Default.DispArchiveFile  = 'Disp';      % file in AD.Directory.Dispersion       dispersion data
AD.Default.CNFArchiveFile   = 'CNF';       % file in AD.Directory.CNF              configuration data
% Default Response Matrix File Prefix
AD.Default.BPMRespFile    = 'BPMRespMat';      % file in AD.Directory.BPMResponse       BPM response matrices
AD.Default.TuneRespFile   = 'TuneRespMat';     % file in AD.Directory.TuneResponse      tune response matrices
AD.Default.ChroRespFile   = 'ChroRespMat';     % file in AD.Directory.ChroResponse      chromaticity response matrices
AD.Default.DispRespFile   = 'DispRespMat';     % file in AD.Directory.DispResponse      dispersion response matrices
AD.Default.SkewRespFile   = 'SkewRespMat';     % file in AD.Directory.SkewResponse      skew quadrupole response matrices
% Operational Files
AD.OpsData.LatticeFile    = 'GoldenConfig';     % Golden Configuration File (setup for users)
AD.OpsData.PhysDataFile   = 'GoldenPhysData';
% Operational Response Files
AD.OpsData.BPMRespFile    = 'goldenbpmresp';     % sp3respmat;
AD.OpsData.TuneRespFile   = 'goldentuneResp';    % sp3tunemat;
AD.OpsData.ChroRespFile   = 'goldenchroResp';    % sp3chromfile
AD.OpsData.DispRespFile   = 'goldendispResp';
AD.OpsData.SkewRespFile   = 'goldenskewResp';
AD.OpsData.RespFiles      = { AD.OpsData.BPMRespFile, ...
                              AD.OpsData.TuneRespFile, ...
                              AD.OpsData.ChroRespFile, ...
                              AD.OpsData.DispRespFile, ...
                              AD.OpsData.SkewRespFile };
% NSRRC/TLS Storage Ring's Magnets and Power Supplies
% Combined Function Bending magnets --- 12 data pairs --- magnet * 18
AD.DM.device = {'rcdps'}; % RCDPS
AD.DM.Mode = 1; % Convert by Table
AD.DM.PS = [0 146.439 340.934 535.757 730.486 827.679 876.938 940.002 974.425 1071.468 1168.572 1200]; % Power supply (Amp) 952.752304
AD.DM.B0L = [0 -0.24875 -0.57342 -0.89743 -1.21531 -1.36635 -1.43647 -1.51468 -1.55212 -1.64438 -1.72412 -1.75627]; % Bending magnet (T-M) -1.537024493
AD.DM.B1L = [0 0.32648 0.7559 1.18394 1.59819 1.7908 1.87823 1.97319 2.01744 2.12478 2.21154 2.25284]; % Combined function bending magnet (Quadrupole) (T)
% Quadrupoles
% QD1 --- 16 data pairs --- magnets * 12
% Q1.device = {'rcqps1'}; % RCQPS1
AD.Q1.device = {'r61qps1'; 'r12qps1'; 'r23qps1'; 'r34qps1'; 'r45qps1'; 'r56qps1'}; % R61QPS1, R12QPS1, R23QPS1, R34QPS1, R45QPS1, R56QPS1
AD.Q1.Mode = 1; % Convert by Table
AD.Q1.PS = [0 37.992 45.612 53.232 60.864 68.484 76.102 78.832 83.714 91.338 98.954 101.4 106.578 114.19 121.832 125.148];
AD.Q1.B1L = [0 0.92027 1.10031 1.28033 1.46082 1.64092 1.82051 1.88506 1.9993 2.17885 2.3563 2.41282 2.53237 2.70645 2.87743 2.95014]; % T
% QF2 --- 11 data pairs ---  magnets * 12
% AD.Q2.device = {'rcqps2'}; % RCQPS2
AD.Q2.device = {'r61qps2'; 'r12qps2'; 'r23qps2'; 'r34qps2'; 'r45qps2'; 'r56qps2'}; % R61QPS2, R12QPS2, R23QPS2, R34QPS2, R45QPS2, R56QPS2
AD.Q2.Mode = 1; % Convert by Table
AD.Q2.PS = [0 30.368 50.492 78.832 101.4 125.148 152.308 188.89 202.93 223.366 250];
AD.Q2.B1L = [0 -0.7422 -1.2191 -1.8902 -2.4236 -2.9838 -3.6182 -4.45781 -4.7703 -5.2001 -5.64333];
% QD3 --- 16 data pairs --- magnets * 12
% AD.Q3.devic = {'rcqps3'}; % RCQPS3
AD.Q3.devices = {'r61qps3'; 'r12qps3'; 'r23qps3'; 'r34qps3'; 'r45qps3'; 'r56qps3'}; % R61QPS3, R12QPS3, R23QPS3, R34QPS3, R45QPS3, R56QPS3
AD.Q3.Mode = 1; % Convert by Table
AD.Q3.PS = AD.Q1.PS; % = [0 37.992 45.612 53.232 60.864 68.484 76.102 78.832 83.714 91.338 98.954 101.4 106.578 114.19 121.832 125.148];
AD.Q3.B1L = [0 0.65171 0.77939 0.90677 1.03485 1.16202 1.28936 1.33501 1.41628 1.54273 1.66844 1.70846 1.79277 1.91567 2.03608 2.08703]; % T
% QF4 --- 11 data pairs ---  magnets * 12
AD.Q4.device = {'rcqps4'}; % RCQPS4
AD.Q4.Mode = 1; % Convert by Table
AD.Q4.PS = AD.Q2.PS; % = [0 30.368 50.492 78.832 101.4 125.148 152.308 188.89 202.93 223.366 250];
AD.Q4.B1L = AD.Q2.B1L; % = [0 -0.7422 -1.2191 -1.8902 -2.4236 -2.9838 -3.6182 -4.45781 -4.7703 -5.2001 -5.64333];
% Sextupoles
% SD --- 12 data pairs --- magnets * 12
AD.SD.device = {'rcsdps'}; % RCSDPS
AD.SD.Mode = 1; % Convert by Table
AD.SD.PS = [0 29.717 49.052 78.537 98.260 116.838 146.246 181.667 195.465 214 233.547 250]; % Amp
AD.SD.B2L = [0 4.9511 8.0323 12.7231  15.8477 18.7722 23.3264 28.6294 30.5427 32.7048 34.4581 36.492]; % T/M
% SF --- 12 data pairs --- magnets * 12
AD.SF.device = {'rcsfps'}; % RCSFPS
AD.SF.Mode = 1; % Convert by Table
AD.SF.PS = AD.SD.PS;
AD.SF.B2L = -AD.SD.B2L;
% Correctors
% Horizontal Correctors (HCOR)
AD.HCOR.Mode = 0; % Convert by Scaling
AD.HCOR.C_type.I2B0L = 6.04484402e-4; % Type C (independent) T-M/Amp (R1HC1 R1HC2 R1HCU R2HCU R2HC1 R2HC2 R3HC1 R3HC2 R4HC1 R4HC2 R5HC1 R5HC2 R6HC1 R6HC2)
AD.HCOR.C_type.B0L2I = 1/AD.HCOR.C_type.I2B0L;
AD.HCOR.A_type.I2B0L = 3.36e-4; % Type A (combined) T-M/Amp (R1HC1A R1HC3 R2HC0 R2HC1A R2HC3 R3HC0 R3HC1A R3HC3 R4HC3 R5HC0 R5HC1A R5HC3 R6HC0 R6HC1A)
AD.HCOR.A_type.B0L2I = 1/AD.HCOR.A_type.I2B0L;
AD.HCOR.SF_type.I2B0L = 3.9460603e-4; %  Type SF (trim) T-M/Amp (RxHCSFx)
AD.HCOR.SF_type.B0L2I = 1/AD.HCOR.SF_type.I2B0L;
AD.HCOR.a48_type.I2B0L = 2.24e-4; % Type a48 (combined) T-M/Amp (R1HC2A R2HC2A R4HC0 R4HC0A R4HC2A R5HC2A)
AD.HCOR.a48_type.B0L2I = 1/AD.HCOR.a48_type.I2B0L;
AD.HCOR.c40_type.I2B0L = 1.879528e-3; % Type c40 (independent) T-M/Amp (R1HC0 R1HC0A)
AD.HCOR.c40_type.B0L2I = 1/AD.HCOR.c40_type.I2B0L;
AD.HCOR.a1_type.I2B0L = 3.031977e-3; % Type a1 (combined) T-M/Amp (R6HC4)
AD.HCOR.a1_type.B0L2I = 1/AD.HCOR.a1_type.I2B0L;
%AD.HCOR.PS = { ... };
%AD.HCOR.B0L = { ... };
HW2PhysicsGain = 1.;
Physics2HWGain = 1./HW2PhysicsGain;
% HW in ampere, Physics in radian        ** radian units converted to ampere below ***
% common(MGN/magnet-name)    monitor/setpoint(PS/device-name)  stat  devlist elem range(ampere) tol  kick  H2Pgain P2Hgain  H2P    P2H
AD.HCOR.LIST = {
 'R1HC0'   'RCHCPS10'   1  [1, 1]  1   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain  AD.HCOR.c40_type.I2B0L  AD.HCOR.c40_type.B0L2I; ...
 'R1HC0A'  'RCHCPS10A'  1  [1, 2]  2   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.c40_type.I2B0L  AD.HCOR.c40_type.B0L2I; ...
 'R1HC1'   'RCHCPS11'   1  [1, 3]  3   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R1HC1A'  'RCHCPS11A'  1  [1, 4]  4   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R1HCSF1' 'RCHCSPS11'  1  [1, 5]  5   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R1HCSF2' 'RCHCSPS12'  1  [1, 6]  6   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R1HC2A'  'RCHCPS12A'  1  [1, 7]  7   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.a48_type.I2B0L  AD.HCOR.a48_type.B0L2I; ...
 'R1HC2'   'RCHCPS12'   1  [1, 8]  8   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R1HC3'   'RCHCPS13'   1  [1, 9]  9   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R2HC0'   'RCHCPS20'   1  [2, 1]  10  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R2HC1'   'RCHCPS21'   1  [2, 2]  11  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R2HC1A'  'RCHCPS21A'  1  [2, 3]  12  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R2HCSF1' 'RCHCSPS21'  1  [2, 4]  13  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R2HCSF2' 'RCHCSPS22'  1  [2, 5]  14  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R2HC2A'  'RCHCPS22A'  1  [2, 6]  15  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.a48_type.I2B0L  AD.HCOR.a48_type.B0L2I; ...
 'R2HC2'   'RCHCPS22'   1  [2, 7]  16  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R2HC3'   'RCHCPS23'   1  [2, 8]  17  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R3HC0'   'RCHCPS30'   1  [3, 1]  18  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R3HC1'   'RCHCPS31'   1  [3, 2]  19  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R3HC1A'  'RCHCPS31A'  1  [3, 3]  20  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R3HCSF1' 'RCHCSPS31'  1  [3, 4]  21  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R3HCSF2' 'RCHCSPS32'  1  [3, 5]  22  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R3HC2'   'RCHCPS32'   1  [3, 6]  23  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R3HC3'   'RCHCPS33'   1  [3, 7]  24  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R4HC0'   'RCHCPS40'   1  [4, 1]  25  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.a48_type.I2B0L  AD.HCOR.a48_type.B0L2I; ...
 'R4HC0A'  'RCHCPS40A'  1  [4, 2]  26  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.a48_type.I2B0L  AD.HCOR.a48_type.B0L2I; ...
 'R4HC1'   'RCHCPS41'   1  [4, 3]  27  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R4HCSF1' 'RCHCSPS41'  1  [4, 4]  28  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R4HCSF2' 'RCHCSPS42'  1  [4, 5]  29  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R4HC2A'  'RCHCPS42A'  1  [4, 6]  30  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.a48_type.I2B0L  AD.HCOR.a48_type.B0L2I; ...
 'R4HC2'   'RCHCPS42'   1  [4, 7]  31  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R4HC3'   'RCHCPS43'   1  [4, 8]  32  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R5HC0'   'RCHCPS50'   1  [5, 1]  33  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R5HC1'   'RCHCPS51'   1  [5, 2]  34  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R5HC1A'  'RCHCPS51A'  1  [5, 3]  35  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R5HCSF1' 'RCHCSPS51'  1  [5, 4]  36  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R5HCSF2' 'RCHCSPS52'  1  [5, 5]  37  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R5HC2A'  'RCHCPS52A'  1  [5, 6]  38  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.a48_type.I2B0L  AD.HCOR.a48_type.B0L2I; ...
 'R5HC2'   'RCHCPS52'   1  [5, 7]  39  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R5HC3'   'RCHCPS53'   1  [5, 8]  40  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R6HC0'   'RCHCPS60'   1  [6, 1]  41  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R6HC1'   'RCHCPS61'   1  [6, 2]  42  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R6HC1A'  'RCHCPS61A'  1  [6, 3]  43  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.A_type.I2B0L    AD.HCOR.A_type.B0L2I; ...
 'R6HCSF1' 'RCHCSPS61'  1  [6, 4]  44  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R6HCSF2' 'RCHCSPS62'  1  [6, 5]  45  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.SF_type.I2B0L   AD.HCOR.SF_type.B0L2I; ...
 'R6HC2'   'RCHCPS62'   1  [6, 6]  46  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.C_type.I2B0L    AD.HCOR.C_type.B0L2I; ...
 'R6HC4'   'RCHCPS64'   1  [6, 7]  47  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.HCOR.a1_type.I2B0L   AD.HCOR.a1_type.B0L2I; ...
};
for ii=1:size(AD.HCOR.LIST,1)
AD.HCOR.device{ii} = AD.HCOR.LIST{ii,2};
%47 {
%9 'RCHCPS10';'RCHCPS10A';'RCHCPS11';'RCHCPS11A';'RCHCSPS11';'RCHCSPS12';'RCHCPS12A';'RCHCPS12';'RCHCPS13'; ...
%8 'RCHCPS20';'RCHCPS21';'RCHCPS21A';'RCHCSPS21';'RCHCSPS22';'RCHCPS22A';'RCHCPS22';'RCHCPS23'; ...
%7 'RCHCPS30';'RCHCPS31';'RCHCPS31A';'RCHCSPS31';'RCHCSPS32';'RCHCPS32'; 'RCHCPS32'; ...
%8 'RCHCPS40';'RCHCPS40A';'RCHCPS41';'RCHCSPS41';'RCHCSPS42';'RCHCPS42A';'RCHCPS42';'RCHCPS43'; ...
%8 'RCHCPS50';'RCHCPS51';'RCHCPS51A';'RCHCSPS51';'RCHCSPS52';'RCHCPS52A';'RCHCPS52';'RCHCPS53'; ...
%7 'RCHCPS60';'RCHCPS61';'RCHCPS61A';'RCHCSPS61';'RCHCSPS62';'RCHCPS62';'RCHCPS64' ...
%};
end
% Vertical correctors (VCOR)
AD.VCOR.Mode = 0; % Convert by Scaling
AD.VCOR.B_type.I2B0L = -3.58180858e-4; % Type B (independent) T-M/Amp (R1VC2 R2VC2 R3EPBM1 R3VC2 R3EPBM3 R3EPBM4 R4VC2 R4VC3 R5VC1 R6VC2 R6VC3)
AD.VCOR.B_type.B0L2I = 1/AD.VCOR.B_type.I2B0L;
AD.VCOR.A_type.I2B0L = -3.25e-4; % Type A (combined) T-M/Amp (R1VC1 R1VC3 R2VC1 R2VC1A R2VC3 R3VC1 R3VC1A R3VC3 R4VC4 R5VC0 R5VC1A R5VC3 R6VC1 R6VC1A)
AD.VCOR.A_type.B0L2I = 1/AD.VCOR.A_type.I2B0L;
AD.VCOR.SD_type.I2B0L = -4.62686411e-4; % Type SD (trim) T-M/Amp (RyVCSDy)
AD.VCOR.SD_type.B0L2I = 1/AD.VCOR.SD_type.I2B0L;
AD.VCOR.a48_type.I2B0L = -2.19e-4; % Type a48 (combined) T-M/Amp (R1VC3A R2VC3A R4VC0 R4VC1 R4VC3A R5VC3A)
AD.VCOR.a48_type.B0L2I =1/AD.VCOR.a48_type.I2B0L;
AD.VCOR.a1_type.I2B0L = -2.88741e-4; % Type a1 (combined) T-M/Amp (R6VC5)
AD.VCOR.a1_type.B0L2I = 1/AD.VCOR.a1_type.I2B0L;
AD.VCOR.b1_type.I2B0L = -2.90928e-4; % Type b1 (independent, 42 mm -> R5VC2) T-M/Amp (R1VC0 R1VC0A R5VC2)
AD.VCOR.b1_type.B0L2I = 1/AD.VCOR.b1_type.I2B0L;
AD.VCOR.H40_type.I2B0L = -5.4e-4; % Type H40 T-M/Amp (R2VC4 R6VC0)
AD.VCOR.H40_type.B0L2I = 1/AD.VCOR.H40_type.I2B0L;
AD.VCOR.h32_type.I2B0L = -4.6e-4; % Type h32 T-M/Amp (R3VC0)
AD.VCOR.h32_type.B0L2I = 1/AD.VCOR.h32_type.I2B0L;
AD.VCOR.h20_type.I2B0L = -2.3e-4; % Type h20 T-M/Amp (R5VC4)
AD.VCOR.h20_type.B0L2I = 1/AD.VCOR.h20_type.I2B0L;
%AD.VCOR.PS = { ... };
%AD.VCOR.B0L = { ... };
HW2PhysicsGain = 1.;
Physics2HWGain = 1./HW2PhysicsGain;
% HW in ampere, Physics in radian        ** radian units converted to ampere below ***
% common(MGN/magnet-name)    monitor/setpoint(PS/device-name)  stat  devlist elem range(ampere) tol  H2Pgain  P2Hgain   H2P   P2H
AD.VCOR.LIST = {
 'R1VC0'   'RCVCPS10'   1  [1, 1]  1   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.b1_type.I2B0L   AD.VCOR.b1_type.B0L2I; ...
 'R1VC0A'  'RCVCPS10A'  1  [1, 2]  2   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.b1_type.I2B0L   AD.VCOR.b1_type.B0L2I; ...
 'R1VC1'   'RCVCPS11'   1  [1, 3]  3   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R1VCSD1' 'RCVCSPS11'  1  [1, 4]  4   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R1VC2'   'RCVCPS12'   1  [1, 5]  5   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.B_type.I2B0L    AD.VCOR.B_type.B0L2I; ...
 'R1VCSD2' 'RCVCSPS12'  1  [1, 6]  6   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R1VC3A'  'RCVCPS13A'  1  [1, 7]  7   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.a48_type.I2B0L  AD.VCOR.a48_type.B0L2I; ...
 'R1VC3'   'RCVCPS13'   1  [1, 8]  8   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R2VC1'   'RCVCPS21'   1  [2, 1]  9   [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R2VC1A'  'RCVCPS21A'  1  [2, 2]  10  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R2VCSD1' 'RCVCSPS21'  1  [2, 3]  11  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R2VC2'   'RCVCPS22'   1  [2, 4]  12  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.B_type.I2B0L    AD.VCOR.B_type.B0L2I; ...
 'R2VCSD2' 'RCVCSPS22'  1  [2, 5]  13  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R2VC3A'  'RCVCPS23A'  1  [2, 6]  14  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.a48_type.I2B0L  AD.VCOR.a48_type.B0L2I; ...
 'R2VC3'   'RCVCPS23'   1  [2, 7]  15  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R2VC4'   'RCVCPS24'   1  [2, 8]  16  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.H40_type.I2B0L  AD.VCOR.H40_type.B0L2I; ...
 'R3VC0'   'RCVCPS30'   1  [3, 1]  17  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.h32_type.I2B0L  AD.VCOR.h32_type.B0L2I; ...
 'R3VC1'   'RCVCPS31'   1  [3, 2]  18  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R3VC1A'  'RCVCPS31A'  1  [3, 3]  19  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R3VCSD1' 'RCVCSPS31'  1  [3, 4]  20  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R3VC2'   'RCVCPS32'   1  [3, 5]  21  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.B_type.I2B0L    AD.VCOR.B_type.B0L2I; ...
 'R3VCSD2' 'RCVCSPS32'  1  [3, 6]  22  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R3VC3'   'RCVCPS33'   1  [3, 7]  23  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R4VC0'   'RCVCPS40'   1  [4, 1]  24  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.a48_type.I2B0L  AD.VCOR.a48_type.B0L2I; ...
 'R4VC1'   'RCVCPS41'   1  [4, 2]  25  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.a48_type.I2B0L  AD.VCOR.a48_type.B0L2I; ...
 'R4VCSD1' 'RCVCSPS41'  1  [4, 3]  26  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R4VC2'   'RCVCPS42'   1  [4, 4]  27  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.B_type.I2B0L    AD.VCOR.B_type.B0L2I; ...
 'R4VCSD2' 'RCVCSPS42'  1  [4, 5]  28  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R4VC3A'  'RCVCPS43A'  1  [4, 6]  29  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.a48_type.I2B0L  AD.VCOR.a48_type.B0L2I; ...
 'R4VC3'   'RCVCPS43'   1  [4, 7]  30  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.B_type.I2B0L    AD.VCOR.B_type.B0L2I; ...
 'R4VC4'   'RCVCPS44'   1  [4, 8]  31  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R5VC0'   'RCVCPS50'   1  [5, 1]  32  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R5VC1'   'RCVCPS51'   1  [5, 2]  33  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.B_type.I2B0L    AD.VCOR.B_type.B0L2I; ...
 'R5VC1A'  'RCVCPS51A'  1  [5, 3]  34  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R5VCSD1' 'RCVCSPS51'  1  [5, 4]  35  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R5VC2'   'RCVCPS52'   1  [5, 5]  36  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.b1_type.I2B0L   AD.VCOR.b1_type.B0L2I; ...
 'R5VCSD2' 'RCVCSPS52'  1  [5, 6]  37  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R5VC3A'  'RCVCPS53A'  1  [5, 7]  38  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.a48_type.I2B0L  AD.VCOR.a48_type.B0L2I; ...
 'R5VC3'   'RCVCPS53'   1  [5, 8]  39  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R5VC4'   'RCVCPS54'   1  [5, 9]  40  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.h20_type.I2B0L  AD.VCOR.h20_type.B0L2I; ...
 'R6VC0'   'RCVCPS60'   1  [6, 1]  41  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.H40_type.I2B0L  AD.VCOR.H40_type.B0L2I; ...
 'R6VC1'   'RCVCPS61'   1  [6, 2]  42  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R6VC1A'  'RCVCPS61A'  1  [6, 3]  43  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.A_type.I2B0L    AD.VCOR.A_type.B0L2I; ...
 'R6VCSD1' 'RCVCSPS61'  1  [6, 4]  44  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R6VC2'   'RCVCPS62'   1  [6, 5]  45  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.B_type.I2B0L    AD.VCOR.B_type.B0L2I; ...
 'R6VCSD2' 'RCVCSPS62'  1  [6, 6]  46  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.SD_type.I2B0L   AD.VCOR.SD_type.B0L2I; ...
 'R6VC3'   'RCVCPS63'   1  [6, 7]  47  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.B_type.I2B0L    AD.VCOR.B_type.B0L2I; ...
 'R6VC5'   'RCVCPS65'   1  [6, 8]  48  [-10.0 +10.0]  0.05 1.5e-4 HW2PhysicsGain  Physics2HWGain   AD.VCOR.a1_type.I2B0L   AD.VCOR.a1_type.B0L2I; ...
};
for ii=1:size(AD.VCOR.LIST,1)
AD.VCOR.device{ii} = AD.VCOR.LIST{ii,2};
%48 {
%8 'RCVCPS10';'RCVCPS10A';'RCVCPS11';'RCVCSPS11';'RCVCPS12';'RCVCSPS12';'RCVCPS13A';'RCVCPS13'; ...
%8 'RCVCPS21';'RCVCPS21A';'RCVCSPS21';'RCVCPS22';'RCVCSPS22';'RCVCPS23A';'RCVCPS23';'RCVCPS24'; ...
%7 'RCVCPS30';'RCVCPS31';'RCVCPS31A';'RCVCSPS31';'RCVCPS32';'RCVCSPS32';'RCVCPS33'; ...
%8 'RCVCPS40';'RCVCPS41';'RCVCSPS41';'RCVCPS42';'RCVCSPS42';'RCVCPS43A';'RCVCPS43';'RCVCPS44'; ...
%9 'RCVCPS50';'RCVCPS51';'RCVCPS51A';'RCVCSPS51';'RCVCPS52';'RCVCSPS52';'RCVCPS53A';'RCVCPS53';'RCVCPS54'; ...
%8 'RCVCPS60';'RCVCPS61';'RCVCPS61A';'RCVCSPS61';'RCVCPS62';'RCVCSPS62';'RCVCPS63';'RCVCPS65' ...
%};
end
% Trim Quadrupoles
AD.TrimQ.device = { ...
'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCQDTPS16'; 'RCQFTPS17'; 'RCQDTPS18'; ...
'RCQDTPS21'; 'RCQFTPS22'; 'RCQDTPS23'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; ...
'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; ...
'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; ...
'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; ...
'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; 'RCMTPS'; ...
};
AD.TrimQ.Mode = 0; % Convert by Scaling
AD.TrimQD1.I2B1L = 0.019;  % B1L (T/Amp)
AD.TrimQD1.B1L2I = 1/AD.TrimQD1.I2B1L;
AD.TrimQF2.I2B1L = -0.019; % B1L (T/Amp)
AD.TrimQF2.B1L2I = 1/AD.TrimQF2.I2B1L;
AD.TrimQD3.I2B1L = 0.013; % B1L (T/Amp)
AD.TrimQD3.B1L2I = 1/AD.TrimQD3.I2B1L;
AD.TrimQF4.I2B1L = -0.019; % B1L (T/Amp)
AD.TrimQF4.B1L2I = 1/AD.TrimQF4.I2B1L;
%AD.TrimQ.PS = { ... };
%AD.Trim.B1L = { ... };
% Skew Quadrupoles
AD.SkewQ.device = {'R1SQ1'; 'R2SQ1'; 'R2SQ2'; 'S4SQ1'; 'R5SQ1'; 'R5SQ2'; 'R6SQ1'; 'R6SQ2'};
AD.SkewQ.Mode = 1; % Convert by Table
AD.SkewQ.PS = [0 5 10];
AD.SkewQ.B1L = [0 0.0614 0.121];

% Insertion Device (ID) data
%
AD.ID.List = {'SWLS'; 'EPU56'; 'U5'; 'SW6'; 'W20'; 'U9'};
%AD.ID.List = strvcat('SWLS', 'EPU56', 'U5', 'SW6', 'W20', 'U9');
%DataOfID.Index = strmatch(DataOfID.Name,AD.ID.List,'exact');
%if (DataOfID.Index < 1) | (DataOfID.Index > length(ID.List))
%   error('Input argument Name does not appear in the ID.List!');
%end
%
% Super-conducting Wave-Length Shifter 6.0 Tesla
% SWLSMPSI SWLSMPSI 2 [0 215 230 260] = [0 5 5.3 6]
% Super-Conducting Wave-Length Shifter (SWLS)
% [N P N] = [(-1/2) 1 (-1/2)]
AD.ID.SWLS.device = {'SWLSMPS'};
AD.ID.SWLS.Parameter = [0 25 50 75 100 125 150 175 200 225 250 260 261]; % Current
AD.ID.SWLS.PeakField = [0.000000 1.245164 1.856044 2.414862 2.916582 3.415849 3.906895 4.365579 4.825984 5.290268 5.758334 5.944600 6.0];
AD.ID.SWLS.NumberOfPoles = 3;
AD.ID.SWLS.NumberOfEndPoles = 1;
%AD.ID.SWLS.Mode = 1; % Use sinh/cosh in x-direction and k_x^2+k_y^2 = k_s^2
AD.ID.SWLS.Mode = 0; % Use sin/cos in x-direction and kappa_x^2+k_s^2 = k_y^2
AD.ID.SWLS.Type = 'AGID';
AD.ID.SWLS.Symmetry = 1;
AD.ID.SWLS.PoleWidth = 0.2;
%AD.ID.SWLS.PoleWidth = 0.1396263; % kx = 3.6, ky = 22.8, ks = 22.5, pole-width = 0.1396263 
AD.ID.SWLS.PeriodLength = 2*AD.ID.SWLS.PoleWidth;
AD.ID.SWLS.ks = AD.pi/AD.ID.SWLS.PoleWidth; % ks = 2*pi/Lambda = pi/PoleWidth;
AD.ID.SWLS.kx = 0;
%AD.ID.SWLS.kx = 3.6;
%
% EPU56 Undulator
% EPU4GAP EPU4GAP 5 [18 230]
% EPU4PHASE EPU4PHASE 5 [-28 -19.8 9.9 0 9.9 19.8 28]
% Undulator EPU56
% [PE NE P1 N1 P2 N P] = [1/4 -3/4 1 -1 1 -1 1]
AD.ID.EPU56.device = {'EPU4GAP'};
AD.ID.EPU56.Parameter = [17 18 20 23 28 35 50 70 110 160 230]; % Gap (or Phase)
AD.ID.EPU56.PeakField = [0.69915008 0.69915008 0.62564473 0.52931217 0.39986535 0.26945240 0.11531039 0.03683968 0.00373228 0.00000000 0.00000000];
AD.ID.EPU56.NumberOfPoles = 133;
AD.ID.EPU56.NumberOfEndPoles = 2;
AD.ID.EPU56.Mode = 0;
AD.ID.EPU56.Type = 'EPID';
AD.ID.EPU56.Symmetry = 0; % Phase ?
AD.ID.EPU56.PoleWidth = 0.028;
AD.ID.EPU56.PeriodLength = 2*AD.ID.EPU56.PoleWidth;
AD.ID.EPU56.ks = AD.pi/AD.ID.EPU56.PoleWidth; % ks = 2*pi/Lambda = pi/PoleWidth;
AD.ID.EPU56.kx = 0;
%
AD.ID.EPU.device = {'EPU4GAP'};
AD.ID.EPU.Parameter = [17 18 20 23 28 35 50 70 110 160 230]; % Gap (or Phase)
AD.ID.EPU.PeakField = [0.69915008 0.69915008 0.62564473 0.52931217 0.39986535 0.26945240 0.11531039 0.03683968 0.00373228 0.00000000 0.00000000];
AD.ID.EPU.NumberOfPoles = 133;
AD.ID.EPU.NumberOfEndPoles = 2;
AD.ID.EPU.Mode = 0;
AD.ID.EPU.Type = 'EPID';
AD.ID.EPU.Symmetry = 0; % Phase ?
AD.ID.EPU.PoleWidth = 0.028;
AD.ID.EPU.PeriodLength = 2*AD.ID.EPU.PoleWidth;
AD.ID.EPU.ks = AD.pi/AD.ID.EPU.PoleWidth; % ks = 2*pi/Lambda = pi/PoleWidth;
AD.ID.EPU.kx = 0;
%
% U5GAP [14 230]
% Undulator U5
%[PE N1 P2 NN PN N2 P1 NE] = [56/916 -32/61 58/61 -1 1 -58/61 32/61 -56/918]
AD.ID.U5.device = {'U5GAP'};
AD.ID.U5.Parameter = [14 18 19 20 22 25 27 30 35 40 45 50 60 70 120 230 250]; % Gap
AD.ID.U5.PeakField = [0.91533720 0.67329090 0.63140240 0.58600030 0.51216510 0.41593170 0.36989030 0.30280650 0.22158930 0.15936110 0.11580370 0.08483674 0.04426467 ...
                      0.02305669 0.00103300 0.00000000 0.00000000];
AD.ID.U5.NumberOfPoles = 156;
AD.ID.U5.NumberOfEndPoles = 2;
AD.ID.U5.Mode = 0;
AD.ID.U5.Type = 'AGID';
AD.ID.U5.Symmetry = 0;
AD.ID.U5.PoleWidth = 0.025;
AD.ID.U5.PeriodLength = 2*AD.ID.U5.PoleWidth;
AD.ID.U5.ks = AD.pi/AD.ID.U5.PoleWidth; % ks = 2*pi/Lambda = pi/PoleWidth;
AD.ID.U5.kx = 0;
%
% Super-conducting Multi-Pole Wiggler
% SMPW6MPSI SMPW6MPSI 3 [0 285 350]
% SMPW6CPS1I SMPW6CPS1I 2 [0 20]
% SMPW6CPS2I SMPW6CPS2I 2 [0 20]
% SMPW6HC1 SMPW6HC1 2 [0 10]
% SMPW6HC2 SMPW6HC2 2 [0 10]
% Super-Conducting Multi-Pole Wiggler SW6
AD.ID.SW6.device = {'SMPW6MPS'}; % setting
AD.ID.SW6.Parameter = [0 10 20 30 40 50 60 70 80 90 105 125 14 5 165 185 205 225 245 285]; % Current
AD.ID.SW6.PeakField = [0 0.448 0.699 0.848 0.976 1.091 1.202 1.303 1.402 1.499 1.64 1.823 2.002 2.179 2.355 2.529 2.702 2.875 3.046 3.216];
AD.ID.SW6.NumberOfPoles = 32;
AD.ID.SW6.NumberOfEndPoles = 1;
AD.ID.SW6.Mode = 0;
AD.ID.SW6.Type = 'AGID';
AD.ID.SW6.Symmetry = 0;
AD.ID.SW6.PoleWidth = 0.03;
AD.ID.SW6.PeriodLength = 2*AD.ID.SW6.PoleWidth;
AD.ID.SW6.ks = AD.pi/AD.ID.SW6.PoleWidth; % ks = 2*pi/Lambda = pi/PoleWidth;
AD.ID.SW6.kx = 0;
%
% W20GAP [22 230]
% Wiggler W20
% Ideal W20: 1st-end-pole (P1) : 2nd-end-pole (P2) : full-pole (PX/PC) = 1/4 : 3/4 : 1
% Real W20: [P1 P2 PX PC] = [1/6 -3/5 1 -1]
AD.ID.W20.device = {'W20GAP'};
AD.ID.W20.Parameter = [22 22.3 26 30 35 40 45 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220 230]; % Gap
AD.ID.W20.PeakField = [1.85800442 1.83999121 1.63038117 1.42944175 1.22988308 1.07126800 0.94573509 0.84357756 0.68074448 0.56165399 0.46678419 0.39248674 0.33061181 ...
                       0.28011830 0.23751561 0.20211365 0.17175343 0.14642083 0.12460224 0.10633915 0.09061517 0.07733557 0.06599265 0.05631031 0.04809014 0.04107413];
AD.ID.W20.NumberOfPoles = 27;
AD.ID.W20.NumberOfEndPoles = 2;
%AD.ID.W20.Mode = 1; % sinh/cosh (k_1nx, k_2nx)
AD.ID.W20.Mode = 0; % sin/cos (kappa_1nx, kappa_2nx)
AD.ID.W20.Type = 'AGID';
AD.ID.W20.Symmetry = 1;
AD.ID.W20.PoleWidth = 0.1; % Unit: meter, 0.1 meter = 10 cm
AD.ID.W20.PeriodLength = 2*AD.ID.W20.PoleWidth;
AD.ID.W20.ks = AD.pi/AD.ID.W20.PoleWidth;
AD.ID.W20.kx = 0;
%
% U9 Undulator [19 230]
% U9GAP U9GAP 5
% Undulator U9
% [NE P1 N2 PN NN P2 N1 PE] = [-2147/12802 8855/12802 -125/128 1 -1 125/128 -8855/12802 2147/12802]
AD.ID.U9.device = {'U9GAP'};
AD.ID.U9.Parameter = [18 19 20 21 22 24 26 28 30 32 34 36 38 42 46 50 54 60 70 80 100 220 230]; % Gap
AD.ID.U9.PeakField = [1.28021150 1.28021150 1.21708700 1.15863990 1.10385940 1.00499390 0.91819627 0.84152641 0.77290514 0.71158841 0.65633119 0.60639290 0.56080759 ...
                      0.48108067 0.41400438 0.35693640 0.30817691 0.24765390 0.17248560 0.12025689 0.05841128 0.00077322 0.00000000];
AD.ID.U9.NumberOfPoles = 100;
AD.ID.U9.NumberOfEndPoles = 2;
AD.ID.U9.Mode = 1;
AD.ID.U9.Type = 'AGID';
AD.ID.U9.Symmetry = 0;
AD.ID.U9.PoleWidth = 0.045;
AD.ID.U9.PeriodLength = 2*AD.ID.U9.PoleWidth;
AD.ID.U9.ks = AD.pi/AD.ID.U9.PoleWidth; % ks = 2*pi/Lambda = pi/PoleWidth;
AD.ID.U9.kx = 0;
%

% Integrable homogeneous ploynomials
% OSIP = OSIP_Nerve(6,6,3)
% Degree 3 (6-variable) the coefficients are from c(29) to c(84)
% [29 30 65 66 81 82]
% g3(1) = c(29)*q1^3+c(30)*q1^2*p1+c(65)*q2^3+c(66)*q2^2*p2+c(81)*q3^3+c(82)*q3^2*p3
% [35 50 69 75 83 84] 
% g3(2) = c(50)*p1^3+c(35)*q1*p1^2+c(75)*p2^3+c(69)*q2*p2^2+c(84)*p3^3+c(83)*q3*p3^2
% [36 40 42 43 44 45 46 47 48 49]
% g3(3) = q1*h32(3)
% = c(40)*q1*q2^2+c(36)*q1*q2*p2+(1/3)*c(42)*q1*q2*q3+(1/3)*c(43)*q1*q2*p3+c(44)*q1*p2^2+(1/3)*c(45)*q1*p2*q3+(1/3)*c(46)*q1*p2*p3+c(47)*q1*q3^2+c(48)*q1*q3*p3+c(49)*q1*p3^2
% [31 41 42 43 51 57 58 72 73 74]
% g3(4) = q2*h32(4)
% = c(31)*q1^2*q2+c(41)*q1*p1*q2+(1/3)*c(42)*q1*q2*q3+(1/3)*c(43)*q1*q2*p3+c(51)*p1^2*q2+(1/3)*c(57)*p1*q2*q3+(1/3)*c(58)*p1*q2*p3+c(72)*q2*q3^2+c(73)*q2*q3*p3+c(74)*q2*p3^2
% [33 38 42 45 53 57 60 67 70 76]
% g3(5) = q3*h32(5)
% = c(33)*q1^2*q3+c(38)*q1*p1*q3+(1/3)*c(42)*q1*q2*q3+(1/3)*c(45)*q1*p2*q3+c(53)*p1^2*q3+(1/3)*c(57)*p1*q2*q3+(1/3)*c(60)*p1*p2*q3+c(67)*q2^2*q3+c(70)*q2*p2*q3+c(76)*p2^2*q3
% [55 56 57 58 59 60 61 62 63 64]
% g3(6) = p1*h32(6)
% = c(55)*p1*q2^2+c(56)*p1*q2*p2+(1/3)*c(57)*p1*q2*q3+(1/3)*c(58)*p1*q2*p3+c(59)*p1*p2^2+(1/3)*c(60)*p1*p2*q3+(1/3)*c(61)*p1*p2*p3+c(62)*p1*q3^2+c(63)*p1*q3*p3+c(64)*p1*p3^2
% [32 37 45 46 52 60 61 78 78 80]
% g3(7) = p2*h32(7)
% = c(32)*q1^2*p2+c(37)*q1*p1*p2+(1/3)*c(45)*q1*p2*q3+(1/3)*c(46)*q1*p2*p3+c(52)*p1^2*p2+(1/3)*c(60)*p1*p2*q3+(1/3)*c(61)*p1*p2*p3+c(78)*p2*q3^2+c(79)*p2*q3*p3+c(80)*p2*p3^2
% [34 39 43 46 54 58 61 68 71 77]
% g3(8) = p3*h32(8)
% = c(34)*q1^2*p3+c(39)*q1*p1*p3+(1/3)*c(43)*q1*q2*p3+(1/3)*c(46)*q1*p2*p3+c(54)*p1^2*p3+(1/3)*c(58)*p1*q2*p3+(1/3)*c(61)*p1*p2*p3+c(68)*q2^2*p3+c(71)*q2*p2*p3+c(77)*p2^2*p3
% g3 = [29 30 31 32 33 34 35 36 37 38 39 40 41 42 42 42 43 43 43 44 45 45 45 46 46 46 47 48 49 50 51 52 53 54 55 56 57 57 57 58 58 58 59 60 60 60 61 61 61 62 63 64 65 66
%       67 68 69 70 71 72 73 74 75 76 77 78 78 80 81 82 83 84]
%
% Degree 4 (6-variable) the coefficients are from c(85) to c(210)
% g4

%GLOBVAL.E0 = AD.Energy*1e+009;
%setad(AD);


