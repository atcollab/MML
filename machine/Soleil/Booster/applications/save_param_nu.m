function save_param_nu(comment)

% save parameter
file=appendtimestamp('boo');

% commentaire
    boo=load_param;
    boo.date   =datestr(clock);
    boo.comment=comment;
    
% mesure nombre d'onde
    boo.time=[0  10 ];
    boo.nux =[6.6 6.65];
    boo.nuz =[4.6 4.65];
    
% sauvegarde
   save(file, 'boo');
   
%%%   
boo
fprintf('Fichier enregisté : %s \n' , file)


