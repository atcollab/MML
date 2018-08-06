soleilinit
getx
plot(getx)
family2dev('BPMx')
family2tango('BPMx')
help getx
help family2tango
doc tango
tango_command_inout('ANS-C08/EI/M-HU80.2_CHAN1', 'State')
tango_error
dev = 'ANS-C08/EI/M-HU80.2_CHAN1';
class(dev)
a=2
class(a)
tango_state(dev)
tango_status(dev)
devM='ans-c08/ei/m-hu80.2_motorscontrol'
tango_command_inout('ANS-C08/EI/M-HU80.2_CHAN1', 'State')
tango_command_inout(devM, 'State')
tango_command_inout2(devM, 'State')
tango_command_inout(devM, 'State4')
tango_command_inout2(devM, 'State4')
tango_command_inout2(devM, 'ON')
tango_command_inout2(devM, 'On')
tango_command_inout2(devM, 'Status')
tango_command_inout2(devM, 'State')
pp = tango_command_inout2(devM, 'State')
tango_command_inout2(devM, 'State')
print(ans)
printf('%s\n', ans)
fprintf('%s\n', ans)
ans
a=2
ans
2
ans
tango_read_attribute2(devM, 'encoder1Position')
a = tango_read_attribute2(devM, 'encoder1Position')
a
a.value
datestr(a.time)
readattribute([devM, 'encoder1Position'])
[devM, 'encoder1Position'])
[devM, 'encoder1Position']
[devM, '/encoder1Position']
readattribute([devM, '/encoder1Position'])
[a z ] = readattribute([devM, '/encoder1Position'])
help readattribute
[a z t] = readattribute([devM, '/encoder1Position'])
edit readattribute.m
datestr(t)
[a z t] = readattribute([devM, '/encoder2Position'])
[a z t] = readattribute([devM, '/encoder3Position'])
[a z t] = readattribute([devM, '/encoder4Position'])
[a z t] = readattribute([devM, '/encoder5Position'])
[a z t] = readattribute([devM, '/encoder6Position'])
tango_command_inout2(devM, 'GotoGap', 2400000)
tango_command_inout2(devM, 'GotoGap', int32(2400000))
[a z t] = readattribute([devM, '/encoder2Position'])
tango_command_inout2(devM, 'Init')
tango_command_inout2(devM, 'State')
tango_command_inout2(devM, 'On')
tango_command_inout2(devM, 'ResetError')
tango_command_inout2(devM, 'Reset')
tango_command_inout2(devM, 'GotoGap', int32(2100000))
tango_command_inout2(devM, 'GotoPhase', int32(50000), int32(50000))
tango_command_inout2(devM, 'GotoPhase', {int32(50000), int32(50000)})
tango_command_inout2(devM, 'GotoPhase', [int32(50000), int32(50000)])
tango_command_inout2(devM, 'Init')
tango_command_inout2(devM, 'GotoPhase', [int32(0), int32(0)])
tango_command_inout2(devM, 'GotoPhase', [int32(100000), int32(-100000)])
tango_command_inout2(devM, 'GotoPhase', [int32(0), int32(0)])
tango_command_inout2(devM, 'GotoGap', int32(2500000))

getx
getz
getam('BPMx')
getam('BPMx',[1 1])
getam('BPMx',[1 1; 1 2])
getam('BPMx',[5 1; 5 2])
family2tangodev('BPMx',[5 1; 5 2])
family2dev('BPMx')
family2status('BPMx')
modelbeta
solorbit
getx
X = getx
I=getdcct

/home/matlabML/mmlcontrol/Ringspecific/insertions

/home/matlabML/measdata/Ringdata/insertions/HU80_TEMPO/

% H orbit
EI.X = getx;
% V orbit
EI.Z = getz;
% encoder #2
EI.encoder2= readattribute([devM, '/encoder2Position']);
% stored current
EI.current = getdcct;
% tunes
EI.tune = gettune;

% measure dispersion functions
[dx dz] = measdisp('Physics');

EI.dx = dx;
EI.dz = dz;

EI.date = datestr(now); % convert date to string

pause(1); % 1 second pause

% measure chromaticities
EI.ksi = measchro('Physics');

%%%%%%%%%%%%%% ARchiving

% If the filename contains a directory then make sure it exists
Filename = 'exemple4Oleg';

FileName = appendtimestamp('G20_P0');
DirectoryName = getfamilydata('Directory','HU80_TEMPO');
DirStart = pwd;
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
save(FileName, 'EI_G20_P0');
cd(DirStart);


edit soleilinit
Filename = 'exemple4Oleg'
FileName = appendtimestamp(Filename)
getfamilydata('Directory','HU80_TEMPO')
ls
rm HU80_2006-09-12_17-24-36
remove HU80_2006-09-12_17-24-36
delete HU80_2006-09-12_17-24-36.mat
ls
dir
help save
doc save
getmcf
pwd
save 'toto' EI

