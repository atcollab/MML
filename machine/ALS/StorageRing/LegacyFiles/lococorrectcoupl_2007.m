% lococorrectcoupl_2007
%
% This routine reads the results of a LOCO analysis of the ALS lattice (83 fit parameters)
% and calculates the skew quadrupole settings to correct the coupling. It allows to set
% the results.
%
% It includes the changes to skew quadrupole cabling (2005) as well as the
% the setpoints for the local dispersion bump in straight 6 (10 skews). It
% allows to set a global dispersion wave simultaneously, using all skew
% quadrupoles except the ones in arc 5.
%
% The final addition is the option to select, whether the current lattice
% is the 6 cm distributed dispersion one or the zero dispersion lattice.
% The local dispersion bump can only be set in the distributed dispersion
% lattice.
%
% Christoph Steier, February 2007


setlocodata('CorrectCoupling');


% 
% % Indices of magnets to use
% 
% SQSFindex = [1 1; 3 1; 3 2; 6 2; 7 2; 9 1; 11 1];
% SQSFind = [1 2 3 7 9 10 11];
% HCSFindex = [5 2;7 1];
% HCSFind = [5 8];
% HCSFindex2 = [5 4;6 4];
% HCSFind2 = [4 6];
% SQSDindex = [2 1; 3 1; 3 2; 4 1; 6 1; 6 2; 7 1; 7 2; 8 1; 10 1; 12 1];
% SQSDind = [12 13 14 15 18 19 20 21 22 23 24];
% HCSDindex = [5 1;5 2];
% HCSDind = [16 17];
% 
% energy = getenergy; 
% 
% if energy<0.7
%     error('cannot read the storage ring energy! exiting ...');
% end
% 
% dispflag =  questdlg(str2mat('Which Lattice?'),sprintf('%.1f GeV nuy = 9.20 lattice correction',energy),'zero dispersion','distributed dispersion','distributed dispersion');
% 
% % scaling factors [A/m^-2] (based on magnetic measurements of skew quadrupoles)
% % SQSF are weaker because the higher sextupole strength causes pole
% % saturation.
% 
% if energy > 1.7
%     SQSFfac = 20.0/0.11*energy/1.894;
%     HCSFfac = 6.1/0.11*energy/1.894;
%     HCSDfac = 4.6/0.11*energy/1.894;
% else
%     SQSFfac = 14.0/0.11*energy/1.894;
%     HCSFfac = 6.1/0.11*energy/1.894;    % probably not correct; but saturation unknow so far
%     HCSDfac = 4.6/0.11*energy/1.894;    % probably not correct; but saturation unknow so far
% end
% 
% SQSDfac = 14.0/0.11*energy/1.894;
% HCSFfac2 = SQSFfac/4.7;
% 
% % calculation routine ...
% 
% % Local dispersion bump:
% % Theoretical k values [m^-2] for the skews by Walter Wittmer
% 
% DispBumpVect_K.SQSF = [ -0.36984004      % [5 1]
%     -0.22817710      % [5 2]
%     -0.25978570      % [6 1]
%     -0.10999989      % [6 2]
%     -0.05744313      % [7 1]
%     -0.09800899];    % [7 2]
% 
% SQSFBumpindex = [4 5 6 7 8 9];
% 
% DispBumpVect_K.SQSD = [  0.22515577       % [5 1]
%     -0.03016227       % [5 2]
%     -0.03330246       % [6 1]
%     0.03189800  ];   % [6 2]
% 
% SQSDBumpindex = [16 17 18 19];
% 
% if strcmp(dispflag,'distributed dispersion')
%     prompt={'Enter the factor for local eta_y bump'};
%     def={'1.0'};
%     dlgTitle='Selection of dispersion bump size';
%     lineNo=1;
%     answernum=inputdlg(prompt,dlgTitle,lineNo,def);
% 
%     factor_bump = str2double(answernum{1})*(-1);
% else
%     factor_bump = 0;
% end
% 
% 
% [locofilename,locofilepath] = uigetfile('*.mat','LOCO results: filename');
% 
% if isempty(locofilename) | (locofilename == 0)
%     error('You have selected an invalid LOCO results filename');
% end
% 
% load(locofilename);
% 
% numiter = size(FitParameters,2);
% 
% % allow to correct to lattice with etaywave - do not always correct to small coupling!
% 
% % Theoretical k values [m^-2] for the skews as determined with a fit using
% %the accelerator toolbox.
% 
% % First 11 entries are SQSF, last 13 are SQSD
% 
% if strcmp(dispflag,'distributed dispersion')
%     disp('distributed dispersion')
%     skew_wave = [ 0.01049061974609; 0.01140933697991;-0.04030875696656; ...
%         0.00000000000000; 0.00000000000000;-0.05502813334686; ...
%         0.01542076460695;-0.01619516668507; 0.00789235914796; ...
%         0.00131257163789; 0.00103749322207; ...
%         -0.03848844279225;-0.01638239892977;-0.01260762847070; ...
%         -0.01719182683414; 0.00000000000000; 0.00000000000000; ...
%         -0.00012424401083;-0.00830469993127;-0.00037523106600; ...
%         -0.03827790708473;-0.02139034673185;-0.01107856244175; ...
%         0.02111710213345];
% else
%     disp('zero dispersion');
%     skew_wave = [0.01157297379474;0.01119306834886;-0.03365503399306; ...
%         -0.00000000000000;0.00000000000000;-0.04751476955472; ...
%         0.01514092010687;-0.01597486848438;0.01029755374564; ...
%         0.00138907222726;0.00107982276350; ...
%         -0.03612300082450;-0.01532848704077;-0.01198859969586; ...
%         -0.01717691979496;-0.00000000000000;-0.00000000000000; ...
%         -0.00012471625950;-0.00945953402402;-0.00032774806922; ...
%         -0.03708187010264;-0.02488363394460;-0.01066978009210; ...
%         0.01884052079746];
% end
% 
% prompt={'Enter the factor for global eta_y wave'};
% def={'0.8'};
% dlgTitle='Selection whether to correct to small emittance, or user settings';
% lineNo=1;
% answernum=inputdlg(prompt,dlgTitle,lineNo,def);
% 
% factor = str2double(answernum{1})*(-1);
% 
% total_skew_k = factor*skew_wave;
% total_skew_k(SQSFBumpindex) = total_skew_k(SQSFBumpindex)+factor_bump*DispBumpVect_K.SQSF;
% total_skew_k(SQSDBumpindex) = total_skew_k(SQSDBumpindex)+factor_bump*DispBumpVect_K.SQSD;
% 
% 
% 
% if length(FitParameters(numiter).Values)==83
% 
%     if 1
%         % Coupling correction & dispersion bump & wave
%         SQSFincr=(FitParameters(numiter).Values(59+SQSFind)-total_skew_k(SQSFind))*SQSFfac;
%         SQSDincr=(FitParameters(numiter).Values(59+SQSDind)-total_skew_k(SQSDind))*SQSDfac;
%         HCSFincr=(FitParameters(numiter).Values(59+HCSFind)-total_skew_k(HCSFind))*HCSFfac;
%         HCSDincr=(FitParameters(numiter).Values(59+HCSDind)-total_skew_k(HCSDind))*HCSDfac;
%         HCSFincr2=(FitParameters(numiter).Values(59+HCSFind2)-total_skew_k(HCSFind2))*HCSFfac2;
%     else
%         % Dispersion bump & wave only
%         SQSFincr=-total_skew_k(SQSFind)*SQSFfac;
%         SQSDincr=-total_skew_k(SQSDind)*SQSDfac;
%         HCSFincr=-total_skew_k(HCSFind)*HCSFfac;
%         HCSDincr=-total_skew_k(HCSDind)*HCSDfac;
%         HCSFincr2=-total_skew_k(HCSFind2)*HCSFfac2;
%     end
% 
%     
%     figure
% 
%     subplot(4,1,1)
%     bar([SQSFincr;HCSFincr;HCSFincr2])
%     axis([0.5 11.5 -20 20])
%     grid on
% 
% 
%     subplot(4,1,2)
%     bar([SQSDincr;HCSDincr])
%     axis([0.5 13.5 -20 20])
%     grid on
% 
%     SQSFold = getsp('SQSF',SQSFindex);
%     SQSDold = getsp('SQSD',SQSDindex);
%     HCSFold = getsp('SQSF',HCSFindex);
%     HCSFold2 = getsp('HCM',HCSFindex2);
%     HCSDold = getsp('SQSD',HCSDindex);
% 
%     subplot(4,1,3)
%     bar([SQSFold SQSFold+SQSFincr;HCSFold HCSFold+HCSFincr;HCSFold2 HCSFold2+HCSFincr2])
%     axis([0.5 11.5 -20 20])
%     grid on
% 
%     subplot(4,1,4)
%     bar([SQSDold SQSDold+SQSDincr;HCSDold HCSDold+HCSDincr])
%     axis([0.5 13.5 -20 20])
%     grid on
% 
%     if any(abs(SQSDold+SQSDincr)>20) | any(abs(HCSDold+HCSDincr)>17)
%        error('Maximum HCSD or SQSD setpoint would be exceeded');
%     end
%        
%     if any(abs(SQSFold+SQSFincr)>20) | any(abs(HCSFold+HCSFincr)>17) | any(abs(HCSFold2+HCSFincr2)>17)
%        error('Maximum HCSF or SQSF setpoint would be exceeded');
%     end
%        
%     % Last chance to stop
%     CorrFlag = questdlg(str2mat('Do you want to set skew correction?'),sprintf('%.1f GeV Coupling Correction',energy),'Yes','No','No');
%     if strcmp(CorrFlag,'No')
%         disp('  No correction made.');
%         SQSFnew = getsp('SQSF',SQSFindex);
%         SQSDnew = getsp('SQSD',SQSDindex);
%         HCSFnew = getsp('SQSF',HCSFindex);
%         HCSFnew2 = getsp('HCM',HCSFindex2);
%         HCSDnew = getsp('SQSD',HCSDindex);
%     elseif strcmp(CorrFlag,'Yes')
%         disp('  Setting new skew quadrupole values (incremental).');
%         stepsp('SQSF',SQSFincr,SQSFindex,0);
%         stepsp('SQSD',SQSDincr,SQSDindex,0);
%         stepsp('SQSF',HCSFincr,HCSFindex,0);
%         stepsp('HCM',HCSFincr2,HCSFindex2,0);
%         stepsp('SQSD',HCSDincr,HCSDindex,0);
% 
%         pause(0.5);
% 
%         SQSFnew = getsp('SQSF',SQSFindex);
%         SQSDnew = getsp('SQSD',SQSDindex);
%         HCSFnew = getsp('SQSF',HCSFindex);
%         HCSFnew2 = getsp('HCM',HCSFindex2);
%         HCSDnew = getsp('SQSD',HCSDindex);
% 
%         setsp('SQSF',SQSFnew,SQSFindex,2);
%         setsp('SQSD',SQSDnew,SQSDindex,2);
%         setsp('SQSF',HCSFnew,HCSFindex,2);
%         setsp('HCM',HCSFnew2,HCSFindex2,2);
%         setsp('SQSD',HCSDnew,HCSDindex,2);
% 
%         disp('  New skew quadrupole values have been set.');
%     else
%         error('  Unknown option.');
%     end
% 
%     subplot(4,1,3)
%     bar([SQSFnew-SQSFincr SQSFnew;HCSFnew-HCSFincr HCSFnew;HCSFnew2-HCSFincr2 HCSFnew2])
%     axis([0.5 11.5 -20 20])
%     grid on
% 
% 
%     subplot(4,1,4)
%     bar([SQSDnew-SQSDincr SQSDnew;HCSDnew-HCSDincr HCSDnew])
%     axis([0.5 13.5 -20 20])
%     grid on
% 
%     orient tall;
% 
% %     if strcmp(CorrFlag,'Yes')
% % 
% %         % Keep changes ?
% %         KeepFlag = questdlg(str2mat('Do you want to keep the changes?'),sprintf('%.1f GeV Coupling Correction',energy),'Yes','No','Yes');
% %         if strcmp(KeepFlag,'No')
% %             disp('  Backing out skew correction.');
% %             stepsp('SQSF',-SQSFincr,SQSFindex,0);
% %             stepsp('SQSD',-SQSDincr,SQSDindex,0);
% %             stepsp('SQSF',-HCSFincr,HCSFindex,0);
% %             stepsp('HCM',-HCSFincr2,HCSFindex2,0);
% %             stepsp('SQSD',-HCSDincr,HCSDindex,0);
% % 
% %             pause(0.5);
% % 
% %             SQSFnew = getsp('SQSF',SQSFindex);
% %             SQSDnew = getsp('SQSD',SQSDindex);
% %             HCSFnew = getsp('SQSF',HCSFindex);
% %             HCSFnew2 = getsp('HCM',HCSFindex2);
% %             HCSDnew = getsp('SQSD',HCSDindex);
% % 
% %             setsp('SQSF',SQSFnew,SQSFindex,2);
% %             setsp('SQSD',SQSDnew,SQSDindex,2);
% %             setsp('SQSF',HCSFnew,HCSFindex,2);
% %             setsp('HCM',HCSFnew2,HCSFindex2,2);
% %             setsp('SQSD',HCSDnew,HCSDindex,2);
% % 
% %             disp('  Old skew quadrupole values have been restored.');
% %         elseif strcmp(KeepFlag,'Yes')
% %             disp('  Keeping new skew quadrupole values.');
% %         else
% %             error('  Unknown option.');
% %         end
% % 
% %     end
% 
% else
%     error('LOCO file has wrong number of FitParameters!');
% 
% end
