function setallsextu(pourcentage_H,pourcentage_V)

%  INPUTS
%  1. pourcentage souhaité sur le courant des sextu 'horizontaux'
%          par exemple 0.01 pour 1%
%          valeur non permise au dela de 2%
%  2. pourcentage souhaité sur le courant des sextu 'verticaux'
% 
%  OUTPUTS
%  

% if pourcentage_H>0.02|pourcentage_V>0.02
%     errordlg('pourcentage trop elevé !','attention')
%     return
% end


% valeurs de sextu pour E = 2.75 GeV !!
pourcentage_H=pourcentage_H+1;
pourcentage_V=pourcentage_V+1;

k = 1
    sextu_name = strcat('S',num2str(k));
    val = getsp(sextu_name);
    setsp(sextu_name,val*(pourcentage_H));
k = 4
    sextu_name = strcat('S',num2str(k));
    val = getsp(sextu_name);
    setsp(sextu_name,val*(pourcentage_H));
k = 6
    sextu_name = strcat('S',num2str(k));
    val =getsp(sextu_name);
    setsp(sextu_name,val*(pourcentage_H));
k = 8
    sextu_name = strcat('S',num2str(k));
    val = getsp(sextu_name);
    setsp(sextu_name,val*(pourcentage_H));
k = 10
    sextu_name = strcat('S',num2str(k));
    val =getsp(sextu_name);
    setsp(sextu_name,val*(pourcentage_H));


%for k = [2 3 5 7 9]
    
k = 2
    sextu_name = strcat('S',num2str(k));
    val = getsp(sextu_name);
    setsp(sextu_name,val*(pourcentage_V));
k = 3
    sextu_name = strcat('S',num2str(k));
    val = getsp(sextu_name);
    setsp(sextu_name,val*(pourcentage_V));
k = 5
    sextu_name = strcat('S',num2str(k));
    val = getsp(sextu_name);
    setsp(sextu_name,val*(pourcentage_V));
k = 7
    sextu_name = strcat('S',num2str(k));
    val = getsp(sextu_name);
    setsp(sextu_name,val*(pourcentage_V));
k = 9
    sextu_name = strcat('S',num2str(k));
    val = getsp(sextu_name);
    setsp(sextu_name,val*(pourcentage_V));

    
%end

% disp('chromaticité après modification')
% getchro
disp('eh voilà')