%%%%%%%%%%%%%% Calculating theoretical Beta values at the positions of BPMs
modelbeta('BPMx')
[bx bz]=modelbeta('BPMx')
bx
[phx, phz] = modelphase('BPMx')
phx
modeltune
[nux nuz] = modeltune
nu = modeltune

%%%%%%%%%%%%%% Measuring COD vs Corrector Currents (to estimate corrector efficiency)
tableCurInCor = [0 0 0 0; -10 0 0 0; -5 0 0 0; 0 0 0 0; 5 0 0 0; 10 0 0 0; 0 0 0 0; 0 -10 0 0; 0 -5 0 0; 0 0 0 0; 0 5 0 0; 0 10 0 0; 0 0 0 0; 0 0 -10 0; 0 0 -5 0; 0 0 0 0; 0 0 5 0; 0 0 10 0; 0 0 0 0; 0 0 0 -10; 0 0 0 -5; 0 0 0 0; 0 0 0 5; 0 0 0 10]
[fileNames, res] = idMeasCorEffic('HU80_PLEIADES', tableCurInCor, 0, 'C1G200', 1)

%To measure electron beam and read undulator state, and save the data
%structure to a file
stMeas = idMeasElecBeamUnd('U20_PROXIMA1', 0, 'test_for_chams', 1)

%to estimate effective field integrals of U20
st = idCalcFldIntFromElecBeamMeasForUndSOLEIL_1('U20_PROXIMA1', '/home/matlabML/measdata/Ringdata/insertions/U20_PROXIMA1', 'u20_g5_5_2006-09-29_12-29-58', 'u20_g30_2006-09-29_11-59-57', '', -1)

% Write a table : attributename to be changed
A=[0 1 2 3;
      10 0.2 0.4 0.5;
      20 0.5 0.21 0.45];
  
tango_write_attribute2(dev,'correctionCHEParallelMode',A);  

% how to write at the same time all the correctors
dev= 'ANS-C08/EI/M-HU80.2';
attr_name_val_list(1).value = 0
attr_name_val_list(2).value = 0
attr_name_val_list(3).value = 0
attr_name_val_list(4).value = 0
attr_name_val_list(1).name='currentCHE'
attr_name_val_list(2).name='currentCVE'
attr_name_val_list(4).name='currentCVS'
attr_name_val_list(3).name='currentCHS'

tango_write_attributes(dev,attr_name_val_list);

% to calculate correction tables for feed-forward
%HU80:
stFileNamesMeasCOD = load('/home/operateur/GrpGMI/HU80_TEMPO/cod_II_filelist_2006-12-10_13-11-12');
vPhase = [-40, -35, -30, -25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30, 35, 40];
vGap = [15.5, 16, 18, 20, 22.5, 25, 27.5, 30, 35, 40, 50, 60, 70, 80, 90, 100, 110, 130, 150];
fileNamesMeasBkg = idAuxPrepFileNameListMeasAndBkg(stFileNamesMeasCOD.filelist, length(vGap));
arBPM2Skip = [58];
[mCHE, mCVE, mCHS, mCVS] = idCalcFeedForwardCorTables('HU80_TEMPO', {{'phase', vPhase}, {'gap', vGap}}, fileNamesMeasBkg, '', '', arBPM2Skip);
mCHE_with_Arg = idAuxMergeCorTableWithArg2D(vGap, vPhase, mCHE);
mCVE_with_Arg = idAuxMergeCorTableWithArg2D(vGap, vPhase, mCVE);
mCHS_with_Arg = idAuxMergeCorTableWithArg2D(vGap, vPhase, mCHS);
mCVS_with_Arg = idAuxMergeCorTableWithArg2D(vGap, vPhase, mCVS);

%U20:
stFileNamesMeasCOD = load('/home/operateur/GrpGMI/U20_PROXIMA1/test_cod_filelist_2007-01-24_13-17-20.mat');
vGap = [30, 27];
fileNamesMeasBkg = idAuxPrepFileNameListMeasAndBkg(stFileNamesMeasCOD.filename, length(vGap))
[mCHE, mCVE, mCHS, mCVS] = idCalcFeedForwardCorTables('U20_PROXIMA1', {{'gap', vGap}}, fileNamesMeasBkg, '', '', -1)

%%
dev = 'ANS-C04/EI/M-HU80.1';

tango_write_attribute2(dev,'parallelModeCHE', mCHE_res_with_arg);
tango_write_attribute2(dev,'parallelModeCVE', mCVE_res_with_arg);
tango_write_attribute2(dev,'parallelModeCHS', mCHS_res_with_arg);
tango_write_attribute2(dev,'parallelModeCVS', mCVS_res_with_arg);

