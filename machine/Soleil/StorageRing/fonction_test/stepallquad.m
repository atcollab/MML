function stepallquad(pourcentage_H,pourcentage_V)

%  INPUTS
%  1. pourcentage souhaité sur le courant des quad focalisant horizontal
%          par exemple 0.01 pour 1%
%          valeur non permise au dela de 2%
%  2. pourcentage souhaité sur le courant des quad défocalisant horizontal
% 
%  OUTPUTS
%  tune avant et après

if pourcentage_H>0.02|pourcentage_V>0.02
    errordlg('pourcentage trop elevé !','attention')
    return
end

% disp('tune avant modification')
% gettune

for k = [2 5 7 10]
    
    quad_name = strcat('Q',num2str(k));
    val = getsp(quad_name);
    % augmentation de N %
    setsp(quad_name,val(1)*(1+pourcentage_H));
    
end

for k = [1 3 4 6 8 9]
    
    quad_name = strcat('Q',num2str(k));
    val = getsp(quad_name);
    % augmentation de N %
    setsp(quad_name,val(1)*(1+pourcentage_V));
    
end

% disp('tune après modification')
% gettune
disp('eh voilà')