function ProblemFlag = checkbpms(InfoFlag)
%  ProblemFlag = checkbpms(InfoFlag {1})
%
%  if InfoFlag, print information to the screen
%  ProblemFlag = 0    -> no problems
%                else -> a problem exists
%

if nargin < 1
   InfoFlag = 1;
end


% h 7 11
% v 2 9
ProblemFlag = 0;

HCM1 = [3  1];
HCM2 = [7  1];
HCM3 = [11 1];
VCM1 = [1  2];
VCM2 = [6  1];
VCM3 = [11 1];
DelHCM = .5;
DelVCM = 1;
BPMtol = .05;
ExtraDelay = 1;

BPMDeviceList = family2dev('BPMx');
%BPMDeviceList = getbpmlist('Bergoz');


% Check the BPM sample rate
%checkbpmavg(2, BPMDeviceList);


fprintf('   Changing HCM(%d,%d) by +/- %.2f\n', HCM1, DelHCM);
x10 = getx(BPMDeviceList);
stepsp('HCM', DelHCM, HCM1, -2);
sleep(ExtraDelay);
x1 = getx(BPMDeviceList);
stepsp('HCM',-DelHCM, HCM1, -2);
sleep(ExtraDelay);


fprintf('   Changing HCM(%d,%d) by +/- %.2f\n', HCM2, DelHCM);
x20 = getx(BPMDeviceList);
stepsp('HCM', DelHCM, HCM2, -2);
sleep(ExtraDelay);
x2 = getx(BPMDeviceList);
stepsp('HCM',-DelHCM, HCM2, -2);
sleep(ExtraDelay);

fprintf('   Changing HCM(%d,%d) by +/- %.2f\n', HCM3, DelHCM);
x30 = getx(BPMDeviceList);
stepsp('HCM', DelHCM, HCM3, -2);
sleep(ExtraDelay);
x3 = getx(BPMDeviceList);
stepsp('HCM',-DelHCM, HCM3, -2);
sleep(ExtraDelay);


fprintf('   Changing VCM(%d,%d) by +/- %.2f\n', VCM1, DelVCM);
y10 = gety(BPMDeviceList);
stepsp('VCM', DelVCM, VCM1, -2);
sleep(ExtraDelay);
y1 = gety(BPMDeviceList);
stepsp('VCM',-DelVCM, VCM1, -2);
sleep(ExtraDelay);


fprintf('   Changing VCM(%d,%d) by +/- %.2f\n', VCM2, DelVCM);
y20 = gety(BPMDeviceList);
stepsp('VCM', DelVCM, VCM2, -2);
sleep(ExtraDelay);
y2 = gety(BPMDeviceList);
stepsp('VCM',-DelVCM, VCM2, -2);
sleep(ExtraDelay);


fprintf('   Changing VCM(%d,%d) by +/- %.2f\n', VCM3, DelVCM);
y30 = gety(BPMDeviceList);
stepsp('VCM', DelVCM, VCM3, -2);
sleep(ExtraDelay);
y3 = gety(BPMDeviceList);
stepsp('VCM',-DelVCM, VCM3, -2);


Sx1 = getrespmat('BPMx',BPMDeviceList,'HCM',HCM1);
Sx2 = getrespmat('BPMx',BPMDeviceList,'HCM',HCM2);
Sx3 = getrespmat('BPMx',BPMDeviceList,'HCM',HCM3);
Sy1 = getrespmat('BPMy',BPMDeviceList,'VCM',VCM1);
Sy2 = getrespmat('BPMy',BPMDeviceList,'VCM',VCM2);
Sy3 = getrespmat('BPMy',BPMDeviceList,'VCM',VCM3);


Sx1new = (x1-x10)/DelHCM;
Sx2new = (x2-x20)/DelHCM;
Sx3new = (x3-x30)/DelHCM;
Sy1new = (y1-y10)/DelVCM;
Sy2new = (y2-y20)/DelVCM;
Sy3new = (y3-y30)/DelVCM;


