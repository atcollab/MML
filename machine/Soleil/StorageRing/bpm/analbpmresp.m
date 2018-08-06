function analbpmresp(Sx, Sy)
%ANALBPMRESP - Analyses bpm response matrix
%  analbpmresp(Sx, Sy)
%               or 
%  analbpmresp(FileName)
%
% Written at SPEAR3
% Modified Laurent S. Nadolski
%
% TODO
% Need adaptation for SOLEIL

BPMxGain = getgain('BPMx');
BPMzGain = getgain('BPMz');

SectorLength = 16.40;
Circumference = 12*SectorLength;
idbpms = IDBPMs;
idbpms(1) = idbpms(1)-Circumference;

if nargin == 0
   Flag = menu('Which S-matrix?','From a file.',sprintf('%.1f GeV Default',GLOBAL_SR_GEV),'     Exit   ');
   if Flag == 1
      CurrentDir = pwd;
      gotodata
      cd smatrix
      [FileName, PathName] = uigetfile('*.*', 'Choose the desired S-matrix file.');
      eval(['cd ',CurrentDir]);
      if FileName == 0
         disp('  Function canceled.'); 
         disp(' ');
         return
      else
         load([PathName, FileName]);
      end
   elseif Flag == 2
      Sx = Sxmat;
      Sy = Symat;
   else
      disp('  Function canceled.'); disp(' ');
      return
   end
elseif nargin == 1
   FileName = Sx;
   if isstr(FileName)
      load(FileName);
   else
      error('FileName must be a string.');
   end
end


if size(Sx) == [96 96]
   % input OK
elseif size(Sx) == [96 94]
   S = zeros(96,96);
   S(:,HCMelem) = Sx;
   Sx = S;
else
   error('Sx is the wrong size.');
end


if size(Sy) == [96 96]
   % input OK
elseif size(Sy) == [96 70]
   S = zeros(96,96);
   S(:,VCMelem) = Sy;
   Sy = S;
else
   error('Sy is the wrong size.');
end


% Horizontal

% New S-matrix
Sxnew=zeros(size(Sxmat));
for i = HCMelem'
   %size(BPMxGain)
   %size(Sx(:,i))
   % Remove BPM eain effect
   Sxnew(:,i) = Sx(:,i) .* BPMxGain;
   
   % Remove corrector magnet gain effect (convert to mm/mrad)
   Sxnew(:,i) = Sxnew(:,i) / (1000*amps2rad('HCM',1,i));
end


