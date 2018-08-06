function [RFData, BUMPdata, TFBdata, LFBdata] = goldenpage(FileName);
% [RFdata, BUMPdata, TFBdata, LFBdata] = goldenpage(FileName)
%
%  FileName = goldenpage filename (no file extension, .txt assumed)
%

OpsDirectory = getfamilydata('Directory', 'OpsData');

if nargin < 1
	[fid, err] = fopen([OpsDirectory,'GoldenPage.txt'],'rt');
else
	if strcmp(FileName(end-3:end),'.txt') == 0
		FileName = [FileName,'.txt'];
	end
	[fid, err] = fopen(FileName,'rt');
end

if fid < 0
	fprintf('  \n%s\n  ALSVARS canceled due to SR mode file problem.\n\n', err);
	return
end


while ~feof(fid)
	tline = fgets(fid);
		
	if isempty(tline)
		% blank
	elseif tline(1) == '#'
		% Comment
	elseif findstr('ASLFileName',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		ASLFileName = sscanf(tline,'%s',1);
	elseif findstr('BTSFileName',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BTSFileName = sscanf(tline,'%s',1);
	elseif findstr('PulseMagnetFileName',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		PulseMagnetFileName = sscanf(tline,'%s',1);
	
	elseif findstr('RFdata.C1TempFBoffAC',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		RFdata.C1TempFBoffAC = sscanf(tline,'%f',1);
	elseif findstr('RFdata.C2TempFBoffAC',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		RFdata.C2TempFBoffAC = sscanf(tline,'%f',1);
	elseif findstr('RFdata.C1TempFBonAC',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		RFdata.C1TempFBonAC = sscanf(tline,'%f',1);
	elseif findstr('RFdata.C1TempFBonAM',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		RFdata.C1TempFBonAM = sscanf(tline,'%f',1);
	elseif findstr('RFdata.C2TempFBonAC',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		RFdata.C2TempFBonAC = sscanf(tline,'%f',1);
	elseif findstr('RFdata.C2TempFBonAM',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		RFdata.C2TempFBonAM = sscanf(tline,'%f',1);
	elseif findstr('RFdata.Power',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		RFdata.Power = sscanf(tline,'%f',1);
	
	elseif findstr('BUMPdata.BRBump1',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.BRBump1 = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.BRBump2',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.BRBump2 = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.BRBump3',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.BRBump3 = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.BR2SENTiming',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.BR2SENTiming = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.BR2SEKTiming',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.BR2SEKTiming = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.BR2SEN',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.BR2SEN = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.BR2SEK',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.BR2SEK = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.BR2KETiming',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.BR2KETiming = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.BR2KE',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.BR2KE = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.ExtFldTrigTiming',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.ExtFldTrigTiming = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.BRBumpTrigTiming',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.BRBumpTrigTiming = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.SRSEKTiming',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.SRSEKTiming = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.SRSEK',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.SRSEK = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.SRSENTiming',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.SRSENTiming = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.SRSEN',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.SRSEN = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.SRBUMP1Timing',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.SRBUMP1Timing = sscanf(tline,'%f',1);
	elseif findstr('BUMPdata.SRBUMP1',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		BUMPdata.SRBUMP1 = sscanf(tline,'%f',1);
	
	elseif findstr('TFBdata.X1Bias',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		TFBdata.X1Bias = sscanf(tline,'%f',1);
	elseif findstr('TFBdata.Y1Bias',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		TFBdata.Y1Bias = sscanf(tline,'%f',1);
	elseif findstr('TFBdata.X2Bias',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		TFBdata.X2Bias = sscanf(tline,'%f',1);
	elseif findstr('TFBdata.Y2Bias',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		TFBdata.Y2Bias = sscanf(tline,'%f',1);
	elseif findstr('TFBdata.XAtten',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		TFBdata.XAtten = sscanf(tline,'%f',1);
	elseif findstr('TFBdata.YAtten',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		TFBdata.YAtten = sscanf(tline,'%f',1);
	elseif findstr('TFBdata.XDelay',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		TFBdata.XDelay = sscanf(tline,'%f',1);
	elseif findstr('TFBdata.YDelay',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		TFBdata.YDelay = sscanf(tline,'%f',1);
	
	elseif findstr('LFBdata.FrontEndDelay',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.FrontEndDelay = sscanf(tline,'%f',1);
	elseif findstr('LFBdata.FEPhaseOffset',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.FEPhaseOffset = sscanf(tline,'%f',1);
	elseif findstr('LFBdata.FEPhaseShift',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.FEPhaseShift = sscanf(tline,'%f',1);
	elseif findstr('LFBdata.FEGainSign',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.FEGainSign = sscanf(tline,'%s',1);
	elseif findstr('LFBdata.BackEndDelay',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.BackEndDelay = sscanf(tline,'%f',1);
	elseif findstr('LFBdata.QPSKAtten',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.QPSKAtten = sscanf(tline,'%f',1);	 
	elseif findstr('LFBdata.FillPattern',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.FillPattern = sscanf(tline,'%s',1);	 
	elseif findstr('LFBdata.SynchrotronFreq',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.SynchrotronFreq = sscanf(tline,'%f',1);
	elseif findstr('LFBdata.CalculatedSynchrotronFreq',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.CalculatedSynchrotronFreq = sscanf(tline,'%f',1);
	elseif findstr('LFBdata.RingShift',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.RingShift = sscanf(tline,'%f',1);	 
	elseif findstr('LFBdata.HoldBufferOffset',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.HoldBufferOffset = sscanf(tline,'%f',1);
	elseif findstr('LFBdata.MinDSPTime',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.MinDSPTime = sscanf(tline,'%f',1);
	elseif findstr('LFBdata.ShiftGain',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.ShiftGain = sscanf(tline,'%f',1);
	elseif findstr('LFBdata.FilterPhase',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		LFBdata.FilterPhase = sscanf(tline,'%f',1);	

	elseif findstr('THCdata.THC1MainAC',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		THCdata.THC1MainAC = sscanf(tline,'%f',1);	
	elseif findstr('THCdata.THC1MainAM',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		THCdata.THC1MainAM = sscanf(tline,'%f',1);	
%	elseif findstr('THCdata.THC1AuxAC',tline)
%		tmp = sscanf(tline,'%s',1);
%		tline(1:length(tmp)) = [];
%		THCdata.THC1AuxAC = sscanf(tline,'%f',1);	
%	elseif findstr('THCdata.THC1AuxAM',tline)
%		tmp = sscanf(tline,'%s',1);
%		tline(1:length(tmp)) = [];
%		THCdata.THC1AuxAM = sscanf(tline,'%f',1);	
	elseif findstr('THCdata.THC2MainAC',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		THCdata.THC2MainAC = sscanf(tline,'%f',1);	
	elseif findstr('THCdata.THC2MainAM',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		THCdata.THC2MainAM = sscanf(tline,'%f',1);	
%	elseif findstr('THCdata.THC2AuxAC',tline)
%		tmp = sscanf(tline,'%s',1);
%		tline(1:length(tmp)) = [];
%		THCdata.THC2AuxAC = sscanf(tline,'%f',1);	
%	elseif findstr('THCdata.THC2AuxAM',tline)
%		tmp = sscanf(tline,'%s',1);
%		tline(1:length(tmp)) = [];
%		THCdata.THC2AuxAM = sscanf(tline,'%f',1);	
	elseif findstr('THCdata.THC3MainAC',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		THCdata.THC3MainAC = sscanf(tline,'%f',1);	
	elseif findstr('THCdata.THC3MainAM',tline)
		tmp = sscanf(tline,'%s',1);
		tline(1:length(tmp)) = [];
		THCdata.THC3MainAM = sscanf(tline,'%f',1);	
%	elseif findstr('THCdata.THC3AuxAC',tline)
%		tmp = sscanf(tline,'%s',1);
%		tline(1:length(tmp)) = [];
%		THCdata.THC3AuxAC = sscanf(tline,'%f',1);	
%	elseif findstr('THCdata.THC3AuxAM',tline)
%		tmp = sscanf(tline,'%s',1);
%		tline(1:length(tmp)) = [];
%		THCdata.THC3AuxAM = sscanf(tline,'%f',1);	
%	elseif findstr('THCdata.THC4MainAC',tline)
%		tmp = sscanf(tline,'%s',1);
%		tline(1:length(tmp)) = [];
%		THCdata.THC4MainAC = sscanf(tline,'%f',1);	
%	elseif findstr('THCdata.THC4MainAM',tline)
%		tmp = sscanf(tline,'%s',1);
%		tline(1:length(tmp)) = [];
%		THCdata.THC4MainAM = sscanf(tline,'%f',1);	
%	elseif findstr('THCdata.THC4AuxAC',tline)
%		tmp = sscanf(tline,'%s',1);
%		tline(1:length(tmp)) = [];
%		THCdata.THC4AuxAC = sscanf(tline,'%f',1);	
%   elseif findstr('THCdata.THC4AuxAM',tline)
%      tmp = sscanf(tline,'%s',1);
%      tline(1:length(tmp)) = [];
%      THCdata.THC4AuxAM = sscanf(tline,'%f',1);	
%   elseif findstr('THCdata.THC5MainAC',tline)
%      tmp = sscanf(tline,'%s',1);
%      tline(1:length(tmp)) = [];
%      THCdata.THC5MainAC = sscanf(tline,'%f',1);	
%   elseif findstr('THCdata.THC5MainAM',tline)
%      tmp = sscanf(tline,'%s',1);
%      tline(1:length(tmp)) = [];
%      THCdata.THC5MainAM = sscanf(tline,'%f',1);	
%   elseif findstr('THCdata.THC5AuxAC',tline)
%      tmp = sscanf(tline,'%s',1);
%      tline(1:length(tmp)) = [];
%      THCdata.THC5AuxAC = sscanf(tline,'%f',1);	
%   elseif findstr('THCdata.THC5AuxAM',tline)
%      tmp = sscanf(tline,'%s',1);
%      tline(1:length(tmp)) = [];
%      THCdata.THC5AuxAM = sscanf(tline,'%f',1);	
   elseif findstr('beamcurrent',tline)
      tmp = sscanf(tline,'%s',1);
      tline(1:length(tmp)) = [];
      beamcurrent = sscanf(tline,'%f',1);
   end
   
end	

fclose(fid);


% Printing section
fid = 1;
fprintf(fid,'  ** GOLDEN PAGE for: %s   **\n\n', getfamilydata('OperationalMode'));
fprintf(fid,'  Physics Parameters:\n');
fprintf(fid,'                Tune     Chromaticity \n');
GoldenTune = getgolden('TUNE');
GoldenChromaticity = getgolden('Chromaticity');
fprintf(fid,'  Horizontal:  %.3f       %.2f \n',    GoldenTune(1), GoldenChromaticity(1));
fprintf(fid,'    Vertical:   %.3f       %.2f \n\n', GoldenTune(2), GoldenChromaticity(2));

[SP, AM]= getproductionlattice;
BENDspp = SP.BEND.Setpoint.Data(1);
i = findrowindex([4 2;8 2;12 2],SP.BEND.Setpoint.DeviceList);
BSCspp = SP.BEND.Setpoint.Data(i);
i = findrowindex([1 1;4 2;8 2;12 2],SP.QFA.Setpoint.DeviceList);
QFAspp = SP.QFA.Setpoint.Data(i);
QDAspp = SP.QDA.Setpoint.Data;
SFspp = SP.SF.Setpoint.Data(1);
SDspp = SP.SD.Setpoint.Data(1);
QFspp = SP.QF.Setpoint.Data;
QDspp = SP.QD.Setpoint.Data;
HCMspp = SP.HCM.Setpoint.Data;
VCMspp = SP.VCM.Setpoint.Data;
HCMCHICANEspp = SP.HCMCHICANE.Setpoint.Data;
%VCMCHICANEspp = VCMCHICANEsp;
HCMCHICANEMspp = SP.HCMCHICANEM.Setpoint.Data;
SQSFspp = SP.SQSF.Setpoint.Data;
SQSDspp = SP.SQSD.Setpoint.Data;
RFdata.FreqProd = SP.RF.Setpoint.Data;


[SP, AM]= getinjectionlattice;
BENDsp = SP.BEND.Setpoint.Data(1);
i = findrowindex([4 2;8 2;12 2],SP.BEND.Setpoint.DeviceList);
BSCsp = SP.BEND.Setpoint.Data(i);
i = findrowindex([1 1;4 2;8 2;12 2],SP.QFA.Setpoint.DeviceList);
QFAsp = SP.QFA.Setpoint.Data(i);
QDAsp = SP.QDA.Setpoint.Data;
SFsp = SP.SF.Setpoint.Data(1);
SDsp = SP.SD.Setpoint.Data(1);
QFsp = SP.QF.Setpoint.Data;
QDsp = SP.QD.Setpoint.Data;
HCMsp = SP.HCM.Setpoint.Data;
VCMsp = SP.VCM.Setpoint.Data;
HCMCHICANEsp = SP.HCMCHICANE.Setpoint.Data;
%VCMCHICANEsp = VCMCHICANEsp;
HCMCHICANEMsp = SP.HCMCHICANEM.Setpoint.Data;
SQSFsp = SP.SQSF.Setpoint.Data;
SQSDsp = SP.SQSD.Setpoint.Data;
RFdata.FreqInj = SP.RF.Setpoint.Data;


fprintf(fid,'  Lattice Parameters:\n');
fprintf(fid,'             ACL magnet filename:  %s\n', ASLFileName);
fprintf(fid,'             BTS magnet filename:  %s\n', BTSFileName);
fprintf(fid,'          Pulsed magnet filename:  %s\n', PulseMagnetFileName);
fprintf(fid,'  SR injection  lattice filename:  %s%s\n',   OpsDirectory, getfamilydata('OpsData', 'InjectionFile'));
fprintf(fid,'  SR production lattice filename:  %s%s\n',   OpsDirectory, getfamilydata('OpsData', 'LatticeFile'));
fprintf(fid,'             Goldenpage filename:  %s%s\n\n', OpsDirectory, 'GoldenPage.txt');


fprintf(fid,'         Setpoints:  Production                                  Injection\n');
fprintf(fid,'              BEND:  %7.3f                                     %7.3f  Amps \n', BENDspp, BENDsp);
fprintf(fid,' SUPERBEND(4,8,12):  %5.2f, %5.2f, %5.2f                      %5.2f, %5.2f, %5.2f  Amps \n', BSCspp(1),BSCspp(2),BSCspp(3),BSCsp(1),BSCsp(2),BSCsp(3));
%fprintf(fid,'              QFA1:  %7.3f                                     %7.3f  Amps \n', QFAspp(1), QFAsp(1));
%fprintf(fid,'       QFA(4,8,12):  %7.3f                                     %7.3f  Amps (average)\n', mean(QFAspp(2:4)), mean(QFAsp(2:4)));
%fprintf(fid,'       QDA(4,8,12):  %7.3f                                     %7.3f  Amps (average)\n', mean(QDAspp), mean(QDAsp));
fprintf(fid,'     QFA(1,4,8,12):  %7.3f, %7.3f, %7.3f, %7.3f          %7.3f, %7.3f, %7.3f, %7.3f  Amps\n', QFAspp(1),QFAspp(2),QFAspp(3),QFAspp(4),QFAsp(1),QFAsp(2),QFAsp(3),QFAsp(4));
fprintf(fid,'       QDA(4,8,12):  %7.3f,%7.3f,%7.3f                    %7.3f,%7.3f,%7.3f  Amps\n', QDAspp(1), QDAspp(2), QDAspp(3), QDAsp(1), QDAsp(2), QDAsp(3));
fprintf(fid,'                SF:  %7.3f                                     %7.3f  Amps \n', SFspp, SFsp);
fprintf(fid,'                SD:  %7.3f                                     %7.3f  Amps \n', SDspp, SDsp);
fprintf(fid,'                QF:  %7.3f                                    %7.3f  Amps (average)\n', mean(QFspp), mean(QFsp));
fprintf(fid,'                QD:  %7.3f                                    %7.3f  Amps (average)\n', mean(QDspp), mean(QDsp));
fprintf(fid,'               HCM:  %7.3f                                   %7.3f  Amps (max)\n', max(abs(HCMspp([1:78 81:end]))), max(abs(HCMsp([1:78 81:end])))); % don't include chicanes
fprintf(fid,'               VCM:  %7.3f                                   %7.3f  Amps (max)\n', max(abs(VCMspp)), max(abs(VCMsp)));
i = findrowindex([4 1;4 3],SP.HCMCHICANE.Setpoint.DeviceList);
fprintf(fid,'   SR04 HCMCHICANE: %5.2f       %5.2f                         %5.2f       %5.2f  Amps \n', HCMCHICANEspp(i(1)),HCMCHICANEspp(i(2)), HCMCHICANEsp(i(1)),HCMCHICANEsp(i(2)));
i = findrowindex([6 1],SP.HCMCHICANE.Setpoint.DeviceList);
fprintf(fid,'   SR06 HCMCHICANE:  %5.2f                                       %5.2f               Amps \n', HCMCHICANEspp(i(1)), HCMCHICANEsp(i(1)));
%fprintf(fid,'      SR04 HCMCHIC: %5.2f,%5.2f,%5.2f                         %5.2f,%5.2f,%5.2f  Amps \n', HCMCHICANEspp(1),HCMCHICANEspp(2),HCMCHICANEspp(3),HCMCHICANEsp(1),HCMCHICANEsp(2),HCMCHICANEsp(3));
%fprintf(fid,'      SR11 HCMCHIC: %5.2f,%5.2f,%5.2f                         %5.2f,%5.2f,%5.2f  Amps \n', HCMspp(79),HCMCHICANEspp(4),HCMspp(80),HCMsp(79),HCMCHICANEsp(4),HCMsp(80));
%fprintf(fid,'   4&11 VCMCHICANE: %5.2f,%5.2f,%5.2f,%5.2f                     %5.2f,%5.2f,%5.2f,%5.2f  Amps \n', VCMCHICANEspp(1),VCMCHICANEspp(2),VCMCHICANEspp(3),VCMCHICANEspp(4),VCMCHICANEsp(1),VCMCHICANEsp(2),VCMCHICANEsp(3),VCMCHICANEsp(4));
i = findrowindex([4 1;4 2;4 3],SP.HCMCHICANEM.Setpoint.DeviceList);
fprintf(fid,' SR04 MotorCHICANE: %6.2f,%6.2f,%5.2f                         %6.2f,%6.2f,%5.2f  [Degrees,Degrees,mm] \n', HCMCHICANEMspp(i(1)),HCMCHICANEMspp(i(2)),HCMCHICANEMspp(i(3)),HCMCHICANEMsp(i(1)),HCMCHICANEMsp(i(2)),HCMCHICANEMsp(i(3)));
i = findrowindex([6 1;6 2;],SP.HCMCHICANEM.Setpoint.DeviceList);
fprintf(fid,' SR06 MotorCHICANE: %6.2f,%6.2f                               %6.2f,%6.2f        [Degrees,Degrees,mm] \n', HCMCHICANEMspp(i(1)),HCMCHICANEMspp(i(2)), HCMCHICANEMsp(i(1)),HCMCHICANEMsp(i(2)));
i = findrowindex([11 1;11 2;11 3],SP.HCMCHICANEM.Setpoint.DeviceList);
fprintf(fid,' SR11 MotorCHICANE: %6.2f,%6.2f,%5.2f                         %6.2f,%6.2f,%5.2f  [Degrees,Degrees,mm] \n', HCMCHICANEMspp(i(1)),HCMCHICANEMspp(i(2)),HCMCHICANEMspp(i(3)),HCMCHICANEMsp(i(1)),HCMCHICANEMsp(i(2)),HCMCHICANEMsp(i(3)));

% fprintf(fid,'              SQSF: %4.1f,%4.1f,%4.1f,%4.1f,%4.1f,%4.1f,              %4.1f,%4.1f,%4.1f,%4.1f,%4.1f,%4.1f, Amps\n', SQSFspp(1),SQSFspp(2),SQSFspp(3),SQSFspp(4),SQSFspp(5),SQSFspp(6),SQSFsp(1),SQSFsp(2),SQSFsp(3),SQSFsp(4),SQSFsp(5),SQSFsp(6));
% fprintf(fid,'                    %4.1f,%4.1f,%4.1f,%4.1f,%4.1f,%4.1f               %4.1f,%4.1f,%4.1f,%4.1f,%4.1f,%4.1f  Amps\n', SQSFspp(7),SQSFspp(8),SQSFspp(9),SQSFspp(10),SQSFspp(11),SQSFspp(12),SQSFsp(7),SQSFsp(8),SQSFsp(9),SQSFsp(10),SQSFsp(11),SQSFsp(12));
% fprintf(fid,'              SQSD: %4.1f,%4.1f,%4.1f,%4.1f,%4.1f,%4.1f,              %4.1f,%4.1f,%4.1f,%4.1f,%4.1f,%4.1f, Amps\n', SQSDspp(1),SQSDspp(2),SQSDspp(3),SQSDspp(4),SQSDspp(5),SQSDspp(6),SQSDsp(1),SQSDsp(2),SQSDsp(3),SQSDsp(4),SQSDsp(5),SQSDsp(6));
% fprintf(fid,'                    %4.1f,%4.1f,%4.1f,%4.1f,%4.1f,%4.1f               %4.1f,%4.1f,%4.1f,%4.1f,%4.1f,%4.1f  Amps\n', SQSDspp(7),SQSDspp(8),SQSDspp(9),SQSDspp(10),SQSDspp(11),SQSDspp(12),SQSDsp(7),SQSDsp(8),SQSDsp(9),SQSDsp(10),SQSDsp(11),SQSDsp(12));

%fprintf(fid,'          RF Freq:  %9.7f                %9.7f MHz  (Synthesizer AC)\n', RFdata.RFSynthesizerACProd, RFdata.RFSynthesizerACProd);
%fprintf(fid,'          RF Freq:  %9.7f                %9.7f MHz  (Synthesizer AM)\n', RFdata.RFSynthesizerAMProd, RFdata.RFSynthesizerAMProd);
fprintf(fid,'           RF Freq:  %12.8f                                %12.8f MHz \n\n', RFdata.FreqProd, RFdata.FreqInj);

fprintf(fid,'  SR RF parameters:     FB on setpoints   FB on monitors     FB off setpoints\n')
fprintf(fid,'     Cavity 1 Temp:       %5.1f             %6.2f             %5.1f            Celsius\n', RFdata.C1TempFBonAC, RFdata.C1TempFBonAM, RFdata.C1TempFBoffAC);
fprintf(fid,'     Cavity 2 Temp:       %5.1f             %6.2f             %5.1f            Celsius\n', RFdata.C2TempFBonAC, RFdata.C2TempFBonAM, RFdata.C2TempFBoffAC);
fprintf(fid,'          RF Power:  %5.1f kWatts (PRO VAL in Ctlplay)\n\n', RFdata.Power);

fprintf(fid,'  Transverse Feedback Parameters:\n');
showtfb;
% fprintf(fid,'  X1-Bias  Y1-Bias  X2-Bias  Y2-Bias  X-Atten  Y-Atten  X-Delay  Y-Delay\n');
% fprintf(fid,'  %6.2f   %6.2f   %6.2f   %6.2f   %5d    %5d    %5d    %5d\n\n', TFBdata.X1Bias, TFBdata.Y1Bias, TFBdata.X2Bias, TFBdata.Y2Bias, TFBdata.XAtten, TFBdata.YAtten, TFBdata.XDelay, TFBdata.YDelay);

% fprintf(fid,'  Longitudinal Feedback Parameters:\n');
% fprintf(fid,'  Front-End-Delay  Front-End-Phase-Offset  Front-End-Phase-Shift  Front-End-Gain-Sign  Back-End-Delay  QPSK-Attenuation\n');
% fprintf(fid,'   %6d              %6.0f                   %6.0f                 %6s             %6d         %6d\n', ...
% 					LFBdata.FrontEndDelay, LFBdata.FEPhaseOffset, LFBdata.FEPhaseShift, LFBdata.FEGainSign, LFBdata.BackEndDelay, LFBdata.QPSKAtten);
% fprintf(fid,'  Fill-Pattern  Synchrotron-Frequency  Ring-Shift  Hold-Buffer-Offset  Min-DSP-Processing-Time  Shift-Gain\n');
% fprintf(fid,'     %5s            %d Hz         %6d         %6d                  %6d           %6d\n\n', ...
%                LFBdata.FillPattern, LFBdata.SynchrotronFreq, LFBdata.RingShift, LFBdata.HoldBufferOffset, LFBdata.MinDSPTime, LFBdata.ShiftGain);

%fprintf(fid,'  Calculated Synchrotron Frequency = %d Hz   (coming soon...)\n\n', LFBdata.CalculatedSynchrotronFreq);

fprintf(fid,'  Pulsed Magnet Parameters:\n');
fprintf(fid,'            BR-BUMP1   BR-BUMP1   BR-BUMP1  \n');
fprintf(fid,'  Setpoint: %7.1f    %7.1f   %7.1f \n\n', BUMPdata.BRBump1, BUMPdata.BRBump2, BUMPdata.BRBump3);


fprintf(fid,'            BR2-SEN   BR2-SEK   BR2-KE   ExtFldTrig   BR-BumpTrig   SR-SEK   SR-SEN   SR-BUMP\n');
fprintf(fid,'  Setpoint: %7.1f   %7.1f %7.1f                              %7.1f  %7.1f  %7.1f\n', ...
	BUMPdata.BR2SEN, BUMPdata.BR2SEK, BUMPdata.BR2KE, BUMPdata.SRSEK, BUMPdata.SRSEN, BUMPdata.SRBUMP1);
fprintf(fid,'    Timing: %6d  %6d      %6d  %9d     %9d %8d  %8d %9d\n\n', ...
	BUMPdata.BR2SENTiming, BUMPdata.BR2SEKTiming, BUMPdata.BR2KETiming, BUMPdata.ExtFldTrigTiming, ...
	BUMPdata.BRBumpTrigTiming, BUMPdata.SRSEKTiming, BUMPdata.SRSENTiming, BUMPdata.SRBUMP1Timing);

fprintf(fid,'  Third Harmonic Cavities Tuner Parameters:\n');
fprintf(fid,'            CAV1 Tuner1  CAV2 Tuner1  CAV3 Tuner1\n');
fprintf(fid,'  Setpoint:    %5.3f        %5.3f        %5.3f \n', ...
   THCdata.THC1MainAC, THCdata.THC2MainAC, THCdata.THC3MainAC);
fprintf(fid,'   Monitor:    %5.3f        %5.3f        %5.3f        (monitors read at %3.0f mA)\n', ...
   THCdata.THC1MainAM, THCdata.THC2MainAM, THCdata.THC3MainAM, beamcurrent);



% % Comment line
% line = fgetl(fid);
% 
% VariableName = fscanf(fid,'%s',1);
% ValueStr = fscanf(fid,'%s\n',1);
% eval([VariableName,'=''',ValueStr,''';']);
% 
% VariableName = fscanf(fid,'%s',1);
% ValueStr = fscanf(fid,'%s\n',1);
% eval([VariableName,'=''',ValueStr,''';']);
% 
% VariableName = fscanf(fid,'%s',1);
% ValueStr = fscanf(fid,'%s\n',1);
% eval([VariableName,'=''',ValueStr,''';']);
% 
% for i = 1:37
%    VariableName = fscanf(fid,'%s',1);
%    Value = fscanf(fid,'%g\n',1);
%    eval([VariableName,'=',num2str(Value),';']);
% end
% 
% % 3 File Names
% % VariableName = fscanf(fid,'%s',1);
% % ValueStr = fscanf(fid,'%s\n',1);
% % assignin('base',VariableName,ValueStr);
% % 
% % VariableName = fscanf(fid,'%s',1);
% % ValueStr = fscanf(fid,'%s\n',1);
% % assignin('base',VariableName,ValueStr);
% % 
% % VariableName = fscanf(fid,'%s',1);
% % ValueStr = fscanf(fid,'%s\n',1);
% % assignin('base',VariableName,ValueStr);
% % 
% % for i = 1:37
% %    VariableName = fscanf(fid,'%s',1);
% %    Value = fscanf(fid,'%g\n',1);
% %    assignin('base',VariableName,num2str(Value));
% % end
