
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% application à la machine (modele)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% valeurs nominales des courants  ! ! regler nux et nuz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% 1ère méthode : mesure sur la machine
%     IQnom = [];
%     for i = 1:10
%         Name = strcat('Q',num2str(i));
%         IQnom = [IQnom getam(Name)']
%     end
%     IQnom = IQnom';
%%%%%%% 2ème méthode : Iq sur fichier
S = load('-mat','/home/matlabML/measdata/Ringdata/QUAD/IQnom_machine_dissym_2006_10_08.mat'); % 
IQnom = S.IQnom ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chargement des corrections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%S =load('-mat','/home/matlabML/measdata/Ringdata/QUAD/solution_2006_10_08_nbvp13.mat'); % 13 valeurs propres
S = load('-mat','/home/matlabML/measdata/Ringdata/QUAD/solution_2006_10_08_nbvp35.mat'); % 35 valeurs propres

deltaIQuad = S.deltaIquad
IQnomB = IQnom - deltaIQuad

IQnom1 = IQnomB(1:8);
IQnom2 = IQnomB(9:16);IQnom3 = IQnomB(17:24);
IQnom4 = IQnomB(25:40); % c'est moche je sais !!
IQnom5 = IQnomB(41:56) ; IQnom6 = IQnomB(57:80);IQnom7 = IQnomB(81:104);IQnom8 = IQnomB(105:128);
IQnom9 = IQnomB(129:144) ; IQnom10 = IQnomB(145:160);


setsp('Q1',IQnom1);setsp('Q2',IQnom2);setsp('Q3',IQnom3);setsp('Q4',IQnom4);
setsp('Q5',IQnom5);setsp('Q6',IQnom6);setsp('Q7',IQnom7);setsp('Q8',IQnom8);
setsp('Q9',IQnom9);setsp('Q10',IQnom10);

disp('oulala')
%getam({'Q1','Q2','Q3','Q4','Q5','Q6','Q7','Q8','Q9','Q10'})
% hold on %figure(12)
% plotbeta