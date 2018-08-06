% Magtest = 1 --> skew quad tests
magtest = 1;
restore = 0;

if ~restore
    switch magtest
        case 1
            % Skew quads
            savehcm = getsp('HCM');
            savevcm = getsp('VCM');
            savesfa = getsp('SFA');
            savesfb = getsp('SFB');
            savesda = getsp('SDA');
            savesdb = getsp('SDB');
            saveskq = getsp('SKQ');

            setsp({'HCM','VCM','SFA','SFB','SDA','SDB'},{0 0 0 0 0 0},'Hardware');
            setsp('SKQ',1.5,'Hardware')

        case 2
        case 3
        case 4
    end
else
    % Section to restore values
end