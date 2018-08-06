% retour update

function retour_update(carte,r)

if     (r==0)
    fprintf('Carte %s = OK\n',carte)
elseif (r==-1)
    fprintf('Carte %s = Probleme\n',carte)
end

    
pause(0.5)