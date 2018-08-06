% lococorrectcoupl_24
%
% This routine reads the results of a LOCO analysis of the ALS lattice (83 fit parameters)
% and calculates the skew quadrupole settings to correct the coupling. It allows to set
% the results.
%
% Christoph Steier, January 2003

% index of skew quadrupoles to be used

SQSFindex = [1 1; 2 1; 2 2; 3 1; 3 2; 5 1; 5 2; 6 1; 6 2; 7 1; 9 1; 11 1];
SQSDindex = [2 1; 2 2; 3 1; 3 2; 4 1; 5 1; 5 2; 6 1; 6 2; 8 1; 10 1; 12 1];


% scaling factors [A/m^-2] (based on magnetic measurements of skew quadrupoles)
% SQSF are weaker because the higher sextupole strength causes pole
% saturation.

energy = getam('cmm:sr_energy');

if energy<0.7
   error('cannot read the storage ring energy! exiting ...');
end

if energy > 1.7
   SQSFfac = 20.0/0.11*energy/1.894;
else
   SQSFfac = 13.0/0.11*energy/1.894;
end

SQSDfac = 13.0/0.11*energy/1.894;

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


if length(FitParameters(numiter).Values)==83
   
   SQSFincr=FitParameters(numiter).Values(60:71)*SQSFfac;
   SQSDincr=FitParameters(numiter).Values(72:83)*SQSDfac;
   
   
   figure
   
   subplot(4,1,1)
   bar(SQSFincr)
   axis([0.5 12.5 -20 20])
   grid on
   
   
   subplot(4,1,2)
   bar(SQSDincr)
   axis([0.5 12.5 -20 20])
   grid on
   
   % Last chance to stop
   CorrFlag = questdlg(str2mat('Do you want to set skew correction?'),sprintf('%.1f GeV Coupling Correction',energy),'Yes','No','No');
   if strcmp(CorrFlag,'No')
      disp('  No correction made.');
      SQSFnew = getsp('SQSF',SQSFindex);
      SQSDnew = getsp('SQSD',SQSDindex);
   elseif strcmp(CorrFlag,'Yes')   
      disp('  Setting new skew quadrupole values (incremental).');
      stepsp('SQSF',SQSFincr,SQSFindex,0);
      stepsp('SQSD',SQSDincr,SQSDindex,0);
      
      pause(0.5);
      
      SQSFnew = getsp('SQSF',SQSFindex);
      SQSDnew = getsp('SQSD',SQSDindex);
      
      setsp('SQSF',SQSFnew,SQSFindex,2);
      setsp('SQSD',SQSDnew,SQSDindex,2);
      disp('  New skew quadrupole values have been set.');
   else
      error('  Unknown option.');      
   end
   
   subplot(4,1,3)
   bar([SQSFnew-SQSFincr SQSFnew])
   axis([0.5 12.5 -20 20])
   grid on
   
   
   subplot(4,1,4)
   bar([SQSDnew-SQSDincr SQSDnew])
   axis([0.5 12.5 -20 20])
   grid on
   
   orient tall;
   
   if strcmp(CorrFlag,'Yes')   
      
      % Keep changes ?
      KeepFlag = questdlg(str2mat('Do you want to keep the changes?'),sprintf('%.1f GeV Coupling Correction',energy),'Yes','No','Yes');
      if strcmp(KeepFlag,'No')
         disp('  Backing out skew correction.');
         stepsp('SQSF',-SQSFincr,SQSFindex,0);
         stepsp('SQSD',-SQSDincr,SQSDindex,0);
         
         pause(0.5);
         
         SQSFnew = getsp('SQSF',SQSFindex);
         SQSDnew = getsp('SQSD',SQSDindex);
         
         setsp('SQSF',SQSFnew,SQSFindex,2);
         setsp('SQSD',SQSDnew,SQSDindex,2);
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