ErrX1 = Sx1new - Sx1;
ErrX2 = Sx2new - Sx2;
ErrX3 = Sx3new - Sx3;
ErrY1 = Sy1new - Sy1;
ErrY2 = Sy2new - Sy2;
ErrY3 = Sy3new - Sy3;

save BPM_Check_Set1

if any(ErrX1>BPMtol) || any(ErrX2>BPMtol) || any(ErrX3>BPMtol) || any(ErrY1>BPMtol) || any(ErrY2>BPMtol) || any(ErrY3>BPMtol)
   ProblemFlag = 1;
end

if InfoFlag
   if ProblemFlag
      fprintf('\n  WARNING:  At least one BPM error is greater than %.0f microns.\n', 1000*BPMtol);
      fprintf('            It could be a problem with the BPM or the S-matrix.\n\n');
   end
   
   BPMs = getspos('BPMx', BPMDeviceList);

   % Setup figures
   Buffer = .01;
   HeightBuffer = .05;
   
   h1 = figure;
   set(h1, 'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
   
   subplot(2,1,1);
   plot(BPMs, Sx1new, '.-r', BPMs, Sx1, '.--r');
   hold on
   plot(BPMs, Sx2new, '.-b', BPMs, Sx2, '.--b');
   plot(BPMs, Sx3new, '.-g', BPMs, Sx3, '.--g');
   hold off
   xlabel('BPM Position [meters]');
   ylabel('Horizontal [mm]');
   title(sprintf('Current S-Matrix (--) and New Data (-) for HCM(%d,%d) (red), HCM(%d,%d) (blue), HCM(%d,%d) (grn)', HCM1(1), HCM1(2), HCM2(1), HCM2(2), HCM3(1), HCM3(2)));
   
   subplot(2,1,2);
   plot(BPMs, Sx1new-Sx1, '.-r');
   hold on
   plot(BPMs, Sx2new-Sx2, '.-b');
   plot(BPMs, Sx3new-Sx3, '.-g');
   hold off
   xlabel('BPM Position [meters]');
   ylabel('Horizontal Error [mm]');
   title(sprintf('Current S-Matrix minus New Data for HCM(%d,%d) (red), HCM(%d,%d) (blue), HCM(%d,%d) (green)', HCM1(1), HCM1(2), HCM2(1), HCM2(2), HCM3(1), HCM3(2)));
   
   
   h2 = figure;
   set(h2,'units','normal','position',[.5+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
   
   subplot(2,1,1);
   plot(BPMs, Sy1new, '.-r', BPMs, Sy1, '.--r');
   hold on
   plot(BPMs, Sy2new, '.-b', BPMs, Sy2, '.--b');
   plot(BPMs, Sy3new, '.-g', BPMs, Sy3, '.--g');
   hold off
   xlabel('BPM Position [meters]');
   ylabel('Vertical [mm]');
   title(sprintf('Current S-Matrix (--) and New Data (-) for VCM(%d,%d) (red), VCM(%d,%d) (blue), VCM(%d,%d) (green)', VCM1(1), VCM1(2), VCM2(1), VCM2(2), VCM3(1), VCM3(2)));
   
   subplot(2,1,2);
   plot(BPMs, Sy1new-Sy1, '.-r');
   hold on
   plot(BPMs, Sy2new-Sy2, '.-b');
   plot(BPMs, Sy3new-Sy3, '.-g');
   hold off
   xlabel('BPM Position [meters]');
   ylabel('Vertical Error [mm]');
   title(sprintf('Current S-Matrix minus New Data for VCM(%d,%d) (red), VCM(%d,%d) (blue), VCM(%d,%d) (green)', VCM1(1), VCM1(2), VCM2(1), VCM2(2), VCM3(1), VCM3(2)));
  
end