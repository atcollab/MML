% matrice réponse DQ/ Dx   sur dispersion en 16 points (symetie)
% on cherche M tel que dX = M dQ par famille

pourcentage=0.001;
wait=2;
M = [];
target=[1 30 31 60 61 90 91 120]; % sextion longue
target=[target 15 16 45 46 75 76 105 106] ;  % section centre maille
length(target)

fprintf('***************************\n')
for k= [1 2 3 4 5 6 7 8 9 10]
    
    x=getx;
    x0=[];
    for i=1:length(target)
      x0=[x0 ; x(target(i))];
    end
    quad_name = strcat('Q',num2str(k));
    val = getsp(quad_name);
    valplus=val(1)*(1+pourcentage);
    fprintf('Famille %2d :  %8g -> %8g \n',k,val(1),valplus)
    %setsp(quad_name,valplus); pause(wait)
    x=getx;
    x1=[];
    for i=1:length(target)
      x1=[x1 ; x(target(i))];
    end

    col=(x1-x0)/(valplus/val(1));
    M=[M col];
    
   %setsp(quad_name,val); pause(wait) 
    
end