for Mag = 1:8
   S=[];
   Snew=[];
   
   if Mag == 1 
      m = 2;
   else
      m = 1;
   end
   
   if Mag == 8
      n = 11;
   else
      n = 12;
   end
   
   for i = m:n
      S(:,i-m+1) = Sx(rem((BPMelem-1)+8*(i-1),96)+1, Mag+8*(i-1)); 
      Snew(:,i-m+1) = Sxnew(rem((BPMelem-1)+8*(i-1),96)+1, Mag+8*(i-1));
      
      ii = rem(((1:24)'-1)+2*(i-1),24)+1;
      SID(:,i-m+1) = SIDxmat(ii, Mag+8*(i-1)); 
      
      % Set missing IDBPMs to NaN
      iNaN=find(SID(:,i-m+1)==0);
      SID(iNaN,i-m+1) = NaN;
   end
   
   if Mag == 9
      break
   end
   
   if Mag <= 4
      figure(1);
      subplot(4,1, Mag);
      plot(BPMs, S);
      
      figure(5);
      subplot(4,1, Mag);
      plot(BPMs, Snew);
      
      figure(9);
      subplot(4,1, Mag);
      plot(idbpms, SID);
      axis tight      
   else
      figure(2);
      subplot(4,1, Mag-4);
      plot(BPMs, S);
      
      figure(6);
      subplot(4,1, Mag-4);
      plot(BPMs, Snew);
      
      figure(10);
      subplot(4,1, Mag-4);
      plot(idbpms, SID);
      axis tight
   end
end

figure(1); 
subplot(4,1,1);
xlabel('BPM Position [meters]');
ylabel('Mag #1');
title('Horizontal Corrector Magnets (S-matrix Data: mm/amp)');

subplot(4,1,2);
xlabel('BPM Position [meters]');
ylabel('Mag #2');

subplot(4,1,3);
xlabel('BPM Position [meters]');
ylabel('Mag #3');

subplot(4,1,4);
xlabel('BPM Position [meters]');
ylabel('Mag #4');

figure(2);
subplot(4,1,1);
xlabel('BPM Position [meters]');
ylabel('Mag #5');
title('Horizontal Corrector Magnets (S-matrix Data: mm/amp)');

subplot(4,1,2);
xlabel('BPM Position [meters]');
ylabel('Mag #6');

subplot(4,1,3);
xlabel('BPM Position [meters]');
ylabel('Mag #7');

subplot(4,1,4);
xlabel('BPM Position [meters]');
ylabel('Mag #8');


figure(5); 
subplot(4,1,1);
xlabel('BPM Position [meters]');
ylabel('Mag #1');
title('Horizontal Corrector Magnets (Calibrated S-matrix Data: mm/mrad)');

subplot(4,1,2);
xlabel('BPM Position [meters]');
ylabel('Mag #2');

subplot(4,1,3);
xlabel('BPM Position [meters]');
ylabel('Mag #3');

subplot(4,1,4);
xlabel('BPM Position [meters]');
ylabel('Mag #4');

figure(6);
subplot(4,1,1);
xlabel('BPM Position [meters]');
ylabel('Mag #5');
title('Horizontal Corrector Magnets (Calibrated S-matrix Data: mm/mrad)');

subplot(4,1,2);
xlabel('BPM Position [meters]');
ylabel('Mag #6');

subplot(4,1,3);
xlabel('BPM Position [meters]');
ylabel('Mag #7');

subplot(4,1,4);
xlabel('BPM Position [meters]');
ylabel('Mag #8');


figure(9); 
subplot(4,1,1);
xlabel('IDBPM Position [meters]');
ylabel('Mag #1');
title('Horizontal Corrector Magnets');

subplot(4,1,2);
xlabel('IDBPM Position [meters]');
ylabel('Mag #2');

subplot(4,1,3);
xlabel('IDBPM Position [meters]');
ylabel('Mag #3');

subplot(4,1,4);
xlabel('IDBPM Position [meters]');
ylabel('Mag #4');

figure(10);
subplot(4,1,1);
xlabel('IDBPM Position [meters]');
ylabel('Mag #5');
title('Horizontal Corrector Magnets');

subplot(4,1,2);
xlabel('IDBPM Position [meters]');
ylabel('Mag #6');

subplot(4,1,3);
xlabel('IDBPM Position [meters]');
ylabel('Mag #7');

subplot(4,1,4);
xlabel('IDBPM Position [meters]');
ylabel('Mag #8');



% Vertical

% New S-matrix
Synew=zeros(size(Symat));
for i = VCMelem'
   % Remove BPM eain effect
   Synew(:,i) = Sy(:,i) .* BPMzGain;
   
   % Remove corrector magnet gain effect (convert to mm/mrad)
   Synew(:,i) = Synew(:,i) / (1000*amps2rad('VCM',1,i));
end

for Mag = [1 2 4 5 7 8]
   S=[];
   Snew=[];
   
   SID=[];
   SIDnew=[];
   
   if Mag == 1 
      m = 2;
   else
      m = 1;
   end
   
   if Mag == 8
      n = 11;
   else
      n = 12;
   end
   
   for i = m:n
      S(:,i-m+1) = Sy(rem((BPMelem-1)+8*(i-1),96)+1, Mag+8*(i-1)); 
      Snew(:,i-m+1) = Synew(rem((BPMelem-1)+8*(i-1),96)+1, Mag+8*(i-1)); 
      
      ii = rem(((1:24)'-1)+2*(i-1),24)+1;
      SID(:,i-m+1) = SIDymat(ii, Mag+8*(i-1)); 
      
      % Set missing IDBPMs to NaN
      iNaN=find(SID(:,i-m+1)==0);
      SID(iNaN,i-m+1) = NaN;
   end
      
   if Mag == 9
      break
   end
   
   if Mag <= 4
      figure(3);
      subplot(4,1, Mag);
      plot(BPMs, S);
      
      figure(7);
      subplot(4,1, Mag);
      plot(BPMs, Snew);
      
      figure(11);
      subplot(4,1, Mag);
      plot(idbpms, SID);
      axis tight
   else
      figure(4);
      subplot(4,1, Mag-4);
      plot(BPMs, S);
      
      figure(8);
      subplot(4,1, Mag-4);
      plot(BPMs, Snew);
      
      figure(12);
      subplot(4,1, Mag-4);
      plot(idbpms, SID);
      axis tight
   end
end


figure(3); 
subplot(4,1,1);
xlabel('BPM Position [meters]');
ylabel('Mag #1');
title('Vertical Corrector Magnets (S-matrix Data: mm/amp)');

subplot(4,1,2);
xlabel('BPM Position [meters]');
ylabel('Mag #2');

subplot(4,1,3);
xlabel('BPM Position [meters]');
ylabel('Mag #3');

subplot(4,1,4);
xlabel('BPM Position [meters]');
ylabel('Mag #4');

figure(4);
subplot(4,1,1);
xlabel('BPM Position [meters]');
ylabel('Mag #5');
title('Vertical Corrector Magnets (S-matrix Data: mm/amp)');

subplot(4,1,2);
xlabel('BPM Position [meters]');
ylabel('Mag #6');

subplot(4,1,3);
xlabel('BPM Position [meters]');
ylabel('Mag #7');

subplot(4,1,4);
xlabel('BPM Position [meters]');
ylabel('Mag #8');



figure(7); 
subplot(4,1,1);
xlabel('BPM Position [meters]');
ylabel('Mag #1');
title('Vertical Corrector Magnets (Calibrated S-matrix Data: mm/mrad)');

subplot(4,1,2);
xlabel('BPM Position [meters]');
ylabel('Mag #2');

subplot(4,1,3);
xlabel('BPM Position [meters]');
ylabel('Mag #3');

subplot(4,1,4);
xlabel('BPM Position [meters]');
ylabel('Mag #4');

figure(8);
subplot(4,1,1);
xlabel('BPM Position [meters]');
ylabel('Mag #5');
title('Vertical Corrector Magnets (Calibrated S-matrix Data: mm/mrad)');

subplot(4,1,2);
xlabel('BPM Position [meters]');
ylabel('Mag #6');

subplot(4,1,3);
xlabel('BPM Position [meters]');
ylabel('Mag #7');

subplot(4,1,4);
xlabel('BPM Position [meters]');
ylabel('Mag #8');

figure(11); 
subplot(4,1,1);
xlabel('IDBPM Position [meters]');
ylabel('Mag #1');
title('Vertical Corrector Magnets');

subplot(4,1,2);
xlabel('IDBPM Position [meters]');
ylabel('Mag #2');

subplot(4,1,3);
xlabel('IDBPM Position [meters]');
ylabel('Mag #3');

subplot(4,1,4);
xlabel('IDBPM Position [meters]');
ylabel('Mag #4');

figure(12);
subplot(4,1,1);
xlabel('IDBPM Position [meters]');
ylabel('Mag #5');
title('Vertical Corrector Magnets');

subplot(4,1,2);
xlabel('IDBPM Position [meters]');
ylabel('Mag #6');

subplot(4,1,3);
xlabel('IDBPM Position [meters]');
ylabel('Mag #7');

subplot(4,1,4);
xlabel('IDBPM Position [meters]');
ylabel('Mag #8');



figure(1); orient tall
figure(2); orient tall
figure(3); orient tall
figure(4); orient tall
figure(5); orient tall
figure(6); orient tall
figure(7); orient tall
figure(8); orient tall
figure(9); orient tall
figure(10); orient tall

