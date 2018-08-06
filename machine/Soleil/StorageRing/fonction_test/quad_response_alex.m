% matrice réponse DQ/ Dx   sur dispersion
% on cherche M tel que dX = M dQ par famille

pourcentage=0.01;
wait=2;
M = [];

fprintf('***************************\n')
for k= [1 2 3 4 5 6 7 8 9 10]
    
    x0=getx;
    quad_name = strcat('Q',num2str(k));
    val = getsp(quad_name);
    valplus=val(1)*(1+pourcentage);
    fprintf('Famille %2d :  %8g -> %8g \n',k,val(1),valplus)
    %setsp(quad_name,valplus); pause(wait)
    x1=getx;
    col=(x1-x0)/(valplus-val(1));
    M=[M col];
    
end

