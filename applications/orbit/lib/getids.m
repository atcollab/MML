function [idgaps, idtrims]=getids

insdevGapsPV = {'spr:ID04M1/AM1';'spr:ID05M1/AM1';'spr:ID06M1/AM1';'spr:ID07M1/AM1';'spr:ID09M1/AM1';'spr:ID10M1/AM1';'spr:ID11M1/AM1'};
insdevTrimsPV  = {   '05S-ID7TH:CurrSetpt'; '05S-ID7TO:CurrSetpt'; '05S-ID7TV:CurrSetpt';...
                     '06S-ID10TH1:CurrSetpt'; '06S-ID10TH2:CurrSetpt';...
                     '07S-ID9TH:CurrSetpt';...
                     '11S-ID6TH:CurrSetpt';...
                     '12S-ID5TH1:CurrSetpt'; '12S-ID5TH2:CurrSetpt';...
                     '13S-ID4TH:CurrSetpt';  '13S-ID4TV:CurrSetpt';...
                     '15S-ID11TH:CurrSetpt'; '15S-ID11TV:CurrSetpt'};


idgapcell=getsp(insdevGapsPV);
for k=1:length(idgapcell)
    idgaps(k)=idgapcell{k};
    disp(['Insertion Device ' insdevGapsPV{k}(7:8) ' gap ' num2str(idgaps(k)) ' mm']);
end

idtrimcell=getsp(insdevTrimsPV);
for k=1:length(idtrimcell)
        idtrims(k)=idtrimcell{k}(1);
        disp(['Insertion Device ' insdevTrimsPV{k}(7:10) ' trim ' num2str(idtrims(k)) ' amps']);
end

idgaps=idgaps(:);
idtrims=idtrims(:);
