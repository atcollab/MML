% bump H

A=setorbitbump('BPMx',[3 5 ; 3 6], [-1 -1] , 'HCOR', [-2 -1 1 2], 'Display')
stepsp('HCOR',A.CM.Delta,A.CM.DeviceList)

% retour
%stepsp('HCOR',-A.CM.Delta,A.CM.DeviceList)

A=setorbitbump('BPMz',[3 5 ; 3 6], [1 1] , 'ZCOR', [-2 -1 1 2], 'Display')