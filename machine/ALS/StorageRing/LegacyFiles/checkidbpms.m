function ProblemFlag = checkidbpms(InfoFlag)
%  ProblemFlag = checkidbpms(InfoFlag {1})
%
%  if InfoFlag, print information to the screen
%  ProblemFlag = 0    -> no problems
%                else -> a problem exists
%

if nargin < 1
   InfoFlag = 1;
end


alsglobe

% h 7 11
% v 2 9
ProblemFlag = 0;
Sector = 7;
HCM1 = [3  1];
HCM2 = [7  1];
HCM3 = [11 1];
VCM1 = [1  2];
VCM2 = [7  1];
VCM3 = [11 1];
DelHCM = .5;
DelVCM = 4;
IDBPMtol = .05;
ExtraDelay = .5;


% Check the IDBPM sample rate
checkidbpmavg(2);


x10 = getidx;
stepsp('HCM', DelHCM, HCM1);
sleep(ExtraDelay);
x1 = getidx;
stepsp('HCM',-DelHCM, HCM1);
sleep(ExtraDelay);


x20 = getidx;
stepsp('HCM', DelHCM, HCM2);
sleep(ExtraDelay);
x2 = getidx;
stepsp('HCM',-DelHCM, HCM2);
sleep(ExtraDelay);


x30 = getidx;
stepsp('HCM', DelHCM, HCM3);
sleep(ExtraDelay);
x3 = getidx;
stepsp('HCM',-DelHCM, HCM3);
sleep(ExtraDelay);


y10 = getidy;
stepsp('VCM', DelVCM, VCM1);
sleep(ExtraDelay);
y1 = getidy;
stepsp('VCM',-DelVCM, VCM1);
sleep(ExtraDelay);


y20 = getidy;
stepsp('VCM', DelVCM, VCM2);
sleep(ExtraDelay);
y2 = getidy;
stepsp('VCM',-DelVCM, VCM2);
sleep(ExtraDelay);


y30 = getidy;
stepsp('VCM', DelVCM, VCM3);
sleep(ExtraDelay);
y3 = getidy;
stepsp('VCM',-DelVCM, VCM3);


Sx1 = SIDxmat(IDBPMelem,dev2elem('HCM',HCM1));
Sx2 = SIDxmat(IDBPMelem,dev2elem('HCM',HCM2));
Sx3 = SIDxmat(IDBPMelem,dev2elem('HCM',HCM3));
Sy1 = SIDymat(IDBPMelem,dev2elem('VCM',VCM1));
Sy2 = SIDymat(IDBPMelem,dev2elem('VCM',VCM2));
Sy3 = SIDymat(IDBPMelem,dev2elem('VCM',VCM3));


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


if any(ErrX1>IDBPMtol) | any(ErrX2>IDBPMtol) | any(ErrX3>IDBPMtol) | any(ErrY1>IDBPMtol) | any(ErrY2>IDBPMtol) | any(ErrY3>IDBPMtol)
   ProblemFlag = 1;
end

if InfoFlag
   if ProblemFlag
      fprintf('\n  WARNING:  At least one IDBPM error is greater than %.0f microns.\n', 1000*IDBPMtol);
      fprintf('            It could be a problem with the IDBPM or the S-matrix.\n\n');
   end
   
   % Setup figures
   Buffer = .01;
   HeightBuffer = .05;
   
   h1=figure;
   set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
   
   subplot(2,1,1);
   plot(IDBPMs(IDBPMelem), Sx1new, '-or', IDBPMs(IDBPMelem), Sx1, '--r');
   hold on
   plot(IDBPMs(IDBPMelem), Sx2new, '-ob', IDBPMs(IDBPMelem), Sx2, '--b');
   plot(IDBPMs(IDBPMelem), Sx3new, '-og', IDBPMs(IDBPMelem), Sx3, '--g');
   hold off
   xlabel('IDBPM Position [meters]');
   ylabel('Horizontal [mm]');
   title(sprintf('Current S-Matrix (--) and New Data (-o) for HCM(%d,%d) (red), HCM(%d,%d) (blue), HCM(%d,%d) (grn)', HCM1(1), HCM1(2), HCM2(1), HCM2(2), HCM3(1), HCM3(2)));
   
   subplot(2,1,2);
   plot(IDBPMs(IDBPMelem), Sx1new-Sx1, '-or');
   hold on
   plot(IDBPMs(IDBPMelem), Sx2new-Sx2, '-ob');
   plot(IDBPMs(IDBPMelem), Sx3new-Sx3, '-og');
   hold off
   xlabel('IDBPM Position [meters]');
   ylabel('Horizontal Error [mm]');
   title(sprintf('Current S-Matrix minus New Data for HCM(%d,%d) (red), HCM(%d,%d) (blue), HCM(%d,%d) (grn)', HCM1(1), HCM1(2), HCM2(1), HCM2(2), HCM3(1), HCM3(2)));
   
   
   h2=figure(h1+1);
   set(h2,'units','normal','position',[.5+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
   
   subplot(2,1,1);
   plot(IDBPMs(IDBPMelem), Sy1new, '-or', IDBPMs(IDBPMelem), Sy1, '--r');
   hold on
   plot(IDBPMs(IDBPMelem), Sy2new, '-ob', IDBPMs(IDBPMelem), Sy2, '--b');
   plot(IDBPMs(IDBPMelem), Sy3new, '-og', IDBPMs(IDBPMelem), Sy3, '--g');
   hold off
   xlabel('IDBPM Position [meters]');
   ylabel('Vertical [mm]');
   title(sprintf('Current S-Matrix (--) and New Data (-o) for VCM(%d,%d) (red), VCM(%d,%d) (blue), VCM(%d,%d) (grn)', VCM1(1), VCM1(2), VCM2(1), VCM2(2), VCM3(1), VCM3(2)));
   
   subplot(2,1,2);
   plot(IDBPMs(IDBPMelem), Sy1new-Sy1, '-or');
   hold on
   plot(IDBPMs(IDBPMelem), Sy2new-Sy2, '-ob');
   plot(IDBPMs(IDBPMelem), Sy3new-Sy3, '-oG');
   hold off
   xlabel('IDBPM Position [meters]');
   ylabel('Vertical Error [mm]');
   title(sprintf('S-Matrix minus New Data for VCM(%d,%d) (red), VCM(%d,%d) (blue), VCM(%d,%d) (grn)', VCM1(1), VCM1(2), VCM2(1), VCM2(2), VCM3(1), VCM3(2)));
   
end