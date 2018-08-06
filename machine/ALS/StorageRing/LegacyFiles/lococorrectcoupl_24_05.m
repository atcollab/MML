% lococorrectcoupl_24
%
% This routine reads the results of a LOCO analysis of the ALS lattice (83 fit parameters)
% and calculates the skew quadrupole settings to correct the coupling. It allows to set
% the results.
%
% Christoph Steier, May 2005

    
    % Index of magnets to use
    
    SQSFindex = [1 1; 3 1; 3 2; 5 1; 6 1; 6 2; 7 2; 9 1; 11 1];
    SQSFind = [1 2 3 4 6 7 9 10 11];  % added 9 GP
    HCSFindex = [5 5;7 4];
    HCSFind = [5 8]; 
    SQSDindex = [2 1; 3 1; 3 2; 4 1; 6 1; 6 2; 7 1; 7 2; 8 1; 10 1; 12 1];
    SQSDind = [12 13 14 15 18 19 20 21 22 23 24];
    HCSDindex = [5 3;5 6];
    HCSDind = [16 17];

% scaling factors [A/m^-2] (based on magnetic measurements of skew quadrupoles)
% SQSF are weaker because the higher sextupole strength causes pole
% saturation.

energy = getenergy; 

if energy<0.7
   error('cannot read the storage ring energy! exiting ...');
end

if energy > 1.7
    SQSFfac = 20.0/0.11*energy/1.894;
    HCSFfac = 6.1/0.11*energy/1.894;
    HCSDfac = 4.6/0.11*energy/1.894;
else
    SQSFfac = 14.0/0.11*energy/1.894;
    HCSFfac = 6.1/0.11*energy/1.894;    % probably not correct; put saturation unknow so far
    HCSDfac = 4.6/0.11*energy/1.894;    % probably not correct; put saturation unknow so far
end

SQSDfac = 14.0/0.11*energy/1.894;


% calculation routine ...

olddir = pwd;

gotodata;
cd 'smatrix/loco'

[locofilename,locofilepath] = uigetfile('*.mat','LOCO results: filename');

if isempty(locofilename) | (locofilename == 0)
   error('You have selected an invalid LOCO results filename');
end

cd(locofilepath);

load(locofilename);

cd(olddir);

numiter = size(FitParameters,2);

% allow to correct to lattice with etaywave - do not always correct to small coupling!

    % Theoretical k values [m^-2] for the skews as determined with a fit using
    %the accelerator toolbox.
    
    % First 11 entries are SQSF, last 13 are SQSD
    skew_fit = [
   0.01727216697979
   0.01184557173045
  -0.02017846221196
  -0.00612197974464
  -0.02069568699941
  -0.06329253170868
   0.00715842780350
  -0.01070896407445
   0.00550406225844
   0.00449906206811
   0.00047090892735
  -0.02375885314324
  -0.01211135612168
  -0.00952587083407
  -0.01543990455777
  -0.02518634499051
   0.02204474741020
   0.00132303391277
  -0.00709686901179
  -0.00046797176215
  -0.03617151751389
  -0.01559864156483
  -0.00545221139740
   0.01903059229621
   ];

prompt={'Enter the factor for eta_y: wave'};
def={'0.95'};
dlgTitle='Selection whether to correct to small emittance, or user settings';
lineNo=1;
answernum=inputdlg(prompt,dlgTitle,lineNo,def);

factor = str2double(answernum{1})*(-1)

if length(FitParameters(numiter).Values)==83
   
   SQSFincr=(FitParameters(numiter).Values(59+SQSFind)-factor*skew_fit(SQSFind))*SQSFfac;
   SQSDincr=(FitParameters(numiter).Values(59+SQSDind)-factor*skew_fit(SQSDind))*SQSDfac;
   HCSFincr=(FitParameters(numiter).Values(59+HCSFind)-factor*skew_fit(HCSFind))*HCSFfac;
   HCSDincr=(FitParameters(numiter).Values(59+HCSDind)-factor*skew_fit(HCSDind))*HCSDfac;
   
   
   figure
   
   subplot(4,1,1)
   bar([SQSFincr;HCSFincr])
   axis([0.5 11.5 -20 20])
   grid on
   
   
   subplot(4,1,2)
   bar([SQSDincr;HCSDincr])
   axis([0.5 13.5 -20 20])
   grid on
   
   % Last chance to stop
   CorrFlag = questdlg(str2mat('Do you want to set skew correction?'),sprintf('%.1f GeV Coupling Correction',energy),'Yes','No','No');
   if strcmp(CorrFlag,'No')
      disp('  No correction made.');
      SQSFnew = getsp('SQSF',SQSFindex);
      SQSDnew = getsp('SQSD',SQSDindex);
      HCSFnew = getsp('HCM',HCSFindex);
      HCSDnew = getsp('HCM',HCSDindex);
   elseif strcmp(CorrFlag,'Yes')   
      disp('  Setting new skew quadrupole values (incremental).');
      stepsp('SQSF',SQSFincr,SQSFindex,0);
      stepsp('SQSD',SQSDincr,SQSDindex,0);
      stepsp('HCM',HCSFincr,HCSFindex,0);
      stepsp('HCM',HCSDincr,HCSDindex,0);
      
      pause(0.5);
      
      SQSFnew = getsp('SQSF',SQSFindex);
      SQSDnew = getsp('SQSD',SQSDindex);
      disp('  New skew quadrupole values have been set.');
   else
      error('  Unknown option.');      
   end
   
   subplot(4,1,3)
   bar([SQSFnew-SQSFincr SQSFnew;HCSFnew-HCSFincr HCSFnew])
   axis([0.5 11.5 -20 20])
   grid on
   
   
   subplot(4,1,4)
   bar([SQSDnew-SQSDincr SQSDnew;HCSDnew-HCSDincr HCSDnew])
   axis([0.5 13.5 -20 20])
   grid on
   
   orient tall;
   
   if strcmp(CorrFlag,'Yes')   
      
      % Keep changes ?
      KeepFlag = questdlg(str2mat('Do you want to keep the changes?'),sprintf('%.1f GeV Coupling Correction',energy),'Yes','No','Yes');
      if strcmp(KeepFlag,'No')
         disp('  Backing out skew correction.');
         stepsp('SQSF',-SQSFincr,SQSFindex,0);
         stepsp('SQSD',-SQSDincr,SQSDindex,0);
         stepsp('HCM',-HCSFincr,HCSFindex,0);
         stepsp('HCM',-HCSDincr,HCSDindex,0);
         
         pause(0.5);
         
         SQSFnew = getsp('SQSF',SQSFindex);
         SQSDnew = getsp('SQSD',SQSDindex);
         HCSFnew = getsp('HCM',HCSFindex);
         HCSDnew = getsp('HCM',HCSDindex);

         setsp('SQSF',SQSFnew,SQSFindex,2);
         setsp('SQSD',SQSDnew,SQSDindex,2);
         setsp('HCM',HCSFnew,HCSFindex,2);
         setsp('HCM',HCSDnew,HCSDindex,2);

         disp('  Old skew quadrupole values have been restored.');      
      elseif strcmp(KeepFlag,'Yes')   
         disp('  Keeping new skew quadrupole values.');
      else
         error('  Unknown option.');      
      end
      
   end
   
else
   error('LOCO file has wrong number of FitParameters!');
   
end
