% NE PAS OUBLIER : switch2sim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% mode vertical  BUMP FERME  en cellule 3  (20 mai 2006)
ORB = setorbitbump('BPMz',[ 3 6;3 7],[-0.3  -0.3],'VCOR',[  -2 -1 1 2 ],'Absolute')
ORB.CM.Delta
ORB.CM.DeviceList
stepsp('VCOR',ORB.CM.Delta,ORB.CM.DeviceList,'Online')

%% UNDO sur les correcteurs concernés par le bump
% stepsp('VCOR',-ORB.CM.Delta,ORB.CM.DeviceList,'Online')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BUMP OUVERT (Pascale)
% %       coeff = 1 ; 10A sur VCOR [2 6]  
% %                    4 A         [2 7]
% %                    -8A         [3 2]
% %    =>   -7 mm en BPM [3 6]
% %         -13 mm en BPM [3 7]
% coeff = 0.3
% val = coeff * [10  4  -8];
% DeviceList = [2 6 ; 2 7 ; 3 2]
% stepsp('VCOR', val , DeviceList ,'Online')


