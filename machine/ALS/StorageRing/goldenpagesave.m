function goldenpagesave(FileNameIn)

% This function generates and saves goldenpage files.
% FileNameIn should have no extension
% If FileNameIn is empty, data is saved to the 1_golden.txt file in the ALSDATA directory.
% If FileNameIn is given, the data is saved to that file (.txt) in the ALSDATA directory.
%
% Filenames and pulsed-magnet timing values are dificult to automatically update, so for now
% these must be updated by editing /home/als/physbase/matlab/als/commands/goldenpagesave.m

% 2004-10-19  T. Scarvie
%     removed references to THC auxiliary tuners (they were replaced by HOM dampers 4-04)

global GLOBAL_SR_GEV
global GLOBAL_ALSDATA_DIRECTORY
global GLOBAL_SR_MODE_TITLE
global GLOBAL_SR_PRODUCTION_FILE
global GLOBAL_SR_GOLDENPAGE_FILE


% setup file names and directories
if nargin < 1
   %FileNameIn = sprintf('%igolden',GLOBAL_SR_GEV*10);
   FileNameIn = sprintf('%s', GLOBAL_SR_GOLDENPAGE_FILE);
end

if isstr(FileNameIn)
   %FileNameHN = sprintf('%s.txt', FileNameIn);  originally to write .txt lattice files for Hiroshi
   txtflag = strcmp(FileNameIn(end-3:end), '.txt');
   if txtflag == 1
   	FileName = sprintf('%s', FileNameIn);
   else
   	FileName = sprintf('%s.txt', FileNameIn);
   end
   %DirName = '.';
   %ReadmeStr = sprintf('Goldenpage values saved to %s.txt in .../alsdata/', FileNameIn);
end

%% choose whether to save all data or just FB data
%SaveDataFlag = menu(sprintf('%s\n\nSave which data?',GLOBAL_SR_MODE_TITLE),'All goldenpage values','Only feedback system values','Exit');
%if SaveDataFlag == 1
%
%	%save all values
%	disp('Will save all values...');
%elseif SaveDataFlag == 2
%	
%	%save only FB values
%	disp('Will save only FB values... (not implemented yet - all values will be saved)');
%end


% filenames
% edit these filenames to change on goldenpage
ASLFileName = 'GSR0309.MCH';
BTSFileName = '1_5GeV.BTS';
PulseMagnetFileName = '1_5GeV.PLS';


% RF data
C1TempFBonAC = getsp('SR03S___C1TEMP_AC00');
C1TempFBonAM = getam('SR03S___C1TEMP_AM00');
C2TempFBonAC = getsp('SR03S___C2TEMP_AC00');
C2TempFBonAM = getam('SR03S___C2TEMP_AM00');
C1TempFBoffAC = 43; %edit this number to change on goldenpage
C2TempFBoffAC = 45; %edit this number to change on goldenpage

if GLOBAL_SR_GEV == 1.9
	Power = 120; %edit this number to change on goldenpage
elseif GLOBAL_SR_GEV == 1.5
	Power = 120; %edit this number to change on goldenpage
else
	Power = 120; %edit this number to change on goldenpage
end


% injection magnet data
% timing values: hand edit these numbers to change them on the goldenpage, because...
% these timing values don't change very often and require special dll call (due to "gr" structure in database)
BRBump1 = getsp('BR2_____BUMP1__AC00');
BRBump2 = getsp('BR2_____BUMP2__AC01');
BRBump3 = getsp('BR2_____BUMP3__AC00');
BR2SEN = getsp('BR2_____SEN____AC00');
BR2SENTiming = 45250;
BR2SEK = getsp('BR2_____SEK____AC01');
BR2SEKTiming = 0;
BR2KE = getsp('BR2_____KE_____AC00');
BR2KETiming = 59650;
ExtFldTrigTiming = 237000;
BRBumpTrigTiming = 234650;
SRSEK = getsp('SR01S___SEK____AC01');
SRSEKTiming = 0;
SRSEN = getsp('SR01S___SEN____AC00');
SRSENTiming = 47250;
SRBUMP1 = getsp('SR01S___BUMP1__AC00');
SRBUMP1Timing = 56700;


