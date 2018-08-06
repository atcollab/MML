% bump du 29 mai

% 3) perte verticale en SDL1
setsp('VCOR',10,[16,6])


% 4) perte horizontal scraper en C13
setsp('HCOR',10,[12,7])


% 5) perte acrhomat C09
setsp('HCOR',-11,[9,1]);setsp('HCOR',-10,[8,4]);
setsp('Q2',0,[9,1]);setsp('Q3',0,[9,1]);setsp('Q5',170,[9,1]);

setsp('Q2',159.3141,[9,1]);setsp('Q3',-76.2217,[9,1]);setsp('Q5',202.2110,[9,1]);


% 6) perte acrhomat C04
setsp('HCOR',10,[3,5]);setsp('HCOR',10,[3,4]);
setsp('Q7',140,[3,2]);

setsp('Q7',209.5696,[3,2]);