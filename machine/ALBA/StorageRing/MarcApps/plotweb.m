%%
global THERING
[TD, tune] = twissring(THERING, 0,1:length(THERING));
qx=tune(1);
qy=tune(2);
qxlist=[qx qx qx+1 qx+1 qx+1 qx qx-1 qx-1 qx-1];
qylist=[qy qy+1 qy+1 qy qy-1 qy-1 qy-1 qy qy+1];
labelist=[0 1 2 3 4 5 6 7 8];
%%
figure(1)
hold on
max_order= 5;
per = 4;
window = [tune(1)-1.2 tune(1)+1.2 tune(2)-1.2 tune(2)+1.2];
for i=max_order:-1:1,
    [k, tab] = reson(i,per,window);
end
xaxis([tune(1)-1.1 tune(1)+1.1])
yaxis([tune(2)-1.1 tune(2)+1.1])
hold on
plot(qxlist, qylist,'o-k','LineWidth',4)
%%