% transverse feedback parametes
X1Bias = getam('tbds:x1bias:Ctrl');
X2Bias = getam('tbds:x2bias:Ctrl');
Y1Bias = getam('tbds:y1bias:Ctrl');
Y2Bias = getam('tbds:y2bias:Ctrl');
XAtten = getam('tbds:X:Atten:Parse.A');
YAtten = getam('tbds:Y:Atten:Parse.A');
XDelay = getam('tbds:cpdl_x_delay:Ctrl');
YDelay = getam('tbds:cpdl_y_delay:Ctrl');


% longitudinal feedback parameters
FrontEndDelay = getam('LFBFS1:PDL0:DELAY');
BackEndDelay = getam('LFBFS1:PDL1:DELAY');
QPSKAtten = getam('LFB0FS1:BE:QPSK_ATTEN');
FillPattern = scagetstring('LFBFS1:DS:FILLPATTERN');

SynchrotronFreq = getam('LFBFS1:SYS:SYNCFREQ');
CalculatedSynchrotronFreq = 99999;

RingShift = getam('LFBFS1:DS:RINGSHIFT');
%FilterPhase = 0;
MinDSPTime = getam('LFBFS1:DS:MINDSPTIME');
HoldBufferOffset = getam('LFBFS1:DS:HBOFFSET');
ShiftGain = getam('LFBFS1:DSP:SHIFTGAIN');
FEPhaseOffset = getam('LFB0FS1:FE:PHASE_OFFSET');
FEPhaseShift = getam('LFB0FS1:FE:PHASE_SHIFT');
FEGainSign = getam('LFB0FS1:FE:GAIN_SIGN');
	if FEGainSign == 0
		FEGainSign = '+';
	elseif FEGainSign == 1;
		FEGainSign = '-';
	else
		FEGainSign = '?';
	end
	
% Third Harmonic Cavity parameters
THC1MainAC = getsp('SR02C___C1MPOS_AC00');
THC1MainAM = getam('SR02C___C1MPOS_AM00');
%THC1AuxAC = getsp('SR02C___C1APOS_AC00');
%THC1AuxAM = getam('SR02C___C1APOS_AM00');
THC2MainAC = getsp('SR02C___C2MPOS_AC00');
THC2MainAM = getam('SR02C___C2MPOS_AM00');
%THC2AuxAC = getsp('SR02C___C2APOS_AC00');
%THC2AuxAM = getam('SR02C___C2APOS_AM00');
THC3MainAC = getsp('SR02C___C3MPOS_AC00');
THC3MainAM = getam('SR02C___C3MPOS_AM00');
%THC3AuxAC = getsp('SR02C___C3APOS_AC00');
%THC3AuxAM = getam('SR02C___C3APOS_AM00');
beamcurrent = getdcct;

%% Go to the proper directory
%tmpdir = pwd;
%gotoalsdata;

