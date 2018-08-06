starttime='2004-02-06 21:10:00.00';
stoptime ='2004-02-07 08:45:00.00';
maintitle='orbit feedback >85 ma,  6 s cycle time, rf frequency in loop';
decimation=50;

families={'BPMx'; 'BPMy'; 'HCM'; 'VCM'};  %RF
fields={'Monitor'; 'Monitor'; 'Monitor'; 'Monitor'};  %Monitor

figure
for k=1:size(families,1)
    family=families{k};
    field=fields{k};
    disp(['   Loading Data.(family) for family ' family ' from ' starttime ' to ' stoptime]);
    disp( '   please be patient...');
[Data.(family),t,col] = gethist(starttime, stoptime, family, field);
disp(' ');
length=size(Data.(family),2);
Data.(family)=Data.(family)(:,1:decimation:length);

subplot(2,2,k)
surf(Data.(family)-repmat(Data.(family)(:,1),1,size(Data.(family),2)));
drawnow;
xlabel(['Time: ' starttime '   ' stoptime]);
ylabel([family ' index']);
title(maintitle);
end

disp('   reminder: save data to disk...        save ''filename'' Data'     )
