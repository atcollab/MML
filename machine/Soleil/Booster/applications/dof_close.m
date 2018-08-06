% store orbite  DOF

%clear

istart=10;
iend=200;
nbpmx=22;

% Orbite sans DOF à stoker
%   [X0,Z0] = getboobpm(22,200,10);
%   save('orbite_no_DOF', 'X0')

load('orbite_no_DOF', 'X0');

% Orbite avec DOF 
   [X1,Z1] = getboobpm(nbpmx,iend,istart);
   save('orbite_avec_DOF', 'X1');

% difference
   Xdiff= X1-X0;
   plot(Xdiff,'-ok')
   

   
%    
% % Pour choisir les deux BPMs de correction
%    display('Choisir 2 BPMs :')
%    Xtest=[Xdiff(12) Xdiff(14) Xdiff(16) Xdiff(17)  Xdiff(18)]
% 
% 
% 
% 
% % BPM choisis
%    n1=12;
%    n2=16; 
% 
% % Detla volt sur DOF
%    deltav=10;
% 
% % Calcul efficaté dof2 et dof3 sur les 2 bpms
%    dof2=readattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue');
%    dof2t=dof2+deltav;
%    %writeattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue',dof2t);pause(1);
%    [X,Z] = getboobpm(nbpmx,iend,istart);
%    m11=X(n1)-Xdiff(n1);
%    m12=X(n2)-Xdiff(n2);
%    %writeattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue',dof2);pause(1);
%    
%    
%    dof3=readattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue');
%    dof3t=dof3+deltav;
%    %writeattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue',dof3t);pause(1);
%    [X,Z] = getboobpm(nbpmx,iend,istart);
%    m21=X(n1)-Xdiff(n1);
%    m22=X(n2)-Xdiff(n2);
%    %writeattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue',doft);pause(1);
%    
%    m=[ m11 m12  ; m21  m22 ]/deltav
%    
% % ferme le bump
%    Ddof=inv(m)*[-Xdiff(n1) ; -Xdiff(n2)]
%    dof2=readattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue');
%    dof2t=dof2+Ddof(1);
%    %writeattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue',dof2t);
%    dof3=readattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue');
%    dof3t=dof3+Ddof(1);
%   %writeattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue',dof3t);
%   
%   
% % Plot pout voir
%    pause(1);
%    [X1,Z1] = getboobpm(nbpmx,iend,istart);
%    Xdiff1= X1-X0;
%    n=1:22;
%    plot(n,Xdiff,n,Xdiff1)
%    
   
  
  
  
  
  
  
  
  
  
  
  
  
   