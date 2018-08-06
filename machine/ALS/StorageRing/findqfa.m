function QFA0 = findqfa
% function QFA0 = findqfa

alsglobe

% Master Osillator Starting Point
QFA00 = getsp('QFA');


% Get Dispersion
%[Dx,Dy]=getdisp;
%Dx=Dx(BPMelem1278);


i = 0; 
for qfa=[0 .2 .4 .6 .8 1 1.2 1.4 1.6 1.8 2]
  i = i+1;
  QFAnew = QFA00+qfa
  qfaam=setsp('QFA', QFAnew);
  sleep(2);
  [Dx(:,i),Dy(:,i)]=getdisp;
  x(:,i) = getx(1,BPMelem1278);
  QFA(:,i) = getsp('QFA');
  save qfaout x QFA Dx Dy
end


% Set QFA back to starting point
setsp('QFA', QFA00);


% Find LS fit to the line
%y=Dxmat; 
%X = [ones(max(size()),1) QFA'];
%b = inv(X'*X)*X'*y;
%QFA0 = -b(1)/b(2);

%QFA1 = linspace(QFA(1),QFA(max(size(QFA))),100);
%yfit = b(1) + b(2)*QFA1;

%figure
%plot(QFA1,yfit, QFA,y,'o'); grid on
%xlabel('RF Frequency [MHz]');
%ylabel('Dot product of Dx and Hor. Orbit');

%fprintf('\n\n                             Zero crossing of QFAF = %f [MHz]\n', rf0);

save qfadata

figure;
plot(QFA,Dx(BPMelem1278,:)); grid on
xlabel('QFA [Amps]');
ylabel('Dispersion');