%%To measure COD vs Undulator Param(s) automatically:
[resFileNames, resErrorFlag] = idMeasElecBeamVsUndParam('HU80_TEMPO', {{'phase', [-40, -35, -30, -25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30, 35, 40]}, {'gap', [15.5]}}, {}, inclPerturbMeas, fileNameCore, dispData)
[resFileNames, resErrorFlag] = idMeasElecBeamVsUndParam('HU80_TEMPO', {{'phase', [-40, -35, -30, -25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30, 35, 40], 0.01}, {'gap', [15.5], 0.01}}, {{'gap', 250, 0.01}, {'phase', 0, 0.01}}, 2, 0, 'test', 1)
[resFileNames, resErrorFlag] = idMeasElecBeamVsUndParam('HU80_TEMPO', {{'phase', [-40, -35, -30, -25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30, 35, 40], 0.01}, {'gap', [15.5, 16, 18, 20, 22.5, 25, 27.5, 30, 35, 40, 50, 60, 70, 80, 90, 100, 110, 130, 150], 0.01}}, {{'gap', 250, 0.01}, {'phase', 0, 0.01}}, 1, 0, 'cod_X_01_07', 1)
[resFiles, resErr] = idMeasElecBeamVsUndParam('HU80_PLEIADES', {{'phase', [-40, -35, -30, -25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30, 35, 40], 0.01}, {'gap', [15.5, 16, 18, 20], 0.01}}, {{'gap', 250, 0.01}, {'phase', 0, 0.01}}, 1, 0, 'cod_extra_II', 1)
[resFiles, resErr] = idMeasElecBeamVsUndParam('HU80_CASSIOPEE', {{'phase', [-40,-37.5, -35,-32.5, -30,-27.5, -25,-22.5, -20,-17.5, -15,-12.5, -10,-7.5, -5,-2.5, 0,2.5, 5,7.5, 10,12.5, 15,17.5, 20,22.5, 25,27.5, 30,32.5, 35, 37.5,40], 0.01}, {'gap', [15.5, 16, 18, 20, 22.5, 25, 27.5, 30, 35, 40, 50, 60, 70, 80, 90, 100, 110, 130, 150, 175, 200, 225, 250], 0.01}}, {{'phase', 0, 0.01}, {'gap', 250, 0.01}}, 1, 0, 'cod_1st_test', 1)
[resFiles, resErr] = idMeasElecBeamVsUndParam('HU80_CASSIOPEE', {{'phase', [-40,-37.5, -35,-32.5, -30,-27.5, -25,-22.5, -20,-17.5, -15,-12.5, -10,-7.5, -5,-2.5, 0,2.5, 5,7.5, 10,12.5, 15,17.5, 20,22.5, 25,27.5, 30,32.5, 35, 37.5,40], 0.01}, {'gap', [15.5, 16, 18, 20, 22.5, 25, 27.5, 30, 35, 40, 50, 60, 70, 80, 90, 100, 110, 130, 150, 175, 200, 225, 250], 0.01}}, {{'phase', 0, 0.01}, {'gap', 250, 0.01}}, 1, 0, 'cod_gen_X', 1)
[resFiles, resErr] = idMeasElecBeamVsUndParam('HU80_CASSIOPEE', {{'phase', [40], 0.01}, {'gap', [15.5, 16, 18, 20, 22.5, 25, 27.5, 30, 35, 40, 50, 60, 70, 80, 90, 100, 110, 130, 150], 0.01}}, {{'phase', 0, 0.01}, {'gap', 250, 0.01}}, 1, 0, 'cod_1st_test', 1)
[resFileNames, resErrorFlag] = idMeasElecBeamVsUndParam('U20_PROXIMA1', {{'gap', [5.5, 6, 10], 0.01}}, {{'gap', 30, 0.01}}, 1, 0, 'test_cod', 1)

%U20 COD meas. and calc. of cor. tables:
[resFileNames, resErrorFlag] = idMeasElecBeamVsUndParam('U20_PROXIMA1', {{'gap', [5.5, 6, 10], 0.01}}, {{'gap', 30, 0.01}}, 1, 0, 'test_cod', 1)
%st.filelist = resFileNames; idSaveStruct(st, 'test_cod_filelist', 'U20_PROXIMA1', 0)
    %do something else...
%ls /home/operateur/GrpGMI/U20_PROXIMA1
%stFileNamesMeasCOD = load('/home/operateur/GrpGMI/U20_PROXIMA1/test_cod_filelist_2007-01-24_14-20-54.mat');
%vGap = [5.5, 6, 10];
%fileNamesMeasBkg = idAuxPrepFileNameListMeasAndBkg(stFileNamesMeasCOD.filelist, length(vGap));
%[mCHE, mCVE, mCHS, mCVS] = idCalcFeedForwardCorTables('U20_PROXIMA1', {{'gap', vGap}}, fileNamesMeasBkg, '', '', -1);
[mCHE, mCVE, mCHS, mCVS] = idCalcFeedForwardCorTables('U20_PROXIMA1', resFileNames.params, resFileNames.filenames_meas_bkg, '', '', -1)

%CHAMS, I've tested the COD meas. using idMeasElecBeamVsUndParam. It seems to work fine now. 03/02/2007 OC
[resFileNames, resErrorFlag] = idMeasElecBeamVsUndParam('U20_PROXIMA1', {{'gap', [29.5, 29.7], 0.01}}, {{'gap', 30, 0.01}}, 1, 0, 'test_cod_to_delete', 1)


