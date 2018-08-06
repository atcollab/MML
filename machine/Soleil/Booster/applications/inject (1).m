%  reglage correcteur verticaux LTI pour injection booster 

zinj = [-0.5 0.] ;  % SPM mai 2007  95% LPM
%zinj = [-0.5 -0.] ;  % LPM mai 2007  95% LPM
%zinj = [1  -0.1];  % SPM2
%zinj = [0  -0.2] ;           % SPM1
%zinj = [1.  -0.3] ;        % LPM
%zinj = [-2.  -0.5] ;        % pos (mm) et angle (mrad)
%zinj = [-2.  -0.5] ; 



m1   =[ 0.0923 -0.4244 ; 0.0738 1.66 ] ;
klt1 = m1*zinj'/1.2  ;  % corr 2 et 3 en A  

klt1=klt1;

fprintf('************************\n')
fprintf(' Courant correcteur LT1      CV.2: %g A    et     CV.3: %g A \n', klt1)

kinit1=0.;
kinit2=0.;
 

tango_write_attribute('LT1/AE/CV.2', 'current', (klt1(1)) );
tango_write_attribute('LT1/AE/CV.3', 'current', (klt1(2)) );
 
CV2=readattribute('LT1/AE/CV.2/current');
CV3=readattribute('LT1/AE/CV.3/current');
fprintf(' Lecture correcteur LT1      CV.2: %g A    et     CV.3: %g A \n', klt1)