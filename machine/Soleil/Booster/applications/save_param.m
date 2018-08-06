function save_param(comment)

% save parameter
file=appendtimestamp('boo');

% commentaire
    boo=load_param;
    boo.date   =datestr(clock);
    boo.comment=comment;
    
% sauvegarde
save(file, 'boo');


