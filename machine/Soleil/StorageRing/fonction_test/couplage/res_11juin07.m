% enregistrement des paramètres machine lors de la correction du couplage
devAna = 'ANS-C02/DG/PHC-IMAGEANALYZER'; devemit = 'ANS-C02/DG/PHC-EMIT';
S.courant = readattribute(['ANS-C03/DG/DCCT' '/current']) ; % courant
S.tau = readattribute(['ANS-C03/DG/DCCT' '/lifeTime']) ; % durée de vie
S.Deltaskewquad = Deltaskewquad  ; % vecteur QT
S.QT = getam('QT','Online') ; 
S.image = tango_read_attribute2('ANS-C02/DG/PHC-VG','image') ; % image pinhole
S.sigmax = readattribute([devAna '/XProfileSigma']);
S.sigmaz = readattribute([devAna '/YProfileSigma']);
S.emitx = readattribute([devemit '/EmittanceH']);
S.emitz = readattribute([devemit '/EmittanceV']);
S.inj = 0.86 ; % efficacité d'injection
S.pourcentage = pourcentage ;

DirectoryName =  '/home/matlabML/measdata/Ringdata/Response/Skew/' ;
FileName = appendtimestamp('Res_couplage-coeffDz-8_58mA_2400kV_ScraperV-4mm');
FileName = [DirectoryName, FileName];
save(FileName,'S');