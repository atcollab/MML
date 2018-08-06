maintitle='orbit feedback >85 ma,  6 s cycle time, rf frequency in loop';

filename='Feb062004';

load(filename);

families=fieldnames(Data);

for k=1:size(families,1)
family=families{k};
disp(' ');
length=size(Data.(family),2);

figure
mesh(Data.(family)(:,:)-repmat(Data.(family)(:,1),1,size(Data.(family),2)));
drawnow;
xlabel(['Time: ' starttime '   ' stoptime]);
ylabel([family ' index']);
title(maintitle);
drawnow
end
