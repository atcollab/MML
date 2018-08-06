function  buildedmapps
%BUILDEDMAPPS - Build all the Matlab generate EDM applications


% ID Control
fprintf('   Building SR - ID Control\n');
mml2edm_id;


% Magnet Power Supplies
mml2edm_mps;
mml2edm_srmag;

% mml2edm('HCM');
% mml2edm('VCM');
% mml2edm('QF');
% mml2edm('QD');
% mml2edm('BEND');
% mml2edm('QFA');
% mml2edm('QDA');
% mml2edm('SQSF');
% mml2edm('SQSD');


% QFA Shunts
mml2edm_qfa_shunts;


% Scraper
mml2edm_scrapers;
