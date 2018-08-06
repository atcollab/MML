%function QUAD0 = scandispquad
% function QUAD0 = scandispquad

QUADFamily = 'QFC';

% Master Osillator Starting Point
QUAD00 = getsp(QUADFamily);
BPMStraightSection = [];


% Get Dispersion
%[Dx,Dy] = measdisp;
%Dx=Dx(BPMStraightSection);


i = 0; 
for DeltaAmp=[0 .2 .4 .6 .8 1 1.2 1.4 1.6 1.8 2]
  i = i + 1;
  QUADnew = QUAD0+DeltaAmp
  setsp(QUADFamily, QUADnew);
  sleep(2);
  [Dx(:,i), Dy(:,i)] = measdisp;
  x(:,i) = getx(BPMStraightSection);
  QUADsp(:,i) = getsp(QUADFamily);
  save x QUADsp Dx Dy
end


% Set QFA back to starting point
setsp(QUADFamily, QUAD00);


q = QUAD(1,:);

% Find LS fit to the line
%y = Dxmat; 
%X = [ones(max(size()),1) q'];
%b = inv(X'*X)*X'*y;
%QUAD0 = -b(1)/b(2);
%
%qvec = linspace(q(1),q(end),100);
%yfit = b(1) + b(2)*qvec;
%
%figure
%plot(qvec, yfit, QFA,y,'o'); grid on
%xlabel('RF Frequency [MHz]');
%ylabel('Dot product of Dx and Hor. Orbit');
%fprintf('\n\n                             Zero crossing of QFAF = %f [MHz]\n', rf0);

%save dispquaddata


%figure
i = findrowindex(BPMStraightSection,family2dev('BPMx'));
plot(q, Dx(i,:)); grid on
xlabel('QFA [Amps]');
ylabel('Dispersion');