%% Warn that goldenpage data will be overwritten
%if strcmp(computer,'PCWIN')==1
%   % PC
%   StartFlag = questdlg(str2mat(sprintf('File: %s',[FileName]),'Already exists on the matlab path.','','Do you want to save data to:',sprintf('File: %s%s',pwd,['\',FileName])),'GOLDENPAGESAVE','Yes','No','No');
%else
%   % Sun
%   StartFlag = questdlg(str2mat(sprintf('File: %s',[FileName]),'Already exists on the matlab path.','','Do you want to save data to:',sprintf('File: %s%s',pwd,['/',FileName])),'GOLDENPAGESAVE','Yes','No','No');
%end
%   
%if strcmp(StartFlag,'Yes')
%   %disp(['  Writing over file: ',FileName,'.txt'])
%else
%   % Return to original directory
%   feval('cd', tmpdir);
%      
%   disp('  Data not saved.');
%   return
%end


% Backup old goldenpage data to 1_golden.txt in .../alsdata/1._/goldenpage_backups/
% Record start directory
DirStart = pwd;

% Get time and date
tmp = clock;
year   = tmp(1);
month  = tmp(2);
day    = tmp(3);
hour   = tmp(4);
minute = tmp(5);
seconds= tmp(6);

% Change to /home/als/physbase/matlab/als/alsdata and create directory by date
cd('/home/als/physbase/matlab/als/alsdata');
if GLOBAL_SR_GEV==1.3 | GLOBAL_SR_GEV==1.5 | GLOBAL_SR_GEV==1.9 
   eval(sprintf('cd %.1f', GLOBAL_SR_GEV));
else
   cd other
end

if strcmp(GLOBAL_SR_GOLDENPAGE_FILE,'19tbfbgolden')
   cd /home/als/physbase/matlab/als/alsdata/1.9TwoBunch
end
BackupDir = pwd;

DirByDate = sprintf('%d-%02d-%02d', year, month, day);
eval(sprintf('!mkdir goldenpage_backups/%s', DirByDate));

% cd to directory by date
eval(sprintf('cd goldenpage_backups/%s', DirByDate));

% Create directory by time
DirByTime = sprintf('%.0f-%02d-%.0f', hour, minute, seconds);
eval(sprintf('!mkdir %s', DirByTime));

% cd to directory by time
eval(sprintf('cd %s', DirByTime));

%modestr = sprintf('%i',GLOBAL_SR_GEV*10);
modestr = GLOBAL_SR_GOLDENPAGE_FILE;

% copy files
eval(sprintf('!cp /home/als/physbase/matlab/als/alsdata/%s.* .', modestr));

% Return to original directory
eval(['cd ', DirStart]);

fprintf('\n  Old %g GeV goldenpage file backed up to %s/goldenpage_backups/%s/%s\n', GLOBAL_SR_GEV, BackupDir, DirByDate, DirByTime);



% Write new goldenpage file
tmpdir = pwd;
gotoalsdata;

if isunix
   c = char(13);
   
   fid = fopen([FileName],'wt');
   
   fprintf(fid,'#%c\n', c);
   fprintf(fid,'# %f GeV Storage Ring Operation%c\n', GLOBAL_SR_GEV, c);
   fprintf(fid,'#%c\n', c);
   fprintf(fid,'# This file created at %.0f:%02d on %d-%02d-%02d%c\n', hour, minute, year, month, day, c);
   fprintf(fid,'%c\n', c);
   
   fprintf(fid,'ASLFileName %s%c\n', ASLFileName, c);
   fprintf(fid,'BTSFileName %s%c\n', BTSFileName, c);
   fprintf(fid,'PulseMagnetFileName %s%c\n', PulseMagnetFileName, c);
   
   fprintf(fid,'RFdata.C1TempFBoffAC %.1f%c\n', C1TempFBoffAC, c);
   fprintf(fid,'RFdata.C2TempFBoffAC %.1f%c\n', C2TempFBoffAC, c);
   fprintf(fid,'RFdata.C1TempFBonAC %.1f%c\n', C1TempFBonAC, c);
   fprintf(fid,'RFdata.C1TempFBonAM %.2f%c\n', C1TempFBonAM, c);
   fprintf(fid,'RFdata.C2TempFBonAC %.1f%c\n', C2TempFBonAC, c);
   fprintf(fid,'RFdata.C2TempFBonAM %.2f%c\n', C2TempFBonAM, c);
   fprintf(fid,'RFdata.Power %.0f%c\n', Power, c);
   
   fprintf(fid,'BUMPdata.BRBump1 %.1f%c\n', BRBump1, c);
   fprintf(fid,'BUMPdata.BRBump2 %.1f%c\n', BRBump2, c);
   fprintf(fid,'BUMPdata.BRBump3 %.1f%c\n', BRBump3, c);
   fprintf(fid,'BUMPdata.BR2SEN %.1f%c\n', BR2SEN, c);
   fprintf(fid,'BUMPdata.BR2SENTiming %.0f%c\n', BR2SENTiming, c);
   fprintf(fid,'BUMPdata.BR2SEK %.1f%c\n', BR2SEK, c);
   fprintf(fid,'BUMPdata.BR2SEKTiming %.0f%c\n', BR2SEKTiming, c);
   fprintf(fid,'BUMPdata.BR2KE %.1f%c\n', BR2KE, c);
   fprintf(fid,'BUMPdata.BR2KETiming %.0f%c\n', BR2KETiming, c);
   fprintf(fid,'BUMPdata.ExtFldTrigTiming %.0f%c\n', ExtFldTrigTiming, c);
   fprintf(fid,'BUMPdata.BRBumpTrigTiming %.0f%c\n', BRBumpTrigTiming, c);
   fprintf(fid,'BUMPdata.SRSEK %.1f%c\n', SRSEK, c);
   fprintf(fid,'BUMPdata.SRSEKTiming %.0f%c\n', SRSEKTiming, c);
   fprintf(fid,'BUMPdata.SRSEN %.1f%c\n', SRSEN, c);
   fprintf(fid,'BUMPdata.SRSENTiming %.0f%c\n', SRSENTiming, c);
   fprintf(fid,'BUMPdata.SRBUMP1 %.1f%c\n', SRBUMP1, c);
   fprintf(fid,'BUMPdata.SRBUMP1Timing %.0f%c\n', SRBUMP1Timing, c);
   
   fprintf(fid,'TFBdata.X1Bias %.2f%c\n', X1Bias, c);
   fprintf(fid,'TFBdata.Y1Bias %.2f%c\n', Y1Bias, c);
   fprintf(fid,'TFBdata.X2Bias %.2f%c\n', X2Bias, c);
   fprintf(fid,'TFBdata.Y2Bias %.2f%c\n', Y2Bias, c);
   fprintf(fid,'TFBdata.XAtten %.0f%c\n', XAtten, c);
   fprintf(fid,'TFBdata.YAtten %.0f%c\n', YAtten, c);
   fprintf(fid,'TFBdata.XDelay %.0f%c\n', XDelay, c);
   fprintf(fid,'TFBdata.YDelay %.0f%c\n', YDelay, c);
   
   fprintf(fid,'LFBdata.FrontEndDelay %.0f%c\n', FrontEndDelay, c);
   fprintf(fid,'LFBdata.FEPhaseOffset %.0f%c\n', FEPhaseOffset, c);
   fprintf(fid,'LFBdata.FEPhaseShift %.0f%c\n', FEPhaseShift, c);
   fprintf(fid,'LFBdata.FEGainSign %s%c\n', FEGainSign, c);
   fprintf(fid,'LFBdata.BackEndDelay %.0f%c\n', BackEndDelay, c);
   fprintf(fid,'LFBdata.QPSKAtten %.0f%c\n', QPSKAtten, c);
   fprintf(fid,'LFBdata.FillPattern %s%c\n', FillPattern, c);
   fprintf(fid,'LFBdata.SynchrotronFreq %.0f%c\n', SynchrotronFreq, c);
   fprintf(fid,'LFBdata.CalculatedSynchrotronFreq %.0f%c\n', CalculatedSynchrotronFreq, c); 
   fprintf(fid,'LFBdata.RingShift %.0f%c\n', RingShift, c);
   fprintf(fid,'LFBdata.HoldBufferOffset %.0f%c\n', HoldBufferOffset, c);
   fprintf(fid,'LFBdata.MinDSPTime %.0f%c\n', MinDSPTime, c);
   fprintf(fid,'LFBdata.ShiftGain %.0f%c\n', ShiftGain, c);
   %fprintf(fid,'LFBdata.FilterPhase %.0f%c\n', FilterPhase, c);
   
   fprintf(fid,'THCdata.THC1MainAC %.3f%c\n', THC1MainAC, c);
   fprintf(fid,'THCdata.THC1MainAM %.3f%c\n', THC1MainAM, c);
%  fprintf(fid,'THCdata.THC1AuxAC %.3f%c\n', THC1AuxAC, c);
%  fprintf(fid,'THCdata.THC1AuxAM %.3f%c\n', THC1AuxAM, c);
   fprintf(fid,'THCdata.THC2MainAC %.3f%c\n', THC2MainAC, c);
   fprintf(fid,'THCdata.THC2MainAM %.3f%c\n', THC2MainAM, c);
%  fprintf(fid,'THCdata.THC2AuxAC %.3f%c\n', THC2AuxAC, c);
%  fprintf(fid,'THCdata.THC2AuxAM %.3f%c\n', THC2AuxAM, c);
   fprintf(fid,'THCdata.THC3MainAC %.3f%c\n', THC3MainAC, c);
   fprintf(fid,'THCdata.THC3MainAM %.3f%c\n', THC3MainAM, c);
%  fprintf(fid,'THCdata.THC3AuxAC %.3f%c\n', THC3AuxAC, c);
%  fprintf(fid,'THCdata.THC3AuxAM %.3f%c\n', THC3AuxAM, c);
   fprintf(fid,'beamcurrent %.3f%c\n', beamcurrent, c);
   
   %close file
   fclose(fid);
   
else
   
   fid = fopen([FileName],'wt');
   
   fprintf(fid,'#\n');
   fprintf(fid,'# %f GeV Storage Ring Operation\n', GLOBAL_SR_GEV);
   fprintf(fid,'#\n');
   fprintf(fid,'# This file created at %.0f:%02d on %d-%02d-%02d\n', hour, minute, year, month, day);
   fprintf(fid,'\n');
   
   fprintf(fid,'ASLFileName %s\n', ASLFileName);
   fprintf(fid,'BTSFileName %s\n', BTSFileName);
   fprintf(fid,'PulseMagnetFileName %s\n', PulseMagnetFileName);
   
   fprintf(fid,'RFdata.C1TempFBoffAC %.1f\n', C1TempFBoffAC);
   fprintf(fid,'RFdata.C2TempFBoffAC %.1f\n', C2TempFBoffAC);
   fprintf(fid,'RFdata.C1TempFBonAC %.1f\n', C1TempFBonAC);
   fprintf(fid,'RFdata.C1TempFBonAM %.2f\n', C1TempFBonAM);
   fprintf(fid,'RFdata.C2TempFBonAC %.1f\n', C2TempFBonAC);
   fprintf(fid,'RFdata.C2TempFBonAM %.2f\n', C2TempFBonAM);
   fprintf(fid,'RFdata.Power %.0f\n', Power);
   
   fprintf(fid,'BUMPdata.BRBump1 %.1f\n', BRBump1);
   fprintf(fid,'BUMPdata.BRBump2 %.1f\n', BRBump2);
   fprintf(fid,'BUMPdata.BRBump3 %.1f\n', BRBump3);
   fprintf(fid,'BUMPdata.BR2SEN %.1f\n', BR2SEN);
   fprintf(fid,'BUMPdata.BR2SENTiming %.0f\n', BR2SENTiming);
   fprintf(fid,'BUMPdata.BR2SEK %.1f\n', BR2SEK);
   fprintf(fid,'BUMPdata.BR2SEKTiming %.0f\n', BR2SEKTiming);
   fprintf(fid,'BUMPdata.BR2KE %.1f\n', BR2KE);
   fprintf(fid,'BUMPdata.BR2KETiming %.0f\n', BR2KETiming);
   fprintf(fid,'BUMPdata.ExtFldTrigTiming %.0f\n', ExtFldTrigTiming);
   fprintf(fid,'BUMPdata.BRBumpTrigTiming %.0f\n', BRBumpTrigTiming);
   fprintf(fid,'BUMPdata.SRSEK %.1f\n', SRSEK);
   fprintf(fid,'BUMPdata.SRSEKTiming %.0f\n', SRSEKTiming);
   fprintf(fid,'BUMPdata.SRSEN %.1f\n', SRSEN);
   fprintf(fid,'BUMPdata.SRSENTiming %.0f\n', SRSENTiming);
   fprintf(fid,'BUMPdata.SRBUMP1 %.1f\n', SRBUMP1);
   fprintf(fid,'BUMPdata.SRBUMP1Timing %.0f\n', SRBUMP1Timing);
   
   fprintf(fid,'TFBdata.X1Bias %.2f\n', X1Bias);
   fprintf(fid,'TFBdata.Y1Bias %.2f\n', Y1Bias);
   fprintf(fid,'TFBdata.X2Bias %.2f\n', X2Bias);
   fprintf(fid,'TFBdata.Y2Bias %.2f\n', Y2Bias);
   fprintf(fid,'TFBdata.XAtten %.0f\n', XAtten);
   fprintf(fid,'TFBdata.YAtten %.0f\n', YAtten);
   fprintf(fid,'TFBdata.XDelay %.0f\n', XDelay);
   fprintf(fid,'TFBdata.YDelay %.0f\n', YDelay);
   
   fprintf(fid,'LFBdata.FrontEndDelay %.0f\n', FrontEndDelay);
   fprintf(fid,'LFBdata.FEPhaseOffset %.0f\n', FEPhaseOffset);
   fprintf(fid,'LFBdata.FEPhaseShift %.0f\n', FEPhaseShift);
   fprintf(fid,'LFBdata.FEGainSign %s\n', FEGainSign);
   fprintf(fid,'LFBdata.BackEndDelay %.0f\n', BackEndDelay);
   fprintf(fid,'LFBdata.QPSKAtten %.0f\n', QPSKAtten);
   fprintf(fid,'LFBdata.FillPattern %s\n', FillPattern);
   fprintf(fid,'LFBdata.SynchrotronFreq %.0f\n', SynchrotronFreq);
   fprintf(fid,'LFBdata.CalculatedSynchrotronFreq %.0f\n', CalculatedSynchrotronFreq); 
   fprintf(fid,'LFBdata.RingShift %.0f\n', RingShift);
   fprintf(fid,'LFBdata.HoldBufferOffset %.0f\n', HoldBufferOffset);
   fprintf(fid,'LFBdata.MinDSPTime %.0f\n', MinDSPTime);
   fprintf(fid,'LFBdata.ShiftGain %.0f\n', ShiftGain);
   %fprintf(fid,'LFBdata.FilterPhase %.0f\n', FilterPhase);
   
   fprintf(fid,'THCdata.THC1MainAC %.3f\n', THC1MainAC);
   fprintf(fid,'THCdata.THC1MainAM %.3f\n', THC1MainAM);
%  fprintf(fid,'THCdata.THC1AuxAC %.3f\n', THC1AuxAC);
%  fprintf(fid,'THCdata.THC1AuxAM %.3f\n', THC1AuxAM);
   fprintf(fid,'THCdata.THC2MainAC %.3f\n', THC2MainAC);
   fprintf(fid,'THCdata.THC2MainAM %.3f\n', THC2MainAM);
%  fprintf(fid,'THCdata.THC2AuxAC %.3f\n', THC2AuxAC);
%  fprintf(fid,'THCdata.THC2AuxAM %.3f\n', THC2AuxAM);
   fprintf(fid,'THCdata.THC3MainAC %.3f\n', THC3MainAC);
   fprintf(fid,'THCdata.THC3MainAM %.3f\n', THC3MainAM);
%  fprintf(fid,'THCdata.THC3AuxAC %.3f\n', THC3AuxAC);
%  fprintf(fid,'THCdata.THC3AuxAM %.3f\n', THC3AuxAM);
   fprintf(fid,'beamcurrent %.3f\n', beamcurrent);
   %close file
   fclose(fid);
   
end

% Output
fprintf('\n  %.1f GeV goldenpage parameters saved to %s/%s.\n\n', GLOBAL_SR_GEV, pwd, FileName);


% Return to original directory
feval('cd', tmpdir);
