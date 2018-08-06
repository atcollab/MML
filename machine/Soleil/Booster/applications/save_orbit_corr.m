function save_orbit_corr(comment)

% save parameter
file=appendtimestamp('orbit');

% commentaire
    orbit=load_orbit_corr;
    orbit.date   =datestr(clock);
    orbit.comment=comment;

    
% sauvegarde
save(file, 'orbit');


